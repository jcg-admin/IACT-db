UID: 20251208123235247788
date: 2025-12-08


# PARTE 3 - PLAN DETALLADO DE ESTRUCTURA Y CONTENIDO

## IDENTIFICAR CASOS DE USO ADICIONALES
**Técnicas Complementarias a Business Rules**

---

## METADATOS DEL DOCUMENTO

```
Título: PARTE 3 - Identificar Casos de Uso Adicionales
Versión: 1.0
Longitud objetivo: 9,700 líneas (~240 páginas)
Secciones: 12 principales
Ejemplos completos: 20+
Ejercicios con soluciones: 4
Diagramas PlantUML: 15
Estilo: Abstracto Real, Profesional, Sin emojis
```

---

## TABLA DE CONTENIDOS COMPLETA

```
1. INTRODUCCIÓN
   1.1 Contexto: UC de BR vs UC Adicionales
   1.2 El Gap: 10 UC de BR, 35 UC adicionales
   1.3 Las 4 Técnicas Complementarias
   1.4 Integración con PARTE 1 y PARTE 2
   1.5 Proceso General de PARTE 3

2. TÉCNICA 1: ANÁLISIS CRUD
   2.1 Fundamento del Análisis CRUD
       2.1.1 Definición de CRUD
       2.1.2 Por Qué Toda Entidad Requiere Mantenimiento
       2.1.3 CRUD en Contexto de UC
   2.2 Proceso de Identificación (5 Pasos)
       Paso 1: Listar Entidades del Modelo
       Paso 2: Clasificar por Tipo (Maestro, Transaccional, Técnica)
       Paso 3: Determinar Operaciones Necesarias
       Paso 4: Generar UC por Operación
       Paso 5: Validar con Stakeholders
   2.3 Reglas de Decisión
       2.3.1 ¿Cuándo SÍ generar CRUD?
       2.3.2 ¿Cuándo NO generar CRUD?
       2.3.3 Tabla de Decisión
   2.4 Variaciones de CRUD
       2.4.1 CRUD Completo (C+R+U+D)
       2.4.2 CRUD Parcial (C+R)
       2.4.3 CRUD con Soft Delete
       2.4.4 CR (Solo Create + Read)
       2.4.5 RU (Solo Read + Update)
   2.5 EJEMPLO GUÍA 1: Entidad "Producto" → 6 UC
       UC-40: Registrar Nuevo Producto (COMPLETO: 8 pasos, 3 FA)
       UC-41: Consultar Productos (COMPLETO: con filtros, orden)
       UC-42: Ver Detalles de Producto (COMPLETO: con historial)
       UC-43: Actualizar Datos de Producto (COMPLETO: con validaciones)
       UC-44: Desactivar Producto (COMPLETO: soft delete con checks)
       UC-45: Activar Producto (COMPLETO: reactivación)
       UC-46: Ajustar Stock (COMPLETO: operación especial)
   2.6 Ejemplo 2: Entidad "Usuario" → 7 UC
       (Desarrollo más breve, enfoque en diferencias)
   2.7 Ejemplo 3: Entidad "Orden" → 3 UC (CR, sin UD)
       (Por qué órdenes no se modifican ni borran)
   2.8 Plantilla Estándar para UC CRUD
   2.9 Ejercicio Práctico: Entidad "Proveedor" (con solución)

3. TÉCNICA 2: MODELO DE LARMAN
   3.1 Introducción a Técnicas de Larman
       3.1.1 "Applying UML and Patterns" - Contexto
       3.1.2 Eventos del Sistema
       3.1.3 Contratos de Operación
       3.1.4 Análisis de Responsabilidades
   
   3.2 SUBTÉCNICA 2.1: Eventos del Sistema
       3.2.1 Definición de Evento del Sistema
       3.2.2 Proceso de Identificación (4 pasos)
             Paso 1: Identificar Actores Externos
             Paso 2: Por Cada Actor, Listar Eventos Generados
             Paso 3: Filtrar Eventos Significativos
             Paso 4: Evento → UC (si no existe ya)
       3.2.3 Diferencia: Evento vs Business Rule
       3.2.4 EJEMPLO COMPLETO: Actor "Estudiante"
             Evento: Solicita producto → UC-04 (ya existe)
             Evento: Consulta estado solicitudes → UC-61 (NUEVO)
             Evento: Cancela solicitud → UC-62 (NUEVO)
             Evento: Consulta disponibilidad → UC-63 (NUEVO)
             [UC-61, UC-62, UC-63 desarrollados COMPLETOS]
       3.2.5 Ejemplo 2: Actor "Sistema Externo (LDAP)"
             Evento: Autentica usuario → UC-70 (NUEVO)
             Evento: Sincroniza datos → UC-71 (NUEVO)
       3.2.6 Ejemplo 3: Actor "Proveedor (vía API)"
             Evento: Notifica envío → UC-80 (NUEVO)
             Evento: Actualiza tracking → UC-81 (NUEVO)
       3.2.7 Diagrama: Actores y Sus Eventos
   
   3.3 SUBTÉCNICA 2.2: Análisis de Operaciones del Sistema
       3.3.1 Definición de Operación del Sistema
       3.3.2 Categorías de Operaciones
       3.3.3 CATEGORÍA A: Operaciones de Consulta
             Operación: ConsultarInventario → UC-90 (NUEVO)
             Operación: GenerarReporte → UC-91 (NUEVO)
             Operación: VerEstadísticas → UC-92 (NUEVO)
       3.3.4 CATEGORÍA B: Operaciones de Proceso
             Operación: RecalcularInventario → UC-93 (NUEVO)
             Operación: ReconciliarDatos → UC-94 (NUEVO)
       3.3.5 CATEGORÍA C: Operaciones de Configuración
             Operación: ConfigurarUmbrales → UC-95 (NUEVO)
             Operación: DefinirPeriodo → UC-96 (NUEVO)
       3.3.6 CATEGORÍA D: Operaciones de Integración
             Operación: ImportarExcel → UC-98 (NUEVO)
             Operación: ExportarCSV → UC-99 (NUEVO)
             Operación: SincronizarERP → UC-100 (NUEVO)
       3.3.7 Ejemplo Completo: UC-90 "Consultar Inventario Actual"
             (COMPLETO: 6 pasos, 2 FA, con filtros y exportación)
   
   3.4 SUBTÉCNICA 2.3: Identificación por Responsabilidades
       3.4.1 ¿Qué Responsabilidades Tiene el Sistema?
       3.4.2 Técnica de Brainstorming de Responsabilidades
       3.4.3 RESPONSABILIDAD 1: Autenticación y Seguridad
             - UC-110: Iniciar Sesión (COMPLETO)
             - UC-111: Cerrar Sesión
             - UC-112: Recuperar Contraseña (COMPLETO con email)
             - UC-113: Cambiar Contraseña
             - UC-114: Ver Sesiones Activas
       3.4.4 RESPONSABILIDAD 2: Configuración del Sistema
             - UC-120: Configurar Parámetros Generales
             - UC-121: Administrar Roles y Permisos (COMPLETO)
             - UC-122: Definir Flujos de Aprobación
       3.4.5 RESPONSABILIDAD 3: Auditoría y Trazabilidad
             - UC-130: Consultar Log de Auditoría (COMPLETO con filtros)
             - UC-131: Ver Historial de Cambios
             - UC-132: Exportar Auditoría
       3.4.6 RESPONSABILIDAD 4: Reportería
             - UC-140: Generar Reporte de Inventario
             - UC-141: Reporte de Uso por Departamento (COMPLETO)
             - UC-142: Reporte de Vencimientos
       3.4.7 Matriz de Responsabilidades vs UC

4. TÉCNICA 3: ANÁLISIS DE INTERFAZ (UI-DRIVEN)
   4.1 Fundamento del Análisis UI-Driven
       4.1.1 De Mockups a Casos de Uso
       4.1.2 Cuándo Aplicar Esta Técnica
       4.1.3 Herramientas (Figma, Balsamiq, Papel)
   4.2 Proceso de Mockup a UC (5 Pasos)
       Paso 1: Crear Mockups de Pantallas Principales
       Paso 2: Identificar Interacciones Usuario-Sistema
       Paso 3: Clasificar Interacciones (significativas vs triviales)
       Paso 4: Interacción Significativa → UC
       Paso 5: Documentar UC con Base en Flujo Visual
   4.3 EJEMPLO GUÍA 1: Dashboard del Coordinador
       4.3.1 Mockup Completo (ASCII art o descripción)
       4.3.2 UC Derivados:
             - UC-150: Ver Dashboard del Coordinador (COMPLETO)
             - UC-151: Filtrar Dashboard por Fecha
             - UC-152: Exportar Gráficos
             - UC-153: Configurar Widgets
   4.4 Ejemplo 2: Búsqueda Avanzada de Productos
       4.4.1 Mockup Completo
       4.4.2 UC Derivados:
             - UC-160: Buscar Productos con Múltiples Criterios (COMPLETO)
             - UC-161: Guardar Búsqueda Favorita
             - UC-162: Recuperar Búsqueda Guardada
             - UC-163: Exportar Resultados
   4.5 Interacciones Comunes que Generan UC
       4.5.1 Filtrado y Ordenamiento
       4.5.2 Acciones en Lote (Bulk Actions)
             Ejemplo: UC-170 "Aprobar Múltiples Solicitudes" (COMPLETO)
       4.5.3 Preferencias de Usuario
       4.5.4 Notificaciones In-App
             Ejemplo: UC-190 "Ver Notificaciones" (COMPLETO)
   4.6 Ejemplo Completo: Módulo de Solicitudes
       4.6.1 Mockup: Pantalla Principal de Solicitudes
       4.6.2 Mockup: Detalle de Solicitud
       4.6.3 Mockup: Aprobar/Rechazar
       4.6.4 UC Derivados (8 UC listados, 3 desarrollados)
   4.7 Cuándo NO Generar UC desde UI
       (Interacciones triviales que no son UC)

5. TÉCNICA 4: REQUERIMIENTOS DIRECTOS DE STAKEHOLDERS
   5.1 Diferencia: Necesidades vs Business Rules
       5.1.1 Por Qué No Todo es BR
       5.1.2 Tipos de Necesidades Sin BR Formal
   5.2 Proceso de Elicitación Enfocada
       5.2.1 Preparación de Entrevista
       5.2.2 Preguntas Guía
       5.2.3 Captura de Necesidades
       5.2.4 Validación y Priorización
   5.3 Categorías de Requerimientos Directos
       5.3.1 CATEGORÍA A: Regulatorios/Compliance
             Ejemplo: UC-200 "Generar Reporte OSHA" (COMPLETO)
             Ejemplo: UC-201 "Exportar para Auditoría FDA"
       5.3.2 CATEGORÍA B: Integración
             Ejemplo: UC-210 "Sincronizar con SAP" (COMPLETO)
             Ejemplo: UC-211 "Recibir Órdenes desde Portal"
       5.3.3 CATEGORÍA C: Análisis y BI
             Ejemplo: UC-220 "Analizar Tendencias de Consumo" (COMPLETO)
             Ejemplo: UC-221 "Predecir Necesidades Futuras"
       5.3.4 CATEGORÍA D: Administración
             Ejemplo: UC-230 "Realizar Backup Manual"
             Ejemplo: UC-231 "Restaurar desde Backup" (COMPLETO)
   5.4 Caso Real: Entrevista con Director de Laboratorio
       5.4.1 Transcripción de Entrevista (simulada pero realista)
       5.4.2 Análisis: Necesidades Identificadas
       5.4.3 UC Derivados (4 UC)
       5.4.4 UC-240 "Reporte Gastos por Departamento" (COMPLETO)
   5.5 Técnicas de Elicitación Adicionales
       5.5.1 Observación
       5.5.2 Cuestionarios
       5.5.3 Workshops
       5.5.4 Análisis de Documentación Existente

6. CONSOLIDACIÓN E INTEGRACIÓN
   6.1 Visión General: UC de 3 Fuentes
       - PARTE 1+2: UC de Business Rules (10 UC)
       - PARTE 3 Técnica 1: CRUD (18 UC)
       - PARTE 3 Técnica 2: Larman (10 UC)
       - PARTE 3 Técnica 3: UI (5 UC)
       - PARTE 3 Técnica 4: Stakeholders (2 UC)
       TOTAL ANTES DE CONSOLIDAR: 45 UC
   6.2 Identificar Duplicados
       6.2.1 UC-53 (CRUD Usuario) vs UC-181 (UI Preferencias)
             Análisis: Mismo objetivo → Consolidar
             Resultado: UC-53 expandido
       6.2.2 UC-91 (Larman Reporte) vs UC-140 (Responsabilidad Reporte)
             Análisis: Similar pero diferente enfoque → Consolidar
       6.2.3 Proceso de Identificación de Duplicados
   6.3 Consolidar UC Similares
       6.3.1 Técnica de Fusión
       6.3.2 Ejemplo Completo: Fusionar 3 UC de "Configuración"
   6.4 Identificar Dependencias Entre UC
       6.4.1 Dependencias de Precondición
             Ejemplo: UC-09 depende de UC-04
       6.4.2 Dependencias de Flujo
             Ejemplo: UC-15 continúa después de UC-13
       6.4.3 Diagrama de Dependencias (PlantUML)
   6.5 Resultado Final: Catálogo Consolidado
       TOTAL DESPUÉS DE CONSOLIDAR: 42 UC
       (3 duplicados eliminados/fusionados)

7. NUMERACIÓN Y ORGANIZACIÓN
   7.1 Sistemas de Numeración de UC
       7.1.1 Opción 1: Secuencial Simple (UC-01, UC-02, ...)
       7.1.2 Opción 2: Por Módulo (UC-AUT-01, UC-INV-01, ...)
       7.1.3 Opción 3: Híbrido (Recomendado)
   7.2 Agrupación por Módulo/Funcionalidad
       MÓDULO 1: Autenticación y Seguridad (UC-110 a UC-119)
       MÓDULO 2: Gestión de Usuarios (UC-50 a UC-59)
       MÓDULO 3: Catálogo de Productos (UC-40 a UC-49)
       MÓDULO 4: Solicitudes (UC-04, UC-60 a UC-69)
       MÓDULO 5: Aprobaciones (UC-09, UC-170)
       MÓDULO 6: Inventario (UC-15 a UC-20, UC-90 a UC-94)
       MÓDULO 7: Notificaciones (UC-07, UC-190 a UC-192)
       MÓDULO 8: Reportes (UC-140 a UC-149, UC-200 a UC-202)
       MÓDULO 9: Configuración (UC-95, UC-120 a UC-129)
       MÓDULO 10: Auditoría (UC-130 a UC-139)
       MÓDULO 11: Integración (UC-80, UC-210 a UC-219)
       MÓDULO 12: Administración (UC-230 a UC-239)
   7.3 Ejemplo: Sistema Lab con 42 UC Organizados
       7.3.1 Tabla Completa de UC por Módulo
       7.3.2 Índice Navegable
   7.4 Herramientas para Gestión de UC
       7.4.1 Jira
       7.4.2 Confluence
       7.4.3 Enterprise Architect
       7.4.4 Google Sheets (simple pero efectivo)

8. PRIORIZACIÓN DE CASOS DE USO
   8.1 Por Qué Priorizar
       8.1.1 No Todo se Puede Construir al Mismo Tiempo
       8.1.2 Valor vs Esfuerzo vs Riesgo
   8.2 Criterios de Priorización
       8.2.1 Criterio 1: Valor de Negocio (1-10)
       8.2.2 Criterio 2: Riesgo Técnico (1-10)
       8.2.3 Criterio 3: Dependencias (bloqueante vs independiente)
       8.2.4 Criterio 4: Esfuerzo Estimado (S, M, L, XL)
   8.3 Técnica MoSCoW
       8.3.1 Must Have (Imprescindible)
       8.3.2 Should Have (Importante)
       8.3.3 Could Have (Deseable)
       8.3.4 Won't Have (No en este release)
   8.4 Matriz de Priorización: Valor vs Esfuerzo
       8.4.1 Cuadrante 1: Alto Valor, Bajo Esfuerzo (PRIORIDAD 1)
       8.4.2 Cuadrante 2: Alto Valor, Alto Esfuerzo (PRIORIDAD 2)
       8.4.3 Cuadrante 3: Bajo Valor, Bajo Esfuerzo (PRIORIDAD 3)
       8.4.4 Cuadrante 4: Bajo Valor, Alto Esfuerzo (POSTERGAR)
   8.5 Ejemplo: 42 UC Priorizados
       8.5.1 Aplicar MoSCoW a los 42 UC
             - Must: 15 UC
             - Should: 18 UC
             - Could: 7 UC
             - Won't: 2 UC
       8.5.2 Aplicar Matriz Valor-Esfuerzo
       8.5.3 Resultado: Orden de Implementación
   8.6 Ajustes por Dependencias
       8.6.1 UC-09 debe ir después de UC-04 (dependencia)
       8.6.2 UC-110 debe ir primero (autenticación base)

9. ROADMAP Y PLANIFICACIÓN
   9.1 De UC Priorizados a Roadmap
       9.1.1 Definir Releases/Incrementos
       9.1.2 Asignar UC a Releases
   9.2 Ejemplo: Roadmap de 4 Releases (6 meses)
       RELEASE 1 (MVP - 2 meses):
         - 12 UC Must Have fundamentales
         - Ejemplo: UC-110, UC-04, UC-40, UC-50, etc.
       RELEASE 2 (2 meses):
         - 10 UC Must Have + 5 Should Have
       RELEASE 3 (1.5 meses):
         - 8 Should Have + 3 Could Have
       RELEASE 4 (0.5 mes - pulido):
         - 4 Could Have + ajustes
   9.3 Gantt Chart Simplificado
   9.4 Gestión de Cambios
       9.4.1 ¿Qué Pasa si Aparece Nuevo UC?
       9.4.2 ¿Qué Pasa si UC Resulta Más Complejo?
       9.4.3 Re-Priorización Durante Ejecución
   9.5 Comunicación del Roadmap a Stakeholders

10. CASOS ESPECIALES Y MEJORES PRÁCTICAS
    10.1 UC de Administración: ¿Incluir o No?
         10.1.1 Argumentos a Favor
         10.1.2 Argumentos en Contra
         10.1.3 Recomendación: Incluir, pero Baja Prioridad
    10.2 UC Técnicos vs UC de Negocio
         10.2.1 Diferencias
         10.2.2 Ejemplo: UC-230 "Backup" es técnico pero necesario
         10.2.3 Documentar Diferente (menos detalle en negocio)
    10.3 Granularidad: ¿Cuándo Dividir UC Grande?
         10.3.1 Señales de UC Muy Grande
         10.3.2 Técnica de División
         10.3.3 Ejemplo: UC-141 original (20 pasos) → dividir en 3 UC
    10.4 UC de Reportes: ¿Uno por Reporte o Agrupados?
         10.4.1 Opción A: UC por Reporte (muchos UC)
         10.4.2 Opción B: UC Genérico "Generar Reportes" (menos UC)
         10.4.3 Recomendación: Depende de complejidad
    10.5 UC de APIs: ¿Cómo Documentar?
         10.5.1 API como Actor
         10.5.2 Ejemplo: UC-211 "API: Recibir Orden Externa"
         10.5.3 Diferencias en Documentación
    10.6 UC de Mantenimiento/Jobs
         10.6.1 Jobs Batch vs UC Interactivos
         10.6.2 Ejemplo: UC-07 (notificación automática) ya visto en PARTE 2
    10.7 Versionado de UC
         10.7.1 Cuándo Crear Nueva Versión vs Modificar
         10.7.2 Control de Cambios en UC

11. EJERCICIOS COMPLETOS CON SOLUCIONES
    
    11.1 EJERCICIO 1: Análisis CRUD Completo
         Enunciado:
           Dado el siguiente modelo de dominio con 5 entidades:
           - Cliente
           - Proyecto
           - Empleado
           - Tarea
           - Factura
           
           Aplicar análisis CRUD completo:
           1. Clasificar entidades por tipo
           2. Determinar operaciones CRUD necesarias
           3. Generar lista de UC
           4. Desarrollar 2 UC completos
         
         SOLUCIÓN COMPLETA:
           (10-15 páginas de solución detallada)
    
    11.2 EJERCICIO 2: Identificar UC desde Eventos
         Enunciado:
           Sistema de Biblioteca Digital
           Actores identificados:
           - Lector
           - Bibliotecario
           - Sistema de Pago (externo)
           
           Identificar eventos y derivar UC
         
         SOLUCIÓN COMPLETA:
           (8-10 páginas)
    
    11.3 EJERCICIO 3: UC desde Mockups
         Enunciado:
           Se proveen 3 mockups de:
           - Pantalla de Login
           - Dashboard de Ventas
           - Configuración de Usuario
           
           Derivar UC de cada mockup
         
         SOLUCIÓN COMPLETA:
           (10 páginas con mockups ASCII y UC derivados)
    
    11.4 EJERCICIO 4: Caso Completo de Inicio a Fin
         Enunciado:
           Sistema de Gestión de Gimnasio
           
           Datos provistos:
           - 15 Business Rules (Parte 1+2 ya aplicadas → 5 UC)
           - Modelo de dominio (8 entidades)
           - 3 actores principales
           - 5 mockups de pantallas
           - Transcripción de entrevista con dueño
           
           Aplicar las 4 técnicas de PARTE 3:
           1. Análisis CRUD
           2. Eventos de Larman
           3. Análisis UI
           4. Requerimientos de stakeholder
           
           Consolidar y priorizar
           
           Resultado esperado:
           - Lista de 30-40 UC totales
           - 5 UC completamente desarrollados
           - Roadmap de 3 releases
         
         SOLUCIÓN COMPLETA:
           (25-30 páginas con todo el proceso documentado)

12. RESUMEN Y CIERRE DE METODOLOGÍA COMPLETA
    12.1 Recapitulación de las 3 PARTES
         12.1.1 PARTE 1: Identificar y Clasificar BR
                Entregable: Catálogo de 45 BR clasificadas
         12.1.2 PARTE 2: Transformar BR en UC
                Entregable: 10 UC de BR + Trazabilidad
         12.1.3 PARTE 3: Identificar UC Adicionales
                Entregable: 32 UC adicionales + Consolidación
                TOTAL: 42 UC finales
    12.2 Flujo Completo: De Nada a Sistema Especificado
         Diagrama de flujo end-to-end (PlantUML grande)
    12.3 Entregables Finales de Metodología Completa
         12.3.1 Catálogo de Business Rules (PARTE 1)
         12.3.2 Modelo de Dominio (PARTE 1, expandido en PARTE 2)
         12.3.3 Catálogo de Casos de Uso (PARTE 2 + PARTE 3)
         12.3.4 Functional Requirements (derivados en PARTE 2)
         12.3.5 Matriz de Trazabilidad Completa (BR → UC → FR)
         12.3.6 Roadmap Priorizado (PARTE 3)
    12.4 Métricas de Éxito de la Metodología
         12.4.1 Cobertura: ¿Todos los UC justificados?
         12.4.2 Trazabilidad: ¿Todo rastreable a fuente?
         12.4.3 Completitud: ¿Sistema completamente especificado?
    12.5 Próximos Pasos: Del Análisis al Diseño
         12.5.1 Diseño de Arquitectura
         12.5.2 Diseño Detallado por UC
         12.5.3 Implementación
         12.5.4 Testing basado en UC
    12.6 Reflexión Final
         La Importancia de la Metodología Rigurosa
    12.7 Referencias y Recursos Adicionales
```

