.. meta::
   :project: IACT - Call Center Analytics
   :version: 4.0.0
   :date: 2026-01-06

.. _glosario:

================================
Glosario de Términos - IACT v4.0
================================

A
=

.. glossary::
   :sorted:

   Agrupador
      Mecanismo de asignación masiva de funciones atómicas a usuarios.
      NO es un rol tradicional. Internamente crea N asignaciones individuales.
      Ver: AGR-001 a AGR-010.

   Analytics
      Base de datos PostgreSQL de lectura-escritura donde se almacenan
      los datos procesados por el ETL, métricas, usuarios y auditoría.

   Auditoría
      Registro inmutable de todas las acciones realizadas en el sistema.
      Implementado mediante UserActionLog (CNST-009).

B
=

.. glossary::
   :sorted:

   Baja Lógica
      Método de eliminación de usuarios que cambia el estado a ELIMINADO
      sin borrar físicamente los datos. Requerido por CNST-005.

   BR (Business Rule)
      Regla de negocio que define restricciones o comportamientos
      específicos del dominio.

   BReq (Business Requirement)
      Requisito de negocio de alto nivel que origina los casos de uso.

C
=

.. glossary::
   :sorted:

   CNST (Constraint)
      Restricción de arquitectura que define limitaciones técnicas
      o de negocio que deben respetarse en todo el sistema.
      Ver: CNST-001 a CNST-010.

   Capacidad
      Permiso atómico expresado en formato "módulo:acción".
      Ejemplo: "users:crear", "reports:exportar_csv".

E
=

.. glossary::
   :sorted:

   ETL
      Extract-Transform-Load. Proceso que extrae datos del IVR (MariaDB),
      los transforma y los carga en Analytics (PostgreSQL).
      Se ejecuta cada 6-12 horas según CNST-003.

F
=

.. glossary::
   :sorted:

   Flat RBAC
      Modelo de control de acceso basado en funciones sin jerarquía
      de roles. Las funciones se asignan directamente a usuarios.
      Definido en CNST-005.

   Función Atómica
      Capacidad indivisible que puede ser asignada a un usuario.
      El sistema IACT tiene 44 funciones atómicas organizadas en 8 módulos.
      Formato: XXX-NNN (ej: USR-001, RPT-004).

   FR (Functional Requirement)
      Requisito funcional derivado de un caso de uso.

I
=

.. glossary::
   :sorted:

   IACT
      IVR Analytics & Customer Tracking. Nombre del sistema de
      dashboard analítico para call center.

   InternalMessage
      Modelo Django para mensajería interna. ÚNICO canal de notificación
      permitido según CNST-001. NO se permite email, SMS ni webhooks.

   IVR
      Interactive Voice Response. Sistema telefónico del call center
      cuya base de datos (MariaDB) es fuente de datos para el ETL.
      Acceso SOLO LECTURA según CNST-003.

K
=

.. glossary::
   :sorted:

   KPI
      Key Performance Indicator. Indicador clave de rendimiento
      mostrado en el dashboard (UC_RPT_10).

M
=

.. glossary::
   :sorted:

   MOD (Módulo)
      Agrupación funcional del sistema. IACT tiene 8 módulos:
      Auth, Users, Access, Pipeline, Reports, Alerts, Audit, Logs.

P
=

.. glossary::
   :sorted:

   Permiso Directo
      Asignación temporal de una capacidad específica a un usuario
      con fecha de vencimiento y justificación obligatoria.
      Máximo 6 meses según CNST-005.

   Permiso Efectivo
      Conjunto real de capacidades que tiene un usuario, calculado
      considerando: funciones asignadas + permisos directos - SoD.

   PII
      Personally Identifiable Information. Información personal
      identificable que NO debe aparecer en logs técnicos (CNST-008).

R
=

.. glossary::
   :sorted:

   RBAC
      Role-Based Access Control. Modelo de control de acceso basado
      en roles/funciones. IACT usa RBAC Flat v5.1.1.

S
=

.. glossary::
   :sorted:

   Segmento
      Partición de datos que limita la visibilidad de un usuario.
      Un usuario pertenece a exactamente un segmento.
      Definido en CNST-005.

   SoD
      Separation of Duties (Separación de Funciones). Restricciones
      que impiden que un usuario tenga combinaciones peligrosas de
      funciones. Ejemplo: quien opera NO audita.

   SEC_RULES
      Componente invisible del módulo Access que realiza el
      enforcement automático de permisos en tiempo real.

T
=

.. glossary::
   :sorted:

   Throttling
      Limitación de tasa de operaciones. Aplicado a exportaciones
      (CNST-007) e intentos de login (CNST-002).

   Timeout
      Tiempo máximo de inactividad de sesión: 15 minutos (CNST-002).

U
=

.. glossary::
   :sorted:

   UC (Use Case)
      Caso de Uso. Especificación de una interacción entre un actor
      y el sistema para lograr un objetivo.
      Formato: UC_MOD_NN (ej: UC_AUTH_01, UC_RPT_06).

   UserActionLog
      Modelo de auditoría inmutable definido en CNST-009.
      Registra todas las acciones críticas del sistema.

Acrónimos
=========

.. list-table::
   :widths: 20 80
   :header-rows: 1

   * - Acrónimo
     - Significado
   * - ACC
     - Access (Módulo de Control de Acceso)
   * - AGR
     - Agrupador (mecanismo de asignación masiva)
   * - ALR
     - Alerts (Módulo de Alertas)
   * - AUD
     - Audit (Módulo de Auditoría)
   * - AUTH
     - Authentication (Módulo de Autenticación)
   * - BR
     - Business Rule (Regla de Negocio)
   * - BReq
     - Business Requirement (Requisito de Negocio)
   * - CNST
     - Constraint (Restricción de Arquitectura)
   * - CSV
     - Comma-Separated Values
   * - ETL
     - Extract-Transform-Load
   * - FR
     - Functional Requirement (Requisito Funcional)
   * - IACT
     - IVR Analytics & Customer Tracking
   * - IVR
     - Interactive Voice Response
   * - JWT
     - JSON Web Token
   * - KPI
     - Key Performance Indicator
   * - LOG
     - Logs (Módulo de Bitácoras)
   * - MOD
     - Módulo
   * - PDF
     - Portable Document Format
   * - PII
     - Personally Identifiable Information
   * - PIP
     - Pipeline (Módulo de ETL)
   * - RBAC
     - Role-Based Access Control
   * - RPT
     - Reports (Módulo de Reportes)
   * - SoD
     - Separation of Duties
   * - UC
     - Use Case (Caso de Uso)
   * - USR
     - Users (Módulo de Usuarios)
   * - XLSX
     - Excel Spreadsheet Format

Historial de Cambios
====================

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Versión
     - Fecha
     - Autor
     - Cambios
   * - 4.0.0
     - 2026-01-06
     - Equipo IACT
     - Versión inicial del glosario v4.0
