---
id: PLAN-REM-DOCS-GOB-001
tipo: plan
categoria: gobernanza
version: 1.0.0
fecha_creacion: 2025-11-17
estado: activo
prioridad: CRITICA
propietario: equipo-gobernanza
relacionados: ["DOC-GOB-ESTANDARES", "GUIA_ESTILO"]
---
# Plan de Remediacion - Documentacion Gobernanza

## Resumen Ejecutivo

**Fecha analisis:** 2025-11-17
**Alcance:** docs/gobernanza/ (387 archivos, 155,213 lineas)
**Hallazgos criticos:** 46 archivos con emojis, 416 enlaces rotos, 203 archivos con multiples H1
**Duracion estimada:** 4 semanas (80 horas esfuerzo total)
**Responsables:** Equipo Gobernanza + Propietarios de Dominio

### Metricas Objetivo

| Metrica | Actual | Objetivo | Delta |
|---------|--------|----------|-------|
| Archivos con emojis | 46 (11.9%) | 0 (0%) | -46 |
| Enlaces rotos | 416 | 0 | -416 |
| Archivos con frontmatter | 322 (83.2%) | 387 (100%) | +65 |
| Archivos con multiple H1 | 203 (52.5%) | 0 (0%) | -203 |
| Archivos duplicados | 37 grupos | 5 grupos | -32 |
| Cobertura README | 48.4% | 80% | +31.6% |

---

## Fase 1: Remediacion Critica (Semana 1)

**Duracion:** 5 dias laborales
**Esfuerzo:** 21 horas
**Bloquea:** Cumplimiento de politicas, calidad de navegacion

### TASK-REM-001: Eliminar Emojis de Documentacion

**Prioridad:** CRITICA
**Severidad:** CRITICA
**Esfuerzo:** 4 horas
**Responsable:** Equipo Gobernanza
**Fecha limite:** 2025-11-19

**Hallazgo:**
- 46 archivos contienen emojis (11.9% del total)
- Viola GUIA_ESTILO.md Seccion 1
- Archivos mas afectados:
  * `sesiones/analisis_nov_2025/analisis_completitud_reorganizacion.md` (139 emojis)
  * `sesiones/analisis_nov_2025/ANALISIS_DOCS_FINAL_20251116_0945.md` (70 emojis)
  * `guias/workflows/workflow_admin_users_and_groups.md` (36 emojis)

**Plan de accion:**

```bash
# 1. Crear script de remediacion
cat > scripts/remove_emojis_gobernanza.sh << 'EOF'
#!/bin/bash
# Script para eliminar emojis de docs/gobernanza/

DOCS_DIR="docs/gobernanza"
BACKUP_DIR="backups/docs_gobernanza_$(date +%Y%m%d_%H%M%S)"

# Crear backup
echo "Creando backup en $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"
cp -r "$DOCS_DIR" "$BACKUP_DIR/"

# Lista de archivos con emojis (top 20)
FILES_WITH_EMOJIS=(
  "sesiones/analisis_nov_2025/analisis_completitud_reorganizacion.md"
  "sesiones/analisis_nov_2025/ANALISIS_DOCS_FINAL_20251116_0945.md"
  "guias/workflows/workflow_admin_users_and_groups.md"
  "guias/onboarding/onboarding_008_atencion_cliente.md"
  "estandares_codigo.md"
  "qa/analisis-errores-adr-2025-11-16.md"
  "estilos/estandares_codigo.md"
  "guias/workflows/workflow_manage_teams_as_coordinator.md"
  "adr/ADR-056-agentic-design-principles.md"
  "marco_integrado/marco_reglas_negocio.md"
)

# Patron de reemplazo de emojis comunes en tablas
for file in "${FILES_WITH_EMOJIS[@]}"; do
  filepath="$DOCS_DIR/$file"
  if [ -f "$filepath" ]; then
    echo "Procesando: $file"

    # Reemplazos especificos para tablas y listas
    sed -i 's/✅/OK/g' "$filepath"
    sed -i 's/❌/NO/g' "$filepath"
    sed -i 's/⚠️/WARNING/g' "$filepath"
    sed -i 's/🔴/CRITICO/g' "$filepath"
    sed -i 's/🟡/MEDIO/g' "$filepath"
    sed -i 's/🟢/BAJO/g' "$filepath"
    sed -i 's/📝/NOTA/g' "$filepath"
    sed -i 's/🔍/REVISION/g' "$filepath"
    sed -i 's/⭐/IMPORTANTE/g' "$filepath"
    sed -i 's/🚀/LANZAMIENTO/g' "$filepath"

    # Eliminar emojis Unicode restantes (preservando caracteres normales)
    # Rango Unicode de emojis mas comunes
    perl -C -pe 's/[\x{1F300}-\x{1F9FF}]//g' "$filepath"
    perl -C -pe 's/[\x{2600}-\x{26FF}]//g' "$filepath"
    perl -C -pe 's/[\x{2700}-\x{27BF}]//g' "$filepath"
  fi
done

# Procesar todos los archivos restantes
find "$DOCS_DIR" -name "*.md" -type f | while read -r file; do
  perl -C -pe 's/[\x{1F300}-\x{1F9FF}]//g' "$file"
  perl -C -pe 's/[\x{2600}-\x{26FF}]//g' "$file"
  perl -C -pe 's/[\x{2700}-\x{27BF}]//g' "$file"
done

echo "Remediacion completada"
echo "Backup guardado en: $BACKUP_DIR"
EOF

chmod +x scripts/remove_emojis_gobernanza.sh

# 2. Ejecutar script
./scripts/remove_emojis_gobernanza.sh

# 3. Verificar resultado
grep -r -P '[\x{1F300}-\x{1F9FF}]' docs/gobernanza/ || echo "SUCCESS: No emojis found"

# 4. Crear hook pre-commit para prevenir regresion
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Pre-commit hook: Verificar ausencia de emojis

if git diff --cached --name-only | grep -q "^docs/"; then
  if git diff --cached | grep -P '[\x{1F300}-\x{1F9FF}]'; then
    echo "ERROR: Emojis detectados en documentacion"
    echo "Los emojis estan prohibidos segun GUIA_ESTILO.md"
    exit 1
  fi
fi
exit 0
EOF

chmod +x .git/hooks/pre-commit
```

