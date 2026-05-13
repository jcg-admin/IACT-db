---
id: TASK-REORG-INFRA-005
tipo: tarea_preparacion
categoria: automatizacion
titulo: Configurar Herramientas de Validacion
fase: FASE_1_PREPARACION
prioridad: ALTA
duracion_estimada: 3h
estado: pendiente
dependencias: [TASK-REORG-INFRA-001]
tags: [validacion, scripts, automatizacion, qa]
tecnica_prompting: Chain-of-Thought
---

# TASK-REORG-INFRA-005: Configurar Herramientas de Validacion

**Fase:** FASE 1 - Preparacion
**Prioridad:** ALTA (P1)
**Duracion Estimada:** 3 horas
**Responsable:** Tech Writer / DevOps
**Estado:** PENDIENTE

---

## AUTO-COT: Analisis de Necesidades

### 1. Lectura de Contexto
De LISTADO-COMPLETO-TAREAS.md se identifica que se necesitan scripts de validacion para asegurar calidad durante reorganizacion de infraestructura.

### 2. Herramientas Identificadas como Necesarias
1. **validate_links.sh** - Detectar enlaces markdown no rotos o invalidos
2. **validate_frontmatter.py** - Validar estructura y completitud de metadatos YAML
3. **validate_naming.sh** - Verificar nomenclatura snake_case en archivos y carpetas
4. **clean_emojis.sh** - Detectar y limpiar emojis de markdown (existente, pero se documenta)

### 3. Razon de Cada Script
- **validate_links.sh**: Evitar enlaces rotos durante migracion de archivos
- **validate_frontmatter.py**: Asegurar metadatos consistentes en todo el proyecto
- **validate_naming.sh**: Mantener convencion de nombres consistente
- **clean_emojis.sh**: Asegurar compatibilidad y limpieza de documentacion

### 4. Ubicacion Final
```
scripts/qa/
├── validate_links.sh
├── validate_frontmatter.py
├── validate_naming.sh
└── clean_emojis.sh (copia/referencia)
```

---

## Objetivo

Crear suite de scripts de validacion para asegurar calidad de documentacion durante reorganizacion de infraestructura. Estos scripts validaran:
- Integridad de enlaces markdown
- Completitud de metadatos YAML (frontmatter)
- Consistencia de nomenclatura
- Ausencia de emojis en documentacion

---

## Prerequisitos

- [ ] Acceso a /home/user/IACT/scripts/qa/ (crear si no existe)
- [ ] Python 3.8+ instalado
- [ ] Bash 4.0+ instalado
- [ ] Git configurado y funcionando
- [ ] TASK-REORG-INFRA-001 completada (backup de seguridad)

---

## Pasos de Ejecucion

### Paso 1: Crear Directorio scripts/qa/

```bash
mkdir -p /home/user/IACT/scripts/qa
cd /home/user/IACT/scripts/qa
```

**Resultado Esperado:** Directorio creado en ruta correcta

### Paso 2: Crear Script validate_links.sh

**Proposito:** Validar que todos los enlaces markdown ([texto](ruta)) apunten a archivos que existen.

**Ubicacion:** `/home/user/IACT/scripts/qa/validate_links.sh`

**Funcionalidad:**
- Buscar todos los archivos .md en directorio especificado
- Extraer enlaces markdown: `[texto](ruta)`
- Validar que archivo destino existe
- Reportar enlaces rotos
- Diferenciar entre enlaces internos y externos

**Uso:**
```bash
./scripts/qa/validate_links.sh /home/user/IACT/docs/infraestructura
```

**Salida Esperada:**
```
[INFO] Validando enlaces en: /home/user/IACT/docs/infraestructura
[OK] Procesados 150 archivos markdown
[BROKEN] 5 enlaces no validos encontrados:
  - docs/infraestructura/qa/archivo.md:15: [link text](path/noexiste.md)
  - docs/infraestructura/qa/otro.md:42: [ref](../../../invalid.md)
[SUMMARY] Enlaces validos: 450, Rotos: 5, Externos: 12
```

### Paso 3: Crear Script validate_frontmatter.py

**Proposito:** Validar que todos los archivos markdown tengan frontmatter YAML valido con campos requeridos.

**Ubicacion:** `/home/user/IACT/scripts/qa/validate_frontmatter.py`

