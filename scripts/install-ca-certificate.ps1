# install-ca-certificate.ps1
# Install IACT DevBox Certificate Authority to Windows
# Version: 1.0.0

#Requires -Version 5.1
#Requires -RunAsAdministrator

[CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
param(
    [switch]$Force,
    [switch]$Remove,
    [switch]$Help
)

# Colors
$ErrorColor = "Red"
$WarningColor = "Yellow"
$SuccessColor = "Green"
$InfoColor = "Cyan"

# Get project root
function Get-ProjectRoot {
    $scriptPath = $PSScriptRoot
    if ([string]::IsNullOrEmpty($scriptPath)) {
        $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
    }
    
    if ([string]::IsNullOrEmpty($scriptPath) -or $scriptPath -eq "") {
        $scriptPath = Get-Location
    }
    
    return Split-Path -Parent $scriptPath
}

# Paths
$script:ProjectRoot = Get-ProjectRoot
$script:LogsPath = Join-Path $script:ProjectRoot "logs"
$script:Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$script:LogFile = Join-Path $script:LogsPath "install-ca-certificate_$($script:Timestamp).log"
$script:CACertPath = Join-Path $script:ProjectRoot "config\certs\ca\ca.crt"
$script:CertSubject = "*IACT DevBox Root CA*"

# Logging functions
function Initialize-Logging {
    if (-not (Test-Path $script:LogsPath)) {
        New-Item -ItemType Directory -Path $script:LogsPath -Force | Out-Null
    }
    
    $startMessage = "========================================`r`n"
    $startMessage += "IACT DevBox CA Certificate Installer`r`n"
    $startMessage += "Version: 1.0.0`r`n"
    $startMessage += "Timestamp: $($script:Timestamp)`r`n"
    $startMessage += "Log File: $($script:LogFile)`r`n"
    $startMessage += "========================================`r`n"
    
    $startMessage | Out-File -FilePath $script:LogFile -Encoding UTF8 -Confirm:$false
}

function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    
    $logMessage | Out-File -FilePath $script:LogFile -Append -Encoding UTF8 -Confirm:$false
}

