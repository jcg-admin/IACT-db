```yml
created_at: 2026-04-28 00:30:00
project: IACT-docs
work_package: 2026-04-27-23-28-26-deployment-pipeline
phase: Phase 3 — DIAGNOSE (sub-análisis)
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Análisis de Referencias Muertas — Bloqueo del primer release

## Hallazgo

`sphinx-build -W` pasa con 0 warnings/errors **pero** ejecutar
`sphinx-build -b linkcheck` revela **147 links rotos** que el modo
estricto no detecta. Esto bloquea el primer release `v1.1.0` declarado en
Phase 5 STRATEGY: el paquete no debería publicarse con refs muertas.

## Distribución de los 147 broken links

### Por tipo de target

| Tipo | Cantidad | Naturaleza |
|------|----------|------------|
| `.md` | **127** | Mayoría — refs a archivos Markdown que ya no existen |
| URL externa (.com/.org) | ~14 | Sitios externos caídos o movidos |
| `.puml` | 7 | Diagramas PlantUML referenciados pero no en repo |
| `.sh`, `.py` | 5 | Scripts/código fuera del repo de docs |
| Otros | ~4 | Stubs varios |

### Por archivo origen (top 10)

| Archivo | Broken |
|---------|--------|
| `normativa/procedimientos/Procesos de Gobernanza-README.rst` | 14 |
| `arquitectura_tecnica/arquitectura/README.rst` | 13 |
| `arquitectura_tecnica/arquitectura/Diagramas de Referencia - README.rst` | 12 |
| `arquitectura_tecnica/diseño_detallado/README_diseno_detallado.rst` | 7 |
| `normativa/procedimientos/guia_completa_desarrollo_features.rst` | 5 |
| `normativa/gobernanza/ADR-DEVOPS-001-vagrant-mod-wsgi-IMPORTANTE-PRODUC.rst` | 5 |
| `normativa/estandares/shell_scripting_guide.rst` | 5 |
| `gestion/pm/checklists/README.rst` | 5 |
| `normativa/procedimientos/PROC-GOB-001-mapeo_procesos_templates.rst` | 4 |
| `normativa/procedimientos/PROC-DEV-001-pipeline_trabajo_iact.rst` | 4 |

## Causa raíz

Patrones identificados:

### 1. Migración `.md → .rst` incompleta (127 refs ≈ 86%)

La mayoría de refs apuntan a archivos como
``../../arquitectura/README.md`` cuando hoy existe ``arquitectura/README.rst``
o el archivo ya fue eliminado. La migración de Markdown a RST dejó refs
sin actualizar.

Sub-categorías:

- **`.md` que ahora son `.rst`** — fix: cambiar extensión en el href.
- **`.md` que ya no existen** — fix: eliminar el ref o reemplazar con
  texto plano.
- **`.md` que existen como `.rst` con otro nombre** — fix: actualizar el
  href al archivo correcto.

### 2. Refs a archivos fuera del repo de documentación (~15 refs)

Refs como:
- `../../../provisioning/bootstrap.sh`
- `../../../scripts/verificar_servicios.sh`
- `../../../vagrantfile`
- `../../api/callcentersite/.../logging.py`
- `../../backend/arquitectura/configuration.md`

Estos archivos están en **otros repos del sistema IACT** (backend, infra,
provisioning) — no son parte de este repo de docs. Sphinx no puede
resolverlos porque no existen relativo al `source/`.

### 3. URLs externas caídas (~14 refs)

Sitios web que cambiaron de URL o están temporalmente caídos al momento
del linkcheck. Algunos pueden volver; otros son bit-rot real.

## Estrategias posibles

| Estrategia | Cobertura | Esfuerzo | Riesgo |
|------------|-----------|----------|--------|
| **A.** Reemplazar `.md` refs por `.rst` automáticamente cuando el `.rst` exista | ~50-70 refs | Bajo (sed) | Bajo |
| **B.** Eliminar refs a `.md` cuyo target no existe en repo | ~50-60 refs | Medio (manual) | Medio (pierde info) |
| **C.** Convertir refs a archivos de OTROS repos en texto plano (sin enlace) | ~15 refs | Bajo (sed) | Bajo |
| **D.** Configurar `linkcheck_ignore` en conf.py para URLs externas inestables | 14 URLs | Bajo (config) | Bajo |
| **E.** Crear stubs para `.md` referenciados | 127 refs | Muy alto | Alto (deuda nueva) |
| **F.** Mantener referencias muertas y aceptar que linkcheck reporte fail | 0 fix | Cero | Bloquea release |

## Estrategia recomendada

**Combinación A + B + C + D** ejecutadas en orden:

1. **A primero**: script que detecta `xxx.md` y verifica si existe `xxx.rst` en el mismo path. Si sí, reemplazar. Esperado: ~50-70 fixes automáticos sin riesgo.

2. **C segundo**: identificar refs a paths fuera del repo de docs (provisioning, scripts, api, backend, vagrantfile, etc.) y convertirlos a literal monospace ``\`\`path\`\``` (texto, no enlace). Esperado: ~15 fixes.

3. **B tercero**: para los `.md` que quedaron sin equivalente `.rst`, **leer cada archivo origen** y decidir caso por caso:
   - Si el ref es dispensable: eliminar.
   - Si el contenido linkeado existe en otro path: actualizar el href.
   - Si necesita stub: crear placeholder mínimo en RST.

4. **D último**: configurar `linkcheck_ignore` para URLs externas que sabemos inestables (gnu.org timeouts, docs.iact que es interna no resolvible desde CI, etc.).

## Estimación de esfuerzo

| Paso | Esperado | Acumulado |
|------|----------|-----------|
| A (auto md→rst) | -50 a -70 | 77-97 restantes |
| C (paths externos→literal) | -15 | 62-82 restantes |
| D (ignore URLs externas) | -14 | 48-68 restantes |
| B (manual dispatch) | resto | **0 broken** |

**Tiempo estimado:** 2-3 horas para implementar A+C+D + script de detección. Manual B depende del contenido a revisar archivo por archivo.

## Bloqueo del release

El release v1.1.0 NO debe publicarse hasta que `sphinx-build -b linkcheck`
también devuelva 0 broken. Modificar el workflow `validate.yml` para
incluir linkcheck **a futuro** (después de fixear estos), pero por ahora
documentar que es un blocker conocido.

### Decisión a tomar

¿Es razonable agregar `linkcheck` al `validate.yml` como gate? Pros:
nunca más se introducen refs muertas. Contras: URLs externas pueden
fallar transitorio y bloquear merges legítimos.

**Recomendación:** sí pero con `linkcheck_anchors_ignore_for_url` y
`linkcheck_ignore` configurados generosamente para URLs externas
notoriamente inestables.

## Plan ejecutable (sub-tareas)

Agregar al task-plan principal del WP deployment-pipeline:

- **T-014** Crear `scripts/fix-md-refs.py` que reemplace `.md` por `.rst`
  cuando el target `.rst` exista.
- **T-015** Ejecutar T-014 sobre `source/`, ver delta.
- **T-016** Convertir refs a paths fuera de repo (provisioning, api,
  backend, vagrantfile) a literal monospace.
- **T-017** Configurar `linkcheck_ignore` en `conf.py` para URLs
  externas y paths internos no-CI-resolvibles.
- **T-018** Revisar manualmente los broken links restantes y decidir
  caso por caso (eliminar / actualizar / stub).
- **T-019** Ejecutar `sphinx-build -b linkcheck` final → 0 broken.
- **T-020** Agregar step `linkcheck` a `validate.yml` (modo
  non-blocking primero, blocking después de validar estabilidad).

## Próximo paso

Confirmar con el ejecutor:

1. ¿Aplica la estrategia A+B+C+D?
2. ¿Agregar `linkcheck` a `validate.yml` (decidir si blocking o
   non-blocking)?
3. ¿Aprobado el orden T-014..T-020 antes del release v1.1.0?
