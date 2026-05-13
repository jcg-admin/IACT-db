---
id: GUIA-ONBOARDING-008
tipo: guia_operativa
categoria: onboarding
audiencia: agentes-atencion
prioridad: P1
tiempo_lectura: 10 minutos
version: 1.0.0
fecha: 2025-11-07
relacionados: ["CASOS_DE_USO_SISTEMA_PERMISOS", "UC-001", "CATALOGO_GRUPOS_FUNCIONALES"]
---

# Operaciones Básicas para Agentes de Atención al Cliente

## Propósito

Esta guía explica las operaciones diarias que realizan los agentes de atención al cliente: atender llamadas, crear tickets, consultar información de clientes.

## Audiencia

Esta guía está dirigida a: **Agentes de atención al cliente** que operan el sistema diariamente.

## Pre-requisitos

- [ ] Tener cuenta activa con grupos `atencion_cliente` y `visualizacion_basica`
- [ ] Haber completado capacitación inicial
- [ ] Tener acceso al sistema y diadema/headset configurado
- [ ] Conocer políticas de atención al cliente

## Tiempo estimado

Tiempo de lectura: 10 minutos
Tiempo para primera llamada: 5 minutos

## Contexto: Tu Rol como Agente

Como agente, tienes acceso a **11 capacidades** distribuidas en 2 grupos:

**atencion_cliente (9 capacidades)**:
- Realizar y recibir llamadas
- Transferir llamadas a otros agentes
- Crear, ver y editar tickets
- Asignar tickets a otros agentes
- Ver y editar información básica de clientes

**visualizacion_basica (2 capacidades)**:
- Ver tu dashboard personal
- Exportar datos de tu dashboard

**Qué NO puedes hacer** (requieren permisos adicionales):
- Cerrar tickets (solo coordinadores)
- Escuchar grabaciones de llamadas (solo coordinadores/calidad)
- Gestionar equipos o horarios
- Aprobar solicitudes

## Pasos

### 1. Iniciar Tu Jornada Laboral

**Al llegar**:
1. Iniciar sesión en el sistema
2. Verificar estado del headset/diadema
3. Establecer disponibilidad:

**Pantalla de estado**:
```
Agente: Ana López
Estado actual: Fuera de línea

Cambiar estado a:
○ Disponible       - Listo para recibir llamadas
○ En descanso      - Pausa programada
○ Capacitación     - En entrenamiento
○ Fuera de línea   - No disponible
```

**Seleccionar**: Disponible

**Output esperado**:
```
Estado actualizado
Agente: Ana López
Estado: DISPONIBLE
Cola de llamadas: 12 llamadas en espera
Posición en equipo: 4/8 agentes disponibles
Próxima llamada asignada automáticamente
```

### 2. Atender Llamada Entrante

**Notificación**:
```
LLAMADA ENTRANTE

Cliente: Juan Pérez
Número: +52 55 1234 5678
Cuenta: 123456
Historial: 3 llamadas previas
Último contacto: 01-Nov-2025

[ACEPTAR]  [RECHAZAR]
```

**Aceptar llamada**:
1. Hacer clic en **ACEPTAR**
2. El sistema abre automáticamente la ficha del cliente

**Pantalla de llamada activa**:
```
LLAMADA EN CURSO - 00:00:23

Cliente: Juan Pérez
Cuenta: 123456
Email: juan.perez@email.com
Teléfono: +52 55 1234 5678

Historial reciente:
- 01-Nov-2025: Consulta sobre factura (Cerrado)
- 15-Oct-2025: Cambio de plan (Cerrado)
- 10-Oct-2025: Soporte técnico (Cerrado)

Tickets abiertos: 0

[CREAR TICKET]  [TRANSFERIR]  [FINALIZAR]
```

**Durante la llamada**:
- Escuchar activamente al cliente
- Tomar notas si es necesario
- Consultar información en la ficha del cliente
- Resolver la consulta si es posible

### 3. Crear Ticket Durante la Llamada

**Caso**: Cliente solicita seguimiento de un caso

**Pasos**:
1. Durante la llamada, hacer clic en **CREAR TICKET**
2. Completar formulario:

```
Crear Nuevo Ticket

Título: Consulta sobre cambio de domicilio fiscal
Cliente: Juan Pérez (autocompletado)
Llamada: CALL-2025-11-07-00123 (autocompletado)

Descripción:
Cliente solicita cambio de domicilio fiscal.
Requiere envío de documentos:
- IFE/INE
- Comprobante de domicilio
- RFC actualizado

Prioridad:
○ Baja
● Normal
○ Alta
○ Crítica

Categoría: Documentación

[CREAR]  [CANCELAR]
```

**Crear ticket**:

**Output esperado**:
```
Ticket creado exitosamente

ID: T-12345
Estado: Abierto
Asignado a: Ana López (tú)
Creado: 2025-11-07 09:15
Prioridad: Normal

NEXT STEPS:
1. Informar al cliente del número de ticket: T-12345
2. Explicar próximos pasos
3. Cerrar llamada cuando esté listo
```

### 4. Finalizar Llamada

**Al terminar la conversación**:
1. Resumir acuerdos con el cliente
2. Proporcionar número de ticket si aplica
3. Hacer clic en **FINALIZAR**

**Pantalla de resumen**:
```
Resumen de Llamada

Duración: 4 minutos 23 segundos
Cliente: Juan Pérez
Ticket creado: T-12345
Resultado:
○ Resuelto en llamada
● Requiere seguimiento
○ Escalado

Notas finales (opcional):
Cliente informado de documentos necesarios.
Enviar email con lista de documentos.

[GUARDAR Y CONTINUAR]
```

**Output esperado**:
```
Llamada finalizada y registrada

Duración: 4m 23s
Ticket: T-12345 (Abierto)
Próxima acción: Enviar email con lista de documentos
Estado: Volviendo a disponible en 5 segundos...

Estadísticas del día:
Llamadas atendidas: 12
Tickets creados: 5
Tiempo promedio: 5m 10s
```

### 5. Dar Seguimiento a Tickets

**Acceder a tus tickets**:
1. Ir a **Mis Tickets**
2. Ver lista de tickets abiertos:

```
Mis Tickets Activos (8)

ID       Cliente          Asunto                    Prioridad  Edad
T-12345  Juan Pérez       Cambio domicilio fiscal   Normal     5m
T-12340  María García     Consulta facturación      Normal     2h
T-12338  Luis Ramírez     Soporte técnico          Alta       1d
T-12330  Ana Martínez     Cambio de plan           Normal     2d
...

[FILTRAR]  [ORDENAR]  [EXPORTAR]
```

**Actualizar ticket**:
1. Hacer clic en ticket T-12345
2. Agregar comentario:

```
Actualizar Ticket T-12345

Última actualización: hace 5 minutos

Historial:
[09:15] Ana López: Ticket creado
Cliente solicita cambio de domicilio fiscal.
Documentos requeridos: INE, comprobante domicilio, RFC.

Agregar comentario:
Email enviado al cliente con lista de documentos.
Esperando recepción de documentos.
Fecha esperada: 10-Nov-2025

Estado:
● Mantener abierto
○ Cerrar ticket (NO PERMITIDO - requiere coordinador)

[GUARDAR COMENTARIO]
```

**Output esperado**:
```
Comentario agregado exitosamente

Ticket: T-12345
Última actualización: hace 1 minuto
Estado: Abierto
Próxima revisión: 10-Nov-2025
```

### 6. Transferir Llamada a Otro Agente

**Caso**: Llamada requiere conocimiento especializado

**Durante la llamada**:
1. Explicar al cliente que será transferido
2. Hacer clic en **TRANSFERIR**

**Seleccionar destino**:
```
Transferir Llamada

Llamada actual: CALL-2025-11-07-00145
Cliente: Pedro Sánchez
Motivo: Consulta técnica de facturación electrónica

Transferir a:
● Otro agente
○ Coordinador
○ Equipo especializado

Seleccionar agente disponible:
● Carlos Mendoza - Disponible (Especialista en facturación)
○ María Torres - En llamada
○ Luis Gómez - En descanso

Notas para el agente receptor:
Cliente tiene dudas sobre CFDI 4.0 y complementos de pago.
Requiere soporte técnico especializado.

[TRANSFERIR AHORA]  [CANCELAR]
```

