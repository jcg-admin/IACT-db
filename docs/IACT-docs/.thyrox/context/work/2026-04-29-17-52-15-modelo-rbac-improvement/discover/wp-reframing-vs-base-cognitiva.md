```yml
created_at: 2026-04-29 18:50:00
project: IACT-docs
work_package: 2026-04-29-17-52-15-modelo-rbac-improvement
phase: Phase 1 — DISCOVER (reframing)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# WP Reframing — Naturaleza del trabajo según la base cognitiva

## Premisa que clarifica el ejecutor

> "Todo lo que se menciona en source aún no ha sido implementado.
> Todo se está considerando de manera abstracta, para que cuando se
> implemente, se implemente de manera correcta."

Esta clarificación obliga a reconsiderar QUÉ tipo de trabajo es este
WP, y cómo el resultado contribuye al sistema final.

## Lo que dice la base cognitiva

### FND-01 — Concepto de Requisito

| Aspecto | Requisito | Especificación |
|---------|-----------|----------------|
| **Nivel** | QUE debe hacerse | CÓMO debe hacerse |
| **Abstracción** | Más abstracta | Más concreta |
| **Ejemplo IACT** | "Sistema DEBE controlar acceso por funciones" | "El control se implementa con tabla `function_groups`..." |

### FND-05 — Jerarquía de 4 niveles de requisitos

```
   Nivel 0          Nivel 1          Nivel 2          Nivel 3
   BR (Reglas)  →   BReq (Obj.)  →   UC (Casos)   →   FR (Func.)
   ── más abstracto ───────────────── más concreto ──>
```

Después del nivel 3 (FR) viene **CÓDIGO + TESTS** (implementación).

### FND-00 — Niveles de transformación

```
Business Requirements (BReq)
        ↓
Business Rules (BR)
        ↓
Use Cases (UC)
        ↓
Functional Requirements (FR)
        ↓
