# Instalación del Certificado CA en Windows

Guía completa para instalar el certificado de la Certificate Authority (CA) de IACT DevBox en el almacén de certificados raíz de Windows, eliminando advertencias SSL en navegadores.

## Información General

**Objetivo**: Instalar el certificado CA raíz generado por ssl.sh en Windows para que todos los certificados firmados por esta CA sean automáticamente confiables.

**Resultado esperado**: 
- Acceso a https://adminer.devbox sin advertencias de seguridad
- Candado verde en la barra de direcciones del navegador
- Certificado válido emitido por "IACT DevBox Root CA"

**Requisitos**:
- Windows 10/11
- PowerShell 5.1 o superior
- Privilegios de administrador
- VMs levantadas con `vagrant up`

## Ubicación del Certificado

El certificado CA se genera automáticamente durante el provisioning de la VM Adminer:

```
D:\Estadia_IACT\proyecto\IACT\db\config\certs\ca\ca.crt
```

**Propiedades del certificado**:
- Tipo: X.509 Certificate Authority
- Válido por: 10 años
- Subject: CN=IACT DevBox Root CA, OU=Development, O=IACT DevBox
- Uso: Firma de certificados SSL para servicios internos

## Instalación con Script PowerShell

### Paso 1: Verificar Archivo CA

```powershell
cd D:\Estadia_IACT\proyecto\IACT\db

# Verificar que el certificado existe
Test-Path config\certs\ca\ca.crt

# Debe retornar: True
```

Si retorna False, ejecutar:

```powershell
vagrant provision adminer
```

### Paso 2: Ejecutar Script de Instalación

```powershell
# IMPORTANTE: PowerShell como Administrador
# Click derecho en PowerShell -> "Ejecutar como administrador"

cd D:\Estadia_IACT\proyecto\IACT\db\scripts

# Ejecutar instalador
.\install-ca-certificate.ps1
```

### Paso 3: Salida Esperada

```
======================================================================
  Installing IACT DevBox CA Certificate
======================================================================

[OK] Running as Administrator
[INFO] Looking for CA certificate...
[INFO] Path: D:\Estadia_IACT\proyecto\IACT\db\config\certs\ca\ca.crt
[OK] CA certificate file found

[INFO] Checking if certificate is already installed...
[INFO] Importing CA certificate to Trusted Root Certification Authorities...

Certificate information:
  Subject:    CN=IACT DevBox Root CA, OU=Development, O=IACT DevBox, L=Ciudad, ST=Estado, C=MX
  Issuer:     CN=IACT DevBox Root CA, OU=Development, O=IACT DevBox, L=Ciudad, ST=Estado, C=MX
  Valid from: 2026-01-10 13:43:31
  Valid to:   2036-01-08 13:43:31
  Thumbprint: [hash único]

[OK] Certificate installed successfully!
[INFO] Verifying installation...
[OK] Certificate verified in certificate store

==========================================
  Certificate Installation Complete!
==========================================

Next steps:
  1. Close all browser windows
  2. Restart your browsers
  3. Visit https://adminer.devbox

You should now see:
  - No SSL warnings
  - Green padlock in address bar
  - Valid certificate from 'IACT DevBox Root CA'
```

### Paso 4: Reiniciar Navegadores

IMPORTANTE: Es necesario reiniciar completamente los navegadores para que reconozcan el nuevo certificado:

**Chrome/Edge**:
1. Cerrar todas las ventanas del navegador
2. Abrir el Administrador de tareas (Ctrl+Shift+Esc)
3. Buscar procesos de Chrome/Edge y finalizarlos
4. Abrir navegador de nuevo

**Firefox**:
1. Cerrar todas las ventanas
2. Firefox usa su propio almacén de certificados (ver sección siguiente)

## Verificación de Instalación

### Verificar en Windows

```powershell
# Ver certificados instalados
Get-ChildItem -Path Cert:\LocalMachine\Root | Where-Object {$_.Subject -like "*IACT DevBox*"}
```

Debe mostrar:

```
Thumbprint                                Subject
----------                                -------
[hash]                                    CN=IACT DevBox Root CA, OU=Development, O=IACT DevBox...
```

### Verificar en Navegador

1. Abrir: https://adminer.devbox

2. Click en el candado en la barra de direcciones

3. Ver información del certificado:
   - Emitido para: 192.168.56.12 (o adminer.devbox)
   - Emitido por: IACT DevBox Root CA
   - Válido desde: [fecha de generación]
   - Válido hasta: [fecha + 365 días]

4. Verificar Subject Alternative Names (SAN):
   - IP Address: 192.168.56.12
   - DNS Name: adminer.devbox
   - DNS Name: localhost

### Verificar con PowerShell

```powershell
# Test SSL sin warnings
$result = Invoke-WebRequest -Uri "https://adminer.devbox" -UseBasicParsing

# Si funciona correctamente, no habrá errores de certificado
$result.StatusCode
# Debe retornar: 200
```

## Instalación Manual (Sin Script)

Si prefieres instalar manualmente o el script falla:

### Método 1: certmgr.msc (GUI)

1. Abrir certmgr.msc como Administrador:
   ```powershell
   Start-Process certmgr.msc -Verb RunAs
   ```

2. Navegar a: Certificados (Equipo local) > Entidades de certificación raíz de confianza > Certificados

3. Click derecho en "Certificados" > Todas las tareas > Importar

4. Seleccionar archivo: `D:\Estadia_IACT\proyecto\IACT\db\config\certs\ca\ca.crt`

5. Almacén: Entidades de certificación raíz de confianza

6. Finalizar

### Método 2: certutil (Línea de Comandos)

```powershell
# Como Administrador
cd D:\Estadia_IACT\proyecto\IACT\db

certutil -addstore -f "Root" config\certs\ca\ca.crt
```

