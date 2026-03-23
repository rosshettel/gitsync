FROM alpine
LABEL maintainer="Ross Hettel <ross@het.tel>"

RUN apk add --no-cache \
    bash \
    jq \
    openssh \
    git

WORKDIR /repos

VOLUME /config.json
VOLUME /root/.ssh

COPY ./sync.sh /repos/sync.sh
COPY ./entrypoint.sh /repos/entrypoint.sh
RUN chmod +x /repos/sync.sh /repos/entrypoint.sh

CMD ["/repos/entrypoint.sh"]
