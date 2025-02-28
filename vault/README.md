# Configurando uma chave de criptografia

## Criar o vault

```console
vault secrets enable -path /mariadb -version=2 kv
```

## Adicionar a chave

```console
vault kv put /mariadb/1 data=VALOR
```

## Recuperar chave

```console
vault kv get mariadb/1
```

## Criar policy

```console
path "mariadb/*" {
  capabilities = ["read"]
}
```

## Criar token

```console
vault token create -policy=my-policy -policy=other-policy
```
