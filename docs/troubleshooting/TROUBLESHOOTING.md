# Troubleshooting Completo - IACT DevBox

Guía consolidada de problemas comunes y sus soluciones en el sistema IACT DevBox.

## Organización del Documento

Este documento cubre problemas en las siguientes áreas:
1. Vagrant y VirtualBox
2. Networking y conectividad
3. SSH y PowerShell
4. vagrant-goodhosts y DNS
5. SSL y certificados
6. Servicios de base de datos
7. Adminer web interface
8. Performance y recursos

## Sección 1: Vagrant y VirtualBox

### Problema 1.1: Error "Log level must be in 0..8"

**Síntomas**:
```
C:/Program Files/Vagrant/embedded/gems/gems/vagrant_cloud-3.1.3/lib/vagrant_cloud/logger.rb:40:
Log level must be in 0..8 (ArgumentError)
```

**Causa**: Bug conocido en Vagrant 2.4.7

**Solución**:
```powershell
# Temporal (sesión actual)
$env:VAGRANT_LOG_LEVEL = "INFO"
vagrant up

# Permanente (perfil PowerShell)
notepad $PROFILE
# Agregar: $env:VAGRANT_LOG_LEVEL = "INFO"
```

**Documentación detallada**: VAGRANT_2.4.7_WORKAROUND.md

### Problema 1.2: "VERR_INTNET_FLT_IF_NOT_FOUND"

**Síntomas**:
```
The guest machine entered an invalid state while waiting for it to boot.
VERR_INTNET_FLT_IF_NOT_FOUND
```

**Causa**: Adaptador Host-Only de VirtualBox deshabilitado o corrupto

**Solución 1** (Rápida):
```
1. Win+R
2. Escribir: ncpa.cpl
3. Enter
4. Buscar "VirtualBox Host-Only Network"
5. Click derecho -> Deshabilitar
6. Esperar 5 segundos
7. Click derecho -> Habilitar
8. Cerrar ventana
9. vagrant up
```

**Solución 2** (Recrear adaptador):
```powershell
# Como Administrador
cd "C:\Program Files\Oracle\VirtualBox"
.\VBoxManage.exe hostonlyif remove "VirtualBox Host-Only Ethernet Adapter"
.\VBoxManage.exe hostonlyif create

# Verificar
.\VBoxManage.exe list hostonlyifs
```

**Solución 3** (Reinstalar VirtualBox):
Si las anteriores fallan, reinstalar VirtualBox manteniendo settings.

### Problema 1.3: VMs no arrancan después de reiniciar Windows

**Síntomas**:
```
vagrant up
# VM queda en "powering on" indefinidamente
```

**Causa**: VirtualBox service no inició correctamente

**Solución**:
```powershell
# Verificar servicio
Get-Service VBox*

# Reiniciar servicios
Restart-Service -Name VBoxDRV
Restart-Service -Name VBoxNetAdp
Restart-Service -Name VBoxNetFlt
Restart-Service -Name VBoxSVC

# Reintentar
vagrant up
```

### Problema 1.4: "A VirtualBox machine with the name already exists"

**Síntomas**:
```
A VirtualBox machine with the name 'iact-mariadb' already exists.
```

**Causa**: VM existe en VirtualBox pero no en Vagrant

**Solución**:
```powershell
# Opción A: Eliminar de VirtualBox
VBoxManage unregistervm iact-mariadb --delete

# Opción B: Usar vagrant destroy
vagrant destroy -f mariadb

# Opción C: Eliminar todas las VMs del proyecto
vagrant destroy -f
vagrant up
```

## Sección 2: Networking y Conectividad

### Problema 2.1: No se puede hacer ping a las VMs

**Síntomas**:
```powershell
ping 192.168.56.10
# Request timed out
```

**Diagnóstico**:
```powershell
# 1. Verificar que VM está corriendo
vagrant status mariadb

# 2. Verificar IP en la VM
vagrant ssh mariadb
ip addr show enp0s8
# Debe mostrar: inet 192.168.56.10/24
```

**Solución 1** (VM sin IP):
```powershell
vagrant reload mariadb
```

