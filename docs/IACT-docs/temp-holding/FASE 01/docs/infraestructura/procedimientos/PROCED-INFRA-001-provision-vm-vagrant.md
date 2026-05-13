---
id: PROCED-INFRA-001
tipo: procedimiento
categoria: infraestructura
subcategoria: provision
version: 1.0.0
fecha_creacion: 2025-11-18
autor: Claude Code (Haiku 4.5)
estado: activo
relacionados: ["PROC-INFRA-001", "TASK-REORG-INFRA-044", "docs/infraestructura/vagrant-dev/README.md"]
---

# PROCED-INFRA-001: Provisión de VM Vagrant

## Objetivo

Proporcionar pasos DETALLADOS y PASO A PASO para provisionar una máquina virtual con Vagrant, incluyendo validación de requisitos, creación de VM, aprovisionamiento de servicios (PostgreSQL, MariaDB), y verificación de funcionalidad.

Este es un procedimiento operacional (CÓMO provisionar), no un proceso de alto nivel (QUÉ provisionar).

---

## Alcance

Este procedimiento cubre:
- Verificación de pre-requisitos (Vagrant, VirtualBox)
- Creación e inicialización de Vagrantfile
- Configuración de bootstrap.sh
- Ejecución de vagrant up
- Verificación de aprovisionamiento
- Validación de servicios
- Creación de snapshots
- Testing de conectividad
- Troubleshooting de problemas comunes
- Rollback a estado anterior

**NO cubre**:
- Instalación inicial de Vagrant/VirtualBox (ver pre-requisitos)
- Configuración avanzada de networking
- Customización de Vagrantfile más allá de parámetros básicos
- Deployment a producción (solo desarrollo local)

---

## Pre-requisitos

Antes de ejecutar este procedimiento, verificar:

### Hardware
- [ ] CPU con virtualización habilitada (VT-x o AMD-V)
- [ ] Mínimo 8 GB RAM disponible (4 GB para VM + 4 GB para host)
- [ ] Mínimo 50 GB espacio libre en disco
- [ ] Conexión a Internet estable

### Software Requerido
- [ ] Vagrant >= 2.3.0
- [ ] VirtualBox >= 6.0 (6.1.x recomendado)
- [ ] Git (para clonar repositorio)
- [ ] SSH client (para vagrant ssh)

### Verificación de Requisitos

```bash
# Verificar Vagrant
vagrant --version
# Esperado: Vagrant 2.3.x o superior

# Verificar VirtualBox
VBoxManage --version
# Esperado: 6.x o 7.x

# Verificar virtualizacion en BIOS
# Linux: grep -c vmx /proc/cpuinfo  (esperado: > 0)
# macOS: sysctl -a | grep machdep.cpu.features | grep VMX
# Windows: systeminfo | findstr "Hyper-V"
```

### Conocimiento Requerido
- Conceptos básicos de máquinas virtuales
- Línea de comandos (bash/terminal)
- SSH básico
- Vagrant workflow (up, ssh, halt, destroy)

---

## Roles y Responsabilidades

| Rol | Responsabilidad |
|-----|-----------------|
| **DevOps Engineer** | Ejecuta procedimiento, configura Vagrantfile, troubleshooting |
| **Developer** | Valida funcionalidad, verifica acceso a BDs, prueba conexiones |
| **Tech Lead** | Aprueba cambios significativos, revisa snapshots |

---

## Procedimiento Detallado

### PASO 1: Verificar Pre-requisitos

#### 1.1 Validar versiones instaladas

```bash
# Terminal/Cmd - Ejecutar estos comandos
vagrant --version
VBoxManage --version
git --version
ssh -V
```

**Salida Esperada**:
```
Vagrant 2.3.4
Oracle VM VirtualBox Manager, v 6.1.38
git version 2.42.0
OpenSSH_9.0p1
```

**Si algún comando falla**: Instalar software faltante antes de continuar.

---

#### 1.2 Verificar virtualizacion en BIOS

**Síntoma de fallo**: `VT-x is not available` o `VBoxManage: error: VT-x`

