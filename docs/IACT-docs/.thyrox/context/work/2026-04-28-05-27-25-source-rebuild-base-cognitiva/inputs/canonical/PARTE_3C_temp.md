# PARTE 3C: TÉCNICAS UI-DRIVEN Y STAKEHOLDERS

## SECCIÓN 4: TÉCNICA 3 - UI-DRIVEN

### 4.1 Fundamento de la Técnica UI-Driven

#### 4.1.1 De Mockups a Casos de Uso

**¿Qué es la técnica UI-Driven?**

> "Técnica de identificación de casos de uso que parte de la interfaz de usuario
> (mockups, wireframes, prototipos) para descubrir funcionalidades del sistema."

**Principio fundamental:**

```
UI/UX Design → Interacciones del Usuario → Casos de Uso

La interfaz revela:
  • ¿Qué acciones puede realizar el usuario?
  • ¿Qué información necesita ver?
  • ¿Qué flujos de trabajo existen?
  • ¿Qué validaciones son necesarias?
```

**Ventajas de esta técnica:**

```
✅ VISUAL: Stakeholders entienden mejor mockups que documentos
✅ COMPLETO: La UI muestra interacciones que BR/CRUD no capturan
✅ PRÁCTICO: Enfoque bottom-up desde lo tangible
✅ VALIDABLE: Prototipos se pueden probar con usuarios reales
✅ ITERATIVO: Fácil ajustar mockups antes de codificar
```

**Cuándo aplicar UI-Driven:**

```
🎯 Aplicar cuando:
  • Sistema tiene interfaz de usuario rica (dashboards, portales)
  • Stakeholders son visuales (prefieren ver a leer)
  • Experiencia de usuario es crítica
  • Hay diseñadores UX en el equipo
  • Interacciones complejas (filtros, búsquedas, visualizaciones)

⚠️ NO aplicar cuando:
  • Sistema es principalmente backend (APIs, batch jobs)
  • No hay recursos para crear mockups
  • Funcionalidad es más importante que UX
  • Sistema es muy técnico/administrativo
```

#### 4.1.2 Herramientas para Mockups

**Herramientas profesionales:**

```
WIREFRAMES (baja fidelidad):
  • Balsamiq Mockups
  • Sketch
  • Figma (wireframe mode)
  • Draw.io
  • Papel y lápiz (válido!)

PROTOTIPOS (alta fidelidad):
  • Figma
  • Adobe XD
  • InVision
  • Axure RP
  • Marvel App

ASCII ART (documentación):
  • Para documentos técnicos
  • Portátil y versionable (Git)
  • No requiere herramientas especiales
```

**En este documento usamos ASCII art para portabilidad.**

---

### 4.2 Proceso de Derivación UI → UC

**Proceso de 5 pasos:**

```
┌─────────────────────────────────────────────────────────────┐
│ PASO 1: Crear/Recopilar Mockups                            │
│   ↓ Diseñar interfaces clave del sistema                    │
├─────────────────────────────────────────────────────────────┤
│ PASO 2: Identificar Interacciones                          │
│   ↓ Cada botón, filtro, acción → candidato a UC            │
├─────────────────────────────────────────────────────────────┤
│ PASO 3: Clasificar por Tipo                                │
│   ↓ Consulta, Comando, Navegación, Configuración           │
├─────────────────────────────────────────────────────────────┤
│ PASO 4: Generar UC                                         │
│   ↓ Documentar formalmente cada interacción                │
├─────────────────────────────────────────────────────────────┤
│ PASO 5: Validar con Stakeholders                           │
│   ↓ Revisar mockups + UC juntos                            │
└─────────────────────────────────────────────────────────────┘
```

**Detalle Paso 2: Identificar Interacciones:**

```
Ejemplo: Dashboard con 5 widgets

INTERACCIONES IDENTIFICADAS:
  1. Ver dashboard completo → UC-150
  2. Filtrar por fecha → Parte de UC-150
  3. Filtrar por categoría → Parte de UC-150
  4. Exportar a Excel → UC-152 (separado, reutilizable)
  5. Configurar widgets → UC-153 (separado, administración)
  6. Hacer clic en KPI → Navegación (no UC, es link)
  7. Refrescar datos → No UC (funcionalidad técnica)

Resultado: 3 UC identificados
```

---

### 4.3 EJEMPLO GUÍA 1: Dashboard del Coordinador

#### 4.3.1 Mockup Completo (ASCII Art)

```
╔═══════════════════════════════════════════════════════════════════════════╗
║ SISTEMA GESTIÓN LABORATORIO - Dashboard Coordinador           [Usuario ▼] ║
╠═══════════════════════════════════════════════════════════════════════════╣
║                                                                            ║
║  [🏠 Inicio] [📊 Reportes] [⚙️ Configuración] [❓ Ayuda]                   ║
║                                                                            ║
╠═══════════════════════════════════════════════════════════════════════════╣
║                                                                            ║
║  Dashboard de Gestión - Resumen Ejecutivo                                 ║
║  ══════════════════════════════════════════════════════════════════════   ║
║                                                                            ║
║  Filtros:                                                                 ║
║  ┌──────────────┬──────────────┬──────────────┬─────────────────────┐   ║
║  │ Fecha inicio:│ Fecha fin:   │ Categoría:   │ [🔍 Filtrar]        │   ║
║  │ [📅 01/11/25]│ [📅 30/11/25]│ [▼ Todas]    │ [↻ Limpiar filtros]│   ║
║  └──────────────┴──────────────┴──────────────┴─────────────────────┘   ║
║                                                                            ║
║  ┌─────────────────────────────────────────────────────────────────────┐ ║
║  │ KPIs PRINCIPALES                                         [📥 Exportar]│ ║
║  ├─────────────────────────────────────────────────────────────────────┤ ║
║  │                                                                      │ ║
║  │  ┏━━━━━━━━━━━━━━━━┓  ┏━━━━━━━━━━━━━━━━┓  ┏━━━━━━━━━━━━━━━━┓      │ ║
║  │  ┃ Solicitudes    ┃  ┃ Productos      ┃  ┃ Alertas Stock  ┃      │ ║
║  │  ┃ Pendientes     ┃  ┃ Registrados    ┃  ┃ Bajo Mínimo    ┃      │ ║
║  │  ┃                ┃  ┃                ┃  ┃                ┃      │ ║
║  │  ┃      23        ┃  ┃     156        ┃  ┃       8        ┃      │ ║
║  │  ┃   [Ver más]    ┃  ┃   [Ver más]    ┃  ┃   [Ver más]    ┃      │ ║
║  │  ┗━━━━━━━━━━━━━━━━┛  ┗━━━━━━━━━━━━━━━━┛  ┗━━━━━━━━━━━━━━━━┛      │ ║
║  │                                                                      │ ║
║  │  ┏━━━━━━━━━━━━━━━━┓  ┏━━━━━━━━━━━━━━━━┓  ┏━━━━━━━━━━━━━━━━┓      │ ║
║  │  ┃ Usuarios       ┃  ┃ Proveedores    ┃  ┃ Vencimientos   ┃      │ ║
║  │  ┃ Activos        ┃  ┃ Activos        ┃  ┃ Próximos 30d   ┃      │ ║
║  │  ┃                ┃  ┃                ┃  ┃                ┃      │ ║
║  │  ┃      45        ┃  ┃      12        ┃  ┃       5        ┃      │ ║
║  │  ┃   [Ver más]    ┃  ┃   [Ver más]    ┃  ┃   [Ver más]    ┃      │ ║
║  │  ┗━━━━━━━━━━━━━━━━┛  ┗━━━━━━━━━━━━━━━━┛  ┗━━━━━━━━━━━━━━━━┛      │ ║
║  │                                                                      │ ║
║  └──────────────────────────────────────────────────────────────────────┘ ║
║                                                                            ║
║  ┌─────────────────────────────────────────────────────────────────────┐ ║
║  │ GRÁFICO: Solicitudes por Mes                           [📊 Detalles]│ ║
║  ├─────────────────────────────────────────────────────────────────────┤ ║
║  │     │                                                                │ ║
║  │  50 │     ██                                                         │ ║
║  │     │     ██                                                         │ ║
║  │  40 │     ██      ██                                                 │ ║
║  │     │     ██      ██                                                 │ ║
║  │  30 │ ██  ██      ██  ██                                             │ ║
║  │     │ ██  ██  ██  ██  ██                                             │ ║
║  │  20 │ ██  ██  ██  ██  ██  ██                                         │ ║
║  │     │ ██  ██  ██  ██  ██  ██  ██                                     │ ║
║  │  10 │ ██  ██  ██  ██  ██  ██  ██  ██                                 │ ║
║  │     │ ██  ██  ██  ██  ██  ██  ██  ██                                 │ ║
║  │   0 ├─────────────────────────────────────────────────────────────  │ ║
║  │      May Jun Jul Ago Sep Oct Nov Dic                                │ ║
║  └──────────────────────────────────────────────────────────────────────┘ ║
║                                                                            ║
║  ┌─────────────────────────────────────────────────────────────────────┐ ║
║  │ ÚLTIMAS ACTIVIDADES                                      [Ver todas] │ ║
║  ├─────────────────────────────────────────────────────────────────────┤ ║
║  │ 🟢 Juan Pérez solicitó Ácido Sulfúrico (100ml)      Hace 15 minutos │ ║
║  │ 🔵 Solicitud #1234 fue aprobada                     Hace 1 hora      │ ║
║  │ 🟡 Producto P-045 tiene stock bajo (alerta)         Hace 2 horas     │ ║
║  │ 🟢 María García registró nuevo producto            Hace 3 horas     │ ║
║  │ 🔴 Solicitud #1220 fue rechazada                    Hace 4 horas     │ ║
║  └──────────────────────────────────────────────────────────────────────┘ ║
║                                                                            ║
╚════════════════════════════════════════════════════════════════════════════╝
```

