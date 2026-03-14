# verify-vms.ps1
# Script de verificacion completa del sistema IACT DevBox
# Version: 1.0.1 (FIXED - Deteccion mejorada de provisioning)

#Requires -Version 5.1

# Configuracion de colores
$script:SuccessColor = "Green"
$script:ErrorColor = "Red"
$script:WarningColor = "Yellow"
$script:InfoColor = "Cyan"

# Configuracion de VMs
$script:VMs = @{
    "mariadb" = @{
        Name = "mariadb"
        IP = "192.168.56.10"
        Ports = @(3306)
        RequiredLogs = @("mariadb_bootstrap.log", "mariadb_install.log", "mariadb_setup.log")
    }
    "postgresql" = @{
        Name = "postgresql"
        IP = "192.168.56.11"
        Ports = @(5432)
        RequiredLogs = @("postgres_bootstrap.log", "postgres_install.log", "postgres_setup.log")
    }
    "adminer" = @{
        Name = "adminer"
        IP = "192.168.56.12"
        Ports = @(80, 443)
        RequiredLogs = @("adminer_bootstrap.log", "adminer_install.log", "adminer_ssl.log", "adminer_swap.log")
    }
}

# Funcion para mostrar header
function Show-Header {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor $InfoColor
    Write-Host " IACT DevBox - System Verification" -ForegroundColor $InfoColor
    Write-Host " Version: 1.0.1" -ForegroundColor $InfoColor
    Write-Host "========================================" -ForegroundColor $InfoColor
    Write-Host ""
}

# Funcion para mostrar seccion
function Show-Section {
    param([string]$Title)
    Write-Host ""
    Write-Host "$Title" -ForegroundColor $InfoColor
    Write-Host ("-" * $Title.Length) -ForegroundColor $InfoColor
}

# Funcion para mostrar resultado OK
function Show-OK {
    param([string]$Message)
    Write-Host "  [OK] $Message" -ForegroundColor $SuccessColor
}

# Funcion para mostrar resultado FAIL
function Show-Fail {
    param([string]$Message)
    Write-Host "  [FAIL] $Message" -ForegroundColor $ErrorColor
}

# Funcion para mostrar resultado WARN
function Show-Warn {
    param([string]$Message)
    Write-Host "  [WARN] $Message" -ForegroundColor $WarningColor
}

# Funcion para mostrar resultado INFO
function Show-Info {
    param([string]$Message)
    Write-Host "  [INFO] $Message" -ForegroundColor $InfoColor
}

# 1. Verificar VirtualBox instalado
function Test-VirtualBox {
    Show-Section "1. Verificando VirtualBox"

    try {
        $vboxVersion = & VBoxManage --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Show-OK "VirtualBox instalado: $vboxVersion"
            return $true
        } else {
            Show-Fail "VirtualBox no encontrado"
            Show-Info "Descarga desde: https://www.virtualbox.org/"
            return $false
        }
    } catch {
        Show-Fail "VirtualBox no encontrado"
        Show-Info "Descarga desde: https://www.virtualbox.org/"
        return $false
    }
}

# 2. Verificar Vagrant instalado
function Test-Vagrant {
    Show-Section "2. Verificando Vagrant"

    try {
        $vagrantVersion = & vagrant --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Show-OK "Vagrant instalado: $vagrantVersion"
            return $true
        } else {
            Show-Fail "Vagrant no encontrado"
            Show-Info "Descarga desde: https://www.vagrantup.com/"
            return $false
        }
    } catch {
        Show-Fail "Vagrant no encontrado"
        Show-Info "Descarga desde: https://www.vagrantup.com/"
        return $false
    }
}