**Validacion:**
```bash
# Contar emojis restantes
find docs/gobernanza -name "*.md" -exec grep -P '[\x{1F300}-\x{1F9FF}]' {} \; | wc -l
# Resultado esperado: 0
```

**Criterios de aceptacion:**
- [ ] 0 archivos con emojis en docs/gobernanza/
- [ ] Backup creado exitosamente
- [ ] Hook pre-commit instalado y funcionando
- [ ] Commit con mensaje: "fix(docs): eliminar emojis de documentacion de gobernanza"

---

### TASK-REM-002: Corregir Enlaces Rotos

**Prioridad:** CRITICA
**Severidad:** ALTA
**Esfuerzo:** 8 horas
**Responsable:** Equipo Documentacion
**Fecha limite:** 2025-11-20

**Hallazgo:**
- 416 referencias potencialmente rotas
- Problemas comunes:
  * Case-sensitivity (readme.md vs README.md)
  * Rutas relativas incorrectas
  * Referencias a archivos movidos/renombrados

**Plan de accion:**

```bash
# 1. Instalar herramienta de validacion
npm install -g markdown-link-check

# 2. Crear configuracion
cat > .markdown-link-check.json << 'EOF'
{
  "ignorePatterns": [
    {
      "pattern": "^http://localhost"
    },
    {
      "pattern": "^http://127.0.0.1"
    }
  ],
  "timeout": "20s",
  "retryOn429": true,
  "retryCount": 3,
  "fallbackRetryDelay": "30s",
  "aliveStatusCodes": [200, 206]
}
EOF

# 3. Ejecutar analisis
markdown-link-check docs/gobernanza/**/*.md \
  --config .markdown-link-check.json \
  --quiet \
  > broken_links_report.txt

# 4. Crear script de correccion automatica
cat > scripts/fix_broken_links_gobernanza.sh << 'EOF'
#!/bin/bash
# Script para corregir enlaces rotos comunes

DOCS_DIR="docs/gobernanza"

# Backup
BACKUP_DIR="backups/docs_links_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp -r "$DOCS_DIR" "$BACKUP_DIR/"

# Correcciones comunes
find "$DOCS_DIR" -name "*.md" -type f | while read -r file; do
  # Corregir case-sensitivity
  sed -i 's|readme\.md|README.md|gi' "$file"
  sed -i 's|Readme\.md|README.md|g' "$file"

  # Corregir rutas relativas comunes
  sed -i 's|\.\./\.\./arquitectura/readme\.md|../arquitectura/README.md|g' "$file"
  sed -i 's|/index\.md|/INDEX.md|g' "$file"

  # Normalizar extension markdown
  sed -i 's|\.markdown|.md|g' "$file"
done

echo "Correcciones aplicadas. Backup en: $BACKUP_DIR"
EOF

chmod +x scripts/fix_broken_links_gobernanza.sh
./scripts/fix_broken_links_gobernanza.sh

# 5. Re-validar
markdown-link-check docs/gobernanza/**/*.md \
  --config .markdown-link-check.json \
  > broken_links_after_fix.txt

# 6. Comparar resultados
diff broken_links_report.txt broken_links_after_fix.txt
```

**Correcciones manuales requeridas:**
- Archivos referenciados que no existen: Crear o eliminar referencia
- Enlaces a secciones incorrectas: Verificar anchors
- URLs externas rotas: Actualizar o archivar

**Criterios de aceptacion:**
- [ ] Menos de 5 enlaces rotos restantes (tolerancia para externos temporales)
- [ ] Todos los enlaces internos funcionando
- [ ] Reporte de enlaces validado
- [ ] Commit con mensaje: "fix(docs): corregir 400+ enlaces rotos en gobernanza"

---

### TASK-REM-003: Agregar Frontmatter a Archivos Criticos

**Prioridad:** CRITICA
**Severidad:** ALTA
**Esfuerzo:** 6 horas
**Responsable:** Propietarios de Dominio
**Fecha limite:** 2025-11-21

**Hallazgo:**
- 65 archivos sin frontmatter (16.8%)
- Criticos sin frontmatter:
  * INDEX.md
  * 15+ ADRs
  * 20+ plantillas

**Plan de accion:**

