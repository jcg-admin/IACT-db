# REPORTE: Análisis de Marco Integrado - Archivos a Crear

**Fecha de Análisis:** 2025-11-17 08:35:00
**Autor:** Claude Code (Sonnet 4.5)
**Archivos Analizados:**
- `docs/gobernanza/marco_integrado/05a_casos_practicos_iact.md` (1249 líneas)
- `docs/gobernanza/marco_integrado/05b_caso_didactico_generico.md` (1086 líneas) - EXCLUIDO (pedagógico)
- `docs/gobernanza/marco_integrado/06_plantillas_integradas_iact.md` (1536 líneas)

---

## Resumen Ejecutivo

El marco integrado define 3 casos prácticos REALES del proyecto IACT que requieren crear 54+ archivos de documentación de análisis de negocio. De estos:
- 21 archivos YA EXISTEN
- 54+ archivos necesitan ser CREADOS
- Prioridad: 47 MUST, 17+ SHOULD, 6 COULD

---

## Caso Práctico 1: Sistema de Autenticación y Gestión de Sesiones

### Archivos Existentes (Reglas de Negocio)

**RN-C01**: Autenticación y Sesiones (14 reglas)
- Ubicación: `docs/backend/requisitos/requerimientos_negocio/rn_c01_autenticacion_sesiones.md`
- Estado: EXISTE (1859 líneas)
- Reglas: RN-C01-01 a RN-C01-14

### Archivos a Crear

#### Procesos (1 archivo - MUST)
- **PROC-AUTH-001**: Proceso de Autenticación de Usuario
  - Ubicación: `docs/gobernanza/procesos/PROC-AUTH-001-autenticacion_usuario.md`
  - Contenido: Diagrama de flujo, actores, reglas RN-C01

#### Casos de Uso (2 archivos - MUST)
- **UC-001**: Iniciar Sesión
  - Ubicación: `docs/gobernanza/casos_de_uso/UC-001-iniciar_sesion.md`
  - Contenido: Actor principal, flujo 8 pasos, 3 flujos alternativos

- **UC-002**: Renovar Sesión
  - Ubicación: `docs/gobernanza/casos_de_uso/UC-002-renovar_sesion.md`
  - Contenido: Sistema automático, flujo 7 pasos

#### Requisitos Funcionales (3 archivos - MUST)
- **RF-005**: Validación de Credenciales
  - Ubicación: `docs/backend/requisitos/requerimientos_funcionales/RF-005-validacion_credenciales.md`
  - Criterios: 5 criterios de aceptación

- **RF-006**: Generación de Token JWT
  - Ubicación: `docs/backend/requisitos/requerimientos_funcionales/RF-006-generacion_token_jwt.md`
  - Criterios: 5 criterios de aceptación
  - Estructura: userId, email, rol, permissions, iat, exp

- **RF-010**: Registro de Auditoría de Autenticación
  - Ubicación: `docs/backend/requisitos/requerimientos_funcionales/RF-010-registro_auditoria_autenticacion.md`
  - Eventos: LOGIN_SUCCESS, LOGIN_FAILED, LOGIN_BLOCKED, SESSION_RENEWED

#### Requisitos No Funcionales (1 archivo - SHOULD)
- **RNF-005**: Tiempo de Respuesta de Autenticación
  - Ubicación: `docs/backend/requisitos/atributos_calidad/RNF-005-tiempo_respuesta_autenticacion.md`
  - Métricas: P50 <= 200ms, P95 <= 500ms, P99 <= 1000ms

#### Procedimientos (1 archivo - SHOULD)
- **PROCED-LOGIN-001**: Procedimiento de Inicio de Sesión
  - Ubicación: `docs/gobernanza/procedimientos/PROCED-LOGIN-001-procedimiento_inicio_sesion.md`
  - Contenido: 9 pasos, casos especiales, mockup UI

