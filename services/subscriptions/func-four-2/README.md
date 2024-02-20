# Subscription list function

This folder contains code for the function-app in Azure - goes through all existing subscriptions and returns a list of all subscriptions that are not marked as important.
The function goes through the entire list and sends each one to another function-app that checks the relevant tests on it.
In addition, the creation of an Excel file is activated, containing all the details of the subscriptions intended for deletion due to lack of use or a budget problem - the details are filled in the second function-app after the desired tests, then it is sent to the function-app that is responsible for sending the emails and an updated file is sent to the company manager in Azure.

## Dependencies

The following dependencies are required to run the code end deploy to function-app:

- azure-functions
- azure-cli
- azure-mgmt-resource
- azure-keyvault-secrets
- azure-storage-blob
- azure-identity
- azure-data-tables
- python-dotenv
- python-dateutil
- pytz
- requests
- openpyxl

These dependencies exist in the 'requirements.txt' file.

## Running the code

The code is automatically run using CI CD processes through workflow.

## Tests

The code has undergone in-depth TEST tests with respect to end situations, the tests are also automatically run in the CI CD process through workflow.
