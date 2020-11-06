IMAGE := alpine/fio
APP:="app/deploy-openesb.sh"

deploy-yocto-latest-toolchain:
	bash deploy-yocto-latest-toolchain.sh

deploy-yocto-latest-sdk:
	bash deploy-yocto-latest-sdk.sh

deploy-yocto-toolchain:
	bash deploy-yocto-toolchain.sh

deploy-yocto-sdk:
	bash deploy-yocto-sdk.sh

deploy-topology-opennebula:
	bash scripts/deploy-topology-opennebula.sh

deploy-topology-cobbler:
	bash scripts/deploy-topology-cobbler.sh

deploy-topology-katello:
	bash scripts/deploy-topology-katello.sh

deploy-libvirt:
	bash scripts/deploy-libvirt.sh

deploy-vagrant:
	bash scripts/deploy-vagrant.sh
	
push-image:
	docker push $(IMAGE)
.PHONY: deploy-openesb deploy-dashboard push-image
