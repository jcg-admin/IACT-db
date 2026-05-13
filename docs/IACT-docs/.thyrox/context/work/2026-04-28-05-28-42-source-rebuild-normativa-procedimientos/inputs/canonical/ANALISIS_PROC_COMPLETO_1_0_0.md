# ANALISIS DE PROCEDIMIENTOS (PROC) A GENERAR
## Proyecto IACT Dashboard Analytics

**Fecha:** 2026-01-07  
**Version:** 1.0.0  
**Base:** MODELO DOCUMENTAL IACT v2.1.1 + 17 TPL generados  
**Proposito:** Definir plan completo de generacion de PROC

---

## 1. ESTADO ACTUAL

### 1.1 PROC Existentes (segun modelo v2.1.0)

```
normativa/procedimientos/
├── PROC_001_Cambio_Requisitos.rst
├── PROC_002_Revision_Artefactos.rst
└── PROC_003_Aprobacion_Documentos.rst
```

**Total existentes:** 3 PROC

### 1.2 Templates Disponibles

Con la generacion de 17 TPL completada, ahora tenemos:

| TPL | Disponible | Usado para PROC |
|-----|------------|-----------------|
| TPL_PROC_Procedimientos_1_0_0.rst | SI | Base para todos los PROC |

### 1.3 Procedimientos Ejecutados de Facto (sin PROC formal)

| Actividad | Artefactos Generados | PROC Formal |
|-----------|---------------------|-------------|
| Generacion BR | BR_001 a BR_020 (20) | NO |
| Generacion UC | UC_xxx (49) | NO |
| Generacion FR | FR_xxx (55) | NO |
| Generacion STD | STD_001 a STD_006 (6) | NO |
| Generacion TPL | TPL_xxx (17) | NO |
| Actualizacion index.rst | Varios | NO |
| Derivacion BReq a BR | 8 BReq -> 20 BR | NO |
| Derivacion BR a UC | 20 BR -> 49 UC | NO |
| Derivacion UC a FR | 49 UC -> 55 FR (parcial) | NO |

**Deuda tecnica:** Todos estos procedimientos fueron ejecutados correctamente pero sin documentacion formal.

---

## 2. CATALOGO COMPLETO DE PROC NECESARIOS

### 2.1 Categoria: Control de Cambios (001-003) - EXISTENTES

| ID | Nombre | Estado | Descripcion |
|----|--------|--------|-------------|
| PROC_001 | Cambio de Requisitos | EXISTE | Control de cambios en requisitos |
| PROC_002 | Revision de Artefactos | EXISTE | Proceso de revision |
| PROC_003 | Aprobacion de Documentos | EXISTE | Flujo de aprobacion |

### 2.2 Categoria: Generacion de Artefactos (004-013) - PENDIENTES

| ID | Nombre | TPL Asociado | Prioridad | Artefactos Existentes |
|----|--------|--------------|-----------|----------------------|
| PROC_004 | Generacion de BReq | TPL_BReq | P2 Baja | 8 BReq |
| PROC_005 | Generacion de BR | TPL_BR | P1 Media | 20 BR |
| PROC_006 | Generacion de UC | TPL_UC | P1 Media | 49 UC |
| PROC_007 | Generacion de FR | TPL_FR | P0 CRITICA | 55 FR (14%) |
| PROC_008 | Generacion de CNST | TPL_CNST | P2 Baja | 10 CNST |
| PROC_009 | Generacion de MOD | TPL_MOD | P2 Baja | 8 MOD |
| PROC_010 | Generacion de ADR | TPL_ADR | P2 Baja | 5 ADR |
| PROC_011 | Generacion de STD | TPL_STD | P1 Media | 6 STD |
| PROC_012 | Generacion de TST | TPL_TST | P0 CRITICA | 0 TST |
| PROC_013 | Generacion de NFR | TPL_NFR | P1 Media | ~20 NFR |

### 2.3 Categoria: Derivacion de Artefactos (014-018) - PENDIENTES

