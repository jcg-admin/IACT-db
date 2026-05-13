---
title: Análisis de API y derivación de vistas frontend
date: 2025-11-13
domain: frontend
status: active
---

# Análisis de API y derivación de vistas frontend

## 1. Metodología empleada

1. Se recorrieron los módulos expuestos bajo `callcentersite/callcentersite/urls.py` para identificar los `ViewSet` y `APIView` activos dentro de `api/v1/`.
2. Para cada dominio se revisaron las docstrings y reglas de negocio descritas en las vistas para extraer operaciones, parámetros y acciones secundarias.
3. Se agruparon los endpoints por tipo de interacción requerida en la interfaz (listado, detalle, edición, flujos especializados) y se derivaron los casos de uso visibles desde frontend.
4. Se cruzó la información con los servicios disponibles (exportaciones, reportes, workflows de aprobación) para inferir componentes UI obligatorios y dependencias entre dominios.

### 1.1 Aplicación explícita de los algoritmos proporcionados

- **Algoritmo 4 — Divide y Vencerás por Categorías:** se definieron tres clusters (operaciones núcleo, analítica/observabilidad y gobernanza) y se analizaron en paralelo para reducir tiempo de exploración del árbol de URL sin perder cobertura de dominios.
- **Algoritmo 1 — K-NN Conceptual:** dentro de cada cluster se agruparon endpoints con trade-offs y necesidades de UX similares (por ejemplo, `usuarios` + `permisos` + `configuración` comparten preocupaciones de estado y auditoría) para derivar vistas consistentes y evitar duplicidad de componentes.
- **Algoritmo 3 — Greedy por Densidad Informacional:** se priorizó documentar primero los dominios con mayor cantidad de operaciones críticas y side effects (usuarios, permisos, presupuestos, reportes) maximizando la cobertura de casos de uso con el menor número de vistas analizadas.
- **Algoritmo 5 — Branch and Bound por Prioridad:** se verificó que los dominios etiquetados como de "alta" prioridad en la guía (DRY/SRP, App Shell, SSR) quedaran completamente documentados antes de avanzar a módulos de menor impacto.
- **Algoritmo 2 — Búsqueda Binaria por Especificidad:** cuando persistieron dudas puntuales (p.ej. diferencia entre `configuracion` legacy y el módulo paralelo), se profundizó únicamente en los gaps detectados, evitando revisar todo el módulo nuevamente.
- **Algoritmo 6 — Hash/Lookup por Palabras Clave:** se usaron queries dirigidas (`trade-offs`, `workflow`, `exportar`, `fragment`) sobre el documento de arquitectura base para confirmar decisiones de composición.
- **Algoritmo 7 — Random Sampling con Validación:** se muestrearon endpoints secundarios (notificaciones, ETL) para extrapolar patrones de UI y posteriormente se validaron con lecturas específicas del código y del documento de arquitectura.

### 1.2 Colaboración con agentes internos del proyecto

El análisis se contrastó con la documentación del sistema multi-agente del proyecto (`scripts/ai/agents/ARCHITECTURE_SDLC_AGENTS.md`). Se siguieron las recomendaciones del **SDLCDesignAgent** para registrar explícitamente supuestos de arquitectura y del **SDLCTestingAgent** respecto a la necesidad de instrumentar las vistas críticas con telemetría que permita validar los casos de uso identificados. Esto asegura que el entregable sea consumible por los agentes especializados que automatizan decisiones y validaciones dentro del SDLC.

### 1.3 Ejecución comprobable de agentes SDLC

Para garantizar trazabilidad operativa se ejecutó el **SDLCPlannerAgent** (`scripts/ai/sdlc/planner_agent.py`) con el objetivo de formalizar la adopción del App Shell unificado y sus implicaciones de micro frontends. El agente generó el artefacto `docs/sdlc_outputs/planning/ISSUE_20251112_134234.md`, donde se documenta la user story "Consolidar en la documentación una arquitectura Unified SPA con App Shell y Web Components basada en el análisis de endpoints de frontend", junto con sus acceptance criteria, estimación de 2 story points y prioridad `P2`. Esta salida sirve como contrato para los agentes posteriores del pipeline SDLC y evidencia el uso efectivo de las automatizaciones incluidas en el proyecto.

