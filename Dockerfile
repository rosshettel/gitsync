FROM gliderlabs/alpine
MAINTAINER Ross Hettel <ross@het.tel>

RUN apk-install \
    bash \
    jq \
    openssh \
    git

WORKDIR /repos

VOLUME /config.json
VOLUME /root/.ssh

ADD ./crontab /var/spool/cron/crontabs/root
ADD ./sync.sh /repos/sync.sh

CMD crond -f
