wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vault

mkdir -p {file,logs,certs,share}
# Exec into the vault container
docker network create web
docker compose down
docker compose up -d
#docker exec -it vault /bin/sh

docker compose exec -T vault sh -c "vault operator init > /share/init.file"
#vault operator init > /share/init.file
export VAULT_ADDR=http://127.0.0.1:8200
echo "export VAULT_ADDR=http://127.0.0.1:8200" >> ~/.bashrc 
cat share/init.file
read -p "Digite a primeira chave de unseal: " seal1
read -p "Digite a segunda chave de unseal: " seal2
read -p "Digite a terceira chave de unseal: " seal3
read -p "Digite o token root: " token
vault operator unseal $seal1
vault operator unseal $seal2
vault operator unseal $seal3
vault login $token
vault secrets enable -path /cppgi -version=2 kv
vault kv put /cppgi/1 data=$(openssl rand -hex 32)
vault kv put /cppgi/2 data=$(openssl rand -hex 32)
vault policy write cppgi_read ./policy/cppgi_read.hcl
vault token create -policy=cppgi_read > share/token_ro
cat share/token_ro
read -p "Digite o token somente leitura: " token
vault login $token

