# diagnose-system.ps1
# Script de diagnostico completo del sistema IACT DevBox
# Detecta problemas de red, Ghost Network Adapters, dispositivos PnP fantasma
# Version: 1.0.0

#Requires -Version 5.1

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
$script:LogFile = Join-Path $script:LogsPath "diagnose-system_$($script:Timestamp).log"

# Configuracion de IPs esperadas
$script:ExpectedHostIP = "192.168.56.1"
$script:ExpectedNetworkRange = "192.168.56.0/24"
$script:ExpectedVMs = @{
    "mariadb" = "192.168.56.10"
    "postgresql" = "192.168.56.11"
    "adminer" = "192.168.56.12"
}

# Funcion para inicializar logging
function Initialize-Logging {
    if (-not (Test-Path $script:LogsPath)) {
        New-Item -ItemType Directory -Path $script:LogsPath -Force | Out-Null
    }

    $startMessage = "========================================`r`n"
    $startMessage += "IACT DevBox - System Diagnostics`r`n"
    $startMessage += "Version: 1.0.0`r`n"
    $startMessage += "Timestamp: $($script:Timestamp)`r`n"
    $startMessage += "Log File: $($script:LogFile)`r`n"
    $startMessage += "========================================`r`n"

    $startMessage | Out-File -FilePath $script:LogFile -Encoding UTF8
}

# Funcion para escribir a log y consola
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"

    # Escribir a archivo sin colores
    $logMessage | Out-File -FilePath $script:LogFile -Append -Encoding UTF8
}

# Funcion para mostrar header
function Show-Header {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor $InfoColor
    Write-Host " IACT DevBox - System Diagnostics" -ForegroundColor $InfoColor
    Write-Host " Version: 1.0.0" -ForegroundColor $InfoColor
    Write-Host "========================================" -ForegroundColor $InfoColor
    Write-Host ""
    Write-Host "  [INFO] Directorio del proyecto: $($script:ProjectRoot)" -ForegroundColor $InfoColor
    Write-Host "  [INFO] Generando log: $($script:LogFile)" -ForegroundColor $InfoColor
    Write-Host ""

    Write-Log "=== Inicio de diagnostico ===" "INFO"
    Write-Log "Directorio del proyecto: $($script:ProjectRoot)" "INFO"
}

# Funcion para mostrar seccion
function Show-Section {
    param([string]$Title)
    Write-Host ""
    Write-Host "$Title" -ForegroundColor $InfoColor
    Write-Host ("-" * $Title.Length) -ForegroundColor $InfoColor

    Write-Log "" "INFO"
    Write-Log $Title "INFO"
    Write-Log ("-" * $Title.Length) "INFO"
}

# Funcion para mostrar resultado OK
function Show-OK {
    param([string]$Message)
    Write-Host "  [OK] $Message" -ForegroundColor $SuccessColor
    Write-Log "[OK] $Message" "INFO"
}

# Funcion para mostrar resultado FAIL
function Show-Fail {
    param([string]$Message)
    Write-Host "  [FAIL] $Message" -ForegroundColor $ErrorColor
    Write-Log "[FAIL] $Message" "ERROR"
}

# Funcion para mostrar resultado WARN
function Show-Warn {
    param([string]$Message)
    Write-Host "  [WARN] $Message" -ForegroundColor $WarningColor
    Write-Log "[WARN] $Message" "WARN"
}

# Funcion para mostrar resultado INFO
function Show-Info {
    param([string]$Message)
    Write-Host "  [INFO] $Message" -ForegroundColor $InfoColor
    Write-Log "[INFO] $Message" "INFO"
}

