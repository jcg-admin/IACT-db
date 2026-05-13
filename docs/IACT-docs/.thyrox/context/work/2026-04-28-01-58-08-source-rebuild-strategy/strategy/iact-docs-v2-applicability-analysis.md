```yml
created_at: 2026-04-28 04:35:00
project: IACT-docs
work_package: 2026-04-28-01-58-08-source-rebuild-strategy
phase: Phase 5 — STRATEGY (análisis de propuesta externa)
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Análisis de aplicabilidad — IACT-DOCS Híbrido v2.0

## 0. Propósito

El ejecutor compartió un documento externo titulado "IACT-DOCS
HÍBRIDO v2.0: Production-Ready" (15 secciones, ~1100 líneas) como
**ejemplo a considerar** explicitando "puede que no aplique TODO
para nosotros". Este análisis evalúa qué partes son aplicables al
WP `source-rebuild-strategy`, cuáles no, y cuáles requieren
adaptación.

**Este documento NO modifica la solution-strategy.md.** Su propósito
es informar la decisión del ejecutor sobre qué adoptar antes de
cerrar Phase 5.

## 1. Contraste fundamental — diferencia de scope y filosofía

| Dimensión | source/ actual + strategy v1.2 | IACT-DOCS v2.0 propuesta |
|-----------|--------------------------------|---------------------------|
| **Scope** | UNA documentación: el producto IACT (call center analytics) | INTRANET corporativa multi-proyecto (proyectos/saas/, proyectos/mobile/, etc.) |
| **Top-level** | 5 dominios metodológicos (`arquitectura_tecnica`, `base_cognitiva`, `gestion`, `normativa`, `requisitos`) + `plantuml-guide` | 10 categorías corporativas (`guide`, `news`, `policies`, `procedures`, `planning`, `knowledge`, `projects`, `reports`, `teams`, `resources`) |
| **Dimensión organizadora** | Por DIMENSIÓN METODOLÓGICA (qué tipo de artefacto es: regla, requisito, plantilla, etc.) | Por DIMENSIÓN DE CONSUMO/ROL (quién lo lee y para qué) |
| **Profundidad por dominio** | Variable según dominio (ej: `normativa/` tiene 4 subdominios; `gestion/` plano) | 12 "cajones" estándar dentro de cada `projects/X/` |
| **Audiencia esperada** | Equipo técnico + stakeholders del producto IACT | Toda la organización: comms, legal, HR, devops, devs, PMs, analytics |
| **Volumen** | 379 archivos en un producto | Diseñado para 50+ proyectos paralelos |

**Implicación crítica:** elegir v2.0 tal cual implica **expandir el
scope del repo** de "documentación del producto IACT" a "intranet
corporativa que incluye al IACT como un proyecto entre muchos". Esa
es una decisión de proyecto, no metodológica — fuera del scope del
WP `source-rebuild-strategy` actual.

## 2. Mapa de aplicabilidad — qué adoptar / adaptar / descartar

### 2.1 ADOPTAR DIRECTAMENTE (alta utilidad, scope compatible)

| Capacidad v2.0 | Por qué aplica | Cómo |
|----------------|----------------|------|
| **Metadata schema YAML universal** (status, version, last_updated, author, audience, related, priority) | source/ ya tiene `.. meta::` blocks pero inconsistente. STD_006 obliga versión en metadata. | Definir schema en `STD_007` o nuevo `STD_008`. Aplicar progresivamente durante el rebuild — cada archivo del nuevo source/ tiene metadata estándar. |
| **CODEOWNERS** (ownership por path) | Sin scope multi-team-corporativo, igual sirve por dominio (ej: `requisitos/` → equipo de producto; `arquitectura_tecnica/` → tech lead). | Crear `.github/CODEOWNERS` mapeando dominios. No requiere intranet, solo cuentas/teams en GitHub. |
| **CI con linting + link-check + spell-check** | `validate.yml` ya hace `sphinx-build -W`. Falta link-check explícito y validación de metadata. | Extender workflow existente con `make linkcheck`, `validate_metadata.py`, `pyspelling` (ya viene `sphinxcontrib-spelling`). |
| **Staleness detection automatizada** | Una doc desactualizada engaña más que una ausente. | Script Python que recorre archivos, lee `last_updated` del metadata, abre issues GitHub si supera threshold por dominio. Ejecutar weekly via Actions. |
| **Auto-breadcrumbs** | UX directa, baja complejidad. | Sphinx ya soporta vía theme (Furo lo trae). Verificar si está activo. Si no, custom extension trivial. |
| **Deprecation/archiving procedure** | Aplica a cualquier doc evolutivo, sea single-product o intranet. | Procedure en `normativa/procedimientos/` + tooling opcional. |
| **Versioning per doc + metadata** | Ya cubierto por STD_006. v2.0 lo refuerza. | Confirmar STD_006 cubre todos los casos del schema v2.0. |

### 2.2 ADAPTAR (concepto útil, implementación distinta)

| Capacidad v2.0 | Por qué adaptar | Adaptación propuesta |
|----------------|----------------|---------------------|
| **"12 cajones" planos por proyecto** (specifications/, planning/, architecture/, backend/, frontend/, infrastructure/, operations/, onboarding/, quality-scenarios/, risks-technical-debt/, crosscutting-concepts/, glossary/) | El concepto de "cajones estándar" es ARC42-like y bueno; pero los 12 cajones son para un PROYECTO de software. IACT-docs es DOCUMENTACIÓN del producto, no su código. | Mantener los 5 dominios metodológicos actuales. NO adoptar los 12 cajones tal cual. Sí evaluar si dentro de `arquitectura_tecnica/` conviene agrupar siguiendo ARC42 (system-overview, components, design, deployment, decisions). |
| **Front-matter YAML triple-dash** (`---`) | I-010 + `metadata-standards.md` ya define convención: bloque `\`\`\`yml` en artefactos WP. Aplicar `---` a source/ rompe consistencia con `.thyrox/`. | Adoptar metadata, pero usando bloque `\`\`\`yml` (consistencia con resto del repo). En RST, esto se traduce a `.. meta::` o un comment `..` con el bloque YAML. Decidir formato técnico. |
| **Project templates con `create_project.py`** | Útil concepto, pero tenemos `TPL_*` que cumple esto a nivel de artefacto, no de proyecto. | Adoptar la idea de **scaffolding por dominio**: script que crea estructura mínima de un nuevo dominio en `source/` siguiendo STD_007. |
| **Search con facetas (Algolia)** | UX excelente, pero introduce dependencia SaaS y compleja la pipeline. Furo ya provee búsqueda built-in respetable. | Postergar Algolia. Validar que la búsqueda built-in de Furo cubre el caso de uso. Considerar Algolia solo si la doc crece >1000 archivos o el equipo lo pide explícitamente. |
| **Governance committee con reuniones semanales** | Over-engineered para escala actual. Aplicable a intranet corp, no a single-product. | Adoptar el espíritu (decisiones documentadas en `decisions/`, conflict resolution via ADRs) pero sin formalismo de comité. Ya existe `decisions/` con ADRs. |

