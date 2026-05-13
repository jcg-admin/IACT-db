---
# Metadatos del documento
id: TEMPLATE-NECESIDAD
tipo: plantilla
titulo: Plantilla de Necesidad de Negocio
version: 1.0.0
fecha_creacion: 2025-11-03
ultima_actualizacion: 2025-11-03
estado: activo
propietario: equipo-ba
estandares: ["BABOK v3", "ISO/IEC/IEEE 29148:2018"]
---

# Template: Necesidad de Negocio (Business Need)

> **Instrucciones:** Este template debe usarse para documentar necesidades de negocio según BABOK v3.
> Las necesidades son problemas u oportunidades que deben abordarse para lograr objetivos organizacionales.
> Reemplace los campos entre `[CORCHETES]` con información específica.

---

## Metadatos del Requisito

```yaml
---
id: N-[XXX]
tipo: necesidad
titulo: [Título descriptivo de la necesidad]
dominio: [backend|frontend|infrastructure]
owner: [equipo-propietario]
prioridad: [alta|media|baja]
estado: [propuesto|en_analisis|aprobado|rechazado|implementado]
fecha_creacion: [YYYY-MM-DD]
fecha_aprobacion: [YYYY-MM-DD]
sponsor: [nombre-stakeholder-sponsor]
stakeholders:
  - [stakeholder-1]
  - [stakeholder-2]
  - [stakeholder-n]
babok_knowledge_area: "Business Analysis Planning and Monitoring"
iso29148_clause: "6.2"
valor_negocio: [alto|medio|bajo]
urgencia: [critica|alta|media|baja]
---
```

---

## 1. Descripción de la Necesidad

### 1.1 Problema u Oportunidad

**[Describa claramente el problema actual o la oportunidad identificada]**

Ejemplo:
> El área de compras experimenta frecuentes roturas de stock que generan pérdida de ventas y afectan la satisfacción del cliente.

### 1.2 Situación Actual (As-Is)

**[Describa el estado actual sin la solución]**

- Proceso actual: [descripción]
- Impacto negativo: [impacto cuantificable]
- Frecuencia del problema: [métrica]

### 1.3 Situación Deseada (To-Be)

**[Describa el estado deseado una vez resuelta la necesidad]**

- Proceso objetivo: [descripción]
- Beneficios esperados: [beneficios cuantificables]
- Criterios de éxito: [métricas]

---

## 2. Justificación de Negocio

### 2.1 Impacto en el Negocio

| Dimensión | Impacto Actual | Impacto Esperado |
|-----------|----------------|-------------------|
| **Financiero** | [pérdidas/costos actuales] | [ahorros/ganancias proyectadas] |
| **Operacional** | [ineficiencias actuales] | [mejoras esperadas] |
| **Cliente** | [insatisfacción actual] | [mejora en satisfacción] |
| **Estratégico** | [desalineación actual] | [alineación esperada] |

### 2.2 Costo de No Hacer Nada

**[Cuantifique el costo de no abordar esta necesidad]**

- Costo anual estimado: $[monto]
- Riesgos asociados: [lista de riesgos]
- Oportunidades perdidas: [descripción]

---

## 3. Alcance

### 3.1 En Alcance

- [ ] [Elemento en alcance 1]
- [ ] [Elemento en alcance 2]
- [ ] [Elemento en alcance n]

### 3.2 Fuera de Alcance

- [ ] [Elemento fuera de alcance 1]
- [ ] [Elemento fuera de alcance 2]
- [ ] [Elemento fuera de alcance n]

### 3.3 Supuestos

1. [Supuesto 1]
2. [Supuesto 2]
3. [Supuesto n]

### 3.4 Restricciones

1. [Restricción 1: presupuesto, tiempo, recursos, tecnología]
2. [Restricción 2]
3. [Restricción n]

---

## 4. Stakeholders Afectados

| Stakeholder | Rol | Interés | Impacto | Influencia |
|-------------|-----|---------|---------|------------|
| [Nombre/Rol 1] | [rol en proyecto] | [alto|medio|bajo] | [positivo|neutro|negativo] | [alta|media|baja] |
| [Nombre/Rol 2] | [rol en proyecto] | [alto|medio|bajo] | [positivo|neutro|negativo] | [alta|media|baja] |

---

## 5. Criterios de Éxito

### 5.1 Métricas de Éxito (KPIs)

| KPI | Baseline Actual | Target | Método de Medición |
|-----|-----------------|--------|--------------------|
| [Métrica 1] | [valor actual] | [valor objetivo] | [cómo se mide] |
| [Métrica 2] | [valor actual] | [valor objetivo] | [cómo se mide] |

### 5.2 Criterios de Aceptación del Negocio

1. **[Criterio 1]**: [descripción verificable]
2. **[Criterio 2]**: [descripción verificable]
3. **[Criterio n]**: [descripción verificable]

---

## 6. Análisis de Alternativas

### 6.1 Opciones Evaluadas

