curl --request PUT -d '{"secret_shares": 1,"secret_threshold": 1}' -vs http://$(kubectl get svc | grep vault | awk '{print $3}'):8200/v1/sys/init | jq -r '.' > ./init.json

for ip in `kubectl get pods -o wide  | grep vault | awk '{print $6}'`
do	
item=$(cat ./init.json | jq -r '.keys_base64[]')
curl --request PUT --data '{"key":"'$item'"}' -vs http://$ip:8200/v1/sys/unseal
done
root=$(cat ./init.json | jq -r '.root_token')
curl --header "X-Vault-Token:$root" --request POST --data ../@create.json http://$(kubectl get svc | grep vault | awk '{print $3}'):8200/v1/sys/mounts/my-mount