### 2.3 DESCARTAR PARA EL SCOPE ACTUAL (decisión explícita)

| Capacidad v2.0 | Por qué descartar |
|----------------|------------------|
| **10 categorías corporativas** (guide, news, policies, procedures, planning, knowledge, projects, reports, teams, resources) | Asumen scope intranet, no producto. IACT-docs no documenta políticas de la org, ni news, ni teams, ni reports. Adoptarlas implicaría inventar contenido inexistente. |
| **`projects/` multi-tenant con N proyectos hermanos** | IACT es un solo producto. No hay otros proyectos que documentar acá. |
| **`shared-components/` para docs compartidas** | Sin múltiples proyectos, no hay shared. |
| **Algolia / Elasticsearch como capa de search** | Dependencia SaaS sin necesidad demostrada. Furo built-in basta. |
| **Slack webhooks para notificaciones de stale docs** | Útil pero infraestructura adicional. GitHub issues automáticos via Actions cubre el 80% del valor sin Slack. |
| **`scripts/index_to_algolia.py`, `migrate_doc.py` con redirects HTML** | Solo aplicable si se adoptan partes 2.0 ya descartadas (Algolia, multi-project). |
| **Roadmap de 8 semanas dividido en FASE 1-4** | Es un plan de implementación de v2.0 completo. Inaplicable porque no se va a implementar v2.0 completo. Si adoptamos parcialmente, el roadmap se reescribe en Phase 6 PLAN. |

