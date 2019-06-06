from flask import session
from typing import Tuple
def get_user_data():
    return (session.get('username'), session.get('type'))

def mock_login():
    session['username'] = 'xixi'
    session['type'] = 0