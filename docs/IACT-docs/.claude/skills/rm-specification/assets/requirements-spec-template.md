```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: rm:specification
author: [nombre]
status: Borrador
```

# Especificación de Requisitos — v1.0

> Estándares de especificación: [specification-standards.md](../references/specification-standards.md)

---

## Metadata del documento

| Campo | Valor |
|-------|-------|
| **Proyecto** | [nombre del proyecto] |
| **Versión** | 1.0 |
| **Formato** | IEEE 830 SRS / BRD / User Stories / Híbrido |
| **Baseline** | Pendiente de aprobación |
| **Cambios posteriores** | Vía rm:management (Change Request) |

---

## 1. Introducción

### 1.1 Propósito
[Describir el propósito de este documento y su audiencia principal]

### 1.2 Alcance del sistema
[Descripción de alto nivel del sistema — qué hace y qué no hace]

### 1.3 Definiciones y acrónimos

| Término | Definición |
|---------|-----------|
| [término] | [definición] |

### 1.4 Trazabilidad

Este documento es trazable a:
- Elicitación: `{wp}/rm-elicitation.md`
- Análisis: `{wp}/rm-analysis.md`

---

## 2. Descripción general

### 2.1 Perspectiva del sistema
[Contexto: ¿es un sistema nuevo? ¿reemplaza algo? ¿se integra con qué?]

### 2.2 Funciones principales
[Lista de las funciones principales — nivel de resumen]

### 2.3 Características de los usuarios

| Tipo de usuario | Frecuencia de uso | Nivel técnico | Necesidades especiales |
|----------------|------------------|--------------|------------------------|
| [tipo] | [diario/semanal] | [bajo/medio/alto] | [accesibilidad, idioma] |

### 2.4 Restricciones de diseño e implementación
[Constraints técnicos, regulatorios, de plataforma que condicionan el diseño]

---

## 3. Requisitos funcionales

> Formato: `REQ-NNN: [Descripción]`
> Cada requisito tiene: ID, descripción, prioridad MoSCoW, origen, criterio de aceptación.

### 3.1 [Módulo / Dominio funcional A]

---

**REQ-001:** [Nombre corto del requisito]

| Campo | Contenido |
|-------|-----------|
| **Descripción** | [El sistema debe/permitirá/podrá + acción + objeto + condición] |
| **Prioridad** | Must Have / Should Have / Could Have |
| **Origen** | [stakeholder] / [sesión de elicitación] |
| **Dependencias** | [REQ-NNN si aplica] |

**Criterio de aceptación:**
```gherkin
Given [estado inicial del sistema]
When [acción del actor]
Then [resultado observable y verificable]
```

**Notas:** [Restricciones adicionales, excepciones, notas de diseño permitidas]

---

**REQ-002:** [Nombre corto]

*(repetir estructura)*

---

### 3.2 [Módulo / Dominio funcional B]

*(repetir sección)*

---

## 4. Requisitos no funcionales (NFR)

### 4.1 Performance

| Req ID | Descripción | Métrica | Condición | Método de verificación |
|--------|-------------|---------|-----------|----------------------|
| NFR-P01 | Tiempo de respuesta | p95 < [X] ms | [N] usuarios concurrentes | Test de carga en staging |
| NFR-P02 | Throughput | ≥ [N] req/s | Carga sostenida de [X] min | |

### 4.2 Disponibilidad y confiabilidad

| Req ID | Descripción | Métrica | Período | Método de verificación |
|--------|-------------|---------|---------|----------------------|
| NFR-A01 | Uptime | ≥ [X]% | Mensual | Monitoring (SLA report) |
| NFR-A02 | RTO (Recovery Time Objective) | ≤ [X] min | Por incidente | Test de failover |
| NFR-A03 | RPO (Recovery Point Objective) | ≤ [X] min de pérdida de datos | Por incidente | Test de restore |

### 4.3 Seguridad

| Req ID | Descripción | Estándar / Referencia | Método de verificación |
|--------|-------------|----------------------|----------------------|
| NFR-S01 | Autenticación | OWASP ASVS Nivel [1/2/3] | Penetration test |
| NFR-S02 | Autorización | RBAC — roles definidos en REQ-NNN | Test de autorización |
| NFR-S03 | Datos sensibles | Cifrado en reposo y tránsito (AES-256, TLS 1.3) | Auditoría de configuración |

### 4.4 Usabilidad

| Req ID | Descripción | Métrica | Método de verificación |
|--------|-------------|---------|----------------------|
| NFR-U01 | Curva de aprendizaje | Usuario nuevo completa [tarea X] sin ayuda en < [N] min | Test de usabilidad con [N] usuarios |
| NFR-U02 | Tasa de error | < [X]% en [tarea crítica] | Observación en UAT |

### 4.5 Mantenibilidad

| Req ID | Descripción | Métrica | Método de verificación |
|--------|-------------|---------|----------------------|
| NFR-M01 | Cobertura de tests | ≥ [X]% en lógica de dominio | Coverage report en CI |
| NFR-M02 | Documentación técnica | API documentada con OpenAPI 3.0 | Revisión de documentación |

### 4.6 Escalabilidad

| Req ID | Descripción | Capacidad actual | Capacidad objetivo |
|--------|-------------|-----------------|-------------------|
| NFR-E01 | Volumen de usuarios | [N actual] | [N objetivo en X años] |
| NFR-E02 | Volumen de datos | [N registros/día] | [N objetivo] |

---

## 5. Restricciones externas

### 5.1 Interfaces con sistemas externos

| Sistema | Dirección | Protocolo | Formato | Versión |
|---------|-----------|----------|---------|---------|
| [Sistema A] | Salida | REST / SOAP / gRPC | JSON / XML | v[X] |

### 5.2 Restricciones regulatorias / legales

| Regulación | Requisitos aplicables | Req ID relacionados |
|-----------|----------------------|---------------------|
| [GDPR / PCI-DSS / HIPAA] | [qué cumplimiento requiere] | NFR-S0N |

---

## 6. Trazabilidad

### Matriz de trazabilidad — Requisitos → Stakeholders

| Req ID | Stakeholder principal | Prioridad | Sesión de origen |
|--------|----------------------|-----------|-----------------|
| REQ-001 | [stakeholder] | Must Have | S-01 |

### Matriz de trazabilidad — Requisitos → Casos de uso (si aplica)

| UC ID | Req ID(s) soportados |
|-------|---------------------|
| UC-001 | REQ-001, REQ-003, NFR-P01 |

---

## 7. Baseline y aprobación

| Stakeholder | Rol | Estado | Fecha | Observaciones |
|-------------|-----|--------|-------|---------------|
| [nombre] | Sponsor | ✅ Aprobado / ⏳ Pendiente / ❌ Rechazado | [fecha] | |
| [nombre] | PO | | | |

**Versión baseline:** 1.0
**Fecha de baseline:** [fecha de aprobación]
**Cambios posteriores:** vía Change Request → rm:management
