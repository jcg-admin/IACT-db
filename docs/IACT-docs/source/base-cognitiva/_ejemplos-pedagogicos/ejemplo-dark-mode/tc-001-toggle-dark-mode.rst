.. meta::
 :artefacto: TC-001-toggle-dark-mode
 :tipo: Caso de Prueba
 :dominio: base-cognitiva
 :subdominio: ejemplos-pedagogicos
 :saga: dark-mode
 :fase_sdlc: pruebas
 :skill_aplicada: dmaic-control
 :estado: Aprobado
 :version: 1.0.0
 :fecha_creacion: 2026-04-30
 :ultimo_cambio: 2026-04-30
 :autor: NestorMonroy
 :clasificacion: Interno

========================
TC-001: Toggle Dark Mode
========================

.. note::

 **Ejemplo pedagógico (saga dark-mode).** Caso de prueba E2E
 derivado del :doc:`test-plan-dark-mode`.

1. Identificación
=================

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **ID**
   - TC-001
 * - **Tipo**
   - End-to-End
 * - **UC backing**
   - :doc:`uc-001-activar-dark-mode`
 * - **Tooling**
   - Playwright
 * - **Prioridad**
   - Alta

2. Precondiciones
=================

- Aplicación corriendo en ambiente de pruebas.
- Usuario de prueba con sesión activa.
- BD limpia (sin preferencia previa para el usuario).

3. Pasos de prueba
==================

.. list-table::
 :widths: 8 50 42
 :header-rows: 1

 * - Paso
   - Acción
   - Resultado esperado
 * - 1
   - Login con usuario de prueba
   - Página principal cargada en modo CLARO (default)
 * - 2
   - Inspeccionar ``document.documentElement.dataset.theme``
   - Valor = "light"
 * - 3
   - Click en botón ThemeToggle del header
   - UI cambia a modo OSCURO inmediatamente
 * - 4
   - Inspeccionar dataset.theme
   - Valor = "dark"
 * - 5
   - Verificar request POST a /api/preferences/theme
   - Status 200; payload {theme: "dark"}
 * - 6
   - Logout
   - Redirección a login page
 * - 7
   - Login nuevamente
   - Página principal en modo OSCURO (preferencia recuperada)
 * - 8
   - Verificar tiempo entre login y aplicación del tema
   - < 200ms (sin FOUC)

4. Código del test (Playwright)
===============================

.. code-block:: javascript

 import { test, expect } from '@playwright/test';

 test('TC-001: Toggle changes mode and persists', async ({ page }) => {
   // Login
   await page.goto('/login');
   await page.fill('[name=email]', 'test@example.com');
   await page.fill('[name=password]', 'testpass');
   await page.click('[type=submit]');
   await page.waitForURL('/dashboard');

   // Step 1-2: Default is light
   const html = page.locator('html');
   await expect(html).toHaveAttribute('data-theme', 'light');

   // Step 3: Click toggle
   await page.click('button[aria-label*="oscuro"]');

   // Step 4: Mode changed
   await expect(html).toHaveAttribute('data-theme', 'dark');

   // Step 5: Backend persisted
   const response = await page.waitForResponse(
     resp => resp.url().includes('/api/preferences/theme')
              && resp.request().method() === 'POST'
   );
   expect(response.status()).toBe(200);

   // Step 6-7: Logout & login → preferencia persiste
   await page.click('[data-test=logout]');
   await page.fill('[name=email]', 'test@example.com');
   await page.fill('[name=password]', 'testpass');
   await page.click('[type=submit]');
   await page.waitForURL('/dashboard');
   await expect(html).toHaveAttribute('data-theme', 'dark');
 });

5. Criterios de pass/fail
=========================

**PASS:** todos los pasos completados sin errores; assertions OK.

**FAIL:** si el toggle no cambia el modo, o la preferencia no
persiste, o se observa FOUC en step 7.

6. Trazabilidad
===============

.. list-table::
 :widths: 25 75
 :header-rows: 0

 * - **Saga**
   - dark-mode (:doc:`index`)
 * - **Skill aplicada**
   - ``dmaic-control``
 * - **Fase SDLC**
   - Pruebas
 * - **Test plan backing**
   - :doc:`test-plan-dark-mode`
 * - **Documento siguiente**
   - :doc:`release-plan-v1-5-0`
