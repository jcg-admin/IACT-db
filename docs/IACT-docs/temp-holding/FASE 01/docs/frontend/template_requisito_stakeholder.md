---
# Metadatos del documento
id: TEMPLATE-REQ-STAKEHOLDER
tipo: plantilla
titulo: Plantilla de Requisito de Stakeholder
version: 1.0.0
fecha_creacion: 2025-11-03
ultima_actualizacion: 2025-11-03
estado: activo
propietario: equipo-ba
estandares: ["ISO/IEC/IEEE 29148:2018 - Clause 9.4", "BABOK v3"]
date: 2025-11-13
---

# Template: Requisito de Stakeholder (Stakeholder Requirement)

> **Instrucciones:** Este template debe usarse para documentar requisitos de stakeholders según ISO 29148 Clause 9.4.
> Los requisitos de stakeholders describen las necesidades específicas de usuarios, clientes y otras partes interesadas.
> Se sitúan entre los requisitos de negocio (más abstractos) y los requisitos de sistema/software (más técnicos).
> Reemplace los campos entre `[CORCHETES]` con información específica.

---

## Metadatos del Requisito

```yaml
---
id: RS-[XXX]
tipo: stakeholder
titulo: [Título del requisito desde la perspectiva del stakeholder]
dominio: [backend|frontend|infrastructure|cross-domain]
owner: [equipo-ba|equipo-producto]
prioridad: [critica|alta|media|baja]
estado: [propuesto|en_revision|aprobado|en_desarrollo|implementado|verificado|rechazado]
fecha_creacion: [YYYY-MM-DD]
fecha_aprobacion: [YYYY-MM-DD]

# Stakeholder principal al que sirve este requisito
stakeholder_primario: [rol-o-nombre-stakeholder]
stakeholder_tipo: [usuario_final|cliente|gerente|operador|administrador|auditor|regulador]

# Trazabilidad Upward
trazabilidad_upward:
  - N-[XXX]  # Necesidad de negocio
  - RN-[XXX] # Requisito de negocio que este RS ayuda a satisfacer

# Trazabilidad Downward
trazabilidad_downward:
  - RF-[XXX]  # Requisitos funcionales que implementan este RS
  - RNF-[XXX] # Requisitos no funcionales derivados
  - UC-[XXX]  # Casos de uso asociados

# Otros stakeholders beneficiados
stakeholders_secundarios:
  - [stakeholder-2]
  - [stakeholder-3]

# Contexto de uso
contexto_uso: [descripción breve del contexto donde aplica]
frecuencia_uso: [diaria|semanal|mensual|esporádica]
criticidad_operacional: [alta|media|baja]

# Conformidad ISO 29148
iso29148_clause: "9.4"  # Stakeholder Requirements Specification
babok_knowledge_area: "Requirements Analysis and Design Definition"
verificacion_metodo: [demonstration|test|inspection|analysis]

# Experiencia de usuario
categoria_ux: [usabilidad|accesibilidad|performance|satisfaccion]
impacto_experiencia: [alto|medio|bajo]
---
```

---

## 1. Descripción del Requisito de Stakeholder

### 1.1 Declaración del Requisito

**Como** [rol del stakeholder],
**Necesito** [capacidad o funcionalidad],
**Para** [beneficio o valor que obtiene el stakeholder].

> **User Story Format** (recomendado por BABOK v3 y ampliamente usado):
>
> Ejemplo:
> **Como** gerente de compras,
> **Necesito** recibir alertas automáticas cuando el stock esté bajo el punto de reorden,
> **Para** poder tomar decisiones de reabastecimiento a tiempo y evitar roturas de stock.

### 1.2 Descripción Narrativa

[Proporcione una descripción en prosa del requisito desde la perspectiva del stakeholder. Use lenguaje no técnico que el stakeholder pueda entender y validar.]

**¿Qué necesita el stakeholder?**
[Descripción detallada]

**¿Por qué lo necesita?**
[Justificación desde perspectiva del stakeholder]

**¿Cuándo y dónde lo necesita?**
[Contexto de uso]

---

## 2. Perfil del Stakeholder