**Linux**:
```bash
# Verificar si virtualizacion esta habilitada
grep -c vmx /proc/cpuinfo
# Esperado: > 0
```

**macOS**:
```bash
# Verificar VMX
sysctl -a | grep machdep.cpu.features | grep VMX
# Esperado: debe mostrar VMX
```

**Windows**:
```cmd
# Verificar Hyper-V
systeminfo | findstr "Hyper-V"
# Esperado: Hyper-V Capabilities: Virtualization Enabled
```

Si virtualizacion NO está habilitada:
1. Reiniciar computadora
2. Entrar a BIOS (F2, DEL, F10, etc., depende del fabricante)
3. Buscar "Virtualization Technology", "VT-x", "VT-d", o "AMD-V"
4. Habilitar
5. Guardar y salir
6. Reiniciar

---

#### 1.3 Validar espacio en disco

```bash
# Linux/macOS
df -h
# Buscar partición raíz, verificar >= 50GB disponible

# Windows
dir C:\
# Verificar espacio disponible >= 50GB
```

---

#### 1.4 Validar RAM disponible

```bash
# Linux/macOS
free -h
# Esperado: >= 8GB total

# macOS alternativa
vm_stat | grep "Pages free"

# Windows
systeminfo | findstr "Total Physical Memory"
# Esperado: >= 8192 MB
```

---

### PASO 2: Clonar/Obtener Vagrantfile

#### 2.1 Ubicación del Vagrantfile

El Vagrantfile debe estar en: `/home/user/IACT/infraestructura/vagrant/`

```bash
# Navegar al directorio del proyecto
cd /home/user/IACT

# Verificar que existe directorio vagrant
ls -la infraestructura/vagrant/
# Esperado: ver Vagrantfile (sin extensión)
```

**Si no existe Vagrantfile**:

```bash
# Opción 1: Si el repo tiene estructura
git pull origin develop

# Opción 2: Si el Vagrantfile está en rama específica
git checkout feature/vagrant-setup
```

---

#### 2.2 Validar sintaxis del Vagrantfile

```bash
# Cambiar a directorio vagrant
cd /home/user/IACT/infraestructura/vagrant

# Validar sintaxis Ruby
vagrant validate
# Esperado: "Vagrantfile validated successfully"
```

**Si da error**:
- Revisar syntax del Vagrantfile
- Verificar comillas, paréntesis
- Revisar caracteres especiales

---

#### 2.3 Revisar configuración importante

```bash
# Ver contenido del Vagrantfile (primeras 30 líneas)
head -30 Vagrantfile
```

**Verificar que incluya**:
- `config.vm.box = "ubuntu/focal64"` (o versión similar)
- `config.vm.network "private_network"` (red privada)
- `config.vm.network "forwarded_port"` (puertos forward)
- `config.vm.provision "shell"` (bootstrap script)

---

### PASO 3: Configurar Bootstrap Script

#### 3.1 Ubicar bootstrap.sh

```bash
# El script debe estar en: infraestructura/vagrant/bootstrap.sh
ls -la /home/user/IACT/infraestructura/vagrant/bootstrap.sh
# Esperado: -rwxr-xr-x (permisos ejecutables)
```

---

#### 3.2 Validar permisos de ejecución

```bash
# Si NO tiene permisos ejecutables:
chmod +x /home/user/IACT/infraestructura/vagrant/bootstrap.sh

# Verificar permisos nuevamente
ls -l /home/user/IACT/infraestructura/vagrant/bootstrap.sh
# Esperado: -rwxr-xr-x (debe empezar con x)
```

---

#### 3.3 Revisar variables de entorno en bootstrap.sh

```bash
# Ver primeras 50 líneas del script
head -50 /home/user/IACT/infraestructura/vagrant/bootstrap.sh
```

**Buscar variables críticas**:
```bash
# Estas variables DEBEN estar definidas:
# DB_ROOT_PASSWORD=rootpass123
# DB_PASSWORD=postgrespass123
# DJANGO_DB_NAME=iact_analytics
# IVR_DB_NAME=ivr_legacy
# POSTGRES_VERSION=16
# MARIADB_VERSION=11.4
```

