mkdir {cipher,plain}
echo "ESCOLHA UMA SENHA PARA A PASTA CRIPTOGRAFADA"
echo "*********************************************"
gocryptfs -init cipher
echo "ENTRE COM A SENHA PARA MONTAR A PASTA CRIPTOGRAFADA"
echo "*********************************************"
gocryptfs cipher plain
touch plain/.env
cp conf/encryption.cnf.sample conf/encryption.cnf
rm conf/*.sample
