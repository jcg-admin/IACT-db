---

## 2. MATRIZ DE HALLAZGOS CONSOLIDADA

| ID | Severidad | FND | Descripción | Impacto |
|----|-----------|-----|-------------|---------|
| H-001 | 🟡 MEDIA | FND_02 | Template BR no documentado en modelo | Inconsistencia al crear BR |
| H-002 | 🔴 ALTA | FND_03 | Conflicto Actores (18 Roles) vs Funciones (44 atómicas) | Confusión conceptual |
| H-003 | 🟡 MEDIA | FND_03 | Discrepancia cantidad UC (38 vs 49) | FND desactualizado |
| H-004 | 🟡 MEDIA | FND_03 | Módulos Dashboards/Análisis no existen en modelo | Estructura diferente |
| H-005 | 🔴 CRÍTICA | FND_04 | Archivo corrupto/duplicado de FND_03 | Documento inexistente |
| H-006 | 🔴 ALTA | FND_05 | Nivel 1 (BReq) no implementado en modelo | Gap estructural |
| H-007 | 🟡 MEDIA | FND_05 | Cantidades típicas no coinciden | Referencia incorrecta |
| H-008 | 🟢 BAJA | FND_07 | SMART no referenciado en modelo | Mejora opcional |

---

## 3. ANÁLISIS DE CONFLICTO CRÍTICO: ACTORES vs FUNCIONES

### 3.1 El Problema

**FND_03 (líneas 255-290)** define actores como ROLES con nomenclatura "pretenciosa":
```
R001: USERS_FULL_MANAGER
R008: DASHBOARD_VIEWER
R016: SYSTEM_ADMIN
R017: AUDIT_VIEWER
```

**MODELO v2.0.4 / RBAC v5.1.1** usa FUNCIONES con filosofía "Sin Pretensiones":
```
USR-001: crea_usuarios
RPT-001: ve_reportes
AUD-001: ve_auditoria
```

### 3.2 Análisis de Impacto

| Documento | Usa Roles (R00x) | Usa Funciones (XXX-00x) |
|-----------|-----------------|-------------------------|
| FND_03 | ✅ Exclusivo | ❌ No menciona |
| MODELO v2.0.4 | ❌ No menciona | ✅ Exclusivo |
| RBAC v5.1.1 | ❌ Eliminados | ✅ 44 funciones |
| UC documentados | R00x como actor | Debería usar funciones |

### 3.3 Decisión Requerida

**Opción A: Actualizar FND_03** (RECOMENDADA)
- Cambiar actores de R00x a funciones atómicas
- Alinear con filosofía "Sin Pretensiones"
- Actualizar lista de UC con nuevos 11 identificados

**Opción B: Mantener roles como concepto separado**
- Roles = Agrupadores (AGR-001 a AGR-010)
- Funciones = Permisos atómicos
- Requiere clarificación en ambos documentos

**Opción C: Híbrido**
- FND_03 documenta ACTORES como concepto abstracto
- MODELO implementa actores via AGRUPADORES
- Mapeo explícito: R001 = AGR-001, etc.

---

## 4. ANÁLISIS DEL ERROR FND_04

### 4.1 Evidencia del Error

```rst
Archivo: FND_04_Trazabilidad.rst
Línea 2-3:
   :artefacto: FND_03        ← ERROR (debería ser FND_04)
   :tipo: Fundamento Conceptual

Línea 13:
   .. _fnd-03:               ← ERROR (debería ser _fnd-04)

Línea 15-17:
   ==============================================================
   FND_03: Casos de Uso      ← ERROR (debería ser FND_04: Trazabilidad)
   ==============================================================
```

### 4.2 Contenido Esperado de FND_04

Basado en referencias en otros FND, FND_04 debería contener:

```
FND_04: Trazabilidad
1. Definición de trazabilidad
2. Tipos de enlaces (deriva, influye, genera, verifica)
3. Matriz RTM (Requirements Traceability Matrix)
4. Métricas de cobertura
5. Herramientas de trazabilidad
```

### 4.3 Impacto

- FND_05 línea 543 referencia `:ref:`fnd-04`` → apunta a documento corrupto
- FND_06 línea 488 referencia `:ref:`fnd-04`` → apunta a documento corrupto
- MODELO v2.0.4 sección 6 menciona métricas RTM sin FND de respaldo

---

## 5. ANÁLISIS DEL GAP: NIVEL BReq

### 5.1 El Gap

FND_05 define jerarquía de 4 niveles:
```
Nivel 0: BR (Business Rules)
Nivel 1: BReq (Business Requirements)  ← NO EXISTE EN MODELO
Nivel 2: UC (Use Cases)
Nivel 3: FR (Functional Requirements)
```

MODELO v2.0.4 implementa 3 niveles:
```
requisitos/
├── reglas_negocio/     ← Nivel 0 (BR) ✅
├── casos_uso/          ← Nivel 2 (UC) ✅
├── funcionales/        ← Nivel 3 (FR) ✅
└── no_funcionales/     ← NFR ✅
```

### 5.2 ¿Dónde está BReq?

**Posibilidad 1:** Implícito en META_04_Contexto_IACT.rst
- El contexto del proyecto contiene objetivos de negocio
- No está formalizado como BReq_NNN

**Posibilidad 2:** No se necesita para IACT
- Proyecto interno, no contractual
- BR directamente genera UC
- BReq es redundante

**Posibilidad 3:** Omisión accidental
- Debería existir requisitos/objetivos/
- Falta documentar BReq_001 a BReq_00N

### 5.3 Recomendación

**Opción elegida: Documentar como decisión explícita**

Agregar en MODELO v2.0.5:
```
NOTA: El Nivel 1 (BReq) definido en FND_05 está implícito en 
META_04_Contexto_IACT. Para IACT, la cadena de derivación es:
BR → UC → FR (3 niveles operativos)

Justificación: IACT es proyecto interno donde los objetivos de 
negocio están documentados en el contexto, no requieren 
formalización separada como BReq.
```
