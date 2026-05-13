.. meta::
 :artefacto: API-preferences
 :tipo: API Reference
 :dominio: base-cognitiva
 :subdominio: ejemplos-pedagogicos
 :saga: dark-mode
 :fase_sdlc: implementacion
 :skill_aplicada: backend-nodejs
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

===============================
API Reference: User Preferences
===============================

.. note::

 **Ejemplo pedagógico (saga dark-mode).** Aplica el skill
 ``backend-nodejs`` para documentar la API.

1. Endpoint: GET /api/preferences/theme
=======================================

**Descripción:** recupera la preferencia de tema del usuario autenticado.

**Autenticación:** sesión activa requerida (cookie/JWT).

**Request:**

.. code-block:: http

 GET /api/preferences/theme HTTP/1.1
 Host: app.iact.example
 Cookie: session=abc123

**Response 200:**

.. code-block:: json

 {
   "theme": "light"
 }

**Response 401:** sin sesión activa.

2. Endpoint: POST /api/preferences/theme
========================================

**Descripción:** persiste la preferencia de tema.

**Request:**

.. code-block:: http

 POST /api/preferences/theme HTTP/1.1
 Host: app.iact.example
 Cookie: session=abc123
 Content-Type: application/json

 {
   "theme": "dark"
 }

**Response 200:**

.. code-block:: json

 {
   "ok": true
 }

**Response 400:** valor de ``theme`` no en ``["light", "dark"]``.

**Response 401:** sin sesión.

3. Errores
==========

.. list-table::
 :widths: 15 30 55
 :header-rows: 1

 * - Código
   - Causa
   - Acción cliente
 * - 400
   - ``theme`` inválido
   - Validar input antes de enviar
 * - 401
   - sin sesión
   - Redirigir a login
 * - 503
   - DB temporalmente no disponible
   - Reintento exponencial (max 3)

4. Rate limiting
================

- Aplicar throttling estándar del producto (CNST-011).
- POST limitado a 10 requests/min por usuario (anti-abuse).

5. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Saga**
   - dark-mode (:doc:`index`)
 * - **Skill aplicada**
   - ``backend-nodejs``
 * - **Fase SDLC**
   - Implementación
 * - **DB backing**
   - :doc:`db-user-preferences`
 * - **Documento siguiente**
   - :doc:`test-plan-dark-mode`
