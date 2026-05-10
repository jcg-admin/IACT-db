# check-prerequisites.ps1
# Script de verificacion de requisitos previos para IACT DevBox
# Ejecutar ANTES de 'vagrant up' para asegurar que el sistema cumple requisitos
# Version: 1.0.0

#Requires -Version 5.1

# Configuracion de colores
$script:SuccessColor = "Green"
$script:ErrorColor = "Red"
$script:WarningColor = "Yellow"
$script:InfoColor = "Cyan"

# Requisitos minimos
$script:MinVirtualBoxVersion = "7.0"
$script:MinVagrantVersion = "2.3"
$script:RequiredRAM_GB = 6
$script:RequiredDisk_GB = 20
$script:RequiredPorts = @(3306, 5432, 80, 443)

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
$script:LogFile = Join-Path $script:LogsPath "check-prerequisites_$($script:Timestamp).log"

# Funcion para inicializar logging
function Initialize-Logging {
    if (-not (Test-Path $script:LogsPath)) {
        New-Item -ItemType Directory -Path $script:LogsPath -Force | Out-Null
    }
    
    $startMessage = "========================================`r`n"
    $startMessage += "IACT DevBox - Prerequisites Check`r`n"
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
    Write-Host " IACT DevBox - Prerequisites Check" -ForegroundColor $InfoColor
    Write-Host " Version: 1.0.0" -ForegroundColor $InfoColor
    Write-Host "========================================" -ForegroundColor $InfoColor
    Write-Host ""
    Write-Host "  [INFO] Directorio del proyecto: $($script:ProjectRoot)" -ForegroundColor $InfoColor
    Write-Host "  [INFO] Generando log: $($script:LogFile)" -ForegroundColor $InfoColor
    Write-Host ""
    Write-Host "  Verificando requisitos antes de 'vagrant up'..." -ForegroundColor $InfoColor
    Write-Host ""
    
    Write-Log "=== Inicio de verificacion de requisitos ===" "INFO"
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

# 1. Verificar VirtualBox
function Test-VirtualBoxInstalled {
    Show-Section "1. Verificando VirtualBox"
    
    try {
        $vboxVersion = & VBoxManage --version 2>&1
        
        if ($LASTEXITCODE -ne 0) {
            Show-Fail "VirtualBox no esta instalado"
            Show-Info "Descarga desde: https://www.virtualbox.org/"
            Write-Log "VirtualBox no encontrado" "ERROR"
            return @{ Installed = $false; Version = $null }
        }
        
        # Extraer version (formato: 7.1.8r168469)
        if ($vboxVersion -match "(\d+\.\d+\.\d+)") {
            $version = $matches[1]
            Show-OK "VirtualBox instalado: $vboxVersion"
            
            # Comparar version
            $versionObj = [version]$version
            $minVersionObj = [version]$script:MinVirtualBoxVersion
            
            if ($versionObj -ge $minVersionObj) {
                Show-OK "Version cumple requisito minimo ($script:MinVirtualBoxVersion)"
                Write-Log "VirtualBox version OK: $version" "INFO"
                return @{ Installed = $true; Version = $version; MeetsRequirement = $true }
            } else {
                Show-Warn "Version $version es menor que $script:MinVirtualBoxVersion"
                Show-Info "Actualizar desde: https://www.virtualbox.org/"
                Write-Log "VirtualBox version antigua: $version" "WARN"
                return @{ Installed = $true; Version = $version; MeetsRequirement = $false }
            }
        } else {
            Show-OK "VirtualBox instalado: $vboxVersion"
            Show-Warn "No se pudo determinar version exacta"
            return @{ Installed = $true; Version = "unknown"; MeetsRequirement = $true }
        }
        
    } catch {
        Show-Fail "Error al verificar VirtualBox: $_"
        Write-Log "Error verificando VirtualBox: $_" "ERROR"
        return @{ Installed = $false; Version = $null }
    }
}

# 2. Verificar Vagrant
function Test-VagrantInstalled {
    Show-Section "2. Verificando Vagrant"
    
    try {
        $vagrantVersion = & vagrant --version 2>&1
        
        if ($LASTEXITCODE -ne 0) {
            Show-Fail "Vagrant no esta instalado"
            Show-Info "Descarga desde: https://www.vagrantup.com/"
            Write-Log "Vagrant no encontrado" "ERROR"
            return @{ Installed = $false; Version = $null }
        }
        
        # Extraer version (formato: Vagrant 2.4.7)
        if ($vagrantVersion -match "(\d+\.\d+\.\d+)") {
            $version = $matches[1]
            Show-OK "Vagrant instalado: $vagrantVersion"
            
            # Comparar version
            $versionObj = [version]$version
            $minVersionObj = [version]$script:MinVagrantVersion
            
            if ($versionObj -ge $minVersionObj) {
                Show-OK "Version cumple requisito minimo ($script:MinVagrantVersion)"
                Write-Log "Vagrant version OK: $version" "INFO"
                return @{ Installed = $true; Version = $version; MeetsRequirement = $true }
            } else {
                Show-Warn "Version $version es menor que $script:MinVagrantVersion"
                Show-Info "Actualizar desde: https://www.vagrantup.com/"
                Write-Log "Vagrant version antigua: $version" "WARN"
                return @{ Installed = $true; Version = $version; MeetsRequirement = $false }
            }
        } else {
            Show-OK "Vagrant instalado: $vagrantVersion"
            Show-Warn "No se pudo determinar version exacta"
            return @{ Installed = $true; Version = "unknown"; MeetsRequirement = $true }
        }
        
    } catch {
        Show-Fail "Error al verificar Vagrant: $_"
        Write-Log "Error verificando Vagrant: $_" "ERROR"
        return @{ Installed = $false; Version = $null }
    }
}

# 3. Verificar RAM disponible
function Test-AvailableRAM {
    Show-Section "3. Verificando RAM Disponible"
    
    try {
        $computerInfo = Get-CimInstance -ClassName Win32_OperatingSystem
        $totalRAM_GB = [math]::Round($computerInfo.TotalVisibleMemorySize / 1MB, 2)
        $freeRAM_GB = [math]::Round($computerInfo.FreePhysicalMemory / 1MB, 2)
        $usedRAM_GB = $totalRAM_GB - $freeRAM_GB
        
        Write-Host ""
        Write-Host "  RAM Total: $totalRAM_GB GB" -ForegroundColor Cyan
        Write-Host "  RAM Usada: $usedRAM_GB GB" -ForegroundColor Gray
        Write-Host "  RAM Libre: $freeRAM_GB GB" -ForegroundColor Gray
        Write-Host ""
        
        Write-Log "RAM Total: $totalRAM_GB GB, Libre: $freeRAM_GB GB" "INFO"
        
        if ($freeRAM_GB -ge $script:RequiredRAM_GB) {
            Show-OK "RAM disponible suficiente ($freeRAM_GB GB >= $($script:RequiredRAM_GB) GB)"
            return @{ Available = $true; Free_GB = $freeRAM_GB; Total_GB = $totalRAM_GB }
        } else {
            Show-Warn "RAM disponible por debajo de lo recomendado ($freeRAM_GB GB < $($script:RequiredRAM_GB) GB)"
            Show-Info "Las VMs necesitan: MariaDB 2GB, PostgreSQL 2GB, Adminer 1GB"
            Show-Info "Considera cerrar aplicaciones para liberar RAM"
            Write-Log "RAM insuficiente: $freeRAM_GB GB" "WARN"
            return @{ Available = $false; Free_GB = $freeRAM_GB; Total_GB = $totalRAM_GB }
        }
        
    } catch {
        Show-Fail "Error al verificar RAM: $_"
        Write-Log "Error verificando RAM: $_" "ERROR"
        return @{ Available = $false }
    }
}

# 4. Verificar espacio en disco
function Test-DiskSpace {
    Show-Section "4. Verificando Espacio en Disco"
    
    try {
        # Verificar disco del proyecto
        $projectDrive = Split-Path $script:ProjectRoot -Qualifier
        $drive = Get-PSDrive -Name $projectDrive.TrimEnd(':') -ErrorAction Stop
        
        if ($drive.Free) {
            $freeSpace_GB = [math]::Round($drive.Free / 1GB, 2)
            
            Write-Host ""
            Write-Host "  Disco del proyecto ($projectDrive): $freeSpace_GB GB libres" -ForegroundColor Cyan
            Write-Host ""
            
            Write-Log "Espacio en disco $projectDrive : $freeSpace_GB GB" "INFO"
            
            if ($freeSpace_GB -ge $script:RequiredDisk_GB) {
                Show-OK "Espacio en disco suficiente ($freeSpace_GB GB >= $($script:RequiredDisk_GB) GB)"
                return @{ Available = $true; Free_GB = $freeSpace_GB }
            } else {
                Show-Warn "Espacio en disco limitado ($freeSpace_GB GB < $($script:RequiredDisk_GB) GB)"
                Show-Info "Las VMs ocuparan aproximadamente 10-15 GB"
                Write-Log "Espacio en disco bajo: $freeSpace_GB GB" "WARN"
                return @{ Available = $false; Free_GB = $freeSpace_GB }
            }
        } else {
            Show-Warn "No se pudo determinar espacio libre en disco"
            return @{ Available = $true }
        }
        
    } catch {
        Show-Fail "Error al verificar espacio en disco: $_"
        Write-Log "Error verificando disco: $_" "ERROR"
        return @{ Available = $true }
    }
}

# 5. Verificar adaptadores Host-Only
function Test-HostOnlyAdapters {
    Show-Section "5. Verificando Adaptadores Host-Only"
    
    try {
        $adaptersOutput = & VBoxManage list hostonlyifs 2>&1
        
        if ($LASTEXITCODE -ne 0) {
            Show-Warn "No se pudo obtener lista de adaptadores"
            return @{ OK = $true; Count = 0 }
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
        
        Write-Host ""
        Show-Info "Adaptadores Host-Only encontrados: $adapterCount"
        
        if ($adapterCount -eq 0) {
            Show-Warn "No hay adaptadores Host-Only configurados"
            Show-Info "Vagrant creara uno automaticamente durante 'vagrant up'"
            Write-Log "No hay adaptadores Host-Only" "WARN"
            return @{ OK = $true; Count = 0; Adapters = @() }
        }
        
        foreach ($adapter in $adapters) {
            Write-Host "  - $($adapter.Name) (IP: $($adapter.IP))" -ForegroundColor Gray
        }
        Write-Host ""
        
        if ($adapterCount -eq 1) {
            Show-OK "Configuracion ideal: 1 adaptador"
            Write-Log "1 adaptador Host-Only - OK" "INFO"
            return @{ OK = $true; Count = $adapterCount; Adapters = $adapters }
        } else {
            Show-Warn "Multiples adaptadores detectados ($adapterCount)"
            Show-Warn "Esto puede causar el problema de Ghost Network Adapters"
            Show-Info "Recomendacion: Ejecutar .\scripts\fix-network.ps1 ANTES de 'vagrant up'"
            Write-Log "Multiples adaptadores: $adapterCount" "WARN"
            return @{ OK = $false; Count = $adapterCount; Adapters = $adapters }
        }
        
    } catch {
        Show-Fail "Error al verificar adaptadores: $_"
        Write-Log "Error verificando adaptadores: $_" "ERROR"
        return @{ OK = $true; Count = 0 }
    }
}

# 6. Verificar puertos no esten en uso
function Test-PortsAvailable {
    Show-Section "6. Verificando Puertos Disponibles"
    
    $portsInUse = @()
    $portsAvailable = @()
    
    Write-Host ""
    
    foreach ($port in $script:RequiredPorts) {
        try {
            $connection = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
            
            if ($connection) {
                Show-Warn "Puerto $port YA esta en uso"
                $processId = $connection[0].OwningProcess
                try {
                    $process = Get-Process -Id $processId -ErrorAction SilentlyContinue
                    Show-Info "  Proceso: $($process.ProcessName) (PID: $processId)"
                    Write-Log "Puerto $port en uso por $($process.ProcessName)" "WARN"
                } catch {
                    Show-Info "  PID: $processId"
                    Write-Log "Puerto $port en uso por PID $processId" "WARN"
                }
                $portsInUse += $port
            } else {
                Show-OK "Puerto $port disponible"
                Write-Log "Puerto $port disponible" "INFO"
                $portsAvailable += $port
            }
        } catch {
            Show-OK "Puerto $port disponible"
            $portsAvailable += $port
        }
    }
    
    Write-Host ""
    
    if ($portsInUse.Count -eq 0) {
        Show-OK "Todos los puertos necesarios estan disponibles"
        return @{ AllAvailable = $true; InUse = @(); Available = $portsAvailable }
    } else {
        Show-Warn "$($portsInUse.Count) puerto(s) en uso"
        Show-Info "Las VMs no podran usar estos puertos"
        Show-Info "Considera detener los procesos antes de 'vagrant up'"
        return @{ AllAvailable = $false; InUse = $portsInUse; Available = $portsAvailable }
    }
}

# 7. Verificar Vagrantfile existe
function Test-VagrantfileExists {
    Show-Section "7. Verificando Vagrantfile"
    
    $vagrantfilePath = Join-Path $script:ProjectRoot "Vagrantfile"
    
    if (Test-Path $vagrantfilePath) {
        Show-OK "Vagrantfile encontrado"
        
        # Validar sintaxis
        Push-Location $script:ProjectRoot
        try {
            $validateOutput = & vagrant validate 2>&1
            if ($LASTEXITCODE -eq 0) {
                Show-OK "Vagrantfile tiene sintaxis valida"
                Write-Log "Vagrantfile validado OK" "INFO"
                Pop-Location
                return @{ Exists = $true; Valid = $true }
            } else {
                Show-Warn "Vagrantfile tiene errores de sintaxis"
                Show-Info $validateOutput
                Write-Log "Vagrantfile con errores: $validateOutput" "WARN"
                Pop-Location
                return @{ Exists = $true; Valid = $false }
            }
        } catch {
            Show-Warn "No se pudo validar Vagrantfile"
            Pop-Location
            return @{ Exists = $true; Valid = $true }
        }
    } else {
        Show-Fail "Vagrantfile NO encontrado"
        Show-Info "Ruta esperada: $vagrantfilePath"
        Write-Log "Vagrantfile no encontrado" "ERROR"
        return @{ Exists = $false; Valid = $false }
    }
}

# Funcion para mostrar resumen final
function Show-FinalSummary {
    param(
        $VBoxResult,
        $VagrantResult,
        $RAMResult,
        $DiskResult,
        $AdaptersResult,
        $PortsResult,
        $VagrantfileResult
    )
    
    Show-Section "RESUMEN DE VERIFICACION"
    
    Write-Host ""
    
    $readyForVagrantUp = $true
    $warnings = @()
    $blockers = @()
    
    # Evaluar cada requisito
    if (-not $VBoxResult.Installed) {
        Show-Fail "VirtualBox: NO INSTALADO"
        $blockers += "VirtualBox no esta instalado"
        $readyForVagrantUp = $false
    } elseif (-not $VBoxResult.MeetsRequirement) {
        Show-Warn "VirtualBox: VERSION ANTIGUA"
        $warnings += "Actualizar VirtualBox"
    } else {
        Show-OK "VirtualBox: OK"
    }
    
    if (-not $VagrantResult.Installed) {
        Show-Fail "Vagrant: NO INSTALADO"
        $blockers += "Vagrant no esta instalado"
        $readyForVagrantUp = $false
    } elseif (-not $VagrantResult.MeetsRequirement) {
        Show-Warn "Vagrant: VERSION ANTIGUA"
        $warnings += "Actualizar Vagrant"
    } else {
        Show-OK "Vagrant: OK"
    }
    
    if ($RAMResult.Available) {
        Show-OK "RAM Disponible: OK ($($RAMResult.Free_GB) GB)"
    } else {
        Show-Warn "RAM Disponible: BAJA ($($RAMResult.Free_GB) GB)"
        $warnings += "Cerrar aplicaciones para liberar RAM"
    }
    
    if ($DiskResult.Available) {
        Show-OK "Espacio en Disco: OK ($($DiskResult.Free_GB) GB)"
    } else {
        Show-Warn "Espacio en Disco: LIMITADO ($($DiskResult.Free_GB) GB)"
        $warnings += "Liberar espacio en disco"
    }
    
    if ($AdaptersResult.OK) {
        if ($AdaptersResult.Count -le 1) {
            Show-OK "Adaptadores Host-Only: OK ($($AdaptersResult.Count))"
        } else {
            Show-Warn "Adaptadores Host-Only: MULTIPLES ($($AdaptersResult.Count))"
            $warnings += "Ejecutar fix-network.ps1 para evitar Ghost Adapters"
        }
    } else {
        Show-Warn "Adaptadores Host-Only: MULTIPLES ($($AdaptersResult.Count))"
        $warnings += "Ejecutar fix-network.ps1 ANTES de vagrant up"
    }
    
    if ($PortsResult.AllAvailable) {
        Show-OK "Puertos Requeridos: TODOS DISPONIBLES"
    } else {
        Show-Warn "Puertos Requeridos: $($PortsResult.InUse.Count) EN USO"
        $warnings += "Detener procesos usando puertos: $($PortsResult.InUse -join ', ')"
    }
    
    if ($VagrantfileResult.Exists -and $VagrantfileResult.Valid) {
        Show-OK "Vagrantfile: OK"
    } elseif ($VagrantfileResult.Exists) {
        Show-Warn "Vagrantfile: ERRORES DE SINTAXIS"
        $warnings += "Corregir errores en Vagrantfile"
    } else {
        Show-Fail "Vagrantfile: NO ENCONTRADO"
        $blockers += "Vagrantfile no existe"
        $readyForVagrantUp = $false
    }
    
    # Resultado final
    Write-Host ""
    Write-Host "========================================" -ForegroundColor $InfoColor
    Write-Host " RESULTADO FINAL" -ForegroundColor $InfoColor
    Write-Host "========================================" -ForegroundColor $InfoColor
    Write-Host ""
    
    if ($blockers.Count -gt 0) {
        Show-Fail "NO ES SEGURO ejecutar 'vagrant up'"
        Write-Host ""
        Show-Info "Problemas bloqueantes:"
        foreach ($blocker in $blockers) {
            Write-Host "  - $blocker" -ForegroundColor Red
        }
        Write-Log "Sistema NO listo - bloqueantes: $($blockers.Count)" "ERROR"
    } elseif ($warnings.Count -gt 0) {
        Show-Warn "PUEDES ejecutar 'vagrant up' con advertencias"
        Write-Host ""
        Show-Info "Advertencias (opcionales):"
        foreach ($warning in $warnings) {
            Write-Host "  - $warning" -ForegroundColor Yellow
        }
        Write-Log "Sistema listo con advertencias: $($warnings.Count)" "WARN"
    } else {
        Show-OK "SISTEMA LISTO - Puedes ejecutar 'vagrant up'"
        Write-Host ""
        Show-Info "Todos los requisitos se cumplen correctamente"
        Write-Log "Sistema completamente listo" "INFO"
    }
    
    Write-Host ""
}

# Funcion principal
function Main {
    Initialize-Logging
    Show-Header
    
    # Ejecutar verificaciones
    $vboxResult = Test-VirtualBoxInstalled
    $vagrantResult = Test-VagrantInstalled
    $ramResult = Test-AvailableRAM
    $diskResult = Test-DiskSpace
    $adaptersResult = Test-HostOnlyAdapters
    $portsResult = Test-PortsAvailable
    $vagrantfileResult = Test-VagrantfileExists
    
    # Mostrar resumen
    Show-FinalSummary -VBoxResult $vboxResult `
                      -VagrantResult $vagrantResult `
                      -RAMResult $ramResult `
                      -DiskResult $diskResult `
                      -AdaptersResult $adaptersResult `
                      -PortsResult $portsResult `
                      -VagrantfileResult $vagrantfileResult
    
    Write-Log "=== Fin de verificacion de requisitos ===" "INFO"
    Write-Host "  [INFO] Log guardado en: $($script:LogFile)" -ForegroundColor $InfoColor
    Write-Host ""
}

# Ejecutar
Main