---

## EJEMPLOS CLAVE QUE DEBEN ESTAR COMPLETOS

### 1. UC-40: Registrar Nuevo Producto (CRUD)
- Sección 2.5
- Longitud: 150-200 líneas
- Incluye: Flujo normal (8 pasos), 3 FA completos, precondiciones, postcondiciones, BR aplicadas

### 2. UC-61, UC-62, UC-63: Eventos del Estudiante
- Sección 3.2.4
- Longitud: 300-400 líneas total (100+ cada uno)
- UC-62 especialmente detallado con casos edge

### 3. UC-90: Consultar Inventario Actual
- Sección 3.3.7
- Longitud: 150 líneas
- Operación compleja con filtros múltiples, exportación

### 4. UC-110: Iniciar Sesión
- Sección 3.4.3
- Longitud: 120 líneas
- Clásico pero con 2FA, captcha, intentos fallidos

### 5. UC-112: Recuperar Contraseña
- Sección 3.4.3
- Longitud: 180 líneas
- Flujo completo con email, token, expiración

### 6. UC-121: Administrar Roles y Permisos
- Sección 3.4.4
- Longitud: 200 líneas
- Complejo con matriz de permisos

### 7. UC-130: Consultar Log de Auditoría
- Sección 3.4.5
- Longitud: 150 líneas
- Con filtros avanzados por fecha, usuario, acción