#### Tests (4 archivos - MUST)
- **TS-RF-005-001**: Validación Credenciales Válidas
- **TS-RF-005-002**: Validación Credenciales Inválidas
- **TS-RF-006-001**: Generación Token JWT
- **TS-RF-010-001**: Registro Auditoría
  - Ubicación: `docs/backend/testing/TS-RF-XXX-YYY-*.md`

**Subtotal Caso 1:** 12 archivos a crear

---

## Caso Práctico 2: Sistema de Evaluación de Permisos en Tres Niveles

### Archivos Existentes

**RF-001**: Evaluación de Permisos en Tres Niveles
- Ubicación: `docs/backend/requisitos/requerimientos_funcionales/rf001_evaluacion_permisos_tres_niveles.md`
- Estado: EXISTE (1039 líneas)

### Archivos a Crear

#### Procesos (1 archivo - MUST)
- **PROC-PERM-001**: Proceso de Evaluación de Permisos
  - Ubicación: `docs/gobernanza/procesos/PROC-PERM-001-evaluacion_permisos.md`
  - Contenido: 3 niveles (Rol, Operación, Contexto)

#### Casos de Uso (2 archivos - MUST)
- **UC-010**: Evaluar Permiso de Acceso a Recurso
  - Ubicación: `docs/gobernanza/casos_de_uso/UC-010-evaluar_permiso_acceso.md`
  - Contenido: Middleware, flujo 10 pasos, 3 flujos alternativos

- **UC-011**: Gestionar Permisos de Usuario
  - Ubicación: `docs/gobernanza/casos_de_uso/UC-011-gestionar_permisos_usuario.md`
  - Contenido: Asignación, modificación, revocación

#### Requisitos Funcionales (2 archivos - MUST/SHOULD)
- **RF-011**: Gestión de Roles y Permisos (MUST)
  - Ubicación: `docs/backend/requisitos/requerimientos_funcionales/RF-011-gestion_roles_permisos.md`
  - Operaciones: ASSIGN_ROLE, GRANT_PERMISSION, REVOKE_PERMISSION

- **RF-012**: Auditoría de Decisiones de Autorización (SHOULD)
  - Ubicación: `docs/backend/requisitos/requerimientos_funcionales/RF-012-auditoria_decisiones_autorizacion.md`
  - Eventos: PERMISSION_GRANTED, PERMISSION_DENIED

#### Procedimientos (1 archivo - SHOULD)
- **PROCED-PERM-ADMIN-001**: Asignar Permisos a Usuario
  - Ubicación: `docs/gobernanza/procedimientos/PROCED-PERM-ADMIN-001-asignar_permisos_usuario.md`
  - Contenido: 13 pasos, ejemplo agente → supervisor

#### Tests (12 archivos - MUST/SHOULD)
- **TS-RF-001-001 a TS-RF-001-010**: Tests Evaluación Permisos (10 tests)
  - Nivel 1, Nivel 2, Nivel 3, casos mixtos
- **TS-RF-011-001**: Test Gestión Roles
- **TS-RF-012-001**: Test Auditoría Decisiones
  - Ubicación: `docs/backend/testing/TS-RF-XXX-YYY-*.md`

**Subtotal Caso 2:** 18 archivos a crear

---

## Caso Práctico 3: Sistema de Auditoría de Seguridad

### Archivos a Crear

#### Procesos (1 archivo - MUST)
- **PROC-AUDIT-001**: Proceso de Registro y Análisis de Eventos
  - Ubicación: `docs/gobernanza/procesos/PROC-AUDIT-001-registro_analisis_eventos_seguridad.md`
  - Contenido: Clasificación (INFO/WARNING/CRITICAL), patrones

#### Casos de Uso (3 archivos - MUST/SHOULD)
- **UC-020**: Registrar Evento de Auditoría (MUST)
  - Ubicación: `docs/gobernanza/casos_de_uso/UC-020-registrar_evento_auditoria.md`

