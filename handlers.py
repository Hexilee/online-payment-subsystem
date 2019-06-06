from app import app
from models import Order
import json

@app.route('/')
def hello_world():
    return json.dumps(Order.query.all())
