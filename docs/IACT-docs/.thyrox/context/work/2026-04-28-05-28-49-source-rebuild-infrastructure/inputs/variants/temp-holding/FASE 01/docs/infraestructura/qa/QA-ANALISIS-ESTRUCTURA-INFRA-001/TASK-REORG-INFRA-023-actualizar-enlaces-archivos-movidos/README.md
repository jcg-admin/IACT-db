---
id: TASK-REORG-INFRA-023
titulo: Actualizar Enlaces a Archivos Movidos
fase: FASE_2_REORGANIZACION_CRITICA
subcategoria: Actualizacion de Enlaces
prioridad: CRITICA (P0)
duracion_estimada: 4 horas
estado: Pendiente
tipo: Actualizacion
dependencias:
  - TASK-REORG-INFRA-022
tecnica_prompting: Self-Consistency + Auto-CoT
fecha_creacion: 2025-11-18
autor: QA Infraestructura
tags:
  - enlaces
  - validacion
  - integridad
  - fase-2
---

# TASK-REORG-INFRA-023: Actualizar Enlaces a Archivos Movidos

## Descripción

Actualizar todos los enlaces en la documentación de `/docs/infraestructura/` que apuntan a archivos que fueron movidos en TASK-022. Esta tarea es crítica para mantener la integridad de la documentación y evitar enlaces rotos.

## Objetivo

Garantizar que todos los enlaces internos en la documentación funcionen correctamente después de la reorganización de archivos, utilizando múltiples estrategias de búsqueda para asegurar completitud (Self-Consistency).

## Técnica de Prompting: Self-Consistency + Auto-CoT

### Aplicación de Self-Consistency

**Self-Consistency** valida resultados mediante múltiples enfoques independientes, comparando outputs para asegurar completitud y correctitud.

#### Estrategia Multi-Path para Encontrar Enlaces

```
OBJETIVO: Encontrar TODOS los enlaces a archivos movidos

PATH 1: Búsqueda por Nombre de Archivo
├─ grep -r "canvas_devcontainer_host\.md"
├─ grep -r "ADR-INFRA-001\.md"
└─ grep -r "PROC-INFRA-.*\.md"

PATH 2: Búsqueda por Patrón de Enlace Markdown
├─ grep -r "\[.*\](\.\.*/.*\.md)"
├─ grep -r "\[.*\](\./*\.md)"
└─ find . -name "*.md" -exec grep -l "](.*\.md)" {} \;

PATH 3: Búsqueda por Carpeta Origen
├─ Buscar enlaces que apuntan a rutas antiguas
├─ grep -r "](\./" | grep -v "diseno/\|adr/\|procesos/"
└─ Buscar referencias sin ./: grep -r "](canvas_"

VALIDACIÓN CRUZADA:
- Comparar resultados de PATH 1, 2, 3
- Identificar enlaces encontrados por todos los paths
- Identificar enlaces únicos de cada path
- Consolidar lista completa sin duplicados
```

### Auto-CoT: Razonamiento para Actualización

#### Paso 1: Identificar Enlaces Afectados
```
RAZONAMIENTO:
Para cada archivo que fue movido en TASK-022:
  Archivo: canvas_devcontainer_host.md
  Ubicación anterior: /docs/infraestructura/canvas_devcontainer_host.md
  Ubicación nueva: /docs/infraestructura/diseno/canvas/canvas_devcontainer_host.md

  BUSCAR REFERENCIAS:
  - Enlaces directos: [Canvas](./canvas_devcontainer_host.md)
  - Enlaces relativos: [Canvas](../canvas_devcontainer_host.md)
  - Enlaces absolutos: [Canvas](/docs/infraestructura/canvas_devcontainer_host.md)

  CALCULAR NUEVA RUTA:
  Desde /docs/infraestructura/README.md:
    Antigua: ./canvas_devcontainer_host.md
    Nueva: ./diseno/canvas/canvas_devcontainer_host.md

  Desde /docs/infraestructura/adr/ADR-INFRA-001.md:
    Antigua: ../canvas_devcontainer_host.md
    Nueva: ../diseno/canvas/canvas_devcontainer_host.md
```

