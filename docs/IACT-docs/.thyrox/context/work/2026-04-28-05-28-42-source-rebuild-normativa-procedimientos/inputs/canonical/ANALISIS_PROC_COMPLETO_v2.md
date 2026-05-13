# ANALISIS DE PROCEDIMIENTOS (PROC) A GENERAR
## Proyecto IACT Dashboard Analytics

**Fecha:** 2026-01-07  
**Version:** 2.0.0  
**Base:** MODELO DOCUMENTAL IACT v2.1.1 + 17 TPL generados  
**Proposito:** Definir plan completo de generacion de PROC con nomenclatura correcta

---

## 1. NOMENCLATURA APROBADA

### 1.1 Formato de Nombre de Archivo

```
PROC_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].rst
```

**Caracteristicas:**
- SIN numeros secuenciales
- Nombre descriptivo en snake_case
- Version semantica con guiones bajos
- Extension .rst

**Ejemplos:**
```
PROC_Generacion_FR_1_0_0.rst
PROC_Derivacion_UC_FR_1_0_0.rst
PROC_Crear_Estructura_Tmp_1_0_0.rst
PROC_Revision_UC_Previo_Derivacion_1_0_0.rst
```

---

## 2. ESTADO ACTUAL

### 2.1 PROC Existentes (segun modelo v2.1.0)

```
normativa/procedimientos/
├── PROC_001_Cambio_Requisitos.rst       # Requiere renombrar
├── PROC_002_Revision_Artefactos.rst     # Requiere renombrar
└── PROC_003_Aprobacion_Documentos.rst   # Requiere renombrar
```

**Total existentes:** 3 PROC (nomenclatura antigua)

### 2.2 Procedimientos Ejecutados de Facto (sin PROC formal)

Analizando los transcripts, identifico los procedimientos que hemos ejecutado:

| Procedimiento Ejecutado | Artefactos | Sesion |
|------------------------|------------|--------|
| Revisar UC antes de derivar FR | 49 UC | 2026-01-07 |
| Crear estructura directorios en /tmp | auth/, users/, access/ | 2026-01-07 |
| Crear index.rst por modulo | 8 index.rst | 2026-01-07 |
| Generar FR desde UC | 55 FR | 2026-01-07 |
| Copiar de /tmp a /outputs | Multiples | Todas |
| Generar BR desde BReq | 20 BR | 2026-01-07 |
| Generar UC desde BR | 49 UC | 2025-12-25 |
| Generar STD | 6 STD | 2026-01-07 |
| Generar TPL | 17 TPL | 2026-01-07 |
| Actualizar index.rst | Varios | Todas |
| Crear plan de analisis | Multiples .md | Todas |
| Validar con sphinx-build | - | Todas |

---

## 3. CATALOGO COMPLETO DE PROC NECESARIOS

### 3.1 Categoria: PREPARACION Y APOYO

Procedimientos previos a la generacion de artefactos.

| PROC | Nombre Archivo | Descripcion | Prioridad |
|------|----------------|-------------|-----------|
| PREP-01 | PROC_Revision_UC_Previo_Derivacion_1_0_0.rst | Revisar UC para extraer info antes de derivar FR | P0 |
| PREP-02 | PROC_Revision_TPL_Previo_Generacion_1_0_0.rst | Revisar template antes de crear artefacto | P0 |
| PREP-03 | PROC_Crear_Estructura_Directorios_Tmp_1_0_0.rst | Crear carpetas en /tmp antes de generar | P0 |
| PREP-04 | PROC_Crear_Plan_Analisis_1_0_0.rst | Crear documento de analisis/plan en .md | P1 |

### 3.2 Categoria: GENERACION DE ARTEFACTOS

Procedimientos para crear cada tipo de artefacto.

