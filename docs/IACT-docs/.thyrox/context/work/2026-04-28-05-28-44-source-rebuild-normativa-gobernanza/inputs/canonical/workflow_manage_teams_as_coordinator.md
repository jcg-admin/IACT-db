---
id: GUIA-WORKFLOW-MANAGE-TEAMS-AS-COORDINATOR
tipo: guia_operativa
categoria: workflows
audiencia: coordinadores-equipo
prioridad: P2
tiempo_lectura: 12 minutos
version: 1.0.0
fecha: 2025-01-15
relacionados: ["CASOS_DE_USO_SISTEMA_PERMISOS", "UC-002", "prioridad_04_modulos_gestion"]
---

# Gestión de Equipos y Operaciones de Coordinación

## Propósito

Esta guía explica cómo coordinadores de equipo gestionan sus equipos, horarios, tickets escalados y generan reportes operativos.

## Audiencia

Esta guía está dirigida a: **Coordinadores de equipo** que supervisan agentes y operaciones diarias.

## Pre-requisitos

- [ ] Tener cuenta con grupos `atencion_cliente_avanzada`, `gestion_equipos`, `gestion_horarios`, `analisis_operativo`
- [ ] Tener un equipo asignado
- [ ] Conocer a los agentes de tu equipo
- [ ] Acceso al panel de coordinación

## Tiempo estimado

Tiempo de lectura: 12 minutos
Tiempo de ejecución: Variable según tarea

## Contexto: Responsabilidades del Coordinador

Como coordinador, tienes acceso a **37 capacidades** distribuidas en 4 grupos:

**atencion_cliente_avanzada (16 capacidades)**:
- Todas las operaciones básicas de atención
- Cerrar y reabrir tickets
- Escalar casos complejos
- Escuchar y descargar grabaciones
- Ver historial completo de clientes

**gestion_equipos (6 capacidades)**:
- Ver y editar equipos
- Asignar agentes a equipos
- Ver métricas del equipo

**gestion_horarios (6 capacidades)**:
- Crear y aprobar horarios
- Gestionar turnos del equipo

**analisis_operativo (9 capacidades)**:
- Ver métricas detalladas
- Generar reportes personalizados
- Crear alertas operativas

## Pasos

### 1. Gestionar Performance Semanal del Equipo

**Navegación**:
1. Ir a **Coordinación > Mi Equipo**
2. Seleccionar período: "Última semana"

**Vista de dashboard**:
```
Equipo Norte - Métricas Semanales
Período: 01-Nov-2025 al 07-Nov-2025

Agentes: 8
Llamadas atendidas: 1,247
Tickets cerrados: 892
Tiempo promedio: 4m 23s
Satisfacción: 87%
```

**Generar reporte**:
1. Hacer clic en **Generar Reporte**
2. Seleccionar formato: PDF
3. Incluir: Métricas por agente

**Output esperado**:
```
Reporte generado: reporte_equipo_norte_2025_11_01-07.pdf
Tamaño: 2.3 MB
Secciones:
  - Resumen ejecutivo
  - Métricas por agente (8 agentes)
  - Gráficos de tendencias
  - Recomendaciones automáticas
```

### 2. Cerrar Tickets Pendientes de Agentes

**Caso**: Agente Ana López tiene 15 tickets abiertos ya resueltos

**Pasos**:
1. Ir a **Coordinación > Tickets del Equipo**
2. Filtrar por: Agente = "Ana López", Estado = "Abierto"
3. Revisar ticket T-12345

**Vista de ticket**:
```
Ticket: T-12345
Cliente: Juan Pérez
Asunto: Consulta sobre facturación
Estado: Abierto
Asignado a: Ana López
Última actualización: 05-Nov-2025 14:30
Comentarios: 3
```

**Cerrar ticket**:
1. Revisar comentarios y resolución
2. Hacer clic en **Cerrar Ticket**
3. Agregar nota de cierre:

```
Nota: Ticket resuelto correctamente.
Cliente confirmó resolución.
Cerrado por: Carlos Ruiz (Coordinador)
```

**Output esperado**:
```
Ticket T-12345 cerrado exitosamente
Estado: Cerrado
Fecha de cierre: 2025-11-07 10:15
Tiempo de resolución: 2 días 4 horas
Métricas del agente actualizadas
```

### 3. Crear Turno Extraordinario para Refuerzo

**Caso**: Próximo lunes requiere refuerzo por alta demanda

**Pasos**:
1. Ir a **Coordinación > Horarios**
2. Hacer clic en **Crear Turno**
3. Completar formulario:

```
Fecha: 11-Nov-2025 (Lunes)
Turno: Extraordinario - Tarde
Horario: 14:00 - 20:00
Agentes requeridos: 2
Asignar a:
  ☑ María García
  ☑ Luis Martínez
Motivo: Alta demanda proyectada
Tipo: Horas extras
```

**Validación del sistema**:
```
Validando disponibilidad de agentes...
María García: Disponible
Luis Martínez: Disponible

Calculando horas extras...
María García: 6 horas extras
Luis Martínez: 6 horas extras

Total horas extras: 12 horas
Costo estimado: $240 USD

REQUIERE APROBACIÓN: Horas extras
Aprobador: Director de Operaciones
```

