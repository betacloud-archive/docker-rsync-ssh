#!/usr/bin/env bash

SSH_HOST_KEY_TYPES=( "rsa" "dsa" "ecdsa" "ed25519" )

for key_type in ${SSH_HOST_KEY_TYPES[@]}; do
    KEY_PATH=/etc/ssh/ssh_host_${key_type}_key
    if [[ ! -f "${KEY_PATH}" ]]; then
        ssh-keygen -q -t ${key_type} -f ${KEY_PATH} -N ""
    fi
done

mkdir -p /var/lib/rsync/.ssh

if [[ $(stat -c %U:%G /var/lib/rsync/.ssh) != "rsync:rsync" ]]; then
    chown rsync: /var/lib/rsync/.ssh
fi

echo "$RSYNC_AUTHORIZED_KEYS" > /var/lib/rsync/.ssh/authorized_keys
chmod 600 /var/lib/rsync/.ssh/authorized_keys

exec /usr/sbin/sshd -D
