FROM mcr.microsoft.com/azure-functions/python:3.0

ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true

COPY . /home/site/wwwroot

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

CMD ["python", "-m", "function_app"]





# FROM python

# # --- NETFREE CERT INTSALL ---
# # ADD https://netfree.link/dl/unix-ca.sh /home/netfree-unix-ca.sh
# # RUN cat  /home/netfree-unix-ca.sh | sh
# # ENV NODE_EXTRA_CA_CERTS=/etc/ca-bundle.crt
# # ENV REQUESTS_CA_BUNDLE=/etc/ca-bundle.crt
# # ENV SSL_CERT_FILE=/etc/ca-bundle.crt
# # --- END NETFREE CERT INTSALL ---

# COPY requirements.txt requirements.txt

# RUN pip install -r requirements.txt