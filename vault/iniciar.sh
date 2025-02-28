mkdir {file,logs,certs,share}
# Exec into the vault container
docker compose up -d
#docker exec -it vault /bin/sh

docker compose exec -T vault sh -c "vault operator init > /share/init.file"
#vault operator init > /share/init.file
export VAULT_ADDR=http://127.0.0.1:8200
cat share/init.file
read -p "Digite o token root" token
vault login $token
vault secrets enable -path /cppgi -version=2 kv
vault kv put /cppgi/1 data=$(openssl rand -hex 32)
vault kv put /cppgi/2 data=$(openssl rand -hex 32)
vault policy write ./policy/cppgi_read.hcl
vault token create -policy=cppgi_read > share/token_ro
cat share/token_ro
read -p "Digite o token somente leitura" token
vault login $token