**Solución 2** (Problema de red):
```
1. Win+R -> ncpa.cpl
2. VirtualBox Host-Only Network -> Properties
3. IPv4 -> Properties
4. Usar la siguiente dirección IP:
   IP: 192.168.56.1
   Máscara: 255.255.255.0
5. OK -> OK
6. vagrant reload
```

**Solución 3** (Firewall bloqueando):
```powershell
# Verificar regla de firewall
Get-NetFirewallRule -DisplayName "*VirtualBox*"

# Agregar regla si no existe
New-NetFirewallRule -DisplayName "VirtualBox Host-Only" `
  -Direction Inbound `
  -Action Allow `
  -InterfaceAlias "VirtualBox Host-Only Network"
```

### Problema 2.2: Puertos de base de datos no responden

**Síntomas**:
```powershell
Test-NetConnection -ComputerName 192.168.56.10 -Port 3306
# TcpTestSucceeded: False
```

**Diagnóstico**:
```powershell
vagrant ssh mariadb
sudo netstat -tlnp | grep 3306
# Si no muestra nada, MariaDB no está escuchando
```

**Solución**:
```bash
# Verificar servicio
sudo systemctl status mariadb

# Si está detenido
sudo systemctl start mariadb

# Verificar configuración de bind-address
sudo grep bind-address /etc/mysql/mariadb.conf.d/50-server.cnf
# Debe mostrar: bind-address = 0.0.0.0
```

### Problema 2.3: "Connection refused" al conectar a bases de datos

**Síntomas**:
```powershell
mysql -h 192.168.56.10 -u root -p
# ERROR 2003 (HY000): Can't connect to MySQL server on '192.168.56.10' (10061)
```

**Diagnóstico en la VM**:
```bash
vagrant ssh mariadb

# Verificar servicio corriendo
sudo systemctl is-active mariadb
# Debe mostrar: active

# Verificar puerto
sudo ss -tlnp | grep 3306
# Debe mostrar mariadbd escuchando en 0.0.0.0:3306
```

**Solución 1** (Servicio detenido):
```bash
sudo systemctl restart mariadb
```

**Solución 2** (Configuración incorrecta):
```bash
# Verificar bind-address
sudo cat /etc/mysql/mariadb.conf.d/50-server.cnf | grep bind-address

# Si muestra 127.0.0.1, cambiar a 0.0.0.0
sudo sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# Reiniciar
sudo systemctl restart mariadb
```

## Sección 3: SSH y PowerShell

### Problema 3.1: "ssh: connect to host 127.0.0.1 port 2222: Connection timed out"

**Síntomas**:
```powershell
vagrant ssh mariadb
# Timeout después de varios minutos
```

**Causa**: PowerShell usa SSH de Windows en lugar de Git SSH

**Diagnóstico**:
```powershell
(Get-Command ssh).Source
# Si muestra C:\Windows\System32\OpenSSH\ssh.exe = PROBLEMA
# Debe mostrar C:\Program Files\Git\usr\bin\ssh.exe
```

**Solución**:
```powershell
# 1. Abrir perfil
notepad $PROFILE

# 2. Agregar al inicio
$env:PATH = "C:\Program Files\Git\usr\bin;$env:PATH"

# 3. Guardar y recargar
. $PROFILE

# 4. Verificar
(Get-Command ssh).Source
# Debe mostrar Git SSH ahora
```

**Documentación detallada**: ANALISIS_PROBLEMA_SSH_VAGRANT.md

### Problema 3.2: "Permission denied (publickey)"

**Síntomas**:
```
vagrant@192.168.56.10: Permission denied (publickey,gssapi-keyex,gssapi-with-mic)
```

**Causa**: Claves SSH no generadas o no copiadas correctamente

**Solución**:
```powershell
# Regenerar claves SSH de Vagrant
vagrant ssh-config mariadb
# Verificar IdentityFile path existe

# Si no, reprovisionar
vagrant destroy -f mariadb
vagrant up mariadb
```

### Problema 3.3: SSH funciona pero es muy lento

**Síntomas**: Demora 30+ segundos en conectar

**Causa**: DNS reverse lookup timeout

**Solución en la VM**:
```bash
vagrant ssh mariadb

