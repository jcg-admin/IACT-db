# 📋 PLAN DE GENERACIÓN DE TEMPLATES (TPL)
## Proyecto IACT Dashboard Analytics

**Fecha:** 2026-01-07  
**Versión del Plan:** 1.0.0  
**Total TPL:** 17  
**Existentes:** 1 (requiere renombrar)  
**Por Generar:** 16  

---

## 1. NOMENCLATURA OFICIAL

### 1.1 Formato de Nombre de Archivo

```
TPL_[PREFIJO]_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].rst
```

### 1.2 Reglas

| Elemento | Regla | Ejemplo |
|----------|-------|---------|
| `TPL_` | Prefijo fijo obligatorio | TPL_ |
| `[PREFIJO]` | Código del artefacto (2-4 chars) | BR, UC, FR, PROC |
| `[Nombre_Descriptivo]` | Nombre legible con guiones bajos | Business_Rules |
| `[MAJOR]_[MINOR]_[PATCH]` | Versionado semántico con guiones bajos | 1_0_0 |
| `.rst` | Extensión ReStructuredText | .rst |

### 1.3 Ejemplos

```
TPL_BR_Business_Rules_1_0_0.rst
TPL_UC_Casos_de_Uso_2_0_0.rst
TPL_FR_Requisitos_Funcionales_1_0_0.rst
TPL_PROC_Procedimientos_1_0_0.rst
```

---

## 2. CATÁLOGO COMPLETO DE 17 TPL

| # | Archivo | Artefacto | Estado |
|---|---------|-----------|--------|
| 1 | TPL_BR_Business_Rules_1_0_0.rst | BR_xxx | ⏳ Pendiente |
| 2 | TPL_UC_Casos_de_Uso_2_0_0.rst | UC_xxx | 🔄 Renombrar |
| 3 | TPL_FR_Requisitos_Funcionales_1_0_0.rst | FR_xxx | ⏳ Pendiente |
| 4 | TPL_CNST_Restricciones_1_0_0.rst | CNST_xxx | ⏳ Pendiente |
| 5 | TPL_MOD_Modulos_1_0_0.rst | MOD_xxx | ⏳ Pendiente |
| 6 | TPL_ADR_Decisiones_Arquitectonicas_1_0_0.rst | ADR_xxx | ⏳ Pendiente |
| 7 | TPL_STD_Estandares_1_0_0.rst | STD_xxx | ⏳ Pendiente |
| 8 | TPL_BReq_Objetivos_Negocio_1_0_0.rst | BReq_xxx | ⏳ Pendiente |
| 9 | TPL_TST_Pruebas_1_0_0.rst | TST_xxx | ⏳ Pendiente |
| 10 | TPL_FD_Flujos_Datos_1_0_0.rst | FD_xxx | ⏳ Pendiente |
| 11 | TPL_PROC_Procedimientos_1_0_0.rst | PROC_xxx | ⏳ Pendiente |
| 12 | TPL_POL_Politicas_1_0_0.rst | POL_xxx | ⏳ Pendiente |
| 13 | TPL_RTM_Trazabilidad_1_0_0.rst | RTM_xxx | ⏳ Pendiente |
| 14 | TPL_NFR_No_Funcionales_1_0_0.rst | NFR_xxx | ⏳ Pendiente |
| 15 | TPL_VIEW_Vistas_Arquitectonicas_1_0_0.rst | VIEW_xxx | ⏳ Pendiente |
| 16 | TPL_API_Documentacion_API_1_0_0.rst | API_xxx | ⏳ Pendiente |
| 17 | TPL_INDEX_Indices_1_0_0.rst | index.rst | ⏳ Pendiente |

---

## 3. PLAN POR FASES

### FASE 1: Templates Críticos (Prioridad P0)
**Justificación:** Necesarios para la fase actual de generación FR y procedimientos pendientes.

| # | TPL | Justificación | Líneas Est. |
|---|-----|---------------|-------------|
| 1 | TPL_FR_Requisitos_Funcionales_1_0_0.rst | 55 FR generados, ~337 pendientes | ~200 |
| 2 | TPL_BR_Business_Rules_1_0_0.rst | 20 BR generadas (retroactivo) | ~250 |
| 3 | TPL_PROC_Procedimientos_1_0_0.rst | 16 PROC identificados pendientes | ~180 |
| 4 | TPL_TST_Pruebas_1_0_0.rst | Próxima fase después de FR | ~220 |

**Subtotal Fase 1:** 4 TPL (~850 líneas)

---