# 1. Diagnostico de adaptadores Host-Only
function Test-HostOnlyAdapters {
    Show-Section "1. Diagnostico de Adaptadores Host-Only"

    try {
        $adaptersOutput = & VBoxManage list hostonlyifs 2>&1

        if ($LASTEXITCODE -ne 0) {
            Show-Fail "No se pudo obtener lista de adaptadores"
            Show-Info "VirtualBox instalado?: VBoxManage --version"
            return @{ Status = "FAIL"; AdapterCount = 0; Adapters = @() }
        }

        # Parsear adaptadores
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

        # Agregar el ultimo adaptador
        if ($currentAdapter.Count -gt 0) {
            $adapters += $currentAdapter
        }

        $adapterCount = $adapters.Count

        Write-Host ""
        Show-Info "Adaptadores Host-Only encontrados: $adapterCount"
        Write-Host ""

        if ($adapterCount -eq 0) {
            Show-Fail "No hay adaptadores Host-Only configurados"
            Show-Info "Crear con: VBoxManage hostonlyif create"
            return @{ Status = "FAIL"; AdapterCount = 0; Adapters = @() }
        }

        # Mostrar detalles de cada adaptador
        $correctAdapter = $null
        $ghostAdapters = @()

        foreach ($adapter in $adapters) {
            Write-Host "  Adaptador: $($adapter.Name)" -ForegroundColor Cyan
            Write-Host "    IP: $($adapter.IP)" -ForegroundColor Gray
            Write-Host "    Status: $($adapter.Status)" -ForegroundColor Gray

            if ($adapter.IP -eq $script:ExpectedHostIP) {
                Write-Host "    [OK] Este es el adaptador correcto" -ForegroundColor $SuccessColor
                $correctAdapter = $adapter
            }
            elseif ($adapter.Name -match "#\d+") {
                Write-Host "    [PROBLEMA] Adaptador numerado (posible ghost)" -ForegroundColor $WarningColor
                $ghostAdapters += $adapter
            }
            else {
                Write-Host "    [INFO] IP no coincide con esperada ($script:ExpectedHostIP)" -ForegroundColor $WarningColor
            }
            Write-Host ""
        }

        # Evaluacion
        Write-Host ""
        if ($adapterCount -eq 1 -and $correctAdapter) {
            Show-OK "Configuracion ideal: 1 adaptador con IP correcta"
            return @{ Status = "OK"; AdapterCount = $adapterCount; Adapters = $adapters; CorrectAdapter = $correctAdapter }
        }
        elseif ($adapterCount -gt 1) {
            Show-Fail "PROBLEMA: Multiples adaptadores Host-Only detectados ($adapterCount)"
            Show-Warn "Esto causa el problema de Ghost Network Adapters"
            Show-Info "Solucion: Eliminar adaptadores sobrantes con fix-network.ps1"

            if ($ghostAdapters.Count -gt 0) {
                Write-Host ""
                Show-Info "Adaptadores a eliminar:"
                foreach ($ghost in $ghostAdapters) {
                    Write-Host "    - $($ghost.Name) (IP: $($ghost.IP))" -ForegroundColor Yellow
                }
            }

            return @{ Status = "PROBLEM"; AdapterCount = $adapterCount; Adapters = $adapters; GhostAdapters = $ghostAdapters }
        }
        elseif (-not $correctAdapter) {
            Show-Warn "Adaptador existe pero no tiene la IP correcta"
            Show-Info "IP esperada: $script:ExpectedHostIP"
            Show-Info "Configurar con: VBoxManage hostonlyif ipconfig ""$($adapters[0].Name)"" --ip $script:ExpectedHostIP"
            return @{ Status = "WARN"; AdapterCount = $adapterCount; Adapters = $adapters }
        }

    }
    catch {
        Show-Fail "Error al diagnosticar adaptadores: $_"
        return @{ Status = "ERROR"; AdapterCount = 0; Adapters = @() }
    }
}

