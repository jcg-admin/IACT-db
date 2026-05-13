# ANÁLISIS PROFUNDO: METODOLOGÍA COMPLETA PARA CASOS DE USO
## Basado en PARTE 1, 2, 3 y 4 de la Metodología IACT

**Fecha:** 2025-12-22
**Versión:** 1.0.0
**Estado:** Análisis Completo

---

## 1. HALLAZGOS CLAVE DE LA METODOLOGÍA

### 1.1 Flujo Completo de Derivación

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    FLUJO METODOLÓGICO COMPLETO                          │
│                                                                         │
│  PARTE 1: Business Rules                                                │
│  ─────────────────────────                                              │
│  45 BR clasificadas en 5 tipos:                                         │
│  • Hechos (8) → Modelo de Dominio                                       │
│  • Restricciones (15) → Precondiciones/Validaciones                     │
│  • Desencadenadores (7) → UC COMPLETOS ⭐                               │
│  • Inferencias (6) → FR Directos                                        │
│  • Cálculos (9) → Pasos en UC                                          │
│                          │                                              │
│                          ▼                                              │
│  PARTE 2: Transformación BR → UC                                        │
│  ───────────────────────────────                                        │
│  10 UC derivados de BR (22% del total)                                  │
│  Solo DESENCADENADORES generan UC completos                             │
│                          │                                              │
│                          ▼                                              │
│  PARTE 3: Técnicas Complementarias ⭐ CRÍTICO                           │
│  ─────────────────────────────────────────────                          │
│  35 UC adicionales (78% del total):                                     │
│  • Técnica 1 CRUD: 15-20 UC (40%)                                       │
│  • Técnica 2 Larman: 10-15 UC (22%)                                     │
│  • Técnica 3 UI-Driven: 5-10 UC (11%)                                   │
│  • Técnica 4 Stakeholders: 2-5 UC (5%)                                  │
│                          │                                              │
│                          ▼                                              │
│  CONSOLIDACIÓN                                                          │
│  ─────────────                                                          │
│  45 UC → 42 UC (eliminados duplicados)                                  │
│  Organizados en 12 módulos                                              │
│                          │                                              │
│                          ▼                                              │
│  PARTE 4: UC → FR                                                       │
│  ────────────────                                                       │
│  42 UC → ~450 FR (ratio 1:10)                                           │
│  Cada paso de UC → múltiples FR atómicos                                │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 1.2 Descubrimiento Crítico: GAP del 78%

```
╔══════════════════════════════════════════════════════════════════════════╗
║                         HALLAZGO FUNDAMENTAL                             ║
╠══════════════════════════════════════════════════════════════════════════╣
║                                                                          ║
║   Las Business Rules solo generan el 22% de los UC necesarios.           ║
║                                                                          ║
║   El 78% restante viene de:                                              ║
║   • Operaciones CRUD sobre entidades                                     ║
║   • Autenticación y seguridad                                            ║
║   • Reportería y consultas                                               ║
║   • Configuración del sistema                                            ║
║   • Necesidades operacionales de stakeholders                            ║
║                                                                          ║
║   IMPLICACIÓN PARA IACT:                                                 ║
║   Tu catálogo de 40+ UC es CORRECTO y NECESARIO.                         ║
║   ESTRUCTURA v2.0.0 con solo 3 UC está INCOMPLETA.                       ║
║                                                                          ║
╚══════════════════════════════════════════════════════════════════════════╝
```

---

## 2. MAPEO DE TU CATÁLOGO ACTUAL

### 2.1 Clasificación por Técnica de Origen