Si necesitas cambiar contraseñas:
```bash
# Editar archivo (usar editor preferido)
nano /home/user/IACT/infraestructura/vagrant/bootstrap.sh
# O
vim /home/user/IACT/infraestructura/vagrant/bootstrap.sh

# Buscar y cambiar variables (Ctrl+X para buscar en nano)
# DB_ROOT_PASSWORD=newpass123
# DB_PASSWORD=newpass456
```

---

#### 3.4 Validar sintaxis del script bash

```bash
# Verificar sintaxis sin ejecutar
bash -n /home/user/IACT/infraestructura/vagrant/bootstrap.sh
# Esperado: sin salida (sin errores)

# Si hay errores, mostrará línea y tipo de error
```

---

### PASO 4: Ejecutar vagrant up

#### 4.1 Preparar directorio de trabajo

```bash
# Navegar al directorio vagrant
cd /home/user/IACT/infraestructura/vagrant

# Verificar archivos necesarios
ls -la
# Esperado: ver Vagrantfile, bootstrap.sh, y scripts/ (directorio)
```

---

#### 4.2 Eliminar VM anterior si existe

```bash
# Ver estado actual
vagrant status
# Posibles estados: running, stopped, not created

# Si running o stopped, destruir
if [ "$(vagrant status --machine-readable | grep state | awk -F, '{print $3}')" != "not created" ]; then
  vagrant destroy -f
fi
```

---

#### 4.3 Descargar base box

```bash
# Esto se ejecuta automáticamente en vagrant up
# Pero puedes pre-descargar para ahorrar tiempo

vagrant box add ubuntu/focal64
# Esperado: "Successfully added box 'ubuntu/focal64'"
```

---

#### 4.4 Ejecutar vagrant up (PASO CRÍTICO)

```bash
# Cambiar a directorio vagrant
cd /home/user/IACT/infraestructura/vagrant

# Ejecutar vagrant up
vagrant up

# DURACIÓN ESPERADA: 15-25 minutos (primera ejecución)
```

**Salida esperada durante ejecución**:
```
==> default: Importing base box 'ubuntu/focal64'...
==> default: Matching MAC address for NAT networking...
==> default: Waiting for the box to be ready...
==> default: Setting hostname...
==> default: Configuring and enabling network interfaces...
==> default: Rsyncing folder...
==> default: Running provisioner: shell...

[STEP 1/5] system_prepare.sh
[STEP 2/5] mariadb_install.sh
[STEP 3/5] postgres_install.sh
[STEP 4/5] setup_mariadb_database.sh
[STEP 5/5] setup_postgres_database.sh

[SUCCESS] Bootstrap completado exitosamente
```

---

#### 4.5 Si vagrant up falla

**Capturar logs completos**:
```bash
# La salida completa ya mostró el error
# Notar el PASO que falló (STEP 1-5)
# Ir a sección Troubleshooting para soluciones específicas
```

---

### PASO 5: Verificar Máquina Virtual

#### 5.1 Verificar VM está corriendo

```bash
# Ver estado de VM
vagrant status

# Salida esperada:
# Current machine states:
#
# default                   running (virtualbox)
#
# The VM is running.
```

---

#### 5.2 Verificar recursos de VM

```bash
# Listar VMs en VirtualBox
VBoxManage list vms

# Esperado: ver "iact-devbox" en la lista
```

---

#### 5.3 Verificar configuración de red

```bash
# Conectar a VM y verificar IP
vagrant ssh -c "hostname -I"

# Esperado: 10.0.2.10 (u otra IP privada)
```

---

### PASO 6: SSH y Validaciones

#### 6.1 Conectar a VM via SSH

```bash
# Entrar a VM
vagrant ssh

# Si exitoso, verás prompt como: vagrant@callcenter-analytics:~$
```

---

#### 6.2 Verificar servicios están corriendo

```bash
# Dentro de la VM:

# Verificar PostgreSQL
sudo systemctl status postgresql
# Esperado: active (running)

# Verificar MariaDB
sudo systemctl status mariadb
# Esperado: active (running)
```

