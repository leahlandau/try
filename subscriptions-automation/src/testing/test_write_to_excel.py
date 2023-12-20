from unittest.mock import patch, Mock
from project.write_to_excel import *
import project.get_connection_string

class mock_Workbook():
    def __init__(self):
        self.active = {}
    def save(self,file_stream):
        return 'save'


@patch("project.get_connection_string.get_connection_string_from_keyvault",return_value = "connection_string")
@patch('project.write_to_excel.Workbook',mock_Workbook)
@patch('project.write_to_excel.BlobServiceClient')
def test_write_to_excel(get_connection_string_from_keyvault,BlobServiceClient):
    result =  write_to_excel([{"display_name": "display_name","subscription_id": "subscription_id","body": "body"}])
    assert result == None
