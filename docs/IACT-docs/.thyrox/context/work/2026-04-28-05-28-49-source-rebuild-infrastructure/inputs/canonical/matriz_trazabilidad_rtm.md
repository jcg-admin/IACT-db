---
id: DOC-RTM
titulo: Requirements Traceability Matrix (RTM)
generado: 2025-11-06 12:24:27
estandar: ISO/IEC/IEEE 29148:2018 - Clause 5.2.8
date: 2025-11-13
---

# Requirements Traceability Matrix (RTM)

GENERADO AUTOMATICAMENTE - NO EDITAR MANUALMENTE

Matriz de trazabilidad bidireccional de todos los requisitos.

---

## Trazabilidad Completa

| ID | Título | Tipo | Dominio | Estado | Upward (Deriva de) | Downward (Genera) |
|----|--------|------|---------|--------|-------------------|------------------|
| DOC-REQ-BACKEND-PLANTILLA |  |  |  | borrador | - | - |
| DOC-REQ-BACKEND-TRACE |  |  |  | borrador | - | - |
| DOC-RESTRICCIONES-MAESTRO | Documento Maestro de Restricciones y Lineamientos | restricciones | global | definitivo | - | - |
| N-001 | Obtener visibilidad de metricas operativas del IVR en tiempo casi real | necesidad | backend | aprobado | - | - |
| N-002 | Datos actualizados para toma de decisiones oportunas | necesidad | backend | aprobado | - | - |
| N-003 | Visibilidad de metricas operativas en tiempo casi real | necesidad | backend | aprobado | - | - |
| RF-001 | Sistema de evaluación de permisos con tres niveles de precedencia | funcional | backend | implementado | N-001  # Necesidad de control de acceso granular | TEST-001  # test_permission_precedence.py |
| RF-001 | Login con credenciales username/password | funcional | backend | aprobado | N-001   # Prevenir accesos fraudulentos mediante autenticacion robusta, RN-001  # Sistema de autenticacion seguro con prevencion de fraude, RS-001  # Auditoria requiere trazabilidad completa, RS-002  # Usuarios requieren acceso rapido | TEST-RF-001  # Suite de tests para RF-001, CODE-authentication-services  # apps/authentication/services.py, CODE-authentication-views  # apps/authentication/views.py |
| RF-002 | Generacion de tokens JWT (access 15min, refresh 7dias) | funcional | backend | aprobado | [, N, -, 0, 0, 1, ,,  , R, N, -, 0, 0, 1, ,,  , R, S, -, 0, 0, 2, ] | [, T, E, S, T, -, R, F, -, 0, 0, 2, ,,  , C, O, D, E, -, j, w, t, -, s, e, r, v, i, c, e, ] |
| RF-002 | Gestión de permisos granulares basados en recurso y acción | funcional | backend | implementado | N-001  # Necesidad de control de acceso granular | TEST-002  # Tests de Permission model |
| RF-003 | Bloqueo automatico tras 5 intentos fallidos en 5 minutos | funcional | backend | aprobado | [, N, -, 0, 0, 1, ,,  , R, N, -, 0, 0, 1, ,,  , R, S, -, 0, 0, 1, ] | [, T, E, S, T, -, R, F, -, 0, 0, 3, ,,  , C, O, D, E, -, l, o, g, i, n, -, a, t, t, e, m, p, t, -, s, e, r, v, i, c, e, ] |
| RF-003 | Obtener todos los permisos efectivos de un usuario | funcional | backend | implementado | N-001  # Necesidad de control de acceso granular | TEST-003  # Tests de permissions_for_user |
| RF-004 | Sesion unica con cierre de sesiones previas | funcional | backend | aprobado | [, N, -, 0, 0, 1, ,,  , R, N, -, 0, 0, 1, ,,  , R, S, -, 0, 0, 1, ] | [, T, E, S, T, -, R, F, -, 0, 0, 4, ,,  , C, O, D, E, -, s, e, s, s, i, o, n, -, s, e, r, v, i, c, e, ] |
| RF-004 | Segmentación de usuarios con criterios dinámicos | funcional | backend | implementado | N-001  # Necesidad de control de acceso granular | TEST-004  # Tests de Segment matching |
| RF-005 | Logout manual con invalidacion de tokens | funcional | backend | aprobado | [, N, -, 0, 0, 1, ,,  , R, N, -, 0, 0, 1, ,,  , R, S, -, 0, 0, 1, ] | [, T, E, S, T, -, R, F, -, 0, 0, 5, ,,  , C, O, D, E, -, l, o, g, o, u, t, -, v, i, e, w, ] |
| RF-005 | Login con credenciales locales y validación | funcional | backend | pendiente | RN-C01-01  # Login con Credenciales Locales, RN-C01-02  # Validación de Credenciales | TEST-005  # Tests de login |
| RF-006 | Recuperacion de password sin email mediante 3 preguntas seguridad | funcional | backend | aprobado | [, N, -, 0, 0, 1, ,,  , R, N, -, 0, 0, 1, ] | [, T, E, S, T, -, R, F, -, 0, 0, 6, ,,  , C, O, D, E, -, p, a, s, s, w, o, r, d, -, r, e, c, o, v, e, r, y, ] |
| RF-006 | Generación y validación de tokens JWT | funcional | backend | pendiente | RN-C01-03  # Generación de Tokens JWT, RN-C01-04  # Validación de Tokens JWT, RN-C01-11  # Refresh Token | TEST-006  # Tests de tokens JWT |
| RF-007 | Logout manual y cierre de sesión | funcional | backend | pendiente | RN-C01-05  # Logout Manual, RN-C01-12  # Auditoría de Login | TEST-007  # Tests de logout |
| RF-008 | Cierre automático de sesiones por inactividad | funcional | backend | pendiente | RN-C01-06  # Cierre por Inactividad, RN-C01-12  # Auditoría de Login | TEST-008  # Tests de cierre por inactividad |
| RF-009 | Gestión de contraseñas seguras e intentos fallidos | funcional | backend | pendiente | RN-C01-07  # Complejidad de Contraseñas, RN-C01-08  # Intentos Fallidos Limitados, RN-C01-09  # Bloqueo Temporal de Cuenta, RN-C01-10  # Hash Seguro de Passwords | TEST-009  # Tests de passwords e intentos fallidos |
| RF-010 | Pantalla de login con validaciones | funcional | frontend | aprobado | [, N, -, 0, 0, 1, ,,  , R, N, -, 0, 0, 1, ,,  , R, S, -, 0, 0, 2, ] | [, T, E, S, T, -, R, F, -, 0, 1, 0, -, u, i, ] |
| RF-010 | Sesión única por usuario en PostgreSQL | funcional | backend | pendiente | RN-C01-13  # Sesiones en PostgreSQL, RN-C01-14  # Sesión Única por Usuario | TEST-010  # Tests de sesión única |
| RF-011 | Pantalla de cambio de password | funcional | frontend | aprobado | [, N, -, 0, 0, 1, ,,  , R, N, -, 0, 0, 1, ] | [, T, E, S, T, -, R, F, -, 0, 1, 1, -, u, i, ] |
| RF-020 | CPython 3.12.6 precompilado en Dev Container | funcional | infrastructure | aprobado | [, O, b, j, e, t, i, v, o, -, D, e, v, E, x, p, ] | [, C, O, N, F, I, G, -, d, e, v, c, o, n, t, a, i, n, e, r, ] |
| RN-001 | Sistema de seguridad y auditoría conforme a ISO 27001 | negocio | backend | aprobado | N-001 | RS-001, RS-002, RF-001, RF-002, RF-003, RNF-001, RNF-002 |
| RN-C01-COMPONENTE-1 | Reglas de Negocio - Componente 1 - Autenticación y Sesiones | reglas_negocio | backend | completo_definitivo | - | - |
| RNF-001 | Tiempo de respuesta login menor 2 segundos (P95) | no_funcional | backend | aprobado | [, N, -, 0, 0, 1, ,,  , R, N, -, 0, 0, 1, ,,  , R, S, -, 0, 0, 2, ] | [, T, E, S, T, -, R, N, F, -, 0, 0, 1, -, p, e, r, f, o, r, m, a, n, c, e, ] |
| RNF-002 | Sesiones almacenadas en MySQL (NO Redis) | no_funcional | backend | aprobado | [, N, -, 0, 0, 1, ,,  , R, N, -, 0, 0, 1, ] | [, C, O, D, E, -, d, j, a, n, g, o, -, s, e, t, t, i, n, g, s, -, s, e, s, s, i, o, n, s, ] |
| RNF-020 | Disponibilidad del sistema 99.9% uptime | no_funcional | infrastructure | aprobado | [, R, N, -, 0, 0, 1, ] | [, M, O, N, I, T, O, R, -, u, p, t, i, m, e, ] |
| RS-001 | Auditoria requiere trazabilidad completa de accesos | stakeholder | backend | aprobado | N-001  # Prevenir accesos fraudulentos mediante autenticacion robusta, RN-001 # Sistema de autenticacion seguro con prevencion de fraude | RF-001  # Login con credenciales, RF-003  # Bloqueo intentos fallidos, RF-004  # Sesion unica, RF-005  # Logout manual |
| RS-002 | Usuarios requieren acceso rapido menor 2 segundos | stakeholder | backend | aprobado | N-001  # Prevenir accesos fraudulentos mediante autenticacion robusta, RN-001 # Sistema de autenticacion seguro con prevencion de fraude | RF-001  # Login con credenciales, RF-002  # Tokens JWT, RNF-001 # Tiempo respuesta login menor 2 segundos |
| RS-002 | Reportes automatizados de compliance | stakeholder | backend | aprobado | N-001, RN-001 | RF-002, RF-003, RNF-001 |

---

Generado: 2025-11-06 12:24:27
Total requisitos: 33
