# Analysis Techniques — Técnicas de Análisis y Modelado de Requisitos

## Decision Tables (Tablas de decisión)

**Cuándo usar:** Cuando hay múltiples condiciones que se combinan para determinar una acción; especialmente cuando las combinaciones son numerosas y difíciles de expresar textualmente.

**Estructura:**

| | Regla 1 | Regla 2 | Regla 3 | Regla 4 |
|--|:-------:|:-------:|:-------:|:-------:|
| **Condición A** | Sí | Sí | No | No |
| **Condición B** | Sí | No | Sí | No |
| **Acción 1** | X | — | X | — |
| **Acción 2** | — | X | — | X |

**X = acción se ejecuta · — = acción no se ejecuta**

### Ejemplo: Aprobación de crédito

| | Regla 1 | Regla 2 | Regla 3 | Regla 4 |
|--|:-------:|:-------:|:-------:|:-------:|
| **Score crediticio ≥ 700** | Sí | Sí | No | No |
| **Ingreso ≥ 3× cuota** | Sí | No | Sí | No |
| Aprobar automáticamente | X | — | — | — |
| Aprobar con revisión manual | — | X | X | — |
| Rechazar | — | — | — | X |

**Ventajas:** Explícita; cubre todas las combinaciones; fácil de convertir en lógica de negocio.
**Limitaciones:** No captura secuencias; se complica con > 5 condiciones (2^n reglas).

**Verificación de completitud:** Una decision table es completa cuando cubre 2^n combinaciones para n condiciones binarias. Si hay condiciones con > 2 valores, multiplicar.

---

## Decision Trees (Árboles de decisión)

**Cuándo usar:** Cuando las condiciones son secuenciales y una condición lleva a otra; cuando se necesita modelar una secuencia de preguntas o verificaciones.

**Elementos:**
- **Nodo de decisión (rombo/cuadrado):** Una pregunta o condición
- **Rama:** Respuesta a la condición (Sí/No o valor específico)
- **Nodo terminal (óvalo):** Acción o resultado final

```
¿Score ≥ 700?
├── Sí → ¿Ingreso ≥ 3× cuota?
│         ├── Sí → APROBADO AUTOMÁTICAMENTE
│         └── No → REVISIÓN MANUAL
└── No  → ¿Historial > 5 años?
           ├── Sí → REVISIÓN MANUAL
           └── No → RECHAZADO
```

**Ventajas:** Visualiza el flujo de decisión; intuitivo para stakeholders.
**Limitaciones:** No captura condiciones simultáneas bien (usar decision table); difícil de mantener con muchas ramas.

**Cuándo preferir árbol sobre tabla:**
- Las condiciones se evalúan en secuencia (una depende de la anterior)
- Hay pocas ramas en cada nivel
- El stakeholder necesita entender visualmente el flujo

---

## Process Modeling (Modelado de procesos)

### Business Process Notation (BPMN básico)

**Cuándo usar:** Modelar el flujo de un proceso de negocio para identificar actores, pasos, decisiones y flujos de excepción.

**Elementos BPMN básicos:**

| Símbolo | Nombre | Uso |
|---------|--------|-----|
| Círculo delgado | Evento de inicio | Inicia el proceso |
| Círculo doble | Evento de fin | Termina el proceso |
| Rectángulo | Tarea | Una actividad que alguien realiza |
| Rombo | Gateway (AND/OR/XOR) | Decisión o bifurcación |
| Rectángulo con líneas | Pool / Lane | Separa actores o sistemas |
| Flecha continua | Flujo de secuencia | Orden de actividades |
| Flecha punteada | Flujo de mensaje | Comunicación entre pools |

**Swimlanes (cuándo usar cada uno):**
- **Pool:** Organización o sistema separado
- **Lane:** Rol o departamento dentro de una organización

### Value Stream Map (VSM) simplificado

| Elemento | Descripción |
|----------|-------------|
| **Process boxes** | Pasos del proceso con tiempo de ciclo (CT) |
| **Push arrows** | Flujo de trabajo empujado |
| **Inventory triangles** | Cola / espera entre pasos |
| **Value-added time** | Tiempo que agrega valor al cliente |
| **Non-value-added time** | Espera, retrabajo, transporte — candidatos a eliminar |

