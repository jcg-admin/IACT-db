---
id: DOC-SRS
titulo: Software Requirements Specification (SRS)
generado: 2025-11-06 12:24:27
estandar: ISO/IEC/IEEE 29148:2018 - Clause 9.6
conformance: Full Conformance
date: 2025-11-13
---

# Software Requirements Specification (SRS)

GENERADO AUTOMATICAMENTE - NO EDITAR MANUALMENTE

Este documento consolida todos los requisitos funcionales del proyecto IACT.

Conforme a: ISO/IEC/IEEE 29148:2018 - Clause 9.6

---

## Resumen Ejecutivo

Total de requisitos funcionales: 19

Por dominio:
- backend: 16 requisitos
- frontend: 2 requisitos
- infrastructure: 1 requisitos

---

## Dominio: BACKEND

### RF-001: Sistema de evaluación de permisos con tres niveles de precedencia

- **Owner**: equipo-backend
- **Prioridad**: critica
- **Estado**: implementado
- **Archivo**: `docs/backend/requisitos/funcionales/rf001_evaluacion_permisos_tres_niveles.md`
- **Deriva de**: N-001  # Necesidad de control de acceso granular
- **Verificación**: test

### RF-001: Login con credenciales username/password

- **Owner**: equipo-backend
- **Prioridad**: critica
- **Estado**: aprobado
- **Archivo**: `docs/backend/requisitos/funcionales/rf001_login_credenciales.md`
- **Deriva de**: N-001   # Prevenir accesos fraudulentos mediante autenticacion robusta, RN-001  # Sistema de autenticacion seguro con prevencion de fraude, RS-001  # Auditoria requiere trazabilidad completa, RS-002  # Usuarios requieren acceso rapido
- **Verificación**: test

### RF-002: Generacion de tokens JWT (access 15min, refresh 7dias)

- **Owner**: equipo-backend
- **Prioridad**: critica
- **Estado**: aprobado
- **Archivo**: `docs/backend/requisitos/funcionales/rf002_jwt_tokens.md`
- **Deriva de**: [, N, -, 0, 0, 1, ,,  , R, N, -, 0, 0, 1, ,,  , R, S, -, 0, 0, 2, ]
- **Verificación**: test

### RF-002: Gestión de permisos granulares basados en recurso y acción

- **Owner**: equipo-backend
- **Prioridad**: alta
- **Estado**: implementado
- **Archivo**: `docs/backend/requisitos/funcionales/rf002_gestion_permisos_granulares.md`
- **Deriva de**: N-001  # Necesidad de control de acceso granular
- **Verificación**: test

### RF-003: Bloqueo automatico tras 5 intentos fallidos en 5 minutos

- **Owner**: equipo-backend
- **Prioridad**: critica
- **Estado**: aprobado
- **Archivo**: `docs/backend/requisitos/funcionales/rf003_bloqueo_intentos_fallidos.md`
- **Deriva de**: [, N, -, 0, 0, 1, ,,  , R, N, -, 0, 0, 1, ,,  , R, S, -, 0, 0, 1, ]
- **Verificación**: test

### RF-003: Obtener todos los permisos efectivos de un usuario

- **Owner**: equipo-backend
- **Prioridad**: alta
- **Estado**: implementado
- **Archivo**: `docs/backend/requisitos/funcionales/rf003_obtener_permisos_efectivos_usuario.md`
- **Deriva de**: N-001  # Necesidad de control de acceso granular
- **Verificación**: test

### RF-004: Sesion unica con cierre de sesiones previas

- **Owner**: equipo-backend
- **Prioridad**: alta
- **Estado**: aprobado
- **Archivo**: `docs/backend/requisitos/funcionales/rf004_sesion_unica.md`
- **Deriva de**: [, N, -, 0, 0, 1, ,,  , R, N, -, 0, 0, 1, ,,  , R, S, -, 0, 0, 1, ]
- **Verificación**: test

### RF-004: Segmentación de usuarios con criterios dinámicos

- **Owner**: equipo-backend
- **Prioridad**: alta
- **Estado**: implementado
- **Archivo**: `docs/backend/requisitos/funcionales/rf004_segmentos_criterios_dinamicos.md`
- **Deriva de**: N-001  # Necesidad de control de acceso granular
- **Verificación**: test

### RF-005: Logout manual con invalidacion de tokens

- **Owner**: equipo-backend
- **Prioridad**: alta
- **Estado**: aprobado
- **Archivo**: `docs/backend/requisitos/funcionales/rf005_logout.md`
- **Deriva de**: [, N, -, 0, 0, 1, ,,  , R, N, -, 0, 0, 1, ,,  , R, S, -, 0, 0, 1, ]
- **Verificación**: test