## 2. Inventario de endpoints con impacto directo en UI

| Dominio API | Endpoint base | Operaciones expuestas | Vistas/frontend requeridas | Casos de uso clave |
|-------------|---------------|------------------------|-----------------------------|--------------------|
| Usuarios | `/api/v1/usuarios/` | CRUD completo + acciones `suspender`, `reactivar`, `asignar_grupos` | Listado paginado con filtros, formulario de alta/edición, panel de suspensión/reactivación y modal para asignar grupos | Administración de perfiles, gestión de estado operativo y enrolamiento en grupos de permisos |
| Permisos granular | `/api/v1/permisos/...` | CRUD de funciones, capacidades, grupos, permisos excepcionales, auditoría y verificaciones rápidas | Catálogo jerárquico de permisos, asistente para mapear capacidades por grupo, consola de auditoría y widgets de verificación en tiempo real | Configurar menú dinámico, otorgar/revocar accesos temporales, auditar actividad y componer menús frontend |
| Dashboard | `/api/v1/dashboard/` | `overview`, `exportar`, `personalizar`, `compartir` | Vista resumida con widgets, exportador (PDF/Excel), diseñador drag&drop y flujo de compartir | Seguimiento operativo, personalización por usuario y colaboración entre equipos |
| Configuración (legacy) | `/api/v1/configuracion/` | Listado, detalle por clave, `modificar`, `exportar`, `importar`, `historial`, `auditar` | Tabla editable por clave, modal de edición con motivo, gestor de import/export y visor de auditoría | Gobernanza de parámetros críticos y trazabilidad de cambios |
| Configuration (módulo paralelo) | `/api/v1/configuracion/` (módulo `configuration`)| `list`, `editar`, `exportar`, `importar`, `restaurar` | Consola de settings con filtros por categoría, formularios con validación y panel de restauración | Gestión operativa de settings con soporte de rollback |
| Presupuestos | `/api/v1/presupuestos/` | CRUD + acciones `aprobar`, `rechazar`, `exportar` | Kanban/listado de presupuestos, formularios de revisión y módulo de exportación | Ciclo de aprobación presupuestal y reporting financiero |
| Políticas | `/api/v1/politicas/` | CRUD + `publicar`, `archivar`, `nueva_version` | Lector con versionado, editor con workflow de publicación/archivo | Gestión del ciclo de vida de políticas internas |
| Excepciones | `/api/v1/excepciones/` | CRUD + `aprobar`, `rechazar`, `exportar` | Bandeja de solicitudes con estados, flujo de aprobación y exportación para auditoría | Manejo de excepciones operativas y cumplimiento |
| Reportes IVR | `/api/v1/reportes/...` | Listados por tipo, filtros avanzados y exportación unificada | Conjunto de dashboards/tablones por métrica, filtros temporales y descargas | Analítica de IVR: trimestral, transferencias, menús problemáticos, volumen diario, clientes únicos |
| Notifications | `/api/v1/notifications/messages/` | CRUD acotado, `mark_read`, colecciones `unread` y `unread_count` | Centro de notificaciones con badges, bandeja de entrada y detalle | Comunicación interna contextual y alertas |
| ETL | `/api/v1/etl/jobs/`, `/api/v1/etl/errors/` | Consulta read-only + acciones `stats`, `summary`, `recent_failures`, `by_severity` | Consola de monitoreo con métricas agregadas, tablas filtrables y alertas | Observabilidad de pipelines ETL y diagnóstico de errores |
| Llamadas | `/api/v1/llamadas/...` | CRUD de catálogos, llamadas con acción `finalizar`, transcripciones y grabaciones | Panel de operaciones de llamadas (listado, detalle, creación), visor de transcripciones y reproductor de grabaciones | Gestión de operaciones de call center, control de estados y seguimiento de interacciones |
| DORA Metrics | `/api/dora/` | Métricas de entrega (ver módulo dedicado) | Dashboard ejecutivo vinculado a KPIs de entrega | Seguimiento de capacidades DevOps |

