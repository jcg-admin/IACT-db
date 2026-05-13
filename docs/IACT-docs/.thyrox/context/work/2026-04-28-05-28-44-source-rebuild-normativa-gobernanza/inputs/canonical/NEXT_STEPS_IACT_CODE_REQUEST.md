# NEXT_STEPS_IACT_CODE_REQUEST.md

## 1. Archivos Críticos para la Trazabilidad (TRZ-001)

Con los insumos de `politicas`, `permissions` y `audit` ya integrados, se completaron los artefactos fundacionales (BR-NEG, BR-SEG y RNF-AUD) y se cerró el UC-010. El siguiente paso es formalizar la **Gobernanza del Proceso (RNF-PROC-XXX)** con prácticas manuales del equipo y métricas básicas de entrega (sin agentes IA ni esquema DORA).

| Rol de Trazabilidad | Directorio/Módulo | Archivo/s Solicitado/s | Razón para el Análisis de Trazabilidad |
| :--- | :--- | :--- | :--- |
| **Nivel 3: RNF de Proceso (SDLC)** | `docs/governance` | `requirements_management.md` | Formalizar **RNF-PROC-001** (gobernanza del proceso SDLC ejecutado por el equipo). |
| **Nivel 3: RNF de Métricas y Gobernanza** | `docs/governance` | `metrics_and_reporting.md` | Formalizar **RNF-PROC-002** (métricas internas de despliegue y reporting, sin DORA). |
| **Nivel 1: Reglas de Negocio** | `politicas/*` | **COMPLETADO.** Fuente del `CATALOGO_BR.md` y `CATALOGO_BR_SEGURIDAD.md`. |
| **Nivel 3: RNF de Auditoría** | `audit/*` | **COMPLETADO.** Fuente de `RNF-AUD-001_AUDITORIA.md`. |
| **Nivel 1: Autorización/Privilegios** | `permissions/*` | **COMPLETADO.** Fuente de `CATALOGO_BR_SEGURIDAD.md` y BR-SEG-007. |
| **Nivel 4: CU Central de Negocio** | `llamadas/services.py` | **COMPLETADO.** Fuente de `UC-010_REGISTRAR_LLAMADA_ENTRANTE_FINAL.md`. |

## 2. Instrucción para Continuar

Proveer el contenido de los archivos solicitados en `docs/governance` permitirá generar los RNF-PROC-XXX y completar la trazabilidad de proceso en la carpeta **GOVERNANZA_SDLC/** sin depender de agentes IA ni métricas DORA.
