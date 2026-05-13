---
title: Plantilla 1 - Documento Maestro de Análisis Integrado
date: 2025-11-16
domain: general
status: active
tipo: plantilla
plantilla_numero: 1
---

# Plantilla 1: Documento Maestro de Análisis Integrado

### Propósito

Documento que integra todos los artefactos de análisis para un componente o funcionalidad específica del sistema IACT.

### Estructura de la Plantilla

```markdown
# Análisis Integrado: [NOMBRE DEL COMPONENTE]

**ID:** AI-[XXX]
**Versión:** X.Y
**Fecha:** YYYY-MM-DD
**Autor:** [Nombre]
**Estado:** Borrador | En Revisión | Aprobado
**Área:** [Seguridad | Gestión de Usuarios | Operaciones | ...]

## 1. Contexto de Negocio

### 1.1 Objetivo
[Descripción del objetivo de negocio que motiva este componente]

### 1.2 Stakeholders

| Rol | Nombre | Interés | Nivel de Influencia |
|-----|--------|---------|-------------------|
| [Rol] | [Nombre] | [Descripción] | Alto | Medio | Bajo |

### 1.3 Alcance

**Incluye:**
- [Elemento 1]
- [Elemento 2]

**Excluye:**
- [Elemento 1]
- [Elemento 2]

### 1.4 Restricciones y Supuestos

**Restricciones:**
- [Restricción técnica 1]
- [Restricción de negocio 1]

**Supuestos:**
- [Supuesto 1]
- [Supuesto 2]

---

## 2. Procesos de Negocio

### 2.1 Proceso Principal

**ID:** PROC-[ÁREA]-[NNN]
**Nombre:** [Nombre del Proceso]

**Descripción:**
[Descripción narrativa del proceso]

**Diagrama BPMN:**

```
[Insertar diagrama BPMN o descripción textual del flujo]

INICIO
  |
  v
[Paso 1]
  |
  v
[Decisión?]
  |--Sí--> [Rama A]
  |
  No
  v
[Rama B]
  |
  v
FIN
```

**Actores:**
- Actor 1: [Descripción]
- Actor 2: [Descripción]

**Entradas:**
- Entrada 1: [Descripción, formato]
- Entrada 2: [Descripción, formato]

**Salidas:**
- Salida 1: [Descripción, formato]
- Salida 2: [Descripción, formato]

**Reglas de Negocio Aplicables:**
- RN-[XXX]: [Nombre corto]
- RN-[YYY]: [Nombre corto]

**Métricas:**
- Tiempo de ejecución esperado: [X minutos/horas]
- Volumen: [X operaciones/día]
- Criticidad: Alta | Media | Baja

### 2.2 Subprocesos (si aplica)

[Repetir estructura para cada subproceso]

---

## 3. Reglas de Negocio

### 3.1 Catálogo de Reglas

**RN-[ÁREA]-[NN]: [Nombre de la Regla]**

```
Tipo: Hecho | Restricción | Desencadenador | Inferencia | Cálculo
Categoría: [Categoría específica]

Descripción:
[Descripción detallada de la regla]

Expresión Formal:
SI [condición]
ENTONCES [acción/resultado]
SI NO [acción alternativa]

Validación:
- [Cómo se valida la regla]

Excepción:
- [Casos excepcionales, si aplican]

Impacto:
- Proceso: [ID del proceso afectado]
- Caso de Uso: [ID del caso de uso afectado]
- Requisito: [ID del requisito derivado]

Sanción (si aplica):
- [Qué ocurre si se viola la regla]

Referencia:
- Documento: [Ruta del documento detallado]
```

[Repetir para cada regla del componente]

---

## 4. Casos de Uso

### 4.1 Diagrama de Casos de Uso

```
[Insertar diagrama UML de casos de uso o descripción textual]

Actor: Usuario
  - UC-XXX: Acción Principal
  - UC-YYY: Acción Secundaria

Actor: Sistema
  - UC-ZZZ: Proceso Automático