**Transferir**:

**Output esperado**:
```
Llamada transferida exitosamente

Transferida a: Carlos Mendoza
Cliente: Pedro Sánchez
Notas compartidas: Sí
Estado: Llamada transferida
Registrada en: Historial de llamadas
```

## Validación

Para validar que completaste correctamente esta guía:

- [ ] Pudiste cambiar tu estado a "Disponible"
- [ ] Recibiste y atendiste al menos una llamada
- [ ] Creaste un ticket correctamente
- [ ] El ticket aparece en "Mis Tickets"
- [ ] Pudiste agregar comentarios al ticket
- [ ] Entiendes qué operaciones NO puedes realizar

## Cómo interpretar resultados

**Éxito**:
- Llamadas se asignan automáticamente cuando estás disponible
- Tickets creados tienen ID único (T-XXXXX)
- Dashboard muestra tus estadísticas actualizadas
- Puedes ver historial de clientes sin problemas

**Errores comunes**: Ver sección Troubleshooting

## Troubleshooting

### Error 1: No puedo cerrar ticket

**Síntomas**:
```
ERROR: No autorizado para cerrar ticket T-12345
Permiso requerido: sistema.operaciones.tickets.cerrar
Tu grupo: atencion_cliente (no incluye este permiso)
```

**Causa**: Solo coordinadores pueden cerrar tickets

**Solución**:
```
1. Si el ticket está resuelto:
   - Agregar comentario: "Ticket resuelto, listo para cierre"
   - Notificar a tu coordinador
   - El coordinador cerrará el ticket

2. Si requieres cerrar tickets frecuentemente:
   - Hablar con tu coordinador sobre tu rol
   - Solicitar grupo atencion_cliente_avanzada (requiere aprobación)
```

### Error 2: No puedo ver llamada en curso

**Síntomas**:
```
Pantalla en blanco al aceptar llamada
No se muestra información del cliente
```

**Causa**: Problema de conexión o caché del navegador

**Solución**:
```
1. Refrescar la página (F5)
2. Limpiar caché del navegador
3. Cerrar sesión y volver a iniciar
4. Si persiste: Contactar a soporte técnico
```

### Error 3: Cliente no aparece en el sistema

**Síntomas**:
```
Búsqueda de cliente: "Juan Pérez"
Resultados: 0 clientes encontrados
```

**Causa**: Cliente nuevo o datos incorrectos

**Solución**:
```
Opción A: Cliente nuevo
1. Verificar número de teléfono
2. Preguntar al cliente si es primera vez que llama
3. Solicitar datos básicos: nombre, email, teléfono
4. El sistema creará ficha automáticamente al crear ticket

Opción B: Datos incorrectos
1. Buscar por número de teléfono en lugar de nombre
2. Buscar por número de cuenta si lo tiene
3. Verificar ortografía del nombre

Opción C: Error del sistema
1. Notificar a coordinador inmediatamente
2. Tomar nota manual de los datos
3. Crear ticket con datos temporales
```

### Error 4: No puedo transferir llamada

**Síntomas**:
```
ERROR: No hay agentes disponibles para transferencia
Equipo: 0/8 agentes disponibles
```

**Causa**: Todos los agentes están ocupados

**Solución**:
```
1. Opciones inmediatas:
   - Poner llamada en espera temporal
   - Esperar 30-60 segundos
   - Reintentar transferencia

2. Si persiste:
   - Tomar nota del caso
   - Crear ticket de alta prioridad
   - Explicar al cliente que recibirá llamada de retorno
   - Notificar a coordinador del caso

3. Si es urgente:
   - Escalar directamente a coordinador (botón ESCALAR)
```

## Buenas Prácticas

### 1. Mantén Tu Dashboard Actualizado

Revisa tus métricas cada hora:

```
Checklist por hora:
☐ Tickets abiertos pendientes de actualización
☐ Llamadas en cola de retorno
☐ Tiempo promedio de atención (meta: <6 minutos)
☐ Satisfacción del cliente (meta: >85%)
```

### 2. Documenta Todo en los Tickets

Buena documentación ayuda a otros agentes:

```
Comentario BUENO:
"Cliente solicita cambio de domicilio fiscal.
Documentos requeridos: INE, comprobante, RFC.
Email enviado con instrucciones.
Fecha esperada de recepción: 10-Nov-2025.
Cliente confirmó recepción del email."

Comentario MALO:
"Enviado email"
(No proporciona contexto suficiente)
```

### 3. Usa el Sistema, No Papel

Evita notas en papel:

```
INCORRECTO:
- Apuntar datos en papel
- Prometer seguimiento sin crear ticket
- Confiar en memoria para casos pendientes

CORRECTO:
- Todo registrado en el sistema
- Ticket para cada caso que requiere seguimiento
- Usar comentarios para actualizar estado
```

### 4. Comunica Proactivamente

Mantén informados a clientes y equipo:

```
Con clientes:
✓ Proporcionar número de ticket
✓ Explicar próximos pasos
✓ Establecer expectativas realistas
✓ Confirmar datos de contacto

Con tu equipo:
✓ Notificar casos complejos a coordinador
✓ Compartir información de casos transferidos
✓ Reportar problemas del sistema
```

## Casos de Uso Diarios

### Caso A: Cliente Molesto

**Situación**: Cliente llama molesto por problema no resuelto

**Acciones**:
```
1. Escucha activa:
   ☐ Dejar que el cliente exprese su frustración
   ☐ No interrumpir
   ☐ Tomar notas de los puntos clave

2. Empatía:
   ☐ Reconocer la molestia: "Entiendo su frustración"
   ☐ Disculparse: "Lamento las molestias"

3. Acción:
   ☐ Revisar historial del cliente
   ☐ Identificar ticket anterior si existe
   ☐ Escalar a coordinador si es necesario
   ☐ Crear plan de acción concreto

4. Seguimiento:
   ☐ Crear ticket de alta prioridad
   ☐ Establecer timeline claro
   ☐ Notificar a coordinador
```

### Caso B: Primera Llamada del Día

**Situación**: Inicias tu jornada laboral

**Checklist**:
```
☐ Iniciar sesión en el sistema
☐ Verificar equipamiento (headset, internet)
☐ Revisar tickets pendientes de ayer
☐ Leer comunicados del equipo
☐ Cambiar estado a "Disponible"
☐ Prepararte mentalmente para primera llamada
```

### Caso C: Fin de Tu Turno

**Situación**: Terminas tu jornada laboral

**Antes de irte**:
```
☐ Cambiar estado a "Fuera de línea"
☐ Actualizar todos los tickets abiertos
☐ Dejar notas claras para próximo turno
☐ Cerrar sesión del sistema
☐ Reportar cualquier problema técnico
```

## Métricas de Éxito

Como agente, se miden:

```
Métricas individuales:
- Llamadas atendidas por día (meta: 40-50)
- Tiempo promedio de atención (meta: 4-6 minutos)
- Tickets creados vs cerrados por coordinador (ratio saludable)
- Satisfacción del cliente (meta: >85%)
- Asistencia y puntualidad (meta: 100%)
```

## Próximos pasos

Después de dominar estas operaciones básicas:

1. **Solicitar capacitación avanzada** para grupo `atencion_cliente_avanzada`
2. **GUIA-WORKFLOWS-006**: Entender cómo trabajan los coordinadores
3. **CASOS_DE_USO_SISTEMA_PERMISOS.md > UC-001**: Caso completo de Ana López
4. **Shadowing**: Acompañar a agente senior para aprender mejores prácticas

## Referencias

- Documentación técnica: `docs/backend/requisitos/CASOS_DE_USO_SISTEMA_PERMISOS.md`
- Caso de uso: UC-001 (Ana López - Agente)
- Catálogo de grupos: `CATALOGO_GRUPOS_FUNCIONALES.md`
- Políticas de atención: Consultar con tu coordinador

## Feedback

Si encuentras problemas con esta guía o tienes sugerencias:
- Crea un issue en GitHub con label `documentation`
- Contacta a: equipo-backend
- Habla con tu coordinador

---

**Mantenedores**: equipo-backend, equipo-documentacion
**Última actualización**: 2025-11-07
