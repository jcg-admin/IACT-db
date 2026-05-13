---
id: RF-[DOMINIO]-[###]
tipo: requisito_funcional
categoria: [DOMINIO]
version: 1.0.0
fecha_creacion: [YYYY-MM-DD]
ultima_actualizacion: [YYYY-MM-DD]
autor: [NOMBRE_AUTOR]
estado: [borrador|en_revision|aprobado|implementado|obsoleto]
prioridad: [alta|media|baja]
---

# RF-[DOMINIO]-[###]: [Título del Requisito Funcional]

<!--
INSTRUCCIONES:
- Reemplace [DOMINIO] con: BACK, FRONT, DEVOPS, QA, AI, GOB
- Reemplace [###] con número secuencial: 001, 002, 003, etc.
- El título debe describir QUÉ debe hacer el sistema (NO CÓMO)
- Los RF son funciones específicas que el sistema debe realizar
- Derivados de Casos de Uso (nivel superior)
- Implementables directamente por desarrolladores

PRINCIPIO QUÉ vs CÓMO:
- CORRECTO: "El sistema debe validar formato de email según RFC 5322"
- INCORRECTO: "El sistema debe usar regex ^[a-z]+@[a-z]+\.[a-z]+$ para validar email"
- Describa QUÉ debe hacer el sistema, NO CÓMO implementarlo

CARACTERÍSTICAS:
- Detallado y específico
- Verificable y testeable
- Sin ambigüedades
- Una sola funcionalidad por RF
-->

## Descripción

<!--
Escriba una descripción clara y concisa del requisito funcional.
¿Qué debe hacer el sistema?
Use el formato: "El sistema debe [acción] [objeto] [condiciones]"

Ejemplos:
- "El sistema debe validar credenciales de usuario contra la base de datos de autenticación"
- "El sistema debe generar token JWT con expiración de 15 minutos al autenticar exitosamente"
- "El sistema debe enviar email de confirmación dentro de 5 minutos después de registro"
- "El sistema debe validar formato de email según RFC 5322"
-->

El sistema debe [describir la funcionalidad específica que el sistema debe realizar]

## Criterios de Aceptación

<!--
Liste criterios claros y verificables que determinan cuándo este requisito está cumplido.
Use formato "Dado-Cuando-Entonces" (Given-When-Then) cuando sea apropiado.

Cada criterio debe ser:
- Específico y medible
- Testeable
- Sin ambigüedad
-->

1. **Criterio 1**: [Descripción del primer criterio]
   - **Dado**: [Precondición]
   - **Cuando**: [Acción]
   - **Entonces**: [Resultado esperado]

2. **Criterio 2**: [Descripción del segundo criterio]
   - **Dado**: [Precondición]
   - **Cuando**: [Acción]
   - **Entonces**: [Resultado esperado]

3. **Criterio 3**: [Descripción del tercer criterio]

<!--
EJEMPLO:
1. Email válido es aceptado:
   - Dado: Un usuario ingresa "usuario@ejemplo.com"
   - Cuando: El sistema valida el formato
   - Entonces: El sistema acepta el email como válido

2. Email inválido es rechazado:
   - Dado: Un usuario ingresa "usuario@ejemplo"
   - Cuando: El sistema valida el formato
   - Entonces: El sistema rechaza el email y muestra mensaje de error

3. Email sin @ es rechazado:
   - Dado: Un usuario ingresa "usuario.ejemplo.com"
   - Cuando: El sistema valida el formato
   - Entonces: El sistema rechaza el email y muestra mensaje "Formato de email inválido"
-->

## Entradas

<!--
Liste las entradas que este requisito funcional necesita.
¿Qué datos o información recibe?
-->

| Entrada | Tipo | Formato | Validaciones | Origen |
|---------|------|---------|--------------|--------|
| [Entrada1] | [tipo de dato] | [formato específico] | [validaciones aplicadas] | [de dónde viene] |
| [Entrada2] | [tipo de dato] | [formato específico] | [validaciones aplicadas] | [de dónde viene] |

<!--
EJEMPLO:
| Entrada | Tipo | Formato | Validaciones | Origen |
|---------|------|---------|--------------|--------|
| Email | String | RFC 5322 | No vacío, formato válido | Formulario de usuario |
| Contraseña | String | Min 8 caracteres | No vacía, >= 8 chars | Formulario de usuario |
-->

## Salidas

<!--
Liste las salidas que este requisito funcional produce.
¿Qué genera o devuelve?
-->

| Salida | Tipo | Formato | Condición | Destino |
|--------|------|---------|-----------|---------|
| [Salida1] | [tipo de dato] | [formato específico] | [cuándo se produce] | [a dónde va] |
| [Salida2] | [tipo de dato] | [formato específico] | [cuándo se produce] | [a dónde va] |

<!--
EJEMPLO:
| Salida | Tipo | Formato | Condición | Destino |
|--------|------|---------|-----------|---------|
| Token JWT | String | JWT estándar | Si autenticación exitosa | Cliente (cookie/header) |
| Mensaje de error | String | JSON {"error": "mensaje"} | Si autenticación falla | Cliente (respuesta HTTP) |
| Registro de auditoría | Object | JSON estructurado | Siempre | Log de auditoría |
-->

## Reglas de Procesamiento

<!--
OPCIONAL: Si hay lógica de procesamiento específica, descríbala aquí.
¿Qué pasos o reglas sigue el sistema para cumplir este requisito?

Si no hay reglas complejas, elimine esta sección.
-->

1. [Paso 1 del procesamiento]
2. [Paso 2 del procesamiento]
3. [Paso 3 del procesamiento]

<!--
EJEMPLO (para validación de email):
1. Verificar que el campo no esté vacío
2. Verificar que contiene exactamente un símbolo @
3. Verificar que parte local (antes de @) cumple RFC 5322
4. Verificar que dominio (después de @) es válido
5. Si todas las validaciones pasan, marcar como válido
6. Si alguna validación falla, marcar como inválido y generar mensaje de error
-->

## Trazabilidad

<!--
Establezca las relaciones con otros artefactos de requisitos.
Esto es CRÍTICO para gestión de cambios.
-->

### Trazabilidad Ascendente (De dónde se deriva)

**Implementa Casos de Uso**:
- [UC-DOMINIO-###]: [Nombre del caso de uso]
- [UC-DOMINIO-###]: [Nombre del caso de uso]

<!--
Ejemplo:
- UC-BACK-001: Iniciar Sesión
- UC-BACK-003: Cambiar Contraseña
-->

**Derivado de Reglas de Negocio**:
- [RN-DOMINIO-###]: [Nombre de la regla]
- [RN-DOMINIO-###]: [Nombre de la regla]

<!--
Ejemplo:
- RN-BACK-001: Usuario debe estar autenticado
- RN-BACK-005: Contraseña debe cumplir requisitos de seguridad
-->

**Relacionado con Requerimientos de Negocio**:
- [RNEG-DOMINIO-###]: [Nombre del requerimiento]

### Trazabilidad Descendente (Qué se deriva de esto)

**Cumple Atributos de Calidad**:
- [RNF-DOMINIO-###]: [Descripción breve]
- [RNF-DOMINIO-###]: [Descripción breve]

<!--
Ejemplo:
- RNF-BACK-006: Sistema debe responder en < 2 segundos
- RNF-BACK-005: Contraseña debe tener mínimo 8 caracteres
-->

**Tests Relacionados**:
- [TS-DOMINIO-###-001]: [Descripción del test]
- [TS-DOMINIO-###-002]: [Descripción del test]
- [TS-DOMINIO-###-003]: [Descripción del test]

<!--
Ejemplo:
- TS-BACK-010-001: Test validación credenciales correctas
- TS-BACK-010-002: Test validación credenciales incorrectas
- TS-BACK-010-003: Test usuario inexistente
-->

### Trazabilidad Lateral (Relaciones con otros RF)

**Depende de**:
<!--
Otros RF que deben existir para que este funcione
-->
- [RF-DOMINIO-###]: [Descripción de la dependencia]

**Usado por**:
<!--
Otros RF que usan este requisito
-->
- [RF-DOMINIO-###]: [Cómo lo usa]

## Restricciones

<!--
OPCIONAL: Liste restricciones técnicas o de negocio específicas.
Si no hay, elimine esta sección.
-->

- [Restricción 1]
- [Restricción 2]

<!--
Ejemplos:
- Debe usar biblioteca estándar de validación, no regex custom
- No debe almacenar contraseñas en texto plano
- Debe ser compatible con navegadores modernos (últimas 2 versiones)
-->

## Supuestos

<!--
OPCIONAL: Liste supuestos que se hacen al especificar este requisito.
Si no hay, elimine esta sección.
-->

- [Supuesto 1]
- [Supuesto 2]

<!--
Ejemplos:
- Se asume que la base de datos de usuarios está siempre disponible
- Se asume que los emails de usuarios son únicos en el sistema
-->

## Notas de Implementación

<!--
OPCIONAL: Notas técnicas relevantes para desarrolladores.
NO describa CÓMO implementar, pero puede incluir:
- Referencias a estándares
- Bibliotecas recomendadas (no obligatorias)
- Consideraciones importantes

Si no hay notas, elimine esta sección.
-->

- [Nota 1]
- [Nota 2]

<!--
Ejemplos:
- Consultar RFC 5322 para especificación completa de formato email
- Considerar usar biblioteca validator.js (no obligatorio)
- Tener en cuenta internacionalización de dominios (IDN)
-->

## Estado de Implementación

<!--
Tracking del progreso de implementación
-->

**Estado**: [No iniciado | En progreso | Implementado | En testing | Desplegado | Obsoleto]

**Responsable**: [Nombre o equipo responsable]

**Fecha estimada**: [YYYY-MM-DD]

**Fecha real**: [YYYY-MM-DD] (cuando se complete)

**Módulo/Componente**: [Dónde se implementa]

**Ubicación en código**: [Path al código relevante] (cuando esté implementado)

## Validación y Testing

**Tests unitarios requeridos**: [Sí | No]

**Tests de integración requeridos**: [Sí | No]

**Tests E2E requeridos**: [Sí | No]

**Cobertura mínima esperada**: [porcentaje]%

**Escenarios de prueba críticos**:
1. [Escenario 1]
2. [Escenario 2]
3. [Escenario 3]

## Información Adicional

**Prioridad**: [Alta | Media | Baja]

**Complejidad estimada**: [Baja | Media | Alta]

**Esfuerzo estimado**: [story points, horas, días - según metodología]

**Riesgos identificados**:
<!--
OPCIONAL: Si hay riesgos conocidos, liste aquí.
Elimine si no aplica.
-->
- [Riesgo 1]: [Descripción y mitigación]
- [Riesgo 2]: [Descripción y mitigación]

## Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | [YYYY-MM-DD] | [Autor] | Versión inicial |

<!-- Agregue nuevas filas para cambios posteriores -->

## Aprobación

**Especificado por**: [Nombre]

**Revisado por**: [Nombre] - [Fecha]

**Aprobado por**: [Nombre] - [Fecha]
