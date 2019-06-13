from .app import app
from . import handlers
from . import models

if __name__ == '__main__':
    app.run(debug=True)