**Funcionalidad:**
- Buscar todos los archivos .md
- Verificar presencia de frontmatter YAML (entre ---)
- Validar campos requeridos: id, tipo, categoria, titulo, estado
- Validar formato YAML (sin errores de sintaxis)
- Reportar archivos sin frontmatter o frontmatter incompleto

**Campos Validados:**
- `id`: Requerido, debe ser unico
- `tipo`: Requerido, valores permitidos: [tarea, documentacion, adr, procedimiento]
- `categoria`: Requerido
- `titulo`: Requerido
- `estado`: Requerido, valores permitidos: [pendiente, en_progreso, completada, archivado]

**Uso:**
```bash
python3 scripts/qa/validate_frontmatter.py /home/user/IACT/docs/infraestructura
```

**Salida Esperada:**
```
[INFO] Validando frontmatter YAML en: /home/user/IACT/docs/infraestructura
[OK] 85 archivos con frontmatter valido
[ERROR] 3 archivos sin frontmatter:
  - docs/infraestructura/qa/README.md
  - docs/infraestructura/planificacion/notas.md
[ERROR] 2 archivos con frontmatter incompleto:
  - docs/infraestructura/qa/archivo.md: Falta campo 'id'
  - docs/infraestructura/design/otro.md: Falta campo 'tipo'
[ERROR] 1 ID duplicado:
  - 'TASK-001' aparece en 2 archivos
[SUMMARY] Total procesados: 90, Validos: 85, Problemas: 5
```

### Paso 4: Crear Script validate_naming.sh

**Proposito:** Validar que carpetas y archivos sigan convencion de nombres snake_case.

**Ubicacion:** `/home/user/IACT/scripts/qa/validate_naming.sh`

**Funcionalidad:**
- Verificar que archivos .md sigan pattern: `lowercase-with-dashes.md`
- Verificar que carpetas sigan pattern: `lowercase-with-dashes/`
- Permitir excepciones: MAYUSCULAS para constantes (README, LICENSE, etc.)
- Reportar nombres no conformes
- Sugerir correcciones

**Excepciones Permitidas:**
- README.md
- LICENSE
- .env files
- .git* files
- Archivos generados (*.log, *.tmp)

**Uso:**
```bash
./scripts/qa/validate_naming.sh /home/user/IACT/docs/infraestructura
```

**Salida Esperada:**
```
[INFO] Validando nomenclatura en: /home/user/IACT/docs/infraestructura
[OK] 200 nombres validos (snake_case)
[WARNING] 3 nombres invalidos encontrados:
  - docs/infraestructura/Planificacion/Plan.md (sugerir: planificacion/plan.md)
  - docs/infraestructura/QA/ANALISIS.md (sugerir: qa/analisis.md)
[SUMMARY] Total: 203, Validos: 200, Invalidos: 3
```

### Paso 5: Crear Script clean_emojis.sh (Referencia/Copia)

**Proposito:** Detectar y limpiar emojis de archivos markdown.

**Ubicacion:** `/home/user/IACT/scripts/qa/clean_emojis.sh` (copia del existente en scripts/)

**Funcionalidad:**
- Escanear archivos .md para detectar emojis
- Reemplazar emojis comunes por equivalentes ASCII
- Hacer backup antes de modificar
- Reportar cambios realizados

**Emojis Soportados:**
- [COMPLETADO] -> [x]
- [ERROR] -> [ ]
- [OK] -> [OK]
- [ERROR] -> [FAIL]
- [WARNING] -> [WARNING]
- Remover:     🔒 🔐 🚨  📈 📉   🔥 👍 👎 ⭐ 🌟

**Uso:**
```bash
./scripts/qa/clean_emojis.sh /home/user/IACT/docs/infraestructura
```

---

## Criterios de Exito (SELF-CONSISTENCY)

- [ ] Script validate_links.sh creado y ejecutable
  - [ ] Detecta enlaces invalidos
  - [ ] Diferencia enlaces internos vs externos
  - [ ] Genera reporte legible

- [ ] Script validate_frontmatter.py creado y ejecutable
  - [ ] Valida estructura YAML
  - [ ] Verifica campos requeridos
  - [ ] Detecta IDs duplicados
  - [ ] Genera reporte JSON opcional

- [ ] Script validate_naming.sh creado y ejecutable
  - [ ] Verifica snake_case
  - [ ] Reporta excepciones permitidas
  - [ ] Sugiere correcciones