# 3. Verificar estado de VMs
function Test-VMStatus {
    Show-Section "3. Verificando estado de VMs"

    try {
        $status = & vagrant status 2>&1
        if ($LASTEXITCODE -ne 0) {
            Show-Fail "No se pudo obtener estado de VMs"
            Show-Info "Ejecutar desde el directorio del proyecto"
            return $false
        }

        $runningCount = 0
        $totalCount = $script:VMs.Count

        foreach ($vm in $script:VMs.Values) {
            if ($status -match "$($vm.Name)\s+running") {
                Show-OK "$($vm.Name) esta corriendo"
                $runningCount++
            } elseif ($status -match "$($vm.Name)\s+poweroff") {
                Show-Warn "$($vm.Name) esta apagada"
            } elseif ($status -match "$($vm.Name)\s+not created") {
                Show-Warn "$($vm.Name) no ha sido creada"
            } else {
                Show-Warn "$($vm.Name) estado desconocido"
            }
        }

        Write-Host ""
        if ($runningCount -eq $totalCount) {
            Show-OK "Todas las VMs ($runningCount/$totalCount) estan corriendo"
            return $true
        } else {
            Show-Warn "Solo $runningCount/$totalCount VMs corriendo"
            return $false
        }
    } catch {
        Show-Fail "Error al verificar estado de VMs: $_"
        return $false
    }
}

# 4. Verificar logs generados
function Test-Logs {
    Show-Section "4. Verificando logs generados"

    $logsPath = "logs"
    if (-not (Test-Path $logsPath)) {
        Show-Fail "Directorio logs/ no existe"
        return $false
    }

    $allLogs = @()
    foreach ($vm in $script:VMs.Values) {
        $allLogs += $vm.RequiredLogs
    }

    $foundCount = 0
    $missingLogs = @()

    foreach ($logFile in $allLogs) {
        $logPath = Join-Path $logsPath $logFile
        if (Test-Path $logPath) {
            $foundCount++
        } else {
            $missingLogs += $logFile
        }
    }

    $totalLogs = $allLogs.Count

    if ($foundCount -eq $totalLogs) {
        Show-OK "Todos los logs generados ($foundCount/$totalLogs)"
    } else {
        Show-Warn "$foundCount/$totalLogs logs encontrados"
        foreach ($missing in $missingLogs) {
            Show-Info "Faltante: $missing"
        }
    }

    # Verificar errores en logs
    $errorCount = 0
    if ($foundCount -gt 0) {
        Write-Host ""
        Show-Info "Buscando errores en logs..."

        $logFiles = Get-ChildItem -Path $logsPath -Filter "*.log" -File
        foreach ($logFile in $logFiles) {
            $errors = Select-String -Path $logFile.FullName -Pattern "\[ERROR\]" -SimpleMatch
            if ($errors) {
                $errorCount += $errors.Count
            }
        }

        if ($errorCount -eq 0) {
            Show-OK "No se encontraron errores en logs"
        } else {
            Show-Warn "Se encontraron $errorCount errores en logs"
            Show-Info "Revisar con: Select-String -Path logs\*.log -Pattern '\[ERROR\]'"
        }
    }

    return ($foundCount -gt 0)
}

# 5. Verificar conectividad de red
function Test-NetworkConnectivity {
    Show-Section "5. Verificando conectividad de red"

    $allReachable = $true

    foreach ($vm in $script:VMs.Values) {
        $pingResult = Test-Connection -ComputerName $vm.IP -Count 1 -Quiet -ErrorAction SilentlyContinue

        if ($pingResult) {
            Show-OK "$($vm.Name) ($($vm.IP)) alcanzable"
        } else {
            Show-Fail "$($vm.Name) ($($vm.IP)) NO alcanzable"
            $allReachable = $false
        }
    }

    return $allReachable
}

