---

## 9. CATÁLOGO DE PREFIJOS

### 9.1 Por Dominio

| Dominio | Prefijos | Cantidad Est. |
|---------|----------|---------------|
| base_cognitiva | META, GLOS, FND, SBVR, TXM, MTM, METH | ~25 |
| requisitos | BR, UC, FR, NFR | ~470 |
| arquitectura_tecnica | MOD, CNST, ADR, VIEW, FD, API, MDL | ~45 |
| normativa | STD, PROC, POL, TPL | ~15 |
| evidencia | TST, RTM, COV | ~12 |
| **TOTAL** | -- | **~567** |

### 9.2 Nomenclatura de Archivos

```
[PREFIJO]_[NNN]_[Nombre_Descriptivo].rst

Ejemplos:
- BR_001_Fuente_Inmutable.rst
- UC_010_Asignar_Roles.rst
- MOD_Auth.rst (sin número, nombre único)
- CNST_001_Comunicaciones_Prohibidas.rst
```

### 9.3 Caso Especial: FR

```
FR_UC[NNN]_[Nombre_UC].rst

El archivo contiene todos los FR del UC.

Ejemplo:
- FR_UC010_Asignar_Roles.rst → contiene FR-010.1 a FR-010.N
```

---

## 10. CONTEO DE ARTEFACTOS

### 10.1 Por Estado

| Estado | Cantidad | % |
|--------|----------|---|
| ✅ COMPLETADOS | 23 | 4% |
| ⏳ IDENTIFICADOS | ~100 | 18% |
| ❌ PENDIENTES | ~444 | 78% |
| **TOTAL** | **~567** | 100% |

### 10.2 Completados

| Tipo | Cantidad | Ubicación |
|------|----------|-----------|
| CNST | 10 | arquitectura_tecnica/restricciones/ |
| FND | 7 | base_cognitiva/_fundamentos_conceptuales/ |
| TXM | 3 | base_cognitiva/_taxonomias_y_metamodelos/taxonomias/ |
| MTM | 3 | base_cognitiva/_taxonomias_y_metamodelos/metamodelos/ |
| **TOTAL** | **23** | -- |

### 10.3 Pendientes Prioritarios

| Tipo | Cantidad | Prioridad |
|------|----------|-----------|
| BR | 20 | 🔴 ALTA (identificadas, falta documentar) |
| UC | 49 | 🔴 ALTA |
| FR | ~400 | 🟡 MEDIA |
| MOD | 8 | 🟡 MEDIA |
| TST | ~320 | 🟢 BAJA |

---

## 11. ORDEN DE EJECUCIÓN

### Fase 1: Business Rules (BR)
```
Prioridad: 🔴 ALTA
Cantidad: 20 documentos
Ubicación: requisitos/reglas_negocio/
Template: TPL_001_Plantilla_BR.rst (ver FND_02 para campos)

Orden:
1. BR_006, BR_007 (actualizadas - alineación RBAC v5.1.1)
2. BR_019, BR_020 (nuevas)
3. BR_001 a BR_018 restantes
4. index.rst con clasificación por tipo
```

### Fase 2: Casos de Uso (UC)
```
Prioridad: 🔴 ALTA
Cantidad: 49 documentos
Ubicación: requisitos/casos_uso/{modulo}/
Template: TPL_002_Plantilla_UC.rst
Actor: Usar Agrupadores (AGR-00x) según mapeo sección 5.2

Por módulo:
1. auth/ (5 UC)
2. users/ (4 UC)
3. access/ (9 UC)
4. pipeline/ (4 UC)
5. reports/ (12 UC)
6. alerts/ (5 UC)
7. audit/ (4 UC)
8. logs/ (3 UC)
```

### Fase 3: Módulos (MOD)
```
Prioridad: 🟡 MEDIA
Cantidad: 8 documentos
Ubicación: arquitectura_tecnica/modulos/
Template: TPL_006_Plantilla_MOD.rst

1. MOD_Auth.rst
2. MOD_Users.rst
3. MOD_Access.rst (con SEC_RULES)
4. MOD_Pipeline.rst
5. MOD_Reports.rst
6. MOD_Alerts.rst
7. MOD_Audit.rst
8. MOD_Logs.rst
```

### Fase 4: Functional Requirements (FR)
```
Prioridad: 🟡 MEDIA
Cantidad: ~400 documentos
Ubicación: requisitos/funcionales/{modulo}/
Template: TPL_003_Plantilla_FR.rst
Criterios: SMART (ver FND_07)

Derivar desde cada UC usando ratio 1:8
```

