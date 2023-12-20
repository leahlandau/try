from datetime import datetime
from unittest.mock import patch
from project.upload_to_subs_to_delete import *


def test_build_sub_object():
    date = datetime.now(tz = timezone("Asia/Jerusalem"))
    Sub = type(
        "Sub",
        (object,),
        {
            "subscription_id": "id",
            "display_name": "name",
            "PartitionKey": date.strftime("%Y-%m-%d %H:%M:%S"),
            "reason": "not activity",
        },
    )
    sub = Sub()
    return_sub = dict(
        {
            "PartitionKey": date.strftime("%Y-%m-%d"),
            "RowKey": date.strftime("%Y-%m-%d %H:%M:%S"),
            "subscription_id": sub.subscription_id,
            "subscription_name": sub.display_name,
            "reason": "not activity",
        }
    )
    assert build_sub_object(sub, False, False) == return_sub
    Sub = type(
        "Sub",
        (object,),
        {},
    )
    sub = Sub()
    assert build_sub_object(sub, False, False) == "'Sub' object has no attribute 'subscription_id'"


@patch("project.upload_to_subs_to_delete.build_sub_object",return_value = [{"subscription_id": "id"}])
@patch("project.upload_to_subs_to_delete.upload_to_table")
def test_upload_deleted_subscriptions(build_email_object, upload_to_table):
    assert upload_subscriptions_to_delete({"subscription_id": "id"}, False, False) == None
    