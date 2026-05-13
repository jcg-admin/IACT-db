# Template Fishbone (Ishikawa) — PS8 Step 4

> Template para el Diagrama de Causa y Efecto (Fishbone/Ishikawa).
> Usar en pps:analyze para exploración sistemática de causas potenciales.

---

## Información general

| Campo | Valor |
|-------|-------|
| **Efecto / Problema** | [Problem Statement de pps:clarify — el "problema" va en la cabeza del pez] |
| **Facilitador** | [nombre] |
| **Participantes** | [nombres — incluir representantes de cada categoría cuando sea posible] |
| **Fecha** | [YYYY-MM-DD] |
| **Categorías usadas** | [ ] 6M (manufactura/ingeniería)  [ ] 4P (servicios/software) |

---

## Diagrama — Categorías 6M

> Usar para procesos de manufactura, operaciones, ingeniería de hardware/infraestructura.

```
                    MANPOWER                    METHODS
                   (Personas)                 (Procesos)
                       │                          │
    ───────────────────┼──────────────────────────┼──────────── ►► EFECTO
                       │                          │              [Problema]
               MACHINES          MATERIALS    MEASUREMENTS
              (Equipos)         (Materiales)  (Mediciones)
                                         MOTHER NATURE
                                           (Entorno)
```

### MANPOWER — Personas

| Causa potencial | Hipótesis específica | Prioridad (A/M/B) |
|----------------|---------------------|-------------------|
| Falta de capacitación | [¿El equipo conoce el proceso estándar?] | |
| Variación por persona | [¿El problema ocurre más con ciertas personas?] | |
| Fatiga / sobrecarga | [¿El error ocurre más en ciertos turnos o períodos?] | |
| Comunicación deficiente | [¿Hay malentendidos en el handoff entre roles?] | |
| [otra causa] | [descripción] | |

### METHODS — Métodos/Procesos

| Causa potencial | Hipótesis específica | Prioridad (A/M/B) |
|----------------|---------------------|-------------------|
| Proceso no documentado | [¿Existe SOP / runbook actualizado?] | |
| Proceso documentado no seguido | [¿Se siguen los procedimientos consistentemente?] | |
| Proceso inadecuado para el contexto | [¿El proceso fue diseñado para este volumen/caso?] | |
| Ausencia de verificación/gate | [¿Hay puntos de control que detecten el error?] | |
| [otra causa] | [descripción] | |

### MACHINES — Equipos/Herramientas/Software

| Causa potencial | Hipótesis específica | Prioridad (A/M/B) |
|----------------|---------------------|-------------------|
| Herramienta con defecto | [¿Hay bugs conocidos en el sistema/herramienta?] | |
| Herramienta inadecuada para la tarea | [¿La herramienta fue diseñada para este caso de uso?] | |
| Mantenimiento insuficiente | [¿Hay actualizaciones pendientes, deuda técnica?] | |
| Falta de automatización | [¿Un paso manual podría automatizarse para reducir error?] | |
| [otra causa] | [descripción] | |

### MATERIALS — Materiales/Datos de Entrada

| Causa potencial | Hipótesis específica | Prioridad (A/M/B) |
|----------------|---------------------|-------------------|
| Input de mala calidad | [¿Los datos/materiales de entrada tienen defectos?] | |
| Input inconsistente | [¿Varía la calidad del input según el proveedor/fuente?] | |
| Input incompleto | [¿Llegan inputs faltando información crítica?] | |
| Especificación del input no definida | [¿Hay requisitos claros para lo que debe entrar al proceso?] | |
| [otra causa] | [descripción] | |

### MEASUREMENTS — Mediciones

| Causa potencial | Hipótesis específica | Prioridad (A/M/B) |
|----------------|---------------------|-------------------|
| Métrica mal definida | [¿La métrica captura realmente el problema?] | |
| Instrumento de medición sesgado | [¿El sistema de medición tiene error sistemático?] | |
| Frecuencia de medición insuficiente | [¿Se mide con suficiente granularidad?] | |
| Datos no disponibles a tiempo | [¿La información llega cuando aún puede usarse?] | |
| [otra causa] | [descripción] | |

### MOTHER NATURE — Entorno/Condiciones Externas

| Causa potencial | Hipótesis específica | Prioridad (A/M/B) |
|----------------|---------------------|-------------------|
| Carga del sistema (peak times) | [¿El problema ocurre más bajo alta demanda?] | |
| Condiciones estacionales | [¿Hay patrón por período del año, mes, semana?] | |
| Dependencias externas | [¿Sistemas o APIs de terceros afectan el proceso?] | |
| Regulaciones / restricciones | [¿Hay cambios regulatorios recientes que impacten?] | |
| [otra causa] | [descripción] | |

---

## Diagrama — Categorías 4P (alternativa para servicios/software)

> Usar para procesos de software, servicios, trabajo de conocimiento.

### PEOPLE — Personas

| Causa potencial | Hipótesis específica | Prioridad (A/M/B) |
|----------------|---------------------|-------------------|
| [causa] | [descripción] | |

### PROCESSES — Procesos

| Causa potencial | Hipótesis específica | Prioridad (A/M/B) |
|----------------|---------------------|-------------------|
| [causa] | [descripción] | |

### POLICIES — Políticas/Gobernanza

| Causa potencial | Hipótesis específica | Prioridad (A/M/B) |
|----------------|---------------------|-------------------|
| [causa] | [descripción] | |

### PLANT/TECHNOLOGY — Tecnología/Infraestructura

| Causa potencial | Hipótesis específica | Prioridad (A/M/B) |
|----------------|---------------------|-------------------|
| [causa] | [descripción] | |

---

## Síntesis — Causas priorizadas para análisis 5 Whys

Seleccionar las causas potenciales de mayor prioridad para explorar con 5 Whys:

| # | Causa potencial | Categoría | Prioridad | Razón de selección |
|---|----------------|-----------|-----------|-------------------|
| 1 | [causa más probable] | [6M/4P] | Alta | [por qué se prioriza] |
| 2 | [segunda más probable] | [6M/4P] | Alta | [por qué se prioriza] |
| 3 | [tercera candidata] | [6M/4P] | Media | [por qué se incluye] |

**Criterios de priorización:**
- Frecuencia con que la causa fue mencionada por participantes con conocimiento del proceso
- Correlación temporal con la aparición del problema
- Disponibilidad de datos para confirmarla

---

## Notas de la sesión

**Observaciones del proceso de brainstorming:**

[Insights surgidos durante la sesión que no caben en las tablas anteriores]

**Causas que requieren más información antes de confirmar:**

[Hipótesis interesantes que no se pueden evaluar aún — describir qué dato falta]
