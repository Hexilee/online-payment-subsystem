from app import app
from models import *
import json
import session
import time
from flask import request
from middleware import auth_guard

@app.route('/api/order')
@auth_guard
def get_orders():
    state = request.args.get('state', None)
    end_time = time.localtime(request.args.get('end', time.time()))
    page_size = request.args.get('size', 15)
    (username, typ) = session.get_user_data()
    query = Buyer.query if typ == 1 else Seller.query
    user = query.filter_by(username=username).first()
    return json.dumps(Order.query.all())

@app.route('/api/mock/session', methods = ['POST'])
def mock_login():
    session.mock_login()
    return b"", 201
