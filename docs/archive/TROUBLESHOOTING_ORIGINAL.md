# IACT DevBox - Troubleshooting

Soluciones a problemas comunes con IACT DevBox. Todos los problemas listados aquí han sido verificados en el sistema.

## Diagnóstico General

Antes de cualquier troubleshooting específico, ejecuta el diagnóstico completo:

```powershell
.\scripts\diagnose-system.ps1
```

Este script detecta automáticamente los problemas más comunes y sugiere soluciones.

## Problema #1: Ghost Network Adapters

### Síntomas

- Error al hacer `ping 192.168.56.10/11/12`:
  ```
  Request timed out.
  Packets: Sent = 4, Received = 0, Lost = 4 (100% loss)
  ```

- Error de conexión a bases de datos:
  ```
  ERROR 2003 (HY000): Can't connect to MySQL server on '192.168.56.10' (10060)
  ```

- `diagnose-system.ps1` reporta:
  ```
  [FAIL] PROBLEMA: Multiples adaptadores Host-Only detectados (5)
  [WARN] Esto causa el problema de Ghost Network Adapters
  ```

### Causa

VirtualBox crea múltiples adaptadores Host-Only numerados (#2, #3, #4, #5) que causan conflictos de enrutamiento de red.

### Solución Verificada

```powershell
# 1. Detener VMs
vagrant halt

# 2. Ejecutar fix-network.ps1
.\scripts\fix-network.ps1

# Esto eliminará los adaptadores numerados y dejará solo uno
# El script pide confirmación antes de eliminar

# 3. Reiniciar VMs
vagrant up

# 4. Verificar
.\scripts\verify-vms.ps1
ping 192.168.56.10
```

**Resultado esperado:**
```
[OK] EXITO: Configuracion ideal alcanzada
[OK] 1 adaptador con IP correcta (192.168.56.1)
```

### Prevención

Ejecutar `check-prerequisites.ps1` ANTES de `vagrant up` para detectar el problema temprano.

## Problema #2: VMs No Arrancan

### Síntomas

- `vagrant up` falla con error de VirtualBox
- VMs quedan en estado "aborted" o "poweroff"
- Error: `VBoxManage: error: Failed to open/create the internal network`

### Causa Común

RAM insuficiente o conflicto de puertos.

### Solución

**Paso 1: Verificar RAM**

```powershell
.\scripts\check-prerequisites.ps1
```

Si reporta:
```
[WARN] RAM Disponible: BAJA (1.18 GB)
```

Cierra aplicaciones para liberar RAM. Las VMs necesitan:
- MariaDB: 2 GB
- PostgreSQL: 2 GB
- Adminer: 1 GB

**Paso 2: Verificar puertos**

```powershell
# Ver qué está usando los puertos
Get-NetTCPConnection -LocalPort 3306,5432,80,443 -ErrorAction SilentlyContinue | 
  ForEach-Object {
    $proc = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue
    "Puerto $($_.LocalPort): $($proc.ProcessName)"
  }
```

Si hay conflictos, detén los procesos o cambia la configuración de puertos en el `Vagrantfile`.

**Paso 3: Reset completo**

```powershell
vagrant destroy -f
vagrant up
```

## Problema #3: Perfil de Red en PUBLIC

### Síntomas

- `diagnose-system.ps1` reporta:
  ```
  [WARN] Adaptador VirtualBox en perfil PUBLIC
  [INFO] El firewall de Windows puede bloquear puertos
  ```

- Puertos 3306, 5432, 80, 443 no son accesibles

### Solución

Cambiar el perfil de red a PRIVATE:

```powershell
# Ver adaptadores
Get-NetConnectionProfile | Where-Object { $_.InterfaceAlias -like "*VirtualBox*" }

# Cambiar a PRIVATE
Set-NetConnectionProfile -InterfaceAlias "VirtualBox Host-Only Network" -NetworkCategory Private
```

## Problema #4: Provisioning Incompleto

### Síntomas

- `vagrant up` termina pero las bases de datos no están disponibles
- `verify-vms.ps1` reporta:
  ```
  [WARN] mariadb provision incompleto o con errores
  ```

### Diagnóstico

```powershell
# Ver logs de provisioning
Get-Content logs\mariadb_bootstrap.log | Select-String "ERROR"
Get-Content logs\postgres_bootstrap.log | Select-String "ERROR"
Get-Content logs\adminer_bootstrap.log | Select-String "ERROR"
```

### Solución

```powershell
# Re-ejecutar provisioning
vagrant reload --provision
```

Si persiste el error, revisar los logs detallados en `logs/` para identificar el problema específico.

## Problema #5: Problemas con MariaDB/MySQL

### No Puedo Conectarme a MariaDB

**Síntomas:**
```
ERROR 2003 (HY000): Can't connect to MySQL server on '192.168.56.10' (10060)
ERROR 1045 (28000): Access denied for user 'root'@'192.168.56.1'
```

**Diagnóstico:**

```powershell
# Verificar que VM está corriendo
vagrant status mariadb

# Verificar conectividad
Test-NetConnection -ComputerName 192.168.56.10 -Port 3306

# Ver logs de MariaDB
vagrant ssh mariadb -c "sudo tail -50 /var/log/mysql/error.log"
```

**Soluciones:**

**Problema 1: Puerto no accesible**

```powershell
vagrant ssh mariadb

# Verificar que MariaDB está corriendo
sudo systemctl status mariadb

# Reiniciar si es necesario
sudo systemctl restart mariadb

# Verificar bind-address
sudo grep bind-address /etc/mysql/mariadb.conf.d/50-server.cnf
# Debería mostrar: bind-address = 0.0.0.0
```

**Problema 2: Usuario no tiene permisos**

```bash
vagrant ssh mariadb

# Conectar como root local
sudo mysql -u root

# Ver usuarios
SELECT user, host FROM mysql.user;

# Crear/actualizar usuario
CREATE USER IF NOT EXISTS 'django_user'@'%' IDENTIFIED BY 'django_pass';
GRANT ALL PRIVILEGES ON ivr_legacy.* TO 'django_user'@'%';
FLUSH PRIVILEGES;
```

**Problema 3: Firewall bloqueando**

```bash
vagrant ssh mariadb

# Verificar firewall
sudo ufw status
# Debería estar: inactive

# Si está activo, permitir puerto
sudo ufw allow 3306/tcp
```

### Base de Datos No Existe

```bash
vagrant ssh mariadb
sudo mysql -u root

# Ver bases de datos
SHOW DATABASES;

# Crear base si no existe
CREATE DATABASE IF NOT EXISTS ivr_legacy CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### Resetear Contraseña de Root

```bash
vagrant ssh mariadb

# Detener MariaDB
sudo systemctl stop mariadb

# Iniciar en modo seguro
sudo mysqld_safe --skip-grant-tables &

# En otra terminal
sudo mysql -u root

# Cambiar contraseña
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY 'rootpass123';
FLUSH PRIVILEGES;
exit

# Reiniciar normalmente
sudo killall mysqld
sudo systemctl start mariadb
```

### MariaDB Lento o No Responde

```bash
vagrant ssh mariadb

# Ver procesos activos
sudo mysql -u root -p'rootpass123' -e "SHOW PROCESSLIST;"

# Ver conexiones
sudo mysql -u root -p'rootpass123' -e "SHOW STATUS LIKE 'Threads_connected';"

# Matar proceso problemático
sudo mysql -u root -p'rootpass123' -e "KILL <process_id>;"
```

## Problema #6: Problemas con PostgreSQL

### No Puedo Conectarme a PostgreSQL

**Síntomas:**
```
psql: error: could not connect to server: Connection timed out
psql: FATAL: password authentication failed for user "postgres"
```

**Diagnóstico:**

```powershell
# Verificar VM
vagrant status postgresql

# Verificar puerto
Test-NetConnection -ComputerName 192.168.56.11 -Port 5432

# Ver logs
vagrant ssh postgresql -c "sudo tail -50 /var/log/postgresql/postgresql-16-main.log"
```

**Soluciones:**

**Problema 1: PostgreSQL no está escuchando**

```bash
vagrant ssh postgresql

# Verificar servicio
sudo systemctl status postgresql

# Reiniciar
sudo systemctl restart postgresql

# Verificar configuración de escucha
sudo grep listen_addresses /etc/postgresql/16/main/postgresql.conf
# Debería ser: listen_addresses = '*'
```

**Problema 2: pg_hba.conf no permite conexiones**

```bash
vagrant ssh postgresql

# Ver configuración de autenticación
sudo cat /etc/postgresql/16/main/pg_hba.conf

# Debería tener esta línea al final:
# host    all    all    192.168.56.0/24    md5

# Si no está, agregar:
sudo bash -c 'echo "host    all    all    192.168.56.0/24    md5" >> /etc/postgresql/16/main/pg_hba.conf'

# Recargar configuración
sudo systemctl reload postgresql
```

**Problema 3: Usuario no existe o contraseña incorrecta**

```bash
vagrant ssh postgresql

# Conectar como postgres local
sudo -u postgres psql

# Ver usuarios
\du

# Crear usuario si no existe
CREATE USER django_user WITH PASSWORD 'django_pass';

# Cambiar contraseña
ALTER USER django_user WITH PASSWORD 'django_pass';

# Dar permisos
GRANT ALL PRIVILEGES ON DATABASE iact_analytics TO django_user;

\q
```

### Base de Datos No Existe

```bash
vagrant ssh postgresql
sudo -u postgres psql

# Ver bases de datos
\l

# Crear base
CREATE DATABASE iact_analytics OWNER django_user ENCODING 'UTF8';

\q
```

### Resetear Contraseña de postgres

```bash
vagrant ssh postgresql

# Editar pg_hba.conf temporalmente
sudo sed -i 's/md5/trust/g' /etc/postgresql/16/main/pg_hba.conf

# Recargar
sudo systemctl reload postgresql

# Cambiar contraseña
psql -U postgres -c "ALTER USER postgres WITH PASSWORD 'postgrespass123';"

# Restaurar md5
sudo sed -i 's/trust/md5/g' /etc/postgresql/16/main/pg_hba.conf

# Recargar
sudo systemctl reload postgresql
```

### PostgreSQL Lento

```bash
vagrant ssh postgresql
sudo -u postgres psql

-- Ver conexiones activas
SELECT pid, usename, datname, state, query 
FROM pg_stat_activity 
WHERE state != 'idle';

-- Matar proceso problemático
SELECT pg_terminate_backend(<pid>);

-- Ver estadísticas de tablas
SELECT * FROM pg_stat_user_tables;
```

## Problema #7: Configurar HTTPS para Adminer

### Adminer HTTPS No Funciona

**Síntomas:**
- `https://192.168.56.12` no carga
- Browser muestra error de certificado
- `verify-vms.ps1` reporta:
  ```
  [WARN] Adminer HTTPS no accesible (normal si SSL no configurado)
  ```

**Solución: Ya Está Configurado (Certificado Autofirmado)**

IACT DevBox ya incluye HTTPS con certificado autofirmado. El warning es normal porque el browser no confía en el certificado.

**Para acceder:**

1. Ir a: `https://192.168.56.12`
2. El browser mostrará warning de seguridad
3. Hacer click en "Avanzado" → "Continuar al sitio (no seguro)"
4. Adminer cargará con HTTPS

**Verificar que SSL está activo:**

```bash
vagrant ssh adminer

# Ver si Apache SSL está habilitado
sudo apache2ctl -M | grep ssl
# Debería mostrar: ssl_module (shared)

# Ver sitio SSL habilitado
ls -la /etc/apache2/sites-enabled/
# Debería mostrar: adminer-ssl.conf

# Ver logs de SSL
sudo tail -50 /var/log/apache2/error.log
```

**Regenerar Certificado SSL (si es necesario):**

```bash
vagrant ssh adminer

# Generar nuevo certificado autofirmado
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/adminer-selfsigned.key \
  -out /etc/ssl/certs/adminer-selfsigned.crt \
  -subj "/C=MX/ST=Estado/L=Ciudad/O=IACT/OU=DevBox/CN=192.168.56.12"

# Reiniciar Apache
sudo systemctl restart apache2
```

**Usar Certificado Válido (Producción):**

Si necesitas un certificado válido para desarrollo interno:

```bash
vagrant ssh adminer

# Copiar certificados desde host
# Coloca tus archivos .crt y .key en config/ssl/

# Copiar a ubicación SSL
sudo cp /vagrant/config/ssl/adminer.crt /etc/ssl/certs/
sudo cp /vagrant/config/ssl/adminer.key /etc/ssl/private/

# Actualizar configuración
sudo nano /etc/apache2/sites-available/adminer-ssl.conf

# Cambiar las líneas:
SSLCertificateFile /etc/ssl/certs/adminer.crt
SSLCertificateKeyFile /etc/ssl/private/adminer.key

# Reiniciar
sudo systemctl restart apache2
```

**Deshabilitar HTTPS (solo HTTP):**

Si no necesitas HTTPS:

```bash
vagrant ssh adminer

# Deshabilitar sitio SSL
sudo a2dissite adminer-ssl.conf

# Reiniciar Apache
sudo systemctl restart apache2
```

Ahora solo funcionará `http://192.168.56.12`

**Redirigir HTTP → HTTPS:**

Si quieres forzar HTTPS:

```bash
vagrant ssh adminer

# Editar sitio HTTP
sudo nano /etc/apache2/sites-available/adminer.conf

# Agregar dentro de <VirtualHost>:
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]

# Habilitar rewrite
sudo a2enmod rewrite

# Reiniciar
sudo systemctl restart apache2
```

## Problema #8: Adminer HTTP No Accesible

### Síntomas

- `http://192.168.56.12` no carga
- Browser muestra "This site can't be reached"

### Diagnóstico

```powershell
# Verificar que VM está corriendo
vagrant status adminer

# Verificar puerto 80
Test-NetConnection -ComputerName 192.168.56.12 -Port 80

# Ver logs de Apache
vagrant ssh adminer -c "sudo tail -50 /var/log/apache2/error.log"
```

### Soluciones

**Solución 1: Reiniciar Apache**

```powershell
vagrant ssh adminer -c "sudo systemctl restart apache2"
```

**Solución 2: Verificar firewall**

```powershell
vagrant ssh adminer -c "sudo ufw status"
# Debería mostrar: Status: inactive
```

**Solución 3: Reload VM**

```powershell
vagrant reload adminer
```

## Problema #9: Error de SSH

### Síntomas

- `vagrant ssh mariadb` falla
- Error: `Connection timeout`

### Solución

```powershell
# Ver estado detallado
vagrant status

# Si VM está running pero SSH no funciona
vagrant reload mariadb
```

## Generar Reporte para Soporte

Si ninguna solución funciona, genera un bundle de diagnóstico completo:

```powershell
.\scripts\generate-support-bundle.ps1 -IncludeLogs -IncludeVagrantfile
```

Esto creará un archivo `support-bundle_TIMESTAMP.zip` con toda la información del sistema.

## Comandos de Diagnóstico Útiles

```powershell
# Ver todos los adaptadores VirtualBox
VBoxManage list hostonlyifs

# Ver VMs de VirtualBox
VBoxManage list vms
VBoxManage list runningvms

# Logs detallados de Vagrant
$env:VAGRANT_LOG="debug"
vagrant up

# Ver procesos de VirtualBox
Get-Process | Where-Object { $_.Name -like "*VBox*" }

# Reiniciar servicios de VirtualBox (como admin)
net stop vboxdrv
net start vboxdrv
```

## Problemas Conocidos No Resueltos

Ninguno hasta la fecha.

Si encuentras un problema no listado aquí, genera un support bundle y repórtalo al equipo.

---

**Última actualización**: 2026-01-10