---

#### 6.3 Validar directorios creados

```bash
# Dentro de la VM:

# Directorio de logs
ls -la /vagrant/logs/
# Esperado: archivo bootstrap-*.log

# Estado de provisión
ls -la /var/iact/state/
# Esperado: archivos marker (system-prepared, mariadb-installed, etc.)
```

---

#### 6.4 Validar bases de datos creadas

```bash
# Dentro de la VM:

# Conectar a PostgreSQL
psql -U postgres -d iact_analytics -c "SELECT version();"
# Esperado: PostgreSQL 16.x

# Conectar a MariaDB
mysql -u root -p'rootpass123' -e "SHOW DATABASES;"
# Esperado: ver ivr_legacy, iact_analytics, mysql, etc.
```

---

#### 6.5 Salir de VM

```bash
# Dentro de la VM:
exit

# De vuelta en host machine
```

---

### PASO 7: Crear Snapshot

#### 7.1 Pausar VM

```bash
# En host machine, en directorio vagrant
vagrant suspend

# Esperar a que termine (2-3 segundos)
```

---

#### 7.2 Crear snapshot

```bash
# Tomar snapshot del estado actual
VBoxManage snapshot "iact-devbox" take "clean-provision" --description "VM recién provisionada, servicios OK"

# Esperado: sin errores
```

---

#### 7.3 Listar snapshots

```bash
# Ver snapshots creados
VBoxManage snapshot "iact-devbox" list

# Esperado:
#    Name: clean-provision
#    Description: VM recién provisionada, servicios OK
```

---

#### 7.4 Reanudar VM

```bash
# Reactivar VM
vagrant resume

# Esperado: VM vuelve a estado running
```

---

### PASO 8: Tests Finales

#### 8.1 Ejecutar bootstrap test

```bash
# En host machine, ejecutar test suite
vagrant ssh -c "bash /vagrant/tests/bootstrap_test.sh"

# Esperado:
# [PASS] MariaDB installed and running
# [PASS] PostgreSQL installed and running
# [PASS] Database iact_analytics created
# [PASS] Database ivr_legacy created
# [PASS] django_user has permissions
# [PASS] All tests PASSED
```

---

#### 8.2 Verificar conectividad desde HOST

```bash
# En host machine:

# Test PostgreSQL
psql -h localhost -p 15432 -U django_user -d iact_analytics -c "SELECT 1;"
# Password: django_pass
# Esperado: ?column?
#          1

# Test MariaDB
mysql -h 127.0.0.1 -P 13306 -u django_user -p'django_pass' -e "SELECT 1;"
# Esperado: 1
```

---

#### 8.3 Seed data (opcional)

```bash
# Cargar datos de prueba (si existe script)
vagrant ssh -c "bash /vagrant/tests/seed_data.sh"

# Verificar datos insertados
vagrant ssh -c "psql -U django_user -d iact_analytics -c 'SELECT COUNT(*) FROM information_schema.tables;'"
```

---

## Validaciones por Paso

| Paso | Validación | Comando |
|------|-----------|---------|
| **1** | Vagrant version OK | `vagrant --version` |
| **1** | VirtualBox version OK | `VBoxManage --version` |
| **1** | Virtualizacion habilitada | `grep -c vmx /proc/cpuinfo` (>0) |
| **2** | Vagrantfile existe | `test -f Vagrantfile` |
| **2** | Vagrantfile sintaxis OK | `vagrant validate` |
| **3** | bootstrap.sh existe | `test -f bootstrap.sh` |
| **3** | bootstrap.sh ejecutable | `test -x bootstrap.sh` |
| **4** | vagrant up sin errores | Exit code 0 |
| **5** | VM running | `vagrant status` = running |
| **6** | PostgreSQL corriendo | `sudo systemctl status postgresql` |
| **6** | MariaDB corriendo | `sudo systemctl status mariadb` |
| **6** | BD iact_analytics existe | `psql -l` muestra DB |
| **6** | BD ivr_legacy existe | `mysql -e "SHOW DATABASES;"` |
| **7** | Snapshot creado | `VBoxManage snapshot list` |
| **8** | Todos tests PASS | `bootstrap_test.sh` exit 0 |

