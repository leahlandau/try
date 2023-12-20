import requests
from project.body_email import *
from project.subscription_activity import *
from project.upload_to_deleted_subs import upload_deleted_subscriptions
from project.upload_to_emails import upload_to_emails
from project.upload_to_subs_to_delete import upload_subscriptions_to_delete
from project.sub_manager_email import get_email_manager_by_sub_name
from project.write_to_excel import write_to_excel
import config.config_variables 
import azure.functions as func

app = func.FunctionApp()

@app.function_name(name = "HttpTrigger1")
@app.route(route = "")
def subscriptions_automation_function(req: func.HttpRequest) -> func.HttpResponse:
    subscriptions = get_subscriptions()
    if subscriptions == []:
        return func.HttpResponse(
        "No subscriptions were found that meet the requirement.",
        status_code = 200
    )
    subscriptions_to_excel=[]
    for sub in subscriptions:
        activity = check_subscription_activity(sub.subscription_id)
        low_price = is_lower_than_the_set_price(sub.subscription_id)
        if activity == False or low_price == True:
            body = build_email_body(
                sub.display_name, sub.subscription_id, activity, low_price
            )
            recipient_email = get_email_manager_by_sub_name(sub.display_name)
            if not recipient_email.__contains__('@'):
                recipient_email = config.config_variables.recipient_email
            if body != "":
                requests.post(
                    config.config_variables.http_trigger_url,
                    json = {
                        "recipient_email": recipient_email,
                        "subject": "Subscription Activity Alert",
                        "body": body,
                        "excel":None
                    }
                )
            body_to_excel = build_email_body_to_excel(activity,low_price)
            subscriptions_to_excel.append({"display_name":sub.display_name,"subscription_id":sub.subscription_id,"body":body_to_excel})
            upload_to_emails(recipient_email, activity, low_price)
            upload_subscriptions_to_delete(sub, activity, low_price)
    if subscriptions_to_excel != [] :
        write_to_excel(subscriptions_to_excel)
        requests.post(
            config.config_variables.http_trigger_url,
            json = {
                "recipient_email": config.config_variables.shelis_email,
                "subject": "Summary Subscription",
                "body": "קובץ סיכום",
                "excel":'file_subscription.xlsx'
            })  
    upload_deleted_subscriptions(subscriptions) 
    return func.HttpResponse(
        "This HTTP triggered function executed successfully.",
        status_code = 200
    )