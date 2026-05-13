# 📋 ANÁLISIS DE PROCEDIMIENTOS PENDIENTES
## Proyecto IACT Dashboard Analytics

**Fecha:** 2026-01-07  
**Versión:** 1.0.0  
**Base:** MODELO DOCUMENTAL IACT v2.1.0  
**Propósito:** Identificar todos los procedimientos (PROC) necesarios para gobernar la generación de artefactos del proyecto.

---

## 1. ESTADO ACTUAL DEL PROYECTO

### 1.1 Modelo Documental v2.1.0

| Métrica | Valor | Estado |
|---------|-------|--------|
| BReq documentados | 8 | ✅ |
| BR documentadas | 20 | ✅ |
| UC generados | 49 | ✅ |
| FR generados | 55 | 🔄 14% |
| STD documentados | 5 → **6** | 🆕 |
| PROC existentes | 3 | ⚠️ Insuficientes |
| TPL existentes | 6 | ✅ |
| TST creados | 0 | ⏳ |

### 1.2 Cambios Realizados en Esta Sesión (v2.1.0 → v2.1.1)

| Cambio | Artefacto | Cantidad | Estado |
|--------|-----------|----------|--------|
| 🆕 Nuevo Estándar | STD_006_Versionado_Semantico.rst | 1 | ✅ Generado |
| 🆕 Nuevas BR | BR_011 a BR_020 | 10 | ✅ Generados |
| 🆕 Index Actualizado | reglas_negocio/index.rst | 1 | ✅ Actualizado |

### 1.3 Problema Identificado

Las 10 BR (BR_011 a BR_020) fueron generadas **sin revisar primero el template TPL_001_Plantilla_BR.rst**. 

El procedimiento correcto es:
1. ✅ Revisar template/plantilla correspondiente (TPL_xxx)
2. ✅ Seguir procedimiento de generación (PROC_xxx)
3. ✅ Crear el artefacto

**Nota:** Los artefactos fueron generados correctamente siguiendo el formato de BR_001 existente, pero faltó el paso procedimental formal.

---

## 2. ESTRUCTURA NORMATIVA ACTUAL (v2.1.0)

### 2.1 Dominio normativa/ según modelo

```
normativa/
├── estandares/                              # [DESCONGELADO]
│   ├── STD_001_Suite_Calidad_Codigo.rst
│   ├── STD_002_Metodologia_SBVR_UML_Larman.rst
│   ├── STD_003_Clean_Code_Naming.rst
│   ├── STD_004_Nomenclatura_Proyecto.rst
│   ├── STD_005_Estilo_Documentacion_Sphinx.rst
│   ├── STD_006_Versionado_Semantico.rst     ← 🆕 SESIÓN ACTUAL
│   └── plantillas/
│       ├── TPL_001_Plantilla_BR.rst
│       ├── TPL_002_Plantilla_UC.rst
│       ├── TPL_003_Plantilla_FR.rst
│       ├── TPL_004_Plantilla_ADR.rst
│       ├── TPL_005_Plantilla_CNST.rst
│       └── TPL_006_Plantilla_MOD.rst
│
├── procedimientos/                          # [CONGELADO] ⚠️ SOLO 3
│   ├── PROC_001_Cambio_Requisitos.rst
│   ├── PROC_002_Revision_Artefactos.rst
│   └── PROC_003_Aprobacion_Documentos.rst
│
└── politicas/                               # [CONGELADO]
    ├── POL_001_Seguridad_Informacion.rst
    └── POL_002_Control_Acceso.rst
```

### 2.2 Gap Identificado

| Elemento | Existente | Necesario | Gap |
|----------|-----------|-----------|-----|
| STD | 5 → 6 | 6+ | ✅ Cubierto (STD_006 añadido) |
| TPL | 6 | 6+ | ⚠️ Faltan TPL_007+ |
| PROC | 3 | 15+ | ❌ **Gap crítico: -12** |
| POL | 2 | 2 | ✅ |

---

## 3. CATÁLOGO DE PROCEDIMIENTOS NECESARIOS

### 3.1 Procedimientos de Generación de Artefactos

Cada tipo de artefacto requiere un PROC que defina:
- Precondiciones (template a usar)
- Pasos de generación
- Validación
- Registro en modelo documental