#### Paso 2: Categorizar Enlaces por Tipo de Actualización
```
TIPO 1: Enlaces desde raíz a archivos movidos
  Patrón: ./archivo.md
  Actualización: ./categoria/archivo.md
  Ejemplo: ./canvas.md → ./diseno/canvas/canvas.md

TIPO 2: Enlaces desde carpetas a archivos movidos en raíz
  Patrón: ../archivo.md
  Actualización: ../categoria/archivo.md
  Ejemplo: ../canvas.md → ../diseno/canvas/canvas.md

TIPO 3: Enlaces entre archivos movidos
  Patrón: ../archivo.md
  Actualización: ../../otra-categoria/archivo.md
  Ejemplo: Desde adr/ a diseno/: ../canvas.md → ../diseno/canvas/canvas.md

TIPO 4: Enlaces absolutos
  Patrón: /docs/infraestructura/archivo.md
  Actualización: /docs/infraestructura/categoria/archivo.md
```

## Pasos de Ejecución

### 1. Preparación: Obtener Lista de Archivos Movidos (15 min)

```bash
cd /home/user/IACT/docs/infraestructura

# Leer lista de archivos movidos desde TASK-022
cat qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-REORG-INFRA-022-mover-archivos-raiz/evidencias/archivos-raiz-movidos.txt

# Crear lista de archivos para buscar
cat > /tmp/archivos-movidos.txt << 'EOF'
canvas_devcontainer_host.md
canvas_pipeline_cicd_devcontainer.md
ADR-INFRA-001.md
PROC-INFRA-001.md
PROCED-INFRA-001.md
# ... añadir todos los archivos movidos
EOF
```

### 2. Búsqueda Multi-Path (PATH 1): Por Nombre de Archivo (30 min)

```bash
# PATH 1: Búsqueda por nombre exacto de archivo
mkdir -p /tmp/enlaces-encontrados

while IFS= read -r archivo; do
  echo "=== Buscando referencias a: $archivo ===" | tee -a /tmp/enlaces-encontrados/path1.txt
  grep -rn "$archivo" . --include="*.md" | tee -a /tmp/enlaces-encontrados/path1.txt
done < /tmp/archivos-movidos.txt
```

**Auto-CoT - Razonamiento PATH 1:**
```
VENTAJA: Encuentra todas las referencias exactas al nombre del archivo
LIMITACIÓN: No encuentra variaciones de ruta (ej: ./archivo vs ../archivo)
CONFIABILIDAD: Alta - nombres de archivo son únicos
```

### 3. Búsqueda Multi-Path (PATH 2): Por Patrón de Enlace (30 min)

```bash
# PATH 2: Búsqueda por patrón de enlaces Markdown
echo "=== Buscando todos los enlaces Markdown ===" > /tmp/enlaces-encontrados/path2.txt

# Buscar enlaces relativos: [texto](./path.md) o [texto](../path.md)
grep -rn "\[.*\](\.\.*/.*\.md)" . --include="*.md" | tee -a /tmp/enlaces-encontrados/path2.txt

# Buscar enlaces en misma carpeta: [texto](archivo.md)
grep -rn "\[.*\]([^/]*\.md)" . --include="*.md" | tee -a /tmp/enlaces-encontrados/path2.txt

# Buscar enlaces absolutos: [texto](/docs/infraestructura/...)
grep -rn "\[.*\](/docs/infraestructura/.*\.md)" . --include="*.md" | tee -a /tmp/enlaces-encontrados/path2.txt
```

**Auto-CoT - Razonamiento PATH 2:**
```
VENTAJA: Encuentra todos los enlaces Markdown independiente del archivo
LIMITACIÓN: Puede incluir enlaces que no necesitan actualización
CONFIABILIDAD: Media - requiere filtrado posterior
```

### 4. Búsqueda Multi-Path (PATH 3): Por Exclusión de Carpetas (30 min)

