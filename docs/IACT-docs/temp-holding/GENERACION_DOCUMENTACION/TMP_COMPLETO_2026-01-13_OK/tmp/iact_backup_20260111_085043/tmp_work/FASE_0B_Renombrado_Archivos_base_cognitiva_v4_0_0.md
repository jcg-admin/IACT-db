# FASE 0B [CRÍTICA]: Renombrado Masivo de Archivos base_cognitiva/

**Fecha:** 2026-01-08  
**Prioridad:** CRÍTICA - BLOQUEA FASE 3-5  
**Estado:** [PENDING] DESCUBIERTO  
**Impacto:** ALTO

---

## PROBLEMA IDENTIFICADO

El PLAN_MAESTRO original NO contempló que **NINGÚN archivo en base_cognitiva/** sigue la nomenclatura `_[MAJOR]_[MINOR]_[PATCH].rst` definida en NOM_01.

**Situación actual:**
```
[ACTUAL - INCORRECTO]
FND_01_Concepto_Requisito.rst
MTM_01_Metamodelo_Requisitos.rst
TXM_01_Taxonomia_Requisitos.rst
META_01_Identidad_Proyecto.rst
SBVR_01_Conceptos_Nucleares.rst
```

**Debería ser (según NOM_01):**
```
[ESPERADO - CORRECTO]
FND_01_Concepto_Requisito_1_0_0.rst
MTM_01_Metamodelo_Requisitos_1_0_0.rst
TXM_01_Taxonomia_Requisitos_1_0_0.rst
META_01_Identidad_Proyecto_1_0_0.rst
SBVR_01_Conceptos_Nucleares_1_0_0.rst
```

---

## ALCANCE DE CAMBIOS

### Archivos a Renombrar (~23 archivos)

**_fundamentos_conceptuales/ (7 archivos):**
- FND_01_Concepto_Requisito.rst → FND_01_Concepto_Requisito_1_0_0.rst
- FND_02_[nombre].rst → FND_02_[nombre]_1_0_0.rst
- FND_03_Casos_de_Uso.rst → FND_03_Casos_de_Uso_1_0_0.rst
- FND_04_Plantillas.rst → FND_04_Plantillas_1_0_0.rst
- FND_05_[nombre].rst → FND_05_[nombre]_1_0_0.rst
- FND_06_[nombre].rst → FND_06_[nombre]_1_0_0.rst
- FND_07_[nombre].rst → FND_07_[nombre]_1_0_0.rst

**_metadata/ (5 archivos):**
- META_01_Identidad_Proyecto.rst → META_01_Identidad_Proyecto_1_0_0.rst
- META_02_Clasificacion_Documental.rst → META_02_Clasificacion_Documental_1_0_0.rst
- META_03_Fases_SDLC.rst → META_03_Fases_SDLC_1_0_0.rst
- META_04_Contexto_IACT.rst → META_04_Contexto_IACT_1_0_0.rst
- META_05_Estructura_Documental.rst → META_05_Estructura_Documental_1_0_0.rst

**_ontologia_sbvr/ (5 archivos):**
- SBVR_01_Conceptos_Nucleares.rst → SBVR_01_Conceptos_Nucleares_1_0_0.rst
- SBVR_02_Fact_Types.rst → SBVR_02_Fact_Types_1_0_0.rst
- SBVR_03_Reglas_Estructurales.rst → SBVR_03_Reglas_Estructurales_1_0_0.rst
- SBVR_04_Reglas_Operativas.rst → SBVR_04_Reglas_Operativas_1_0_0.rst
- SBVR_05_Vocabulario_Controlado.rst → SBVR_05_Vocabulario_Controlado_1_0_0.rst

**_taxonomias_y_metamodelos/metamodelos/ (3 archivos):**
- MTM_01_Metamodelo_Requisitos.rst → MTM_01_Metamodelo_Requisitos_1_0_0.rst
- MTM_02_Metamodelo_Trazabilidad.rst → MTM_02_Metamodelo_Trazabilidad_1_0_0.rst
- MTM_03_Metamodelo_RBAC.rst → MTM_03_Metamodelo_RBAC_1_0_0.rst

**_taxonomias_y_metamodelos/taxonomias/ (3 archivos):**
- TXM_01_Taxonomia_Requisitos.rst → TXM_01_Taxonomia_Requisitos_1_0_0.rst
- TXM_02_[nombre].rst → TXM_02_[nombre]_1_0_0.rst
- TXM_03_Taxonomia_Reglas_Negocio.rst → TXM_03_Taxonomia_Reglas_Negocio_1_0_0.rst

**TOTAL:** ~23 archivos en base_cognitiva/

---

## IMPACTO EN REFERENCIAS

### 1. Archivos index.rst a Actualizar (~5 archivos)

Cada subdirectorio tiene un index.rst con toctree que apunta a estos archivos:

```rst
[ACTUAL - ROTO DESPUÉS DE RENOMBRADO]
.. toctree::
   :maxdepth: 1
   
   FND_01_Concepto_Requisito
   FND_03_Casos_de_Uso
   FND_04_Plantillas
```

```rst
[DEBE SER]
.. toctree::
   :maxdepth: 1
   
   FND_01_Concepto_Requisito_1_0_0
   FND_03_Casos_de_Uso_1_0_0
   FND_04_Plantillas_1_0_0
```

**Archivos index.rst afectados:**
- base_cognitiva/_fundamentos_conceptuales/index.rst
- base_cognitiva/_metadata/index.rst
- base_cognitiva/_ontologia_sbvr/index.rst
- base_cognitiva/_taxonomias_y_metamodelos/metamodelos/index.rst
- base_cognitiva/_taxonomias_y_metamodelos/taxonomias/index.rst

### 2. Referencias :doc: y :ref: (~50-100 referencias)

Todos los archivos que referencian estos documentos con :doc: quedarán ROTOS:

```rst
[ACTUAL - FUNCIONABA]
Consultar :doc:`FND_01_Concepto_Requisito` para más información.
Ver también :doc:`/base_cognitiva/_taxonomias_y_metamodelos/metamodelos/MTM_01_Metamodelo_Requisitos`
```

```rst
[DEBE SER]
Consultar :doc:`FND_01_Concepto_Requisito_1_0_0` para más información.
Ver también :doc:`/base_cognitiva/_taxonomias_y_metamodelos/metamodelos/MTM_01_Metamodelo_Requisitos_1_0_0`
```

**Archivos con referencias :doc: potenciales:**
- TODOS los archivos en base_cognitiva/ que se referencian entre sí (~50-70 referencias)
- Archivos en requisitos/ que referencian base_cognitiva/ (~10-20 referencias)
- Archivos en arquitectura/ si existen (~5-10 referencias)

---

## METODOLOGÍA DE IMPLEMENTACIÓN

### Paso 1: Renombrado de Archivos

```bash
# Script de renombrado masivo
cd source/base_cognitiva

# _fundamentos_conceptuales/
cd _fundamentos_conceptuales/
for file in FND_*.rst; do
  base="${file%.rst}"
  mv "$file" "${base}_1_0_0.rst"
done
cd ..

# _metadata/
cd _metadata/
for file in META_*.rst; do
  base="${file%.rst}"
  mv "$file" "${base}_1_0_0.rst"
done
cd ..

# _ontologia_sbvr/
cd _ontologia_sbvr/
for file in SBVR_*.rst; do
  base="${file%.rst}"
  mv "$file" "${base}_1_0_0.rst"
done
cd ..

# metamodelos/
cd _taxonomias_y_metamodelos/metamodelos/
for file in MTM_*.rst; do
  base="${file%.rst}"
  mv "$file" "${base}_1_0_0.rst"
done
cd ../..

# taxonomias/
cd _taxonomias_y_metamodelos/taxonomias/
for file in TXM_*.rst; do
  base="${file%.rst}"
  mv "$file" "${base}_1_0_0.rst"
done
cd ../../..
```

### Paso 2: Actualizar Toctrees en index.rst

Para CADA archivo index.rst en subdirectorios:

```bash
# Actualizar referencias en toctree
sed -i 's/FND_\([0-9]\{2\}\)_\([^[:space:]]*\)$/FND_\1_\2_1_0_0/g' _fundamentos_conceptuales/index.rst
sed -i 's/META_\([0-9]\{2\}\)_\([^[:space:]]*\)$/META_\1_\2_1_0_0/g' _metadata/index.rst
sed -i 's/SBVR_\([0-9]\{2\}\)_\([^[:space:]]*\)$/SBVR_\1_\2_1_0_0/g' _ontologia_sbvr/index.rst
sed -i 's/MTM_\([0-9]\{2\}\)_\([^[:space:]]*\)$/MTM_\1_\2_1_0_0/g' _taxonomias_y_metamodelos/metamodelos/index.rst
sed -i 's/TXM_\([0-9]\{2\}\)_\([^[:space:]]*\)$/TXM_\1_\2_1_0_0/g' _taxonomias_y_metamodelos/taxonomias/index.rst
```

### Paso 3: Buscar y Actualizar Referencias :doc:

```bash
# Buscar TODAS las referencias :doc: a archivos renombrados
grep -r ":doc:\`.*FND_[0-9]" source/ --include="*.rst"
grep -r ":doc:\`.*META_[0-9]" source/ --include="*.rst"
grep -r ":doc:\`.*SBVR_[0-9]" source/ --include="*.rst"
grep -r ":doc:\`.*MTM_[0-9]" source/ --include="*.rst"
grep -r ":doc:\`.*TXM_[0-9]" source/ --include="*.rst"

# Actualizar referencias (ejemplo FND)
find source/ -name "*.rst" -exec sed -i 's/:doc:`\(FND_[0-9]\{2\}_[^`]*\)`/:doc:`\1_1_0_0`/g' {} +
find source/ -name "*.rst" -exec sed -i 's/:doc:`\(\/.*FND_[0-9]\{2\}_[^`]*\)`/:doc:`\1_1_0_0`/g' {} +

# Repetir para META, SBVR, MTM, TXM
```

### Paso 4: Validación Build

```bash
# Build y verificar warnings
make clean
make html 2>&1 | tee build.log
grep -i "warning\|error" build.log

# Verificar links rotos
make linkcheck 2>&1 | tee linkcheck.log
grep -i "broken" linkcheck.log
```

---

## ESTIMACIÓN DE TIEMPO

| Tarea | Tiempo | Complejidad |
|-------|--------|-------------|
| Renombrado de archivos (~23) | 30 min | Baja (script) |
| Actualizar toctrees (5 index.rst) | 30 min | Baja |
| Buscar referencias :doc: | 1h | Media |
| Actualizar referencias :doc: (~50-100) | 2-3h | Alta (manual o regex) |
| Validación build completo | 30 min | Media |
| Testing navegación HTML | 30 min | Media |
| Corrección de errores | 1h | Media |
| **TOTAL** | **6-7h** | **ALTA** |

---

## RIESGOS

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| **Referencias :doc: rotas** | Alta | Crítico | Búsqueda exhaustiva con grep |
| **Toctree sin actualizar** | Media | Alto | Validación build por fase |
| **Confusión durante migración** | Alta | Medio | Implementar en rama separada |
| **Archivos en Git mal rastreados** | Baja | Alto | Usar `git mv` en lugar de `mv` |
| **Navegación rota en HTML** | Media | Crítico | Testing manual completo |

---

## PLAN DE ROLLBACK

Si algo falla durante FASE 0B:

```bash
# Rollback completo
git checkout -- source/base_cognitiva/
git clean -fd source/base_cognitiva/
```

---

## INTEGRACIÓN CON PLAN MAESTRO

### Nueva Secuencia de Fases

| Fase | Original | Nueva (con 0B) |
|------|----------|----------------|
| FASE 0 | Análisis y mapeo [DONE] | [DONE] |
| **FASE 0B** | **NO EXISTÍA** | **[TODO] Renombrado base_cognitiva/** |
| FASE 1 | Verificar 7 módulos UC | [TODO] |
| FASE 2 | Actualizar 7 módulos UC | [TODO] |
| FASE 3 | Actualizar fundamentos | [BLOQUEADO por 0B] |
| FASE 4 | Actualizar metamodelos | [BLOQUEADO por 0B] |
| FASE 5 | Actualizar taxonomías | [BLOQUEADO por 0B] |
| FASE 6 | Validación final | [BLOQUEADO por 0B] |

**CRÍTICO:** FASE 3, 4, 5 están BLOQUEADAS hasta completar FASE 0B.

---

## ESTIMACIÓN TOTAL ACTUALIZADA

**Plan Maestro Original:**
- Análisis (FASE 0): 2-3h [DONE]
- Implementación (FASES 1-6): 12-18h

**Plan Maestro Actualizado (con FASE 0B):**
- Análisis (FASE 0): 2-3h [DONE]
- **Renombrado (FASE 0B): 6-7h [TODO]**
- Implementación (FASES 1-6): 12-18h

**TOTAL:** 20-28 horas (vs 14-21 original)

**Incremento:** +6-7 horas (+43% tiempo adicional)

---

## ARCHIVOS AFECTADOS ESTIMADOS

| Categoría | Cantidad |
|-----------|----------|
| Archivos a renombrar | 23 |
| Index.rst a actualizar | 5 |
| Referencias :doc: a actualizar | 50-100 |
| Referencias :ref: a actualizar | 10-20 |
| **TOTAL archivos tocados** | **88-148** |

---

## DECISIÓN REQUERIDA

**Opciones:**

**A) Implementar FASE 0B completa**
- Pro: Cumple NOM_01 al 100%
- Pro: Consistencia total en proyecto
- Contra: +6-7 horas de trabajo
- Contra: Alto riesgo de romper referencias

**B) Modificar NOM_01**
- Pro: Rápido (15 min)
- Pro: Sin riesgo
- Contra: Nomenclatura inconsistente
- Contra: NOM_01 no se cumple

**C) Híbrido: Solo nuevos archivos**
- Pro: Archivos existentes no se tocan
- Pro: Nuevos archivos siguen NOM_01
- Contra: Inconsistencia parcial
- Contra: Confusión en equipo

**D) Renombrado incremental**
- Pro: Riesgo distribuido
- Pro: Validación por subdirectorio
- Contra: +1-2 horas adicionales por overhead
- Contra: 3-4 semanas de trabajo

---

## RECOMENDACIÓN

**RECOMENDACIÓN: Opción B (Modificar NOM_01)**

**Justificación:**
1. Archivos base_cognitiva/ son **PRIVADOS** (prefijo `_`)
2. No se buildean directamente a HTML público
3. El riesgo de romper 50-100 referencias no justifica el beneficio
4. Equipo ya conoce archivos con nombres actuales
5. NOM_01 puede especificar excepción para archivos privados

**Modificación propuesta a NOM_01:**

```rst
EXCEPCIÓN: Archivos en subdominios PRIVADOS (prefijo _)
-------------------------------------------------------

Los archivos en subdominios privados (base_cognitiva/_*) pueden
omitir el sufijo de versión si:

- El archivo fue creado antes de NOM_01 v1.0.0
- El archivo es de uso interno exclusivo
- El archivo no se buildea a HTML público

Estos archivos deben incluir la versión en metadatos:

.. code-block:: rst

   .. meta::
      :artefacto: FND_01
      :version: 1.0.0
```

---

**Estado:** [PENDING] DECISIÓN DEL USUARIO  
**Fecha Límite:** ANTES de ejecutar FASE 3-5  
**Impacto:** BLOQUEA 50% del plan maestro original