| ID | Nombre | Flujo | Prioridad | Ratio |
|----|--------|-------|-----------|-------|
| PROC_014 | Derivacion BReq a BR | BReq -> BR | P2 Baja | 1:2.5 |
| PROC_015 | Derivacion BR a UC | BR -> UC | P2 Baja | 1:2.5 |
| PROC_016 | Derivacion UC a FR | UC -> FR | P0 CRITICA | 1:8 |
| PROC_017 | Derivacion FR a TST | FR -> TST | P0 CRITICA | 1:1 |
| PROC_018 | Derivacion FR a CODE | FR -> Codigo | P1 Media | 1:N |

### 2.4 Categoria: Gobernanza Documental (019-023) - PENDIENTES

| ID | Nombre | Descripcion | Prioridad |
|----|--------|-------------|-----------|
| PROC_019 | Versionado Semantico | Aplicar STD_006 | P1 Media |
| PROC_020 | Congelamiento Subdominio | Proceso de freeze | P1 Media |
| PROC_021 | Descongelamiento Subdominio | Proceso de unfreeze | P1 Media |
| PROC_022 | Actualizacion Modelo Documental | Generar nueva version | P0 CRITICA |
| PROC_023 | Generacion de Index | Crear/actualizar index.rst | P1 Media |

### 2.5 Categoria: Trazabilidad y Verificacion (024-026) - PENDIENTES

| ID | Nombre | Descripcion | Prioridad |
|----|--------|-------------|-----------|
| PROC_024 | Generacion RTM | Crear matriz trazabilidad | P1 Media |
| PROC_025 | Verificacion Cobertura | Validar umbrales | P1 Media |
| PROC_026 | Auditoria Documental | Verificar consistencia | P2 Baja |

### 2.6 Categoria: Arquitectura (027-030) - PENDIENTES

| ID | Nombre | TPL Asociado | Prioridad |
|----|--------|--------------|-----------|
| PROC_027 | Generacion de FD | TPL_FD | P2 Baja |
| PROC_028 | Generacion de VIEW | TPL_VIEW | P2 Baja |
| PROC_029 | Generacion de API | TPL_API | P1 Media |
| PROC_030 | Generacion de POL | TPL_POL | P2 Baja |

---

## 3. RESUMEN CUANTITATIVO

### 3.1 Totales

| Categoria | Existentes | Pendientes | Total |
|-----------|------------|------------|-------|
| Control de Cambios | 3 | 0 | 3 |
| Generacion Artefactos | 0 | 10 | 10 |
| Derivacion | 0 | 5 | 5 |
| Gobernanza | 0 | 5 | 5 |
| Trazabilidad | 0 | 3 | 3 |
| Arquitectura | 0 | 4 | 4 |
| **TOTAL** | **3** | **27** | **30** |

### 3.2 Por Prioridad

| Prioridad | Cantidad | PROC |
|-----------|----------|------|
| P0 CRITICA | 5 | PROC_007, PROC_012, PROC_016, PROC_017, PROC_022 |
| P1 Media | 12 | PROC_005, PROC_006, PROC_011, PROC_013, PROC_018, PROC_019, PROC_020, PROC_021, PROC_023, PROC_024, PROC_025, PROC_029 |
| P2 Baja | 10 | PROC_004, PROC_008, PROC_009, PROC_010, PROC_014, PROC_015, PROC_026, PROC_027, PROC_028, PROC_030 |

---

## 4. PLAN DE GENERACION POR FASES

### FASE 1: Criticos para Fase Actual (5 PROC)

Necesarios para continuar con la generacion de FR y preparar TST.

| Orden | PROC | Nombre | Justificacion |
|-------|------|--------|---------------|
| 1 | PROC_007 | Generacion de FR | Fase actual: 55/392 FR |
| 2 | PROC_016 | Derivacion UC a FR | Metodologia de derivacion |
| 3 | PROC_012 | Generacion de TST | Proxima fase |
| 4 | PROC_017 | Derivacion FR a TST | Preparar testing |
| 5 | PROC_022 | Actualizacion Modelo Documental | Registrar cambios |

