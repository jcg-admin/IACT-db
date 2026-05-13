# PLAN MAESTRO DE GENERACIÓN DOCUMENTACIÓN IACT
## Con Nomenclatura NOM_001 v2.0.0 Correcta

**Fecha:** 2026-01-08  
**Versión:** 1.0.0  
**Objetivo:** Generar/renombrar TODA la documentación con nomenclatura correcta  
**Estándar:** NOM_001 v2.0.0 (guiones_bajos + versionado OBLIGATORIO)

---

## 🎯 PRINCIPIOS DE NOMENCLATURA

### Formato General

```
[PREFIJO]_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].ext

Donde:
  PREFIJO: Tipo de documento (PARTE, TPL, BR, UC, FR, CNST, etc.)
  Nombre_Descriptivo: En CamelCase con guiones bajos
  MAJOR_MINOR_PATCH: Versionado semántico OBLIGATORIO
  ext: Extensión (.md para pedagógicos, .rst para técnicos)
```

### Prefijos Definidos

```
PARTE: Material pedagógico (PARTE 0-6)
TPL: Templates
BR: Business Rules
UC: Use Cases
FR: Functional Requirements
CNST: Constraints
BRQ: Business Requirements
AGR: Agrupadores RBAC
PROC: Procedimientos
ANLSS: Análisis
PLN: Planes
STD: Estándares
NOM: Nomenclaturas
```

---

## 📋 INVENTARIO COMPLETO

### GRUPO 1: PARTES PEDAGÓGICAS (0-6)

| Documento | Nombre Actual | Nombre Correcto | Estado | Acción |
|-----------|---------------|-----------------|--------|--------|
| **PARTE 0** | PARTE_0_CONTEXTO_FUNDAMENTOS_IACT_1_0_0.md | ✅ CORRECTO | Generado | Copiar a outputs |
| **PARTE 1** | NO EXISTE | PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md | Pendiente | **GENERAR** |
| **PARTE 2A** | PARTE_2A_FUNDAMENTOS_IACT.md | PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md | Existe | **RENOMBRAR** |
| **PARTE 2B** | PARTE_2B_CONSTRUCCION_IACT.md | PARTE_2B_Construccion_Detallada_IACT_1_0_0.md | Existe | **RENOMBRAR** |
| **PARTE 2C** | PARTE_2C_CASOS_ESPECIALES_IACT.md | PARTE_2C_Casos_Especiales_Validacion_IACT_1_0_0.md | Existe | **RENOMBRAR** |
| **PARTE 3A** | analisis_parte3a_introduccion_crud.md | PARTE_3A_Introduccion_CRUD_IACT_1_0_0.md | Existe | **RENOMBRAR** |
| **PARTE 3B** | PARTE3B_TECNICA_LARMAN_COMPLETA.md | PARTE_3B_Tecnica_Larman_IACT_1_0_0.md | Existe | **RENOMBRAR** |
| **PARTE 3C** | PARTE3C_UI_STAKEHOLDERS_COMPLETA.md | PARTE_3C_UI_Stakeholders_IACT_1_0_0.md | Existe | **RENOMBRAR** |
| **PARTE 3D** | PARTE3D_CONSOLIDACION_RESUMEN_COMPLETA.md | PARTE_3D_Consolidacion_Resumen_IACT_1_0_0.md | Existe | **RENOMBRAR** |
| **PARTE 4** | 8 secciones separadas | PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md | Existe | **CONSOLIDAR** |
| **PARTE 5** | NO EXISTE | PARTE_5_Trazabilidad_Gestion_IACT_1_0_0.md | Pendiente | **GENERAR** |
| **PARTE 6** | NO EXISTE | PARTE_6_Casos_Practicos_Completos_IACT_1_0_0.md | Pendiente | **GENERAR** |

### GRUPO 2: TEMPLATES

