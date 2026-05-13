```yml
created_at: 2026-04-20 13:41:02
project: THYROX
author: NestorMonroy
status: Borrador
```

# Mandato Agentic de THYROX — Definición Operacional

THYROX declara ser un "Sistema de Agentic AI". Este documento define qué significa eso en términos verificables.

## Definición verificable

THYROX es agentic cuando cumple TODOS los criterios siguientes:

| Criterio | Descripción | Estado |
|---------|-------------|--------|
| C1 — Auto-rechazo | El motor puede rechazar su propio output | CUMPLE — bound-detector.py (PreToolUse) |
| C2 — Razonamiento sobre incertidumbre | Cada artefacto de gate declara confianza con umbral | PARCIAL — exit-conditions.md.template tiene umbrales, no todos los artefactos los usan |
| C3 — Persistencia de estado | Persiste estado entre sesiones sin intervención humana | CUMPLE — sync-wp-state.sh, git |
| C4 — Orquestación especializada | Puede orquestar agentes especializados con scope acotado | CUMPLE — 25+ agentes, bound-detector |

## Criterios NO cumplidos todavía

- C2 parcial: los WPs producidos no siempre declaran confianza epistémica en sus claims
- No hay criterio C5 todavía: capacidad de detectar cuando el WP activo contradice decisions/ anteriores

## Cómo evaluar si un WP contribuye al mandato agentic

1. ¿El WP mejora la capacidad del motor de rechazar outputs incorrectos? → contribuye a C1
2. ¿El WP mejora la calibración epistémica de artefactos? → contribuye a C2
3. ¿El WP mejora la persistencia o recuperación de estado? → contribuye a C3
4. ¿El WP agrega agentes especializados con scope acotado? → contribuye a C4

---

## Tracking de versiones del mandato

| Versión | Fecha | Cambio | Criterios afectados |
|---------|-------|--------|---------------------|
| 1.0 | 2026-04-20 | Definición inicial C1..C4 | — |

---

## Tabla de riesgo por característica agentic

| Característica | Riesgo si falla | Indicador de fallo | Mitigación actual |
|----------------|----------------|-------------------|-------------------|
| Auto-rechazo (C1) | Agente acepta output incorrecto | bound-detector no intercepta | bound-detector.py (PreToolUse) |
| Calibración epistémica (C2) | Gates avanzan con SPECULATIVE | Claims no clasificados en artefactos | evidence-classification.md + I-012 |
| Persistencia de estado (C3) | Sesión reinicia sin contexto | sync-wp-state.sh falla silenciosamente | exit 0 explícito (T-071) |
| Orquestación (C4) | Scope sin límite, agentes unbounded | Agent tool sin bound en prompt | bound-detector.py |

---

## Autonomía condicional vs. autonomía plena

THYROX opera en **autonomía condicional**, no en autonomía plena:

| Tipo | Descripción | Estado en THYROX |
|------|-------------|-----------------|
| Autonomía plena | El agente ejecuta sin mecanismo de rechazo o supervisión | NO — bound-detector.py puede rechazar outputs |
| Autonomía condicional | El agente ejecuta, pero hay mecanismos de rechazo activos con criterios operacionales | SI — C1 + C4 implementados |

**Regla:** Declarar THYROX como "autónomo" sin la distinción condicional/plena reproduce el anti-patrón
de realismo performativo. La autonomía de THYROX es verificable porque tiene condiciones de fallo
documentadas (bound-detector.py, exit 0 en sync-wp-state.sh). Sin esas condiciones documentadas,
"autónomo" sería un label, no una propiedad del sistema.