### 8. UC-141: Reporte Uso por Departamento
- Sección 3.4.6
- Longitud: 180 líneas
- Parámetros, gráficos, exportación

### 9. UC-150: Ver Dashboard del Coordinador
- Sección 4.3.1
- Longitud: 200 líneas
- Multiple widgets, personalizalizable

### 10. UC-160: Buscar Productos con Múltiples Criterios
- Sección 4.4.2
- Longitud: 170 líneas
- 8 criterios de búsqueda, combinaciones, guardado

### 11. UC-170: Aprobar Múltiples Solicitudes
- Sección 4.5.2
- Longitud: 160 líneas
- Bulk action complejo con validaciones

### 12. UC-190: Ver Notificaciones
- Sección 4.5.4
- Longitud: 130 líneas
- In-app notifications con estados

### 13. UC-200: Generar Reporte OSHA Anual
- Sección 5.3.1
- Longitud: 180 líneas
- Compliance, formato específico, validaciones

### 14. UC-210: Sincronizar con SAP
- Sección 5.3.2
- Longitud: 200 líneas
- Integración compleja, manejo de errores, retry

### 15. UC-220: Analizar Tendencias de Consumo
- Sección 5.3.3
- Longitud: 190 líneas
- Análisis con ML básico, predicciones

### 16. UC-231: Restaurar desde Backup
- Sección 5.3.4
- Longitud: 150 líneas
- Técnico pero crítico, validaciones de integridad

