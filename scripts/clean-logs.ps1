# clean-logs.ps1
# Script de limpieza y archivo de logs antiguos
# Version: 2.0.0

#Requires -Version 5.1

[CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
param(
    [int]$DaysToKeep = 30,
    [switch]$Compress,
    [switch]$DeleteArchived,
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
$script:ArchivePath = Join-Path $script:LogsPath "archive"
$script:Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$script:CleanLogFile = Join-Path $script:LogsPath "clean-logs_$($script:Timestamp).log"

# Funcion para inicializar logging
function Initialize-Logging {
    if (-not (Test-Path $script:LogsPath)) {
        Write-Host "  [ERROR] Directorio logs/ no existe" -ForegroundColor $ErrorColor
        return $false
    }

    $startMessage = "========================================`r`n"
    $startMessage += "IACT DevBox - Log Cleanup`r`n"
    $startMessage += "Version: 2.0.0`r`n"
    $startMessage += "Timestamp: $($script:Timestamp)`r`n"
    $startMessage += "DaysToKeep: $DaysToKeep`r`n"
    $startMessage += "Compress: $Compress`r`n"
    $startMessage += "========================================`r`n"

    try {
        $startMessage | Out-File -FilePath $script:CleanLogFile -Encoding UTF8 -Confirm:$false
        return $true
    }
    catch {
        Write-Host "  [WARN] No se pudo crear log de limpieza: $_" -ForegroundColor $WarningColor
        return $true
    }
}

# Funcion para escribir a log
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )

    if (-not (Test-Path $script:CleanLogFile)) {
        return
    }

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"

    try {
        $logMessage | Out-File -FilePath $script:CleanLogFile -Append -Encoding UTF8 -Confirm:$false
    }
    catch {
        # Silently fail if log write fails
    }
}

# Funcion para mostrar header
function Show-Header {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor $InfoColor
    Write-Host " IACT DevBox - Log Cleanup Utility" -ForegroundColor $InfoColor
    Write-Host " Version: 2.0.0" -ForegroundColor $InfoColor
    Write-Host "========================================" -ForegroundColor $InfoColor
    Write-Host ""
    Write-Host "  [INFO] Directorio del proyecto: $($script:ProjectRoot)" -ForegroundColor $InfoColor
    Write-Host "  [INFO] Generando log: $($script:CleanLogFile)" -ForegroundColor $InfoColor
    Write-Host ""

    Write-Log "=== Inicio de limpieza de logs ===" "INFO"
}

# Funciones de output
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
    Write-Host "  Limpia logs antiguos y opcionalmente los comprime en archive/"
    Write-Host ""
    Write-Host "USO:"
    Write-Host "  .\clean-logs.ps1 [-DaysToKeep <dias>] [-Compress] [-DeleteArchived] [-WhatIf] [-Confirm] [-Help]"
    Write-Host ""
    Write-Host "PARAMETROS:"
    Write-Host "  -DaysToKeep <int>   Dias a mantener (default: 30)"
    Write-Host "  -Compress           Comprimir logs movidos a archive/"
    Write-Host "  -DeleteArchived     Eliminar logs originales despues de comprimir"
    Write-Host "  -WhatIf             Simular sin hacer cambios"
    Write-Host "  -Confirm            Pedir confirmacion antes de ejecutar"
    Write-Host "  -Help               Mostrar esta ayuda"
    Write-Host ""
    Write-Host "MODOS DE OPERACION:"
    Write-Host ""
    Write-Host "  Modo 1: Solo mover logs antiguos"
    Write-Host "    .\clean-logs.ps1"
    Write-Host "    Mueve logs de mas de 30 dias a archive/"
    Write-Host ""
    Write-Host "  Modo 2: Mover y comprimir"
    Write-Host "    .\clean-logs.ps1 -Compress"
    Write-Host "    Mueve logs antiguos y comprime los de archive/"
    Write-Host ""
    Write-Host "  Modo 3: Mover, comprimir y limpiar"
    Write-Host "    .\clean-logs.ps1 -Compress -DeleteArchived"
    Write-Host "    Mueve, comprime y elimina .log originales de archive/"
    Write-Host ""
    Write-Host "EJEMPLOS:"
    Write-Host ""
    Write-Host "  .\clean-logs.ps1"
    Write-Host "    Limpiar logs de mas de 30 dias (default)"
    Write-Host ""
    Write-Host "  .\clean-logs.ps1 -DaysToKeep 0"
    Write-Host "    Limpiar TODOS los logs (util para pruebas)"
    Write-Host ""
    Write-Host "  .\clean-logs.ps1 -DaysToKeep 7"
    Write-Host "    Limpiar logs de mas de 7 dias"
    Write-Host ""
    Write-Host "  .\clean-logs.ps1 -WhatIf"
    Write-Host "    Simular limpieza sin hacer cambios"
    Write-Host ""
    Write-Host "  .\clean-logs.ps1 -Compress -Confirm"
    Write-Host "    Mover y comprimir, pidiendo confirmacion"
    Write-Host ""
    Write-Host "  .\clean-logs.ps1 -DaysToKeep 15 -Compress -DeleteArchived"
    Write-Host "    Limpiar logs de 15+ dias, comprimir y eliminar originales"
    Write-Host ""
}

