---
# Metadatos del documento
id: TEMPLATE-REQ-FUNCIONAL
tipo: plantilla
titulo: Plantilla de Requisito Funcional
version: 1.0.0
fecha_creacion: 2025-11-03
ultima_actualizacion: 2025-11-03
estado: activo
propietario: equipo-ba
estandares: ["ISO/IEC/IEEE 29148:2018 - Clause 9.6", "BABOK v3"]
---

# Template: Requisito Funcional (Functional Requirement)

> **Instrucciones:** Este template debe usarse para documentar requisitos funcionales del sistema.
> Los requisitos funcionales describen QUÉ debe hacer el sistema (comportamiento, funciones, capacidades).
> Siga la estructura "Subject + Modal Verb + Action + Object + Condition" (ISO 29148).
> Reemplace los campos entre `[CORCHETES]` con información específica.

---

## Metadatos del Requisito

```yaml
---
id: RF-[XXX]
tipo: funcional
titulo: [Título conciso del requisito (max 80 caracteres)]
dominio: [backend|frontend|infrastructure]
owner: [equipo-backend|equipo-frontend|equipo-devops]
prioridad: [critica|alta|media|baja]
estado: [propuesto|en_revision|aprobado|en_desarrollo|implementado|verificado|rechazado]
fecha_creacion: [YYYY-MM-DD]
fecha_aprobacion: [YYYY-MM-DD]
sprint_target: [SPRINT-XX]
estimacion_esfuerzo: [story-points o horas]

# Trazabilidad Upward (de dónde viene este requisito)
trazabilidad_upward:
  - N-[XXX]   # Necesidad de negocio
  - RN-[XXX]  # Requisito de negocio
  - RS-[XXX]  # Requisito de stakeholder

# Trazabilidad Downward (qué deriva de este requisito)
trazabilidad_downward:
  - TEST-[XXX]    # Casos de prueba
  - DESIGN-[XXX]  # Documentos de diseño
  - TASK-[XXX]    # Tareas de implementación

# Stakeholders interesados
stakeholders:
  - [rol-stakeholder-1]
  - [rol-stakeholder-2]

# Conformidad ISO 29148
iso29148_clause: "9.6.4"  # Software Requirements Specification
verificacion_metodo: [test|inspection|analysis|demonstration]

# Categorización adicional
categoria: [ui|api|business-logic|integration|data-processing|security|reporting]
modulo: [nombre-modulo-sistema]
subsistema: [nombre-subsistema]

# Dependencias
dependencias:
  - RF-[YYY]  # Otros requisitos de los que depende
  - API-[ZZZ] # APIs externas necesarias

# Impacto
impacto_usuarios: [alto|medio|bajo]
impacto_sistema: [alto|medio|bajo]
breaking_change: [si|no]
---
```

---

## 1. Descripción del Requisito

### 1.1 Declaración del Requisito (ISO 29148 Format)

**El sistema DEBERÁ** [acción específica que el sistema debe realizar].

> **Estructura ISO 29148:** Subject + Modal Verb + Action + Object + Condition
>
> Ejemplo correcto:
> "El sistema **DEBERÁ** calcular el stock mínimo de cada producto **considerando** la demanda histórica de los últimos 90 días **cuando** el usuario solicite el reporte de reabastecimiento."

### 1.2 Descripción Detallada

[Proporcione una descripción detallada del requisito en lenguaje natural. Explique el contexto, la necesidad, y el comportamiento esperado del sistema.]

**Contexto:**
[¿En qué situación se aplica este requisito?]

**Necesidad:**
[¿Por qué es necesario este requisito?]

**Comportamiento esperado:**
[¿Qué debe hacer exactamente el sistema?]

---

## 2. Criterios de Aceptación

> **IMPORTANTE:** Los criterios de aceptación deben ser verificables, específicos y medibles.

### 2.1 Criterios Funcionales

**Given-When-Then Format (Gherkin):**

#### Escenario 1: [Nombre del escenario - Caso feliz]

