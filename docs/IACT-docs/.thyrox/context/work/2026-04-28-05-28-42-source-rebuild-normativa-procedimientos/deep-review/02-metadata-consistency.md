```yml
created_at: 2026-04-28 08:30:00
project: IACT-docs
work_package: 2026-04-28-05-28-42-source-rebuild-normativa-procedimientos
phase: Phase 11 — TRACK (artefacto deep-review)
agent_id: a82a35c002c5c4834
invocation_bound: 72 archivos · ≤8 hallazgos
author: deep-review agent
status: Aprobado
version: 1.0.0
```

# Deep-Review 02 — Consistencia de metadata

## Tabla resumen por patrón (al inicio del review)

| Patrón | Archivos | Con `.. meta::` antes | Después |
|---|---|---|---|
| A ``PROC-MOD-NNN-*`` | 10 | 0/10 | **10/10** ✓ |
| B ``PROCED-MOD-NNN-*`` | 14 | 0/14 | **14/14** ✓ |
| C ``PROC_PascalCase`` | 37 | 37/37 | 37/37 ✓ |
| D ``procedimiento-*`` / ``guia-*`` | 10 | 0/10 | **10/10** ✓ |
| index | 1 | 1/1 | 1/1 ✓ |

**Total final tras fixes: 72/72 archivos con metadata estándar.**

## Hallazgos resueltos

### F-01 [CRÍTICO RESUELTO] — 34/72 archivos sin `.. meta::`

Aplicado script ``/tmp/fix_proc_meta.py``: 34 archivos recibieron
bloque `.. meta::` con 10 campos estándar (artefacto derivado del
filename, tipo Procedimiento o Guia, dominio normativa, etc.).

### F-02 [CRÍTICO RESUELTO] — Metadata legacy `:Campo: PascalCase`

Detectados 2 archivos: PROC-OPS-001-deployment.rst y
PROC-OPS-002-setup-entorno-desarrollo.rst.
Migrados al schema nuevo en el mismo script.

### F-03 [ALTO RESUELTO] — 15/37 archivos del patrón C sin `:ultimo_cambio:`

Completados via add_missing_fields.

### F-04 [ALTO RESUELTO] — 16/37 archivos del patrón C sin `:clasificacion:`

Completados via add_missing_fields. Default seguro:
``:clasificacion: Interno``.

### F-05 [MEDIO] — Versión embebida en H1

No detectadas violaciones reales (falso positivo del grep en
PROC_Versionado_Semantico).

### F-06 [MEDIO RESUELTO] — Stub PROC_Generacion_Index.rst con placeholders

Verificado: los placeholders ``[dominio]`` y ``[subdominio]``
están dentro de ``.. code-block:: rst`` como ejemplos de la
plantilla descrita por el procedimiento. NO son metadata
incompleta — son contenido de ejemplo deliberado.

### F-07 [BAJO] — index.rst sin `:categoria:`

Tipo "Indice" no requiere `:categoria:` por convención.

### F-08 [BAJO] — Campo legacy `:anterior:` retenido

Mantenido como trazabilidad de migración (3 archivos).
