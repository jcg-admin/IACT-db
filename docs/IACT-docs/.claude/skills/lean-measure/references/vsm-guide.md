# VSM Guide — Value Stream Mapping

Guía completa para construir, leer e interpretar un Value Stream Map (VSM) en procesos de manufactura y servicios.

---

## Qué es un VSM y para qué sirve

Un Value Stream Map es una representación visual de todos los pasos, tiempos e inventarios en un flujo de valor, desde el proveedor hasta el cliente. Su función en Lean:

1. **Hacer visible el waste** — las colas, esperas y pasos NVA que no son obvios en el día a día
2. **Establecer el baseline** — métricas actuales (Lead Time, PE, WIP) para comparar post-mejora
3. **Alinear al equipo** — todos ven el mismo proceso real, no el proceso imaginado
4. **Guiar el diseño To-Be** — el VSM As-Is es la base para diseñar el VSM To-Be en lean:improve

---

## Iconos VSM estándar

| Icono | Nombre | Qué representa |
|-------|--------|---------------|
| Rectángulo | Caja de proceso | Un paso del proceso con sus métricas (CT, Op, Up) |
| Triángulo ▽ | Inventario / Push | WIP o inventario acumulado entre pasos |
| Triángulo con círculo ○▽ | Supermercado | Inventario controlado en sistema pull |
| Flecha recta → | Push arrow | Material empujado según schedule/forecast |
| Flecha con círculo ○→ | Pull arrow | Material jalado por señal Kanban |
| Rayo ⚡ | Flujo de información electrónico | Señal via sistema ERP, email, sistema digital |
| Línea recta fina | Flujo de información manual | Señal en papel, verbal, reunión |
| Nube/explosión | Kaizen burst | Oportunidad de mejora identificada |

---

## Cómo construir el VSM — paso a paso

### Fase 1: Preparar (antes del Gemba)

1. **Confirmar el scope** con el Charter: punto de inicio y fin del flujo de valor
2. **Identificar la familia de producto/servicio** que será mapeada (una familia = un VSM)
3. **Preparar materiales**: papel A3 o A2, post-its, rotuladores, cronómetro, cámara
4. **Calcular el Takt Time** con los datos de demanda del cliente

### Fase 2: Mapear el cliente y proveedor

- Dibujar el cliente en la esquina superior derecha del mapa
- Dibujar el proveedor en la esquina superior izquierda
- Registrar los datos del cliente: demanda (unidades/período), frecuencia de entrega

### Fase 3: Caminar el proceso (Gemba walk)

**Regla clave: caminar de derecha a izquierda** (desde el cliente hacia el proveedor) para entender el flujo desde la perspectiva del cliente.

1. Comenzar en el último paso antes del cliente
2. Observar y cronometrar el proceso: mínimo 5 observaciones por paso
3. Contar el inventario/WIP entre cada par de pasos
4. Preguntar: ¿cómo sabe este paso cuándo y cuánto producir? (push vs pull)
5. Avanzar hacia upstream hasta llegar al proveedor

### Fase 4: Mapear el flujo de información

El flujo de información es la parte más olvidada del VSM:
- ¿Cómo se comunica al proceso qué producir? (schedule, kanban, email, ERP)
- ¿Es push (programado con anticipación) o pull (según demanda real)?
- ¿Hay desconexión entre lo que el sistema dice y lo que el proceso hace?

### Fase 5: Dibujar el timeline VA/NVA

Debajo del mapa de proceso, dibujar la línea de tiempo:
- Los tiempos de ciclo (CT) de cada paso = tiempo VA (el proceso está transformando)
- Los tiempos entre pasos (esperas, colas) = tiempo NVA

```
Ejemplo:
[CT: 5min]  [Esp: 2h]  [CT: 10min]  [Esp: 8h]  [CT: 3min]
   VA          NVA          VA          NVA          VA

Lead Time = 5min + 120min + 10min + 480min + 3min = 618min (10.3h)
VA Time = 5 + 10 + 3 = 18min
Process Efficiency = 18 / 618 = 2.9%
```

