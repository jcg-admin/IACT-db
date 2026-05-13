<#
.SYNOPSIS
    Bootstrap del entorno de desarrollo IACT-docs en Windows PowerShell.

.DESCRIPTION
    Equivalente PowerShell de scripts/setup.sh. Idempotente: ejecutar
    N veces produce el mismo estado final.

    Pasos:
      1. uv (gestor de Python)            -- debe existir en sistema
      2. Java JRE                          -- detectar; sin auto-instalación
      3. plantuml.jar                      -- descarga a tools/plantuml.jar
      4. uv sync                           -- deps Python en .venv/
      5. git hooks                         -- core.hooksPath = .githooks

    NO instala libenchant en Windows (sphinx-spelling no aplica).

.EXAMPLE
    .\scripts\setup.ps1

.NOTES
    Requiere: PowerShell 5.1+ y permiso de ejecución.
    Para habilitar: Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
#>

param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Cambiar al directorio raíz del repo
$RepoRoot = git rev-parse --show-toplevel 2>$null
if (-not $RepoRoot) {
    Write-Error "ERROR: este script debe ejecutarse dentro de un repo git."
    exit 1
}
Set-Location $RepoRoot

# Variables
$PlantumlVersion = "1.2024.7"
$PlantumlJar = "tools\plantuml.jar"
$PlantumlUrl = "https://github.com/plantuml/plantuml/releases/download/v$PlantumlVersion/plantuml-$PlantumlVersion.jar"

# Helpers
function Write-Step { param($msg) Write-Host "`n==> $msg" -ForegroundColor Cyan }
function Write-Ok   { param($msg) Write-Host "    [OK] $msg" -ForegroundColor Green }
function Write-Warn { param($msg) Write-Host "    [WARN] $msg" -ForegroundColor Yellow }
function Write-Err  { param($msg) Write-Host "    [ERROR] $msg" -ForegroundColor Red }

function Test-Command {
    param($cmd)
    $null = Get-Command $cmd -ErrorAction SilentlyContinue
    return $?
}

# ---------------------------------------------------------------------------
# 1. uv
# ---------------------------------------------------------------------------
Write-Step "1/5 Verificando uv (gestor Python)"
if (-not (Test-Command "uv")) {
    Write-Err "uv no esta instalado."
    Write-Host "    Instalar con:" -ForegroundColor Yellow
    Write-Host '    powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"' -ForegroundColor Yellow
    exit 1
}
$UvVersion = (uv --version 2>&1 | Select-Object -First 1)
Write-Ok "uv $UvVersion"

# ---------------------------------------------------------------------------
# 2. Java JRE
# ---------------------------------------------------------------------------
Write-Step "2/5 Verificando Java JRE (requerido por plantuml)"
$HasJava = $false

# Check JAVA_HOME
if ($env:JAVA_HOME -and (Test-Path "$env:JAVA_HOME\bin\java.exe")) {
    $HasJava = $true
    $JavaVer = (& "$env:JAVA_HOME\bin\java.exe" -version 2>&1 | Select-Object -First 1)
    Write-Ok "java en JAVA_HOME ($JavaVer)"
}
# Check tools\jre\bin\java
elseif (Test-Path "$RepoRoot\tools\jre\bin\java.exe") {
    $HasJava = $true
    $JavaVer = (& "$RepoRoot\tools\jre\bin\java.exe" -version 2>&1 | Select-Object -First 1)
    Write-Ok "java portable en tools\jre\ ($JavaVer)"
}
# Check PATH
elseif (Test-Command "java") {
    $HasJava = $true
    $JavaVer = (java -version 2>&1 | Select-Object -First 1)
    Write-Ok "java en PATH ($JavaVer)"
}

if (-not $HasJava) {
    Write-Err "Java no encontrado."
    Write-Host "    Instalar con winget:" -ForegroundColor Yellow
    Write-Host "    winget install --id EclipseAdoptium.Temurin.21.JRE -e" -ForegroundColor Yellow
    Write-Host "    O descargar manualmente desde https://adoptium.net/" -ForegroundColor Yellow
    exit 1
}

# ---------------------------------------------------------------------------
# 3. plantuml.jar
# ---------------------------------------------------------------------------
Write-Step "3/5 Verificando plantuml.jar bundled"

