# PLAN DE REGENERACIÓN COMPLETA DESDE CERO
## Documentación IACT con NOM_001 v2.0.0

**Fecha:** 2026-01-08  
**Versión:** 1.0.0  
**Objetivo:** Regenerar TODA la documentación con nomenclatura y referencias correctas  
**Estándar:** NOM_001 v2.0.0 + STD_001 v1.1.0

---

## 🎯 PROBLEMA IDENTIFICADO

### No Basta con Renombrar

```
❌ INCORRECTO: Renombrar archivos con bash
  mv PARTE_2A_FUNDAMENTOS_IACT.md PARTE_2A_..._1_0_0.md
  
  Problema:
    Dentro de PARTE_2A hay referencias como:
    - "Ver PARTE_1 sección 3"
    - "Usar template T01"
    - "BR-IACT-028 documentada en BR_028.rst"
    - "import from reports.services"
    
  Todas estas referencias quedarían ROTAS

✅ CORRECTO: Regenerar desde cero
  Generar cada documento con referencias correctas:
    - "Ver PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md sección 3"
    - "Usar TPL_BR_Decision_Tipo_1_0_0.rst"
    - "BR-IACT-028 documentada en BR_IACT_028_Aprobacion_Consultas_1_0_0.rst"
```

### Tipos de Referencias a Corregir

```
1. REFERENCIAS A OTROS DOCUMENTOS PARTE
   "Ver PARTE 2A" → "Ver PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md"

2. REFERENCIAS A TEMPLATES
   "Template T01" → "TPL_BR_Decision_Tipo_1_0_0.rst"

3. REFERENCIAS EN TRAZABILIDAD
   UC-IACT-RPT-01 → UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst

4. REFERENCIAS EN CÓDIGO
   from apps.reports.services → reports_1_0_0/services.py

5. VÍNCULOS MARKDOWN/RST
   [PARTE 1](PARTE_1.md) → [PARTE 1](PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md)

6. EJEMPLOS DE COMANDOS
   view /path/to/UC_RPT_01.rst → view UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst
```

---

## 📚 INVENTARIO COMPLETO CON DEPENDENCIAS

### Tabla Maestra de Documentos

