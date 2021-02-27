FROM ubuntu:latest

ARG PORT
ARG SERVERS
RUN apt-get update 
RUN apt-get install -y python3-pip
RUN pip3 install prometheus-client

RUN apt-get install -y iperf3

RUN mkdir /app
COPY entrypoint.py /app/

ENTRYPOINT [ "/app/entrypoint.py" ]
