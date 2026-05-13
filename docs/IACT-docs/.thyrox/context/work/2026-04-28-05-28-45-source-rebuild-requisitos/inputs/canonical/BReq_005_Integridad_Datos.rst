.. meta::
   :artefacto: BReq_005
   :tipo: Business Requirement
   :dominio: requisitos
   :subdominio: objetivos
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: 2026-01-06
   :autor: Equipo IACT

.. _breq-005:

===========================================
BReq_005: Integridad de Datos Operacionales
===========================================


Resumen
-------

.. list-table::
   :widths: 25 75
   :header-rows: 0

   * - **ID**
     - BReq-005
   * - **Nombre**
     - Integridad de Datos Operacionales
   * - **Categoria**
     - Integridad de Datos
   * - **Prioridad**
     - Critica
   * - **Estado**
     - Aprobado

----

1. Enunciado Formal
-------------------

El sistema DEBE garantizar que los datos operacionales del IVR permanezcan
inalterados, accediendo a la base de datos IVR exclusivamente en modo
lectura. Ningun componente de IACT puede ejecutar operaciones de escritura
en la base IVR.

----

2. Metrica de Exito
-------------------

::

   Indicadores:
   - Operaciones de escritura en base IVR: 0 (absoluto)
   - Accesos via Database Router validado: 100%
   - Alertas de intento de escritura: 0

   Verificacion: Logs de base de datos IVR
   Frecuencia: Continua (monitoreo automatico)

----

3. Justificacion
----------------

La base IVR es un sistema legacy critico que:

- Alimenta multiples aplicaciones del call center
- Contiene datos operacionales en tiempo real
- Es propiedad y responsabilidad del cliente
- Tiene dependencias con otros sistemas

Cualquier modificacion accidental desde IACT:

- Comprometeria operaciones del call center
- Afectaria otros sistemas dependientes
- Violaria acuerdo contractual con cliente
- Podria causar perdida de datos irreversible

La arquitectura dual (IVR readonly + Analytics read/write) es una
restriccion NO NEGOCIABLE impuesta por el cliente.

----

4. BR que Influyen
------------------

.. list-table::
   :widths: 15 35 50
   :header-rows: 1

   * - BR
     - Nombre
     - Como Influye
   * - BR_001
     - Fuente Operacional Inmutable
     - Define restriccion absoluta de solo lectura en IVR

----

5. UC que Genera
----------------

.. list-table::
   :widths: 15 35 50
   :header-rows: 1

   * - UC
     - Nombre
     - Relacion
   * - UC-050
     - Supervisar Estado ETL
     - Monitorea extraccion que solo LEE de IVR
   * - UC-051
     - Consultar Errores ETL
     - Diagnostico sin modificar origen
   * - UC-052
     - Consultar Disponibilidad Datos
     - Verifica sincronizacion sin alterar fuente
   * - UC-053
     - Reiniciar Proceso ETL
     - Re-extraccion (solo lectura de IVR)

----

6. Criterios de Aceptacion
--------------------------

1. Database Router implementado con IVRReadOnlyRouter
2. Usuario de BD IACT sin permisos INSERT/UPDATE/DELETE en IVR
3. Modelos Django de IVR con managed=False
4. Tests automatizados que verifican bloqueo de escritura
5. Monitoreo de logs de BD sin operaciones de escritura desde IACT
6. Middleware que intercepta y bloquea cualquier intento de escritura

----

7. Implementacion Tecnica
-------------------------

::

   Arquitectura:

   +------------------+          +------------------+
   |   BASE IVR       |          |  BASE ANALYTICS  |
   |   (MariaDB)      |          |  (PostgreSQL)    |
   |                  |          |                  |
   |  SOLO LECTURA    |          |  LECTURA Y       |
   |  - SELECT        |          |  ESCRITURA       |
   +--------+---------+          +--------+---------+
            |                             |
            |    IVRReadOnlyRouter        |
            +-------------+---------------+
                          |
                  +-------+-------+
                  | Django ORM    |
                  | Database      |
                  | Router        |
                  +---------------+

----

8. Stakeholders
---------------

- **Sponsor**: Cliente (propietario de IVR)
- **Responsable**: Arquitecto de Solucion
- **Afectados**: Todo el equipo de desarrollo

----

9. CNST Relacionada
-------------------

- **CNST_003**: Base de Datos Dual con Inmutabilidad IVR

  Define en detalle la arquitectura dual y las restricciones tecnicas.

----

10. Historial de Cambios
------------------------

.. list-table::
   :widths: 15 15 20 50
   :header-rows: 1

   * - Version
     - Fecha
     - Autor
     - Descripcion del Cambio
   * - 1.0.0
     - 2026-01-06
     - Equipo IACT
     - Version inicial
