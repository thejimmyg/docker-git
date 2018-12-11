FROM node:alpine as git
RUN apk update && apk add --no-cache git openssh && rm -rf /var/cache/apk/*
RUN adduser -h /home/git -s /usr/bin/git-shell -S git
# Unlocking the git account for SSH
RUN cat /etc/shadow | sed -e s/git:\!:/git:\*:/g > /etc/shadow
RUN mkdir -p /git/repo ; mkdir /git/keys ; mkdir /home/git/.ssh ; chmod 700 /home/git/.ssh ; mkdir -p /git/hostkeys/etc/ssh/

FROM git as builder
RUN mkdir -p /app
WORKDIR /app
COPY bin/ /app/bin/
COPY package.json /app
COPY package-lock.json /app
# RUN npm install

FROM git
COPY --from=builder /app /app
RUN mkdir -p /git/cmd
COPY ./sshd.sh /git/cmd/sshd.sh
RUN chmod +x /git/cmd/sshd.sh
WORKDIR /app
EXPOSE 8002
ENV NODE_PATH=/app/node_modules
ENV PORT=8002
ENV NODE_ENV=production
ENV PATH="${PATH}:/app/node_modules/.bin"
#RUN chmod 644 /git/keys/authorized_keys ; chown git:git /git/keys/authorized_keys
#RUN chmod 644 /home/git/.ssh/authorized_keys ; chown git:git /home/git/.ssh/authorized_keys
ENTRYPOINT ["/bin/sh", "/git/cmd/sshd.sh"]
CMD []