| # | Documento | Nombre Correcto | Depende De | Referencias A |
|---|-----------|-----------------|------------|---------------|
| **GRUPO FUNDACIONAL** |
| 1 | STD_001 | STD_001_Estandares_Documentacion_1_1_0.rst | - | - |
| 2 | NOM_001 | NOM_001_Nomenclatura_Proyecto_2_0_0.rst | STD_001 | Ejemplos de todos |
| **PARTES PEDAGÓGICAS** |
| 3 | PARTE 0 | PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md | NOM_001 | PARTE 1-6, Templates |
| 4 | PARTE 1 | PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md | PARTE 0 | PARTE 2, TPL_BR |
| 5 | PARTE 2A | PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md | PARTE 1 | PARTE 2B, TPL_UC |
| 6 | PARTE 2B | PARTE_2B_Construccion_Detallada_IACT_1_0_0.md | PARTE 2A | PARTE 2C, TPL_UC, TPL_FR |
| 7 | PARTE 2C | PARTE_2C_Casos_Especiales_Validacion_IACT_1_0_0.md | PARTE 2B | PARTE 3, TPL_UC |
| 8 | PARTE 3A | PARTE_3A_Introduccion_CRUD_IACT_1_0_0.md | PARTE 2C | PARTE 3B, TPL_UC |
| 9 | PARTE 3B | PARTE_3B_Tecnica_Larman_IACT_1_0_0.md | PARTE 3A | PARTE 3C, TPL_UC |
| 10 | PARTE 3C | PARTE_3C_UI_Stakeholders_IACT_1_0_0.md | PARTE 3B | PARTE 3D, TPL_UC |
| 11 | PARTE 3D | PARTE_3D_Consolidacion_Resumen_IACT_1_0_0.md | PARTE 3C | PARTE 4 |
| 12 | PARTE 4 | PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md | PARTE 3D | PARTE 5, TPL_FR |
| 13 | PARTE 5 | PARTE_5_Trazabilidad_Gestion_IACT_1_0_0.md | PARTE 4 | PARTE 6, TPL_TRZ |
| 14 | PARTE 6 | PARTE_6_Casos_Practicos_Completos_IACT_1_0_0.md | PARTE 5 | Todos |
| **TEMPLATES** |
| 15 | TPL_BR | TPL_BR_Decision_Tipo_1_0_0.rst | NOM_001 | PARTE 1 |
| 16 | TPL_UC_1 | TPL_UC_Construccion_7_Pasos_1_0_0.rst | NOM_001 | PARTE 2B |
| 17 | TPL_UC_2 | TPL_UC_Identificacion_Actor_1_0_0.rst | NOM_001 | PARTE 2B |
| 18 | TPL_UC_3 | TPL_UC_Flujos_Alternos_1_0_0.rst | NOM_001 | PARTE 2C |
| 19 | TPL_UC_4 | TPL_UC_Integracion_BR_1_0_0.rst | NOM_001 | PARTE 2A |
| 20 | TPL_UC_5 | TPL_UC_Checklist_Calidad_26_Puntos_1_0_0.rst | NOM_001 | PARTE 2C |
| 21 | TPL_UC_6 | TPL_UC_Peer_Review_1_0_0.rst | NOM_001 | PARTE 2C |
| 22 | TPL_UC_7 | TPL_UC_Derivacion_FR_1_0_0.rst | NOM_001 | PARTE 4 |
| 23 | TPL_UC_8 | TPL_UC_Walkthrough_Stakeholder_1_0_0.rst | NOM_001 | PARTE 2C |
| 24 | TPL_FR_1 | TPL_FR_Documentacion_10_Componentes_1_0_0.rst | NOM_001 | PARTE 4 |
| 25 | TPL_FR_2 | TPL_FR_Casos_Prueba_1_0_0.rst | NOM_001 | PARTE 4 |
| 26 | TPL_TRZ | TPL_TRZ_Matriz_RTM_1_0_0.rst | NOM_001 | PARTE 5 |
| **EJEMPLOS BR** |
| 27 | BR_028 | BR_IACT_028_Aprobacion_Consultas_1_0_0.rst | TPL_BR | PARTE 1, 2 |
| 28 | BR_031 | BR_IACT_031_Notificar_Sesion_Expira_1_0_0.rst | TPL_BR | PARTE 1 |
| 29 | BR_046 | BR_IACT_046_Marcar_Sesion_Expirada_1_0_0.rst | TPL_BR | PARTE 1 |
| 30 | BR_087 | BR_IACT_087_Nivel_Seguridad_Criticas_1_0_0.rst | TPL_BR | PARTE 1, 2 |
| **EJEMPLOS UC** |
| 31 | UC_RPT_01 | UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst | TPL_UC | PARTE 0, 2, 4 |
| 32 | UC_AUTH_07 | UC_IACT_AUTH_07_Notificar_Sesion_4_0_0.rst | TPL_UC | PARTE 1, 2 |
| 33 | UC_ACC_01 | UC_IACT_ACC_01_Asignar_Funciones_4_0_0.rst | TPL_UC | PARTE 2, 3 |
| **ÍNDICES** |
| 34 | ÍNDICE | INDICE_MAESTRO_DOCUMENTACION_IACT_1_0_0.md | Todos | Todos |
| 35 | MAPA | MAPA_REFERENCIAS_CRUZADAS_IACT_1_0_0.md | Todos | Todos |

**Total:** 35 documentos con dependencias complejas

---

## 🔄 ESTRATEGIA DE GENERACIÓN

### Principio: Orden Topológico por Dependencias

```
1. Generar documentos SIN dependencias primero (fundacionales)
2. Luego generar los que dependen de los anteriores
3. Validar referencias después de cada documento
4. Usar contenido existente como BASE, pero regenerar con referencias correctas
```

### Metodología de Regeneración

```
Para cada documento:

PASO 1: Analizar contenido existente
  - Leer archivo actual (si existe)
  - Identificar secciones principales
  - Identificar todas las referencias a otros documentos
  
PASO 2: Crear tabla de referencias
  - Listar todas las referencias del documento
  - Mapear nombres antiguos → nombres nuevos
  
PASO 3: Regenerar contenido
  - Mantener estructura y contenido sustantivo
  - Actualizar TODAS las referencias
  - Usar nomenclatura correcta
  
PASO 4: Validar referencias
  - Verificar que archivos referenciados existan o estén planificados
  - Validar sintaxis de vínculos
  - Verificar trazabilidad
```

---

## 📊 FASES DE EJECUCIÓN

### FASE 0: PREPARACIÓN (1 hora)

**Objetivo:** Crear infraestructura y herramientas

**Acciones:**

