# Analysis Patterns — Guía de referencia

> Reference for rm:analysis. MoSCoW criterios, resolución de conflictos, mapeo de dependencias.

---

## Criterios de calidad de requisitos — definición operacional

Para que la verificación sea consistente, cada criterio debe tener una definición objetiva:

| Criterio | Pregunta de verificación | Ejemplo de fallo | Cómo corregir |
|----------|------------------------|-----------------|---------------|
| **Completo** | ¿Tiene todo lo necesario para implementarlo? | "El sistema debe ser rápido" (sin métrica) | Agregar criterio cuantificado |
| **Correcto** | ¿Refleja exactamente lo que el stakeholder necesita? | Req basado en suposición del analista | Confirmar con stakeholder |
| **Factible** | ¿Puede implementarse con tecnología/tiempo/presupuesto disponible? | Req que requiere tecnología no disponible | Consultar con tech lead |
| **No ambiguo** | ¿Solo una interpretación posible? | "El sistema debe ser fácil de usar" | Reemplazar con Usability NFR medible |
| **Verificable** | ¿Existe un criterio de aceptación medible? | "El sistema debe funcionar bien bajo carga" | Definir: "p95 < 2s con 500 usuarios concurrentes" |
| **Trazable** | ¿Se sabe de dónde viene? | Req sin stakeholder o sesión de origen | Agregar referencia de origen |
| **Consistente** | ¿No contradice otros requisitos? | REQ-A pide X; REQ-B pide NOT X | Resolver conflicto antes de aprobar |

### Palabras que indican ambigüedad

Estos términos deben ser eliminados o cuantificados antes de aprobar un requisito:

| Término ambiguo | Pregunta de clarificación |
|----------------|--------------------------|
| rápido, veloz | ¿Cuántos milisegundos? ¿En qué percentil? |
| fácil de usar | ¿Qué tasa de error? ¿Qué tiempo para completar la tarea? |
| siempre, nunca | ¿En qué condiciones? ¿Qué excepciones? |
| intuitivo | ¿Sin training? ¿Con cuánto training? |
| eficiente | ¿Cuánto más eficiente que qué baseline? |
| suficiente, adecuado | ¿Suficiente para qué caso de uso específico? |
| apropiado | ¿Según qué criterio? |
| moderno, actualizado | ¿Qué versión? ¿Qué estándar? |

---

## MoSCoW — Criterios de asignación por categoría

### Cómo definir Must Have

Un requisito es Must Have si Y SOLO SI todas estas condiciones son verdaderas:
1. Sin este requisito, el sistema **no puede entrar en producción**
2. No hay workaround aceptable para el usuario
3. Su ausencia viola un requisito legal, contractual o de seguridad

**Anti-patrón:** Marcar como Must Have porque el stakeholder lo pidió con urgencia. Must Have no es sinónimo de "el stakeholder quiere esto". Es sinónimo de "sin esto, el proyecto fracasa".

### Cómo resolver el "todo es Must Have"

Si ≥ 70% de los requisitos son clasificados como Must Have, ejecutar:

1. **Ejercicio del recorte de presupuesto:** "Si mañana les digo que el presupuesto se redujo a la mitad, ¿qué sacan del scope?"
2. **Test de supervivencia:** "Si este requisito no existiera, ¿el sistema aún tendría valor para los usuarios?" Si la respuesta es "sí" → no es Must Have
3. **Priorización forzada:** Pedir al PO que asigne $ ficticios (ej. $100 entre todos los requisitos)

### Tabla de ejemplos por categoría

| MoSCoW | Ejemplo de requisito de un sistema de e-commerce |
|--------|--------------------------------------------------|
| Must Have | Los usuarios deben poder completar una compra con tarjeta de crédito |
| Should Have | Los usuarios deben recibir un email de confirmación al completar la compra |
| Could Have | Los usuarios pueden guardar su carrito y retomarlo en otro dispositivo |
| Won't Have | Integración con criptomonedas (próxima versión) |

---

## Resolución de conflictos entre requisitos

### Tipos de conflicto

