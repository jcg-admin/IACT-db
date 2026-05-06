# fix-network.ps1
# Script de reparacion de Ghost Network Adapters
# Elimina adaptadores duplicados de VirtualBox de forma segura
# Version: 1.0.0

#Requires -Version 5.1
#Requires -RunAsAdministrator

[CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
param(
    [switch]$Force,
    [switch]$SkipVMCheck,
    [switch]$Help
)

# Configuracion de colores
$script:SuccessColor = "Green"
$script:ErrorColor = "Red"
$script:WarningColor = "Yellow"
$script:InfoColor = "Cyan"

# Detectar directorio raiz del proyecto (donde esta Vagrantfile)
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
    
    # Si no se encuentra Vagrantfile, usar directorio actual
    return Get-Location
}

$script:ProjectRoot = Get-ProjectRoot
$script:LogsPath = Join-Path $script:ProjectRoot "logs"
$script:Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$script:LogFile = Join-Path $script:LogsPath "fix-network_$($script:Timestamp).log"

# Configuracion de IPs esperadas
$script:ExpectedHostIP = "192.168.56.1"
$script:ExpectedNetmask = "255.255.255.0"

# Funcion para inicializar logging
function Initialize-Logging {
    if (-not (Test-Path $script:LogsPath)) {
        New-Item -ItemType Directory -Path $script:LogsPath -Force | Out-Null
    }
    
    $startMessage = "========================================`r`n"
    $startMessage += "IACT DevBox - Network Fix Utility`r`n"
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

# Funcion para mostrar header
function Show-Header {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor $InfoColor
    Write-Host " IACT DevBox - Network Fix Utility" -ForegroundColor $InfoColor
    Write-Host " Version: 1.0.0" -ForegroundColor $InfoColor
    Write-Host "========================================" -ForegroundColor $InfoColor
    Write-Host ""
    Write-Host "  [INFO] Directorio del proyecto: $($script:ProjectRoot)" -ForegroundColor $InfoColor
    Write-Host "  [INFO] Generando log: $($script:LogFile)" -ForegroundColor $InfoColor
    Write-Host ""
    Write-Host "  [WARN] Este script modificara la configuracion de red" -ForegroundColor $WarningColor
    Write-Host "  [WARN] Requiere permisos de Administrador" -ForegroundColor $WarningColor
    Write-Host ""
    
    Write-Log "=== Inicio de reparacion de red ===" "INFO"
    Write-Log "Directorio del proyecto: $($script:ProjectRoot)" "INFO"
}

# Funciones de output
function Show-Section {
    param([string]$Title)
    Write-Host ""
    Write-Host "$Title" -ForegroundColor $InfoColor
    Write-Host ("-" * $Title.Length) -ForegroundColor $InfoColor
    
    Write-Log "" "INFO"
    Write-Log $Title "INFO"
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

# Funcion para mostrar ayuda
function Show-Help {
    Show-Header
    
    Write-Host "DESCRIPCION:"
    Write-Host "  Elimina adaptadores Host-Only duplicados de VirtualBox (Ghost Network Adapters)"
    Write-Host "  y configura correctamente el adaptador principal."
    Write-Host ""
    Write-Host "USO:"
    Write-Host "  .\fix-network.ps1 [-Force] [-SkipVMCheck] [-WhatIf] [-Help]"
    Write-Host ""
    Write-Host "PARAMETROS:"
    Write-Host "  -Force          Eliminar adaptadores sin confirmacion (peligroso)"
    Write-Host "  -SkipVMCheck    Saltar verificacion de VMs apagadas (no recomendado)"
    Write-Host "  -WhatIf         Mostrar que haria sin hacer cambios"
    Write-Host "  -Help           Mostrar esta ayuda"
    Write-Host ""
    Write-Host "EJEMPLOS:"
    Write-Host "  .\fix-network.ps1"
    Write-Host "    Ejecutar con confirmaciones (recomendado)"
    Write-Host ""
    Write-Host "  .\fix-network.ps1 -WhatIf"
    Write-Host "    Simular sin hacer cambios"
    Write-Host ""
    Write-Host "NOTAS:"
    Write-Host "  - Requiere permisos de Administrador"
    Write-Host "  - Las VMs deben estar apagadas (vagrant halt)"
    Write-Host "  - Se creara un log detallado en logs/"
    Write-Host ""
}

# 1. Obtener adaptadores Host-Only
function Get-HostOnlyAdapters {
    Show-Section "1. Detectando Adaptadores Host-Only"
    
    try {
        $adaptersOutput = & VBoxManage list hostonlyifs 2>&1
        
        if ($LASTEXITCODE -ne 0) {
            Show-Fail "No se pudo obtener lista de adaptadores"
            return $null
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
                    Status = $null
                }
            }
            elseif ($line -match "^IPAddress:\s+(.+)$") {
                $currentAdapter.IP = $matches[1].Trim()
            }
            elseif ($line -match "^Status:\s+(.+)$") {
                $currentAdapter.Status = $matches[1].Trim()
            }
        }
        
        if ($currentAdapter.Count -gt 0) {
            $adapters += $currentAdapter
        }
        
        Show-Info "Adaptadores encontrados: $($adapters.Count)"
        Write-Host ""
        
        foreach ($adapter in $adapters) {
            Write-Host "  - $($adapter.Name)" -ForegroundColor Cyan
            Write-Host "    IP: $($adapter.IP)" -ForegroundColor Gray
            Write-Host "    Status: $($adapter.Status)" -ForegroundColor Gray
            
            Write-Log "Adaptador: $($adapter.Name), IP: $($adapter.IP), Status: $($adapter.Status)" "INFO"
        }
        
        return $adapters
        
    }
    catch {
        Show-Fail "Error al obtener adaptadores: $_"
        Write-Log "Error al obtener adaptadores: $_" "ERROR"
        return $null
    }
}

