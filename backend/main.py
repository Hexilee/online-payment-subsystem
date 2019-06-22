from app import app
import handlers
import models
from config import PORT

if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True, port=PORT)