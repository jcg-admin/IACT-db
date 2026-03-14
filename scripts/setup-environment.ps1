# setup-environment.ps1
# Script de configuracion inicial guiada para IACT DevBox
# Ayuda a usuarios nuevos a configurar el entorno paso a paso
# Version: 1.0.0

#Requires -Version 5.1

[CmdletBinding()]
param(
    [switch]$SkipChecks,
    [switch]$AutoConfirm,
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
$script:LogFile = Join-Path $script:LogsPath "setup-environment_$($script:Timestamp).log"

# Funcion para inicializar logging
function Initialize-Logging {
    if (-not (Test-Path $script:LogsPath)) {
        New-Item -ItemType Directory -Path $script:LogsPath -Force | Out-Null
    }
    
    $startMessage = "========================================`r`n"
    $startMessage += "IACT DevBox - Environment Setup`r`n"
    $startMessage += "Version: 1.0.0`r`n"
    $startMessage += "Timestamp: $($script:Timestamp)`r`n"
    $startMessage += "Log File: $($script:LogFile)`r`n"
    $startMessage += "========================================`r`n"
    
    $startMessage | Out-File -FilePath $script:LogFile -Encoding UTF8
}

# Funcion para escribir a log
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    
    $logMessage | Out-File -FilePath $script:LogFile -Append -Encoding UTF8
}

# Funciones de output
function Show-Header {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor $InfoColor
    Write-Host " IACT DevBox - Environment Setup" -ForegroundColor $InfoColor
    Write-Host " Version: 1.0.0" -ForegroundColor $InfoColor
    Write-Host "========================================" -ForegroundColor $InfoColor
    Write-Host ""
    Write-Host "  Bienvenido al asistente de configuracion inicial" -ForegroundColor $InfoColor
    Write-Host ""
    
    Write-Log "=== Inicio de setup de entorno ===" "INFO"
}

