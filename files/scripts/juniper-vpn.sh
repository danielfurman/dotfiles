#!/usr/bin/env bash

run() {
	# After container rebuild we could face SSH remote identification change
	# and deny of connection. So we remove it.
	ssh-keygen -f "/home/$USER/.ssh/known_hosts" -R "[127.1]:2222"

	# Starting Pulse Secure connection dialog.
	sshpass -p 'root' ssh -X -D 127.0.0.1:1080 -o StrictHostKeyChecking=no root@127.1 -p 2222 /usr/local/pulse/pulseUi
}

run