- **UC-021**: Detectar Patrón Sospechoso (SHOULD)
  - Ubicación: `docs/gobernanza/casos_de_uso/UC-021-detectar_patron_sospechoso.md`
  - Patrones: Fuerza Bruta, Escalación, Acceso Anómalo, Extracción, Manipulación

- **UC-022**: Generar Reporte de Auditoría (SHOULD)
  - Ubicación: `docs/gobernanza/casos_de_uso/UC-022-generar_reporte_auditoria.md`
  - Formatos: PDF, CSV, JSON

#### Requisitos Funcionales (3 archivos - MUST/SHOULD)
- **RF-020**: Registro Inmutable de Eventos (MUST)
  - Ubicación: `docs/backend/requisitos/requerimientos_funcionales/RF-020-registro_inmutable_eventos.md`
  - Contenido: Tabla audit_log, trigger prevención, hash SHA-256

- **RF-021**: Detección Automática de Amenazas (SHOULD)
  - Ubicación: `docs/backend/requisitos/requerimientos_funcionales/RF-021-deteccion_automatica_amenazas.md`
  - Reglas: 5 patrones de detección

- **RF-022**: Generación de Reportes de Auditoría (SHOULD)
  - Ubicación: `docs/backend/requisitos/requerimientos_funcionales/RF-022-generacion_reportes_auditoria.md`
  - Formatos: PDF, CSV, JSON

#### Procedimientos (1 archivo - SHOULD)
- **PROCED-AUDIT-REVIEW-001**: Revisión de Eventos de Seguridad
  - Ubicación: `docs/gobernanza/procedimientos/PROCED-AUDIT-REVIEW-001-revision_eventos_seguridad.md`
  - Contenido: 10 pasos, checklist, frecuencias

#### Tests (7 archivos - MUST/SHOULD)
- **TS-RF-020-001**: Registro Inmutable (MUST)
- **TS-RF-021-001 a TS-RF-021-005**: Detección Amenazas (5 tests - SHOULD/MUST)
  - Fuerza Bruta, Escalación, Acceso Anómalo, Extracción, Manipulación
- **TS-RF-022-001**: Generación Reportes (SHOULD)
  - Ubicación: `docs/backend/testing/TS-RF-XXX-YYY-*.md`

**Subtotal Caso 3:** 15 archivos a crear

---

## Plantillas del Marco Integrado

### Estado: Todas EXISTEN

Las 5 plantillas propuestas en el documento 06 ya están creadas:

1. Plantilla 1: Documento Maestro de Análisis Integrado
   - Ubicación: `docs/gobernanza/analisis_negocio/marco_integrado/plantillas/plantilla-01-documento-maestro-analisis.md`

2. Plantilla 2: Matriz de Trazabilidad Extendida (RTM)
   - Ubicación: `docs/gobernanza/analisis_negocio/marco_integrado/plantillas/plantilla-02-matriz-trazabilidad-rtm.md`

3. Plantilla 3: Checklist de Completitud del Análisis
   - Ubicación: `docs/gobernanza/analisis_negocio/marco_integrado/plantillas/plantilla-03-checklist-completitud.md`

4. Plantilla 4: Especificación Rápida de Regla de Negocio
   - Ubicación: `docs/gobernanza/analisis_negocio/marco_integrado/plantillas/plantilla-04-regla-negocio.md`

5. Guía de Uso de Plantillas
   - Ubicación: `docs/gobernanza/analisis_negocio/marco_integrado/plantillas/guia-uso-plantillas.md`

---

## Matrices de Trazabilidad (3 archivos - SHOULD)

- **RTM-001**: Matriz Autenticación y Sesiones
  - Ubicación: `docs/gobernanza/trazabilidad/RTM-001-autenticacion_sesiones.md`

- **RTM-002**: Matriz Evaluación de Permisos
  - Ubicación: `docs/gobernanza/trazabilidad/RTM-002-evaluacion_permisos.md`

- **RTM-003**: Matriz Auditoría de Seguridad
  - Ubicación: `docs/gobernanza/trazabilidad/RTM-003-auditoria_seguridad.md`