# 6. Verificar puertos de servicios
function Test-ServicePorts {
    Show-Section "6. Verificando puertos de servicios"

    $allPortsOpen = $true

    foreach ($vm in $script:VMs.Values) {
        foreach ($port in $vm.Ports) {
            try {
                $connection = Test-NetConnection -ComputerName $vm.IP -Port $port -WarningAction SilentlyContinue -ErrorAction Stop

                if ($connection.TcpTestSucceeded) {
                    Show-OK "$($vm.Name) puerto $port abierto"
                } else {
                    Show-Fail "$($vm.Name) puerto $port cerrado"
                    $allPortsOpen = $false
                }
            } catch {
                Show-Fail "$($vm.Name) puerto $port - error al verificar"
                $allPortsOpen = $false
            }
        }
    }

    return $allPortsOpen
}

# 7. Verificar Adminer Web Interface
function Test-AdminerWeb {
    Show-Section "7. Verificando Adminer Web Interface"

    $adminerIP = $script:VMs["adminer"].IP

    # Verificar HTTP
    try {
        $httpResponse = Invoke-WebRequest -Uri "http://$adminerIP" -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
        if ($httpResponse.StatusCode -eq 200) {
            Show-OK "Adminer HTTP (puerto 80) accesible"
        } else {
            Show-Warn "Adminer HTTP respondio con codigo: $($httpResponse.StatusCode)"
        }
    } catch {
        Show-Fail "Adminer HTTP no accesible"
        Show-Info "URL: http://$adminerIP"
    }

    # Verificar HTTPS (puede fallar por certificado autofirmado)
    try {
        # Ignorar errores de certificado SSL para desarrollo
        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
        $httpsResponse = Invoke-WebRequest -Uri "https://$adminerIP" -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop

        if ($httpsResponse.StatusCode -eq 200) {
            Show-OK "Adminer HTTPS (puerto 443) accesible"
        } else {
            Show-Warn "Adminer HTTPS respondio con codigo: $($httpsResponse.StatusCode)"
        }
    } catch {
        Show-Warn "Adminer HTTPS no accesible (normal si SSL no configurado)"
        Show-Info "URL: https://$adminerIP"
    } finally {
        # Restaurar validacion de certificados
        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = $null
    }
}

# 8. Verificar provision completado (VERSION MEJORADA)
function Test-ProvisionCompleted {
    Show-Section "8. Verificando provision completado"

    $logsPath = "logs"
    if (-not (Test-Path $logsPath)) {
        Show-Fail "Directorio logs/ no existe"
        return $false
    }

    $bootstrapLogs = @(
        "mariadb_bootstrap.log",
        "postgres_bootstrap.log",
        "adminer_bootstrap.log"
    )

    $completedCount = 0

    foreach ($logFile in $bootstrapLogs) {
        $logPath = Join-Path $logsPath $logFile

        if (Test-Path $logPath) {
            $content = Get-Content $logPath -Raw

            # CORRECCION: Buscar multiples patrones de exito (case-insensitive)
            $patterns = @(
                "completed successfully",
                "\[SUCCESS\].*complet",
                "\[OK\].*complet",
                "provisioning completed",
                "VM Ready",
                "All steps completed successfully",
                "PROVISIONING COMPLETE"
            )

            $provisionOK = $false
            foreach ($pattern in $patterns) {
                if ($content -match "(?i)$pattern") {
                    $provisionOK = $true
                    break
                }
            }

            if ($provisionOK) {
                $vmName = $logFile -replace "_bootstrap.log", ""
                Show-OK "$vmName provision completado"
                $completedCount++
            } else {
                $vmName = $logFile -replace "_bootstrap.log", ""
                Show-Warn "$vmName provision incompleto o con errores"
                Show-Info "Revisar log: $logPath"
            }
        } else {
            $vmName = $logFile -replace "_bootstrap.log", ""
            Show-Warn "$vmName log no encontrado"
        }
    }

    $totalVMs = $bootstrapLogs.Count

    Write-Host ""
    if ($completedCount -eq $totalVMs) {
        Show-OK "Todas las VMs ($completedCount/$totalVMs) provisionadas exitosamente"
        return $true
    } else {
        Show-Warn "Solo $completedCount/$totalVMs VMs provisionadas completamente"
        Show-Info "Nota: Si las VMs funcionan correctamente, esto puede ser un falso negativo"
        return $false
    }
}

