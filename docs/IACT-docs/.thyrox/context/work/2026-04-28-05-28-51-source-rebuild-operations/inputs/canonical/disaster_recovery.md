---
title: Scripts de Disaster Recovery
date: 2025-11-13
domain: general
status: active
---

# Scripts de Disaster Recovery

Documentacion de scripts para backup, restore y testing de DR.

## Ubicacion

`/home/user/IACT---project/scripts/disaster_recovery/`

## Scripts de Backup

### backup_mysql.sh

**Proposito:** Realizar backup de base de datos MySQL.

**Uso:**
```bash
./scripts/disaster_recovery/backup_mysql.sh
```

**Que hace:**
1. Crea dump de MySQL con mysqldump
2. Comprime el backup (gzip)
3. Guarda en directorio de backups
4. Mantiene ultimos 7 backups (rotacion)

**Output:**
```
[INFO] MySQL Backup - Starting...
[INFO] Database: iact_production
[INFO] Host: mysql-server.local
[OK] Backup created: /backups/mysql_backup_20251107_103000.sql.gz
[INFO] Size: 450 MB
[INFO] Cleaning old backups (keeping last 7)...
[OK] Backup completed successfully
```

**Prerequisitos:**
```bash
# Variables de entorno
export DB_HOST=mysql-server.local
export DB_USER=backup_user
export DB_PASSWORD=backup_pass
export DB_NAME=iact_production
export BACKUP_DIR=/backups
```

---

### backup_cassandra.sh

**Proposito:** Realizar backup de Cassandra (logs).

**Uso:**
```bash
./scripts/disaster_recovery/backup_cassandra.sh
```

**Que hace:**
1. Crea snapshot de Cassandra
2. Exporta datos a archivos
3. Comprime backup
4. Limpia snapshots antiguos

**Output:**
```
[INFO] Cassandra Backup - Starting...
[INFO] Keyspace: iact_logs
[OK] Snapshot created: snapshot_20251107_103000
[OK] Backup created: /backups/cassandra_backup_20251107_103000.tar.gz
[INFO] Size: 2.1 GB
[OK] Backup completed successfully
```

---

## Scripts de Restore

### restore_mysql.sh

**Proposito:** Restaurar backup de MySQL.

**Uso:**
```bash
./scripts/disaster_recovery/restore_mysql.sh <backup_file>
```

**Ejemplo:**
```bash
./scripts/disaster_recovery/restore_mysql.sh /backups/mysql_backup_20251107_103000.sql.gz
```

**Que hace:**
1. Valida backup file
2. Descomprime backup
3. Detiene aplicacion (opcional)
4. Restaura base de datos
5. Reinicia aplicacion

**Output:**
```
[INFO] MySQL Restore - Starting...
[INFO] Backup file: /backups/mysql_backup_20251107_103000.sql.gz
[WARNING] This will OVERWRITE current database!
[PROMPT] Continue? (yes/no): yes
[INFO] Stopping application...
[OK] Application stopped
[INFO] Restoring database...
[OK] Database restored successfully
[INFO] Starting application...
[OK] Application started
[OK] Restore completed successfully
[INFO] Validation: Run ./scripts/health_check.sh
```

**CUIDADO:** Este script SOBRESCRIBE la base de datos actual. Usar solo en DR real.

---

### restore_cassandra.sh

**Proposito:** Restaurar backup de Cassandra.

**Uso:**
```bash
./scripts/disaster_recovery/restore_cassandra.sh <backup_file>
```

---

## Script de Testing

### test_dr.sh

**Proposito:** Probar procedimientos de disaster recovery sin afectar produccion.

**Uso:**
```bash
./scripts/disaster_recovery/test_dr.sh
```

**Que hace:**
1. Crea backup de prueba
2. Crea ambiente de test
3. Restaura backup en ambiente test
4. Valida que todo funcione
5. Limpia ambiente test

**Output:**
```
[INFO] DR Test - Starting...
[INFO] Phase 1: Create test backup
[OK] Test backup created
[INFO] Phase 2: Setup test environment
[OK] Test environment ready
[INFO] Phase 3: Restore to test environment
[OK] Restore successful
[INFO] Phase 4: Validation
[OK] Application responding
[OK] Database queries working
[OK] All validations passed
[INFO] Phase 5: Cleanup
[OK] Test environment cleaned
[OK] DR test completed successfully

RESULT: All DR procedures working correctly
```

**Ejecutar regularmente:** Mensual (minimo trimestral)

---

