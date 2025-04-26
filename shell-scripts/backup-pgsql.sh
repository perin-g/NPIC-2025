#!/bin/bash

# Configurações
DATA_ATUAL=$(date +"%Y%m%d_%H%M")
BACKUP_DIR="/backups/postgres"
BANCO="nome_do_banco"
USUARIO="usuario_postgres"
SENHA="senha_postgres"
RETENCAO_DIAS=7

# Exporta a senha para o pg_dump usar sem prompt
export PGPASSWORD=$SENHA

# Cria o diretório de backup se não existir
mkdir -p $BACKUP_DIR

# Realiza o backup
pg_dump -U $USUARIO -F c -b -v -f "$BACKUP_DIR/${BANCO}_backup_$DATA_ATUAL.dump" $BANCO

# Verifica se o backup foi criado com sucesso
if [ $? -eq 0 ]; then
    echo "Backup realizado com sucesso em $BACKUP_DIR/${BANCO}_backup_$DATA_ATUAL.dump"
else
    echo "Erro ao realizar backup do banco $BANCO"
    exit 1
fi

# Remove backups mais antigos que X dias
find $BACKUP_DIR -name "${BANCO}_backup_*.dump" -type f -mtime +$RETENCAO_DIAS -exec rm -f {} \;

# Remove variável de senha da sessão
unset PGPASSWORD