| Template | Nombre Actual | Nombre Correcto | Estado | Acción |
|----------|---------------|-----------------|--------|--------|
| T01 | T01_Decision_Tipo_BR.md | TPL_BR_Decision_Tipo_1_0_0.rst | Existe | **RENOMBRAR + RST** |
| T02 | T02_Construccion_UC_7_Pasos.md | TPL_UC_Construccion_7_Pasos_1_0_0.rst | Existe | **RENOMBRAR + RST** |
| T03 | T03_Identificacion_Actor_Primario.md | TPL_UC_Identificacion_Actor_1_0_0.rst | Existe | **RENOMBRAR + RST** |
| T04 | T04_Documentacion_FR_10_Componentes.md | TPL_FR_Documentacion_10_Componentes_1_0_0.rst | Existe | **RENOMBRAR + RST** |
| T05 | T05_Construccion_Flujos_Alternos.md | TPL_UC_Flujos_Alternos_1_0_0.rst | Existe | **RENOMBRAR + RST** |
| T06 | T06_Integracion_BR_en_UC.md | TPL_UC_Integracion_BR_1_0_0.rst | Existe | **RENOMBRAR + RST** |
| T07 | NO EXISTE | TPL_UC_Derivacion_FR_1_0_0.rst | Pendiente | **GENERAR** |
| T08 | NO EXISTE | TPL_FR_Casos_Prueba_1_0_0.rst | Pendiente | **GENERAR** |
| T09 | T09_Checklist_Calidad_UC_26_Puntos.md | TPL_UC_Checklist_Calidad_26_Puntos_1_0_0.rst | Existe | **RENOMBRAR + RST** |
| T10 | T10_Peer_Review_UC.md | TPL_UC_Peer_Review_1_0_0.rst | Existe | **RENOMBRAR + RST** |
| T11 | NO EXISTE | TPL_UC_Walkthrough_Stakeholder_1_0_0.rst | Pendiente | **GENERAR** |
| T12 | T12_Matriz_Trazabilidad_RTM.md | TPL_TRZ_Matriz_RTM_1_0_0.rst | Existe | **RENOMBRAR + RST** |

### GRUPO 3: PLANTILLAS PARTE 3

| Plantilla | Nombre Actual | Nombre Correcto | Estado | Acción |
|-----------|---------------|-----------------|--------|--------|
| Plantillas | PLANTILLAS_PARTE3_COMPLETAS.md | TPL_PARTE3_Plantillas_Completas_1_0_0.md | Existe | **RENOMBRAR** |

### GRUPO 4: ANÁLISIS

| Análisis | Nombre Actual | Nombre Correcto | Estado | Acción |
|----------|---------------|-----------------|--------|--------|
| Consolidado v2 | ANALISIS_CONSOLIDADO_COMPLETO_v2_UNIFICADO.md | ANLSS_Consolidado_Completo_IACT_2_0_0.md | Existe | **RENOMBRAR** |
| Partes 1-6 | 6 archivos separados | Mantener separados pero renombrar | Existe | **RENOMBRAR** |

---

## 🔄 FASES DE EJECUCIÓN

### FASE 1: RENOMBRADO DE ARCHIVOS EXISTENTES ⏱️ 30 min

**Objetivo:** Renombrar todos los archivos existentes a nomenclatura correcta

**Script de Renombrado:**

```bash
#!/bin/bash
# FASE 1: Renombrar archivos existentes

cd /mnt/user-data/outputs

# PARTES PEDAGÓGICAS
mv PARTE_2A_FUNDAMENTOS_IACT.md \
   PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md

mv PARTE_2B_CONSTRUCCION_IACT.md \
   PARTE_2B_Construccion_Detallada_IACT_1_0_0.md

mv PARTE_2C_CASOS_ESPECIALES_IACT.md \
   PARTE_2C_Casos_Especiales_Validacion_IACT_1_0_0.md

mv PARTE3B_TECNICA_LARMAN_COMPLETA.md \
   PARTE_3B_Tecnica_Larman_IACT_1_0_0.md

mv PARTE3C_UI_STAKEHOLDERS_COMPLETA.md \
   PARTE_3C_UI_Stakeholders_IACT_1_0_0.md

mv PARTE3D_CONSOLIDACION_RESUMEN_COMPLETA.md \
   PARTE_3D_Consolidacion_Resumen_IACT_1_0_0.md

mv PLANTILLAS_PARTE3_COMPLETAS.md \
   TPL_PARTE3_Plantillas_Completas_1_0_0.md

# ANÁLISIS
mv ANALISIS_CONSOLIDADO_COMPLETO_v2_UNIFICADO.md \
   ANLSS_Consolidado_Completo_IACT_2_0_0.md

mv ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_1.md \
   ANLSS_Consolidado_IACT_2_0_0_PARTE_1.md

mv ANALISIS_CONSOLIDADO_COMPLETO_v2_PARTE_2.md \
   ANLSS_Consolidado_IACT_2_0_0_PARTE_2.md

# ... continuar con PARTE_3 a 6

echo "✅ FASE 1 COMPLETADA: Archivos renombrados"
```

