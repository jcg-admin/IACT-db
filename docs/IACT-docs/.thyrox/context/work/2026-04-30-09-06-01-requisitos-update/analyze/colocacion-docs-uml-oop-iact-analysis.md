```yml
created_at: 2026-04-30 09:06:01
project: IACT-docs
work_package: 2026-04-30-09-06-01-requisitos-update
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Análisis — colocación de docs UML/OOP/casos-uso aplicados a IACT

## Premisa

Durante este WP se generaron 7 documentos derivados de las
"GUÍAS-*" internas (Schmuller Hora 1..6 + Plan + ejemplos
aplicados al dominio). Inicialmente fueron colocados en
`source/gestion/pm/`. El ejecutor cuestionó si esa ubicación
es correcta, pidiendo revisar los `.claude/skills/*` para
mejor orientación.

## Hallazgos

### F-0 — Marco más relevante: RM (Requirements Management)

Tras review del catálogo completo de skills, los `rm-*` son el
framework **más directo** para estos docs (más que PMBOK o
BABOK):

| Skill RM | Descriptor literal | Encaja con |
|----------|--------------------|------------|
| `rm-elicitation` | *"plan and conduct requirements elicitation using structured techniques"* | `ejemplos-analisis-dominio-aplicados-iact` (sustantivos→clases es elicitation), `ejemplos-casos-uso-aplicados-iact` (UC desde POV usuario) |
| `rm-analysis` | *"analyze completeness, consistency and priority of requirements"* | `ejemplos-oop-aplicados-iact`, `ejemplos-relaciones-uml-aplicados-iact`, `ejemplos-agregacion-interfaces-aplicados-iact` |
| `rm-specification` | *"formalize analyzed requirements into a specification document with SRS/BRD format and acceptance criteria"* | `ejemplos-uml-aplicados-iact`, `ejemplos-casos-uso-aplicados-iact` (template + ejemplo completo) |
| `rm-management` | *"manage requirements baseline, changes and traceability over the project lifecycle"* | `plan-documentacion-uc-con-uml` (plan establece baseline de 97 UCs en 13 docs + trazabilidad) |
| `rm-validation` | *"verify that requirements meet quality standards"* | (criterios de aceptación del plan) |

BABOK (`ba-*`) e ISO 29148 / IEEE (`rm-*`) son frameworks
**paralelos** que cubren lo mismo con vocabulario distinto. El
proyecto tiene ambos disponibles. **`rm-*` es la elección más
clara para artefactos de requisitos** porque:

1. Los nombres `rm-elicitation/analysis/specification/validation/
   management` siguen el ciclo IEEE / ISO 29148 que es el
   estándar industria para documentación de requisitos.
2. El cajón existente `source/requisitos/` mapea directamente a
   los outputs de `rm-*`.
3. Las metodologías ya existentes
   (`metodologia-analisis-dominio-ucs`,
   `metodologia-oop-para-ucs`) son aplicaciones de RM, no
   de gestión de proyectos.

### F-1 — Mismatch PMBOK vs BABOK

Los 7 docs son artefactos **BABOK**, no **PMBOK**.

| Doc | Skill correcto | Por qué |
|-----|----------------|---------|
| `plan-documentacion-uc-con-uml.rst` | `ba-planning` | Es un BA Plan (planificar elicitación + análisis), no un PM Plan |
| `ejemplos-uml-aplicados-iact.rst` | `ba-requirements-analysis` | Modelado de requisitos con UML — descripción literal del skill |
| `ejemplos-oop-aplicados-iact.rst` | `ba-requirements-analysis` | Análisis OOP de UCs |
| `ejemplos-analisis-dominio-aplicados-iact.rst` | `ba-elicitation` + `ba-requirements-analysis` | Sustantivos→clases es elicitación + análisis |
| `ejemplos-relaciones-uml-aplicados-iact.rst` | `ba-requirements-analysis` | Modelado de relaciones |
| `ejemplos-agregacion-interfaces-aplicados-iact.rst` | `ba-requirements-analysis` | Modelado de aggregation/composition/interfaces |
| `ejemplos-casos-uso-aplicados-iact.rst` | `ba-requirements-analysis` | Especificación de UCs |

PMBOK no incluye UML / OOP / casos de uso — son herramientas
BABOK. El descriptor literal de `ba-requirements-analysis`
dice: *"model requirements with use cases and user stories"*.

### F-2 — Naturaleza dual de los docs

Los 7 docs **no son del mismo tipo**:

- **Plan operativo** (1 doc) — qué hacer (13 docs × 97 UCs).
- **Ejemplos aplicados al dominio** (6 docs) — cómo lucen las
  técnicas en IACT (precedente visual + explicación).

Tratarlos como un solo bloque homogéneo es incorrecto.

### F-3 — Cajones existentes en `source/`

| Cajón | Propósito |
|-------|-----------|
| `gestion/pm/` | Project management (PMBOK) |
| `gestion/evidencia/` | Evidencias / archives |
| `normativa/estandares/` | Reglas + metodologías + plantillas |
| `base-cognitiva/_uml/` | Lecciones UML genéricas (Schmuller) |
| `base-cognitiva/_ejemplos-pedagogicos/` | **Sagas end-to-end** del SDLC |
| `base-cognitiva/_taxonomias-y-metamodelos/` | Metamodelos formales |

El cajón `_ejemplos-pedagogicos/` es para **sagas end-to-end de
un feature** (ya tiene `ejemplo-dark-mode`). No es para guías
de aplicación de UNA técnica al dominio. Es otra dimensión.

### F-4 — Cross-links existentes que se rompen

Si se mueven los archivos, hay que actualizar refs en:

- `normativa/estandares/metodologia-oop-para-ucs.rst` →
  apunta a `ejemplos-oop-aplicados-iact`
- `normativa/estandares/metodologia-analisis-dominio-ucs.rst`
  → apunta a `ejemplos-analisis-dominio-aplicados-iact`
- `base-cognitiva/_uml/cuando-usar-cada-diagrama.rst` →
  apunta a `ejemplos-uml-aplicados-iact`
- Plan → apunta a los 6 ejemplos
- Cada ejemplo → apunta al plan + a los demás ejemplos
- `gestion/pm/index.rst` toctree
- `gestion/index.rst` (si se crea `ba/`)

## Tres opciones evaluadas

### Opción 1 — SPLIT por naturaleza (recomendada)

```
gestion/ba/                                  ← NUEVO (paralelo a pm/)
├── index.rst
└── plan-documentacion-uc-con-uml.rst        ← BA Plan operativo

base-cognitiva/_aplicaciones-iact/           ← NUEVO
├── index.rst
├── diagramas-uml.rst
├── orientacion-objetos.rst
├── analisis-dominio.rst
├── relaciones-uml.rst
├── agregacion-interfaces.rst
└── casos-uso-especificacion.rst
```

| Pros | Cons |
|------|------|
| Cada doc en su lugar semánticamente correcto | Plan y ejemplos en cajones distintos |
| `gestion/ba/` cumple el descriptor BABOK exactamente | 2 cajones nuevos |
| Ejemplos = conocimiento cognitivo aplicado, no gestión | Hay que actualizar varios cross-links |
| Nombres simplificados (sin `-aplicados-iact` redundante) | |
| Refleja la realidad: hay BA y PM, son dos prácticas distintas | |

### Opción 2 — TODO en `gestion/ba/`

```
gestion/ba/
├── index.rst
├── plan-documentacion-uc-con-uml.rst
├── ejemplos-uml-aplicados-iact.rst
├── ejemplos-oop-aplicados-iact.rst
├── ejemplos-analisis-dominio-aplicados-iact.rst
├── ejemplos-relaciones-uml-aplicados-iact.rst
├── ejemplos-agregacion-interfaces-aplicados-iact.rst
└── ejemplos-casos-uso-aplicados-iact.rst
```

| Pros | Cons |
|------|------|
| Plan + ejemplos juntos (ejecutor tiene todo a mano) | Mezcla naturalezas: ejemplos no son gestión |
| Un solo cajón nuevo | `gestion/` se llena de material que es realmente cognitivo |
| Cross-links menos invasivos | |

### Opción 3 — TODO en `normativa/estandares/`

```
normativa/estandares/
├── metodologia-oop-para-ucs.rst              (existente)
├── metodologia-analisis-dominio-ucs.rst      (existente)
├── plan-documentacion-uc-con-uml.rst         (movido)
├── ejemplos-uml-aplicados-iact.rst           (movido)
├── ejemplos-oop-aplicados-iact.rst           (movido)
├── ejemplos-analisis-dominio-aplicados-iact.rst (movido)
├── ejemplos-relaciones-uml-aplicados-iact.rst (movido)
├── ejemplos-agregacion-interfaces-aplicados-iact.rst (movido)
└── ejemplos-casos-uso-aplicados-iact.rst     (movido)
```

| Pros | Cons |
|------|------|
| Ejemplos compañeros directos de metodologías | `estandares/` es para reglas normativas, no precedentes ni planes |
| Sin nuevos cajones | Diluye el propósito del cajón |

## Opción 4 — agregada tras incluir `rm-*`

```
source/requisitos/_metodologia-aplicacion/   ← NUEVO sub-cajón
├── index.rst
├── plan-documentacion-uc.rst                ← rm-management
├── diagramas-uml.rst                        ← rm-specification
├── orientacion-objetos.rst                  ← rm-analysis
├── analisis-dominio.rst                     ← rm-elicitation
├── relaciones-uml.rst                       ← rm-specification
├── agregacion-interfaces.rst                ← rm-specification
└── casos-uso-especificacion.rst             ← rm-elicitation +
                                                rm-analysis +
                                                rm-specification
```

| Pros | Cons |
|------|------|
| Adyacente a los artefactos que describe (`requisitos/business-requirements/`, `casos-uso/`, etc.) | Sub-cajón con prefijo `_` rompe levemente el patrón (otros sub-cajones internos sí usan `_` — sbvr, taxonomias, etc., pero todos en `base-cognitiva/`) |
| Mapea directo al ciclo `rm-elicitation → rm-analysis → rm-specification → rm-validation → rm-management` | |
| Un solo lugar — plan + 6 ejemplos juntos como cuerpo coherente | |
| Permite nombres simplificados sin redundancia `-aplicados-iact` | |
| No requiere crear nuevos top-level cajones (`gestion/ba/`) ni fragmentar (split entre `gestion/ba/` + `base-cognitiva/`) | |
| El cajón `requisitos/` ya tiene index propio que puede listar el sub-cajón sin tocar otros | |

### Argumento adicional — `knowledge/` ya cubierto

El argumento de mover ejemplos a `base-cognitiva/_aplicaciones-iact/`
descansaba en que son "conocimiento cognitivo aplicado". Pero
**`base-cognitiva/` ya tiene** lo equivalente al `knowledge/`
del proyecto:

- `_uml/` — lecciones genéricas de UML
- `_uml/cuando-usar-cada-diagrama.rst` — cheat-sheet
- `_taxonomias-y-metamodelos/` — metamodelos formales
- `_ontologia-sbvr/` — ontología
- `_ejemplos-pedagogicos/` — sagas end-to-end
- `_fundamentos-conceptuales/` — fundamentos
- `glosario.rst` — glosario
- `plantuml-guide/` — guía de la herramienta
- `_metadata/` — metadata del proyecto

→ Agregar `_aplicaciones-iact/` ahí sería redundante. Esos
ejemplos no son **base** cognitiva (vocabulario, ontología,
fundamentos); son **aplicación específica** del marco RM al
dominio del proyecto. Pertenecen junto a los artefactos de
requisitos, no junto a la base ontológica.

## Recomendación actualizada

**Opción 4 (CONSOLIDADA en `source/requisitos/_metodologia-aplicacion/`)**:

- Plan + 6 ejemplos → un solo sub-cajón en `requisitos/`.
- Skill aplicada por archivo: `rm-management` (plan),
  `rm-elicitation` / `rm-analysis` / `rm-specification`
  (ejemplos según corresponda).
- Cross-link bidireccional con metodologías ya existentes en
  `normativa/estandares/metodologia-*`.

Razones:

1. **Marco correcto**: `rm-*` (Requirements Management ISO
   29148) es más directo que BABOK o PMBOK para estos docs.
2. **Adyacencia semántica**: viven junto a los artefactos que
   describen (BReq, BR, UC, FR, NFR).
3. **No fragmenta**: plan y ejemplos juntos como cuerpo
   coherente.
4. **No agrega top-level cajones** (descartada la idea de
   `gestion/ba/`).
5. **Respeta `base-cognitiva/`** como base ontológica pura
   (no la mezclamos con material project-specific).
6. **Nombres simplificados**: sin sufijos `-aplicados-iact`
   redundantes (el cajón ya marca el contexto).

## Pendiente de aprobación del ejecutor

Confirmación de la opción a aplicar:

- Opción 1 (split: `gestion/ba/` + `base-cognitiva/`)
- Opción 2 (todo en `gestion/ba/`)
- Opción 3 (todo en `normativa/estandares/`)
- **Opción 4 (NUEVA, recomendada): todo en
  `source/requisitos/_metodologia-aplicacion/`**

## Trazabilidad

- **Skill aplicada**: `workflow-analyze` (Phase 3 ANALYZE).
- **Origen del análisis**: cuestionamiento del ejecutor sobre
  la colocación inicial en `gestion/pm/`.
- **Skills consultados**: `pm-*` (PMBOK) vs `ba-*` (BABOK) —
  descriptores leídos de `.claude/skills/`.
- **Decisión pendiente**: aplicación de opción 1, 2 o 3.
