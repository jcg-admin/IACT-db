---
id: DOC-FRONTEND-MF-CANVAS
estado: borrador
propietario: equipo-frontend
ultima_actualizacion: 2025-11-09
relacionados: ["DOC-ARQ-FRONTEND"]
date: 2025-11-13
---

# Arquitectura que encaja con mi proyecto — Guía y Canvas de Decisión (v1)

> **Estado actual (2025-11-09):** este canvas se conserva como referencia exploratoria. La arquitectura vigente del frontend continúa siendo el monolito modular definido en [ADR_011](../../adr/ADR_2025_015-frontend-modular-monolith.md) y su implementación está pospuesta según [ADR_2025_009](../../adr/ADR_2025_009-frontend-postponement.md); por lo tanto, **no se requieren microfrontends** en esta fase.

## 0. Propósito

Definir, comparar y seleccionar la arquitectura de micro frontends que mejor se ajusta a un proyecto específico, alineando necesidades de negocio, complejidad técnica, experiencia de usuario y gobernanza entre equipos. Documento operativo y editable para decidir, justificar y ejecutar.

---

## 1. Glosario mínimo

* **Enrutamiento inter-equipos**: cómo un usuario pasa de páginas de Equipo A a Equipo B.
* **Composición**: cómo se incluyen fragmentos UI de distintos equipos en una misma vista.
* **Navegación dura**: transición que recarga documento HTML completo.
* **Navegación blanda**: transición manejada en cliente sin recargar documento.
* **Render del lado servidor (SSR)**: el servidor genera HTML inicial.
* **Render del lado cliente (CSR)**: el navegador genera la UI a partir de JS.
* **Universal/Isomórfico**: SSR para primera carga + hidratación en cliente.
* **Fragmento**: micro frontend embebible (header, buy button, mini-cart, etc.).

---

## 2. Técnicas de integración (catálogo operativo)

### 2.1 Enrutamiento y transiciones

* **Enlaces**: contrato por URL. Simple, acoplamiento bajo. Navegación dura.
* **Application Shell**: contenedor JS que mapea URL → aplicación activa. Navegación blanda entre equipos. Requiere contrato y disciplina de ciclo de vida.

### 2.2 Composición

* **Server-side**: SSI/ESI, Tailor/Podium. Ensambla HTML antes de llegar al navegador. Favorece rendimiento inicial y mejora progresiva.
* **Client-side**: Web Components (Custom Elements), micro-frontends con ciclo de vida declarativo. Comunicación por CustomEvent/Broadcast Channel.
* **iframe**: fuerte aislamiento técnico y de seguridad. Coste en rendimiento, responsive complejo, comunicación por postMessage.
* **Ajax**: patrón híbrido para traer HTML parcial o datos. Útil para actualizaciones incrementales.

---

## 3. Arquitecturas de alto nivel

Para cada una: beneficios, retos, cuándo usar, riesgos.

### A) Linked Pages

* **Beneficios**: simplicidad, depuración directa, sin infra compartida.
* **Retos**: UX menos ágil por recargas; estado transitorio se pierde entre páginas.
* **Usos**: sitios orientados a contenido, SEO, baja interacción.
* **Riesgos**: degradación de UX en flujos con conmutación frecuente.

### B) Server Routing

* **Beneficios**: un front proxy enruta por prefijos; control central de dominios/headers.
* **Retos**: gestión de reglas y observabilidad; sigue habiendo navegación dura.
* **Usos**: multi-equipo con hospedaje unificado, seguridad y control.

### C) Linked SPAs

* **Beneficios**: UX suave dentro de cada equipo; contrato sigue siendo URL.
* **Retos**: cruces entre equipos siguen siendo duros; duplicación de infra SPA por equipo.
* **Usos**: dominios funcionales relativamente independientes.

### D) Linked Universal SPAs

* **Beneficios**: primera carga rápida por SSR, luego SPA por equipo.
* **Retos**: complejidad de SSR por equipo; coordinación de caché y headers.
* **Usos**: SEO y time-to-interactive exigentes, pero toleran navegación dura entre equipos.

### E) Unified SPA (App Shell)

* **Beneficios**: navegación blanda entre todos los equipos, experiencia continua.
* **Retos**: acoplamiento al shell, fugas de memoria si no hay buen ciclo de vida, gobernanza.
* **Usos**: flujos con saltos frecuentes entre equipos, back-office, apps internas.
* **Riesgos**: punto único de fallo; necesidad de pruebas de contrato y budget de rendimiento.

### F) Unified Universal SPA

* **Beneficios**: mejor UX combinando SSR inicial + SPA unificada.
* **Retos**: muy compleja; shell universal SSR/CSR, orquestación de hidratación.
* **Usos**: casos premium con equipo maduro y fuerte inversión en plataforma.

---

## 4. Continuo Documentos → Aplicaciones