- [ ] Script clean_emojis.sh disponible y documentado
  - [ ] Realiza backups antes de modificar
  - [ ] Reemplaza emojis definidos
  - [ ] Genera reporte de cambios

- [ ] Todos los scripts tienen:
  - [ ] Propósito claro en comentario de cabecera
  - [ ] Uso/sintaxis documentado
  - [ ] Manejo de errores básico
  - [ ] Mensaje de help (-h o --help)
  - [ ] Ser ejecutables (chmod +x)

---

## Validacion

### Prueba validate_links.sh
```bash
# Test 1: Validar en directorio docs/infraestructura
./scripts/qa/validate_links.sh /home/user/IACT/docs/infraestructura > evidencias/test-links.log 2>&1

# Test 2: Validar que detecta enlaces rotos (crear archivo de prueba)
mkdir -p evidencias/test_data
echo "# Test\n[broken link](noexiste.md)" > evidencias/test_data/test.md
./scripts/qa/validate_links.sh evidencias/test_data | grep BROKEN
```

**Salida Esperada:** Script ejecuta sin errores, reporte generado

### Prueba validate_frontmatter.py
```bash
# Test 1: Validar en directorio actual
python3 scripts/qa/validate_frontmatter.py /home/user/IACT/docs/infraestructura > evidencias/test-frontmatter.log 2>&1

# Test 2: Validar que detecta frontmatter incompleto
cat > evidencias/test_data/bad.md << 'EOF'
---
id: BAD-001
titulo: Sin tipo
---
Contenido
EOF

python3 scripts/qa/validate_frontmatter.py evidencias/test_data | grep ERROR
```

**Salida Esperada:** Script ejecuta sin errores, detecta problemas

### Prueba validate_naming.sh
```bash
# Test 1: Validar en directorio docs/infraestructura
./scripts/qa/validate_naming.sh /home/user/IACT/docs/infraestructura > evidencias/test-naming.log 2>&1

# Test 2: Crear archivo con nombre incorrecto
touch evidencias/test_data/BadFileName.md
./scripts/qa/validate_naming.sh evidencias/test_data | grep WARNING
```

**Salida Esperada:** Script ejecuta sin errores, identifica nombres invalidos

### Prueba clean_emojis.sh
```bash
# Test 1: Crear archivo con emojis
cat > evidencias/test_data/emojis.md << 'EOF'
# Test  [COMPLETADO]
- Tarea [OK]
- Error [ERROR]
- Warning [WARNING]
EOF

# Test 2: Ejecutar limpieza
./scripts/qa/clean_emojis.sh evidencias/test_data

# Test 3: Verificar cambios
cat evidencias/test_data/emojis.md
```

**Salida Esperada:** Emojis reemplazados, backup creado

---

## Implementacion Detallada

### validate_links.sh - Codigo Completo