### FASE 2: Templates de Requisitos (Prioridad P1)
**Justificación:** Completan el dominio de requisitos.

| # | TPL | Justificación | Líneas Est. |
|---|-----|---------------|-------------|
| 5 | TPL_BReq_Objetivos_Negocio_1_0_0.rst | 8 BReq existentes | ~150 |
| 6 | TPL_NFR_No_Funcionales_1_0_0.rst | ~20 NFR existentes | ~180 |
| 7 | TPL_UC_Casos_de_Uso_2_0_0.rst | Renombrar existente | ~500 (existente) |

**Subtotal Fase 2:** 3 TPL (~330 líneas nuevas + 500 renombrado)

---

### FASE 3: Templates de Arquitectura (Prioridad P2)
**Justificación:** Documentación técnica y de diseño.

| # | TPL | Justificación | Líneas Est. |
|---|-----|---------------|-------------|
| 8 | TPL_CNST_Restricciones_1_0_0.rst | 10 CNST congeladas | ~180 |
| 9 | TPL_MOD_Modulos_1_0_0.rst | 8 MOD congelados | ~200 |
| 10 | TPL_ADR_Decisiones_Arquitectonicas_1_0_0.rst | 5 ADR existentes | ~220 |
| 11 | TPL_FD_Flujos_Datos_1_0_0.rst | 12 FD existentes | ~180 |
| 12 | TPL_VIEW_Vistas_Arquitectonicas_1_0_0.rst | 5 VIEW existentes | ~150 |
| 13 | TPL_API_Documentacion_API_1_0_0.rst | 8 API existentes | ~250 |

**Subtotal Fase 3:** 6 TPL (~1,180 líneas)

---

### FASE 4: Templates de Gobernanza (Prioridad P3)
**Justificación:** Normativa y evidencia.

| # | TPL | Justificación | Líneas Est. |
|---|-----|---------------|-------------|
| 14 | TPL_STD_Estandares_1_0_0.rst | 6 STD existentes | ~180 |
| 15 | TPL_POL_Politicas_1_0_0.rst | 2 POL existentes | ~150 |
| 16 | TPL_RTM_Trazabilidad_1_0_0.rst | RTM pendiente | ~200 |
| 17 | TPL_INDEX_Indices_1_0_0.rst | Índices de subdominios | ~120 |

**Subtotal Fase 4:** 4 TPL (~650 líneas)

---

## 4. RESUMEN DEL PLAN

### 4.1 Por Fase

| Fase | Prioridad | TPL | Líneas Est. | Estado |
|------|-----------|-----|-------------|--------|
| FASE 1 | P0 - Críticos | 4 | ~850 | ⏳ Pendiente |
| FASE 2 | P1 - Requisitos | 3 | ~330 | ⏳ Pendiente |
| FASE 3 | P2 - Arquitectura | 6 | ~1,180 | ⏳ Pendiente |
| FASE 4 | P3 - Gobernanza | 4 | ~650 | ⏳ Pendiente |
| **TOTAL** | — | **17** | **~3,010** | — |

### 4.2 Orden de Ejecución

```
FASE 1 (P0 - Críticos)
├── 1. TPL_FR_Requisitos_Funcionales_1_0_0.rst      ← PRIMERO
├── 2. TPL_BR_Business_Rules_1_0_0.rst
├── 3. TPL_PROC_Procedimientos_1_0_0.rst
└── 4. TPL_TST_Pruebas_1_0_0.rst

FASE 2 (P1 - Requisitos)
├── 5. TPL_BReq_Objetivos_Negocio_1_0_0.rst
├── 6. TPL_NFR_No_Funcionales_1_0_0.rst
└── 7. TPL_UC_Casos_de_Uso_2_0_0.rst               ← Renombrar

FASE 3 (P2 - Arquitectura)
├── 8. TPL_CNST_Restricciones_1_0_0.rst
├── 9. TPL_MOD_Modulos_1_0_0.rst
├── 10. TPL_ADR_Decisiones_Arquitectonicas_1_0_0.rst
├── 11. TPL_FD_Flujos_Datos_1_0_0.rst
├── 12. TPL_VIEW_Vistas_Arquitectonicas_1_0_0.rst
└── 13. TPL_API_Documentacion_API_1_0_0.rst

FASE 4 (P3 - Gobernanza)
├── 14. TPL_STD_Estandares_1_0_0.rst
├── 15. TPL_POL_Politicas_1_0_0.rst
├── 16. TPL_RTM_Trazabilidad_1_0_0.rst
└── 17. TPL_INDEX_Indices_1_0_0.rst
```

