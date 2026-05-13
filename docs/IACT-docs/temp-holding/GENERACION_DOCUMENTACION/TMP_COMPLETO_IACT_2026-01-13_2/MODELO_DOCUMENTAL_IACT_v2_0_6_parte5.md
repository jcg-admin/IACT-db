---

## 10. CATÁLOGO DE PREFIJOS

### 10.1 Por Dominio

| Dominio | Prefijos | Cantidad Est. |
|---------|----------|---------------|
| base_cognitiva | META, GLOS, FND, SBVR, TXM, MTM, METH | ~25 |
| requisitos | BReq, BR, UC, FR, NFR | ~475 |
| arquitectura_tecnica | MOD, CNST, ADR, VIEW, FD, API, MDL | ~45 |
| normativa | STD, PROC, POL, TPL | ~15 |
| evidencia | TST, RTM, COV | ~12 |
| **TOTAL** | -- | **~572** |

### 10.2 Nomenclatura de Archivos

```
[PREFIJO]_[NNN]_[Nombre_Descriptivo].rst

Ejemplos:
- BReq_001_Objetivos_IACT.rst
- BR_001_Fuente_Inmutable.rst
- UC_010_Asignar_Roles.rst
- MOD_Auth.rst (sin número, nombre único)
```

### 10.3 Caso Especial: FR

```
FR_UC[NNN]_[Nombre_UC].rst

El archivo contiene todos los FR del UC.
Ejemplo: FR_UC010_Asignar_Roles.rst → contiene FR-010.1 a FR-010.N
```

---

## 11. CONTEO DE ARTEFACTOS

### 11.1 Por Estado

| Estado | Cantidad | % |
|--------|----------|---|
| ✅ COMPLETADOS | 24 | 4% |
| ⏳ IDENTIFICADOS | ~105 | 18% |
| ❌ PENDIENTES | ~443 | 78% |
| **TOTAL** | **~572** | 100% |

### 11.2 Completados

| Tipo | Cantidad | Ubicación |
|------|----------|-----------|
| CNST | 10 | arquitectura_tecnica/restricciones/ |
| FND | 7 | base_cognitiva/_fundamentos_conceptuales/ |
| TXM | 3 | base_cognitiva/_taxonomias_y_metamodelos/taxonomias/ |
| MTM | 3 | base_cognitiva/_taxonomias_y_metamodelos/metamodelos/ |
| BReq | 1 | requisitos/objetivos/ |
| **TOTAL** | **24** | -- |

### 11.3 Pendientes Prioritarios

| Tipo | Cantidad | Prioridad |
|------|----------|-----------|
| BReq | 1 (documentar completo) | 🔴 ALTA |
| BR | 20 (documentar) | 🔴 ALTA |
| UC | 49 | 🔴 ALTA |
| FR | ~400 | 🟡 MEDIA |
| MOD | 8 | 🟡 MEDIA |
| TST | ~320 | 🟢 BAJA |

---

## 12. ORDEN DE EJECUCIÓN

### Fase 0: Corrección FND_04 (CRÍTICO)
```
Prioridad: 🔴 CRÍTICA
Archivo: FND_04_Trazabilidad.rst
Estado actual: CORRUPTO (contiene copia de FND_03)
Acción: RECREAR con contenido correcto
```

### Fase 1: Business Requirements (BReq)
```
Prioridad: 🔴 ALTA
Cantidad: 1 documento (5 BReq consolidados)
Ubicación: requisitos/objetivos/
Archivo: BReq_001_Objetivos_IACT.rst
```

### Fase 2: Business Rules (BR)
```
Prioridad: 🔴 ALTA
Cantidad: 20 documentos
Ubicación: requisitos/reglas_negocio/
Template: TPL_001_Plantilla_BR.rst (ver FND_02)
```

### Fase 3: Casos de Uso (UC)
```
Prioridad: 🔴 ALTA
Cantidad: 49 documentos
Ubicación: requisitos/casos_uso/{modulo}/
Template: TPL_002_Plantilla_UC.rst
Actor: Usar Agrupadores (AGR-00x)

Por módulo:
1. auth/ (5 UC)
2. users/ (4 UC)
3. access/ (9 UC)
4. pipeline/ (4 UC)
5. reports/ (14 UC)
6. alerts/ (5 UC)
7. audit/ (4 UC)
8. logs/ (3 UC)
```

### Fase 4: Módulos (MOD)
```
Prioridad: 🟡 MEDIA
Cantidad: 8 documentos
Ubicación: arquitectura_tecnica/modulos/
Template: TPL_006_Plantilla_MOD.rst
```

### Fase 5: Functional Requirements (FR)
```
Prioridad: 🟡 MEDIA
Cantidad: ~400 documentos
Ubicación: requisitos/funcionales/{modulo}/
Template: TPL_003_Plantilla_FR.rst
Criterios: SMART (ver FND_07)
Ratio: 1 UC : 8 FR
```

### Fase 6: Trazabilidad (RTM)
```
Prioridad: 🟡 MEDIA
Cantidad: 2 documentos
Ubicación: evidencia/trazabilidad/
Referencia: FND_04_Trazabilidad.rst (después de recrear)
```

### Fase 7: Tests (TST)
```
Prioridad: 🟢 BAJA
Cantidad: ~320 documentos
Ubicación: evidencia/pruebas/{modulo}/
Meta: 80% cobertura FR→TEST
```

---

## 13. REFERENCIAS A FND

### 13.1 Documentos de Fundamentos Conceptuales

| FND | Título | Uso en Modelo |
|-----|--------|---------------|
| FND_01 | Concepto de Requisito | Base conceptual FR/NFR |
| FND_02 | Reglas de Negocio | Template BR, 5 tipos, campos |
| FND_03 | Casos de Uso | Estructura UC, actores → AGR |
| FND_04 | Trazabilidad | ⚠️ PENDIENTE RECREAR |
| FND_05 | Jerarquía 4 Niveles | BR→BReq→UC→FR |
| FND_06 | Derivación vs Transformación | Proceso derivar UC→FR |
| FND_07 | Requerimientos Funcionales | Criterios SMART, template FR |

### 13.2 Estado de FND

| FND | Versión | Estado | Notas |
|-----|---------|--------|-------|
| FND_01 | 1.0.0 | ✅ OK | -- |
| FND_02 | 1.1.0 | ✅ OK | Referenciado para template BR |
| FND_03 | 1.1.0 | ⚠️ Desalineado | UC: 38 vs 49, Actores: R00x vs AGR |
| FND_04 | -- | 🔴 CORRUPTO | Contiene copia de FND_03 |
| FND_05 | 1.0.0 | ✅ OK | Jerarquía 4 niveles aplicada |
| FND_06 | 1.0.0 | ✅ OK | -- |
| FND_07 | 1.0.0 | ✅ OK | Referenciado para SMART |

---

## 14. ARCHIVOS DE REFERENCIA

| Archivo | Propósito | Ubicación |
|---------|-----------|-----------|
| REFERENCIA_GLOBAL_MODULOS_IACT.md | Fuente para MOD_.rst | /outputs/ |
| MODELO_RBAC_IACT_v5_1_1.md | Modelo RBAC oficial | /outputs/ |
| ANALISIS_BR_REVISION_INTEGRAL_v1.md | Análisis BR vs RBAC | /outputs/ |
| ANALISIS_FND_vs_MODELO_REVISION_v2.md | Análisis alineación FND | /outputs/ |
| MODELO_DOCUMENTAL_IACT_v2_0_6.md | Este documento | /outputs/ |