Salida esperada:
```
Root "Entidades de certificación raíz de confianza"
Firma correcta
CertUtil: -addstore comando completado correctamente.
```

## Configuración Específica por Navegador

### Chrome / Edge (Chromium)

Chrome y Edge usan el almacén de certificados de Windows automáticamente. No requiere configuración adicional.

Verificación:
1. chrome://settings/certificates
2. Pestaña "Autoridades"
3. Buscar "IACT DevBox Root CA"

### Firefox

Firefox usa su propio almacén de certificados. Requiere importación manual:

1. Abrir Firefox

2. Ir a: about:preferences#privacy

3. Scroll hasta "Certificados" > "Ver certificados"

4. Pestaña "Autoridades"

5. "Importar"

6. Seleccionar: `D:\Estadia_IACT\proyecto\IACT\db\config\certs\ca\ca.crt`

7. Marcar:
   - [X] Confiar en esta CA para identificar sitios web

8. Aceptar

### Brave

Brave usa el almacén de Windows. Mismo comportamiento que Chrome.

## Troubleshooting

### Problema: Script no encuentra el certificado

Causa: La VM Adminer no ha ejecutado el provisioner ssl.sh

Solución:
```powershell
vagrant provision adminer
```

Verificar generación:
```powershell
ls config\certs\ca\
# Debe mostrar: ca.crt, ca.key
```

### Problema: "Certificate already installed"

Causa: El certificado ya está en el almacén

Solución:
- Si funciona correctamente: No hacer nada
- Si quieres reinstalar: `.\install-ca-certificate.ps1 -Force`

### Problema: Navegador sigue mostrando advertencia

Causa: Navegador no ha recargado el almacén de certificados

Solución:
1. Cerrar TODAS las ventanas del navegador
2. Verificar en Administrador de tareas que no hay procesos
3. Limpiar cache SSL:
   ```powershell
   # Chrome/Edge
   Remove-Item "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*" -Recurse -Force
   
   # O simplemente reiniciar Windows
   ```

### Problema: "This script must be run as Administrator"

Causa: PowerShell no tiene privilegios elevados

Solución:
1. Click derecho en PowerShell
2. "Ejecutar como administrador"
3. Volver a ejecutar script

### Problema: Firefox no confía en el certificado

Causa: Firefox usa su propio almacén

Solución: Ver sección "Firefox" en "Configuración Específica por Navegador"

## Desinstalación

### Con Script

```powershell
# Como Administrador
.\install-ca-certificate.ps1 -Uninstall
```

### Manual con certmgr

1. Abrir: certmgr.msc

2. Navegar a: Entidades de certificación raíz de confianza > Certificados

3. Buscar "IACT DevBox Root CA"

4. Click derecho > Eliminar

5. Confirmar

### Manual con PowerShell

```powershell
# Como Administrador
Get-ChildItem -Path Cert:\LocalMachine\Root | 
  Where-Object {$_.Subject -like "*IACT DevBox*"} | 
  Remove-Item
```

## Regeneración del Certificado CA

Si necesitas regenerar la CA (por ejemplo, si expira):

```powershell
# 1. Eliminar certificados actuales
Remove-Item D:\Estadia_IACT\proyecto\IACT\db\config\certs\ca\* -Force

# 2. Reprovisionar Adminer
vagrant provision adminer

# 3. Desinstalar CA antigua de Windows
.\install-ca-certificate.ps1 -Uninstall

# 4. Instalar nueva CA
.\install-ca-certificate.ps1
```

## Seguridad y Mejores Prácticas

### Uso Apropiado

USAR para:
- Desarrollo local en máquina personal
- Testing de aplicaciones con HTTPS
- Entornos de staging internos

NO USAR para:
- Servidores de producción
- Certificados públicos
- Compartir con otros desarrolladores (cada uno debe generar su CA)

### Protección de la Clave Privada

La clave privada de la CA está en:
```
D:\Estadia_IACT\proyecto\IACT\db\config\certs\ca\ca.key
```

IMPORTANTE:
- NO compartir este archivo
- NO commitear a Git (ya está en .gitignore)
- Mantener permisos restrictivos
- Solo se usa dentro de la VM

### Rotación de Certificados

La CA es válida por 10 años. Los certificados firmados por ella son válidos por 365 días.

Para renovar certificado de Adminer (antes de que expire):
```powershell
# SSH a Adminer
vagrant ssh adminer

# Eliminar certificado actual
sudo rm /vagrant/config/certs/adminer.crt
sudo rm /vagrant/config/certs/adminer.key

# Ejecutar provisioner SSL
sudo /vagrant/config/ssl.sh

# O desde host
vagrant provision adminer --provision-with adminer_ssl
```

## Referencias

Ubicaciones de certificados:
- CA Certificate: `/vagrant/config/certs/ca/ca.crt` (en VM)
- CA Key: `/vagrant/config/certs/ca/ca.key` (en VM)
- Adminer Cert: `/vagrant/config/certs/adminer.crt` (en VM)
- Adminer Key: `/vagrant/config/certs/adminer.key` (en VM)
- Apache Cert: `/etc/ssl/certs/adminer-selfsigned.crt` (en VM)
- Apache Key: `/etc/ssl/private/adminer-selfsigned.key` (en VM)

Scripts relacionados:
- Generación: `/vagrant/config/ssl.sh`
- Instalación Windows: `scripts/install-ca-certificate.ps1`
- VirtualHost SSL: `/etc/apache2/sites-available/adminer-ssl.conf`

---

Documento generado: 2026-01-10
Sistema: IACT DevBox v2.1.0
Certificado CA: IACT DevBox Root CA
Validez: 10 años
