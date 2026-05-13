```yml
created_at: 2026-04-27 05:26:20
project: IACT-docs
analysis_version: 1.0
author: NestorMonroy
status: Borrador
```

# Phase 1 DISCOVER — Zero Warnings Build

**WP:** `2026-04-27-05-26-20-zero-warnings-build`
**Branch base:** `feature/repository-diagnostics` (puede mergearse a develop antes o trabajar derivada)
**Objetivo declarado por usuario:** **0 warnings** en `make clean && make html`.

> Nota sobre fases: este DISCOVER **no** define scope. Eso ocurre en Phase 6 SCOPE. DISCOVER captura contexto, evidencia, stakeholders y riesgos para que la decisión de scope sea informada.

---

## Estado actual (baseline observable)

`make clean && make html` ejecutado tras `bash scripts/setup.sh` con plantuml.jar bundled, 27-Apr-2026:

- **exit code:** `0` (build "succeeded")
- **HTML output:** 45 MB en `build/html/`
- **Diagramas PlantUML renderizados:** 173 PNGs
- **stderr:** 829 líneas — `306 WARNING:` + `173 ERROR:`

**Sphinx no falla** porque "ERROR" en docutils significa "error de parsing en el contenido", no "build broken". Sphinx los reporta y sigue.

---

## Inventario completo (479 issues)

### Por severidad (clasificación de Sphinx, no nuestra)

| Severidad | Cantidad | Significado |
|-----------|----------|-------------|
| ERROR | 173 | Falla de parsing en docutils — el bloque puede no renderizarse correctamente |
| WARNING | 306 | Algo no ideal pero el render continúa |
| **Total** | **479** | |

### Por categoría (`tag` que Sphinx asigna)

| Tag | Cantidad | % | Naturaleza |
|-----|----------|---|------------|
| `[docutils]` | **246** | 51% | Sintaxis RST mal formada en archivos del repo |
| `[toc.not_included]` | **177** | 37% | Archivos `.rst`/`.md` no listados en ningún `toctree::` |
| `[plantuml]` | **7** | 1.5% | Diagramas con paths de `!include` mal resueltos |
| Sin tag (otros) | ~49 | 10% | Misceláneos: tablas mal formadas, títulos cortos, labels duplicados |

### Top 10 patrones de mensaje (agrupados con tokens normalizados)

| # | Patrón | Severidad |
|---|--------|-----------|
| **166** | `document isn't included in any toctree` | WARNING |
| **131** | `Unknown target name: "X"` (link rota a label inexistente) | ERROR |
| **29** | `Bullet list ends without a blank line; unexpected unindent` | WARNING |
| **24** | `Unexpected indentation` | ERROR |
| **23** | `Block quote ends without a blank line; unexpected unindent` | WARNING |
| **13** | `Title underline too short` | WARNING |
| **8** | `Undefined substitution referenced: "X"` | ERROR |
| **7** | `error while running plantuml` (cannot include path) | WARNING |
| **5** | `Line block ends without a blank line` | WARNING |
| **3+3+3+3** | `duplicate label validación-N` (etiquetas repetidas en UC) | WARNING |

---

## Análisis por categoría

### A. `[toc.not_included]` — 177 warnings (37% del total)

**Síntoma:** archivos `.rst`/`.md` que existen en `source/` pero ningún `toctree::` los referencia.

**Significado:** Sphinx los procesa (genera HTML), pero el lector solo llega a ellos por URL directa o búsqueda — no aparecen en el menú de navegación.

**Posibles causas:**
- Decisión consciente: páginas de detalle accedidas vía link inline (válido pero requiere `:orphan:`).
- Olvido: archivo creado y no se actualizó el toctree padre.
- Refactoring incompleto: archivo movido sin actualizar refs.

**Resolución posible (Phase 4 CONSTRAINTS / Phase 5 STRATEGY):**
- Opción A: incluir el archivo en el toctree padre.
- Opción B: marcar `:orphan:` en el front matter (declara explícitamente que es huérfano).
- Opción C: borrar el archivo si quedó como deuda de refactoring.

### B. `[docutils]` — 246 issues (51% del total)

**Subdivisión:**
- 131 `Unknown target name: "X"` — refs `:ref:` o `_X_` apuntando a labels que no existen. La doc tiene ~131 links rotos.
- 24 `Unexpected indentation` — bloques con indentación incorrecta (después de directiva, lista, código).
- 8 `Undefined substitution referenced` — `|XXX|` sin `.. |XXX| replace::` definido.
- 3 `Unknown interpreted text role` — uso de roles inventados o de extensiones no cargadas.
- 1 `Document may not end with a transition` — archivo termina con `----`.
- 1 `"list-table" widths do not match` — `:widths:` declara N columnas, las filas tienen otro número.
- ~78 más: warnings de bullet/block-quote/line-block que no terminan con línea en blanco; títulos con underline corto.