# Output functions
function Show-Header {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor $InfoColor
    Write-Host " IACT DevBox CA Certificate Installer" -ForegroundColor $InfoColor
    Write-Host " Version: 1.0.0" -ForegroundColor $InfoColor
    Write-Host "========================================" -ForegroundColor $InfoColor
    Write-Host ""
    Write-Host "  [INFO] Directorio del proyecto: $($script:ProjectRoot)" -ForegroundColor $InfoColor
    Write-Host "  [INFO] Generando log: $($script:LogFile)" -ForegroundColor $InfoColor
    Write-Host ""
    
    Write-Log "=== Inicio de instalación de CA ===" "INFO"
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

# Show help
function Show-Help {
    Show-Header
    
    Write-Host "DESCRIPCION:"
    Write-Host "  Instala el Certificate Authority (CA) de IACT DevBox en Windows"
    Write-Host "  para que los certificados SSL sean confiables en los navegadores."
    Write-Host ""
    Write-Host "USO:"
    Write-Host "  .\install-ca-certificate.ps1 [-Force] [-Remove] [-Help]"
    Write-Host ""
    Write-Host "PARAMETROS:"
    Write-Host "  -Force     Instalar sin pedir confirmacion"
    Write-Host "  -Remove    Eliminar certificado CA instalado"
    Write-Host "  -Help      Mostrar esta ayuda"
    Write-Host ""
    Write-Host "EJEMPLOS:"
    Write-Host "  .\install-ca-certificate.ps1"
    Write-Host "    Instalar CA con confirmacion"
    Write-Host ""
    Write-Host "  .\install-ca-certificate.ps1 -Force"
    Write-Host "    Instalar CA sin confirmacion"
    Write-Host ""
    Write-Host "  .\install-ca-certificate.ps1 -Remove"
    Write-Host "    Eliminar CA instalada"
    Write-Host ""
    Write-Host "NOTAS:"
    Write-Host "  - Requiere privilegios de Administrador"
    Write-Host "  - El certificado CA debe existir en: config\certs\ca\ca.crt"
    Write-Host "  - Despues de instalar, reinicia tu navegador"
    Write-Host ""
}

# Check if CA certificate exists
function Test-CACertificateExists {
    Write-Log "Verificando si el archivo CA existe" "INFO"
    
    if (-not (Test-Path $script:CACertPath)) {
        Show-Fail "Certificado CA no encontrado"
        Show-Info "Ruta esperada: $script:CACertPath"
        Show-Info "Ejecutar primero: vagrant up"
        Write-Log "Archivo CA no encontrado: $script:CACertPath" "ERROR"
        return $false
    }
    
    Show-OK "Archivo CA encontrado: $script:CACertPath"
    Write-Log "Archivo CA encontrado" "INFO"
    return $true
}

# Check if CA is already installed
function Test-CAInstalled {
    try {
        $cert = Get-ChildItem -Path Cert:\LocalMachine\Root -ErrorAction SilentlyContinue | 
                Where-Object { $_.Subject -like $script:CertSubject }
        
        if ($cert) {
            Write-Log "CA ya está instalada: $($cert.Thumbprint)" "INFO"
            return $true
        }
        
        return $false
    }
    catch {
        Write-Log "Error verificando CA instalada: $_" "ERROR"
        return $false
    }
}

# Get installed CA certificate
function Get-InstalledCA {
    try {
        $cert = Get-ChildItem -Path Cert:\LocalMachine\Root -ErrorAction SilentlyContinue | 
                Where-Object { $_.Subject -like $script:CertSubject }
        
        if ($cert) {
            Write-Log "CA encontrada: $($cert.Thumbprint)" "INFO"
        }
        
        return $cert
    }
    catch {
        Write-Log "Error buscando CA: $_" "ERROR"
        return $null
    }
}

# Install CA certificate
function Install-CACertificate {
    Show-Section "Instalando Certificado CA"
    
    try {
        if ($PSCmdlet.ShouldProcess("Cert:\LocalMachine\Root", "Importar CA de IACT DevBox")) {
            $cert = Import-Certificate -FilePath $script:CACertPath -CertStoreLocation Cert:\LocalMachine\Root -ErrorAction Stop
            
            Show-OK "CA instalada exitosamente"
            Write-Log "CA instalada: $($cert.Thumbprint)" "INFO"
            Write-Host ""
            Show-Info "Detalles del certificado:"
            Write-Host "  Subject: $($cert.Subject)" -ForegroundColor Gray
            Write-Host "  Issuer: $($cert.Issuer)" -ForegroundColor Gray
            Write-Host "  Thumbprint: $($cert.Thumbprint)" -ForegroundColor Gray
            Write-Host "  Valido desde: $($cert.NotBefore)" -ForegroundColor Gray
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
        Show-Fail "Error instalando CA: $_"
        Write-Log "Error instalando CA: $_" "ERROR"
        return $false
    }
}

# Remove CA certificate
function Remove-CACertificate {
    Show-Section "Eliminando Certificado CA"
    
    $cert = Get-InstalledCA
    
    if (-not $cert) {
        Show-Warn "CA no esta instalada"
        return $true
    }
    
    Show-Info "CA encontrada:"
    Write-Host "  Subject: $($cert.Subject)" -ForegroundColor Gray
    Write-Host "  Thumbprint: $($cert.Thumbprint)" -ForegroundColor Gray
    Write-Host ""
    
    try {
        if ($PSCmdlet.ShouldProcess($cert.Thumbprint, "Eliminar CA")) {
            $thumbprint = $cert.Thumbprint
            $cert | Remove-Item -Force -ErrorAction Stop
            Show-OK "CA eliminada exitosamente"
            Write-Log "CA eliminada: $thumbprint" "INFO"
            return $true
        }
        else {
            Show-Info "Eliminacion simulada (WhatIf)"
            Write-Log "Eliminación simulada (WhatIf)" "INFO"
            return $false
        }
    }
    catch {
        Show-Fail "Error eliminando CA: $_"
        Write-Log "Error eliminando CA: $_" "ERROR"
        return $false
    }
}

# Show final instructions
function Show-FinalInstructions {
    param([bool]$Installed)
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor $SuccessColor
    if ($Installed) {
        Write-Host "  CA INSTALADA EXITOSAMENTE" -ForegroundColor $SuccessColor
    } else {
        Write-Host "  CA ELIMINADA" -ForegroundColor $SuccessColor
    }
    Write-Host "========================================" -ForegroundColor $SuccessColor
    Write-Host ""
    
    if ($Installed) {
        Write-Host "Proximos pasos:" -ForegroundColor $InfoColor
        Write-Host ""
        Write-Host "1. REINICIA tu navegador (Chrome, Firefox, Edge)" -ForegroundColor $WarningColor
        Write-Host "   - Cierra completamente el navegador"
        Write-Host "   - Vuelve a abrirlo"
        Write-Host ""
        Write-Host "2. Accede a Adminer:" -ForegroundColor $InfoColor
        Write-Host "   https://192.168.56.12" -ForegroundColor $InfoColor
        Write-Host ""
        Write-Host "3. Verifica:" -ForegroundColor $InfoColor
        Write-Host "   - Candado verde en la barra de direcciones"
        Write-Host "   - Sin advertencias de seguridad"
        Write-Host ""
        Write-Host "NOTA:" -ForegroundColor $WarningColor
        Write-Host "  Firefox requiere configuracion adicional:"
        Write-Host "  1. Abrir about:config"
        Write-Host "  2. Buscar: security.enterprise_roots.enabled"
        Write-Host "  3. Cambiar a: true"
        Write-Host ""
    } else {
        Write-Host "El certificado CA ha sido eliminado." -ForegroundColor $InfoColor
        Write-Host "Los certificados de Adminer ya no seran confiables." -ForegroundColor $WarningColor
        Write-Host ""
    }
}

# Main function
function Main {
    if ($Help) {
        Show-Help
        return
    }
    
    Initialize-Logging
    Show-Header
    
    # Mode: Remove
    if ($Remove) {
        Write-Log "Modo: Eliminación de CA" "INFO"
        $removed = Remove-CACertificate
        Show-FinalInstructions -Installed $false
        Write-Log "=== Fin de eliminación de CA ===" "INFO"
        Write-Host ""
        Write-Host "  [INFO] Log guardado en: $($script:LogFile)" -ForegroundColor $InfoColor
        Write-Host ""
        return
    }
    
    Write-Log "Modo: Instalación de CA" "INFO"
    
    # Check if CA file exists
    if (-not (Test-CACertificateExists)) {
        Write-Log "=== Fin de instalación (FALLIDO) ===" "ERROR"
        Write-Host ""
        Write-Host "  [INFO] Log guardado en: $($script:LogFile)" -ForegroundColor $InfoColor
        Write-Host ""
        return
    }
    
    # Check if already installed
    if (Test-CAInstalled) {
        $cert = Get-InstalledCA
        
        Write-Host ""
        Show-Warn "La CA ya esta instalada"
        Write-Log "CA ya instalada: $($cert.Thumbprint)" "WARN"
        Write-Host "  Subject: $($cert.Subject)" -ForegroundColor Gray
        Write-Host "  Thumbprint: $($cert.Thumbprint)" -ForegroundColor Gray
        Write-Host "  Valido hasta: $($cert.NotAfter)" -ForegroundColor Gray
        Write-Host ""
        Show-Info "Para reinstalar, primero eliminala con: -Remove"
        Write-Host ""
        Write-Host "  [INFO] Log guardado en: $($script:LogFile)" -ForegroundColor $InfoColor
        Write-Host ""
        return
    }
    
    # Install CA
    $installed = Install-CACertificate
    
    # Show instructions
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

# Execute
Main