---

## Diagramas (6 archivos - COULD - OPCIONAL)

### Diagramas BPMN (3 archivos)
- DIAG-PROC-AUTH-001: Autenticación
- DIAG-PROC-PERM-001: Evaluación Permisos
- DIAG-PROC-AUDIT-001: Auditoría

### Diagramas UML (3 archivos)
- UML-UC-AUTH: Casos de Uso Autenticación
- UML-UC-PERM: Casos de Uso Permisos
- UML-UC-AUDIT: Casos de Uso Auditoría

---

## Resumen Total

### Estadísticas Generales

| Categoría | Total | Ya Existen | A Crear | MUST | SHOULD | COULD |
|-----------|-------|------------|---------|------|--------|-------|
| Reglas de Negocio | 14 | 14 | 0 | 14 | 0 | 0 |
| Procesos | 3 | 0 | 3 | 3 | 0 | 0 |
| Casos de Uso | 8 | 0 | 8 | 5 | 3 | 0 |
| Requisitos Funcionales | 9 | 2 | 7 | 4 | 3 | 0 |
| Requisitos No Funcionales | 1 | 0 | 1 | 0 | 1 | 0 |
| Procedimientos | 3 | 0 | 3 | 0 | 3 | 0 |
| Tests | 23 | 0 | 23 | 15 | 8 | 0 |
| Matrices RTM | 3 | 0 | 3 | 0 | 3 | 0 |
| Plantillas | 5 | 5 | 0 | 0 | 0 | 0 |
| Diagramas | 6 | 0 | 6 | 0 | 0 | 6 |
| **TOTAL** | **75** | **21** | **54** | **41** | **21** | **6** |

### Distribución por Dominio

| Dominio | Archivos | MUST | SHOULD | COULD |
|---------|----------|------|--------|-------|
| BACK | 35 | 27 | 8 | 0 |
| FRONT | 6 | 2 | 4 | 0 |
| DEVOPS | 1 | 0 | 1 | 0 |
| QA | 23 | 15 | 8 | 0 |
| GOB | 13 | 3 | 4 | 6 |

---

## Plan de Implementación Recomendado

### Fase 1: MUST - Crítico (41 archivos)

**Prioridad Alta - Semana 1-2**
1. Procesos (3): PROC-AUTH-001, PROC-PERM-001, PROC-AUDIT-001
2. Casos de Uso críticos (5): UC-001, UC-002, UC-010, UC-011, UC-020
3. Requisitos Funcionales críticos (4): RF-005, RF-006, RF-010, RF-020
4. Tests críticos (15): TS-RF-005-*, TS-RF-006-*, TS-RF-010-*, TS-RF-020-*, TS-RF-021-005

### Fase 2: SHOULD - Importante (21 archivos)

**Prioridad Media - Semana 3-4**
1. Casos de Uso adicionales (3): UC-021, UC-022
2. Requisitos Funcionales (3): RF-011, RF-012, RF-021, RF-022
3. Requisitos No Funcionales (1): RNF-005
4. Procedimientos (3): PROCED-LOGIN-001, PROCED-PERM-ADMIN-001, PROCED-AUDIT-REVIEW-001
5. Tests adicionales (8): TS-RF-011-*, TS-RF-012-*, TS-RF-021-001 a 004, TS-RF-022-*
6. Matrices RTM (3): RTM-001, RTM-002, RTM-003

### Fase 3: COULD - Opcional (6 archivos)

**Prioridad Baja - Backlog**
1. Diagramas BPMN (3)
2. Diagramas UML (3)

---

## Estructura de Directorios Propuesta

