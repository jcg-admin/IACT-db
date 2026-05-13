.. meta::
 :artefacto: CNST_005
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Critico

.. _cnst-005:

=========================================
CNST-005: Timeout de Sesion de 15 Minutos
=========================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_005
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


La sesion de usuario DEBE expirar tras 15 minutos de inactividad. La
sesion expirada no puede reutilizarse: requiere re-autenticacion
completa.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


Limita la ventana de exposicion de sesiones abandonadas en estaciones
compartidas. Alineado con politicas tipicas de sistemas con datos PII.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Politica de seguridad
- **Documento:** RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.rst:76
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^

(detalle en parametros)

2.2 Parametros
^^^^^^^^^^^^^^


- ``SESSION_COOKIE_AGE = 900`` (15 minutos en segundos).
- ``SESSION_SAVE_EVERY_REQUEST = True`` (renueva timeout en cada
  request autenticado).
- ``SESSION_EXPIRE_AT_BROWSER_CLOSE = False`` (la BD es la fuente de
  verdad, no el navegador).

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Django settings: SESSION_COOKIE_AGE, SESSION_SAVE_EVERY_REQUEST

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
   - Configuracion de timeouts en settings

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - UC_001
   - Iniciar Sesion
 * - UC_005
   - Gestion de Sesiones

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Configurar timeout > 15 minutos
- Hacer la sesion persistente al cierre del navegador

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
 assert settings.SESSION_COOKIE_AGE == 900
 assert settings.SESSION_SAVE_EVERY_REQUEST is True

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

Sin excepciones — politica fija.

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
- **Herramienta:** Test de configuracion en CI

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-003-sesiones-persistidas-en-base-de-datos`, :doc:`cnst-004-sesion-unica-por-usuario`
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

