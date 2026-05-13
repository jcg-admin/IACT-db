.. meta::
 :artefacto: CNST_025
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Critico

.. _cnst-025:

=========================================
CNST-025: Auditoria Inmutable Append-Only
=========================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_025
 * - **Categoria**
   - Logging
 * - **Tipo (TXM_01)**
   - Regulatoria
 * - **Criticidad**
   - Critico
 * - **Negociable**
   - No
 * - **Estado**
   - Vigente

1. Definicion
-------------

1.1 Enunciado
^^^^^^^^^^^^^


Los registros de auditoria del sistema IACT DEBEN ser inmutables.
Esta prohibido ``UPDATE`` y ``DELETE`` sobre la tabla de auditoria,
incluso desde superusuario de aplicacion.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


La trazabilidad legal y forense requiere garantia de no manipulacion.
Un audit log mutable es indistinguible de no tener audit log a ojos
de un auditor externo.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Compliance + politica de auditoria
- **Documento:** Politica de auditoria IACT
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^


- Modelo ``AuditLog`` rechaza ``save`` para registros existentes
  (override que rechaza ``pk is not None``).
- A nivel BD: trigger que rechaza ``UPDATE`` y ``DELETE``.
- Usuario de BD de aplicacion sin permisos ``UPDATE``/``DELETE`` sobre
  la tabla.
- Retencion minima: 7 anos.

2.2 Parametros
^^^^^^^^^^^^^^

Ver subseccion 2.1.

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- PostgreSQL trigger
- Modelo AuditLog (override save)
- GRANT SELECT/INSERT only en BD

3. Impacto en Sistema
---------------------

3.1 Modulos Afectados
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Modulo
   - Impacto
 * - MOD_Audit
   - Implementa AuditLog + trigger
 * - (todos)
   - Generan eventos auditables

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - Todos los UCs sensibles
   - Generan AuditLog inmutable
 * - UC_005
   - Gestion de Sesiones — audit log

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- UPDATE o DELETE sobre tabla AuditLog
- Borrar registros antiguos sin proceso formal de retencion
- Modificar audit log desde superusuario de aplicacion

4. Business Rules Derivadas
---------------------------

Sin BRs especificas mapeadas a esta CNST en la base cognitiva actual.
El catalogo BR_NNN del dominio IACT esta pendiente de elaborar en
el WP de requisitos (deuda diferida).

5. Implementacion
-----------------

5.1 Codigo de Referencia
^^^^^^^^^^^^^^^^^^^^^^^^


.. code-block:: text

 CREATE OR REPLACE FUNCTION audit_immutable RETURNS TRIGGER AS $$
 BEGIN RAISE EXCEPTION 'audit log is append-only'; END;
 $$ LANGUAGE plpgsql;

5.2 Validacion de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ver seccion 5.1 (codigo de referencia es la validacion ejecutable).


6. Excepciones
--------------

6.1 Excepciones Permitidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

- Politica de retencion (>= 7 anos) puede archivar a cold storage con cadena de custodia

6.2 Proceso de Excepcion
^^^^^^^^^^^^^^^^^^^^^^^^

Archivado a cold storage requiere ADR + procedimiento de cadena de custodia.

El protocolo formal de waiver de CNSTs esta pendiente de elaborar en
el WP de gobernanza (`PROC_Excepciones_CNST` — ver
(referencia interna) § W-4).

7. Verificacion
---------------

7.1 Criterios de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El cumplimiento se verifica via los snippets de la seccion 5.

7.2 Metodo de Verificacion
^^^^^^^^^^^^^^^^^^^^^^^^^^

- **Tipo:** Automatico
- **Frecuencia:** Continuo
- **Herramienta:** Test que verifica que UPDATE/DELETE generan exception + verificacion del trigger en BD

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-024-logs-estructurados-en-formato-json`, :doc:`cnst-026-pii-prohibida-en-logs-y-auditoria`
 * - **BR derivadas**
   - Pendiente WP requisitos
 * - **UCs afectados**
   - Todos los UCs sensibles, UC_005
 * - **MODs afectados**
   - MOD_Audit, (todos)
 * - **ADRs relacionados**
   - Pendiente WP arquitectura tecnica

9. Historial de Cambios
-----------------------

.. list-table::
 :widths: 12 15 25 48
 :header-rows: 1

 * - Version
   - Fecha
   - Autor
   - Cambios
 * - 1.0.0
   - 2025-12-17
   - NestorMonroy
   - Version inicial (consolidada del backup canonico)
 * - 2.0.0
   - 2026-04-28
   - NestorMonroy
   - Descomposicion SRP (un concern por archivo) + enriquecimiento estructura completa TPL_CNST (9 secciones)

