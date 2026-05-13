---
id: QA-ANALISIS-ESTRUCTURA-INFRA-001
estado: borrador
propietario: lider-qa
ultima_actualizacion: 2024-06-01
version: 1.0
relacionados:
  - docs/standards/engineering-ruleset.md
  - docs/gobernanza/qa/QA-ANALISIS-RAMAS-001
---
# QA-ANALISIS-ESTRUCTURA-INFRA-001

## 1. Portada

- **Versión:** 1.0
- **Fecha:** 2024-06-01
- **Sistema/equipo:** Infraestructura de ejecución y despliegue

## 2. Objetivo

Validar que la estructura de infraestructura (carpetas, scripts, configuraciones y artefactos de despliegue) cumpla con estándares de seguridad, observabilidad y mantenibilidad definidos para el monorrepo, con el mismo nivel de trazabilidad que el control de ramas.

## 3. Alcance

- **Incluye:** organización de `infrastructure/`, scripts de automatización, configuraciones de entornos, plantillas de infraestructura como código y pipelines de despliegue relacionados.
- **Excluye:** lógica de aplicación en `api/`, `ui/` u otros módulos funcionales, así como configuraciones de CI/CD que no estén bajo `infrastructure/`.

## 4. Responsables

| Rol | Responsabilidad | Contacto / canal |
| --- | --- | --- |
| Liderazgo QA | Aprobar hallazgos y planes de remediación | #qa-gobernanza |
| SRE / DevOps | Implementar cambios de estructura y controles técnicos | #sre |
| Seguridad | Validar alineación con requisitos de cumplimiento | #security |

## 5. Frecuencia

- Auditoría estructural por cada cambio mayor de infraestructura o trimestral.
- Validación ligera posterior a despliegues significativos.

## 6. Checklist operativo

| Paso | Acción | Evidencia esperada | Estado |
| --- | --- | --- | --- |
| Inventario de carpetas críticas | Listar `infrastructure/bin`, `infrastructure/scripts`, `infrastructure/system`, `infrastructure/utils` y subcarpetas por entorno | Registro del árbol, responsables y propietarios |
| Convenciones de nombres | Confirmar prefijos y sufijos coherentes (p. ej., scripts `*.sh` con `set -euo pipefail`) y alineados a `engineering-ruleset.md` | Muestra de archivos revisados y referencias cruzadas |
| Seguridad y permisos en scripts | Validar uso de `SCRIPT_DIR`, ausencia de rutas absolutas rígidas, permisos mínimos (`chmod 750/640`) y dependencias explícitas | Extractos de scripts con controles y salida de `ls -l` |
| Plantillas y configuraciones | Revisar consistencia de archivos de configuración y ambientes (`*-dev.*`, `*-stage.*`, `*-prod.*`), variables obligatorias y valores seguros por defecto | Listado de plantillas, parámetros obligatorios y ejemplos de valores | 
| Observabilidad y logs | Confirmar que scripts generan trazas `[INFO]/[WARN]/[ERROR]/[SUCCESS]` y que pipelines capturan logs y artefactos | Capturas o logs generados y rutas de almacenamiento |
| Housekeeping de artefactos | Verificar políticas de retención y limpieza de artefactos/paquetes en pipelines y repositorios de infraestructura | Evidencia de políticas o jobs programados |

## 7. Métricas

| Métrica | Definición | Umbral | Fuente |
| --- | --- | --- | --- |
| Scripts conformes | Scripts que cumplen guías de `infrastructure/scripts/AGENTS.md` vs. total auditado | ≥ 95% | Auditoría puntual |
| Pipelines con logging completo | Pipelines que almacenan logs y artefactos accesibles durante ≥ 30 días | ≥ 95% | Plataforma CI/CD |
| Desviaciones corregidas | Hallazgos cerrados dentro del período de revisión | ≥ 90% | Seguimiento de tickets |
| Tiempo de remediación | Promedio de días para corregir hallazgos críticos | ≤ 7 días | Sistema de tickets |

## 8. Convenciones de nomenclatura

- Alinear con `docs/standards/engineering-ruleset.md` para reglas generales de carpetas y archivos.
- Scripts Bash en `snake_case.sh` y con cabecera `#!/usr/bin/env bash`; incluir sufijos que describan el objetivo (`-deploy`, `-backup`, `-lint`).
- Plantillas y configuraciones nombradas por entorno (`*-dev.*`, `*-stage.*`, `*-prod.*`) y tecnología (`terraform-`, `ansible-`, `helm-`).
- Directorios por entorno en `infrastructure/<dominio>/<entorno>` para reflejar los límites de responsabilidad.

## 9. Registro de decisiones y observaciones

- Documentar dependencias compartidas entre componentes de infraestructura y riesgos conocidos.
- Registrar excepciones aprobadas a estándares de hardening o logging.

## 10. Trazabilidad y anexos

- Enlazar a playbooks, runbooks o pipelines que automaticen validaciones.
- Adjuntar referencias a ADR relevantes cuando las decisiones afecten la arquitectura.
