# MariaDB com tabelas encriptadas e chaves armazenadas em servidor hashicorp vault

## Pré-requisitos

- Um servidor vault configurado (hashicorp vault);
- Token root do servidor vault (para criação dos segredos)
- Vault criado no servidor (o nome do vault utilizado neste exemplo é **cppgi**)
  - SEGREDOS
    - MYSQL_PASSWORD
    - MYSQL_ROOT_PASSWORD
    - 1
    - 2
- Token para acesso somente leitura para o vault **cppgi/\***

> [!WARNING]  
> Os próximos passos só funcionam quando o servidor hashicorp vault estiver funcionando corretamente

## Preparação

### Instalando um cliente vault (ubuntu)

```console
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vault
```

Para outras distribuições consulte o [LINK](https://www.markdownguide.org/basic-syntax/)

### Configuração dos segredos no servidor vault

### Instalar o goCryptfs

```console
sudo apt-get install -y gocryptfs
```

### Clone o repositório

```console
mkdir mariadb.vault
cd mariadb.vault
git clone https://github.com/rafaelperazzo/mariadb.vault.git
```

### Inicialize a pasta criptografada

```console
./init.sh
```

### Faça o login no vault

```console
vault login
```

### Exporte os segredos do servidor para um arquivo .env em pasta criptografada

```console
./vault.exec
```

Os segredos serão escritos na pasta criptografada *plain/.env*

Neste momento, temos 4 segredos
    - 2 chaves de criptografia: Para utilização na criptografia das tabelas do MariaDB
    - MYSQL_ROOT_PASSORD: Para senha inicial do usuário root no MariaDB
    - MYSQL_PASSWORD: Para senha de usuário comum no MariaDB

Outros segredos podem ser adicionados e utilizados conforme a aplicação, basta editar o arquivo cppgi.exec.

### Adicione o token (somente leitura) no arquivo plain/.env

Coloque a variável de ambiente:

```console
VAULT_TOKEN=SEU_TOKEN_SOMENTE_LEITURA
```

## Iniciando o MariaDB

### Build da imagem docker

```console
docker compose --env-file plain/.env build
```

### Inciar o container sem criptografia (configuração inicial)

```console
docker compose --env-file plain/.env -f docker-compose-inicial.yml up -d
```

### Parar o container

```console
docker compose --env-file plain/.env down
```

### Iniciar novamente o container

```console
docker compose --env-file plain/.env up -d
```

### Verificar logs para conferir se o MariaDB iniciou corretamente

```console
docker compose --env-file plain/.env logs
```