```bash
# 1. Crear directorio de trabajo
mkdir -p /tmp/iact_regeneracion
cd /tmp/iact_regeneracion

# 2. Crear subdirectorios por tipo
mkdir -p {fundacionales,partes,templates,ejemplos,indices}

# 3. Crear archivo de referencias maestro
cat > referencias_maestro.txt << 'EOF'
# MAPEO DE NOMBRES ANTIGUOS → NUEVOS

# PARTES
PARTE_0 → PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md
PARTE_1 → PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md
PARTE_2A → PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md
...

# TEMPLATES
T01 → TPL_BR_Decision_Tipo_1_0_0.rst
T02 → TPL_UC_Construccion_7_Pasos_1_0_0.rst
...

# BR
BR-IACT-028 → BR_IACT_028_Aprobacion_Consultas_1_0_0.rst
...

# UC
UC-IACT-RPT-01 → UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst
...
EOF

# 4. Script de reemplazo de referencias
cat > actualizar_referencias.sh << 'ENDSCRIPT'
#!/bin/bash
# Actualiza referencias en un documento

archivo="$1"

# Reemplazos de PARTES
sed -i 's/PARTE 0/PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md/g' "$archivo"
sed -i 's/PARTE 1/PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md/g' "$archivo"
# ... continuar con todos

# Reemplazos de TEMPLATES
sed -i 's/Template T01/TPL_BR_Decision_Tipo_1_0_0.rst/g' "$archivo"
# ... continuar

echo "✅ Referencias actualizadas en $archivo"
ENDSCRIPT

chmod +x actualizar_referencias.sh

# 5. Script de validación de referencias
cat > validar_referencias.sh << 'ENDVAL'
#!/bin/bash
# Valida que todas las referencias apunten a archivos correctos

archivo="$1"
errores=0

# Buscar referencias a archivos .md
grep -o '[A-Z_]*_[0-9]_[0-9]_[0-9]\.md' "$archivo" | while read ref; do
  if [ ! -f "$ref" ] && [ ! -f "/tmp/iact_regeneracion/*/$ref" ]; then
    echo "❌ Referencia rota: $ref en $archivo"
    errores=$((errores + 1))
  fi
done

# Buscar referencias a archivos .rst
grep -o '[A-Z_]*_[0-9]_[0-9]_[0-9]\.rst' "$archivo" | while read ref; do
  if [ ! -f "$ref" ] && [ ! -f "/tmp/iact_regeneracion/*/$ref" ]; then
    echo "❌ Referencia rota: $ref en $archivo"
    errores=$((errores + 1))
  fi
done

if [ $errores -eq 0 ]; then
  echo "✅ Todas las referencias válidas en $archivo"
else
  echo "❌ Encontrados $errores errores en $archivo"
  exit 1
fi
ENDVAL

chmod +x validar_referencias.sh
```

**Entregables FASE 0:**
- Estructura de directorios
- Archivo de mapeo de referencias
- Scripts de actualización y validación

---

### FASE 1: FUNDACIONALES (2 horas)

**Documentos a generar:** STD_001, NOM_001

#### 1.1 STD_001_Estandares_Documentacion_1_1_0.rst

**Base:** Contenido existente de STD_001  
**Cambios:** Actualizar ejemplos con nomenclatura nueva

```bash
cat > /tmp/iact_regeneracion/fundacionales/STD_001_Estandares_Documentacion_1_1_0.rst << 'ENDSTD'
.. meta::
   :Proyecto: IACT
   :Codigo: STD-001
   :Titulo: Estándares de Documentación
   :Version: 1.1.0
   :Fecha: 2026-01-08
   :Estado: VIGENTE

================================================
STD-001: Estándares de Documentación Proyecto
================================================

:ID: STD-001
:Versión: 1.1.0
:Fecha: 2026-01-08
:Estado: VIGENTE

Introducción
============

Este documento establece los estándares de documentación para el proyecto IACT.

Regla 1: Sin Emojis
====================

Prohibido
---------

No usar emojis Unicode en documentación técnica:

- ✅ ❌ ⚠️ (checkmarks)
- 🚀 📁 💾 (iconos)
- Cualquier emoji

Alternativas Permitidas
------------------------

Usar prefijos textuales:

- [OK] [ERROR] [WARN]
- [INFO] [SUCCESS] [PENDING]

Ejemplos Correctos
------------------

.. code-block:: rst

   [OK] PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md generado
   [ERROR] Falta TPL_UC_Construccion_7_Pasos_1_0_0.rst
   [WARN] Referencias a PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md

Regla 2: Formato RST Estricto
==============================

Todos los documentos técnicos deben usar reStructuredText (.rst).

Material pedagógico puede usar Markdown (.md).

Regla 3: Nomenclatura
======================

Ver: NOM_001_Nomenclatura_Proyecto_2_0_0.rst

Todos los archivos deben seguir:

::

   [PREFIJO]_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].ext

Ejemplos:

- PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md
- TPL_UC_Construccion_7_Pasos_1_0_0.rst
- UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst

Validación
==========

Script de validación:

.. code-block:: bash

   grep -E '(✅|❌|⚠️|🚀|📁|💾)' *.rst && echo "ERROR: Emojis encontrados"

Historial
=========

- 1.1.0 (2026-01-08): Actualización nomenclatura con ejemplos correctos
- 1.0.0 (2025-12-15): Versión inicial

ENDSTD

echo "✅ STD_001 generado"
```

