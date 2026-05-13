# Plantillas Integradas del Marco IACT

**Versión:** 1.0
**Fecha:** 2025-11-05
**Estado:** Vigente

## Propósito del Documento

Este documento proporciona plantillas reutilizables para aplicar el marco integrado de análisis de negocio en el proyecto IACT. Cada plantilla está diseñada para facilitar la creación sistemática de documentación trazable y completa.

## Referencias

- **01_marco_conceptual_iact.md** - Fundamentos del marco
- **04_metodologia_analisis_iact.md** - Metodología de 4 fases
- **docs/plantillas/** - Plantillas existentes del proyecto
- ISO/IEC/IEEE 29148:2018 - Estándar de ingeniería de requisitos
- BABOK v3 - Business Analysis Body of Knowledge

---

## Plantilla 1: Documento Maestro de Análisis Integrado

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

## Plantilla 2: Matriz de Trazabilidad Extendida (RTM)

### Propósito

Matriz completa de trazabilidad que conecta necesidades de negocio con requisitos, casos de uso, pruebas e implementación.

### Estructura de la Plantilla

```markdown
# Matriz de Trazabilidad de Requisitos (RTM): [COMPONENTE]

**ID:** RTM-[XXX]
**Versión:** X.Y
**Fecha:** YYYY-MM-DD
**Área:** [Área del sistema]

## 1. Resumen de Trazabilidad

| Métrica | Cantidad |
|---------|----------|
| Necesidades de Negocio | [N] |
| Procesos | [N] |
| Reglas de Negocio | [N] |
| Casos de Uso | [N] |
| Requisitos Funcionales | [N] |
| Requisitos No Funcionales | [N] |
| Casos de Prueba | [N] |
| Componentes Implementados | [N] |

## 2. Matriz Principal: Necesidad → Requisito → Prueba → Implementación

| ID Necesidad | Descripción | ID Proceso | ID UC | ID Requisito | Prioridad | ID Prueba | Estado Prueba | ID Implementación | Estado Impl |
|--------------|-------------|-----------|-------|--------------|-----------|-----------|--------------|-------------------|-------------|
| N-001 | [Descripción] | PROC-X | UC-X | RF-X | MUST | TS-X | Pasó | backend/auth | Completo |
| N-001 | [Descripción] | PROC-X | UC-Y | RF-Y | MUST | TS-Y | Pendiente | - | Pendiente |

## 3. Matriz Reglas de Negocio → Impacto

| ID Regla | Tipo | Nombre | Procesos Impactados | UC Impactados | Requisitos Derivados |
|----------|------|--------|-------------------|--------------|---------------------|
| RN-[X] | Restricción | [Nombre] | PROC-A, PROC-B | UC-1, UC-2 | RF-10, RF-11 |

## 4. Matriz UC → Requisitos → Pruebas

| ID UC | Nombre UC | Paso | ID RF | Nombre RF | Criterios Aceptación | ID Prueba | Estado |
|-------|-----------|------|-------|-----------|---------------------|-----------|--------|
| UC-001 | [Nombre] | 3 | RF-005 | [Nombre] | [Criterios] | TS-RF-005-001 | Pasó |
| UC-001 | [Nombre] | 5 | RF-006 | [Nombre] | [Criterios] | TS-RF-006-001 | Pasó |

## 5. Cobertura de Pruebas

| Tipo de Requisito | Total Requisitos | Requisitos con Prueba | % Cobertura |
|------------------|----------------|---------------------|-------------|
| Funcionales (MUST) | [N] | [N] | [%] |
| Funcionales (SHOULD) | [N] | [N] | [%] |
| No Funcionales | [N] | [N] | [%] |
| **TOTAL** | [N] | [N] | [%] |

## 6. Estado de Implementación

| Componente | Requisitos Asignados | Requisitos Implementados | % Completitud |
|-----------|-------------------|------------------------|---------------|
| Backend - Auth | [N] | [N] | [%] |
| Backend - Permisos | [N] | [N] | [%] |
| Frontend - UI | [N] | [N] | [%] |
| **TOTAL** | [N] | [N] | [%] |

## 7. Trazabilidad Inversa (Backward)

### 7.1 Requisitos Huérfanos

Lista de requisitos sin trazabilidad hacia arriba (no vinculados a UC o necesidad):

| ID Requisito | Nombre | Acción Requerida |
|--------------|--------|------------------|
| RF-[X] | [Nombre] | Vincular a UC-[Y] o eliminar |

### 7.2 Casos de Uso Sin Requisitos

Lista de casos de uso que no derivaron requisitos:

| ID UC | Nombre | Acción Requerida |
|-------|--------|------------------|
| UC-[X] | [Nombre] | Derivar requisitos o eliminar UC |

## 8. Trazabilidad Forward (Adelante)

### 8.1 Necesidades Sin Implementación

Lista de necesidades de negocio sin requisitos o sin implementación:

| ID Necesidad | Descripción | Estado | Acción Requerida |
|--------------|-------------|--------|------------------|
| N-[X] | [Descripción] | Sin requisitos | Analizar y derivar requisitos |
| N-[Y] | [Descripción] | Con requisitos, sin implementación | Priorizar implementación |

### 8.2 Requisitos Sin Pruebas

Lista de requisitos sin casos de prueba:

| ID Requisito | Nombre | Prioridad | Acción Requerida |
|--------------|--------|-----------|------------------|
| RF-[X] | [Nombre] | MUST | CREAR PRUEBA URGENTE |
| RF-[Y] | [Nombre] | SHOULD | Planificar creación de prueba |

## 9. Análisis de Cambios

### 9.1 Impacto de Cambios Recientes

| Fecha | Elemento Cambiado | Elementos Impactados | Estado de Propagación |
|-------|------------------|---------------------|---------------------|
| [Fecha] | RN-[X] modificada | RF-[A], RF-[B], TS-[C] | Actualizado |
| [Fecha] | UC-[Y] agregado | RF-[D] derivado | Prueba pendiente |

### 9.2 Cambios Pendientes

| Elemento | Cambio Solicitado | Fecha Solicitud | Elementos a Actualizar | Responsable |
|----------|------------------|---------------|----------------------|-------------|
| RF-[X] | Modificar criterio | [Fecha] | TS-[X], Implementación | [Nombre] |

## 10. Métricas de Calidad

### 10.1 Índice de Trazabilidad

```
Índice de Trazabilidad = (Requisitos con trazabilidad completa / Total de requisitos) * 100

Trazabilidad Completa = Requisito tiene:
- Vínculo a Necesidad/Proceso/UC (upward)
- Vínculo a Prueba (forward)
- Vínculo a Implementación (forward)

Valor Actual: [X%]
Meta: >= 95%
```

### 10.2 Índice de Cobertura de Pruebas

```
Cobertura de Pruebas = (Requisitos con prueba / Total de requisitos) * 100

Valor Actual: [X%]
Meta: >= 90% (MUST), >= 70% (SHOULD)
```

### 10.3 Índice de Completitud de Implementación

```
Completitud = (Requisitos implementados / Total de requisitos) * 100

Valor Actual: [X%]
Meta: >= 100% (MUST), >= 80% (SHOULD)
```

---

**Fin de la Plantilla RTM**
```

---

## Plantilla 3: Checklist de Completitud del Análisis

### Propósito

Checklist para validar que un análisis integrado está completo y cumple con los estándares del proyecto IACT.

### Estructura de la Plantilla

```markdown
# Checklist de Completitud del Análisis: [COMPONENTE]

**Componente:** [Nombre]
**Analista:** [Nombre]
**Fecha de Revisión:** YYYY-MM-DD
**Versión del Documento:** X.Y

## Instrucciones

Marcar con [X] cada ítem completado. Agregar notas si el ítem no aplica (N/A) o está parcialmente completo.

---

## 1. CONTEXTO DE NEGOCIO

### 1.1 Documentación del Contexto

- [ ] Objetivo de negocio claramente definido
- [ ] Área o dominio del sistema identificada
- [ ] Stakeholders listados con roles e intereses
- [ ] Alcance definido (qué incluye y qué excluye)
- [ ] Restricciones técnicas y de negocio documentadas
- [ ] Supuestos explicitados

**Notas:** _____________________________________________

**Responsable:** [Nombre]
**Estado:** Completo | Parcial | Pendiente

---

## 2. PROCESOS DE NEGOCIO

### 2.1 Identificación de Procesos

- [ ] Al menos 1 proceso principal identificado
- [ ] Proceso tiene ID único (formato: PROC-[ÁREA]-[NNN])
- [ ] Proceso tiene nombre descriptivo

### 2.2 Documentación de Procesos

- [ ] Descripción narrativa del proceso
- [ ] Diagrama de flujo o BPMN (textual o gráfico)
- [ ] Actores del proceso identificados
- [ ] Entradas del proceso definidas
- [ ] Salidas del proceso definidas
- [ ] Reglas de negocio aplicables listadas
- [ ] Métricas del proceso (tiempo, volumen, criticidad)

### 2.3 Subprocesos (si aplica)

- [ ] Subprocesos identificados y documentados
- [ ] Relación con proceso principal clara

**Notas:** _____________________________________________

**Responsable:** [Nombre]
**Estado:** Completo | Parcial | Pendiente

---

## 3. REGLAS DE NEGOCIO

### 3.1 Identificación de Reglas

- [ ] Todas las reglas de negocio identificadas
- [ ] Cada regla tiene ID único (formato: RN-[ÁREA]-[NN])
- [ ] Cada regla tiene nombre descriptivo

### 3.2 Documentación de Reglas

Para cada regla:

- [ ] Tipo clasificado (Hecho, Restricción, Desencadenador, Inferencia, Cálculo)
- [ ] Categoría específica definida
- [ ] Descripción detallada
- [ ] Expresión formal (SI-ENTONCES) cuando aplica
- [ ] Validación descrita
- [ ] Excepciones documentadas (si aplica)
- [ ] Impacto en procesos, UC, requisitos identificado
- [ ] Sanción por violación documentada (si aplica)

### 3.3 Catálogo de Reglas

- [ ] Reglas consolidadas en catálogo central
- [ ] Referencia a documento detallado cuando existe (ej: rn_c01_autenticacion_sesiones.md)

**Notas:** _____________________________________________

**Responsable:** [Nombre]
**Estado:** Completo | Parcial | Pendiente

---

## 4. CASOS DE USO

### 4.1 Identificación de Casos de Uso

- [ ] Todos los casos de uso derivados del proceso identificados
- [ ] Cada UC tiene ID único (formato: UC-[NNN])
- [ ] Nombre del UC en formato: VERBO + OBJETO

### 4.2 Especificación de Casos de Uso

Para cada caso de uso:

- [ ] Actor principal identificado
- [ ] Stakeholders e intereses listados
- [ ] Precondiciones definidas
- [ ] Postcondiciones de éxito definidas
- [ ] Postcondiciones de fallo definidas
- [ ] Disparador identificado (si aplica)

### 4.3 Flujos de Casos de Uso

- [ ] Flujo principal documentado en tabla de dos columnas
- [ ] Pasos numerados secuencialmente
- [ ] Acción del actor y respuesta del sistema claras
- [ ] Flujos alternativos identificados y documentados
- [ ] Flujos de excepción identificados y documentados (si aplica)
- [ ] Referencia al paso del flujo principal en flujos alternativos

### 4.4 Información Adicional

- [ ] Requisitos especiales listados (rendimiento, seguridad, usabilidad)
- [ ] Trazabilidad a proceso, reglas, requisitos documentada

### 4.5 Estándares de Calidad

- [ ] UC sigue formato de tabla estándar del proyecto
- [ ] No contiene emojis (estándar del proyecto)
- [ ] Redacción clara y sin ambigüedades

**Notas:** _____________________________________________

**Responsable:** [Nombre]
**Estado:** Completo | Parcial | Pendiente

---

## 5. REQUISITOS

### 5.1 Requisitos Funcionales

#### 5.1.1 Identificación

- [ ] Todos los RF derivados de casos de uso
- [ ] Cada RF tiene ID único (formato: RF-[NNN])
- [ ] Cada RF tiene título descriptivo

#### 5.1.2 Documentación

Para cada requisito funcional:

- [ ] Prioridad definida (MoSCoW: MUST, SHOULD, COULD, WON'T)
- [ ] Categoría específica asignada
- [ ] Descripción detallada
- [ ] Criterios de aceptación definidos (mínimo 3)
- [ ] Entrada definida (parámetros, tipos)
- [ ] Salida definida (resultado, tipo)
- [ ] Proceso documentado (si aplica)
- [ ] Reglas de negocio aplicables referenciadas
- [ ] Validaciones especificadas
- [ ] Manejo de errores documentado
- [ ] Trazabilidad completa (proceso, UC, prueba)
- [ ] Referencia a documento detallado (si existe)

#### 5.1.3 Cobertura

- [ ] Todos los pasos del UC tienen RF asociado
- [ ] Todos los flujos alternativos cubiertos por RF
- [ ] No hay RF huérfanos (sin vínculo a UC)

### 5.2 Requisitos No Funcionales

#### 5.2.1 Identificación

- [ ] Todos los RNF identificados
- [ ] Cada RNF tiene ID único (formato: RNF-[NNN])
- [ ] Cada RNF tiene título descriptivo

#### 5.2.2 Documentación

Para cada requisito no funcional:

- [ ] Categoría definida (Rendimiento, Seguridad, Usabilidad, Confiabilidad, Mantenibilidad)
- [ ] Descripción detallada
- [ ] Métrica específica y medible
- [ ] Condiciones de medición especificadas
- [ ] Trazabilidad a proceso, UC, RF relacionado

#### 5.2.3 Cobertura

- [ ] Requisitos de rendimiento definidos
- [ ] Requisitos de seguridad definidos (si aplica)
- [ ] Requisitos de disponibilidad definidos (si aplica)

**Notas:** _____________________________________________

**Responsable:** [Nombre]
**Estado:** Completo | Parcial | Pendiente

---

## 6. PROCEDIMIENTOS OPERACIONALES

### 6.1 Identificación

- [ ] Procedimientos operacionales identificados
- [ ] Cada procedimiento tiene ID único (formato: PROC-[NOMBRE]-[NNN])

### 6.2 Documentación

Para cada procedimiento:

- [ ] Objetivo claramente definido
- [ ] Alcance especificado (a quién aplica)
- [ ] Responsable identificado
- [ ] Frecuencia de ejecución definida
- [ ] Pasos detallados en tabla
- [ ] Casos especiales documentados
- [ ] Errores comunes y soluciones listados
- [ ] Validaciones visuales (screenshots/mockups) incluidos si aplica

**Notas:** _____________________________________________

**Responsable:** [Nombre]
**Estado:** Completo | Parcial | Pendiente
**N/A si:** Este componente no requiere procedimientos operacionales

---

## 7. TRAZABILIDAD

### 7.1 Matriz de Trazabilidad

- [ ] Matriz Proceso-UC-Requisito completa
- [ ] Matriz UC-Requisito-Prueba completa
- [ ] Matriz Reglas-Impacto completa

### 7.2 Trazabilidad Bidireccional

#### Upward (hacia arriba):

- [ ] Cada RF está trazado a un UC
- [ ] Cada UC está trazado a un Proceso
- [ ] Cada regla está aplicada en al menos un RF

#### Downward (hacia abajo):

- [ ] Cada Proceso deriva al menos 1 UC
- [ ] Cada UC deriva al menos 1 RF
- [ ] Cada RF tiene al menos 1 caso de prueba (planificado o ejecutado)

### 7.3 Análisis de Gaps

- [ ] No hay requisitos huérfanos
- [ ] No hay casos de uso sin requisitos
- [ ] No hay necesidades sin implementación (o justificación de pendiente)

**Notas:** _____________________________________________

**Responsable:** [Nombre]
**Estado:** Completo | Parcial | Pendiente

---

## 8. PRUEBAS

### 8.1 Plan de Pruebas

- [ ] Objetivo de las pruebas definido
- [ ] Alcance de las pruebas especificado

### 8.2 Casos de Prueba

- [ ] Cada RF MUST tiene al menos 1 caso de prueba
- [ ] Al menos 70% de RF SHOULD tienen caso de prueba
- [ ] Cada caso de prueba tiene ID único (formato: TS-RF-[NNN]-[001])
- [ ] Precondiciones definidas
- [ ] Datos de entrada especificados
- [ ] Pasos documentados
- [ ] Resultado esperado descrito
- [ ] Criterios de éxito claros

### 8.3 Cobertura

- [ ] Cobertura de pruebas >= 90% para requisitos MUST
- [ ] Cobertura de pruebas >= 70% para requisitos SHOULD

**Notas:** _____________________________________________

**Responsable:** [Nombre]
**Estado:** Completo | Parcial | Pendiente

---

## 9. DISEÑO E IMPLEMENTACIÓN

### 9.1 Arquitectura

- [ ] Componentes del sistema identificados
- [ ] Diagrama de arquitectura disponible (si aplica)

### 9.2 Modelo de Datos

- [ ] Entidades de datos identificadas
- [ ] Estructura de tablas definida (si aplica)
- [ ] Relaciones entre entidades documentadas

### 9.3 Implementación

- [ ] Requisitos MUST implementados al 100%
- [ ] Requisitos SHOULD implementados al >= 80%
- [ ] Código revisado (code review)
- [ ] Pruebas unitarias ejecutadas y pasadas

**Notas:** _____________________________________________

**Responsable:** [Nombre]
**Estado:** Completo | Parcial | Pendiente

---

## 10. ESTÁNDARES Y CALIDAD

### 10.1 Conformidad con Estándares

- [ ] ISO/IEC/IEEE 29148:2018 - Ingeniería de requisitos
- [ ] BABOK v3 - Business analysis
- [ ] UML 2.5 - Casos de uso
- [ ] Estándares del proyecto IACT

### 10.2 Nomenclatura

- [ ] Procesos: PROC-[ÁREA]-[NNN]
- [ ] Reglas de Negocio: RN-[ÁREA]-[NN]
- [ ] Casos de Uso: UC-[NNN]
- [ ] Requisitos Funcionales: RF-[NNN]
- [ ] Requisitos No Funcionales: RNF-[NNN]
- [ ] Procedimientos: PROC-[NOMBRE]-[NNN]
- [ ] Casos de Prueba: TS-RF-[NNN]-[001]

### 10.3 Calidad de Documentación

- [ ] Sin emojis (estándar del proyecto)
- [ ] Redacción clara y sin ambigüedades
- [ ] Tablas bien formateadas
- [ ] Referencias cruzadas correctas
- [ ] Sin errores ortográficos graves

**Notas:** _____________________________________________

**Responsable:** [Nombre]
**Estado:** Completo | Parcial | Pendiente

---

## 11. REVISIÓN Y APROBACIÓN

### 11.1 Revisiones

- [ ] Revisión por analista de negocio
- [ ] Revisión por arquitecto de software
- [ ] Revisión por líder técnico
- [ ] Revisión por Product Owner
- [ ] Revisión por QA (casos de prueba)

### 11.2 Aprobaciones

- [ ] Aprobación de analista de negocio
- [ ] Aprobación de arquitecto de software
- [ ] Aprobación de Product Owner

### 11.3 Control de Cambios

- [ ] Tabla de control de versiones presente
- [ ] Cambios recientes documentados

**Notas:** _____________________________________________

**Responsable:** [Nombre]
**Estado:** Completo | Parcial | Pendiente

---

## RESUMEN DE COMPLETITUD

| Sección | Items Totales | Items Completos | % Completitud |
|---------|--------------|----------------|---------------|
| 1. Contexto de Negocio | [N] | [N] | [%] |
| 2. Procesos de Negocio | [N] | [N] | [%] |
| 3. Reglas de Negocio | [N] | [N] | [%] |
| 4. Casos de Uso | [N] | [N] | [%] |
| 5. Requisitos | [N] | [N] | [%] |
| 6. Procedimientos | [N] | [N] | [%] |
| 7. Trazabilidad | [N] | [N] | [%] |
| 8. Pruebas | [N] | [N] | [%] |
| 9. Diseño/Implementación | [N] | [N] | [%] |
| 10. Estándares | [N] | [N] | [%] |
| 11. Revisión/Aprobación | [N] | [N] | [%] |
| **TOTAL** | [N] | [N] | [%] |

**Meta de Completitud:** >= 95%
**Completitud Actual:** [%]

**Estado General:** COMPLETO | CASI COMPLETO | INCOMPLETO

**Acciones Pendientes:**
1. [Acción 1]
2. [Acción 2]
3. [Acción 3]

**Fecha Objetivo de Completitud:** YYYY-MM-DD

---

**Revisado por:** [Nombre]
**Fecha:** YYYY-MM-DD
**Firma:** ________________

---

**Fin de Checklist de Completitud**
```

---

## Plantilla 4: Especificación Rápida de Regla de Negocio

### Propósito

Plantilla simplificada para documentar rápidamente una regla de negocio individual.

### Estructura de la Plantilla

```markdown
# Regla de Negocio: [NOMBRE DE LA REGLA]

**ID:** RN-[ÁREA]-[NN]
**Versión:** X.Y
**Fecha:** YYYY-MM-DD
**Autor:** [Nombre]
**Estado:** Borrador | Revisión | Aprobado

---

## Clasificación

**Tipo:** Hecho | Restricción | Desencadenador | Inferencia | Cálculo
**Categoría:** [Categoría específica]
**Criticidad:** Alta | Media | Baja

---

## Descripción

[Descripción en lenguaje natural de la regla de negocio]

---

## Expresión Formal

```
SI [condición]
ENTONCES [acción/resultado]
SI NO [acción alternativa]
```

**Ejemplo:**

```
SI edad_usuario >= 18
ENTONCES permitir_registro()
SI NO rechazar_con_mensaje("Debes tener al menos 18 años")
```

---

## Origen

**Fuente:** [De dónde proviene la regla]
- [ ] Regulación legal/normativa
- [ ] Política de la empresa
- [ ] Lógica de negocio
- [ ] Restricción técnica

**Referencia:** [Número de ley, política, documento, etc.]

---

## Validación

**¿Cómo se valida esta regla?**

[Descripción de cómo el sistema valida que la regla se cumple]

**Momento de Validación:**
- [ ] En tiempo de entrada de datos (frontend)
- [ ] En tiempo de procesamiento (backend)
- [ ] En tiempo de persistencia (base de datos)
- [ ] Post-procesamiento (auditoría)

---

## Excepciones

**¿Existen casos en los que esta regla NO aplica?**

- Excepción 1: [Descripción]
- Excepción 2: [Descripción]

---

## Impacto

**Procesos Afectados:**
- PROC-[XXX]: [Nombre del proceso]

**Casos de Uso Afectados:**
- UC-[XXX]: [Nombre del UC] (paso [N])

**Requisitos Derivados:**
- RF-[XXX]: [Nombre del requisito]

---

## Sanción

**¿Qué ocurre si se viola esta regla?**

[Descripción de la consecuencia: rechazo, alerta, bloqueo, etc.]

**Mensaje al Usuario:**
"[Mensaje que se muestra al usuario cuando se viola la regla]"

---

## Pruebas

**Casos de Prueba:**
- TS-RN-[XX]-001: Validar cumplimiento de la regla
- TS-RN-[XX]-002: Validar detección de violación

---

## Referencias

- Documento detallado: [Ruta al documento]
- Regulación: [Enlace o referencia]
- Decisión de negocio: [Jira ticket, email, acta de reunión]

---

## Historial de Cambios

| Versión | Fecha | Autor | Cambio |
|---------|-------|-------|--------|
| 1.0 | [Fecha] | [Autor] | Creación inicial |

---

**Aprobado por:** [Nombre del aprobador]
**Fecha de Aprobación:** YYYY-MM-DD

---

**Fin de Plantilla de Regla de Negocio**
```

---

## Guía de Uso de las Plantillas

### 1. Cuándo Usar Cada Plantilla

| Plantilla | Cuándo Usarla |
|-----------|---------------|
| **Documento Maestro de Análisis** | Al iniciar el análisis de un componente o funcionalidad nueva. Integra todos los artefactos en un solo documento. |
| **Matriz de Trazabilidad (RTM)** | Para validar completitud y trazabilidad de requisitos. Útil en revisiones y auditorías. |
| **Checklist de Completitud** | Al finalizar el análisis, antes de enviar a revisión. Garantiza que no se omitió ningún artefacto. |
| **Regla de Negocio Individual** | Cuando se identifica una regla nueva que debe documentarse rápidamente. |

### 2. Workflow Recomendado

```
1. INICIAR ANÁLISIS
   - Usar Plantilla 1 (Documento Maestro)
   - Completar Sección 1: Contexto

2. IDENTIFICAR PROCESOS Y REGLAS
   - Completar Sección 2 (Procesos)
   - Completar Sección 3 (Reglas)
   - Para cada regla compleja, crear documento individual con Plantilla 4

3. DERIVAR CASOS DE USO
   - Completar Sección 4 (Casos de Uso)

4. ESPECIFICAR REQUISITOS
   - Completar Sección 5 (Requisitos)

5. DOCUMENTAR PROCEDIMIENTOS
   - Completar Sección 6 (Procedimientos)

6. VALIDAR TRAZABILIDAD
   - Completar Sección 7 (Matriz de Trazabilidad)
   - Crear Plantilla 2 (RTM) para análisis detallado

7. DEFINIR PRUEBAS
   - Completar Sección 8 (Pruebas)

8. VALIDAR COMPLETITUD
   - Ejecutar Plantilla 3 (Checklist)
   - Resolver items pendientes

9. ENVIAR A REVISIÓN
   - Completar Sección 11 (Aprobaciones)

10. IMPLEMENTAR
    - Completar Sección 9 (Diseño/Implementación)
    - Actualizar RTM con estado de implementación
```

### 3. Integración con Directorio plantillas/

El proyecto IACT tiene un directorio `docs/plantillas/` con plantillas existentes. Este documento complementa esas plantillas con:

- **Integración de artefactos:** Las plantillas aquí unen procesos, UC, requisitos, y procedimientos en un flujo coherente
- **Trazabilidad:** Las matrices RTM garantizan trazabilidad bidireccional
- **Validación:** El checklist valida completitud antes de implementar

**Relación con plantillas existentes:**

```
docs/plantillas/
├── [plantillas existentes del proyecto]
│
docs/gobernanza/marco_integrado/
├── 06_plantillas_integradas_iact.md (ESTE DOCUMENTO)
    ├── Plantilla 1: Documento Maestro (integra todo)
    ├── Plantilla 2: RTM (trazabilidad)
    ├── Plantilla 3: Checklist (validación)
    └── Plantilla 4: Regla Individual (documentación rápida)
```

### 4. Consejos de Uso

#### Para Analistas de Negocio:

- **Comenzar siempre con el contexto:** Sección 1 del Documento Maestro
- **Documentar reglas ANTES de casos de uso:** Las reglas influyen en los UC
- **Validar con stakeholders temprano:** No esperar a tener todo completo

#### Para Desarrolladores:

- **Revisar trazabilidad:** Usar RTM para entender de dónde viene cada requisito
- **Consultar procedimientos:** Entender el flujo de usuario antes de implementar
- **Actualizar estado de implementación:** Mantener RTM actualizado

#### Para QA:

- **Derivar casos de prueba de criterios de aceptación:** Cada criterio es un caso de prueba potencial
- **Validar cobertura con RTM:** Usar Plantilla 2 para identificar gaps
- **Ejecutar checklist antes de release:** Garantizar que nada quedó sin probar

#### Para Product Owners:

- **Usar RTM para priorización:** Ver qué requisitos tienen más impacto
- **Validar completitud con checklist:** Antes de aceptar un análisis como completo
- **Revisar trazabilidad de necesidades:** Garantizar que necesidades de negocio están cubiertas

---

## Ejemplos de Uso

### Ejemplo 1: Análisis de Nueva Funcionalidad "Recuperación de Contraseña"

**Paso 1:** Crear documento usando Plantilla 1

```markdown
# Análisis Integrado: Recuperación de Contraseña

ID: AI-004
Área: Seguridad

## 1. Contexto
Objetivo: Permitir a usuarios recuperar acceso a su cuenta cuando olvidan contraseña

Stakeholders:
- Usuarios: Requieren proceso simple y seguro
- Admin de Seguridad: Requiere trazabilidad

...
```

**Paso 2:** Identificar reglas de negocio

```markdown
RN-SEC-10: Token de Recuperación Expirable
Tipo: Restricción
Descripción: Token de recuperación debe expirar en 1 hora
```

**Paso 3:** Derivar casos de uso

```markdown
UC-015: Solicitar Recuperación de Contraseña
UC-016: Establecer Nueva Contraseña con Token
```

**Paso 4:** Crear RTM usando Plantilla 2 para validar trazabilidad

**Paso 5:** Ejecutar Checklist (Plantilla 3) antes de enviar a revisión

### Ejemplo 2: Auditoría de Requisitos Existentes

**Paso 1:** Crear RTM (Plantilla 2) con todos los requisitos actuales

**Paso 2:** Identificar requisitos huérfanos (sin UC asociado)

**Paso 3:** Identificar UC sin requisitos (derivar requisitos faltantes)

**Paso 4:** Validar cobertura de pruebas

**Paso 5:** Generar reporte de gaps y acciones correctivas

---

## Integración con Herramientas

### Jira / Azure DevOps

- **Requisitos:** Crear User Stories con ID del requisito (RF-XXX)
- **Trazabilidad:** Usar "Linked Issues" para vincular US → UC → Necesidad
- **Pruebas:** Crear Test Cases vinculados a User Stories

### Confluence / Wiki

- **Publicar Documento Maestro:** Crear página por componente
- **Matrices RTM:** Crear tablas dinámicas que se actualicen automáticamente
- **Checklist:** Crear template de página con checklist incorporado

### Git

- **Commit Messages:** Incluir IDs de requisitos en commits
  ```
  feat(auth): implementar validación de token (RF-006)
  ```
- **Pull Requests:** Referenciar casos de uso y requisitos en descripción
- **Issues:** Vincular issues de GitHub a requisitos

---

## Métricas de Calidad del Análisis

### Índice de Completitud del Análisis

```
Completitud = (Artefactos completos / Artefactos obligatorios) * 100

Artefactos Obligatorios:
- Contexto
- Al menos 1 Proceso
- Al menos 1 Regla de Negocio
- Al menos 1 Caso de Uso
- Al menos 1 Requisito Funcional
- Matriz de Trazabilidad

Meta: >= 95%
```

### Índice de Trazabilidad

```
Trazabilidad = (Requisitos con trazabilidad completa / Total requisitos) * 100

Trazabilidad Completa:
- Upward: Requisito → UC → Proceso
- Downward: Requisito → Prueba → Implementación

Meta: >= 95%
```

### Índice de Cobertura de Pruebas

```
Cobertura Pruebas = (Requisitos con prueba / Total requisitos) * 100

Meta: >= 90% (MUST), >= 70% (SHOULD)
```

---

## Apéndice: Referencias Cruzadas

### Documentos del Marco Integrado

1. `00_resumen_ejecutivo_mejores_practicas.md` - Resumen ejecutivo
2. `01_marco_conceptual_iact.md` - Fundamentos teóricos
3. `02_relaciones_fundamentales_iact.md` - Patrones de transformación
4. `03_matrices_trazabilidad_iact.md` - Ejemplos de matrices RTM
5. `04_metodologia_analisis_iact.md` - Metodología de 4 fases
6. `05a_casos_practicos_iact.md` - Casos reales del proyecto
7. `05b_caso_didactico_generico.md` - Caso pedagógico genérico
8. `06_plantillas_integradas_iact.md` - Este documento

### Estándares y Guías del Proyecto

- `docs/gobernanza/casos_de_uso_guide.md` - Guía de casos de uso
- `docs/gobernanza/procesos/procedimiento_trazabilidad_requisitos.md` - Procedimiento de trazabilidad
- `docs/solicitudes/sc00/sc00_documents/guia_documentacion_integrada.md` - Guía de documentación

### Ejemplos Reales

- `docs/implementacion/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md` - 14 reglas de autenticación
- `docs/implementacion/backend/requisitos/funcionales/rf001_evaluacion_permisos_tres_niveles.md` - Requisito funcional completo

---

## Conclusión

Este documento proporciona 4 plantillas reutilizables para aplicar el marco integrado de análisis de negocio en el proyecto IACT:

1. **Documento Maestro** - Integración completa de todos los artefactos
2. **Matriz RTM** - Trazabilidad y validación de completitud
3. **Checklist** - Validación de calidad antes de revisión
4. **Regla Individual** - Documentación rápida de reglas de negocio

**Beneficios de usar estas plantillas:**

- Estandarización de documentación
- Trazabilidad bidireccional garantizada
- Validación de completitud sistemática
- Reducción de tiempo de análisis
- Mejor comunicación entre roles (BA, Dev, QA, PO)
- Conformidad con ISO 29148:2018 y BABOK v3

**Próximos Pasos:**

1. Aplicar plantillas en próximo análisis de componente nuevo
2. Adaptar plantillas según necesidades específicas del equipo
3. Integrar plantillas con herramientas de gestión (Jira, Confluence, etc.)
4. Capacitar al equipo en el uso de las plantillas

---

**Fin del Documento de Plantillas Integradas**
