from app import app
from models import *
import json
import session
import time
from flask import request
from middleware import auth_guard
from db import db

@app.route('/api/order', methods=['GET', 'POST'])
@auth_guard
def get_orders():
    (_, uid, typ) = session.get_user_data()
    if request.method == "GET":   
        state = request.args.get('state', None)
        end_time = time.localtime(request.args.get('end', time.time()))
        page_size = request.args.get('size', 15)
        return json.dumps(Order.query.all())
    else:
        if typ == 1:
            orders_data = json.loads(request.data)
            order_iter = filter(lambda order: order.buyer_id == uid, map(lambda order: Order(**order), orders_data))
            orders = [order for order in order_iter]
            db.session.add_all(orders)
            db.session.commit()
            return b"", 201
            
            

@app.route('/api/mock/session', methods = ['POST'])
def mock_login():
    session.mock_login()
    return b"", 201