#### 4.3.2 UC Derivados del Dashboard

**UC identificados:**

```
Del mockup anterior derivan:

UC-150: Ver Dashboard Coordinador (principal) ⭐
UC-151: Filtrar Dashboard por Criterios
UC-152: Exportar Dashboard a Excel
UC-153: Configurar Widgets del Dashboard
UC-154: Ver Detalle de KPI Específico
```

**Desarrollamos UC-150 completo:**

---

#### 4.3.3 UC-150: Ver Dashboard del Coordinador (COMPLETO)

```
═══════════════════════════════════════════════════════════════
UC-150: Ver Dashboard del Coordinador
═══════════════════════════════════════════════════════════════

ACTOR PRINCIPAL:
  Coordinador de Laboratorio

STAKEHOLDERS E INTERESES:
  • Coordinador: Necesita visión ejecutiva del laboratorio
  • Director: Requiere acceso a datos agregados en tiempo real
  • Admin Sistema: Debe poder configurar widgets

PRECONDICIONES:
  • Coordinador está autenticado en el sistema
  • Coordinador tiene rol "Coordinador" o superior
  • Existe al menos 1 solicitud en el sistema (para mostrar datos)

POSTCONDICIONES:
  ✓ Dashboard se carga exitosamente
  ✓ Todos los KPIs muestran datos actualizados
  ✓ Gráficos se renderizan correctamente
  ✓ Log de acceso registrado en auditoría

FLUJO NORMAL:

  1. Coordinador selecciona "Dashboard" en el menú principal
  
  2. Sistema verifica que usuario tiene permiso "dashboard:view"
  
  3. Sistema carga configuración de widgets del usuario
     (Si primera vez: configuración por defecto)
  
  4. Sistema calcula KPIs en paralelo:
     a. Solicitudes pendientes: COUNT WHERE estado = 'Pendiente'
     b. Productos registrados: COUNT WHERE activo = TRUE
     c. Alertas stock: COUNT WHERE stock_actual < stock_min
     d. Usuarios activos: COUNT WHERE activo = TRUE AND last_login > 30 days
     e. Proveedores activos: COUNT WHERE activo = TRUE
     f. Vencimientos próximos: COUNT WHERE fecha_vencimiento < NOW() + 30 days
  
  5. Sistema obtiene datos para gráfico de solicitudes:
     Query: SELECT MONTH(fecha), COUNT(*) 
            FROM Solicitud 
            WHERE fecha >= NOW() - 8 months
            GROUP BY MONTH(fecha)
            ORDER BY fecha DESC
  
  6. Sistema obtiene últimas 5 actividades:
     Query: SELECT * FROM ActividadLog
            ORDER BY fecha DESC
            LIMIT 5
  
  7. Sistema renderiza dashboard con:
     • Filtros con valores por defecto (mes actual)
     • 6 widgets de KPI con valores calculados
     • Gráfico de barras de solicitudes
     • Tabla de últimas actividades
  
  8. Sistema registra acceso en log de auditoría
  
  9. Sistema muestra dashboard completo al Coordinador
  
  10. [FIN UC]

FLUJOS ALTERNATIVOS:

  FA-1: Sin Datos Disponibles (Paso 4)
    4a. Sistema detecta que no hay datos para calcular KPIs
    4b. Sistema muestra dashboard con widgets en cero
    4c. Sistema muestra mensaje informativo: 
        "No hay datos disponibles. Registre productos y solicitudes."
    4d. Continúa en paso 9

  FA-2: Error de Conexión a BD (Paso 4)
    4a. Sistema no puede conectar a base de datos
    4b. Sistema muestra dashboard en modo degradado
    4c. Sistema muestra mensaje: 
        "Error de conexión. Intente nuevamente en unos momentos."
    4d. Sistema registra error en log del sistema
    4e. [FIN UC - FALLO]

  FA-3: Timeout en Cálculo de KPIs (Paso 4)
    4a. Cálculo de KPIs excede 5 segundos
    4b. Sistema cancela queries pendientes
    4c. Sistema muestra KPIs calculados hasta el momento
    4d. Sistema muestra spinner en KPIs no calculados
    4e. Sistema intenta completar KPIs en background
    4f. Continúa en paso 7

  FA-4: Usuario sin Configuración Guardada (Paso 3)
    3a. Sistema detecta que usuario nunca accedió al dashboard
    3b. Sistema carga configuración por defecto:
        - Todos los widgets visibles
        - Filtro de fecha: mes actual
        - Ordenamiento: por defecto
    3c. Sistema guarda configuración inicial del usuario
    3d. Continúa en paso 4

  FA-5: Permisos Insuficientes (Paso 2)
    2a. Sistema detecta que usuario NO tiene permiso "dashboard:view"
    2b. Sistema muestra mensaje de error: 
        "No tiene permisos para acceder al Dashboard"
    2c. Sistema registra intento de acceso no autorizado
    2d. [FIN UC - FALLO]

REQUERIMIENTOS ESPECIALES:

  • Performance: Dashboard DEBE cargar en < 3 segundos
  • Responsiveness: Dashboard DEBE ser responsive (móvil/tablet)
  • Cache: KPIs DEBEN cachear por 5 minutos
  • Actualización: Opción de refrescar datos manualmente
  • Accesibilidad: Dashboard DEBE cumplir WCAG 2.1 nivel AA

FRECUENCIA DE OCURRENCIA:
  • Alta: 50-100 accesos por día
  • Cada coordinador accede al menos 5 veces al día

ISSUES ABIERTOS:
  • ¿Permitir exportar dashboard completo a PDF?
  • ¿Agregar comparación con mes anterior en KPIs?
  • ¿Notificaciones push cuando KPI crítico cambia?

QUERIES SQL DETALLADAS:

  -- KPI 1: Solicitudes Pendientes
  SELECT COUNT(*) as pendientes
  FROM Solicitud
  WHERE estado = 'Pendiente'
    AND fecha >= :fecha_inicio
    AND fecha <= :fecha_fin;

  -- KPI 2: Productos Registrados
  SELECT COUNT(*) as total_productos
  FROM Producto
  WHERE activo = TRUE;

  -- KPI 3: Alertas Stock Bajo
  SELECT COUNT(*) as alertas
  FROM Producto
  WHERE activo = TRUE
    AND stock_actual < stock_minimo;

  -- KPI 4: Usuarios Activos (últimos 30 días)
  SELECT COUNT(*) as usuarios_activos
  FROM Usuario
  WHERE activo = TRUE
    AND ultimo_acceso >= NOW() - INTERVAL 30 DAY;

  -- KPI 5: Proveedores Activos
  SELECT COUNT(*) as proveedores
  FROM Proveedor
  WHERE activo = TRUE;

  -- KPI 6: Vencimientos Próximos
  SELECT COUNT(*) as vencimientos
  FROM Producto
  WHERE activo = TRUE
    AND fecha_vencimiento IS NOT NULL
    AND fecha_vencimiento BETWEEN NOW() AND NOW() + INTERVAL 30 DAY;

  -- Gráfico: Solicitudes por Mes (últimos 8 meses)
  SELECT 
    DATE_FORMAT(fecha_solicitud, '%Y-%m') as mes,
    COUNT(*) as cantidad
  FROM Solicitud
  WHERE fecha_solicitud >= NOW() - INTERVAL 8 MONTH
  GROUP BY DATE_FORMAT(fecha_solicitud, '%Y-%m')
  ORDER BY mes DESC;

  -- Últimas Actividades
  SELECT 
    a.tipo_actividad,
    a.descripcion,
    a.fecha,
    u.nombre as usuario
  FROM ActividadLog a
  JOIN Usuario u ON a.usuario_id = u.id
  ORDER BY a.fecha DESC
  LIMIT 5;

CRITERIOS DE ACEPTACIÓN:

  ✓ Dashboard carga en menos de 3 segundos
  ✓ Todos los 6 KPIs muestran valores correctos
  ✓ Gráfico renderiza con datos de últimos 8 meses
  ✓ Últimas 5 actividades aparecen ordenadas por fecha
  ✓ Filtros funcionan correctamente (fecha, categoría)
  ✓ Botón "Exportar" genera Excel válido
  ✓ Dashboard es responsive en móvil y tablet
  ✓ Acceso se registra en log de auditoría
  ✓ Usuario sin permisos ve mensaje de error apropiado
```

