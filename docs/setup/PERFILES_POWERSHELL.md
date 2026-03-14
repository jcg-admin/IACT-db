# Configuración de Perfiles de PowerShell

Guía completa sobre la configuración del perfil de PowerShell para el entorno IACT DevBox.

## Información General

Los perfiles de PowerShell son scripts que se ejecutan automáticamente cuando se inicia una sesión. En el contexto de IACT DevBox, el perfil se usa para:
- Configurar Git SSH en el PATH (solución problema Vagrant SSH)
- Configurar variable de entorno para Vagrant 2.4.7 bug
- Cargar configuraciones y aliases personalizados

## Tipos de Perfiles

PowerShell tiene varios niveles de perfiles:

| Perfil | Ubicación | Aplica a |
|--------|-----------|----------|
| All Users, All Hosts | $PSHOME\Profile.ps1 | Todos los usuarios, todas las aplicaciones |
| All Users, Current Host | $PSHOME\Microsoft.PowerShell_profile.ps1 | Todos los usuarios, PowerShell |
| Current User, All Hosts | $HOME\Documents\PowerShell\Profile.ps1 | Usuario actual, todas las aplicaciones |
| Current User, Current Host | $HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 | Usuario actual, PowerShell |

**Para IACT DevBox usamos**: Current User, Current Host

## Ubicación del Perfil

### Variable Automática

```powershell
# Ver ruta del perfil
$PROFILE

# Típicamente muestra:
C:\Users\[usuario]\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```

### Verificar si Existe

```powershell
Test-Path $PROFILE

# True: El perfil existe
# False: El perfil no existe (necesita crearse)
```

## Configuración para IACT DevBox

### Contenido Requerido

```powershell
# =============================================================================
# IACT DevBox - PowerShell Profile Configuration
# =============================================================================

# -----------------------------------------------------------------------------
# SSH Configuration - Fix Vagrant SSH Timeout
# -----------------------------------------------------------------------------
# Problema: PowerShell por defecto usa SSH de Windows (C:\Windows\System32\OpenSSH\ssh.exe)
# que no es compatible con Vagrant, causando timeouts al ejecutar 'vagrant ssh'.
# Solución: Agregar SSH de Git al inicio del PATH para que tenga prioridad.
$env:PATH = "C:\Program Files\Git\usr\bin;$env:PATH"

# -----------------------------------------------------------------------------
# Vagrant Configuration - Fix Log Level Bug (Vagrant 2.4.7)
# -----------------------------------------------------------------------------
# Problema: Vagrant 2.4.7 tiene un bug en vagrant_cloud gem que causa error:
# "Log level must be in 0..8 (ArgumentError)"
# Solución: Configurar nivel de logging válido antes de usar Vagrant.
$env:VAGRANT_LOG_LEVEL = "INFO"

# -----------------------------------------------------------------------------
# Aliases y Funciones Personalizadas (Opcional)
# -----------------------------------------------------------------------------

# Alias para ir directamente al proyecto
function goto-iact {
    Set-Location "D:\Estadia_IACT\proyecto\IACT\db"
}
Set-Alias -Name iact -Value goto-iact

# Función para verificar estado de VMs rápidamente
function vagrant-check {
    Write-Host "Verificando VMs de IACT DevBox..." -ForegroundColor Cyan
    vagrant status
    Write-Host ""
    Write-Host "Conectividad:" -ForegroundColor Yellow
    Test-Connection -ComputerName 192.168.56.10 -Count 1 -Quiet
    Test-Connection -ComputerName 192.168.56.11 -Count 1 -Quiet
    Test-Connection -ComputerName 192.168.56.12 -Count 1 -Quiet
    Test-Connection -ComputerName adminer.devbox -Count 1 -Quiet
}

# Función para abrir Adminer en navegador
function open-adminer {
    param(
        [switch]$SSL
    )
    if ($SSL) {
        Start-Process "https://adminer.devbox"
    } else {
        Start-Process "http://adminer.devbox"
    }
}

# =============================================================================
# End of IACT DevBox Configuration
# =============================================================================
```

## Crear el Perfil

### Método 1: Crear Archivo Nuevo

```powershell
# Crear directorio si no existe
New-Item -ItemType Directory -Path (Split-Path $PROFILE) -Force

# Crear archivo de perfil
New-Item -ItemType File -Path $PROFILE -Force

# Abrir en editor
notepad $PROFILE

# Pegar contenido de la sección anterior
# Guardar y cerrar
```