---

## Troubleshooting

### Problema 1: VT-x Not Available

**Síntomas**:
```
VBoxManage: error: VT-x is not available (VERR_VMX_NO_VMX)
```

**Causa**: Virtualizacion deshabilitada en BIOS

**Solución**:
1. Reiniciar computadora
2. Entrar a BIOS (F2, DEL, F10, etc.)
3. Buscar "Virtualization Technology" o "VT-x"
4. Cambiar a "Enabled"
5. Guardar y salir (usualmente F10)
6. Reiniciar
7. Ejecutar `vagrant up` nuevamente

---

### Problema 2: Port Already In Use (15432 o 13306)

**Síntomas**:
```
The port(s) to be forwarded are now not available on the host machine.
...Port 15432 is already allocated
```

**Causa**: Puerto ya está en uso por otro proceso o VM

**Solución A - Terminar proceso en puerto**:
```bash
# Linux/macOS
lsof -i :15432
kill -9 <PID>

# Windows (PowerShell como admin)
netstat -ano | findstr :15432
taskkill /PID <PID> /F
```

**Solución B - Cambiar puerto en Vagrantfile**:
```bash
# Editar Vagrantfile
nano Vagrantfile

# Buscar línea con puerto 15432 y cambiar:
# config.vm.network "forwarded_port", guest: 5432, host: 25432  # Cambiar 15432 → 25432

# Luego
vagrant destroy -f
vagrant up
```

---

### Problema 3: Insufficient Disk Space

**Síntomas**:
```
The VM failed to start because there was not enough space...
```

**Causa**: Menos de 50 GB libres en disco

**Solución**:
1. Liberar espacio (limpiar caché, eliminar archivos antiguos)
2. O cambiar ubicación de VirtualBox VMs:
```bash
# Linux: Editar ~/.VirtualBox/VirtualBox.xml
# macOS: Editar ~/Library/VirtualBox/VirtualBox.xml
# Cambiar: <defaultMachineFolder>/path/with/more/space</defaultMachineFolder>

# Windows: File → Preferences → General → Default Machine Folder
```

---

### Problema 4: Bootstrap Script Fails

**Síntomas**:
```
[ERROR] mariadb_install.sh failed with code: 1
```

**Causa**: Uno de los scripts de aprovisionamiento falló

**Solución**:
```bash
# Ver logs completos
cat infraestructura/vagrant/logs/bootstrap-*.log | tail -100

# Opción 1: Limpiar estado y re-provisionar
vagrant ssh
sudo rm /var/iact/state/mariadb-installed
exit
vagrant provision

# Opción 2: Destruir y recrear
vagrant destroy -f
vagrant up
```

---

### Problema 5: Migrations Failed on Startup

**Síntomas**:
```
django.db.utils.OperationalError: relation does not exist
```

**Causa**: Migraciones de Django no aplicadas

**Solución** (desde app Django):
```bash
# En host machine, conectar a Django container/entorno
python manage.py migrate
python manage.py showmigrations
```

O dentro de VM:
```bash
# SSH a VM
vagrant ssh

# Conectar directamente a BD
psql -U django_user -d iact_analytics -c "SELECT * FROM django_migrations;"
```

---

### Problema 6: PostgreSQL Connection Refused from Host

**Síntomas**:
```
psql: could not connect to server: Connection refused
    Is the server running on host "localhost" (127.0.0.1) and accepting
    TCP/IP connections on port 15432?
```

**Causa**: Port forwarding no configurado o PostgreSQL no escucha en 0.0.0.0

**Solución**:
```bash
# 1. Verificar port forwarding en VM
vagrant ssh -c "netstat -tlnp | grep 5432"

# 2. Verificar PostgreSQL escucha en 0.0.0.0
vagrant ssh -c "sudo grep 'listen_addresses' /etc/postgresql/16/main/postgresql.conf"
# Esperado: listen_addresses = '*'

# 3. Si no está configurado, editar
vagrant ssh
sudo nano /etc/postgresql/16/main/postgresql.conf
# Buscar listen_addresses y cambiar a '*'
sudo systemctl restart postgresql
exit
```