```bash
# 1. Crear script generador de frontmatter
cat > scripts/add_frontmatter_gobernanza.sh << 'EOF'
#!/bin/bash
# Script para agregar frontmatter a archivos sin el

generate_frontmatter() {
  local file="$1"
  local tipo="$2"
  local categoria="$3"

  local filename=$(basename "$file" .md)
  local id=$(echo "$filename" | tr '[:lower:]' '[:upper:]' | tr '-' '_')
  local fecha=$(date +%Y-%m-%d)

  cat << FRONTMATTER
---
id: $id
tipo: $tipo
categoria: $categoria
version: 1.0.0
fecha_creacion: $fecha
estado: activo
propietario: equipo-gobernanza
---
FRONTMATTER
}

# Procesar ADRs
for adr in docs/gobernanza/adr/ADR-*.md; do
  if ! grep -q "^---" "$adr"; then
    echo "Agregando frontmatter a: $adr"
    temp_file=$(mktemp)
    generate_frontmatter "$adr" "adr" "arquitectura" > "$temp_file"
    cat "$adr" >> "$temp_file"
    mv "$temp_file" "$adr"
  fi
done

# Procesar plantillas
for plantilla in docs/gobernanza/plantillas/*.md; do
  if ! grep -q "^---" "$plantilla"; then
    echo "Agregando frontmatter a: $plantilla"
    temp_file=$(mktemp)
    generate_frontmatter "$plantilla" "plantilla" "desarrollo" > "$temp_file"
    cat "$plantilla" >> "$temp_file"
    mv "$temp_file" "$plantilla"
  fi
done

# Procesar INDEX.md
if ! grep -q "^---" "docs/gobernanza/INDEX.md"; then
  temp_file=$(mktemp)
  cat << 'FRONTMATTER' > "$temp_file"
---
id: DOC-GOB-INDEX
tipo: indice
categoria: gobernanza
version: 1.0.0
fecha_creacion: 2025-11-17
estado: activo
propietario: equipo-gobernanza
---
FRONTMATTER
  cat "docs/gobernanza/INDEX.md" >> "$temp_file"
  mv "$temp_file" "docs/gobernanza/INDEX.md"
fi

echo "Frontmatter agregado a archivos criticos"
EOF

chmod +x scripts/add_frontmatter_gobernanza.sh
./scripts/add_frontmatter_gobernanza.sh

# 2. Validar frontmatter
cat > scripts/validate_frontmatter.sh << 'EOF'
#!/bin/bash
# Validar que todos los archivos tengan frontmatter

missing=0
find docs/gobernanza -name "*.md" -type f | while read -r file; do
  if ! grep -q "^---" "$file"; then
    echo "FALTA FRONTMATTER: $file"
    missing=$((missing + 1))
  fi
done

if [ $missing -eq 0 ]; then
  echo "SUCCESS: Todos los archivos tienen frontmatter"
  exit 0
else
  echo "FAIL: $missing archivos sin frontmatter"
  exit 1
fi
EOF

chmod +x scripts/validate_frontmatter.sh
./scripts/validate_frontmatter.sh
```

**Criterios de aceptacion:**
- [ ] 100% de archivos con frontmatter (387/387)
- [ ] Frontmatter valido YAML
- [ ] Campos obligatorios presentes: id, tipo, categoria, version, fecha_creacion
- [ ] Commit con mensaje: "docs(gobernanza): agregar frontmatter a 65 archivos"

---

### TASK-REM-004: Resolver Duplicacion Marco Integrado

**Prioridad:** CRITICA
**Severidad:** ALTA
**Esfuerzo:** 3 horas
**Responsable:** Arquitecto Senior
**Fecha limite:** 2025-11-22

**Hallazgo:**
- Marco integrado triplicado (9 archivos, 14,613 lineas duplicadas)
- Ubicaciones:
  1. `/marco_integrado/` (CANONICA)
  2. `/analisis_negocio/marco_integrado/` (DUPLICADO)
  3. `/requisitos/analisis_negocio/marco_integrado/` (DUPLICADO)

**Decision arquitectonica:**
- Version canonica: `docs/gobernanza/marco_integrado/`
- Eliminar duplicados
- Crear referencias/enlaces

**Plan de accion:**

```bash
# 1. Verificar que marco_integrado/ es la version mas actual
diff -r docs/gobernanza/marco_integrado/ \
        docs/gobernanza/analisis_negocio/marco_integrado/

# 2. Crear backup
BACKUP_DIR="backups/marco_integrado_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp -r docs/gobernanza/analisis_negocio/marco_integrado "$BACKUP_DIR/analisis_negocio"
cp -r docs/gobernanza/requisitos/analisis_negocio/marco_integrado "$BACKUP_DIR/requisitos"

# 3. Buscar todas las referencias a ubicaciones duplicadas
grep -r "analisis_negocio/marco_integrado" docs/gobernanza/ > referencias_duplicados.txt
grep -r "requisitos/analisis_negocio/marco_integrado" docs/gobernanza/ >> referencias_duplicados.txt

# 4. Reemplazar referencias
find docs/gobernanza -name "*.md" -type f -exec sed -i \
  's|analisis_negocio/marco_integrado|marco_integrado|g' {} \;

find docs/gobernanza -name "*.md" -type f -exec sed -i \
  's|requisitos/analisis_negocio/marco_integrado|marco_integrado|g' {} \;

# 5. Eliminar duplicados
rm -rf docs/gobernanza/analisis_negocio/marco_integrado
rm -rf docs/gobernanza/requisitos/analisis_negocio/marco_integrado

# 6. Crear archivo de referencia en ubicaciones antiguas
cat > docs/gobernanza/analisis_negocio/MARCO_INTEGRADO_MOVIDO.md << 'EOF'
---
id: REF-MARCO-INTEGRADO
tipo: referencia
categoria: redireccion
---
# Marco Integrado - Movido

El contenido del marco integrado se ha consolidado en:

**Ubicacion canonica:** [docs/gobernanza/marco_integrado/](../marco_integrado/README.md)

Por favor, actualiza tus referencias.

## Archivos disponibles

- [Marco de Reglas de Negocio](../marco_integrado/marco_reglas_negocio.md)
- [Marco de Casos de Uso](../marco_integrado/marco_casos_uso.md)
- [Casos Practicos IACT](../marco_integrado/05a_casos_practicos_iact.md)
- [Plantillas Integradas](../marco_integrado/06_plantillas_integradas_iact.md)
EOF

# Verificar eliminacion exitosa
echo "Archivos restantes en marco_integrado:"
find docs/gobernanza -name "*marco_integrado*" -type d
```