### 17. UC-240: Reporte Gastos por Departamento
- Sección 5.4.4
- Longitud: 160 líneas
- Derivado de entrevista real

### 18. Consolidación de UC-53 + UC-181
- Sección 6.3.2
- Longitud: 100 líneas
- Ejemplo de cómo fusionar 2 UC similares

### 19. Ejercicio 4: Gimnasio - Caso Completo
- Sección 11.4
- Longitud: 2,000+ líneas (el más largo)
- Demuestra aplicación de toda la metodología

### 20. Diagrama End-to-End: De BR a Código
- Sección 12.2
- Diagrama PlantUML grande mostrando flujo completo

---

## DIAGRAMAS PLANTUML REQUERIDOS

1. Proceso General de PARTE 3 (smetana)
2. Clasificación de Entidades para CRUD (default)
3. Tabla de Decisión CRUD (activity)
4. Actores y Sus Eventos (usecase)
5. Categorías de Operaciones (mindmap)
6. Responsabilidades del Sistema (component)
7. Mockup to UC Flow (smetana)
8. Dashboard Mockup (ASCII in code block)
9. Dependencias Entre UC (elk)
10. Sistemas de Numeración (class diagram)
11. Matriz Valor-Esfuerzo (activity custom)
12. Roadmap de 4 Releases (gantt)
13. División de UC Grande (activity)
14. Flujo End-to-End Completo (smetana - GRANDE)
15. Métricas de Éxito (mindmap)

