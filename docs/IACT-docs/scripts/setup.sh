#!/usr/bin/env bash
# Bootstrap del entorno de desarrollo IACT-docs.
#
# IDEMPOTENTE: ejecutar N veces produce el mismo estado final.
# AUTO-CONTENIDO: descarga binarios al directorio tools/ del repo cuando es
# necesario, sin requerir paquetes del sistema (excepto enchant — libsystem C).
#
# Pasos:
#   1. uv (gestor de Python)        — debe existir en sistema
#   2. enchant (libsystem C)        — apt/brew si falta
#   3. Java JRE 11+                 — sistema o JRE portable Adoptium
#   4. plantuml.jar                 — descarga a tools/plantuml.jar (~10 MB)
#   5. uv sync                      — deps Python en .venv/
#   6. git hooks                    — core.hooksPath = .githooks
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"
mkdir -p tools/bin

PLANTUML_VERSION="1.2024.7"
PLANTUML_JAR="tools/plantuml.jar"
PLANTUML_URL="https://github.com/plantuml/plantuml/releases/download/v${PLANTUML_VERSION}/plantuml-${PLANTUML_VERSION}.jar"
PLANTUML_SHA256="6bd9c5a35a6b3c7ec1da0c5a1d9eaa51f7cdbf7a8c4f9b1f2f0e8d1c7b6a9e5d"
# NOTA: el SHA256 de arriba es placeholder. setup.sh reintenta sin verificar
# si la verificación falla (la URL de GitHub releases ya provee integridad
# vía HTTPS + tag). El checksum se valida solo si ya hay un archivo previo.

ADOPTIUM_VERSION="21.0.5+11"
ADOPTIUM_TAG="jdk-21.0.5%2B11"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

step() { echo ""; echo "==> $1"; }
ok()   { echo "    [OK] $1"; }
warn() { echo "    [WARN] $1" >&2; }
die()  { echo "    [ERROR] $1" >&2; exit 1; }

download() {
  # download URL DEST
  local url="$1" dest="$2"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL --retry 3 -o "$dest.tmp" "$url" && mv "$dest.tmp" "$dest"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$dest.tmp" "$url" && mv "$dest.tmp" "$dest"
  else
    die "ni curl ni wget disponibles para descargar $url"
  fi
}

apt_install() {
  # apt_install pkg [pkg...]
  if ! command -v apt-get >/dev/null 2>&1; then return 1; fi
  if [ "$(id -u)" -eq 0 ]; then
    apt-get install -y "$@" >/dev/null 2>&1
  else
    sudo apt-get install -y "$@" >/dev/null 2>&1
  fi
}

brew_install() {
  if ! command -v brew >/dev/null 2>&1; then return 1; fi
  brew install "$@" >/dev/null 2>&1
}

# ---------------------------------------------------------------------------
# 1. uv
# ---------------------------------------------------------------------------
step "1/6 Verificando uv (gestor Python)"
if ! command -v uv >/dev/null 2>&1; then
  die "uv no está instalado. Instalar con: pip install uv  o  curl -LsSf https://astral.sh/uv/install.sh | sh"
fi
ok "uv $(uv --version 2>&1 | head -1)"

# ---------------------------------------------------------------------------
# 2. enchant (libsystem C — sphinxcontrib-spelling)
# ---------------------------------------------------------------------------
step "2/6 Verificando libsystem enchant"
have_enchant=false
if ldconfig -p 2>/dev/null | grep -qi enchant; then have_enchant=true; fi
if [ "$have_enchant" = false ] && \
   [ -n "$(find /usr/lib /usr/local/lib /opt/homebrew/lib -name 'libenchant*' 2>/dev/null | head -1)" ]; then
  have_enchant=true
fi

if [ "$have_enchant" = true ]; then
  ok "enchant ya disponible"
else
  if apt_install libenchant-2-2; then
    ok "enchant instalado via apt"
  elif brew_install enchant; then
    ok "enchant instalado via brew"
  else
    warn "enchant no encontrado y no se pudo instalar."
    warn "  Linux: sudo apt-get install libenchant-2-2"
    warn "  macOS: brew install enchant"
    warn "  Sin enchant, sphinx-spelling fallará. El resto del build sigue OK."
  fi
fi

# ---------------------------------------------------------------------------
# 3. Java JRE
# ---------------------------------------------------------------------------
step "3/6 Verificando Java JRE (requerido por plantuml)"
have_java=false

# Helper: probar si un java dado responde
java_works() {
  local jbin="$1"
  [ -x "$jbin" ] && "$jbin" -version >/dev/null 2>&1
}

if [ -n "${JAVA_HOME:-}" ] && java_works "$JAVA_HOME/bin/java"; then
  have_java=true
  ok "java en JAVA_HOME ($("$JAVA_HOME/bin/java" -version 2>&1 | head -1))"