| ID | Nombre | Template | Prioridad | Justificación |
|----|--------|----------|-----------|---------------|
| PROC_004 | Generación de BR | TPL_001 | Alta | Ya generamos 10 BR sin PROC |
| PROC_005 | Generación de UC | TPL_002 | Media | 49 UC ya generados |
| **PROC_006** | **Generación de FR** | TPL_003 | **🔴 CRÍTICA** | **Fase actual: 55/392 FR** |
| PROC_007 | Generación de CNST | TPL_005 | Baja | 10 CNST congelados |
| PROC_008 | Generación de MOD | TPL_006 | Baja | 8 MOD congelados |
| PROC_009 | Generación de ADR | TPL_004 | Baja | 5 ADR existentes |
| PROC_010 | Generación de STD | (nuevo TPL_007) | Media | STD_006 generado sin PROC |
| PROC_011 | Generación de TST | (nuevo TPL_008) | Alta | Próxima fase |

### 3.2 Procedimientos de Derivación

Metodología de cómo derivar artefactos hijos desde padres:

| ID | Nombre | Flujo | Prioridad |
|----|--------|-------|-----------|
| PROC_012 | Derivación BReq → BR | BReq → BR | Baja (ya hecho) |
| PROC_013 | Derivación BR → UC | BR → UC | Baja (ya hecho) |
| **PROC_014** | **Derivación UC → FR** | UC → FR | **🔴 CRÍTICA** |
| PROC_015 | Derivación FR → TST | FR → TST | Alta |
| PROC_016 | Derivación FR → CODE | FR → Código | Media |

### 3.3 Procedimientos de Gobernanza

| ID | Nombre | Descripción | Prioridad |
|----|--------|-------------|-----------|
| PROC_017 | Aplicar Versionado Semántico | Usar STD_006 | Alta |
| PROC_018 | Congelar Subdominio | Proceso de congelamiento | Media |
| PROC_019 | Descongelar Subdominio | Proceso de descongelamiento | Media |
| PROC_020 | Actualizar Modelo Documental | Generar nueva versión | Alta |

### 3.4 Procedimientos de Trazabilidad

| ID | Nombre | Descripción | Prioridad |
|----|--------|-------------|-----------|
| PROC_021 | Generar RTM | Crear matriz de trazabilidad | Alta |
| PROC_022 | Verificar Cobertura | Validar umbrales | Media |

---

## 4. TEMPLATES FALTANTES

| Template | Para | Estado | Prioridad |
|----------|------|--------|-----------|
| TPL_001-006 | BR, UC, FR, ADR, CNST, MOD | ✅ Existen | — |
| **TPL_007** | **STD** | ❌ Falta | Media |
| **TPL_008** | **TST** | ❌ Falta | Alta |
| TPL_009 | BReq | ❌ Falta | Baja |
| TPL_010 | FD (Flujo Datos) | ❌ Falta | Baja |
| TPL_011 | PROC (meta-template) | ❌ Falta | Alta |

---

## 5. RESUMEN EJECUTIVO

### 5.1 Totales

| Categoría | Actual | Necesario | Pendiente |
|-----------|--------|-----------|-----------|
| **PROC** | 3 | 19 | **16** |
| **TPL** | 6 | 11 | **5** |
| **STD** | 6 | 6 | 0 ✅ |
| **Total artefactos normativos** | 11 | 32 | **21** |

### 5.2 Priorización para Fase Actual (FR)

| Prioridad | Artefacto | Justificación |
|-----------|-----------|---------------|
| 🔴 P0 | **PROC_006_Generacion_FR** | Actualmente generando FR |
| 🔴 P0 | **PROC_014_Derivacion_UC_FR** | Metodología de derivación |
| 🟠 P1 | TPL_011_Plantilla_PROC | Para crear otros PROC |
| 🟠 P1 | PROC_020_Actualizar_Modelo | Para v2.1.1 |
| 🟡 P2 | PROC_004_Generacion_BR | Retroactivo (ya generamos BR) |
| 🟡 P2 | PROC_017_Versionado_Semantico | Usar STD_006 |

### 5.3 Deuda Técnica Documental

| Artefacto | Generado Sin PROC | Acción Requerida |
|-----------|-------------------|------------------|
| BR_011 a BR_020 | ✅ Sí | Documentar en historial |
| STD_006 | ✅ Sí | Documentar en historial |
| index.rst (BR) | ✅ Sí | Documentar en historial |
| 55 FR generados | ⚠️ Parcial | Validar contra TPL_003 |

---

## 6. CAMBIOS PARA v2.1.1

### 6.1 Actualización del Árbol normativa/

```
normativa/
├── estandares/
│   ├── STD_001_Suite_Calidad_Codigo.rst
│   ├── STD_002_Metodologia_SBVR_UML_Larman.rst
│   ├── STD_003_Clean_Code_Naming.rst
│   ├── STD_004_Nomenclatura_Proyecto.rst
│   ├── STD_005_Estilo_Documentacion_Sphinx.rst
│   ├── STD_006_Versionado_Semantico.rst          ← 🆕 v2.1.1
│   └── plantillas/
│       └── (sin cambios)
│
├── procedimientos/                               # PENDIENTE EXPANSIÓN
│   ├── PROC_001_Cambio_Requisitos.rst
│   ├── PROC_002_Revision_Artefactos.rst
│   ├── PROC_003_Aprobacion_Documentos.rst
│   └── (PROC_004 a PROC_022 pendientes)
│
└── politicas/
    └── (sin cambios)
```