### 2.1 Información del Stakeholder

| Atributo | Valor |
|----------|-------|
| **Nombre/Rol** | [Nombre o rol del stakeholder] |
| **Departamento/Área** | [Área organizacional] |
| **Nivel jerárquico** | [Ejecutivo|Gerencial|Operacional|Usuario final] |
| **Experiencia técnica** | [Alta|Media|Baja|Ninguna] |
| **Frecuencia de interacción con sistema** | [Diaria|Semanal|Mensual|Ocasional] |
| **Canales de acceso** | [Desktop|Mobile|Web|API|Otro] |
| **Idioma preferido** | [Español|Inglés|Otro] |
| **Necesidades de accesibilidad** | [Sí/No - Especificar si aplica] |

### 2.2 Contexto de Trabajo del Stakeholder

**Entorno de trabajo:**
[Describa el entorno donde el stakeholder usará la funcionalidad]

**Flujo de trabajo típico:**
1. [Paso 1 del flujo de trabajo diario]
2. [Paso 2]
3. [Paso 3]
4. [Donde encaja este requisito en su flujo]

**Herramientas que usa actualmente:**
- [Herramienta 1]
- [Herramienta 2]
- [Herramienta 3]

**Puntos de dolor actuales:**
- [Dolor/Frustración 1]
- [Dolor/Frustración 2]
- [Dolor/Frustración 3]

---

## 3. Criterios de Aceptación del Stakeholder

### 3.1 Criterios en Formato Gherkin

> Los criterios deben reflejar la perspectiva del stakeholder, no detalles técnicos de implementación.

#### Escenario 1: [Nombre del escenario - Caso principal]

```gherkin
Given [el stakeholder está en cierta situación/contexto]
  And [condición adicional del contexto]
When [el stakeholder realiza una acción]
  And [acción adicional si aplica]
Then [el stakeholder observa cierto resultado]
  And [resultado adicional que el stakeholder valida]
```

**Ejemplo:**
```gherkin
Given soy un gerente de compras autenticado en el sistema
  And existen productos con stock por debajo del punto de reorden
When accedo al dashboard de alertas
Then veo una lista priorizada de productos que requieren reabastecimiento
  And cada alerta muestra: nombre del producto, stock actual, punto de reorden, proveedor sugerido
  And puedo filtrar las alertas por categoría de producto
  And puedo marcar alertas como "en proceso" o "resueltas"
```

#### Escenario 2: [Nombre del escenario - Caso alternativo]

```gherkin
Given [contexto alternativo]
When [acción del stakeholder]
Then [resultado alternativo esperado]
```

#### Escenario 3: [Nombre del escenario - Manejo de situaciones excepcionales]

```gherkin
Given [contexto de excepción]
When [acción que causa excepción]
Then [el sistema comunica claramente al stakeholder]
  And [el stakeholder puede recuperarse o tomar acción alternativa]
```

### 3.2 Criterios de Satisfacción del Stakeholder

El stakeholder considerará este requisito satisfactorio cuando:

- [ ] **Criterio 1**: [Criterio específico desde perspectiva del stakeholder]
- [ ] **Criterio 2**: [Debe ser observable/validable por el stakeholder]
- [ ] **Criterio 3**: [No debe contener detalles técnicos de implementación]

---

## 4. Valor para el Stakeholder

### 4.1 Beneficios Directos

| Beneficio | Descripción | Impacto | Medición |
|-----------|-------------|---------|----------|
| [Beneficio 1] | [Cómo mejora el trabajo del stakeholder] | [Alto|Medio|Bajo] | [Cómo el stakeholder percibe la mejora] |
| [Beneficio 2] | [Cómo mejora el trabajo del stakeholder] | [Alto|Medio|Bajo] | [Cómo el stakeholder percibe la mejora] |

### 4.2 Impacto en el Trabajo del Stakeholder

**Antes (sin este requisito):**
- Tiempo invertido: [X horas/día en tarea manual]
- Errores: [Tasa de error actual]
- Frustración: [Descripción de puntos de dolor]