**Cálculo clave:** Lead Time = suma de todos los tiempos (VA + NVA). Value Ratio = VA time / Lead Time. Target: > 25% para procesos de servicio.

---

## Data Modeling (Modelado de datos)

**Cuándo usar:** Cuando se necesita especificar qué datos maneja el sistema, sus relaciones y restricciones.

### Entity-Relationship Diagram (ERD) — notación simplificada

**Notación crow's foot:**

| Símbolo | Significado |
|---------|-------------|
| `|` (una línea) | Exactamente uno |
| `O` (círculo) | Cero |
| `<` (crow's foot) | Muchos |
| `|<` | Uno y solo uno |
| `O<` | Cero o muchos |
| `|<` + `O` | Uno o muchos |

**Plantilla de entidad:**

```
ENTIDAD: [Nombre]
Atributos:
  - [PK] id: integer
  - nombre: varchar(100) NOT NULL
  - email: varchar(255) UNIQUE
  - created_at: timestamp
Relaciones:
  - tiene muchos → OTRA_ENTIDAD
  - pertenece a → ENTIDAD_PADRE
```

### Data Dictionary (Diccionario de datos)

| Campo | Tipo | Tamaño | Obligatorio | Único | Descripción | Ejemplo válido |
|-------|------|--------|:-----------:|:-----:|-------------|---------------|
| id | integer | — | Sí | Sí | Clave primaria autoincremental | 1, 2, 3 |
| email | varchar | 255 | Sí | Sí | Email de contacto | user@example.com |
| status | enum | — | Sí | No | Estado del registro | activo, inactivo, suspendido |
| amount | decimal | 10,2 | Sí | No | Monto en moneda local | 1234.56 |

**Reglas de negocio que aplican a los datos:**
| Campo | Regla | Ejemplo |
|-------|-------|---------|
| email | Debe ser único por tenant | Un email no puede repetirse en la misma organización |
| amount | Debe ser > 0 | No se aceptan montos negativos ni cero |

---

## Combinación de técnicas por tipo de requisito

| Tipo de requisito | Técnica recomendada | Output |
|------------------|--------------------|----|
| Lógica de negocio compleja con muchas condiciones | Decision table | Tabla de reglas |
| Flujo de decisión secuencial | Decision tree | Árbol de decisión |
| Proceso de negocio end-to-end | Process model (BPMN) | Diagrama de proceso |
| Estructura de datos y relaciones | ERD + Data dictionary | Modelo de datos |
| Proceso con múltiples actores | Swimlane diagram | Diagrama con carriles |
| Requisito funcional de sistema | Use case | Plantilla UC |
| Requisito en contexto ágil | User story + Given/When/Then | Backlog item |

---

## Verificación de modelos

### Checklist de verificación de modelos de análisis

| Criterio | Decision Table | Decision Tree | Process Model | ERD |
|---------|:-------------:|:-------------:|:-------------:|:---:|
| Todas las combinaciones posibles cubiertos | ✓ | — | — | — |
| Sin ramas huérfanas (sin nodo terminal) | — | ✓ | ✓ | — |
| Todos los actores tienen al menos una tarea | — | — | ✓ | — |
| Todas las entidades tienen PK | — | — | — | ✓ |
| Sin relaciones sin cardinalidad definida | — | — | — | ✓ |
| Validado por SME del dominio | ✓ | ✓ | ✓ | ✓ |

### Señales de modelo incompleto o incorrecto

| Señal | Técnica afectada | Acción |
|-------|-----------------|--------|
| Combinación de condiciones sin acción definida | Decision table | Completar la regla faltante |
| Rama que nunca llega a un terminal | Decision tree | Agregar nodo de fin |
| Actor en el proceso pero sin tareas asignadas | Process model | Asignar tareas o eliminar el actor |
| Entidad sin relaciones | ERD | Verificar si debe relacionarse con otra |
| Atributo obligatorio sin valor por defecto | Data dictionary | Definir cómo se inicializa |
