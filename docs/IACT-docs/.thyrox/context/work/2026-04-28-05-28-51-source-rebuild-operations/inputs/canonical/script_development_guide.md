---
title: Guia de Desarrollo de Scripts
date: 2025-11-13
domain: general
status: active
---

# Guia de Desarrollo de Scripts

Como crear nuevos scripts para el proyecto IACT.

## Templates Disponibles

**Path:** `/home/user/IACT---project/scripts/templates/`

### bash_script_template.sh

Template completo para scripts Bash con mejores practicas.

**Uso:**
```bash
cp scripts/templates/bash_script_template.sh scripts/mi_nuevo_script.sh
chmod +x scripts/mi_nuevo_script.sh
vi scripts/mi_nuevo_script.sh
```

**Features incluidas:**
- Strict mode (`set -euo pipefail`)
- Logging functions (log_info, log_error, log_success)
- Colors para terminal
- Argument parsing
- Error handling
- Help message

---

### posix_script_template.sh

Template para scripts POSIX sh (compatible con cualquier shell).

**Cuando usar:**
- Scripts que deben correr en sh/dash/ash
- Compatibilidad maxima
- Ambientes con Bash no disponible

---

### library_template.sh

Template para librerias Bash (funciones reutilizables).

**Uso:**
```bash
# Crear libreria
cp scripts/templates/library_template.sh scripts/lib/mi_libreria.sh

# Usar en otro script
source scripts/lib/mi_libreria.sh
mi_funcion_libreria
```

---

## Estructura de un Script

### Minimo viable

```bash
#!/bin/bash
set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Tu codigo aqui
echo "Hello from script"
```

### Completo con mejores practicas

```bash
#!/bin/bash
#
# Descripcion corta del script
#
# Uso:
#   ./script.sh [opciones] argumentos
#
# Ejemplos:
#   ./script.sh --verbose input.txt

set -euo pipefail  # Strict mode

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors (solo si terminal interactivo)
if [ -t 1 ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    NC='\033[0m'
else
    RED=''
    GREEN=''
    YELLOW=''
    NC=''
fi

# Logging functions
log_info() {
    echo "[INFO] $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_error() {
    echo -e "${RED}[FAIL]${NC} $1" >&2
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Help message
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] ARGUMENTS

Descripcion del script.

OPTIONS:
    -h, --help      Show this help
    -v, --verbose   Verbose output

EXAMPLES:
    $(basename "$0") input.txt
    $(basename "$0") --verbose input.txt
EOF
}

# Parse arguments
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        *)
            # Positional argument
            INPUT_FILE="$1"
            shift
            ;;
    esac
done

# Validate required arguments
if [ -z "${INPUT_FILE:-}" ]; then
    log_error "Missing required argument: INPUT_FILE"
    usage
    exit 1
fi

# Main logic
log_info "Starting script..."

# Tu codigo aqui

log_success "Script completed successfully"
```

---

## Mejores Practicas

### 1. Strict Mode

Siempre usar:
```bash
set -e   # Exit on error
set -u   # Error on undefined variable
set -o pipefail  # Error in pipes
```

O combinado:
```bash
set -euo pipefail
```

### 2. Quoting

```bash
# Malo
file=$1
cat $file

# Bueno
file="$1"
cat "$file"

# Mejor (arrays)
files=("$@")
for file in "${files[@]}"; do
    cat "$file"
done
```

### 3. Error Handling

```bash
# Malo
rm -rf /important/data

# Bueno
if [ -d "/important/data" ]; then
    rm -rf /important/data || {
        log_error "Failed to delete data"
        exit 1
    }
fi

# Mejor (con validacion)
DATA_DIR="${DATA_DIR:-/important/data}"
if [ -z "$DATA_DIR" ]; then
    log_error "DATA_DIR not set"
    exit 1
fi

if [ ! -d "$DATA_DIR" ]; then
    log_warning "Directory does not exist: $DATA_DIR"
else
    rm -rf "$DATA_DIR" || {
        log_error "Failed to delete $DATA_DIR"
        exit 1
    }
fi
```

### 4. Logging

```bash
# Informacion normal
log_info "Processing file: $filename"

# Success
log_success "File processed successfully"

# Warnings (continua ejecucion)
log_warning "File is empty, skipping"

# Errors (detiene ejecucion)
log_error "File not found: $filename"
exit 1
```

### 5. Argument Parsing

```bash
# Opciones cortas y largas
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        -*)
            log_error "Unknown option: $1"
            usage
            exit 1
            ;;
        *)
            # Positional
            POSITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done
```

---

## Scripts Python

### Template basico

