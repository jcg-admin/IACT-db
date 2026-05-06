# install-adminer-certificate.ps1
# Script para instalar certificado SSL de Adminer en Windows
# Elimina el warning de "No segura" en el navegador
# Version: 1.0.0

#Requires -Version 5.1
#Requires -RunAsAdministrator

[CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
param(
    [switch]$Force,
    [switch]$Remove,
    [switch]$Help
)

# Configuracion de colores
$script:SuccessColor = "Green"
$script:ErrorColor = "Red"
$script:WarningColor = "Yellow"
$script:InfoColor = "Cyan"

# Detectar directorio raiz del proyecto
function Get-ProjectRoot {
    $currentDir = Get-Location
    $maxLevels = 5
    $level = 0
    
    while ($level -lt $maxLevels) {
        if (Test-Path (Join-Path $currentDir "Vagrantfile")) {
            return $currentDir
        }
        
        $parentDir = Split-Path $currentDir -Parent
        if (-not $parentDir -or $parentDir -eq $currentDir) {
            break
        }
        
        $currentDir = $parentDir
        $level++
    }
    
    return Get-Location
}

$script:ProjectRoot = Get-ProjectRoot
$script:LogsPath = Join-Path $script:ProjectRoot "logs"
$script:Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$script:LogFile = Join-Path $script:LogsPath "install-adminer-certificate_$($script:Timestamp).log"
$script:TempCertPath = Join-Path $env:TEMP "adminer.cer"
$script:CertSubject = "*192.168.56.12*"

# Funcion para inicializar logging
function Initialize-Logging {
    if (-not (Test-Path $script:LogsPath)) {
        New-Item -ItemType Directory -Path $script:LogsPath -Force | Out-Null
    }
    
    $startMessage = "========================================`r`n"
    $startMessage += "Adminer SSL Certificate Installer`r`n"
    $startMessage += "Version: 1.0.0`r`n"
    $startMessage += "Timestamp: $($script:Timestamp)`r`n"
    $startMessage += "Log File: $($script:LogFile)`r`n"
    $startMessage += "========================================`r`n"
    
    $startMessage | Out-File -FilePath $script:LogFile -Encoding UTF8 -Confirm:$false
}

# Funcion para escribir a log
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    
    $logMessage | Out-File -FilePath $script:LogFile -Append -Encoding UTF8 -Confirm:$false
}

# Funciones de output
function Show-Header {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor $InfoColor
    Write-Host " Adminer SSL Certificate Installer" -ForegroundColor $InfoColor
    Write-Host " Version: 1.0.0" -ForegroundColor $InfoColor
    Write-Host "========================================" -ForegroundColor $InfoColor
    Write-Host ""
    Write-Host "  [INFO] Directorio del proyecto: $($script:ProjectRoot)" -ForegroundColor $InfoColor
    Write-Host "  [INFO] Generando log: $($script:LogFile)" -ForegroundColor $InfoColor
    Write-Host ""
    
    Write-Log "=== Inicio de instalación de certificado SSL ===" "INFO"
}

function Show-OK {
    param([string]$Message)
    Write-Host "  [OK] $Message" -ForegroundColor $SuccessColor
    Write-Log "[OK] $Message" "INFO"
}

function Show-Fail {
    param([string]$Message)
    Write-Host "  [FAIL] $Message" -ForegroundColor $ErrorColor
    Write-Log "[FAIL] $Message" "ERROR"
}

function Show-Warn {
    param([string]$Message)
    Write-Host "  [WARN] $Message" -ForegroundColor $WarningColor
    Write-Log "[WARN] $Message" "WARN"
}

function Show-Info {
    param([string]$Message)
    Write-Host "  [INFO] $Message" -ForegroundColor $InfoColor
    Write-Log "[INFO] $Message" "INFO"
}

function Show-Section {
    param([string]$Title)
    Write-Host ""
    Write-Host "$Title" -ForegroundColor $InfoColor
    Write-Host ("-" * $Title.Length) -ForegroundColor $InfoColor
    
    Write-Log "" "INFO"
    Write-Log $Title "INFO"
}

