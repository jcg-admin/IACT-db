```yml
type: Architectural Decision Record
version: 1.0
updated_at: 2026-04-03-00-49-34
```

# ADR-012: Refinamiento de ADR-004 — Management Skill + N Tech Skills

## Metadatos

**ADR ID:** ADR-012
**Título:** Un management skill + N tech skills generados desde registry
**Fecha:** 2026-04-03-00-49-34
**Status:** Aprobado
**Refina:** ADR-004 (Single Skill)

---

## Contexto

ADR-004 establece: "Un pm-thyrox con references, no 15 skills separados."

El espíritu de ADR-004 es evitar la fragmentación de la metodología de gestión en múltiples skills que compiten o se superponen. Sin embargo, al analizar el proyecto Volt Factory (WP voltfactory-adaptation, H-014), se identificó una categoría de skills fundamentalmente diferente: los **tech skills** de tecnología específica. Estos no fragmentan la metodología — la complementan desde un eje ortogonal.

**Drivers:**
- Los proyectos tienen stacks tecnológicos concretos que requieren guía específica
- Las convenciones tecnológicas deben vivir en git como artefactos permanentes (ADR-008)
- El registry permite escalar a nuevas tecnologías sin modificar la metodología de gestión

---

## Decisión

**ADR-004 se refina, no se viola.** La nueva regla es:

> **Un skill de gestión** (pm-thyrox) + **N tech skills de tecnología** (generados desde registry).
> Los tech skills son una categoría nueva — tecnología, no gestión.

**Dos ejes ortogonales:**
- pm-thyrox: CUÁNDO y CÓMO documentar (fases SDLC, artefactos, gates)
- tech skills: CÓMO implementar en una tecnología específica (convenciones, patrones, ejemplos)

pm-thyrox no conoce React. `frontend-react` no conoce fases SDLC. Ninguno reemplaza al otro.

---

## Alternativas consideradas

**Alternativa A — Extender pm-thyrox con secciones tech**
Rechazada: SKILL.md de 2000+ líneas; no escala a 10+ techs; viola responsabilidad única.

**Alternativa B — Tech skills manuales por proyecto**
Rechazada: duplicación masiva; deriva entre proyectos; sin actualización centralizada.

**Alternativa C — Registry + generación (ELEGIDA)**
Una fuente de verdad, escala a N tecnologías, generación consistente via `_generator.sh`.

---

## Consecuencias

**Positivas:**
- pm-thyrox permanece enfocado en gestión — no crece por cada nueva tecnología
- Bootstrap una vez; sesiones subsecuentes tienen contexto automático via `.instructions.md`
- El registry es el único lugar a actualizar cuando cambia una tecnología

**Negativas:**
- Introduce registry y `_generator.sh` como componentes a mantener
- Risk R-004: registry puede crecer sin control si no hay criterios claros

---

## Relación con otros ADRs

| ADR | Relación |
|---|---|
| ADR-004 | Este ADR refina ADR-004 — la regla "sin 15 skills de gestión" sigue vigente |
| ADR-008 | Tech skills son artefactos git permanentes — alineado con "Git as persistence" |
| ADR-001 | Tech skills son archivos Markdown — alineado con "Markdown only" |
| ADR-003 | Bootstrap genera commits convencionales — alineado con "Conventional Commits" |
