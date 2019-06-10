from flask import session

def auth_guard(handler):
    def authenticated_handler(*args, **kwargs):
        if session.get('username') is None or session.get('userid') is None or session.get('type') is None:
            return b"", 401
        else:
            return handler(*args, **kwargs)
    return authenticated_handler