# Verificar directorio de logs
function Test-LogsDirectory {
    if (-not (Test-Path $script:LogsPath)) {
        Show-Fail "Directorio de logs no encontrado: $script:LogsPath"
        Show-Info "Ejecutar desde la raiz del proyecto"
        return $false
    }
    return $true
}

# Crear directorio de archivo
function Initialize-ArchiveDirectory {
    if (-not (Test-Path $script:ArchivePath)) {
        if ($PSCmdlet.ShouldProcess($script:ArchivePath, "Crear directorio de archivo")) {
            try {
                # CORRECCION: Usar -Confirm:$false para evitar confirmacion duplicada
                New-Item -ItemType Directory -Path $script:ArchivePath -Force -Confirm:$false | Out-Null
                Show-OK "Directorio de archivo creado: archive/"
                Write-Log "Directorio archive/ creado" "INFO"
            }
            catch {
                Show-Fail "No se pudo crear directorio de archivo: $_"
                Write-Log "Error creando archive/: $_" "ERROR"
                return $false
            }
        }
        else {
            Show-Info "[WHATIF] Se crearia directorio: archive/"
        }
    }
    return $true
}

# Obtener logs antiguos
function Get-OldLogs {
    param([int]$Days)

    $cutoffDate = (Get-Date).AddDays(-$Days)

    # Excluir el log de esta ejecucion y los logs de scripts de diagnostico recientes
    $excludePatterns = @(
        "clean-logs_*.log",
        "diagnose-system_*.log",
        "fix-network_*.log",
        "check-prerequisites_*.log",
        "verify-vms_*.log",
        "setup-environment_*.log",
        "generate-support-bundle_*.log"
    )

    $allLogs = Get-ChildItem -Path $script:LogsPath -Filter "*.log" -File

    $oldLogs = $allLogs | Where-Object {
        $isOld = $_.LastWriteTime -lt $cutoffDate
        $isExcluded = $false

        foreach ($pattern in $excludePatterns) {
            if ($_.Name -like $pattern) {
                # Solo excluir si es reciente (menos de 2 dias)
                if ($_.LastWriteTime -gt (Get-Date).AddDays(-2)) {
                    $isExcluded = $true
                    break
                }
            }
        }

        $isOld -and -not $isExcluded
    }

    return $oldLogs
}

# Mover logs al archivo
function Move-LogsToArchive {
    param(
        [Parameter(Mandatory)]
        [System.IO.FileInfo[]]$Logs
    )

    Show-Section "Moviendo Logs Antiguos a Archive"

    $movedCount = 0

    foreach ($log in $Logs) {
        $destPath = Join-Path $script:ArchivePath $log.Name

        if ($PSCmdlet.ShouldProcess($log.Name, "Mover a archive")) {
            try {
                Move-Item -Path $log.FullName -Destination $destPath -Force -Confirm:$false
                Show-OK "Movido: $($log.Name)"
                Write-Log "Movido: $($log.Name)" "INFO"
                $movedCount++
            }
            catch {
                Show-Fail "Error moviendo $($log.Name): $_"
                Write-Log "Error moviendo $($log.Name): $_" "ERROR"
            }
        }
        else {
            Show-Info "[WHATIF] Se moveria: $($log.Name)"
        }
    }

    Write-Host ""
    if ($movedCount -gt 0) {
        Show-OK "Total movidos: $movedCount archivos"
        Write-Log "Total movidos: $movedCount" "INFO"
    }

    return $movedCount
}

# Comprimir logs archivados
function Compress-ArchivedLogs {
    Show-Section "Comprimiendo Logs en Archive"

    $logFiles = Get-ChildItem -Path $script:ArchivePath -Filter "*.log" -File

    if ($logFiles.Count -eq 0) {
        Show-Info "No hay logs .log para comprimir en archive/"
        return 0
    }

    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $zipPath = Join-Path $script:ArchivePath "logs_$timestamp.zip"
    $zipName = "logs_$timestamp.zip"

    Show-Info "Encontrados $($logFiles.Count) archivos .log en archive/"

    # Confirmacion UNICA para toda la operacion
    $compressionTarget = "$($logFiles.Count) archivos -> $zipName"

    if ($PSCmdlet.ShouldProcess($compressionTarget, "Comprimir logs")) {
        try {
            Show-Info "Comprimiendo $($logFiles.Count) logs..."

            # Comprimir
            Compress-Archive -Path $logFiles.FullName -DestinationPath $zipPath -Force -Confirm:$false

            $zipSize = (Get-Item $zipPath).Length
            $zipSizeKB = [math]::Round($zipSize / 1KB, 2)

            Show-OK "Logs comprimidos: $zipName"
            Show-Info "Tamano del archivo: $zipSizeKB KB"
            Write-Log "Comprimido: $zipName ($zipSizeKB KB)" "INFO"

            # Eliminar logs originales SI se especifico -DeleteArchived
            if ($DeleteArchived) {
                Write-Host ""
                Show-Info "Eliminando archivos .log originales..."

                $deletedCount = 0
                foreach ($log in $logFiles) {
                    try {
                        Remove-Item -Path $log.FullName -Force -Confirm:$false -ErrorAction Stop
                        Show-OK "Eliminado: $($log.Name)"
                        Write-Log "Eliminado: $($log.Name)" "INFO"
                        $deletedCount++
                    }
                    catch {
                        Show-Warn "No se pudo eliminar $($log.Name): $_"
                        Write-Log "Error eliminando $($log.Name): $_" "WARN"
                    }
                }

                Write-Host ""
                Show-OK "Archivos .log eliminados: $deletedCount"
                Write-Log "Total eliminados: $deletedCount" "INFO"
            }
            else {
                Write-Host ""
                Show-Info "Archivos .log originales conservados en archive/"
                Show-Info "Para eliminarlos, usa: -DeleteArchived"
            }

            return $logFiles.Count

        }
        catch {
            Show-Fail "Error comprimiendo logs: $_"
            Write-Log "Error comprimiendo: $_" "ERROR"
            return 0
        }
    }
    else {
        Show-Info "[WHATIF] Se comprimirian $($logFiles.Count) archivos en $zipName"
        return 0
    }
}