```bash
# PATH 3: Buscar enlaces que probablemente apuntan a archivos movidos
echo "=== Buscando enlaces a archivos en raíz ===" > /tmp/enlaces-encontrados/path3.txt

# Buscar enlaces que NO apuntan a carpetas conocidas (probablemente apuntan a archivos que estaban en raíz)
grep -rn "](\./" . --include="*.md" | \
  grep -v "](./diseno/" | \
  grep -v "](./adr/" | \
  grep -v "](./procesos/" | \
  grep -v "](./procedimientos/" | \
  grep -v "](./devops/" | \
  grep -v "](./plantillas/" | \
  grep -v "](./checklists/" | \
  grep -v "](./solicitudes/" | \
  grep -v "](./README.md)" | \
  grep -v "](./INDEX.md)" \
  >> /tmp/enlaces-encontrados/path3.txt
```

**Auto-CoT - Razonamiento PATH 3:**
```
VENTAJA: Identifica enlaces que probablemente necesitan actualización
LIMITACIÓN: Puede perder algunos casos edge
CONFIABILIDAD: Alta - lógica de exclusión es sólida
```

### 5. Consolidación y Validación Cruzada (Self-Consistency) (45 min)

```bash
# Consolidar resultados de los 3 paths
cat /tmp/enlaces-encontrados/path1.txt \
    /tmp/enlaces-encontrados/path2.txt \
    /tmp/enlaces-encontrados/path3.txt | \
  sort -u > /tmp/enlaces-encontrados/consolidado.txt

# Analizar resultados
echo "=== ANÁLISIS DE RESULTADOS ===" > evidencias/analisis-enlaces.md
echo "## Estadísticas" >> evidencias/analisis-enlaces.md
echo "- Enlaces encontrados PATH 1: $(wc -l < /tmp/enlaces-encontrados/path1.txt)" >> evidencias/analisis-enlaces.md
echo "- Enlaces encontrados PATH 2: $(wc -l < /tmp/enlaces-encontrados/path2.txt)" >> evidencias/analisis-enlaces.md
echo "- Enlaces encontrados PATH 3: $(wc -l < /tmp/enlaces-encontrados/path3.txt)" >> evidencias/analisis-enlaces.md
echo "- Enlaces únicos consolidados: $(wc -l < /tmp/enlaces-encontrados/consolidado.txt)" >> evidencias/analisis-enlaces.md

# Identificar enlaces encontrados por todos los paths (alta confianza)
echo "## Enlaces de Alta Confianza (encontrados por múltiples paths)" >> evidencias/analisis-enlaces.md
comm -12 <(sort /tmp/enlaces-encontrados/path1.txt) <(sort /tmp/enlaces-encontrados/path2.txt) >> evidencias/analisis-enlaces.md
```

**Self-Consistency - Validación:**
```
PREGUNTA: ¿Encontramos TODOS los enlaces?

VERIFICACIÓN:
[OK] PATH 1 encontró: N enlaces por nombre exacto
[OK] PATH 2 encontró: M enlaces por patrón
[OK] PATH 3 encontró: K enlaces por exclusión

ANÁLISIS:
- Enlaces en común (alta confianza): X
- Enlaces únicos PATH 1: Y (verificar manualmente)
- Enlaces únicos PATH 2: Z (filtrar falsos positivos)
- Enlaces únicos PATH 3: W (verificar edge cases)

CONCLUSIÓN:
Si X + Y + Z + W = Total esperado → COMPLETO
Si hay discrepancias → INVESTIGAR manualmente
```

### 6. Actualizar Enlaces (90 min)

**Estrategia: Actualizar por archivo fuente**

```bash
# Para cada archivo que contiene enlaces a actualizar
# Ejemplo: Actualizar README.md

# 1. Verificar enlaces actuales
grep -n "](\./" README.md

# 2. Actualizar manualmente o con sed (cuidadosamente)
# Ejemplo: canvas_devcontainer_host.md movido a diseno/canvas/
sed -i 's|\](./canvas_devcontainer_host\.md)|\](./diseno/canvas/canvas_devcontainer_host.md)|g' README.md

# 3. Verificar cambio
git diff README.md

# 4. Documentar cambio
echo "README.md: canvas_devcontainer_host.md → diseno/canvas/canvas_devcontainer_host.md" >> evidencias/enlaces-actualizados-completo.md
```

