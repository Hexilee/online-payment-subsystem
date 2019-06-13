from flask import Flask
from flask_cors import CORS
from config import *

app = Flask(__name__)
CORS(app, supports_credentials=True)

app.config['SECRET_KEY'] = SESSION_SECRET_KEY
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://%s:%s@%s:%s/%s?charset=utf8' % (DB_USERNAME, DB_PASSWD, DB_HOST, DB_PORT, DB_NAME)
app.config['SQLALCHEMY_ECHO'] = SQLALCHEMY_ECHO
app.config['FLASK_ENV'] = FLASK_ENV