Preguntas guía para posicionar el producto y orientar la selección:

1. ¿El valor principal es contenido legible o interacción rica de herramienta?
2. ¿Sin JS la página sigue siendo útil?
3. ¿SEO/descubribilidad crítica?
4. ¿Usuarios alternan con frecuencia entre vistas de distintos equipos en una sola sesión?
5. ¿Latencia percibida tras acciones debe ser sub-200 ms con feedback optimista?

Reglas prácticas:

* Lado servidor si el proyecto es contenido-céntrico y requiere progresiva mejora.
* Lado cliente si es herramienta pura y prima interacción sobre contenido.
* Universal cuando necesitas ambas y aceptas complejidad añadida.

---

## 5. Árbol de decisión operativo

Secuencia de decisiones y resultado esperado.

1. ¿Requieres aislamiento fuerte por legado o seguridad de terceros?
   * Sí → Prioriza iframe para esos módulos; combina con Server Routing.
   * No → 2.
2. ¿Necesitas primera carga rápida y mejora progresiva?
   * Sí → Preferir SSR o Universal; ve a 3.
   * No → Puedes ir a 4 directamente.
3. ¿La conmutación entre equipos debe ser blanda?
   * Sí → Unified SPA; si además quieres SSR inicial, valorar Unified Universal SPA.
   * No → Linked Universal SPAs con Server Routing.
4. ¿Se necesita feedback instantáneo dentro de cada área?
   * Sí → Al menos Linked SPAs por equipo.
   * No → Linked Pages o Server Routing bastan.
5. ¿Habrá múltiples fragmentos en una misma vista?
   * Server-side composición si priorizas primera carga y resiliencia.
   * Client-side composición si priorizas interactividad y comunicación en front.

Mapa técnica compatible:

* Linked Pages/Server Routing → SSI/ESI o Podium.
* Linked SPAs/Linked Universal → fragmentos SSR + hidratación opcional.
* Unified SPA → App Shell con enrutamiento de dos niveles, Web Components o single-spa.
* Unified Universal SPA → App Shell universal + SSR de equipos, estricto ciclo de vida.

---

## 6. Matriz de compatibilidad de composición

| Necesidad                     | Server-side (SSI/ESI/Podium) | Client-side (Web Components) | iframe              | Ajax  |
| ----------------------------- | ---------------------------- | ---------------------------- | ------------------- | ----- |
| Primera carga muy rápida      | Alta                         | Media                        | Baja                | Media |
| Comunicación entre fragmentos | Media (vía URL/SSR)          | Alta (CustomEvent/Broadcast) | Media (postMessage) | Media |
| Aislamiento                   | Media                        | Media                        | Alta                | Baja  |
| SEO                           | Alta                         | Media                        | Baja                | Media |
| Complejidad operativa         | Media                        | Media                        | Alta por sandboxing | Baja  |

---

## 7. Recomendación base para un proyecto típico de back-office con flujos cruzados

* **Arquitectura**: Heterogénea. Unified SPA entre áreas con conmutación frecuente; Linked Universal/Server Routing para áreas de bajo acoplamiento y catálogos públicos.
* **Shell**: App Shell con enrutamiento de dos niveles por prefijo de equipo. Shell mínimo, sin lógica de dominio.
* **Composición**: Web Components para fragmentos interactivos; SSR con SSI para contenido crítico y progressive enhancement, técnica universal combinada cuando aplique.
* **Comunicación UI**: CustomEvent con burbujeo y payload mínimo; BroadcastChannel solo si se necesitan múltiples ventanas.
* **Frontera de datos**: cada equipo habla solo con su backend; replicación por feeds o streams si se requiere independencia.
* **Aislamiento selectivo**: módulos de terceros o alta seguridad por iframe con postMessage y Content Security Policy restrictiva.

---

## 8. Contratos y gobernanza

* Espacio de URL por equipo: prefijos estables, p. ej. `/product/`, `/checkout/`.
* Catálogo de rutas expuesto por equipo; el shell solo mapea prefijos → componente equipo.
* Convención de fragmentos universales: `<[equipo]-[nombre] [params]>` con SSI `virtual="/[equipo]/fragment/[nombre]?[qs]"`.
* Versionado y compatibilidad: política SemVer para endpoints de fragmentos; pruebas de contrato.
* Performance Budgets: TTFB, LCP, INP; límites por vista y fragmento.
* Seguridad: CSP, Subresource Integrity, aislamiento de orígenes de terceros.

---

## 9. Plan de migración por fases

1. **Fase 0**: cartografiar dominios, prefijos y dependencias entre equipos.
2. **Fase 1**: pasar a Server Routing con SSI para fragmentos críticos y mejora progresiva.
3. **Fase 2**: introducir Web Components en fragmentos interactivos con eventos estándar.
4. **Fase 3**: App Shell de dos niveles para áreas con conmutación frecuente.
5. **Fase 4**: universalizar fragmentos que impactan conversión o primer render.
6. **Fase 5**: endurecer seguridad y pruebas de contrato, synthetic tests sin JS.