# Mostrar resumen
function Show-Summary {
    param(
        [int]$MovedCount,
        [int]$CompressedCount
    )

    Show-Section "RESUMEN"

    Write-Host ""

    if ($MovedCount -gt 0) {
        Show-OK "Logs movidos a archive/: $MovedCount"
    }
    else {
        Show-Info "No se movieron logs (ninguno mas antiguo que $DaysToKeep dias)"
    }

    if ($Compress) {
        if ($CompressedCount -gt 0) {
            Show-OK "Logs comprimidos: $CompressedCount"
            if ($DeleteArchived) {
                Show-OK "Archivos .log originales eliminados"
            }
            else {
                Show-Info "Archivos .log originales conservados"
            }
        }
        else {
            Show-Info "No se comprimieron logs"
        }
    }

    Write-Host ""

    # Mostrar estado actual del directorio
    $currentLogs = Get-ChildItem -Path $script:LogsPath -Filter "*.log" -File
    $archiveLogs = Get-ChildItem -Path $script:ArchivePath -Filter "*.log" -File -ErrorAction SilentlyContinue
    $archiveZips = Get-ChildItem -Path $script:ArchivePath -Filter "*.zip" -File -ErrorAction SilentlyContinue

    Show-Info "Estado actual:"
    Show-Info "  logs/ activos: $($currentLogs.Count) archivos .log"
    if (Test-Path $script:ArchivePath) {
        Show-Info "  archive/ logs: $($archiveLogs.Count) archivos .log"
        Show-Info "  archive/ zips: $($archiveZips.Count) archivos .zip"
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

    # Verificar directorio de logs
    if (-not (Test-LogsDirectory)) {
        return
    }

    # Crear directorio de archivo si es necesario
    if (-not (Initialize-ArchiveDirectory)) {
        return
    }

    # Obtener logs antiguos
    $oldLogs = Get-OldLogs -Days $DaysToKeep

    if ($oldLogs.Count -eq 0 -and -not $Compress) {
        Write-Host ""
        Show-Info "No hay logs antiguos para mover (mas de $DaysToKeep dias)"
        Write-Host ""
        Write-Host "  Logs actuales en logs/:" -ForegroundColor Cyan

        $currentLogs = Get-ChildItem -Path $script:LogsPath -Filter "*.log" -File
        foreach ($log in $currentLogs | Sort-Object LastWriteTime -Descending | Select-Object -First 5) {
            $age = [math]::Round(((Get-Date) - $log.LastWriteTime).TotalDays, 1)
            Write-Host "    - $($log.Name) ($age dias)" -ForegroundColor Gray
        }

        Write-Host ""
        Write-Log "No hay logs para mover" "INFO"
        return
    }

    # Mover logs antiguos
    $movedCount = 0
    if ($oldLogs.Count -gt 0) {
        Write-Host ""
        Show-Info "Logs encontrados mas antiguos que $DaysToKeep dias: $($oldLogs.Count)"

        foreach ($log in $oldLogs | Sort-Object LastWriteTime) {
            $age = [math]::Round(((Get-Date) - $log.LastWriteTime).TotalDays, 1)
            Write-Host "    - $($log.Name) ($age dias)" -ForegroundColor Gray
        }

        $movedCount = Move-LogsToArchive -Logs $oldLogs
    }

    # Comprimir si se solicito
    $compressedCount = 0
    if ($Compress) {
        $compressedCount = Compress-ArchivedLogs
    }

    # Mostrar resumen
    Show-Summary -MovedCount $movedCount -CompressedCount $compressedCount

    Write-Log "=== Fin de limpieza de logs ===" "INFO"
    Write-Host "  [INFO] Log de limpieza: $($script:CleanLogFile)" -ForegroundColor $InfoColor
    Write-Host ""
}

# Ejecutar
Main