#### 1.2 NOM_001_Nomenclatura_Proyecto_2_0_0.rst

**Base:** Contenido existente de NOM_001 v2.0.0  
**Cambios:** Agregar tabla completa de 35 documentos con nomenclatura correcta

```bash
cat > /tmp/iact_regeneracion/fundacionales/NOM_001_Nomenclatura_Proyecto_2_0_0.rst << 'ENDNOM'
.. meta::
   :Proyecto: IACT
   :Codigo: NOM-001
   :Titulo: Nomenclatura del Proyecto
   :Version: 2.0.0
   :Fecha: 2026-01-08
   :Estado: VIGENTE

=============================================
NOM-001: Nomenclatura del Proyecto IACT
=============================================

Formato General
===============

::

   [PREFIJO]_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].ext

Donde:

- PREFIJO: Tipo de documento (ver tabla)
- Nombre_Descriptivo: CamelCase con guiones bajos
- MAJOR_MINOR_PATCH: Versionado semántico OBLIGATORIO
- ext: .md (pedagógico) o .rst (técnico)

Tabla de Prefijos
=================

.. list-table::
   :header-rows: 1
   :widths: 15 25 60

   * - Prefijo
     - Descripción
     - Ejemplo
   * - PARTE
     - Material pedagógico
     - PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md
   * - TPL
     - Templates
     - TPL_UC_Construccion_7_Pasos_1_0_0.rst
   * - BR
     - Business Rules
     - BR_IACT_028_Aprobacion_Consultas_1_0_0.rst
   * - UC
     - Use Cases
     - UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst
   * - FR
     - Functional Requirements
     - FR_RPT_01_07_Calcular_Count_1_0_0.rst
   * - CNST
     - Constraints
     - CNST_005_Seguridad_DRF_1_1_0.rst
   * - BRQ
     - Business Requirements
     - BRQ_RPT_001_Prevenir_Sobrecarga_1_0_0.rst
   * - AGR
     - Agrupadores RBAC
     - AGR_003_Supervisor_1_0_0.rst
   * - STD
     - Estándares
     - STD_001_Estandares_Documentacion_1_1_0.rst
   * - NOM
     - Nomenclaturas
     - NOM_001_Nomenclatura_Proyecto_2_0_0.rst
   * - ANLSS
     - Análisis
     - ANLSS_Consolidado_Completo_IACT_2_0_0.md
   * - PLN
     - Planes
     - PLN_Actualizacion_Access_1_0_0.md
   * - INDICE
     - Índices
     - INDICE_MAESTRO_DOCUMENTACION_IACT_1_0_0.md

Catálogo Completo de Documentos
================================

Material Pedagógico (PARTES 0-6)
---------------------------------

.. list-table::
   :header-rows: 1

   * - Doc
     - Nombre Correcto
     - Líneas
   * - PARTE 0
     - PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md
     - 2,780
   * - PARTE 1
     - PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md
     - ~2,500
   * - PARTE 2A
     - PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md
     - 3,735
   * - PARTE 2B
     - PARTE_2B_Construccion_Detallada_IACT_1_0_0.md
     - 4,359
   * - PARTE 2C
     - PARTE_2C_Casos_Especiales_Validacion_IACT_1_0_0.md
     - 3,332
   * - PARTE 3A
     - PARTE_3A_Introduccion_CRUD_IACT_1_0_0.md
     - 936
   * - PARTE 3B
     - PARTE_3B_Tecnica_Larman_IACT_1_0_0.md
     - 3,277
   * - PARTE 3C
     - PARTE_3C_UI_Stakeholders_IACT_1_0_0.md
     - 1,801
   * - PARTE 3D
     - PARTE_3D_Consolidacion_Resumen_IACT_1_0_0.md
     - 1,280
   * - PARTE 4
     - PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md
     - ~2,000
   * - PARTE 5
     - PARTE_5_Trazabilidad_Gestion_IACT_1_0_0.md
     - ~1,500
   * - PARTE 6
     - PARTE_6_Casos_Practicos_Completos_IACT_1_0_0.md
     - ~2,500

Templates (12 archivos)
-----------------------

.. list-table::
   :header-rows: 1

   * - Template
     - Nombre Correcto
   * - BR
     - TPL_BR_Decision_Tipo_1_0_0.rst
   * - UC-1
     - TPL_UC_Construccion_7_Pasos_1_0_0.rst
   * - UC-2
     - TPL_UC_Identificacion_Actor_1_0_0.rst
   * - UC-3
     - TPL_UC_Flujos_Alternos_1_0_0.rst
   * - UC-4
     - TPL_UC_Integracion_BR_1_0_0.rst
   * - UC-5
     - TPL_UC_Checklist_Calidad_26_Puntos_1_0_0.rst
   * - UC-6
     - TPL_UC_Peer_Review_1_0_0.rst
   * - UC-7
     - TPL_UC_Derivacion_FR_1_0_0.rst
   * - UC-8
     - TPL_UC_Walkthrough_Stakeholder_1_0_0.rst
   * - FR-1
     - TPL_FR_Documentacion_10_Componentes_1_0_0.rst
   * - FR-2
     - TPL_FR_Casos_Prueba_1_0_0.rst
   * - TRZ
     - TPL_TRZ_Matriz_RTM_1_0_0.rst

Cambios v1.0 → v2.0
====================

.. list-table::
   :header-rows: 1

   * - Aspecto
     - v1.0
     - v2.0
   * - Dígitos secuenciales
     - 2 (01-99)
     - 3 (001-999)
   * - Versionado
     - Opcional
     - OBLIGATORIO
   * - Formato versión
     - No especificado
     - _MAJOR_MINOR_PATCH
   * - Prefijos
     - 17
     - 27
   * - Separadores
     - Guiones o guiones bajos
     - Solo guiones bajos

ENDNOM

echo "✅ NOM_001 generado"
```

