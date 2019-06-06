from app import app
from flask_sqlalchemy import SQLAlchemy
from config import *;

app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://%s:%s@%s:%s/%s' % (DB_USERNAME, DB_PASSWD, DB_HOST, DB_PORT, DB_NAME)
app.config['SQLALCHEMY_COMMIT_ON_TEARDOWN'] = True
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True
app.config['SQLALCHEMY_ECHO'] = True
db = SQLAlchemy(app)