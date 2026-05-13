---
id: MODULE-HOME
tipo: react_module
dominio: frontend
estado: documentado
fecha: 2025-11-06
auto_generado: true
---

# React Module: home

## Descripción

El módulo `home` presenta el panel inicial de la plataforma. Su objetivo es
mostrar anuncios editoriales, mensajes operativos y cualquier contenido de
contexto que permita que el usuario comprenda el estado general del sistema al
ingresar. El módulo funciona como microfrontend autónomo dentro del layout
principal, gestionando su propio estado, orquestación de datos y degradación
controlada cuando la API aún no expone todos los endpoints.

## Estructura

```
ui/src/modules/home/
├── HomeModule.jsx                   # Contenedor principal que orquesta UI y datos
├── components/
│   └── AnnouncementContent.jsx      # Renderiza anuncios estructurados (rich content)
├── constants/
│   └── announcementFallback.js      # Mensajes de respaldo cuando no hay datos remotos
├── hooks/
│   └── useHomeAnnouncement.js       # Coordina fetch, errores y selección de contenido
└── state/
    ├── homeSlice.js                 # Redux Toolkit slice con estados de carga/errores
    └── homeSlice.test.js            # Cobertura de reducers y thunks
```

## Componentes

### `HomeModule`

* **Responsabilidad**: Componente de alto nivel que conecta el estado global y
  decide qué vista mostrar (cargando, error, anuncio disponible o fallback).
* **Integraciones**: Usa `useHomeAnnouncement` para obtener datos, muestra
  metadatos (fuente, fecha) y expone puntos de anclaje para futuras métricas.

### `AnnouncementContent`

* **Responsabilidad**: Presentar anuncios con secciones tipadas (contexto,
  acciones, referencias) siguiendo el diseño editorial.
* **Detalles**: Admite bloques destacados, listas accionables y enlaces.
  La estilización vive en `ui/src/styles/global.css` para compartir tokens con
  otros módulos.

## Estado (Redux)

### `homeSlice`

* **Dominios de estado**: `status` (idle/loading/succeeded/failed),
  `announcement` (contenido renderizable), `metadata` (origen, sello temporal) y
  `error` (mensaje destinado a telemetría/UI).
* **Acciones asincrónicas**: `fetchHomeAnnouncement` consulta el servicio de
  anuncios. Ante fallos, la UI recurre a los mensajes de `announcementFallback`
  sin bloquear la interacción. Se documenta la degradación controlada como
  requisito arquitectónico para convivir con APIs incompletas.
* **Cobertura**: `homeSlice.test.js` valida transiciones de estado y escenarios
  de error para mantener ≥80 % de cobertura del slice.

## Hooks

### `useHomeAnnouncement`

* **Flujo**: Lanza `fetchHomeAnnouncement` al montar, expone indicadores de
  carga/errores y elige entre contenido remoto o fallback según disponibilidad.
* **Errores**: Normaliza excepciones antes de guardarlas en Redux para que la UI
  muestre mensajes consistentes y se reporten métricas cuando se integre la
  telemetría.

## Estilos Compartidos

* Los estilos específicos del anuncio (`.announcement-card`, `.announcement-callout`)
  residen en `ui/src/styles/global.css`. Se reutilizan variables CSS definidas
  por el design system y se aíslan en prefijos para evitar colisiones con otros
  microfrontends.

## Integración futura

* El módulo está listo para consumir servicios reales mediante la capa de
  `services/announcements`. Cuando la API se habilite, basta con ajustar el
  thunk para leer del nuevo endpoint y mantener los mismos contratos de datos.
* La arquitectura contempla internacionalización; los textos dinámicos provienen
  del contenido remoto y los labels del fallback se externalizan para facilitar
  traducciones.

## Notas

* La documentación reemplaza la plantilla autogenerada y deberá mantenerse en
  sincronía con cualquier cambio de componentes o estado.
