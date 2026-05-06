# Script de Reorganización de Documentación - IACT DevBox
# Opción B: Consolidar TROUBLESHOOTING (usar COMPLETO, archivar original)

<#
.SYNOPSIS
    Reorganiza la estructura de documentación de IACT DevBox paso a paso.

.DESCRIPTION
    Este script reorganiza la documentación en subdirectorios categorizados:
    - getting-started/
    - setup/
    - architecture/
    - troubleshooting/
    - archive/
    
    Implementa la Opción B para TROUBLESHOOTING:
    - TROUBLESHOOTING_COMPLETO.md -> troubleshooting/TROUBLESHOOTING.md
    - TROUBLESHOOTING.md -> archive/TROUBLESHOOTING_ORIGINAL.md

.PARAMETER WhatIf
    Modo de simulación. Muestra qué haría sin ejecutar cambios.

.PARAMETER SkipBackup
    Omite la creación de backup inicial.

.PARAMETER Force
    Sobrescribe archivos existentes sin preguntar.

.EXAMPLE
    .\reorganize-docs-step-by-step.ps1 -WhatIf
    Ejecuta en modo simulación sin hacer cambios

.EXAMPLE
    .\reorganize-docs-step-by-step.ps1
    Ejecuta la reorganización con confirmaciones

.EXAMPLE
    .\reorganize-docs-step-by-step.ps1 -Force
    Ejecuta la reorganización sobrescribiendo sin preguntar

.NOTES
    File Name      : reorganize-docs-step-by-step.ps1
    Author         : IACT DevBox
    Prerequisite   : PowerShell 5.1+
    Version        : 1.1.3
    Changes        : v1.1.0 - Corregido: nombres de funciones, DryRun->WhatIf
                     v1.1.1 - Corregido: interpolación de variables con ${}
                     v1.1.2 - Removido SupportsShouldProcess (duplicaba parámetro WhatIf)
                     v1.1.3 - Mejorado: Show-FinalStructure muestra estructura proyectada en WhatIf
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [switch]$WhatIf,

    [Parameter(Mandatory = $false)]
    [switch]$SkipBackup,

    [Parameter(Mandatory = $false)]
    [switch]$Force
)

# =============================================================================
# CONFIGURACIÓN
# =============================================================================

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# Colores
$ColorSuccess = "Green"
$ColorError = "Red"
$ColorWarning = "Yellow"
$ColorInfo = "Cyan"
$ColorGray = "Gray"

# Timestamp para backup
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

# Directorio base
$docsPath = "docs"
$backupPath = "docs_backup_$timestamp"

# Estructura de directorios destino
$directories = @(
    "getting-started",
    "setup",
    "architecture",
    "troubleshooting",
    "archive"
)

# Mapeo de archivos a directorios
$fileMapping = @{
    "QUICKSTART.md" = "getting-started"
    "COMMANDS.md" = "getting-started"
    "VERIFICACION_COMPLETA.md" = "getting-started"
    "INSTALAR_CA_WINDOWS.md" = "setup"
    "PERFILES_POWERSHELL.md" = "setup"
    "DEVELOPMENT.md" = "architecture"
    "PROVISIONERS.md" = "architecture"
    "VAGRANT_2.4.7_WORKAROUND.md" = "troubleshooting"
}

# Archivos especiales (requieren tratamiento especial)
$specialFiles = @{
    "INDICE_DOCUMENTACION_COMPLETA.md" = "README.md"  # Renombrar
    "TROUBLESHOOTING_COMPLETO.md" = "troubleshooting/TROUBLESHOOTING.md"  # Mover y renombrar
    "TROUBLESHOOTING.md" = "archive/TROUBLESHOOTING_ORIGINAL.md"  # Archivar
}

# =============================================================================
# FUNCIONES
# =============================================================================

function WriteHeader {
    param([string]$Text)
    Write-Host ""
    Write-Host "=" * 70 -ForegroundColor $ColorInfo
    Write-Host "  $Text" -ForegroundColor $ColorInfo
    Write-Host "=" * 70 -ForegroundColor $ColorInfo
    Write-Host ""
}

