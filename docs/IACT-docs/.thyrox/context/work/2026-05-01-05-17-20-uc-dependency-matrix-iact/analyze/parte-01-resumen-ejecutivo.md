```yml
created_at: 2026-05-01 05:17:20
project: IACT-docs
work_package: 2026-05-01-05-17-20-uc-dependency-matrix-iact
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Borrador
version: 1.0.0
language: es
parte: 1 de 12
```

# PARTE 1 — Resumen ejecutivo + distribución por criticidad + flujo crítico

> Primera parte del entregable
> ``MATRIZ-DEPENDENCIAS UC-IACT``. Establece el
> marco operativo de las 11 partes restantes:
> qué UCs son críticos, qué flujo no puede
> faltar, y qué tan denso es el grafo de
> dependencias del catálogo.

----

## 1.1 Resumen ejecutivo

El catálogo IACT está formado por **61 casos de
uso** agrupados en **9 clusters funcionales**
(AUTH, USR, ACC, PERM, RPT, ALR, PIP, AUD, LOG)
que operan sobre **25 clases de dominio**
distribuidas en 7 bounded contexts (Auth, RBAC,
Calls, Reports & Metrics, Pipeline ETL, Alerts,
Audit, Logs).

Esta matriz analiza las dependencias estructurales
entre los 61 UCs para identificar:

- **Cuáles UCs son críticos** — sin ellos el
  sistema no entrega su valor de negocio
  (call-center analytics + RBAC granular +
  auditoría compliance).
- **Cuál es el flujo mínimo end-to-end** que el
  sistema debe soportar para considerarse
  operativo.
- **Qué dependencias son transversales** —
  invocadas implícitamente por casi todos los
  UCs (autenticación, verificación de permiso,
  emisión de auditoría).
- **Qué dependencias son cuellos de botella** —
  puntos del grafo cuya falla deja sin servicio
  a varios consumidores aguas abajo.

----

## 1.2 Distribución por criticidad — los 61 UCs

Cada UC del catálogo se clasifica en una de
cuatro categorías de criticidad. La definición
formal vive en la Parte 2; aquí está la
distribución resultante.

```
CRÍTICOS  (8 UC)  — Sin estos, IACT no opera.
ALTOS     (27 UC) — Esenciales operativos.
MEDIOS    (18 UC) — Funcionalidades importantes,
                    prescindibles en una primera
                    versión funcional.
BAJOS     (8 UC)  — Opcionales / sub-features
                    avanzadas.
TOTAL     (61 UC)
```

Distribución gráfica:

::

   Criticidad          %     UCs
   ----------------------------
   CRÍTICOS            13%   8
   ALTOS               44%   27
   MEDIOS              30%   18
   BAJOS               13%   8

### 1.2.1 CRÍTICOS — los 8 UCs sin los cuales el
sistema no opera

::

   UC_AUTH_01  Iniciar Sesion        (entrada universal)
   UC_AUTH_04  Cambiar Contrasena    (forzado primer login, CNST-003)
   UC_PERM_07  Verificar Permiso     (gate seguridad universal)
   UC_USR_02   Consultar Usuarios    (baseline admin RBAC)
   UC_ACC_03   Consultar Permisos    (visibilidad RBAC mínima)
   UC_PIP_01   Supervisar ETL        (sin ETL no hay analytics)
   UC_RPT_01   Ver Dashboard         (UI principal del producto)
   UC_AUD_01   Consultar Auditoria   (compliance mandatorio CNST-025)

Justificación de cada uno en Parte 2 § 2.3.

### 1.2.2 ALTOS — los 27 UCs esenciales operativos

::

   AUTH (2):  UC_AUTH_02 Cerrar Sesion
              UC_AUTH_05 Gestionar Sesiones

   USR  (3):  UC_USR_01 Crear Usuario
              UC_USR_03 Modificar Usuario
              UC_USR_04 Eliminar (Deactivate) Usuario

   ACC  (4):  UC_ACC_01 Asignar Funciones
              UC_ACC_02 Revocar Funciones
              UC_ACC_04 Asignar Agrupador
              UC_ACC_05 Gestionar SoD

   PERM (5):  UC_PERM_01 Asignar Grupo a Usuario
              UC_PERM_02 Revocar Grupo a Usuario
              UC_PERM_05 Crear Grupo de Permisos
              UC_PERM_06 Asignar Funciones a Grupo
              UC_PERM_08 Generar Menu Dinamico

   RPT  (3):  UC_RPT_02 Ver Metricas Tiempo Real
              UC_RPT_03 Ver Reportes Historicos
              UC_RPT_04 Exportar Reporte (Larman consolidado)

   ALR  (3):  UC_ALR_01 Configurar Umbrales
              UC_ALR_02 Ver Alertas Activas
              UC_ALR_03 Reconocer Alerta

   PIP  (3):  UC_PIP_02 Consultar Errores ETL
              UC_PIP_03 Consultar Disponibilidad
              UC_PIP_04 Solicitar Reintento

   AUD  (2):  UC_AUD_02 Buscar Auditoria
              UC_AUD_03 Exportar Auditoria

   LOG  (2):  UC_LOG_01 Consultar Logs Sistema
              UC_LOG_02 Consultar Logs ETL