#### Opción 1: [Nombre de la opción]
- **Descripción**: [breve descripción]
- **Pros**: [ventajas]
- **Contras**: [desventajas]
- **Costo estimado**: $[monto]
- **Tiempo estimado**: [duración]

#### Opción 2: [Nombre de la opción]
- **Descripción**: [breve descripción]
- **Pros**: [ventajas]
- **Contras**: [desventajas]
- **Costo estimado**: $[monto]
- **Tiempo estimado**: [duración]

### 6.2 Recomendación

**Opción seleccionada**: [Opción X]

**Justificación**: [razones de la selección basadas en valor, viabilidad, riesgo]

---

## 7. Roadmap de Implementación

### 7.1 Fases Propuestas

| Fase | Descripción | Duración | Dependencias |
|------|-------------|----------|--------------|
| Fase 1 | [descripción fase 1] | [X semanas] | [ninguna] |
| Fase 2 | [descripción fase 2] | [X semanas] | [Fase 1] |
| Fase 3 | [descripción fase 3] | [X semanas] | [Fase 2] |

### 7.2 Hitos Principales

- [ ] **Hito 1**: [descripción] - [fecha]
- [ ] **Hito 2**: [descripción] - [fecha]
- [ ] **Hito 3**: [descripción] - [fecha]

---

## 8. Derivación a Requisitos

Esta necesidad se descompone en los siguientes requisitos:

### 8.1 Requisitos de Negocio (Business Requirements)

- [ ] [RN-XXX](../implementacion/[dominio]/requisitos/negocio/rnXXX_[nombre].md) - [Título]

### 8.2 Requisitos de Stakeholders

- [ ] [RS-XXX](../implementacion/[dominio]/requisitos/stakeholders/rsXXX_[nombre].md) - [Título]

### 8.3 Requisitos Funcionales

- [ ] [RF-XXX](../implementacion/[dominio]/requisitos/funcionales/rfXXX_[nombre].md) - [Título]

### 8.4 Requisitos No Funcionales

- [ ] [RNF-XXX](../implementacion/[dominio]/requisitos/no_funcionales/rnfXXX_[nombre].md) - [Título]

---

## 9. Trazabilidad

### 9.1 Trazabilidad Upward (Origen)

Esta necesidad está alineada con:

- **Objetivo estratégico**: [OE-XXX - Descripción]
- **Iniciativa corporativa**: [INIT-XXX - Descripción]
- **Business case**: [BC-XXX - Referencia]

### 9.2 Trazabilidad Downward (Derivados)

Esta necesidad genera:

- **Requisitos de negocio**: RN-XXX, RN-YYY
- **Proyectos/Iniciativas**: [PROJ-XXX - Nombre]
- **Entregables**: [lista de entregables principales]

---

## 10. Riesgos Identificados

| ID | Riesgo | Probabilidad | Impacto | Mitigación |
|----|--------|--------------|---------|------------|
| R-01 | [descripción riesgo 1] | [alta|media|baja] | [alto|medio|bajo] | [estrategia de mitigación] |
| R-02 | [descripción riesgo 2] | [alta|media|baja] | [alto|medio|bajo] | [estrategia de mitigación] |

---

## 11. Aprobaciones

| Rol | Nombre | Fecha | Firma/Aprobación |
|-----|--------|-------|------------------|
| Sponsor | [nombre] | [YYYY-MM-DD] | [ ] Aprobado |
| BA Lead | [nombre] | [YYYY-MM-DD] | [ ] Aprobado |
| PMO | [nombre] | [YYYY-MM-DD] | [ ] Aprobado |
| Tech Lead | [nombre] | [YYYY-MM-DD] | [ ] Revisado |

---

## 12. Referencias

### 12.1 Documentos Relacionados

- [Business Case](../vision_y_alcance/business_case_[nombre].md)
- [Project Charter](../planificacion_y_releases/charter_[nombre].md)
- [Análisis de Stakeholders](../anexos/stakeholder_analysis_[nombre].md)

### 12.2 Estándares Aplicados

- **BABOK v3**: Knowledge Area - Business Analysis Planning and Monitoring
- **ISO/IEC/IEEE 29148:2018**: Clause 6.2 - Business Analysis Process
- **PMBOK Guide 7th Ed**: Principle-Based Approach to Project Management

---

## Control de Cambios

| Versión | Fecha | Autor | Descripción del Cambio |
|---------|-------|-------|------------------------|
| 1.0 | [YYYY-MM-DD] | [autor] | Creación inicial |
| 1.1 | [YYYY-MM-DD] | [autor] | [descripción cambios] |

---

**Notas para el Autor:**

1. OK Completar TODOS los campos del frontmatter YAML
2. OK Usar verbos en infinitivo para describir la necesidad
3. OK Cuantificar impactos y beneficios siempre que sea posible
4. OK Vincular con objetivos estratégicos organizacionales
5. OK Obtener aprobación de sponsor antes de derivar a requisitos
6. OK Asegurar que ID sea único en el proyecto (formato: N-XXX)
7. OK Actualizar matriz de trazabilidad cuando se deriven requisitos

---

**Fin del Template**