# 2. Diagnostico de perfil de red (Firewall)
function Test-NetworkProfile {
    Show-Section "2. Diagnostico de Perfil de Red (Firewall)"

    try {
        $vboxAdapters = Get-NetAdapter -Name "VirtualBox*" -ErrorAction SilentlyContinue

        if (-not $vboxAdapters) {
            Show-Warn "No se encontraron adaptadores de VirtualBox en Windows"
            Show-Info "Esto es normal si las VMs no estan corriendo"
            return @{ Status = "SKIP"; Profiles = @() }
        }

        Write-Host ""
        $publicProfiles = @()
        $privateProfiles = @()

        foreach ($adapter in $vboxAdapters) {
            $profile = Get-NetConnectionProfile -InterfaceAlias $adapter.Name -ErrorAction SilentlyContinue

            if ($profile) {
                Write-Host "  Adaptador: $($adapter.Name)" -ForegroundColor Cyan
                Write-Host "    Categoria de Red: $($profile.NetworkCategory)" -ForegroundColor Gray

                if ($profile.NetworkCategory -eq "Public") {
                    Write-Host "    [PROBLEMA] Perfil PUBLICO bloquea puertos" -ForegroundColor $ErrorColor
                    $publicProfiles += $adapter.Name
                }
                elseif ($profile.NetworkCategory -eq "Private") {
                    Write-Host "    [OK] Perfil PRIVADO permite conexiones" -ForegroundColor $SuccessColor
                    $privateProfiles += $adapter.Name
                }
                Write-Host ""
            }
        }

        if ($publicProfiles.Count -gt 0) {
            Write-Host ""
            Show-Fail "PROBLEMA: $($publicProfiles.Count) adaptador(es) con perfil PUBLICO"
            Show-Warn "Esto bloquea conexiones TCP a puertos 3306, 5432, 80, 443"
            Show-Info "Solucion: Cambiar a perfil PRIVADO con fix-network.ps1"
            Write-Host ""
            Show-Info "Comando manual:"
            Show-Info "  Get-NetConnectionProfile -InterfaceAlias 'VirtualBox*' | Set-NetConnectionProfile -NetworkCategory Private"
            return @{ Status = "PROBLEM"; PublicProfiles = $publicProfiles; PrivateProfiles = $privateProfiles }
        }
        elseif ($privateProfiles.Count -gt 0) {
            Show-OK "Todos los adaptadores tienen perfil PRIVADO correcto"
            return @{ Status = "OK"; PublicProfiles = @(); PrivateProfiles = $privateProfiles }
        }
        else {
            Show-Info "No se encontraron perfiles de red configurados"
            return @{ Status = "SKIP"; PublicProfiles = @(); PrivateProfiles = @() }
        }

    }
    catch {
        Show-Fail "Error al diagnosticar perfiles de red: $_"
        return @{ Status = "ERROR"; PublicProfiles = @(); PrivateProfiles = @() }
    }
}

# 3. Diagnostico de conectividad a VMs
function Test-VMConnectivity {
    Show-Section "3. Diagnostico de Conectividad a VMs"

    $results = @()

    foreach ($vmName in $script:ExpectedVMs.Keys) {
        $ip = $script:ExpectedVMs[$vmName]

        Write-Host ""
        Write-Host "  VM: $vmName ($ip)" -ForegroundColor Cyan

        # Test ping
        $pingResult = Test-Connection -ComputerName $ip -Count 1 -Quiet -ErrorAction SilentlyContinue

        if ($pingResult) {
            Write-Host "    Ping: OK" -ForegroundColor $SuccessColor
        }
        else {
            Write-Host "    Ping: FAIL" -ForegroundColor $ErrorColor
        }

        $results += @{
            VM = $vmName
            IP = $ip
            PingOK = $pingResult
        }
    }

    Write-Host ""
    $reachableCount = ($results | Where-Object { $_.PingOK }).Count
    $totalCount = $results.Count

    if ($reachableCount -eq $totalCount) {
        Show-OK "Todas las VMs ($reachableCount/$totalCount) son alcanzables"
        return @{ Status = "OK"; ReachableCount = $reachableCount; TotalCount = $totalCount; Results = $results }
    }
    elseif ($reachableCount -eq 0) {
        Show-Fail "Ninguna VM es alcanzable"
        Show-Info "Posibles causas:"
        Show-Info "  1. VMs no estan corriendo (vagrant status)"
        Show-Info "  2. Problema de Ghost Network Adapters"
        Show-Info "  3. Firewall bloqueando"
        return @{ Status = "FAIL"; ReachableCount = $reachableCount; TotalCount = $totalCount; Results = $results }
    }
    else {
        Show-Warn "Solo $reachableCount/$totalCount VMs son alcanzables"
        foreach ($result in $results) {
            if (-not $result.PingOK) {
                Show-Info "  - $($result.VM) ($($result.IP)) no responde"
            }
        }
        return @{ Status = "PARTIAL"; ReachableCount = $reachableCount; TotalCount = $totalCount; Results = $results }
    }
}

