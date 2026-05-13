```yml
created_at: 2026-04-29 04:50:00
project: IACT-docs
work_package: 2026-04-28-05-28-42-source-rebuild-normativa-procedimientos
phase: Phase 11 — TRACK (v2 pendiente)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# WP #3 normativa-procedimientos — Fixes pendientes para iteracion v2

## P-1 [MEDIO] PROC_Excepciones_CNST.rst pendiente

**Origen del hallazgo:** WP #4 `cross-wp-debt-summary.md` § W-4.

**Problema:** los CNSTs del rebuild (set SRP-31) declaran "Sin
excepciones" o "Aprobacion formal" en su § 6 Excepciones, pero NO
existe un procedimiento formal de waiver/exception en
`source/normativa/procedimientos/`.

**Procedimiento esperado:**

```
PROC_Excepciones_CNST.rst
├── 1. Solicitud formal (formulario, datos requeridos)
├── 2. Analisis de riesgo
├── 3. Aprobador segun severidad CNST:
│      - Critico: Tech Lead + Compliance Officer
│      - Alto: Tech Lead
│      - Medio/Bajo: Manager
├── 4. Vigencia acotada de la excepcion (max 90 dias)
├── 5. Auditoria del uso durante la vigencia
└── 6. Renovacion (requiere nueva justificacion)
```

**Accion v2:**

1. Crear `source/normativa/procedimientos/PROC_Excepciones_CNST.rst`
   con la estructura arriba.
2. Aplicar template `TPL_PROC_Procedimientos.rst` (de
   `normativa/estandares/plantillas/`).
3. Metadata estandar 10 campos.
4. Conectar al index.rst de procedimientos/.
5. Build verde.

**Estimacion:** 1 h (procedimiento sustantivo, no boilerplate).

## Total iteracion v2

- 1 hallazgo (1 MEDIO)
- Estimacion: ~1 h
- Commit + push

## Pre-condicion

Idealmente se ejecuta despues de WP #4 v3 (donde se actualizan los
CNSTs § 6 Excepciones que apuntan a este procedimiento).

## Cross-refs

- WP #4 `cross-wp-debt-summary.md` § W-4
- WP padre `track/cross-wp-deep-audit-2026-04-29.md`