| PROC | Nombre Archivo | TPL Asociado | Prioridad |
|------|----------------|--------------|-----------|
| GEN-01 | PROC_Generacion_BReq_1_0_0.rst | TPL_BReq | P2 |
| GEN-02 | PROC_Generacion_BR_1_0_0.rst | TPL_BR | P1 |
| GEN-03 | PROC_Generacion_UC_1_0_0.rst | TPL_UC | P1 |
| GEN-04 | PROC_Generacion_FR_1_0_0.rst | TPL_FR | P0 |
| GEN-05 | PROC_Generacion_NFR_1_0_0.rst | TPL_NFR | P1 |
| GEN-06 | PROC_Generacion_TST_1_0_0.rst | TPL_TST | P0 |
| GEN-07 | PROC_Generacion_CNST_1_0_0.rst | TPL_CNST | P2 |
| GEN-08 | PROC_Generacion_MOD_1_0_0.rst | TPL_MOD | P2 |
| GEN-09 | PROC_Generacion_ADR_1_0_0.rst | TPL_ADR | P2 |
| GEN-10 | PROC_Generacion_STD_1_0_0.rst | TPL_STD | P1 |
| GEN-11 | PROC_Generacion_POL_1_0_0.rst | TPL_POL | P2 |
| GEN-12 | PROC_Generacion_FD_1_0_0.rst | TPL_FD | P2 |
| GEN-13 | PROC_Generacion_VIEW_1_0_0.rst | TPL_VIEW | P2 |
| GEN-14 | PROC_Generacion_API_1_0_0.rst | TPL_API | P1 |
| GEN-15 | PROC_Generacion_RTM_1_0_0.rst | TPL_RTM | P1 |
| GEN-16 | PROC_Generacion_Index_1_0_0.rst | TPL_INDEX | P1 |

### 3.3 Categoria: DERIVACION

Procedimientos para derivar artefactos hijos desde padres.

| PROC | Nombre Archivo | Flujo | Ratio | Prioridad |
|------|----------------|-------|-------|-----------|
| DER-01 | PROC_Derivacion_BReq_BR_1_0_0.rst | BReq -> BR | 1:2.5 | P2 |
| DER-02 | PROC_Derivacion_BR_UC_1_0_0.rst | BR -> UC | 1:2.5 | P2 |
| DER-03 | PROC_Derivacion_UC_FR_1_0_0.rst | UC -> FR | 1:8 | P0 |
| DER-04 | PROC_Derivacion_FR_TST_1_0_0.rst | FR -> TST | 1:1 | P0 |
| DER-05 | PROC_Derivacion_FR_CODE_1_0_0.rst | FR -> Codigo | 1:N | P1 |

### 3.4 Categoria: GOBERNANZA DOCUMENTAL

Procedimientos para control del modelo documental.

| PROC | Nombre Archivo | Descripcion | Prioridad |
|------|----------------|-------------|-----------|
| GOB-01 | PROC_Versionado_Semantico_1_0_0.rst | Aplicar STD_006 | P1 |
| GOB-02 | PROC_Congelamiento_Subdominio_1_0_0.rst | Proceso de freeze | P1 |
| GOB-03 | PROC_Descongelamiento_Subdominio_1_0_0.rst | Proceso de unfreeze | P1 |
| GOB-04 | PROC_Actualizacion_Modelo_Documental_1_0_0.rst | Generar nueva version | P0 |
| GOB-05 | PROC_Cambio_Requisitos_1_0_0.rst | (Renombrar PROC_001) | P1 |
| GOB-06 | PROC_Revision_Artefactos_1_0_0.rst | (Renombrar PROC_002) | P1 |
| GOB-07 | PROC_Aprobacion_Documentos_1_0_0.rst | (Renombrar PROC_003) | P1 |

### 3.5 Categoria: TRANSFERENCIA Y PUBLICACION

Procedimientos para mover artefactos y publicar.

| PROC | Nombre Archivo | Descripcion | Prioridad |
|------|----------------|-------------|-----------|
| PUB-01 | PROC_Copiar_Tmp_Outputs_1_0_0.rst | Mover de /tmp a /outputs | P0 |
| PUB-02 | PROC_Validacion_Sphinx_1_0_0.rst | Validar con sphinx-build | P1 |
| PUB-03 | PROC_Publicacion_Documentacion_1_0_0.rst | Publicar docs finales | P2 |

### 3.6 Categoria: TRAZABILIDAD Y VERIFICACION

Procedimientos para verificar consistencia.

| PROC | Nombre Archivo | Descripcion | Prioridad |
|------|----------------|-------------|-----------|
| TRZ-01 | PROC_Verificacion_Cobertura_1_0_0.rst | Validar umbrales RTM | P1 |
| TRZ-02 | PROC_Auditoria_Documental_1_0_0.rst | Verificar consistencia | P2 |
| TRZ-03 | PROC_Identificar_Gaps_Huerfanos_1_0_0.rst | Buscar artefactos sin cobertura | P1 |

---

## 4. RESUMEN CUANTITATIVO