# 4. Diagnostico de estado de VMs en Vagrant
function Test-VagrantStatus {
    Show-Section "4. Diagnostico de Estado de VMs (Vagrant)"

    try {
        # Verificar que estamos en directorio del proyecto
        if (-not (Test-Path "Vagrantfile")) {
            Show-Warn "No se encontro Vagrantfile en el directorio actual"
            Show-Info "Ejecutar este script desde la raiz del proyecto"
            return @{ Status = "SKIP"; VMs = @() }
        }

        $statusOutput = & vagrant status 2>&1

        if ($LASTEXITCODE -ne 0) {
            Show-Fail "No se pudo obtener estado de Vagrant"
            return @{ Status = "ERROR"; VMs = @() }
        }

        Write-Host ""
        $vms = @()

        foreach ($vmName in $script:ExpectedVMs.Keys) {
            if ($statusOutput -match "$vmName\s+running") {
                Show-OK "$vmName - running"
                $vms += @{ Name = $vmName; Status = "running" }
            }
            elseif ($statusOutput -match "$vmName\s+poweroff") {
                Show-Warn "$vmName - poweroff"
                $vms += @{ Name = $vmName; Status = "poweroff" }
            }
            elseif ($statusOutput -match "$vmName\s+not created") {
                Show-Warn "$vmName - not created"
                $vms += @{ Name = $vmName; Status = "not created" }
            }
            else {
                Show-Info "$vmName - estado desconocido"
                $vms += @{ Name = $vmName; Status = "unknown" }
            }
        }

        $runningCount = ($vms | Where-Object { $_.Status -eq "running" }).Count
        $totalCount = $vms.Count

        Write-Host ""
        if ($runningCount -eq $totalCount) {
            Show-OK "Todas las VMs ($runningCount/$totalCount) estan corriendo"
            return @{ Status = "OK"; RunningCount = $runningCount; TotalCount = $totalCount; VMs = $vms }
        }
        elseif ($runningCount -eq 0) {
            Show-Warn "Ninguna VM esta corriendo"
            Show-Info "Iniciar con: vagrant up"
            return @{ Status = "STOPPED"; RunningCount = $runningCount; TotalCount = $totalCount; VMs = $vms }
        }
        else {
            Show-Warn "Solo $runningCount/$totalCount VMs corriendo"
            return @{ Status = "PARTIAL"; RunningCount = $runningCount; TotalCount = $totalCount; VMs = $vms }
        }

    }
    catch {
        Show-Fail "Error al obtener estado de Vagrant: $_"
        return @{ Status = "ERROR"; VMs = @() }
    }
}

# 5. Diagnostico de dispositivos PnP fantasma
function Test-GhostPnPDevices {
    Show-Section "5. Diagnostico de Dispositivos PnP Fantasma"

    try {
        # Obtener dispositivos de red con problemas
        $allNetworkDevices = Get-PnpDevice -Class Net -ErrorAction SilentlyContinue

        if (-not $allNetworkDevices) {
            Show-Info "No se pudo obtener lista de dispositivos PnP"
            return @{ Status = "SKIP"; GhostDevices = @() }
        }

        $vboxDevices = $allNetworkDevices | Where-Object { $_.FriendlyName -like "*VirtualBox*" }

        Write-Host ""
        Show-Info "Dispositivos de red VirtualBox encontrados: $($vboxDevices.Count)"
        Write-Host ""

        $ghostDevices = @()
        $activeDevices = @()

        foreach ($device in $vboxDevices) {
            Write-Host "  Dispositivo: $($device.FriendlyName)" -ForegroundColor Cyan
            Write-Host "    Status: $($device.Status)" -ForegroundColor Gray
            Write-Host "    InstanceId: $($device.InstanceId)" -ForegroundColor Gray

            if ($device.Status -eq "OK") {
                Write-Host "    [OK] Dispositivo activo" -ForegroundColor $SuccessColor
                $activeDevices += $device
            }
            elseif ($device.Status -eq "Error" -or $device.Status -eq "Unknown") {
                Write-Host "    [PROBLEMA] Dispositivo fantasma o con error" -ForegroundColor $WarningColor
                $ghostDevices += $device
            }
            Write-Host ""
        }

        if ($ghostDevices.Count -gt 0) {
            Show-Warn "Se encontraron $($ghostDevices.Count) dispositivo(s) PnP con problemas"
            Show-Info "Estos pueden causar conflictos de adaptadores"
            Show-Info "Limpiar con fix-network.ps1 o manualmente en Device Manager"
            return @{ Status = "PROBLEM"; GhostDevices = $ghostDevices; ActiveDevices = $activeDevices }
        }
        else {
            Show-OK "No se encontraron dispositivos PnP fantasma"
            return @{ Status = "OK"; GhostDevices = @(); ActiveDevices = $activeDevices }
        }

    }
    catch {
        Show-Fail "Error al diagnosticar dispositivos PnP: $_"
        return @{ Status = "ERROR"; GhostDevices = @() }
    }
}

