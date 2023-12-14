FROM mcr.microsoft.com/azure-functions/python:4-python3.10

ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true \
    AzureWebJobsFeatureFlags=EnableWorkerIndexing \ 
    AzureWebJobsStorage=UseDevelopmentStorage=true 

COPY requirements.txt /
RUN pip install -r /requirements.txt

COPY . /home/site/wwwroot
# FROM mcr.microsoft.com/azure-functions/python:3.0
# FROM microsoft/azure-functions-python3.6:v2.0.11737-alpha

# ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
#     AzureFunctionsJobHost__Logging__Console__IsEnabled=true

# COPY . /home/site/wwwroot

# COPY requirements.txt requirements.txt

# RUN cd /home/site/wwwroot && pip install -r requirements.txt

# RUN cd /home/site/wwwroot


# RUN pip install -r requirements.txt

# CMD ["python", "-m", "function_app"]




# Install requirements



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