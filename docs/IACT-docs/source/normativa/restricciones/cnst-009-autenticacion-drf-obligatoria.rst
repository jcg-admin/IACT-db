.. meta::
 :artefacto: CNST_009
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Critico

.. _cnst-009:

=======================================
CNST-009: Autenticacion DRF Obligatoria
=======================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_009
 * - **Categoria**
   - Seguridad DRF
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


Toda vista DRF (``APIView``, ``ViewSet``, ``GenericAPIView``) DEBE
requerir autenticacion del cliente. La unica excepcion permitida es
el endpoint de login.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


El sistema IACT maneja datos PII y operaciones sensibles. Endpoints
sin autenticacion son superficie de ataque inaceptable.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Politica de seguridad
- **Documento:** RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.rst:213-216
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^


- ``DEFAULT_AUTHENTICATION_CLASSES`` incluye ``SessionAuthentication``
  y ``TokenAuthentication``.
- Vistas con ``authentication_classes = []`` requieren ADR explicito
  con justificacion documentada.

2.2 Parametros
^^^^^^^^^^^^^^

Ver subseccion 2.1.

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Django REST Framework
- rest_framework.authentication.SessionAuthentication
- rest_framework_simplejwt (TokenAuthentication)

3. Impacto en Sistema
---------------------

3.1 Modulos Afectados
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Modulo
   - Impacto
 * - Todos los modulos DRF
   - Heredan autenticacion obligatoria

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - UC_001
   - Iniciar Sesion (excepcion permitida)
 * - Todos los demas UCs DRF
   - Requieren autenticacion

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Exponer endpoints DRF sin authentication_classes
- Usar AllowAny excepto en login
- Permitir acceso anonimo a recursos protegidos

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

 for view in get_all_drf_views:
 if view.__name__ != "LoginView":
 assert view.authentication_classes

5.2 Validacion de Cumplimiento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ver seccion 5.1 (codigo de referencia es la validacion ejecutable).


6. Excepciones
--------------

6.1 Excepciones Permitidas
^^^^^^^^^^^^^^^^^^^^^^^^^^

- Endpoint /api/auth/login/ (justificado por su naturaleza)

6.2 Proceso de Excepcion
^^^^^^^^^^^^^^^^^^^^^^^^

Cualquier endpoint adicional sin auth requiere ADR + revision de seguridad.

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
- **Frecuencia:** Continuo (tests CI)
- **Herramienta:** Linter custom que itera DRF views y valida authentication_classes

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-010-permission-class-explicita-en-vistas-drf`
 * - **BR derivadas**
   - Pendiente WP requisitos
 * - **UCs afectados**
   - UC_001, Todos los demas UCs DRF
 * - **MODs afectados**
   - Todos los modulos DRF
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

