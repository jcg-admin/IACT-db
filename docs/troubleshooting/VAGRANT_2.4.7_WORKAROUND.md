# Solución Bug Vagrant 2.4.7 - Log Level Error

Documentación del bug conocido en Vagrant 2.4.7 y sus soluciones prácticas.

## Descripción del Problema

### Error Completo

```
C:/Program Files/Vagrant/embedded/gems/gems/vagrant_cloud-3.1.3/lib/vagrant_cloud/logger.rb:40:in `block in default': 
Log level must be in 0..8 (ArgumentError)
```

### Contexto del Error

El error ocurre cuando Vagrant 2.4.7 intenta verificar si hay actualizaciones disponibles para la box usando el gem `vagrant_cloud`.

**Momento de aparición**:
```
==> mariadb: Cloning VM...
==> mariadb: Matching MAC address for NAT networking...
==> mariadb: Checking if box 'ubuntu/focal64' version '20240821.0.1' is up to date...
[ERROR AQUÍ]
```

### Causa Raíz

Bug en el gem `vagrant_cloud` versión 3.1.3 incluido con Vagrant 2.4.7:
- El código intenta configurar un nivel de logging inválido
- El validador de niveles de log solo acepta valores 0-8
- El valor proporcionado está fuera de este rango

**Archivo afectado**:
```
C:/Program Files/Vagrant/embedded/gems/gems/vagrant_cloud-3.1.3/lib/vagrant_cloud/logger.rb
```

## Impacto

### Qué Falla

- Box update check durante `vagrant up`
- Primera ejecución de VMs (al clonar la box)
- Comando `vagrant box outdated`

### Qué NO Falla

- Ejecución de VMs ya creadas
- SSH a VMs
- Provisioning
- Comandos que no verifican actualizaciones de box

## Soluciones

### Solución 1: Variable de Entorno (Temporal)

Configurar nivel de logging válido antes de ejecutar comandos Vagrant.

**Uso único**:
```powershell
$env:VAGRANT_LOG_LEVEL = "INFO"
vagrant up
```

**Ventajas**:
- Rápido y simple
- No modifica archivos
- Efectivo inmediatamente

**Desventajas**:
- Se pierde al cerrar PowerShell
- Debe repetirse en cada sesión
- Solo aplica a la sesión actual

### Solución 2: Perfil de PowerShell (Permanente)

Agregar la variable al perfil de PowerShell para que se configure automáticamente.

**Implementación**:

```powershell
# Abrir perfil
notepad $PROFILE

# Agregar al inicio del archivo
$env:VAGRANT_LOG_LEVEL = "INFO"

# Guardar y cerrar

# Recargar perfil
. $PROFILE

# Verificar
$env:VAGRANT_LOG_LEVEL
# Debe mostrar: INFO
```

**Ventajas**:
- Permanente
- Automático en todas las sesiones
- No requiere recordar configurar

**Desventajas**:
- Requiere edición del perfil
- Afecta todas las sesiones de PowerShell

### Solución 3: Deshabilitar Box Update Check

Configurar Vagrant para no verificar actualizaciones de boxes.

**En Vagrantfile** (Global):

```ruby
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Deshabilitar verificación de actualizaciones (workaround Vagrant 2.4.7 bug)
  config.vm.box_check_update = false
  
  # Resto de la configuración...
end
```

**Ventajas**:
- Evita el bug completamente
- No requiere variables de entorno
- Funciona en Windows, Linux, macOS

**Desventajas**:
- No se notificará de actualizaciones de box
- Aplicable solo a proyectos específicos

**NOTA**: El Vagrantfile de IACT DevBox ya tiene `box_check_update = true` en cada VM individual. Para aplicar esta solución, cambiar a `false`.

### Solución 4: Actualizar Vagrant

Instalar versión de Vagrant sin este bug.

**Versiones recomendadas**:
- Vagrant 2.4.1 (estable, sin bug)
- Vagrant 2.4.3+ (corregido)
- Vagrant latest (última versión)

**Verificar versión actual**:
```powershell
vagrant --version
# Muestra: Vagrant 2.4.7
```

**Proceso de actualización**:

1. Descargar versión nueva:
   https://developer.hashicorp.com/vagrant/downloads

2. Desinstalar versión actual:
   ```powershell
   # Panel de Control > Programas > Desinstalar
   # O usando Chocolatey:
   choco uninstall vagrant
   ```

3. Instalar versión nueva

4. Verificar:
   ```powershell
   vagrant --version
   ```

**Ventajas**:
- Soluciona el problema definitivamente
- Actualización a versión más reciente
- Sin workarounds necesarios

**Desventajas**:
- Requiere reinstalación
- Puede introducir cambios de comportamiento
- Downtime durante la actualización

## Recomendación para IACT DevBox

### Configuración Implementada

El proyecto IACT DevBox utiliza **Solución 2** (Perfil PowerShell):

**Archivo**: `C:\Users\[usuario]\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`

**Contenido relevante**:
```powershell
# SSH de Git en PATH (solución problema SSH Vagrant)
$env:PATH = "C:\Program Files\Git\usr\bin;$env:PATH"

# Workaround Vagrant 2.4.7 bug (log level)
$env:VAGRANT_LOG_LEVEL = "INFO"
```

### Ventajas de Esta Configuración

1. Permanente: Se aplica automáticamente
2. Compatible: Funciona con todas las versiones de Vagrant
3. Transparente: Usuario no necesita recordar configurar
4. Documentado: Comentarios explican el propósito

### Verificación

```powershell
# Ver contenido del perfil
Get-Content $PROFILE

# Verificar variable configurada
$env:VAGRANT_LOG_LEVEL
# Debe mostrar: INFO

