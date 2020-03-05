# Spot InstancesTest Makefile

VENV := spot-env
TERRAFORM := $(PWD)/bin/terraform
TERRAVERS = $$( ./sh/get_terraform_version.sh )
TERRAURL := https://releases.hashicorp.com/terraform/$(TERRAVERS)/terraform_$(TERRAVERS)_linux_amd64.zip
KEYS := terraform/ec2.key
SYSUSER :=  $$( cat conf/sysuser.txt )
SSHOPTS := -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null

SPOT_STATUS = $$( cd terraform && $(TERRAFORM)  output -json spot_status | awk -F\" ' { print $$2 } '  )

ip = $$( cd terraform && $(TERRAFORM)  output -json instance_ips | awk -F\" ' { print $$2 } '  )

help:
	@cat docs/help.txt

pyvenv:
	@python3 -m venv $(VENV) && .  $(VENV)/bin/activate && pip install -r requirements.txt -U pip setuptools

# get terraform version
terravers:
	@./sh/get_terraform_version.sh

# "shortcut" to next target
terrabin: bin/terraform

# download and "install" terraform
bin/terraform:
	@wget -q -O bin/terraform.zip $(TERRAURL) && cd bin && unzip -q terraform.zip && chmod +x terraform && rm terraform.zip

all: terrabin init apply_force

terraversion:
	@$(TERRAFORM) version

init:
	@cd terraform && $(TERRAFORM) init

plan:
	@cd terraform && $(TERRAFORM) plan

apply:
	@cd terraform && $(TERRAFORM) apply -input=false

apply_force:
	@cd terraform && $(TERRAFORM) apply -auto-approve -input=false

show:
	@cd terraform && $(TERRAFORM) show

destroy:
	@cd terraform && $(TERRAFORM) destroy

refresh:
	@cd terraform && $(TERRAFORM) refresh


$(KEYS):
	@ssh-keygen -t rsa -b 2048 -f $(KEYS) -N ""

keys: $(KEYS)

output:
	@cd terraform && $(TERRAFORM) output instance_ips

spot_status:
	@echo $(SPOT_STATUS)