**Después (con este requisito):**
- Tiempo invertido: [Y horas/día - reducción de X-Y]
- Errores: [Reducción esperada]
- Satisfacción: [Mejoras en experiencia de trabajo]

### 4.3 Costo de NO tener este Requisito

**Para el stakeholder:**
- [Impacto 1: tiempo perdido, errores, frustración]
- [Impacto 2]

**Para el negocio:**
- [Impacto financiero]
- [Impacto operacional]

---

## 5. Escenarios de Uso

### 5.1 Escenario Principal de Uso

**Título:** [Nombre del escenario típico de uso]

**Actor:** [Nombre/Rol del stakeholder]

**Precondiciones:**
- [Precondición 1]
- [Precondición 2]

**Flujo Principal:**
1. [Stakeholder realiza acción 1]
2. [Sistema responde con comportamiento 1]
3. [Stakeholder realiza acción 2]
4. [Sistema responde con comportamiento 2]
5. [Resultado final]

**Postcondiciones:**
- [Estado final del sistema]
- [Resultado observable por stakeholder]

**Frecuencia de uso:** [X veces por día/semana/mes]

### 5.2 Escenarios Alternativos

#### Escenario Alternativo A: [Nombre]

**Descripción:** [Variación del escenario principal]

**Diferencias con escenario principal:**
- [Diferencia 1]
- [Diferencia 2]

### 5.3 Escenarios de Excepción

#### Excepción 1: [Nombre de la situación excepcional]

**Situación:** [Qué puede salir mal]

**Expectativa del stakeholder:** [Cómo el stakeholder espera que el sistema maneje la excepción]

**Recuperación:** [Cómo el stakeholder puede continuar su tarea]

---

## 6. Interacciones con Otros Stakeholders

### 6.1 Colaboración Entre Stakeholders

| Stakeholder Secundario | Rol en este Requisito | Tipo de Interacción |
|------------------------|----------------------|---------------------|
| [Stakeholder 2] | [Su rol/responsabilidad] | [Proporciona datos|Recibe notificaciones|Aprueba|Consulta] |
| [Stakeholder 3] | [Su rol/responsabilidad] | [Proporciona datos|Recibe notificaciones|Aprueba|Consulta] |

### 6.2 Dependencias Entre Stakeholders

[Describa cualquier dependencia entre stakeholders para que este requisito funcione efectivamente]

---

## 7. Requisitos de Experiencia de Usuario (UX)

### 7.1 Usabilidad

- **Facilidad de aprendizaje**: [El stakeholder debe poder usar la funcionalidad en X minutos/horas]
- **Eficiencia de uso**: [El stakeholder debe completar la tarea en Y tiempo]
- **Tasa de error tolerable**: [< Z% de errores del usuario]
- **Satisfacción subjetiva**: [Target en encuesta: X/10]

### 7.2 Accesibilidad

- [ ] Cumple WCAG 2.1 nivel [A|AA|AAA]
- [ ] Soporte para lectores de pantalla (si aplica)
- [ ] Navegación por teclado (si aplica)
- [ ] Contraste de colores adecuado
- [ ] Tamaño de fuente ajustable

### 7.3 Diseño de Interacción

**Elementos de UI requeridos (desde perspectiva del stakeholder):**
- [ ] [Elemento 1: ej. botón claramente visible para X acción]
- [ ] [Elemento 2: ej. mensajes de confirmación antes de acciones críticas]
- [ ] [Elemento 3: ej. indicadores de progreso para operaciones lentas]

**Expectativas de feedback:**
- [El stakeholder espera ver X cuando realiza Y acción]
- [El sistema debe confirmar que Z acción fue exitosa]

---

## 8. Requisitos de Información

### 8.1 Información que el Stakeholder Necesita Ver

| Dato/Información | Propósito | Formato Preferido | Frecuencia de Actualización |
|------------------|-----------|-------------------|----------------------------|
| [Dato 1] | [Para qué lo necesita] | [Tabla|Gráfico|Lista|Otro] | [Tiempo real|Diaria|Semanal] |
| [Dato 2] | [Para qué lo necesita] | [Tabla|Gráfico|Lista|Otro] | [Tiempo real|Diaria|Semanal] |