**Criterios de aceptacion:**
- [ ] Solo 1 copia del marco integrado existe
- [ ] Todas las referencias actualizadas
- [ ] Archivo de redireccion creado
- [ ] 9,742 lineas de duplicacion eliminadas
- [ ] Commit con mensaje: "refactor(docs): consolidar marco integrado en ubicacion canonica"

---

## Fase 2: Remediacion Alta Prioridad (Semanas 2-3)

**Duracion:** 10 dias laborales
**Esfuerzo:** 34 horas

### TASK-REM-005: Refactorizar Multiples H1

**Prioridad:** ALTA
**Severidad:** ALTA
**Esfuerzo:** 20 horas (distribuido)
**Responsable:** Equipo Gobernanza + Propietarios
**Fecha limite:** 2025-12-01

**Hallazgo:**
- 203 archivos con multiples H1 (52.5%)
- Viola estandar markdown
- Impacto: SEO, indices, accesibilidad

**Plan de accion:**

```bash
# 1. Detectar archivos con multiples H1
cat > scripts/detect_multiple_h1.sh << 'EOF'
#!/bin/bash
# Detectar archivos con mas de un H1

find docs/gobernanza -name "*.md" -type f | while read -r file; do
  h1_count=$(grep -c "^# " "$file")
  if [ "$h1_count" -gt 1 ]; then
    echo "$file: $h1_count H1 headers"
  fi
done > archivos_multiple_h1.txt

echo "Detectados $(wc -l < archivos_multiple_h1.txt) archivos con multiples H1"
EOF

chmod +x scripts/detect_multiple_h1.sh
./scripts/detect_multiple_h1.sh

# 2. Script de correccion semi-automatica
cat > scripts/fix_multiple_h1.sh << 'EOF'
#!/bin/bash
# Convertir H1 adicionales a H2

file="$1"

if [ ! -f "$file" ]; then
  echo "Uso: $0 <archivo.md>"
  exit 1
fi

# Backup
cp "$file" "$file.backup"

# Contar H1
h1_count=$(grep -c "^# " "$file")

if [ "$h1_count" -le 1 ]; then
  echo "OK: $file tiene un solo H1"
  exit 0
fi

# Estrategia: Mantener primer H1, convertir resto a H2
awk '
  BEGIN { first_h1 = 0 }
  /^# / {
    if (first_h1 == 0) {
      print $0
      first_h1 = 1
    } else {
      print "#" $0
    }
    next
  }
  { print }
' "$file" > "$file.tmp"

mv "$file.tmp" "$file"
echo "FIXED: $file - Convertidos $(($h1_count - 1)) H1 adicionales a H2"
EOF

chmod +x scripts/fix_multiple_h1.sh

# 3. Procesar archivos en lotes (revision manual requerida)
# Priorizar archivos criticos primero
for file in $(head -50 archivos_multiple_h1.txt | cut -d: -f1); do
  ./scripts/fix_multiple_h1.sh "$file"

  # Revision manual recomendada
  echo "Revisar: $file"
  git diff "$file"

  read -p "Aceptar cambios? (y/n): " confirm
  if [ "$confirm" != "y" ]; then
    git checkout "$file"
  fi
done
```

**Proceso recomendado:**
1. Procesar 20-30 archivos por dia
2. Revision manual de cada archivo
3. Ajustar estructura de encabezados segun contenido
4. Validar que la jerarquia tiene sentido
5. Commit incremental cada 10-15 archivos

**Criterios de aceptacion:**
- [ ] 0 archivos con multiples H1
- [ ] Jerarquia de encabezados logica (H1 > H2 > H3)
- [ ] Indices autogenerados funcionando
- [ ] Commits con mensajes: "fix(docs): refactorizar H1 en [dominio]"

---

### TASK-REM-006: Consolidar Duplicados QA y Procesos

**Prioridad:** ALTA
**Severidad:** MEDIA
**Esfuerzo:** 4 horas
**Responsable:** QA Lead
**Fecha limite:** 2025-11-29

**Hallazgo:**
- Archivos QA duplicados en `/qa/` y `/procesos/qa/`
- Documentos duplicados:
  * actividades_garantia_documental.md
  * checklist_auditoria_restricciones.md
  * estrategia_qa.md

**Decision:**
- Version canonica: `docs/gobernanza/procesos/qa/`
- Eliminar: `docs/gobernanza/qa/` (directorio raiz)

**Plan de accion:**

```bash
# 1. Comparar versiones
diff -r docs/gobernanza/qa/ docs/gobernanza/procesos/qa/

# 2. Backup
BACKUP_DIR="backups/qa_consolidation_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp -r docs/gobernanza/qa "$BACKUP_DIR/"

# 3. Actualizar referencias
find docs/gobernanza -name "*.md" -type f -exec sed -i \
  's|/qa/|/procesos/qa/|g' {} \;

find docs/gobernanza -name "*.md" -type f -exec sed -i \
  's|(qa/|(procesos/qa/|g' {} \;

# 4. Eliminar directorio qa/ raiz
rm -rf docs/gobernanza/qa/

# 5. Actualizar INDEX.md
sed -i 's|docs/qa/|docs/procesos/qa/|g' docs/gobernanza/INDEX.md

# 6. Commit
git add docs/gobernanza/
git commit -m "refactor(docs): consolidar QA en procesos/qa, eliminar duplicados"
```

