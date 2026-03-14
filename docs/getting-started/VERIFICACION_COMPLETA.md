# Verificación Completa del Sistema IACT DevBox

Checklist exhaustivo para verificar que todas las VMs, servicios y configuraciones del proyecto IACT DevBox funcionan correctamente.

## Información General

Este documento proporciona un conjunto estructurado de verificaciones para confirmar la correcta instalación y funcionamiento de:
- 3 VMs (MariaDB, PostgreSQL, Adminer)
- Networking (host-only network)
- SSH access
- Servicios de base de datos
- Servidor web y SSL
- Dominio adminer.devbox
- Certificados SSL

## Requisitos Previos

Antes de comenzar las verificaciones:

```powershell
# 1. Estar en el directorio del proyecto
cd D:\Estadia_IACT\proyecto\IACT\db

# 2. PowerShell debe tener configuración correcta
$env:PATH -like "*Git\usr\bin*"
# Debe retornar: True

# 3. Variable Vagrant configurada
$env:VAGRANT_LOG_LEVEL
# Debe mostrar: INFO
```

## Sección 1: Estado de las VMs

### 1.1 Verificar Estado General

```powershell
vagrant status
```

**Salida esperada**:
```
Current machine states:

mariadb                   running (virtualbox)
postgresql                running (virtualbox)
adminer                   running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state.
```

**Criterio de éxito**: Las 3 VMs muestran estado "running"

### 1.2 Verificar Versión de Box

```powershell
vagrant box list
```

**Salida esperada**:
```
ubuntu/focal64 (virtualbox, 20240821.0.1)
```

### 1.3 Verificar Plugins

```powershell
vagrant plugin list
```

**Salida esperada debe incluir**:
```
vagrant-goodhosts (1.1.8, global)
```

## Sección 2: Conectividad de Red

### 2.1 Ping a IPs Estáticas

```powershell
# MariaDB
ping -n 4 192.168.56.10

# PostgreSQL
ping -n 4 192.168.56.11

# Adminer
ping -n 4 192.168.56.12
```

**Criterio de éxito**: Respuesta exitosa de las 3 IPs con tiempo < 5ms

**Salida esperada (ejemplo)**:
```
Haciendo ping a 192.168.56.10 con 32 bytes de datos:
Respuesta desde 192.168.56.10: bytes=32 tiempo<1ms TTL=64
...
Paquetes: enviados = 4, recibidos = 4, perdidos = 0 (0% perdidos)
```

### 2.2 Verificar Resolución DNS (adminer.devbox)

```powershell
ping adminer.devbox
```

**Criterio de éxito**: Resuelve a 192.168.56.12 y responde

**Salida esperada**:
```
Haciendo ping a adminer.devbox [192.168.56.12] con 32 bytes de datos:
Respuesta desde 192.168.56.12: bytes=32 tiempo<1ms TTL=64
```

Si falla, verificar archivo hosts:
```powershell
Get-Content C:\Windows\System32\drivers\etc\hosts | Select-String "adminer"
```

Debe mostrar:
```
192.168.56.12	adminer.devbox
192.168.56.12	www.adminer.devbox
```

### 2.3 Verificar Puertos Abiertos

```powershell
# MariaDB
Test-NetConnection -ComputerName 192.168.56.10 -Port 3306

# PostgreSQL
Test-NetConnection -ComputerName 192.168.56.11 -Port 5432

# Adminer HTTP
Test-NetConnection -ComputerName 192.168.56.12 -Port 80

# Adminer HTTPS
Test-NetConnection -ComputerName 192.168.56.12 -Port 443
```

**Criterio de éxito**: Todos muestran `TcpTestSucceeded: True`

## Sección 3: Acceso SSH

### 3.1 SSH a MariaDB

```powershell
vagrant ssh mariadb
```

**Dentro de la VM**:
```bash
# Verificar hostname
hostname
# Debe mostrar: iact-mariadb

# Verificar IP
ip addr show enp0s8 | grep inet
# Debe mostrar: inet 192.168.56.10/24

# Verificar MariaDB corriendo
sudo systemctl status mariadb
# Debe mostrar: active (running)

# Salir
exit
```

### 3.2 SSH a PostgreSQL

```powershell
vagrant ssh postgresql
```

**Dentro de la VM**:
```bash
# Verificar hostname
hostname
# Debe mostrar: iact-postgres

# Verificar IP
ip addr show enp0s8 | grep inet
# Debe mostrar: inet 192.168.56.11/24

# Verificar PostgreSQL corriendo
sudo systemctl status postgresql
# Debe mostrar: active (running)

# Salir
exit
```

### 3.3 SSH a Adminer

```powershell
vagrant ssh adminer
```