```
docs/
├── gobernanza/
│   ├── procesos/
│   │   ├── PROC-AUTH-001-autenticacion_usuario.md
│   │   ├── PROC-PERM-001-evaluacion_permisos.md
│   │   └── PROC-AUDIT-001-registro_analisis_eventos_seguridad.md
│   ├── casos_de_uso/
│   │   ├── [14 UC existentes]
│   │   ├── UC-001-iniciar_sesion.md
│   │   ├── UC-002-renovar_sesion.md
│   │   ├── UC-010-evaluar_permiso_acceso.md
│   │   ├── UC-011-gestionar_permisos_usuario.md
│   │   ├── UC-020-registrar_evento_auditoria.md
│   │   ├── UC-021-detectar_patron_sospechoso.md
│   │   └── UC-022-generar_reporte_auditoria.md
│   ├── procedimientos/
│   │   ├── [7 PROCED existentes]
│   │   ├── PROCED-LOGIN-001-procedimiento_inicio_sesion.md
│   │   ├── PROCED-PERM-ADMIN-001-asignar_permisos_usuario.md
│   │   └── PROCED-AUDIT-REVIEW-001-revision_eventos_seguridad.md
│   ├── trazabilidad/
│   │   ├── RTM-001-autenticacion_sesiones.md
│   │   ├── RTM-002-evaluacion_permisos.md
│   │   └── RTM-003-auditoria_seguridad.md
│   └── diagramas/ (opcional)
│       ├── DIAG-PROC-AUTH-001-autenticacion.svg
│       ├── DIAG-PROC-PERM-001-evaluacion_permisos.svg
│       └── DIAG-PROC-AUDIT-001-auditoria.svg
├── backend/
│   ├── requisitos/
│   │   ├── requerimientos_funcionales/
│   │   │   ├── [RF-001 existente]
│   │   │   ├── RF-005-validacion_credenciales.md
│   │   │   ├── RF-006-generacion_token_jwt.md
│   │   │   ├── RF-010-registro_auditoria_autenticacion.md
│   │   │   ├── RF-011-gestion_roles_permisos.md
│   │   │   ├── RF-012-auditoria_decisiones_autorizacion.md
│   │   │   ├── RF-020-registro_inmutable_eventos.md
│   │   │   ├── RF-021-deteccion_automatica_amenazas.md
│   │   │   └── RF-022-generacion_reportes_auditoria.md
│   │   ├── atributos_calidad/
│   │   │   └── RNF-005-tiempo_respuesta_autenticacion.md
│   │   └── requerimientos_negocio/
│   │       └── [RN-C01 existente]
│   └── testing/
│       ├── TS-RF-005-001-validacion_credenciales_validas.md
│       ├── TS-RF-005-002-validacion_credenciales_invalidas.md
│       ├── TS-RF-006-001-generacion_token_jwt.md
│       ├── TS-RF-010-001-registro_auditoria.md
│       ├── TS-RF-001-001 a 010-*.md (10 archivos)
│       ├── TS-RF-011-001-gestion_roles_permisos.md
│       ├── TS-RF-012-001-auditoria_decisiones.md
│       ├── TS-RF-020-001-registro_inmutable_eventos.md
│       ├── TS-RF-021-001 a 005-*.md (5 archivos)
│       └── TS-RF-022-001-generacion_reportes.md
```

---

## Recomendaciones

1. **Usar plantillas existentes**: Aprovechar las 5 plantillas del marco integrado ya creadas
2. **Mantener trazabilidad**: Cada archivo debe referenciar sus dependencias
3. **Nomenclatura consistente**: Seguir patrones PROC-XXX, UC-XXX, RF-XXX, etc.
4. **Priorizar MUST**: Concentrarse en los 41 archivos críticos primero
5. **Validar con stakeholders**: Revisar cada artefacto con dueños de procesos

---

## Archivos NO Crear

**Caso didáctico genérico (05b)**: NO crear archivos para el caso bancario, es pedagógico
**Plantillas (06)**: NO crear, ya todas existen

---

**FIN DEL REPORTE**

Fecha: 2025-11-17 08:35:00
Total archivos a crear: 54
Prioridad MUST: 41 archivos
Prioridad SHOULD: 21 archivos
Prioridad COULD: 6 archivos