# 2. Identificar adaptadores a eliminar
function Get-AdaptersToRemove {
    param([array]$Adapters)
    
    Show-Section "2. Identificando Adaptadores a Eliminar"
    
    $correctAdapter = $null
    $ghostAdapters = @()
    
    foreach ($adapter in $Adapters) {
        if ($adapter.IP -eq $script:ExpectedHostIP) {
            $correctAdapter = $adapter
            Show-OK "Adaptador correcto encontrado: $($adapter.Name)"
        }
        elseif ($adapter.Name -match "#\d+") {
            $ghostAdapters += $adapter
            Show-Warn "Ghost Adapter: $($adapter.Name) (IP: $($adapter.IP))"
        }
    }
    
    Write-Host ""
    
    if (-not $correctAdapter) {
        Show-Warn "No se encontro adaptador con IP correcta ($script:ExpectedHostIP)"
        Show-Info "Se configurara el primer adaptador con la IP correcta"
    }
    
    if ($ghostAdapters.Count -eq 0) {
        Show-OK "No se encontraron Ghost Adapters"
        return @{
            CorrectAdapter = $correctAdapter
            GhostAdapters = @()
            NeedsFix = $false
        }
    }
    
    Show-Info "Total de Ghost Adapters a eliminar: $($ghostAdapters.Count)"
    
    return @{
        CorrectAdapter = $correctAdapter
        GhostAdapters = $ghostAdapters
        NeedsFix = $true
    }
}

