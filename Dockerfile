FROM ubuntu:latest

RUN apt-get update \
    && apt-get install -y subversion git

EXPOSE 80

CMD ["echo", "Welcome!"]

RUN exec $@