Hitos técnicos: métricas de primera carga, errores JS por equipo, fuga de listeners, tiempo de desmontaje, uso de memoria.

---

## 10. Checklists

### 10.1 Selección arquitectónica

* ¿Posición en Continuo Documentos → Aplicaciones justificada?
* ¿Frecuencia de navegación inter-equipos medida con datos reales?
* ¿Necesidad de SSR y progresiva mejora documentada por vista?
* ¿Requisitos de aislamiento identificados por módulo?

### 10.2 Shell y ciclo de vida

* Enrutamiento de dos niveles implementado.
* Interceptación de enlaces con soporte de nuevas pestañas y enlaces externos.
* Montaje, desmontaje, listeners y timers limpiados en `disconnectedCallback`.
* Sin estado de dominio en el shell.

### 10.3 Comunicación y datos

* Eventos con nombres con prefijo de equipo.
* Payload mínimo y estable.
* Sin dependencia de stores compartidos entre equipos.
* Replicación de datos por feeds cuando aplique.

### 10.4 Rendimiento y SEO

* SSR donde impacta LCP.
* Hydrate solo cuando sea necesario; evitar doble render innecesario.
* Presupuestos de rendimiento monitoreados en CI.

---

## 11. KPIs y medición

* LCP p95 por vista y por combinación de fragmentos.
* INP p95 acciones clave.
* Tasa de errores JS por equipo y por versión.
* Tiempo medio de navegación inter-equipos.
* Fugas de memoria detectadas en ciclos de montaje/desmontaje.
* Porcentaje de vistas útiles sin JS.

---

## 12. Antipatrones comunes

* Colocar lógica de negocio en el App Shell.
* Compartir estado global entre equipos.
* Enviar objetos complejos en eventos.
* Depender de tiempos en vez de hooks de ciclo de vida.
* No limpiar listeners ni timers al desmontar.

---

## 13. Snippets de referencia

### 13.1 App Shell básico, rutas por prefijo

```html
<script type="module">
  const routes = { "/product/": "decide-pages", "/checkout/": "checkout-pages", "/": "inspire-pages" };
  const app = document.querySelector("#app");
  const hist = window.History.createBrowserHistory();
  function find(path) { return Object.keys(routes).find(p => path.startsWith(p)); }
  function update(loc) {
    const name = routes[find(loc.pathname)];
    const next = document.createElement(name);
    app.replaceChildren(next);
  }
  hist.listen(update); update(window.location);
  document.addEventListener("click", e => {
    const a = e.target.closest("a[href]");
    if (!a || a.target === "_blank" || a.origin !== location.origin) return;
    e.preventDefault(); hist.push(a.getAttribute("href"));
  });
  window.appHistory = hist;
</script>
```

### 13.2 Fragmento con evento y burbujeo

```js
class CheckoutBuy extends HTMLElement {
  connectedCallback(){
    const btn = document.createElement("button");
    btn.textContent = "buy"; this.append(btn);
    btn.addEventListener("click", () => {
      this.dispatchEvent(new CustomEvent("checkout:item_added", {
        bubbles: true, detail: { sku: this.getAttribute("sku") }
      }));
    });
  }
  disconnectedCallback(){ /* limpiar si aplica */ }
}
customElements.define("checkout-buy", CheckoutBuy);
```

### 13.3 Universal composition con SSI

```html
<checkout-buy sku="fendt">
  <!--#include virtual="/checkout/fragment/buy/fendt" -->
</checkout-buy>
```

---

## 14. Plantilla de decisión por producto

Completar por cada dominio funcional.

* **Dominio**:
* **Posición en continuo**:
* **Necesidad de SSR**:
* **Frecuencia de salto inter-equipos**:
* **Aislamiento requerido**:
* **Arquitectura elegida**:
* **Composición**:
* **Comunicación UI**:
* **Métricas objetivo**:
* **Riesgos y mitigaciones**:

---

## 15. Riesgos y mitigaciones

* **Punto único de fallo en App Shell** → pruebas, canary, rollback rápido, SLO y presupuestos.
* **Desalineación de contratos de rutas/fragmentos** → contrato versionado y Pact tests.
* **Fugas de memoria** → auditorías periódicas de ciclo de vida, tooling de detección.
* **SEO inconsistente** → ownership de meta en shell con API mínima y convenciones por equipo.

---

## 16. Resultado esperado

Una selección arquitectónica justificada, con contratos claros, plan de transición por fases, KPIs y salvaguardas técnicas para sostener la evolución por equipos autónomos con una experiencia de usuario coherente y de alto rendimiento.