# Editar sshd_config
sudo nano /etc/ssh/sshd_config

# Cambiar o agregar:
UseDNS no

# Guardar y reiniciar
sudo systemctl restart sshd

exit

# Probar velocidad
time vagrant ssh mariadb
```

## Sección 4: vagrant-goodhosts y DNS

### Problema 4.1: "adminer.devbox" no resuelve

**Síntomas**:
```powershell
ping adminer.devbox
# La solicitud de ping no pudo encontrar el host
```

**Diagnóstico**:
```powershell
# Verificar plugin instalado
vagrant plugin list | Select-String goodhosts

# Verificar archivo hosts
Get-Content C:\Windows\System32\drivers\etc\hosts | Select-String adminer
```

**Solución 1** (Plugin no instalado):
```powershell
vagrant plugin install vagrant-goodhosts
vagrant reload adminer
```

**Solución 2** (Entradas no agregadas):
```powershell
# Como Administrador
vagrant reload adminer

# O agregar manualmente
Add-Content C:\Windows\System32\drivers\etc\hosts "`n192.168.56.12    adminer.devbox`n192.168.56.12    www.adminer.devbox"
```

**Solución 3** (Permisos insuficientes):
vagrant-goodhosts requiere privilegios de administrador la primera vez.
```powershell
# Ejecutar PowerShell como Administrador
vagrant reload adminer
```

### Problema 4.2: Error "The following settings shouldn't exist: enabled"

**Síntomas**:
```
VagrantPlugins::GoodHosts::Config:
* The following settings shouldn't exist: enabled
```

**Causa**: Configuración incorrecta en Vagrantfile

**Solución**:
Eliminar línea `adminer.goodhosts.enabled = true` del Vagrantfile.

Configuración correcta:
```ruby
if Vagrant.has_plugin?('vagrant-goodhosts')
  adminer.goodhosts.aliases = [
    ADMINER_DOMAIN,
    "www.#{ADMINER_DOMAIN}"
  ]
end
```

### Problema 4.3: Entradas duplicadas en hosts file

**Síntomas**:
```
192.168.56.12    adminer.devbox
192.168.56.12    adminer.devbox
```

**Causa**: Múltiples ejecuciones sin limpiar entradas antiguas

**Solución**:
```powershell
# Como Administrador
# Editar manualmente
notepad C:\Windows\System32\drivers\etc\hosts

# Eliminar líneas duplicadas, mantener solo:
## vagrant-goodhosts-adminer-... START
192.168.56.12	adminer.devbox
192.168.56.12	www.adminer.devbox
## vagrant-goodhosts-adminer-... END
```

## Sección 5: SSL y Certificados

### Problema 5.1: "Su conexión no es privada" en navegador

**Síntomas**: Al abrir https://adminer.devbox aparece advertencia de certificado

**Causa**: Certificado CA no instalado en Windows

**Solución**:
```powershell
# Instalar CA
cd D:\Estadia_IACT\proyecto\IACT\db\scripts
.\install-ca-certificate.ps1

# Reiniciar navegador completamente
# Chrome/Edge: Cerrar todas las ventanas y procesos en Task Manager
```

**Documentación detallada**: INSTALAR_CA_WINDOWS.md

### Problema 5.2: Certificado instalado pero navegador sigue mostrando error

**Síntomas**: CA instalado pero advertencia persiste

**Causa 1**: Navegador no recargó el almacén de certificados

**Solución**:
```
1. Cerrar TODAS las ventanas del navegador
2. Abrir Task Manager (Ctrl+Shift+Esc)
3. Buscar procesos de Chrome/Edge/Firefox
4. Finalizar todos los procesos
5. Abrir navegador de nuevo
6. Probar https://adminer.devbox
```

**Causa 2**: Cache de certificados SSL

**Solución Chrome/Edge**:
```
1. chrome://settings/security
2. "Manage certificates"
3. Pestaña "Trusted Root Certification Authorities"
4. Verificar que aparece "IACT DevBox Root CA"
5. Si no aparece, reinstalar
```

**Causa 3**: Firefox usa almacén propio

**Solución Firefox**:
```
1. about:preferences#privacy
2. Scroll a "Certificates" -> "View Certificates"
3. Pestaña "Authorities"
4. Importar: D:\Estadia_IACT\proyecto\IACT\db\config\certs\ca\ca.crt
5. Marcar "Trust this CA to identify websites"
```

### Problema 5.3: Certificado expirado

**Síntomas**:
```
NET::ERR_CERT_DATE_INVALID
```

**Diagnóstico**:
```bash
vagrant ssh adminer
openssl x509 -in /vagrant/config/certs/adminer.crt -noout -dates
# Verificar notAfter
```

**Solución** (Regenerar certificado):
```powershell
# SSH a adminer
vagrant ssh adminer

