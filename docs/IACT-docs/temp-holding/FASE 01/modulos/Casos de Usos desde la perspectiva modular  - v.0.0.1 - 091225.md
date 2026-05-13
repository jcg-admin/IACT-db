
Casos de Usos desde la perspectiva modular  - v.0.0.1 
Date: 2025-12-09

  ```
  Rehacer la lista preliminar desde cero con los 8 módulos finales
  ```


Perfecto, vamos a rehacerla desde cero, limpia, con solo los 8 módulos finales y respetando, en lo posible, los UC que ya existen en tus restricciones.

No uso SEC_RULES como módulo, todo eso vive dentro de RBAC_CORE.

---

## MOD-01 – Autenticación y Sesiones (AUTH)

Enfocado solo en login, logout, sesiones y contraseñas.

- **UC-001 – Iniciar sesión en el sistema**
    
- **UC-002 – Cerrar sesión del sistema**
    
- **UC-003 – Recuperar contraseña mediante preguntas de seguridad**
    
- **UC-004 – Cambiar contraseña**
    
- **UC-005 – Gestionar sesiones activas del usuario**  
    (ver sesiones abiertas, cerrar otras sesiones, aplicar timeout)
    

> Nota: Aunque en el documento de restricciones “Autenticación y Usuarios” agrupa más cosas, a nivel de módulos separamos “AUTH” de “USER_IDENTITY”.

---

## MOD-02 – Gestión de Identidades y Cuentas de Usuario (USER_IDENTITY)

Todo lo que sea identidad de usuario (cuenta, datos, estado, seguridad básica de perfil).

- **UC-006 – Crear cuenta de usuario**  
    (username autogenerado, estado inicial PENDIENTE_CONFIGURACION, contraseña temporal)
    
- **UC-007 – Actualizar datos de usuario**  
    (nombre, apellidos, estado, unidad organizacional, etc.)
    
- **UC-008 – Dar de baja lógica a un usuario**  
    (baja lógica, conservar datos por auditoría, `deleted_at`, `deleted_by`)
    
- **UC-009 – Gestionar preguntas de seguridad del usuario**  
    (alta, cambio, validación de mínimo 3 preguntas)
    
- **UC-010 – Consultar perfil de usuario**  
    (datos básicos, roles asignados, estado)
    

---

## MOD-03 – Administración de Roles, Segmentos y Permisos (RBAC_CORE)

Aquí vive todo el RBAC, incluida la parte de “enforcers” automática, pero sin módulo SEC_RULES separado.

- **UC-041 – Administrar catálogo de roles funcionales**  
    (crear, modificar, desactivar roles como REPORTS_VIEWER, ALERTS_MANAGER, etc.)
    
- **UC-042 – Calcular permisos efectivos de un usuario**  
    (aplicar precedencia: directo > rol > segmento; respetar SoD)
    
- **UC-043 – Asignar y retirar roles a un usuario**
    
- **UC-044 – Configurar segmentos de datos (Data Segments)**  
    (por centro, servicio, región, etc.)
    
- **UC-045 – Asignar permisos directos a un usuario con vigencia**  
    (permiso directo, justificación obligatoria, expiración máxima 6 meses)
    
- **UC-046 – Simular acceso de un usuario a un recurso**  
    (“¿qué vería este usuario?” sin iniciar sesión como él)
    
- **UC-047 – Consultar matriz de roles, segmentos y permisos**  
    (vista consolidada para gobierno/PMO)
    

> Dentro de este módulo, la lógica de “restricciones y reglas de seguridad” se implementa como validaciones internas del RBAC (no como módulo separado).

---

## MOD-04 – Supervisión del ETL, Calidad y Disponibilidad de Datos (ETL_MONITORING)

No ejecuta ETL “a mano” desde la UI; supervisa y valida que todo esté bien, alineado con el diseño de vistas y jobs que ya documentaste.

- **UC-051 – Consultar ejecuciones del ETL**  
    (histórico de jobs, duración, resultado, volumen de datos)
    
- **UC-052 – Ver detalle de una ejecución de ETL**  
    (rangos de fechas, tablas origen, métricas cargadas, tiempo, errores)
    
- **UC-053 – Consultar disponibilidad de datos por período**  
    (cuáles trimestres/fechas están completos, parcial, faltante)
    
- **UC-054 – Consultar incidencias de calidad de datos**  
    (nulos, inconsistencias, duplicados detectados en la transformación)
    
- **UC-055 – Reintentar procesamiento lógico sobre datos ya extraídos**  
    (reprocesar métricas derivadas cuando el origen está sano, sin volver a tocar MySQL)
    

---

