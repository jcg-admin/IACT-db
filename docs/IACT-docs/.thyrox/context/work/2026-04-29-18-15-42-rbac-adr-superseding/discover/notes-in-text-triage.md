```yml
created_at: 2026-04-29 19:50:00
project: IACT-docs
work_package: 2026-04-29-18-15-42-rbac-adr-superseding
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Triaje — Notas in-text en ADRs aceptados

## Premisa

Un ADR aceptado debe ser **inmutable**. Las notas in-text con
indicaciones del tipo "VALIDAR ESTA ESTRATEGIA" o "DOCUMENTAR
MATRIZ RACI" son evidencia de **proceso de revisión inconcluso**
en el momento de la aceptación. Cada nota debe triagearse:

- **VÁLIDA** = contiene un requerimiento legítimo no resuelto que
  debe preservarse en el ADR nuevo.
- **NOISE** = artefacto del workflow de revisión, sin contenido
  sustancial; descartable.

## Nota 1 — ADR-BACK-003 (línea 15-17)

### Texto literal

> "NOTA: VALIDAR ESTA ESTRATEGIA YA QUE ES REDUDANTE QUE SE
> CONSIDERE DEVELOP Y TEST, SE TIENE QUE CREAR UNA ESTRATEGIA
> SOLO PARA PRODUCCION PARA QUE SE MANTEGA UNA SOLA TRAZABILIDAD
> DE PERMISOS"

### Análisis

**Posición:** título del ADR, antes incluso del bloque "Estado".
Indica que fue insertada como recordatorio del revisor antes de
formalizar la aceptación.

**Contenido sustancial:**

1. "Es redundante que se considere DEVELOP y TEST" → cuestiona si
   el ADR debería describir 3 estrategias (ORM, SQL, híbrida) o
   solo la de producción.
2. "Crear una estrategia solo para producción" → propone simplificación.
3. "Para que se mantenga una sola trazabilidad de permisos" → el
   problema de fondo es **trazabilidad única** del enforcement de
   permisos.

### Veredicto: **PARCIALMENTE VÁLIDA**

- **Lo válido (preservar):** la inquietud sobre **trazabilidad
  única de permisos** es legítima y se ha vuelto más relevante
  con CNST-032 (menú dinámico obligatorio) y ADR-GOB-008
  (coexistencia ACC ↔ PERM). Si el sistema tiene 3 vías para
  verificar permisos (ORM, vistas SQL, funciones SQL), debe haber
  una **fuente única de verdad** para auditoría.
- **Lo descartable:** la formulación "solo producción, no DEVELOP/
  TEST" es confusa. ORM se usa en testing (fixtures, mocks) y SQL
  en runtime/production. Ambos son legítimos; lo que importa es
  que **la lógica de evaluación final sea la misma** (single
  source of truth).

### Acción para el ADR nuevo

En `adr-back-005-rbac-estrategia-implementacion.rst` agregar
sección explícita:

> **Trazabilidad única del enforcement:** la verificación final
> de "¿usuario X tiene función Y?" SIEMPRE debe pasar por la
> función SQL `usuario_tiene_funcion()` (renombre de
> `usuario_tiene_permiso` para CNST-033). El ORM Django NO
> implementa lógica propia de evaluación — solo gestiona CRUD
> sobre las tablas. Las vistas SQL son optimizaciones de lectura;
> no son fuente de verdad para autorización.

Esto resuelve la inquietud manteniendo la estrategia híbrida
y resolviendo la nota in-text.

## Nota 2 — ADR-BACK-004 (línea 23-25)

### Texto literal

> "LA DEFINICION ESTA CORRECTA, SIN EMBARGO PARA UNA MAYOR
> TRAZABILIDAD SE REQUIERE QUE SE DOCUMENTE UNA MATRIZ RACI, EN
> DONDE SE IDENTIFIQUE MAS FACIL LAS FUNCIONES ACTIVAS DEL
> SISTEMA."

### Análisis

**Posición:** dentro de la sección "Contexto", antes del problema.
Insertada como recordatorio del revisor.

**Contenido sustancial:**

1. "La definición está correcta" → confirma la decisión del ADR.
2. "Para mayor trazabilidad documentar una MATRIZ RACI" →
   propone agregar matriz RACI (Responsible, Accountable,
   Consulted, Informed) sobre las funciones del sistema.
3. "Identificar más fácil las funciones activas" → el problema
   es **visibilidad de quién hace qué** sobre cada función.

### Veredicto: **VÁLIDA**

Una **matriz RACI sobre las 42 funciones** es un artefacto útil
para:

- Documentación de gobernanza (qué grupo es Accountable de cada función).
- Auditoría (quién aprueba cambios al catálogo de funciones).
- Onboarding (qué stakeholder consultar para cada función).

NO existe en el corpus actual. Sería complemento natural al modelo
v5.2.1.

### Acción

**NO incluir en el ADR nuevo conceptual.** En su lugar, registrar
como **deuda técnica explícita** (DEBT) o crear un mini-WP futuro
dedicado.

**Propuesta:** agregar entrada en la sección "Out of scope" /
"Deuda diferida" del ADR conceptual nuevo:

> **Diferido:** matriz RACI sobre las 42 funciones del catálogo.
> Útil para gobernanza/auditoría/onboarding pero excede el scope
> de este ADR. Tracker en `risks-technical-debt/deuda-tecnica-rebuild.rst`
> como DEBT-RBAC-RACI.

Esto preserva la inquietud sin contaminar el ADR de modelo
conceptual con una matriz que requiere su propio análisis.

## Síntesis

| Nota | Vereditc | Acción en ADR nuevo |
|------|----------|---------------------|
| Nota 1 (BACK-003) "validar estrategia" | PARCIALMENTE VÁLIDA | Sección "Trazabilidad única del enforcement" en `adr-back-005-*` |
| Nota 2 (BACK-004) "matriz RACI" | VÁLIDA pero out-of-scope | Sección "Diferido: deuda DEBT-RBAC-RACI" en `adr-gob-009-*` + entrada en `deuda-tecnica-rebuild.rst` |

## Implicación para Phase 5 STRATEGY

Los 2 ADRs nuevos (Opción C del análisis previo) son suficientes
para:
- Supersede los 3 ADR-BACK legacy.
- Resolver las 2 notas in-text (1 directamente, 1 deferida).
- Alinearse a vocabulario CNST-033 + cifras v5.2.1 + ADR-GOB-008.

NO se requiere mini-WP adicional para la matriz RACI dentro de
Z.1; se propaga como deuda hacia un futuro WP independiente.

## Próximo paso

Phase 5 STRATEGY: confirmar Opción C (2 ADRs nuevos) con el
ejecutor + redactar plan de Phase 6 PLAN.