```

### 4.2 Especificación de Casos de Uso

**UC-[NNN]: [VERBO + OBJETO]**

| Caso de Uso | UC-[NNN]: [Nombre] |
|-------------|-------------------|
| **Actor Principal** | [Actor] |
| **Stakeholders** | - Stakeholder 1: [Interés]<br>- Stakeholder 2: [Interés] |
| **Precondiciones** | - Precondición 1<br>- Precondición 2 |
| **Postcondiciones Éxito** | - Postcondición éxito 1<br>- Postcondición éxito 2 |
| **Postcondiciones Fallo** | - Postcondición fallo 1<br>- Postcondición fallo 2 |
| **Disparador** | [Evento que inicia el caso de uso] |

**Flujo Principal:**

| Paso | Acción del Actor | Respuesta del Sistema |
|------|-----------------|----------------------|
| 1 | [Acción] | [Respuesta] |
| 2 | [Acción] | [Respuesta] |
| 3 | - | [Acción del sistema] |
| ... | ... | ... |

**Flujos Alternativos:**

**FA-1: [Nombre del Flujo Alternativo]**

| Paso | Condición | Acción del Sistema |
|------|-----------|-------------------|
| 3a | [Condición que dispara este flujo] | [Acción] |
| 3b | - | [Acción] |
| 3c | - | Retorna a paso [N] o FIN |

[Repetir para cada flujo alternativo]

**Flujos de Excepción:**

**FE-1: [Nombre del Flujo de Excepción]**

| Paso | Error | Acción del Sistema |
|------|-------|-------------------|
| *a | [Error que puede ocurrir en cualquier momento] | [Acción de recuperación] |

**Requisitos Especiales:**
- Rendimiento: [Requisito específico]
- Seguridad: [Requisito específico]
- Usabilidad: [Requisito específico]

**Trazabilidad:**
- Proceso: [ID proceso]
- Reglas: [IDs de reglas aplicadas]
- Requisitos derivados: [IDs de requisitos]

[Repetir estructura para cada caso de uso]

---

## 5. Requisitos

### 5.1 Requisitos Funcionales

**RF-[NNN]: [Título del Requisito]**

```
ID: RF-[NNN]
Título: [Título descriptivo]
Prioridad: MUST | SHOULD | COULD | WON'T (MoSCoW)
Categoría: [Categoría específica]

Descripción:
[Descripción detallada del requisito]

Criterios de Aceptación:
1. [Criterio 1]
2. [Criterio 2]
3. [Criterio 3]

Entrada:
- parámetro1: tipo (descripción)
- parámetro2: tipo (descripción)

Salida:
- resultado: tipo (descripción)

Proceso (si aplica):
[Descripción paso a paso del proceso que implementa el requisito]

Reglas de Negocio:
- RN-[XXX]: [Nombre]
- RN-[YYY]: [Nombre]

Validaciones:
- [Validación 1]
- [Validación 2]

Manejo de Errores:
- [Error 1]: [Acción]
- [Error 2]: [Acción]

Trazabilidad:
- Proceso: [ID]
- Caso de Uso: [ID] (paso [N])
- Prueba: [ID de caso de prueba]

Referencias:
- docs/implementacion/[ruta al documento detallado]
```

[Repetir para cada requisito funcional]

### 5.2 Requisitos No Funcionales

**RNF-[NNN]: [Título del Requisito]**

```
ID: RNF-[NNN]
Título: [Título descriptivo]
Categoría: Rendimiento | Seguridad | Usabilidad | Confiabilidad | Mantenibilidad

Descripción:
[Descripción detallada del requisito no funcional]

Métrica:
[Métrica específica y medible]
Ejemplo: P95 <= 500ms, Disponibilidad >= 99.5%

Condiciones:
[Condiciones bajo las cuales se mide la métrica]

Trazabilidad:
- Proceso: [ID]
- Caso de Uso: [ID]
- Requisito Funcional relacionado: [ID]
```

[Repetir para cada requisito no funcional]

---

## 6. Procedimientos Operacionales

### 6.1 Procedimiento: [NOMBRE]

**ID:** PROC-[NOMBRE]-[NNN]
**Objetivo:** [Objetivo del procedimiento]
**Alcance:** [A quién aplica]
**Responsable:** [Rol responsable]
**Frecuencia:** [Cuando se ejecuta]

**Pasos Detallados:**

| Paso | Pantalla/Ubicación | Acción del Usuario | Validación del Sistema | Referencia |
|------|-------------------|-------------------|----------------------|------------|
| 1 | [Pantalla] | [Acción] | [Validación] | [UC/RF] |
| 2 | [Pantalla] | [Acción] | [Validación] | [UC/RF] |
| ... | ... | ... | ... | ... |

**Casos Especiales:**

**CE-1: [Nombre del Caso Especial]**

| Paso | Acción | Sistema |
|------|--------|---------|
| 1 | [Acción] | [Respuesta] |
| ... | ... | ... |

**Errores Comunes y Soluciones:**

| Error | Causa Probable | Solución |
|-------|---------------|----------|
| [Mensaje de error] | [Causa] | [Solución paso a paso] |

**Validaciones Visuales:**
[Capturas de pantalla o mockups de las interfaces clave]

---

## 7. Matriz de Trazabilidad

### 7.1 Matriz Proceso-UC-Requisito

| Proceso | Caso de Uso | Requisito Funcional | Requisito No Funcional | Regla de Negocio |
|---------|-------------|---------------------|----------------------|-----------------|
| PROC-[X] | UC-[X] | RF-[X] | RNF-[X] | RN-[X] |
| PROC-[X] | UC-[Y] | RF-[Y] | - | RN-[Y] |

### 7.2 Matriz UC-Requisito-Prueba

| Caso de Uso | Requisito | Caso de Prueba | Estado |
|-------------|-----------|---------------|--------|
| UC-[X] | RF-[X] | TS-RF-[X]-001 | Pendiente | En Progreso | Pasó | Falló |

---

## 8. Pruebas

### 8.1 Plan de Pruebas

**Objetivo:**
[Qué se busca validar con las pruebas]

**Alcance:**
[Qué requisitos/casos de uso se prueban]

**Casos de Prueba:**

**TS-RF-[NNN]-[001]: [Nombre del Caso de Prueba]**

```
ID: TS-RF-[NNN]-[001]
Requisito: RF-[NNN]
Prioridad: Alta | Media | Baja
Tipo: Unitaria | Integración | Sistema | Aceptación