**Script de Actualización (ejemplo):**
```bash
#!/bin/bash
# update-links.sh

# Matriz de transformación: antigua_ruta → nueva_ruta
declare -A LINK_MAP=(
  ["./canvas_devcontainer_host.md"]="./diseno/canvas/canvas_devcontainer_host.md"
  ["./canvas_pipeline_cicd_devcontainer.md"]="./diseno/canvas/canvas_pipeline_cicd_devcontainer.md"
  ["./ADR-INFRA-001.md"]="./adr/ADR-INFRA-001.md"
  ["./PROC-INFRA-001.md"]="./procesos/PROC-INFRA-001.md"
  # ... más mapeos
)

# Aplicar transformaciones
for OLD_PATH in "${!LINK_MAP[@]}"; do
  NEW_PATH="${LINK_MAP[$OLD_PATH]}"
  echo "Actualizando: $OLD_PATH → $NEW_PATH"

  # Buscar y reemplazar en todos los archivos .md
  find . -name "*.md" -type f -exec sed -i "s|]($OLD_PATH)|]($NEW_PATH)|g" {} \;
done
```

**Auto-CoT - Razonamiento para Actualización:**
```
PARA CADA ENLACE:
  1. Identificar archivo fuente del enlace
  2. Identificar archivo destino del enlace
  3. Calcular ruta relativa correcta desde fuente a destino
  4. Actualizar enlace
  5. Verificar cambio con git diff
  6. Probar enlace (abrir en editor/navegador)
  7. Documentar actualización
```

### 7. Verificación de Enlaces No Rotos (45 min)

```bash
# Verificar que no hay enlaces rotos
# Opción 1: Script personalizado
cat > /tmp/check-links.sh << 'EOF'
#!/bin/bash
cd /home/user/IACT/docs/infraestructura

ERROR_COUNT=0

# Extraer todos los enlaces relativos
grep -rh "\[.*\](\..*\.md)" . --include="*.md" | \
  grep -o "](\..*\.md)" | \
  sed 's/](\.\///g;s/)$//' | \
  sort -u > /tmp/all-links.txt

# Verificar cada enlace
while IFS= read -r link; do
  if [ ! -f "$link" ]; then
    echo "ERROR: Enlace roto: $link" | tee -a evidencias/enlaces-rotos.log
    ((ERROR_COUNT++))
  fi
done < /tmp/all-links.txt

echo "=== RESUMEN ===" | tee -a evidencias/verificacion-enlaces.log
echo "Enlaces verificados: $(wc -l < /tmp/all-links.txt)" | tee -a evidencias/verificacion-enlaces.log
echo "Enlaces rotos: $ERROR_COUNT" | tee -a evidencias/verificacion-enlaces.log

if [ $ERROR_COUNT -eq 0 ]; then
  echo "[OK] VALIDACIÓN EXITOSA: 0 enlaces rotos" | tee -a evidencias/verificacion-enlaces.log
  exit 0
else
  echo "[ERROR] VALIDACIÓN FALLIDA: $ERROR_COUNT enlaces rotos" | tee -a evidencias/verificacion-enlaces.log
  exit 1
fi
EOF

chmod +x /tmp/check-links.sh
/tmp/check-links.sh
```

**Self-Consistency - Verificación Final:**
```
VERIFICACIÓN MULTI-NIVEL:

NIVEL 1: Verificación Sintáctica
- [ ] Todos los enlaces siguen formato Markdown correcto
- [ ] Rutas relativas usan ./ o ../
- [ ] No hay espacios en rutas de enlace

NIVEL 2: Verificación Semántica
- [ ] Archivos destino existen en nueva ubicación
- [ ] Rutas relativas son correctas desde archivo fuente
- [ ] No hay enlaces circulares

NIVEL 3: Verificación de Completitud
- [ ] Todos los archivos movidos fueron considerados
- [ ] Todos los archivos que enlazan a movidos fueron actualizados
- [ ] 0 enlaces rotos reportados

CONSISTENCIA:
Si NIVEL 1 ∧ NIVEL 2 ∧ NIVEL 3 → TAREA COMPLETA
```

## Auto-CoT: Razonamiento Completo Documentado

### Análisis del Problema

```
SITUACIÓN:
- TASK-022 movió 13 archivos de raíz a carpetas
- Enlaces en documentación ahora apuntan a ubicaciones antiguas
- Enlaces rotos rompen navegación y experiencia de usuario

DESAFÍO:
¿Cómo asegurar que encontramos TODOS los enlaces afectados?

SOLUCIÓN: Self-Consistency
- Usar múltiples estrategias de búsqueda independientes
- Comparar resultados entre estrategias
- Consolidar lista completa sin duplicados
- Validar que no hay enlaces rotos después de actualización
```