**Estimacion:** ~250-300 lineas por PROC = ~1,250-1,500 lineas total

### FASE 2: Gobernanza y Versionado (5 PROC)

Para formalizar procesos de control.

| Orden | PROC | Nombre | Justificacion |
|-------|------|--------|---------------|
| 6 | PROC_019 | Versionado Semantico | Usar STD_006 |
| 7 | PROC_020 | Congelamiento Subdominio | Control de cambios |
| 8 | PROC_021 | Descongelamiento Subdominio | Control de cambios |
| 9 | PROC_023 | Generacion de Index | Mantener indices |
| 10 | PROC_024 | Generacion RTM | Trazabilidad |

**Estimacion:** ~1,250-1,500 lineas total

### FASE 3: Generacion de Artefactos Principales (5 PROC)

Retroactivo para documentar procesos ya ejecutados.

| Orden | PROC | Nombre | Justificacion |
|-------|------|--------|---------------|
| 11 | PROC_005 | Generacion de BR | 20 BR existentes |
| 12 | PROC_006 | Generacion de UC | 49 UC existentes |
| 13 | PROC_011 | Generacion de STD | 6 STD existentes |
| 14 | PROC_013 | Generacion de NFR | ~20 NFR existentes |
| 15 | PROC_018 | Derivacion FR a CODE | Para implementacion |

**Estimacion:** ~1,250-1,500 lineas total

### FASE 4: Derivacion y Trazabilidad (5 PROC)

| Orden | PROC | Nombre | Justificacion |
|-------|------|--------|---------------|
| 16 | PROC_014 | Derivacion BReq a BR | Retroactivo |
| 17 | PROC_015 | Derivacion BR a UC | Retroactivo |
| 18 | PROC_025 | Verificacion Cobertura | Metricas |
| 19 | PROC_026 | Auditoria Documental | Calidad |
| 20 | PROC_029 | Generacion de API | Arquitectura |

**Estimacion:** ~1,250-1,500 lineas total

### FASE 5: Arquitectura y Complementarios (7 PROC)

| Orden | PROC | Nombre | Justificacion |
|-------|------|--------|---------------|
| 21 | PROC_004 | Generacion de BReq | 8 BReq existentes |
| 22 | PROC_008 | Generacion de CNST | 10 CNST existentes |
| 23 | PROC_009 | Generacion de MOD | 8 MOD existentes |
| 24 | PROC_010 | Generacion de ADR | 5 ADR existentes |
| 25 | PROC_027 | Generacion de FD | 12 FD existentes |
| 26 | PROC_028 | Generacion de VIEW | 5 VIEW existentes |
| 27 | PROC_030 | Generacion de POL | 2 POL existentes |

**Estimacion:** ~1,750-2,100 lineas total

---

## 5. ESTRUCTURA DE CADA PROC

Segun TPL_PROC_Procedimientos_1_0_0.rst, cada PROC tendra:

```
1. Resumen Ejecutivo
2. Proposito
3. Alcance
4. Roles y Responsabilidades
5. Precondiciones
6. Artefactos de Entrada
7. Procedimiento (Diagrama + Pasos)
8. Artefactos de Salida
9. Postcondiciones
10. Verificacion y Validacion
11. Manejo de Excepciones
12. Referencias
13. Historial de Cambios
```

**Estimacion por PROC:** 250-350 lineas

---

## 6. NOMENCLATURA FINAL

### 6.1 Formato de Nombre de Archivo

```
PROC_[NNN]_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].rst
```

### 6.2 Catalogo Completo (30 PROC)

