import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from dotenv import load_dotenv

load_dotenv()

num_of_months = os.getenv("NUM_OF_MONTHS")
cost = os.getenv("COST")
table_subscriptions_to_delete = os.getenv("TABLE_SUBSCRIPTIONS_TO_DELETE")
table_deleted_subscriptions = os.getenv("TABLE_DELETED_SUBSCRIPTIONS")
table_subscription_managers=os.getenv("TABLE_SUBSCRIPTIONS_MANAGERS")
table_emails = os.getenv("TABLE_EMAILS")
http_trigger_url = os.getenv("HTTP_TRIGGER_URL")
recipient_email=os.getenv("RECIPIENT_EMAIL")
secret_name=os.getenv("SECRET")
keyvault_name= os.getenv("KEYVAULT_NAME")
keyvault_uri = os.getenv("KEYVAULT_URI")
shelis_email=os.getenv("SHELIS_EMAIL")
tag_name=os.getenv("TAG_NAME")
