.. meta::
 :artefacto: CNST_004
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Critico

.. _cnst-004:

==================================
CNST-004: Sesion Unica por Usuario
==================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_004
 * - **Categoria**
   - Sesiones
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


Un usuario solo PUEDE tener una sesion activa simultanea. Al iniciar
una nueva sesion, todas las sesiones previas del mismo usuario deben
invalidarse automaticamente.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


Reduce la superficie de ataque por credenciales comprometidas y
simplifica la auditoria al asociar cada accion con un origen unico.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Politica de seguridad
- **Documento:** Politica de gestion de sesiones IACT
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^


- Al login exitoso: invalidar todas las sesiones activas del usuario
  antes de crear la nueva.
- ``UserSession.is_active = False`` para todas las sesiones previas.
- La fila correspondiente en ``django_session`` se elimina.

2.2 Parametros
^^^^^^^^^^^^^^

Ver subseccion 2.1.

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Signal de login en MOD_Auth
- UserSession.is_active flag

3. Impacto en Sistema
---------------------

3.1 Modulos Afectados
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Modulo
   - Impacto
 * - MOD_Auth
   - Logica de invalidacion en login

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - UC_001
   - Iniciar Sesion — invalida sesiones anteriores
 * - UC_005
   - Gestion de Sesiones — admin puede forzar logout

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Mantener multiples sesiones activas del mismo usuario
- Permitir login concurrente desde distintos dispositivos sin invalidar el anterior

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

 assert UserSession.objects.filter(user=u, is_active=True).count == 1

5.2 Validacion de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ver seccion 5.1 (codigo de referencia es la validacion ejecutable).


6. Excepciones
--------------

6.1 Excepciones Permitidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

- Cuenta de servicio (system) puede tener sesiones paralelas con ADR explicito

6.2 Proceso de Excepcion
^^^^^^^^^^^^^^^^^^^^^^^^

Excepcion para cuentas de servicio requiere ADR + revision de seguridad.

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
- **Herramienta:** Test de integracion: post-login verifica count(UserSession active) == 1

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-003-sesiones-persistidas-en-base-de-datos`, :doc:`cnst-005-timeout-de-sesion-de-15-minutos`
 * - **BR derivadas**
   - Pendiente WP requisitos
 * - **UCs afectados**
   - UC_001, UC_005
 * - **MODs afectados**
   - MOD_Auth
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

