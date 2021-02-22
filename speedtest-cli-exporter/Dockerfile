FROM ubuntu:latest

ARG PORT
ARG SERVERS
RUN apt-get update 
RUN apt-get install -y python3-pip
RUN pip3 install prometheus-client

RUN apt-get install -y speedtest-cli

RUN mkdir /app
COPY run-speedtest.py /app/

ENTRYPOINT [ "/app/run-speedtest.py" ]