### 1.2.3 MEDIOS — los 18 UCs prescindibles en
versión funcional inicial

::

   AUTH (1):  UC_AUTH_03 Recuperar Contrasena

   ACC  (1):  UC_ACC_08 Permiso Temporal

   PERM (2):  UC_PERM_03 Conceder Permiso Excepcional
              UC_PERM_04 Revocar Permiso Excepcional

   RPT  (9):  UC_RPT_07 Programar Reporte
              UC_RPT_08 Ver Reportes Programados
              UC_RPT_11 Compartir Reporte
              UC_RPT_12 Ver Reporte Agentes
              UC_RPT_13 Ver Reporte Colas
              UC_RPT_14 Ver Reporte Campanas
              UC_RPT_15 Reporte Transferencias Centro
              UC_RPT_16 Reporte Menus IVR
              UC_RPT_17 Reporte Clientes Unicos

   ALR  (2):  UC_ALR_04 Ver Historial Alertas
              UC_ALR_05 Gestionar Suscripciones

   AUD  (1):  UC_AUD_04 Generar Reporte Compliance

   LOG  (2):  UC_LOG_04 Exportar Logs
              UC_LOG_05 Ver Logs Infraestructura

### 1.2.4 BAJOS — los 8 UCs opcionales / advanced

::

   ACC  (1):  UC_ACC_09 Auditar Cambios de Acceso

   PERM (2):  UC_PERM_09 Auditar Acceso
              UC_PERM_10 Consultar Auditoria de Permisos

   RPT  (2):  UC_RPT_09 Configurar Filtros
              UC_RPT_10 Guardar Vista

   LOG  (3):  UC_LOG_03 Buscar Logs
              UC_LOG_06 Ver Estado Sistema
              UC_LOG_07 Ver Metricas Tecnicas

### 1.2.5 Verificación cuantitativa

::

   8 + 27 + 18 + 8 = 61 UC  ✓

Cobertura: 100 % de los 61 UCs vigentes
clasificados.

----

## 1.3 Flujo crítico identificado — IACT

A diferencia de un ecommerce (Login → Catálogo →
Carrito → Pago), el flujo crítico de IACT no es
un único pipeline lineal. IACT es una
**plataforma de analytics + RBAC** con tres
caminos críticos paralelos según el actor:

### 1.3.1 Camino crítico — Sistema (background)

Pre-requisito de todos los demás caminos.

::

   ETL externo (background)
        ↓
   UC_PIP_01  Supervisar ETL
   (consume datos de la BD operativa,
    los carga en BD analítica
    según ventana CNST-006/008)
        ↓
   Datos analíticos disponibles
   (necesarios por todos los UCs RPT/ALR)

Sin este camino, los reportes RPT, las alertas
ALR y el monitoreo PIP no tienen datos.

### 1.3.2 Camino crítico — Operador / Supervisor

Camino de **valor de negocio** (lo que el cliente
final usa).

::

   UC_AUTH_01  Iniciar Sesion
        ↓
   [primer login: UC_AUTH_04 Cambiar Contrasena
    forzado per CNST-003]
        ↓
   UC_PERM_07  Verificar Permiso
   (transversal, en cada request)
        ↓
   UC_RPT_01  Ver Dashboard
   (la UI principal del producto)

Sin este camino el producto no entrega su valor
operativo (un supervisor no puede ver métricas
del call center en tiempo real).

### 1.3.3 Camino crítico — Administrador RBAC

Camino de **bootstrap** del sistema (sin él, no
hay usuarios para los otros caminos).

::

   UC_AUTH_01  Iniciar Sesion (admin)
        ↓
   UC_PERM_07  Verificar Permiso
        ↓
   UC_USR_02   Consultar Usuarios
   UC_ACC_03   Consultar Permisos
   (operaciones mínimas de visibilidad RBAC)

Sin este camino no se puede onboarding usuarios
ni revisar quién tiene qué permisos — no hay
gobierno del sistema.

### 1.3.4 Camino crítico — Auditor

Camino de **compliance** (mandatorio por
CNST-025).

::

   UC_AUTH_01  Iniciar Sesion (auditor)
        ↓
   UC_PERM_07  Verificar Permiso
        ↓
   UC_AUD_01   Consultar Auditoria
   (visibilidad sobre AuditEvent inmutable)

Sin este camino el sistema no cumple los
requisitos de compliance que motivan su
existencia (CNST-025 declara la auditoría como
inmutable y consultable).

### 1.3.5 Diagrama unificado del flujo crítico

