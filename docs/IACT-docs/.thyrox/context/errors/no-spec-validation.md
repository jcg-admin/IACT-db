```yml
id: ERR-003
created_at: 2026-03-28
type: Gap en el framework
severity: Alta
status: Detectado
```

# ERR-003: Sin validación de especificaciones

## Qué falta

THYROX permite que specs (epics, PRDs, análisis) avancen de una fase a la siguiente sin validación de calidad. No hay checklist que verifique completitud, claridad, o consistencia antes de proceder.

## Cómo lo resuelve spec-kit

spec-kit tiene `checklist-template.md` — "unit tests for specs":
- Verifica: requisitos completos, testables, sin ambigüedad
- Itera: máximo 3 veces si hay fallas
- Bloquea: si persisten problemas, advierte antes de proceder

## Impacto en THYROX

Specs malas avanzan silenciosamente. Errores se descubren en Phase 6 (EXECUTE) cuando son más costosos de corregir.

## Corrección propuesta

Crear `assets/spec-quality-checklist.md.template` y hacer su uso obligatorio en Phase 4 (STRUCTURE) antes de pasar a Phase 5 (DECOMPOSE).
