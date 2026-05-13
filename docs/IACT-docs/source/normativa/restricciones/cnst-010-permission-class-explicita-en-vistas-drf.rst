.. meta::
 :artefacto: CNST_010
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Critico

.. _cnst-010:

==================================================
CNST-010: Permission Class Explicita en Vistas DRF
==================================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_010
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


Toda vista DRF DEBE declarar ``permission_classes`` explicitamente.
Esta prohibido depender de ``DEFAULT_PERMISSION_CLASSES`` global para
endpoints que tocan datos sensibles.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


Una permission class explicita hace auditable la autorizacion de
cada endpoint. Una permission heredada del default es opaca al
revisor.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Politica de seguridad + mejor practica de auditoria
- **Documento:** Convencion de codigo IACT
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^


- ``DEFAULT_PERMISSION_CLASSES = [IsAuthenticated]`` como fallback.
- Toda vista que opera sobre PII o catalogo RBAC declara una
  permission class especifica (``HasFunctionPermission``,
  ``IsAdminUser``).
- Esta prohibido ``permission_classes = [AllowAny]`` excepto en login.

2.2 Parametros
^^^^^^^^^^^^^^

Ver subseccion 2.1.

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Django REST Framework
- permission_classes (HasFunctionPermission custom)
- django-guardian (object-level)

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
   - Define permission classes custom
 * - Todos los DRF views
   - Declaran permission_classes

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - Todos los UCs sobre PII o catalogo RBAC
   - Requieren permission class explicita

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Depender solo del DEFAULT_PERMISSION_CLASSES
- Usar AllowAny excepto login
- Mezclar permisos en logica de la vista

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
 assert hasattr(view, "permission_classes")

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

Sin excepciones — toda vista declara permission_classes.

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
- **Herramienta:** Linter custom que verifica hasattr(view, 'permission_classes')

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-009-autenticacion-drf-obligatoria`, :doc:`cnst-029-rbac-modelo-plano`
 * - **BR derivadas**
   - Pendiente WP requisitos
 * - **UCs afectados**
   - Todos los UCs sobre PII o catalogo RBAC
 * - **MODs afectados**
   - MOD_Access, Todos los DRF views
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

