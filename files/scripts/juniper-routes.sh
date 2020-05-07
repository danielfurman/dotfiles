#!/usr/bin/env bash

set -x

run() {
	CONTAINER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' juniper-vpn)
	CONTAINER_DEVICE=$(ip ro get $CONTAINER_IP | head -1 | awk '{ print $3 }')

	sudo ip ro replace 10.50.0.0/16 via ${CONTAINER_IP}
	sudo ip ro replace 10.76.0.0/16 via ${CONTAINER_IP}
	sudo ip ro replace 10.84.0.0/16 via ${CONTAINER_IP}
	sudo ip ro replace 10.87.0.0/16 via ${CONTAINER_IP}
	sudo ip ro replace 10.88.0.0/16 via ${CONTAINER_IP}
	sudo ip ro replace 10.104.0.0/16 via ${CONTAINER_IP}
	sudo ip ro replace 10.155.0.0/16 via ${CONTAINER_IP}
	sudo ip ro replace 10.160.0.0/16 via ${CONTAINER_IP}
	sudo ip ro replace 10.171.0.0/16 via ${CONTAINER_IP}
	sudo ip ro replace 172.30.0.0/16 via ${CONTAINER_IP}
	sudo ip ro replace 172.29.0.0/16 via ${CONTAINER_IP}

	sudo /usr/bin/systemd-resolve \
		--interface ${CONTAINER_DEVICE} \
		--set-dns 127.0.53.1 \
		--set-domain juniper.net \
		--set-domain jnpr.net
}

run
