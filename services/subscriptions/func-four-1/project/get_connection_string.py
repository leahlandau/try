from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient
import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
import config.config_variables

credentials = DefaultAzureCredential()


def get_connection_string_from_keyvault():
    try:
        client = SecretClient(
            config.config_variables.keyvault_uri, credential=credentials
        )
        keyVaultNameValue = client.get_secret(config.config_variables.secret_name)
        return keyVaultNameValue.value
    except Exception as ex:
        return str(ex)