## Procedimiento de Disaster Recovery

### Escenario 1: Corrupcion de Base de Datos

```bash
# 1. Identificar ultimo backup valido
ls -lth /backups/mysql_backup_*.sql.gz | head -5

# 2. Detener aplicacion
sudo systemctl stop iact-backend

# 3. Restaurar backup
./scripts/disaster_recovery/restore_mysql.sh /backups/mysql_backup_20251107_080000.sql.gz

# 4. Validar restauracion
./scripts/health_check.sh staging

# 5. Reiniciar aplicacion
sudo systemctl start iact-backend

# 6. Smoke tests
./scripts/ci/smoke_tests.sh

# 7. Reportar incidente
# Crear issue en GitHub con label 'incident'
```

### Escenario 2: Perdida de Servidor Completo

```bash
# 1. Provisionar nuevo servidor
# (usar infrastructure as code)

# 2. Restaurar ultimo backup
./scripts/disaster_recovery/restore_mysql.sh <latest_backup>

# 3. Configurar aplicacion
# (usar scripts de deployment)

# 4. Smoke tests
./scripts/ci/smoke_tests.sh

# 5. Cambiar DNS para apuntar a nuevo servidor

# 6. Monitorear por 24h
```

---

## Automatizacion de Backups

### Cron Job

Agregar a crontab del servidor:

```crontab
# Backup MySQL diario a las 3 AM
0 3 * * * /home/user/IACT---project/scripts/disaster_recovery/backup_mysql.sh >> /var/log/mysql_backup.log 2>&1

# Backup Cassandra diario a las 4 AM
0 4 * * * /home/user/IACT---project/scripts/disaster_recovery/backup_cassandra.sh >> /var/log/cassandra_backup.log 2>&1

# Test DR mensual (primer domingo del mes a las 2 AM)
0 2 1-7 * 0 /home/user/IACT---project/scripts/disaster_recovery/test_dr.sh >> /var/log/dr_test.log 2>&1
```

Instalar con:
```bash
./scripts/cassandra/setup-cron-jobs.sh
```

---

## Almacenamiento de Backups

### Estrategia de Retencion

- **Diarios:** Ultimos 7 dias
- **Semanales:** Ultimas 4 semanas
- **Mensuales:** Ultimos 12 meses
- **Anuales:** Ultimos 3 anos

### Ubicaciones

1. **Local:** `/backups/` (servidor principal)
2. **Remote:** AWS S3 o equivalente
3. **Offsite:** Backup en datacenter diferente

### Validacion de Backups

```bash
# Validar integridad de backup
gzip -t /backups/mysql_backup_20251107_103000.sql.gz

# Verificar tamano razonable
du -h /backups/mysql_backup_20251107_103000.sql.gz
# Esperado: 400-500 MB

# Probar restauracion en ambiente test
./scripts/disaster_recovery/test_dr.sh
```

---

## RTO y RPO

**Recovery Time Objective (RTO):** 4 horas

- Tiempo maximo para restaurar servicio

**Recovery Point Objective (RPO):** 24 horas

- Maximo de datos que podemos perder
- Backups diarios: perdida maxima de 24h de datos

---

## Troubleshooting

### Backup falla por espacio

**Sintoma:** `No space left on device`

**Solucion:**
```bash
# Limpiar backups viejos
rm /backups/mysql_backup_$(date -d "30 days ago" +%Y%m%d)_*.sql.gz

# O mover a storage remoto
aws s3 sync /backups/ s3://iact-backups/
```

### Restore falla

**Sintoma:** `ERROR 1045: Access denied`

**Solucion:**
```bash
# Verificar credenciales
mysql -h $DB_HOST -u $DB_USER -p

# Verificar permisos del usuario
SHOW GRANTS FOR 'backup_user'@'%';
```

---

## Mejores Practicas

1. **Test DR regularmente:**
   - Minimo trimestral
   - Documentar resultados
   - Actualizar runbooks

2. **Verificar backups:**
   - Automatico: validar que backup se crea
   - Manual: test restore mensual

3. **Monitorear espacio:**
   - Alertas cuando disco > 80%
   - Rotacion automatica de backups

4. **Documentar procedimientos:**
   - Runbooks actualizados
   - Contactos de emergencia
   - Escalation path

5. **Acceso a backups:**
   - Multiple locations
   - Encryption at rest
   - Access control

---

**Mantenedores:** @devops-lead, @dba-lead
**RTO:** 4 horas
**RPO:** 24 horas
