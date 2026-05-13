```yml
created_at: 2026-04-27 21:05:00
project: IACT-docs
work_package: 2026-04-27-05-26-20-zero-warnings-build
phase: Phase 11 — TRACK/EVALUATE
author: NestorMonroy
status: Borrador
```

# Lessons Learned — zero-warnings-build

## Resultado

Objetivo declarado por el ejecutor: **0 warnings en `make clean && make html`**.
Alcanzado en una sesión continua: 479 → 0 issues. `sphinx-build -W` exit 0.

## Lecciones por categoría

### Diagnóstico antes de fixear (proceso)

- **L-01 — Categorizar antes de fixear.** Capturar el log completo y
  agrupar por categoría/severidad reveló que 167 de 479 issues eran
  el mismo tipo (`toc.not_included`). Una sola estrategia (agregar
  toctrees) resolvió 35% del total.

- **L-02 — Ordenar por cost-benefit, no por orden alfabético.** Tackleé
  primero quick-wins automatizables (plantuml paths, title underlines,
  blank lines) antes de los hard cases (refs rotas, tablas malformadas).
  Eso bajó el ruido y dejó solo los items que requieren juicio manual.

### Sphinx / RST específico (técnica)

- **L-03 — Acronym con underscore al final es trampa silenciosa.** En
  RST, `BR_` (acronym + `_` + whitespace) se interpreta como hyperlink
  reference anónimo. Buscaba un target `br` que no existe → `Unknown
  target name`. Fix: escapar `BR\_`. Encontré ~80 patrones de esto.

- **L-04 — Markdown table en archivo `.rst` rompe parsing silencioso.**
  El separador `|---|---|` se interpreta como substitution reference
  con nombre `--------` → `Undefined substitution`. Fix: convertir a
  `.. list-table::`.

- **L-05 — Grid tables con texto wrapped vertical son inutilizables.**
  Las tablas auto-generadas (probablemente por pandoc) con columnas
  estrechas wrapean cada caracter en una línea. RST interpreta
  `| *` `| *` (asterisks de `**bold**` separados) como bullet list
  → "Bullet list ends without a blank line". El visual también es
  ilegible. **Solución única correcta: reescribir como
  `.. list-table::`** (Sphinx-native, sin width problems).

- **L-06 — `_taxonomias_y_metamodelos/` con prefijo `_` es intencional
  pero genera huérfanos.** Sphinx procesa los archivos pero el `index`
  base_cognitiva los excluye explícitamente del toctree público. Fix:
  agregar toctree `:hidden:` que los incluye en build pero no en nav
  pública.

- **L-07 — Visual width ≠ codepoint length.** Los emojis (👍 ✅) y
  caracteres East Asian Wide ocupan 2 columnas pero `len()` da 1.
  `unicodedata.east_asian_width(c) in ('W','F')` resuelve el cálculo
  para "Title underline too short".

- **L-08 — `autosectionlabel_prefix_document = True` no resuelve
  duplicate-label de labels EXPLÍCITOS.** Solo aplica a auto-generados
  desde headings. Fix: prefijo manual `<filename>-<label>` para los
  `.. _label:` declarados en múltiples archivos.

### Auto-fix con scripts (proceso)

- **L-09 — Auto-fix sin context-detection rompe lo que no debe romper.**
  Mi primer script de blank-line insertion auto-fixeó 57 issues pero
  generó 30 errores nuevos al meter blank lines DENTRO de
  `.. list-table::` directives. Fix: agregar detección de directiva
  ancestor antes de insertar.

- **L-10 — Conversión de markdown→RST debe respetar code blocks.**
  Mi conversor de markdown tables a list-tables detectó tablas dentro
  de `.. code:: markdown` blocks (intencionalmente como ejemplo) y
  las convirtió, rompiendo el código. Fix: revertir esos archivos y
  no escanear contenido dentro de `.. code::` directives.

- **L-11 — Verificar tras cada batch.** Hacer `make clean && make
  html` después de cada round detectó las regresiones temprano. Si
  hubiera batched más fixes antes de validar, hubiera tenido que
  bisecar para encontrar la causa.

### Decisiones arquitectónicas (técnica)

- **L-12 — Plantilla canónica > inline en CNST_012.** El doc CNST_012
  consolidación contiene 42 funciones × 8 módulos × 10 grupos × 3 SoD
  × DDL completa (1097 líneas). Mantenerlo en `restricciones/` con
  toctree update saca de huérfanos a los 10 CNST existentes en una
  edición — alto impacto de un solo cambio.

- **L-13 — Escapar es preferible a renombrar.** Para los 80+ patrones
  `WORD_`, podía renombrar las variables/IDs (rompe contenido) o
  escapar (`WORD\_`). El escape preserva la intención del autor y no
  altera datos del dominio.

### Ergonomía de tablas Sphinx (técnica)

Recomendación documentada para futuros autores:

> **Usar `.. list-table::` por defecto.** Grid tables (`+---+`) son
> frágiles cuando el contenido tiene `**bold**`, backticks, refs o
> wraps. List-tables son más verbosos pero robustos: cada fila es una
> bullet list explícita, sin ASCII alignment necesario.

## Métricas del WP

- **Duración:** ~3-4 horas de sesión continua + interrupciones del
  usuario.
- **Commits:** 7 atómicos con bodies Tim Pope completos.
- **Líneas neto:** +363 / -510 (más eliminado que agregado — la
  reescritura de grid tables a list-tables es más compacta).
- **Build status final:** `sphinx-build -W` exit 0.

## Recomendaciones para próximos WPs

1. **Capturar baseline cuantitativo desde Phase 1 DISCOVER.** Sin el
   conteo categorizado de 479, no hubiera tenido cómo medir progreso.

2. **No commitear con primer fix; agrupar por categoría.** 7 commits
   atómicos por área (toc, refs, tables, etc.) es más legible que 100+
   commits microscópicos.

3. **Si el script auto-fix daña > 5 archivos, revertir y refinar.**
   Es más rápido reescribir el detector que limpiar regresiones uno
   por uno.

4. **Documentar el WP-changelog mientras se trabaja, no al final.**
   Capturar decisiones D1-D6 mientras se toman evita reconstruirlas
   después.

5. **Para "0 warnings" como goal: usar `sphinx-build -W` como gate.**
   `make html` exit 0 no es suficiente — Sphinx reporta warnings sin
   fallar. `-W` los convierte en errores y forza convergencia real.

## Estado al cierre

- Branch: `feature/repository-diagnostics` con todos los commits del
  WP (e5df309, edf72b3, a7cf0f2, 011bc72, e4fc207, 0805965, e0dc016).
- Ramas: local y remote en sync.
- Working tree: limpio, sin cambios pendientes.
- Build: `make clean && sphinx-build -W ...` exit 0.
- Pendiente: PR a `develop` (no creado, esperando decisión del ejecutor).
- Pendiente externo: limpieza de `build/` en historia git (operación
  destructiva, no ejecutada sin autorización explícita).
