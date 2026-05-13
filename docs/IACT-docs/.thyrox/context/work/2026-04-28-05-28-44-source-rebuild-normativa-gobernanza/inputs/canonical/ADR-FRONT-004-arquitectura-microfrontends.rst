ESTO NO ES NECESARIO, AGREGA COMPLEJIDAD AL PROYECTO

Contexto
--------

El roadmap del frontend exige habilitar colaboración entre equipos
independientes mientras se mantiene una experiencia de usuario fluida
para herramientas internas y dashboards que combinan datos de múltiples
dominios. La documentación “Arquitectura que encaja con mi proyecto —
Guía y Canvas de Decisión” describe múltiples opciones (Linked Pages,
Server Routing, Unified SPA, etc.) y criterios como frecuencia de
navegación inter-equipos, necesidad de SSR y requerimientos de
aislamiento. Actualmente coexistirán módulos con mocks y futuros
endpoints reales, por lo que debemos definir cómo orquestarlos sin
duplicar esfuerzos por equipo.

   **Nota de estado (2025-11-09):** la evaluación se realizó, pero tras
   contrastar con
   `ADR-015-frontend-modular-monolith <./ADR-015-frontend-modular-monolith.md>`__
   y
   `ADR-009-frontend-postponement <./ADR-009-frontend-postponement.md>`__
   se determinó que la propuesta no se adoptará en esta etapa. El
   documento se conserva como análisis de opciones para un futuro
   posible.

Decisión evaluada (no adoptada)
-------------------------------

1. Adoptar una **Unified SPA con App Shell** como columna vertebral para
   los flujos operativos del back-office, garantizando navegación blanda
   entre dominios críticos (configuración, permisos, llamadas) y un solo
   punto de integración con feature flags de resiliencia.
2. Complementar el shell con **Linked Universal SPAs** para áreas de
   baja frecuencia de conmutación o catálogos públicos, permitiendo SSR
   opcional cuando se necesite SEO o primera carga optimizada.
3. Definir **Web Components como mecanismo principal de composición
   cliente** dentro del shell, reservando iframes únicamente para
   módulos de terceros con requerimientos de aislamiento fuerte.
4. Mantener las fronteras de datos por equipo: cada microfrontend
   consume sus servicios resilientes y emite eventos con nombres con
   prefijo de dominio; el shell solo resuelve enrutamiento y montaje.

Consecuencias si se reactivara
------------------------------

-  El App Shell se convierte en artefacto crítico: requiere pruebas de
   contrato de ciclo de vida (montaje/desmontaje) y budget de
   rendimiento compartido. No debe contener lógica de dominio ni estado
   global.
-  Los equipos deberían empaquetar sus microfrontends como Web
   Components compatibles con single-spa, exponiendo hooks de limpieza
   para evitar fugas de memoria.
-  Sería necesario documentar prefijos de URL, catálogos de rutas y
   eventos compartidos en la guía de arquitectura, además de sincronizar
   el backlog (``TODO.md``) con hitos de adopción de shell y SSR.
-  SSR solo se habilitaría en microfrontends con métricas de SEO o LCP
   exigentes; requiere coordinación con infraestructura para plantillas
   ESI/SSI.

Consideraciones futuras
-----------------------

-  Evaluar inversión en una variante Unified Universal SPA cuando
   existan recursos para SSR compartido y monitoreo avanzado.
-  Automatizar pruebas sintéticas que monten y desmonten fragmentos,
   detectando fugas y verificando presupuestos de rendimiento.
-  Publicar lineamientos específicos para payloads de eventos y adopción
   de BroadcastChannel cuando haya multi-ventana.
