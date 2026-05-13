```yml
created_at: 2026-04-28 00:19:57
project: IACT-docs
analysis_version: 1.0
author: NestorMonroy
status: Borrador
```

# Phase 1 DISCOVER — Auditoría de Referencias en source/

**WP:** ``2026-04-28-00-19-57-source-references-audit``
**Branch:** ``feature/repository-diagnostics``
**Scope declarado por el ejecutor:** registrar y analizar **cuántas
referencias** hay en la documentación que vive en ``source/``, separar
las que existen de las que no, y dejar un plan de acción.

> **IMPORTANTE — alcance del WP:**
> Este WP es **solo de auditoría y registro**. NO modifica archivos
> ``.rst``, NO crea, NO elimina contenido. Su entregable es un inventario
> + plan documentado. La ejecución del cleanup ocurre en un WP posterior
> separado.

---

## Snapshot inicial

Capturado el 2026-04-28 00:19:57 con scripts ad-hoc (regex sobre
``source/**/*.rst``):

| Métrica | Valor |
|---------|-------|
| Archivos ``.rst`` en ``source/`` | **377** |
| Archivos ``.md`` en ``source/`` | **0** ✅ (regla cumplida) |
| Total entradas en toctree | 376 |
| Total inline targets (``.. _label:``) | 306 (en 210 archivos) |

## Inventario de referencias por tipo