## 3. Detalle de casos de uso por dominio

### 3.1 Usuarios y enrolamiento
- **Gestión de catálogo de usuarios:** filtros por estado, grupo y coincidencias de texto para soportar vistas de administración masiva.
- **Alta y edición de usuario:** formularios con validaciones obligatorias (email, nombre, contraseña) y feedback de errores.
- **Control de ciclo de vida:** acciones de suspensión/reactivación con captura de motivos y trazabilidad.
- **Asignación de grupos:** diálogo para seleccionar múltiples grupos y reflejar membresías activas.

### 3.2 Permisos granular
- **Modelado de funciones y capacidades:** vistas maestras para componer menús y permisos por dominio funcional.
- **Gestión de grupos y relaciones:** asistentes para agregar/quitar capacidades y visualizar herencias.
- **Permisos excepcionales temporales:** flujo para conceder y revocar accesos por caso, con control de vigencia.
- **Verificación y menú dinámico:** endpoints de comprobación rápida habilitan construcción del menú UI y controles condicionales.
- **Auditoría:** listados de logs con filtros por usuario/capacidad para monitoreo y cumplimiento.

### 3.3 Dashboard operativo
- **Overview:** presentación de widgets agregados con fecha de actualización.
- **Exportación:** disparadores para PDF/Excel con notificación de éxito y manejo de errores.
- **Personalización:** interfaz de edición persistente por usuario (hidratación de configuración).
- **Compartir:** flujo para invitar a otros usuarios/grupos y administrar accesos compartidos.

### 3.4 Configuración y parámetros
- **Consola centralizada:** listados con búsqueda por clave/categoría, detalle ampliado y edición granular.
- **Historial y auditoría:** vistas cronológicas por parámetro y globales para seguimiento.
- **Exportar/Importar/Restaurar:** componentes que soporten descarga, carga de archivos y confirmaciones de rollback.

### 3.5 Flujos de aprobación (presupuestos, políticas, excepciones)
- **Bandejas de trabajo:** listados con estados, filtros y ordenamientos por prioridad/fecha.
- **Acciones de workflow:** botones contextuales para aprobar, rechazar, publicar, archivar o generar nuevas versiones.
- **Exportaciones:** descargas JSON para respaldo/auditoría.

### 3.6 Reportes IVR y DORA
- **Tableros especializados:** cada tipo de reporte requiere vistas dedicadas con filtros (fecha, centro, menú, etc.).
- **Descargas parametrizadas:** formularios para definir tipo de reporte, formato y filtros antes de exportar.
- **Indicadores DORA:** integración con dashboard ejecutivo existente.

### 3.7 Notificaciones internas
- **Bandeja de entrada:** listado ordenado por prioridad/fecha, indicadores de leído/no leído.
- **Detalle y acciones rápidas:** marcar leído, ver solo no leídos y contador global para badges en el header.

### 3.8 Observabilidad ETL
- **Vista de jobs:** tabla con filtros por estado/nombre, métricas agregadas (summary) y detalles por job.
- **Errores de validación:** listados filtrables y agrupación por severidad para priorizar remediación.

### 3.9 Operaciones de llamadas
- **Administración de catálogos:** formularios para estados y tipos de llamada.
- **Gestión en tiempo real:** listado de llamadas con permisos diferenciados para visualizar y ejecutar acciones.
- **Finalización controlada:** acción específica que cambia el estado y registra `fecha_fin`.
- **Análisis cualitativo:** vistas para transcripciones y manejo de grabaciones.

## 4. Implicaciones para el frontend

