from flask import Flask
from flask_cors import CORS
from config import *

app = Flask(__name__)
CORS(app, supports_credentials=True)

app.config['SECRET_KEY'] = SESSION_SECRET_KEY
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://%s:%s@%s:%s/%s?charset=utf8' % (DB_USERNAME, DB_PASSWD, DB_HOST, DB_PORT, DB_NAME)
app.config['SQLALCHEMY_COMMIT_ON_TEARDOWN'] = True
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True
app.config['SQLALCHEMY_ECHO'] = True
