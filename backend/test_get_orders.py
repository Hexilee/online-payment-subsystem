import unittest
import os
import tempfile
from app import app
from db import db
from models import *
import handlers
import json


class AppClass(unittest.TestCase):

    # initialization logic for the test suite declared in the test module
    # code that is executed before all tests in one test run
    @classmethod
    def setUpClass(cls):
        app.config['TESTING'] = True

    # clean up logic for the test suite declared in the test module
    # code that is executed after all tests in one test run
    @classmethod
    def tearDownClass(cls):
        pass

    # initialization logic
    # code that is executed before each test
    def setUp(self):
        self.db_fd, self.path = tempfile.mkstemp()
        app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:////%s' % self.path
        self.client = app.test_client()
        with app.app_context():
            db.create_all()
            seller = Seller(username='XIXI', balance=100000)
            buyer = Buyer(username='HEX', balance=100000)
            db.session.add(seller)
            db.session.add(buyer)
            db.session.commit()
            self.seller = {
                'seller_id': seller.seller_id,
                'username': seller.username,
                'balance': seller.balance,
            }

            self.buyer = {
                'buyer_id': buyer.buyer_id,
                'username': buyer.username,
                'balance': buyer.balance,
            }

    # clean up logic
    # code that is executed after each test
    def tearDown(self):
        os.close(self.db_fd)
        os.unlink(self.path)

    def test_get_without_cookie(self):
        resp = self.client.get('/api/userInfo')
        self.assertEqual(401, resp.status_code, 'should be unauthenrized')

    def test_login_as_seller(self):
        resp = self.client.post(
            '/api/mock/session?userid=%s&typ=0' % self.seller['seller_id'])
        self.assertEqual(201, resp.status_code, 'should be created')
        resp = self.client.get('/api/userInfo')
        self.assertEqual(200, resp.status_code, 'should be ok')
        data = json.loads(resp.data)
        self.assertDictEqual({
            'username': self.seller['username'],
            'userid': self.seller['seller_id'],
            'typ': 0
        }, data)

    def test_login_as_buyer(self):
        resp = self.client.post(
            '/api/mock/session?userid=%s&typ=1' % self.buyer['buyer_id'])
        self.assertEqual(201, resp.status_code, 'should be created')
        resp = self.client.get('/api/userInfo')
        self.assertEqual(200, resp.status_code, 'should be ok')
        data = json.loads(resp.data)
        self.assertDictEqual({
            'username': self.buyer['username'],
            'userid': self.buyer['buyer_id'],
            'typ': 1
        }, data)

    def test_pay(self):
        resp = self.client.post(
            '/api/mock/session?userid=%s&typ=1' % self.buyer['buyer_id'])
        self.assertEqual(201, resp.status_code, 'should be created')


# runs the unit tests in the module
if __name__ == '__main__':
    unittest.main()