**Criterios de aceptacion:**
- [ ] Solo existe `/procesos/qa/`
- [ ] Todas las referencias actualizadas
- [ ] 6 archivos de duplicacion eliminados
- [ ] INDEX.md actualizado

---

### TASK-REM-007: Normalizar Nomenclatura ADRs

**Prioridad:** ALTA
**Severidad:** MEDIA
**Esfuerzo:** 6 horas
**Responsable:** Arquitecto Senior
**Fecha limite:** 2025-12-02

**Hallazgo:**
- Nomenclatura inconsistente:
  * ADR-012 (correcto)
  * ADR_012 (incorrecto - underscore)
  * adr_2025_012 (incorrecto - lowercase + year)

**Estandar definido:**
- Formato: `ADR-NNN-descripcion-kebab-case.md`
- Numeracion: 001-999 (3 digitos)
- Descripcion: Breve, kebab-case

**Plan de accion:**

```bash
# 1. Listar todos los ADRs con nombres no conformes
find docs/gobernanza/adr -name "*.md" | grep -v "^ADR-[0-9]\{3\}" > adrs_no_conformes.txt

# 2. Script de renombramiento
cat > scripts/normalize_adr_names.sh << 'EOF'
#!/bin/bash
# Normalizar nombres de ADRs

ADR_DIR="docs/gobernanza/adr"
BACKUP_DIR="backups/adr_rename_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Crear mapa de renombramientos
declare -A rename_map

# Procesar cada ADR no conforme
while IFS= read -r old_file; do
  # Extraer numero ADR
  if [[ "$old_file" =~ ADR[_-]?([0-9]+) ]]; then
    num="${BASH_REMATCH[1]}"
    num_padded=$(printf "%03d" "$num")

    # Generar nuevo nombre
    new_name="ADR-${num_padded}.md"
    new_file="$ADR_DIR/$new_name"

    # Backup
    cp "$old_file" "$BACKUP_DIR/"

    # Guardar mapeo
    rename_map["$old_file"]="$new_file"

    echo "Renombrar: $(basename "$old_file") -> $new_name"
  fi
done < adrs_no_conformes.txt

# Ejecutar renombramientos
for old in "${!rename_map[@]}"; do
  new="${rename_map[$old]}"
  git mv "$old" "$new"
done

# Actualizar referencias en todos los documentos
for old_path in "${!rename_map[@]}"; do
  old_name=$(basename "$old_path")
  new_name=$(basename "${rename_map[$old_path]}")

  find docs/gobernanza -name "*.md" -type f -exec sed -i \
    "s|$old_name|$new_name|g" {} \;
done

echo "Renombramiento completado. Backup en: $BACKUP_DIR"
EOF

chmod +x scripts/normalize_adr_names.sh
./scripts/normalize_adr_names.sh

# 3. Validar nombres
find docs/gobernanza/adr -name "*.md" | while read -r file; do
  filename=$(basename "$file")
  if ! [[ "$filename" =~ ^(ADR-[0-9]{3}|README)\.md$ ]]; then
    echo "NOMBRE NO CONFORME: $filename"
  fi
done
```

**Criterios de aceptacion:**
- [ ] Todos los ADRs siguen formato ADR-NNN.md
- [ ] Referencias actualizadas en documentos
- [ ] INDICE_ADRs.md actualizado
- [ ] Commit con mensaje: "refactor(docs): normalizar nomenclatura de ADRs"

---

### TASK-REM-008: Crear Documentos Criticos Faltantes

**Prioridad:** ALTA
**Severidad:** CRITICA
**Esfuerzo:** 12 horas
**Responsable:** Arquitecto + DevOps Lead
**Fecha limite:** 2025-12-06

**Hallazgo:**
- Gaps criticos en documentacion:
  * Gestion de secretos
  * Disaster Recovery
  * Rollback procedures

**Plan de accion:**

```bash
# 1. Crear documento: Gestion de Secretos
cat > docs/gobernanza/seguridad/gestion_secretos.md << 'EOF'
---
id: PROC-SEC-SECRETS-001
tipo: procedimiento
categoria: seguridad
version: 1.0.0
fecha_creacion: 2025-11-17
estado: activo
prioridad: CRITICA
propietario: equipo-seguridad
relacionados: ["ADR-013", "PROC-SEC-AUDIT-001"]
---
# Gestion de Secretos

## Proposito

Establecer procedimientos para gestionar secretos (API keys, passwords, certificates)
de forma segura en todo el ciclo de vida del proyecto IACT.

## Alcance

- Desarrollo local
- Entornos CI/CD
- Produccion
- Rotacion de secretos
- Auditoria de acceso

## Principios

1. NUNCA commitear secretos en repositorio
2. Usar variables de entorno
3. Rotacion periodica obligatoria
4. Principio de minimo privilegio
5. Auditoria de accesos

## Herramientas Aprobadas

### Desarrollo Local
- `.env` con `.gitignore` (OBLIGATORIO)
- `python-decouple` para cargar secrets
- `django-environ` para Django

### CI/CD
- GitHub Secrets (cifrado en reposo)
- Secrets por entorno (dev, staging, prod)

### Produccion
- Variables de entorno del sistema
- AWS Secrets Manager (si aplica)
- Rotacion automatica cuando sea posible

## Procedimiento

### 1. Crear Secreto

**Paso 1.1:** Generar secreto con herramienta apropiada
```bash
# Generar API key
openssl rand -hex 32

