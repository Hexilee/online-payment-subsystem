from db import db
from sqlalchemy.sql.sqltypes import TIMESTAMP
from utils import try_from_timestamp


class Buyer(db.Model):
    __tablename__ = "Buyer"
    buyer_id = db.Column(db.Integer, primary_key=True,
                         nullable=False, name="BuyerId")
    username = db.Column(db.String(40), nullable=False, name="UserName")
    balance = db.Column(db.Numeric(25, 2), nullable=False, name="Balance")


class Seller(db.Model):
    __tablename__ = "Seller"
    seller_id = db.Column(db.Integer, primary_key=True,
                          nullable=False, name="SellerId")
    username = db.Column(db.String(40), nullable=False, name="UserName")
    balance = db.Column(db.Numeric(25, 2), nullable=False, name="Balance")

class Good(db.Model):
    __tablename__ = "Good"
    good_id = db.Column(db.Integer, primary_key=True,
                         nullable=False, name="GoodID")
    good_name = db.Column(db.String(255), nullable=False, name="GoodName")

class Order(db.Model):
    __tablename__ = "Order"
    order_id = db.Column(db.Integer, primary_key=True,
                         nullable=False, name="OrderNo")
    buyer_id = db.Column(db.Integer, db.ForeignKey(
        'Buyer.BuyerId'), nullable=False, name="BuyerId")
    seller_id = db.Column(db.Integer, db.ForeignKey(
        'Seller.SellerId'), nullable=False, name="SellerId")
    good_id = db.Column(db.Integer, db.ForeignKey(
        'Good.GoodID'), nullable=False, name="GoodID")
    numbers = db.Column(db.Integer, nullable=False, name="Numbers")
    order_state = db.Column(db.Integer, nullable=False, name="OrderState")
    order_time = db.Column(TIMESTAMP, nullable=False, name="OrderTime")
    pay_time = db.Column(TIMESTAMP, name="PayTime")
    deliver_time = db.Column(TIMESTAMP, name="DeliverTime")
    cancel_time = db.Column(TIMESTAMP, name="CancelTime")
    success_time = db.Column(TIMESTAMP, name="SuccessTime")
    amount = db.Column(db.Numeric(25, 2), nullable=False, name="Amount")

    def __init__(self, **obj):
        self.__dict__.update(obj)
        self.order_time = try_from_timestamp(self.order_time)
        self.pay_time = try_from_timestamp(self.pay_time)
        self.deliver_time = try_from_timestamp(self.deliver_time)
        self.success_time = try_from_timestamp(self.success_time)
        self.cancel_time = try_from_timestamp(self.cancel_time)