**Validación:**

```bash
# Verificar nomenclatura correcta
ls -1 /mnt/user-data/outputs/PARTE_*.md | while read f; do
  if [[ ! $f =~ _[0-9]+_[0-9]+_[0-9]+\.md$ ]]; then
    echo "❌ INCORRECTO: $f"
  else
    echo "✅ CORRECTO: $f"
  fi
done
```

---

### FASE 2: COPIAR PARTE 0 ⏱️ 5 min

**Objetivo:** Copiar PARTE 0 ya generada con nomenclatura correcta

```bash
# PARTE 0 ya está correcta
cp /tmp/PARTE_0_CONTEXTO_FUNDAMENTOS_IACT_1_0_0.md \
   /mnt/user-data/outputs/

echo "✅ FASE 2 COMPLETADA: PARTE 0 copiada"
```

---

### FASE 3: GENERAR PARTE 1 ⏱️ 3-4 horas

**Objetivo:** Generar PARTE 1 completa con nomenclatura correcta

**Archivo:** `PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md`

**Tamaño estimado:** 15,000 palabras (~60-70 páginas, ~2,500 líneas)

**Estructura:**

```
Sección 1: Introducción (300 líneas)
  - ¿Qué es una BR?
  - ¿Por qué documentar BR?
  - BR vs BReq vs UC vs FR

Sección 2: Taxonomía de BR - 5 Tipos (600 líneas)
  - Tipo 1: Restricciones
  - Tipo 2: Cálculos
  - Tipo 3: Desencadenadores ⭐
  - Tipo 4: Inferencias ⭐
  - Tipo 5: Definiciones

Sección 3: Desencadenadores vs Inferencias ⭐⭐⭐ (800 líneas)
  - Test de observabilidad
  - Timeline comparativo detallado
  - Impacto en UC
  - BR-IACT-031 vs BR-IACT-046 (análisis exhaustivo)
  - 10+ ejemplos adicionales

Sección 4: Técnicas de Elicitación de BR (400 líneas)
  - Entrevistas con stakeholders
  - Análisis de documentos
  - Observación de procesos
  - Workshops
  - Técnicas de cuestionamiento

Sección 5: Documentación de BR (300 líneas)
  - Template estándar
  - Campos obligatorios
  - Nomenclatura BR-IACT-NNN
  - Ejemplos completos

Secciones 6-12: Ejemplos y Ejercicios (600 líneas)
  - 15+ BR del proyecto IACT documentadas
  - 5 ejercicios prácticos con soluciones
  - Casos especiales
  - Errores comunes
```

**Metodología de Generación:**

```
1. Generar en 4 secciones usando heredoc en /tmp
2. Validar cada sección (wc -l, head, tail)
3. Unificar en archivo completo
4. Copiar a /mnt/user-data/outputs/
5. Presentar archivo al usuario
```

---

### FASE 4: RENOMBRAR PARTE 3A ⏱️ 5 min

**Objetivo:** Renombrar PARTE 3A desde /tmp

```bash
cp /tmp/analisis_parte3a_introduccion_crud.md \
   /mnt/user-data/outputs/PARTE_3A_Introduccion_CRUD_IACT_1_0_0.md

echo "✅ FASE 4 COMPLETADA: PARTE 3A renombrada"
```