### 2.4 INTERESANTE PERO REQUIERE ANÁLISIS ADICIONAL

| Capacidad v2.0 | Por qué requiere más análisis |
|----------------|-------------------------------|
| **Health dashboard con métricas (stale %, broken links, metadata coverage)** | Útil, pero para single-product puede ser overkill al inicio. Decidir si vale la pena en Phase 6 PLAN. |
| **Custom Sphinx extensions (`breadcrumb_extension`, `autotoctree`, `metadata_schema`, `version_injection`)** | Cuántas son redundantes con Furo + sphinx-design + sphinxcontrib-spelling ya instalados. Auditar antes de implementar custom. |
| **Conflict detection (`detect_conflicts.py`)** | El concepto aplica a múltiples proyectos contradiciéndose. Para single-product puede aplicar a contradicciones entre dominios — pero hay que pensar qué es "conflicto" en single-product. |
| **`PR template` + checklist de validación** | Útil, baja inversión. Decidir templates específicos en Phase 6. |

## 3. Áreas donde v2.0 valida o refuerza la strategy v1.2

| v1.2 (existente) | v2.0 (refuerza/valida) |
|------------------|------------------------|
| Idea 6: templates como contrato estructural | Sección 11 "Plantillas para Nuevos Documentos" — confirma que templates son first-class |
| Idea 4: RST puro, sin Markdown | Sección 1 muestra `.rst` exclusivamente en su árbol (aunque algunas refs mencionan `.md`) |
| Decision 7: CNST como input arquitectónico | Sección 6 (Architecture) y Sección 11.1 (Especificación template) listan "Reglas de Negocio" como input — alinea con CNST como restricciones |
| Idea 3: Standards-first | Sección 8 "Procedimientos Operacionales" + Sección 4 "CI/CD" — todo gira alrededor de standards aplicados consistentemente |
| Idea 2: Reconstrucción incremental dominio por dominio | Sección 13 "Roadmap" tiene fases incrementales — refuerza el principio |

## 4. Áreas donde v2.0 sugiere mejoras a v1.2

| Área | Sugerencia derivada de v2.0 |
|------|------------------------------|
| **Metadata schema** | strategy v1.2 menciona STD_006 para versionado, pero no define schema completo (status, audience, priority, related). Considerar adoptar el schema de v2.0 sección 2 como base y referenciarlo desde STD_007 o nuevo STD. |
| **Ownership** | v1.2 no menciona CODEOWNERS. Aunque sea single-product, hay roles distintos (PM, tech lead, devops, etc.). Definir ownership por dominio agrega rigor sin mucho costo. |
| **Operational docs (deprecation, archiving)** | v1.2 trata el rebuild de un solo source/. No define qué pasa con docs deprecadas DESPUÉS del rebuild. Adoptar la procedure de v2.0 secciones 8.1-8.3. |
| **Health checks** | v1.2 dice "0 warnings" como goal pero no define checks continuos post-rebuild. Adoptar el concepto de staleness check + link check periódicos. |
| **PR template + CI validation extendida** | Existing CI (validate.yml) ya tiene base; ampliar con metadata validation y link check sería bajo costo, alto valor. |

## 5. Ítem por ítem — los 37 cuellos de v2.0

La sección 14 de v2.0 lista 37 cuellos resueltos. Tabla con
aplicabilidad para nuestro WP:

| # | Cuello v2.0 | Aplica a IACT-docs single-product | Acción propuesta |
|---|-------------|-----------------------------------|------------------|
| 1 | 3 clicks myth | SÍ (UX universal) | Adoptar: homepage mejorada + breadcrumbs |
| 2 | Sin breadcrumbs | SÍ | Verificar Furo theme; si no, custom extension |
| 3 | Índices manuales | SÍ | Auto-toctree (Sphinx ya soporta) |
| 4 | Convenciones múltiples | SÍ — es uno de los problemas raíz del rebuild | Ya cubierto en strategy v1.2 (STD_007) |
| 5 | Search sin facetas | NO inicialmente | Furo built-in primero; Algolia si crece |
| 6 | Inconsistencia intra-project | SÍ | Linting + templates (Idea 6 v1.2) |
| 7 | Planning duplicado | NO | No tenemos `planning/` multi-nivel |
| 8 | Knowledge difuso | NO | No tenemos categoría `knowledge/` corporativa |
| 9 | Procedures conflictivas | PARCIAL | Aplicaría a `normativa/procedimientos/` |
| 10 | Crosscutting catch-all | SÍ — `base_cognitiva/` puede caer en esto | Definir alcance claro de cada dominio en Phase 6 |
| 11 | 12 cajones arbitrarios | NO — no usamos los 12 cajones | N/A |
| 12 | Glossary duplicado | SÍ — `base_cognitiva/glossary*` tiene 3 variantes | Resolver en WP `base_cognitiva` |
| 13 | Releases misplaced | PARCIAL | No tenemos releases doc actualmente |
| 14 | Specs/Arch fuzzy | SÍ — definir alcance de `requisitos/` vs `arquitectura_tecnica/` | Phase 6 PLAN debe clarificar |
| 15 | Ownership sin enforcement | SÍ | CODEOWNERS adoptable |
| 16 | SLAs sin auditoría | SÍ | Staleness check automatizado |
| 17 | Sin approval | PARCIAL — branch protection ya existe en CI | Reforzar con CODEOWNERS |
| 18 | Sin migración | SÍ | Procedure adoptable para post-rebuild |
| 19 | Sin versionado | SÍ — STD_006 cubre principio, falta enforcement | Validación en CI |
| 20 | Conflictos cross-proyecto | NO (single product) | N/A |
| 21 | Shared-components ambiguo | NO | N/A |
| 22 | 50 proyectos chaos | NO | N/A |
| 23 | Nuevo proyecto 2-3h | PARCIAL — equivalente: nuevo dominio o nuevo artefacto | Scaffolding script opcional |
| 24 | Silos sin notificación | SÍ | GitHub issues automáticos basta |
| 25 | Niveles profundos | SÍ | Linting de profundidad |
| 26 | Mezcla RST/MD | SÍ — Idea 4 v1.2 ya lo resuelve | Confirmado |
| 27 | Recursión planning | NO | N/A |
| 28 | Search no escala | NO inicialmente | Re-evaluar a futuro |
| 29 | Sin deprecation | SÍ | Procedure adoptable |
| 30 | Sin archiving | SÍ | Procedure adoptable |
| 31 | Validación manual | SÍ — `validate.yml` ya valida en CI | Ampliar checks |
| 32 | Links rotos silent | SÍ | `make linkcheck` adoptable |
| 33 | Sin CI/CD docs | SÍ — ya existe (verificado en F-NEW-7) | Confirmado |
| 34 | Sin metadata | SÍ — partial (`.. meta::` existe pero inconsistente) | Schema unificado adoptable |
| 35 | Sin tagging | SÍ | Adoptable como parte del metadata schema |
| 36 | Sin versionado docs | SÍ — STD_006 ya cubre | Confirmado |
| 37 | Sin Last Updated | SÍ | `sphinx-last-updated-by-git` ya está instalado, hay que verificar uso |

**Resultado del análisis:** de los 37 cuellos, **24 aplican** al
single-product (sí o parcial), **9 no aplican** (multi-project),
**4 son ambiguos**.

## 6. Decisiones a tomar (D-V2-1..7)

Antes de cerrar Phase 5 con la nueva información:

### D-V2-1: ¿Adoptar el scope intranet corporativa multi-proyecto?

- **A) NO.** Mantener single-product (IACT como producto único en
  el repo). Recomendación por defecto si no hay otros proyectos
  que documentar.