### Método 2: Crear con Contenido Directo

```powershell
# Crear directorio si no existe
$profileDir = Split-Path $PROFILE
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force
}

# Crear archivo con contenido básico
@"
# IACT DevBox - PowerShell Profile

# Fix Vagrant SSH timeout (usar Git SSH)
`$env:PATH = "C:\Program Files\Git\usr\bin;`$env:PATH"

# Fix Vagrant 2.4.7 log level bug
`$env:VAGRANT_LOG_LEVEL = "INFO"
"@ | Out-File -FilePath $PROFILE -Encoding UTF8

Write-Host "Perfil creado en: $PROFILE" -ForegroundColor Green
```

## Activar el Perfil

### Recargar en Sesión Actual

```powershell
# Dot-sourcing del perfil
. $PROFILE

# Verificar que se aplicó
$env:PATH -like "*Git\usr\bin*"
# Debe retornar: True

$env:VAGRANT_LOG_LEVEL
# Debe mostrar: INFO
```

### Aplicación Automática

El perfil se carga automáticamente en:
- Cada nueva ventana de PowerShell
- Cada nueva pestaña en Windows Terminal
- Al iniciar PowerShell ISE

NO se carga automáticamente en:
- Sesiones PowerShell ya abiertas (usar dot-sourcing)
- Scripts ejecutados sin invocar el perfil

## Verificación de Configuración

### Test Completo

```powershell
Write-Host "Verificando configuración del perfil..." -ForegroundColor Cyan

# 1. Perfil existe
if (Test-Path $PROFILE) {
    Write-Host "[OK] Perfil existe: $PROFILE" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Perfil no existe" -ForegroundColor Red
}

# 2. Contenido correcto
$profileContent = Get-Content $PROFILE -Raw
if ($profileContent -like "*Git\usr\bin*") {
    Write-Host "[OK] Configuración de SSH presente" -ForegroundColor Green
} else {
    Write-Host "[WARN] Configuración de SSH no encontrada" -ForegroundColor Yellow
}

if ($profileContent -like "*VAGRANT_LOG_LEVEL*") {
    Write-Host "[OK] Configuración de Vagrant presente" -ForegroundColor Green
} else {
    Write-Host "[WARN] Configuración de Vagrant no encontrada" -ForegroundColor Yellow
}

# 3. Variables activas
if ($env:PATH -like "*Git\usr\bin*") {
    Write-Host "[OK] Git SSH en PATH" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Git SSH NO en PATH" -ForegroundColor Red
}

if ($env:VAGRANT_LOG_LEVEL) {
    Write-Host "[OK] VAGRANT_LOG_LEVEL = $env:VAGRANT_LOG_LEVEL" -ForegroundColor Green
} else {
    Write-Host "[FAIL] VAGRANT_LOG_LEVEL no configurada" -ForegroundColor Red
}

# 4. SSH correcto
$sshPath = (Get-Command ssh -ErrorAction SilentlyContinue).Source
if ($sshPath -like "*Git\usr\bin\ssh.exe*") {
    Write-Host "[OK] SSH correcto: $sshPath" -ForegroundColor Green
} else {
    Write-Host "[WARN] SSH path: $sshPath" -ForegroundColor Yellow
}
```

### Script de Verificación Rápida

Guardar como `verify-profile.ps1`:

```powershell
param([switch]$Fix)

function Test-ProfileConfig {
    $issues = @()
    
    # Test 1: Perfil existe
    if (-not (Test-Path $PROFILE)) {
        $issues += "Perfil no existe"
    }
    
    # Test 2: SSH en PATH
    if ($env:PATH -notlike "*Git\usr\bin*") {
        $issues += "Git SSH no está en PATH"
    }
    
    # Test 3: Vagrant variable
    if (-not $env:VAGRANT_LOG_LEVEL) {
        $issues += "VAGRANT_LOG_LEVEL no configurada"
    }
    
    # Test 4: SSH ejecutable correcto
    $ssh = Get-Command ssh -ErrorAction SilentlyContinue
    if ($ssh.Source -notlike "*Git\usr\bin\ssh.exe*") {
        $issues += "SSH ejecutable incorrecto: $($ssh.Source)"
    }
    
    return $issues
}

$issues = Test-ProfileConfig

if ($issues.Count -eq 0) {
    Write-Host "Perfil configurado correctamente" -ForegroundColor Green
} else {
    Write-Host "Problemas encontrados:" -ForegroundColor Red
    $issues | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
    
    if ($Fix) {
        Write-Host "`nAplicando correcciones..." -ForegroundColor Cyan
        
        # Crear perfil si no existe
        if (-not (Test-Path $PROFILE)) {
            New-Item -ItemType File -Path $PROFILE -Force
        }
        
        # Agregar configuraciones faltantes
        $content = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
        
        if ($content -notlike "*Git\usr\bin*") {
            Add-Content $PROFILE "`n# Fix SSH`n`$env:PATH = `"C:\Program Files\Git\usr\bin;`$env:PATH`""
        }
        
        if ($content -notlike "*VAGRANT_LOG_LEVEL*") {
            Add-Content $PROFILE "`n# Fix Vagrant 2.4.7`n`$env:VAGRANT_LOG_LEVEL = `"INFO`""
        }
        
        Write-Host "Correcciones aplicadas. Recarga el perfil con: . `$PROFILE" -ForegroundColor Green
    } else {
        Write-Host "`nPara corregir automáticamente, ejecuta: .\verify-profile.ps1 -Fix" -ForegroundColor Cyan
    }
}
```

## Problemas Comunes

### Problema 1: "Execution Policy" Impide Cargar Perfil

**Síntomas**:
```
. : File [...]\Microsoft.PowerShell_profile.ps1 cannot be loaded because running scripts is disabled on this system.
```

**Causa**: Política de ejecución muy restrictiva

**Solución**:
```powershell
# Ver política actual
Get-ExecutionPolicy

# Si muestra Restricted, cambiar a RemoteSigned
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# Confirmar cambio
# Reabrir PowerShell
```

### Problema 2: Perfil No Se Carga Automáticamente

**Síntomas**: Variables no están configuradas en nuevas ventanas

**Diagnóstico**:
```powershell
# Ver si el perfil realmente se está cargando
$PROFILE
Test-Path $PROFILE

# Ver contenido
Get-Content $PROFILE
```

**Causa común**: Perfil en ubicación incorrecta

**Solución**:
```powershell
# Asegurarse de editar el perfil correcto
notepad $PROFILE

# NO editar manualmente paths alternativos
```

### Problema 3: Cambios No Se Aplican

**Síntomas**: Editas el perfil pero no ves los cambios

**Causa**: Sesión PowerShell no recargó el perfil

**Solución**:
```powershell
# Opción 1: Recargar perfil en sesión actual
. $PROFILE

# Opción 2: Cerrar y abrir PowerShell
exit
# Abrir nueva ventana

# Opción 3: Forzar recarga en todas las pestañas
Get-Process pwsh,powershell -ErrorAction SilentlyContinue | Stop-Process -Force
# Abrir nuevo PowerShell
```

### Problema 4: Error al Cargar Perfil

**Síntomas**:
```
At line:X char:Y
+ [alguna línea del perfil]
+ ~~~
Syntax error...
```

**Causa**: Error de sintaxis en el perfil

**Solución**:
```powershell
# Test syntax del perfil
Test-Path $PROFILE
Get-Content $PROFILE | Out-Null

# Si hay error, editar
notepad $PROFILE

# Verificar comillas, paréntesis, etc.
```

### Problema 5: PATH se Duplica en Cada Sesión

**Síntomas**: PATH crece cada vez que recargas el perfil

**Causa**: Agregando a PATH sin verificar si ya existe

**Solución**:
```powershell
# En lugar de:
$env:PATH = "C:\Program Files\Git\usr\bin;$env:PATH"

# Usar (solo si no está):
if ($env:PATH -notlike "*Git\usr\bin*") {
    $env:PATH = "C:\Program Files\Git\usr\bin;$env:PATH"
}
```

## Configuración Avanzada

### Perfil con Logging

```powershell
# Agregar al inicio del perfil
$ProfileLog = "$env:TEMP\powershell-profile.log"
"[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] PowerShell profile loaded" | Out-File $ProfileLog -Append