# Funcion para mostrar ayuda
function Show-Help {
    Show-Header
    
    Write-Host "DESCRIPCION:"
    Write-Host "  Instala el certificado SSL de Adminer en el almacen de certificados"
    Write-Host "  de Windows para eliminar el warning 'No segura' en el navegador."
    Write-Host ""
    Write-Host "USO:"
    Write-Host "  .\install-adminer-certificate.ps1 [-Force] [-Remove] [-Help]"
    Write-Host ""
    Write-Host "PARAMETROS:"
    Write-Host "  -Force     Instalar sin pedir confirmacion"
    Write-Host "  -Remove    Eliminar certificado instalado"
    Write-Host "  -Verbose   Mostrar información detallada (parametro comun de PowerShell)"
    Write-Host "  -Help      Mostrar esta ayuda"
    Write-Host ""
    Write-Host "REQUIERE:"
    Write-Host "  - Ejecutar como Administrador"
    Write-Host "  - VM de Adminer corriendo (vagrant status adminer)"
    Write-Host ""
    Write-Host "EJEMPLOS:"
    Write-Host ""
    Write-Host "  .\install-adminer-certificate.ps1"
    Write-Host "    Instalar certificado (con confirmacion)"
    Write-Host ""
    Write-Host "  .\install-adminer-certificate.ps1 -Force"
    Write-Host "    Instalar sin confirmacion"
    Write-Host ""
    Write-Host "  .\install-adminer-certificate.ps1 -Remove"
    Write-Host "    Eliminar certificado instalado"
    Write-Host ""
    Write-Host "  .\install-adminer-certificate.ps1 -Verbose"
    Write-Host "    Instalar con salida detallada de debugging"
    Write-Host ""
    Write-Host "NOTA:"
    Write-Host "  Despues de instalar, cierra completamente el navegador y vuelve a abrirlo."
    Write-Host ""
}

# Verificar si ya esta instalado
function Test-CertificateInstalled {
    try {
        $cert = Get-ChildItem -Path Cert:\LocalMachine\Root -ErrorAction SilentlyContinue | 
                Where-Object { $_.Subject -like $script:CertSubject }
        
        return $null -ne $cert
    }
    catch {
        return $false
    }
}

# Obtener certificado instalado
function Get-InstalledCertificate {
    try {
        $cert = Get-ChildItem -Path Cert:\LocalMachine\Root -ErrorAction SilentlyContinue | 
                Where-Object { $_.Subject -like $script:CertSubject }
        
        if ($cert) {
            Write-Log "Certificado encontrado: $($cert.Thumbprint)" "INFO"
        }
        
        return $cert
    }
    catch {
        Write-Log "Error buscando certificado: $_" "ERROR"
        return $null
    }
}

# Exportar certificado desde VM
function Export-CertificateFromVM {
    Show-Section "Exportando Certificado desde Adminer VM"
    
    # Verificar que VM esta corriendo
    try {
        Push-Location $script:ProjectRoot
        $status = & vagrant status adminer 2>&1 | Out-String
        Pop-Location
        
        Write-Log "Verificando estado de VM adminer" "INFO"
        
        # Buscar patron especifico: "adminer" seguido de "running"
        if ($status -match "adminer\s+running") {
            Show-OK "VM de Adminer esta corriendo"
            Write-Log "VM adminer está corriendo" "INFO"
        }
        else {
            Show-Fail "VM de Adminer no esta corriendo"
            Write-Log "VM adminer no está corriendo" "ERROR"
            Show-Info "Estado actual:"
            Write-Host ""
            & vagrant status adminer 2>&1 | Select-String -Pattern "adminer"
            Write-Host ""
            Show-Info "Ejecutar: vagrant up adminer"
            return $false
        }
        
    }
    catch {
        Pop-Location
        Show-Fail "Error verificando estado de VM: $_"
        Write-Log "Error verificando estado de VM: $_" "ERROR"
        return $false
    }
    
    # Exportar certificado
    try {
        Show-Info "Exportando certificado desde VM..."
        
        Write-Verbose "Directorio del proyecto: $script:ProjectRoot"
        Write-Verbose "Verificando existencia del certificado..."
        
        Push-Location $script:ProjectRoot
        
        # Primero verificar que el certificado existe
        $certCheck = & vagrant ssh adminer -c "sudo test -f /etc/ssl/certs/adminer-selfsigned.crt && echo EXISTS || echo MISSING" 2>&1
        
        Write-Verbose "Resultado de verificación: $certCheck"
        
        if ($certCheck -match "MISSING") {
            Pop-Location
            Show-Fail "Certificado no existe en la VM"
            Write-Log "Certificado no existe en /etc/ssl/certs/adminer-selfsigned.crt" "ERROR"
            Show-Info "Ruta esperada: /etc/ssl/certs/adminer-selfsigned.crt"
            Show-Info "Regenerar con: vagrant reload adminer --provision"
            return $false
        }
        
        Write-Verbose "Ejecutando: vagrant ssh adminer -c 'sudo cat /etc/ssl/certs/adminer-selfsigned.crt'"
        
        # Exportar certificado
        $certContent = & vagrant ssh adminer -c "sudo cat /etc/ssl/certs/adminer-selfsigned.crt" 2>&1
        $exitCode = $LASTEXITCODE
        
        Write-Verbose "Exit code: $exitCode"
        Write-Verbose "Líneas recibidas: $($certContent.Count)"
        
        Pop-Location
        
        if ($exitCode -ne 0) {
            Show-Fail "Error exportando certificado desde VM (exit code: $exitCode)"
            Write-Log "Error exportando certificado: exit code $exitCode" "ERROR"
            Show-Info "Salida del comando:"
            Write-Host ""
            $certContent | ForEach-Object { 
                Write-Host "  $_" -ForegroundColor Gray
                Write-Log "  $_" "ERROR"
            }
            Write-Host ""
            return $false
        }
        
        # Verificar que el contenido es válido
        if (-not ($certContent -match "BEGIN CERTIFICATE")) {
            Show-Fail "El contenido exportado no parece ser un certificado válido"
            Write-Log "Contenido exportado no es un certificado válido" "ERROR"
            Show-Info "Contenido recibido:"
            Write-Host ""
            $certContent | Select-Object -First 5 | ForEach-Object { 
                Write-Host "  $_" -ForegroundColor Gray
                Write-Log "  $_" "ERROR"
            }
            Write-Host "  ..." -ForegroundColor Gray
            Write-Host ""
            return $false
        }
        
        Write-Verbose "Guardando en: $script:TempCertPath"
        
        # Guardar en archivo temporal
        $certContent | Out-File -FilePath $script:TempCertPath -Encoding ASCII
        
        Show-OK "Certificado exportado a: $script:TempCertPath"
        Write-Log "Certificado exportado exitosamente" "INFO"
        Write-Log "Ruta temporal: $script:TempCertPath" "INFO"
        return $true
        
    }
    catch {
        if (Get-Location -eq $script:ProjectRoot) {
            Pop-Location
        }
        Show-Fail "Error exportando certificado: $_"
        Write-Verbose "Stack trace: $($_.ScriptStackTrace)"
        return $false
    }
}