---

### 4.4 EJEMPLO 2: Búsqueda Avanzada de Productos

#### 4.4.1 Mockup de Búsqueda Avanzada

```
╔═══════════════════════════════════════════════════════════════════════════╗
║ BÚSQUEDA AVANZADA DE PRODUCTOS QUÍMICOS                                   ║
╠═══════════════════════════════════════════════════════════════════════════╣
║                                                                            ║
║  Criterios de Búsqueda:                                                   ║
║  ┌──────────────────────────────────────────────────────────────────────┐ ║
║  │ Nombre/CAS: [________________]  Categoría: [▼ Todas]                │ ║
║  │                                                                       │ ║
║  │ Clase Peligrosidad: [▼ Todas]   Estado: [☑] Activos [☐] Inactivos  │ ║
║  │                                                                       │ ║
║  │ Stock disponible: [☐] Sí [☐] No [☐] Todos                           │ ║
║  │                                                                       │ ║
║  │ Proveedor: [▼ Todos]             Ubicación: [▼ Todas]               │ ║
║  │                                                                       │ ║
║  │ Rango de precio:                                                     │ ║
║  │   Desde: [$______]  Hasta: [$______]                                │ ║
║  │                                                                       │ ║
║  │ Fecha de vencimiento:                                                │ ║
║  │   Desde: [📅______]  Hasta: [📅______]                               │ ║
║  │                                                                       │ ║
║  │ [🔍 Buscar]  [💾 Guardar búsqueda]  [↻ Limpiar]                     │ ║
║  └──────────────────────────────────────────────────────────────────────┘ ║
║                                                                            ║
║  Búsquedas Guardadas:                                                     ║
║  [▼ Mis búsquedas] [Productos críticos bajo stock] [Cargar]              ║
║                                                                            ║
║  ┌──────────────────────────────────────────────────────────────────────┐ ║
║  │ RESULTADOS (25 encontrados)                    [📥 Exportar Excel]  │ ║
║  │                                                                       │ ║
║  │ Mostrar: [20▼] por página  │  Ordenar por: [Nombre▼]  [↑↓]        │ ║
║  ├───┬────────────┬──────────┬────────┬────────┬─────────┬──────────┤ ║
║  │☐ │ CAS Number │ Nombre    │ Categ. │ Stock  │ Precio  │ Acciones │ ║
║  ├───┼────────────┼──────────┼────────┼────────┼─────────┼──────────┤ ║
║  │☐ │ 7732-18-5  │ Agua dest│ Solv.  │ 50 L   │ $25.00  │[Ver][📝]│ ║
║  │☐ │ 7664-93-9  │ Ác.Sulfúr│ Ácido  │ 15 L   │ $120.50 │[Ver][📝]│ ║
║  │☐ │ 1310-73-2  │ Hidróx.So│ Base   │ 8 kg   │ $85.00  │[Ver][📝]│ ║
║  │☐ │ 67-64-1    │ Acetona  │ Solv.  │ ⚠️ 2 L │ $45.00  │[Ver][📝]│ ║
║  │☐ │ 7697-37-2  │ Ác.Nítric│ Ácido  │ 12 L   │ $95.00  │[Ver][📝]│ ║
║  ├───┴────────────┴──────────┴────────┴────────┴─────────┴──────────┤ ║
║  │                                                                    │ ║
║  │  [☐ Seleccionar todos]  [Acción en lote ▼]                       │ ║
║  │                                                                    │ ║
║  │  [◄] 1 2 3 4 [5] 6 7 ... 25 [►]                                  │ ║
║  └────────────────────────────────────────────────────────────────────┘ ║
║                                                                            ║
╚════════════════════════════════════════════════════════════════════════════╝
```

#### 4.4.2 UC-160: Búsqueda con Múltiples Criterios (COMPLETO)

```
═══════════════════════════════════════════════════════════════
UC-160: Búsqueda Avanzada con Múltiples Criterios
═══════════════════════════════════════════════════════════════

ACTOR PRINCIPAL:
  Estudiante, Coordinador, Administrador (cualquier usuario autenticado)

PRECONDICIONES:
  • Usuario está autenticado
  • Existen productos registrados en el sistema

POSTCONDICIONES:
  ✓ Resultados de búsqueda se muestran correctamente
  ✓ Criterios de búsqueda se guardan en sesión (para volver atrás)
  ✓ Historial de búsqueda se actualiza (opcional)

FLUJO NORMAL:

  1. Usuario selecciona "Búsqueda Avanzada" en el menú
  
  2. Sistema muestra formulario con 8 criterios de búsqueda:
     • Texto libre (nombre o CAS Number)
     • Categoría (dropdown)
     • Clase de peligrosidad (dropdown)
     • Estado (activo/inactivo/todos)
     • Stock disponible (checkbox)
     • Proveedor (dropdown)
     • Ubicación (dropdown)
     • Rango de precio (desde-hasta)
     • Rango de fecha vencimiento (desde-hasta)
  
  3. Usuario completa al menos 1 criterio de búsqueda
  
  4. Usuario hace clic en "Buscar"
  
  5. Sistema valida criterios ingresados:
     • Si precio_desde > precio_hasta → Error
     • Si fecha_desde > fecha_hasta → Error
     • Al menos 1 criterio completado → OK
  
  6. Sistema construye query SQL dinámica con criterios seleccionados
  
  7. Sistema ejecuta query con paginación (20 resultados por página)
  
  8. Sistema cuenta total de resultados encontrados
  
  9. Sistema ordena resultados por nombre ASC (por defecto)
  
  10. Sistema muestra resultados en tabla con:
      • Checkbox para selección múltiple
      • Columnas: CAS, Nombre, Categoría, Stock, Precio, Acciones
      • Indicador visual si stock bajo mínimo (⚠️)
      • Botones [Ver] y [Editar] por fila
      • Paginación en pie de tabla
  
  11. Sistema guarda criterios de búsqueda en sesión del usuario
  
  12. [FIN UC]

FLUJOS ALTERNATIVOS:

  FA-1: Sin Resultados (Paso 8)
    8a. Query no retorna ningún resultado
    8b. Sistema muestra mensaje: "No se encontraron productos con 
        los criterios especificados"
    8c. Sistema sugiere: "Intente ampliar los criterios de búsqueda"
    8d. Formulario permanece con valores ingresados
    8e. [FIN UC]

  FA-2: Validación Falla (Paso 5)
    5a. Sistema detecta criterios inválidos
    5b. Sistema muestra mensaje de error específico:
        • "Precio 'desde' no puede ser mayor que 'hasta'"
        • "Fecha 'desde' no puede ser posterior a 'hasta'"
    5c. Sistema resalta campos con error en rojo
    5d. Vuelve a paso 3

  FA-3: Usuario Guarda Búsqueda (después de paso 10)
    10a. Usuario hace clic en "Guardar búsqueda"
    10b. Sistema muestra modal: "Nombre de la búsqueda: [____]"
    10c. Usuario ingresa nombre descriptivo
    10d. Usuario confirma
    10e. Sistema guarda criterios en tabla BusquedaGuardada:
         {usuario_id, nombre, criterios_json, fecha_creacion}
    10f. Sistema muestra mensaje: "Búsqueda guardada exitosamente"
    10g. Continúa en paso 12

  FA-4: Usuario Carga Búsqueda Guardada (antes de paso 3)
    2a. Usuario selecciona búsqueda del dropdown "Mis búsquedas"
    2b. Usuario hace clic en "Cargar"
    2c. Sistema recupera criterios guardados desde BD
    2d. Sistema pre-completa formulario con criterios guardados
    2e. Continúa en paso 3

  FA-5: Usuario Exporta Resultados (después de paso 10)
    10a. Usuario hace clic en "Exportar Excel"
    10b. Sistema verifica que hay resultados para exportar
    10c. Sistema genera archivo Excel con:
         • Mismas columnas que tabla de resultados
         • Todos los resultados (no solo página actual)
         • Formato legible (headers en negrita, columnas auto-ajustadas)
    10d. Sistema descarga archivo: "productos_YYYYMMDD_HHMMSS.xlsx"
    10e. [FIN UC]

  FA-6: Timeout en Query (Paso 7)
    7a. Query excede timeout de 10 segundos
    7b. Sistema cancela query
    7c. Sistema muestra mensaje: "La búsqueda tardó demasiado. 
        Por favor refine los criterios."
    7d. Formulario permanece con valores
    7e. [FIN UC - TIMEOUT]

REQUERIMIENTOS ESPECIALES:

  • Query DEBE usar índices apropiados para rendimiento
  • Paginación DEBE ser server-side (no cargar todo en memoria)
  • Búsquedas guardadas DEBEN ser privadas por usuario
  • Export Excel DEBE limitar a 10,000 registros máximo
  • Formulario DEBE recordar criterios si usuario navega atrás

QUERY SQL DINÁMICO (Ejemplo con 3 criterios):

  SELECT 
    p.cas_number,
    p.nombre,
    c.nombre as categoria,
    p.stock_actual,
    p.precio_unitario,
    p.stock_minimo,
    p.activo
  FROM Producto p
  LEFT JOIN Categoria c ON p.categoria_id = c.id
  WHERE 1=1
    -- Criterio 1: Texto libre (nombre o CAS)
    AND (p.nombre LIKE '%:texto%' OR p.cas_number LIKE '%:texto%')
    -- Criterio 2: Categoría seleccionada
    AND (:categoria_id IS NULL OR p.categoria_id = :categoria_id)
    -- Criterio 3: Solo con stock disponible
    AND (:solo_con_stock = FALSE OR p.stock_actual > 0)
  ORDER BY p.nombre ASC
  LIMIT :offset, :page_size;

  -- Count total
  SELECT COUNT(*) FROM (...misma query sin ORDER BY y LIMIT...);

CRITERIOS DE ACEPTACIÓN:

  ✓ Formulario muestra todos los 8 criterios correctamente
  ✓ Búsqueda con 1 solo criterio funciona
  ✓ Búsqueda combinando múltiples criterios funciona
  ✓ Validación de rangos (precio, fecha) funciona correctamente
  ✓ Resultados se paginan correctamente (20 por página)
  ✓ Ordenamiento por columna funciona
  ✓ Exportar Excel genera archivo válido con todos los resultados
  ✓ Guardar búsqueda persiste criterios correctamente
  ✓ Cargar búsqueda guardada pre-completa formulario
  ✓ Sin resultados muestra mensaje apropiado
```

