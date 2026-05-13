.. meta::
   :artefacto: DATABASES_OVERVIEW
   :tipo: Visión general del tier
   :dominio: tech
   :estado: Esqueleto
   :version: 1.0.0
   :fecha_creacion: 2026-04-28
   :autor: Equipo IACT

============================================
Bases de Datos — Visión general
============================================

Alcance
=======

El tier de persistencia del producto IACT usa **dos motores de
base de datos relacionales** con roles distintos, conectados al
backend Django REST Framework (:doc:`/backend/overview`):

- **MySQL** — fuente operativa, modo solo-lectura desde IACT.
- **PostgreSQL** — destino analítico, optimizado para consultas
  agregadas y reportes.

Topología
=========

::

    [Sistema operativo externo (origen)]
              │
              ▼
        [MySQL] ────────────── (read-only desde IACT)
              │
              │   ETL pipeline
              ▼
        [PostgreSQL] ────────── (escritura desde ETL,
                                  lectura desde DRF)
              │
              ▼
        [DRF App] ← :doc:`/backend/overview`

Razón de la arquitectura dual
=============================

El producto IACT consume datos generados por sistemas operativos
existentes (call center, telefonía, contact center) cuyas BDs
viven en MySQL. **No es responsabilidad de IACT modificar esos
datos** — restricción documentada como CNST aplicable (ver
:doc:`/normativa/restricciones/index`).

Para servir consultas analíticas eficientes, IACT extrae datos
de MySQL via un proceso ETL y los carga normalizados en
PostgreSQL, donde se aplican optimizaciones (índices, materialized
views, particionado) sin afectar el sistema origen.

**Beneficios:**

- Aislamiento operativo: IACT nunca degrada performance del sistema
  origen.
- Optimización analítica independiente.
- Auditabilidad: el flujo ETL es trazable.

**Costos:**

- Latencia inherente entre dato origen y disponibilidad analítica.
- Complejidad operacional (dos motores a mantener, monitorear,
  respaldar).

Roles concretos
===============

MySQL
-----

- **Modo de acceso:** read-only desde IACT (el sistema NO escribe
  ni altera datos).
- **Versión soportada:** 8.0+.
- **Schemas relevantes:** definidos por el sistema origen (no por
  IACT).
- **Conexión:** vía Django settings, con usuario de DB con permisos
  ``SELECT`` exclusivamente.

PostgreSQL
----------

- **Modo de acceso:** lectura/escritura.
- **Versión soportada:** 14+.
- **Schemas:** definidos por modelos Django de IACT.
- **Migrations:** gestionadas por Django (``manage.py migrate``).
- **Optimización:** índices por queries de reporte, materialized
  views si aplica, vacuum/analyze regular.

ETL pipeline
============

El pipeline ETL que mueve datos de MySQL a PostgreSQL vive como
parte del backend (no es un componente independiente). Detalles en
:doc:`/operations/overview`. Decisiones arquitectónicas asociadas:
ver ADRs en :doc:`/normativa/gobernanza/index` con prefijo
``ADR-DB-`` o ``ADR-DEVOPS-``.

Restricciones aplicables
========================

Ver :doc:`/normativa/restricciones/index` para CNSTs específicas
(BD inmutable, gestión de sesiones, límites de queries, auditoría
inmutable).

Operaciones
===========

Backups, restore, replicación, failover: :doc:`/operations/overview`.

Convenciones
============

Naming, schema design, migrations workflow: :doc:`conventions`.
