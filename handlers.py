from app import app
from models import Order
import json
import session
from middleware import auth_guard

@app.route('/api/order')
@auth_guard
def get_orders():
    (username, typ) = session.get_user_data()
    return json.dumps(Order.query.all())

@app.route('/api/mock/session', methods = ['POST'])
def mock_login():
    session.mock_login()
    return b"", 201
