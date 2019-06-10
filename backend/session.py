from flask import session
from typing import Tuple
def get_user_data() -> Tuple[str, int, int]:
    return (session.get('username'), int(session.get('userid')), int(session.get('type')))

def mock_login():
    session['username'] = 'Zhang'
    session['userid'] = 1
    session['type'] = 1 # 1 for buyer, 0 for seller