### 4.1 Totales por Categoria

| Categoria | Cantidad | Descripcion |
|-----------|----------|-------------|
| Preparacion y Apoyo | 4 | Procedimientos previos |
| Generacion de Artefactos | 16 | Crear cada tipo |
| Derivacion | 5 | Padre -> Hijo |
| Gobernanza Documental | 7 | Control modelo (3 renombrar) |
| Transferencia y Publicacion | 3 | /tmp -> /outputs |
| Trazabilidad y Verificacion | 3 | Consistencia |
| **TOTAL** | **38** | -- |

### 4.2 Por Prioridad

| Prioridad | Cantidad | PROC Clave |
|-----------|----------|------------|
| **P0 CRITICA** | 8 | Revision_UC, Crear_Estructura_Tmp, Generacion_FR, Generacion_TST, Derivacion_UC_FR, Derivacion_FR_TST, Actualizacion_Modelo, Copiar_Tmp_Outputs |
| **P1 Media** | 17 | Generacion (BR, UC, NFR, STD, API, RTM, Index), Derivacion_FR_CODE, Gobernanza, Validacion_Sphinx, Verificacion_Cobertura |
| **P2 Baja** | 13 | Generacion (BReq, CNST, MOD, ADR, POL, FD, VIEW), Derivacion (BReq_BR, BR_UC), Publicacion, Auditoria |

---

## 5. PLAN DE GENERACION POR FASES

### FASE 1: Criticos - Apoyo y FR/TST (8 PROC)

Procedimientos necesarios para continuar con FR y preparar TST.

| Orden | PROC | Justificacion |
|-------|------|---------------|
| 1 | PROC_Revision_UC_Previo_Derivacion_1_0_0.rst | Primer paso antes de derivar |
| 2 | PROC_Revision_TPL_Previo_Generacion_1_0_0.rst | Revisar template primero |
| 3 | PROC_Crear_Estructura_Directorios_Tmp_1_0_0.rst | Crear carpetas en /tmp |
| 4 | PROC_Generacion_FR_1_0_0.rst | Fase actual: 55/392 FR |
| 5 | PROC_Derivacion_UC_FR_1_0_0.rst | Metodologia de derivacion |
| 6 | PROC_Generacion_TST_1_0_0.rst | Proxima fase |
| 7 | PROC_Derivacion_FR_TST_1_0_0.rst | Preparar testing |
| 8 | PROC_Copiar_Tmp_Outputs_1_0_0.rst | Transferir artefactos |

**Estimacion:** ~2,400-3,200 lineas (300-400 por PROC)

### FASE 2: Gobernanza y Versionado (7 PROC)

| Orden | PROC | Justificacion |
|-------|------|---------------|
| 9 | PROC_Actualizacion_Modelo_Documental_1_0_0.rst | Registrar cambios |
| 10 | PROC_Versionado_Semantico_1_0_0.rst | Usar STD_006 |
| 11 | PROC_Congelamiento_Subdominio_1_0_0.rst | Control de cambios |
| 12 | PROC_Descongelamiento_Subdominio_1_0_0.rst | Control de cambios |
| 13 | PROC_Cambio_Requisitos_1_0_0.rst | Renombrar PROC_001 |
| 14 | PROC_Revision_Artefactos_1_0_0.rst | Renombrar PROC_002 |
| 15 | PROC_Aprobacion_Documentos_1_0_0.rst | Renombrar PROC_003 |

**Estimacion:** ~2,100-2,800 lineas

### FASE 3: Generacion Artefactos Principales (8 PROC)

| Orden | PROC | Justificacion |
|-------|------|---------------|
| 16 | PROC_Generacion_BR_1_0_0.rst | 20 BR existentes |
| 17 | PROC_Generacion_UC_1_0_0.rst | 49 UC existentes |
| 18 | PROC_Generacion_STD_1_0_0.rst | 6 STD existentes |
| 19 | PROC_Generacion_NFR_1_0_0.rst | ~20 NFR pendientes |
| 20 | PROC_Generacion_API_1_0_0.rst | 8 API pendientes |
| 21 | PROC_Generacion_RTM_1_0_0.rst | Trazabilidad |
| 22 | PROC_Generacion_Index_1_0_0.rst | Indices Sphinx |
| 23 | PROC_Crear_Plan_Analisis_1_0_0.rst | Documentos .md |

