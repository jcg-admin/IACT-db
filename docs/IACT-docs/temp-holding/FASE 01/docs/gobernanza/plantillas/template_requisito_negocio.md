---
# Metadatos del documento
id: TEMPLATE-REQ-NEGOCIO
tipo: plantilla
titulo: Plantilla de Requisito de Negocio
version: 1.0.0
fecha_creacion: 2025-11-03
ultima_actualizacion: 2025-11-03
estado: activo
propietario: equipo-ba
estandares: ["ISO/IEC/IEEE 29148:2018 - Clause 9.3", "BABOK v3"]
---

# Template: Requisito de Negocio (Business Requirement)

> **Instrucciones:** Este template debe usarse para documentar requisitos de negocio según ISO 29148 Clause 9.3.
> Los requisitos de negocio describen objetivos, metas y resultados de alto nivel que el negocio debe lograr.
> Derivan de necesidades de negocio y se descomponen en requisitos de stakeholders y requisitos de solución.
> Reemplace los campos entre `[CORCHETES]` con información específica.

---

## Metadatos del Requisito

```yaml
---
id: RN-[XXX]
tipo: negocio
titulo: [Título del requisito de negocio]
dominio: [backend|frontend|infrastructure|cross-domain]
owner: [equipo-ba|equipo-producto]
prioridad: [critica|alta|media|baja]
estado: [propuesto|en_analisis|aprobado|en_implementacion|implementado|verificado|archivado]
fecha_creacion: [YYYY-MM-DD]
fecha_aprobacion: [YYYY-MM-DD]
sponsor: [nombre-sponsor-ejecutivo]

# Trazabilidad Upward
trazabilidad_upward:
  - N-[XXX]  # Necesidad de negocio que origina este requisito
  - OE-[XXX] # Objetivo estratégico (si aplica)

# Trazabilidad Downward
trazabilidad_downward:
  - RS-[XXX]  # Requisitos de stakeholders derivados
  - RF-[XXX]  # Requisitos funcionales derivados
  - RNF-[XXX] # Requisitos no funcionales derivados

# Stakeholders
stakeholders:
  - [stakeholder-ejecutivo-1]
  - [stakeholder-gerencial-2]
  - [stakeholder-operacional-3]

# Alineación estratégica
objetivo_estrategico: [OE-XXX - Descripción]
kpi_negocio: [KPI principal que este requisito impacta]

# Conformidad ISO 29148
iso29148_clause: "9.3"  # Business Requirements Specification
babok_knowledge_area: "Requirements Analysis and Design Definition"
verificacion_metodo: [inspection|analysis|demonstration]

# Impacto en el negocio
impacto_financiero: [alto|medio|bajo]
impacto_operacional: [alto|medio|bajo]
urgencia: [critica|alta|media|baja]
---
```

---

## 1. Descripción del Requisito de Negocio

### 1.1 Declaración del Requisito

**El negocio NECESITA** [capacidad o resultado de negocio específico].

> **Formato ISO 29148 para Business Requirements:**
> - Enfocarse en QUÉ debe lograr el negocio (no CÓMO lograrlo)
> - Usar lenguaje de negocio (no técnico)
> - Ser medible y verificable

**Ejemplo correcto:**
> "El negocio **NECESITA** reducir las roturas de stock en un 40% durante el próximo año fiscal para minimizar pérdidas de ventas y mejorar la satisfacción del cliente."

### 1.2 Contexto de Negocio

**Situación actual:**
[Describa el contexto de negocio actual que motiva este requisito]

**Problema u oportunidad:**
[Explique el problema de negocio o la oportunidad identificada]

**Justificación:**
[Por qué este requisito es importante para el negocio]

---

## 2. Objetivos de Negocio

### 2.1 Objetivo Principal

**[Describa el objetivo principal que este requisito busca alcanzar]**

- **Métrica de éxito**: [Cómo se medirá el éxito]
- **Target cuantitativo**: [Valor objetivo específico]
- **Plazo**: [Timeline para alcanzar el objetivo]

### 2.2 Objetivos Secundarios

1. **Objetivo secundario 1**: [descripción]
   - Métrica: [métrica]
   - Target: [valor]

2. **Objetivo secundario 2**: [descripción]
   - Métrica: [métrica]
   - Target: [valor]

---

## 3. Alcance de Negocio

### 3.1 Áreas de Negocio Impactadas

| Área de Negocio | Tipo de Impacto | Nivel de Cambio | Stakeholder Responsable |
|-----------------|-----------------|-----------------|-------------------------|
| [Área 1] | [Procesos|Personas|Tecnología|Datos] | [Alto|Medio|Bajo] | [Nombre/Rol] |
| [Área 2] | [Procesos|Personas|Tecnología|Datos] | [Alto|Medio|Bajo] | [Nombre/Rol] |