# Eliminar certificados actuales
sudo rm /vagrant/config/certs/adminer.crt
sudo rm /vagrant/config/certs/adminer.key

# Salir y reprovisionar
exit
vagrant provision adminer
```

### Problema 5.4: Certificados no se generan en provisioning

**Síntomas**: Directorio `config/certs` vacío o inexistente

**Diagnóstico**:
```powershell
ls config\certs\ca\
# Si no existe o está vacío = problema
```

**Solución**:
```bash
# SSH a adminer
vagrant ssh adminer

# Ver logs de ssl.sh
tail -100 /vagrant/logs/adminer/adminer_*.log | grep -A 10 "SSL"

# Ejecutar manualmente
sudo bash /vagrant/config/ssl.sh

# O reprovisionar
exit
vagrant provision adminer
```

## Sección 6: Servicios de Base de Datos

### Problema 6.1: "Access denied for user 'django_user'@'host'"

**Síntomas** (MariaDB):
```powershell
mysql -h 192.168.56.10 -u django_user -p'django_pass' -D ivr_legacy
# ERROR 1045 (28000): Access denied
```

**Diagnóstico en VM**:
```bash
vagrant ssh mariadb
sudo mysql -u root -p'rootpass123'

# Verificar usuario existe
SELECT User, Host FROM mysql.user WHERE User='django_user';

# Verificar permisos
SHOW GRANTS FOR 'django_user'@'%';
```

**Solución** (Usuario no existe):
```sql
CREATE USER 'django_user'@'%' IDENTIFIED BY 'django_pass';
GRANT ALL PRIVILEGES ON ivr_legacy.* TO 'django_user'@'%';
FLUSH PRIVILEGES;
```

**Solución** (Host incorrecto):
```sql
-- Si usuario existe solo para localhost
RENAME USER 'django_user'@'localhost' TO 'django_user'@'%';
FLUSH PRIVILEGES;
```

### Problema 6.2: PostgreSQL "FATAL: password authentication failed"

**Síntomas**:
```powershell
psql -h 192.168.56.11 -U django_user -d iact_analytics
# FATAL: password authentication failed for user "django_user"
```

**Diagnóstico en VM**:
```bash
vagrant ssh postgresql
sudo -u postgres psql

# Verificar usuario
\du django_user

# Verificar database owner
\l iact_analytics
```

**Solución** (Usuario no existe):
```sql
CREATE USER django_user WITH PASSWORD 'django_pass';
GRANT ALL PRIVILEGES ON DATABASE iact_analytics TO django_user;
```

**Solución** (Password incorrecto):
```sql
ALTER USER django_user WITH PASSWORD 'django_pass';
```

### Problema 6.3: "Too many connections" en MariaDB

**Síntomas**:
```
ERROR 1040 (HY000): Too many connections
```

**Diagnóstico**:
```sql
SHOW STATUS LIKE 'Threads_connected';
SHOW VARIABLES LIKE 'max_connections';
```

**Solución temporal**:
```sql
SET GLOBAL max_connections = 200;
```

**Solución permanente** en VM:
```bash
sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf

# Agregar en [mysqld]
max_connections = 200

sudo systemctl restart mariadb
```

### Problema 6.4: PostgreSQL extensiones no instaladas

**Síntomas**:
```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- ERROR: could not open extension control file
```

**Solución**:
```bash
vagrant ssh postgresql

# Instalar paquete contrib
sudo apt-get update
sudo apt-get install -y postgresql-contrib