function WriteStep {
    param(
        [string]$Step,
        [string]$Description
    )
    Write-Host ""
    Write-Host "PASO $Step : $Description" -ForegroundColor $ColorInfo
    Write-Host ("-" * 70) -ForegroundColor $ColorGray
}

function WriteSuccess {
    param([string]$Text)
    Write-Host "[OK] $Text" -ForegroundColor $ColorSuccess
}

function WriteWarning {
    param([string]$Text)
    Write-Host "[WARN] $Text" -ForegroundColor $ColorWarning
}

function WriteError {
    param([string]$Text)
    Write-Host "[ERROR] $Text" -ForegroundColor $ColorError
}

function WriteInfo {
    param([string]$Text)
    Write-Host "[INFO] $Text" -ForegroundColor $ColorInfo
}

function WriteWhatIf {
    param([string]$Text)
    Write-Host "[WHATIF] $Text" -ForegroundColor $ColorWarning
}

function Test-DocsDirectory {
    if (-not (Test-Path $docsPath)) {
        WriteError "Directorio 'docs' no encontrado"
        WriteInfo "Asegúrate de ejecutar este script desde el directorio del proyecto"
        return $false
    }
    return $true
}

function Get-FileSize {
    param([string]$Path)
    if (Test-Path $Path) {
        return (Get-Item $Path).Length
    }
    return 0
}

function Compare-TroubleshootingFiles {
    WriteStep "0" "Análisis de archivos TROUBLESHOOTING"

    $original = "$docsPath\TROUBLESHOOTING.md"
    $completo = "$docsPath\TROUBLESHOOTING_COMPLETO.md"

    $originalExists = Test-Path $original
    $completoExists = Test-Path $completo

    WriteInfo "Análisis de archivos:"
    Write-Host ""

    if ($originalExists) {
        $originalSize = Get-FileSize $original
        $originalLines = (Get-Content $original).Count
        Write-Host "  TROUBLESHOOTING.md:" -ForegroundColor White
        Write-Host "    Tamaño: $originalSize bytes" -ForegroundColor $ColorGray
        Write-Host "    Líneas: $originalLines" -ForegroundColor $ColorGray
    } else {
        Write-Host "  TROUBLESHOOTING.md: NO EXISTE" -ForegroundColor $ColorWarning
    }

    Write-Host ""

    if ($completoExists) {
        $completoSize = Get-FileSize $completo
        $completoLines = (Get-Content $completo).Count
        Write-Host "  TROUBLESHOOTING_COMPLETO.md:" -ForegroundColor White
        Write-Host "    Tamaño: $completoSize bytes" -ForegroundColor $ColorGray
        Write-Host "    Líneas: $completoLines" -ForegroundColor $ColorGray
    } else {
        Write-Host "  TROUBLESHOOTING_COMPLETO.md: NO EXISTE" -ForegroundColor $ColorWarning
    }

    Write-Host ""

    if ($originalExists -and $completoExists) {
        WriteInfo "Recomendación: Usar TROUBLESHOOTING_COMPLETO como principal"
        WriteInfo "Razón: Es más extenso y completo"
        return $true
    } elseif ($completoExists) {
        WriteInfo "Solo existe TROUBLESHOOTING_COMPLETO"
        return $true
    } elseif ($originalExists) {
        WriteWarning "Solo existe TROUBLESHOOTING original"
        WriteWarning "No se puede aplicar Opción B sin TROUBLESHOOTING_COMPLETO"
        return $false
    } else {
        WriteWarning "No existen archivos TROUBLESHOOTING"
        return $false
    }
}

function New-BackupDirectory {
    WriteStep "1" "Crear backup de documentación actual"

    if ($SkipBackup) {
        WriteWarning "Backup omitido por parámetro -SkipBackup"
        return $true
    }

    if ($WhatIf) {
        WriteWhatIf "Crearía backup en: $backupPath"
        return $true
    }

    try {
        WriteInfo "Creando backup en: $backupPath"
        Copy-Item -Path $docsPath -Destination $backupPath -Recurse -Force

        $fileCount = (Get-ChildItem $backupPath -Recurse -File).Count
        WriteSuccess "Backup creado ($fileCount archivos)"

        return $true
    }
    catch {
        WriteError "Error creando backup: $($_.Exception.Message)"
        return $false
    }
}