**Enviar solicitud**:
```
Solicitud de aprobación enviada
ID: APR-2025-00123
Estado: Pendiente
Aprobador: Director de Operaciones
Notificación enviada: Sí
```

### 4. Escalar Ticket Complejo

**Caso**: Ticket requiere intervención técnica especializada

**Pasos**:
1. Ir a **Tickets > T-12567**
2. Revisar situación:

```
Ticket: T-12567
Cliente: Empresa ABC S.A.
Asunto: Error en integración API
Prioridad: Alta
Agente actual: Ana López

Descripción:
Cliente reporta error 500 en llamadas API.
Requiere análisis técnico de logs del servidor.
```

**Escalar ticket**:
1. Hacer clic en **Escalar**
2. Completar formulario:

```
Escalar a: Equipo Técnico
Prioridad: Alta
Motivo: Requiere análisis de logs del servidor
Notas adicionales: Cliente VIP, SLA de 4 horas
Adjuntar: logs_api_error_500.txt
```

**Output esperado**:
```
Ticket escalado exitosamente
Nuevo asignado: Equipo Técnico
Prioridad: Alta
SLA: 4 horas
Notificaciones enviadas:
  - Ana López (agente original)
  - Equipo Técnico
  - Cliente (notificación automática)
Auditoría registrada: Sí
```

### 5. Aprobar Solicitud de Horario de Agente

**Caso**: Agente solicita cambio de turno

**Pasos**:
1. Ir a **Coordinación > Solicitudes Pendientes**
2. Ver solicitud:

```
Solicitud: SOL-2025-00456
Tipo: Cambio de turno
Solicitante: Ana López
Fecha solicitada: 12-Nov-2025
Turno actual: Mañana (08:00-14:00)
Turno solicitado: Tarde (14:00-20:00)
Motivo: Trámite personal urgente
```

**Evaluar disponibilidad**:
```
Verificando disponibilidad...
Turno mañana 12-Nov-2025:
  - Agentes programados: 5
  - Agentes mínimos: 4
  - Disponibilidad si se aprueba: 4 (JUSTO EN MÍNIMO)

Turno tarde 12-Nov-2025:
  - Agentes programados: 6
  - Agentes mínimos: 5
  - Disponibilidad si se aprueba: 7 (OK)
```

**Aprobar**:
1. Hacer clic en **Aprobar**
2. Agregar comentario:

```
Aprobado. Cubre mínimos requeridos.
Aprobado por: Carlos Ruiz
Condición: Buscar reemplazo para turno mañana si es posible
```

**Output esperado**:
```
Solicitud aprobada
Nuevo turno de Ana López: Tarde (14:00-20:00) - 12-Nov-2025
Turno actualizado en calendario
Notificación enviada a Ana López
Recordatorio: Buscar reemplazo opcional para turno mañana
```

## Validación

Para validar que completaste correctamente esta guía:

- [ ] Reportes generados incluyen todos los agentes del equipo
- [ ] Tickets cerrados cambian estado correctamente
- [ ] Turnos extraordinarios quedan pendientes de aprobación si son horas extras
- [ ] Tickets escalados se asignan al equipo correcto
- [ ] Solicitudes aprobadas actualizan el calendario

## Cómo interpretar resultados

**Éxito**:
- Métricas del equipo se actualizan en tiempo real
- Agentes reciben notificaciones de cambios en sus tickets/horarios
- Auditoría registra todas las acciones del coordinador
- Dashboard muestra datos actualizados

**Errores comunes**: Ver sección Troubleshooting

## Troubleshooting

### Error 1: No puedo cerrar ticket de otro equipo

**Síntomas**:
```
ERROR: No autorizado para cerrar ticket T-99999
Motivo: Ticket asignado a equipo "Equipo Sur"
Tu equipo: "Equipo Norte"
```

**Causa**: Solo puedes gestionar tickets de tu equipo asignado

**Solución**:
```
1. Verificar que el ticket pertenezca a tu equipo
2. Si es ticket escalado a tu equipo: Aceptar escalamiento primero
3. Si es de otro equipo: Contactar al coordinador responsable
4. Si debe transferirse: Usar función "Transferir a otro equipo"
```

### Error 2: Turno extraordinario rechazado automáticamente

**Síntomas**:
```
ERROR: No se puede crear turno
Motivo: María García ya tiene 48 horas esta semana
Límite semanal: 48 horas
```

**Causa**: Límites laborales automáticos del sistema

**Solución**:
```
1. Verificar horas trabajadas del agente en la semana
2. Seleccionar otro agente con horas disponibles
3. Si es urgente: Solicitar excepción al Director de Operaciones
4. Considerar distribuir las horas entre varios agentes
```

### Error 3: Métricas no coinciden con las esperadas

**Síntomas**:
```
Dashboard muestra:
  Tickets cerrados: 450

Expectativa del coordinador: ~600
Diferencia: -150 tickets
```