### RF-005: Login con credenciales locales y validación

- **Owner**: equipo-backend
- **Prioridad**: critica
- **Estado**: pendiente
- **Archivo**: `docs/backend/requisitos/funcionales/rf005_login_credenciales_locales.md`
- **Deriva de**: RN-C01-01  # Login con Credenciales Locales, RN-C01-02  # Validación de Credenciales
- **Verificación**: test

### RF-006: Recuperacion de password sin email mediante 3 preguntas seguridad

- **Owner**: equipo-backend
- **Prioridad**: media
- **Estado**: aprobado
- **Archivo**: `docs/backend/requisitos/funcionales/rf006_recuperacion_sin_email.md`
- **Deriva de**: [, N, -, 0, 0, 1, ,,  , R, N, -, 0, 0, 1, ]
- **Verificación**: test

### RF-006: Generación y validación de tokens JWT

- **Owner**: equipo-backend
- **Prioridad**: critica
- **Estado**: pendiente
- **Archivo**: `docs/backend/requisitos/funcionales/rf006_tokens_jwt.md`
- **Deriva de**: RN-C01-03  # Generación de Tokens JWT, RN-C01-04  # Validación de Tokens JWT, RN-C01-11  # Refresh Token
- **Verificación**: test

### RF-007: Logout manual y cierre de sesión

- **Owner**: equipo-backend
- **Prioridad**: alta
- **Estado**: pendiente
- **Archivo**: `docs/backend/requisitos/funcionales/rf007_logout_manual.md`
- **Deriva de**: RN-C01-05  # Logout Manual, RN-C01-12  # Auditoría de Login
- **Verificación**: test

### RF-008: Cierre automático de sesiones por inactividad

- **Owner**: equipo-backend
- **Prioridad**: alta
- **Estado**: pendiente
- **Archivo**: `docs/backend/requisitos/funcionales/rf008_cierre_inactividad.md`
- **Deriva de**: RN-C01-06  # Cierre por Inactividad, RN-C01-12  # Auditoría de Login
- **Verificación**: test

### RF-009: Gestión de contraseñas seguras e intentos fallidos

- **Owner**: equipo-backend
- **Prioridad**: critica
- **Estado**: pendiente
- **Archivo**: `docs/backend/requisitos/funcionales/rf009_gestion_passwords_intentos_fallidos.md`
- **Deriva de**: RN-C01-07  # Complejidad de Contraseñas, RN-C01-08  # Intentos Fallidos Limitados, RN-C01-09  # Bloqueo Temporal de Cuenta, RN-C01-10  # Hash Seguro de Passwords
- **Verificación**: test

### RF-010: Sesión única por usuario en PostgreSQL

- **Owner**: equipo-backend
- **Prioridad**: critica
- **Estado**: pendiente
- **Archivo**: `docs/backend/requisitos/funcionales/rf010_sesion_unica.md`
- **Deriva de**: RN-C01-13  # Sesiones en PostgreSQL, RN-C01-14  # Sesión Única por Usuario
- **Verificación**: test

## Dominio: FRONTEND

### RF-010: Pantalla de login con validaciones

- **Owner**: equipo-frontend
- **Prioridad**: critica
- **Estado**: aprobado
- **Archivo**: `docs/frontend/requisitos/funcionales/rf010_pantalla_login.md`
- **Deriva de**: [, N, -, 0, 0, 1, ,,  , R, N, -, 0, 0, 1, ,,  , R, S, -, 0, 0, 2, ]
- **Verificación**: demonstration

### RF-011: Pantalla de cambio de password

- **Owner**: equipo-frontend
- **Prioridad**: media
- **Estado**: aprobado
- **Archivo**: `docs/frontend/requisitos/funcionales/rf011_cambio_password_ui.md`
- **Deriva de**: [, N, -, 0, 0, 1, ,,  , R, N, -, 0, 0, 1, ]
- **Verificación**: demonstration

## Dominio: INFRASTRUCTURE

### RF-020: CPython 3.12.6 precompilado en Dev Container

- **Owner**: equipo-infraestructura
- **Prioridad**: media
- **Estado**: aprobado
- **Archivo**: `docs/infraestructura/requisitos/funcionales/rf020_cpython_precompilado.md`
- **Deriva de**: [, O, b, j, e, t, i, v, o, -, D, e, v, E, x, p, ]
- **Verificación**: demonstration


---

Generado: 2025-11-06 12:24:27
