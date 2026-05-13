---
id: RN-[DOMINIO]-[###]
tipo: regla_negocio
subtipo: restriccion
categoria: [DOMINIO]
version: 1.0.0
fecha: [YYYY-MM-DD]
autor: [NOMBRE_AUTOR]
estado: [borrador|en_revision|aprobado|obsoleto]
---

# RN-[DOMINIO]-[###]: [Título de la Restricción]

<!--
INSTRUCCIONES:
- Reemplace [DOMINIO] con: BACK, FRONT, DEVOPS, QA, AI, GOB
- Reemplace [###] con número secuencial: 001, 002, 003, etc.
- El título debe describir claramente la restricción
- Las restricciones limitan acciones de usuarios y sistemas
-->

## Tipo

Restricción

## Declaración

<!--
Escriba aquí la declaración clara de la restricción.
USE las palabras clave obligatorias según el tipo de restricción:

- "debe" → Obligación
- "no debe" → Prohibición
- "no puede" → Limitación
- "solo puede" → Restricción exclusiva

Ejemplos:
- "Un solicitante de préstamo que es menor de 18 años DEBE tener un padre o tutor legal como cosignatario"
- "Un usuario de la biblioteca NO PUEDE tener más de 10 artículos en espera en cualquier momento"
- "La correspondencia NO DEBE mostrar más de cuatro dígitos del número de seguro social"
- "SOLO PUEDE acceder el administrador del sistema"
-->

[Escriba aquí la declaración de la restricción usando palabras clave: debe, no debe, no puede, solo puede]

## Alcance

<!--
Defina claramente a qué o quién aplica esta restricción
-->

**Aplica a**: [Usuarios | Sistema | Módulo específico | Proceso específico]

**Roles afectados**:
- [Rol 1]
- [Rol 2]
- [Rol 3]
<!-- Agregue o elimine roles según sea necesario -->

## Matriz de Permisos

<!--
OPCIONAL: Si esta restricción se basa en roles de usuario, incluya una matriz de permisos.
Elimine esta sección si no aplica.

Ejemplo:
| Operación | Administrador | Staff | Usuario | Invitado |
|-----------|:-------------:|:-----:|:-------:|:--------:|
| Ver registro | ✓ | ✓ | ✓ | ✓ |
| Editar registro | ✓ | ✓ | ✗ | ✗ |
| Eliminar registro | ✓ | ✗ | ✗ | ✗ |

Leyenda: ✓ = Permitido    ✗ = No permitido
-->

| Operación | [Rol 1] | [Rol 2] | [Rol 3] | [Rol 4] |
|-----------|:-------:|:-------:|:-------:|:-------:|
| [Operación 1] | ✓ | ✓ | ✗ | ✗ |
| [Operación 2] | ✓ | ✗ | ✗ | ✗ |
| [Operación 3] | ✓ | ✓ | ✓ | ✓ |

**Leyenda**: ✓ = Permitido    ✗ = No permitido

<!-- Agregue o elimine filas/columnas según sea necesario -->

## Justificación

<!--
Explique por qué existe esta restricción.
Posibles razones:
- Seguridad
- Regulación legal
- Política organizacional
- Protección de datos
- Control de calidad
-->

**Razón**: [Seguridad | Regulación | Política | Protección de Datos | Control de Calidad]

**Detalle**: [Explique por qué esta restricción es necesaria]

## Excepciones

<!--
OPCIONAL: Liste cualquier excepción a la restricción.
Si no hay excepciones, escriba "No hay excepciones" o elimine esta sección.
-->

**¿Existen excepciones?**: [Sí | No]

**Excepciones**:
1. [Descripción de excepción 1 - bajo qué condiciones no aplica la restricción]
2. [Descripción de excepción 2]

<!-- O si no hay excepciones: -->
<!-- No hay excepciones a esta restricción. -->

## Validación

<!--
Describa cómo se valida el cumplimiento de esta restricción.
¿Qué métodos o mecanismos aseguran que se cumple?
-->

**Método de validación**: [Validación automática | Validación manual | Auditoría periódica]

**Descripción**: [Explique cómo se valida que la restricción se cumple]

**Frecuencia**: [En tiempo real | Diaria | Semanal | Mensual | Por evento]

## Consecuencias de Incumplimiento

<!--
OPCIONAL: Describa qué sucede si esta restricción es violada.
Elimine esta sección si no es relevante.
-->

[Describa las consecuencias de no cumplir con esta restricción]

## Impacto en Requisitos

<!--
Liste los requisitos de otros niveles que son influenciados por esta restricción.
Esto establece la trazabilidad descendente.
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