# 6. Diagnostico de recursos del sistema
function Test-SystemResources {
    Show-Section "6. Diagnostico de Recursos del Sistema"

    try {
        # RAM
        $computerInfo = Get-CimInstance -ClassName Win32_OperatingSystem
        $totalRAM_GB = [math]::Round($computerInfo.TotalVisibleMemorySize / 1MB, 2)
        $freeRAM_GB = [math]::Round($computerInfo.FreePhysicalMemory / 1MB, 2)
        $usedRAM_GB = $totalRAM_GB - $freeRAM_GB

        Write-Host ""
        Write-Host "  RAM Total: $totalRAM_GB GB" -ForegroundColor Cyan
        Write-Host "  RAM Usada: $usedRAM_GB GB" -ForegroundColor Gray
        Write-Host "  RAM Libre: $freeRAM_GB GB" -ForegroundColor Gray

        $requiredRAM = 6  # 6GB para las 3 VMs

        if ($freeRAM_GB -ge $requiredRAM) {
            Write-Host "  [OK] RAM suficiente para las VMs" -ForegroundColor $SuccessColor
            $ramStatus = "OK"
        }
        else {
            Write-Host "  [WARN] RAM libre por debajo de lo recomendado ($requiredRAM GB)" -ForegroundColor $WarningColor
            $ramStatus = "WARN"
        }

        # Espacio en disco
        $drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -gt 0 }

        Write-Host ""
        foreach ($drive in $drives) {
            if ($drive.Free) {
                $freeSpace_GB = [math]::Round($drive.Free / 1GB, 2)
                Write-Host "  Disco $($drive.Name): $freeSpace_GB GB libres" -ForegroundColor Cyan
            }
        }

        return @{ Status = $ramStatus; TotalRAM = $totalRAM_GB; FreeRAM = $freeRAM_GB }

    }
    catch {
        Show-Fail "Error al diagnosticar recursos: $_"
        return @{ Status = "ERROR" }
    }
}

