read -p "Digite o token cppgi: " token
if [ -z "$token" ]; then
    echo "Token não pode ser vazio"
    exit 1
fi

wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt-get -y install vault

sudo apt-get install -y gocryptfs

mkdir mariadb.vault
cd mariadb.vault
git clone https://github.com/rafaelperazzo/mariadb.vault.git

cd mariadb.vault

./init.sh

vault login $token

./vault.exec.sh

echo "VAULT_TOKEN=$token" > plain/.env

docker compose --env-file plain/.env build

docker compose --env-file plain/.env -f docker-compose-inicial.yml up -d

docker compose --env-file plain/.env down

docker compose --env-file plain/.env up -d

docker compose --env-file plain/.env logs

