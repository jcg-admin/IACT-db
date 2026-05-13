# Estándar de trazabilidad SDLC para PRODUCTO_DASHBOARD_ANALYTICS

Este documento define cómo se mantienen las relaciones de trazabilidad de punta a punta (requisito → diseño → implementación → pruebas → despliegue) en el producto de dashboards y analíticas. Se eliminan referencias explícitas a "agentes" o IA en la nomenclatura, manteniendo la posibilidad de usar automatizaciones internas cuando aporten valor.

## 1. Identificadores obligatorios

| Tipo de artefacto | Prefijo / formato | Ejemplo enfocado a analíticas |
| --- | --- | --- |
| Requisito / Feature | `REQ-DASH-NNN` | `REQ-DASH-045` (ver tasa de churn mensual) |
| Decisión de arquitectura (ADR) | `ADR-YYYY-NNN` | `ADR-2025-012` (selección de Kafka para streaming) |
| Métrica / KPI | `METRIC-NNN` | `METRIC-005` (fórmula de churn) |
| Visualización | `VIS-NNN` | `VIS-022` (gráfico de línea mensual) |
| Capacidad / permiso | `sistema.vistas.<dominio>.<acción>` | `sistema.vistas.dashboards.ver.metrics_confidenciales` |

## 2. Trazabilidad mínima por fase del SDLC

Cada artefacto debe enlazar explícitamente sus dependencias hacia atrás (origen) y hacia adelante (destino):

| Fase | Artefacto generado | Referencias obligatorias |
| --- | --- | --- |
| Planificación | `issue-REQ-DASH-NNN.md` | Punto de inicio (no requiere referencias previas). |
| Viabilidad | `FeasibilityReport.md` | Referencia a `REQ-DASH-NNN`. |
| Diseño | `HLD/LLD.md` | Referencias a `REQ-DASH-NNN` y ADRs relevantes. |
| Decisiones | `ADR-YYYY-NNN.md` | Referencias a requisitos; justifica la elección técnica. |
| Implementación | Código (vistas/servicios) | Docstrings o metadatos con `REQ-DASH-NNN` y `ADR-YYYY-NNN`. |
| Testing | `test_*.py` | Nombre o comentarios referenciando `REQ-DASH-NNN` y la funcionalidad cubierta. |
| Despliegue | `DeploymentPlan.md` | Referencias a requisitos y ADRs de infraestructura. |

## 3. Adaptación específica a dashboards y analíticas

### 3.1 Cadena de trazabilidad de métricas

1. **Requisito → Métrica/KPI**: cada `REQ-DASH-NNN` debe indicar la métrica que lo satisface (`METRIC-NNN`).
2. **Métrica → Fuente de datos**: toda `METRIC-NNN` declara tablas/campos o streams de datos y reglas de limpieza. 
3. **Métrica → Visualización**: cada `VIS-NNN` referencia la `METRIC-NNN` que consume y sus filtros admitidos.

### 3.2 Seguridad y permisos

1. **Sensibilidad del dato**: `METRIC-NNN` define el nivel de sensibilidad (público/confidencial/restringido).
2. **Capacidad requerida**: para datos confidenciales o restringidos, se documenta la capacidad `sistema.vistas.dashboards.ver.<métrica>` y se aplica en la vista o servicio correspondiente.
3. **Auditoría**: las capacidades marcadas como sensibles deben llevar `requiere_auditoria=True` en la definición de permisos y registrar el acceso en `AuditoriaPermiso`.

## 4. Herramientas y controles de cumplimiento (sin nomenclatura de “agente”)

- **Validador de requisitos y planes**: comprueba que `issue-REQ-DASH-NNN.md` incluye métricas asociadas y nivel de sensibilidad antes de avanzar a diseño.
- **Revisión de documentación**: escaneo automático/manual que verifica coherencia de IDs (`REQ`, `ADR`, `METRIC`, `VIS`) en HLD/LLD y que los permisos declarados coinciden con los decoradores de vistas.
- **Revisión de scripts**: análisis incremental de scripts de CI/CD o ETL para asegurar que mantienen referencias a requisitos y no exponen datos sensibles sin la capacidad correspondiente.

## 5. Checklist de trazabilidad para entregables del dashboard

- ¿Cada requisito (`REQ-DASH-NNN`) está enlazado a una métrica (`METRIC-NNN`)?
- ¿Cada métrica documenta su fuente de datos, fórmula y nivel de sensibilidad?
- ¿Cada visualización (`VIS-NNN`) referencia la métrica que consume y sus filtros?
- ¿Las vistas/servicios que exponen datos sensibles aplican la capacidad granular correcta y registran auditoría?
- ¿Las pruebas (`test_*.py`) y planes de despliegue referencian el requisito y la decisión de arquitectura pertinentes?
