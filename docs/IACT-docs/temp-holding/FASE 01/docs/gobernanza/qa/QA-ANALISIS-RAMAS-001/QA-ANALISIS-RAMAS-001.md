---
id: QA-ANALISIS-RAMAS-001
estado: borrador
propietario: lider-qa
ultima_actualizacion: 2024-06-01
version: 1.0
relacionados:
  - docs/standards/engineering-ruleset.md
  - docs/gobernanza/qa/QA-ANALISIS-ESTRUCTURA-003
---
# QA-ANALISIS-RAMAS-001

## 1. Portada

- **Versión:** 1.0
- **Fecha:** 2024-06-01
- **Sistema/equipo:** Gestión de ramas y releases

## 2. Objetivo

Asegurar que la estrategia de ramas cumpla con las reglas de gobernanza, reduce riesgos de integraciones defectuosas y garantiza trazabilidad entre cambios, revisiones y despliegues.

## 3. Alcance

- **Incluye:** ramas permanentes (`main`, `develop`), ramas de soporte (hotfix, release) y ramas efímeras de feature/experimentales.
- **Excluye:** configuraciones de CI/CD no relacionadas con políticas de ramas y controles específicos de seguridad estática.

## 4. Responsables

| Rol | Responsabilidad | Contacto / canal |
| --- | --- | --- |
| Liderazgo QA | Aprobar cambios al flujo de ramas y sus métricas de calidad | #qa-gobernanza |
| Dev Lead | Implementar políticas y proteger ramas en el repositorio | #engineering |
| Release Manager | Validar cumplimiento antes de cortes y etiquetado | #releases |

## 5. Frecuencia

- Revisión completa por release o cambio mayor de flujo.
- Verificación parcial semanal sobre ramas activas.

## 6. Checklist operativo

| Paso | Acción | Evidencia esperada | Estado |
| --- | --- | --- | --- |
| Definir convenciones de nombres | Ramas con prefijos `feature/`, `hotfix/`, `release/`, `experiment/` | Listado exportado desde el repositorio | 
| Protección de ramas principales | `main` y `develop` con políticas de revisión requerida y status checks obligatorios | Capturas de configuración o policy-as-code | 
| Reglas de merge | Uso de squash/rebase según política y restricción de `force push` | Registro de auditoría del repositorio | 
| Trazabilidad | Asociación de PRs a issues o tickets vinculados | Reporte de enlaces o etiquetas | 
| Housekeeping | Eliminación automática de ramas mergeadas y expiración de ramas huérfanas | Evidencia de políticas o jobs programados | 

## 7. Métricas

| Métrica | Definición | Umbral | Fuente |
| --- | --- | --- | --- |
| Ratio de PRs aprobados sin excepciones | PRs aprobados con todos los checks vs. total de PRs mergeados | ≥ 95% | Datos del repositorio / API |
| Tiempo medio de ciclo de rama | Tiempo desde creación hasta merge | ≤ 14 días | API de repositorio |
| Ramas huérfanas | Número de ramas sin actividad > 30 días | 0 | Auditoría semanal |

## 8. Convenciones de nomenclatura

- Aplicar prefijos según tipo de trabajo (`feature/`, `hotfix/`, `release/`, `experiment/`).
- Mantener `kebab-case` en el resto del nombre (`feature/refactor-cache-layer`).
- Seguir las reglas de `Naming Conventions` en `docs/standards/engineering-ruleset.md` para coherencia transversal.

## 9. Registro de decisiones y observaciones

- Documentar excepciones aprobadas y la justificación de riesgo asumido.
- Registrar acciones correctivas cuando un control falle (p. ej., release revertido).

## 10. Trazabilidad y anexos

- Enlazar al pipeline o políticas de protección de ramas vigentes.
- Referenciar tableros o reportes de seguimiento si aplican.