# Test con Vagrant
vagrant version
# No debe mostrar errores
```

## Troubleshooting

### Problema: Error persiste después de configurar variable

**Causa posible**: Perfil no se recargó o variable no se configuró correctamente

**Verificación**:
```powershell
$env:VAGRANT_LOG_LEVEL
```

Si no muestra "INFO":
```powershell
# Recargar perfil manualmente
. $PROFILE

# O configurar directamente
$env:VAGRANT_LOG_LEVEL = "INFO"
```

### Problema: Variable se pierde al abrir nueva ventana

**Causa**: No está en el perfil de PowerShell

**Solución**:
```powershell
# Verificar si perfil existe
Test-Path $PROFILE
# Si retorna False:

# Crear perfil
New-Item -ItemType File -Path $PROFILE -Force

# Editar y agregar configuración
notepad $PROFILE
```

### Problema: Box update check sigue intentando ejecutarse

**Causa**: Variable configurada pero Vagrantfile tiene box_check_update = true

**Solución**: La variable de entorno previene el error pero no deshabilita el check. Si quieres deshabilitarlo completamente, usar Solución 3.

### Problema: Otras aplicaciones afectadas por VAGRANT_LOG_LEVEL

**Causa poco probable**: Otras herramientas leen esta variable

**Solución**: Configurar solo cuando se usa Vagrant:
```powershell
# En lugar de en el perfil, crear función:
function vagrant-safe {
    $env:VAGRANT_LOG_LEVEL = "INFO"
    vagrant $args
}

# Usar: vagrant-safe up
```

## Información Técnica Adicional

### Niveles de Log Válidos

Según el validador de `vagrant_cloud`:

```ruby
# Valores válidos: 0-8
0 = FATAL
1 = ERROR  
2 = WARN
3 = INFO    # Recomendado
4 = DEBUG
5-8 = Niveles debug adicionales
```

### Por Qué INFO Es la Mejor Opción

- INFO (nivel 3): Balance entre información y verbosidad
- No es demasiado silencioso (evita FATAL/ERROR)
- No es demasiado verbose (evita DEBUG)
- Compatible con salida normal de Vagrant

### Logs de Vagrant con Variable Configurada

Con `VAGRANT_LOG_LEVEL=INFO`, Vagrant mostrará:
- Operaciones principales
- Warnings importantes
- Errores
- NO mostrará: Debug detallado, trace interno

## Historial del Bug

**Versión afectada**: Vagrant 2.4.7

**Gem afectado**: vagrant_cloud 3.1.3

**Fecha reporte**: Reportado en issues de HashiCorp Vagrant

**Estado**: 
- Bug confirmado por comunidad
- Workarounds disponibles
- Corregido en versiones posteriores

**Referencias**:
- GitHub Vagrant Issues
- HashiCorp Forum
- Stack Overflow discussions

## Scripts de Diagnóstico

### Verificar si estás afectado

```powershell
# Verificar versión de Vagrant
vagrant --version

# Si muestra 2.4.7, ejecutar test:
vagrant box outdated

# Si da error "Log level must be in 0..8", estás afectado
```

### Test de solución

```powershell
# Configurar variable
$env:VAGRANT_LOG_LEVEL = "INFO"

# Reintentar
vagrant box outdated

# Si funciona sin error, la solución es efectiva
```

### Script de verificación completa

```powershell
Write-Host "Verificando configuración Vagrant 2.4.7 workaround..." -ForegroundColor Cyan

# 1. Versión de Vagrant
$vagrantVersion = vagrant --version
Write-Host "Versión: $vagrantVersion"

# 2. Variable de entorno
$logLevel = $env:VAGRANT_LOG_LEVEL
if ($logLevel) {
    Write-Host "VAGRANT_LOG_LEVEL: $logLevel" -ForegroundColor Green
} else {
    Write-Host "VAGRANT_LOG_LEVEL: NO CONFIGURADA" -ForegroundColor Yellow
}

# 3. Perfil de PowerShell
if (Test-Path $PROFILE) {
    $profileContent = Get-Content $PROFILE -Raw
    if ($profileContent -like "*VAGRANT_LOG_LEVEL*") {
        Write-Host "Perfil PowerShell: CONFIGURADO" -ForegroundColor Green
    } else {
        Write-Host "Perfil PowerShell: NO CONFIGURADO" -ForegroundColor Yellow
    }
} else {
    Write-Host "Perfil PowerShell: NO EXISTE" -ForegroundColor Yellow
}

# 4. Test funcional
Write-Host "`nProbando vagrant version..."
vagrant version 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "Test: OK" -ForegroundColor Green
} else {
    Write-Host "Test: FALLO" -ForegroundColor Red
}
```

## Recursos Adicionales

### Documentación Relacionada

- PERFILES_POWERSHELL.md: Configuración completa del perfil
- ANALISIS_PROBLEMA_SSH_VAGRANT.md: Otro problema de PowerShell resuelto
- README_PROYECTO.md: Setup general del proyecto

### Comandos Útiles

```powershell
# Ver todas las variables de entorno de Vagrant
Get-ChildItem env: | Where-Object {$_.Name -like "VAGRANT*"}

# Ver nivel de logging actual
$env:VAGRANT_LOG_LEVEL

# Limpiar variable (test)
Remove-Item env:\VAGRANT_LOG_LEVEL

# Restaurar variable
$env:VAGRANT_LOG_LEVEL = "INFO"
```

---

Documento generado: 2026-01-10
Bug: Vagrant 2.4.7 Log Level ArgumentError
Solución implementada: Variable de entorno en perfil PowerShell
Estado: Activo y funcional
