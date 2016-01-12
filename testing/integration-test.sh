#!/usr/bin/env bash

## This integration test assumes that ./terraform.yml and ./terraform.tf are already in place

export EXIT_CODE=0 # passing until proven failed
RETRY_ATTEMPTS=3

# this section needs to make fewer assumptions of the build env
# it currently makes an assumption that the build is in a docker container

function retry_command() {
	for i in `seq 1 $RETRY_ATTEMPTS`
	do
		echo -e "CMD: $1\tTRY: $i"
		eval $1
		RETRY=$?
		if [ $RETRY -eq 0 ]
		then
			break
		fi
	done
	if [ $RETRY -ne 0 ]
	then
		EXIT_CODE=1
	fi
}

ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa && eval `ssh-agent -s` && ssh-add ~/.ssh/id_rsa
./security-setup

terraform get
retry_command "terraform apply -state=$TERRAFORM_STATE_ROOT/terraform.tfstate -var 'build_number=$CI_BUILD_NUMBER'"

ansible_commands="ansible-playbook playbooks/wait-for-hosts.yml --private-key ~/.ssh/id_rsa"
ansible_commands+=" && ansible-playbook terraform.yml --extra-vars=@security.yml --private-key ~/.ssh/id_rsa"
retry_command "$ansible_commands"

control_hosts=$(plugins/inventory/terraform.py --hostfile | awk '/control/ {print $1}')

testing/health-checks.py $control_hosts || EXIT_CODE=1

retry_command "terraform destroy -force -state=$TERRAFORM_STATE_ROOT/terraform.tfstate -var 'build_number=$CI_BUILD_NUMBER'"

rm security.yml terraform.tf terraform.yml

exit $EXIT_CODE
