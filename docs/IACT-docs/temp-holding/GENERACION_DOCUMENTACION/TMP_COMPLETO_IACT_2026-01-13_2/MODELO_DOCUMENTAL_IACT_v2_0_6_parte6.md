---

## 15. RESUMEN DE CAMBIOS v2.0.5 → v2.0.6

### 15.1 Cambios Estructurales

| Cambio | Descripción |
|--------|-------------|
| **AGREGADO** | Nueva carpeta `requisitos/objetivos/` para BReq (Nivel 1) |
| **AGREGADO** | Archivo BReq_001_Objetivos_IACT.rst con 5 BReq |
| **CORREGIDO** | Eliminado error "BReq implícito en META_04" |
| **CORREGIDO** | Clarificación META_04 ≠ BReq |
| **ACTUALIZADO** | Jerarquía muestra 4 niveles completos |
| **ACTUALIZADO** | Diagrama de derivación incluye Nivel 1 |
| **AGREGADO** | Sección 3 completa de Business Requirements |
| **ACTUALIZADO** | Conteo de subdominios: 21 → 22 |
| **ACTUALIZADO** | Prefijos incluyen BReq |

### 15.2 Correcciones Conceptuales

| Error en v2.0.5 | Corrección en v2.0.6 |
|-----------------|---------------------|
| "BReq implícito en META_04" | BReq son objetivos medibles, META_04 es contexto |
| Jerarquía 3 niveles | Jerarquía 4 niveles según FND_05 |
| Sin carpeta objetivos/ | Agregada requisitos/objetivos/ |
| BReq no documentados | 5 BReq identificados y trazados a UC |

### 15.3 Nuevos Artefactos Identificados

| Tipo | Cantidad Nueva | Total |
|------|----------------|-------|
| BReq | +5 | 5 |
| UC (reports) | +2 (UC-026, UC-030) | 49 |
| Subdominios | +1 (objetivos/) | 22 |

### 15.4 Alineación con FND

| FND | Estado v2.0.5 | Estado v2.0.6 |
|-----|---------------|---------------|
| FND_01 | ✅ | ✅ |
| FND_02 | ✅ | ✅ |
| FND_03 | ⚠️ Desalineado | ⚠️ Pendiente actualizar FND |
| FND_04 | 🔴 Corrupto | 🔴 Pendiente recrear |
| FND_05 | ❌ Violado (3 niveles) | ✅ Alineado (4 niveles) |
| FND_06 | ✅ | ✅ |
| FND_07 | ✅ | ✅ |

---

## 16. PRÓXIMOS PASOS

### 16.1 Acciones Inmediatas

```
┌─────────────────────────────────────────────────────────────────┐
│ PRIORIDAD CRÍTICA                                               │
├─────────────────────────────────────────────────────────────────┤
│ 1. Recrear FND_04_Trazabilidad.rst (archivo corrupto)          │
│ 2. Documentar BReq_001_Objetivos_IACT.rst completo             │
│ 3. Actualizar FND_03 a v1.2.0 (49 UC, AGR-00x)                 │
└─────────────────────────────────────────────────────────────────┘
```

### 16.2 Acciones de Seguimiento

```
┌─────────────────────────────────────────────────────────────────┐
│ PRIORIDAD ALTA                                                  │
├─────────────────────────────────────────────────────────────────┤
│ 4. Documentar las 20 BR con template FND_02                    │
│ 5. Documentar los 49 UC por módulo                             │
│ 6. Crear RTM_Master inicial                                     │
└─────────────────────────────────────────────────────────────────┘
```

### 16.3 Validación de Consistencia

Después de completar acciones:

- [ ] FND_04 existe y contiene trazabilidad
- [ ] FND_03 v1.2.0 lista 49 UC
- [ ] FND_03 v1.2.0 usa AGR-00x como actores
- [ ] BReq_001 documenta 5 objetivos
- [ ] Todos BReq tienen trazabilidad a UC
- [ ] Todas BR tienen template FND_02

---

## APÉNDICE A: Contenido Esperado de BReq_001

```rst
====================================
BReq_001: Objetivos de Negocio IACT
====================================

.. meta::
   :artefacto: BReq_001
   :tipo: Business Requirement
   :dominio: requisitos
   :subdominio: objetivos
   :estado: Aprobado
   :version: 1.0.0

1. BReq-001: Visibilidad de Métricas IVR
----------------------------------------

**Declaración:**
El Sistema IACT Dashboard Analytics DEBE proporcionar visibilidad 
en tiempo real de las métricas de llamadas del IVR.

**Métrica de Éxito:** Dashboard actualizado cada 5 minutos

**UC Relacionados:** UC-025, UC-026, UC-027, UC-028, UC-029, UC-030

**BR que Influyen:** BR_001, BR_002

---

2. BReq-002: Reducción de Tiempo de Incidentes
----------------------------------------------

**Declaración:**
El Sistema DEBE reducir el tiempo de resolución de incidentes 
operacionales en al menos 40% respecto a la línea base.

**Métrica de Éxito:** Tiempo promedio resolución ≤ 60% del actual

**UC Relacionados:** UC-036, UC-037, UC-038, UC-039, UC-040

**BR que Influyen:** BR_014

---

3. BReq-003: Decisiones Informadas
----------------------------------

**Declaración:**
El Sistema DEBE permitir a los supervisores identificar problemas 
operacionales y tomar decisiones basadas en datos verificables.

**Métrica de Éxito:** 100% decisiones con respaldo de datos

**UC Relacionados:** UC-017 a UC-024

**BR que Influyen:** BR_016, BR_017, BR_018

---

4. BReq-004: Cumplimiento de Seguridad
--------------------------------------

**Declaración:**
El Sistema DEBE garantizar control de acceso basado en roles (RBAC) 
y auditoría completa de todas las operaciones críticas.

**Métrica de Éxito:** 0 accesos no autorizados detectados

**UC Relacionados:** UC-010, UC-011, UC-043-047, UC-060-063

**BR que Influyen:** BR_006, BR_007, BR_010

---

5. BReq-005: Integridad de Datos Operacionales
----------------------------------------------

**Declaración:**
El Sistema DEBE proteger la base de datos operacional (MySQL) 
de cualquier operación de escritura no autorizada.

**Métrica de Éxito:** 0 escrituras desde IACT a MySQL operacional

**UC Relacionados:** UC-050, UC-051, UC-052

**BR que Influyen:** BR_001
```

---

*Modelo Documental IACT v2.0.6*  
*Proyecto: IACT Dashboard Analytics*  
*Fecha: 2026-01-03*  
*Base: TXM_01-03 + MTM_01-03 + MODELO_RBAC_v5.1.1 + CNST_001-010 + FND_01-07*