# Instalar certificado
function Install-Certificate {
    Show-Section "Instalando Certificado en Windows"
    
    if (-not (Test-Path $script:TempCertPath)) {
        Show-Fail "Archivo de certificado no encontrado: $script:TempCertPath"
        return $false
    }
    
    # Confirmar instalacion
    if (-not $Force) {
        Write-Host ""
        Write-Host "  Se instalara el certificado SSL de Adminer en:" -ForegroundColor Yellow
        Write-Host "  Cert:\LocalMachine\Root (Entidades de certificacion raiz de confianza)" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "  Esto permite que el navegador confie en https://192.168.56.12" -ForegroundColor Yellow
        Write-Host ""
        
        $confirm = Read-Host "  Continuar? (S/N)"
        
        if ($confirm -ne "S" -and $confirm -ne "s") {
            Show-Info "Instalacion cancelada"
            return $false
        }
    }
    
    # Importar certificado
    try {
        if ($PSCmdlet.ShouldProcess("Cert:\LocalMachine\Root", "Importar certificado de Adminer")) {
            $cert = Import-Certificate -FilePath $script:TempCertPath -CertStoreLocation Cert:\LocalMachine\Root -ErrorAction Stop
            
            Show-OK "Certificado instalado exitosamente"
            Write-Log "Certificado instalado: $($cert.Thumbprint)" "INFO"
            Write-Host ""
            Show-Info "Detalles del certificado:"
            Write-Host "  Subject: $($cert.Subject)" -ForegroundColor Gray
            Write-Host "  Thumbprint: $($cert.Thumbprint)" -ForegroundColor Gray
            Write-Host "  Valido hasta: $($cert.NotAfter)" -ForegroundColor Gray
            Write-Host ""
            
            Write-Log "Subject: $($cert.Subject)" "INFO"
            Write-Log "Valido hasta: $($cert.NotAfter)" "INFO"
            
            return $true
        }
        else {
            Show-Info "Instalacion simulada (WhatIf)"
            Write-Log "Instalación simulada (WhatIf)" "INFO"
            return $false
        }
    }
    catch {
        Show-Fail "Error instalando certificado: $_"
        Write-Log "Error instalando certificado: $_" "ERROR"
        return $false
    }
}

