
from openpyxl import Workbook
from azure.storage.blob import BlobServiceClient
import io
import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
import project.get_connection_string

def write_to_excel(excel_array):
    connection_string = project.get_connection_string.get_connection_string_from_keyvault()
    last_cell_written = 1
    blob_name = 'file_subscription.xlsx'
    for i in excel_array:
        if last_cell_written == 1:
            workbook = Workbook()
            sheet = workbook.active
            sheet['A1'] = "Subscription Name"
            sheet['B1'] = "Subscription ID"
            sheet['C1'] = "Reason To Delete"
            file_stream = io.BytesIO()
    
        column_subscription_name = "A{}".format(last_cell_written + 1)
        sheet[column_subscription_name] = i['display_name']
        column_subscription_id = "B{}".format(last_cell_written + 1)
        sheet[column_subscription_id] = i['subscription_id']
        column_body = "C{}".format(last_cell_written + 1)
        sheet[column_body] = i['body']
        workbook.save(file_stream)
        file_stream.seek(0)
        last_cell_written += 1

    container_name = 'excel'
    blob_service_client = BlobServiceClient.from_connection_string(connection_string)
    blob_client = blob_service_client.get_blob_client(container = container_name, blob = blob_name)
    blob_client.upload_blob(file_stream.getvalue(), overwrite = True)