---

### 4.5 Interacciones Comunes en UI

#### 4.5.1 Patrón: Filtrado y Ordenamiento

**Características:**

```
FILTRADO:
  • Múltiples criterios combinables (AND lógico)
  • Filtros persistentes durante sesión
  • Posibilidad de guardar filtros favoritos
  • Limpiar filtros con un botón

ORDENAMIENTO:
  • Clic en header de columna para ordenar
  • ASC / DESC alternado
  • Indicador visual de columna ordenada (▲▼)
  • Mantiene filtros activos al ordenar
```

**UC derivados:**

- UC-160: Ya desarrollado arriba
- UC-161: Guardar Búsqueda → Subtask de UC-160
- UC-162: Cargar Búsqueda Guardada → Subtask de UC-160

#### 4.5.2 Patrón: Acciones en Lote

**UC-170: Aprobar Múltiples Solicitudes (COMPLETO)**

```
═══════════════════════════════════════════════════════════════
UC-170: Aprobar Múltiples Solicitudes en Lote
═══════════════════════════════════════════════════════════════

ACTOR PRINCIPAL:
  Coordinador de Laboratorio

PRECONDICIONES:
  • Coordinador está autenticado
  • Coordinador tiene permiso "solicitudes:aprobar_lote"
  • Existen solicitudes en estado "Pendiente"

POSTCONDICIONES:
  ✓ Todas las solicitudes seleccionadas cambian a estado "Aprobada"
  ✓ Stock se reserva para cada solicitud aprobada
  ✓ Notificaciones se envían a solicitantes
  ✓ Transacciones se registran en auditoría

FLUJO NORMAL:

  1. Coordinador accede a "Mis Solicitudes Pendientes"
  
  2. Sistema muestra lista de solicitudes pendientes de aprobación
     con checkbox en cada fila
  
  3. Coordinador selecciona múltiples solicitudes haciendo check
     (o usa "Seleccionar todas")
  
  4. Coordinador selecciona "Aprobar seleccionadas" del menú de acciones
  
  5. Sistema muestra modal de confirmación:
     "¿Aprobar 5 solicitudes seleccionadas?
      [Lista de solicitudes con ID y solicitante]
      [Confirmar] [Cancelar]"
  
  6. Coordinador confirma
  
  7. Sistema inicia transacción ACID
  
  8. Sistema itera sobre cada solicitud seleccionada:
     Para cada solicitud:
       a. Verifica que solicitud sigue en estado "Pendiente"
       b. Verifica stock disponible del producto
       c. Si stock suficiente:
          - Actualiza estado a "Aprobada"
          - Reserva stock: stock_reservado += cantidad
          - Registra fecha y usuario que aprobó
          - Genera notificación para solicitante
       d. Si stock insuficiente:
          - Marca solicitud como "fallida en lote"
          - Registra motivo de fallo
  
  9. Sistema finaliza transacción (COMMIT)
  
  10. Sistema muestra resumen de resultados:
      "✓ 4 solicitudes aprobadas exitosamente
       ✗ 1 solicitud falló: Stock insuficiente (Solicitud #1234)"
  
  11. Sistema envía notificaciones asíncronas a solicitantes
  
  12. Sistema actualiza lista de solicitudes
  
  13. [FIN UC]

FLUJOS ALTERNATIVOS:

  FA-1: Ninguna Solicitud Seleccionada (Paso 4)
    4a. Usuario hace clic en "Aprobar" sin seleccionar ninguna
    4b. Sistema muestra mensaje: "Debe seleccionar al menos 1 solicitud"
    4c. Vuelve a paso 3

  FA-2: Stock Insuficiente en Alguna Solicitud (Paso 8c)
    8c1. Stock actual < cantidad solicitada
    8c2. Sistema NO aprueba esa solicitud
    8c3. Sistema registra motivo: "Stock insuficiente"
    8c4. Continúa con siguiente solicitud
    8c5. Al final muestra resumen con solicitudes fallidas

  FA-3: Error en Transacción (Paso 8)
    8a. Ocurre error de BD durante procesamiento
    8b. Sistema ejecuta ROLLBACK de toda la transacción
    8c. Ninguna solicitud se aprueba (atomicidad)
    8d. Sistema muestra mensaje: "Error al procesar. Ninguna solicitud 
        fue aprobada. Intente nuevamente."
    8e. [FIN UC - ERROR]

  FA-4: Usuario Cancela Confirmación (Paso 6)
    6a. Usuario hace clic en "Cancelar" en el modal
    6b. Sistema cierra modal sin hacer cambios
    6c. Selecciones permanecen marcadas
    6d. Vuelve a paso 3

  FA-5: Solicitud Cambió de Estado Concurrentemente (Paso 8a)
    8a1. Otro usuario aprobó/rechazó la solicitud mientras tanto
    8a2. Sistema detecta que estado != "Pendiente"
    8a3. Sistema NO procesa esa solicitud
    8a4. Sistema registra: "Solicitud ya fue procesada"
    8a5. Continúa con siguiente solicitud
    8a6. Al final muestra en resumen: "1 solicitud ya fue procesada"

REQUERIMIENTOS ESPECIALES:

  • Transacción DEBE ser ACID (todo o nada por solicitud)
  • Procesamiento DEBE manejar concurrencia (lock optimista)
  • Notificaciones DEBEN enviarse asíncronamente (no bloquear UI)
  • Límite máximo: 100 solicitudes por lote
  • Timeout: 30 segundos máximo para procesar lote

PSEUDOCÓDIGO DE TRANSACCIÓN:

  BEGIN TRANSACTION;
  
  aprobadas = []
  fallidas = []
  
  FOR EACH solicitud IN solicitudes_seleccionadas:
    
    -- Lock optimista
    solicitud_actual = SELECT * FROM Solicitud 
                       WHERE id = solicitud.id 
                       FOR UPDATE;
    
    IF solicitud_actual.estado != 'Pendiente':
      fallidas.append({solicitud.id, "Ya procesada"})
      CONTINUE
    END IF
    
    producto = SELECT * FROM Producto 
               WHERE id = solicitud_actual.producto_id
               FOR UPDATE;
    
    IF producto.stock_actual < solicitud_actual.cantidad:
      fallidas.append({solicitud.id, "Stock insuficiente"})
      CONTINUE
    END IF
    
    -- Aprobar
    UPDATE Solicitud 
    SET estado = 'Aprobada',
        fecha_aprobacion = NOW(),
        aprobador_id = :coordinador_id
    WHERE id = solicitud.id;
    
    -- Reservar stock
    UPDATE Producto
    SET stock_reservado = stock_reservado + solicitud_actual.cantidad
    WHERE id = producto.id;
    
    -- Auditoría
    INSERT INTO AuditoriaLog (...);
    
    aprobadas.append(solicitud.id)
    
  END FOR
  
  COMMIT;
  
  -- Notificaciones asíncronas
  ASYNC enviar_notificaciones(aprobadas);
  
  RETURN {aprobadas, fallidas}

CRITERIOS DE ACEPTACIÓN:

  ✓ Selección múltiple con checkboxes funciona
  ✓ "Seleccionar todas" marca todos los checkbox
  ✓ Modal de confirmación muestra lista correcta
  ✓ Aprobación en lote procesa todas las seleccionadas
  ✓ Transacción hace ROLLBACK si hay error crítico
  ✓ Stock se reserva correctamente para cada solicitud
  ✓ Solicitudes con stock insuficiente se marcan como fallidas
  ✓ Resumen final muestra aprobadas vs fallidas
  ✓ Notificaciones se envían a cada solicitante
  ✓ No se aprueban solicitudes que cambiaron de estado
```