```python
#!/usr/bin/env python3
"""
Descripcion del script.

Usage:
    python script.py [options] arguments
"""

import argparse
import logging
import sys
from pathlib import Path


def setup_logging(verbose: bool = False) -> None:
    """Configura logging."""
    level = logging.DEBUG if verbose else logging.INFO
    logging.basicConfig(
        level=level,
        format='[%(levelname)s] %(message)s'
    )


def main() -> int:
    """Punto de entrada principal."""
    parser = argparse.ArgumentParser(
        description="Descripcion del script"
    )
    parser.add_argument(
        '--verbose',
        action='store_true',
        help='Verbose output'
    )
    parser.add_argument(
        'input_file',
        type=Path,
        help='Input file'
    )

    args = parser.parse_args()

    setup_logging(args.verbose)

    try:
        # Tu codigo aqui
        logging.info(f"Processing {args.input_file}")

        # ...

        logging.info("Script completed successfully")
        return 0

    except Exception as e:
        logging.error(f"Error: {e}")
        return 1


if __name__ == '__main__':
    sys.exit(main())
```

---

## Testing de Scripts

### Bash scripts

```bash
# test_mi_script.sh

#!/bin/bash

source ./mi_script.sh

# Test function
test_mi_funcion() {
    local result
    result=$(mi_funcion "input")

    if [ "$result" == "expected" ]; then
        echo "PASS: mi_funcion"
    else
        echo "FAIL: mi_funcion (expected 'expected', got '$result')"
        exit 1
    fi
}

# Run tests
test_mi_funcion

echo "All tests passed"
```

### Python scripts

```python
# test_mi_script.py

import unittest
from mi_script import mi_funcion


class TestMiScript(unittest.TestCase):

    def test_mi_funcion(self):
        result = mi_funcion("input")
        self.assertEqual(result, "expected")


if __name__ == '__main__':
    unittest.main()
```

---

## Integration con Constitution

Los scripts deben respetar restricciones criticas:

```bash
# Validar que NO se use Redis
if grep -r "redis" "$FILE"; then
    log_error "Redis detected. Prohibited by RNF-002"
    exit 1
fi

# Validar que NO se use email
if grep -r "send_mail" "$FILE"; then
    log_warning "Email usage detected. Use InternalMessage instead"
fi
```

---

## Documentacion

### En el script

```bash
#!/bin/bash
#
# Script Name: backup_database.sh
# Description: Performs backup of MySQL database
# Author: DevOps Team
# Version: 1.0
# Date: 2025-11-07
#
# Usage:
#   ./backup_database.sh [options]
#
# Options:
#   -h, --help      Show help
#   -d, --database  Database name (required)
#   -o, --output    Output directory (default: /backups)
#
# Examples:
#   ./backup_database.sh --database mydb
#   ./backup_database.sh --database mydb --output /custom/path
#
# Prerequisites:
#   - MySQL client installed
#   - DB_USER and DB_PASSWORD env vars set
#
# Exit Codes:
#   0 - Success
#   1 - Error
#
```

### En README

Agregar al README del directorio:

```markdown
## backup_database.sh

Performs backup of MySQL database.

**Usage:**
\`\`\`bash
./backup_database.sh --database mydb
\`\`\`

**Cron:**
\`\`\`cron
0 3 * * * /path/to/backup_database.sh --database prod_db
\`\`\`
```

---

## Publicacion

### 1. Testing local

```bash
# Ejecutar script
./mi_script.sh

# Testing con diferentes inputs
./mi_script.sh input1.txt
./mi_script.sh input2.txt

# Testing error cases
./mi_script.sh nonexistent.txt  # Debe fallar gracefully
```

### 2. Code review

```bash
# Linter
shellcheck mi_script.sh

# Formateo
shfmt -w mi_script.sh
```

### 3. Documentacion

```bash
# Agregar a README.md principal
vi docs/scripts/README.md

# Agregar a SCRIPTS_MATRIX.md
vi docs/scripts/SCRIPTS_MATRIX.md
```

### 4. Commit

```bash
git add scripts/mi_script.sh
git commit -m "feat(scripts): agregar mi_script.sh para [proposito]"
git push
```

---

## Checklist

Antes de commitear un nuevo script:

- [ ] Script tiene shebang correcto (`#!/bin/bash` o `#!/usr/bin/env python3`)
- [ ] Script es ejecutable (`chmod +x`)
- [ ] Usa strict mode (`set -euo pipefail`)
- [ ] Tiene logging functions
- [ ] Tiene help message (`--help`)
- [ ] Maneja errores correctamente
- [ ] Variables quoted (`"$var"`)
- [ ] Paths son absolutos o relativos a `$PROJECT_ROOT`
- [ ] No usa tecnologias prohibidas (Redis, etc)
- [ ] Tiene documentacion en header
- [ ] Agregado a README.md
- [ ] Agregado a SCRIPTS_MATRIX.md
- [ ] Testeado localmente
- [ ] Pasado por shellcheck (Bash) o flake8 (Python)

---

**Mantenedores:** @tech-lead, @devops-lead