```
TU CATÁLOGO                              TÉCNICA DE ORIGEN
───────────────────────────────────────────────────────────

AUTENTICACIÓN (UC-001 a UC-005):
├── UC-001: Iniciar Sesión               → Larman (Evento del Sistema)
├── UC-002: Cerrar Sesión                → Larman (Evento del Sistema)
├── UC-003: Recuperar Contraseña         → Larman (Responsabilidad)
├── UC-004: Cambiar Contraseña           → CRUD (Update especial)
└── UC-005: Gestión de Sesiones          → Larman (Responsabilidad)

GESTIÓN USUARIOS (UC-006 a UC-011):
├── UC-006: Crear Usuario                → CRUD (Create)
├── UC-007: Modificar Usuario            → CRUD (Update)
├── UC-008: Eliminar Usuario             → CRUD (Delete - soft)
├── UC-009: Listar Usuarios              → CRUD (Read - lista)
├── UC-010: Asignar Roles                → BR (Desencadenador) + CRUD
└── UC-011: Gestionar Permisos por Rol   → BR (RBAC) + CRUD

MÓDULOS Y PERFILES (UC-012 a UC-016):
├── UC-012: Asignar Módulos a Usuario    → CRUD (Update especial)
├── UC-013: Crear Perfil de Módulos      → CRUD (Create)
├── UC-014: Asignar Perfil a Usuario     → CRUD (Update)
├── UC-015: Ver Módulos Disponibles      → CRUD (Read)
└── UC-016: Configurar Permisos de Módulo → CRUD (Update)

SEGMENTOS (UC-041, UC-042):
├── UC-041: Gestionar Segmentos de Datos → CRUD (CRUD completo)
└── UC-042: Gestionar Permisos Directos  → CRUD + BR

EXPORTACIONES: (por identificar)
└── UC-0XX: Exportar a Excel/CSV/PDF     → UI-Driven + BReq_002

REPORTES: (por identificar)
└── UC-0XX: Consultar Reportes           → CRUD + Stakeholders

DASHBOARD: (por identificar)
└── UC-0XX: Visualizar Dashboard         → UI-Driven + BReq_001
```

### 2.2 UC Derivados de BR vs UC de Técnicas

```
UC DE BUSINESS RULES (PARTE 2):
──────────────────────────────
• UC derivados de BR_001 (Inmutabilidad): 0 UC directos
  → BR_001 es RESTRICCIÓN, no genera UC, se integra como precondición
  
• UC derivados de BR_002 (ETL): 1 UC interno
  → UC-ETL: Ejecutar Sincronización (actor: Sistema/Tiempo)
  
• UC derivados de BR_003 (RBAC): Integrado en múltiples UC
  → UC-010: Asignar Roles (desencadenador de asignación)
  → UC-011: Gestionar Permisos
  
TOTAL DE BR: 1-2 UC directos (~5%)

UC DE TÉCNICAS COMPLEMENTARIAS (PARTE 3):
─────────────────────────────────────────
• CRUD sobre Usuario: 7 UC (UC-006 a UC-011, UC-054)
• CRUD sobre Módulos: 5 UC (UC-012 a UC-016)
• CRUD sobre Segmentos: 2 UC (UC-041, UC-042)
• Autenticación (Larman): 5 UC (UC-001 a UC-005)
• UI/Dashboard: ~3 UC (por definir)
• Reportes: ~3 UC (por definir)

TOTAL TÉCNICAS: 25+ UC (~95%)
```

---

## 3. PROCESO DE EJECUCIÓN PROPUESTO