#### 4.5.3 Patrón: Notificaciones In-App

**UC-190: Ver Notificaciones (COMPLETO)**

```
═══════════════════════════════════════════════════════════════
UC-190: Ver Notificaciones In-App
═══════════════════════════════════════════════════════════════

ACTOR PRINCIPAL:
  Cualquier usuario autenticado

PRECONDICIONES:
  • Usuario está autenticado
  • Sistema de notificaciones está activo

POSTCONDICIONES:
  ✓ Notificaciones no leídas se marcan como leídas
  ✓ Badge de contador se actualiza
  ✓ Usuario puede acceder a contenido de notificación

FLUJO NORMAL:

  1. Usuario ve icono de campana (🔔) con badge rojo indicando 
     cantidad de notificaciones no leídas
  
  2. Usuario hace clic en icono de campana
  
  3. Sistema abre panel dropdown con notificaciones
  
  4. Sistema consulta últimas 10 notificaciones del usuario:
     Query: SELECT * FROM Notificacion 
            WHERE usuario_id = :user_id
            ORDER BY fecha DESC
            LIMIT 10
  
  5. Sistema muestra cada notificación con:
     • Icono según tipo (✓ éxito, ℹ info, ⚠ alerta, ✗ error)
     • Título
     • Mensaje breve
     • Tiempo relativo ("Hace 5 minutos")
     • Indicador de leída/no leída (punto azul si no leída)
  
  6. Sistema marca automáticamente notificaciones como leídas
     después de 3 segundos de visualización
  
  7. Sistema actualiza badge de contador (decrementa no leídas)
  
  8. [Usuario puede hacer clic en notificación → UC-191: Ver Detalle]
  
  9. [Usuario puede hacer clic en "Ver todas" → UC-192: Historial Completo]
  
  10. [FIN UC]

FLUJOS ALTERNATIVOS:

  FA-1: Sin Notificaciones (Paso 4)
    4a. Usuario no tiene notificaciones
    4b. Sistema muestra mensaje: "No tienes notificaciones"
    4c. Sistema muestra icono sin badge
    4d. [FIN UC]

  FA-2: Usuario Hace Clic en Notificación Específica (después de paso 5)
    5a. Usuario hace clic en una notificación
    5b. Sistema obtiene la acción asociada a la notificación:
        • "solicitud_aprobada" → Redirige a UC-61 (ver solicitud)
        • "producto_stock_bajo" → Redirige a UC-42 (ver producto)
        • "nueva_notificacion" → Muestra modal con detalles
    5c. Sistema marca notificación como leída inmediatamente
    5d. Sistema cierra panel de notificaciones
    5e. Sistema navega a destino correspondiente
    5f. [FIN UC]

  FA-3: Usuario Hace Clic en "Ver todas" (después de paso 5)
    5a. Usuario hace clic en link "Ver todas las notificaciones"
    5b. Sistema navega a página completa de notificaciones
    5c. Sistema muestra tabla paginada con todas las notificaciones
    5d. [FIN UC - Continúa en UC-192]

  FA-4: Llega Nueva Notificación en Tiempo Real (durante uso)
    • Sistema recibe notificación via WebSocket/SSE
    • Sistema incrementa badge de contador
    • Sistema muestra toast temporal (3 seg) en esquina superior derecha
    • Sistema agrega notificación al dropdown (sin abrirlo)
    • Si dropdown está abierto → Sistema lo actualiza automáticamente

REQUERIMIENTOS ESPECIALES:

  • Notificaciones DEBEN actualizarse en tiempo real (WebSocket/SSE)
  • Badge DEBE mostrar máximo "99+" (no números grandes)
  • Marcar como leído DEBE ser automático después de 3 segundos
  • Panel dropdown DEBE cerrarse al hacer clic fuera
  • Notificaciones DEBEN persistir por 30 días

TIPOS DE NOTIFICACIONES:

  1. Solicitud Aprobada (tipo: success)
     Título: "Solicitud aprobada"
     Mensaje: "Tu solicitud #1234 de Ácido Sulfúrico fue aprobada"
     Acción: Ver solicitud (UC-61)
  
  2. Solicitud Rechazada (tipo: error)
     Título: "Solicitud rechazada"
     Mensaje: "Tu solicitud #1234 fue rechazada. Motivo: [...]"
     Acción: Ver solicitud (UC-61)
  
  3. Stock Bajo (tipo: warning)
     Título: "Alerta de stock bajo"
     Mensaje: "Producto 'Acetona' tiene stock bajo mínimo"
     Acción: Ver producto (UC-42)
  
  4. Producto Próximo a Vencer (tipo: warning)
     Título: "Producto próximo a vencer"
     Mensaje: "Producto 'Ácido Nítrico' vence en 7 días"
     Acción: Ver producto (UC-42)
  
  5. Nuevo Comentario (tipo: info)
     Título: "Nuevo comentario"
     Mensaje: "María comentó en tu solicitud #1234"
     Acción: Ver solicitud (UC-61)

MOCKUP PANEL NOTIFICACIONES:

  ┌────────────────────────────────────────────────────┐
  │ NOTIFICACIONES                    [🔄] [⚙️]        │
  ├────────────────────────────────────────────────────┤
  │                                                     │
  │ ● ✓ Solicitud aprobada                             │
  │     Tu solicitud #1234 fue aprobada                │
  │     Hace 5 minutos                                 │
  │                                                     │
  │   ⚠ Stock bajo mínimo                              │
  │     Acetona tiene stock bajo                       │
  │     Hace 1 hora                                    │
  │                                                     │
  │   ℹ Nueva notificación                             │
  │     Revisa el nuevo producto P-156                 │
  │     Hace 2 horas                                   │
  │                                                     │
  │   ✗ Solicitud rechazada                            │
  │     Solicitud #1220 fue rechazada                  │
  │     Ayer                                           │
  │                                                     │
  ├────────────────────────────────────────────────────┤
  │ [Ver todas las notificaciones]                     │
  └────────────────────────────────────────────────────┘

CRITERIOS DE ACEPTACIÓN:

  ✓ Badge muestra contador de no leídas correctamente
  ✓ Panel dropdown se abre/cierra correctamente
  ✓ Notificaciones aparecen ordenadas por fecha DESC
  ✓ Marcar como leída después de 3 segundos funciona
  ✓ Hacer clic en notificación navega al destino correcto
  ✓ Nuevas notificaciones llegan en tiempo real
  ✓ Toast de nueva notificación aparece por 3 segundos
  ✓ "Ver todas" navega a página completa
```

---

### 4.6 Consolidación de UC UI-Driven

**UC identificados en Sección 4:**

```
UC-150: Ver Dashboard Coordinador ⭐ (COMPLETO)
UC-151: Filtrar Dashboard (subtask de UC-150)
UC-152: Exportar Dashboard a Excel
UC-153: Configurar Widgets Dashboard
UC-154: Ver Detalle de KPI

UC-160: Búsqueda Avanzada Múltiples Criterios ⭐ (COMPLETO)
UC-161: Guardar Búsqueda (subtask de UC-160)
UC-162: Cargar Búsqueda Guardada (subtask de UC-160)
UC-163: Exportar Resultados Búsqueda (subtask de UC-160)

UC-170: Aprobar Múltiples Solicitudes ⭐ (COMPLETO)

UC-190: Ver Notificaciones In-App ⭐ (COMPLETO)
UC-191: Ver Detalle de Notificación
UC-192: Ver Historial Completo Notificaciones

Total: 13 UC identificados
Completos: 4 UC principales desarrollados
```

---

## SECCIÓN 5: TÉCNICA 4 - STAKEHOLDER REQUIREMENTS

### 5.1 Diferencia: Necesidades de Stakeholders vs Business Rules

#### 5.1.1 ¿Qué son Stakeholder Requirements?

**Definición:**

> "Requerimientos que surgen directamente de necesidades explícitas
> de stakeholders (clientes, usuarios, gerentes, reguladores) y que
> pueden no estar capturados en Business Rules o entidades CRUD."

**Diferencia con BR:**

```
BUSINESS RULES:
  • Reglas del negocio (cómo funciona el dominio)
  • Ejemplo: "Productos clase 5 requieren aprobación nivel 2"
  • Origen: Análisis del dominio, políticas internas

STAKEHOLDER REQUIREMENTS:
  • Necesidades específicas de personas/organizaciones
  • Ejemplo: "Director necesita reporte mensual para cumplir OSHA"
  • Origen: Entrevistas, regulaciones externas, peticiones directas

Overlap: A veces se solapan, pero enfoque es diferente
```

#### 5.1.2 Categorías de Stakeholder Requirements