### 3.2 Procesos de Negocio Afectados

- [ ] **Proceso 1**: [Nombre del proceso]
  - Cambio: [Descripción del cambio esperado]
  - Documentación actual: [Link a documentación del proceso actual]

- [ ] **Proceso 2**: [Nombre del proceso]
  - Cambio: [Descripción del cambio esperado]

### 3.3 Limitaciones de Alcance

**En alcance:**
- [Elemento de alcance 1]
- [Elemento de alcance 2]

**Fuera de alcance:**
- [Elemento fuera de alcance 1]
- [Elemento fuera de alcance 2]

---

## 4. Beneficios Esperados

### 4.1 Beneficios Cuantificables

| Categoría | Beneficio | Baseline Actual | Target | Timeline | ROI Estimado |
|-----------|-----------|-----------------|--------|----------|--------------|
| **Financiero** | [Descripción] | [$X] | [$Y] | [Q1/Q2/Q3/Q4] | [%] |
| **Operacional** | [Descripción] | [X unidades] | [Y unidades] | [Q1/Q2/Q3/Q4] | [% mejora] |
| **Cliente** | [Descripción] | [X%] | [Y%] | [Q1/Q2/Q3/Q4] | [NPS/CSAT] |

### 4.2 Beneficios Intangibles

- **Mejora en la satisfacción del cliente**: [Descripción]
- **Mejora en la moral de empleados**: [Descripción]
- **Mejor posicionamiento competitivo**: [Descripción]
- **Cumplimiento regulatorio**: [Descripción]

---

## 5. Métricas y KPIs

### 5.1 Key Performance Indicators (KPIs)

| KPI | Definición | Fórmula de Cálculo | Baseline | Target | Frecuencia de Medición |
|-----|------------|-------------------|----------|--------|------------------------|
| [KPI-1] | [Definición clara] | [Fórmula] | [Valor actual] | [Valor objetivo] | [Diaria|Semanal|Mensual] |
| [KPI-2] | [Definición clara] | [Fórmula] | [Valor actual] | [Valor objetivo] | [Diaria|Semanal|Mensual] |

### 5.2 Métricas de Seguimiento

| Métrica | Propósito | Responsable | Herramienta/Sistema |
|---------|-----------|-------------|---------------------|
| [Métrica 1] | [Para qué se usa] | [Quién la monitorea] | [Dónde se visualiza] |
| [Métrica 2] | [Para qué se usa] | [Quién la monitorea] | [Dónde se visualiza] |

---

## 6. Criterios de Éxito del Negocio

### 6.1 Criterios de Aceptación del Negocio

El requisito se considerará exitoso cuando:

1. OK **[Criterio 1]**: [Descripción específica y medible]
   - Método de verificación: [Cómo se verificará]
   - Responsable de verificación: [Rol/Persona]

2. OK **[Criterio 2]**: [Descripción específica y medible]
   - Método de verificación: [Cómo se verificará]
   - Responsable de verificación: [Rol/Persona]

3. OK **[Criterio 3]**: [Descripción específica y medible]
   - Método de verificación: [Cómo se verificará]
   - Responsable de verificación: [Rol/Persona]

### 6.2 Umbrales Críticos

| Umbral | Valor Mínimo Aceptable | Valor Objetivo | Valor Aspiracional |
|--------|------------------------|----------------|-------------------|
| [Umbral 1] | [Mínimo] | [Target] | [Stretch goal] |
| [Umbral 2] | [Mínimo] | [Target] | [Stretch goal] |

---

## 7. Stakeholders y Roles

### 7.1 Matriz de Stakeholders

| Stakeholder | Rol/Posición | Interés | Influencia | Expectativas | Necesidades |
|-------------|--------------|---------|------------|--------------|-------------|
| [Nombre/Rol 1] | [Posición] | [Alto|Medio|Bajo] | [Alta|Media|Baja] | [Lista expectativas] | [Lista necesidades] |
| [Nombre/Rol 2] | [Posición] | [Alto|Medio|Bajo] | [Alta|Media|Baja] | [Lista expectativas] | [Lista necesidades] |

### 7.2 RACI del Requisito

| Actividad | Responsable (R) | Accountable (A) | Consultado (C) | Informado (I) |
|-----------|-----------------|-----------------|----------------|---------------|
| Definición del requisito | [BA Lead] | [Sponsor] | [Stakeholders] | [Equipos técnicos] |
| Aprobación del requisito | [Sponsor] | [Executive] | [Finance, Legal] | [Todos] |
| Implementación | [Tech Lead] | [PMO] | [BA, Arquitecto] | [Stakeholders] |
| Verificación | [QA Lead] | [Product Owner] | [BA, Stakeholders] | [Todos] |

---

## 8. Restricciones y Supuestos

### 8.1 Restricciones de Negocio