| Tipo | Total | Archivos afectados |
|------|-------|--------------------|
| Menciones de paths ``.md`` | **976** | **93** archivos |
| Menciones de paths ``.rst`` | 357 | 69 |
| Inline targets (``.. _label:``) | 306 | 210 |
| ``:ref:`` (cross-ref Sphinx) | 204 | 34 |
| Menciones de paths ``.puml`` | 121 | 28 |
| URLs externas (``<https://...>``) | 94 | 34 |
| ``:doc:`` references | 29 | 10 |
| ``.. image::`` directives | 1 | 1 |

## Refs ``.md`` agrupadas por destino único

| Métrica | Valor |
|---------|-------|
| Targets ``.md`` únicos referenciados | **518** |
| Total ocurrencias | **976** |
| Targets que existen como ``.md`` actual | **0** (regla cumplida) |
| → **Todas las 976 son refs muertas por definición** | ✅ |

## Categorización de los 518 targets únicos

| Caso | Targets únicos | Ocurrencias | Estrategia propuesta |
|------|----------------|-------------|---------------------|
| **A** — Target con ``.rst`` hermano (mismo dir/path) | 33 | **155** | Auto-fix: cambiar ``.md`` → ``.rst`` |
| **B** — Target sin equivalente, sin path externo | **409** | **691** | Manual: eliminar / actualizar / convertir a literal texto |
| **C** — Target a path externo conocido (provisioning, api, backend, etc.) | 76 | **130** | Convertir a literal monospace ``\`\`path\`\``` (no link) |
| **D** — Relativo con ``..`` ambiguo | 0 | 0 | — |
| **TOTAL** | **518** | **976** | |

## Top 15 destinos más referenciados

| Ocurrencias | Target | Categoría aproximada |
|-------------|--------|----------------------|
| 27× | ``README.md`` | C externo o B raíz |
| 18× | ``CHANGELOG.md`` | B raíz |
| 13× | ``readme.md`` | B variante minúsculas |
| 10× | ``descripcion.md`` | B sin equivalente |
| 10× | ``plantilla_django_app.md`` | C externo (template backend) |
| 10× | ``verificar_servicios.md`` | C externo (devops) |
| 9× | ``INDICE.md`` | B raíz |
| 9× | ``procedimiento_qa.md`` | A — existe ``procedimiento_qa.rst`` |
| 9× | ``docs/guias/GUIA-BACK-003-authentication-guide.md`` | C externo |
| 8× | ``arquitectura/lineamientos_codigo.md`` | A — existe ``lineamientos_codigo.rst`` |
| 8× | ``procedimiento_desarrollo_local.md`` | A — existe ``.rst`` |
| 8× | ``procedimiento_release.md`` | A — existe ``.rst`` |
| 8× | ``PROCED-GOB-009-refactorizaciones-codigo-tdd.md`` | A — existe ``.rst`` |
| 8× | ``procedimiento_gestion_cambios.md`` | A — existe ``.rst`` |
| 8× | ``checklist_desarrollo.md`` | C externo (checklists/) |

## Top 15 archivos ``.rst`` con más refs ``.md`` rotas

| Refs | Archivo |
|------|---------|
| **208** | ``normativa/procedimientos/PROC-GOB-001-mapeo_procesos_templates.rst`` |
| 39 | ``normativa/procedimientos/Procesos de Gobernanza-README.rst`` |
| 39 | ``normativa/procedimientos/PROC-001-gobernanza_sdlc.rst`` |
| 38 | ``normativa/procedimientos/PROC-GOB-008-reorganizacion-estructura-documental.rst`` |
| 38 | ``normativa/procedimientos/PROCED-GOB-005-analisis-impacto-cambios.rst`` |
| 30 | ``normativa/gobernanza/ADR-GOB-006-clasificacion-reglas-negocio.rst`` |
| 25 | ``normativa/gobernanza/ADR-GOB-005-jerarquia-requerimientos-5-niveles.rst`` |
| 24 | ``normativa/procedimientos/procedimientos operacionales-readme.rst`` |
| 21 | ``gestion/pm/checklists/Checklists del backend- README.rst`` |
| 21 | ``normativa/gobernanza/Architecture Decision Records (ADRs) - Indice Maestro.rst`` |
| 20 | ``normativa/procedimientos/guia_completa_desarrollo_features.rst`` |
| 20 | ``normativa/procedimientos/procedimiento_trazabilidad_requisitos.rst`` |
| 19 | ``normativa/procedimientos/PROCED-GOB-007-consolidacion-ramas-git.rst`` |
| 19 | ``normativa/gobernanza/ADR-GOB-007-especificacion-casos-uso.rst`` |
| 18 | ``normativa/procedimientos/PROCED-GOB-009-refactorizaciones-codigo-tdd.rst`` |

**Observación:** ``PROC-GOB-001-mapeo_procesos_templates.rst`` concentra
21% de TODAS las refs ``.md`` del repo. Es el blast-zone principal del
cleanup.

## Distinción crítica: refs validadas vs menciones de texto

Sphinx **solo valida** las refs que reconoce como hyperlinks
estructurados (``:ref:``, ``:doc:``, ``<URL>``, ``[text](file.md)``,
etc.). El resto son menciones en texto plano, citas en code blocks,
ejemplos en plantillas que no se intentan resolver.

| Categoría | Cantidad | ¿``sphinx-build -W`` falla? | ¿``-b linkcheck`` falla? |
|-----------|----------|------------------------------|---------------------------|
| Hyperlinks reales rotos | **147** | ❌ no detecta | ✅ sí — bloquea |
| Menciones ``.md`` en texto plano | **829** | ❌ no | ❌ no |
| Total refs ``.md`` | **976** | | |

**Implicación:** los 829 son **deuda de contenido**, no bloqueador de
build. El release v1.1.0 puede salir con esos refs si se tolera el
texto desactualizado, pero los 147 sí bloquean.

## Otros tipos de refs detectados

### Inline targets (``.. _label:``) — 306

Todos válidos por definición (no se usan, simplemente declaran). El
problema serían **labels duplicados** entre archivos, ya tratados en el
WP zero-warnings-build (47 renombrados con prefijo).

### ``:ref:`` cross-references — 204

No analizados aquí en detalle. Sphinx los valida en build estricto
(``-W``); si quedaran rotos, ya hubieran salido como ``Unknown target
name`` en el WP zero-warnings-build (que llegó a 0).

### ``:doc:`` references — 29

Igual: validados por ``-W``.

### URLs externas — 94

No validadas por ``-W`` (solo por ``-b linkcheck``). De los 147 broken
detectados, ~14 son URLs externas (sitios caídos / movidos).

### Refs ``.puml`` — 121

Diagramas PlantUML referenciados como ``!include``. Sphinx no los
valida estructuralmente; PlantUML los procesa al renderizar diagramas.
Si el path es incorrecto, sale como warning de plantuml (ya tratado en
F-15 del WP repository-diagnostics).

## Hallazgos clave

| ID | Hallazgo | Severidad |
|----|----------|-----------|
| **F-AUD-01** | ``source/`` contiene **0 archivos ``.md``** — la regla del proyecto se cumple | INFO ✅ |
| **F-AUD-02** | Hay **976 menciones de ``.md``** en archivos ``.rst`` apuntando a archivos que NO existen | Alta |
| **F-AUD-03** | **518 destinos únicos** distintos: el problema NO es 976 fixes individuales, son ~518 decisiones de qué hacer con cada destino | Alta |
| **F-AUD-04** | Solo **147** son hyperlinks que bloquean ``linkcheck`` (release blocker) | Crítica |
| **F-AUD-05** | **829** son menciones en texto plano (no bloquean build) — deuda diferida posible | Media |
| **F-AUD-06** | **155 ocurrencias (Caso A)** son auto-fixeables: ``.rst`` hermano existe, basta sustituir extensión | Quick win |
| **F-AUD-07** | **691 ocurrencias (Caso B)** requieren juicio caso-por-caso: el archivo destino simplemente NO existe en repo ni hay equivalente claro | Trabajoso |
| **F-AUD-08** | **130 ocurrencias (Caso C)** son refs a otros repos del sistema IACT (provisioning, api, backend, frontend, devops) — no fixeables aquí, convertir a literal | Decisión semántica |
| **F-AUD-09** | **PROC-GOB-001** concentra el 21% de las refs muertas (208 de 976). Fixear ese archivo da el mayor delta inmediato | Hot spot |
| **F-AUD-10** | Top destinos refs (``README.md``, ``CHANGELOG.md``) son archivos que SÍ existen pero en raíz, no en ``source/`` — refs apuntan al lugar equivocado | Patrón |

## Stakeholders

| Rol | Interés |
|-----|---------|
| **NestorMonroy** | Tener inventario completo y plan documentado antes de fix |
| **Lectores de la doc** | Que los links funcionen al hacer click en HTML |
| **Validador del CI** (pipeline futuro) | ``linkcheck`` con 0 broken como gate post-merge |
| **Operador del release** | Release v1.1.0 sin refs muertas |

## Restricciones aplicables

- **Sin archivos ``.md`` en ``source/``** (regla cumplida, no violar).
- **No crear stubs ``.rst`` artificiales** para resolver refs que apunten
  a docs que ya no existen — eso infla ``source/`` con contenido
  vacío.
- **No commitear cambios de ``.rst`` en este WP** — solo análisis.
- **Mantener ``sphinx-build -W`` exit 0** (estado actual del WP
  zero-warnings-build) durante todo el cleanup posterior.

## Síntomas observables

- ``sphinx-build -b linkcheck`` reporta **147 broken links**.
- ``grep -r '\.md' source/ --include='*.rst' | wc -l`` ≈ **976**
  ocurrencias.
- En el HTML rendered, los hyperlinks aparecen sin destino o con error
  404 al click.
- Top archivos problemáticos están en ``normativa/procedimientos/`` —
  área de mayor deuda de migración md→rst.

## Plan de acción propuesto (entrada para Phase 5 STRATEGY del WP cleanup)

### Plan en niveles

**Nivel 1 — Mínimo para release v1.1.0** (147 broken hyperlinks)

- Solo los refs validados por ``linkcheck``.
- Aplica estrategia A+C+D del WP deployment-pipeline (analyze
  dead-references-analysis.md):
  - A: auto-fix ``.md`` → ``.rst`` cuando existe (33 destinos × ~5
    ocurrencias = ~155 ocurrencias, pero solo subset son hyperlinks)
  - C: literal monospace para externos (~14)
  - D: ``linkcheck_ignore`` para URLs caídas (~14)
- Esfuerzo: ~1-2 horas.
- Desbloquea release v1.1.0.

**Nivel 2 — Limpieza completa de menciones ``.md``** (976 ocurrencias)

- Incluye los 829 que no bloquean build pero son texto desactualizado.
- Trabajo principal: revisar PROC-GOB-001 (208 refs) y los otros top.
- Esfuerzo: ~6-10 horas.
- Mejora calidad de texto pero no es release blocker.

**Nivel 3 — Audit periódico**

- Agregar step ``linkcheck`` a ``validate.yml``.
- Documentar en lessons-learned el patrón "no commitear refs ``.md``
  desde ``source/``".

## Próximo paso

Este WP **termina aquí en Phase 1 DISCOVER**. Su entregable es este
documento + el risk register. **No avanza a Phase 3+** porque el
ejecutor declaró scope "registrar y analizar".

El plan de acción documentado arriba es **input** para un futuro WP
de cleanup (probablemente un sub-WP del deployment-pipeline o uno
independiente, según decisión del ejecutor).

## Decisiones a tomar (post-audit, no en este WP)

1. ¿**Cleanup nivel 1 antes de release v1.1.0**? (recomendado para
   no shipping con linkcheck rojo)
2. ¿**Nivel 2 como WP separado** o como continuación del
   deployment-pipeline?
3. ¿**Agregar ``linkcheck`` a ``validate.yml``** en modo blocking,
   warning, o post-release?
4. ¿**Política de "no .md refs en source/"** documentada como
   invariante del proyecto?