| Tipo | Descripción | Ejemplo | Técnica de resolución |
|------|-------------|---------|----------------------|
| **Directo** | Dos req dicen exactamente lo opuesto | REQ-A: tiempo respuesta < 1s; REQ-B: procesar todos los datos sin límite de tamaño | Negociación con ambos stakeholders; solución técnica (paginación) |
| **Indirecto** | Dos req que se contradicen solo en ciertos escenarios | REQ-A: logs detallados; REQ-B: performance alta | Definir umbrales de activación (logs solo en error) |
| **De prioridad** | Ambos son Must Have pero no hay capacidad para los dos | Dos Must Have que compiten por el mismo componente | Re-priorizar: solo uno puede ser Must Have en esta release |
| **De stakeholder** | Stakeholders de igual jerarquía quieren cosas opuestas | Área de ventas vs área de operaciones | Escalar a sponsor para decisión |

### Proceso de resolución estructurado

```
1. Documentar el conflicto con evidencia (citas de cada stakeholder)
2. Clasificar el tipo de conflicto
3. ¿Hay solución técnica que satisfaga ambos requisitos?
   → Sí: diseñar la solución; documentar; obtener ACK de ambos stakeholders
   → No: escalar a quien tiene autoridad para decidir (PO, Sponsor)
4. Documentar la decisión con fecha y quién decidió
5. Actualizar los requisitos afectados
6. Notificar a todos los stakeholders involucrados del resultado
```

### Señales de conflicto no resuelto

- Requisitos marcados como "pendiente de revisión" durante más de 1 semana
- Mismo req con dos valores contradictorios en distintos documentos
- Desarrolladores implementan interpretaciones diferentes del mismo req
- Stakeholders que "recuerdan diferente" lo que se acordó

---

## Mapeo de dependencias

### Tipos de dependencia entre requisitos

| Tipo | Definición | Ejemplo |
|------|-----------|---------|
| **Funcional** | REQ-B no puede existir sin REQ-A | "Modificar usuario" depende de "Crear usuario" |
| **De datos** | REQ-B usa datos creados o modificados por REQ-A | "Reporte de ventas" depende de "Registrar venta" |
| **De interfaz** | REQ-A y REQ-B comparten una interfaz o protocolo | Dos módulos que intercambian datos en el mismo formato |
| **De implementación** | REQ-B reutiliza infraestructura creada por REQ-A | "Notificaciones push" depende de "Integración Firebase" |
| **Regulatoria** | REQ-A habilita el cumplimiento requerido por REQ-B | "Audit log" habilita cumplimiento de GDPR |

### Diagrama de dependencias (formato DAG)

```
REQ-001 (Autenticación)
    └──→ REQ-003 (Autorización por rol)
              └──→ REQ-005 (Panel de administración)
              └──→ REQ-007 (Restricción de datos por departamento)
REQ-002 (Registrar pedido)
    └──→ REQ-004 (Inventario en tiempo real)
    └──→ REQ-006 (Facturación automática)
              └──→ REQ-008 (Reporte financiero)
```

### Cómo detectar dependencias implícitas

1. **Análisis de datos:** Mapear qué entidades de datos crea cada req y qué entidades lee. Si B lee lo que A crea → dependencia de datos.
2. **Análisis de actores:** Si dos req comparten el mismo actor, pueden tener dependencias de secuencia.
3. **Análisis de componentes:** Si dos req tocan el mismo componente técnico, pueden tener dependencias de implementación.

---

## Priorización avanzada — técnicas complementarias

### Técnica de la Hoja de Presupuesto (Buy a Feature)

1. Asignar un "costo" relativo a cada requisito (proporcional a su complejidad)
2. Dar a cada stakeholder un "presupuesto" ficticio (generalmente 50-100% del total)
3. Pedirles que "compren" los requisitos que más valoran
4. Los requisitos con más "compradores" son los de mayor valor percibido

### Técnica 100-point method

1. Dar a cada stakeholder 100 puntos para distribuir entre los requisitos
2. Promediar los puntos de todos los stakeholders
3. Ordenar por puntuación promedio → ranking de valor

### Matriz de Valor vs Esfuerzo

| | Bajo esfuerzo | Alto esfuerzo |
|---|---|---|
| **Alto valor** | Implementar primero (Quick wins) | Planificar cuidadosamente (Proyectos mayores) |
| **Bajo valor** | Implementar si hay tiempo (Nice to have) | Evitar o diferir (Out of scope) |