# 3. Verificar que VMs esten apagadas
function Test-VMsAreStopped {
    Show-Section "3. Verificando que VMs esten Apagadas"
    
    if ($SkipVMCheck) {
        Show-Warn "Verificacion de VMs omitida (-SkipVMCheck)"
        Write-Log "Verificacion de VMs omitida por parametro -SkipVMCheck" "WARN"
        return $true
    }
    
    # Verificar que estamos en directorio del proyecto
    $vagrantfilePath = Join-Path $script:ProjectRoot "Vagrantfile"
    if (-not (Test-Path $vagrantfilePath)) {
        Show-Warn "No se encontro Vagrantfile, omitiendo verificacion de VMs"
        return $true
    }
    
    try {
        Push-Location $script:ProjectRoot
        $statusOutput = & vagrant status 2>&1
        Pop-Location
        
        if ($LASTEXITCODE -ne 0) {
            Show-Warn "No se pudo obtener estado de VMs"
            return $true
        }
        
        # Buscar VMs corriendo
        $runningVMs = @()
        if ($statusOutput -match "mariadb\s+running") { $runningVMs += "mariadb" }
        if ($statusOutput -match "postgresql\s+running") { $runningVMs += "postgresql" }
        if ($statusOutput -match "adminer\s+running") { $runningVMs += "adminer" }
        
        if ($runningVMs.Count -gt 0) {
            Write-Host ""
            Show-Fail "HAY VMS CORRIENDO - NO ES SEGURO CONTINUAR"
            Write-Host ""
            Show-Info "VMs que deben detenerse:"
            foreach ($vm in $runningVMs) {
                Write-Host "  - $vm" -ForegroundColor Yellow
            }
            Write-Host ""
            Show-Info "Ejecuta: vagrant halt"
            Write-Host ""
            Write-Log "VMs corriendo detectadas: $($runningVMs -join ', ')" "ERROR"
            return $false
        }
        
        Show-OK "Todas las VMs estan detenidas"
        Write-Log "Verificacion de VMs OK - todas detenidas" "INFO"
        return $true
        
    }
    catch {
        Show-Warn "Error al verificar estado de VMs: $_"
        Write-Log "Error al verificar VMs: $_" "WARN"
        return $true
    }
}

# 4. Mostrar plan de accion
function Show-ActionPlan {
    param($AdaptersInfo)
    
    Show-Section "4. Plan de Accion"
    
    Write-Host ""
    Write-Host "  Se realizaran las siguientes acciones:" -ForegroundColor Cyan
    Write-Host ""
    
    $actionCount = 1
    
    foreach ($ghost in $AdaptersInfo.GhostAdapters) {
        Write-Host "  $actionCount. Eliminar: $($ghost.Name)" -ForegroundColor Yellow
        Write-Host "     IP: $($ghost.IP)" -ForegroundColor Gray
        Write-Log "Accion $actionCount : Eliminar $($ghost.Name) (IP: $($ghost.IP))" "INFO"
        $actionCount++
    }
    
    Write-Host ""
    
    if ($AdaptersInfo.CorrectAdapter) {
        Write-Host "  $actionCount. Verificar IP del adaptador principal" -ForegroundColor Cyan
        Write-Host "     Adaptador: $($AdaptersInfo.CorrectAdapter.Name)" -ForegroundColor Gray
        Write-Host "     IP esperada: $script:ExpectedHostIP" -ForegroundColor Gray
        Write-Log "Accion $actionCount : Verificar IP de $($AdaptersInfo.CorrectAdapter.Name)" "INFO"
    }
    
    Write-Host ""
}

# 5. Pedir confirmacion
function Get-UserConfirmation {
    param([string]$Message)
    
    if ($Force) {
        Show-Warn "Modo -Force activado, omitiendo confirmacion"
        Write-Log "Confirmacion omitida por parametro -Force" "WARN"
        return $true
    }
    
    Write-Host ""
    Write-Host "  $Message" -ForegroundColor Yellow
    Write-Host ""
    $response = Read-Host "  Escriba 'SI' para continuar, cualquier otra cosa para cancelar"
    
    Write-Log "Confirmacion solicitada: '$Message', Respuesta: '$response'" "INFO"
    
    return ($response -eq "SI")
}