**Mayoría son arreglables sin cambiar contenido**, pero requieren leer cada archivo: las refs rotas pueden ser typos o pueden ser refs a contenido que ya no existe.

### C. `[plantuml]` — 7 warnings

**Patrón:** `cannot include ../../../_static/plantuml-styles.puml`

7 archivos con `!include` de profundidad incorrecta. Coincide con lo que `scripts/validate-plantuml.sh` ya advierte: deben ser `../../_static/...` (2 niveles), no `../../../` (3 niveles). Trivial de fixear.

### D. Sin tag — ~49

- `Title underline too short` (13): cosmético, fix de un caracter por archivo.
- `duplicate label validación-N` (12+): casos de uso reusan labels — colisión por copy-paste de templates.
- Otros tablas, transiciones, etc.

---

## Stakeholders

| Rol | Interés | Nivel |
|-----|---------|-------|
| **NestorMonroy** (mantenedor) | Build limpio, CI con `-W` viable | Alto |
| **Lectores de la doc** (equipo IACT) | Páginas funcionando, refs no rotas | Alto — sufren los 131 links rotos y los 166 huérfanos |
| **Autores originales de los `.rst`** | Su intención preservada al "corregir" sintaxis | Medio — riesgo de regresión en Phase 10 |
| **CI/GitHub Actions** | Falla rápido si se introducen warnings nuevos | Medio — gate `-W` viable solo después del cleanup |

---

## Costo y beneficio (estimación cualitativa)

| Categoría | Esfuerzo | Beneficio | Recomendación inicial |
|-----------|----------|-----------|----------------------|
| `[plantuml]` (7) | Bajo (regex/sed) | Alto (diagramas que hoy no renderizan bien) | **Fix-first** |
| `Title underline too short` (13) | Bajo (un char por archivo) | Bajo | Fix mecánico |
| `duplicate label` (12+) | Bajo-medio (renombrar labels en UCs) | Medio | Fix mecánico con verificación |
| `Unexpected indentation` (24) | Medio (un caso a la vez) | Alto (ERROR en docutils) | Fix manual por archivo |
| `Bullet/block-quote sin blank line` (52) | Medio (mecánico pero abundante) | Medio | Script + revisión |
| `Unknown target name` (131) | **Alto** (cada link es decisión) | Alto (links rotos visibles al usuario) | Phase 5 STRATEGY decide approach |
| `toc.not_included` (177) | **Alto** (decisión por archivo: include o `:orphan:`) | Medio | Phase 5 STRATEGY decide policy |

---

## Riesgos clave (full registry en `zero-warnings-build-risk-register.md`)

- **R-01** "0 warnings" puede no ser alcanzable si extensiones third-party emiten warnings inevitables. Mitigación: definir scope final solo después de un experimento Phase 9 PILOT.
- **R-02** Fix masivo rompe contenido. Mitigación: commits atómicos por categoría.
- **R-04** Sumidero de tiempo (479 × 5 min ≈ 40 h). Mitigación: priorizar por impacto.
- **R-05** Warnings revelan deuda de IA más profunda (177 huérfanos). Mitigación: decisión explícita en Phase 5 sobre reorganizar vs `:orphan:`.

---

## Pregunta abierta para Phase 6 SCOPE

El usuario declaró el objetivo "**0 warnings**". Phase 6 deberá precisar:

1. **¿0 warnings de Sphinx ó 0 issues totales (incluye errores)?**
   - Sphinx no falla con ERRORs si el build "succeeded". Para CI gate real, hay que pasar `-W` que convierte WARN en ERROR. ¿Qué severidad disparar?
2. **¿"0" significa absoluto o "0 propias, supresión documentada de las inevitables"?**
3. **¿Scope incluye reescribir contenido (ej: borrar archivos huérfanos) o solo correcciones de forma?**
4. **¿Política de toctree: incluir todos los huérfanos al toctree, o marcar `:orphan:`, o eliminar?**
5. **¿Cap de horas o entrega por categoría completable?**

Respuestas → Phase 6 SCOPE.

---

## Síntomas observables

- `make html` reporta `build succeeded, 479 warnings` — métrica visible.
- 131 errores `Unknown target name` → 131 links rotos en el HTML publicado.
- 166 archivos huérfanos → ~37% del contenido no aparece en navegación.
- 7 diagramas con `!include` mal resuelto → diagramas con error visual (texto "Some diagram description contains errors") embebido.

---

## Próximo paso (sugerido)

**Saltar a Phase 3 ANALYZE** (sequence Mediano: 1→3→5→6→8→10→11). DISCOVER ya capturó el inventario; ANALYZE profundiza causa raíz por categoría antes de decidir estrategia en Phase 5.

Alternativa Phase-2 MEASURE: ya tenemos el baseline (479) — no se necesita un stage MEASURE separado si el objetivo es contraste numérico simple.
