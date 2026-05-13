# Propuesta de reorganización documental para trazabilidad IACT (TRZ-001)

## Objetivo
Separar la documentación del **producto** (qué hace el call center) de la **gobernanza SDLC/IA** (cómo se construye) para facilitar la trazabilidad BR → UC → RNF → Código → Tests y reducir ruido operativo.

- `PRODUCTO_DASHBOARD_ANALYTICS/`
  - `CATALOGO_BR/`: catálogo único de reglas de negocio (BR-XXX) derivadas de RF/RT. Cada BR incluye referencias descendentes a UC.
  - `REQUISITOS/`
    - `UC/`: casos UC-V2 con trazabilidad upward (BR/RNF) y downward (UML/API/Código/Tests).
    - `RNF/`: consolidado de RNF críticos para el dominio de analytics (p. ej., RNF-AUD-001 para accesos a PII, RNF-DATA-001 para calidad de datos y RNF-PERF-001 para tiempos de carga) con vínculos a módulos `audit/`, `notifications/`, `etl/`, `analytics/`.
  - `DISENO/`: diagramas y modelos (UML, secuencia, actividad) vinculados desde UC.
  - `REFERENCIA_API/`: catálogos de endpoints (`API_REFERENCE.md`, `CATALOGO-APIs.md`) con `uc_refs/rf_refs/adr_refs`.
- `GOVERNANZA_SDLC/`
  - `ADR/`: decisiones arquitectónicas (ADR-BACK-XXX.md) con trazabilidad a UC/UML y código.
  - `PROCESO_SDLC/`: metodologías, procedimientos, planes.
  - `AI_AGENTES/`: agentes, prompting y automatizaciones.

## Pasos de migración
1. **Inventario**: listar archivos actuales en `docs/` y clasificarlos según el árbol propuesto para `PRODUCTO_DASHBOARD_ANALYTICS/` y `GOVERNANZA_SDLC/`.
2. **Movimiento controlado**: mover documentos al nuevo árbol manteniendo referencias relativas y actualizando índices (`docs/index.md`, RTM-IACT).
3. **Actualización de RTM**: registrar rutas nuevas y verificar que toda referencia bidireccional se conserve, incluyendo los RNF de datos, performance y auditoría que impactan dashboards y reportes.
4. **Validación CI/CD**: ajustar `rtm-drift-check` y `api-metadata-check` para fallar si un artefacto del producto carece de `uc_refs/rf_refs/adr_refs` o si un BR/RNF no enlaza a un UC.
5. **Comunicación**: documentar el cambio en el checklist de PR y en `docs/gobernanza/reglas_restricciones_detalle.md`.

## Impacto esperado
- Ubicación única para BR y RNF críticos (Auditoría, Seguridad) consumidos por `authentication/`, `permissions/`, `audit/`, `notifications/`.
- Reducción de brechas en RTM al eliminar dispersiones entre requisitos y diseño.
- Mayor legibilidad para equipos de negocio y QA al distinguir producto vs. proceso.