**Dentro de la VM**:
```bash
# Verificar hostname
hostname
# Debe mostrar: adminer (sin .devbox - es normal en SSH)

# Verificar IP
ip addr show enp0s8 | grep inet
# Debe mostrar: inet 192.168.56.12/24

# Verificar Apache corriendo
sudo systemctl status apache2
# Debe mostrar: active (running)

# Verificar puertos escuchando
sudo netstat -tlnp | grep -E ":(80|443)"
# Debe mostrar apache2 en ambos puertos

# Salir
exit
```

## Sección 4: Servicios de Base de Datos

### 4.1 MariaDB

**Test de conectividad**:
```powershell
mysql -h 192.168.56.10 -u root -p'rootpass123' -e "SELECT VERSION();"
```

**Salida esperada**:
```
+------------------+
| VERSION()        |
+------------------+
| 11.4.7-MariaDB   |
+------------------+
```

**Test de base de datos**:
```powershell
mysql -h 192.168.56.10 -u django_user -p'django_pass' -D ivr_legacy -e "SHOW TABLES;"
```

**Test de permisos**:
```powershell
mysql -h 192.168.56.10 -u django_user -p'django_pass' -D ivr_legacy -e "CREATE TABLE test_table (id INT); DROP TABLE test_table;"
```

**Criterio de éxito**: Todas las queries ejecutan sin error

### 4.2 PostgreSQL

**Test de conectividad**:
```powershell
$env:PGPASSWORD='postgrespass123'
psql -h 192.168.56.11 -U postgres -c "SELECT version();"
```

**Salida esperada**:
```
PostgreSQL 16.9 on x86_64-pc-linux-gnu...
```

**Test de base de datos**:
```powershell
$env:PGPASSWORD='django_pass'
psql -h 192.168.56.11 -U django_user -d iact_analytics -c "\dt"
```

**Test de permisos**:
```powershell
$env:PGPASSWORD='django_pass'
psql -h 192.168.56.11 -U django_user -d iact_analytics -c "CREATE TABLE test_table (id INT); DROP TABLE test_table;"
```

**Test de extensiones**:
```powershell
$env:PGPASSWORD='django_pass'
psql -h 192.168.56.11 -U django_user -d iact_analytics -c "SELECT * FROM pg_extension;"
```

Debe mostrar:
- uuid-ossp
- pg_trgm
- hstore
- citext
- pg_stat_statements

**Criterio de éxito**: Todas las queries ejecutan sin error, extensiones instaladas

## Sección 5: Adminer Web Interface

### 5.1 Verificar HTTP

```powershell
# Test con curl
Invoke-WebRequest -Uri "http://192.168.56.12" -UseBasicParsing

# O abrir en navegador
Start-Process "http://192.168.56.12"
```

**Criterio de éxito**: 
- StatusCode: 200
- Content-Type: text/html
- Página de login de Adminer visible

### 5.2 Verificar HTTP con Dominio

```powershell
Start-Process "http://adminer.devbox"
```

**Criterio de éxito**: Misma página que con IP

### 5.3 Verificar HTTPS

```powershell
# Con dominio
Start-Process "https://adminer.devbox"

# Con IP
Start-Process "https://192.168.56.12"
```

**IMPORTANTE**: Si el certificado CA no está instalado, aparecerá advertencia de seguridad (normal).

**Criterio de éxito**: Página carga (advertencia de certificado es aceptable si CA no instalado)

### 5.4 Verificar Contenido de Adminer

