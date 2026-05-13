---
title: Resumen de Casos Prácticos IACT
date: 2025-11-16
domain: general
status: active
tipo: indice
relacionado:
  - ../05a_casos_practicos_iact.md
  - ../01_marco_conceptual_iact.md
---

# Resumen de Casos Prácticos IACT

**Versión:** 1.0
**Fecha:** 2025-11-16
**Estado:** Vigente

Este documento presenta un resumen ejecutivo de los casos prácticos reales del proyecto IACT que demuestran la aplicación completa del marco integrado de análisis de negocio.

---

## Casos Implementados

| # | Caso | Proceso | Casos de Uso | Requisitos | Procedimientos |
|---|------|---------|--------------|-----------|----------------|
| 1 | Autenticación y Sesiones | PROC-AUTH-001 | UC-001, UC-002 | RF-005, RF-006, RF-010, RNF-005 | PROC-LOGIN-001 |
| 2 | Evaluación de Permisos | PROC-PERM-001 | UC-010, UC-011 | RF-001, RF-011, RF-012 | PROC-PERM-ADMIN-001 |
| 3 | Auditoría de Seguridad | PROC-AUDIT-001 | UC-020, UC-021, UC-022 | RF-020, RF-021, RF-022 | PROC-AUDIT-REVIEW-001 |

---

## Métricas de Cobertura

- **Procesos Documentados:** 3
- **Casos de Uso Derivados:** 8
- **Requisitos Funcionales:** 11
- **Requisitos No Funcionales:** 1
- **Procedimientos Operacionales:** 3
- **Reglas de Negocio Aplicadas:** 14 (RN-C01-01 a RN-C01-14)

---

## Acceso a Casos Individuales

### Caso 1: Sistema de Autenticación y Gestión de Sesiones
**Archivo:** [`caso-practico-01-autenticacion-sesiones.md`](./caso-practico-01-autenticacion-sesiones.md)

**Resumen:** Implementación completa del flujo de autenticación de usuarios en el sistema IACT, incluyendo validación de credenciales, generación de tokens JWT, renovación de sesiones y registro de auditoría.

**Stakeholders principales:**
- Agentes de call center
- Administradores de seguridad
- Oficiales de cumplimiento

**Componentes clave:**
- PROC-AUTH-001: Proceso de autenticación
- UC-001: Iniciar Sesión
- UC-002: Renovar Sesión
- RF-005: Validación de credenciales
- RF-006: Generación de token JWT
- RF-010: Registro de auditoría
- PROC-LOGIN-001: Procedimiento operacional

---

### Caso 2: Sistema de Evaluación de Permisos en Tres Niveles
**Archivo:** [`caso-practico-02-evaluacion-permisos.md`](./caso-practico-02-evaluacion-permisos.md)

**Resumen:** Sistema de autorización granular que evalúa permisos en tres niveles jerárquicos: Rol Global, Permisos de Operación y Contexto Específico. Garantiza control de acceso fino y auditable.

**Stakeholders principales:**
- Agentes
- Supervisores
- Administradores
- Auditores

**Componentes clave:**
- PROC-PERM-001: Proceso de evaluación de permisos
- UC-010: Evaluar permiso de acceso a recurso
- UC-011: Gestionar permisos de usuario
- RF-001: Evaluación en tres niveles
- RF-011: Gestión de roles y permisos
- RF-012: Auditoría de decisiones
- PROC-PERM-ADMIN-001: Procedimiento de asignación

---

### Caso 3: Sistema de Auditoría de Seguridad
**Archivo:** [`caso-practico-03-auditoria-seguridad.md`](./caso-practico-03-auditoria-seguridad.md)

**Resumen:** Sistema integral de registro inmutable de eventos de seguridad con detección automática de patrones de amenaza, generación de alertas y reportes de cumplimiento regulatorio.

**Stakeholders principales:**
- Oficial de Seguridad
- Auditores externos
- Administradores
- Oficiales de cumplimiento

**Componentes clave:**
- PROC-AUDIT-001: Proceso de registro y análisis
- UC-020: Registrar evento de auditoría
- UC-021: Detectar patrón sospechoso
- UC-022: Generar reporte de auditoría
- RF-020: Registro inmutable
- RF-021: Detección automática de amenazas
- RF-022: Generación de reportes
- PROC-AUDIT-REVIEW-001: Procedimiento de revisión

---

## Referencias a Documentación Real

Todos los casos prácticos están basados en documentación real del proyecto IACT:

- **Reglas de Negocio:** `docs/implementacion/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md` (1859 líneas, 14 reglas)
- **Requisitos Funcionales:** `docs/implementacion/backend/requisitos/funcionales/rf001_evaluacion_permisos_tres_niveles.md` (1039 líneas)
- **Decisiones Arquitectónicas:** `docs/gobernanza/adr/ADR-017-sistema-permisos-sin-roles-jerarquicos.md`

---

## Valor Demostrativo

Estos casos prácticos demuestran:

1. **Flujo completo:** Desde proceso de negocio hasta procedimiento operacional
2. **Trazabilidad bidireccional:** Cada artefacto referencia sus orígenes y derivados
3. **Aplicación de estándares:** ISO 29148:2018, BABOK v3, UML 2.5
4. **Integración real:** Basados en código y documentación existente del proyecto
5. **Cobertura completa:** Todos los niveles del marco integrado representados

---

## Matriz de Trazabilidad Consolidada

### Trazabilidad Upward (hacia requisitos de negocio)

| Requisito Funcional | Caso de Uso | Proceso | Reglas de Negocio |
|---------------------|-------------|---------|------------------|
| RF-005 | UC-001 | PROC-AUTH-001 | RN-C01-01, RN-C01-02, RN-C01-03 |
| RF-006 | UC-001, UC-002 | PROC-AUTH-001 | RN-C01-05, RN-C01-14 |
| RF-010 | UC-001 | PROC-AUTH-001 | - |
| RF-001 | UC-010 | PROC-PERM-001 | - |
| RF-011 | UC-011 | PROC-PERM-001 | - |
| RF-012 | UC-010 | PROC-PERM-001 | - |
| RF-020 | UC-020 | PROC-AUDIT-001 | - |
| RF-021 | UC-021 | PROC-AUDIT-001 | - |
| RF-022 | UC-022 | PROC-AUDIT-001 | - |

### Trazabilidad Downward (hacia implementación)

| Proceso | Casos de Uso | Requisitos | Procedimientos | Pruebas |
|---------|--------------|-----------|----------------|---------|
| PROC-AUTH-001 | UC-001, UC-002 | RF-005, RF-006, RF-010, RNF-005 | PROC-LOGIN-001 | TS-RF-005-001, TS-RF-006-001, TS-RF-010-001 |
| PROC-PERM-001 | UC-010, UC-011 | RF-001, RF-011, RF-012 | PROC-PERM-ADMIN-001 | TS-RF-001-001, TS-RF-011-001, TS-RF-012-001 |
| PROC-AUDIT-001 | UC-020, UC-021, UC-022 | RF-020, RF-021, RF-022 | PROC-AUDIT-REVIEW-001 | TS-RF-020-001, TS-RF-021-001, TS-RF-022-001 |

---

## Uso de los Casos Prácticos

### Para Analistas de Negocio
- Revisar cómo se transforman procesos de negocio en casos de uso
- Entender la aplicación de reglas de negocio en requisitos
- Usar como plantilla para nuevos análisis

### Para Desarrolladores
- Entender el contexto de negocio detrás de cada requisito
- Consultar trazabilidad para impacto de cambios
- Revisar criterios de aceptación antes de implementar

### Para QA
- Derivar casos de prueba de los requisitos funcionales
- Validar cobertura de pruebas con matrices de trazabilidad
- Consultar procedimientos operacionales para pruebas E2E

### Para Product Owners
- Validar que necesidades de negocio están cubiertas
- Priorizar requisitos basados en procesos críticos
- Revisar completitud del análisis antes de sprint

---

## Próximos Pasos

Para aplicar el marco integrado a nuevos componentes:

1. **Usar plantillas:** Consultar `../plantillas/` para documentación estandarizada
2. **Seguir metodología:** Revisar `../04_metodologia_analisis_iact.md` para proceso de 4 fases
3. **Validar trazabilidad:** Usar matrices RTM para garantizar completitud
4. **Documentar decisiones:** Crear ADRs para decisiones arquitectónicas importantes

---

## Referencias

- **Documento maestro:** `../05a_casos_practicos_iact.md`
- **Caso didáctico genérico:** `../05b_caso_didactico_generico.md`
- **Plantillas integradas:** `../06_plantillas_integradas_iact.md`
- **Marco conceptual:** `../01_marco_conceptual_iact.md`
- **Relaciones fundamentales:** `../02_relaciones_fundamentales_iact.md`
- **Matrices de trazabilidad:** `../03_matrices_trazabilidad_iact.md`
- **Metodología de análisis:** `../04_metodologia_analisis_iact.md`

---

**Última actualización:** 2025-11-16
**Responsable:** Equipo de Análisis de Negocio
**Estado:** Vigente