**Estimacion:** ~2,400-3,200 lineas

### FASE 4: Derivacion y Trazabilidad (8 PROC)

| Orden | PROC | Justificacion |
|-------|------|---------------|
| 24 | PROC_Derivacion_BReq_BR_1_0_0.rst | Retroactivo |
| 25 | PROC_Derivacion_BR_UC_1_0_0.rst | Retroactivo |
| 26 | PROC_Derivacion_FR_CODE_1_0_0.rst | Para implementacion |
| 27 | PROC_Validacion_Sphinx_1_0_0.rst | Validar sintaxis |
| 28 | PROC_Verificacion_Cobertura_1_0_0.rst | Metricas RTM |
| 29 | PROC_Identificar_Gaps_Huerfanos_1_0_0.rst | Buscar faltantes |
| 30 | PROC_Auditoria_Documental_1_0_0.rst | Calidad |
| 31 | PROC_Publicacion_Documentacion_1_0_0.rst | Publicar |

**Estimacion:** ~2,400-3,200 lineas

### FASE 5: Arquitectura y Complementarios (7 PROC)

| Orden | PROC | Justificacion |
|-------|------|---------------|
| 32 | PROC_Generacion_BReq_1_0_0.rst | 8 BReq existentes |
| 33 | PROC_Generacion_CNST_1_0_0.rst | 10 CNST existentes |
| 34 | PROC_Generacion_MOD_1_0_0.rst | 8 MOD existentes |
| 35 | PROC_Generacion_ADR_1_0_0.rst | 5 ADR existentes |
| 36 | PROC_Generacion_FD_1_0_0.rst | 12 FD existentes |
| 37 | PROC_Generacion_VIEW_1_0_0.rst | 5 VIEW existentes |
| 38 | PROC_Generacion_POL_1_0_0.rst | 2 POL existentes |

**Estimacion:** ~2,100-2,800 lineas

---

## 6. ESTRUCTURA DE CADA PROC

Segun TPL_PROC_Procedimientos_1_0_0.rst (577 lineas), cada PROC incluye:

```
0. Meta tags y Resumen Ejecutivo
1. Proposito
2. Alcance
3. Roles y Responsabilidades
4. Precondiciones
5. Artefactos de Entrada
6. Procedimiento (Diagrama PlantUML + Pasos detallados)
7. Artefactos de Salida
8. Postcondiciones
9. Verificacion y Validacion
10. Manejo de Excepciones
11. Referencias
12. Historial de Cambios
```

**Estimacion por PROC:** 300-400 lineas

---

## 7. CATALOGO FINAL DE NOMBRES

### 7.1 Listado Completo (38 PROC)

```
normativa/procedimientos/
├── index.rst
│
├── # PREPARACION Y APOYO (4)
├── PROC_Revision_UC_Previo_Derivacion_1_0_0.rst
├── PROC_Revision_TPL_Previo_Generacion_1_0_0.rst
├── PROC_Crear_Estructura_Directorios_Tmp_1_0_0.rst
├── PROC_Crear_Plan_Analisis_1_0_0.rst
│
├── # GENERACION DE ARTEFACTOS (16)
├── PROC_Generacion_BReq_1_0_0.rst
├── PROC_Generacion_BR_1_0_0.rst
├── PROC_Generacion_UC_1_0_0.rst
├── PROC_Generacion_FR_1_0_0.rst
├── PROC_Generacion_NFR_1_0_0.rst
├── PROC_Generacion_TST_1_0_0.rst
├── PROC_Generacion_CNST_1_0_0.rst
├── PROC_Generacion_MOD_1_0_0.rst
├── PROC_Generacion_ADR_1_0_0.rst
├── PROC_Generacion_STD_1_0_0.rst
├── PROC_Generacion_POL_1_0_0.rst
├── PROC_Generacion_FD_1_0_0.rst
├── PROC_Generacion_VIEW_1_0_0.rst
├── PROC_Generacion_API_1_0_0.rst
├── PROC_Generacion_RTM_1_0_0.rst
├── PROC_Generacion_Index_1_0_0.rst
│
├── # DERIVACION (5)
├── PROC_Derivacion_BReq_BR_1_0_0.rst
├── PROC_Derivacion_BR_UC_1_0_0.rst
├── PROC_Derivacion_UC_FR_1_0_0.rst
├── PROC_Derivacion_FR_TST_1_0_0.rst
├── PROC_Derivacion_FR_CODE_1_0_0.rst
│
├── # GOBERNANZA DOCUMENTAL (7)
├── PROC_Versionado_Semantico_1_0_0.rst
├── PROC_Congelamiento_Subdominio_1_0_0.rst
├── PROC_Descongelamiento_Subdominio_1_0_0.rst
├── PROC_Actualizacion_Modelo_Documental_1_0_0.rst
├── PROC_Cambio_Requisitos_1_0_0.rst
├── PROC_Revision_Artefactos_1_0_0.rst
├── PROC_Aprobacion_Documentos_1_0_0.rst
│
├── # TRANSFERENCIA Y PUBLICACION (3)
├── PROC_Copiar_Tmp_Outputs_1_0_0.rst
├── PROC_Validacion_Sphinx_1_0_0.rst
├── PROC_Publicacion_Documentacion_1_0_0.rst
│
├── # TRAZABILIDAD Y VERIFICACION (3)
├── PROC_Verificacion_Cobertura_1_0_0.rst
├── PROC_Auditoria_Documental_1_0_0.rst
└── PROC_Identificar_Gaps_Huerfanos_1_0_0.rst
```