# Funcion para generar resumen de diagnostico
function Show-DiagnosticSummary {
    param(
        $AdapterResult,
        $ProfileResult,
        $ConnectivityResult,
        $VagrantResult,
        $PnPResult,
        $ResourceResult
    )

    Show-Section "RESUMEN DEL DIAGNOSTICO"

    $issues = @()

    # Evaluar resultados
    Write-Host ""

    if ($AdapterResult.Status -eq "PROBLEM") {
        Show-Fail "Adaptadores Host-Only: PROBLEMA CRITICO"
        Show-Info "  - Se encontraron $($AdapterResult.AdapterCount) adaptadores (se espera 1)"
        Show-Info "  - Ghost Network Adapters detectados"
        $issues += "Ghost Network Adapters"
    }
    elseif ($AdapterResult.Status -eq "OK") {
        Show-OK "Adaptadores Host-Only: OK"
    }
    else {
        Show-Warn "Adaptadores Host-Only: $($AdapterResult.Status)"
    }

    if ($ProfileResult.Status -eq "PROBLEM") {
        Show-Fail "Perfil de Red: PROBLEMA"
        Show-Info "  - $($ProfileResult.PublicProfiles.Count) adaptador(es) con perfil PUBLICO"
        $issues += "Perfil de Firewall incorrecto"
    }
    elseif ($ProfileResult.Status -eq "OK") {
        Show-OK "Perfil de Red: OK"
    }
    else {
        Show-Info "Perfil de Red: $($ProfileResult.Status)"
    }

    if ($ConnectivityResult.Status -eq "FAIL") {
        Show-Fail "Conectividad VMs: FALLO TOTAL"
        $issues += "VMs no alcanzables"
    }
    elseif ($ConnectivityResult.Status -eq "PARTIAL") {
        Show-Warn "Conectividad VMs: PARCIAL ($($ConnectivityResult.ReachableCount)/$($ConnectivityResult.TotalCount))"
        $issues += "Conectividad parcial a VMs"
    }
    elseif ($ConnectivityResult.Status -eq "OK") {
        Show-OK "Conectividad VMs: OK"
    }

    if ($VagrantResult.Status -eq "OK") {
        Show-OK "Estado Vagrant: OK (todas las VMs corriendo)"
    }
    elseif ($VagrantResult.Status -eq "STOPPED") {
        Show-Warn "Estado Vagrant: VMs detenidas"
    }
    elseif ($VagrantResult.Status -eq "PARTIAL") {
        Show-Warn "Estado Vagrant: Solo $($VagrantResult.RunningCount)/$($VagrantResult.TotalCount) VMs corriendo"
    }
    else {
        Show-Info "Estado Vagrant: $($VagrantResult.Status)"
    }

    if ($PnPResult.Status -eq "PROBLEM") {
        Show-Warn "Dispositivos PnP: $($PnPResult.GhostDevices.Count) dispositivo(s) fantasma"
        $issues += "Dispositivos PnP fantasma"
    }
    elseif ($PnPResult.Status -eq "OK") {
        Show-OK "Dispositivos PnP: OK"
    }

    if ($ResourceResult.Status -eq "OK") {
        Show-OK "Recursos del Sistema: OK"
    }
    elseif ($ResourceResult.Status -eq "WARN") {
        Show-Warn "Recursos del Sistema: RAM baja"
    }

    # Recomendaciones
    Write-Host ""
    Write-Host "========================================" -ForegroundColor $InfoColor
    Write-Host " RECOMENDACIONES" -ForegroundColor $InfoColor
    Write-Host "========================================" -ForegroundColor $InfoColor
    Write-Host ""

    if ($issues.Count -eq 0) {
        Show-OK "No se detectaron problemas criticos"
        Write-Host ""
        Show-Info "El sistema esta configurado correctamente"
    }
    else {
        Show-Fail "Se detectaron $($issues.Count) problema(s):"
        Write-Host ""

        foreach ($issue in $issues) {
            Show-Info "  - $issue"
        }

        Write-Host ""
        Show-Info "Acciones recomendadas:"
        Write-Host ""

        if ($issues -contains "Ghost Network Adapters") {
            Show-Info "1. Ejecutar: .\fix-network.ps1"
            Show-Info "   Esto eliminara adaptadores duplicados y configurara el correcto"
        }

        if ($issues -contains "Perfil de Firewall incorrecto") {
            Show-Info "2. Cambiar perfil de red a PRIVADO:"
            Show-Info "   Get-NetConnectionProfile -InterfaceAlias 'VirtualBox*' | Set-NetConnectionProfile -NetworkCategory Private"
        }

        if ($issues -contains "VMs no alcanzables" -or $issues -contains "Conectividad parcial a VMs") {
            Show-Info "3. Verificar estado de VMs:"
            Show-Info "   vagrant status"
            Show-Info "   vagrant reload"
        }
    }

    Write-Host ""
}

# Funcion principal
function Main {
    # Inicializar logging
    Initialize-Logging

    Show-Header

    # Ejecutar diagnosticos
    $adapterResult = Test-HostOnlyAdapters
    $profileResult = Test-NetworkProfile
    $connectivityResult = Test-VMConnectivity
    $vagrantResult = Test-VagrantStatus
    $pnpResult = Test-GhostPnPDevices
    $resourceResult = Test-SystemResources

    # Mostrar resumen
    Show-DiagnosticSummary -AdapterResult $adapterResult `
                          -ProfileResult $profileResult `
                          -ConnectivityResult $connectivityResult `
                          -VagrantResult $vagrantResult `
                          -PnPResult $pnpResult `
                          -ResourceResult $resourceResult

    Write-Host ""
    Write-Log "=== Fin de diagnostico ===" "INFO"
    Write-Host "  [INFO] Log guardado en: $($script:LogFile)" -ForegroundColor $InfoColor
    Write-Host ""
}

# Ejecutar script
Main