function Show-Section {
    param([string]$Title)
    Write-Host ""
    Write-Host "$Title" -ForegroundColor $InfoColor
    Write-Host ("-" * $Title.Length) -ForegroundColor $InfoColor
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

function Show-Step {
    param(
        [int]$Step,
        [int]$Total,
        [string]$Title
    )
    Write-Host ""
    Write-Host "[$Step/$Total] $Title" -ForegroundColor Cyan -BackgroundColor DarkBlue
    Write-Host ""
}

# Funcion para mostrar ayuda
function Show-Help {
    Show-Header
    
    Write-Host "DESCRIPCION:"
    Write-Host "  Asistente interactivo para configurar el entorno IACT DevBox desde cero."
    Write-Host "  Guia paso a paso para usuarios nuevos."
    Write-Host ""
    Write-Host "USO:"
    Write-Host "  .\setup-environment.ps1 [-SkipChecks] [-AutoConfirm] [-Help]"
    Write-Host ""
    Write-Host "PARAMETROS:"
    Write-Host "  -SkipChecks     Omitir verificaciones de requisitos"
    Write-Host "  -AutoConfirm    Aceptar todas las confirmaciones automaticamente"
    Write-Host "  -Help           Mostrar esta ayuda"
    Write-Host ""
    Write-Host "PASOS QUE EJECUTA:"
    Write-Host "  1. Verificar requisitos (VirtualBox, Vagrant, RAM, Disco)"
    Write-Host "  2. Verificar adaptadores Host-Only (Ghost Adapters)"
    Write-Host "  3. Crear VMs con 'vagrant up'"
    Write-Host "  4. Verificar que VMs esten funcionando"
    Write-Host "  5. Probar conectividad a bases de datos"
    Write-Host "  6. Mostrar informacion de acceso"
    Write-Host ""
    Write-Host "EJEMPLO:"
    Write-Host "  .\setup-environment.ps1"
    Write-Host "    Ejecutar con confirmaciones interactivas"
    Write-Host ""
}

# Funcion para pedir confirmacion
function Get-UserConfirmation {
    param([string]$Message)
    
    if ($AutoConfirm) {
        Show-Info "Auto-confirmado (-AutoConfirm)"
        Write-Log "Auto-confirmado: $Message" "INFO"
        return $true
    }
    
    Write-Host ""
    Write-Host "  $Message" -ForegroundColor Yellow
    $response = Read-Host "  Continuar? (S/N)"
    
    Write-Log "Confirmacion: '$Message', Respuesta: '$response'" "INFO"
    
    return ($response -eq "S" -or $response -eq "s" -or $response -eq "Y" -or $response -eq "y")
}

# Paso 1: Verificar requisitos
function Step1-CheckPrerequisites {
    Show-Step -Step 1 -Total 6 -Title "Verificando Requisitos del Sistema"
    
    if ($SkipChecks) {
        Show-Warn "Verificacion de requisitos omitida (-SkipChecks)"
        return $true
    }
    
    Show-Info "Ejecutando check-prerequisites.ps1..."
    Write-Host ""
    
    $prereqScript = Join-Path $script:ProjectRoot "scripts\check-prerequisites.ps1"
    
    if (-not (Test-Path $prereqScript)) {
        Show-Warn "Script check-prerequisites.ps1 no encontrado"
        Show-Info "Continuando sin verificacion automatica..."
        return $true
    }
    
    try {
        # Ejecutar el script de prerequisitos
        & $prereqScript
        
        Write-Host ""
        $continue = Get-UserConfirmation -Message "Requisitos verificados. Continuar con el setup?"
        
        if (-not $continue) {
            Show-Info "Setup cancelado por el usuario"
            return $false
        }
        
        return $true
        
    } catch {
        Show-Fail "Error al verificar requisitos: $_"
        return $false
    }
}

# Paso 2: Verificar y limpiar Ghost Adapters
function Step2-CheckGhostAdapters {
    Show-Step -Step 2 -Total 6 -Title "Verificando Adaptadores de Red"
    
    try {
        $adaptersOutput = & VBoxManage list hostonlyifs 2>&1
        
        if ($LASTEXITCODE -ne 0) {
            Show-Warn "No se pudo obtener lista de adaptadores"
            return $true
        }
        
        $adapters = @()
        $currentAdapter = @{}
        
        foreach ($line in $adaptersOutput) {
            if ($line -match "^Name:\s+(.+)$") {
                if ($currentAdapter.Count -gt 0) {
                    $adapters += $currentAdapter
                }
                $currentAdapter = @{
                    Name = $matches[1].Trim()
                    IP = $null
                }
            }
            elseif ($line -match "^IPAddress:\s+(.+)$") {
                $currentAdapter.IP = $matches[1].Trim()
            }
        }
        
        if ($currentAdapter.Count -gt 0) {
            $adapters += $currentAdapter
        }
        
        $adapterCount = $adapters.Count
        
        if ($adapterCount -eq 0) {
            Show-OK "No hay adaptadores Host-Only (Vagrant creara uno automaticamente)"
            return $true
        }
        
        if ($adapterCount -eq 1) {
            Show-OK "Configuracion ideal: 1 adaptador Host-Only"
            Show-Info "Adaptador: $($adapters[0].Name) (IP: $($adapters[0].IP))"
            return $true
        }
        
        # Multiples adaptadores detectados
        Show-Warn "Se detectaron $adapterCount adaptadores Host-Only"
        Show-Warn "Esto puede causar el problema de Ghost Network Adapters"
        Write-Host ""
        
        foreach ($adapter in $adapters) {
            Write-Host "  - $($adapter.Name) (IP: $($adapter.IP))" -ForegroundColor Yellow
        }
        
        Write-Host ""
        Show-Info "Recomendacion: Ejecutar fix-network.ps1 para limpiar adaptadores"
        
        $runFix = Get-UserConfirmation -Message "Ejecutar fix-network.ps1 ahora?"
        
        if ($runFix) {
            $fixScript = Join-Path $script:ProjectRoot "scripts\fix-network.ps1"
            
            if (Test-Path $fixScript) {
                Write-Host ""
                Show-Info "Ejecutando fix-network.ps1..."
                Write-Host ""
                
                # Verificar permisos de admin
                $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
                if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
                    Show-Fail "fix-network.ps1 requiere permisos de Administrador"
                    Show-Info "Reinicia PowerShell como Administrador y vuelve a ejecutar setup"
                    return $false
                }
                
                & $fixScript
                
                Write-Host ""
                Show-Info "Adaptadores limpiados. Continuando con setup..."
                return $true
            } else {
                Show-Warn "Script fix-network.ps1 no encontrado"
                Show-Info "Continuando sin limpiar adaptadores..."
                return $true
            }
        } else {
            Show-Info "Continuando sin limpiar adaptadores (puede causar problemas)"
            return $true
        }
        
    } catch {
        Show-Fail "Error al verificar adaptadores: $_"
        return $true
    }
}