**Validación FASE 1:**

```bash
cd /tmp/iact_regeneracion/fundacionales
./validar_referencias.sh STD_001_Estandares_Documentacion_1_1_0.rst
./validar_referencias.sh NOM_001_Nomenclatura_Proyecto_2_0_0.rst
```

---

### FASE 2-14: GENERACIÓN DE DOCUMENTOS (15-20 horas)

**Nota:** Cada fase sigue el mismo patrón:

```
1. Leer contenido existente
2. Crear tabla de referencias a actualizar
3. Regenerar con heredoc en /tmp
4. Actualizar referencias con script
5. Validar referencias
6. Copiar a destino
```

Por brevedad, muestro el plan detallado solo para PARTE 1. Las demás siguen el mismo patrón.

---

### FASE 2: PARTE_1 (4 horas) - EJEMPLO DETALLADO

**Archivo:** `PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md`

#### Paso 1: Analizar Contenido Existente

```bash
# Contenido NO existe, se genera desde cero basándose en:
# - Estructura definida en PARTE_0
# - Templates de la sección de análisis
```

#### Paso 2: Tabla de Referencias

```
Referencias que PARTE_1 debe incluir:

A otros documentos PARTE:
  - "Ver PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md sección 2"
  - "Continuar con PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md"

A Templates:
  - "Usar TPL_BR_Decision_Tipo_1_0_0.rst"

A Ejemplos BR:
  - "BR_IACT_028_Aprobacion_Consultas_1_0_0.rst"
  - "BR_IACT_031_Notificar_Sesion_Expira_1_0_0.rst"
  - "BR_IACT_046_Marcar_Sesion_Expirada_1_0_0.rst"
  - "BR_IACT_087_Nivel_Seguridad_Criticas_1_0_0.rst"

A Normativas:
  - "STD_001_Estandares_Documentacion_1_1_0.rst"
  - "NOM_001_Nomenclatura_Proyecto_2_0_0.rst"
```

#### Paso 3: Generar Contenido (usando heredoc en 4 secciones)

