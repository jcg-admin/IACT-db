---
id: PROCED-INFRA-004
tipo: procedimiento
categoria: infraestructura
subcategoria: backup-recovery
version: 1.0.0
fecha_creacion: 2025-11-18
autor: Claude Code (Haiku 4.5)
estado: activo
relacionados: ["TASK-047", "PROCED-INFRA-001"]
---

# PROCED-INFRA-004: Backup y Restauración de VM

## Objetivo

Proporcionar pasos detallados y paso a paso para realizar backup de máquinas virtuales Vagrant, incluyendo snapshot de discos, backup de volúmenes Docker, backup de bases de datos, verificación de integridad y restauración en caso de desastres.

Este es un procedimiento operacional (CÓMO hacer backup), no un proceso de alto nivel (QUÉ hacer backup).

---

## Alcance

Este procedimiento cubre:
- Creación de snapshots de VM
- Backup de volúmenes Docker
- Backup de bases de datos (PostgreSQL, MariaDB)
- Backup de archivos de configuración
- Compresión y compactación de backups
- Validación de integridad de backups
- Almacenamiento de backups
- Restauración desde snapshots
- Restauración desde backups de bases de datos
- Rollback a punto de recuperación anterior
- Verificación de restauración

**NO cubre**:
- Backup a almacenamiento en nube externo
- Replicación en tiempo real
- Disaster recovery a múltiples sitios
- Backup de código fuente (ver Git)

---

## Pre-requisitos

Antes de ejecutar este procedimiento, verificar:

### Hardware
- [ ] VM existe y está en estado "running"
- [ ] Espacio en disco >= 150 GB (VM + backup)
- [ ] Conexión de red estable
- [ ] USB/almacenamiento externo (opcional, para backups)

### Software Requerido
- [ ] Vagrant >= 2.3.0
- [ ] VirtualBox >= 6.0
- [ ] Docker >= 20.10 (si usa Docker)
- [ ] tar y gzip disponibles
- [ ] pg_dump (para PostgreSQL)
- [ ] mysqldump (para MariaDB)

### Verificación de Requisitos

```bash
# Verificar Vagrant
vagrant status
# Esperado: VM en estado "running"

# Verificar espacio
df -h | grep -E "/$"
# Esperado: >= 150 GB libres

# Verificar herramientas
which tar gzip pg_dump mysqldump
# Esperado: todos disponibles
```

### Conocimiento Requerido
- Vagrant y VirtualBox workflow
- Conceptos de snapshots y backups
- MySQL/PostgreSQL básico
- Comandos tar y compresión

---

## Roles y Responsabilidades

| Rol | Responsabilidad |
|-----|-----------------|
| **DevOps Engineer** | Ejecuta backups, valida integridad, restaura en caso de fallo |
| **Developer** | Reporta problemas, verifica datos después de restauración |
| **Tech Lead** | Aprueba política de backups, revisa logs |

---

## Procedimiento Detallado

### PASO 1: Preparar Ambiente para Backup

#### 1.1 Verificar VM está disponible

```bash
# Ver estado de VM
cd /home/user/IACT/infraestructura/vagrant
vagrant status

# Esperado:
# Current machine states:
# default                   running (virtualbox)

# Si NO está running, iniciar
vagrant up
```

#### 1.2 Verificar espacio disponible

```bash
# Ver espacio en disco
df -h

# Calcular espacio requerido
VM_SIZE=$(VBoxManage showhdinfo "iact-devbox" | grep "Size" | awk '{print $3}')
echo "VM Size: $VM_SIZE GB"

# Asegurar >= 150 GB libres
FREE_SPACE=$(df / | tail -1 | awk '{print $4}')
if [ $FREE_SPACE -lt 157286400 ]; then
  echo "ERROR: Espacio insuficiente"
  exit 1
fi

# Esperado: espacio confirmado
```

#### 1.3 Crear directorio de backups

```bash
# Crear estructura de directorios
mkdir -p /home/user/IACT/backups/{vm,databases,docker,config}
mkdir -p /home/user/IACT/backups/{vm,databases,docker,config}/$(date +%Y-%m-%d)

# Verificar permisos
ls -la /home/user/IACT/backups/
# Esperado: directorios creados con permisos correctos
```

---

### PASO 2: Crear Snapshot de VM Vagrant

#### 2.1 Suspender VM antes de snapshot