### 3.1 Fase 0: Inventario y Decisiones

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    FASE 0: PREPARACIÓN (1 día)                          │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  PASO 0.1: INVENTARIO COMPLETO                                          │
│  ────────────────────────────                                           │
│  □ Listar TODOS los UC existentes en tu Obsidian                        │
│  □ Identificar versiones más recientes (v.0.1.1 > v.0.0.1)              │
│  □ Descartar UC obsoletos o duplicados                                  │
│  □ Resultado: Lista maestra de N UC válidos                             │
│                                                                         │
│  PASO 0.2: CLASIFICACIÓN POR TÉCNICA                                    │
│  ─────────────────────────────────                                      │
│  □ Etiquetar cada UC con su origen:                                     │
│    - [BR] = Derivado de Business Rule                                   │
│    - [CRUD] = Operación CRUD sobre entidad                              │
│    - [LARMAN] = Evento/Responsabilidad del sistema                      │
│    - [UI] = Derivado de interfaz/mockup                                 │
│    - [STK] = Requerimiento directo de stakeholder                       │
│                                                                         │
│  PASO 0.3: DECISIONES DE NUMERACIÓN                                     │
│  ───────────────────────────────                                        │
│  □ Aprobar esquema de bloques:                                          │
│                                                                         │
│    UC_001-009:  Autenticación y Sesiones                                │
│    UC_010-019:  Gestión de Usuarios                                     │
│    UC_020-029:  Roles y Permisos                                        │
│    UC_030-039:  Módulos y Perfiles                                      │
│    UC_040-049:  Segmentos de Datos                                      │
│    UC_050-059:  Dashboard y Visualización                               │
│    UC_060-069:  Reportes y Consultas                                    │
│    UC_070-079:  Exportaciones                                           │
│    UC_080-089:  Alertas y Notificaciones                                │
│    UC_090-099:  Administración Sistema                                  │
│    UC_100-109:  ETL y Sincronización                                    │
│    UC_110+:     Reservado para expansión                                │
│                                                                         │
│  PASO 0.4: MAPEO NUMERACIÓN VIEJA → NUEVA                               │
│  ─────────────────────────────────────────                              │
│  □ Crear tabla de equivalencias:                                        │
│                                                                         │
│    UC-001 (viejo) → UC_001 (nuevo)  Iniciar Sesión                      │
│    UC-006 (viejo) → UC_010 (nuevo)  Crear Usuario                       │
│    UC-041 (viejo) → UC_040 (nuevo)  Gestionar Segmentos                 │
│    ...                                                                  │
│                                                                         │
│  ENTREGABLE FASE 0:                                                     │
│  ──────────────────                                                     │
│  □ Documento: CATALOGO_UC_MAESTRO.md                                    │
│    - Lista de N UC con ID nuevo, nombre, categoría, origen              │
│    - Tabla de mapeo viejo → nuevo                                       │
│    - Decisiones aprobadas                                               │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.2 Fase 1: Migración por Categorías

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    FASE 1: MIGRACIÓN (5-7 días)                         │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ESTRATEGIA: Migrar por CATEGORÍA, no por número                        │
│                                                                         │
│  LOTE 1: AUTENTICACIÓN (UC_001-009) - 5 UC                              │
│  ─────────────────────────────────────────────                          │
│  Día 1:                                                                 │
│  □ Migrar UC_001 (Iniciar Sesión) - COMPLETO con FR                     │
│  □ Migrar UC_002 (Cerrar Sesión)                                        │
│  □ Migrar UC_003 (Recuperar Contraseña)                                 │
│  □ Migrar UC_004 (Cambiar Contraseña)                                   │
│  □ Migrar UC_005 (Gestión de Sesiones)                                  │
│  □ Crear index.rst de autenticación                                     │
│                                                                         │
│  LOTE 2: USUARIOS (UC_010-019) - 6 UC                                   │
│  ─────────────────────────────────────                                  │
│  Día 2:                                                                 │
│  □ Migrar UC_010 (Crear Usuario)                                        │
│  □ Migrar UC_011 (Modificar Usuario)                                    │
│  □ Migrar UC_012 (Desactivar Usuario)                                   │
│  □ Migrar UC_013 (Listar Usuarios)                                      │
│  □ Migrar UC_014 (Ver Detalle Usuario)                                  │
│  □ Migrar UC_015 (Buscar Usuario)                                       │
│  □ Crear index.rst de usuarios                                          │
│                                                                         │
│  LOTE 3: ROLES Y PERMISOS (UC_020-029) - 4 UC                           │
│  ─────────────────────────────────────────────                          │
│  Día 3:                                                                 │
│  □ Migrar UC_020 (Asignar Roles)                                        │
│  □ Migrar UC_021 (Revocar Rol)                                          │
│  □ Migrar UC_022 (Gestionar Permisos por Rol)                           │
│  □ Migrar UC_023 (Ver Matriz de Permisos)                               │
│                                                                         │
│  LOTE 4: MÓDULOS Y PERFILES (UC_030-039) - 5 UC                         │
│  ───────────────────────────────────────────────                        │
│  Día 3-4:                                                               │
│  □ Migrar UC_030 (Asignar Módulos a Usuario)                            │
│  □ Migrar UC_031 (Crear Perfil de Módulos)                              │
│  □ Migrar UC_032 (Asignar Perfil a Usuario)                             │
│  □ Migrar UC_033 (Ver Módulos Disponibles)                              │
│  □ Migrar UC_034 (Configurar Permisos de Módulo)                        │
│                                                                         │
│  LOTE 5: SEGMENTOS (UC_040-049) - 3 UC                                  │
│  ─────────────────────────────────────                                  │
│  Día 4:                                                                 │
│  □ Migrar UC_040 (Gestionar Segmentos de Datos)                         │
│  □ Migrar UC_041 (Asignar Segmento a Usuario)                           │
│  □ Migrar UC_042 (Gestionar Permisos Directos)                          │
│                                                                         │
│  LOTE 6: DASHBOARD (UC_050-059) - 3-5 UC                                │
│  ─────────────────────────────────────────                              │
│  Día 5:                                                                 │
│  □ Crear UC_050 (Consultar Dashboard Principal)                         │
│  □ Crear UC_051 (Personalizar Dashboard)                                │
│  □ Crear UC_052 (Filtrar Métricas)                                      │
│  □ Crear UC_053 (Ver Detalle de Widget)                                 │
│                                                                         │
│  LOTE 7: REPORTES (UC_060-069) - 4 UC                                   │
│  ─────────────────────────────────────                                  │
│  Día 5-6:                                                               │
│  □ Crear UC_060 (Consultar Reporte Básico)                              │
│  □ Crear UC_061 (Consultar Reporte Avanzado)                            │
│  □ Crear UC_062 (Crear Reporte Personalizado)                           │
│  □ Crear UC_063 (Programar Generación Automática)                       │
│                                                                         │
│  LOTE 8: EXPORTACIONES (UC_070-079) - 3 UC                              │
│  ───────────────────────────────────────────                            │
│  Día 6:                                                                 │
│  □ Crear UC_070 (Exportar a Excel)                                      │
│  □ Crear UC_071 (Exportar a CSV)                                        │
│  □ Crear UC_072 (Exportar a PDF)                                        │
│                                                                         │
│  LOTE 9: ALERTAS (UC_080-089) - 4 UC                                    │
│  ────────────────────────────────────                                   │
│  Día 6-7:                                                               │
│  □ Crear UC_080 (Ver Alertas)                                           │
│  □ Crear UC_081 (Configurar Alerta Personal)                            │
│  □ Crear UC_082 (Gestionar Alertas de Equipo)                           │
│  □ Crear UC_083 (Configurar Alertas Globales)                           │
│                                                                         │
│  LOTE 10: ADMINISTRACIÓN (UC_090-099) - 3 UC                            │
│  ───────────────────────────────────────────                            │
│  Día 7:                                                                 │
│  □ Crear UC_090 (Configurar Sistema)                                    │
│  □ Crear UC_091 (Ver Logs de Auditoría)                                 │
│  □ Crear UC_092 (Gestionar Parámetros)                                  │
│                                                                         │
│  LOTE 11: ETL (UC_100-109) - 2 UC                                       │
│  ────────────────────────────────                                       │
│  Día 7:                                                                 │
│  □ Crear UC_100 (Ejecutar ETL Manual)                                   │
│  □ Crear UC_101 (Ver Estado de Sincronización)                          │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.3 Fase 2: Derivación de FR

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    FASE 2: DERIVAR FR (3-5 días)                        │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  PROCESO POR UC:                                                        │
│  ───────────────                                                        │
│                                                                         │
│  Por cada UC migrado:                                                   │
│                                                                         │
│  1. ANALIZAR PASOS DEL FLUJO NORMAL                                     │
│     Cada paso → 1-5 FR atómicos                                         │
│                                                                         │
│  2. ANALIZAR FLUJOS ALTERNOS                                            │
│     Cada alterno → 2-4 FR adicionales                                   │
│                                                                         │
│  3. EXTRAER VALIDACIONES                                                │
│     Cada validación implícita → 1 FR                                    │
│                                                                         │
│  4. IDENTIFICAR FR DE SEGURIDAD                                         │
│     Autenticación, autorización, auditoría                              │
│                                                                         │
│  EJEMPLO UC_001 (Iniciar Sesión):                                       │
│  ─────────────────────────────────                                      │
│  Paso 1: Usuario ingresa credenciales                                   │
│    → FR_001_01: Sistema DEBE mostrar campos username y password         │
│    → FR_001_02: Campo password DEBE ocultar caracteres                  │
│                                                                         │
│  Paso 2: Sistema valida credenciales                                    │
│    → FR_001_03: Sistema DEBE verificar username existe                  │
│    → FR_001_04: Sistema DEBE comparar password hasheado                 │
│    → FR_001_05: Sistema DEBE usar bcrypt cost=12                        │
│                                                                         │
│  Paso 3: Sistema verifica estado de cuenta                              │
│    → FR_001_06: Sistema DEBE verificar cuenta activa                    │
│    → FR_001_07: Sistema DEBE verificar cuenta no bloqueada              │
│                                                                         │
│  Paso 4: Sistema genera token JWT                                       │
│    → FR_001_08: Sistema DEBE generar access_token (15 min)              │
│    → FR_001_09: Sistema DEBE generar refresh_token (7 días)             │
│    → FR_001_10: Token DEBE incluir user_id y roles                      │
│                                                                         │
│  Flujo Alterno: Credenciales inválidas                                  │
│    → FR_001_11: Sistema DEBE incrementar contador de intentos           │
│    → FR_001_12: Sistema DEBE bloquear tras 5 intentos fallidos          │
│    → FR_001_13: Bloqueo DEBE durar 30 minutos                           │
│                                                                         │
│  Total: 1 UC → 13+ FR                                                   │
│                                                                         │
│  RATIO ESTIMADO:                                                        │
│  ────────────────                                                       │
│  42 UC × 10 FR/UC promedio = ~420 FR                                    │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.4 Fase 3: Consolidación y Trazabilidad

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    FASE 3: CONSOLIDACIÓN (2 días)                       │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  PASO 3.1: ÍNDICES Y ORGANIZACIÓN                                       │
│  ─────────────────────────────────                                      │
│  □ Crear index.rst para cada categoría                                  │
│  □ Crear index.rst maestro de casos_uso/                                │
│  □ Verificar todos los :ref: funcionan                                  │
│                                                                         │
│  PASO 3.2: MATRIZ DE TRAZABILIDAD                                       │
│  ─────────────────────────────────                                      │
│  □ Crear RTM_Master.rst:                                                │
│                                                                         │
│    CNST → BR → BReq → UC → FR → TST                                     │
│                                                                         │
│    Ejemplo fila:                                                        │
│    CNST_005 | BR_003 | BReq_003 | UC_020 | FR_020_01-15 | TST_020       │
│                                                                         │
│  PASO 3.3: VALIDACIÓN DE COMPLETITUD                                    │
│  ────────────────────────────────────                                   │
│  □ Todo BR tiene al menos 1 UC que lo aplica                            │
│  □ Todo BReq tiene al menos 1 UC que lo implementa                      │
│  □ Todo UC tiene al menos 3 FR derivados                                │
│  □ Todo FR tiene criterio de aceptación                                 │
│                                                                         │
│  PASO 3.4: ACTUALIZAR ESTRUCTURA                                        │
│  ─────────────────────────────────                                      │
│  □ Actualizar ESTRUCTURA v2.0.0 → v2.1.0                                │
│  □ Reflejar los 42 UC reales (no solo 3)                                │
│  □ Documentar decisiones de numeración                                  │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 4. PLANTILLA RST PARA UC