```gherkin
Given [contexto o estado inicial]
  And [contexto adicional si aplica]
When [acción o evento que ocurre]
  And [acción adicional si aplica]
Then [resultado esperado]
  And [resultado adicional esperado]
```

**Ejemplo:**
```gherkin
Given el usuario tiene permisos de "Gerente de Compras"
  And existe al menos un producto con stock bajo el mínimo
When el usuario solicita el reporte de reabastecimiento
Then el sistema muestra una lista de productos bajo stock mínimo
  And cada producto incluye: código, nombre, stock actual, stock mínimo, cantidad sugerida
  And la lista está ordenada por urgencia (menor stock primero)
```

#### Escenario 2: [Nombre del escenario - Caso alternativo]

```gherkin
Given [contexto]
When [acción]
Then [resultado esperado]
```

#### Escenario 3: [Nombre del escenario - Caso de error]

```gherkin
Given [contexto]
When [acción que causa error]
Then [manejo de error esperado]
  And [mensaje de error específico]
```

### 2.2 Criterios No Funcionales Asociados

| Aspecto | Criterio | Target | Medición |
|---------|----------|--------|----------|
| **Performance** | Tiempo de respuesta | [< X ms/seg] | [95th percentile] |
| **Concurrencia** | Usuarios simultáneos | [X usuarios] | [Test de carga] |
| **Disponibilidad** | Uptime | [99.X%] | [Monitoreo mensual] |
| **Seguridad** | Autenticación | [Requerida] | [Test de seguridad] |
| **Usabilidad** | Accesibilidad | [WCAG 2.1 AA] | [Auditoría] |

---

## 3. Especificación Técnica

### 3.1 Componentes Afectados

| Componente | Ubicación | Tipo de Cambio |
|------------|-----------|----------------|
| [Componente 1] | `[ruta/archivo]` | [nuevo|modificación|eliminación] |
| [Componente 2] | `[ruta/archivo]` | [nuevo|modificación|eliminación] |

### 3.2 Interfaces

#### 3.2.1 Interface de Usuario (si aplica)

**Wireframe/Mockup:**
[Enlace a diseño o descripción de UI]

**Elementos de UI:**
- [ ] [Elemento 1: botón, campo, tabla, etc.]
- [ ] [Elemento 2]
- [ ] [Elemento n]

**Flujo de navegación:**
1. Usuario en pantalla [A]
2. Realiza acción [X]
3. Sistema muestra [B]
4. Usuario puede [Y]

#### 3.2.2 API (si aplica)

**Endpoint:** `[METHOD] /api/v1/[recurso]/[accion]`

**Request:**
```json
{
  "parametro1": "tipo y descripción",
  "parametro2": "tipo y descripción"
}
```

**Response (Success):**
```json
{
  "status": "success",
  "data": {
    "campo1": "descripción",
    "campo2": "descripción"
  }
}
```

**Response (Error):**
```json
{
  "status": "error",
  "code": "ERROR_CODE",
  "message": "Descripción del error"
}
```

**Status Codes:**
- `200 OK`: [descripción]
- `400 Bad Request`: [descripción]
- `401 Unauthorized`: [descripción]
- `404 Not Found`: [descripción]
- `500 Internal Server Error`: [descripción]

#### 3.2.3 Base de Datos (si aplica)

**Tablas afectadas:**

```sql
-- Tabla: [nombre_tabla]
-- Acción: [CREATE|ALTER|DROP]
-- Descripción: [descripción del cambio]

CREATE TABLE [nombre_tabla] (
  id BIGSERIAL PRIMARY KEY,
  campo1 VARCHAR(255) NOT NULL,
  campo2 INTEGER,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP
);
```

**Índices requeridos:**
```sql
CREATE INDEX idx_[nombre] ON [tabla]([campo]);
```

**Migraciones:**
- [ ] Migración creada: `[YYYY_MM_DD_HHMMSS_descripcion.py]`
- [ ] Rollback verificado

### 3.3 Reglas de Negocio

| ID | Regla | Descripción | Referencia |
|----|-------|-------------|------------|
| BR-[XX] | [Nombre regla] | [Descripción detallada de la lógica de negocio] | [RN-XXX] |