```bash
#!/bin/bash
# Script: validate_links.sh
# Proposito: Validar enlaces markdown en archivos .md
# Uso: ./validate_links.sh <directorio>

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ -z "$1" ]; then
    echo "Uso: $0 <directorio>"
    echo "Ejemplo: $0 /home/user/IACT/docs/infraestructura"
    exit 1
fi

TARGET_DIR="$1"

if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}ERROR: Directorio no existe: $TARGET_DIR${NC}"
    exit 1
fi

echo -e "${GREEN}[INFO] Validando enlaces en: $TARGET_DIR${NC}"

TOTAL_FILES=0
VALID_LINKS=0
BROKEN_LINKS=0
EXTERNAL_LINKS=0
TEMP_FILE="/tmp/broken_links_$$.txt"

# Procesar cada archivo markdown
find "$TARGET_DIR" -type f -name "*.md" | while read -r file; do
    TOTAL_FILES=$((TOTAL_FILES + 1))

    # Extraer enlaces markdown: [texto](ruta)
    grep -oP '\[.*?\]\(\K[^)]+' "$file" 2>/dev/null | while read -r link; do
        # Ignorar enlaces externos (http, https, mailto)
        if [[ "$link" =~ ^(http|https|mailto|ftp):// ]]; then
            EXTERNAL_LINKS=$((EXTERNAL_LINKS + 1))
        elif [[ "$link" =~ ^#.* ]]; then
            # Links a anclas internas
            VALID_LINKS=$((VALID_LINKS + 1))
        else
            # Enlaces internos - validar que archivo existe
            # Resolver ruta relativa
            file_dir=$(dirname "$file")
            target_file="$file_dir/$link"

            # Normalizar ruta
            target_file=$(cd "$file_dir" && readlink -f "$link" 2>/dev/null || echo "")

            if [ -z "$target_file" ] || [ ! -f "$target_file" ]; then
                BROKEN_LINKS=$((BROKEN_LINKS + 1))
                echo -e "${RED}[BROKEN]${NC} $file: $link" >> "$TEMP_FILE"
            else
                VALID_LINKS=$((VALID_LINKS + 1))
            fi
        fi
    done
done

# Mostrar resultados
if [ -f "$TEMP_FILE" ]; then
    echo -e "${RED}[BROKEN] Enlaces no validos encontrados:${NC}"
    cat "$TEMP_FILE"
    rm "$TEMP_FILE"
fi

echo ""
echo -e "${GREEN}[SUMMARY] Procesados: $TOTAL_FILES archivos${NC}"
echo -e "${GREEN}[SUMMARY] Enlaces validos: $VALID_LINKS${NC}"
if [ $BROKEN_LINKS -gt 0 ]; then
    echo -e "${RED}[SUMMARY] Enlaces rotos: $BROKEN_LINKS${NC}"
else
    echo -e "${GREEN}[SUMMARY] Enlaces rotos: 0${NC}"
fi
echo -e "${YELLOW}[SUMMARY] Enlaces externos: $EXTERNAL_LINKS${NC}"
```

### validate_frontmatter.py - Codigo Completo

