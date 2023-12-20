import azure.functions as func
import ssl
import smtplib
import os
import sys
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
import config.config_variables
from project.send_email import build_email_message

app = func.FunctionApp()

@app.function_name(name = "HttpTrigger1")
@app.route(route = "")
def send_email_function(req: func.HttpRequest) -> func.HttpResponse:
    req_body = req.get_json()
    sender_email = config.config_variables.sender_email
    sender_email_password = config.config_variables.sender_email_password
    host = config.config_variables.host
    port = int(config.config_variables.port)
    message = build_email_message(req_body.get('recipient_email'),req_body.get('subject') ,req_body.get('body'),req_body.get('excel'))
    context = ssl.create_default_context()
    with smtplib.SMTP_SSL(host, port, context = context) as smtp:
        smtp.connect(host, port)  
        smtp.login(sender_email, sender_email_password)
        smtp.sendmail(sender_email,req_body.get('recipient_email'), message.as_string())
    return func.HttpResponse(
        "This HTTP triggered function executed successfully.",
        status_code = 200
    )