### 8.2 Información que el Stakeholder Debe Proporcionar

| Dato/Input | Propósito | Formato | Validaciones Requeridas |
|------------|-----------|---------|------------------------|
| [Input 1] | [Para qué se usa] | [Texto|Número|Fecha|Archivo] | [Reglas de validación] |
| [Input 2] | [Para qué se usa] | [Texto|Número|Fecha|Archivo] | [Reglas de validación] |

---

## 9. Restricciones del Stakeholder

### 9.1 Restricciones de Negocio

- [Restricción 1: ej. el stakeholder solo tiene X minutos para completar tarea]
- [Restricción 2: ej. el stakeholder tiene acceso limitado a ciertos datos]
- [Restricción 3]

### 9.2 Restricciones Tecnológicas del Stakeholder

- **Dispositivos usados**: [Desktop|Laptop|Tablet|Smartphone]
- **Navegadores/SO**: [Lista de navegadores/sistemas que usa]
- **Conectividad**: [Siempre online|Ocasionalmente offline|Baja bandwidth]
- **Periféricos**: [Teclado|Mouse|Touch|Lector de códigos|Otro]

### 9.3 Restricciones Operacionales

- **Horario de uso**: [24/7|Horario de oficina|Específico]
- **Ubicación**: [Oficina|Remoto|Móvil|Mixto]
- **Interrupciones**: [Puede ser interrumpido frecuentemente|Requiere concentración]

---

## 10. Derivación a Requisitos de Sistema/Software

### 10.1 Requisitos Funcionales Derivados

Este requisito de stakeholder se implementa mediante:

- [ ] **RF-[XXX]**: [Título requisito funcional]
  - Dominio: [backend|frontend|infrastructure]
  - Link: [../../implementacion/[dominio]/requisitos/funcionales/rfXXX_[nombre].md]
  - Relación: [Cómo RF implementa este RS]

- [ ] **RF-[YYY]**: [Título requisito funcional]
  - Dominio: [backend|frontend|infrastructure]
  - Link: [../../implementacion/[dominio]/requisitos/funcionales/rfYYY_[nombre].md]
  - Relación: [Cómo RF implementa este RS]

### 10.2 Requisitos No Funcionales Derivados

- [ ] **RNF-[XXX]**: [Performance] - [Descripción]
- [ ] **RNF-[YYY]**: [Usabilidad] - [Descripción]
- [ ] **RNF-[ZZZ]**: [Disponibilidad] - [Descripción]

---

## 11. Validación con el Stakeholder

### 11.1 Plan de Validación

| Hito | Actividad de Validación | Método | Stakeholder(s) | Fecha | Estado |
|------|-------------------------|--------|----------------|-------|--------|
| [Hito 1] | [Revisión de requisito] | [Entrevista|Workshop|Demo] | [Nombre/Rol] | [YYYY-MM-DD] | [ ] |
| [Hito 2] | [Validación de prototipo] | [Mockup|Prototype|Pilot] | [Nombre/Rol] | [YYYY-MM-DD] | [ ] |
| [Hito 3] | [Aceptación UAT] | [User Acceptance Test] | [Nombre/Rol] | [YYYY-MM-DD] | [ ] |

### 11.2 Criterios de Validación

El stakeholder confirmará que el requisito está correcto cuando:

- [ ] **Comprensión**: El stakeholder confirma que el requisito refleja su necesidad
- [ ] **Completitud**: No faltan aspectos importantes desde su perspectiva
- [ ] **Viabilidad**: El stakeholder considera que la solución propuesta es práctica
- [ ] **Valor**: El stakeholder confirma que obtendría valor de esta capacidad

### 11.3 Sesiones de Validación Realizadas

| Fecha | Stakeholder(s) Presentes | Método | Resultado | Feedback Clave |
|-------|-------------------------|--------|-----------|----------------|
| [YYYY-MM-DD] | [Nombres] | [Entrevista|Demo|Review] | [Aprobado|Cambios solicitados] | [Comentarios] |

---

## 12. Trazabilidad

### 12.1 Trazabilidad Upward (Origen)

Este requisito de stakeholder deriva de:

| Tipo | ID | Título | Justificación |
|------|----|----|---------------|
| Necesidad | [N-XXX](../necesidades/nXXX_[nombre].md) | [Título] | [Cómo RS aborda la necesidad] |
| Req. Negocio | [RN-XXX](../negocio/rnXXX_[nombre].md) | [Título] | [Cómo RS contribuye a RN] |

### 12.2 Trazabilidad Downward (Implementación)

Este requisito se implementa mediante:

**Requisitos Funcionales:**
- [RF-XXX](../../implementacion/[dominio]/requisitos/funcionales/rfXXX_[nombre].md)
- [RF-YYY](../../implementacion/[dominio]/requisitos/funcionales/rfYYY_[nombre].md)

**Requisitos No Funcionales:**
- [RNF-XXX](../../implementacion/[dominio]/requisitos/no_funcionales/rnfXXX_[nombre].md)

**Casos de Uso:**
- [UC-XXX](../../diseno_detallado/casos_uso/ucXXX_[nombre].md)

**Tests de Aceptación del Usuario (UAT):**
- [UAT-XXX](../../qa/uat/uatXXX_[nombre].md)

### 12.3 Trazabilidad Horizontal (Relacionados)

Otros requisitos de stakeholders relacionados:

- [RS-YYY](./rsYYY_[nombre].md) - [Tipo de relación: complementa|depende|condiciona]

---

## 13. Riesgos desde Perspectiva del Stakeholder

| ID | Riesgo | Probabilidad | Impacto en Stakeholder | Mitigación |
|----|--------|--------------|------------------------|------------|
| R-01 | [El stakeholder podría no adoptar la funcionalidad] | [A|M|B] | [Descripción] | [Estrategia de adopción] |
| R-02 | [Cambio en proceso de trabajo del stakeholder] | [A|M|B] | [Descripción] | [Plan de gestión de cambio] |

---

## 14. Aprobaciones

| Rol | Nombre | Fecha | Firma/Estado |
|-----|--------|-------|--------------|
| **Stakeholder Primario** | [nombre] | [YYYY-MM-DD] | [ ] Aprobado |
| **Product Owner** | [nombre] | [YYYY-MM-DD] | [ ] Aprobado |
| **Business Analyst** | [nombre] | [YYYY-MM-DD] | [ ] Documentado |
| **UX Designer** | [nombre] | [YYYY-MM-DD] | [ ] Revisado |

---

## 15. Referencias

### 15.1 Documentos Relacionados

- [Personas/Profiles](../../anexos/stakeholder_personas.md)
- [Journey Map](../../anexos/journey_map_[proceso].md)
- [Wireframes/Mockups](../../diseno_detallado/ux/wireframes_[pantalla].md)

### 15.2 Estándares Aplicados

- **ISO/IEC/IEEE 29148:2018**: Clause 9.4 - Stakeholder Requirements Specification (StRS)
- **BABOK v3**: Requirements Analysis and Design Definition
- **User Story Mapping**: Jeff Patton methodology

---

## Control de Cambios

| Versión | Fecha | Autor | Descripción del Cambio | Stakeholder Notificado |
|---------|-------|-------|------------------------|------------------------|
| 1.0 | [YYYY-MM-DD] | [autor] | Creación inicial | [Sí|No] |
| 1.1 | [YYYY-MM-DD] | [autor] | [descripción cambios] | [Sí|No] |

---

**Notas para el Autor:**

1. OK Los requisitos de stakeholders deben expresarse en lenguaje del stakeholder (no técnico)
2. OK Cada RS debe tener un stakeholder primario identificado y contactable
3. OK Debe validarse directamente con el stakeholder (entrevistas, demos, UAT)
4. OK El formato User Story ("Como...Necesito...Para...") es altamente recomendado
5. OK Debe ser independiente de la solución técnica (describe necesidad, no implementación)
6. OK Los criterios de aceptación deben ser observables por el stakeholder
7. OK Debe derivarse en requisitos funcionales y no funcionales específicos del sistema
8. OK Mantener trazabilidad hacia arriba (RN) y hacia abajo (RF/RNF)

---

**Fin del Template**