# Generar password seguro
openssl rand -base64 24
```

**Paso 1.2:** Almacenar en gestor apropiado
- Desarrollo: `.env` local
- CI/CD: GitHub Secrets
- Produccion: Variables de entorno

**Paso 1.3:** Documentar
- Nombre del secreto
- Proposito
- Fecha de creacion
- Politica de rotacion
- Responsable

### 2. Usar Secreto

**Desarrollo local:**
```python
from decouple import config

API_KEY = config('API_KEY')
SECRET_KEY = config('SECRET_KEY')
```

**Django settings:**
```python
import environ

env = environ.Env()
SECRET_KEY = env('SECRET_KEY')
```

**CI/CD (GitHub Actions):**
```yaml
env:
  API_KEY: ${{ secrets.API_KEY }}
```

### 3. Rotar Secreto

**Frecuencia:**
- API keys criticas: Cada 90 dias
- Passwords: Cada 180 dias
- Certificates: Antes de expiracion

**Proceso:**
1. Generar nuevo secreto
2. Configurar en paralelo (si posible)
3. Actualizar aplicaciones
4. Verificar funcionamiento
5. Revocar secreto antiguo
6. Documentar en log de rotacion

### 4. Revocar Secreto Comprometido

**Accion inmediata (< 1 hora):**
1. Generar nuevo secreto
2. Actualizar en todos los entornos
3. Revocar secreto comprometido
4. Verificar que no esta en uso
5. Notificar a equipo de seguridad

## Checklist de Verificacion

- [ ] Archivo `.env.example` existe (sin valores reales)
- [ ] `.gitignore` incluye `.env`
- [ ] GitHub Secrets configurados
- [ ] Documentacion de secretos actualizada
- [ ] Log de rotacion mantenido

## Auditoria

**Mensual:**
- Revisar accesos a secretos
- Verificar politica de rotacion
- Escanear commits en busca de leaks

**Herramientas:**
- `gitleaks` en CI/CD
- `trufflehog` para escaneo profundo

## Incumplimiento

**Secreto en commit:**
- SEVERIDAD: CRITICA
- ACCION: Rotar inmediatamente, limpiar historial Git

**Secreto no rotado:**
- SEVERIDAD: ALTA
- ACCION: Rotar en < 24 horas

## Referencias

- [ADR-013: Configuracion de secretos](../adr/ADR-013.md)
- [OWASP Secrets Management](https://owasp.org/www-project-secrets-management/)
EOF

# 2. Crear documento: Disaster Recovery
cat > docs/gobernanza/procesos/disaster_recovery_plan.md << 'EOF'
---
id: PROC-DR-001
tipo: procedimiento
categoria: operaciones
version: 1.0.0
fecha_creacion: 2025-11-17
estado: activo
prioridad: CRITICA
propietario: equipo-devops
relacionados: ["PROC-BACKUP-001", "RUNBOOK-RESTORE"]
---
# Plan de Disaster Recovery

## Proposito

Definir procedimientos para recuperacion del sistema IACT ante desastres.

## Objetivos

- **RTO (Recovery Time Objective):** 4 horas
- **RPO (Recovery Point Objective):** 1 hora

## Escenarios de Desastre

### 1. Perdida de Base de Datos

**Deteccion:**
- Alerta de monitoreo
- Aplicacion sin conectividad

**Recuperacion:**
1. Verificar backup mas reciente
2. Restaurar desde backup
3. Aplicar transaction logs
4. Verificar integridad
5. Reconectar aplicacion

**Tiempo estimado:** 2 horas

### 2. Perdida de Servidor de Aplicacion

**Deteccion:**
- Health check fallando
- 502/503 errors

**Recuperacion:**
1. Provision nuevo servidor
2. Deploy desde CI/CD
3. Configurar variables entorno
4. Verificar conectividad DB
5. Activar trafico

**Tiempo estimado:** 1 hora

### 3. Perdida de Repositorio Git

**Deteccion:**
- GitHub inaccesible
- Commits no sincronizan

**Recuperacion:**
1. Usar mirror local mas reciente
2. Push a GitHub restaurado o alternativo
3. Verificar integridad
4. Actualizar CI/CD webhooks

**Tiempo estimado:** 30 minutos

## Procedimientos Detallados

### Restauracion de Base de Datos

```bash
# 1. Listar backups disponibles
aws s3 ls s3://iact-backups/postgres/

# 2. Descargar backup mas reciente
aws s3 cp s3://iact-backups/postgres/latest.dump /tmp/

# 3. Detener aplicacion
systemctl stop iact-api

# 4. Restaurar backup
pg_restore -h localhost -U postgres -d iact_db /tmp/latest.dump

# 5. Verificar integridad
psql -h localhost -U postgres -d iact_db -c "SELECT COUNT(*) FROM django_migrations;"

# 6. Reiniciar aplicacion
systemctl start iact-api