---

## MÉTRICAS OBJETIVO

```
Longitud total: ~9,700 líneas
Distribución:
  - Introducción: 600 líneas (6%)
  - Técnica 1 (CRUD): 1,200 líneas (12%)
  - Técnica 2 (Larman): 1,800 líneas (19%) ← La más larga
  - Técnica 3 (UI): 900 líneas (9%)
  - Técnica 4 (Stakeholders): 700 líneas (7%)
  - Consolidación: 600 líneas (6%)
  - Numeración: 400 líneas (4%)
  - Priorización: 700 líneas (7%)
  - Roadmap: 500 líneas (5%)
  - Casos Especiales: 600 líneas (6%)
  - Ejercicios: 1,200 líneas (12%) ← Ejercicio 4 es 2,000+
  - Resumen: 500 líneas (5%)

UC completamente desarrollados: 20 UC
UC con desarrollo parcial: 22 UC
Ejercicios con solución completa: 4
Diagramas PlantUML: 15
```

---

## NOTAS DE ESTILO

- Mantener Abstracto Real: teoría + ejemplos concretos
- Sin emojis (excepto ⭐ para énfasis MUY crítico)
- PlantUML todos con monochrome true, shadowing false
- Ejemplos COMPLETOS, no truncados
- Ejercicios con SOLUCIONES COMPLETAS, no solo enunciados
- Trazabilidad explícita en todos los ejemplos
- Código/SQL cuando sea necesario para claridad
- Referencias a PARTE 1 y PARTE 2 frecuentes

---

## VALIDACIÓN DE COMPLETITUD

PARTE 3 estará completa cuando:

✓ Las 4 técnicas estén explicadas con proceso paso a paso
✓ Al menos 5 ejemplos completos por técnica (20 UC totales)
✓ Consolidación demuestre fusión real de UC duplicados
✓ Priorización con ejemplo real de 40+ UC
✓ Roadmap muestre plan de 4 releases concreto
✓ 4 ejercicios con soluciones de 5-30 páginas cada uno
✓ 15 diagramas PlantUML incluidos
✓ Sección 12 cierre metodología completa de 3 partes
✓ Sin secciones "TODO" o "pendiente"
✓ Todos los ejemplos guía numerados completos
✓ ~9,700 líneas alcanzadas


