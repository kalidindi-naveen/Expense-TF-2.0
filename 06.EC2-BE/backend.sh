#!/bin/bash
SERVER=$1
ENVIRONMENT=$2
dnf install ansible -y
ansible-pull -i localhost, -U https://github.com/kalidindi-naveen/Expense-Ansible-Roles-Pull.git main.yml -e SERVER=$1 -e ENVIRONMENT=$2