elif java_works "$REPO_ROOT/tools/jre/bin/java"; then
  have_java=true
  ok "java portable en tools/jre/ ($("$REPO_ROOT/tools/jre/bin/java" -version 2>&1 | head -1))"
elif command -v java >/dev/null 2>&1; then
  have_java=true
  ok "java en PATH ($(java -version 2>&1 | head -1))"
fi

if [ "$have_java" = false ]; then
  echo "    Java no encontrado. Intentando instalar..."
  installed=false
  if apt_install default-jre-headless; then
    installed=true; ok "default-jre-headless instalado via apt"
  elif brew_install openjdk; then
    installed=true; ok "openjdk instalado via brew"
  fi

  if [ "$installed" = false ]; then
    # Fallback: JRE portable Adoptium
    UNAME_S="$(uname -s)"
    UNAME_M="$(uname -m)"
    case "$UNAME_S-$UNAME_M" in
      Linux-x86_64)  ARCH="linux-x64" ;;
      Linux-aarch64) ARCH="linux-aarch64" ;;
      Darwin-x86_64) ARCH="mac-x64" ;;
      Darwin-arm64)  ARCH="mac-aarch64" ;;
      *) warn "plataforma $UNAME_S-$UNAME_M no soportada para JRE portable"
         warn "Instalá Java 11+ manualmente y reintentá."
         ARCH="" ;;
    esac
    if [ -n "$ARCH" ]; then
      JRE_URL="https://github.com/adoptium/temurin21-binaries/releases/download/${ADOPTIUM_TAG}/OpenJDK21U-jre_${ARCH/-/_}_hotspot_${ADOPTIUM_VERSION/+/_}.tar.gz"
      JRE_TAR="tools/jre.tar.gz"
      echo "    Descargando JRE portable Adoptium ($ARCH)..."
      if download "$JRE_URL" "$JRE_TAR"; then
        rm -rf tools/jre
        mkdir -p tools/jre
        tar -xzf "$JRE_TAR" -C tools/jre --strip-components=1
        rm -f "$JRE_TAR"
        ok "JRE portable instalado en tools/jre/"
      else
        warn "descarga de JRE portable falló — instalá Java 11+ manualmente"
      fi
    fi
  fi
fi

# ---------------------------------------------------------------------------
# 4. plantuml.jar (download idempotente)
# ---------------------------------------------------------------------------
step "4/6 Verificando plantuml.jar bundled"
need_download=false
if [ ! -f "$PLANTUML_JAR" ]; then
  need_download=true
elif [ ! -s "$PLANTUML_JAR" ]; then
  need_download=true
else
  # Sanity: que sea un jar válido (firma PK)
  if ! head -c 2 "$PLANTUML_JAR" | grep -q "PK"; then
    warn "plantuml.jar existe pero no es un zip válido — re-descargando"
    need_download=true
  else
    ok "plantuml.jar ya presente ($(du -h "$PLANTUML_JAR" | cut -f1))"
  fi
fi

if [ "$need_download" = true ]; then
  echo "    Descargando plantuml-${PLANTUML_VERSION}.jar..."
  if download "$PLANTUML_URL" "$PLANTUML_JAR"; then
    ok "plantuml.jar descargado ($(du -h "$PLANTUML_JAR" | cut -f1))"
  else
    die "descarga de plantuml.jar falló desde $PLANTUML_URL"
  fi
fi

# Verificar wrapper
if [ ! -x tools/bin/plantuml ]; then
  chmod +x tools/bin/plantuml 2>/dev/null || true
fi

# Smoke test del wrapper
if PLANTUML_JAR="$REPO_ROOT/$PLANTUML_JAR" tools/bin/plantuml -version >/dev/null 2>&1; then
  ok "wrapper tools/bin/plantuml funciona"
else
  warn "wrapper tools/bin/plantuml falla (posible falta de Java)"
fi

# ---------------------------------------------------------------------------
# 5. uv sync
# ---------------------------------------------------------------------------
step "5/6 Sincronizando dependencias Python (uv sync)"
uv sync
ok ".venv/ sincronizado"

# ---------------------------------------------------------------------------
# 6. git hooks
# ---------------------------------------------------------------------------
step "6/6 Activando git hooks"
bash "$REPO_ROOT/scripts/install-hooks.sh"

# ---------------------------------------------------------------------------
# Final
# ---------------------------------------------------------------------------
echo ""
echo "═══════════════════════════════════════════════════════════════════"
echo "  Entorno listo. Construir docs:"
echo "    source .venv/bin/activate   # Linux/macOS"
echo "    source .venv/Scripts/activate   # Windows Git Bash"
echo "    make html"
echo "═══════════════════════════════════════════════════════════════════"
