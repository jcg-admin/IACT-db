.. _uc-auth-01-parte-01:

============================================
Parte 1 — Informacion general de UC_AUTH_01
============================================

1.1 Identificacion
==================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID UC**
   - UC_AUTH_01
 * - **Nombre**
   - Iniciar Sesion
 * - **Version spec**
   - 5.0.0 (estructura 12-partes)
 * - **Fecha**
   - 2026-05-01
 * - **Autor**
   - NestorMonroy
 * - **Clasificacion**
   - Critico (criticidad CRITICO segun
     :doc:`/arquitectura-tecnica/matriz-dependencias-uc-iact`
     § 1.2.1)
 * - **Modulo**
   - MOD_Auth
 * - **WP origen**
   - ``2026-05-01-07-00-34-uc-auth-01-spec-completa``
 * - **Predecesor analitico**
   - ``2026-05-01-06-33-29-uc-auth-01-analisis``
     (3 analisis: uml-06, uml-07,
     template-completo)

1.2 Proposito
=============

UC_AUTH_01 permite a un usuario registrado
autenticarse en el sistema IACT mediante sus
credenciales (username y password), produciendo
una ``Session`` activa que constituye la
**precondicion universal T-01** documentada en
:doc:`/arquitectura-tecnica/matriz-dependencias-uc-iact`
§ 4.3.

El proposito desde el punto de vista del usuario
es **acceder funcionalmente al sistema** —
visualizar dashboards, gestionar reportes,
consultar auditoria, supervisar el ETL, segun el
``AccessGroup`` (AGR-001..010) al que pertenece.
Los tokens JWT que el sistema genera son el
**mecanismo**, no el resultado de valor.

El proposito desde la perspectiva del sistema es
**establecer la identidad autenticada** que
gobernara todas las invocaciones subsecuentes
del usuario hasta cierre de sesion (UC_AUTH_02),
expiracion (CNST-005) o invalidacion por inicio
de nueva sesion en otro dispositivo (CNST-004).

1.3 Alcance
===========

1.3.1 IN (incluido en este UC)
------------------------------

- Recoleccion de credenciales en formulario
  ``/login`` servido por HTTPS.
- Validacion de formato y completitud de input
  vía DRF Serializer (CNST-012).
- Throttling de intentos por usuario / IP
  (CNST-011: 5 intentos / 5 minutos).
- Verificacion de existencia y estado del
  ``User`` (state ∈ {ACTIVE, INACTIVE, BLOCKED}
  per BR-009 v2.0.0).
- Verificacion del password vía bcrypt
  constant-time.
- Aplicacion de **CNST-004 sesion unica** —
  cierre de Sessions previas activas del mismo
  ``User``.
- Generacion de tokens JWT (access + refresh) y
  persistencia de ``Session`` en BD (CNST-003).
- Emision de ``AuditEvent`` ``LOGIN`` inmutable
  (CNST-025).
- Manejo estandarizado de excepciones DRF
  (CNST-013): respuestas 4xx con error_code y
  estructura JSON consistente.
- Respuestas con manejo de errores (UC-AUTH-01:
  EX-01..EX-07).
- Integracion con ``InternalMailbox`` (CNST-002)
  cuando el flujo deriva a recovery o cambio
  forzado de contrasena.

1.3.2 OUT (excluido — vive en otros UCs o ADRs)
-----------------------------------------------

- Registro de nuevos usuarios — IACT no expone
  registro publico; el alta de usuarios la
  realiza un administrador via UC_USR_01 sobre
  un ``User`` con state PENDIENTE.
- Recuperacion de contrasena — UC_AUTH_03.
- Cambio de contrasena — UC_AUTH_04 (puede
  invocarse como extension de este UC en FA-01
  / FA-02).
- Cierre de sesion explicito por usuario —
  UC_AUTH_02.
- Gestion administrativa de Sessions activas —
  UC_AUTH_05.
- OAuth / SSO con identity provider externo —
  fuera del alcance de la version actual del
  producto.
- 2FA / MFA — no incorporado en v1.0; pendiente
  de ADR futuro.
- Cifrado de datos en reposo — responsabilidad
  de la capa de infraestructura (ADR-DEVOPS-001
  + CNST-028).

1.3.3 Posicion en el flujo critico
----------------------------------

UC_AUTH_01 es el **paso B.1 de la Ruta B
Operador / Supervisor**, **C.1 de la Ruta C
Administrador RBAC**, y **D.1 de la Ruta D
Auditor** documentadas en
:doc:`/arquitectura-tecnica/matriz-dependencias-uc-iact`
§ 4.1.

Su pre-condicion estructural es:

- **Ruta A** (Sistema / background) operacional
  — la BD analitica esta poblada por
  ``UC_PIP_01 Supervisar ETL`` dentro de la
  ventana CNST-006/008.

UC_AUTH_01 no requiere otros UCs como invocacion
sincrona; no extiende a ningun UC; es **extendido
por UC_AUTH_04** en los flujos alternos FA-01 y
FA-02.

1.4 Trazabilidad inicial
========================

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **BReq origen**
   - BRQ-AUTH-001 — el sistema debe permitir
     autenticacion segura de usuarios con
     credenciales username + password.
 * - **Reglas de Negocio**
   - BR-AUTH-01..07 (cluster AUTH); BR-009
     v2.0.0 (alcance global de soft-delete).
 * - **Restricciones (CNST canonicas vigentes)**
   - CNST-001 prohibicion de email; CNST-002
     buzon interno obligatorio; CNST-003
     sesiones persistidas en BD; CNST-004 sesion
     unica por usuario; CNST-005 timeout 15 min;
     CNST-009 autenticacion DRF; CNST-011
     throttling endpoints publicos; CNST-013
     manejo estandarizado excepciones DRF;
     CNST-025 auditoria inmutable.
 * - **Funcion RBAC**
   - publica (no requiere funcion previa);
     post-login el ``User`` recibe AUTH-001
     ``view_own_sessions`` que habilita
     UC_AUTH_05 sobre sus propias Sessions.
 * - **UC Relacionados**
   - UC_AUTH_02 (Cerrar Sesion), UC_AUTH_04
     (Cambiar Contrasena, extiende), UC_AUTH_05
     (Gestionar Sesiones, consume).
 * - **Clase de Dominio primaria**
   - ``Session``
 * - **Clases secundarias**
   - ``User``, ``InternalMailbox``, ``AuditEvent``

Las partes 2-12 expanden cada uno de estos
ejes.