---

## 8. ESTIMACION TOTAL

| Fase | PROC | Lineas Est. |
|------|------|-------------|
| FASE 1 (Criticos) | 8 | ~3,000 |
| FASE 2 (Gobernanza) | 7 | ~2,500 |
| FASE 3 (Generacion) | 8 | ~3,000 |
| FASE 4 (Derivacion) | 8 | ~3,000 |
| FASE 5 (Arquitectura) | 7 | ~2,500 |
| **TOTAL** | **38** | **~14,000** |

---

## 9. TRACKING DE PROGRESO

### Estado Inicial

```
FASE 1 (Criticos):      --------------------   0% (0/8)
FASE 2 (Gobernanza):    --------------------   0% (0/7)
FASE 3 (Generacion):    --------------------   0% (0/8)
FASE 4 (Derivacion):    --------------------   0% (0/8)
FASE 5 (Arquitectura):  --------------------   0% (0/7)
--------------------------------------------------
TOTAL:                  --------------------   0% (0/38)
```

---

## 10. DIFERENCIAS CON VERSION 1.0.0

| Aspecto | v1.0.0 | v2.0.0 |
|---------|--------|--------|
| Nomenclatura | PROC_NNN_Nombre | PROC_Nombre_X_Y_Z |
| Numeros secuenciales | Si | No |
| Version en nombre | No | Si |
| PROC de apoyo | No incluidos | Incluidos (4) |
| PROC de transferencia | No incluidos | Incluidos (3) |
| Total PROC | 27 | **38** |
| Categorias | 6 | 6 (reorganizadas) |

### 10.1 PROC Nuevos Identificados

| PROC | Razon de inclusion |
|------|-------------------|
| PROC_Revision_UC_Previo_Derivacion | Ejecutado en sesion FR |
| PROC_Revision_TPL_Previo_Generacion | Buena practica documentada |
| PROC_Crear_Estructura_Directorios_Tmp | Ejecutado en sesion FR |
| PROC_Crear_Plan_Analisis | Ejecutado multiples sesiones |
| PROC_Copiar_Tmp_Outputs | Ejecutado en todas las sesiones |
| PROC_Validacion_Sphinx | Ejecutado en todas las sesiones |
| PROC_Publicacion_Documentacion | Paso final |
| PROC_Identificar_Gaps_Huerfanos | Para calidad RTM |

---

## 11. PROXIMA ACCION

**Pregunta:** Proceder con FASE 1 (8 PROC criticos)?

Generare en orden:
1. PROC_Revision_UC_Previo_Derivacion_1_0_0.rst
2. PROC_Revision_TPL_Previo_Generacion_1_0_0.rst
3. PROC_Crear_Estructura_Directorios_Tmp_1_0_0.rst
4. PROC_Generacion_FR_1_0_0.rst
5. PROC_Derivacion_UC_FR_1_0_0.rst
6. PROC_Generacion_TST_1_0_0.rst
7. PROC_Derivacion_FR_TST_1_0_0.rst
8. PROC_Copiar_Tmp_Outputs_1_0_0.rst

---

*Documento: Analisis de Procedimientos PROC v2.0.0*  
*Fecha: 2026-01-07*  
*Proyecto IACT Dashboard Analytics*
