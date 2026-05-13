---
id: RN-[DOMINIO]-[###]
tipo: regla_negocio
subtipo: inferencia
categoria: [DOMINIO]
version: 1.0.0
fecha: [YYYY-MM-DD]
autor: [NOMBRE_AUTOR]
estado: [borrador|en_revision|aprobado|obsoleto]
---

# RN-[DOMINIO]-[###]: [Título de la Inferencia]

<!--
INSTRUCCIONES:
- Reemplace [DOMINIO] con: BACK, FRONT, DEVOPS, QA, AI, GOB
- Reemplace [###] con número secuencial: 001, 002, 003, etc.
- El título debe describir el conocimiento que se deriva
- Las inferencias siguen el patrón SI-ENTONCES donde "entonces" es un NUEVO HECHO

DIFERENCIA CRÍTICA con Desencadenadores:
- Inferencia: SI [condición] ENTONCES [ESTABLECER NUEVO HECHO/CONOCIMIENTO]
  Ejemplo: SI pago no recibido en 30 días ENTONCES cuenta ES deudora
  → Resultado: Se ESTABLECE un nuevo estado, NO se ejecuta una acción

- Desencadenador: SI [condición] ENTONCES [EJECUTAR ACCIÓN]
  Ejemplo: SI cuenta es deudora ENTONCES enviar notificación
  → Resultado: Se EJECUTA algo (enviar, bloquear, notificar)

Las inferencias crean CONOCIMIENTO. Los desencadenadores crean ACCIONES.
-->

## Tipo

Inferencia (Conocimiento Derivado)

## Declaración

<!--
IMPORTANTE: Use el patrón SI-ENTONCES donde el "entonces" establece un NUEVO HECHO.
La cláusula "entonces" debe indicar qué se SABE o qué ESTADO se establece.

Ejemplos correctos:
- SI pago no recibido en 30 días ENTONCES cuenta ES deudora
- SI estudiante completó cursos obligatorios y promedio >= 7.0 ENTONCES estudiante ES elegible para graduación
- SI vendedor nuevo no envía en 5 días ENTONCES orden ES cancelada
- SI usuario intenta login 3 veces incorrectas ENTONCES usuario TIENE estado "sospechoso"

Palabras clave que indican conocimiento derivado:
- es, está, tiene el estado de
- se marca como, se clasifica como
- se considera, se califica como
- tiene la propiedad de
-->

**SI**: [Describa las condiciones sobre hechos existentes]

**ENTONCES**: [Describa el nuevo hecho que se establece - use verbos de estado como "es", "está", "tiene"]

## Hechos de Entrada

<!--
Liste los hechos o datos existentes que se usan para derivar el nuevo conocimiento.
Estos son los "inputs" de la inferencia.
-->

**Hechos necesarios**:
1. [Hecho 1 que debe ser verdadero]
2. [Hecho 2 que debe ser verdadero]
3. [Hecho 3 que debe ser verdadero]

**Datos requeridos**:
- [Dato 1]: [Tipo de dato, origen]
- [Dato 2]: [Tipo de dato, origen]

<!-- Ejemplos:
Hechos necesarios:
1. Existe un registro de pago para esta cuenta
2. La fecha de vencimiento del pago está definida
3. Existe una fecha actual del sistema

Datos requeridos:
- Fecha de vencimiento: fecha, proveniente de la factura
- Fecha actual: fecha, proveniente del reloj del sistema
- Días transcurridos: número entero, calculado
-->

## Conocimiento Derivado

<!--
Describa en detalle el nuevo hecho o conocimiento que se crea.
¿Qué se SABE después de aplicar esta regla?
-->

**Nuevo conocimiento establecido**:

[Describa el nuevo hecho que se deriva]

**Tipo de conocimiento**: [Estado | Clasificación | Propiedad | Atributo derivado]

**Persistencia**: [Se guarda permanentemente | Temporal | Calculado en tiempo real]

**Visibilidad**: [Quién puede ver o usar este conocimiento derivado]

## Regla de Derivación

<!--
Explique la lógica que conecta los hechos de entrada con el conocimiento derivado.
¿Cómo se llega de A a B?
Sea específico con umbrales, condiciones, cálculos.
-->

**Lógica**:

[Explique el razonamiento lógico]

**Condiciones específicas**:
- [Condición 1]: [Valor o umbral]
- [Condición 2]: [Valor o umbral]

**Operadores lógicos**: [Y | O | NO | Combinación]

<!-- Ejemplo:
Lógica:
Si la diferencia entre fecha actual y fecha de vencimiento es mayor a 30 días,
entonces la cuenta adquiere el estado "deudora".

Condiciones específicas:
- Días transcurridos: > 30
- Estado de pago: != "pagado"

Operadores lógicos: Y (ambas condiciones deben cumplirse)
-->

## Persistencia

<!--
¿Qué sucede con el conocimiento derivado?
¿Se guarda? ¿Dónde? ¿Por cuánto tiempo?
-->

**¿Se persiste?**: [Sí | No]

**Si se persiste**:
- **Ubicación**: [Base de datos, archivo, campo específico]
- **Duración**: [Permanente | Temporal | Hasta que cambie condición]
- **Actualización**: [Único evento | Se recalcula periódicamente]

**Si NO se persiste**:
- **Razón**: [Por qué no se guarda]
- **Cálculo**: [Cuándo y cómo se recalcula]

## Ejemplo Concreto

<!--
OPCIONAL pero RECOMENDADO: Proporcione un ejemplo concreto de cómo funciona esta inferencia.
Ayuda a clarificar la regla con un caso real.
-->

**Escenario**: [Describa un escenario específico]

**Hechos de entrada**:
- [Hecho 1 con valores específicos]
- [Hecho 2 con valores específicos]

**Aplicación de regla**: [Cómo se aplica la lógica]

**Conocimiento resultante**: [Qué nuevo conocimiento se establece]

<!--
Ejemplo:
Escenario: Cuenta del cliente "Empresa ABC"

Hechos de entrada:
- Fecha de vencimiento de factura: 2025-10-01
- Fecha actual: 2025-11-05
- Estado de pago: "pendiente"
- Días transcurridos: 35 días

Aplicación de regla:
35 días > 30 días Y estado != "pagado"
Ambas condiciones se cumplen

Conocimiento resultante:
Cuenta de "Empresa ABC" se marca como "deudora"
Este estado se guarda en el campo account_status en la base de datos
-->

## Uso del Conocimiento Derivado

<!--
¿Para qué se usa este conocimiento derivado?
¿Qué otros procesos, reglas o decisiones lo utilizan?
-->

**Utilizado por**:
- [Proceso 1]: [Cómo lo usa]
- [Regla 2]: [Cómo lo usa]
- [Decisión 3]: [Cómo lo usa]

<!-- Ejemplo:
Utilizado por:
- RN-BACK-031 (Desencadenador): Si cuenta es deudora ENTONCES enviar notificación
- UC-BACK-015: Consultar estado de cuenta (muestra "deudora")
- Reporte mensual: Lista de cuentas deudoras
-->

## Impacto en Requisitos

<!--
Liste los requisitos de otros niveles que son influenciados por esta inferencia.
-->

**Requerimientos de Negocio**:
- [RNEG-DOMINIO-###]: [Breve descripción]

**Requerimientos de Usuario**:
- [UC-DOMINIO-###]: [Nombre del caso de uso]

**Requisitos Funcionales**:
- [RF-DOMINIO-###]: [Breve descripción]

**Atributos de Calidad**:
- [RNF-DOMINIO-###]: [Breve descripción]

## Notas Adicionales

<!--
OPCIONAL: Agregue cualquier información adicional relevante.
Elimine esta sección si no es necesaria.
-->

[Notas adicionales, observaciones, consideraciones especiales]

## Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | [YYYY-MM-DD] | [Autor] | Versión inicial |

<!-- Agregue nuevas filas para cambios posteriores -->