# Ver log
Get-Content $env:TEMP\powershell-profile.log -Tail 10
```

### Perfil Condicional (Solo para Proyecto IACT)

```powershell
# Solo cargar configuración si estamos en el proyecto
if ((Get-Location).Path -like "*IACT*") {
    $env:PATH = "C:\Program Files\Git\usr\bin;$env:PATH"
    $env:VAGRANT_LOG_LEVEL = "INFO"
    Write-Host "IACT DevBox environment loaded" -ForegroundColor Cyan
}
```

### Múltiples Proyectos

```powershell
# Función para cambiar entre entornos
function Set-ProjectEnvironment {
    param([string]$Project)
    
    switch ($Project) {
        "IACT" {
            Set-Location "D:\Estadia_IACT\proyecto\IACT\db"
            $env:PATH = "C:\Program Files\Git\usr\bin;$env:PATH"
            $env:VAGRANT_LOG_LEVEL = "INFO"
            Write-Host "IACT DevBox environment active" -ForegroundColor Green
        }
        "OtroProyecto" {
            Set-Location "D:\OtroProyecto"
            # Otras configuraciones
        }
    }
}

# Usar: Set-ProjectEnvironment -Project IACT
```

## Backup y Restauración

### Crear Backup

```powershell
# Backup manual
Copy-Item $PROFILE "$PROFILE.backup.$(Get-Date -Format 'yyyyMMdd')"

# Ver backups
Get-ChildItem (Split-Path $PROFILE) -Filter "*.backup.*"
```

### Restaurar desde Backup

```powershell
# Listar backups disponibles
Get-ChildItem (Split-Path $PROFILE) -Filter "*.backup.*" | 
    Sort-Object LastWriteTime -Descending |
    Select-Object Name, LastWriteTime

# Restaurar específico
Copy-Item "$PROFILE.backup.20260110" $PROFILE -Force

# Recargar
. $PROFILE
```

### Resetear a Configuración Mínima

```powershell
# Backup actual
Copy-Item $PROFILE "$PROFILE.old"

# Crear perfil mínimo
@"
# IACT DevBox - Minimal Profile
`$env:PATH = "C:\Program Files\Git\usr\bin;`$env:PATH"
`$env:VAGRANT_LOG_LEVEL = "INFO"
"@ | Out-File $PROFILE -Force

# Recargar
. $PROFILE
```

## Integración con Windows Terminal

Si usas Windows Terminal, puedes configurar un perfil específico:

```json
{
    "name": "PowerShell (IACT DevBox)",
    "commandline": "pwsh.exe -NoExit -Command \"cd D:\\Estadia_IACT\\proyecto\\IACT\\db\"",
    "startingDirectory": "D:\\Estadia_IACT\\proyecto\\IACT\\db",
    "icon": "🏗️"
}
```

## Referencias

### Variables de Perfil Estándar

```powershell
$PROFILE                           # Current User, Current Host
$PROFILE.AllUsersAllHosts          # All Users, All Hosts
$PROFILE.AllUsersCurrentHost       # All Users, Current Host
$PROFILE.CurrentUserAllHosts       # Current User, All Hosts
$PROFILE.CurrentUserCurrentHost    # Current User, Current Host (mismo que $PROFILE)
```

### Locations por Defecto

PowerShell 5.1 (Windows PowerShell):
```
C:\Users\[usuario]\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
```

PowerShell 7+ (PowerShell Core):
```
C:\Users\[usuario]\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
```

### Comandos Útiles

```powershell
# Abrir perfil en editor predeterminado
notepad $PROFILE

# Abrir perfil en VS Code
code $PROFILE

# Verificar existencia
Test-Path $PROFILE

# Ver contenido
Get-Content $PROFILE

# Recargar
. $PROFILE

# Ver última modificación
Get-Item $PROFILE | Select-Object LastWriteTime
```

## Documentación Relacionada

- ANALISIS_PROBLEMA_SSH_VAGRANT.md: Contexto del problema SSH
- VAGRANT_2.4.7_WORKAROUND.md: Contexto del problema de Vagrant
- README_PROYECTO.md: Setup general del proyecto
- VERIFICACION_COMPLETA.md: Cómo verificar que todo funciona

---

Documento generado: 2026-01-10
Sistema: IACT DevBox v2.1.0
Tipo: Guía de configuración de PowerShell Profile
Ámbito: Current User, Current Host profile