**Causa**: Métricas solo incluyen tickets del equipo asignado

**Solución**:
```
1. Verificar filtros aplicados:
   - Período correcto
   - Equipo = "Tu equipo"
   - Estado = "Todos" o "Cerrados"

2. Verificar que agentes no hayan sido transferidos a otro equipo

3. Revisar tickets escalados que ya no cuentan para el equipo

4. Generar reporte detallado para auditoría si persiste la discrepancia
```

## Buenas Prácticas

### 1. Revisar Métricas Diariamente

Monitorear performance del equipo cada mañana:

```
Checklist diario:
☐ Revisar dashboard de métricas
☐ Identificar agentes con tickets atrasados
☐ Verificar cumplimiento de SLAs
☐ Revisar satisfacción del cliente
☐ Atender alertas activas
```

### 2. Comunicación Proactiva con el Equipo

Notificar cambios importantes:

```
Cuando cerrar tickets de agentes:
✓ Agregar nota explicativa
✓ Notificar al agente del cierre
✓ Reconocer buen trabajo en comentarios

Cuando modificar horarios:
✓ Notificar con anticipación (>24h)
✓ Explicar motivo del cambio
✓ Confirmar disponibilidad antes
```

### 3. Escalamiento Estratégico

Escalar solo cuando sea necesario:

```
Escalar SI:
- Requiere conocimiento técnico especializado
- Cliente VIP con alta prioridad
- Caso complejo fuera del alcance del agente
- SLA en riesgo

NO escalar SI:
- Agente puede resolverlo con más tiempo
- Solo requiere aprobación estándar
- Es parte del aprendizaje del agente
```

### 4. Gestión de Turnos Eficiente

Optimizar asignación de turnos:

```
Consideraciones:
- Balancear carga entre agentes
- Rotar turnos difíciles equitativamente
- Respetar preferencias cuando sea posible
- Planificar con 2 semanas de anticipación
- Dejar buffer para contingencias
```

## Casos de Uso Reales

### Caso A: Agente con Bajo Rendimiento

**Situación**: Ana tiene 20 tickets abiertos, promedio del equipo es 8

**Acciones**:
```
1. Revisar tickets individuales:
   - Identificar si hay tickets complejos
   - Verificar si necesita ayuda técnica

2. Analizar métricas del agente:
   - Tiempo promedio de resolución
   - Satisfacción del cliente
   - Tipos de casos que atiende

3. Tomar acción:
   - Cerrar tickets ya resueltos (si aplica)
   - Reasignar tickets muy complejos
   - Programar sesión de retroalimentación
   - Considerar capacitación adicional
```

### Caso B: Pico de Demanda No Planificado

**Situación**: Lunes por la mañana, 50 llamadas en cola

**Acciones**:
```
1. Evaluación inmediata:
   - Agentes disponibles: 4
   - Agentes necesarios: ~6
   - Déficit: 2 agentes

2. Soluciones rápidas:
   - Llamar a agentes de guardia (si existen)
   - Solicitar apoyo temporal de otro equipo
   - Priorizar llamadas urgentes

3. Soluciones a corto plazo:
   - Crear turnos extraordinarios para próximos días
   - Solicitar aprobación de horas extras
   - Ajustar calendario de la semana
```

### Caso C: Cliente VIP Escalado

**Situación**: Cliente VIP con problema crítico, SLA 2 horas

**Acciones**:
```
1. Revisión inmediata:
   ☐ Leer descripción completa del caso
   ☐ Verificar historial del cliente
   ☐ Identificar recursos necesarios

2. Asignación estratégica:
   ☐ Asignar a agente senior disponible
   ☐ Establecer prioridad "Crítica"
   ☐ Monitorear progreso cada 30 minutos

3. Escalamiento si es necesario:
   ☐ Notificar a Director de Operaciones
   ☐ Involucrar área técnica si aplica
   ☐ Mantener comunicación constante con cliente
```

## Próximos pasos

Después de completar esta guía, puedes continuar con:

1. **GUIA-WORKFLOWS-007**: Auditoría de Permisos y Compliance
2. **GUIA-WORKFLOWS-005**: Gestión de Usuarios (para entender permisos de tu equipo)
3. **CASOS_DE_USO_SISTEMA_PERMISOS.md > UC-002**: Caso completo de Carlos Ruiz
4. **prioridad_04_modulos_gestion.md**: Especificación técnica de módulos

## Referencias

- Documentación técnica: `docs/backend/requisitos/CASOS_DE_USO_SISTEMA_PERMISOS.md`
- Casos de uso: UC-002 (Carlos Ruiz - Coordinador)
- Módulos relacionados: `prioridad_04_modulos_gestion.md`
- Catálogo de grupos: `CATALOGO_GRUPOS_FUNCIONALES.md`

## Feedback

Si encuentras problemas con esta guía o tienes sugerencias:
- Crea un issue en GitHub con label `documentation`
- Contacta a: equipo-backend

---

**Mantenedores**: equipo-backend, equipo-documentacion
**Última actualización**: 2025-11-07
