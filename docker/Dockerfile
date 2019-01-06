FROM ubuntu:latest

# SVN & Git installation
RUN apt-get update \
    && apt-get install -y subversion git

# Set the workdir
RUN mkdir -p /app
WORKDIR /app
