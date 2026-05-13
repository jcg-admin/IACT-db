.. _evidencia:

=========
Evidencia
=========

Propósito
=========

Este subdominio contiene las **evidencias de pruebas, validaciones y aprobaciones** 
del proyecto IACT, documentando la verificación y validación del sistema.

La evidencia proporciona trazabilidad auditable de la calidad del proyecto.

Contenido
=========

Las evidencias incluyen:

* **Casos de Prueba:** Especificación de pruebas funcionales y no funcionales
* **Resultados de Pruebas:** Ejecución, defectos encontrados, resolución
* **Validaciones:** Confirmación de cumplimiento de requisitos
* **Aprobaciones:** Firmas y autorizaciones formales
* **Auditorías:** Reportes de revisiones de calidad
* **Certificaciones:** Documentos de cumplimiento normativo

Tipos de Evidencia
==================

* **Pruebas Unitarias:** Código, cobertura
* **Pruebas de Integración:** Interfaces, APIs
* **Pruebas de Sistema:** End-to-end, UAT
* **Pruebas de Seguridad:** Vulnerabilidades, pentesting
* **Pruebas de Rendimiento:** Load testing, stress testing

Trazabilidad
============

La evidencia se relaciona con:

* **FR → Casos de Prueba:** Cada requisito debe tener pruebas
* **Casos de Prueba → Resultados:** Ejecución documentada
* **Defectos → Resolución:** Seguimiento de correcciones

Prefijos
========

Los artefactos de este subdominio usan:

* **EV_CP_** para casos de prueba
* **EV_RES_** para resultados de pruebas
* **EV_VAL_** para validaciones
* **EV_APR_** para aprobaciones

Ejemplo: ``EV_CP_001_Login_Usuario.rst``

.. note::
   Contenido en desarrollo. Las evidencias se generarán durante las fases 
   de pruebas y validación del sistema.
