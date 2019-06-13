from flask import session
from typing import Tuple
from flask import request
from models import *


def get_user_data() -> Tuple[str, int, int]:
    return (session.get('username'), int(session.get('userid')), int(session.get('type')))


def mock_login():
    userid = int(request.args.get('userid'))
    typ = int(request.args.get('typ'))
    session['type'] = typ  # 1 for buyer, 0 for seller
    if typ == 1:
        session['username'] = Buyer.query.\
            filter_by(buyer_id=userid).\
            first().\
            username
        session['userid'] = userid
    else:
        session['username'] = Seller.query.\
            filter_by(seller_id=userid).\
            first().\
            username
        session['userid'] = userid