```python
#!/usr/bin/env python3
# Script: validate_frontmatter.py
# Proposito: Validar frontmatter YAML en archivos markdown
# Uso: python3 validate_frontmatter.py <directorio>

import os
import sys
import yaml
import re
from pathlib import Path
from collections import defaultdict

# Colores
RED = '\033[0;31m'
GREEN = '\033[0;32m'
YELLOW = '\033[1;33m'
NC = '\033[0m'

# Campos requeridos y valores validos
REQUIRED_FIELDS = ['id', 'tipo', 'categoria', 'titulo', 'estado']
VALID_TIPOS = ['tarea', 'documentacion', 'adr', 'procedimiento', 'tarea_preparacion', 'indice_tareas']
VALID_ESTADOS = ['pendiente', 'en_progreso', 'completada', 'archivado']

def extract_frontmatter(file_path):
    """Extrae frontmatter YAML de archivo markdown"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        return None, f"Error leyendo archivo: {e}"

    # Buscar frontmatter entre --- ---
    match = re.match(r'^---\s*\n(.*?)\n---\s*\n', content, re.DOTALL)
    if not match:
        return None, "Sin frontmatter"

    try:
        fm = yaml.safe_load(match.group(1))
        return fm, None
    except yaml.YAMLError as e:
        return None, f"YAML invalido: {e}"

def validate_frontmatter(file_path, frontmatter):
    """Valida estructura del frontmatter"""
    errors = []

    if not isinstance(frontmatter, dict):
        return ["Frontmatter no es diccionario YAML valido"]

    # Validar campos requeridos
    for field in REQUIRED_FIELDS:
        if field not in frontmatter:
            errors.append(f"Falta campo requerido: '{field}'")
        elif not frontmatter[field]:
            errors.append(f"Campo vacio: '{field}'")

    # Validar tipo
    if 'tipo' in frontmatter:
        if frontmatter['tipo'] not in VALID_TIPOS:
            errors.append(f"Tipo invalido: '{frontmatter['tipo']}' (permitidos: {', '.join(VALID_TIPOS)})")

    # Validar estado
    if 'estado' in frontmatter:
        if frontmatter['estado'] not in VALID_ESTADOS:
            errors.append(f"Estado invalido: '{frontmatter['estado']}' (permitidos: {', '.join(VALID_ESTADOS)})")

    return errors

def main():
    if len(sys.argv) < 2:
        print("Uso: python3 validate_frontmatter.py <directorio>")
        print("Ejemplo: python3 validate_frontmatter.py /home/user/IACT/docs/infraestructura")
        sys.exit(1)

    target_dir = sys.argv[1]

    if not os.path.isdir(target_dir):
        print(f"{RED}ERROR: Directorio no existe: {target_dir}{NC}")
        sys.exit(1)

    print(f"{GREEN}[INFO] Validando frontmatter YAML en: {target_dir}{NC}")

    valid_count = 0
    error_count = 0
    no_frontmatter_count = 0
    duplicate_ids = defaultdict(list)
    all_errors = []

    # Procesar cada archivo markdown
    for root, dirs, files in os.walk(target_dir):
        for file in files:
            if file.endswith('.md'):
                file_path = os.path.join(root, file)
                rel_path = os.path.relpath(file_path, target_dir)

                fm, extract_error = extract_frontmatter(file_path)

                if extract_error:
                    if extract_error == "Sin frontmatter":
                        no_frontmatter_count += 1
                        all_errors.append((rel_path, extract_error))
                    else:
                        error_count += 1
                        all_errors.append((rel_path, extract_error))
                    continue

                # Validar contenido
                validation_errors = validate_frontmatter(file_path, fm)

                if validation_errors:
                    error_count += 1
                    for err in validation_errors:
                        all_errors.append((rel_path, err))
                else:
                    valid_count += 1
                    # Track IDs para detectar duplicados
                    if 'id' in fm:
                        duplicate_ids[fm['id']].append(rel_path)

    # Mostrar resultados
    print(f"{GREEN}[OK] {valid_count} archivos con frontmatter valido{NC}")

    if no_frontmatter_count > 0:
        print(f"{RED}[ERROR] {no_frontmatter_count} archivos sin frontmatter:{NC}")
        for path, err in all_errors:
            if err == "Sin frontmatter":
                print(f"  - {path}")

    if error_count > 0:
        print(f"{RED}[ERROR] {error_count} archivos con problemas:{NC}")
        for path, err in all_errors:
            if err != "Sin frontmatter" and "Falta" in err:
                print(f"  - {path}: {err}")

    # Detectar IDs duplicados
    duplicates = {k: v for k, v in duplicate_ids.items() if len(v) > 1}
    if duplicates:
        print(f"{RED}[ERROR] IDs duplicados:{NC}")
        for id_val, paths in duplicates.items():
            print(f"  - '{id_val}' aparece en {len(paths)} archivos")
            for path in paths:
                print(f"    * {path}")
        error_count += len(duplicates)

    # Resumen
    total = valid_count + error_count + no_frontmatter_count
    print("")
    print(f"{GREEN}[SUMMARY] Total procesados: {total}${NC}")
    print(f"{GREEN}[SUMMARY] Validos: {valid_count}${NC}")

    if error_count > 0 or no_frontmatter_count > 0:
        print(f"{RED}[SUMMARY] Problemas: {error_count + no_frontmatter_count}${NC}")

    return 0 if (error_count == 0 and no_frontmatter_count == 0 and len(duplicates) == 0) else 1

if __name__ == "__main__":
    sys.exit(main())
```

### validate_naming.sh - Codigo Completo

