# IACT-db — Referencia de Comandos

Referencia completa de todos los comandos disponibles.

## Scripts principales

| Script | Requiere root | Descripción |
|---|---|---|
| `sudo bash bootstrap.sh` | Sí | Instala y configura todo (MariaDB + PostgreSQL + Adminer) |
| `sudo bash bootstrap.sh --no-adminer` | Sí | Solo MariaDB y PostgreSQL |
| `sudo bash bootstrap.sh --seed` | Sí | Instala todo + siembra datos de prueba |
| `sudo bash setup.sh` | Sí | Solo configura BDs (sin instalar paquetes) |
| `bash verify.sh` | No | Verifica conectividad y estado completo |
| `sudo bash scripts/install-clients.sh` | Sí | Instala clientes mysql/psql |
| `sudo bash provisioners/mariadb/schema_seed.sh` | Sí | Crea y siembra tbl_temp_prueba_ivr |

## Verificación

```bash
# Estado completo (7 secciones, contadores OK/WARN/ERR)
bash verify.sh

# Verificar conexión Python a ambas BDs
cd test
pip install -r requirements.txt
python check_db_connections.py
```

## MariaDB

```bash
# Conexión root via socket (sin contraseña, requiere sudo)
sudo mysql

# Conexión root con contraseña
mysql -h 127.0.0.1 -u root -p'rootpass123'

# Conexión Django (READ-ONLY)
mysql -h 127.0.0.1 -u django_user -p'django_pass' ivr_legacy

# Estado del servicio
sudo systemctl status mariadb
# o en entornos sin systemd:
sudo service mariadb status

# Arrancar / detener
sudo systemctl start mariadb
sudo systemctl stop  mariadb

# Importar / exportar
mysql  -h 127.0.0.1 -u root -p'rootpass123' ivr_legacy < backup.sql
mysqldump -h 127.0.0.1 -u root -p'rootpass123' ivr_legacy > backup.sql
```

## PostgreSQL

```bash
# Conexión superusuario via peer auth
sudo -u postgres psql

# Conexión Django
PGPASSWORD='django_pass' psql -h 127.0.0.1 -U django_user -d iact_analytics

# Estado del cluster
sudo pg_ctlcluster 16 main status
# o:
sudo systemctl status postgresql

# Arrancar / detener
sudo pg_ctlcluster 16 main start
sudo pg_ctlcluster 16 main stop

# Importar / exportar
psql    -h 127.0.0.1 -U postgres -d iact_analytics -f backup.sql
pg_dump -h 127.0.0.1 -U postgres    iact_analytics > backup.sql
```

## Provisioners individuales

```bash
# Solo instalar MariaDB (sin configurar BD ni usuario)
sudo bash provisioners/mariadb/install.sh

# Solo configurar BD/usuario en MariaDB (MariaDB ya instalado)
sudo bash provisioners/mariadb/setup.sh

# Solo instalar PostgreSQL
sudo bash provisioners/postgres/install.sh

# Solo configurar BD/usuario en PostgreSQL
sudo bash provisioners/postgres/setup.sh

# Solo Adminer
sudo bash provisioners/adminer/bootstrap.sh
```

## Logs

```bash
# Ver todos los logs generados
ls logs/

# Seguir el último bootstrap
tail -f logs/mariadb_bootstrap.log
tail -f logs/postgres_bootstrap.log

# Buscar errores
grep -i "error\|fatal" logs/*.log
```

## Configuración (.env)

```bash
# Ver configuración activa
cat .env

# Editar
nano .env    # o vim .env

# Variables principales de BD:
# MARIADB_HOST, MARIADB_PORT
# DB_MARIADB_NAME, DB_MARIADB_USER, DB_MARIADB_PASSWORD
# POSTGRES_HOST, POSTGRES_PORT
# DB_POSTGRES_NAME, DB_POSTGRES_USER, DB_POSTGRES_PASSWORD
# SEED_ROWS (registros a sembrar en tbl_temp_prueba_ivr)
```

---

**Última actualización**: 2026-05-05 — Migración Vagrant → shell scripts puros
