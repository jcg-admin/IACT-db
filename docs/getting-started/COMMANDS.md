# IACT DevBox - Referencia de Comandos

Referencia completa de todos los comandos disponibles en IACT DevBox.

## Scripts PowerShell

### check-prerequisites.ps1

Verifica requisitos del sistema antes de `vagrant up`.

```powershell
# Uso básico
.\scripts\check-prerequisites.ps1

# Ver ayuda
.\scripts\check-prerequisites.ps1 -Help
```

**Verifica:**
- VirtualBox 7.0+
- Vagrant 2.3+
- RAM disponible (6 GB)
- Espacio en disco (20 GB)
- Adaptadores Host-Only
- Puertos disponibles (3306, 5432, 80, 443)
- Validez del Vagrantfile

**Cuándo usar:** Antes de `vagrant up`, especialmente si es primera vez.

### setup-environment.ps1

Asistente interactivo de setup completo.

```powershell
# Uso normal (con confirmaciones)
.\scripts\setup-environment.ps1

# Modo automático
.\scripts\setup-environment.ps1 -AutoConfirm

# Saltar verificación de requisitos
.\scripts\setup-environment.ps1 -SkipChecks

# Ver ayuda
.\scripts\setup-environment.ps1 -Help
```

**Ejecuta automáticamente:**
1. check-prerequisites.ps1
2. fix-network.ps1 (si es necesario)
3. vagrant up
4. verify-vms.ps1
5. Test de conectividad

**Cuándo usar:** Primera vez configurando el entorno o reset completo.

### diagnose-system.ps1

Diagnóstico profundo del sistema.

```powershell
# Uso básico
.\scripts\diagnose-system.ps1
```

**Diagnostica:**
- Adaptadores Host-Only (detecta Ghost Adapters)
- Perfil de red (PUBLIC vs PRIVATE)
- Conectividad a VMs (ping)
- Estado de VMs (vagrant status)
- Dispositivos PnP fantasma
- Recursos del sistema (RAM, Disco)

**Genera log en:** `logs/diagnose-system_TIMESTAMP.log`

**Cuándo usar:** Cuando hay problemas de conectividad o comportamiento inesperado.

### fix-network.ps1

Elimina Ghost Network Adapters de forma segura.

```powershell
# Uso normal (pide confirmación)
.\scripts\fix-network.ps1

# Simulación
.\scripts\fix-network.ps1 -WhatIf

# Forzar sin confirmación (peligroso)
.\scripts\fix-network.ps1 -Force

# Saltar verificación de VMs
.\scripts\fix-network.ps1 -SkipVMCheck

# Ver ayuda
.\scripts\fix-network.ps1 -Help
```

**Requiere:** Permisos de Administrador

