```yml
created_at: 2026-04-29 04:50:00
project: IACT-docs
work_package: 2026-04-28-05-28-44-source-rebuild-normativa-gobernanza
phase: Phase 11 — TRACK (v2 pendiente)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# WP #5 normativa-gobernanza — Fixes pendientes para iteracion v2

## G-1 [ALTO] ADR-GOB-008 RBAC Coexistencia ACC ↔ PERM NO existe

**Origen:** Hipotesis 1 aprobada (rbac-formalization §12, D-RBAC-1..8).

**Problema:** la decision arquitectonica clave del WP #6 (coexistencia
de MOD_Access vista funcional ↔ MOD_Permissions vista tecnica) NO
tiene ADR formal en `source/normativa/gobernanza/`. Los UCs (49 ACC +
10 PERM) viven en source/ pero la decision que los justifica esta
solo en `analyze/` del WP (no publicado).

**ADR a crear:** `source/normativa/gobernanza/ADR-GOB-008_RBAC_
Coexistencia_ACC_PERM.rst`

**Estructura (template TPL_ADR_Decisiones_Arquitectonicas):**

| Seccion | Contenido |
|---------|-----------|
| Estado | Aceptada (2026-04-29) |
| Contexto | Sistema PERM granular 75% implementado en backend (8 modelos Django, 5 funciones SQL incluyendo `obtener_menu_usuario`). Modelo RBAC v5.2.1 declara catalogo cerrado de 42 funciones + 10 grupos predefinidos AGR-001..010. Los .rst canonicos del backup (49 UCs v4.0.0) reflejan vista funcional (ACC). Los 10 .md UC-PERM reflejan vista tecnica granular. |
| Problema | ¿ACC y PERM son duplicacion (uno reemplaza al otro) o complementacion (coexisten)? |
| Alternativas | (1) Coexistencia: ACC vista admin no-tech + PERM vista admin tech. (2) Evolucion limitada: PERM absorbe RBAC_CORE de ACC, queda ACC reducido. (3) Evolucion total: PERM reemplaza completamente a ACC. |
| Decision | **Hipotesis 1 — Coexistencia.** ACC preserva los 9 UCs canonicos + PERM agrega 10 UCs nuevos. |
| Consecuencias positivas | Cobertura maxima sin perdida de UCs documentados. Dos perfiles admin diferenciados (no-tech vs tech). Zero rework sobre los .rst canonicos. |
| Consecuencias negativas | Doble vocabulario (mitigado con D-RBAC-1 "Funcion" canonico). Doble auditoria (UC_ACC_09 + UC_PERM_09 + UC_AUD_*). Mas UCs para mantener (~63). |
| Mitigaciones | CNST_033 Vocabulario Unificado (WP #4 v3). NFR_AUD_01 unica fuente de verdad para auditoria. ADR-GOB-008 (este) declara coexistencia formal. |
| Decisiones relacionadas | D-RBAC-1..8 (rbac-formalization § 12). |

**Estimacion:** 1 h (ADR sustantivo).

## Total iteracion v2

- 1 hallazgo (1 ALTO)
- Estimacion: ~1 h
- Build verification
- Conectar al index.rst de gobernanza
- Commit + push

## Pre-condicion

WP #4 v3 (CNST_033 Vocabulario Unificado) idealmente antes, ya que
ADR-GOB-008 lo cita en mitigaciones. Pero puede ejecutarse en
paralelo si se referencia "pendiente CNST_033".

## Cross-refs

- WP padre `track/cross-wp-deep-audit-2026-04-29.md`
- WP #6 `analyze/rbac-formalization.md` (modelo formal completo)
- WP #6 `analyze/hipotesis-1-coexistencia.md` (decision aprobada)
