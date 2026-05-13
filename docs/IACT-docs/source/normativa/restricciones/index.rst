.. meta::
 :artefacto: INDEX_RESTRICCIONES
 :tipo: Indice
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Interno

Restricciones Tecnicas
======================

Las restricciones (CNST) son condiciones de borde no negociables del
sistema IACT. Definen los limites tecnicos, de seguridad, de
arquitectura y de operacion que toda solucion debe respetar.

A diferencia de los requisitos (que describen QUE debe hacer el
sistema), las restricciones describen QUE NO PUEDE hacer o bajo QUE
condiciones puede operar. Sirven como input arquitectonico para los
casos de uso, los requisitos funcionales y las decisiones de diseno.

Principio de single responsibility
----------------------------------

Cada CNST declara **una sola restriccion**. Si un concern combina
multiples condiciones de borde (prohibicion + mecanismo alternativo,
autenticacion + autorizacion, modelo + reglas + permisos), se
descompone en CNSTs atomicas con referencias cruzadas via
``:doc:``.

Catalogo
--------

.. toctree::
 :maxdepth: 1
 :caption: Comunicaciones

 cnst-001-prohibicion-de-email-y-smtp
 cnst-002-buzon-interno-obligatorio

.. toctree::
 :maxdepth: 1
 :caption: Sesiones

 cnst-003-sesiones-persistidas-en-base-de-datos
 cnst-004-sesion-unica-por-usuario
 cnst-005-timeout-de-sesion-de-15-minutos

.. toctree::
 :maxdepth: 1
 :caption: Base de datos

 cnst-006-arquitectura-de-base-de-datos-dual
 cnst-007-base-de-datos-ivr-es-solo-lectura
 cnst-008-sincronizacion-etl-en-ventana-de-6-a-12-horas

.. toctree::
 :maxdepth: 1
 :caption: Seguridad DRF

 cnst-009-autenticacion-drf-obligatoria
 cnst-010-permission-class-explicita-en-vistas-drf
 cnst-011-throttling-obligatorio-en-endpoints-publicos
 cnst-012-validacion-de-input-via-serializer
 cnst-013-manejo-estandarizado-de-excepciones-drf
 cnst-014-paginacion-obligatoria-en-listados

.. toctree::
 :maxdepth: 1
 :caption: Arquitectura

 cnst-015-antipatrones-de-arquitectura-prohibidos
 cnst-016-principios-solid-obligatorios

.. toctree::
 :maxdepth: 1
 :caption: Performance y exportaciones

 cnst-017-sla-de-tiempos-de-respuesta
 cnst-018-rango-maximo-de-consulta-de-2-anos
 cnst-019-exportaciones-asincronas-sobre-10k-registros
 cnst-020-throttling-de-exportaciones-por-formato

.. toctree::
 :maxdepth: 1
 :caption: Infraestructura

 cnst-021-stack-obligatorio-ubuntu-apache-mod-wsgi
 cnst-022-estructura-de-directorios-en-servidor
 cnst-023-rollback-obligatorio-en-cada-deployment

.. toctree::
 :maxdepth: 1
 :caption: Logging y auditoria

 cnst-024-logs-estructurados-en-formato-json
 cnst-025-auditoria-inmutable-append-only
 cnst-026-pii-prohibida-en-logs-y-auditoria

.. toctree::
 :maxdepth: 1
 :caption: Datos

 cnst-027-clasificacion-obligatoria-de-datos-en-4-niveles
 cnst-028-cifrado-obligatorio-de-datos-confidenciales

.. toctree::
 :maxdepth: 1
 :caption: RBAC

 cnst-029-rbac-modelo-plano
 cnst-030-reglas-de-separacion-de-funciones-sod
 cnst-031-permisos-temporales-maximo-6-meses
 cnst-032-menu-dinamico-obligatorio
 cnst-033-vocabulario-unificado-rbac

Convenciones
------------

- Todas las CNST estan en estado Vigente desde 2026-04-28.
- La numeracion es flat consecutiva (CNST_001 a CNST_033).
- Cada CNST tiene clasificacion ``Critico``, ``Alto`` o ``Medio``
  segun el impacto de su violacion.
- El formato de archivo y metadata sigue
  :doc:`/normativa/estandares/std-007-convencion-naming` y
  :doc:`/normativa/estandares/plantillas/tpl-cnst-restricciones`.