En el navegador (http://adminer.devbox o https://adminer.devbox):

1. Debe mostrar formulario de login con:
   - System: [Dropdown: MySQL, PostgreSQL, SQLite, etc.]
   - Server: [Input field]
   - Username: [Input field]
   - Password: [Input field]
   - Database: [Input field]

2. Verificar versión en footer: Adminer 4.8.1

## Sección 6: Certificados SSL

### 6.1 Verificar Generación de Certificados

```powershell
# Verificar directorio de certificados
Test-Path D:\Estadia_IACT\proyecto\IACT\db\config\certs\ca\ca.crt
Test-Path D:\Estadia_IACT\proyecto\IACT\db\config\certs\ca\ca.key
Test-Path D:\Estadia_IACT\proyecto\IACT\db\config\certs\adminer.crt
Test-Path D:\Estadia_IACT\proyecto\IACT\db\config\certs\adminer.key
```

**Criterio de éxito**: Todos retornan `True`

### 6.2 Verificar Detalles del Certificado

```powershell
# SSH a Adminer
vagrant ssh adminer

# Ver certificado
openssl x509 -in /vagrant/config/certs/adminer.crt -text -noout | grep -A 5 "Subject:"
```

**Debe mostrar**:
```
Subject: C = MX, ST = Estado, L = Ciudad, O = IACT DevBox, OU = Development, CN = 192.168.56.12
Issuer: C = MX, ST = Estado, L = Ciudad, O = IACT DevBox, OU = Development, CN = IACT DevBox Root CA
```

### 6.3 Verificar SAN (Subject Alternative Names)

```bash
# Dentro de VM Adminer
openssl x509 -in /vagrant/config/certs/adminer.crt -text -noout | grep -A 3 "Subject Alternative Name"
```

**Debe mostrar**:
```
X509v3 Subject Alternative Name:
    IP Address:192.168.56.12, DNS:adminer.devbox, DNS:localhost
```

### 6.4 Verificar Instalación de CA en Windows

```powershell
Get-ChildItem -Path Cert:\LocalMachine\Root | Where-Object {$_.Subject -like "*IACT DevBox*"}
```

**Si CA instalada, debe mostrar**:
```
Thumbprint                                Subject
----------                                -------
[hash]                                    CN=IACT DevBox Root CA...
```

**Si no muestra nada**: CA no instalada (ver INSTALAR_CA_WINDOWS.md)

### 6.5 Test de Certificado en Navegador

Abrir: https://adminer.devbox

**Si CA instalada**:
- Candado verde en barra de direcciones
- Sin advertencias de seguridad
- Certificado válido visible

**Si CA NO instalada**:
- Advertencia de certificado
- "No segura" en barra de direcciones
- Esto es NORMAL - instalar CA para eliminar advertencia

## Sección 7: Vagrant Goodhosts

### 7.1 Verificar Plugin Instalado

```powershell
vagrant plugin list | Select-String "goodhosts"
```

**Debe mostrar**:
```
vagrant-goodhosts (1.1.8, global)
```

### 7.2 Verificar Entradas en Hosts File

```powershell
Get-Content C:\Windows\System32\drivers\etc\hosts | Select-String -Pattern "vagrant-goodhosts" -Context 0,3
```

**Debe mostrar algo como**:
```
## vagrant-goodhosts-adminer-[hash] START
192.168.56.12	adminer.devbox
192.168.56.12	www.adminer.devbox
## vagrant-goodhosts-adminer-[hash] END
```

### 7.3 Test de Actualización Automática

```powershell
# Destruir y recrear Adminer
vagrant destroy -f adminer
vagrant up adminer

# Verificar que las entradas se regeneran
Get-Content C:\Windows\System32\drivers\etc\hosts | Select-String "adminer.devbox"
```

**Criterio de éxito**: Entradas se recrean automáticamente

## Sección 8: Logs y Diagnósticos

### 8.1 Verificar Directorios de Logs

```powershell
Test-Path D:\Estadia_IACT\proyecto\IACT\db\logs\mariadb
Test-Path D:\Estadia_IACT\proyecto\IACT\db\logs\postgresql
Test-Path D:\Estadia_IACT\proyecto\IACT\db\logs\adminer
```

**Criterio de éxito**: Todos retornan `True`

### 8.2 Ver Últimos Logs de Provisioning

```powershell
# MariaDB
Get-ChildItem D:\Estadia_IACT\proyecto\IACT\db\logs\mariadb | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# PostgreSQL
Get-ChildItem D:\Estadia_IACT\proyecto\IACT\db\logs\postgresql | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# Adminer
Get-ChildItem D:\Estadia_IACT\proyecto\IACT\db\logs\adminer | Sort-Object LastWriteTime -Descending | Select-Object -First 1
```

### 8.3 Verificar Logs de Apache en Adminer

```powershell
vagrant ssh adminer
```

```bash
# Logs de error
sudo tail -20 /var/log/apache2/adminer-error.log
sudo tail -20 /var/log/apache2/adminer-ssl-error.log

# Logs de acceso
sudo tail -20 /var/log/apache2/adminer-access.log
sudo tail -20 /var/log/apache2/adminer-ssl-access.log
```

**Criterio de éxito**: No deben haber errores críticos recientes

## Sección 9: Configuración de PowerShell

### 9.1 Verificar Perfil Existe

```powershell
Test-Path $PROFILE
```

**Debe retornar**: True

### 9.2 Verificar Contenido del Perfil

```powershell
Get-Content $PROFILE
```

**Debe incluir**:
```powershell
# SSH de Git en PATH
$env:PATH = "C:\Program Files\Git\usr\bin;$env:PATH"

# Workaround Vagrant 2.4.7 bug
$env:VAGRANT_LOG_LEVEL = "INFO"
```

### 9.3 Verificar Variables Activas

```powershell
# PATH incluye Git SSH
$env:PATH -like "*Git\usr\bin*"
# Debe retornar: True

# Variable de Vagrant
$env:VAGRANT_LOG_LEVEL
# Debe mostrar: INFO

# SSH correcto
(Get-Command ssh).Source
# Debe mostrar: C:\Program Files\Git\usr\bin\ssh.exe
```

## Sección 10: Test de Integración

### 10.1 Test Completo de MariaDB vía Adminer

1. Abrir: http://adminer.devbox
2. Configurar conexión:
   - System: MySQL
   - Server: 192.168.56.10
   - Username: django_user
   - Password: django_pass
   - Database: ivr_legacy
3. Click "Login"
4. Debe acceder sin errores
5. Verificar que muestra estructura de base de datos

### 10.2 Test Completo de PostgreSQL vía Adminer

1. Abrir: http://adminer.devbox
2. Configurar conexión:
   - System: PostgreSQL
   - Server: 192.168.56.11
   - Username: django_user
   - Password: django_pass
   - Database: iact_analytics
3. Click "Login"
4. Debe acceder sin errores
5. Verificar que muestra estructura de base de datos y extensiones

### 10.3 Test de Creación de Tabla

En Adminer (conectado a cualquier DB):

1. SQL command: 
```sql
CREATE TABLE verificacion_test (
    id INT PRIMARY KEY,
    nombre VARCHAR(100),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

2. Insertar dato:
```sql
INSERT INTO verificacion_test (id, nombre) VALUES (1, 'Test IACT DevBox');
```

3. Consultar:
```sql
SELECT * FROM verificacion_test;
```

4. Limpiar:
```sql
DROP TABLE verificacion_test;
```

**Criterio de éxito**: Todas las operaciones ejecutan correctamente

## Resumen de Verificación

### Checklist Rápido

```
[ ] Vagrant status - 3 VMs running
[ ] Ping a 192.168.56.10 (MariaDB)
[ ] Ping a 192.168.56.11 (PostgreSQL)
[ ] Ping a 192.168.56.12 (Adminer)
[ ] Ping a adminer.devbox
[ ] SSH a mariadb
[ ] SSH a postgresql
[ ] SSH a adminer
[ ] Conectar MariaDB con mysql CLI
[ ] Conectar PostgreSQL con psql CLI
[ ] Abrir http://adminer.devbox
[ ] Abrir https://adminer.devbox
[ ] Login en Adminer -> MariaDB
[ ] Login en Adminer -> PostgreSQL
[ ] Crear/eliminar tabla de prueba
[ ] Certificados SSL generados
[ ] CA instalada en Windows (opcional pero recomendado)
[ ] vagrant-goodhosts funcionando
[ ] Perfil PowerShell configurado
```

### Script de Verificación Automatizada

```powershell
# Guardar como: verify-iact-devbox.ps1

Write-Host "Verificando IACT DevBox..." -ForegroundColor Cyan

$checks = @{
    "Vagrant Status" = { (vagrant status | Select-String "running").Count -eq 3 }
    "MariaDB Ping" = { Test-Connection -ComputerName 192.168.56.10 -Count 1 -Quiet }
    "PostgreSQL Ping" = { Test-Connection -ComputerName 192.168.56.11 -Count 1 -Quiet }
    "Adminer Ping" = { Test-Connection -ComputerName 192.168.56.12 -Count 1 -Quiet }
    "Adminer Domain" = { Test-Connection -ComputerName adminer.devbox -Count 1 -Quiet }
    "MariaDB Port" = { (Test-NetConnection -ComputerName 192.168.56.10 -Port 3306).TcpTestSucceeded }
    "PostgreSQL Port" = { (Test-NetConnection -ComputerName 192.168.56.11 -Port 5432).TcpTestSucceeded }
    "Adminer HTTP" = { (Test-NetConnection -ComputerName 192.168.56.12 -Port 80).TcpTestSucceeded }
    "Adminer HTTPS" = { (Test-NetConnection -ComputerName 192.168.56.12 -Port 443).TcpTestSucceeded }
    "Certificates" = { Test-Path "config\certs\ca\ca.crt" }
    "PowerShell Profile" = { Test-Path $PROFILE }
    "Vagrant Plugin" = { (vagrant plugin list | Select-String "goodhosts").Count -gt 0 }
}

$passed = 0
$failed = 0

foreach ($check in $checks.GetEnumerator()) {
    try {
        $result = & $check.Value
        if ($result) {
            Write-Host "[OK] $($check.Name)" -ForegroundColor Green
            $passed++
        } else {
            Write-Host "[FAIL] $($check.Name)" -ForegroundColor Red
            $failed++
        }
    } catch {
        Write-Host "[ERROR] $($check.Name): $($_.Exception.Message)" -ForegroundColor Red
        $failed++
    }
}

Write-Host "`nResultados: $passed OK, $failed FAIL" -ForegroundColor $(if ($failed -eq 0) { "Green" } else { "Yellow" })
```

---

Documento generado: 2026-01-10
Sistema: IACT DevBox v2.1.0
Tipo: Checklist de verificación completa
VMs: 3 (MariaDB 11.4, PostgreSQL 16, Adminer 4.8.1)