| ID | Restricción | Tipo | Impacto | Mitigation |
|----|-------------|------|---------|------------|
| C-01 | [Descripción restricción] | [Presupuesto|Tiempo|Recursos|Regulatorio] | [Alto|Medio|Bajo] | [Cómo manejarla] |
| C-02 | [Descripción restricción] | [Presupuesto|Tiempo|Recursos|Regulatorio] | [Alto|Medio|Bajo] | [Cómo manejarla] |

### 8.2 Supuestos de Negocio

| ID | Supuesto | Validación | Riesgo si es Falso |
|----|----------|------------|--------------------|
| A-01 | [Descripción supuesto] | [Cómo se validará] | [Impacto si no se cumple] |
| A-02 | [Descripción supuesto] | [Cómo se validará] | [Impacto si no se cumple] |

---

## 9. Derivación a Requisitos de Nivel Inferior

### 9.1 Requisitos de Stakeholders Derivados

Este requisito de negocio se descompone en los siguientes requisitos de stakeholders:

- [ ] **RS-[XXX]**: [Título requisito stakeholder 1]
  - Stakeholder afectado: [rol/nombre]
  - Link: [../stakeholders/rsXXX_[nombre].md]

- [ ] **RS-[YYY]**: [Título requisito stakeholder 2]
  - Stakeholder afectado: [rol/nombre]
  - Link: [../stakeholders/rsYYY_[nombre].md]

### 9.2 Requisitos Funcionales Derivados

- [ ] **RF-[XXX]**: [Título requisito funcional 1] -> [Dominio: backend]
- [ ] **RF-[YYY]**: [Título requisito funcional 2] -> [Dominio: frontend]

### 9.3 Requisitos No Funcionales Derivados

- [ ] **RNF-[XXX]**: [Título requisito no funcional 1] -> [Performance]
- [ ] **RNF-[YYY]**: [Título requisito no funcional 2] -> [Security]

---

## 10. Análisis de Impacto

### 10.1 Análisis Financiero

| Concepto | Año 1 | Año 2 | Año 3 | Total 3 años |
|----------|-------|-------|-------|--------------|
| **Costos** |
| Desarrollo | $[X] | $[Y] | $[Z] | $[Total] |
| Infraestructura | $[X] | $[Y] | $[Z] | $[Total] |
| Operación y mantenimiento | $[X] | $[Y] | $[Z] | $[Total] |
| Capacitación | $[X] | $[Y] | $[Z] | $[Total] |
| **Total Costos** | **$[X]** | **$[Y]** | **$[Z]** | **$[Total]** |
| **Beneficios** |
| Reducción de costos | $[X] | $[Y] | $[Z] | $[Total] |
| Incremento de ingresos | $[X] | $[Y] | $[Z] | $[Total] |
| Otros beneficios | $[X] | $[Y] | $[Z] | $[Total] |
| **Total Beneficios** | **$[X]** | **$[Y]** | **$[Z]** | **$[Total]** |
| **Beneficio Neto** | **$[X]** | **$[Y]** | **$[Z]** | **$[Total]** |
| **ROI Acumulado** | [X%] | [Y%] | [Z%] | **[Total%]** |
| **Payback Period** | | | | **[X meses]** |

### 10.2 Análisis de Riesgos de Negocio

| ID | Riesgo | Probabilidad | Impacto | Exposición | Estrategia | Owner |
|----|--------|--------------|---------|------------|------------|-------|
| R-01 | [Descripción] | [Alta|Media|Baja] | [Alto|Medio|Bajo] | [Valor] | [Evitar|Mitigar|Transferir|Aceptar] | [Responsable] |
| R-02 | [Descripción] | [Alta|Media|Baja] | [Alto|Medio|Bajo] | [Valor] | [Evitar|Mitigar|Transferir|Aceptar] | [Responsable] |

---

## 11. Cambio Organizacional

### 11.1 Gestión del Cambio

**Nivel de cambio organizacional**: [Transformacional|Alto|Medio|Bajo]

**Áreas de impacto:**

| Dimensión | Impacto | Descripción | Plan de Gestión |
|-----------|---------|-------------|-----------------|
| **Procesos** | [Alto|Medio|Bajo] | [Cambios en procesos] | [Estrategia de adopción] |
| **Personas** | [Alto|Medio|Bajo] | [Cambios en roles/responsabilidades] | [Plan de capacitación] |
| **Tecnología** | [Alto|Medio|Bajo] | [Nuevas tecnologías/sistemas] | [Plan de migración] |
| **Cultura** | [Alto|Medio|Bajo] | [Cambios en formas de trabajo] | [Plan de comunicación] |

### 11.2 Plan de Capacitación

- [ ] **Grupo 1**: [Rol/Área]
  - Capacitación requerida: [Descripción]
  - Duración: [Horas/Días]
  - Fecha objetivo: [YYYY-MM-DD]

