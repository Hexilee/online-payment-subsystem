from app import app
from models import Order
import json
from session import get_user_data

@app.route('/')
def hello_world():
    (username, typ) = get_user_data()
    return json.dumps(Order.query.all())