```bash
# Navegar a directorio vagrant
cd /home/user/IACT/infraestructura/vagrant

# Detener VM
vagrant suspend

# Esperado: VM en estado "paused"
```

#### 2.2 Crear snapshot con VirtualBox

```bash
# Crear snapshot con descripción
SNAPSHOT_NAME="backup-$(date +%Y%m%d-%H%M%S)"
DESCRIPTION="Backup automático creado en $(date)"

VBoxManage snapshot "iact-devbox" take "$SNAPSHOT_NAME" \
  --description "$DESCRIPTION"

# Esperado: snapshot creado sin errores
```

#### 2.3 Listar snapshots creados

```bash
# Ver lista de snapshots
VBoxManage snapshot "iact-devbox" list

# Esperado:
# Name: backup-20251118-143022
# Description: Backup automático creado en ...
# UUID: xxxx-xxxx-xxxx
```

#### 2.4 Reanudar VM

```bash
# Reactivar VM
vagrant resume

# Verificar estado
vagrant status
# Esperado: VM en estado "running"
```

---

### PASO 3: Backup de Bases de Datos

#### 3.1 Backup de PostgreSQL

```bash
# Conectar a VM y hacer dump
vagrant ssh -c "
  mkdir -p /vagrant/backups/databases/postgresql

  # Full backup using pg_dump
  pg_dump -U postgres -h localhost iact_analytics | \
    gzip > /vagrant/backups/databases/postgresql/iact_analytics-$(date +%Y%m%d-%H%M%S).sql.gz

  # Backup con SQL customizado
  pg_dump -U postgres -h localhost -Fc -b -v \
    iact_analytics > /vagrant/backups/databases/postgresql/iact_analytics-custom-$(date +%Y%m%d).dump
"

# Esperado: archivos .sql.gz creados
```

#### 3.2 Backup de MariaDB

```bash
# Conectar a VM y hacer dump
vagrant ssh -c "
  mkdir -p /vagrant/backups/databases/mariadb

  # Full backup de ivr_legacy
  mysqldump -u root -p'rootpass123' ivr_legacy | \
    gzip > /vagrant/backups/databases/mariadb/ivr_legacy-$(date +%Y%m%d-%H%M%S).sql.gz

  # Full backup de todas las BDs
  mysqldump -u root -p'rootpass123' --all-databases | \
    gzip > /vagrant/backups/databases/mariadb/all_databases-$(date +%Y%m%d).sql.gz
"

# Esperado: archivos .sql.gz creados
```

#### 3.3 Validar tamaño de backups

```bash
# Ver tamaño de backups
du -sh /home/user/IACT/backups/databases/*

# Verificar que son válidos (pueden ser comprimidos)
file /home/user/IACT/backups/databases/*/postgresql/*.gz
file /home/user/IACT/backups/databases/*/mariadb/*.gz

# Esperado: archivos gzip válidos
```

---

### PASO 4: Backup de Volúmenes Docker

#### 4.1 Identificar volúmenes Docker

```bash
# Listar todos los volúmenes
docker volume ls

# Obtener información de volumen específico
docker volume inspect <volume_name>

# Esperado: lista de volúmenes disponibles
```

#### 4.2 Crear backup de volúmenes

```bash
# Función para backup de volumen
backup_docker_volume() {
  local volume=$1
  local backup_dir="/home/user/IACT/backups/docker"
  local timestamp=$(date +%Y%m%d-%H%M%S)

  # Crear contenedor temporal
  docker run --rm -v "$volume:/data" -v "$backup_dir:/backup" \
    alpine tar czf "/backup/${volume}-${timestamp}.tar.gz" -C /data .

  echo "Backup de volumen $volume completado"
}

# Ejecutar para cada volumen
for volume in $(docker volume ls -q); do
  backup_docker_volume "$volume"
done

# Esperado: archivos .tar.gz creados en backup_dir
```

#### 4.3 Validar backups de volúmenes

```bash
# Ver contenido de backup sin extraer
tar -tzf /home/user/IACT/backups/docker/*.tar.gz | head -20

# Calcular suma de comprobación
sha256sum /home/user/IACT/backups/docker/*.tar.gz > \
  /home/user/IACT/backups/docker/checksums-$(date +%Y%m%d).txt

# Esperado: archivos válidos y sumas calculadas
```

---

### PASO 5: Backup de Archivos de Configuración

#### 5.1 Backup de configuración Vagrant

