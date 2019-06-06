from db import db

class Buyer(db.Model):
    __tablename__ = "Buyer"
    buyer_id = db.Column(db.Integer, primary_key=True, nullable=False, name="BuyerId")
    username = db.Column(db.String(40), nullable=False, name="UserName")

class Seller(db.Model):
    __tablename__ = "Seller"
    seller_id = db.Column(db.Integer, primary_key=True, nullable=False, name="SellerId")
    username = db.Column(db.String(40), nullable=False, name="UserName")


class Order(db.Model):
    __tablename__ = "Order"
    order_id = db.Column(db.Integer, primary_key=True, nullable=False, name="OrderNo")
    buyer_id = db.Column(db.Integer, db.ForeignKey('Buyer.BuyerId'), nullable=False, name="BuyerId")
    seller_id = db.Column(db.Integer, db.ForeignKey('Seller.SellerId'), nullable=False, name="SellerId")

db.create_all()