**Proceso:**
1. Detecta adaptadores Host-Only
2. Identifica cuáles eliminar (numerados #2, #3, etc.)
3. Verifica que VMs estén apagadas
4. Pide confirmación
5. Elimina adaptadores fantasma
6. Configura IP correcta (192.168.56.1)
7. Verifica resultado

**Genera log en:** `logs/fix-network_TIMESTAMP.log`

**Cuándo usar:** Cuando `diagnose-system.ps1` detecta Ghost Network Adapters.

### verify-vms.ps1

Verifica que VMs estén funcionando correctamente.

```powershell
# Uso básico
.\scripts\verify-vms.ps1
```

**Verifica:**
- VirtualBox instalado
- Vagrant instalado
- Estado de VMs (running/poweroff)
- Logs generados
- Conectividad de red
- Puertos de servicios (3306, 5432, 80, 443)
- Adminer Web Interface
- Provisioning completado

**Cuándo usar:** Después de `vagrant up` para confirmar que todo funciona.

### clean-logs.ps1

Limpia y archiva logs antiguos.

```powershell
# Mover logs de 30+ días
.\scripts\clean-logs.ps1

# Personalizar días
.\scripts\clean-logs.ps1 -DaysToKeep 7

# Mover y comprimir
.\scripts\clean-logs.ps1 -Compress

# Mover, comprimir y eliminar originales
.\scripts\clean-logs.ps1 -Compress -DeleteArchived

# Limpiar todo (desarrollo)
.\scripts\clean-logs.ps1 -DaysToKeep 0 -Compress -DeleteArchived

# Simulación
.\scripts\clean-logs.ps1 -WhatIf

# Ver ayuda
.\scripts\clean-logs.ps1 -Help
```

**Genera log en:** `logs/clean-logs_TIMESTAMP.log`

**Cuándo usar:** Mantenimiento periódico (semanal/mensual).

### generate-support-bundle.ps1

Genera bundle de diagnóstico completo.

```powershell
# Bundle básico
.\scripts\generate-support-bundle.ps1

# Bundle completo
.\scripts\generate-support-bundle.ps1 -IncludeLogs -IncludeVagrantfile

# Ubicación personalizada
.\scripts\generate-support-bundle.ps1 -OutputPath C:\Support

# Sin comprimir
.\scripts\generate-support-bundle.ps1 -CompressBundle:$false

# Ver ayuda
.\scripts\generate-support-bundle.ps1 -Help
```

**Incluye:**
- Información del sistema
- Versiones de software
- Estado de VMs
- Configuración de red
- Tests de conectividad
- Puertos en uso
- Salida de scripts de diagnóstico
- (Opcional) Logs de provisioning
- (Opcional) Vagrantfile

**Genera:** `support-bundle_TIMESTAMP.zip`

**Cuándo usar:** Para reportar problemas complejos al equipo de soporte.

## Comandos Vagrant

### Gestión de VMs

```powershell
# Ver estado
vagrant status

# Iniciar todas las VMs
vagrant up

# Iniciar una VM específica
vagrant up mariadb
vagrant up postgresql
vagrant up adminer

# Detener todas las VMs
vagrant halt

# Detener una VM específica
vagrant halt mariadb

# Reiniciar VMs
vagrant reload

# Reiniciar y re-provisionar
vagrant reload --provision

# Destruir todas las VMs
vagrant destroy

# Destruir sin confirmación
vagrant destroy -f

# Suspender VMs (guardar estado)
vagrant suspend

# Reanudar VMs suspendidas
vagrant resume
```

### SSH y Ejecución Remota

```powershell
# SSH a una VM
vagrant ssh mariadb
vagrant ssh postgresql
vagrant ssh adminer

# Ejecutar comando remoto
vagrant ssh mariadb -c "mysql -u root -p'rootpass123' -e 'SHOW DATABASES;'"
vagrant ssh postgresql -c "psql -U postgres -c '\l'"
vagrant ssh adminer -c "sudo systemctl status apache2"
```

### Provisioning

```powershell
# Re-ejecutar provisioning en todas las VMs
vagrant provision

# Re-ejecutar provisioning en una VM
vagrant provision mariadb

# Ejecutar provisioner específico
vagrant provision --provision-with shell
```

### Información y Debugging

```powershell
# Ver versión de Vagrant
vagrant --version

# Ver lista global de VMs
vagrant global-status

# Limpiar cache de VMs
vagrant global-status --prune

# Validar Vagrantfile
vagrant validate

# Ver configuración SSH
vagrant ssh-config mariadb

# Debugging verbose
$env:VAGRANT_LOG="debug"
vagrant up
```

## Comandos de Base de Datos

### MariaDB

```bash
# Conectar como root
mysql -h 192.168.56.10 -u root -p'rootpass123'

# Conectar a base específica
mysql -h 192.168.56.10 -u django_user -p'django_pass' ivr_legacy

# Ejecutar query
mysql -h 192.168.56.10 -u root -p'rootpass123' -e "SHOW DATABASES;"

# Importar SQL
mysql -h 192.168.56.10 -u root -p'rootpass123' ivr_legacy < backup.sql

# Exportar SQL
mysqldump -h 192.168.56.10 -u root -p'rootpass123' ivr_legacy > backup.sql
```

### PostgreSQL

```bash
# Conectar como postgres
psql -h 192.168.56.11 -U postgres

# Conectar a base específica
psql -h 192.168.56.11 -U django_user -d iact_analytics

# Ejecutar query
psql -h 192.168.56.11 -U postgres -c "\l"

# Importar SQL
psql -h 192.168.56.11 -U postgres -d iact_analytics -f backup.sql

# Exportar SQL
pg_dump -h 192.168.56.11 -U postgres iact_analytics > backup.sql
```

## Comandos de VirtualBox

```powershell
# Listar VMs
VBoxManage list vms

# Listar VMs corriendo
VBoxManage list runningvms

# Listar adaptadores Host-Only
VBoxManage list hostonlyifs

# Info de una VM
VBoxManage showvminfo "db_mariadb"

# Crear adaptador Host-Only
VBoxManage hostonlyif create

# Configurar IP de adaptador
VBoxManage hostonlyif ipconfig "VirtualBox Host-Only Ethernet Adapter" --ip 192.168.56.1

# Eliminar adaptador
VBoxManage hostonlyif remove "VirtualBox Host-Only Ethernet Adapter #2"
```

## Comandos de Windows

### Red

```powershell
# Ver adaptadores
Get-NetAdapter | Where-Object { $_.Name -like "*VirtualBox*" }

# Ver IPs
Get-NetIPAddress | Where-Object { $_.InterfaceAlias -like "*VirtualBox*" }

# Ver perfil de red
Get-NetConnectionProfile | Where-Object { $_.InterfaceAlias -like "*VirtualBox*" }

# Cambiar perfil a PRIVATE
Set-NetConnectionProfile -InterfaceAlias "VirtualBox Host-Only Network" -NetworkCategory Private

# Ping
ping 192.168.56.10
Test-Connection -ComputerName 192.168.56.10 -Count 4

# Test de puerto
Test-NetConnection -ComputerName 192.168.56.10 -Port 3306
```

### Procesos y Puertos

```powershell
# Ver procesos de VirtualBox
Get-Process | Where-Object { $_.Name -like "*VBox*" }

# Ver puertos en uso
Get-NetTCPConnection -LocalPort 3306,5432,80,443

# Ver proceso usando un puerto
Get-NetTCPConnection -LocalPort 3306 | ForEach-Object {
  Get-Process -Id $_.OwningProcess
}
```

### Logs

```powershell
# Buscar errores en logs
Get-ChildItem logs\*.log | Select-String "ERROR"

# Ver últimas 50 líneas de un log
Get-Content logs\mariadb_bootstrap.log -Tail 50

# Seguir un log en tiempo real
Get-Content logs\mariadb_bootstrap.log -Wait
```

---

**Última actualización**: 2026-01-10