# Funcion para mostrar resumen final
function Show-Summary {
    param(
        [bool]$VBoxOK,
        [bool]$VagrantOK,
        [bool]$VMStatusOK,
        [bool]$LogsOK,
        [bool]$NetworkOK,
        [bool]$PortsOK,
        [bool]$ProvisionOK
    )

    Show-Section "Resumen de Verificacion"

    $checks = @(
        @{Name = "VirtualBox instalado"; Status = $VBoxOK},
        @{Name = "Vagrant instalado"; Status = $VagrantOK},
        @{Name = "VMs corriendo"; Status = $VMStatusOK},
        @{Name = "Logs generados"; Status = $LogsOK},
        @{Name = "Conectividad de red"; Status = $NetworkOK},
        @{Name = "Puertos de servicios"; Status = $PortsOK},
        @{Name = "Provision completado"; Status = $ProvisionOK}
    )

    $passedCount = 0
    $totalCount = $checks.Count

    foreach ($check in $checks) {
        if ($check.Status) {
            Show-OK $check.Name
            $passedCount++
        } else {
            Show-Fail $check.Name
        }
    }

    Write-Host ""
    Write-Host "Resultado: $passedCount/$totalCount verificaciones pasadas" -ForegroundColor $(
        if ($passedCount -eq $totalCount) { $SuccessColor }
        elseif ($passedCount -gt ($totalCount / 2)) { $WarningColor }
        else { $ErrorColor }
    )

    if ($passedCount -eq $totalCount) {
        Write-Host ""
        Write-Host "El sistema esta completamente funcional!" -ForegroundColor $SuccessColor
        Write-Host ""
        Write-Host "Puedes acceder a:" -ForegroundColor $InfoColor
        Write-Host "  - Adminer: http://192.168.56.12" -ForegroundColor $InfoColor
        Write-Host "  - MariaDB: mysql -h 192.168.56.10 -u django_user -p'django_pass'" -ForegroundColor $InfoColor
        Write-Host "  - PostgreSQL: psql -h 192.168.56.11 -U django_user -d iact_analytics" -ForegroundColor $InfoColor
    } elseif ($passedCount -eq 0) {
        Write-Host ""
        Write-Host "El sistema no esta funcional. Ejecutar: vagrant up" -ForegroundColor $ErrorColor
    } else {
        Write-Host ""
        Write-Host "El sistema esta parcialmente funcional. Revisar verificaciones fallidas." -ForegroundColor $WarningColor
        Write-Host ""
        Show-Info "Si la conectividad y puertos funcionan, el sistema esta operativo"
    }
}

# Funcion principal
function Main {
    Show-Header

    # Ejecutar todas las verificaciones
    $vboxOK = Test-VirtualBox
    $vagrantOK = Test-Vagrant

    # Si VirtualBox y Vagrant estan OK, continuar con mas verificaciones
    if ($vboxOK -and $vagrantOK) {
        $vmStatusOK = Test-VMStatus
        $logsOK = Test-Logs
        $networkOK = Test-NetworkConnectivity
        $portsOK = Test-ServicePorts
        Test-AdminerWeb
        $provisionOK = Test-ProvisionCompleted
    } else {
        $vmStatusOK = $false
        $logsOK = $false
        $networkOK = $false
        $portsOK = $false
        $provisionOK = $false

        Write-Host ""
        Show-Warn "No se pueden ejecutar mas verificaciones sin VirtualBox y Vagrant"
    }

    # Mostrar resumen
    Show-Summary -VBoxOK $vboxOK -VagrantOK $vagrantOK -VMStatusOK $vmStatusOK `
                 -LogsOK $logsOK -NetworkOK $networkOK -PortsOK $portsOK `
                 -ProvisionOK $provisionOK

    Write-Host ""
}

# Ejecutar script
Main