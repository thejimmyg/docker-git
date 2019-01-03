#!/bin/sh

cleanupInt() {
  echo "Received a SIGNINT. Exiting ..."
  exit
}

cleanupTerm() {
  echo "Received a SIGTERM. Exiting ..."
  exit
}

trap cleanupInt INT
trap cleanupTerm TERM


ssh-keygen -A -f /git/hostkeys
chown git /git/keys/authorized_keys
chmod 700 /git/keys/authorized_keys
mkdir -p /home/git/.ssh
chown -R git /home/git/.ssh
chmod 700 /home/git/.ssh
cp -p /git/keys/authorized_keys /home/git/.ssh/authorized_keys
echo /usr/sbin/sshd -h /git/hostkeys/etc/ssh/ssh_host_dsa_key -h /git/hostkeys/etc/ssh/ssh_host_ecdsa_key -h /git/hostkeys/etc/ssh/ssh_host_ed25519_key -h /git/hostkeys/etc/ssh/ssh_host_rsa_key $@
/usr/sbin/sshd -h /git/hostkeys/etc/ssh/ssh_host_dsa_key -h /git/hostkeys/etc/ssh/ssh_host_ecdsa_key -h /git/hostkeys/etc/ssh/ssh_host_ed25519_key -h /git/hostkeys/etc/ssh/ssh_host_rsa_key $@
while [ 1 -lt 2 ] 
do 
  /bin/sleep 1
  cp -puv /git/keys/authorized_keys /home/git/.ssh/authorized_keys
done
/bin/echo "Exiting"