**Ejemplo:**
```
BR-01: Cálculo de Stock Mínimo
Fórmula: stock_minimo = (demanda_promedio_diaria * lead_time_dias) + stock_seguridad
Donde:
  - demanda_promedio_diaria = SUM(ventas_90dias) / 90
  - lead_time_dias = tiempo de reabastecimiento del proveedor
  - stock_seguridad = demanda_promedio_diaria * factor_seguridad (default: 0.2)
```

### 3.4 Validaciones

#### Validaciones de Entrada
- [ ] [Campo X]: [regla de validación]
- [ ] [Campo Y]: [regla de validación]

#### Validaciones de Negocio
- [ ] [Condición 1]: [mensaje de error]
- [ ] [Condición 2]: [mensaje de error]

---

## 4. Dependencias

### 4.1 Requisitos Prerequisitos

Este requisito **depende de** que los siguientes requisitos estén implementados:

- [ ] [RF-YYY](./rfYYY_[nombre].md) - [Título del requisito]
- [ ] [RNF-ZZZ](../no_funcionales/rnfZZZ_[nombre].md) - [Título del requisito]

### 4.2 APIs/Servicios Externos

- [ ] **[Nombre API/Servicio]**
  - Endpoint: `[URL]`
  - Documentación: [URL documentación]
  - SLA: [disponibilidad esperada]
  - Fallback: [estrategia si falla]

### 4.3 Permisos/Roles Requeridos

| Rol | Permisos | Acciones Permitidas |
|-----|----------|---------------------|
| [Rol 1] | [lectura|escritura|admin] | [lista de acciones] |
| [Rol 2] | [lectura|escritura|admin] | [lista de acciones] |

---

## 5. Casos de Prueba

### 5.1 Tests Unitarios

- [ ] **TEST-[XXX]-001**: [Descripción test unitario 1]
  - Ubicación: `tests/unit/test_[modulo].py::test_[funcion]`
  - Estado: [pendiente|implementado|pasando]

- [ ] **TEST-[XXX]-002**: [Descripción test unitario 2]

### 5.2 Tests de Integración

- [ ] **TEST-[XXX]-101**: [Descripción test integración 1]
  - Ubicación: `tests/integration/test_[modulo].py::test_[flujo]`
  - Estado: [pendiente|implementado|pasando]

### 5.3 Tests End-to-End

- [ ] **TEST-[XXX]-201**: [Descripción test E2E 1]
  - Herramienta: [Selenium|Cypress|Playwright]
  - Ubicación: `tests/e2e/test_[flujo].py`
  - Estado: [pendiente|implementado|pasando]

### 5.4 Tests Manuales

| ID | Escenario | Pasos | Resultado Esperado | Estado |
|----|-----------|-------|-------------------|--------|
| MT-[XX] | [descripción] | [pasos numerados] | [resultado] | [ ] |

---

## 6. Definición de Hecho (Definition of Done)

- [ ] Código implementado y revisado (code review aprobado)
- [ ] Tests unitarios escritos y pasando (coverage >= 80%)
- [ ] Tests de integración pasando
- [ ] Documentación técnica actualizada (docstrings, README)
- [ ] API documentada (si aplica - Swagger/OpenAPI)
- [ ] Criterios de aceptación verificados
- [ ] Performance cumple targets definidos
- [ ] Seguridad verificada (sin vulnerabilidades críticas)
- [ ] Accesibilidad cumple estándares (si aplica WCAG)
- [ ] Aprobado por Product Owner / BA
- [ ] Desplegado en ambiente de staging
- [ ] Smoke tests en staging pasando
- [ ] Demostración realizada a stakeholders
- [ ] Documentación de usuario actualizada (si aplica)

---

## 7. Trazabilidad

### 7.1 Trazabilidad Upward (Origen)

Este requisito deriva de:

| Tipo | ID | Título | Vínculo |
|------|----|----|---------|
| Necesidad | N-[XXX] | [Título necesidad] | [link](../necesidades/nXXX_[nombre].md) |
| Req. Negocio | RN-[XXX] | [Título req negocio] | [link](../negocio/rnXXX_[nombre].md) |
| Req. Stakeholder | RS-[XXX] | [Título req stakeholder] | [link](../stakeholders/rsXXX_[nombre].md) |

**Justificación:**
[Explique cómo este requisito funcional satisface las necesidades y requisitos de nivel superior]

### 7.2 Trazabilidad Downward (Derivados)

Este requisito genera:

| Tipo | ID | Título | Ubicación |
|------|----|----|-----------|
| Test | TEST-[XXX] | [Nombre test] | `tests/[ruta]` |
| Diseño | DESIGN-[XXX] | [Documento diseño] | [link] |
| Tarea | TASK-[XXX] | [Descripción tarea] | [Jira/GitHub Issue] |

### 7.3 Trazabilidad Horizontal (Relacionados)

Requisitos relacionados que deben considerarse:

- [RF-YYY](./rfYYY_[nombre].md) - [Relación: complementa/alterna/condiciona]
- [RNF-ZZZ](../no_funcionales/rnfZZZ_[nombre].md) - [Relación: restringe/soporta]

---

## 8. Riesgos e Issues

| ID | Tipo | Descripción | Probabilidad | Impacto | Mitigación | Estado |
|----|------|-------------|--------------|---------|------------|--------|
| R-01 | Riesgo | [descripción] | [A|M|B] | [A|M|B] | [estrategia] | [Abierto|Mitigado|Cerrado] |
| I-01 | Issue | [descripción] | N/A | [A|M|B] | [resolución] | [Abierto|En progreso|Resuelto] |

---

## 9. Notas Adicionales

### 9.1 Consideraciones de Implementación

[Notas técnicas importantes para el equipo de desarrollo]

### 9.2 Deuda Técnica Conocida

[Aspectos que se dejarán para futuras iteraciones]

### 9.3 Alternativas Consideradas

[Otras soluciones evaluadas y por qué fueron descartadas]

---

## 10. Aprobaciones

| Rol | Nombre | Fecha | Estado |
|-----|--------|-------|--------|
| Product Owner | [nombre] | [YYYY-MM-DD] | [ ] Aprobado |
| Business Analyst | [nombre] | [YYYY-MM-DD] | [ ] Aprobado |
| Tech Lead | [nombre] | [YYYY-MM-DD] | [ ] Revisado |
| QA Lead | [nombre] | [YYYY-MM-DD] | [ ] Revisado |

---

## 11. Referencias

### 11.1 Documentos Relacionados

- [Documento de Diseño](../../diseno_detallado/[nombre].md)
- [ADR relevante](../../arquitectura/adr/adr_[numero]_[nombre].md)
- [Manual de Usuario](../../anexos/manual_usuario_[modulo].md)

### 11.2 Estándares Aplicados

- **ISO/IEC/IEEE 29148:2018**: Clause 9.6 - Software Requirements Specification
- **BABOK v3**: Solution Requirements (Functional)
- **IEEE 830-1998**: Recommended Practice for Software Requirements Specifications

---

## Control de Cambios

| Versión | Fecha | Autor | Descripción del Cambio | Aprobado Por |
|---------|-------|-------|------------------------|--------------|
| 1.0 | [YYYY-MM-DD] | [autor] | Creación inicial | [aprobador] |
| 1.1 | [YYYY-MM-DD] | [autor] | [descripción cambios] | [aprobador] |

---

**Notas para el Autor:**

1. OK El ID del requisito (RF-XXX) debe ser único en todo el proyecto
2. OK Use DEBERÁ/SHALL para requisitos obligatorios, DEBERÍA/SHOULD para deseables
3. OK Cada requisito debe ser atómico (una sola funcionalidad)
4. OK Criterios de aceptación deben ser verificables (testeable)
5. OK Mantenga trazabilidad bidireccional (upward/downward)
6. OK Actualice cuando el requisito cambie (control de versiones)
7. OK Vincule a tests específicos (coverage)
8. OK Obtenga aprobaciones formales antes de implementar

---

**Fin del Template**
