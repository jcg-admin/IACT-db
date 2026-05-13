```yml
created_at: 2026-04-27 05:50:00
project: IACT-docs
work_package: 2026-04-27-05-26-20-zero-warnings-build
phase: Phase 1 — DISCOVER (constraints input)
author: NestorMonroy
status: En recepción
```

# Constraints Input Inventory

> Documentos **CNST_*** proporcionados por el ejecutor como contenido oficial
> del sistema IACT. Se guardan aquí como input — NO se procesan hasta que
> el ejecutor confirme que terminó de pasarlos.

## Recibidos

| ID | Título | Estado |
|----|--------|--------|
| CNST_001 | NO Email bajo Ninguna Circunstancia | Recibido |
| CNST_002 | Sesiones en BD, Única, Timeout 15 Minutos | Recibido |
| CNST_003 | BD IVR Readonly, ETL 6-12h, NO Real-Time | Recibido |
| CNST_004 | Alertas Buzón Interno, Máximo 50 Destinatarios | Recibido |
| CNST_005 | Modelo RBAC Flat + SoD + Permisos Temporales | Recibido |
| CNST_006 | Reportes: Rango Máximo 2 Años | Recibido |

Más por llegar: CNST_007 (Límites exportación), CNST_008 (Audit inmutable),
posiblemente otros referenciados en los textos.

## Reglas confirmadas por el ejecutor

1. **Scope WP:** 0 warnings en `make clean && make html` sobre `source/*`.
2. **Formato:** sin archivos `.md` en `source/` — todo `.rst`.
3. **NO BORRAR** archivos — integrar y desarrollar correctamente.
4. **Decisiones técnicas:** las toma Claude (autonomía sobre cómo integrar).
5. **Seguir las fases del SKILL** — discover → analyze → constraints → strategy → ...

## Pendiente de definir (Phase 4/5)

- ¿Dónde van estos CNST_* en `source/`? (ej: `source/normativa/restricciones/`,
  `source/requisitos/constraints/`, otro path).
- ¿Reemplazan o complementan archivos existentes con nombre similar?
- ¿Cómo se integran con los toctrees existentes (resolver F-toc.not_included)?
- ¿Los `:ref:` que aparecen en los textos (UC_003, UC_006, AUT_003, etc.) deben
  resolverse a archivos existentes o se crean labels stub para evitar
  "Unknown target name"?

Estas preguntas se responden en Phase 3 ANALYZE (después de tener todos los
inputs y de leer el estado actual de `source/`).