# 6. Eliminar adaptadores fantasma
function Remove-GhostAdapters {
    param([array]$GhostAdapters)
    
    Show-Section "5. Eliminando Ghost Adapters"
    
    $removedCount = 0
    $failedCount = 0
    
    foreach ($ghost in $GhostAdapters) {
        Write-Host ""
        Show-Info "Eliminando: $($ghost.Name)..."
        
        if ($PSCmdlet.ShouldProcess($ghost.Name, "Eliminar adaptador Host-Only")) {
            try {
                $result = & VBoxManage hostonlyif remove $ghost.Name 2>&1
                
                if ($LASTEXITCODE -eq 0) {
                    Show-OK "Eliminado: $($ghost.Name)"
                    Write-Log "Adaptador eliminado exitosamente: $($ghost.Name)" "INFO"
                    $removedCount++
                }
                else {
                    Show-Fail "Error eliminando $($ghost.Name): $result"
                    Write-Log "Error eliminando $($ghost.Name): $result" "ERROR"
                    $failedCount++
                }
                
                Start-Sleep -Milliseconds 500
                
            }
            catch {
                Show-Fail "Excepcion eliminando $($ghost.Name): $_"
                Write-Log "Excepcion eliminando $($ghost.Name): $_" "ERROR"
                $failedCount++
            }
        }
        else {
            Show-Info "[WHATIF] Se eliminaria: $($ghost.Name)"
        }
    }
    
    Write-Host ""
    Show-Info "Resultados: $removedCount eliminados, $failedCount fallidos"
    Write-Log "Resultados eliminacion: $removedCount OK, $failedCount FAIL" "INFO"
    
    return @{
        Removed = $removedCount
        Failed = $failedCount
    }
}

# 7. Configurar IP del adaptador correcto
function Set-AdapterIP {
    param($Adapter)
    
    Show-Section "6. Configurando IP del Adaptador Principal"
    
    if (-not $Adapter) {
        Show-Warn "No hay adaptador para configurar"
        return $false
    }
    
    if ($Adapter.IP -eq $script:ExpectedHostIP) {
        Show-OK "IP ya esta configurada correctamente: $($Adapter.IP)"
        return $true
    }
    
    Show-Info "Configurando IP: $script:ExpectedHostIP"
    Show-Info "Adaptador: $($Adapter.Name)"
    
    if ($PSCmdlet.ShouldProcess($Adapter.Name, "Configurar IP $script:ExpectedHostIP")) {
        try {
            $result = & VBoxManage hostonlyif ipconfig $Adapter.Name --ip $script:ExpectedHostIP --netmask $script:ExpectedNetmask 2>&1
            
            if ($LASTEXITCODE -eq 0) {
                Show-OK "IP configurada exitosamente"
                Write-Log "IP configurada: $($Adapter.Name) -> $script:ExpectedHostIP" "INFO"
                return $true
            }
            else {
                Show-Fail "Error configurando IP: $result"
                Write-Log "Error configurando IP: $result" "ERROR"
                return $false
            }
        }
        catch {
            Show-Fail "Excepcion configurando IP: $_"
            Write-Log "Excepcion configurando IP: $_" "ERROR"
            return $false
        }
    }
    else {
        Show-Info "[WHATIF] Se configuraria IP $script:ExpectedHostIP en $($Adapter.Name)"
        return $true
    }
}

