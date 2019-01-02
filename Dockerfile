FROM node:alpine as git
RUN apk update && apk add --no-cache git openssh && rm -rf /var/cache/apk/*
RUN adduser -h /home/git -s /usr/bin/git-shell -S git
# Unlocking the git account for SSH
RUN cat /etc/shadow | sed -e s/git:\!:/git:\*:/g > /etc/shadow
RUN mkdir -p /git/repo ; mkdir /git/keys ; mkdir /home/git/.ssh ; chmod 700 /home/git/.ssh ; mkdir -p /git/hostkeys/etc/ssh/

FROM git
RUN mkdir -p /git/cmd
COPY ./sshd.sh /git/cmd/sshd.sh
RUN chmod +x /git/cmd/sshd.sh
WORKDIR /app
EXPOSE 8002
ENV PORT=8002
ENTRYPOINT ["/bin/sh", "/git/cmd/sshd.sh"]
CMD []
