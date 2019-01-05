FROM alpine:3.6

# SVN & Git installation
RUN apt-get update \
    && apt-get install -y subversion git

# run the entrypoint
ADD ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
