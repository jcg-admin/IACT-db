.. meta::
 :artefacto: CNST_026
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Critico

.. _cnst-026:

===========================================
CNST-026: PII Prohibida en Logs y Auditoria
===========================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_026
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


Esta PROHIBIDO incluir PII (Personally Identifiable Information) en
mensajes de log y registros de auditoria. La PII a referenciar se
guarda como ID; el detalle se consulta de la BD por separado segun
el RBAC vigente.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


Los logs son persistidos, replicados a sistemas de observabilidad y eventualmente exportados para soporte. Cualquier PII en los logs amplia la superficie de exposicion fuera del ambito controlado por el RBAC, viola regulaciones tipicas de proteccion de datos y crea pasivos legales.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Compliance (proteccion de datos personales)
- **Documento:** Politica de privacidad IACT
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^


- Telefono, email, direccion fisica completa.
- Numero de identificacion oficial (DNI, CURP, RFC, SSN, etc.).
- Datos financieros (numero de tarjeta, IBAN).
- Datos biometricos.
- Contenido completo de mensajes de usuarios.

2.2 Parametros
^^^^^^^^^^^^^^

Ver subseccion 2.1.

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Filtro de logging que sanitiza
- Regex de PII patterns
- Redaccion automatica

3. Impacto en Sistema
---------------------

3.1 Modulos Afectados
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Modulo
   - Impacto
 * - MOD_Common
   - Define filtro de PII
 * - (todos)
   - Usan structured logging con filtro

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - (transversal)
   - Todos los UCs que tocan PII

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Emitir logs con telefono, email, DNI/CURP/RFC, datos financieros, biometricos
- Loguear contenido completo de mensajes
- Persistir PII en sistemas de observabilidad

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

 import re
 PII_PATTERNS = [r"\b\d{10}\b", r"[\w.+-]+@[\w-]+\.[\w.-]+"]

5.2 Validacion de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ver seccion 5.1 (codigo de referencia es la validacion ejecutable).


6. Excepciones
--------------

6.1 Excepciones Permitidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

- Eventos de auditoria registran user_id (no PII directa); detalle se consulta por separado segun RBAC

6.2 Proceso de Excepcion
^^^^^^^^^^^^^^^^^^^^^^^^

Sin excepciones — la PII no aparece en logs.

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
- **Herramienta:** Tests que verifican sanitizacion + auditoria periodica de logs

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-024-logs-estructurados-en-formato-json`, :doc:`cnst-025-auditoria-inmutable-append-only`
 * - **BR derivadas**
   - Pendiente WP requisitos
 * - **UCs afectados**
   - (transversal)
 * - **MODs afectados**
   - MOD_Common, (todos)
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