```
normativa/procedimientos/
├── index.rst
│
├── # EXISTENTES (001-003)
├── PROC_001_Cambio_Requisitos_1_0_0.rst
├── PROC_002_Revision_Artefactos_1_0_0.rst
├── PROC_003_Aprobacion_Documentos_1_0_0.rst
│
├── # GENERACION ARTEFACTOS (004-013)
├── PROC_004_Generacion_BReq_1_0_0.rst
├── PROC_005_Generacion_BR_1_0_0.rst
├── PROC_006_Generacion_UC_1_0_0.rst
├── PROC_007_Generacion_FR_1_0_0.rst
├── PROC_008_Generacion_CNST_1_0_0.rst
├── PROC_009_Generacion_MOD_1_0_0.rst
├── PROC_010_Generacion_ADR_1_0_0.rst
├── PROC_011_Generacion_STD_1_0_0.rst
├── PROC_012_Generacion_TST_1_0_0.rst
├── PROC_013_Generacion_NFR_1_0_0.rst
│
├── # DERIVACION (014-018)
├── PROC_014_Derivacion_BReq_BR_1_0_0.rst
├── PROC_015_Derivacion_BR_UC_1_0_0.rst
├── PROC_016_Derivacion_UC_FR_1_0_0.rst
├── PROC_017_Derivacion_FR_TST_1_0_0.rst
├── PROC_018_Derivacion_FR_CODE_1_0_0.rst
│
├── # GOBERNANZA (019-023)
├── PROC_019_Versionado_Semantico_1_0_0.rst
├── PROC_020_Congelamiento_Subdominio_1_0_0.rst
├── PROC_021_Descongelamiento_Subdominio_1_0_0.rst
├── PROC_022_Actualizacion_Modelo_Documental_1_0_0.rst
├── PROC_023_Generacion_Index_1_0_0.rst
│
├── # TRAZABILIDAD (024-026)
├── PROC_024_Generacion_RTM_1_0_0.rst
├── PROC_025_Verificacion_Cobertura_1_0_0.rst
├── PROC_026_Auditoria_Documental_1_0_0.rst
│
├── # ARQUITECTURA (027-030)
├── PROC_027_Generacion_FD_1_0_0.rst
├── PROC_028_Generacion_VIEW_1_0_0.rst
├── PROC_029_Generacion_API_1_0_0.rst
└── PROC_030_Generacion_POL_1_0_0.rst
```

---

## 7. ESTIMACION TOTAL

| Fase | PROC | Lineas Est. |
|------|------|-------------|
| FASE 1 | 5 | ~1,500 |
| FASE 2 | 5 | ~1,500 |
| FASE 3 | 5 | ~1,500 |
| FASE 4 | 5 | ~1,500 |
| FASE 5 | 7 | ~2,100 |
| **TOTAL** | **27** | **~8,100** |

**Nota:** Los 3 PROC existentes (001-003) pueden requerir actualizacion a nueva nomenclatura.

---

## 8. TRACKING DE PROGRESO

### Estado Inicial

```
FASE 1 (Criticos):     --------------------   0% (0/5)
FASE 2 (Gobernanza):   --------------------   0% (0/5)
FASE 3 (Generacion):   --------------------   0% (0/5)
FASE 4 (Derivacion):   --------------------   0% (0/5)
FASE 5 (Arquitectura): --------------------   0% (0/7)
--------------------------------------------------
TOTAL NUEVOS:          --------------------   0% (0/27)
EXISTENTES:            ====================  100% (3/3)
TOTAL GENERAL:         ==--------------------  10% (3/30)
```

---

## 9. PROXIMA ACCION

**Pregunta:** Proceder con FASE 1 (5 PROC criticos)?

Generare en orden:
1. PROC_007_Generacion_FR_1_0_0.rst
2. PROC_016_Derivacion_UC_FR_1_0_0.rst
3. PROC_012_Generacion_TST_1_0_0.rst
4. PROC_017_Derivacion_FR_TST_1_0_0.rst
5. PROC_022_Actualizacion_Modelo_Documental_1_0_0.rst

---

*Documento: Analisis de Procedimientos PROC*  
*Version: 1.0.0*  
*Fecha: 2026-01-07*  
*Proyecto IACT Dashboard Analytics*