### 4.1 Plantilla Estándar (basada en PARTE 2)

```rst
.. meta::
   :artefacto: UC_NNN
   :tipo: Caso de Uso
   :dominio: requisitos
   :subdominio: casos_uso
   :categoria: [autenticacion|usuarios|roles|modulos|...]
   :estado: Aprobado
   :version: 1.0.0
   :fecha_creacion: YYYY-MM-DD
   :ultimo_cambio: YYYY-MM-DD
   :autor: Equipo IACT
   :origen: [BR|CRUD|LARMAN|UI|STK]

.. _uc-nnn:

==============================================================================
UC_NNN: Nombre del Caso de Uso
==============================================================================

.. contents:: Contenido
   :local:
   :depth: 2

----

Identificacion
--------------

.. list-table::
   :widths: 25 75
   :stub-columns: 1

   * - ID
     - UC_NNN
   * - Nombre
     - [Verbo] [Objeto]
   * - Actor Primario
     - [Rol]
   * - Actores Secundarios
     - [Lista o "Ninguno"]
   * - Categoria
     - [autenticacion|usuarios|roles|...]
   * - Origen
     - [BR_XXX|CRUD(Entidad)|Larman|UI|Stakeholder]
   * - Prioridad
     - [Critica|Alta|Media|Baja]
   * - Frecuencia
     - [Muy frecuente|Frecuente|Moderado|Ocasional]

----

1. Descripcion
--------------

[1-3 oraciones describiendo el propósito del UC]

----

2. Precondiciones
-----------------

1. [Condición que debe ser verdadera ANTES de iniciar]
2. [Otra precondición]
3. ...

----

3. Trigger
----------

[Evento que inicia el caso de uso]

----

4. Flujo Normal
---------------

.. code-block:: text

   1. Actor [acción]
   2. Sistema [respuesta]
   3. Actor [acción]
   4. Sistema [respuesta]
   ...
   N. Sistema [estado final]

----

5. Flujos Alternos
------------------

5.1 FA-1: [Nombre del alterno]
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   Xa. [Condición que dispara el alterno]
   Xb. Sistema [acción alternativa]
   Xc. [Continúa en paso Y | UC termina]

5.2 FA-2: [Otro alterno]
^^^^^^^^^^^^^^^^^^^^^^^^

...

----

6. Postcondiciones
------------------

**Éxito:**

- [Estado del sistema tras ejecución exitosa]

**Fallo:**

- [Estado del sistema si UC falla]

----

7. Reglas de Negocio Aplicadas
------------------------------

.. list-table::
   :header-rows: 1
   :widths: 15 50 35

   * - BR
     - Cómo se Aplica
     - Ubicación en UC
   * - BR_001
     - [Descripción]
     - [Precondición|Paso N|FA-X]
   * - BR_003
     - [Descripción]
     - [Precondición|Paso N|FA-X]

----

8. Requisitos Funcionales Derivados
-----------------------------------

.. list-table::
   :header-rows: 1
   :widths: 20 60 20

   * - FR
     - Descripción
     - Origen (Paso)
   * - FR_NNN_01
     - Sistema DEBE [acción específica]
     - Paso 2
   * - FR_NNN_02
     - Sistema DEBE [acción específica]
     - Paso 4
   * - ...
     - ...
     - ...

----

9. Requerimientos No Funcionales
--------------------------------

- RNF-XX: [Performance, seguridad, usabilidad aplicable]

----

10. Trazabilidad
----------------

**Hacia Arriba:**

.. code-block:: text

   UC_NNN
     ├──▶ BReq_XXX: [Nombre]
     └──▶ BR_XXX: [Nombre] (si aplica)

**Hacia Abajo:**

.. code-block:: text

   UC_NNN
     ├──▶ FR_NNN_01
     ├──▶ FR_NNN_02
     └──▶ TST_NNN

----

11. Historial de Cambios
------------------------

.. list-table::
   :header-rows: 1
   :widths: 15 15 20 50

   * - Versión
     - Fecha
     - Autor
     - Cambios
   * - 1.0.0
     - YYYY-MM-DD
     - Equipo IACT
     - Creación inicial

----

Referencias
-----------

- :ref:`breq-xxx` - [Nombre]
- :ref:`br-xxx` - [Nombre]
```

