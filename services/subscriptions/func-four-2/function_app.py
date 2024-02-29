import azure.functions as func
import requests
from project.get_subscriptions import get_subscriptions
from project.upload_to_deleted_subs import upload_deleted_subscriptions
from project.excel_blob import get_last_row, create_excel_blob
import config.config_variables

app = func.FunctionApp()


@app.function_name(name="HttpTrigger1")
@app.route(route="")
def func_subscriptions_list(req: func.HttpRequest) -> func.HttpResponse:
    subscriptions = get_subscriptions()
    create_excel_blob()
    for sub in subscriptions:
        requests.post(
            config.config_variables.http_trigger_url_subscription_automation,
            json={
                "subscription_name": sub.display_name,
                "subscription_id": sub.subscription_id,
            },
        )
    upload_deleted_subscriptions(subscriptions)

    if get_last_row() >= 2:
        requests.post(
            config.config_variables.http_trigger_url,
            json={
                "recipient_email": config.config_variables.cloud_email,
                "subject": "Summary Subscription",
                "body": "Summary file",
                "excel": "file_subscription.xlsx",
            },
        )

    return func.HttpResponse(
        "This HTTP triggered function executed successfully. ", status_code=200
    )