# 8. Verificar resultado final
function Test-FinalState {
    Show-Section "7. Verificando Resultado Final"
    
    try {
        $adaptersOutput = & VBoxManage list hostonlyifs 2>&1
        
        if ($LASTEXITCODE -ne 0) {
            Show-Fail "No se pudo verificar estado final"
            return $false
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
        
        Write-Host ""
        Show-Info "Adaptadores despues de reparacion: $($adapters.Count)"
        Write-Host ""
        
        foreach ($adapter in $adapters) {
            Write-Host "  - $($adapter.Name)" -ForegroundColor Cyan
            Write-Host "    IP: $($adapter.IP)" -ForegroundColor Gray
            Write-Log "Adaptador final: $($adapter.Name), IP: $($adapter.IP)" "INFO"
        }
        
        Write-Host ""
        
        if ($adapters.Count -eq 1 -and $adapters[0].IP -eq $script:ExpectedHostIP) {
            Show-OK "EXITO: Configuracion ideal alcanzada"
            Show-OK "1 adaptador con IP correcta ($script:ExpectedHostIP)"
            Write-Log "Reparacion exitosa - configuracion ideal" "INFO"
            return $true
        }
        elseif ($adapters.Count -eq 1) {
            Show-Warn "1 adaptador pero IP incorrecta"
            Show-Info "Ejecuta nuevamente el script para configurar IP"
            Write-Log "1 adaptador pero IP incorrecta" "WARN"
            return $false
        }
        elseif ($adapters.Count -gt 1) {
            Show-Warn "Aun existen multiples adaptadores ($($adapters.Count))"
            Show-Info "Puede requerir limpieza manual adicional"
            Write-Log "Multiples adaptadores persisten: $($adapters.Count)" "WARN"
            return $false
        }
        else {
            Show-Fail "No se encontraron adaptadores Host-Only"
            Show-Info "Puede necesitar crear uno: VBoxManage hostonlyif create"
            Write-Log "No se encontraron adaptadores despues de reparacion" "ERROR"
            return $false
        }
        
    }
    catch {
        Show-Fail "Error verificando estado final: $_"
        Write-Log "Error verificando estado final: $_" "ERROR"
        return $false
    }
}

# Funcion principal
function Main {
    # Verificar permisos de administrador
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host ""
        Write-Host "  [ERROR] Este script requiere permisos de Administrador" -ForegroundColor Red
        Write-Host ""
        Write-Host "  Ejecuta PowerShell como Administrador y vuelve a intentar" -ForegroundColor Yellow
        Write-Host ""
        exit 1
    }
    
    if ($Help) {
        Show-Help
        return
    }
    
    Initialize-Logging
    Show-Header
    
    # 1. Obtener adaptadores
    $adapters = Get-HostOnlyAdapters
    if (-not $adapters) {
        Show-Fail "No se pudieron obtener adaptadores"
        return
    }
    
    # 2. Identificar cuales eliminar
    $adaptersInfo = Get-AdaptersToRemove -Adapters $adapters
    
    if (-not $adaptersInfo.NeedsFix) {
        Write-Host ""
        Show-OK "No se requieren cambios - sistema ya esta configurado correctamente"
        Write-Host ""
        Write-Log "No se requieren cambios" "INFO"
        return
    }
    
    # 3. Verificar VMs apagadas
    if (-not (Test-VMsAreStopped)) {
        Write-Host ""
        Show-Fail "OPERACION CANCELADA - Detener VMs primero"
        Write-Host ""
        Write-Log "Operacion cancelada - VMs corriendo" "ERROR"
        return
    }
    
    # 4. Mostrar plan
    Show-ActionPlan -AdaptersInfo $adaptersInfo
    
    # 5. Confirmacion
    $confirmed = Get-UserConfirmation -Message "Continuar con la eliminacion de $($adaptersInfo.GhostAdapters.Count) adaptador(es) fantasma?"
    
    if (-not $confirmed) {
        Write-Host ""
        Show-Info "Operacion cancelada por el usuario"
        Write-Host ""
        Write-Log "Operacion cancelada por el usuario" "INFO"
        return
    }
    
    # 6. Eliminar adaptadores fantasma
    $removeResults = Remove-GhostAdapters -GhostAdapters $adaptersInfo.GhostAdapters
    
    # 7. Configurar IP si es necesario
    if ($adaptersInfo.CorrectAdapter) {
        Set-AdapterIP -Adapter $adaptersInfo.CorrectAdapter
    }
    
    # 8. Verificar resultado final
    $success = Test-FinalState
    
    # Resumen final
    Write-Host ""
    Write-Host "========================================" -ForegroundColor $InfoColor
    Write-Host " RESUMEN" -ForegroundColor $InfoColor
    Write-Host "========================================" -ForegroundColor $InfoColor
    Write-Host ""
    
    if ($success) {
        Show-OK "Reparacion completada exitosamente"
        Write-Host ""
        Show-Info "Proximo paso:"
        Show-Info "  1. Ejecutar: vagrant up"
        Show-Info "  2. Verificar: .\scripts\verify-vms.ps1"
    }
    else {
        Show-Warn "Reparacion completada con advertencias"
        Write-Host ""
        Show-Info "Revisar el log para mas detalles"
    }
    
    Write-Host ""
    Write-Log "=== Fin de reparacion de red ===" "INFO"
    Write-Host "  [INFO] Log guardado en: $($script:LogFile)" -ForegroundColor $InfoColor
    Write-Host ""
}

# Ejecutar
Main
