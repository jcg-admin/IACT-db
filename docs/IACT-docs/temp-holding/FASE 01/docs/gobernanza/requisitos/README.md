---
id: DOC-REQ-INDEX
estado: activo
propietario: equipo-ba
fecha_creacion: 2025-11-06
ultima_actualizacion: 2025-11-06
auto_generado: true
relacionados: ["DOC-IMPLEMENTACION-INDEX", "DOC-PROPUESTA-FINAL-REESTRUCTURACION"]
---
# Indices de Requisitos IACT - ISO/IEC/IEEE 29148:2018

Este directorio contiene los indices consolidados de requisitos del proyecto IACT, generados automaticamente conforme al estandar **ISO/IEC/IEEE 29148:2018 - Systems and software engineering - Life cycle processes - Requirements engineering**.

---

## Conformance Statement

**El Sistema de Requisitos IACT cumple COMPLETAMENTE (Full Conformance) con ISO/IEC/IEEE 29148:2018**

- Clause 5.2: Requirements Management
- Clause 5.2.8: Requirements Traceability
- Clause 9.3: Business Requirements Specification (BRS)
- Clause 9.4: Stakeholder Requirements Specification (StRS)
- Clause 9.6: Software Requirements Specification (SRS)

---

## Indices Generados (READY)

| Documento | ISO Clause | Estado | Requisitos | Archivo |
|-----------|------------|--------|------------|---------|
| **BRS** - Business Requirements | 9.3 | GENERADO | 3 requisitos de negocio | [brs_business_requirements.md](./brs_business_requirements.md) |
| **StRS** - Stakeholder Requirements | 9.4 | GENERADO | 4 requisitos stakeholders | [strs_stakeholder_requirements.md](./strs_stakeholder_requirements.md) |
| **SRS** - Software Requirements | 9.6 | GENERADO | 18 requisitos funcionales | [srs_software_requirements.md](./srs_software_requirements.md) |
| **RTM** - Traceability Matrix | 5.2.8 | GENERADO | 36 requisitos totales | [matriz_trazabilidad_rtm.md](./matriz_trazabilidad_rtm.md) |

---

## Resumen Ejecutivo

### Estadisticas Generales

- **Total requisitos:** 36
- **Necesidades (N-XXX):** 3
- **Requisitos de Negocio (RN-XXX):** 3
- **Requisitos de Stakeholders (RS-XXX):** 4
- **Requisitos Funcionales (RF-XXX):** 18
- **Requisitos No Funcionales (RNF-XXX):** 8

### Por Dominio

- **Backend:** 25 requisitos (3 necesidades, 2 RN, 2 RS, 12 RF, 6 RNF)
- **Frontend:** 2 requisitos (2 RF)
- **Infrastructure:** 2 requisitos (1 RF, 1 RNF)

### Cobertura de Trazabilidad

- **100% requisitos con upward traceability:** Todos los requisitos vinculan a su origen
- **100% requisitos con frontmatter YAML completo:** Metadata estructurada
- **Trazabilidad bidireccional:** Upward y downward en todos los requisitos

---

## Estructura de Requisitos ISO 29148

```
Necesidades de Negocio (Business Needs)
    |
    v
Requisitos de Negocio (Business Requirements) - ISO 29148 Clause 9.3
    |
    v
Requisitos de Stakeholders (Stakeholder Requirements) - ISO 29148 Clause 9.4
    |
    v
Requisitos de Sistema/Software - ISO 29148 Clause 9.6
    |
    +-- Requisitos Funcionales (RF-XXX)
    |
    +-- Requisitos No Funcionales (RNF-XXX)
```

---

## Generacion de Indices

### Comando

```bash
python3 scripts/requisitos/generate_requirements_index.py
```

### Resultado

El script escanea todos los archivos `.md` en `implementacion/**/requisitos/` y genera automaticamente:

1. **BRS** (Business Requirements Specification) - ISO 29148 Clause 9.3
2. **StRS** (Stakeholder Requirements Specification) - ISO 29148 Clause 9.4
3. **SRS** (Software Requirements Specification) - ISO 29148 Clause 9.6
4. **RTM** (Requirements Traceability Matrix) - ISO 29148 Clause 5.2.8

### Automatizacion

- **GitHub Actions:** Workflow automatizado en `.github/workflows/requisitos-index.yml`
- **Pre-commit hook:** Disponible en `.husky/pre-commit`
- **Frecuencia:** Ejecutar tras crear/modificar cualquier requisito

---

## Source of Truth

El **Source of Truth** para requisitos esta en:

```
implementacion/
├── backend/requisitos/
│   ├── necesidades/
│   ├── negocio/
│   ├── stakeholders/
│   ├── funcionales/
│   └── no_funcionales/
├── frontend/requisitos/
│   └── funcionales/
└── infrastructure/requisitos/
    ├── funcionales/
    └── no_funcionales/
```

---

## Restricciones IACT Criticas

Todos los requisitos IACT respetan las siguientes restricciones tecnicas:

1. **NO EMAIL:** Solo buzon interno (modelo InternalMessage)
2. **BD IVR READONLY:** Zero escritura en BD legacy, solo SELECT
3. **SESIONES EN BD:** MySQL, NO Redis
4. **NO REAL-TIME:** Dashboard actualizado via ETL batch (6-12h)
5. **JWT + PERMISOS:** Access token 15 min, refresh 7 dias
6. **PAGINACION:** Obligatoria siempre
7. **AUDITORIA:** Todos los eventos criticos
8. **BAJA LOGICA:** No eliminacion fisica de usuarios
9. **SIN EMOJIS:** En ningun archivo
10. **THROTTLING:** Login 5 intentos/5min

---

## Recursos

### Plantillas

- [Plantillas de Requisitos](../plantillas/README.md)
- Template Necesidad (N-XXX)
- Template Requisito Negocio (RN-XXX)
- Template Requisito Stakeholder (RS-XXX)
- Template Requisito Funcional (RF-XXX)
- Template Requisito No Funcional (RNF-XXX)

### Estandares

- **ISO/IEC/IEEE 29148:2018** - Systems and software engineering - Requirements engineering
- **BABOK v3** - Business Analysis Body of Knowledge
- **PMBOK 7th Edition** - Project Management Body of Knowledge
- **OWASP ASVS v4.0** - Application Security Verification Standard

### Documentacion Relacionada

- [Glosario BABOK+PMBOK+ISO](../glosario_babok_pmbok_iso.md)
- [Restricciones y Lineamientos IACT](../../backend/requisitos/restricciones_y_lineamientos.md)

---

## ADVERTENCIA: NO EDITAR MANUALMENTE

Los indices en esta carpeta son **auto-generados** mediante script desde requisitos documentados en `implementacion/`.

**Cualquier cambio manual sera sobrescrito** en la proxima ejecucion del script.

Para modificar requisitos, editar archivos en `implementacion/{dominio}/requisitos/` y re-ejecutar script.

---

**Ultima actualizacion:** 2025-11-06
**Owner:** equipo-ba
**Conformance:** ISO/IEC/IEEE 29148:2018 - Full Conformance
**Total requisitos:** 36
