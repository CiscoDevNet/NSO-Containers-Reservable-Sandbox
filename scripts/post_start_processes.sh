#!/bin/bash

# Start SSH as non-root

/usr/sbin/sshd -f /home/developer/.ssh/sshd_config -h /nso/etc/ssh/ssh_host_ed25519_key &