# Paso 3: Ejecutar vagrant up
function Step3-VagrantUp {
    Show-Step -Step 3 -Total 6 -Title "Creando Maquinas Virtuales"
    
    Show-Info "Este paso ejecutara: vagrant up"
    Show-Info "Tiempo estimado: 10-15 minutos"
    Show-Info "Se crearan 3 VMs:"
    Write-Host "  - MariaDB 11.4 (192.168.56.10)" -ForegroundColor Gray
    Write-Host "  - PostgreSQL 16 (192.168.56.11)" -ForegroundColor Gray
    Write-Host "  - Adminer 4.8.1 (192.168.56.12)" -ForegroundColor Gray
    Write-Host ""
    
    $continue = Get-UserConfirmation -Message "Ejecutar 'vagrant up'?"
    
    if (-not $continue) {
        Show-Info "Setup cancelado por el usuario"
        return $false
    }
    
    try {
        Push-Location $script:ProjectRoot
        
        Write-Host ""
        Show-Info "Ejecutando: vagrant up"
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host ""
        
        # Ejecutar vagrant up
        & vagrant up
        
        $exitCode = $LASTEXITCODE
        
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host ""
        
        Pop-Location
        
        if ($exitCode -eq 0) {
            Show-OK "vagrant up completado exitosamente"
            Write-Log "vagrant up exitoso" "INFO"
            return $true
        } else {
            Show-Fail "vagrant up fallo con codigo: $exitCode"
            Write-Log "vagrant up fallo: $exitCode" "ERROR"
            
            Show-Info "Revisar logs en: $script:LogsPath"
            return $false
        }
        
    } catch {
        Pop-Location
        Show-Fail "Error ejecutando vagrant up: $_"
        Write-Log "Error en vagrant up: $_" "ERROR"
        return $false
    }
}

# Paso 4: Verificar VMs funcionando
function Step4-VerifyVMs {
    Show-Step -Step 4 -Total 6 -Title "Verificando Maquinas Virtuales"
    
    Show-Info "Verificando que las VMs esten corriendo..."
    Write-Host ""
    
    $verifyScript = Join-Path $script:ProjectRoot "scripts\verify-vms.ps1"
    
    if (Test-Path $verifyScript) {
        try {
            & $verifyScript
            Write-Host ""
            return $true
        } catch {
            Show-Warn "Error al ejecutar verify-vms.ps1: $_"
            return $true
        }
    } else {
        Show-Warn "Script verify-vms.ps1 no encontrado"
        Show-Info "Verificando manualmente..."
        
        try {
            Push-Location $script:ProjectRoot
            $status = & vagrant status 2>&1
            Pop-Location
            
            if ($status -match "mariadb\s+running" -and 
                $status -match "postgresql\s+running" -and 
                $status -match "adminer\s+running") {
                Show-OK "Todas las VMs estan corriendo"
                return $true
            } else {
                Show-Warn "No todas las VMs estan corriendo"
                return $false
            }
        } catch {
            Pop-Location
            Show-Fail "Error al verificar estado de VMs"
            return $false
        }
    }
}

# Paso 5: Probar conectividad
function Step5-TestConnectivity {
    Show-Step -Step 5 -Total 6 -Title "Probando Conectividad"
    
    Show-Info "Probando conexion a las VMs..."
    Write-Host ""
    
    $vms = @{
        "MariaDB" = "192.168.56.10"
        "PostgreSQL" = "192.168.56.11"
        "Adminer" = "192.168.56.12"
    }
    
    $allReachable = $true
    
    foreach ($vm in $vms.GetEnumerator()) {
        try {
            $result = Test-Connection -ComputerName $vm.Value -Count 2 -Quiet -ErrorAction SilentlyContinue
            
            if ($result) {
                Show-OK "$($vm.Key) ($($vm.Value)) alcanzable"
            } else {
                Show-Fail "$($vm.Key) ($($vm.Value)) NO alcanzable"
                $allReachable = $false
            }
        } catch {
            Show-Fail "$($vm.Key) ($($vm.Value)) error al verificar"
            $allReachable = $false
        }
    }
    
    Write-Host ""
    
    if ($allReachable) {
        Show-OK "Todas las VMs son alcanzables"
        return $true
    } else {
        Show-Warn "Algunas VMs no son alcanzables"
        Show-Info "Verificar con: .\scripts\diagnose-system.ps1"
        return $false
    }
}

