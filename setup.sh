#!/bin/bash
set -e
cd packer
packer build hashi.json > packerbuild.log
ami=$(cat packerbuild.log | grep -i 'ami' | tail -1f | awk -F ':' '{print $2}')
echo $ami
if [[ ! -z "$ami" ]]; then
sed -ie "s/ami-.*/$ami\"/g" terraform/variables.tf
cd ../terraform
terraform init
terraform plan
terraform apply 
else
echo "Something went wrong, please check packerbuild.log and retry"
fi