---

### FASE 5: CONSOLIDAR PARTE 4 ⏱️ 2 horas

**Objetivo:** Consolidar 8 secciones de PARTE 4 en archivo único

**Archivo:** `PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md`

**Contenido:**

```bash
cat > /tmp/PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md << 'ENDOFPART4'
# PARTE 4: REQUISITOS FUNCIONALES
## Del Caso de Uso al Código Implementable

[Consolidar contenido de 8 secciones existentes]
ENDOFPART4
```

---

### FASE 6: CONVERTIR TEMPLATES .md → .rst ⏱️ 3 horas

**Objetivo:** Convertir templates a formato RST con nomenclatura correcta

**Proceso por Template:**

```bash
# Ejemplo: T01

# 1. Leer contenido Markdown
cat /mnt/user-data/outputs/TEMPLATES/T01_Decision_Tipo_BR.md

# 2. Convertir a RST usando pandoc o manual
pandoc -f markdown -t rst \
  /mnt/user-data/outputs/TEMPLATES/T01_Decision_Tipo_BR.md \
  -o /tmp/TPL_BR_Decision_Tipo_1_0_0.rst

# 3. Agregar metadatos RST
cat > /mnt/user-data/outputs/TPL_BR_Decision_Tipo_1_0_0.rst << 'ENDOFTPL'
.. meta::
   :Proyecto: IACT
   :Codigo: TPL-BR-001
   :Titulo: Decision de Tipo de BR
   :Version: 1.0.0
   :Fecha: 2026-01-08

================================
Template: Decisión de Tipo de BR
================================

[Contenido convertido]
ENDOFTPL

# 4. Validar sintaxis RST
python -m docutils /mnt/user-data/outputs/TPL_BR_Decision_Tipo_1_0_0.rst
```

**Templates a Convertir:**

```
T01 → TPL_BR_Decision_Tipo_1_0_0.rst
T02 → TPL_UC_Construccion_7_Pasos_1_0_0.rst
T03 → TPL_UC_Identificacion_Actor_1_0_0.rst
T04 → TPL_FR_Documentacion_10_Componentes_1_0_0.rst
T05 → TPL_UC_Flujos_Alternos_1_0_0.rst
T06 → TPL_UC_Integracion_BR_1_0_0.rst
T09 → TPL_UC_Checklist_Calidad_26_Puntos_1_0_0.rst
T10 → TPL_UC_Peer_Review_1_0_0.rst
T12 → TPL_TRZ_Matriz_RTM_1_0_0.rst
```

---

### FASE 7: GENERAR TEMPLATES FALTANTES ⏱️ 2 horas

**Objetivo:** Generar templates T07, T08, T11

**T07: TPL_UC_Derivacion_FR_1_0_0.rst**

```
Contenido:
  - Proceso de derivación UC → FR
  - 1 paso UC → 1-3 FR
  - Nomenclatura FR
  - Ejemplos IACT
```

**T08: TPL_FR_Casos_Prueba_1_0_0.rst**

```
Contenido:
  - Estructura de casos de prueba
  - Given-When-Then
  - Casos positivos/negativos
  - Datos de prueba
```

**T11: TPL_UC_Walkthrough_Stakeholder_1_0_0.rst**

```
Contenido:
  - Preparación del walkthrough
  - Agenda
  - Checklist de validación
  - Captura de feedback
```

---

### FASE 8: GENERAR PARTES 5 Y 6 ⏱️ 6-8 horas

**PARTE 5: Trazabilidad y Gestión**

**Archivo:** `PARTE_5_Trazabilidad_Gestion_IACT_1_0_0.md`

**Tamaño:** ~1,500 líneas (~6,000 palabras)

**Contenido:**

```
Sección 1: Matrices RTM
  - Estructura RTM
  - Forward tracing
  - Backward tracing
  - Ejemplos IACT

Sección 2: Herramientas de Trazabilidad
  - Scripts Python automatización
  - Dashboards de cobertura
  - Alertas de gaps

Sección 3: Gestión de Cambios
  - Propagación de cambios
  - Versionado semántico
  - Impact analysis

Sección 4: Métricas de Calidad
  - Cobertura BR→UC→FR
  - Completitud
  - Consistencia
```