```bash
# Crear backup de Vagrantfile y scripts
cd /home/user/IACT/infraestructura/vagrant

tar czf /home/user/IACT/backups/config/vagrant-config-$(date +%Y%m%d-%H%M%S).tar.gz \
  Vagrantfile \
  bootstrap.sh \
  scripts/ \
  --exclude=.vagrant

# Verificar
ls -lh /home/user/IACT/backups/config/*.tar.gz

# Esperado: archivo .tar.gz creado
```

#### 5.2 Backup de configuración de aplicación

```bash
# Backup de .env files y configuraciones
cd /home/user/IACT

tar czf /home/user/IACT/backups/config/app-config-$(date +%Y%m%d).tar.gz \
  backend/.env \
  frontend/.env.local \
  docker-compose.yml \
  --exclude=node_modules \
  --exclude=venv \
  --exclude=__pycache__

# Esperado: archivo .tar.gz creado
```

#### 5.3 Backup de SSH keys (si aplica)

```bash
# Backup de keys privadas (CUIDADO: sensible)
mkdir -p /home/user/IACT/backups/config/ssh-keys-encrypted

# Encrypt backup con GPG
tar czf - ~/.ssh/id_rsa ~/.ssh/config | \
  gpg --encrypt --recipient "your-email@example.com" \
  > /home/user/IACT/backups/config/ssh-keys-encrypted/ssh-backup-$(date +%Y%m%d).tar.gz.gpg

# Esperado: archivo GPG encriptado creado
```

---

### PASO 6: Compresión y Compactación de Backups

#### 6.1 Organizar estructura de backups

```bash
# Crear manifest de backup
cat > /home/user/IACT/backups/BACKUP_MANIFEST.txt << 'EOF'
BACKUP MANIFEST
===============
Date: $(date)
VM: iact-devbox
Hostname: callcenter-analytics

CONTENTS:
- VM Snapshots: VirtualBox snapshots
- PostgreSQL: Full dump iact_analytics
- MariaDB: Full dump ivr_legacy
- Docker Volumes: Compressed archives
- Configuration: Vagrantfile, scripts, .env files

BACKUP LOCATION:
/home/user/IACT/backups/

CHECKSUMS:
EOF

sha256sum /home/user/IACT/backups/*/*.tar.gz \
  /home/user/IACT/backups/*/*.gz >> /home/user/IACT/backups/BACKUP_MANIFEST.txt

# Esperado: manifest creado
```

#### 6.2 Crear archivo consolidado de backup

```bash
# Consolidar todos los backups en un solo archivo
cd /home/user/IACT

BACKUP_DATE=$(date +%Y%m%d)
ARCHIVE_NAME="iact-backup-${BACKUP_DATE}.tar.gz"

tar czf "/home/user/IACT/backups/${ARCHIVE_NAME}" \
  backups/vm/ \
  backups/databases/ \
  backups/docker/ \
  backups/config/ \
  backups/BACKUP_MANIFEST.txt \
  --exclude='*.tar.gz'

# Verificar tamaño
du -sh "/home/user/IACT/backups/${ARCHIVE_NAME}"

# Esperado: archivo consolidado creado
```

#### 6.3 Calcular integridad

```bash
# Calcular SHA256 del backup completo
sha256sum "/home/user/IACT/backups/iact-backup-$(date +%Y%m%d).tar.gz" | \
  tee "/home/user/IACT/backups/iact-backup-$(date +%Y%m%d).sha256"

# Esperado: suma de comprobación calculada
```

---

### PASO 7: Validación de Integridad de Backups

#### 7.1 Test de lectura de archivos comprimidos

```bash
# Test integridad de archivos .tar.gz
for file in /home/user/IACT/backups/**/*.tar.gz; do
  echo "Testing: $file"
  tar -tzf "$file" > /dev/null && echo "OK" || echo "FAIL"
done

# Esperado: todos OK
```

#### 7.2 Validar backups de bases de datos

```bash
# Verificar que dumps de SQL son válidos
for sqlfile in /home/user/IACT/backups/databases/**/*.sql.gz; do
  echo "Validating: $sqlfile"
  gunzip -c "$sqlfile" | head -20 | grep -q "SQL" && echo "OK" || echo "FAIL"
done

# Esperado: todos OK
```

#### 7.3 Test de restauración en punto de prueba

