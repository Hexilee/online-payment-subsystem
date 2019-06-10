from app import app
from models import *
import json
import session
import time
from flask import request
from sqlalchemy import or_
from middleware import auth_guard
from db import db
from utils import try_from_timestamp, try_into_timestamp
from typing import List, Tuple


@app.route('/api/order', methods=['GET', 'POST'])
@auth_guard
def get_orders():
    (_, uid, typ) = session.get_user_data()
    if request.method == "GET":
        order_type = request.args.get('orderType')
        end_time = try_from_timestamp(
            int(request.args.get('endTime', time.time())))
        search_words = request.args.get('search_words', "")
        offset = request.args.get('offset', 0)
        limit = request.args.get('limit', 10)
        query = db.session.\
            query(Order, Seller.username, Buyer.username).\
            join(Seller, Seller.seller_id == Order.seller_id).\
            join(Buyer, Buyer.buyer_id == Order.buyer_id)
        if typ == 0:
            query = query.filter(Order.seller_id == uid)
        if typ == 1:
            query = query.filter(Order.buyer_id == uid)
        if order_type != None:
            query = query.filter(Order.order_state == order_type)
        query = query.filter(Order.order_time <= end_time)
        if search_words != "":
            query = query.filter(or_(
                Order.good_name.like('%%%s%%' % search_words),
                Order.good_description.like('%%%s%%' % search_words),
            ))
        count = query.count()
        query = query
        query = query.offset(offset).limit(limit)
        records: Tuple[List[Order], str, str] = query.all()

        return json.dumps({
            'totalItem': count,
            'userType': typ,
            'items': [{
                'id': order.order_id,
                'orderState': order.order_state,
                'goodName': order.good_name,
                'goodDescription': order.good_description,
                'sellerName': seller_name,
                'buyerName': buyer_name,
                'orderTime': try_into_timestamp(order.order_time),
                'payTime': try_into_timestamp(order.pay_time),
                'deliverTime': try_into_timestamp(order.pay_time),
                'completeTime': try_into_timestamp(order.success_time),
                'cancelTime': try_into_timestamp(order.cancel_time),
                'amount': float(order.amount),
            } for order, seller_name, buyer_name in records]
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


@app.route('/api/mock/session', methods=['POST'])
def mock_login():
    session.mock_login()
    return b"", 201