**PARTE 6: Casos Prácticos Completos**

**Archivo:** `PARTE_6_Casos_Practicos_Completos_IACT_1_0_0.md`

**Tamaño:** ~2,500 líneas (~10,000 palabras)

**Contenido:**

```
Ejercicio 1: Módulo Reportes Completo
  - 5 BR documentadas
  - 3 UC completos (14 secciones c/u)
  - 15 FR derivados
  - Código Python implementable
  - Tests completos

Ejercicio 2: Módulo Alertas Completo
  - 4 BR documentadas
  - 2 UC completos
  - 10 FR derivados
  - Código + Tests

Ejercicio 3: Módulo RBAC Completo
  - 6 BR documentadas
  - 4 UC completos
  - 20 FR derivados
  - Código + Tests
```

---

### FASE 9: GENERAR ÍNDICE MAESTRO ⏱️ 1 hora

**Objetivo:** Crear índice navegable de toda la documentación

**Archivo:** `INDICE_MAESTRO_DOCUMENTACION_IACT_1_0_0.md`

**Contenido:**

```markdown
# ÍNDICE MAESTRO - DOCUMENTACIÓN PROYECTO IACT

## PARTES PEDAGÓGICAS (0-6)

### PARTE 0: Contexto y Fundamentos
- Archivo: PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md
- Tamaño: 2,780 líneas (93KB)
- Duración: 2-3 horas
- Prerequisitos: Ninguno

[Continuar con PARTE 1-6...]

## TEMPLATES (12 archivos RST)

### Templates BR
- TPL_BR_Decision_Tipo_1_0_0.rst

### Templates UC
- TPL_UC_Construccion_7_Pasos_1_0_0.rst
- TPL_UC_Identificacion_Actor_1_0_0.rst
[...]

## ANÁLISIS

### Análisis Consolidado
- ANLSS_Consolidado_Completo_IACT_2_0_0.md

## NAVEGACIÓN RÁPIDA

### Por Tiempo Disponible
- 2-3 horas → PARTE 0
- 8-10 horas → PARTE 1
- 12-15 horas → PARTE 2
[...]

### Por Tema
- Reglas de Negocio → PARTE 0, 1, 2A
- Casos de Uso → PARTE 2B, 2C, 3
- Requisitos Funcionales → PARTE 4
[...]
```

---

### FASE 10: VALIDACIÓN FINAL ⏱️ 2 horas

**Objetivo:** Validar que TODO cumple nomenclatura NOM_001 v2.0.0

**Script de Validación:**

```bash
#!/bin/bash
# Validar nomenclatura de TODA la documentación

validate_file() {
  local file="$1"
  local basename=$(basename "$file")
  
  # Verificar versionado _X_Y_Z
  if [[ ! $basename =~ _[0-9]+_[0-9]+_[0-9]+\.(md|rst)$ ]]; then
    echo "❌ SIN VERSIONADO: $basename"
    return 1
  fi
  
  # Verificar guiones bajos (no guiones)
  if [[ $basename =~ - ]]; then
    echo "❌ USA GUIONES: $basename"
    return 1
  fi
  
  echo "✅ CORRECTO: $basename"
  return 0
}

# Validar todos los archivos
total=0
errors=0

for file in /mnt/user-data/outputs/PARTE_*.md \
            /mnt/user-data/outputs/TPL_*.rst \
            /mnt/user-data/outputs/ANLSS_*.md; do
  total=$((total + 1))
  if ! validate_file "$file"; then
    errors=$((errors + 1))
  fi
done

echo ""
echo "========================================="
echo "VALIDACIÓN FINAL"
echo "========================================="
echo "Total archivos: $total"
echo "Correctos: $((total - errors))"
echo "Errores: $errors"
echo ""

if [ $errors -eq 0 ]; then
  echo "✅ TODOS LOS ARCHIVOS CUMPLEN NOM_001 v2.0.0"
else
  echo "❌ HAY ERRORES DE NOMENCLATURA"
  exit 1
fi
```

