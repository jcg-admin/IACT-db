```yml
project: IACT-docs
work_package: 2026-04-29-09-17-01-std007-naming-recalibration
created_at: 2026-04-29 09:17:01
current_phase: Phase 1 — DISCOVER
flow: thyrox
methodology_step: workflow-discover
author: NestorMonroy
status: Borrador (analisis en curso)
```

# WP — STD_007 Naming Recalibration

## Origen del WP

Tras el `source-compliance-audit` (WP 2026-04-29-06-56-16), el
ejecutor identifico contradicciones internas en
`source/normativa/estandares/STD_007_Convencion_Naming.rst` y
propone unificar todo el corpus a `snake_case` con
`PascalCase` para descripciones.

## Propuesta del ejecutor

1. **§3.3 "Mezcla de Separadores"**: eliminar el ejemplo
   "Permitido (estructural): `ADR-BACK-001-...rst` (kebab puro)".
   Razon citada: contradice el patron canonico.

2. **§4.2 "Artefactos con Modulo y Numeracion"**: cambiar de:
   ```
   <PREFIX>-<MOD>-<NNN>-<descripcion-en-kebab>.rst
   ```
   a:
   ```
   <PREFIX>_<NN>_<Descripcion_PascalCase>.rst
   ```
   (o variante con MOD: `<PREFIX>_<MOD>_<NNN>_<Descripcion_PascalCase>.rst`)

3. **§4.4 "Guias y Documentos Generales"**: cambiar de
   `<descripcion-en-kebab-case>.rst` a
   `<Descripcion_PascalCase>.rst`.

4. **Excepcion unica**: `index.rst` (lowercase, sin Pascal).

## Pregunta del ejecutor

> "tu que opinas"

## Estado

DISCOVER en curso. Antes de opinar, inventario factual del
corpus + analisis de trade-offs + (opcionalmente) deep-review
adversarial para evitar caer en el sesgo "responder con
recomendacion sin haber medido".
