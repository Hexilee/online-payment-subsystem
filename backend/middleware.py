from session import get_user_data

def auth_guard(handler):
    def authenticated_handler(*args, **kwargs):
        (username, uid, typ) = get_user_data()
        if username is None or uid is None or typ is None:
            return b"", 401
        else:
            return handler(*args, **kwargs)
    return authenticated_handler