- **B) SÍ.** Reorganizar todo el repo siguiendo el árbol v2.0.
  Implica scope creep masivo, justificable solo si hay decisión
  organizacional de centralizar docs corporativas.

### D-V2-2: ¿Adoptar el metadata schema YAML estandarizado?

- **A) SÍ, en bloque `\`\`\`yml`** (consistencia con resto del repo).
- **B) SÍ, en triple-dash `---`** (consistencia con v2.0 textual).
- **C) NO**, mantener `.. meta::` actuales.

Recomendación: A. Crear `STD_008_Metadata_Documentos.rst` que
defina el schema (status, version, last_updated, author,
reviewed_by, audience, related, priority) y usarlo en todo el
nuevo source/.

### D-V2-3: ¿Adoptar CODEOWNERS por dominio?

- **A) SÍ.** Mapear dominios a teams/usuarios GitHub.
- **B) NO.** Mantener review libre.

Recomendación: A. Bajo costo, alto rigor.

### D-V2-4: ¿Ampliar CI con metadata validation + link check + spell check?

- **A) SÍ todo.** Extender `validate.yml`.
- **B) SÍ solo link check + metadata** (skip spell por ruido inicial).
- **C) NO.** Mantener CI actual.

Recomendación: B inicial, escalar a A después.

### D-V2-5: ¿Adoptar staleness check automatizado?

- **A) SÍ.** Script + Actions weekly + GitHub issues automáticos.
- **B) NO.** Manual review en retros.

Recomendación: A — pero solo después de que el metadata schema
(D-V2-2) esté implementado, porque depende de `last_updated`.

### D-V2-6: ¿Adoptar deprecation/archiving procedures?

- **A) SÍ.** Documentar en `normativa/procedimientos/` durante
  el rebuild. Implementar tooling después si hace falta.
- **B) NO inicialmente.** Resolver caso por caso.

Recomendación: A — la procedure documental es barata; el tooling
puede esperar.

### D-V2-7: ¿Adoptar Algolia / search avanzada?

- **A) SÍ.** Setup completo.
- **B) NO inicialmente.** Furo built-in basta hasta >1000 archivos
  o pedido explícito del equipo.

Recomendación: B.

## 7. Impacto sobre la strategy v1.2 si se adoptan las recomendaciones

### Cambios mínimos esperados

- **Idea 8 (NEW):** Metadata schema universal como contrato
  cross-domain (deriva de D-V2-2 + D-V2-5).
- **Idea 9 (NEW):** Operación post-rebuild — el repo no termina
  con el rebuild; tiene ciclo de vida (deprecation, archiving,
  staleness checks).
- **Decision 9 (NEW):** Single-product confirmado (D-V2-1.A) —
  cierra debate explícitamente.
- **Decision 10 (NEW):** STD_008 a crear como parte del WP
  `normativa/estandares` — define metadata schema estandarizado.
- **Decision 11 (NEW):** CODEOWNERS por dominio (D-V2-3.A) — se
  crea durante este WP o spinoff.
- **Decision 12 (NEW):** CI ampliado en spinoff WP (similar a
  bootstrap-hardening) o en `normativa/procedimientos`.

### Sin cambio

- 8 dominios de rebuild
- Orden secuencial
- Backup-as-reference
- Decisions 1-8 existentes

## 8. Recomendación al ejecutor

**Adoptar parcialmente (~40% de v2.0):** las capacidades de
metadata, ownership, CI extendido, staleness, deprecation/archiving
y procedure de governance ligero. **Descartar el 60% restante**
(scope multi-proyecto, 10 categorías corporativas, Algolia,
governance committee, 12 cajones).

**Próximo paso recomendado:**
1. El ejecutor responde D-V2-1..7.
2. Si confirma adopción parcial, bumpear strategy a v1.3 con las
   3 Ideas + 4 Decisions nuevas.
3. Cerrar Phase 5 STRATEGY.
4. Phase 6 PLAN traduce Decisions a tareas concretas (incluido
   spawn de WPs/procedimientos para los nuevos componentes).
