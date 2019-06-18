from app import app
import handlers
import models
from config import PORT

if __name__ == '__main__':
    app.run(debug=True, port=PORT)