CODE + TESTS
```

## Clasificación taxonómica del trabajo del WP

### ¿Es `modelo-rbac-iact.rst` un requerimiento?

**NO en sentido estricto.** El archivo vive en
`source/arquitectura-tecnica/rbac/`, NO en `source/requisitos/`. Per
la taxonomía del proyecto:

| Capa | Ubicación | Contenido | Este WP toca? |
|------|-----------|-----------|---------------|
| **Requirements (Niveles 0-3)** | `source/requisitos/` | BR, BReq, UC, FR | NO directamente |
| **Specifications / Architecture** | `source/arquitectura-tecnica/` | Modelos, módulos, contratos | **SÍ — este WP** |
| **Constraints normativas** | `source/normativa/restricciones/` | CNSTs | indirectamente (cross-refs) |
| **Decisions arquitectónicas** | `source/normativa/gobernanza/` | ADRs | **SÍ (Inc-01..Inc-05)** |
| **Fundamentos conceptuales** | `source/base-cognitiva/` | FNDs, MTMs, glosario | indirectamente |
| **Implementación** | (no existe en source/) | Código + tests | NO (no implementado) |

### Entonces, ¿qué somos haciendo?

**Estamos refinando la capa de ESPECIFICACIÓN abstracta del subsistema
RBAC** — es decir, la respuesta al "CÓMO" que el sistema debe cumplir
cuando se implemente.

NO estamos derivando requisitos nuevos (BR, BReq, UC, FR — esos viven
en `requisitos/`).
NO estamos implementando código.
**SÍ estamos consolidando la spec arquitectónica** que será input para
la futura implementación.

## Implicación crítica de la abstracción total

Si **nada está implementado**, entonces:

1. **No hay "código real" que el modelo describa.** El modelo NO está
   describiendo un sistema existente — está **diseñando** uno futuro.
2. **El código embebido en `modelo-rbac-iact.rst`** (39% del archivo:
   DDL SQL, Models Django, Service, Decorator, Middleware) es **spec
   ejemplificativa**, no código real running. Igualmente útil como
   "diseño de referencia para el implementador" — pero hay que
   etiquetarlo como tal.
3. **Las inconsistencias Inc-01..Inc-05 son CRÍTICAS:** si el
   implementador toma como input ADR-BACK-001 (cita "19 funciones /
   130+ capacidades"), implementará el sistema legacy, contradiciendo
   modelo v5.2.1 + ADR-GOB-008. **El corpus inconsistente induce
   implementación incorrecta.**
4. **La trazabilidad bidireccional (Inc-05) es esencial** porque sin
   ella, el implementador no encuentra todos los CNSTs/ADRs aplicables
   a la sección que está implementando.

## Reframe de la pregunta del scope

### Antes (asumiendo "fix de un doc")

| Op | Costo | Beneficio |
|----|-------|-----------|
| X | 4-6h | Modelo coherente |
| Y | 1-2 sesiones | Modelo + ADR-BACK |
| Z | 3-4 sesiones | Reorg completa |

### Ahora (asumiendo "asegurar implementabilidad correcta")

| Op | Riesgo de implementación incorrecta |
|----|--------------------------------------|
| X | **ALTO** — los ADR-BACK legacy contradicen v5.2.1; implementador puede seguir cualquiera |
| Y | **MEDIO** — modelo + ADRs alineados, pero modelo y ARQ_MOD_003 siguen duplicando |
| Z | **BAJO** — single source of truth + bidireccional |

**El user no contrata "limpieza estética" — contrata "spec
implementable sin ambigüedad".** Y es el **mínimo aceptable**; Z es
lo correcto.

## Vocabulario correcto

Aplicando el vocabulario canónico del proyecto, este WP es un trabajo
de:

- **Specification refinement** (no "requirement engineering"
  estrictamente).
- **Cross-artifact consistency** entre arquitectura, normativa
  (CNSTs + ADRs) y fundamentos.
- **Pre-implementation hardening** del corpus para garantizar
  que la fase de codificación futura tenga ground truth única.

Esto encaja en la **Phase 7 DESIGN/SPECIFY** de THYROX (no Phase 1
DISCOVER de un nuevo requirement).

## Implicaciones operativas

### Sobre el código embebido en modelo-rbac-iact (Cat. C del gap analysis)

Re-evaluación: el código embebido NO es duplicación de implementación
existente (no hay implementación). Es **spec ejemplificativa de
referencia**. Acciones razonables:

1. **Mantenerlo** — es valor para el implementador.
2. **Etiquetarlo claramente** como "Reference design — to be implemented"
   (no como "implementación actual").
3. **Asegurar consistencia** entre el código de referencia y los CNSTs/
   ADRs vigentes (CNST-033 vocabulary, ADR-GOB-008 coexistencia).

C-03 baja de CRITICAL → MAJOR (no es "código real desincronizado",
es "diseño de referencia que necesita actualización").

### Sobre los ADR-BACK-001/003/004 legacy (Inc-01..Inc-03)

CRITICAL para implementabilidad. Antes de cualquier implementación:

- **Inc-01:** ADR-BACK-001 cita "19 funciones / 130+ capacidades" —
  contradice v5.2.1.
- **Inc-02:** "Capacidad" prohibido por CNST-033 vigente.
- **Inc-03:** Notas "pendiente validar" en ADRs aceptados.

**Acción recomendada:** supersede formal con ADRs nuevos (ADR-GOB-NNN)
que declaren los ADR-BACK como deprecados, alineados al modelo v5.2.1
y CNST-033.

### Sobre ARQ_MOD_003 vs modelo-rbac-iact (Inc-04)

Si el WP solo "mejora el modelo" sin reconciliar con ARQ_MOD_003,
queda **dos artefactos describiendo el mismo subsistema** — el
implementador puede seguir cualquiera de los dos. CRITICAL para
implementabilidad.

## Recomendación recalibrada

**Opción Z** (refactor completo) **es el mínimo correcto** dado el
framing real:

- Sin Z, queda corpus inconsistente que **garantiza implementación
  divergente** del intent del proyecto.
- El costo (3-4 sesiones) es proporcional al riesgo evitado
  (implementación incorrecta de un sistema crítico de seguridad).

Si el ejecutor prefiere granularidad, **Z se puede partir en sub-WPs
secuenciales:**

1. **Z.1 — ADR superseding** (Inc-01..Inc-03)
   Crear ADR-GOB-NNN que supersede los 3 ADR-BACK + alinear con
   modelo v5.2.1 + CNST-033.

2. **Z.2 — Modelo conceptual cleanup** (sub-set de findings F-01..F-21)
   Modelo vuelve a ser conceptual puro; código de ref etiquetado
   como tal.

3. **Z.3 — Reconciliación modelo ↔ ARQ_MOD_003** (Inc-04)
   Definir clear ownership: ¿modelo conceptual + ARQ_MOD_003 spec
   técnica? ¿o consolidar?

4. **Z.4 — Trazabilidad bidireccional** (Inc-05)
   Cross-refs en ambos sentidos modelo ↔ ADRs ↔ CNSTs ↔ UCs.

5. **Z.5 — Validation final**
   Deep-review adversarial para confirmar single source of truth.

## Pregunta para el ejecutor

Dado el framing real del proyecto (todo abstracto, nada implementado):

1. ¿Confirmas que el objetivo es **garantizar implementabilidad
   correcta** del sistema RBAC futuro, no solo "limpiar el doc"?
2. Si sí, ¿abordamos como **Z monolítico** (3-4 sesiones) o como
   **Z particionado en Z.1..Z.5** (5 sub-WPs)?
3. ¿Hay urgencia/timeline para iniciar implementación que afecte el
   ritmo? Eso prioriza Z.1 (los ADR-BACK son la mayor amenaza
   inmediata).