---

## 📊 RESUMEN DEL PLAN

### Cronograma de Ejecución

| Fase | Descripción | Tiempo | Archivos |
|------|-------------|--------|----------|
| 1 | Renombrar existentes | 30 min | 15 archivos |
| 2 | Copiar PARTE 0 | 5 min | 1 archivo |
| 3 | **Generar PARTE 1** | 3-4 h | 1 archivo (2,500 líneas) |
| 4 | Renombrar PARTE 3A | 5 min | 1 archivo |
| 5 | Consolidar PARTE 4 | 2 h | 1 archivo |
| 6 | Convertir Templates MD→RST | 3 h | 9 archivos |
| 7 | Generar Templates faltantes | 2 h | 3 archivos |
| 8 | **Generar PARTES 5 y 6** | 6-8 h | 2 archivos (4,000 líneas) |
| 9 | Generar Índice Maestro | 1 h | 1 archivo |
| 10 | Validación Final | 2 h | Script validación |
| **TOTAL** | **20-24 horas** | **35 archivos** |

### Entregables Finales

```
PARTES PEDAGÓGICAS (7 archivos):
  ✅ PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md (2,780 líneas)
  🔄 PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md (2,500 líneas)
  ✅ PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md (3,735 líneas)
  ✅ PARTE_2B_Construccion_Detallada_IACT_1_0_0.md (4,359 líneas)
  ✅ PARTE_2C_Casos_Especiales_Validacion_IACT_1_0_0.md (3,332 líneas)
  ✅ PARTE_3A_Introduccion_CRUD_IACT_1_0_0.md (936 líneas)
  ✅ PARTE_3B_Tecnica_Larman_IACT_1_0_0.md (3,277 líneas)
  ✅ PARTE_3C_UI_Stakeholders_IACT_1_0_0.md (1,801 líneas)
  ✅ PARTE_3D_Consolidacion_Resumen_IACT_1_0_0.md (1,280 líneas)
  🔄 PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md (~2,000 líneas)
  🔄 PARTE_5_Trazabilidad_Gestion_IACT_1_0_0.md (~1,500 líneas)
  🔄 PARTE_6_Casos_Practicos_Completos_IACT_1_0_0.md (~2,500 líneas)

TEMPLATES (12 archivos RST):
  🔄 TPL_BR_Decision_Tipo_1_0_0.rst
  🔄 TPL_UC_Construccion_7_Pasos_1_0_0.rst
  [... 10 templates más]

ANÁLISIS (7 archivos):
  ✅ ANLSS_Consolidado_Completo_IACT_2_0_0.md (4,204 líneas)
  [... 6 partes separadas]

ÍNDICE:
  🔄 INDICE_MAESTRO_DOCUMENTACION_IACT_1_0_0.md

TOTAL: ~35 archivos, ~35,000 líneas, 100% NOM_001 v2.0.0
```

**Leyenda:**
- ✅ Existe, renombrar
- 🔄 Por generar

---

## 🚀 PRÓXIMOS PASOS INMEDIATOS

### Opción A: Ejecutar Plan Completo (20-24h)

```
1. Ejecutar FASE 1 (renombrado) → 30 min
2. Ejecutar FASE 2 (PARTE 0) → 5 min
3. Ejecutar FASE 3 (PARTE 1) → 3-4h
4. Continuar fases 4-10
```

### Opción B: Ejecutar por Prioridad

```
PRIORIDAD 1 (BLOCKER):
  - FASE 1: Renombrar existentes
  - FASE 3: Generar PARTE 1
  
PRIORIDAD 2 (HIGH):
  - FASE 5: Consolidar PARTE 4
  - FASE 8: Generar PARTES 5 y 6
  
PRIORIDAD 3 (MEDIUM):
  - FASE 6: Convertir Templates
  - FASE 7: Generar Templates faltantes
  
PRIORIDAD 4 (LOW):
  - FASE 9: Índice Maestro
  - FASE 10: Validación
```

---

**FIN DEL PLAN MAESTRO**