---

### Problema 7: MariaDB Access Denied

**Síntomas**:
```
ERROR 1045 (28000): Access denied for user 'django_user'@'localhost'
```

**Causa**: Usuario no creado o contraseña incorrecta

**Solución**:
```bash
# SSH a VM
vagrant ssh

# Conectar como root
mysql -u root -p'rootpass123'

# Dentro de MySQL:
SHOW GRANTS FOR 'django_user'@'%';

# Si usuario no existe, crearlo:
CREATE USER 'django_user'@'%' IDENTIFIED BY 'django_pass';
GRANT ALL PRIVILEGES ON ivr_legacy.* TO 'django_user'@'%';
GRANT ALL PRIVILEGES ON iact_analytics.* TO 'django_user'@'%';
FLUSH PRIVILEGES;

# Salir
exit
exit
```

---

### Problema 8: VM Slow or High CPU Usage

**Síntoma**: VM lenta, CPU al 100%

**Causa**: RAM insuficiente o carga de proceso

**Solución A - Aumentar RAM**:
```bash
# Editar Vagrantfile
nano infraestructura/vagrant/Vagrantfile

# Cambiar: VM_MEMORY = 8192  # (de 4096)

# Aplicar cambio
vagrant reload
```

**Solución B - Aumentar shared_buffers PostgreSQL**:
```bash
vagrant ssh
sudo nano /etc/postgresql/16/main/postgresql.conf

# Cambiar:
# shared_buffers = 512MB  (de 256MB)
# effective_cache_size = 2GB  (de 1GB)

sudo systemctl restart postgresql
exit
```

---

## Rollback

### Rollback A: Usar Snapshot

Si creaste snapshot en Paso 7:

```bash
# 1. Detener VM
vagrant halt

# 2. Restaurar snapshot
VBoxManage snapshot "iact-devbox" restore "clean-provision"

# 3. Iniciar VM
vagrant up

# 4. Verificar estado
vagrant status
vagrant ssh -c "sudo systemctl status postgresql"
```

---

### Rollback B: Destruir y Recrear

Para rollback completo:

```bash
# 1. Destruir VM completamente
vagrant destroy -f

# 2. Limpiar box (opcional)
vagrant box remove ubuntu/focal64

# 3. Recrear desde cero
vagrant up
```

---

### Rollback C: Partial Rollback (Re-provisionar selectively)

Para rollback parcial (solo cierto script):

```bash
# 1. SSH a VM
vagrant ssh

# 2. Eliminar marker de paso fallido
sudo rm /var/iact/state/mariadb-installed  # Por ejemplo

# 3. Salir
exit

# 4. Re-ejecutar provisión
vagrant provision
```

---

## Criterios de Éxito

Una provisión exitosa cumple TODOS estos criterios:

- [x] `vagrant status` muestra "running"
- [x] `vagrant ssh` conecta exitosamente
- [x] PostgreSQL servicio está "active (running)"
- [x] MariaDB servicio está "active (running)"
- [x] Base de datos iact_analytics existe en PostgreSQL
- [x] Base de datos ivr_legacy existe en MariaDB
- [x] Usuario django_user existe con permisos correctos
- [x] Port forwarding: localhost:15432 → PostgreSQL (guest:5432)
- [x] Port forwarding: localhost:13306 → MariaDB (guest:3306)
- [x] Conexión desde HOST a PostgreSQL: `psql -h localhost -p 15432` exitosa
- [x] Conexión desde HOST a MariaDB: `mysql -h 127.0.0.1 -P 13306` exitosa
- [x] `bootstrap_test.sh` todos los tests PASS
- [x] Snapshot creado exitosamente
- [x] Logs en /vagrant/logs/ sin errores críticos

---

## Tiempo Estimado