# Eliminar certificado
function Remove-Certificate {
    Show-Section "Eliminando Certificado de Windows"
    
    $cert = Get-InstalledCertificate
    
    if ($null -eq $cert) {
        Show-Warn "Certificado no esta instalado"
        return $true
    }
    
    Show-Info "Certificado encontrado:"
    Write-Host "  Subject: $($cert.Subject)" -ForegroundColor Gray
    Write-Host "  Thumbprint: $($cert.Thumbprint)" -ForegroundColor Gray
    Write-Host ""
    
    # Confirmar eliminacion
    if (-not $Force) {
        $confirm = Read-Host "  Eliminar certificado? (S/N)"
        
        if ($confirm -ne "S" -and $confirm -ne "s") {
            Show-Info "Eliminacion cancelada"
            return $false
        }
    }
    
    # Eliminar
    try {
        if ($PSCmdlet.ShouldProcess($cert.Thumbprint, "Eliminar certificado")) {
            $thumbprint = $cert.Thumbprint
            $cert | Remove-Item -Force -ErrorAction Stop
            Show-OK "Certificado eliminado exitosamente"
            Write-Log "Certificado eliminado: $thumbprint" "INFO"
            return $true
        }
        else {
            Show-Info "Eliminacion simulada (WhatIf)"
            Write-Log "Eliminación simulada (WhatIf)" "INFO"
            return $false
        }
    }
    catch {
        Show-Fail "Error eliminando certificado: $_"
        Write-Log "Error eliminando certificado: $_" "ERROR"
        return $false
    }
}

# Limpiar archivo temporal
function Remove-TempFile {
    if (Test-Path $script:TempCertPath) {
        try {
            Remove-Item -Path $script:TempCertPath -Force -ErrorAction SilentlyContinue
        }
        catch {
            # Silently ignore
        }
    }
}

# Mostrar instrucciones finales
function Show-FinalInstructions {
    param([bool]$Installed)
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host " SIGUIENTE PASO" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    
    if ($Installed) {
        Write-Host "  1. Cierra COMPLETAMENTE el navegador (todas las pestanas)" -ForegroundColor Cyan
        Write-Host "  2. Abre el navegador nuevamente" -ForegroundColor Cyan
        Write-Host "  3. Ve a: https://192.168.56.12" -ForegroundColor Cyan
        Write-Host "  4. Ya NO deberia mostrar 'No segura'" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  Si aun muestra el warning:" -ForegroundColor Yellow
        Write-Host "  - En Chrome/Edge: chrome://net-internals/#sockets → Flush" -ForegroundColor Gray
        Write-Host "  - Ctrl + Shift + Delete → Limpiar cache" -ForegroundColor Gray
    }
    else {
        Write-Host "  El certificado ha sido eliminado." -ForegroundColor Cyan
        Write-Host "  https://192.168.56.12 volvera a mostrar el warning 'No segura'" -ForegroundColor Cyan
    }
    
    Write-Host ""
}

# Funcion principal
function Main {
    if ($Help) {
        Show-Help
        return
    }
    
    Initialize-Logging
    Show-Header
    
    # Modo eliminacion
    if ($Remove) {
        Write-Log "Modo: Eliminación de certificado" "INFO"
        $removed = Remove-Certificate
        Show-FinalInstructions -Installed $false
        Write-Log "=== Fin de eliminación de certificado ===" "INFO"
        Write-Host "  [INFO] Log guardado en: $($script:LogFile)" -ForegroundColor $InfoColor
        Write-Host ""
        return
    }
    
    Write-Log "Modo: Instalación de certificado" "INFO"
    
    # Verificar si ya esta instalado
    if (Test-CertificateInstalled) {
        $cert = Get-InstalledCertificate
        
        Write-Host ""
        Show-Warn "El certificado ya esta instalado"
        Write-Log "Certificado ya instalado: $($cert.Thumbprint)" "WARN"
        Write-Host "  Subject: $($cert.Subject)" -ForegroundColor Gray
        Write-Host "  Thumbprint: $($cert.Thumbprint)" -ForegroundColor Gray
        Write-Host "  Valido hasta: $($cert.NotAfter)" -ForegroundColor Gray
        Write-Host ""
        Show-Info "Para reinstalar, primero eliminalo con: -Remove"
        Write-Host ""
        Write-Host "  [INFO] Log guardado en: $($script:LogFile)" -ForegroundColor $InfoColor
        Write-Host ""
        return
    }
    
    # Exportar certificado desde VM
    $exported = Export-CertificateFromVM
    
    if (-not $exported) {
        Show-Fail "No se pudo exportar el certificado"
        Write-Log "=== Fin de instalación (FALLIDO) ===" "ERROR"
        Write-Host ""
        Write-Host "  [INFO] Log guardado en: $($script:LogFile)" -ForegroundColor $InfoColor
        Write-Host ""
        return
    }
    
    # Instalar certificado
    $installed = Install-Certificate
    
    # Limpiar archivo temporal
    Remove-TempFile
    
    # Mostrar instrucciones
    if ($installed) {
        Show-FinalInstructions -Installed $true
        Write-Log "=== Fin de instalación (EXITOSO) ===" "INFO"
    } else {
        Write-Log "=== Fin de instalación (CANCELADO) ===" "INFO"
    }
    
    Write-Host ""
    Write-Host "  [INFO] Log guardado en: $($script:LogFile)" -ForegroundColor $InfoColor
    Write-Host ""
}

# Ejecutar
Main