# Crear extensión
sudo -u postgres psql -d iact_analytics
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

## Sección 7: Adminer Web Interface

### Problema 7.1: "403 Forbidden" al acceder a Adminer

**Síntomas**:
```
Forbidden
You don't have permission to access this resource.
```

**Causa**: Permisos incorrectos en archivos de Adminer

**Solución** en VM:
```bash
vagrant ssh adminer

# Verificar permisos
ls -la /usr/share/adminer/

# Corregir si es necesario
sudo chmod 644 /usr/share/adminer/index.php
sudo chown www-data:www-data /usr/share/adminer/index.php

# Verificar VirtualHost
sudo apachectl -S | grep adminer

# Reiniciar Apache
sudo systemctl restart apache2
```

### Problema 7.2: Página en blanco (blank page)

**Síntomas**: http://adminer.devbox muestra página en blanco

**Causa**: Error en PHP

**Diagnóstico**:
```bash
vagrant ssh adminer

# Ver logs de error
sudo tail -50 /var/log/apache2/adminer-error.log

# Verificar PHP
php -v

# Test PHP syntax
php -l /usr/share/adminer/index.php
```

**Solución común** (PHP errors):
```bash
# Habilitar display_errors temporalmente
sudo nano /etc/php/7.4/apache2/php.ini

# Cambiar
display_errors = On

sudo systemctl restart apache2
```

### Problema 7.3: Adminer no puede conectar a bases de datos

**Síntomas**: "Unable to connect" en formulario de login

**Diagnóstico**:
```bash
vagrant ssh adminer

# Probar conectividad desde Adminer VM
telnet 192.168.56.10 3306  # MariaDB
telnet 192.168.56.11 5432  # PostgreSQL
```

**Solución** (No hay ruta):
```bash
# Verificar tabla de rutas
route -n
# Debe haber ruta a 192.168.56.0/24

# Agregar si no existe
sudo ip route add 192.168.56.0/24 dev enp0s8
```

**Solución** (Firewall en DB VMs):
Verificar que MariaDB/PostgreSQL aceptan conexiones remotas (ver Sección 6).

### Problema 7.4: Timeout al ejecutar queries grandes

**Síntomas**: Query se detiene después de 30 segundos

**Solución** en VM Adminer:
```bash
sudo nano /etc/php/7.4/apache2/php.ini

# Aumentar límites
max_execution_time = 600
max_input_time = 600
memory_limit = 512M

sudo systemctl restart apache2
```

## Sección 8: Performance y Recursos

### Problema 8.1: VMs consumen mucha RAM

**Síntomas**: Sistema host lento, uso alto de memoria

**Diagnóstico**:
```powershell
# Ver uso de memoria por VM
Get-Process | Where-Object {$_.Name -like "*VBoxHeadless*"} | Select-Object Name, WorkingSet64
```

**Solución temporal**:
```powershell
# Detener VMs no usadas
vagrant halt mariadb
vagrant halt postgresql
# Mantener solo adminer si es necesario
```

**Solución permanente** (Reducir memoria asignada):
Editar Vagrantfile:
```ruby
# MariaDB
mariadb.vm.provider "virtualbox" do |vb|
  vb.memory = 1024  # Reducir de 2048
end

# PostgreSQL
postgresql.vm.provider "virtualbox" do |vb|
  vb.memory = 1024  # Reducir de 2048
end
```

Aplicar cambios:
```powershell
vagrant reload
```

### Problema 8.2: Disco lleno en VM

**Síntomas**:
```bash
-bash: cannot create temp file: No space left on device
```

**Diagnóstico**:
```bash
vagrant ssh [vm]
df -h
```

**Solución 1** (Limpiar apt cache):
```bash
sudo apt-get clean
sudo apt-get autoclean
sudo apt-get autoremove
```

**Solución 2** (Limpiar logs):
```bash
sudo journalctl --vacuum-time=3d
sudo find /var/log -type f -name "*.log" -mtime +7 -delete
```

**Solución 3** (Aumentar disco):
```powershell
# Aumentar tamaño de disco (requiere recrear VM)
vagrant destroy -f [vm]
# Editar Vagrantfile para aumentar disk size
vagrant up [vm]
```

