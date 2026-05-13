.. meta::
 :artefacto: PROC_Excepciones_CNST
 :tipo: Procedimiento
 :dominio: normativa
 :subdominio: procedimientos
 :estado: Vigente
 :version: 1.0.0
 :fecha_creacion: 2026-04-29
 :ultimo_cambio: 2026-04-29
 :autor: NestorMonroy
 :clasificacion: Critico

.. _proc-req-015-excepciones-cnst:

=============================================================
PROC_Excepciones_CNST: Proceso de Excepción a una Restricción
=============================================================

1. Propósito
------------

Establecer el flujo formal para solicitar, evaluar, aprobar o rechazar
excepciones temporales a una restricción arquitectónica (CNST) del
sistema IACT cuando un escenario de negocio o técnico lo justifique.

Sin este procedimiento, las excepciones quedan informales y sin
trazabilidad, contradiciendo la naturaleza no negociable de los CNST.

2. Alcance
----------

Aplica a cualquier solicitud de excepción a un CNST del catálogo
canónico (CNST_001..CNST_033 al cierre v3 de WP #4). NO aplica a:

- Cambios permanentes al CNST (eso es modificación de la restricción,
  requiere ADR + bump de versión MAYOR del CNST).
- Variaciones de implementación que NO violan el enunciado del CNST.

3. Roles
--------

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Rol
   - Responsabilidad
 * - **Solicitante**
   - Documenta la justificación de negocio o técnica, propone
     vigencia y mitigaciones.
 * - **Tech Lead**
   - Evalúa impacto técnico. Aprueba/rechaza excepciones de
     criticidad Alta y Media.
 * - **Compliance Officer**
   - Co-aprueba excepciones de criticidad Crítica. Verifica que
     no haya impacto regulatorio.
 * - **Manager / Product Owner**
   - Aprueba excepciones de criticidad Baja.
 * - **Auditor**
   - Verifica trimestralmente las excepciones vigentes.

4. Flujo del Proceso
--------------------

4.1 Solicitud formal
^^^^^^^^^^^^^^^^^^^^

El solicitante crea un ticket / PR con la siguiente plantilla:

.. code-block:: yaml

 excepcion_id: EXC-YYYY-NNN
 cnst_afectado: CNST_NNN
 solicitante: <nombre + rol>
 fecha_solicitud: YYYY-MM-DD
 justificacion: |
 <Descripción del escenario de negocio o técnico que requiere
 la excepción. Mínimo 200 caracteres.>
 alternativas_evaluadas: |
 <Lista de alternativas que NO requieren excepción y por qué
 fueron descartadas.>
 vigencia_solicitada: <max 90 días desde aprobación>
 mitigaciones: |
 <Controles compensatorios durante la vigencia: monitoreo extra,
 auditoría reforzada, rollback automático, etc.>
 plan_remediation: |
 <Cómo se eliminará la excepción al vencer la vigencia.>

4.2 Análisis de riesgo
^^^^^^^^^^^^^^^^^^^^^^

El Tech Lead evalúa:

- Severidad del CNST afectado (Crítico / Alto / Medio / Bajo).
- Impacto operacional de la excepción.
- Riesgos de seguridad, legales o financieros.
- Adecuación de las mitigaciones propuestas.

Genera un dictamen escrito que se anexa a la solicitud.

4.3 Aprobador según criticidad
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 25 30 45
 :header-rows: 1

 * - Criticidad CNST
   - Aprobador requerido
   - Vigencia máxima
 * - Crítico
   - Tech Lead + Compliance Officer (ambos)
   - 30 días
 * - Alto
   - Tech Lead
   - 60 días
 * - Medio
   - Tech Lead o Manager
   - 90 días
 * - Bajo
   - Manager / Product Owner
   - 90 días

4.4 Vigencia y monitoreo
^^^^^^^^^^^^^^^^^^^^^^^^

Durante la vigencia de la excepción aprobada:

- El sistema registra cada uso del comportamiento excepcionado en
  ``AuditLog`` con flag ``is_exception=true`` y ``exception_id``.
- El monitoreo opera en modo reforzado (alertas adicionales según
  mitigaciones propuestas).
- El Auditor revisa el log semanalmente.

4.5 Renovación
^^^^^^^^^^^^^^

NO existe renovación automática. Para extender una excepción, el
solicitante debe iniciar un nuevo flujo ``PROC_Excepciones_CNST``
con justificación actualizada (no copia de la anterior). El nuevo
flujo puede aprobar nueva vigencia respetando los máximos de §4.3.

4.6 Cierre
^^^^^^^^^^

Al vencer la vigencia:

- El sistema bloquea automáticamente el comportamiento excepcionado.
- Se genera reporte de cierre con: usos durante la vigencia,
  incidentes (si los hubo), efectividad de mitigaciones.
- El reporte se archiva en el AuditLog inmutable.

5. Excepciones que NO requieren este proceso
--------------------------------------------

- Cambios al CNST mismo: usar ADR + bump versión del CNST.
- Variaciones de implementación que NO violan el enunciado: no son
  excepciones, son flexibilidad de implementación.
- Hallazgos de auditoría que requieren acción inmediata: usar el
  proceso de incident response, no este.

6. Trazabilidad
---------------

Cada excepción genera tres artefactos:

1. **Ticket / PR** con la plantilla §4.1 completa.
2. **AuditLog entries** con ``is_exception=true`` durante la vigencia.
3. **Reporte de cierre** archivado al vencer.

Los tres son inmutables (CNST_025 Auditoría Inmutable).

7. Referencias
--------------

- :doc:`/normativa/restricciones/index` — catálogo de CNST canónicos
- :doc:`/normativa/restricciones/cnst-025-auditoria-inmutable-append-only`
- :doc:`/normativa/restricciones/cnst-032-menu-dinamico-obligatorio`
- :doc:`/normativa/restricciones/cnst-033-vocabulario-unificado-rbac`
- :doc:`/normativa/gobernanza/adr-gob-008-rbac-coexistencia-acc-perm`

8. Historial de Cambios
-----------------------

.. list-table::
 :widths: 12 15 25 48
 :header-rows: 1

 * - Versión
   - Fecha
   - Autor
   - Cambios
 * - 1.0.0
   - 2026-04-29
   - NestorMonroy
   - Versión inicial. Procedimiento creado en iteracion correspondiente tras
     hallazgo P-1 del audit cross-WP del 2026-04-29.
