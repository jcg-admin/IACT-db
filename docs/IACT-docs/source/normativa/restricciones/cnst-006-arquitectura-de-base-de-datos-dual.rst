.. meta::
 :artefacto: CNST_006
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Critico

.. _cnst-006:

============================================
CNST-006: Arquitectura de Base de Datos Dual
============================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_006
 * - **Categoria**
   - Base de datos
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


El sistema IACT DEBE operar sobre dos bases de datos separadas: BD
IVR (origen del cliente) y BD Analytics (BD del sistema IACT). No se
permite una unica BD compartida ni acceso directo de IACT a la BD del
cliente para escritura.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


Aisla el sistema del cliente de cualquier riesgo de modificacion
desde IACT. Permite definir politicas de acceso, ETL y disponibilidad
independientes.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Limitacion tecnica + contrato cliente
- **Documento:** Contrato cliente — separacion de ambientes
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^


- BD IVR: MySQL o equivalente, propiedad del cliente, accesible solo
  en lectura desde IACT.
- BD Analytics: PostgreSQL, propiedad del sistema IACT, read/write
  para IACT, no accesible al cliente.
- Routers Django enrutan modelos al alias correcto.

2.2 Parametros
^^^^^^^^^^^^^^

Ver subseccion 2.1.

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- MySQL (BD IVR del cliente)
- PostgreSQL (BD Analytics IACT)
- Django DATABASE_ROUTERS

3. Impacto en Sistema
---------------------

3.1 Modulos Afectados
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Modulo
   - Impacto
 * - MOD_Reports
   - Lee de BD IVR via routers
 * - MOD_Analytics
   - Escribe en BD Analytics

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - UC_017
   - Reporte Trimestral — consume BD IVR readonly
 * - UC_022..024
   - Exportaciones — consultan BD Analytics

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Usar una unica BD compartida
- Acceder directamente a BD IVR del cliente para escritura
- Mover datos sensibles del cliente a IACT sin ETL

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

 from django.conf import settings
 assert "ivr" in settings.DATABASES
 assert "default" in settings.DATABASES
 assert settings.DATABASE_ROUTERS

5.2 Validacion de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ver seccion 5.1 (codigo de referencia es la validacion ejecutable).


6. Excepciones
--------------

6.1 Excepciones Permitidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

Sin excepciones permitidas.

6.2 Proceso de Excepcion
^^^^^^^^^^^^^^^^^^^^^^^^

Sin excepciones — restriccion contractual.

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
- **Frecuencia:** Por deployment
- **Herramienta:** Test que valida settings.DATABASES + DATABASE_ROUTERS

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-007-base-de-datos-ivr-es-solo-lectura`, :doc:`cnst-008-sincronizacion-etl-en-ventana-de-6-a-12-horas`
 * - **BR derivadas**
   - Pendiente WP requisitos
 * - **UCs afectados**
   - UC_017, UC_022..024
 * - **MODs afectados**
   - MOD_Reports, MOD_Analytics
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

