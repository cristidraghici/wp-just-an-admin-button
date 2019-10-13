# FROM alpine:3.6

# # SVN & Git installation
# RUN apk update && \
#   apk add --no-cache subversion && \
#   apk add --no-cache git && \
#   apk add --no-cache bash

FROM ubuntu:latest

# SVN & Git installation
RUN apt-get update \
    && apt-get install -y subversion git

EXPOSE 80

CMD ["echo", "Welcome!"]

RUN exec $@
