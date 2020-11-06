PACKER_VERSION=1.6.5
AMI_NAME_PREFIX?=flugel-microk8s-aws

install_packer:
	./bin/installdep.sh packer https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip ./bin

ami: install_packer
	AMI_NAME_PREFIX=${AMI_NAME_PREFIX} packer build packer/microk8s-aws.json