::

                ┌─────────────────────┐
                │  UC_PIP_01          │
                │  Supervisar ETL     │
                │  (background)       │
                └──────────┬──────────┘
                           │
                           ▼
              ┌────────────────────────┐
              │  Datos analíticos      │
              │  disponibles           │
              └────────────────────────┘
                           │
                           ▼
              ┌────────────────────────┐
              │  UC_AUTH_01            │
              │  Iniciar Sesion        │
              └──────────┬─────────────┘
                         │
                ┌────────┴───────┐
                │ primer login?   │
                ▼                 ▼
         UC_AUTH_04         (continúa)
         Cambiar Contrasena
         (CNST-003)
                │                 │
                └────────┬────────┘
                         ▼
              ┌────────────────────────┐
              │  UC_PERM_07            │
              │  Verificar Permiso     │
              │  (transversal)         │
              └──┬─────────┬──────┬────┘
                 │         │      │
                 ▼         ▼      ▼
           OPERADOR    ADMIN   AUDITOR
                 │         │      │
                 ▼         ▼      ▼
         UC_RPT_01   UC_USR_02 UC_AUD_01
         Ver         Consultar Consultar
         Dashboard   Usuarios  Auditoria
                       │
                       ▼
                  UC_ACC_03
                  Consultar
                  Permisos

----

## 1.4 Tres tipos de dependencia transversal

Tres relaciones se repiten en casi todos los UCs
y se tratan en la Parte 4 con el mismo peso que
los puentes intra-cluster:

### T-01 — Sesión activa (UC_AUTH_01)

Pre-condición universal de los UCs operativos
(salvo los públicos como recuperación de
contraseña). Está documentada en CNST-003 (sesión
única) más que como ``<<include>>`` en cada UC.

### T-02 — Verificación de permiso (UC_PERM_07)

Pre-condición universal de los UCs autorizados.
Se invoca implícitamente en cada request (vía
decorador ``@require_function`` o middleware).
ADR-GOB-008 declara la coexistencia ACC ↔ PERM:
UC_ACC_03 es la vista funcional, UC_PERM_07 es
la vista técnica de la misma operación.

### T-03 — Emisión de AuditEvent

Toda operación de escritura en cualquier cluster
emite un ``AuditEvent`` (CNST-025 inmutable). Los
UCs AUD_01..04 son los consumidores. Esta
relación NO está cableada como
``<<include>>`` — se modela como nota en la
clase canónica y como atributo ``state`` en cada
entidad con ciclo de vida (per BR-009 v2.0.0).

----

## 1.5 Densidad del grafo — primeras métricas

Estimación inicial (refinada en Partes 3 y 7):

::

   Nodos:       61 UCs
   Aristas:     ≈ 100-130 (estimado)
                ├─ ≈ 60 transversales (UC_AUTH_01, UC_PERM_07
                │   como destino universal)
                ├─ ≈ 25 intra-cluster
                └─ ≈ 15-20 cross-cluster (los 10 puentes
                    estructurales del modelo de dominio +
                    invocaciones específicas)

   Camino crítico:     5-6 UCs (Sistema → Auth → Perm → Operador)
   Centralidad alta:   UC_AUTH_01, UC_PERM_07, UC_PIP_01

Detalle cuantitativo en Parte 7.

----

## 1.6 Próximos pasos (Partes 2 a 12)

| Parte | Foco |
|-------|------|
| 2 | Definiciones y criterios formales de criticidad |
| 3 | Matriz UC × UC — entrantes y salientes por UC |
| 4 | Dependencias transversales (T-01, T-02, T-03 detalle) |
| 5 | Análisis intra-cluster (9 clusters) |
| 6 | Análisis cross-cluster (10 puentes estructurales) |
| 7 | Camino crítico (longest path) y cuellos de botella |
| 8 | Riesgos por dependencia (SPOF, ciclos, huérfanos) |
| 9 | Implicaciones para implementación (orden de desarrollo) |
| 10 | Implicaciones para testing (orden de validación) |
| 11 | Implicaciones para deployment (rollout sequence) |
| 12 | Visualizaciones PlantUML (overview + camino crítico + matriz por cluster) |

----

## 1.7 Trazabilidad

Esta Parte 1 se ancla en:

- ``modelo-dominio-iact.rst`` v1.0.0 (25 clases /
  7 bounded contexts).
- ``modelo-rbac-iact.rst`` v5.4.0 (61 funciones).
- ``CNST-001, CNST-002, CNST-003, CNST-006/007/008,
  CNST-024, CNST-025, CNST-030`` (vigentes).
- ``BR-009 v2.0.0`` (alcance global, soft-delete).
- ``ADR-GOB-008`` (coexistencia ACC ↔ PERM).
- ``Z.2.A`` § 5 categorías de UCs.
- WP previo
  ``2026-05-01-03-29-03-uc-corrections-against-canonical-model``
  ``analyze/decisions-log.md`` (mapeo UC → clase).