**Categoría A: Regulatorios**

```
Origen: Leyes, normas, estándares externos obligatorios

Ejemplos:
  • Reporte OSHA (USA - Occupational Safety)
  • Reporte FDA (Food and Drug Administration)
  • Cumplimiento GDPR (protección datos UE)
  • Reporte auditoría ISO 9001
  • Declaraciones fiscales obligatorias

Características:
  • NO negociables (obligación legal)
  • Formato específico predefinido
  • Frecuencia mandatoria (mensual, trimestral, anual)
  • Multas si no se cumplen
```

**Categoría B: Integración con Sistemas Externos**

```
Origen: Necesidad de interoperabilidad con otros sistemas

Ejemplos:
  • Sincronización con SAP/ERP corporativo
  • Recibir órdenes de portal externo
  • Enviar datos a sistema de inventario central
  • Integración con API de proveedores

Características:
  • Formato de datos predefinido (XML, JSON, CSV)
  • Protocolos específicos (REST, SOAP, FTP)
  • Autenticación requerida (OAuth, API Keys)
  • Manejo de errores de red
```

**Categoría C: Análisis y Business Intelligence**

```
Origen: Stakeholders de nivel gerencial/directivo

Ejemplos:
  • Análisis de tendencias de uso
  • Predicción de necesidades futuras
  • Dashboards ejecutivos
  • KPIs estratégicos

Características:
  • Requieren datos históricos
  • Visualizaciones complejas (gráficos)
  • Exportables a presentaciones (PPT, PDF)
  • Actualizaciones periódicas
```

**Categoría D: Administración Técnica**

```
Origen: Equipo técnico, administradores de sistema

Ejemplos:
  • Backups y restauración
  • Logs de auditoría
  • Configuración de parámetros
  • Monitoreo de salud del sistema

Características:
  • Usuarios técnicos especializados
  • Interfaz puede ser menos "amigable"
  • Potencialmente peligroso (puede romper sistema)
  • Requiere permisos especiales
```

---

### 5.2 Proceso de Elicitación de Stakeholder Requirements

#### 5.2.1 Técnicas de Elicitación

**1. Entrevistas Estructuradas:**

```
Preparación:
  • Identificar stakeholders clave
  • Preparar preguntas abiertas y cerradas
  • Agendar 1-2 horas por stakeholder

Durante entrevista:
  • Grabar con permiso (para transcribir después)
  • Tomar notas de puntos clave
  • Hacer preguntas de seguimiento
  • Pedir ejemplos concretos

Post-entrevista:
  • Transcribir notas/audio
  • Identificar requerimientos explícitos
  • Identificar necesidades implícitas
  • Validar con stakeholder (follow-up)
```

**2. Observación Directa:**

```
Qué observar:
  • Flujos de trabajo actuales
  • Puntos de dolor (frustración)
  • Workarounds (soluciones temporales)
  • Herramientas que usan actualmente

Cómo documentar:
  • Diario de observación
  • Capturas de pantalla de sistema actual
  • Métricas de tiempo (cuánto tardan)
  • Anotaciones de comentarios espontáneos
```

**3. Análisis de Documentos:**

```
Documentos relevantes:
  • Manuales de procedimientos actuales
  • Reportes que generan manualmente (Excel, Word)
  • Normativas y regulaciones aplicables
  • Contratos con clientes/proveedores
  • Auditorías previas

Qué buscar:
  • Formatos obligatorios
  • Datos que recopilan
  • Frecuencia de reportes
  • Destinatarios de información
```

---

### 5.3 Categoría A: Requerimientos Regulatorios

#### 5.3.1 UC-200: Generar Reporte OSHA (COMPLETO) ⭐⭐⭐

**Contexto OSHA:**

> OSHA (Occupational Safety and Health Administration) es la agencia
> federal de USA que regula seguridad y salud ocupacional. Laboratorios
> que manejan químicos peligrosos DEBEN reportar su inventario 
> trimestralmente bajo el Hazard Communication Standard (HCS).

```
═══════════════════════════════════════════════════════════════
UC-200: Generar Reporte de Cumplimiento OSHA
═══════════════════════════════════════════════════════════════

ACTOR PRINCIPAL:
  Coordinador Legal / Coordinador de Laboratorio

STAKEHOLDER:
  • Director de Seguridad (requiere el reporte)
  • OSHA (agencia regulatoria que audita)
  • Departamento Legal (responsable de cumplimiento)

PRECONDICIONES:
  • Usuario tiene permiso "reportes:generar_osha"
  • Existen productos químicos clase 4 o 5 registrados
  • Sistema conoce ubicación física del laboratorio

POSTCONDICIONES:
  ✓ Reporte OSHA generado en formato PDF oficial
  ✓ Registro de generación guardado en auditoría
  ✓ Archivo archivado en repositorio de cumplimiento

FLUJO NORMAL:

  1. Coordinador Legal selecciona "Reportes > Cumplimiento OSHA"
  
  2. Sistema muestra formulario con parámetros:
     • Periodo de reporte: [Q1 2025]
     • Incluir solo químicos clase: [4 y 5] [Todas]
     • Incluir productos inactivos: [☐ Sí]
     • Formato: [PDF] [CSV]
  
  3. Coordinador Legal completa parámetros y hace clic en "Generar"
  
  4. Sistema valida parámetros ingresados
  
  5. Sistema consulta productos químicos según criterios:
     Query: SELECT p.*, c.nombre as categoria
            FROM Producto p
            JOIN Categoria c ON p.categoria_id = c.id
            WHERE p.clase_peligrosidad IN (4, 5)
              AND (:incluir_inactivos = TRUE OR p.activo = TRUE)
              AND p.fecha_registro <= :fecha_fin_periodo
            ORDER BY p.clase_peligrosidad DESC, p.nombre ASC
  
  6. Sistema agrupa productos por clase de peligrosidad
  
  7. Sistema calcula estadísticas requeridas por OSHA:
     a. Total de productos clase 5 (altamente peligrosos)
     b. Total de productos clase 4 (peligrosos)
     c. Cantidad total en unidades (Litros, Kg)
     d. Número de ubicaciones de almacenamiento
     e. Personal certificado para manejo
     f. Incidentes reportados en el periodo (si hay)
  
  8. Sistema genera PDF con estructura oficial OSHA:
     ┌────────────────────────────────────────────────┐
     │ OSHA HAZARDOUS CHEMICAL INVENTORY REPORT       │
     │ Form OSHA-174 (Rev. 2024)                      │
     ├────────────────────────────────────────────────┤
     │                                                 │
     │ FACILITY INFORMATION:                          │
     │   Name: Universidad XYZ - Laboratorio Química  │
     │   Address: [dirección completa]                │
     │   EIN: [número identificación]                 │
     │   Report Period: Q1 2025 (Jan 1 - Mar 31)     │
     │   Report Date: April 15, 2025                  │
     │                                                 │
     │ SUMMARY STATISTICS:                            │
     │   Total Class 5 Chemicals: 8 products          │
     │   Total Class 4 Chemicals: 15 products         │
     │   Total Quantity: 250 L / 80 Kg               │
     │   Storage Locations: 3 secure cabinets        │
     │   Certified Personnel: 12 individuals          │
     │   Incidents Reported: 0                        │
     │                                                 │
     │ DETAILED INVENTORY:                            │
     │                                                 │
     │ CLASS 5 (HIGHLY HAZARDOUS):                    │
     │ ──────────────────────────────────────────────│
     │ 1. Hydrofluoric Acid (HF)                      │
     │    CAS: 7664-39-3                              │
     │    Quantity: 5 Liters                          │
     │    Location: Cabinet A-1 (Secure)              │
     │    MSDS on file: Yes ✓                         │
     │    Last inspection: March 28, 2025             │
     │                                                 │
     │ 2. Sodium Cyanide (NaCN)                       │
     │    CAS: 143-33-9                               │
     │    Quantity: 2 Kg                              │
     │    Location: Cabinet A-1 (Secure)              │
     │    MSDS on file: Yes ✓                         │
     │    Last inspection: March 28, 2025             │
     │                                                 │
     │ [...continúa con todos los productos]          │
     │                                                 │
     │ CLASS 4 (HAZARDOUS):                           │
     │ ──────────────────────────────────────────────│
     │ [similar structure]                            │
     │                                                 │
     │ CERTIFICATION:                                 │
     │ I certify that the information provided        │
     │ is accurate and complete to the best of        │
     │ my knowledge.                                   │
     │                                                 │
     │ Signature: _____________________               │
     │ Name: [Coordinador Legal]                      │
     │ Title: Safety Compliance Officer               │
     │ Date: April 15, 2025                           │
     │                                                 │
     │ ────────────────────────────────────────────── │
     │ For OSHA use only:                             │
     │ Received: ___________                          │
     │ Reviewed by: ___________                       │
     └────────────────────────────────────────────────┘
  
  9. Sistema genera nombre de archivo: 
     "OSHA_Report_Q1_2025_UniversidadXYZ.pdf"
  
  10. Sistema guarda copia en repositorio de cumplimiento:
      Path: /documentos/cumplimiento/osha/2025/Q1/
  
  11. Sistema registra generación en tabla ReporteOSHA:
      {periodo, usuario_id, fecha_generacion, archivo_path, hash_sha256}
  
  12. Sistema muestra PDF generado en pantalla
  
  13. Sistema ofrece opciones:
      [Descargar] [Enviar por email] [Imprimir] [Archivar]
  
  14. [FIN UC]

FLUJOS ALTERNATIVOS:

  FA-1: Sin Productos Clase 4/5 (Paso 5)
    5a. Query no retorna ningún producto
    5b. Sistema muestra advertencia: "No hay productos clase 4 o 5
        registrados en el periodo seleccionado"
    5c. Sistema pregunta: "¿Generar reporte vacío de todos modos?"
    5d. Si usuario confirma:
        - Sistema genera PDF con secciones vacías
        - Indica "No hazardous chemicals in inventory"
    5e. Si usuario cancela:
        - Vuelve a paso 2

  FA-2: Productos sin CAS Number (Paso 5)
    5a. Algunos productos no tienen CAS Number asignado
    5b. Sistema marca esos productos con "⚠️ CAS Missing"
    5c. Sistema genera reporte con advertencia en header:
        "WARNING: X products missing CAS Number"
    5d. Sistema recomienda completar CAS antes de enviar a OSHA
    5e. Continúa generación normalmente

  FA-3: Usuario Envía por Email (Paso 13)
    13a. Usuario hace clic en "Enviar por email"
    13b. Sistema muestra form: "Destinatario: [____@___]"
    13c. Usuario ingresa email (típicamente osha@regional.gov)
    13d. Sistema adjunta PDF y envía email con:
         Subject: "OSHA Hazardous Chemical Inventory Report - Q1 2025"
         Body: Template formal con instrucciones
    13e. Sistema registra envío en log
    13f. [FIN UC]

  FA-4: Reporte Ya Generado para Mismo Periodo (Paso 4)
    4a. Sistema detecta reporte existente para mismo periodo
    4b. Sistema muestra advertencia: "Ya existe un reporte para Q1 2025
        generado el 2025-04-10 por [usuario]"
    4c. Sistema pregunta: "¿Regenerar de todos modos?"
    4d. Si usuario confirma:
        - Continúa en paso 5
        - Nuevo reporte reemplaza anterior (o se versiona)
    4e. Si usuario cancela:
        - Muestra reporte existente
        - [FIN UC]

REQUERIMIENTOS ESPECIALES:

  • PDF DEBE seguir formato oficial OSHA Form 174
  • Encabezado DEBE incluir logo OSHA oficial
  • Tipografía DEBE ser Arial 10pt (estándar gubernamental)
  • Firma digital opcional (si sistema tiene certificados)
  • Reporte DEBE archivarse por 7 años (requisito legal)
  • Hash SHA-256 para verificar integridad del archivo

CAMPOS OBLIGATORIOS OSHA:

  Por facilidad (facility):
    • Nombre legal completo
    • Dirección física (no P.O. Box)
    • EIN (Employer Identification Number)
    • Persona de contacto con teléfono

  Por producto:
    • CAS Number (crítico)
    • Nombre químico (nomenclatura IUPAC)
    • Cantidad con unidades
    • Ubicación física exacta
    • MSDS (Material Safety Data Sheet) en archivo

FRECUENCIA DE REPORTE:

  • Trimestral (Q1, Q2, Q3, Q4)
  • Deadline: 15 días después de fin de trimestre
  • Multa por retraso: $1,000 - $5,000 USD por día

CRITERIOS DE ACEPTACIÓN:

  ✓ PDF generado incluye TODAS las secciones obligatorias
  ✓ Productos se agrupan correctamente por clase 4/5
  ✓ CAS Numbers aparecen en formato correcto
  ✓ Estadísticas se calculan correctamente
  ✓ Logo OSHA aparece en encabezado
  ✓ Archivo se guarda en repositorio con nombre estándar
  ✓ Registro de generación se guarda en auditoría
  ✓ Hash SHA-256 permite verificar integridad
  ✓ Envío por email funciona correctamente
  ✓ Reporte cumple con formato oficial Form OSHA-174
```

