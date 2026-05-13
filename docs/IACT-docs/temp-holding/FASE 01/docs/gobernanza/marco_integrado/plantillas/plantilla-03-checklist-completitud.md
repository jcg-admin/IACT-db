---
title: Plantilla 3 - Checklist de Completitud del Análisis
date: 2025-11-16
domain: general
status: active
tipo: plantilla
plantilla_numero: 3
---

# Plantilla 3: Checklist de Completitud del Análisis

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

## Referencias

Esta plantilla fue extraída de: [06_plantillas_integradas_iact.md](../06_plantillas_integradas_iact.md)

Para más información sobre el marco integrado de análisis, consulte la documentación completa en el directorio padre.
