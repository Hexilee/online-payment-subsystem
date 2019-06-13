import unittest
import os
import tempfile
from app import app
from db import db
from models import *
import handlers


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
            self.seller = Seller(username='XIXI', balance=100000)
            self.buyer = Buyer(username='HEX', balance=100000)
            db.session.add(self.seller)
            db.session.add(self.buyer)
            db.commit()

    # clean up logic
    # code that is executed after each test
    def tearDown(self):
        os.close(self.db_fd)
        os.unlink(self.path)

    def test_get_without_cookie(self):
        resp = self.client.get('/api/order')
        self.assertEqual(401, resp.status_code, 'status should be unauthenrized')

# runs the unit tests in the module
if __name__ == '__main__':
    unittest.main()