- [ ] **Grupo 2**: [Rol/Área]
  - Capacitación requerida: [Descripción]
  - Duración: [Horas/Días]
  - Fecha objetivo: [YYYY-MM-DD]

---

## 12. Trazabilidad

### 12.1 Trazabilidad Upward (Origen)

Este requisito de negocio deriva de:

| Tipo | ID | Título | Justificación |
|------|----|----|---------------|
| Necesidad | [N-XXX](../necesidades/nXXX_[nombre].md) | [Título] | [Cómo RN satisface la necesidad] |
| Objetivo Estratégico | [OE-XXX] | [Título] | [Alineación estratégica] |

### 12.2 Trazabilidad Downward (Derivados)

Este requisito genera:

**Requisitos de Stakeholders:**
- [RS-XXX](../stakeholders/rsXXX_[nombre].md) - [Título]
- [RS-YYY](../stakeholders/rsYYY_[nombre].md) - [Título]

**Requisitos de Solución:**
- [RF-XXX](../funcionales/rfXXX_[nombre].md) - [Título]
- [RNF-XXX](../no_funcionales/rnfXXX_[nombre].md) - [Título]

**Proyectos/Iniciativas:**
- [PROJ-XXX] - [Nombre del proyecto]

---

## 13. Verificación y Validación

### 13.1 Método de Verificación

**Método**: [Inspection|Analysis|Demonstration]

**Criterios de verificación:**
- [ ] Requisito está correctamente derivado de necesidad de negocio
- [ ] Requisito es medible y tiene KPIs asociados
- [ ] Stakeholders han sido identificados y consultados
- [ ] Beneficios están cuantificados
- [ ] Riesgos han sido identificados y mitigados

### 13.2 Plan de Validación con el Negocio

| Hito | Actividad de Validación | Stakeholders Involucrados | Fecha Objetivo | Estado |
|------|-------------------------|---------------------------|----------------|--------|
| [Hito 1] | [Descripción validación] | [Lista stakeholders] | [YYYY-MM-DD] | [ ] |
| [Hito 2] | [Descripción validación] | [Lista stakeholders] | [YYYY-MM-DD] | [ ] |

---

## 14. Aprobaciones

| Rol | Nombre | Fecha | Firma/Estado |
|-----|--------|-------|--------------|
| **Sponsor Ejecutivo** | [nombre] | [YYYY-MM-DD] | [ ] Aprobado |
| **Business Owner** | [nombre] | [YYYY-MM-DD] | [ ] Aprobado |
| **PMO** | [nombre] | [YYYY-MM-DD] | [ ] Aprobado |
| **Finance** | [nombre] | [YYYY-MM-DD] | [ ] Revisado |
| **Legal/Compliance** | [nombre] | [YYYY-MM-DD] | [ ] Revisado |
| **BA Lead** | [nombre] | [YYYY-MM-DD] | [ ] Revisado |

---

## 15. Referencias

### 15.1 Documentos Relacionados

- [Business Case](../../vision_y_alcance/business_case_[nombre].md)
- [Strategic Plan](../../vision_y_alcance/strategic_plan.md)
- [Stakeholder Analysis](../../anexos/stakeholder_analysis.md)
- [Process Documentation](../../anexos/proceso_[nombre].md)

### 15.2 Estándares Aplicados

- **ISO/IEC/IEEE 29148:2018**: Clause 9.3 - Business Requirements Specification (BRS)
- **BABOK v3**: Requirements Analysis and Design Definition
- **PMBOK Guide 7th Ed**: Value Delivery Components

---

## Control de Cambios

| Versión | Fecha | Autor | Descripción del Cambio | Impacto | Aprobado Por |
|---------|-------|-------|------------------------|---------|--------------|
| 1.0 | [YYYY-MM-DD] | [autor] | Creación inicial | [Alto|Medio|Bajo] | [aprobador] |
| 1.1 | [YYYY-MM-DD] | [autor] | [descripción cambios] | [Alto|Medio|Bajo] | [aprobador] |

---

**Notas para el Autor:**

1. OK Los requisitos de negocio deben expresarse en términos de RESULTADOS de negocio, no soluciones técnicas
2. OK Debe ser medible con KPIs claros y cuantificables
3. OK Debe estar directamente vinculado a objetivos estratégicos organizacionales
4. OK Los beneficios deben estar cuantificados (financieros, operacionales, estratégicos)
5. OK Debe incluir análisis de impacto organizacional completo
6. OK Requiere aprobación de nivel ejecutivo/sponsor
7. OK Debe derivarse en requisitos de stakeholders y requisitos de solución
8. OK Mantener trazabilidad bidireccional con necesidades y objetivos estratégicos

---

**Fin del Template**