# 7. Verificar health
curl http://localhost:8000/health/
```

## Contactos de Emergencia

- Arquitecto Senior: [REDACTED]
- DevOps Lead: [REDACTED]
- DBA: [REDACTED]

## Testing del Plan

**Frecuencia:** Trimestral

**Procedimiento:**
1. Simular desastre en entorno staging
2. Ejecutar procedimientos DR
3. Documentar tiempo de recuperacion
4. Identificar mejoras

## Referencias

- [Runbook de Backups](../runbooks/backup_procedures.md)
- [Playbook de Incidentes](../playbooks/incident_response.md)
EOF

# 3. Crear documento: Rollback Procedures
cat > docs/gobernanza/procesos/rollback_procedures.md << 'EOF'
---
id: PROC-ROLLBACK-001
tipo: procedimiento
categoria: deployment
version: 1.0.0
fecha_creacion: 2025-11-17
estado: activo
prioridad: ALTA
propietario: equipo-devops
relacionados: ["PROC-DEPLOY-001", "ADR-008"]
---
# Procedimientos de Rollback

## Proposito

Definir proceso para revertir deployments fallidos o problematicos.

## Criterios de Rollback

**Ejecutar rollback si:**
- Error rate > 5%
- Response time > 2x baseline
- Critical functionality broken
- Data corruption detectada

## Procedimientos por Componente

### Backend Django

**Rollback de codigo:**
```bash
# 1. Identificar version anterior estable
git log --oneline -10

# 2. Crear tag de rollback
git tag rollback-$(date +%Y%m%d-%H%M)

# 3. Revertir a commit anterior
git revert HEAD

# 4. Push
git push origin main

# 5. Trigger CI/CD deploy
```

**Rollback de migraciones DB:**
```bash
# 1. Identificar migracion a revertir
python manage.py showmigrations

# 2. Revertir migracion
python manage.py migrate app_name 0010_previous_migration

# 3. Verificar esquema
python manage.py sqlmigrate app_name 0010
```

### Frontend

**Rollback de assets:**
```bash
# 1. Identificar version anterior
ls -lt /var/www/static/versions/

# 2. Cambiar symlink
ln -sf /var/www/static/versions/20250115/ /var/www/static/current

# 3. Clear CDN cache
curl -X PURGE https://cdn.iact.com/static/*
```

## Validacion Post-Rollback

- [ ] Health check OK
- [ ] Error rate normal
- [ ] Response time normal
- [ ] Critical paths funcionando
- [ ] Notificar a stakeholders

## Referencias

- [Procedimiento de Deployment](procedimiento_deployment.md)
- [ADR-008: Estrategia de deployment](../adr/ADR-008.md)
EOF

# 4. Actualizar index
echo "- [Gestion de Secretos](seguridad/gestion_secretos.md)" >> docs/gobernanza/INDEX.md
echo "- [Disaster Recovery](procesos/disaster_recovery_plan.md)" >> docs/gobernanza/INDEX.md
echo "- [Rollback Procedures](procesos/rollback_procedures.md)" >> docs/gobernanza/INDEX.md

# 5. Commit
git add docs/gobernanza/
git commit -m "docs(gobernanza): agregar documentacion critica (secretos, DR, rollback)"
```

**Criterios de aceptacion:**
- [ ] 3 documentos criticos creados
- [ ] Frontmatter completo
- [ ] Contenido revisado por expertos
- [ ] Agregado a INDEX.md

---

## Fase 3: Mejoras de Calidad (Mes 1)

**Duracion:** 20 dias laborales
**Esfuerzo:** 22 horas

### TASK-REM-009: Estandarizar Frontmatter

**Prioridad:** MEDIA
**Severidad:** MEDIA
**Esfuerzo:** 10 horas
**Responsable:** Equipo Gobernanza
**Fecha limite:** 2025-12-13

**Plan de accion:**

1. Definir estandar de frontmatter
2. Crear validador automatico
3. Corregir desviaciones
4. Integrar en CI/CD

---

### TASK-REM-010: Limpiar Archivos Raiz

**Prioridad:** MEDIA
**Severidad:** BAJA
**Esfuerzo:** 4 horas
**Responsable:** Equipo Documentacion
**Fecha limite:** 2025-12-15

**Objetivo:** Reducir de 34 a 10-15 archivos en raiz

---

### TASK-REM-011: Implementar Validacion CI/CD

**Prioridad:** MEDIA
**Severidad:** ALTA (prevencion)
**Esfuerzo:** 8 horas
**Responsable:** DevOps Lead
**Fecha limite:** 2025-12-20

**Plan de accion:**

```yaml
# .github/workflows/docs-validation.yml
name: Documentation Validation

on:
  pull_request:
    paths:
      - 'docs/**'
  push:
    branches:
      - main
      - develop

jobs:
  validate-docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Check for emojis
        run: |
          if grep -r -P '[\x{1F300}-\x{1F9FF}]' docs/; then
            echo "ERROR: Emojis found in documentation"
            exit 1
          fi

      - name: Validate markdown links
        uses: gaurav-nelson/github-action-markdown-link-check@v1
        with:
          config-file: '.markdown-link-check.json'

      - name: Validate frontmatter
        run: ./scripts/validate_frontmatter.sh

      - name: Check H1 headers
        run: ./scripts/validate_h1.sh

      - name: Lint markdown
        uses: DavidAnson/markdownlint-cli2-action@v11
        with:
          globs: 'docs/**/*.md'
```

---

## Fase 4: Optimizaciones (Mes 2-3)

**Duracion:** 30 dias laborales
**Esfuerzo:** 18 horas

### TASK-REM-012: Resolver TODOs Criticos

**Esfuerzo:** 8 horas
**Fecha limite:** 2025-12-31

---

### TASK-REM-013: Optimizar Profundidad de Directorios

**Esfuerzo:** 6 horas
**Fecha limite:** 2026-01-15

---

### TASK-REM-014: Mejorar Cobertura README

**Esfuerzo:** 4 horas
**Fecha limite:** 2026-01-31

---

## Metricas de Seguimiento

