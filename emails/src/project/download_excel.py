from azure.storage.blob import BlobServiceClient
import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
import project.get_connection_string

def download_blob_excel(blob_name):
    connection_string = project.get_connection_string.get_connection_string_from_keyvault()
    container_name = 'excel'
    blob_service_client = BlobServiceClient.from_connection_string(connection_string)
    container_client = blob_service_client.get_container_client(container_name)
    blob_client = container_client.get_blob_client(blob_name)
    blob_data = blob_client.download_blob().readall()
    delete_blob_excel(container_name, blob_name)
    return blob_data

def delete_blob_excel(container_name, blob_name):
    connection_string = project.get_connection_string.get_connection_string_from_keyvault()
    blob_service_client = BlobServiceClient.from_connection_string(connection_string)
    container_client = blob_service_client.get_container_client(container_name)
    container_client.delete_blob(blob_name)