---

## 5. ESTIMACIÓN REVISADA

### 5.1 Esfuerzo Total

```
FASE 0: Inventario y Decisiones
  • Listar UC existentes: 2 horas
  • Clasificar por técnica: 2 horas
  • Definir numeración: 1 hora
  • Crear mapeo: 1 hora
  Total Fase 0: 6 horas (1 día)

FASE 1: Migración de UC
  • 42 UC × 30 min/UC = 21 horas
  • Índices por categoría: 3 horas
  Total Fase 1: 24 horas (5-6 días)

FASE 2: Derivación de FR
  • 42 UC × 10 FR/UC × 5 min/FR = 35 horas
  • (Puede hacerse en paralelo con Fase 1)
  Total Fase 2: 35 horas (4-5 días)

FASE 3: Consolidación
  • RTM Master: 4 horas
  • Validación: 4 horas
  • Documentación: 2 horas
  Total Fase 3: 10 horas (2 días)

═══════════════════════════════════════
TOTAL ESTIMADO: 75 horas (~2 semanas)
═══════════════════════════════════════
```

---

## 6. PRÓXIMOS PASOS INMEDIATOS

```
ACCIÓN 1 (Hoy):
  ¿Puedes subir 2-3 archivos de UC de tu Obsidian?
  - UC-001 Iniciar Sesión
  - UC-006 Crear Usuario  
  - Cualquier UC de Dashboard/Reportes si existe

ACCIÓN 2 (Tras recibir ejemplos):
  Yo creo:
  - UC_001 completo en RST como piloto
  - FR_001_01-15 derivados
  - Validación de la plantilla

ACCIÓN 3 (Tras aprobar piloto):
  Comenzar Fase 1 Lote 1 (Autenticación)
```

---

**¿Este análisis aclara el proceso? ¿Qué ajustes necesitas?**