## MOD-05 – Visualización y Reportes Operativos del IVR (VIS_REPORTS)

Unifica dashboards y reportes detallados; el RBAC decide si el usuario solo ve o también exporta.

### 1) Reportes tabulares

- **UC-017 – Consultar reporte trimestral consolidado**
    
- **UC-018 – Consultar reporte de problemas de menú/errores**
    
- **UC-019 – Consultar reporte de transferencias y rutas de llamada**
    

### 2) Filtros y criterios

- **UC-020 – Aplicar filtros de fecha a reportes y dashboards**  
    (presets, rango personalizado, límite de 2 años)
    
- **UC-021 – Aplicar filtros por centro, servicio, cola u otros campos de negocio**
    

### 3) Exportaciones

- **UC-022 – Exportar reporte a CSV**
    
- **UC-023 – Exportar reporte a Excel**
    
- **UC-024 – Exportar reporte a PDF**
    

(Límites diarios y técnicos según el documento de restricciones).

### 4) Dashboards

- **UC-025 – Consultar dashboard principal del IVR**  
    (widgets priorizados, última actualización según ETL)
    
- **UC-026 – Consultar widgets de resumen operativo**  
    (llamadas por período, distribución por servicio, top centros, etc.)
    
- **UC-027 – Ver gráficos por hora**
    
- **UC-028 – Ver gráficos por día**
    
- **UC-029 – Ver distribución por centro/servicio/menu**
    
- **UC-030 – Personalizar layout del dashboard**  
    (solo perfiles con permiso, máximo 10 widgets por vista, etc.)
    

---

## MOD-06 – Alertas Internas y Notificaciones (ALERTS)

Incluye tanto configuración de alertas como el buzón interno de notificaciones. Todo va por InternalMessage, sin email.

- **UC-036 – Configurar alerta operativa**  
    (tipo THRESHOLD/ANOMALY/TREND, severidad, destinatarios, frecuencia)
    
- **UC-037 – Recibir notificación en el buzón interno**  
    (mensaje generado por alertas, eventos del sistema u otras funciones)
    
- **UC-038 – Consultar bandeja de notificaciones**  
    (filtrar por severidad, tipo, estado leído/no leído)
    
- **UC-039 – Silenciar o posponer una alerta (snooze)**  
    (1h, 8h, 24h, personalizado)
    
- **UC-040 – Confirmar, cerrar o marcar como atendida una alerta**
    

> Nota: UC-037 aquí actúa como “caso de uso de mensajería interna” genérico, reutilizado por recuperaciones de contraseña, avisos de ETL, etc.

---

## MOD-07 – Auditoría Funcional (AUDIT)

Oriented a “qué hizo quién, sobre qué y cuándo”, con foco en acciones de negocio y seguridad.

- **UC-070 – Consultar bitácora de auditoría funcional**  
    (login/logout, cambios de permisos, creación/modificación de usuarios, exportaciones, etc.)
    
- **UC-071 – Filtrar auditoría por usuario, fecha, recurso o tipo de acción**
    
- **UC-072 – Exportar eventos de auditoría**  
    (CSV/Excel, respetando límites y políticas de retención)
    
- **UC-073 – Generar reporte de cambios de permisos y roles**  
    (para revisiones periódicas y cumplimiento)
    

---

## MOD-08 – Bitácoras Técnicas y Monitoreo del Sistema (SYS_LOGS)

Más técnico: logs de aplicación, health, métricas técnicas. Orientado a soporte/NOC/devops.

- **UC-080 – Consultar bitácoras técnicas del sistema**  
    (logs de aplicación, errores, warnings, con filtros razonables)
    
- **UC-081 – Consultar estado de salud del sistema**  
    (endpoints de health, estado de servicios, colas, conexiones, etc.)
    
- **UC-082 – Descargar paquetes de logs para análisis externo**  
    (paquete comprimido de errores en rango de tiempo acotado)
    
- **UC-083 – Consultar métricas técnicas agregadas**  
    (uso de recursos, tiempos de respuesta globales, indicadores técnicos, sin invadir lo que ya cubre VIS_REPORTS)
    

---

Si te parece bien esta lista preliminar, el siguiente paso lógico sería:

1. Congelar esta numeración para no romper referencias con el documento de restricciones.
    
2. Luego, ir módulo por módulo y detallar cada UC (objetivo, actores, precondiciones, flujo principal, flujos alternos, reglas de negocio asociadas, restricciones relevantes).
    

Si quieres, empezamos con un módulo (por ejemplo VIS_REPORTS o RBAC_CORE) y desarrollamos todos sus UC en formato plantilla de caso de uso.