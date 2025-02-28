cat ../vault/share/token_ro

read -p "Digite o token cppgi: " token
if [ -z "$token" ]; then
    echo "Token não pode ser vazio"
    exit 1
fi

sudo apt-get install -y gocryptfs

cd ~
cd mariadb.vault

./init.sh
#Mude o endereço abaixo em caso de uso de outro servidor hashicorp vault
export VAULT_ADDR=http://127.0.0.1:8200
vault login $token

./vault.exec.sh

echo "VAULT_TOKEN=$token" > plain/.env

docker compose --env-file plain/.env build

docker compose --env-file plain/.env -f docker-compose-inicial.yml up -d

docker compose --env-file plain/.env down

docker compose --env-file plain/.env up -d

docker compose --env-file plain/.env logs