# Paso 6: Mostrar informacion de acceso
function Step6-ShowAccessInfo {
    Show-Step -Step 6 -Total 6 -Title "Informacion de Acceso"
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host " SETUP COMPLETADO EXITOSAMENTE!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "Servicios disponibles:" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "  MariaDB 11.4:" -ForegroundColor Yellow
    Write-Host "    IP: 192.168.56.10:3306" -ForegroundColor Gray
    Write-Host "    User: root / django_user" -ForegroundColor Gray
    Write-Host "    Pass: rootpass123 / django_pass" -ForegroundColor Gray
    Write-Host "    DB: ivr_legacy" -ForegroundColor Gray
    Write-Host "    Comando: mysql -h 192.168.56.10 -u root -p'rootpass123'" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "  PostgreSQL 16:" -ForegroundColor Yellow
    Write-Host "    IP: 192.168.56.11:5432" -ForegroundColor Gray
    Write-Host "    User: postgres / django_user" -ForegroundColor Gray
    Write-Host "    Pass: postgrespass123 / django_pass" -ForegroundColor Gray
    Write-Host "    DB: iact_analytics" -ForegroundColor Gray
    Write-Host "    Comando: psql -h 192.168.56.11 -U postgres" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "  Adminer 4.8.1 (Web Interface):" -ForegroundColor Yellow
    Write-Host "    HTTP:  http://192.168.56.12" -ForegroundColor Gray
    Write-Host "    HTTPS: https://192.168.56.12" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "Comandos utiles:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  vagrant status           - Ver estado de VMs" -ForegroundColor Gray
    Write-Host "  vagrant halt             - Detener VMs" -ForegroundColor Gray
    Write-Host "  vagrant up               - Iniciar VMs" -ForegroundColor Gray
    Write-Host "  vagrant reload           - Reiniciar VMs" -ForegroundColor Gray
    Write-Host "  vagrant ssh mariadb      - SSH a MariaDB VM" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "Scripts de utilidad:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  .\scripts\diagnose-system.ps1        - Diagnostico completo" -ForegroundColor Gray
    Write-Host "  .\scripts\verify-vms.ps1             - Verificar VMs" -ForegroundColor Gray
    Write-Host "  .\scripts\check-prerequisites.ps1    - Verificar requisitos" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "Documentacion:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  docs\README.md           - Guia principal" -ForegroundColor Gray
    Write-Host "  docs\TROUBLESHOOTING.md  - Solucion de problemas" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "Logs del setup:" -ForegroundColor Cyan
    Write-Host "  $($script:LogFile)" -ForegroundColor Gray
    Write-Host ""
    
    Write-Log "Setup completado exitosamente" "INFO"
}

# Funcion principal
function Main {
    if ($Help) {
        Show-Help
        return
    }
    
    Initialize-Logging
    Show-Header
    
    Write-Host "  Este asistente te guiara para:" -ForegroundColor Gray
    Write-Host "    1. Verificar requisitos del sistema" -ForegroundColor Gray
    Write-Host "    2. Limpiar adaptadores de red duplicados" -ForegroundColor Gray
    Write-Host "    3. Crear las VMs con vagrant up" -ForegroundColor Gray
    Write-Host "    4. Verificar que todo funcione correctamente" -ForegroundColor Gray
    Write-Host ""
    
    $start = Get-UserConfirmation -Message "Iniciar configuracion?"
    
    if (-not $start) {
        Show-Info "Setup cancelado por el usuario"
        Write-Log "Setup cancelado por usuario" "INFO"
        return
    }
    
    # Ejecutar pasos
    $step1OK = Step1-CheckPrerequisites
    if (-not $step1OK) { return }
    
    $step2OK = Step2-CheckGhostAdapters
    if (-not $step2OK) { return }
    
    $step3OK = Step3-VagrantUp
    if (-not $step3OK) { return }
    
    $step4OK = Step4-VerifyVMs
    $step5OK = Step5-TestConnectivity
    
    Step6-ShowAccessInfo
    
    Write-Log "=== Fin de setup de entorno ===" "INFO"
}

# Ejecutar
Main