$NeedDownload = $false
if (-not (Test-Path $PlantumlJar)) {
    $NeedDownload = $true
} else {
    $JarSize = (Get-Item $PlantumlJar).Length
    if ($JarSize -lt 1MB) {
        Write-Warn "plantuml.jar existe pero es muy chico ($JarSize bytes) -- re-descargando"
        $NeedDownload = $true
    } else {
        # Sanity: que sea un zip valido (firma PK)
        $bytes = [System.IO.File]::ReadAllBytes($PlantumlJar)[0..1]
        if ($bytes[0] -ne 0x50 -or $bytes[1] -ne 0x4B) {
            Write-Warn "plantuml.jar no parece zip valido -- re-descargando"
            $NeedDownload = $true
        } else {
            $JarMb = [Math]::Round($JarSize / 1MB, 1)
            Write-Ok "plantuml.jar ya presente ($JarMb MB)"
        }
    }
}

if ($NeedDownload) {
    Write-Host "    Descargando plantuml-$PlantumlVersion.jar..." -ForegroundColor White
    if (-not (Test-Path "tools")) {
        New-Item -ItemType Directory -Path "tools" | Out-Null
    }
    if (-not (Test-Path "tools\bin")) {
        New-Item -ItemType Directory -Path "tools\bin" | Out-Null
    }
    try {
        # PowerShell 5+ usa TLS 1.2 por defecto en versiones recientes
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $PlantumlUrl -OutFile "$PlantumlJar.tmp" -UseBasicParsing
        Move-Item "$PlantumlJar.tmp" $PlantumlJar -Force
        $JarSize = (Get-Item $PlantumlJar).Length
        $JarMb = [Math]::Round($JarSize / 1MB, 1)
        Write-Ok "plantuml.jar descargado ($JarMb MB)"
    } catch {
        Write-Err "Falla descarga de plantuml.jar: $_"
        exit 1
    }
}

# Crear wrapper PowerShell si no existe
$PlantumlCmd = "tools\bin\plantuml.cmd"
if (-not (Test-Path $PlantumlCmd)) {
    @'
@echo off
REM Wrapper Windows para plantuml.jar bundled.
REM Equivalente a tools/bin/plantuml para Linux/macOS.
setlocal
set "REPO_ROOT=%~dp0..\.."
set "JAR=%REPO_ROOT%\tools\plantuml.jar"
if not exist "%JAR%" (
    echo ERROR: plantuml.jar no encontrado en %JAR% 1>&2
    echo        Ejecutar: powershell .\scripts\setup.ps1 1>&2
    exit /b 1
)
java -Djava.awt.headless=true -jar "%JAR%" %*
'@ | Set-Content $PlantumlCmd -Encoding ASCII
    Write-Ok "wrapper tools\bin\plantuml.cmd creado"
}

# ---------------------------------------------------------------------------
# 4. uv sync
# ---------------------------------------------------------------------------
Write-Step "4/5 Sincronizando dependencias Python (uv sync)"
uv sync
if ($LASTEXITCODE -ne 0) {
    Write-Err "uv sync falló (exit $LASTEXITCODE)"
    exit $LASTEXITCODE
}
Write-Ok ".venv\ sincronizado"

# ---------------------------------------------------------------------------
# 5. git hooks
# ---------------------------------------------------------------------------
Write-Step "5/5 Activando git hooks"
git config core.hooksPath .githooks
$HooksPath = git config core.hooksPath
Write-Ok "core.hooksPath = $HooksPath"

# Listar hooks activos
if (Test-Path ".githooks") {
    $Hooks = Get-ChildItem ".githooks" -File | Select-Object -ExpandProperty Name
    if ($Hooks) {
        Write-Host "    Hooks activos:" -ForegroundColor White
        $Hooks | ForEach-Object { Write-Host "      $_" -ForegroundColor White }
    }
}

# ---------------------------------------------------------------------------
# Final
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "===================================================================" -ForegroundColor Green
Write-Host "  Entorno listo. Construir docs:" -ForegroundColor Green
Write-Host "    .\.venv\Scripts\Activate.ps1" -ForegroundColor White
Write-Host "    sphinx-build -b html source build\html" -ForegroundColor White
Write-Host "===================================================================" -ForegroundColor Green
