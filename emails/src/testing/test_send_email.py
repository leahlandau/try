from project.send_email import build_email_message
import os
import sys
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
import project.download_excel
import config.config_variables
from unittest import mock
from unittest.mock import Mock, patch


def test_build_email_message():
    mock_config = mock.Mock()
    mock_config.sender_email = "example@example.com"
    email_recipient = "porina3345@ustorp.com"
    subject = "Test build email message"
    body = "Test build email message"
    with mock.patch("config.config_variables", mock_config):
        result = build_email_message(email_recipient, subject, body,None)
        assert result["To"] == "porina3345@ustorp.com"
        assert result["Subject"] == "Test build email message"
        assert result["Content-Type"] == 'text/plain; charset="utf-8"'
        assert result["Content-Transfer-Encoding"] == "7bit"
        assert result["MIME-Version"] == "1.0"

    
@patch("project.download_excel.download_blob_excel",return_value = "att_file")
def test_build_email_message_with_excel(download_blob_excel):
    mock_config = mock.Mock()
    mock_config.sender_email = "example@example.com"
    excel = "alert_file.xlsx"
    email_recipient = "porina3345@ustorp.com"
    subject = "Test build email message"
    body = "Test build email message"
    with mock.patch("config.config_variables", mock_config):
        result = build_email_message(email_recipient, subject, body,excel)
        assert result["To"] == "porina3345@ustorp.com"
        assert result["Subject"] == "Test build email message"
        assert result["Content-Type"] == 'multipart/mixed'
        assert result["MIME-Version"] == "1.0"
    