```bash
# SECCIÓN 1
cat > /tmp/iact_regeneracion/partes/PARTE_1_SECCION_1.md << 'ENDSEC1'
# PARTE 1: IDENTIFICAR REGLAS DE NEGOCIO
## La Base de Todo el Sistema de Requisitos

**Proyecto:** IACT - IVR Analytics & Customer Tracking  
**Documento:** Material Pedagógico - Identificación de BR  
**Versión:** 1.0.0  
**Fecha:** 2026-01-08  
**Prerequisito:** PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md  
**Siguiente:** PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md

---

## ÍNDICE

1. [Introducción](#1-introduccion)
2. [Taxonomía de BR](#2-taxonomia-br)
3. [Desencadenadores vs Inferencias](#3-desencadenadores-inferencias)
4. [Técnicas de Elicitación](#4-tecnicas-elicitacion)
...

---

## 1. INTRODUCCIÓN

### 1.1 Prerequisitos

Antes de comenzar con PARTE 1, debes haber leído:

- **PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md** (completo)
  - Especialmente sección 3: "Transformaciones Clave"
  - Concepto de jerarquía BR → BReq → UC → FR

### 1.2 Objetivos de Aprendizaje

Al completar PARTE 1, serás capaz de:

1. Identificar los 5 tipos de reglas de negocio
2. Distinguir Desencadenadores de Inferencias ⭐
3. Documentar BR usando TPL_BR_Decision_Tipo_1_0_0.rst
4. Aplicar técnicas de elicitación
5. Validar BR con stakeholders

...

ENDSEC1

# SECCIÓN 2
cat > /tmp/iact_regeneracion/partes/PARTE_1_SECCION_2.md << 'ENDSEC2'

## 2. TAXONOMÍA DE BR: LOS 5 TIPOS

### 2.1 Visión General

Como viste en PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md sección 3.2,
existen 5 tipos de reglas de negocio:

1. **Restricciones** (Constraints)
2. **Cálculos** (Calculations)
3. **Desencadenadores** (Triggers) ⭐
4. **Inferencias** (Inferences) ⭐
5. **Definiciones** (Definitions)

...

### 2.2 Tipo 1: Restricciones

**Definición:** Políticas que LIMITAN el comportamiento del sistema.

**Ejemplo Real - BR_IACT_028_Aprobacion_Consultas_1_0_0.rst:**

```yaml
ID: BR-IACT-028
Nombre: Aprobación de Consultas Grandes
Tipo: Restricción
...
```

Para documentar restricciones, usa:
- Template: TPL_BR_Decision_Tipo_1_0_0.rst
- Sección: "Restricciones"

...

ENDSEC2

# SECCIÓN 3 (La MÁS IMPORTANTE)
cat > /tmp/iact_regeneracion/partes/PARTE_1_SECCION_3.md << 'ENDSEC3'

## 3. DESENCADENADORES VS INFERENCIAS ⭐⭐⭐

### 3.1 Por Qué Es Importante

Esta es la distinción MÁS CRÍTICA en PARTE 1.

Como se explicó en PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md sección 3.3,
confundir Desencadenadores con Inferencias causa:

- UC incorrectos (flujos que no deberían existir)
- FR innecesarios (código que no se necesita)
- Tests erróneos (validando comportamiento incorrecto)

### 3.2 El Test de Observabilidad

**Pregunta clave:** ¿El usuario VE o RECIBE algo como resultado directo de esta BR?

```
SI → Desencadenador
  Ejemplos: Ver BR_IACT_031_Notificar_Sesion_Expira_1_0_0.rst
  
NO → Inferencia
  Ejemplos: Ver BR_IACT_046_Marcar_Sesion_Expirada_1_0_0.rst
```

### 3.3 Análisis Comparativo Detallado

Vamos a analizar EN PROFUNDIDAD dos BR similares del proyecto IACT:

#### BR_IACT_031: Notificar Sesión por Expirar (DESENCADENADOR)

**Archivo:** BR_IACT_031_Notificar_Sesion_Expira_1_0_0.rst

```yaml
ID: BR-IACT-031
Tipo: Desencadenador
Enunciado:
  "El sistema debe notificar al usuario cuando su sesión haya estado
   inactiva durante 12 minutos, advirtiéndole que expirará en 3 minutos."

Observable: ✅ SÍ
  Usuario RECIBE notificación en buzón interno
  Notificación dice: "Su sesión expirará en 3 minutos por inactividad"

Acción del Usuario:
  Puede hacer click en cualquier parte → Resetea inactividad
  Puede ignorar → Sesión expira a los 15 minutos
```

**Timeline Observable:**

```
T+0:   Usuario autenticado
T+12min: 🔔 DESENCADENADOR - Sistema envía notificación
         ↓
         Usuario VE mensaje en buzón
         ↓
         Usuario puede ACTUAR (click o ignorar)