---

## 5. ESTRUCTURA DE CADA TPL

### 5.1 Secciones Estándar (Todas las TPL)

Cada plantilla contendrá:

```rst
.. meta::
   :artefacto: TPL_[XXX]
   :tipo: Plantilla
   :dominio: normativa
   :subdominio: estandares/plantillas
   :estado: Aprobado
   :version: [X.Y.Z]
   :fecha_creacion: [YYYY-MM-DD]
   :autor: Equipo IACT

1. Propósito
2. Requisitos Técnicos (si aplica)
3. Instrucciones de Uso
4. Nomenclatura
5. Plantilla (código rst a copiar)
6. Secciones Obligatorias del Artefacto
7. Validación
8. Referencias
9. Historial de Cambios
```

### 5.2 Contenido Específico por TPL

| TPL | Secciones Específicas |
|-----|----------------------|
| TPL_FR | Criterios DADO/CUANDO/ENTONCES, Trazabilidad UC |
| TPL_BR | Formulación SBVR, Clasificación 5 tipos TXM_03 |
| TPL_PROC | Precondiciones, Pasos, Postcondiciones, Roles |
| TPL_TST | Casos de prueba, Datos de prueba, Resultados esperados |
| TPL_UC | 3 diagramas PlantUML obligatorios |
| TPL_ADR | Contexto, Decisión, Consecuencias |
| TPL_API | Endpoints, Request/Response, Códigos HTTP |

---

## 6. ENTREGABLES POR FASE

### FASE 1 - Entregables

| Entregable | Descripción |
|------------|-------------|
| TPL_FR_Requisitos_Funcionales_1_0_0.rst | Plantilla para ~392 FR |
| TPL_BR_Business_Rules_1_0_0.rst | Plantilla para BR (retroactivo) |
| TPL_PROC_Procedimientos_1_0_0.rst | Plantilla para 16+ PROC |
| TPL_TST_Pruebas_1_0_0.rst | Plantilla para ~314 TST |

### FASE 2 - Entregables

| Entregable | Descripción |
|------------|-------------|
| TPL_BReq_Objetivos_Negocio_1_0_0.rst | Plantilla para BReq |
| TPL_NFR_No_Funcionales_1_0_0.rst | Plantilla para NFR |
| TPL_UC_Casos_de_Uso_2_0_0.rst | Renombrado de existente |

### FASE 3 - Entregables

| Entregable | Descripción |
|------------|-------------|
| 6 TPL de arquitectura | CNST, MOD, ADR, FD, VIEW, API |

### FASE 4 - Entregables

| Entregable | Descripción |
|------------|-------------|
| 4 TPL de gobernanza | STD, POL, RTM, INDEX |

---

## 7. CRITERIOS DE COMPLETITUD

### 7.1 Checklist por TPL

- [ ] Archivo creado con nomenclatura correcta
- [ ] Meta tags completos
- [ ] Todas las secciones estándar presentes
- [ ] Código de plantilla copiable
- [ ] Ejemplos de uso incluidos
- [ ] Referencias a artefactos relacionados
- [ ] Historial de cambios iniciado
- [ ] Validación Sphinx exitosa

### 7.2 Checklist por Fase

- [ ] Todos los TPL de la fase generados
- [ ] index.rst de plantillas actualizado
- [ ] MODELO_DOCUMENTAL actualizado
- [ ] Verificación cruzada de referencias

---

## 8. TRACKING DE PROGRESO

### Estado Inicial

```
FASE 1: ░░░░░░░░░░░░░░░░░░░░   0% (0/4)
FASE 2: ░░░░░░░░░░░░░░░░░░░░   0% (0/3)  [1 renombrar]
FASE 3: ░░░░░░░░░░░░░░░░░░░░   0% (0/6)
FASE 4: ░░░░░░░░░░░░░░░░░░░░   0% (0/4)
─────────────────────────────────────
TOTAL:  ░░░░░░░░░░░░░░░░░░░░   0% (0/17)
```

### Actualizar después de cada generación

---

## 9. PRÓXIMA ACCIÓN

**¿Proceder con FASE 1?**

Generaré en orden:
1. `TPL_FR_Requisitos_Funcionales_1_0_0.rst`
2. `TPL_BR_Business_Rules_1_0_0.rst`
3. `TPL_PROC_Procedimientos_1_0_0.rst`
4. `TPL_TST_Pruebas_1_0_0.rst`

---

*Plan de Generación TPL v1.0.0*  
*Proyecto IACT Dashboard Analytics*  
*Fecha: 2026-01-07*
