# Tipos Avanzados de Reglas de Negocio

**Documento:** Parte 3 - Desencadenadores, Inferencias y Cálculos
**Versión:** 1.0
**Última actualización:** 2025-11-14

---

## Tabla de Contenidos

1. [Introducción](#introducción)
2. [Desencadenadores de Acción](#3-desencadenadores-de-acción)
3. [Inferencias](#4-inferencias)
4. [Cálculos Computacionales](#5-cálculos-computacionales)
5. [Comparación entre Tipos](#comparación-entre-tipos)
6. [Aplicación en IACT](#aplicación-en-iact)

---

## Introducción

> **Concepto Clave:** Los tipos avanzados de reglas de negocio (Desencadenadores, Inferencias y Cálculos) transforman datos y desencadenan acciones automáticas basadas en condiciones del negocio.

Este documento complementa [HECHOS_RESTRICCIONES.md](HECHOS_RESTRICCIONES.md) cubriendo los tres tipos restantes de reglas de negocio:

- **Tipo 3:** Desencadenadores de Acción (Triggers)
- **Tipo 4:** Inferencias (Inferences)
- **Tipo 5:** Cálculos Computacionales (Computations)

---

## 3. DESENCADENADORES DE ACCIÓN

### Definición

> **Concepto Clave:** Un desencadenador de acción es una regla que activa alguna actividad si condiciones específicas son verdaderas.

Los desencadenadores implementan lógica condicional: **SI** [condición] **ENTONCES** [acción].

### Características de los Desencadenadores

- Implementan lógica **condicional** (if-then)
- **Monitorean eventos** o estados del sistema
- **Ejecutan acciones** automáticamente cuando se cumplen condiciones
- Pueden ser **síncronos o asíncronos**
- Habilitan **automatización** de procesos

### Estructura Básica

```
SI [condición o evento]
ENTONCES [ejecutar acción]
```

### Ejemplos Generales

#### Sistema de Inventario

**Desencadenador:** Si el inventario de un artículo cae por debajo de 10 unidades, entonces generar automáticamente una orden de compra.

```
SI inventario_actual < 10
ENTONCES generar_orden_compra(producto, cantidad_reorden)
```

#### Sistema de Reservaciones

**Desencadenador:** Si un cliente reserva un vuelo, entonces enviar correo de confirmación automáticamente.

```
SI reservacion.estado == "confirmada"
ENTONCES enviar_email(cliente.email, confirmacion_vuelo)
```

### Ejemplos Aplicados a IACT (Call Center)

#### Desencadenadores de Gestión de Llamadas

**D1: Escalación por Tiempo de Espera**
```
SI llamada.tiempo_espera > 5_minutos
ENTONCES transferir_a_supervisor(llamada_id)
```

**Descripción:** Si una llamada lleva más de 5 minutos en espera, entonces escalarla automáticamente a un supervisor.

**D2: Redistribución de Carga**
```
SI agente.llamadas_en_cola > 10
ENTONCES redistribuir_llamadas(agente_id, otros_agentes)
```

**Descripción:** Si un agente tiene más de 10 llamadas en cola, entonces redistribuir a otros agentes disponibles.

**D3: Alerta de Rendimiento**
```
SI agente.llamadas_abandonadas_hoy > 5
ENTONCES notificar_supervisor(agente_id, "alto_abandono")
```

**Descripción:** Si un agente tiene más de 5 llamadas abandonadas en el día, entonces notificar al supervisor.

#### Desencadenadores de Campañas

**D4: Pausa Automática de Campaña**
```
SI campaña.tasa_conversion < 2% AND campaña.llamadas_totales > 100
ENTONCES pausar_campaña(campaña_id, razon="baja_conversion")
```

**Descripción:** Si la tasa de conversión es menor al 2% después de 100 llamadas, entonces pausar la campaña automáticamente.

**D5: Activación de Recordatorios**
```
SI cliente.ultima_interaccion > 30_dias
ENTONCES programar_llamada_seguimiento(cliente_id, prioridad="media")
```

**Descripción:** Si un cliente no ha tenido interacción en 30 días, entonces programar llamada de seguimiento.

#### Desencadenadores de Seguridad y Auditoría

**D6: Bloqueo de Cuenta**
```
SI usuario.intentos_login_fallidos >= 5
ENTONCES bloquear_cuenta(usuario_id, duracion="30_minutos")
```

**Descripción:** Si hay 5 intentos fallidos de login, entonces bloquear la cuenta temporalmente.

**D7: Registro de Auditoría**
```
SI usuario.accede_a_datos_personales(cliente_id)
ENTONCES registrar_auditoria(usuario_id, accion="lectura_datos", recurso=cliente_id)
```

**Descripción:** Si un usuario accede a datos personales de un cliente, entonces registrar el acceso en el log de auditoría.

---

## 4. INFERENCIAS

### Definición

> **Concepto Clave:** Una inferencia crea un hecho nuevo a partir de otros hechos existentes, estableciendo conocimiento derivado.

Las inferencias **derivan nueva información** a partir de datos existentes sin ejecutar acciones externas.

### Características de las Inferencias

- **Crean nuevos hechos** a partir de hechos existentes
- **No ejecutan acciones** (a diferencia de los desencadenadores)
- Establecen **conocimiento derivado**
- Implementan **lógica deductiva**
- Permiten **clasificación automática**

### Diferencia con Desencadenadores

| Aspecto | Inferencia | Desencadenador |
|---------|------------|----------------|
| **Propósito** | Derivar nuevo conocimiento | Ejecutar acción |
| **Resultado** | Nuevo hecho/estado | Acción/evento |
| **Ejemplo** | "El cliente es VIP" | "Enviar email al cliente" |

### Estructura Básica

```
SI [condiciones sobre hechos existentes]
ENTONCES [derivar nuevo hecho]
```

### Ejemplos Generales

#### Sistema de E-commerce

**Inferencia:** Si un cliente ha realizado más de 10 compras y su gasto total supera los $10,000, entonces ese cliente es clasificado como "VIP".

```
SI cliente.total_compras > 10 AND cliente.gasto_total > 10000
ENTONCES cliente.categoria = "VIP"
```

#### Sistema Académico

**Inferencia:** Si un estudiante tiene promedio mayor a 9.0 y ha completado más del 80% de los créditos, entonces el estudiante está en "lista de honor".

```
SI estudiante.promedio > 9.0 AND estudiante.creditos_completados > 0.8 * creditos_totales
ENTONCES estudiante.estatus_academico = "lista_de_honor"
```

### Ejemplos Aplicados a IACT (Call Center)

#### Inferencias sobre Agentes

**I1: Clasificación de Rendimiento de Agente**
```
SI agente.tasa_resolucion_primer_contacto > 85%
   AND agente.tiempo_promedio_llamada < 5_minutos
   AND agente.calificacion_satisfaccion > 4.5
ENTONCES agente.nivel_rendimiento = "Excelente"
```

**Descripción:** Si un agente cumple con altos estándares en múltiples métricas, entonces es clasificado como rendimiento "Excelente".

**I2: Estado de Disponibilidad**
```
SI agente.tiempo_sin_llamada > 15_minutos
   AND agente.estado_sistema = "disponible"
ENTONCES agente.disponibilidad_real = "Inactivo"
```

**Descripción:** Si un agente lleva 15 minutos sin atender llamadas estando "disponible", entonces su disponibilidad real es "Inactivo".

#### Inferencias sobre Clientes

**I3: Clasificación de Cliente Potencial**
```
SI cliente.intentos_contacto > 3
   AND cliente.producto_interes IN productos_premium
   AND cliente.ingreso_estimado > 50000
ENTONCES cliente.categoria = "Prospecto_Alto_Valor"
```

**Descripción:** Si un cliente cumple con criterios de valor, entonces es clasificado como prospecto de alto valor.

**I4: Riesgo de Abandono**
```
SI cliente.llamadas_no_contestadas > 5
   AND cliente.ultima_compra > 90_dias
ENTONCES cliente.riesgo_abandono = "Alto"
```

**Descripción:** Si un cliente muestra patrones de desconexión, entonces se clasifica con riesgo alto de abandono.

#### Inferencias sobre Campañas

**I5: Efectividad de Campaña**
```
SI campaña.tasa_conversion > 15%
   AND campaña.costo_por_adquisicion < promedio_industria
ENTONCES campaña.efectividad = "Alta"
```

**Descripción:** Si una campaña supera umbrales de rendimiento, entonces se clasifica como altamente efectiva.

**I6: Estado de Campaña**
```
SI campaña.fecha_fin < fecha_actual
   AND campaña.llamadas_pendientes = 0
ENTONCES campaña.estado = "Finalizada"
```

**Descripción:** Si una campaña ha pasado su fecha de fin y no tiene llamadas pendientes, entonces se infiere que está finalizada.

---

## 5. CÁLCULOS COMPUTACIONALES

### Definición

> **Concepto Clave:** Los cálculos computacionales transforman datos existentes en nuevos datos utilizando fórmulas matemáticas o algoritmos.

Los cálculos **procesan datos** para producir **valores derivados** mediante operaciones matemáticas o lógicas.

### Características de los Cálculos

- Aplican **fórmulas matemáticas** o **algoritmos**
- **Transforman datos** existentes en nuevos valores
- Producen **resultados cuantitativos**
- Son **determinísticos** (mismo input → mismo output)
- Habilitan **métricas y KPIs**

### Tipos de Cálculos

1. **Aritméticos:** Suma, resta, multiplicación, división, promedios
2. **Estadísticos:** Media, mediana, desviación estándar, percentiles
3. **Lógicos:** Conteos, agregaciones, clasificaciones
4. **Algorítmicos:** Procesamiento complejo, machine learning

### Ejemplos Generales

#### Sistema Financiero

**Cálculo:** Interés mensual de una cuenta de ahorro.

```
interes_mensual = saldo_cuenta × (tasa_anual / 12)
```

#### Sistema de Ventas

**Cálculo:** Comisión de vendedor.

```
comision = ventas_totales × porcentaje_comision
SI ventas_totales > meta ENTONCES comision = comision × 1.5
```

### Ejemplos Aplicados a IACT (Call Center)

#### Cálculos de Rendimiento de Agentes

**C1: Tiempo Promedio de Manejo (AHT - Average Handle Time)**
```
AHT = (tiempo_total_conversacion + tiempo_total_trabajo_post_llamada) / total_llamadas
```

**Descripción:** Calcula el tiempo promedio que un agente dedica por llamada, incluyendo trabajo posterior.

**C2: Tasa de Resolución en Primer Contacto (FCR)**
```
FCR = (llamadas_resueltas_primer_contacto / total_llamadas) × 100
```

**Descripción:** Porcentaje de llamadas resueltas sin necesidad de seguimiento.

**C3: Nivel de Servicio (Service Level)**
```
nivel_servicio = (llamadas_contestadas_en_20_segundos / total_llamadas_entrantes) × 100
```

**Descripción:** Porcentaje de llamadas atendidas dentro del umbral de tiempo objetivo.

#### Cálculos de Campañas

**C4: Tasa de Conversión**
```
tasa_conversion = (llamadas_exitosas / total_llamadas_realizadas) × 100
```

**Descripción:** Porcentaje de llamadas que resultaron en conversión exitosa.

**C5: Costo por Adquisición (CPA)**
```
CPA = costo_total_campaña / total_conversiones
```

**Descripción:** Costo promedio para adquirir un cliente a través de la campaña.

**C6: Retorno de Inversión (ROI)**
```
ROI = ((ingresos_generados - costo_campaña) / costo_campaña) × 100
```

**Descripción:** Porcentaje de retorno sobre la inversión de la campaña.

#### Cálculos de Operaciones

**C7: Tasa de Abandono**
```
tasa_abandono = (llamadas_abandonadas / total_llamadas_entrantes) × 100
```

**Descripción:** Porcentaje de clientes que cuelgan antes de ser atendidos.

**C8: Ocupación de Agente**
```
ocupacion = (tiempo_en_llamadas + tiempo_trabajo_post_llamada) / tiempo_total_disponible × 100
```

**Descripción:** Porcentaje de tiempo que un agente está productivamente ocupado.

**C9: Productividad Diaria**
```
productividad = total_llamadas_procesadas / horas_trabajadas
```

**Descripción:** Número de llamadas procesadas por hora trabajada.

#### Cálculos de Calidad

**C10: Net Promoter Score (NPS)**
```
NPS = % promotores (9-10) - % detractores (0-6)
```

**Descripción:** Métrica de satisfacción del cliente basada en probabilidad de recomendación.

**C11: Customer Satisfaction Score (CSAT)**
```
CSAT = (respuestas_satisfactorias / total_respuestas) × 100
```

**Descripción:** Porcentaje de clientes satisfechos con el servicio.

---

## Comparación entre Tipos

### Tabla Comparativa

| Tipo | Propósito | Resultado | Ejemplo IACT |
|------|-----------|-----------|--------------|
| **Hechos** | Describir realidad del negocio | Asociación/relación | "Cada llamada tiene un agente asignado" |
| **Restricciones** | Limitar acciones | Permiso/prohibición | "Solo supervisores pueden reasignar llamadas" |
| **Desencadenadores** | Automatizar respuesta a eventos | Ejecución de acción | "SI espera > 5min ENTONCES escalar a supervisor" |
| **Inferencias** | Derivar conocimiento | Nuevo hecho/clasificación | "SI FCR > 85% ENTONCES agente.nivel = Excelente" |
| **Cálculos** | Procesar datos | Valor numérico/métrica | "AHT = tiempo_total / llamadas" |

### Relaciones entre Tipos

```
HECHOS
  └─> Base de conocimiento
      └─> RESTRICCIONES (limitan operaciones sobre hechos)
      └─> DESENCADENADORES (monitorean hechos para ejecutar acciones)
      └─> INFERENCIAS (derivan nuevos hechos)
      └─> CÁLCULOS (procesan hechos para generar métricas)
```

---

## Aplicación en IACT

### Flujo de Trabajo Integrado

**Escenario:** Gestión de llamada entrante con múltiples tipos de reglas

1. **HECHO:** Llamada entrante asignada a agente disponible
2. **RESTRICCIÓN:** Agente debe estar logueado para recibir llamadas
3. **DESENCADENADOR:** SI tiempo_espera > 3min ENTONCES notificar supervisor
4. **CÁLCULO:** Actualizar tiempo_promedio_espera del día
5. **INFERENCIA:** SI agente.llamadas_hoy > 50 ENTONCES agente.carga = "Alta"

### Implementación Técnica

#### Backend (Django)

```python
# HECHO: Modelo de datos
class Llamada(models.Model):
    agente = models.ForeignKey(Agente)
    timestamp = models.DateTimeField()
    duracion = models.IntegerField()

# RESTRICCIÓN: Validación
def puede_recibir_llamada(agente):
    return agente.estado == "logueado"

# DESENCADENADOR: Signal
@receiver(post_save, sender=Llamada)
def verificar_tiempo_espera(sender, instance, **kwargs):
    if instance.tiempo_espera > 180:  # 3 minutos
        notificar_supervisor(instance.agente)

# CÁLCULO: Método
def calcular_aht(agente):
    return agente.llamadas.aggregate(
        avg_tiempo=Avg('duracion')
    )['avg_tiempo']

# INFERENCIA: Propiedad
@property
def nivel_carga(self):
    if self.llamadas_hoy > 50:
        return "Alta"
    return "Normal"
```

### Validación con Business Rules Validator Agent

El agente `business_rules_validator_agent.py` valida que la documentación:

- **Estructura:** Incluya las 5 categorías de reglas
- **Ejemplos:** Contenga casos específicos IACT
- **Matrices:** Tenga tablas de roles y permisos
- **Referencias:** Links correctos entre documentos
- **Compliance:** Mencione LFPDPPP y regulaciones

---

## Resumen

### Tipos Avanzados

#### Desencadenadores de Acción
- **Automatizan respuestas** a eventos o condiciones
- Implementan lógica **SI-ENTONCES**
- **Ejecutan acciones** cuando se cumplen condiciones
- Ejemplos: Escalación de llamadas, redistribución de carga, alertas

#### Inferencias
- **Derivan nuevo conocimiento** de hechos existentes
- **No ejecutan acciones**, solo clasifican o categorizan
- Establecen **conocimiento derivado**
- Ejemplos: Clasificación de agentes, categorización de clientes, estado de campañas

#### Cálculos Computacionales
- **Transforman datos** usando fórmulas matemáticas
- Producen **valores cuantitativos** (métricas, KPIs)
- Son **determinísticos**
- Ejemplos: AHT, FCR, tasa de conversión, ROI

> **Nota Importante:** La correcta implementación de estos tipos avanzados de reglas permite automatización inteligente, clasificación dinámica y métricas en tiempo real que mejoran la operación del call center.

---

## Documentos Relacionados

- [Introducción a las Reglas de Negocio](INTRODUCCION.md)
- [Tipos Básicos: Hechos y Restricciones](HECHOS_RESTRICCIONES.md)
- [Aplicación en el Proyecto IACT](APLICACION_IACT.md)
- [Constitución del Proyecto](../../../../.constitucion.yaml)

---

**Mantenedor:** Equipo de Arquitectura IACT
**Última revisión:** 2025-11-14
