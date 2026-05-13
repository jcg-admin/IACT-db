```yml
type: ADR (Architecture Decision Record)
project: IACT-docs
status: Aprobado
created_at: 2026-04-29 09:17:01
decision_date: 2026-04-29
deciders: NestorMonroy
related_wp: 2026-04-29-09-17-01-std007-naming-recalibration
supersedes: —
superseded_by: —
```

# ADR — Naming Conventions Heterogeneity Accepted

## Contexto

Tras el WP `source-compliance-audit` (2026-04-29-06-56-16) el
ejecutor identificó una contradicción aparente en STD_007
v1.0.0 §3.3: el ejemplo "Permitido (estructural):
ADR-BACK-001-...rst (kebab puro)" sugería que kebab era opción
genérica, contradiciendo §4.2 que reserva kebab a categorías
específicas (ADR, PROCED, PROC, RNF).

Propuesta original del ejecutor: **unificar todo el corpus a
snake+PascalCase** eliminando kebab excepto en `index.rst`.
Costo estimado: 125 archivos a renombrar (32.8% del corpus) +
~343 referencias `:doc:`/`:ref:` a auditar.

## Análisis adversarial

Antes de ejecutar la unificación, se invocó `deep-dive` (ver
`analyze/deep-review-result.md` del WP padre). Veredicto en 5
preguntas:

| Pregunta | Veredicto |
|----------|-----------|
| ¿§3.3 vs §4.2 es contradicción real? | **FALSE** (es ambigüedad editorial) |
| ¿snake+Pascal mejor que kebab para Sphinx? | **FALSE** (Sphinx, RTD, mkdocs, Hugo, Jekyll usan kebab) |
| ¿La unificación agrega valor? | **FALSE** (corpus cumple las 4 reglas, 0 incidentes) |
| ¿Hay alternativa menos invasiva? | **TRUE** (re-redactar §3.3) |
| ¿Es análogo al sesgo I-017 (realismo performativo)? | **TRUE** |

Patrón nombrado: **inflación de severidad editorial a
arquitectónica** — escalar un defecto de wording a defecto
sistémico para justificar intervención desproporcionada.

## Decisión

**Aceptamos heterogeneidad de naming controlada por
categoría de artefacto.** El corpus mantiene 5 dialectos
(snake+Pascal, kebab kebab puro, mixed FR, kebab guías,
index), cada uno determinado por la categoría del artefacto,
no por preferencia del autor.

**Acción ejecutada:**

1. STD_007 v1.0.0 → v1.1.0. §3.3 reescrito con tabla
   explícita de dialecto-por-categoría. Sin renames de
   archivos. Sin cambios en §4.1–§4.5.

2. Este ADR documenta:
   - El defecto detectado (§3.3 ambigua).
   - La propuesta descartada (rename masivo).
   - El razonamiento del descarte (5 puntos del deep-dive).
   - La alternativa elegida (clarificación editorial v1.1.0).
   - La evidencia ecosistémica (Sphinx/RTD usan kebab).

## Consecuencias

**Positivas:**

- Costo cero en archivos: 0 renames, 0 refs rotas, 0 toctrees
  tocados.
- §3.3 deja de ser ambigua: la tabla explícita de
  dialecto-por-categoría elimina la interpretación de "kebab
  como opción genérica".
- Corpus actual (381 archivos) sigue cumpliendo STD_007 sin
  cambios.
- IACT-docs queda alineado con la convención del ecosistema
  Sphinx (kebab para URLs, snake+Pascal para artefactos
  identificables como código).

**Negativas:**

- Heterogeneidad de naming requiere que autores nuevos
  consulten la tabla §3.3 antes de crear archivos. Mitigación:
  la tabla está en la página principal del estándar, no
  en una sección perdida.

- Cinco dialectos pueden generar confusión inicial. Mitigación:
  cada dialecto está justificado por la categoría
  (UC=código-like, ADR=URL-friendly, etc.).

**Riesgos evitados (vs. propuesta original):**

- Colisiones invisibles en macOS HFS+ y Windows NTFS por
  case-insensitivity (PascalCase vulnerable; kebab-lowercase
  inmune).
- Degradación de URL slugs HTML (`Documento_Largo.html` vs
  `documento-largo.html`).
- Pérdida de `git log --follow` por renames masivos.
- Linkrot en sitios externos que ya referencien URLs
  publicadas.

## Patrón documentado para futuras decisiones

**Inflación de severidad editorial a arquitectónica** =
sub-instancia del sesgo "realismo performativo metodológico"
documentado en
`.claude/skills/thyrox/references/methodology-bias-watch.md`.

Diagnóstico: cuando se detecta un defecto editorial (ambigüedad,
ejemplo confuso, sección redundante), la respuesta default es
proponer una intervención arquitectónica (renames, refactors,
unificación). Esa respuesta es **desproporcionada** si:

1. El defecto es solucionable con una edición quirúrgica.
2. La intervención arquitectónica genera costo orden de
   magnitud mayor que el defecto.
3. No hay observable de daño real (incidentes, errores
   reportados, builds rotos) atribuible al defecto editorial.

Antes de proponer intervención arquitectónica, validar:

- ¿Cuántos archivos tendría que tocar?
- ¿Cuál es el daño operativo actual del defecto?
- ¿Hay alternativa de 1-archivo-1-edit que cierre el defecto
  real?

Si la edición quirúrgica resuelve el defecto, **es la
respuesta correcta**.

## Referencias

- WP `2026-04-29-09-17-01-std007-naming-recalibration` —
  análisis completo.
- WP `2026-04-29-05-51-27-methodology-recalibration` — origen
  del concepto "realismo performativo metodológico".
- WP `2026-04-29-06-56-16-source-compliance-audit` — auditoría
  que detectó el defecto §3.3.
- `.claude/skills/thyrox/references/methodology-bias-watch.md` —
  reference cargable on-demand antes de codificar invariantes
  o intervenciones de gran escala.
- STD_007 v1.1.0 § 3.3 — implementación de la decisión.
