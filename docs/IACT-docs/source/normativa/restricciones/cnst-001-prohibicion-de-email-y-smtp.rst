.. meta::
 :artefacto: CNST_001
 :tipo: Restriccion
 :dominio: normativa
 :subdominio: restricciones
 :estado: Vigente
 :version: 2.0.0
 :fecha_creacion: 2025-12-17
 :ultimo_cambio: 2026-04-28
 :autor: NestorMonroy
 :clasificacion: Critico

.. _cnst-001:

=====================================
CNST-001: Prohibicion de Email y SMTP
=====================================

Resumen Ejecutivo
-----------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **ID**
   - CNST_001
 * - **Categoria**
   - Comunicaciones
 * - **Tipo (TXM_01)**
   - Negocio
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


El sistema IACT NO PUEDE enviar correos electronicos por SMTP, ni
integrar servicios de email transaccional, bajo ninguna circunstancia.

1.2 Justificacion
^^^^^^^^^^^^^^^^^


Restriccion de negocio impuesta por el cliente. El cliente NO permite
que aplicaciones corporativas envien correos a traves de servicios
SMTP externos o internos por razones de control de canal y trazabilidad.

1.3 Origen
^^^^^^^^^^

- **Fuente:** Restriccion de negocio (cliente)
- **Documento:** Contrato cliente — politica de comunicaciones corporativas
- **Fecha:** 2025-01-01

2. Especificacion Tecnica
-------------------------

2.1 Descripcion Detallada
^^^^^^^^^^^^^^^^^^^^^^^^^


- Prohibido importar ``django.core.mail``, ``smtplib`` o ``sendmail``.
- Prohibido integrar SaaS de email (SendGrid, Mailgun, AWS SES).
- Prohibido configurar servidores SMTP corporativos.
- Prohibido enviar notificaciones por email a usuarios o administradores.

2.2 Parametros
^^^^^^^^^^^^^^

Ver subseccion 2.1.

2.3 Tecnologias Involucradas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- django.core.mail (prohibido)
- smtplib (prohibido)
- sendmail (prohibido)
- SendGrid/Mailgun/AWS SES (prohibido)

3. Impacto en Sistema
---------------------

3.1 Modulos Afectados
^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - Modulo
   - Impacto
 * - MOD_Notifications
   - Implementa el buzon interno como unico canal
 * - MOD_Auth
   - Recuperacion de password sin email

3.2 Casos de Uso Afectados
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
 :widths: 30 70
 :header-rows: 1

 * - UC
   - Impacto
 * - UC_003
   - Recuperar Contraseña — usa preguntas de seguridad en lugar de email
 * - UC_036
   - Configurar Alertas — destino unico buzon interno
 * - UC_037
   - Recibir Notificacion
 * - UC_038
   - Marcar Alerta como Leida
 * - UC_039
   - Archivar Alerta
 * - UC_040
   - Consultar Historial de Alertas

3.3 Lo que NO se puede hacer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Enviar correos electronicos a usuarios
- Integrar servicios SaaS de email
- Configurar servidores SMTP corporativos
- Enviar tokens de recuperacion por email

4. Business Rules Derivadas
---------------------------

.. list-table::
 :widths: 20 40 40
 :header-rows: 1

 * - BR
   - Nombre
   - Relacion
 * - BR (pendiente)
   - Notificacion via buzon interno como BR derivada
   - FND_07:561-563 — pendiente WP requisitos

5. Implementacion
-----------------

5.1 Codigo de Referencia
^^^^^^^^^^^^^^^^^^^^^^^^


.. code-block:: bash

 grep -E "django-mail|sendgrid|mailgun" requirements.txt && exit 1 || exit 0

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

Cualquier excepcion requiere aprobacion formal del cliente y modificacion contractual. No se aceptan excepciones tecnicas.

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
- **Frecuencia:** Continuo (CI)
- **Herramienta:** grep en requirements.txt + linter custom

8. Trazabilidad
---------------

.. list-table::
 :widths: 30 70
 :header-rows: 0

 * - **CNSTs relacionadas**
   - :doc:`cnst-002-buzon-interno-obligatorio`
 * - **BR derivadas**
   - BR (pendiente)
 * - **UCs afectados**
   - UC_003, UC_036, UC_037, UC_038, UC_039, UC_040
 * - **MODs afectados**
   - MOD_Notifications, MOD_Auth
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

