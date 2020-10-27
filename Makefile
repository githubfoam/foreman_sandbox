IMAGE := alpine/fio
APP:="app/deploy-openesb.sh"

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