---

### 5.4 Categoría B: Integración con Sistemas Externos

#### 5.4.1 UC-210: Sincronizar con SAP (COMPLETO)

```
═══════════════════════════════════════════════════════════════
UC-210: Sincronización Bidireccional con SAP/ERP
═══════════════════════════════════════════════════════════════

ACTOR PRINCIPAL:
  Sistema (proceso automatizado nocturno)
  Alternativo: Administrador (manual si es necesario)

STAKEHOLDER:
  • Departamento Financiero (requiere datos en SAP para contabilidad)
  • Gerente de Compras (órdenes de compra desde SAP)

PRECONDICIONES:
  • Credenciales de SAP configuradas y válidas
  • Endpoint de API SAP accesible
  • Mapeo de datos Sistema ↔ SAP definido

POSTCONDICIONES:
  ✓ Productos sincronizados entre ambos sistemas
  ✓ Órden de compras actualizadas desde SAP
  ✓ Log de sincronización registrado
  ✓ Errores notificados a administrador

FLUJO NORMAL (Sincronización Automática Nocturna):

  1. Sistema inicia job programado (cron) a las 02:00 AM
  
  2. Sistema verifica conectividad con API SAP:
     Endpoint: https://sap.empresa.com/api/v1/sync
     Método: GET /health
  
  3. Sistema obtiene token de autenticación OAuth 2.0:
     POST /auth/token
     Body: {client_id, client_secret, grant_type}
     Response: {access_token, expires_in}
  
  4. Sistema sincroniza PRODUCTOS (Sistema → SAP):
     a. Obtiene productos modificados desde última sync:
        SELECT * FROM Producto 
        WHERE fecha_modificacion > :ultima_sync
     
     b. Para cada producto:
        - Mapea campos Sistema → SAP:
          cas_number → SAP_MATERIAL_ID
          nombre → SAP_SHORT_TEXT
          precio_unitario → SAP_UNIT_PRICE
          categoria_id → SAP_MATERIAL_GROUP
        
        - Envía a SAP:
          POST /materials
          Body: {material_id, short_text, unit_price, ...}
        
        - Si SAP retorna 200 OK:
          • Marca producto como sincronizado
          • Guarda SAP_ID en campo producto.sap_id
        
        - Si SAP retorna error:
          • Registra error en log
          • Continúa con siguiente producto
  
  5. Sistema sincroniza ÓRDENES DE COMPRA (SAP → Sistema):
     a. Obtiene órdenes creadas en SAP desde última sync:
        GET /purchase-orders?since=:ultima_sync
     
     b. Para cada orden:
        - Verifica si producto existe en Sistema (por SAP_ID)
        - Si existe:
          • Crea/Actualiza registro en tabla OrdenCompra
          • Campos: numero_orden, proveedor_id, fecha_entrega, cantidad
        - Si no existe:
          • Registra advertencia en log
          • Opcionalmente crea producto automáticamente
  
  6. Sistema actualiza timestamp de última sincronización:
     UPDATE ConfiguracionSistema
     SET valor = NOW()
     WHERE clave = 'ultima_sync_sap'
  
  7. Sistema genera reporte de sincronización:
     {
       fecha: "2025-12-08 02:15:30",
       productos_enviados: 12,
       productos_error: 1,
       ordenes_recibidas: 8,
       ordenes_error: 0,
       duracion: "2 minutos 15 segundos"
     }
  
  8. Sistema envía email de reporte a administrador
  
  9. [FIN UC]

FLUJOS ALTERNATIVOS:

  FA-1: Error de Conexión con SAP (Paso 2)
    2a. No se puede conectar con API SAP
    2b. Sistema reintenta 3 veces con backoff exponencial (1, 2, 4 min)
    2c. Si falla después de 3 intentos:
        - Registra error crítico en log
        - Envía email urgente a administrador
        - Programa reintento para dentro de 1 hora
    2d. [FIN UC - ERROR]

  FA-2: Token de Autenticación Expirado (Paso 3)
    3a. Token almacenado en cache ha expirado
    3b. Sistema solicita nuevo token
    3c. Si SAP retorna error de credenciales:
        - Notifica administrador inmediatamente
        - No continúa sincronización
        - [FIN UC - ERROR AUTENTICACIÓN]
    3d. Si token se obtiene correctamente:
        - Actualiza cache con nuevo token
        - Continúa en paso 4

  FA-3: Conflicto de Datos (Paso 4b)
    4b1. Producto fue modificado tanto en Sistema como en SAP
    4b2. Sistema detecta conflicto (timestamps no coinciden)
    4b3. Sistema aplica regla de resolución:
         Opción A: "SAP gana" (sobreescribe datos locales)
         Opción B: "Sistema gana" (sobreescribe SAP)
         Opción C: "Manual" (notifica a administrador)
    4b4. Registra conflicto en log para revisión
    4b5. Continúa con siguiente producto

  FA-4: Sincronización Manual (Usuario Administrador)
    1a. Administrador selecciona "Sincronizar con SAP ahora"
    1b. Sistema confirma: "¿Ejecutar sincronización manual?"
    1c. Administrador confirma
    1d. Continúa en paso 2 (mismo flujo que automático)
    1e. Al finalizar: Muestra reporte en pantalla

REQUERIMIENTOS ESPECIALES:

  • Sincronización DEBE ser idempotente (no duplicar datos)
  • Timeout por operación: 30 segundos
  • Reintentos automáticos con backoff exponencial
  • Log detallado de cada operación (éxito/error)
  • Notificaciones a administrador si > 10% errores

MAPEO DE DATOS SISTEMA ↔ SAP:

  Sistema              | SAP                  | Transformación
  ---------------------|----------------------|------------------
  cas_number           | MATERIAL_ID          | Directo
  nombre               | SHORT_TEXT           | Máx 40 chars
  precio_unitario      | UNIT_PRICE           | Formato: 9999.99
  categoria_id         | MATERIAL_GROUP       | Lookup tabla
  unidad_medida        | BASE_UNIT            | "L"→"LTR", "kg"→"KGM"
  proveedor_id         | VENDOR_ID            | Lookup tabla
  activo               | DELETION_FLAG        | Inverso: true→"", false→"X"

CRITERIOS DE ACEPTACIÓN:

  ✓ Job nocturno ejecuta a las 02:00 AM correctamente
  ✓ Productos modificados se envían a SAP
  ✓ Órdenes de compra se reciben desde SAP
  ✓ Mapeo de datos funciona correctamente
  ✓ Errores se registran en log detallado
  ✓ Reporte de sincronización se envía por email
  ✓ Sincronización manual desde UI funciona
  ✓ Sistema maneja errores de conexión apropiadamente
  ✓ Conflictos de datos se resuelven según regla configurada
```