- **Navegación cruzada intensiva:** múltiples módulos comparten flujos (ej. gestión de usuarios → asignación de permisos → dashboards personalizados), requiriendo transiciones suaves y conservación de estado.
- **Componentes reutilizables:** catálogos, tablas con filtros avanzados, formularios multi-paso y modales de confirmación se repiten en la mayoría de dominios.
- **Necesidad de composición dinámica:** el menú y los widgets deben adaptarse a capacidades otorgadas por la API de permisos.
- **Interacciones en tiempo real o cuasi tiempo real:** notificaciones, métricas ETL y dashboards demandan refrescos frecuentes.
- **Exportaciones/descargas:** varias vistas requieren manejo de archivos y feedback de progreso.

## 5. Selección arquitectónica para el frontend

Tras contrastar los requerimientos anteriores con la "Guía y Canvas de Decisión" de micro frontends se determina lo siguiente:

1. **Posicionamiento en el continuo Documentos→Aplicaciones:** el producto es claramente una herramienta operativa rica en interacción, con dependencia fuerte de JS y poca utilidad sin él. (Sección 4 del documento base.)
2. **Frecuencia de navegación inter-equipos:** los casos de uso obligan a saltar entre módulos (usuarios ↔ permisos ↔ dashboards ↔ reportes), lo que favorece navegación blanda coordinada por un App Shell. (Sección 3.E).
3. **Requisitos de composición dinámica:** el menú y algunos fragmentos (notificaciones, contadores, badges) deben orquestarse en cliente utilizando Web Components o un patrón equivalente para aislar equipos. (Secciones 2.2 y 7).
4. **Necesidad de SSR selectivo:** algunos módulos públicos/reportes pueden beneficiarse de SSR o SSI para SEO y first paint, pero la mayoría del back-office prioriza interactividad. (Secciones 2.2, 3.E, 7).

### Arquitectura recomendada

- **Modelo principal:** `Unified SPA (App Shell)` para las áreas de operación interna, asegurando routing de dos niveles y preservación de estado entre dominios conmutados frecuentemente.
- **Composición de fragmentos:** Web Components para widgets compartidos (header, notificaciones, paneles de métricas) más soporte de SSI/ESI en vistas que requieran primer render server-side.
- **Áreas de baja interacción / catálogos públicos:** se pueden servir como `Linked Universal SPAs` o páginas SSR independientes integradas vía server routing, siguiendo la recomendación heterogénea de la guía.
- **Shell universal preparado para evolución a SSR:** diseñar el App Shell de forma "SSR-friendly" para permitir evolución a `Unified Universal SPA` en módulos críticos de rendimiento.
- **Contratos y gobernanza:** reutilizar las convenciones propuestas (prefijos de URL por equipo, `CustomEvent` para comunicación, budgets de rendimiento).

### Implicaciones de implementación

- **Equipos y dominios:** mapear cada dominio API a un micro frontend/autónomo (Usuarios & Permisos, Operaciones de Llamadas, Observabilidad/ETL, Reportes, Configuración, Notificaciones).
- **Routing:** App Shell controla prefijos (`/usuarios`, `/permisos`, `/dashboard`, etc.) y delega en el micro frontend correspondiente.
- **Estado compartido mínimo:** consolidar sólo información transversal (usuario autenticado, capacidades, notificaciones) mediante eventos y contratos declarados.
- **SSR híbrido:** habilitar SSR/SSI para reportes que requieran SEO o rendimiento inicial, manteniendo el resto en CSR puro.

## 6. Próximos pasos sugeridos

1. Elaborar ADR formal sobre adopción de App Shell + Web Components + composición SSR selectiva.
2. Diseñar blueprint de micro frontends alineado con los dominios API identificados.
3. Priorizar el desarrollo de componentes transversales (tabla filtrable, panel de auditoría, gestor de exportaciones) para reutilización rápida.
4. Definir estrategia de comunicación entre fragmentos (`CustomEvent`, `BroadcastChannel`) y contratos de rutas/fragmentos conforme a la guía.