### Razonamiento de Búsqueda Multi-Path

```
PATH 1: Búsqueda por Nombre
├─ VENTAJA: Preciso para archivos específicos
├─ DESVENTAJA: Requiere conocer todos los nombres
└─ USO: Validar que archivos movidos no tienen referencias antiguas

PATH 2: Búsqueda por Patrón
├─ VENTAJA: Encuentra todos los enlaces Markdown
├─ DESVENTAJA: Muchos falsos positivos
└─ USO: Descubrir enlaces no anticipados

PATH 3: Búsqueda por Exclusión
├─ VENTAJA: Identifica enlaces probablemente afectados
├─ DESVENTAJA: Lógica de exclusión puede tener gaps
└─ USO: Filtrar enlaces candidatos a actualización

SÍNTESIS:
Intersección de PATH 1, 2, 3 = Enlaces de alta confianza
Unión de PATH 1, 2, 3 = Lista completa de candidatos
```

### Estrategia de Actualización

```
PREGUNTA: ¿Actualizar todos a la vez o incrementalmente?

OPCIÓN A: Actualización en Masa (sed/script)
├─ PRO: Rápido, consistente
├─ CONTRA: Riesgoso, difícil de revertir
└─ CUÁNDO: Alta confianza en mapeos, backup disponible

OPCIÓN B: Actualización Incremental (manual)
├─ PRO: Seguro, verificable por paso
├─ CONTRA: Lento, propenso a errores humanos
└─ CUÁNDO: Baja confianza, enlaces complejos

DECISIÓN: Híbrida
1. Actualizar enlaces simples con script (80% de casos)
2. Revisar manualmente enlaces complejos (20% de casos)
3. Verificar cada categoría antes de continuar
```

## Criterios de Aceptación

- [ ] Todos los enlaces a archivos movidos han sido identificados usando al menos 2 estrategias de búsqueda (Self-Consistency)
- [ ] Todos los enlaces han sido actualizados a las nuevas ubicaciones
- [ ] Verificación de enlaces ejecutada con 0 enlaces rotos
- [ ] Análisis de Self-Consistency documentado en `evidencias/analisis-enlaces.md`
- [ ] Lista completa de enlaces actualizados en `evidencias/enlaces-actualizados-completo.md`
- [ ] Log de verificación en `evidencias/verificacion-enlaces.log`
- [ ] Comparación de resultados de múltiples estrategias de búsqueda muestra consistencia
- [ ] Validación manual de al menos 10 enlaces críticos
- [ ] `git diff` muestra cambios coherentes en enlaces

## Evidencias a Generar

### 1. evidencias/analisis-enlaces.md
```markdown
# Análisis de Enlaces - Self-Consistency

## Estrategias de Búsqueda

### PATH 1: Búsqueda por Nombre de Archivo
- Archivos buscados: 13
- Enlaces encontrados: XX
- Archivos con enlaces: YY

**Top 5 archivos más referenciados:**
1. canvas_devcontainer_host.md - 15 referencias
2. ADR-INFRA-001.md - 12 referencias
3. PROC-INFRA-001.md - 8 referencias
...

### PATH 2: Búsqueda por Patrón Markdown
- Enlaces totales encontrados: ZZ
- Enlaces relativos (./ o ../): WW
- Enlaces absolutos (/docs/...): VV

### PATH 3: Búsqueda por Exclusión
- Enlaces a raíz encontrados: UU
- Falsos positivos (README.md, INDEX.md): TT
- Enlaces reales a actualizar: SS

## Validación Cruzada (Self-Consistency)

### Enlaces de Alta Confianza
Encontrados por PATH 1 ∩ PATH 2 ∩ PATH 3:
- [Lista de enlaces...]

### Enlaces Únicos por Path
- Solo en PATH 1: N enlaces [investigar...]
- Solo en PATH 2: M enlaces [filtrar...]
- Solo en PATH 3: K enlaces [verificar...]

## Conclusión
- Total enlaces a actualizar: XXX
- Confianza en completitud: 95%
- Enlaces requieren revisión manual: 5% (casos edge)
```

