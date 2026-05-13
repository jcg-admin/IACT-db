---
id: RN-[DOMINIO]-[###]
tipo: regla_negocio
subtipo: desencadenador
categoria: [DOMINIO]
version: 1.0.0
fecha: [YYYY-MM-DD]
autor: [NOMBRE_AUTOR]
estado: [borrador|en_revision|aprobado|obsoleto]
---

# RN-[DOMINIO]-[###]: [Título del Desencadenador]

<!--
INSTRUCCIONES:
- Reemplace [DOMINIO] con: BACK, FRONT, DEVOPS, QA, AI, GOB
- Reemplace [###] con número secuencial: 001, 002, 003, etc.
- El título debe describir la acción que se desencadena
- Los desencadenadores siguen el patrón SI-ENTONCES donde "entonces" es una ACCIÓN

DIFERENCIA CLAVE con Inferencias:
- Desencadenador: SI [condición] ENTONCES [EJECUTAR ACCIÓN]
  Ejemplo: SI caducidad alcanzada ENTONCES enviar notificación
- Inferencia: SI [condición] ENTONCES [ESTABLECER NUEVO HECHO]
  Ejemplo: SI pago no recibido en 30 días ENTONCES cuenta es deudora
-->

## Tipo

Desencadenador de Acción

## Declaración

<!--
IMPORTANTE: Use el patrón SI-ENTONCES donde el "entonces" describe una ACCIÓN.
La cláusula "entonces" debe indicar qué se EJECUTA o qué SUCEDE.

Ejemplos correctos:
- SI el almacén tiene contenedores en stock ENTONCES ofrece los contenedores al solicitante
- SI se alcanza fecha de vencimiento ENTONCES notifica a la persona a cargo
- SI usuario intenta login 3 veces con credenciales incorrectas ENTONCES bloquear cuenta por 15 minutos

Palabras clave que indican acción:
- enviar, notificar, alertar, informar
- bloquear, desbloquear, activar, desactivar
- registrar, guardar, almacenar
- ofrecer, mostrar, presentar
- ejecutar, procesar, iniciar
-->

**SI**: [Describa la condición o evento que dispara la regla]

**ENTONCES**: [Describa la(s) acción(es) que se ejecutan - use verbos de acción]

## Condición de Activación

<!--
Describa en detalle cuándo se activa este desencadenador.
¿Qué debe suceder o qué debe ser verdadero?
Sea específico con valores, umbrales, estados.
-->

**Tipo de condición**: [Evento | Estado | Umbral | Temporal]

**Descripción detallada**:

[Describa aquí en detalle cuándo se activa este desencadenador]

**Parámetros**:
- [Parámetro 1]: [Valor o rango que dispara la regla]
- [Parámetro 2]: [Valor o rango que dispara la regla]

<!-- Ejemplos:
- Cantidad: >= 3 intentos
- Fecha: fecha actual >= fecha vencimiento
- Estado: stock disponible > 0
-->

## Acción(es) Desencadenada(s)

<!--
Liste todas las acciones que se ejecutan cuando se cumple la condición.
Use verbos de acción.
Numere las acciones si son múltiples y hay secuencia.
-->

1. [Primera acción que se ejecuta]
2. [Segunda acción que se ejecuta]
3. [Tercera acción que se ejecuta]

<!-- Ejemplos:
1. Enviar email de notificación al gerente
2. Registrar evento en log de auditoría
3. Bloquear cuenta del usuario por 15 minutos
-->

## Frecuencia Esperada

<!--
¿Qué tan frecuente se espera que se active esta regla?
Esto ayuda a entender el volumen de eventos.
-->

**Frecuencia**: [Continua | Alta (varias veces al día) | Media (diaria/semanal) | Baja (mensual/ocasional)]

**Estimación**: [Número aproximado de veces que se activa por período]

**Justificación**: [Por qué se espera esa frecuencia]

## Prioridad

<!--
¿Qué tan importante es que esta acción se ejecute inmediatamente?
-->

**Prioridad**: [Alta | Media | Baja]

**Justificación**: [Por qué tiene esta prioridad]

**Tiempo de respuesta esperado**: [Inmediato | < 1 minuto | < 5 minutos | Mejor esfuerzo]

## Actores Involucrados

<!--
¿Quiénes están involucrados en esta regla?
- Quién recibe notificaciones
- Quién debe ejecutar acciones manuales
- Qué sistemas externos son notificados
-->

**Actores que reciben notificación**:
- [Actor 1]: [Qué recibe o qué debe hacer]
- [Actor 2]: [Qué recibe o qué debe hacer]

**Sistemas involucrados**:
- [Sistema 1]: [Qué acción realiza]
- [Sistema 2]: [Qué acción realiza]

## Ejemplo Concreto

<!--
OPCIONAL pero RECOMENDADO: Proporcione un ejemplo concreto de cómo funciona esta regla.
Ayuda a clarificar la regla con un caso real.
-->

**Escenario**: [Describa un escenario específico]

**Condición**: [Valores específicos que cumplen la condición]

**Acción resultante**: [Qué sucede exactamente en este escenario]

<!--
Ejemplo:
Escenario: Usuario "juan.perez" intenta iniciar sesión
Condición: Ya ha intentado 3 veces con contraseña incorrecta en los últimos 5 minutos
Acción resultante:
  1. Sistema bloquea cuenta de juan.perez por 15 minutos
  2. Sistema envía email a juan.perez notificando bloqueo
  3. Sistema registra evento en log de seguridad
-->

## Impacto en Requisitos

<!--
Liste los requisitos de otros niveles que son influenciados por este desencadenador.
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
