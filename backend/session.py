from flask import session
from typing import Tuple
def get_user_data():
    return (session.get('username'), session.get('userid'), session.get('type'))

def mock_login():
    session['username'] = 'Zhang'
    session['userid'] = 1
    session['type'] = 1 # 1 for buyer, 0 for seller