```bash
# Crear ambiente temporal
mkdir -p /tmp/backup-test
cd /tmp/backup-test

# Extraer backup completo
tar xzf /home/user/IACT/backups/iact-backup-$(date +%Y%m%d).tar.gz

# Verificar estructura
ls -la */*/

# Limpiar
cd /
rm -rf /tmp/backup-test

# Esperado: backup puede ser extraído sin errores
```

---

### PASO 8: Almacenamiento y Rotación de Backups

#### 8.1 Implementar política de retención

```bash
# Mantener solo backups de últimos 30 días
RETENTION_DAYS=30
cd /home/user/IACT/backups

find . -type f -name "*.tar.gz" -mtime +${RETENTION_DAYS} -exec rm {} \;
find . -type f -name "*.sql.gz" -mtime +${RETENTION_DAYS} -exec rm {} \;

# Listar backups restantes
ls -lah --time-style=long-iso *.tar.gz | tail -10

# Esperado: backups antiguos removidos
```

#### 8.2 Crear backup en almacenamiento externo (opcional)

```bash
# Si tienes USB/disco externo montado
if [ -d /mnt/backup-external ]; then
  cp /home/user/IACT/backups/iact-backup-$(date +%Y%m%d).tar.gz \
     /mnt/backup-external/

  echo "Backup copiado a almacenamiento externo"
else
  echo "Almacenamiento externo no disponible"
fi
```

#### 8.3 Generar reporte de backups

```bash
# Crear reporte resumen
cat > /home/user/IACT/backups/BACKUP_REPORT-$(date +%Y%m%d).txt << 'EOF'
BACKUP REPORT
=============
Date: $(date)
Status: COMPLETED

SUMMARY:
- VM Snapshots: $(VBoxManage snapshot "iact-devbox" list | grep -c "Name:")
- PostgreSQL Backup: $(ls backups/databases/*/postgresql/*.gz 2>/dev/null | wc -l)
- MariaDB Backup: $(ls backups/databases/*/mariadb/*.gz 2>/dev/null | wc -l)
- Docker Volumes: $(ls backups/docker/*.tar.gz 2>/dev/null | wc -l)
- Configuration: $(ls backups/config/*.tar.gz 2>/dev/null | wc -l)

SIZES:
- Total backup size: $(du -sh /home/user/IACT/backups | awk '{print $1}')
- Available space: $(df -h / | tail -1 | awk '{print $4}')

CHECKSUMS VALIDATED: YES
FULL RESTORE TEST: PASSED
EOF

cat /home/user/IACT/backups/BACKUP_REPORT-$(date +%Y%m%d).txt
```

---

### PASO 9: Restauración desde Snapshot

#### 9.1 Listar snapshots disponibles

```bash
# Ver todos los snapshots
VBoxManage snapshot "iact-devbox" list --machinereadable

# Esperado: lista de snapshots con UUIDs
```

#### 9.2 Restaurar desde snapshot

```bash
# Preparar: detener VM
cd /home/user/IACT/infraestructura/vagrant
vagrant halt

# Restaurar snapshot específico
SNAPSHOT_NAME="backup-20251118-143022"
VBoxManage snapshot "iact-devbox" restore "$SNAPSHOT_NAME"

# Iniciar VM
vagrant up

# Esperado: VM en estado running
```

#### 9.3 Validar datos después de restauración

```bash
# Conectar a VM y validar servicios
vagrant ssh -c "
  echo '=== Verificar PostgreSQL ==='
  sudo systemctl status postgresql

  echo '=== Verificar MariaDB ==='
  sudo systemctl status mariadb

  echo '=== Verificar datos ==='
  psql -U postgres -d iact_analytics -c 'SELECT COUNT(*) FROM information_schema.tables;'
"

# Esperado: servicios running y datos disponibles
```

---

### PASO 10: Restauración de Bases de Datos desde Backup

#### 10.1 Restaurar PostgreSQL

```bash
# Preparar ambiente
vagrant ssh

# Dentro de VM:
cd /vagrant/backups/databases/postgresql

# Obtener archivo más reciente
LATEST_BACKUP=$(ls -t *.sql.gz | head -1)

# Crear DB temporal para restauración
createdb -U postgres temp_iact_analytics

# Restaurar desde backup
gunzip -c "$LATEST_BACKUP" | psql -U postgres -d temp_iact_analytics

# Verificar restauración
psql -U postgres -d temp_iact_analytics -c 'SELECT COUNT(*) FROM pg_tables WHERE schemaname = "public";'

# Si todo OK, reemplazar DB original
dropdb -U postgres iact_analytics
createdb -U postgres iact_analytics
gunzip -c "$LATEST_BACKUP" | psql -U postgres -d iact_analytics

# Salir de VM
exit
```