Precondiciones:
- [Precondición 1]
- [Precondición 2]

Datos de Entrada:
- [Dato 1]: [Valor]
- [Dato 2]: [Valor]

Pasos:
1. [Paso 1]
2. [Paso 2]
3. [Paso 3]

Resultado Esperado:
[Descripción del resultado esperado]

Criterios de Éxito:
- [Criterio 1]
- [Criterio 2]

Estado: Pendiente | En Progreso | Pasó | Falló
Fecha de Ejecución: [YYYY-MM-DD]
Ejecutado por: [Nombre]
Notas: [Observaciones]
```

[Repetir para cada caso de prueba]

---

## 9. Documentación de Diseño e Implementación

### 9.1 Arquitectura

**Componentes:**
- [Componente 1]: [Descripción]
- [Componente 2]: [Descripción]

**Diagrama de Arquitectura:**
[Insertar diagrama o descripción]

### 9.2 Modelo de Datos

**Entidades:**

**[Nombre de Entidad]**

```sql
CREATE TABLE [nombre_tabla] (
  id UUID PRIMARY KEY,
  [campo1] [tipo] [restricciones],
  [campo2] [tipo] [restricciones],
  ...
);
```

**Relaciones:**
- [Entidad 1] -- [relación] --> [Entidad 2]

---

## 10. Checklist de Completitud

### 10.1 Artefactos Obligatorios

- [ ] Contexto de negocio documentado
- [ ] Al menos 1 proceso de negocio definido
- [ ] Reglas de negocio identificadas y documentadas
- [ ] Al menos 1 caso de uso especificado
- [ ] Requisitos funcionales derivados
- [ ] Requisitos no funcionales identificados
- [ ] Matriz de trazabilidad completa
- [ ] Procedimientos operacionales (si aplica)
- [ ] Casos de prueba definidos

### 10.2 Validación de Trazabilidad

- [ ] Cada proceso tiene al menos 1 caso de uso
- [ ] Cada caso de uso deriva al menos 1 requisito funcional
- [ ] Cada requisito funcional está trazado a un caso de uso
- [ ] Cada requisito funcional tiene al menos 1 caso de prueba
- [ ] Cada regla de negocio está aplicada en al menos 1 requisito
- [ ] Trazabilidad bidireccional (upward y downward) documentada

### 10.3 Estándares de Calidad

- [ ] Nomenclatura estándar: PROC-[ÁREA]-[NNN], UC-[NNN], RF-[NNN], RN-[ÁREA]-[NN]
- [ ] Sin emojis en documentos (estándar del proyecto)
- [ ] Casos de uso en formato: VERBO + OBJETO
- [ ] Tablas de dos columnas para casos de uso
- [ ] Referencias cruzadas entre documentos
- [ ] Conformidad con ISO 29148:2018
- [ ] Conformidad con BABOK v3

---

## 11. Aprobaciones

| Rol | Nombre | Firma | Fecha |
|-----|--------|-------|-------|
| Analista de Negocio | [Nombre] | | |
| Arquitecto de Software | [Nombre] | | |
| Líder Técnico | [Nombre] | | |
| Product Owner | [Nombre] | | |

---

## 12. Control de Cambios

| Versión | Fecha | Autor | Descripción del Cambio |
|---------|-------|-------|----------------------|
| 0.1 | [Fecha] | [Autor] | Versión inicial |
| 0.2 | [Fecha] | [Autor] | [Cambios realizados] |

---

**Fin de la Plantilla de Documento Maestro**
```

---

## Referencias

Esta plantilla fue extraída de: [06_plantillas_integradas_iact.md](../06_plantillas_integradas_iact.md)

Para más información sobre el marco integrado de análisis, consulte la documentación completa en el directorio padre.