### 6.2 Actualización de requisitos/reglas_negocio/

```
reglas_negocio/                                   # [CONGELADO] 20 BR ✅
├── index.rst                                     ← 🆕 Actualizado v2.0.0
├── BR_001_Fuente_Operacional_Inmutable.rst
├── BR_002_ETL_Batch_Nocturno.rst
├── BR_003_Usuario_Inactivo_90_Dias.rst
├── BR_004_Comunicaciones_Internas_Only.rst
├── BR_005_Sesion_Unica_Por_Usuario.rst
├── BR_006_RBAC_Flat_NIST.rst
├── BR_007_Separacion_Funciones_SoD.rst
├── BR_008_Auditoria_Accesos.rst
├── BR_009_Bajas_Logicas.rst
├── BR_010_Auditoria_Inmutable.rst
├── BR_011_Limites_Exportacion.rst                ← 🆕 v2.1.1
├── BR_012_Usuario_Segmento_Unico.rst             ← 🆕 v2.1.1
├── BR_013_Username_Unico.rst                     ← 🆕 v2.1.1
├── BR_014_Alerta_Por_Umbral.rst                  ← 🆕 v2.1.1
├── BR_015_Bloqueo_Intentos_Fallidos.rst          ← 🆕 v2.1.1
├── BR_016_Tasa_Abandono.rst                      ← 🆕 v2.1.1
├── BR_017_Tiempo_Promedio_Espera.rst             ← 🆕 v2.1.1
├── BR_018_Indice_Eficiencia.rst                  ← 🆕 v2.1.1
├── BR_019_Retencion_2_Anios.rst                  ← 🆕 v2.1.1
└── BR_020_Clasificacion_Datos.rst                ← 🆕 v2.1.1
```

### 6.3 CHANGELOG para v2.1.1

```markdown
| Versión | Cambio |
|---------|--------|
| **v2.1.1** | **🆕 STD_006_Versionado_Semantico.rst añadido a normativa/estandares/** |
| **v2.1.1** | **🆕 BR_011 a BR_020 generadas (10 BR nuevas)** |
| **v2.1.1** | **🆕 index.rst de reglas_negocio actualizado a v2.0.0** |
| **v2.1.1** | **🆕 Análisis de procedimientos pendientes documentado** |
| **v2.1.1** | **🆕 Total BR: 20 (catálogo completo)** |
| **v2.1.1** | **🆕 Total STD: 6** |
```

---

## 7. PRÓXIMOS PASOS RECOMENDADOS

### Inmediatos (antes de continuar con FR)

1. ✅ **Generar MODELO_DOCUMENTAL_IACT_v2.1.1.md** con cambios de esta sesión
2. ⏳ **Revisar TPL_003_Plantilla_FR.rst** antes de continuar generando FR
3. ⏳ **Crear PROC_006_Generacion_FR.rst** (procedimiento crítico)
4. ⏳ **Crear PROC_014_Derivacion_UC_FR.rst** (metodología)

### Corto Plazo

5. ⏳ Crear TPL_011_Plantilla_PROC.rst (meta-template)
6. ⏳ Crear PROC_004_Generacion_BR.rst (retroactivo)
7. ⏳ Crear PROC_017_Versionado_Semantico.rst

### Mediano Plazo (después de completar FR)

8. ⏳ Crear PROC_011_Generacion_TST.rst
9. ⏳ Crear TPL_008_Plantilla_TST.rst
10. ⏳ Crear PROC_015_Derivacion_FR_TST.rst

---

## 8. MÉTRICAS ACTUALIZADAS (v2.1.1)

| Métrica | v2.1.0 | v2.1.1 | Cambio |
|---------|--------|--------|--------|
| BR documentadas | 20 | 20 | = (archivos añadidos) |
| STD documentados | 5 | **6** | +1 |
| FR generados | 55 | 55 | = |
| PROC existentes | 3 | 3 | = (gap identificado) |
| PROC pendientes | — | **16** | 🆕 Identificados |
| TPL pendientes | — | **5** | 🆕 Identificados |

---

*Documento generado: 2026-01-07*  
*Base: MODELO DOCUMENTAL IACT v2.1.0*  
*Próxima versión: v2.1.1*  
*Proyecto IACT Dashboard Analytics*
