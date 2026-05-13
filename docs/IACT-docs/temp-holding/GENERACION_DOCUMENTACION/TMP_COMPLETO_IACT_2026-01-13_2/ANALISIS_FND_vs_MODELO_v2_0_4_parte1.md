# ANÁLISIS DE ALINEACIÓN: FND_01-07 vs MODELO_DOCUMENTAL_IACT_v2.0.4

**Fecha:** 2026-01-03  
**Objetivo:** Determinar si el MODELO_DOCUMENTAL necesita actualización a v2.1.4  
**Artefactos Analizados:** 7 FND + MODELO_DOCUMENTAL_IACT_v2.0.4

---

## RESUMEN EJECUTIVO

| Resultado | Decisión |
|-----------|----------|
| **SE REQUIERE ACTUALIZACIÓN** | v2.0.4 → **v2.0.5** |
| Severidad | 🟡 MEDIA (inconsistencias, no errores críticos) |
| FND con desalineación | 4 de 7 (57%) |
| FND alineados | 3 de 7 (43%) |

**Nota:** La actualización propuesta es v2.0.5 (no v2.1.4) porque los cambios son correcciones menores, no cambios estructurales que justifiquen incremento de minor version.

---

## 1. ANÁLISIS POR DOCUMENTO FND

### 1.1 FND_01: Concepto de Requisito

**Versión FND:** 1.0.0 (2025-12-19)  
**Estado:** ✅ ALINEADO

| Aspecto | FND_01 dice | MODELO v2.0.4 dice | Alineación |
|---------|-------------|-------------------|------------|
| Tipos requisitos | FR y NFR | FR y NFR en requisitos/ | ✅ |
| Prefijos | BR, UC, FR, NFR | BR, UC, FR, NFR | ✅ |
| Ubicación FR | requisitos/funcionales/ | requisitos/funcionales/{modulo}/ | ✅ |
| Nomenclatura | FR-NNN.X | FR_UC[NNN]_xxx.rst | ✅ |

**Hallazgos:** Ninguno. Documento base conceptual alineado.

---

### 1.2 FND_02: Reglas de Negocio

**Versión FND:** 1.1.0 (2025-12-21)  
**Estado:** ⚠️ DESALINEACIÓN PARCIAL

| Aspecto | FND_02 dice | MODELO v2.0.4 dice | Alineación |
|---------|-------------|-------------------|------------|
| 5 tipos BR | Fact, Constraint, Trigger, Inference, Calculation | Hecho, Restricción, Desencadenador, Inferencia, Cálculo | ✅ |
| Cantidad BR | ~15-20 típico | 20 BR identificadas | ✅ |
| Nomenclatura | BR_NNN_Nombre.rst | BR_NNN_Nombre.rst | ✅ |
| Campos obligatorios | Definición, Tipo, Modalidad, Fuente, Fecha Vigencia | **NO DOCUMENTADO** en modelo | ❌ |
| Campos adicionales | Prioridad, Estática/Dinámica, Justificación, Ejemplo | **NO DOCUMENTADO** en modelo | ❌ |

**Hallazgo H-001:** 🔴 DESALINEACIÓN
- FND_02 define template completo con 9 campos para cada BR
- MODELO v2.0.4 solo lista BR sin especificar campos requeridos
- **Impacto:** Al documentar las 20 BR, no hay guía de qué campos incluir

**Acción requerida:** Agregar sección "Template BR" en MODELO v2.0.5 o referenciar TPL_001_Plantilla_BR.rst

---

### 1.3 FND_03: Casos de Uso

**Versión FND:** 1.1.0 (2025-12-21)  
**Estado:** ⚠️ DESALINEACIÓN SIGNIFICATIVA

| Aspecto | FND_03 dice | MODELO v2.0.4 dice | Alineación |
|---------|-------------|-------------------|------------|
| Cantidad UC | 38 identificados | 49 identificados | ❌ |
| Actores RBAC | 18 roles (R001-R018) | 44 funciones atómicas | ❌ CONFLICTO |
| Categorías módulos | Usuarios, Reportes, Dashboards, Análisis, Alertas, Admin | Auth, Users, Access, Pipeline, Reports, Alerts, Audit, Logs | ⚠️ PARCIAL |
| Técnicas derivación UC | 5 técnicas (22%/40%/22%/11%/5%) | No documentado | ❌ |
| UC por módulo | 7+8+6+5+5+7 = 38 | 5+4+9+4+12+5+4+3 = 46 visibles | ⚠️ |

**Hallazgo H-002:** 🔴 CONFLICTO CRÍTICO - Actores vs Funciones
- FND_03 define actores como 18 ROLES (R001-R018): USERS_FULL_MANAGER, DASHBOARD_VIEWER, etc.
- MODELO v2.0.4/RBAC v5.1.1 usa 44 FUNCIONES ATÓMICAS: crea_usuarios, ve_reportes, etc.
- **Filosofía "Sin Pretensiones" contradice nomenclatura FND_03**

**Hallazgo H-003:** 🟡 DISCREPANCIA - Cantidad UC
- FND_03: 38 UC identificados
- MODELO v2.0.4: 49 UC identificados
- Diferencia: +11 UC no documentados en FND_03

**Hallazgo H-004:** 🟡 MÓDULOS DIFERENTES
- FND_03 menciona: Dashboards (6 UC), Análisis (5 UC)
- MODELO v2.0.4 NO tiene módulo MOD_Dashboard ni MOD_Analysis
- UC-025 a UC-035 están en "reports/" pero FND_03 los separa

---

### 1.4 FND_04: Trazabilidad

**Versión FND:** 1.0.0 (2025-12-19)  
**Estado:** 🔴 ERROR CRÍTICO - ARCHIVO CORRUPTO

**Hallazgo H-005:** 🔴 ARCHIVO DUPLICADO
```
FND_04_Trazabilidad.rst contiene el contenido de FND_03_Casos_de_Uso.rst
- Línea 3: :artefacto: FND_03 (debería ser FND_04)
- Línea 13: .. _fnd-03: (debería ser _fnd-04)
- Título: FND_03: Casos de Uso (debería ser FND_04: Trazabilidad)
```

**Impacto:** 
- FND_04 no existe realmente
- No hay documento de Trazabilidad en fundamentos conceptuales
- Referencias cruzadas en FND_05 y FND_06 apuntan a documento inexistente

**Acción CRÍTICA:** Crear FND_04_Trazabilidad.rst con contenido correcto
