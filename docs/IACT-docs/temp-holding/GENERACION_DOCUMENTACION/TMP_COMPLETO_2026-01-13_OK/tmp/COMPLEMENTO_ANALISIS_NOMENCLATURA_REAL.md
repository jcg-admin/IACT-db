# COMPLEMENTO: Nomenclatura Real Confirmada del Proyecto IACT

**Fecha:** 2026-01-08  
**Fuente:** ANEXO_A_ARBOL_COMPLETO v2.2.0  
**Objetivo:** Documentar la nomenclatura REAL confirmada del proyecto

---

## HALLAZGO CRÍTICO: Nomenclatura INCONSISTENTE

### 1. CON Sufijo de Versión

**Dominio normativa/:**
```
normativa/estandares/plantillas/
├── TPL_BReq_Objetivos_Negocio_1_0_0.rst ✅
├── TPL_BR_Business_Rules_1_0_0.rst ✅
├── TPL_UC_Casos_de_Uso_2_0_0.rst ✅
└── TPL_API_Documentacion_API_1_1_0.rst ✅

normativa/procedimientos/
├── PROC_Generacion_FR_1_0_0.rst ✅
├── PROC_Derivacion_UC_FR_1_0_0.rst ✅
└── PROC_Derivacion_FR_TST_1_1_0.rst ✅
```

**Total: 55 archivos (17 TPL + 38 PROC)**

### 2. SIN Sufijo de Versión

**Dominio base_cognitiva/:**
```
base_cognitiva/_fundamentos_conceptuales/
├── FND_01_Concepto_Requisito.rst ❌
├── FND_02_Reglas_de_Negocio.rst ❌
└── FND_03_Casos_de_Uso.rst ❌

base_cognitiva/_taxonomias_y_metamodelos/
├── TXM_01_Taxonomia_Requisitos.rst ❌
├── MTM_01_Metamodelo_Requisitos.rst ❌
└── MTM_02_Metamodelo_Trazabilidad.rst ❌
```

