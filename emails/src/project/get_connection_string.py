from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient
from config import config_variables

credentials = DefaultAzureCredential()

def get_connection_string_from_keyvault():
    client = SecretClient(config_variables.keyvault_uri, credential = credentials)
    keyVaultNameValue = client.get_secret(config_variables.secret_name)
    return keyVaultNameValue.value