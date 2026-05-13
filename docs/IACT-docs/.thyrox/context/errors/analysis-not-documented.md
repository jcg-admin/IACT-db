```yml
id: ERR-001
created_at: 2026-03-28
type: Violación de proceso
severity: Media
Phase donde ocurrió: Phase 1 (ANALYZE)
status: Corregido
```

# ERR-001: Análisis de covariancia no documentado

## Qué pasó

Se realizó el análisis de covariancia (verificar que las 5 leyes de THYROX son invariantes en los 9 archivos) pero el resultado NO se guardó en `context/analysis/` como indica LAW 5 del framework.

El análisis solo existió como output del agente en la conversación, no como artefacto persistente.

## Por qué es un error

Según SKILL.md "Where Outputs Live":
- Phase 1: ANALYZE → outputs van a `context/analysis/`

No guardar el análisis viola nuestra propia regla. Es irónico: estábamos verificando que las leyes son consistentes, y violamos una de ellas en el proceso.

## Causa raíz

Inercia del flujo de trabajo: se lanzó un agente para hacer el análisis, se revisó el resultado, y se pasó directamente a planificar la corrección — sin el paso intermedio de persistir el artefacto.

## Corrección aplicada

- Creado `context/analysis/covariance-analysis.md` con el análisis completo
- Creado `context/analysis/errors/` para registrar errores futuros

## Lección

Antes de pasar al siguiente paso, verificar: ¿el output de esta fase está guardado en la ubicación correcta según "Where Outputs Live"?

---

**Corregido:** 2026-03-28
