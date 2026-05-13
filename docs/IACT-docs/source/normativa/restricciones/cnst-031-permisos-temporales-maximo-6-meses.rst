.. meta::
 :artefacto: CNST_031
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Critico

.. _cnst-031:

============================================
CNST-031: Permisos Temporales Maximo 6 Meses
============================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_031
 * - **Categoria**
   - RBAC
 * - **Tipo (TXM_01)**
   - Tecnica
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


Los permisos temporales DEBEN tener vigencia maxima de 6 meses,
justificacion obligatoria de minimo 20 caracteres y revocacion
automatica al vencer. No existe auto-renovacion: cada renovacion
requiere nueva justificacion y nueva aprobacion.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


Limita la acumulacion de permisos olvidados. La justificacion textual
acotada permite trazabilidad para auditoria. La revocacion automatica
elimina la responsabilidad del olvido humano.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Compliance + control de privilegios
- **Documento:** MODELO_RBAC_IACT:610-623
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^

(detalle en parametros)

2.2 Parametros
^^^^^^^^^^^^^^


- Vigencia maxima: 6 meses (180 dias) desde la asignacion.
- Justificacion: minimo 20 caracteres, texto libre.
- Revocacion: proceso programado diario que desasigna permisos
  vencidos.
- Auditoria: cada uso del permiso temporal genera registro en
  ``AuditLog`` (CNST_025).
- SoD: la validacion de :doc:`cnst-030-reglas-de-separacion-de-funciones-sod`
  aplica tambien a permisos temporales.

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Modelo TemporaryPermission
- Comando de revocacion programado (cron diario)
- Validacion de justificacion (regex >= 20 ch)

3. Impacto en Sistema
---------------------

3.1 Modulos Afectados
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Modulo
   - Impacto
 * - MOD_Access
   - Implementa TemporaryPermission + revocacion programada
 * - MOD_Audit
   - Registra cada uso del permiso temporal

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - UC_004
   - Asignar permisos temporales
 * - UC_005
   - Renovacion + auditoria

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Asignar permisos temporales con vigencia > 6 meses
- Auto-renovar permisos temporales
- Asignar sin justificacion (>= 20 caracteres)
- Asignar permisos temporales que violen SoD (CNST_030)

4. Business Rules Derivadas
---------------------------

Sin BRs especificas mapeadas a esta CNST en la base cognitiva actual.
El catalogo BR_NNN del dominio IACT esta pendiente de elaborar en
el WP de requisitos (deuda diferida).

5. Implementacion
-----------------

5.1 Codigo de Referencia
^^^^^^^^^^^^^^^^^^^^^^^^


.. code-block:: python

 assert (perm.expires_at - perm.granted_at).days <= 180
 assert len(perm.justification) >= 20

5.2 Validacion de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ver seccion 5.1 (codigo de referencia es la validacion ejecutable).


6. Excepciones
--------------

6.1 Excepciones Permitidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

- Renovacion = nueva justificacion + nueva aprobacion (no es excepcion, es procedimiento)

6.2 Proceso de Excepcion
^^^^^^^^^^^^^^^^^^^^^^^^

Renovacion requiere nueva solicitud formal con justificacion actualizada y aprobacion del Tech Lead + Responsable de Seguridad.

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
- **Frecuencia:** Continuo + revocacion diaria
- **Herramienta:** Test que verifica vigencia <= 180 dias y len(justification) >= 20 + cron diario

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-029-rbac-modelo-plano`, :doc:`cnst-030-reglas-de-separacion-de-funciones-sod`, :doc:`cnst-025-auditoria-inmutable-append-only`
 * - **BR derivadas**
   - Pendiente WP requisitos
 * - **UCs afectados**
   - UC_004, UC_005
 * - **MODs afectados**
   - MOD_Access, MOD_Audit
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

