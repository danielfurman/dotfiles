#!/usr/bin/env bash
# Clone Juniper repositories.

run() {
	repositories="\
		git@cl-gitlab.intra.codilime.com:kamil.braun/contrail-bash-api.git \
		git@github.com:Juniper/asf.git \
		git@github.com:Juniper/contrail-analytics.git \
		git@github.com:Juniper/contrail-ansible-deployer.git
		git@github.com:Juniper/contrail-api-client.git \
		git@github.com:Juniper/contrail-build.git \
		git@github.com:Juniper/contrail-datapath-encryption.git \
		git@github.com:Juniper/contrail-deployers-containers.git \
		git@github.com:Juniper/contrail-docs.git \
		git@github.com:Juniper/contrail-multi-cloud.git \
		git@github.com:Juniper/contrail-packages.git \
		git@github.com:Juniper/contrail-project-config.git \
		git@github.com:Juniper/contrail-vnc-private.git \
		git@github.com:Juniper/contrail-vnc.git \
		git@github.com:Juniper/contrail-vrouter.git \
		git@github.com:Juniper/contrail-windows-ci.git \
		git@github.com:Juniper/terraform-provider-contrail.git \
		git@github.com:codilime/contrail-lab.git \
		git@github.com:tungstenfabric/docs.git \
		git@github.com:tungstenfabric/tf-analytics.git \
		git@github.com:tungstenfabric/tf-api-client.git \
		git@github.com:tungstenfabric/tf-common.git \
		git@github.com:tungstenfabric/tf-container-builder.git \
		git@github.com:tungstenfabric/tf-controller.git \
		git@github.com:tungstenfabric/tf-dev-env.git \
		git@github.com:tungstenfabric/tf-devstack.git \
		git@github.com:tungstenfabric/tf-test.git \
		git@github.com:tungstenfabric/tf-web-controller.git \
		git@github.com:tungstenfabric/tf-web-core.git \
		git@ssd-git.juniper.net:atom/atom-operator-framework/atom-infra.git \
		git@ssd-git.juniper.net:atom/atom.git \
		git@ssd-git.juniper.net:contrail/command-app-server.git \
		git@ssd-git.juniper.net:contrail/command-deployer.git \
		git@ssd-git.juniper.net:contrail/command-ui.git \
		git@ssd-git.juniper.net:contrail/contrail-build-jobs.git \
		ssh://dfurman@review.opencontrail.org:29418/Juniper/contrail-common.git \
		ssh://dfurman@review.opencontrail.org:29418/Juniper/contrail-container-builder.git \
		ssh://dfurman@review.opencontrail.org:29418/Juniper/contrail-specs.git \
		ssh://dfurman@review.opencontrail.org:29418/Juniper/contrail-test.git \
		ssh://dfurman@review.opencontrail.org:29418/Juniper/contrail-third-party.git \
		ssh://dfurman@review.opencontrail.org:29418/Juniper/contrail-zuul-jobs.git \
	"

	for r in ${repositories}
	do
		git clone ${r}
	done
}

run