```bash
#!/bin/bash
# Script: validate_naming.sh
# Proposito: Validar nomenclatura snake_case en archivos y carpetas
# Uso: ./validate_naming.sh <directorio>

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ -z "$1" ]; then
    echo "Uso: $0 <directorio>"
    echo "Ejemplo: $0 /home/user/IACT/docs/infraestructura"
    exit 1
fi

TARGET_DIR="$1"

if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}ERROR: Directorio no existe: $TARGET_DIR${NC}"
    exit 1
fi

echo -e "${GREEN}[INFO] Validando nomenclatura en: $TARGET_DIR${NC}"

VALID_COUNT=0
INVALID_COUNT=0

# Excepciones permitidas (MAYUSCULAS o caracteres especiales)
is_exception() {
    local filename=$1

    # Permitir README, LICENSE, .archivos, etc.
    if [[ "$filename" =~ ^README$ ]]; then return 0; fi
    if [[ "$filename" =~ ^LICENSE ]]; then return 0; fi
    if [[ "$filename" =~ ^\. ]]; then return 0; fi
    if [[ "$filename" =~ ^CONTRIBUTING ]]; then return 0; fi
    if [[ "$filename" =~ ^\.git ]]; then return 0; fi

    return 1
}

# Validar nombre
validate_name() {
    local name=$1
    local type=$2  # "file" o "dir"

    if is_exception "$name"; then
        return 0
    fi

    # Patron: lowercase, numeros, guiones
    # Debe empezar con letra o numero
    # Puede contener: a-z, 0-9, guiones (-)
    if [[ "$name" =~ ^[a-z0-9]([a-z0-9-]*[a-z0-9])?(\.[a-z0-9]+)?$ ]]; then
        return 0  # Valido
    fi

    return 1  # Invalido
}

# Procesar archivos
find "$TARGET_DIR" -type f | while read -r file; do
    filename=$(basename "$file")

    if ! validate_name "$filename" "file"; then
        INVALID_COUNT=$((INVALID_COUNT + 1))
        echo -e "${YELLOW}[WARNING]${NC} $file"
        echo "  -> Sugerencia: $(echo "$filename" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')"
    else
        VALID_COUNT=$((VALID_COUNT + 1))
    fi
done

# Procesar carpetas
find "$TARGET_DIR" -type d | while read -r dir; do
    dirname=$(basename "$dir")

    # Ignorar . y ..
    if [[ "$dirname" == "." || "$dirname" == ".." ]]; then
        continue
    fi

    if ! validate_name "$dirname" "dir"; then
        INVALID_COUNT=$((INVALID_COUNT + 1))
        echo -e "${YELLOW}[WARNING]${NC} $dir/"
        echo "  -> Sugerencia: $(echo "$dirname" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')"
    else
        VALID_COUNT=$((VALID_COUNT + 1))
    fi
done

# Resumen
TOTAL=$((VALID_COUNT + INVALID_COUNT))
echo ""
echo -e "${GREEN}[SUMMARY] Total: $TOTAL${NC}"
echo -e "${GREEN}[SUMMARY] Validos: $VALID_COUNT${NC}"

if [ $INVALID_COUNT -gt 0 ]; then
    echo -e "${RED}[SUMMARY] Invalidos: $INVALID_COUNT${NC}"
else
    echo -e "${GREEN}[SUMMARY] Invalidos: 0${NC}"
fi
```

---

## Riesgos y Mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Script bash no portable | MEDIA | BAJO | Usar bash 4.0+ features, documentar |
| Python no instalado | BAJA | MEDIO | Validar en prerequisitos, usar shebang correcto |
| Permisos insuficientes | BAJA | BAJO | Usar chmod +x, documentar |
| Rutas absolutas vs relativas | MEDIA | MEDIO | Usar readlink -f para normalizar |
| Emojis no detectados | BAJA | BAJO | Mantener lista actualizada |
| False positives en validacion | MEDIA | BAJO | Permitir exceptions, revisar resultados |

---

## Cronograma de Ejecucion

| Paso | Duracion | Responsable |
|------|----------|------------|
| 1. Crear directorio scripts/qa/ | 5 min | Tech Writer |
| 2. Crear validate_links.sh | 45 min | DevOps/Tech Writer |
| 3. Crear validate_frontmatter.py | 45 min | DevOps/Tech Writer |
| 4. Crear validate_naming.sh | 30 min | DevOps/Tech Writer |
| 5. Documentar y probar | 15 min | Tech Writer |
| **TOTAL** | **2h 20min** | - |

---

## Evidencias a Capturar

1. **test-links.log** - Output de validate_links.sh
2. **test-frontmatter.log** - Output de validate_frontmatter.py
3. **test-naming.log** - Output de validate_naming.sh
4. **test-emojis.log** - Output de clean_emojis.sh
5. **scripts-created.txt** - Listado de scripts creados
6. **permissions-log.txt** - Verificacion de chmod +x

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

---

## Checklist de Finalizacion

- [ ] Directorio /home/user/IACT/scripts/qa/ creado
- [ ] validate_links.sh creado, executable, y probado
- [ ] validate_frontmatter.py creado, executable, y probado
- [ ] validate_naming.sh creado, executable, y probado
- [ ] clean_emojis.sh copiado/referenciado y documentado
- [ ] Todos los scripts tienen permisos +x
- [ ] Documentacion de uso completa en README.md
- [ ] Ejemplos de ejecucion documentados
- [ ] Criterios de exito verificados (4 scripts funcionales)
- [ ] Evidencias capturadas en carpeta evidencias/
- [ ] Tarea marcada como COMPLETADA en INDICE.md

---

**Tarea creada:** 2025-11-18
**Ultima actualizacion:** 2025-11-18
**Version:** 1.0.0
**Estado:** PENDIENTE