### 2. evidencias/enlaces-actualizados-completo.md
```markdown
# Enlaces Actualizados Completo

## Resumen Ejecutivo
- Total enlaces actualizados: XXX
- Archivos modificados: YYY
- Enlaces verificados: ZZZ
- Enlaces rotos encontrados: 0

## Actualizaciones por Categoría

### Categoría: Canvas de Diseño

#### canvas_devcontainer_host.md → diseno/canvas/canvas_devcontainer_host.md

**Archivos que enlazan:**
1. `/docs/infraestructura/README.md`
   - Línea 45: `[Canvas](./canvas_devcontainer_host.md)` → `[Canvas](./diseno/canvas/canvas_devcontainer_host.md)`

2. `/docs/infraestructura/adr/ADR-INFRA-001.md`
   - Línea 23: `[Ver Canvas](../canvas_devcontainer_host.md)` → `[Ver Canvas](../diseno/canvas/canvas_devcontainer_host.md)`

[... más actualizaciones ...]

### Categoría: ADRs

#### ADR-INFRA-001.md → adr/ADR-INFRA-001.md

[... detalles ...]

## Tabla Resumen

| Archivo Movido | Destino | Referencias Actualizadas | Archivos Modificados |
|----------------|---------|--------------------------|----------------------|
| canvas_devcontainer_host.md | diseno/canvas/ | 15 | 8 |
| ADR-INFRA-001.md | adr/ | 12 | 6 |
| PROC-INFRA-001.md | procesos/ | 8 | 5 |
| ... | ... | ... | ... |
```

### 3. evidencias/verificacion-enlaces.log
```
=== VERIFICACIÓN DE ENLACES ===
Fecha: 2025-11-18
Script: check-links.sh

=== ESTADÍSTICAS ===
Enlaces verificados: 247
Enlaces relativos: 198
Enlaces absolutos: 49
Enlaces rotos: 0

=== VERIFICACIÓN POR CATEGORÍA ===
diseno/: 45 enlaces - OK
adr/: 38 enlaces - OK
procesos/: 32 enlaces - OK
procedimientos/: 28 enlaces - OK
devops/: 24 enlaces - OK
plantillas/: 18 enlaces - OK
checklists/: 15 enlaces - OK
solicitudes/: 12 enlaces - OK
qa/: 35 enlaces - OK

=== RESULTADO ===
[OK] VALIDACIÓN EXITOSA: 0 enlaces rotos
[OK] Todos los enlaces funcionan correctamente
```

## Dependencias

**Requiere completar:**
- TASK-REORG-INFRA-022: Mover Archivos Raíz a Carpetas Apropiadas

**Desbloquea:**
- TASK-REORG-INFRA-024: Validar Reorganización de Raíz (validación completa)

## Notas Importantes

[WARNING] **CRÍTICO - P0**: Esta tarea es crítica para mantener integridad de documentación. Enlaces rotos impactan severamente la usabilidad.

 **Tip - Self-Consistency**: Usar múltiples estrategias de búsqueda asegura que no se pierda ningún enlace.

 **Reversibilidad**:
```bash
# Si actualizaciones fueron incorrectas:
git checkout HEAD -- <archivo>
# O revertir todos los cambios:
git reset --hard HEAD
```

 **Validación Manual**:
Después de actualización automática, verificar manualmente enlaces críticos:
- README.md principal
- INDEX.md
- ADRs principales
- Documentos de procesos críticos

## Relación con Otras Tareas

```
TASK-020 (Identificar archivos raíz)
    ↓
TASK-021 (Eliminar duplicados)
    ↓
TASK-022 (Mover archivos)
    ↓
TASK-023 (Actualizar enlaces) ← ESTA TAREA
    ↓
TASK-024 (Validar reorganización)
```

## Referencias

- LISTADO-COMPLETO-TAREAS.md: Línea 911-943
- Markdown Link Syntax: `[texto](ruta/relativa/archivo.md)`
- Self-Consistency Paper: "Self-Consistency Improves Chain of Thought Reasoning in Language Models"
- Git Best Practices: Commit incremental después de cada categoría actualizada