```

**Transformación a UC:**

Esta BR GENERA un UC completo:
- **UC_IACT_AUTH_07_Notificar_Sesion_4_0_0.rst**
- 11 pasos
- Actor: Sistema (scheduler) + Usuario (receptor)
- Flujo alterno si usuario actúa

#### BR_IACT_046: Marcar Sesión Expirada (INFERENCIA)

**Archivo:** BR_IACT_046_Marcar_Sesion_Expirada_1_0_0.rst

```yaml
ID: BR-IACT-046
Tipo: Inferencia
Enunciado:
  "Una sesión se considera EXPIRADA si han transcurrido más de
   15 minutos desde la última actividad registrada."

Observable: ❌ NO
  Solo campo en BD cambia: session.estado = 'EXPIRED'
  Usuario NO ve nada en este momento

Acción del Usuario:
  Ninguna. Usuario NO se entera hasta próximo request.
```

**Timeline NO Observable:**

```
T+0:   Usuario autenticado
T+15min: 🔇 INFERENCIA - Sistema UPDATE session.estado = 'EXPIRED'
         ↓
         Campo BD cambia (silencioso)
         ↓
         Usuario NO ve nada, NO puede actuar
         
T+17min: Usuario intenta hacer request
         ↓
         Sistema rechaza: "Sesión expirada"
         ↓
         AHORA SÍ es observable (el rechazo, no el cambio)
```

**Transformación a FR:**

Esta BR NO genera UC completo, solo FR directo:
- **FR_AUTH_08_02_Marcar_Sesiones_Expiradas_1_0_0.rst**
- Query SQL UPDATE automático
- Background job cada 1 minuto

### 3.4 Tabla Comparativa

| Aspecto | Desencadenador (BR-IACT-031) | Inferencia (BR-IACT-046) |
|---------|------------------------------|--------------------------|
| Observable | ✅ Usuario RECIBE notificación | ❌ Solo BD cambia |
| Actor | Sistema + Usuario | Solo Sistema |
| Genera UC | ✅ UC completo (11 pasos) | ❌ Solo FR |
| Usuario puede actuar | ✅ Hacer click, ignorar | ❌ No se entera |
| Implementación | UC_IACT_AUTH_07 + FR | Solo FR_AUTH_08_02 |
| Tests | test_notification_sent() | test_session_marked() |

### 3.5 Más Ejemplos del Proyecto IACT

#### Ejemplo 3: BR-IACT-104 (Desencadenador)

```yaml
BR-IACT-104: Alerta de Llamadas Abandonadas
Tipo: Desencadenador
Enunciado:
  "El sistema debe alertar al supervisor cuando el porcentaje de
   llamadas abandonadas supere el 20% en una ventana de 1 hora."

Observable: ✅ SÍ
  Supervisor RECIBE alerta en dashboard
  Alerta dice: "23% llamadas abandonadas en última hora (umbral: 20%)"
  
→ Genera UC_IACT_ALR_01_Alertar_Abandonos_4_0_0.rst
```

#### Ejemplo 4: BR-IACT-091 (Inferencia)

```yaml
BR-IACT-091: Clasificación de Horario
Tipo: Inferencia
Enunciado:
  "Una llamada se clasifica como PEAK si ocurre entre 09:00-12:00
   o 14:00-18:00 de lunes a viernes. De lo contrario es OFF-PEAK."

Observable: ❌ NO
  Solo campo: call.peak_classification se calcula
  Nadie VE este cálculo suceder
  
→ No genera UC, solo FR_PIPE_03_05_Clasificar_Horario_1_0_0.rst
```

### 3.6 Ejercicio Práctico

Clasifica las siguientes BR como Desencadenador o Inferencia:

**BR-X:** "El sistema debe enviar email al cliente cuando su llamada
          sea transferida a un agente supervisor."
          
**BR-Y:** "Un cliente se considera VIP si ha realizado más de 50
          llamadas en los últimos 3 meses."

**Respuestas:**

BR-X: DESENCADENADOR
  - Cliente RECIBE email → Observable
  - Genera UC completo de envío de email

BR-Y: INFERENCIA
  - Solo campo customer.is_vip se calcula
  - Cliente NO recibe notificación de que es VIP
  - Solo FR de cálculo

...

ENDSEC3

# Continuar con SECCIÓN 4 (Técnicas de Elicitación)
# y SECCIONES 5-12 (Ejemplos y Ejercicios)
```

#### Paso 4: Unificar Secciones

```bash
cat /tmp/iact_regeneracion/partes/PARTE_1_SECCION_*.md \
    > /tmp/iact_regeneracion/partes/PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md

wc -l /tmp/iact_regeneracion/partes/PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md
```

#### Paso 5: Actualizar Referencias

```bash
cd /tmp/iact_regeneracion/partes
../actualizar_referencias.sh PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md
```

