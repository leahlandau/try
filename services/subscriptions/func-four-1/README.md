# Subscription automation function

This folder contains code deployed for a function-app in Azure - the code receives a subscription and checks whether the subscription has been used in the last month and also if the cost of the subscription is lower than the budget intended for it. Any subscription that turns out to be unusable or turns out to be unprofitable in terms of budget is transferred to another function-app that handles the problem, and informs those who need to know about it.

## Dependencies

The following dependencies are required to run the code end deploy to function-app:

- azure-functions
- azure-cli
- azure-identity
- azure-data-tables
- azure-storage-blob
- azure-mgmt-monitor
- azure-mgmt-consumption
- azure-mgmt-resource
- azure-mgmt-storage
- azure-keyvault-secrets
- pytest
- pytest_mock
- black
- python-dateutil
- pytest-cov
- python-dotenv
- pytz
- requests
- openpyxl

These dependencies exist in the 'requirements.txt' file.

## Running the code

The code is automatically run using CI CD processes through workflow.

## Tests

The code has undergone in-depth TEST tests with respect to end situations, the tests are also automatically run in the CI CD process through workflow.
