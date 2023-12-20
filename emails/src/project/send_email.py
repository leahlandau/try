from email.mime.multipart import MIMEMultipart
from email.message import EmailMessage
from email.mime.application import MIMEApplication
import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
import config.config_variables
import project.download_excel

def build_email_message(recipient_email, subject, body, excel):
    sender_email = config.config_variables.sender_email
    message = MIMEMultipart()
    message['From'] = sender_email
    if excel != None:
        attachment_file = project.download_excel.download_blob_excel(excel)
        attach_file = MIMEApplication(attachment_file, _subtype = "octet-stream")
        attach_file.add_header('Content-Disposition', 'attachment', filename = excel)           
        message.attach(attach_file)
    else:
        message = EmailMessage()
        message.set_content(body)
    message["From"] = sender_email
    message["To"] = recipient_email
    message["Subject"] = subject
    return message