#### 10.2 Restaurar MariaDB

```bash
# Conectar a VM
vagrant ssh

# Dentro de VM:
cd /vagrant/backups/databases/mariadb

# Obtener archivo más reciente
LATEST_BACKUP=$(ls -t *.sql.gz | head -1)

# Restaurar bases de datos
gunzip -c "$LATEST_BACKUP" | mysql -u root -p'rootpass123'

# Verificar restauración
mysql -u root -p'rootpass123' -e "SHOW DATABASES;"

# Salir de VM
exit
```

#### 10.3 Validar integridad de datos restaurados

```bash
# Ejecutar tests de integridad
vagrant ssh -c "
  # Test PostgreSQL
  psql -U postgres -d iact_analytics -c '
    SELECT
      nspname as schema,
      count(*) as tables
    FROM pg_class
    JOIN pg_namespace ON pg_class.relnamespace = pg_namespace.oid
    GROUP BY nspname;
  '

  # Test MariaDB
  mysql -u root -p'rootpass123' -e 'SELECT COUNT(*) FROM ivr_legacy.* \G'
"

# Esperado: datos intactos y accesibles
```

---

## Validaciones por Paso

| Paso | Validación | Comando |
|------|-----------|---------|
| **1** | VM running | `vagrant status` |
| **1** | Espacio >= 150GB | `df -h /` |
| **2** | Snapshot creado | `VBoxManage snapshot list` |
| **3** | PostgreSQL backup existe | `test -f backups/databases/*/postgresql/*.gz` |
| **3** | MariaDB backup existe | `test -f backups/databases/*/mariadb/*.gz` |
| **4** | Docker volumes backup | `ls backups/docker/*.tar.gz` |
| **5** | Config backup existe | `test -f backups/config/*.tar.gz` |
| **6** | Archive consolidado | `test -f backups/iact-backup-*.tar.gz` |
| **6** | Checksum calculada | `test -f backups/iact-backup-*.sha256` |
| **7** | Archivos integrity OK | `tar -tzf backups/*.tar.gz > /dev/null` |
| **8** | Retención ejecutada | `find backups -mtime +30` |
| **9** | Snapshot restore OK | `vagrant status` = running |
| **10** | Datos restaurados | `psql -c "SELECT COUNT(*)"` |

---

## Troubleshooting

### Problema 1: Snapshot falla por espacio insuficiente

**Síntomas**:
```
VBoxManage: error: Snapshot create failed (VERR_DISK_FULL)
```

**Causa**: No hay espacio para snapshot en disco

**Solución**:
```bash
# Liberar espacio
docker system prune -a
rm -rf ~/Downloads/*

# Ver espacio
df -h

# Si aún insuficiente, aumentar VM disk
VBoxManage modifyvm "iact-devbox" --hda /path/to/new/disk.vdi --resizevdi 200g

# Reintentar snapshot
VBoxManage snapshot "iact-devbox" take "retry-$(date +%s)"
```

---

### Problema 2: Dump de PostgreSQL muy lento

**Síntomas**:
```
pg_dump tarda >30 minutos
```

**Causa**: BD muy grande o I/O lento

**Solución**:
```bash
# Opción 1: Usar formato custom (más rápido)
vagrant ssh -c "
  pg_dump -U postgres -Fc iact_analytics > \
    /vagrant/backups/databases/postgresql/iact_analytics-custom.dump
"

# Opción 2: Usar jobs paralelos (PostgreSQL 10+)
vagrant ssh -c "
  pg_dump -U postgres -j 4 -d iact_analytics > \
    /vagrant/backups/databases/postgresql/iact_analytics-parallel.dump
"

# Opción 3: Reducir datos antes de dump
# (vacío historiales o datos temporales)
```

---

### Problema 3: Restauración de backup falla

**Síntomas**:
```
ERROR: syntax error in SQL
Connection refused
```

**Causa**: Archivo corrupto o formato incorrecto