**Total: ~27 archivos en base_cognitiva/**

**Dominio requisitos/:**
```
requisitos/reglas_negocio/
├── BR_001_Fuente_Operacional_Inmutable.rst ❌
├── BR_002_ETL_Batch_Nocturno.rst ❌
└── BR_020_Clasificacion_Datos.rst ❌

requisitos/casos_uso/auth/
├── UC_AUTH_01_Iniciar_Sesion.rst ❌
├── UC_AUTH_02_Cerrar_Sesion.rst ❌
└── UC_AUTH_05_Gestionar_Sesiones.rst ❌

requisitos/funcionales/auth/UC_AUTH_01/
├── FR_UC_AUTH_01_01_Validar_Username.rst ❌
├── FR_UC_AUTH_01_02_Validar_Password.rst ❌
└── FR_UC_AUTH_01_05_Registrar_Evento_Login.rst ❌
```

**Total: ~142 archivos en requisitos/**

**Dominio arquitectura_tecnica/:**
```
arquitectura_tecnica/modulos/
├── MOD_Auth.rst ❌
├── MOD_Access.rst ❌
└── MOD_Reports.rst ❌

arquitectura_tecnica/restricciones/
├── CNST_001_Comunicaciones_Prohibidas.rst ❌
├── CNST_005_Seguridad_DRF.rst ❌
└── CNST_010_Clasificacion_Datos.rst ❌
```

**Total: ~51 archivos en arquitectura_tecnica/**

---

## ANÁLISIS DE INCONSISTENCIA

### Situación Actual

| Dominio | Con Versión | Sin Versión | Total | % con Versión |
|---------|-------------|-------------|-------|---------------|
| base_cognitiva | 0 | ~27 | ~27 | 0% |
| requisitos | 0 | ~142 | ~142 | 0% |
| arquitectura_tecnica | 0 | ~51 | ~51 | 0% |
| normativa | 55 | 8 | 63 | 87% |
| evidencia | 0 | ~10 | ~10 | 0% |
| **TOTAL** | **55** | **~238** | **~293** | **19%** |

### Interpretación

**Solo 19% de los archivos del proyecto siguen la nomenclatura con sufijo de versión.**

Este 19% corresponde ÚNICAMENTE a:
- 17 Templates (TPL_XXX_1_0_0.rst)
- 38 Procedimientos (PROC_XXX_1_0_0.rst)

**El 81% restante NO sigue la nomenclatura con versión:**
- TODO base_cognitiva/ (27 archivos)
- TODO requisitos/ (142 archivos)
- TODO arquitectura_tecnica/ (51 archivos)
- TODO evidencia/ (10 archivos)
- 8 archivos de normativa/ (STD, POL, algunos índices)

---

## OPCIONES DE CORRECCIÓN

### Opción A: Renombrado Masivo Completo

**Acción:** Renombrar TODOS los archivos para que tengan sufijo de versión.

**Archivos a renombrar:**
- ~27 en base_cognitiva/
- ~142 en requisitos/
- ~51 en arquitectura_tecnica/
- ~10 en evidencia/
- ~8 en normativa/
**Total: ~238 archivos**

**Esfuerzo estimado:**
- Script de renombrado: 2h
- Actualización de referencias en archivos: 8-10h
- Actualización de índices: 2-3h
- Validación Sphinx: 1h
**Total: 13-16h**

**Ventajas:**
- Consistencia total (100%)
- Cumplimiento estricto de NOM_01

**Desventajas:**
- Esfuerzo significativo
- Riesgo de romper referencias
- Cambio masivo en Git (diff grande)

### Opción B: Excepción para Subdominios Privados

**Acción:** Modificar NOM_01 para permitir excepción en subdominios privados (prefijo `_`).

**Regla propuesta:**
```
Archivos en subdominios PRIVADOS (prefijo _) pueden omitir sufijo de versión.
Archivos en subdominios PÚBLICOS deben incluir sufijo de versión.

Privados (sin sufijo permitido):
  - base_cognitiva/_metadata/
  - base_cognitiva/_fundamentos_conceptuales/
  - base_cognitiva/_ontologia_sbvr/
  - base_cognitiva/_taxonomias_y_metamodelos/
  - base_cognitiva/_metodologias_analiticas/

Públicos (sufijo obligatorio):
  - requisitos/
  - arquitectura_tecnica/
  - normativa/
  - evidencia/
```

**Archivos a renombrar:**
- 0 en base_cognitiva/ (excepción aplicada)
- ~142 en requisitos/
- ~51 en arquitectura_tecnica/
- ~10 en evidencia/
**Total: ~203 archivos**

**Esfuerzo estimado:**
- Modificar NOM_01: 30min
- Script de renombrado: 2h
- Actualización de referencias: 6-8h
- Validación: 1h
**Total: 9.5-11.5h**

**Ventajas:**
- Ahorra ~25 archivos de renombrado
- Reconoce naturaleza privada de base_cognitiva/
- Menor impacto

**Desventajas:**
- Inconsistencia parcial (aunque justificada)

### Opción C: Solo Archivos Nuevos

**Acción:** NO renombrar archivos existentes. Solo archivos nuevos siguen nomenclatura con versión.

**Archivos a renombrar:** 0

**Esfuerzo:** 0h (solo actualizar NOM_01 con regla de "grandfathering")

**Ventajas:**
- Cero esfuerzo inmediato
- No rompe nada

**Desventajas:**
- Inconsistencia permanente
- Confusión en equipo
- Deuda técnica

---

## RECOMENDACIÓN: Opción B

**Justificación:**

1. **Balance Esfuerzo/Beneficio:**
   - Ahorra ~5h vs Opción A
   - Logra 87% de consistencia (vs 0% actual)
   - Reconoce realidad del proyecto

2. **Lógica Conceptual:**
   - base_cognitiva/ es documentación INTERNA pedagógica
   - Subdominios con `_` son PRIVADOS por diseño
   - No están pensados para ser referenciados externamente
   - La versión es menos crítica en documentación interna

3. **Precedente en Sphinx:**
   - Archivos con prefijo `_` comúnmente son "privados"
   - Convención estándar en proyectos Sphinx

4. **Menor Impacto:**
   - Solo requisitos/, arquitectura_tecnica/, evidencia/
   - Estos SÍ son referenciados externamente
   - Versionado crítico para trazabilidad

---

## PLAN DE IMPLEMENTACIÓN (Opción B)

### Paso 1: Modificar NOM_01 (30min)

Agregar sección:

```rst
4.5 Excepciones de Nomenclatura
================================

**Subdominios Privados**

Los subdominios marcados con prefijo guion bajo (_) en base_cognitiva/ 
son considerados PRIVADOS y NO requieren sufijo de versión en sus archivos.

Subdominios afectados:
- base_cognitiva/_metadata/
- base_cognitiva/_fundamentos_conceptuales/
- base_cognitiva/_ontologia_sbvr/
- base_cognitiva/_taxonomias_y_metamodelos/
- base_cognitiva/_metodologias_analiticas/

**Justificación:**
Estos subdominios contienen documentación pedagógica interna que no es 
referenciada externamente. El versionado estricto no es crítico para 
su propósito.

**Subdominios Públicos**

Todos los demás subdominios DEBEN seguir nomenclatura con sufijo de versión:
- requisitos/
- arquitectura_tecnica/
- normativa/ (parcialmente, ver TPL y PROC)
- evidencia/
```

### Paso 2: Crear Script de Renombrado (2h)

```bash
#!/bin/bash
# rename_add_version.sh

# Renombrar archivos en requisitos/
find source/requisitos -name "*.rst" \
  -not -name "*_1_0_0.rst" \
  -not -name "index.rst" \
  -not -name "_*.rst" \
  -exec bash -c 'mv "$0" "${0%.rst}_1_0_0.rst"' {} \;

# Renombrar archivos en arquitectura_tecnica/
find source/arquitectura_tecnica -name "*.rst" \
  -not -name "*_1_0_0.rst" \
  -not -name "index.rst" \
  -not -name "_*.rst" \
  -exec bash -c 'mv "$0" "${0%.rst}_1_0_0.rst"' {} \;

# Renombrar archivos en evidencia/
find source/evidencia -name "*.rst" \
  -not -name "*_1_0_0.rst" \
  -not -name "index.rst" \
  -not -name "_*.rst" \
  -exec bash -c 'mv "$0" "${0%.rst}_1_0_0.rst"' {} \;

echo "Renombrado completo. Total archivos: ~203"
```

### Paso 3: Actualizar Referencias (6-8h)

```bash
# Script para actualizar referencias en archivos
# update_references.py

import re
from pathlib import Path

def update_references(file_path):
    content = file_path.read_text()
    
    # Patrones a actualizar
    patterns = [
        (r'BR_(\d+)_([^\.]+)\.rst', r'BR_\1_\2_1_0_0.rst'),
        (r'UC_([A-Z]+)_(\d+)_([^\.]+)\.rst', r'UC_\1_\2_\3_1_0_0.rst'),
        (r'FR_UC([A-Z]+)_(\d+)_(\d+)_([^\.]+)\.rst', r'FR_UC\1_\2_\3_\4_1_0_0.rst'),
        (r'CNST_(\d+)_([^\.]+)\.rst', r'CNST_\1_\2_1_0_0.rst'),
        (r'MOD_([A-Za-z]+)\.rst', r'MOD_\1_1_0_0.rst'),
    ]
    
    for pattern, replacement in patterns:
        content = re.sub(pattern, replacement, content)
    
    file_path.write_text(content)

# Procesar todos los archivos
for rst_file in Path('source').rglob('*.rst'):
    update_references(rst_file)
```

### Paso 4: Validación (1h)

```bash
make clean
make html
make linkcheck

# Verificar warnings
# Verificar que todos los enlaces internos funcionan
```

---

## IMPACTO EN base_cognitiva/

**NINGÚN CAMBIO requerido en archivos existentes.**

Los 23 archivos actuales mantienen su nombre:
- FND_01_Concepto_Requisito.rst ✅ (sin cambio)
- TXM_01_Taxonomia_Requisitos.rst ✅ (sin cambio)
- MTM_01_Metamodelo_Requisitos.rst ✅ (sin cambio)

**Solo se requiere:**
1. Actualizar NOM_01 con excepción
2. Reescribir CONTENIDO (ejemplos UC, nomenclatura v4.0.0)
3. NO renombrar archivos

---

## RESUMEN

| Métrica | Opción A | Opción B | Opción C |
|---------|----------|----------|----------|
| Archivos a renombrar | ~238 | ~203 | 0 |
| Esfuerzo estimado | 13-16h | 9.5-11.5h | 0h |
| Consistencia final | 100% | 87% | 19% |
| Impacto en base_cognitiva/ | Alto | Ninguno | Ninguno |
| Riesgo | Medio | Bajo | Alto (deuda) |
| Recomendación | No | **SÍ** ✅ | No |

---

**CONCLUSIÓN: Opción B es el mejor balance.**

- Ahorra 5h de esfuerzo
- Respeta naturaleza privada de base_cognitiva/
- Logra alta consistencia (87%)
- Menor riesgo de romper cosas
- Permite enfocarse en reescritura de CONTENIDO (más importante)

