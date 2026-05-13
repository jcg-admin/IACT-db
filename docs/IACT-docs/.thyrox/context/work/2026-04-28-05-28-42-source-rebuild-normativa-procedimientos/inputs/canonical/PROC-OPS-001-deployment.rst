.. _proc-ops-001:

PROC-OPS-001: Despliegue de Documentación a Producción
======================================================

:ID: PROC-OPS-001
:Versión: 1.0.0
:Fecha: 2026-04-27
:Estado: VIGENTE
:Clasificación: OPERATIVO
:Origen: WP deployment-pipeline
:Audiencia: Rotación de operación / responsables del servidor on-premise

----

Propósito
---------

Este procedimiento describe el flujo para descargar un release versionado
de la documentación IACT desde GitHub Releases, verificar su integridad,
desempaquetarlo y desplegarlo al servidor on-premise.

Está dirigido al miembro de la **rotación de operación** que recibe la
notificación del nuevo release y debe propagar el cambio al servidor que
sirve los HTML públicos.

Contexto
--------

Origen del Procedimiento
~~~~~~~~~~~~~~~~~~~~~~~~

El sistema IACT no realiza despliegue automático al servidor on-premise
(decisión documentada en el WP ``deployment-pipeline`` y CNST-008). El
pipeline de GitHub Actions termina en la creación del paquete versionado
``iact-docs-v{X.Y.Z}.tar.gz`` adjunto a un GitHub Release. La rotación
de operación es responsable de descargar y desplegar.

Aplicable a
~~~~~~~~~~~

- Cada nuevo release publicado en ``https://github.com/jcg-admin/IACT-docs/releases``
- Rollback a versiones previas (descargar release anterior)

Pre-requisitos
~~~~~~~~~~~~~~

- Acceso de lectura al repositorio en GitHub.
- Acceso SSH o equivalente al servidor on-premise que sirve los docs.
- Permisos de escritura en el directorio de despliegue (``/var/www/iact-docs/``
  u otro según infraestructura).
- ``sha256sum`` o equivalente disponible localmente.

----

Procedimiento
-------------

PASO 1: Identificar el release a desplegar
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Acceder a ``https://github.com/jcg-admin/IACT-docs/releases``.
2. Localizar el release a desplegar (típicamente el más reciente).
3. Anotar el tag: ``v{X.Y.Z}`` (ej. ``v1.1.0``).

PASO 2: Descargar los assets
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cada release publica dos archivos:

- ``iact-docs-v{X.Y.Z}.tar.gz`` — paquete con el HTML, LICENSE, readme y CHANGELOG.
- ``iact-docs-v{X.Y.Z}.tar.gz.sha256`` — checksum SHA-256 para verificar integridad.

Descargar ambos:

.. code-block:: bash

   TAG=v1.1.0
   wget https://github.com/jcg-admin/IACT-docs/releases/download/${TAG}/iact-docs-${TAG}.tar.gz
   wget https://github.com/jcg-admin/IACT-docs/releases/download/${TAG}/iact-docs-${TAG}.tar.gz.sha256

PASO 3: Verificar integridad
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Validar que el tarball no fue alterado durante el transporte:

.. code-block:: bash

   sha256sum -c iact-docs-${TAG}.tar.gz.sha256

Salida esperada:

.. code-block:: text

   iact-docs-v1.1.0.tar.gz: OK

Si la verificación falla, **NO continuar**. Re-descargar y repetir. Si
falla repetidamente, contactar al equipo de infraestructura del repo.

PASO 4: Hacer backup del despliegue actual
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Antes de sobrescribir, preservar el estado actual del servidor por si
hay que hacer rollback:

.. code-block:: bash

   sudo cp -a /var/www/iact-docs /var/www/iact-docs.backup-$(date +%Y%m%d-%H%M%S)

Conservar al menos los **últimos 3 backups**. Eliminar los más antiguos
manualmente para no agotar espacio.

PASO 5: Desempaquetar y verificar contenido
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Desempaquetar en una ubicación temporal antes de mover a producción:

.. code-block:: bash

   tar -xzf iact-docs-${TAG}.tar.gz -C /tmp/

Verificar la estructura esperada:

.. code-block:: bash

   ls /tmp/iact-docs-${TAG}/

Debe contener:

- ``html/`` (con ``index.html`` y assets)
- ``LICENSE.rst``
- ``readme.rst``
- ``CHANGELOG.md``

Verificar que ``html/index.html`` existe y abre correctamente:

.. code-block:: bash

   test -f /tmp/iact-docs-${TAG}/html/index.html && echo OK

PASO 6: Desplegar al servidor
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Reemplazar el contenido del directorio servido por Apache/nginx:

.. code-block:: bash

   sudo rm -rf /var/www/iact-docs/*
   sudo cp -r /tmp/iact-docs-${TAG}/html/* /var/www/iact-docs/
   sudo chown -R www-data:www-data /var/www/iact-docs/
   sudo chmod -R 644 /var/www/iact-docs/
   sudo find /var/www/iact-docs/ -type d -exec chmod 755 {} \;

PASO 7: Validar el despliegue
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Probar que el sitio responde y muestra la nueva versión:

.. code-block:: bash

   curl -fI https://docs.iact.local/ | head -1
   # esperado: HTTP/1.1 200 OK
   curl -s https://docs.iact.local/ | grep -i "version\|build"

Abrir el sitio en navegador y verificar que la página principal carga.

PASO 8: Limpiar archivos temporales
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   rm -rf /tmp/iact-docs-${TAG}
   rm iact-docs-${TAG}.tar.gz iact-docs-${TAG}.tar.gz.sha256

PASO 9: Registrar el despliegue
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Registrar en el log de operaciones:

- Fecha y hora del despliegue.
- Tag desplegado.
- Operador que ejecutó el despliegue.
- Tag previo (para trazabilidad de rollback).
- Resultado de la verificación PASO 7.

----

Procedimiento de Rollback
-------------------------

Si tras el despliegue se detecta un problema crítico:

Opción A — Restaurar desde backup local (rápido)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   sudo rm -rf /var/www/iact-docs
   sudo mv /var/www/iact-docs.backup-{timestamp_previo} /var/www/iact-docs
   curl -fI https://docs.iact.local/

Tiempo estimado: < 1 minuto.

Opción B — Re-desplegar versión anterior desde GitHub Releases
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Repetir PASOS 1 al 7 de este procedimiento usando el tag de la versión
anterior (ej. ``v1.0.0`` si la rota fue ``v1.1.0``). Útil cuando los
backups locales han sido eliminados.

----

Cumplimiento
------------

Verificación
~~~~~~~~~~~~

- Frecuencia: por release (cada despliegue).
- Tipo: manual.
- Responsable: rotación de operación.

Trazabilidad
~~~~~~~~~~~~

- ADR relacionado: WP ``deployment-pipeline`` (Phase 5 STRATEGY)
- CNST origen: CNST-008 (Infraestructura on-premise, deployment vía paquete)
- Workflow CI: ``.github/workflows/release.yml``

----

Historial de Cambios
--------------------

.. list-table::
   :header-rows: 1
   :widths: 12 14 74

   * - Versión
     - Fecha
     - Cambios
   * - 1.0.0
     - 2026-04-27
     - Versión inicial. Procedimiento de descarga, verificación SHA-256,
       backup, despliegue y rollback para releases publicados por el
       pipeline ``release.yml``.