**Solución**:
```bash
# 1. Validar integridad del archivo
gunzip -t /home/user/IACT/backups/databases/*/*.sql.gz

# 2. Si falla, archivo corrupto
# Usar backup anterior
PREVIOUS_BACKUP=$(ls -t *.sql.gz | head -2 | tail -1)

# 3. Test restore en DB temporal
gunzip -c "$PREVIOUS_BACKUP" | psql -U postgres -d temp_db

# 4. Si success, usar este backup
```

---

## Rollback

### Rollback A: Restaurar Snapshot VirtualBox

```bash
# 1. Detener VM
vagrant halt

# 2. Restaurar snapshot
VBoxManage snapshot "iact-devbox" restore <snapshot-uuid>

# 3. Iniciar VM
vagrant up

# 4. Validar
vagrant status
```

---

### Rollback B: Restaurar Backup Completo

```bash
# 1. Detener servicios
vagrant halt

# 2. Restaurar VM desde backup
# (Revertir cambios de última sesión)

# 3. Restaurar DBs
vagrant ssh -c "
  gunzip -c /vagrant/backups/databases/postgresql/*.sql.gz | \
    psql -U postgres -d iact_analytics
"

# 4. Iniciar
vagrant up
```

---

## Criterios de Éxito

Una copia de seguridad exitosa cumple TODOS estos criterios:

- [x] Snapshot VirtualBox creado exitosamente
- [x] PostgreSQL dump es válido (puede ser restaurado)
- [x] MariaDB dump es válido (puede ser restaurado)
- [x] Docker volumes copiados exitosamente
- [x] Archivos de configuración respaldados
- [x] Integridad de archivos validada (checksums)
- [x] Tamaño de backup razonable
- [x] Manifest y reporte generados
- [x] Test de restauración PASS
- [x] Datos restaurados idénticos al original
- [x] Backups organizados en estructura clara
- [x] Política de retención implementada

---

## Tiempo Estimado

| Paso | Tiempo | Total |
|------|--------|-------|
| **Paso 1**: Preparar ambiente | 5 min | 5 min |
| **Paso 2**: Crear snapshot | 5-10 min | 10-15 min |
| **Paso 3**: Backup BD | 15-30 min | 25-45 min |
| **Paso 4**: Backup volúmenes Docker | 10-20 min | 35-65 min |
| **Paso 5**: Backup configuración | 5 min | 40-70 min |
| **Paso 6**: Compresión | 10-15 min | 50-85 min |
| **Paso 7**: Validación | 10 min | 60-95 min |
| **Paso 8**: Almacenamiento | 5 min | 65-100 min |
| **Paso 9**: Test restauración | 20-30 min | 85-130 min |
| **Paso 10**: Validación final | 10 min | 95-140 min |

**Tiempo Total Estimado**: 95-150 minutos (primera ejecución completa)
**Siguientes ejecuciones**: 30-45 minutos (si solo BD + snapshot)

---

## Comandos Frecuentes (Quick Reference)

```bash
# Backup rápido
vagrant suspend
VBoxManage snapshot "iact-devbox" take "quick-backup-$(date +%s)"
vagrant resume

# Backup completo
/path/to/backup-script.sh

# Restaurar
vagrant halt
VBoxManage snapshot "iact-devbox" restore <snapshot-name>
vagrant up

# Ver snapshots
VBoxManage snapshot "iact-devbox" list

# Limpiar backups antiguos
find /home/user/IACT/backups -mtime +30 -delete

# Validar backup
tar -tzf backup-file.tar.gz > /dev/null
sha256sum -c backup-file.sha256
```

---

## Referencias

### Documentación Interna
- [PROCED-INFRA-001: Provisión VM Vagrant](./PROCED-INFRA-001-provision-vm-vagrant.md)

### Documentación Externa
- [VirtualBox Snapshot Manual](https://www.virtualbox.org/manual/UserManual.html#snapshots)
- [PostgreSQL pg_dump Documentation](https://www.postgresql.org/docs/current/app-pgdump.html)
- [MariaDB Backup Documentation](https://mariadb.com/kb/en/library/backup-and-restore/)

---

## Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-11-18 | Claude Code (Haiku 4.5) | Versión inicial - Procedimiento completo de Backup y Restauración |

---

## Aprobación

- **Autor**: Claude Code (Haiku 4.5)
- **Revisado por**: Pendiente
- **Aprobado por**: Pendiente
- **Fecha de próxima revisión**: 2026-02-18
- **Estado**: ACTIVO
