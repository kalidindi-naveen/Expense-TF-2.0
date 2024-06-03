#!/bin/bash

# Install Terraform Not Required if VPN Configured in Local
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform

# Install AWS CLI
dnf install python3-pip
pip3 install awscli --upgrade --user
# pip3 uninstall awscli

# Install Mysql
dnf install mysql -y
