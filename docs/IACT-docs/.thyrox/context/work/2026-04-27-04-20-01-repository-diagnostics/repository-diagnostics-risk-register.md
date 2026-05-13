```yml
project: IACT-docs
work_package: 2026-04-27-04-20-01-repository-diagnostics
created_at: 2026-04-27 04:20:01
updated_at: 2026-04-27 04:20:01
current_phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
```

# Risk Register — repository-diagnostics

| ID | Riesgo | Prob | Impacto | Mitigación | Estado |
|----|--------|------|---------|------------|--------|
| R-01 | Diagnóstico genera falsos positivos por desconocimiento del histórico | M | M | Verificar cada hallazgo contra git log y WPs previos antes de clasificar como problema | Abierto |
| R-02 | Cambios "obvios" durante el diagnóstico rompen flujos activos (build, hooks) | M | A | Diagnóstico solo lectura — no aplicar fixes en este WP, solo reportar | Abierto |
| R-03 | Estado de sesión (now.md) inconsistente confunde el avance del diagnóstico | A | M | Tratar now.md como dato a auditar, no como fuente de verdad del WP actual | Abierto |
| R-04 | Tracking de build/ (1126 archivos, 64 MB) puede ser intencional según ADR no leído | A | M | Buscar ADR/decision antes de marcar como problema | Abierto |
| R-05 | El diagnóstico se desborde y se convierta en re-análisis de cada WP cerrado | A | M | Scope acotado: solo problemas activos del repo HOY, no re-auditar trabajo cerrado | Abierto |
