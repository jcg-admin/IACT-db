```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: rm:validation
author: [nombre]
status: Borrador
```

# RM Validation — Artefacto

---

## Técnica de validación seleccionada

> Checklist de validación por tipo de requisito: [validation-checklist.md](../references/validation-checklist.md)

| Técnica | Justificación | Alcance |
|---------|--------------|---------|
| [ ] Walkthrough informal | Recursos limitados; primer ciclo | Revisión de completitud y coherencia |
| [ ] Inspección Fagan | Alta criticidad; equipo entrenado | Revisión sistemática con defect log formal |
| [ ] Revisión con prototipo | Requisitos difíciles de verificar en texto | Validación con stakeholders usando prototipo |
| [ ] Revisión de trazabilidad | Verificar cobertura de elicitación → spec | Confirmar que todos los requisitos tienen origen y destino |

**Documentos revisados:** [lista de artefactos bajo revisión]
**Versión revisada:** v[X.Y] de [fecha]

---

## Resultados de verificación (calidad interna)

> Ejecutado por el equipo de RM — sin stakeholders.

| Req ID | Completo | Correcto | Factible | No ambiguo | Verificable | Trazable | Consistente | Defecto |
|--------|---------|---------|---------|-----------|-----------|---------|-----------|---------|
| REQ-001 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | — |
| REQ-002 | ✅ | ✅ | ⚠️ | ✅ | ✅ | ✅ | ✅ | D-001 |
| NFR-P01 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | — |

**Resumen de verificación:**

| Criterio | # Aprobados | # Con issues | % Aprobación |
|----------|------------|------------|-------------|
| Completo | | | |
| Correcto | | | |
| Factible | | | |
| No ambiguo | | | |
| Verificable | | | |
| Trazable | | | |
| Consistente | | | |
| **Total general** | | | |

---

## Defect log de verificación

| D-ID | Req ID | Tipo | Descripción | Severidad | Estado | Asignado a |
|------|--------|------|-------------|-----------|--------|-----------|
| D-001 | REQ-002 | Ambiguous | ["procesamiento rápido" sin métrica] | Mayor | Abierto ⚠️ | [analista] |
| D-002 | REQ-005 | Inconsistent | [Contradice NFR-P02] | Mayor | Resuelto ✅ | |
| D-003 | NFR-S02 | Missing | [Sin referencia a GDPR en datos PII] | Crítico | Abierto ⚠️ | |

**Clasificación de defectos:**

| Tipo | Definición | Ejemplo |
|------|-----------|---------|
| **Missing** | Requisito necesario pero no escrito | Manejo de error para caso X no especificado |
| **Wrong** | Requisito incorrecto (no refleja la necesidad real) | Umbral de performance incorrectamente especificado |
| **Extra** | Requisito incluido que no fue solicitado | Feature de bajo valor que nadie pidió |
| **Ambiguous** | Múltiples interpretaciones posibles | "El sistema debe ser fácil de usar" |
| **Inconsistent** | Contradice otro requisito o documento | REQ-A pide X, NFR-B pide NOT-X |

---

## Resultados de validación con stakeholders

### Walkthrough / Revisión con stakeholders

| Sesión | Fecha | Participantes | Requisitos revisados | Resultado |
|--------|-------|--------------|---------------------|-----------|
| W-01 | [fecha] | [stakeholders] | REQ-001..REQ-010 | ✅ / ⚠️ observaciones / ❌ rechazado |

**Observaciones de stakeholders:**

| Stakeholder | Req ID | Tipo de feedback | Acción tomada |
|-------------|--------|-----------------|--------------|
| [nombre] | REQ-003 | Incompleto — falta el caso de [escenario] | Agregar escenario al criterio de aceptación |
| [nombre] | REQ-007 | Prioridad incorrecta — debería ser Must Have | Re-analizar con PO |

---

## Sign-off matrix

| Stakeholder | Rol | Estado | Fecha | Observaciones |
|-------------|-----|--------|-------|---------------|
| [nombre] | Sponsor | ✅ Aprobado / ⚠️ Condicionado / ❌ Rechazado | [fecha] | |
| [nombre] | Product Owner | | | |
| [nombre] | Representante usuarios | | | |
| [nombre] | Tech Lead | | | |

**Condiciones de aprobación condicionada (si aplica):**

| Condición | Req ID | Plazo para resolución |
|-----------|--------|----------------------|
| [descripción de la condición] | [req afectados] | [fecha] |

---

## Decisión de flujo

- [ ] **on_approved → rm:management** — todos los criterios cumplidos; sign-off completo
- [ ] **on_corrections_needed → rm:analysis** — defectos identificados que requieren re-análisis:
  - D-001: [tipo + descripción del defecto]
  - D-002: ...
- [ ] **on_corrections_needed → rm:specification** — defectos menores que solo requieren re-escritura sin re-análisis:
  - [lista de defectos]