### Problema 8.3: Vagrant commands muy lentos

**Síntomas**: `vagrant status` tarda 10+ segundos

**Causa 1**: Muchas VMs en el sistema

**Solución**:
```powershell
# Limpiar VMs obsoletas
VBoxManage list vms
# Eliminar las que no uses

# Limpiar metadata de Vagrant
Remove-Item $env:USERPROFILE\.vagrant.d\data\machine-index\index.lock
```

**Causa 2**: Antivirus escaneando archivos de Vagrant

**Solución**:
Agregar exclusiones en antivirus:
- C:\HashiCorp\Vagrant
- $USERPROFILE\.vagrant.d
- Directorio del proyecto

### Problema 8.4: CPU al 100% constante

**Síntomas**: VBoxHeadless consume mucho CPU

**Diagnóstico en VM**:
```bash
vagrant ssh [vm]
top
# Ver qué proceso consume CPU
```

**Solución común** (Servicios no optimizados):
```bash
# Si es PostgreSQL
sudo -u postgres psql
ALTER SYSTEM SET shared_buffers = '128MB';
ALTER SYSTEM SET effective_cache_size = '256MB';
SELECT pg_reload_conf();

# Si es MariaDB
sudo mysql -u root -p'rootpass123'
SET GLOBAL innodb_buffer_pool_size = 134217728;  -- 128MB
```

## Script de Diagnóstico General

Guardar como `diagnose.ps1`:

```powershell
Write-Host "IACT DevBox Diagnostic Tool" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# 1. Vagrant
Write-Host "1. Vagrant Status:" -ForegroundColor Yellow
vagrant --version
vagrant plugin list | Select-String "goodhosts"
vagrant status | Select-String "running"

# 2. Network
Write-Host "`n2. Network Connectivity:" -ForegroundColor Yellow
Test-Connection -ComputerName 192.168.56.10 -Count 1 -Quiet
Test-Connection -ComputerName 192.168.56.11 -Count 1 -Quiet
Test-Connection -ComputerName 192.168.56.12 -Count 1 -Quiet
Test-Connection -ComputerName adminer.devbox -Count 1 -Quiet

# 3. PowerShell Config
Write-Host "`n3. PowerShell Configuration:" -ForegroundColor Yellow
Write-Host "Profile exists: $(Test-Path $PROFILE)"
Write-Host "SSH Path: $((Get-Command ssh).Source)"
Write-Host "VAGRANT_LOG_LEVEL: $env:VAGRANT_LOG_LEVEL"

# 4. Certificates
Write-Host "`n4. SSL Certificates:" -ForegroundColor Yellow
Write-Host "CA exists: $(Test-Path 'config\certs\ca\ca.crt')"
Write-Host "Adminer cert exists: $(Test-Path 'config\certs\adminer.crt')"
$ca = Get-ChildItem -Path Cert:\LocalMachine\Root | Where-Object {$_.Subject -like "*IACT DevBox*"}
Write-Host "CA installed in Windows: $($ca -ne $null)"

# 5. Services
Write-Host "`n5. Service Ports:" -ForegroundColor Yellow
Write-Host "MariaDB (3306): $((Test-NetConnection -ComputerName 192.168.56.10 -Port 3306 -WarningAction SilentlyContinue).TcpTestSucceeded)"
Write-Host "PostgreSQL (5432): $((Test-NetConnection -ComputerName 192.168.56.11 -Port 5432 -WarningAction SilentlyContinue).TcpTestSucceeded)"
Write-Host "Adminer HTTP (80): $((Test-NetConnection -ComputerName 192.168.56.12 -Port 80 -WarningAction SilentlyContinue).TcpTestSucceeded)"
Write-Host "Adminer HTTPS (443): $((Test-NetConnection -ComputerName 192.168.56.12 -Port 443 -WarningAction SilentlyContinue).TcpTestSucceeded)"

Write-Host "`nDiagnostic complete." -ForegroundColor Green
```

---

Documento generado: 2026-01-10
Sistema: IACT DevBox v2.1.0
Tipo: Guía de troubleshooting consolidada
Cobertura: 8 áreas principales, 30+ problemas documentados
