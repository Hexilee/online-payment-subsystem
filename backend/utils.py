import datetime
import time

def try_from_timestamp(stamp: int) -> datetime:
    return None if stamp is None else datetime.datetime.fromtimestamp(stamp)

def try_into_timestamp(date: datetime) -> float:
    return None if date is None else time.mktime(date.timetuple())