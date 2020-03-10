#!/usr/bin/env bash

run() {
	images="contrail-multicloud-openvpn contrail-multicloud-bird contrail-multicloud-strongswan \
		contrail-multicloud-vrrp contrail-node-init contrail-nodemgr contrail-vrouter-agent \\
		contrail-kubernetes-cni-init"

	for i in ${images}
	do
		curl -sS -u ${REGISTRY_USER}:${REGISTRY_PASSWORD} \
			https://hub.juniper.net/v2/contrail-nightly/${i}/tags/list | jq \
			'.name, (.tags[] | select(contains("2004.1091") or contains("master.1091")))'
	done
}

run
