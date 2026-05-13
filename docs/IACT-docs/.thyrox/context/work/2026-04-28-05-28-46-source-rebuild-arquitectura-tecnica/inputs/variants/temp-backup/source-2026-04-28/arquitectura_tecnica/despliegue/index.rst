.. _despliegue:

==========
Despliegue
==========

Propósito
=========

Este subdominio contiene la **configuración de infraestructura y despliegue** 
del proyecto IACT, documentando cómo se despliega y opera el sistema.

El despliegue define los ambientes, configuraciones y procedimientos operacionales.

Contenido
=========

El despliegue incluye:

* **Ambientes:** DEV, QA, PROD
* **Infraestructura:** Servidores, redes, almacenamiento
* **Configuración:** Variables de entorno, parámetros
* **Procedimientos de Despliegue:** Pasos para implementar cambios
* **Monitoreo y Logs:** Herramientas de observabilidad
* **Backup y Recuperación:** Estrategias de respaldo

Arquitectura de Ambientes
=========================

El sistema IACT se despliega en:

* **DEV:** Ambiente de desarrollo
* **QA:** Ambiente de pruebas
* **PROD:** Ambiente de producción

Tecnologías
===========

* **Contenedores:** Docker (si aplica)
* **Orquestación:** Kubernetes / Docker Compose (si aplica)
* **CI/CD:** Pipeline de integración y despliegue continuo
* **Monitoreo:** Herramientas de observabilidad del sistema

Prefijos
========

Los artefactos de este subdominio usan el prefijo **DEP_** (Deployment).

Ejemplo: ``DEP_001_Configuracion_Produccion.rst``

.. note::
   Contenido en desarrollo. Las configuraciones de despliegue se documentarán 
   conforme se defina la infraestructura del proyecto.
