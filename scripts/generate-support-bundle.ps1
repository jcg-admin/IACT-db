# generate-support-bundle.ps1
# Script para generar bundle de diagnostico completo del sistema IACT DevBox
# Recopila logs, configuracion, y estado del sistema para soporte tecnico
# Version: 1.0.0

#Requires -Version 5.1

[CmdletBinding()]
param(
    [string]$OutputPath,
    [switch]$IncludeLogs,
    [switch]$IncludeVagrantfile,
    [switch]$CompressBundle = $true,
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
$script:Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$script:BundleName = "support-bundle_$($script:Timestamp)"
$script:TempPath = Join-Path $env:TEMP $script:BundleName

if (-not $OutputPath) {
    $OutputPath = Join-Path $script:ProjectRoot $script:BundleName
}

# Funciones de output
function Show-Header {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor $InfoColor
    Write-Host " IACT DevBox - Support Bundle Generator" -ForegroundColor $InfoColor
    Write-Host " Version: 1.0.0" -ForegroundColor $InfoColor
    Write-Host "========================================" -ForegroundColor $InfoColor
    Write-Host ""
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
}

function Show-Fail {
    param([string]$Message)
    Write-Host "  [FAIL] $Message" -ForegroundColor $ErrorColor
}

function Show-Warn {
    param([string]$Message)
    Write-Host "  [WARN] $Message" -ForegroundColor $WarningColor
}

function Show-Info {
    param([string]$Message)
    Write-Host "  [INFO] $Message" -ForegroundColor $InfoColor
}

# Funcion para mostrar ayuda
function Show-Help {
    Show-Header

    Write-Host "DESCRIPCION:"
    Write-Host "  Genera un bundle de diagnostico completo con logs, configuracion y estado del sistema."
    Write-Host "  Util para reportar problemas o solicitar soporte tecnico."
    Write-Host ""
    Write-Host "USO:"
    Write-Host "  .\generate-support-bundle.ps1 [-OutputPath <path>] [-IncludeLogs] [-IncludeVagrantfile] [-Help]"
    Write-Host ""
    Write-Host "PARAMETROS:"
    Write-Host "  -OutputPath <path>       Ruta donde guardar el bundle (default: directorio actual)"
    Write-Host "  -IncludeLogs             Incluir todos los logs del directorio logs/"
    Write-Host "  -IncludeVagrantfile      Incluir copia del Vagrantfile"
    Write-Host "  -CompressBundle          Comprimir bundle en .zip (default: true)"
    Write-Host "  -Help                    Mostrar esta ayuda"
    Write-Host ""
    Write-Host "CONTENIDO DEL BUNDLE:"
    Write-Host "  - Informacion del sistema (OS, PowerShell, RAM, Disco)"
    Write-Host "  - Version de VirtualBox y Vagrant"
    Write-Host "  - Estado de las VMs"
    Write-Host "  - Adaptadores Host-Only configurados"
    Write-Host "  - Conectividad de red"
    Write-Host "  - Puertos en uso"
    Write-Host "  - Logs de diagnostico"
    Write-Host "  - (Opcional) Logs de provisioning"
    Write-Host "  - (Opcional) Vagrantfile"
    Write-Host ""
    Write-Host "EJEMPLOS:"
    Write-Host "  .\generate-support-bundle.ps1"
    Write-Host "    Generar bundle basico"
    Write-Host ""
    Write-Host "  .\generate-support-bundle.ps1 -IncludeLogs -IncludeVagrantfile"
    Write-Host "    Generar bundle completo con todos los logs"
    Write-Host ""
    Write-Host "  .\generate-support-bundle.ps1 -OutputPath C:\Support"
    Write-Host "    Guardar bundle en ubicacion especifica"
    Write-Host ""
}

# 1. Crear directorio temporal
function Initialize-Bundle {
    Show-Section "Inicializando Bundle de Diagnostico"

    try {
        if (Test-Path $script:TempPath) {
            Remove-Item -Path $script:TempPath -Recurse -Force
        }

        New-Item -ItemType Directory -Path $script:TempPath -Force | Out-Null
        Show-OK "Directorio temporal creado: $script:TempPath"
        return $true

    } catch {
        Show-Fail "Error creando directorio temporal: $_"
        return $false
    }
}

# 2. Recopilar informacion del sistema
function Collect-SystemInfo {
    Show-Section "Recopilando Informacion del Sistema"

    $outputFile = Join-Path $script:TempPath "system-info.txt"

    try {
        $info = @"
========================================
IACT DevBox - System Information
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
========================================

SISTEMA OPERATIVO
-----------------
$((Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version, OSArchitecture, BuildNumber | Format-List | Out-String).Trim())

POWERSHELL
----------
Version: $($PSVersionTable.PSVersion)
Edition: $($PSVersionTable.PSEdition)

HARDWARE
--------
$((Get-CimInstance Win32_ComputerSystem | Select-Object Manufacturer, Model, TotalPhysicalMemory | Format-List | Out-String).Trim())

PROCESADOR
----------
$((Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors | Format-List | Out-String).Trim())

MEMORIA RAM
-----------
$((Get-CimInstance Win32_OperatingSystem | Select-Object @{Name="TotalMemory_GB";Expression={[math]::Round($_.TotalVisibleMemorySize/1MB,2)}}, @{Name="FreeMemory_GB";Expression={[math]::Round($_.FreePhysicalMemory/1MB,2)}} | Format-List | Out-String).Trim())

DISCOS
------
$((Get-PSDrive -PSProvider FileSystem | Where-Object {$_.Free -ne $null} | Select-Object Name, @{Name="Used_GB";Expression={[math]::Round(($_.Used)/1GB,2)}}, @{Name="Free_GB";Expression={[math]::Round($_.Free/1GB,2)}} | Format-Table | Out-String).Trim())

"@

        $info | Out-File -FilePath $outputFile -Encoding UTF8
        Show-OK "Informacion del sistema guardada"
        return $true

    } catch {
        Show-Fail "Error recopilando informacion del sistema: $_"
        return $false
    }
}

# 3. Recopilar versiones de software
function Collect-SoftwareVersions {
    Show-Section "Recopilando Versiones de Software"

    $outputFile = Join-Path $script:TempPath "software-versions.txt"

    try {
        $versions = @"
========================================
Software Versions
========================================

"@

        # VirtualBox
        try {
            $vboxVersion = & VBoxManage --version 2>&1
            $versions += "VirtualBox: $vboxVersion`r`n"
        } catch {
            $versions += "VirtualBox: NOT INSTALLED`r`n"
        }

        # Vagrant
        try {
            $vagrantVersion = & vagrant --version 2>&1
            $versions += "Vagrant: $vagrantVersion`r`n"
        } catch {
            $versions += "Vagrant: NOT INSTALLED`r`n"
        }

        # Git (opcional)
        try {
            $gitVersion = & git --version 2>&1
            $versions += "Git: $gitVersion`r`n"
        } catch {
            $versions += "Git: NOT INSTALLED`r`n"
        }

        $versions | Out-File -FilePath $outputFile -Encoding UTF8
        Show-OK "Versiones de software guardadas"
        return $true

    } catch {
        Show-Fail "Error recopilando versiones: $_"
        return $false
    }
}

# 4. Recopilar estado de VMs
function Collect-VMStatus {
    Show-Section "Recopilando Estado de VMs"

    $outputFile = Join-Path $script:TempPath "vm-status.txt"

    try {
        Push-Location $script:ProjectRoot

        $status = @"
========================================
VM Status
========================================

VAGRANT STATUS
--------------
$((& vagrant status 2>&1) -join "`r`n")

VAGRANT GLOBAL STATUS
---------------------
$((& vagrant global-status 2>&1) -join "`r`n")

"@

        $status | Out-File -FilePath $outputFile -Encoding UTF8
        Pop-Location

        Show-OK "Estado de VMs guardado"
        return $true

    } catch {
        Pop-Location
        Show-Fail "Error recopilando estado de VMs: $_"
        return $false
    }
}

# 5. Recopilar configuracion de adaptadores
function Collect-NetworkAdapters {
    Show-Section "Recopilando Configuracion de Red"

    $outputFile = Join-Path $script:TempPath "network-adapters.txt"

    try {
        $network = @"
========================================
Network Configuration
========================================

HOST-ONLY ADAPTERS (VBoxManage)
--------------------------------
$((& VBoxManage list hostonlyifs 2>&1) -join "`r`n")

NETWORK ADAPTERS (Windows)
---------------------------
$((Get-NetAdapter | Where-Object {$_.Name -like "*VirtualBox*"} | Format-List | Out-String).Trim())

IP CONFIGURATION
----------------
$((Get-NetIPAddress | Where-Object {$_.InterfaceAlias -like "*VirtualBox*"} | Format-List | Out-String).Trim())

"@

        $network | Out-File -FilePath $outputFile -Encoding UTF8
        Show-OK "Configuracion de red guardada"
        return $true

    } catch {
        Show-Fail "Error recopilando configuracion de red: $_"
        return $false
    }
}

# 6. Recopilar test de conectividad
function Collect-ConnectivityTests {
    Show-Section "Recopilando Tests de Conectividad"

    $outputFile = Join-Path $script:TempPath "connectivity-tests.txt"

    try {
        $connectivity = @"
========================================
Connectivity Tests
========================================

"@

        $vms = @{
            "MariaDB" = "192.168.56.10"
            "PostgreSQL" = "192.168.56.11"
            "Adminer" = "192.168.56.12"
        }

        foreach ($vm in $vms.GetEnumerator()) {
            $connectivity += "`r`nPING TEST: $($vm.Key) ($($vm.Value))`r`n"
            $connectivity += "----------------------------------------`r`n"

            try {
                $pingResult = Test-Connection -ComputerName $vm.Value -Count 4 -ErrorAction Stop
                $connectivity += ($pingResult | Format-Table | Out-String)
            } catch {
                $connectivity += "FAILED: $_`r`n"
            }
        }

        $connectivity | Out-File -FilePath $outputFile -Encoding UTF8
        Show-OK "Tests de conectividad guardados"
        return $true

    } catch {
        Show-Fail "Error recopilando tests de conectividad: $_"
        return $false
    }
}

# 7. Recopilar puertos en uso
function Collect-PortsInUse {
    Show-Section "Recopilando Puertos en Uso"

    $outputFile = Join-Path $script:TempPath "ports-in-use.txt"

    try {
        $ports = @"
========================================
Ports in Use
========================================

REQUIRED PORTS STATUS
---------------------
"@

        $requiredPorts = @(3306, 5432, 80, 443)

        foreach ($port in $requiredPorts) {
            $ports += "`r`nPort $port :`r`n"

            try {
                $connection = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue

                if ($connection) {
                    $ports += "  Status: IN USE`r`n"
                    foreach ($conn in $connection) {
                        try {
                            $process = Get-Process -Id $conn.OwningProcess -ErrorAction SilentlyContinue
                            $ports += "  Process: $($process.ProcessName) (PID: $($conn.OwningProcess))`r`n"
                        } catch {
                            $ports += "  Process: PID $($conn.OwningProcess)`r`n"
                        }
                    }
                } else {
                    $ports += "  Status: AVAILABLE`r`n"
                }
            } catch {
                $ports += "  Status: AVAILABLE`r`n"
            }
        }

        $ports += "`r`n`r`nALL LISTENING PORTS`r`n"
        $ports += "-------------------`r`n"
        $ports += (Get-NetTCPConnection -State Listen | Select-Object LocalAddress, LocalPort, OwningProcess | Sort-Object LocalPort | Format-Table | Out-String)

        $ports | Out-File -FilePath $outputFile -Encoding UTF8
        Show-OK "Puertos en uso guardados"
        return $true

    } catch {
        Show-Fail "Error recopilando puertos: $_"
        return $false
    }
}

# 8. Ejecutar scripts de diagnostico
function Collect-DiagnosticScripts {
    Show-Section "Ejecutando Scripts de Diagnostico"

    $scriptsPath = Join-Path $script:ProjectRoot "scripts"

    # diagnose-system.ps1
    $diagnoseScript = Join-Path $scriptsPath "diagnose-system.ps1"
    if (Test-Path $diagnoseScript) {
        try {
            Show-Info "Ejecutando diagnose-system.ps1..."
            $diagnoseOutput = & $diagnoseScript 2>&1 | Out-String
            $diagnoseOutput | Out-File -FilePath (Join-Path $script:TempPath "diagnose-system-output.txt") -Encoding UTF8
            Show-OK "Diagnostico del sistema ejecutado"
        } catch {
            Show-Warn "Error ejecutando diagnose-system.ps1: $_"
        }
    }

    # check-prerequisites.ps1
    $prereqScript = Join-Path $scriptsPath "check-prerequisites.ps1"
    if (Test-Path $prereqScript) {
        try {
            Show-Info "Ejecutando check-prerequisites.ps1..."
            $prereqOutput = & $prereqScript 2>&1 | Out-String
            $prereqOutput | Out-File -FilePath (Join-Path $script:TempPath "check-prerequisites-output.txt") -Encoding UTF8
            Show-OK "Verificacion de requisitos ejecutada"
        } catch {
            Show-Warn "Error ejecutando check-prerequisites.ps1: $_"
        }
    }

    # verify-vms.ps1
    $verifyScript = Join-Path $scriptsPath "verify-vms.ps1"
    if (Test-Path $verifyScript) {
        try {
            Show-Info "Ejecutando verify-vms.ps1..."
            $verifyOutput = & $verifyScript 2>&1 | Out-String
            $verifyOutput | Out-File -FilePath (Join-Path $script:TempPath "verify-vms-output.txt") -Encoding UTF8
            Show-OK "Verificacion de VMs ejecutada"
        } catch {
            Show-Warn "Error ejecutando verify-vms.ps1: $_"
        }
    }

    return $true
}

# 9. Copiar logs de provisioning
function Collect-ProvisioningLogs {
    Show-Section "Recopilando Logs de Provisioning"

    if (-not $IncludeLogs) {
        Show-Info "Logs de provisioning omitidos (usar -IncludeLogs para incluir)"
        return $true
    }

    $logsPath = Join-Path $script:ProjectRoot "logs"

    if (-not (Test-Path $logsPath)) {
        Show-Warn "Directorio logs/ no existe"
        return $true
    }

    try {
        $logsDestPath = Join-Path $script:TempPath "logs"
        New-Item -ItemType Directory -Path $logsDestPath -Force | Out-Null

        $logFiles = Get-ChildItem -Path $logsPath -Filter "*.log" -File

        foreach ($logFile in $logFiles) {
            Copy-Item -Path $logFile.FullName -Destination $logsDestPath -Force
        }

        Show-OK "$($logFiles.Count) archivos de log copiados"
        return $true

    } catch {
        Show-Fail "Error copiando logs: $_"
        return $false
    }
}

# 10. Copiar Vagrantfile
function Collect-Vagrantfile {
    Show-Section "Recopilando Vagrantfile"

    if (-not $IncludeVagrantfile) {
        Show-Info "Vagrantfile omitido (usar -IncludeVagrantfile para incluir)"
        return $true
    }

    $vagrantfilePath = Join-Path $script:ProjectRoot "Vagrantfile"

    if (-not (Test-Path $vagrantfilePath)) {
        Show-Warn "Vagrantfile no encontrado"
        return $true
    }

    try {
        Copy-Item -Path $vagrantfilePath -Destination (Join-Path $script:TempPath "Vagrantfile") -Force
        Show-OK "Vagrantfile copiado"
        return $true

    } catch {
        Show-Fail "Error copiando Vagrantfile: $_"
        return $false
    }
}

# 11. Crear README del bundle
function Create-BundleReadme {
    Show-Section "Creando README del Bundle"

    $readmePath = Join-Path $script:TempPath "README.txt"

    try {
        $readme = @"
========================================
IACT DevBox - Support Bundle
========================================

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Bundle Name: $script:BundleName
Project Root: $script:ProjectRoot

CONTENIDO DEL BUNDLE
--------------------

system-info.txt                 - Informacion del sistema operativo y hardware
software-versions.txt           - Versiones de VirtualBox, Vagrant, Git
vm-status.txt                   - Estado de las VMs (vagrant status)
network-adapters.txt            - Configuracion de adaptadores Host-Only
connectivity-tests.txt          - Tests de ping a las VMs
ports-in-use.txt                - Puertos en uso y disponibles
diagnose-system-output.txt      - Salida de diagnose-system.ps1
check-prerequisites-output.txt  - Salida de check-prerequisites.ps1
verify-vms-output.txt           - Salida de verify-vms.ps1

$(if ($IncludeLogs) { "logs/                            - Logs de provisioning de las VMs" } else { "" })
$(if ($IncludeVagrantfile) { "Vagrantfile                      - Configuracion de Vagrant" } else { "" })

USO
---

1. Revisar los archivos de diagnostico
2. Identificar errores o advertencias
3. Compartir este bundle con soporte tecnico si es necesario

NOTA: Este bundle NO contiene informacion sensible como contraseñas.
      Solo contiene logs y configuracion del sistema.

"@

        $readme | Out-File -FilePath $readmePath -Encoding UTF8
        Show-OK "README creado"
        return $true

    } catch {
        Show-Fail "Error creando README: $_"
        return $false
    }
}

# 12. Comprimir bundle
function Compress-Bundle {
    Show-Section "Comprimiendo Bundle"

    if (-not $CompressBundle) {
        Show-Info "Compresion omitida"

        # Copiar directorio sin comprimir
        try {
            if (Test-Path $OutputPath) {
                Remove-Item -Path $OutputPath -Recurse -Force
            }

            Copy-Item -Path $script:TempPath -Destination $OutputPath -Recurse -Force
            Show-OK "Bundle guardado en: $OutputPath"
            return $true
        } catch {
            Show-Fail "Error copiando bundle: $_"
            return $false
        }
    }

    try {
        $zipPath = "$OutputPath.zip"

        if (Test-Path $zipPath) {
            Remove-Item -Path $zipPath -Force
        }

        Compress-Archive -Path "$script:TempPath\*" -DestinationPath $zipPath -CompressionLevel Optimal -Force

        $zipSize = [math]::Round((Get-Item $zipPath).Length / 1MB, 2)
        Show-OK "Bundle comprimido: $zipPath"
        Show-OK "Tamano: $zipSize MB"

        return $true

    } catch {
        Show-Fail "Error comprimiendo bundle: $_"
        return $false
    }
}

# 13. Limpiar directorio temporal
function Cleanup-TempDirectory {
    Show-Section "Limpiando Archivos Temporales"

    try {
        if (Test-Path $script:TempPath) {
            Remove-Item -Path $script:TempPath -Recurse -Force
            Show-OK "Directorio temporal eliminado"
        }
        return $true

    } catch {
        Show-Warn "No se pudo eliminar directorio temporal: $_"
        return $false
    }
}

# Funcion principal
function Main {
    if ($Help) {
        Show-Help
        return
    }

    Show-Header

    Write-Host "  Generando bundle de diagnostico completo..." -ForegroundColor $InfoColor
    Write-Host "  Timestamp: $script:Timestamp" -ForegroundColor Gray
    Write-Host "  Output: $OutputPath" -ForegroundColor Gray
    Write-Host ""

    # Ejecutar pasos
    if (-not (Initialize-Bundle)) { return }

    Collect-SystemInfo
    Collect-SoftwareVersions
    Collect-VMStatus
    Collect-NetworkAdapters
    Collect-ConnectivityTests
    Collect-PortsInUse
    Collect-DiagnosticScripts
    Collect-ProvisioningLogs
    Collect-Vagrantfile
    Create-BundleReadme

    if (-not (Compress-Bundle)) { return }

    Cleanup-TempDirectory

    # Resumen final
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host " BUNDLE GENERADO EXITOSAMENTE" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""

    if ($CompressBundle) {
        Write-Host "  Ubicacion: $OutputPath.zip" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  Puedes compartir este archivo con soporte tecnico" -ForegroundColor Gray
    } else {
        Write-Host "  Ubicacion: $OutputPath" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  Puedes comprimir esta carpeta manualmente si lo necesitas" -ForegroundColor Gray
    }

    Write-Host ""
}

# Ejecutar
Main