function New-DirectoryStructure {
    WriteStep "2" "Crear estructura de subdirectorios"

    foreach ($dir in $directories) {
        $dirPath = Join-Path $docsPath $dir

        if ($WhatIf) {
            WriteWhatIf "Crearía directorio: $dir/"
            continue
        }

        if (Test-Path $dirPath) {
            WriteInfo "Ya existe: $dir/"
        } else {
            try {
                New-Item -ItemType Directory -Path $dirPath -Force | Out-Null
                WriteSuccess "Creado: $dir/"
            }
            catch {
                WriteError "Error creando ${dir}/: $($_.Exception.Message)"
                return $false
            }
        }
    }

    return $true
}

function Move-RegularFiles {
    WriteStep "3" "Mover archivos regulares a subdirectorios"

    $movedCount = 0
    $skippedCount = 0

    foreach ($file in $fileMapping.Keys) {
        $sourcePath = Join-Path $docsPath $file
        $targetDir = $fileMapping[$file]
        $targetPath = Join-Path $docsPath (Join-Path $targetDir $file)

        if (-not (Test-Path $sourcePath)) {
            WriteWarning "No encontrado: $file (saltando)"
            $skippedCount++
            continue
        }

        if ($WhatIf) {
            WriteWhatIf "Movería: $file -> $targetDir/"
            $movedCount++
            continue
        }

        try {
            if ((Test-Path $targetPath) -and -not $Force) {
                WriteWarning "Ya existe en destino: $file"
                $choice = Read-Host "Sobrescribir? (s/n)"
                if ($choice -ne "s") {
                    WriteInfo "Saltando: $file"
                    $skippedCount++
                    continue
                }
            }

            Move-Item -Path $sourcePath -Destination $targetPath -Force
            WriteSuccess "Movido: $file -> $targetDir/"
            $movedCount++
        }
        catch {
            WriteError "Error moviendo ${file}: $($_.Exception.Message)"
            return $false
        }
    }

    WriteInfo ""
    WriteInfo "Archivos movidos: $movedCount"
    WriteInfo "Archivos saltados: $skippedCount"

    return $true
}

function Move-SpecialFiles {
    WriteStep "4" "Procesar archivos especiales"

    foreach ($sourceFile in $specialFiles.Keys) {
        $sourcePath = Join-Path $docsPath $sourceFile
        $targetRelative = $specialFiles[$sourceFile]
        $targetPath = Join-Path $docsPath $targetRelative

        if (-not (Test-Path $sourcePath)) {
            WriteWarning "No encontrado: $sourceFile (saltando)"
            continue
        }

        $operation = if ($sourceFile -ne ($targetRelative.Split('/')[-1])) { "Mover y renombrar" } else { "Mover" }

        if ($WhatIf) {
            WriteWhatIf "$operation : $sourceFile -> $targetRelative"
            continue
        }

        try {
            # Crear directorio destino si no existe
            $targetDir = Split-Path $targetPath -Parent
            if (-not (Test-Path $targetDir)) {
                New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
            }

            if ((Test-Path $targetPath) -and -not $Force) {
                WriteWarning "Ya existe: $targetRelative"
                $choice = Read-Host "Sobrescribir? (s/n)"
                if ($choice -ne "s") {
                    WriteInfo "Saltando: $sourceFile"
                    continue
                }
            }

            Move-Item -Path $sourcePath -Destination $targetPath -Force
            WriteSuccess "$operation : $sourceFile -> $targetRelative"
        }
        catch {
            WriteError "Error procesando ${sourceFile}: $($_.Exception.Message)"
            return $false
        }
    }

    return $true
}

