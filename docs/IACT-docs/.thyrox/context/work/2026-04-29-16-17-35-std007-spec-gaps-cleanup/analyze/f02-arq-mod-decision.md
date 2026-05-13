```yml
created_at: 2026-04-29 16:55:00
project: IACT-docs
work_package: 2026-04-29-16-17-35-std007-spec-gaps-cleanup
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# F-02 — Decisión sobre archivos `arq-mod-NNN-*`

## Hechos verificados (T-004)

8 archivos en `source/arquitectura-tecnica/modulos/`:

| Archivo | Líneas | Descripción |
|---------|-------:|-------------|
| `arq-mod-001-auth.rst` | 517 | Autenticación y Sesiones |
| `arq-mod-002-user-identity.rst` | 374 | Gestión de Identidades |
| `arq-mod-003-rbac-core.rst` | 402 | Roles, Segmentos y Permisos |
| `arq-mod-004-etl-monitoring.rst` | 356 | Supervisión ETL |
| `arq-mod-005-vis-reports.rst` | 459 | Visualización y Reportes |
| `arq-mod-006-alerts.rst` | 393 | Alertas y Notificaciones |
| `arq-mod-007-audit.rst` | 433 | Auditoría |
| `arq-mod-008-sys-logs.rst` | TBD | Logs de Sistema |

Todos:

- Sustantivos (350-520 líneas).
- Sin `.. meta::` frontmatter (usan comment `..` legacy).
- Título RST: `ARQ_MOD_NNN: Descripción (CODE)`.
- Únicos — no duplican otros artefactos del corpus.

## Reinterpretación del patrón

El nombre `arq-mod-NNN-<desc>.rst` puede leerse de dos formas:

| Interpretación | Mapeo a §4 STD_007 |
|----------------|---------------------|
| (a) Prefijo compuesto `arq-mod` + NNN | NO encaja en `<prefix>-<NNN>-<desc>` |
| (b) Prefijo `arq` + módulo `mod` + NNN | Encaja en `<prefix>-<MOD>-<NNN>-<desc>` |

**Interpretación (b) hace que el patrón existente sea canónico:**

```
adr-back-001-grupos-funcionales.rst    (prefix=adr, mod=back, nnn=001)
proc-dev-001-pipeline-trabajo.rst      (prefix=proc, mod=dev, nnn=001)
arq-mod-001-auth.rst                   (prefix=arq, mod=mod, nnn=001)
```

Estructura idéntica.

## Opciones evaluadas

| Op | Acción | Costo | Análisis |
|----|--------|-------|----------|
| A | Rename a `mod-NNN-<desc>.rst` | 8 renames + refs | Pierde categoría "arquitectura" en el filename; requiere prefijo nuevo `mod` |
| B | Rename a `arq-NNN-<desc>.rst` (drop "mod-") | 8 renames + refs | Drop redundante; introduce prefijo `arq` |
| **C** | Keep + documentar `arq` prefix con mod={mod} en STD_007 v2.0.2 | 0 renames + 0 refs | Preserva todo, formaliza patrón existente |

## Decisión: Opción C

**Justificación:**

1. **Preserva trabajo existente** — 0 renames + 0 refs en juego.
2. **Patrón ya es válido bajo §4 §<prefix>-<MOD>-<NNN>-<desc>** —
   solo falta documentarlo.
3. **Extensible** — si aparecen `arq-svc-NNN-`, `arq-comp-NNN-`,
   etc. en el futuro, el framework ya soporta.
4. **Categoría preservada** — "arq" en filename comunica
   inmediatamente "este es un artefacto arquitectónico".
5. **Costo de B/A es alto** — 8 renames + cascading refs +
   posible regresión sobre el WP previo recién cerrado.

## Acción concreta para Bloque B

Agregar a STD_007 v2.0.2 §4:

```
| Prefijo | Tipo | Módulos válidos | Ejemplo |
|---------|------|-----------------|---------|
| arq     | Documento de arquitectura | mod (módulo), svc (servicio, futuro), comp (componente, futuro) | arq-mod-001-auth.rst |
```

Y a la tabla de "módulos canónicos" agregar `arq` como prefijo
con su tabla de módulos.

## Implicación adicional

Los 8 archivos `arq-mod-*` quedan en F-07 (sin `.. meta::`)
y deben ser tratados en Bloque E. La acción del Bloque C para
F-02 será **vacía** (decisión cerrada en Bloque B).

## Cierre del finding

F-02 → **resuelto sin renames** (decisión de spec en Bloque B).
Bloque C podrá omitir T-008 (rename arq-mod-*) y enfocarse en
F-01 (procedimiento-*) + F-06 (que también es spec-only).