### Fase 5: Trazabilidad (RTM)
```
Prioridad: 🟡 MEDIA
Cantidad: 2 documentos
Ubicación: evidencia/trazabilidad/
Referencia: FND_04_Trazabilidad.rst (⚠️ PENDIENTE RECREAR)

1. RTM_Master_v1_0_0.rst
2. COV_001_Reporte_Cobertura.rst
```

### Fase 6: Tests (TST)
```
Prioridad: 🟢 BAJA
Cantidad: ~320 documentos
Ubicación: evidencia/pruebas/{modulo}/

Crear para cumplir 80% cobertura FR→TEST
```

---

## 12. ARCHIVOS DE REFERENCIA (NO DOCUMENTACIÓN)

| Archivo | Propósito | Ubicación |
|---------|-----------|-----------|
| REFERENCIA_GLOBAL_MODULOS_IACT.md | Fuente para MOD_.rst | /outputs/ |
| MODELO_RBAC_IACT_v5_1_1.md | Modelo RBAC oficial | /outputs/ |
| ANALISIS_BR_REVISION_INTEGRAL_v1.md | Análisis BR vs RBAC | /outputs/ |
| ANALISIS_FND_vs_MODELO_v2_0_4.md | Análisis alineación FND | /outputs/ |
| MODELO_DOCUMENTAL_IACT_v2_0_5.md | Este documento | /outputs/ |

---

## 13. REFERENCIAS A FND (v2.0.5)

### 13.1 Documentos de Fundamentos Conceptuales

| FND | Título | Uso en Modelo |
|-----|--------|---------------|
| FND_01 | Concepto de Requisito | Base conceptual FR/NFR |
| FND_02 | Reglas de Negocio | **Template BR, 5 tipos, campos** |
| FND_03 | Casos de Uso | Estructura UC, actores (mapear a AGR) |
| FND_04 | Trazabilidad | ⚠️ **PENDIENTE RECREAR** |
| FND_05 | Jerarquía 4 Niveles | BR→BReq→UC→FR (BReq implícito) |
| FND_06 | Derivación vs Transformación | Proceso derivar UC→FR |
| FND_07 | Requerimientos Funcionales | **Criterios SMART, template FR** |

### 13.2 Estado de FND

| FND | Versión | Estado | Notas |
|-----|---------|--------|-------|
| FND_01 | 1.0.0 | ✅ OK | -- |
| FND_02 | 1.1.0 | ✅ OK | Referenciado para template BR |
| FND_03 | 1.1.0 | ⚠️ Desalineado | Actores R00x → AGR-00x (ver 5.2) |
| FND_04 | -- | 🔴 CORRUPTO | Archivo duplicado de FND_03 |
| FND_05 | 1.0.0 | ⚠️ Parcial | BReq implícito en META_04 |
| FND_06 | 1.0.0 | ✅ OK | -- |
| FND_07 | 1.0.0 | ✅ OK | Referenciado para criterios SMART |

---

## 14. RESUMEN DE CAMBIOS v2.0.4 → v2.0.5

### 14.1 Clarificaciones Agregadas

| Sección | Cambio |
|---------|--------|
| 1.3 | NUEVA: Decisión arquitectónica - BReq implícito en META_04 |
| 3.1 | ACTUALIZADO: Diagrama muestra 3 niveles operativos |
| 4.2 | NUEVO: Template BR con referencia a FND_02/TPL_001 |
| 5.2 | NUEVO: Mapeo Actores FND_03 ↔ Agrupadores RBAC |
| 6.1 | AGREGADO: Referencia a criterios SMART (FND_07) |
| 11 | ACTUALIZADO: Referencias a templates en cada fase |
| 13 | NUEVA: Sección completa de referencias a FND |

### 14.2 Notas Técnicas

- FND_04 marcado como PENDIENTE RECREAR (archivo corrupto)
- FND_03 actores: usar mapeo AGR-00x en lugar de R00x
- BReq (Nivel 1): documentado como decisión explícita, no omisión

### 14.3 Cobertura Mantenida

| Métrica | v2.0.4 | v2.0.5 | Cambio |
|---------|--------|--------|--------|
| Total BR | 20 | 20 | = |
| Cobertura CNST→BR | 100% | 100% | = |
| BR alineadas RBAC v5.1.1 | 20 | 20 | = |
| Referencias FND documentadas | 0 | 7 | +7 |

---

*Modelo Documental IACT v2.0.5*  
*Proyecto: IACT Dashboard Analytics*  
*Fecha: 2026-01-03*  
*Base: TXM_01-03 + MTM_01-03 + MODELO_RBAC_v5.1.1 + CNST_001-010 + FND_01-07*