### Fase 6: Calcular las métricas de flujo

- **Lead Time total** = suma de todos los CT + todos los tiempos de espera
- **VA Time** = suma de solo los CT de pasos que agregan valor
- **Process Efficiency** = VA Time / Lead Time × 100
- **WIP total** = suma de items en todos los buffers del proceso
- **Cuello de botella** = el paso con CT más cercano o mayor al Takt Time

---

## Cómo leer un VSM — señales de alerta

| Señal en el VSM | Waste probable | Qué investigar |
|----------------|---------------|----------------|
| Triángulos ▽ grandes entre pasos | Inventory + Waiting | ¿Por qué se acumula WIP? ¿Push system? |
| CT >> Takt Time en algún paso | Waiting | El cuello de botella; ¿por qué ese paso es lento? |
| Muchos pasos NVA en el timeline | Overprocessing | ¿Qué pasos no agregan valor? ¿Por qué existen? |
| Muchos handoffs entre áreas | Transportation | ¿Por qué el trabajo viaja tanto? |
| Flujo de información solo push | Overproduction | ¿Por qué no hay señal pull del cliente? |
| Process Efficiency < 10% | Waste severo | ¿Dónde están los mayores tiempos de espera? |
| CT muy variable en un paso | Defects / Waiting | ¿Por qué varía tanto? ¿Reproceso? ¿Interrupciones? |

---

## VSM en servicios vs manufactura

El VSM fue diseñado para manufactura, pero aplica con adaptaciones a procesos de servicios:

| Elemento VSM | Manufactura | Servicios / Software |
|-------------|-------------|---------------------|
| "Unidad" del proceso | Pieza física | Ticket, solicitud, historia de usuario, documento |
| Inventario | Materia prima, WIP físico | Backlog, colas de tickets, solicitudes en espera |
| Paso de proceso | Operación de manufactura | Actividad humana: revisar, aprobar, codificar, reunirse |
| Setup time | Tiempo de cambio de herramienta | Tiempo de cambio de contexto, reuniones de inicio |
| Takt Time | Demanda de producción | Demanda de solicitudes del cliente por período |
| Pull system | Kanban físico | Kanban digital (tablero), WIP limits |

**Consejo para servicios:** usar tickets o items rastreables (Jira, Asana, Linear) como "unidades" para calcular CT y LT con datos históricos, complementado con observación directa.

---

## VSM As-Is vs VSM To-Be

| Aspecto | VSM As-Is | VSM To-Be |
|---------|-----------|-----------|
| Cuándo se crea | lean:measure | lean:improve |
| Propósito | Fotografía del estado actual con sus desperdicios | Diseño del estado futuro con los wastes eliminados |
| Contiene | Todos los pasos actuales, incluyendo NVA | Solo pasos VA + NVA-N necesarios; pull system diseñado |
| Kaizen bursts | Identifica oportunidades | Muestra dónde se aplicaron las mejoras |
| Métricas | Baseline (Lead Time, PE, WIP actuales) | Objetivos (Lead Time, PE, WIP mejorados) |

---

## Errores comunes en VSM

| Error | Impacto | Corrección |
|-------|---------|-----------|
| Mapa construido desde reuniones, sin Gemba | El mapa refleja el proceso imaginado, con tiempos optimistas | Siempre hacer Gemba antes de dibujar |
| CT de 1 sola observación | Tiempos no representativos; cuellos de botella incorrectos | Mínimo 5 observaciones; promediar |
| Tiempos de espera no medidos | Process Efficiency sobreestimado; waste invisible | Medir el tiempo real de espera entre pasos, no estimarlo |
| VSM con 20+ pasos | Scope demasiado amplio; mapa inmanejable | Delimitar el scope a máximo 10-12 pasos |
| Sin flujo de información | El VSM no muestra el sistema de señales; no se puede diseñar pull | Mapear explícitamente cómo se comunica qué producir |
| Timeline sin esperas | Process Efficiency artificialmente alta | El timeline debe incluir TODOS los tiempos, incluyendo las esperas más largas |