| Paso | Tiempo | Total |
|------|--------|-------|
| **Paso 1**: Verificar pre-requisitos | 5-10 min | 5-10 min |
| **Paso 2**: Obtener Vagrantfile | 2-5 min | 7-15 min |
| **Paso 3**: Configurar bootstrap | 5-10 min | 12-25 min |
| **Paso 4**: vagrant up | 15-25 min | 27-50 min |
| **Paso 5**: Verificar VM | 5-10 min | 32-60 min |
| **Paso 6**: SSH y validaciones | 5-10 min | 37-70 min |
| **Paso 7**: Crear snapshot | 2-5 min | 39-75 min |
| **Paso 8**: Tests finales | 5-10 min | 44-85 min |

**Tiempo Total Estimado**: 45-90 minutos (primera ejecución)
**Siguientes ejecuciones**: 5-10 minutos (si vagrant resume)

---

## Checklist de Provisión

```markdown
PRE-PROVISIÓN:
- [ ] Virtualizacion habilitada en BIOS
- [ ] Vagrant 2.3+ instalado
- [ ] VirtualBox 6.0+ instalado
- [ ] >50 GB disco libre
- [ ] >8 GB RAM total

CONFIGURACIÓN:
- [ ] Vagrantfile obtido/clonado
- [ ] bootstrap.sh tiene permisos ejecutables
- [ ] Variables de entorno revisadas
- [ ] Sintaxis bash validada

EJECUCIÓN:
- [ ] vagrant up ejecutado sin errores
- [ ] Base box descargada
- [ ] VM creada exitosamente
- [ ] Scripts bootstrap ejecutados (STEP 1-5)

VALIDACIÓN:
- [ ] VM status: running
- [ ] PostgreSQL status: active
- [ ] MariaDB status: active
- [ ] BD iact_analytics existe
- [ ] BD ivr_legacy existe
- [ ] Usuarios BD creados con permisos

VERIFICACIÓN FINAL:
- [ ] Conexión PostgreSQL desde HOST
- [ ] Conexión MariaDB desde HOST
- [ ] bootstrap_test.sh todos PASS
- [ ] Snapshot creado
- [ ] Logs sin errores críticos
```

---

## Comandos Frecuentes (Quick Reference)

```bash
# Inicio
cd infraestructura/vagrant
vagrant up

# Conectar
vagrant ssh

# Estado
vagrant status

# Detener
vagrant halt

# Pausar/Reanudar
vagrant suspend
vagrant resume

# Re-provisionar
vagrant provision

# Destruir
vagrant destroy -f

# Ver logs
cat logs/bootstrap-*.log

# Test
vagrant ssh -c "bash /vagrant/tests/bootstrap_test.sh"

# Conectar BD desde HOST
psql -h localhost -p 15432 -U django_user -d iact_analytics
mysql -h 127.0.0.1 -P 13306 -u django_user -p'django_pass' ivr_legacy
```

---

## Referencias

### Documentación Interna
- [Vagrant Development Environment](../vagrant-dev/README.md)
- [PROCED-GOB-002: Actualizar Documentación](../../gobernanza/procedimientos/PROCED-GOB-002-actualizar_documentacion.md)
- [PROCED-DEVOPS-001: Deploy a Staging](../../gobernanza/procedimientos/PROCED-DEVOPS-001-deploy_staging.md)

### Documentación Externa
- [Vagrant Official Documentation](https://www.vagrantup.com/docs)
- [VirtualBox Manual](https://www.virtualbox.org/manual/)
- [PostgreSQL 16 Documentation](https://www.postgresql.org/docs/16/)
- [MariaDB 11.4 Documentation](https://mariadb.com/kb/en/mariadb-1140-release-notes/)

### Tareas Relacionadas
- [TASK-REORG-INFRA-044: Crear PROCED-INFRA-001](../qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-044-crear-proced-infra-001-provision-vm/README.md)

---

## Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-11-18 | Claude Code (Haiku 4.5) | Versión inicial - Procedimiento completo de provisión VM Vagrant |

---

## Aprobación

- **Autor**: Claude Code (Haiku 4.5)
- **Revisado por**: Pendiente
- **Aprobado por**: Pendiente
- **Fecha de próxima revisión**: 2026-02-18
- **Estado**: ACTIVO