#### Paso 6: Validar Referencias

```bash
../validar_referencias.sh PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md
```

#### Paso 7: Copiar a Destino

```bash
cp PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md /mnt/user-data/outputs/
```

---

### FASES 3-14: Aplicar Mismo Patrón

**FASE 3:** PARTE_2A (reutilizar contenido, actualizar referencias)  
**FASE 4:** PARTE_2B (reutilizar contenido, actualizar referencias)  
**FASE 5:** PARTE_2C (reutilizar contenido, actualizar referencias)  
...  
**FASE 14:** ÍNDICE_MAESTRO (generar desde cero con tabla completa)

---

## 📈 CRONOGRAMA REALISTA

| Fase | Documento | Método | Tiempo |
|------|-----------|--------|--------|
| 0 | Preparación | Scripts | 1h |
| 1 | STD_001, NOM_001 | Regenerar | 2h |
| 2 | PARTE_1 | Generar nuevo | 4h |
| 3 | PARTE_2A | Actualizar refs | 2h |
| 4 | PARTE_2B | Actualizar refs | 2h |
| 5 | PARTE_2C | Actualizar refs | 2h |
| 6 | PARTE_3A | Actualizar refs | 1h |
| 7 | PARTE_3B | Actualizar refs | 2h |
| 8 | PARTE_3C | Actualizar refs | 1h |
| 9 | PARTE_3D | Actualizar refs | 1h |
| 10 | PARTE_4 | Consolidar + refs | 3h |
| 11 | PARTE_5 | Generar nuevo | 4h |
| 12 | PARTE_6 | Generar nuevo | 5h |
| 13 | 12 Templates | Generar/convertir | 6h |
| 14 | Índices + Validación | Generar + scripts | 3h |
| **TOTAL** | **35 documentos** | **39 horas** |

---

## 🎯 ENTREGABLES FINALES

```
/mnt/user-data/outputs/
├── fundacionales/
│   ├── STD_001_Estandares_Documentacion_1_1_0.rst
│   └── NOM_001_Nomenclatura_Proyecto_2_0_0.rst
├── partes/
│   ├── PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md
│   ├── PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md
│   ├── PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md
│   ├── PARTE_2B_Construccion_Detallada_IACT_1_0_0.md
│   ├── PARTE_2C_Casos_Especiales_Validacion_IACT_1_0_0.md
│   ├── PARTE_3A_Introduccion_CRUD_IACT_1_0_0.md
│   ├── PARTE_3B_Tecnica_Larman_IACT_1_0_0.md
│   ├── PARTE_3C_UI_Stakeholders_IACT_1_0_0.md
│   ├── PARTE_3D_Consolidacion_Resumen_IACT_1_0_0.md
│   ├── PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md
│   ├── PARTE_5_Trazabilidad_Gestion_IACT_1_0_0.md
│   └── PARTE_6_Casos_Practicos_Completos_IACT_1_0_0.md
├── templates/
│   ├── TPL_BR_Decision_Tipo_1_0_0.rst
│   ├── TPL_UC_Construccion_7_Pasos_1_0_0.rst
│   ├── [... 10 templates más]
│   └── TPL_TRZ_Matriz_RTM_1_0_0.rst
├── ejemplos/
│   ├── BR_IACT_028_Aprobacion_Consultas_1_0_0.rst
│   ├── BR_IACT_031_Notificar_Sesion_Expira_1_0_0.rst
│   ├── BR_IACT_046_Marcar_Sesion_Expirada_1_0_0.rst
│   ├── BR_IACT_087_Nivel_Seguridad_Criticas_1_0_0.rst
│   ├── UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst
│   ├── UC_IACT_AUTH_07_Notificar_Sesion_4_0_0.rst
│   └── UC_IACT_ACC_01_Asignar_Funciones_4_0_0.rst
└── indices/
    ├── INDICE_MAESTRO_DOCUMENTACION_IACT_1_0_0.md
    └── MAPA_REFERENCIAS_CRUZADAS_IACT_1_0_0.md

TOTAL: 35 archivos, 100% NOM_001 v2.0.0, referencias correctas
```

---

## ✅ CRITERIOS DE ÉXITO

1. **Nomenclatura:** 100% archivos con _X_Y_Z
2. **Referencias:** 0 referencias rotas
3. **Vínculos:** Todos los links funcionan
4. **Trazabilidad:** BR→UC→FR completa
5. **Sin emojis:** 0 emojis en documentación
6. **Validación:** Scripts pasan sin errores

---

**FIN DEL PLAN DE REGENERACIÓN COMPLETA**