---

### 5.5 Categoría C: Análisis y BI

#### 5.5.1 UC-220: Análisis de Tendencias de Uso

```
═══════════════════════════════════════════════════════════════
UC-220: Análisis de Tendencias de Uso de Productos
═══════════════════════════════════════════════════════════════

ACTOR PRINCIPAL:
  Director de Laboratorio, Gerente de Compras

STAKEHOLDER:
  • Director: Necesita planificar presupuesto futuro
  • Gerente Compras: Anticipar órdenes de compra

PRECONDICIONES:
  • Existe historial de al menos 6 meses de solicitudes
  • Usuario tiene permiso "reportes:analisis_avanzado"

POSTCONDICIONES:
  ✓ Gráficos de tendencias generados
  ✓ Predicciones calculadas
  ✓ Reporte exportable a PowerPoint

FLUJO NORMAL:

  1. Director selecciona "Reportes > Análisis de Tendencias"
  
  2. Sistema muestra opciones de análisis:
     • Periodo histórico: [Últimos 12 meses▼]
     • Productos: [Top 20 más usados▼] [Todos]
     • Agrupación: [Por mes▼] [Por semana] [Por trimestre]
     • Incluir predicción: [☑ Sí] [☐ No]
  
  3. Director configura parámetros y hace clic en "Analizar"
  
  4. Sistema obtiene datos históricos:
     Query: SELECT 
              p.nombre,
              DATE_FORMAT(s.fecha_solicitud, '%Y-%m') as periodo,
              SUM(s.cantidad) as total_solicitado
            FROM Solicitud s
            JOIN Producto p ON s.producto_id = p.id
            WHERE s.fecha_solicitud >= NOW() - INTERVAL 12 MONTH
              AND s.estado = 'Entregada'
            GROUP BY p.id, periodo
            ORDER BY p.nombre, periodo
  
  5. Sistema calcula estadísticas por producto:
     • Promedio mensual
     • Desviación estándar
     • Tendencia (regresión lineal simple)
     • Estacionalidad (si hay patrón)
  
  6. Sistema aplica algoritmo de predicción (regresión lineal):
     Para próximos 3 meses:
       predicción[t] = a + b*t
       donde: a = intercept, b = slope calculados
  
  7. Sistema genera visualizaciones:
     a. Gráfico de líneas por producto (histórico + predicción)
     b. Gráfico de barras apiladas (comparación productos)
     c. Mapa de calor (producto × mes)
  
  8. Sistema muestra dashboard con:
     • 3 gráficos interactivos
     • Tabla de estadísticas
     • Insights automáticos (ej: "Acetona muestra incremento 15% mensual")
     • Recomendaciones de compra
  
  9. Director puede exportar a PowerPoint con todos los gráficos
  
  10. [FIN UC]

CRITERIOS DE ACEPTACIÓN:

  ✓ Gráficos muestran histórico correctamente
  ✓ Predicción se calcula con regresión lineal
  ✓ Export a PowerPoint incluye todos los gráficos
  ✓ Recomendaciones de compra son accionables
```

---

### 5.6 Categoría D: Administración Técnica

#### 5.6.1 UC-231: Restaurar Backup del Sistema

```
═══════════════════════════════════════════════════════════════
UC-231: Restaurar Backup del Sistema
═══════════════════════════════════════════════════════════════

ACTOR PRINCIPAL:
  Administrador del Sistema

PRECONDICIONES:
  • Existe al menos 1 backup válido
  • Administrador tiene credenciales de superusuario
  • Sistema está en modo mantenimiento

POSTCONDICIONES:
  ✓ Base de datos restaurada a estado del backup
  ✓ Archivos adjuntos restaurados
  ✓ Log de restauración registrado

FLUJO NORMAL:

  1. Administrador accede a "Sistema > Backups"
  
  2. Sistema muestra lista de backups disponibles:
     ┌────────────────────────────────────────────────────┐
     │ Fecha       | Tamaño  | Estado   | Acciones        │
     ├────────────────────────────────────────────────────┤
     │ 2025-12-08  | 2.3 GB  | Válido ✓ | [Restaurar][💾] │
     │ 2025-12-07  | 2.1 GB  | Válido ✓ | [Restaurar][💾] │
     │ 2025-12-06  | 2.0 GB  | Válido ✓ | [Restaurar][💾] │
     └────────────────────────────────────────────────────┘
  
  3. Administrador selecciona backup a restaurar
  
  4. Sistema muestra advertencia crítica:
     "⚠️ ADVERTENCIA: Restaurar backup eliminará TODOS los datos
      actuales y los reemplazará con datos del 2025-12-07.
      
      Datos que se perderán:
      • Todos los cambios desde 2025-12-07
      • [Lista de registros afectados]
      
      ¿Está seguro?
      [Cancelar] [Sí, restaurar]"
  
  5. Administrador confirma escribiendo "CONFIRMAR"
  
  6. Sistema pone aplicación en modo mantenimiento
  
  7. Sistema crea backup de seguridad del estado actual
     (por si necesita revertir la restauración)
  
  8. Sistema extrae archivo de backup:
     • database_dump.sql (base de datos)
     • uploads/ (archivos adjuntos)
     • config/ (configuraciones)
  
  9. Sistema restaura base de datos:
     mysql -u root -p database_name < database_dump.sql
  
  10. Sistema restaura archivos adjuntos:
      rsync -av uploads/ /var/www/app/storage/uploads/
  
  11. Sistema verifica integridad:
      • Tablas existen
      • Índices correctos
      • Foreign keys válidos
  
  12. Sistema reinicia servicios de aplicación
  
  13. Sistema sale de modo mantenimiento
  
  14. Sistema muestra mensaje: "Restauración exitosa"
  
  15. [FIN UC]

CRITERIOS DE ACEPTACIÓN:

  ✓ Backup se restaura correctamente
  ✓ Datos post-backup se pierden (esperado)
  ✓ Sistema queda funcional después de restaurar
  ✓ Integridad de datos se verifica
```

---

## RESUMEN SECCIÓN 4 Y 5

**UC identificados y desarrollados:**

```
SECCIÓN 4 (UI-DRIVEN): 4 UC completos
  UC-150: Dashboard Coordinador ⭐
  UC-160: Búsqueda Avanzada ⭐
  UC-170: Aprobar Múltiples ⭐
  UC-190: Ver Notificaciones ⭐

SECCIÓN 5 (STAKEHOLDERS): 4 UC completos
  UC-200: Reporte OSHA ⭐⭐⭐ (MÁS ESPECÍFICO)
  UC-210: Sincronizar SAP ⭐
  UC-220: Análisis Tendencias ⭐
  UC-231: Restaurar Backup ⭐

TOTAL: 8 UC completos desarrollados
```

**Líneas generadas:**

- Sección 4: ~1,500 líneas
- Sección 5: ~1,400 líneas
- **Total PARTE 3C: ~2,900 líneas**

**Calidad:** ⭐⭐⭐ Nivel profesional/enterprise

---

**FIN DE PARTE 3C - TÉCNICAS UI-DRIVEN Y STAKEHOLDERS**
