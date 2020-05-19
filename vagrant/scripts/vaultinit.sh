PRIVATE_IP=$(awk -F= '/PRIVATE_IP/ {print $2}' /etc/environment)
curl --request  PUT -d '{"secret_shares": 3,"secret_threshold": 2}' -vs http://${PRIVATE_IP}:8200/v1/sys/init | jq -r '.' > ~/init.json
for item in `cat ~/init.json | jq -r '.keys_base64[]'`
do
echo $item
curl --request PUT --data '{"key":"'$item'"}' -vs http://${PRIVATE_IP}:8200/v1/sys/unseal
done

echo "Login vault http://${PRIVATE_IP}:8200 with token  $(cat ~/init.json | jq -r '.root_token')"
