from flask import session
from functools import wraps
from app import app
from typing import List


def auth_guard(handler):
    @wraps(handler)
    def authenticated_handler(*args, **kwargs):
        if session.get('username') is None or session.get('userid') is None or session.get('type') is None:
            return b"", 401
        else:
            return handler(*args, **kwargs)
    return authenticated_handler


def flask_env_guard(allow: List[str]):
    def flask_env_guard_decorator(handler):
        @wraps(handler)
        def env_guard_handler(*args, **kwargs):
            if app.config['FLASK_ENV'] in allow:
                return handler(*args, **kwargs)
            else:
                return b"", 403
        return env_guard_handler
    return flask_env_guard_decorator
