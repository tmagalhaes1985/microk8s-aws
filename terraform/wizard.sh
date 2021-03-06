#!/bin/bash

BASE=`dirname $0`
DEFAULT_AMI_NAME_FILTER="flugel-microk8s-aws-*"
DEFAULT_AMI_OWNER_FILTER="self"
DEFAULT_INSTANCE_TYPE="t2.micro"
DEFAULT_SSH_PUBLIC_KEY_FILE=~/.ssh/id_rsa.pub
DEFAULT_SSH_PRIVATE_KEY_FILE=~/.ssh/id_rsa
DEFAULT_INTERNET_IP=`dig +short myip.opendns.com @resolver1.opendns.com`
DEFAULT_TAG_NAME="microk8s-aws"

ANSWER=""

function ask() {
    echo -n "$1 [$2]: "
    read
    if [ "$REPLY" == "" ]; then
        ANSWER=$2
    else
        ANSWER="$REPLY"
    fi
}

ask "AMI name filter" $DEFAULT_AMI_NAME_FILTER
AMI_NAME_FILTER=$ANSWER
ask "AMI owner filter" $DEFAULT_AMI_OWNER_FILTER
AMI_OWNER_FILTER=$ANSWER
ask "EC2 instance type" $DEFAULT_INSTANCE_TYPE
INSTANCE_TYPE=$ANSWER
ask "Tag Name" $DEFAULT_TAG_NAME
TAG_NAME=$ANSWER
ask "What is your internet IP address?" $DEFAULT_INTERNET_IP
INTERNET_IP=$ANSWER
ask "SSH public key file" $DEFAULT_SSH_PUBLIC_KEY_FILE
SSH_PUBLIC_KEY_FILE=$ANSWER
ask "SSH private key file" $DEFAULT_SSH_PRIVATE_KEY_FILE
SSH_PRIVATE_KEY_FILE=$ANSWER

cat <<EOF >terraform.auto.tfvars
ami_filter_name="$AMI_NAME_FILTER"
ami_filter_owner="$AMI_OWNER_FILTER"
instance_type="$INSTANCE_TYPE"
tag_name="$TAG_NAME"
allow_ssh_from_cidrs_0="$INTERNET_IP/32"
allow_kube_api_from_cidrs_0="$INTERNET_IP/32"
allow_ingress_from_cidrs_0="$INTERNET_IP/32"
key_pair="`cat $SSH_PUBLIC_KEY_FILE`"
EOF

cat <<EOF >.cmdsettings
export MICROK8S_AWS_PRIVATE_KEY_FILE="$SSH_PRIVATE_KEY_FILE"
EOF


cat <<EOF

To setup your cluster:

1) configure aws-cli
2) Install dependencies

./ctl.sh deps

3) Run

./ctl.sh up

EOF