### Dashboard Semanal

```bash
# Script de metricas
cat > scripts/docs_quality_metrics.sh << 'EOF'
#!/bin/bash
# Generar metricas de calidad de documentacion

echo "=== METRICAS DE CALIDAD DOCS/GOBERNANZA ==="
echo "Fecha: $(date)"
echo

echo "Emojis:"
emoji_count=$(find docs/gobernanza -name "*.md" -exec grep -P '[\x{1F300}-\x{1F9FF}]' {} \; | wc -l)
echo "  Total: $emoji_count (Objetivo: 0)"

echo "Enlaces rotos:"
broken_links=$(markdown-link-check docs/gobernanza/**/*.md 2>&1 | grep -c "STATUS: 404")
echo "  Total: $broken_links (Objetivo: < 5)"

echo "Frontmatter:"
total_files=$(find docs/gobernanza -name "*.md" | wc -l)
with_frontmatter=$(find docs/gobernanza -name "*.md" -exec grep -l "^---" {} \; | wc -l)
percent=$((with_frontmatter * 100 / total_files))
echo "  Cobertura: $percent% ($with_frontmatter/$total_files) (Objetivo: 100%)"

echo "Multiples H1:"
multiple_h1=$(find docs/gobernanza -name "*.md" -exec sh -c 'grep -c "^# " "$1" | awk "\$1 > 1 {print}"' _ {} \; | wc -l)
echo "  Total: $multiple_h1 (Objetivo: 0)"

echo "TODOs:"
todos=$(grep -r "TODO" docs/gobernanza/ | wc -l)
echo "  Total: $todos (Tendencia: descendente)"
EOF

chmod +x scripts/docs_quality_metrics.sh
```

**Ejecutar semanalmente:**
```bash
./scripts/docs_quality_metrics.sh > metricas_$(date +%Y%m%d).txt
```

---

## Responsabilidades

### Equipo Gobernanza
- TASK-REM-001 (Emojis)
- TASK-REM-003 (Frontmatter)
- TASK-REM-005 (H1)
- TASK-REM-009 (Estandarizar frontmatter)

### Equipo Documentacion
- TASK-REM-002 (Enlaces rotos)
- TASK-REM-010 (Limpiar raiz)

### Arquitecto Senior
- TASK-REM-004 (Marco integrado)
- TASK-REM-007 (Nomenclatura ADRs)
- TASK-REM-008 (Docs criticos - parte)

### DevOps Lead
- TASK-REM-008 (Docs criticos - parte)
- TASK-REM-011 (CI/CD validation)

### QA Lead
- TASK-REM-006 (Consolidar QA)

---

## Cronograma

```
Semana 1 (Nov 18-22)
- TASK-REM-001: Emojis
- TASK-REM-002: Enlaces rotos
- TASK-REM-003: Frontmatter
- TASK-REM-004: Marco integrado

Semana 2-3 (Nov 25 - Dic 06)
- TASK-REM-005: Multiples H1 (continuo)
- TASK-REM-006: Consolidar QA
- TASK-REM-007: Nomenclatura ADRs
- TASK-REM-008: Docs criticos

Semana 4 (Dic 09-13)
- TASK-REM-009: Estandarizar frontmatter
- TASK-REM-010: Limpiar raiz

Semana 5 (Dic 16-20)
- TASK-REM-011: CI/CD validation
- TASK-REM-005: Finalizar H1

Mes 2-3 (Dic-Ene)
- TASK-REM-012: TODOs criticos
- TASK-REM-013: Profundidad dirs
- TASK-REM-014: Cobertura README
```

---

## Criterios de Exito

**Al finalizar Fase 1 (Semana 1):**
- [ ] 0 emojis en documentacion
- [ ] < 50 enlaces rotos
- [ ] 100% frontmatter en archivos criticos
- [ ] Marco integrado consolidado

**Al finalizar Fase 2 (Semana 3):**
- [ ] < 50 archivos con multiples H1
- [ ] QA consolidado
- [ ] ADRs nomenclatura estandar
- [ ] 3 documentos criticos creados

**Al finalizar Fase 3 (Mes 1):**
- [ ] Frontmatter estandarizado
- [ ] < 15 archivos en raiz
- [ ] CI/CD validation activa

**Al finalizar Fase 4 (Mes 3):**
- [ ] TODOs criticos resueltos
- [ ] Profundidad < 5 niveles
- [ ] 80% cobertura README

---

## Riesgos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|--------------|---------|------------|
| Conflictos Git por cambios masivos | ALTA | MEDIO | Commits pequenos, coordinacion |
| Regresion por scripts automaticos | MEDIA | ALTO | Backups, validacion manual |
| Resistencia al cambio | MEDIA | MEDIO | Comunicacion clara, beneficios |
| Tiempo insuficiente | MEDIA | ALTO | Priorizacion, fases incrementales |

---

## Comunicacion

**Inicio de plan:**
- Email a todos los equipos
- Presentacion en daily standup
- Documento compartido

**Semanal:**
- Reporte de progreso
- Metricas actualizadas
- Bloqueos identificados

**Completado:**
- Resumen ejecutivo
- Lecciones aprendidas
- Mejoras continuas

---

**Aprobacion:**

- [ ] Arquitecto Senior
- [ ] QA Lead
- [ ] DevOps Lead
- [ ] Product Owner

**Fecha aprobacion:** __________

**Inicio ejecucion:** 2025-11-18

---

**Version:** 1.0.0
**Ultima actualizacion:** 2025-11-17
**Proximo review:** 2025-12-01
