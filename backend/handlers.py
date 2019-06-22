from app import app
from models import *
import json
import session
import time
import datetime
from flask import request, send_from_directory
from sqlalchemy import or_
from middleware import auth_guard, flask_env_guard
from db import db
from utils import try_from_timestamp, try_into_timestamp
from typing import List, Tuple
from config import *


@app.route('/api/order', methods=['GET', 'POST'])
@auth_guard
def handle_orders():
    (_, uid, typ) = session.get_user_data()
    if request.method == "GET":
        order_type = request.args.get('orderType')
        search_words = request.args.get('searchWords', '')
        order_by = request.args.get('orderBy', 'order_time')
        offset = request.args.get('offset', 0)
        limit = request.args.get('limit', 10)
        query = db.session.\
            query(Order, Seller.username, Buyer.username, Good.good_name).\
            join(Seller, Seller.seller_id == Order.seller_id).\
            join(Buyer, Buyer.buyer_id == Order.buyer_id).\
            join(Good, Good.good_id == Order.good_id)
        if typ == 0:
            query = query.filter(Order.seller_id == uid)
        if typ == 1:
            query = query.filter(Order.buyer_id == uid)
        if order_type != None:
            query = query.filter(Order.order_state == order_type)
        if search_words != "":
            query = query.filter(or_(
                Order.good_name.like('%%%s%%' % search_words),
                Order.good_description.like('%%%s%%' % search_words),
            ))
        count = query.count()
        if order_by == 'order_time' or order_by == 'pay_time' or order_by == 'deliver_time' or order_by == 'success_time' or order_by == 'cancel_time':
            query = query.order_by(Order.__dict__[order_by].desc())
        query = query.\
            offset(offset).\
            limit(limit)
        records: Tuple[List[Order], str, str] = query.all()

        return json.dumps({
            'totalItem': count,
            'userType': typ,
            'items': [{
                'id': order.order_id,
                'orderState': order.order_state,
                'goodName': good_name,
                'sellerName': seller_name,
                'buyerName': buyer_name,
                'goodId': order.good_id,
                'numbers': order.numbers,
                'orderTime': try_into_timestamp(order.order_time),
                'payTime': try_into_timestamp(order.pay_time),
                'deliverTime': try_into_timestamp(order.deliver_time),
                'completeTime': try_into_timestamp(order.success_time),
                'cancelTime': try_into_timestamp(order.cancel_time),
                'amount': float(order.amount),
            } for order, seller_name, buyer_name, good_name in records]
        })
    else:
        if typ == 1:
            orders_data = json.loads(request.data)
            order_iter = filter(lambda order: order.buyer_id == uid, map(
                lambda order: Order(**order), orders_data))
            orders = [order for order in order_iter]
            db.session.add_all(orders)
            db.session.commit()
            return b"", 201


@app.route('/api/order/<order_id>', methods=['PUT'])
@auth_guard
def update_order_state(order_id: int):
    order: Order = Order.query.filter_by(order_id=order_id).first()
    if order is None:
        return b'', 404
    target_state = request.args.get('targetState')
    try:
        target_state = int(target_state)
    except Exception:
        return b'', 400

    (_, uid, typ) = session.get_user_data()
    if target_state == 4 and (
            typ == 1 and order.buyer_id == uid or
            typ == 0 and order.seller_id == uid):  # 取消
        if order.order_state > 0 and order.order_state < 4:  # 退款
            buyer: Buyer = Buyer.query.filter_by(
                buyer_id=order.buyer_id).first()
            seller: Seller = Seller.query.filter_by(
                seller_id=order.seller_id).first()
            if seller is None or buyer is None:
                return b'', 409  # conflict
            buyer.balance = buyer.balance + order.amount
            seller.balance = seller.balance - order.amount
            db.session.add(buyer)
            db.session.add(seller)
        order.order_state = 4
        order.cancel_time = datetime.datetime.now()
        db.session.add(order)
        db.session.commit()
        return b'', 200

    if order.order_state == 0 and target_state == 1 and typ == 1 and order.buyer_id == uid:  # 付款
        buyer: Buyer = Buyer.query.filter_by(buyer_id=uid).first()
        seller: Seller = Seller.query.filter_by(
            seller_id=order.seller_id).first()
        if seller is None:
            return b'', 409  # conflict
        if buyer.balance < order.amount:
            return b'', 402  # payment required
        order.order_state = 1
        order.pay_time = datetime.datetime.now()
        buyer.balance = buyer.balance - order.amount
        seller.balance = seller.balance + order.amount
        db.session.add(order)
        db.session.add(buyer)
        db.session.add(seller)
        db.session.commit()
        return b'', 200

    if order.order_state == 1 and target_state == 2 and typ == 0 and order.seller_id == uid:  # 发货
        order.order_state = 2
        order.deliver_time = datetime.datetime.now()
        db.session.add(order)
        db.session.commit()
        return b'', 200

    if order.order_state == 2 and target_state == 3 and typ == 1 and order.buyer_id == uid:  # 确认收货
        order.order_state = 3
        order.success_time = datetime.datetime.now()
        db.session.add(order)
        db.session.commit()
        return b'', 200

    return b'', 403  # 其它情况，Forbidden


@app.route('/api/mock/session', methods=['POST'])
@flask_env_guard(['test', 'dev'])
def mock_login():
    try:
        session.mock_login()
        return b"", 201
    except Exception:
        return b"", 400

@app.route('/api/userInfo', methods=['GET'])
@auth_guard
def get_user_data():
    [username, userid, typ] = session.get_user_data()
    return json.dumps({
        'username': username,
        'userid': userid,
        'typ': typ,
    })

@app.route('/<file>')
def send_static(file):
    return send_from_directory(STATIC_DIRECTORY, file)