function New-SubdirectoryReadmes {
    WriteStep "5" "Crear archivos README.md en subdirectorios"

    $readmeContents = @{
        "getting-started" = @"
# Getting Started

Documentación para empezar con IACT DevBox.

## Orden de Lectura

1. [QUICKSTART.md](QUICKSTART.md) - Instalación en 10 minutos
2. [COMMANDS.md](COMMANDS.md) - Comandos básicos
3. [VERIFICACION_COMPLETA.md](VERIFICACION_COMPLETA.md) - Verificar que todo funciona

## Próximos Pasos

Después de completar esta sección:
- [Setup](../setup/) - Configuración avanzada (opcional)
- [Troubleshooting](../troubleshooting/) - Si hay problemas
"@

        "setup" = @"
# Setup Avanzado

Configuración adicional para mejorar la experiencia de desarrollo.

## Configuraciones Disponibles

1. [INSTALAR_CA_WINDOWS.md](INSTALAR_CA_WINDOWS.md) - Certificados SSL (HTTPS sin warnings)
2. [PERFILES_POWERSHELL.md](PERFILES_POWERSHELL.md) - Optimizar PowerShell

## Nota

Estas configuraciones son opcionales pero recomendadas para una mejor experiencia.
"@

        "architecture" = @"
# Arquitectura y Desarrollo

Documentación técnica para desarrolladores y mantenedores.

## Contenido

1. [DEVELOPMENT.md](DEVELOPMENT.md) - Guía de desarrollo
2. [PROVISIONERS.md](PROVISIONERS.md) - Sistema de provisioning

## Audiencia

Esta sección es para:
- Desarrolladores modificando el sistema
- Mantenedores del proyecto
- Personas implementando cambios en la arquitectura
"@

        "troubleshooting" = @"
# Troubleshooting

Solución de problemas y errores comunes.

## Documentos

1. [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Guía completa de resolución de problemas
2. [VAGRANT_2.4.7_WORKAROUND.md](VAGRANT_2.4.7_WORKAROUND.md) - Solución a bug de Vagrant 2.4.7

## Cómo Usar

1. Identificar síntomas del problema
2. Buscar en TROUBLESHOOTING.md por categoría
3. Seguir pasos de diagnóstico
4. Aplicar solución recomendada
5. Verificar que el problema se resolvió
"@
    }

    foreach ($dir in $readmeContents.Keys) {
        $readmePath = Join-Path $docsPath (Join-Path $dir "README.md")

        if ($WhatIf) {
            WriteWhatIf "Crearía: $dir/README.md"
            continue
        }

        try {
            if ((Test-Path $readmePath) -and -not $Force) {
                WriteWarning "Ya existe: $dir/README.md"
                $choice = Read-Host "Sobrescribir? (s/n)"
                if ($choice -ne "s") {
                    WriteInfo "Saltando: $dir/README.md"
                    continue
                }
            }

            $readmeContents[$dir] | Out-File -FilePath $readmePath -Encoding UTF8 -Force
            WriteSuccess "Creado: $dir/README.md"
        }
        catch {
            WriteError "Error creando ${dir}/README.md: $($_.Exception.Message)"
            return $false
        }
    }

    return $true
}

function Show-FinalStructure {
    WriteStep "6" "Mostrar estructura final"

    WriteInfo "Estructura de documentación reorganizada:"
    Write-Host ""

    if ($WhatIf) {
        WriteWarning "Esto es una simulación de la estructura final"
        Write-Host ""

        # Construir estructura proyectada basada en mapeos
        $projectedStructure = @()

        # README principal
        $projectedStructure += "docs\README.md"

        # Archivos en subdirectorios (desde fileMapping)
        foreach ($dir in $directories) {
            # README del subdirectorio
            $projectedStructure += "docs\$dir\README.md"

            # Archivos que van a este directorio
            foreach ($file in $fileMapping.Keys) {
                if ($fileMapping[$file] -eq $dir) {
                    $projectedStructure += "docs\$dir\$file"
                }
            }
        }

        # Archivos especiales procesados
        foreach ($targetRelative in $specialFiles.Values) {
            if ($targetRelative -ne "README.md") {  # Ya agregado arriba
                $projectedStructure += "docs\$targetRelative"
            }
        }

        # Ordenar y mostrar
        $projectedStructure | Sort-Object | ForEach-Object {
            Write-Host "  $_" -ForegroundColor $ColorGray
        }
    }
    else {
        # Modo real: mostrar estructura actual del disco
        Get-ChildItem $docsPath -Recurse -File -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -notlike "*_backup_*" } |
            Sort-Object FullName |
            ForEach-Object {
                $relativePath = $_.FullName.Replace((Get-Location).Path + "\", "")
                Write-Host "  $relativePath" -ForegroundColor $ColorGray
            }
    }
}

function Show-RollbackInstructions {
    if ($WhatIf -or $SkipBackup) {
        return
    }

    Write-Host ""
    Write-Host "ROLLBACK DISPONIBLE" -ForegroundColor $ColorWarning
    Write-Host ("-" * 70) -ForegroundColor $ColorGray
    Write-Host ""
    Write-Host "Si necesitas deshacer los cambios:" -ForegroundColor $ColorInfo
    Write-Host ""
    Write-Host "  1. Eliminar docs/ actual:" -ForegroundColor $ColorGray
    Write-Host "     Remove-Item docs -Recurse -Force" -ForegroundColor White
    Write-Host ""
    Write-Host "  2. Restaurar backup:" -ForegroundColor $ColorGray
    Write-Host "     Rename-Item $backupPath docs" -ForegroundColor White
    Write-Host ""
}

function Invoke-Reorganization {
    WriteHeader "Reorganización de Documentación IACT DevBox"

    if ($WhatIf) {
        WriteWarning "MODO WHATIF ACTIVO - No se harán cambios reales"
        Write-Host ""
    }

    # Verificar directorio docs
    if (-not (Test-DocsDirectory)) {
        return $false
    }

    WriteSuccess "Directorio 'docs' encontrado"

    # Paso 0: Analizar archivos TROUBLESHOOTING
    if (-not (Compare-TroubleshootingFiles)) {
        WriteError "No se puede continuar sin archivos TROUBLESHOOTING adecuados"
        return $false
    }

    # Confirmar antes de continuar
    if (-not $WhatIf -and -not $Force) {
        Write-Host ""
        WriteWarning "Esta operación moverá archivos en el directorio docs/"
        $confirm = Read-Host "Continuar? (s/n)"
        if ($confirm -ne "s") {
            WriteInfo "Operación cancelada por el usuario"
            return $false
        }
    }

    # Paso 1: Backup
    if (-not (New-BackupDirectory)) {
        return $false
    }

    # Paso 2: Crear estructura
    if (-not (New-DirectoryStructure)) {
        return $false
    }

    # Paso 3: Mover archivos regulares
    if (-not (Move-RegularFiles)) {
        return $false
    }

    # Paso 4: Procesar archivos especiales
    if (-not (Move-SpecialFiles)) {
        return $false
    }

    # Paso 5: Crear READMEs en subdirectorios
    if (-not (New-SubdirectoryReadmes)) {
        return $false
    }

    # Paso 6: Mostrar estructura final
    Show-FinalStructure

    # Instrucciones de rollback
    Show-RollbackInstructions

    Write-Host ""
    WriteHeader "Reorganización Completada"

    if ($WhatIf) {
        WriteInfo "Ejecuta el script sin -DryRun para aplicar cambios"
    } else {
        WriteSuccess "Documentación reorganizada exitosamente"
        WriteInfo ""
        WriteInfo "Siguiente paso: Verificar links en docs/README.md"
        WriteInfo "Comando: notepad docs\README.md"
    }

    return $true
}

# =============================================================================
# EJECUCIÓN PRINCIPAL
# =============================================================================

try {
    $result = Invoke-Reorganization

    if ($result) {
        exit 0
    } else {
        exit 1
    }
}
catch {
    WriteError "Error inesperado: $($_.Exception.Message)"
    WriteError "Stack trace: $($_.ScriptStackTrace)"
    exit 1
}