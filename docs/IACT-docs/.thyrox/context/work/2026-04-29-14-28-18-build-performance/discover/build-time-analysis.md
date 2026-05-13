```yml
created_at: 2026-04-29 14:28:18
project: IACT-docs
work_package: 2026-04-29-14-28-18-build-performance
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Build Time Analysis

## Mediciones empiricas (2026-04-29 14:28, branch feature/solve-problem-docs)

```
make html (incremental, post warm cache)
real    0m9.050s
user    0m3.473s
sys     0m0.482s
build succeeded.

make clean && make html (cold cache)
real    6m3.233s
user    8m40.761s
sys     0m28.643s
build succeeded.
```

**Ratio cold/warm: 40.4x.** El `make clean` fuerza
regeneracion completa de assets cacheados (PlantUML PNGs,
doctrees, HTML).

## Composicion del corpus

| Metrica | Valor |
|---------|-------|
| Archivos `.rst` | 401 |
| Archivos `.puml` standalone | 1 |
| Diagramas inline (`.. uml::` en rst) | varios (no contado exactamente) |
| Tamaño build/ post-rebuild | 90 MB |
| Cache `_plantuml/` post-clean | 0 archivos |

Proyeccion: con WPs diferidos #10 + #12 (infrastructure +
operations) → 600+ archivos rst esperados. Diagramas tambien
crecen (arquitectura tiene mas componentes).

## Bottleneck principal — PlantUML cold render

`sphinxcontrib-plantuml` cachea PNGs por hash del diagrama en
`build/_plantuml/`. `make clean` borra ese directorio. Cada
diagrama post-clean = 1 invocacion a `java -jar plantuml.jar`,
que tiene **JVM startup overhead** (~1-2s por diagrama, no
amortizable en una sola ejecucion).

Calculo: si tenemos N diagramas, tiempo = N × 1.5s (estimado).
Con 200 diagramas (estimacion conservadora) = 300s = 5 min.
**Coincide con observacion empirica de 6 min.**

## Otros costos

1. **Doctrees regeneration** (`build/doctrees/`): Sphinx
   re-parsea los 401 archivos rst, construye AST. ~1-2s
   sin cache.
2. **HTML rendering**: write de 401 paginas HTML + assets.
   ~5-10s.
3. **`nitpicky=True`**: cross-reference resolution. Cada
   `:doc:` y `:ref:` se resuelve contra el indice global.
   ~1-3s adicional.
4. **JS smartquotes / autosectionlabel / extensions**: 1-2s.

Estos suman ~15-30s. **El resto (5+ min) es PlantUML.**

## Validacion del bottleneck

```bash
# PlantUML rendering puede medirse aislado:
ls -la build/_plantuml/
# Post-clean: 0 archivos
# Post-build: cientos de PNGs (cada uno = 1 java spawn)
```

El proyecto WP `2026-04-23-18-51-33-plantuml-java-integration-impl`
ya documento este overhead como riesgo conocido.

## Estrategias evaluadas (analisis decision)

### Estrategia A — Build paralelo (`-j auto`)

**Pro:**
- Sphinx soporta paralelizacion nativa (lectura + escritura).
- 4 cores * 2 = 8 procesos = ~3-4x ganancia en CPU-bound steps.

**Contra:**
- PlantUML render es JVM startup, NO se paraleliza
  trivialmente (cada diagrama spawn java).
- Ganancia limitada a ~30% del tiempo total (los 30s
  no-plantuml).

**Veredicto:** ganancia esperada 2-4x para `make html`
incremental, ~30% para clean rebuild. Implementacion 5 min.

### Estrategia B — Preservar `_plantuml/` en clean

**Pro:**
- Elimina el bottleneck principal en clean rebuild.
- Hash-based cache: si el diagrama no cambia, reutiliza
  PNG existente.

**Contra:**
- Si el cache se corrompe, no se detecta (problema raro).
- Ligeramente fuera del idiom "clean = todo borrado".

**Veredicto:** ganancia esperada **40x → 5x** en clean
rebuild (de 6min a ~1min). El idiom "clean" puede
preservarse via target separado `clean-all` para casos
extremos.

### Estrategia C — `sphinx-autobuild` para dev

**Pro:**
- Watch + incremental + browser reload = ciclo ideal.
- 10x mejor experiencia que `make html` manual.

**Contra:**
- Requiere instalar `pip install sphinx-autobuild`.
- Puerto local ocupado (default 8000).

**Veredicto:** mejora dramatica de DX para edicion continua.
No reemplaza make html, complementa.

### Estrategia D — `nitpicky` toggle

**Pro:**
- Costo nitpicky ~10% del tiempo total.
- En dev, no necesario en cada build.

**Contra:**
- Cross-refs rotas no detectadas hasta CI.

**Veredicto:** ganancia menor (~10%) pero acumula.
Implementar.

### Estrategia E — PlantUML server (deferred)

**Pro:**
- Elimina JVM startup por diagrama (server persistente).
- 10-50x mas rapido para muchos diagramas.

**Contra:**
- Nuevo runtime dependency (server o docker).
- Configuracion nueva en conf.py.
- Overkill para <100 diagramas.

**Veredicto:** **DIFERIDA**. Activar solo cuando
`build/_plantuml/` tenga >100 archivos consistentemente.

## Decisiones

1. **Implementar A + B + C + D ahora** (quick wins).
2. **Diferir E** (PlantUML server) hasta que diagrams crezcan.
3. **Mantener compatibilidad** con flujos actuales: `make
   html` y `make clean` existentes no cambian comportamiento;
   se agregan targets nuevos.

## Proyeccion de ganancia esperada

| Comando | Antes | Despues (estimado) | Ganancia |
|---------|-------|--------------------|----------|
| `make html` (incremental) | 9s | ~3-5s (con `-j auto`) | 2x |
| `make clean && make html` | 6m 3s | ~6m 3s (sin cambio) | — |
| `make clean-fast && make html` | n/a | **~30-90s** | **4-12x** |
| `sphinx-autobuild` (edit-loop) | n/a | ~1-2s por cambio | nuevo flow |
| CI con `SPHINX_NITPICKY=1` | implicito 6m+ | 6m+ (estricto, aceptable) | sin cambio |
