import os
from dotenv import load_dotenv

load_dotenv()

sender_email = os.getenv("EMAIL_SENDER")
sender_email_password = os.getenv("SENDER_EMAIL_PASSWORD")
host = os.getenv("SMTP_HOST")
port = os.getenv("SMTP_PORT")
secret_name = os.getenv("SECRET")
keyvault_name = os.getenv("KEYVAULT_NAME")
keyvault_uri = os.getenv("KEYVAULT_URI")