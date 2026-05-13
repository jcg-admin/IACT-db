```yml
created_at: 2026-04-30 19:30:24
project: IACT-docs
work_package: 2026-04-30-19-30-24-token-consumption-analysis
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador (hold)
version: 1.0.0
```

# DISCOVER — Drivers candidatos del consumo de tokens

> Este documento es un **inventario inicial**, no un análisis
> formal. La verificación cuantitativa pertenece a Phase 2
> MEASURE y queda diferida hasta que el ejecutor retome el
> WP.

## Observación origen

Durante la integración de las guías Schmuller H7-H12 en
``source/requisitos/_metodologia-aplicacion/``, el ejecutor
reportó que un solo intercambio (resume + pegado de guía +
generación de archivo + commit) consumió aproximadamente el
25% del context window disponible.

Clasificación: **OBSERVABLE** (autoreporte del ejecutor),
no medido directamente.

## Drivers candidatos

### D1 — Overhead estructural recurrente por sesión

Componentes que se inyectan al inicio de cada turno o
sesión, independientes del trabajo solicitado:

- **`.claude/rules/*.md`** cargados como project
  instructions. En el repo IACT-docs hay al menos:
  ``calibration-verified-numbers.md``, ``metadata-standards.md``,
  ``convention-naming.md``, ``commit-conventions.md``,
  ``changelog-policy.md``, ``thyrox-invariants.md``,
  más el ``CLAUDE.md`` raíz del proyecto.
- **SessionStart hooks** que imprimen:
  - Lista completa de tech skills activos (~80 entradas).
  - Lista completa de agentes registrados (~29 archivos).
  - Estado del WP activo y opciones de ejecución.
- **Listado de skills disponibles** vía system reminder (más
  de 60 entradas con sus descripciones).
- **CLAUDE.md raíz** — contexto persistente del proyecto.

Tamaño estimado: SPECULATIVE — pendiente de medir en Phase 2.

### D2 — Resume del compact

Cuando una sesión se compacta, el summary generado:

- Reincluye texto narrativo extenso del intercambio previo.
- Cita verbatim porciones de archivos críticos (extractos de
  guías ya creadas, fragmentos de PlantUML, etc.).
- Repite todos los hooks de SessionStart (rules + skills +
  agents) en el resume.

Hipótesis: el resume puede ser comparable en tamaño al
contenido original que pretende resumir, especialmente
cuando hay múltiples archivos grandes en el intercambio.

### D3 — Pegado de documentos largos en el turno

El usuario pegó las guías Schmuller H7, H8, H9, H10, H11, H12
secuencialmente, cada una entre ~8 KB y ~12 KB de markdown
con bloques Mermaid + ASCII. El contenido pegado se incluye
en el siguiente summary cuando llega un compact, lo que
**amplifica** el costo: pegar una vez paga input una vez,
pero el resume puede repetirlo en sesiones siguientes.

### D4 — Output generado

Cada guía RST generada en este scope tiene entre 200 y 350
líneas. La salida es facturable y, si el archivo existente
se rewrite, el costo se duplica respecto a un Edit
quirúrgico. La política del proyecto ya prefiere Edit, pero
algunos archivos nuevos justifican Write completo.

### D5 — Tool overhead

- ``Read`` de archivos largos antes de un ``Edit`` carga el
  contenido completo en context aunque solo se modifiquen
  pocas líneas.
- ``Bash`` con comandos que producen mucha salida (e.g.
  ``ls -la``, ``find``) ensucia el context.

## Mitigaciones candidatas (no aplicar todavía)

Listadas para Phase 5 STRATEGY cuando se retome el WP. No
implementar sin medir antes.

1. Auditar ``.claude/rules/*.md`` y consolidar contenido
   redundante. Algunas reglas duplican afirmaciones (ejemplo
   sospechado: I-002 en ``thyrox-invariants.md`` y la
   sección "Locked Decisions" del ``CLAUDE.md``).
2. Reducir verbosidad del SessionStart hook: la lista
   completa de tech skills y agents podría imprimirse solo
   cuando hay cambios, o resumirse a un conteo.
3. Convención de pegado: para guías largas, pedir al usuario
   pegar en chunks por sección en lugar de la guía completa,
   o referenciar archivos del repo en vez de pegar.
4. Dividir las guías H7-H12 ya creadas en lecturas más
   atómicas si se editan iterativamente.
5. Evitar ``Read`` completos cuando solo se necesita una
   sección — usar ``Read`` con ``offset`` y ``limit``.

## Riesgos del propio análisis

- Auto-reporte del ejecutor sobre consumo de tokens es
  imperfecto: no tenemos acceso directo a métricas del
  harness. Cualquier número en Phase 2 será una
  aproximación.
- Cambios a hooks o a ``.claude/rules/`` pueden tener
  efectos colaterales sobre la calidad del trabajo (las
  reglas existen por motivos válidos). Toda mitigación debe
  pasar por un piloto antes de adoptarse.

## Próximo paso

**No avanzar a Phase 2 MEASURE** hasta orden explícita del
ejecutor. Este documento queda como punto de retoma.
