```yml
created_at: [timestamp]
project: [nombre]
work_package: [wp-id]
phase: rup:transition
rup_iteration: [N]
author: [nombre]
status: Borrador
```

# RUP Transition — Artefacto

---

## Plan de deployment

> Criterios de aceptación post-deployment: [pd-criteria.md](../references/pd-criteria.md)

### Checklist pre-deployment

- [ ] Entorno de producción configurado y verificado
- [ ] Base de datos migrada / inicializada
- [ ] Configuración de producción revisada (variables de entorno, secrets)
- [ ] Backup del sistema anterior realizado (si hay sistema previo)
- [ ] Monitoring y alertas configuradas
- [ ] Plan de rollback documentado y probado

### Pasos de deployment

| Paso | Descripción | Responsable | Duración estimada | Estado |
|------|-------------|-------------|------------------|--------|
| 1 | [Deploy de infraestructura] | [DevOps] | [X min] | ⏳ / ✅ / ❌ |
| 2 | [Migración de base de datos] | [DBA] | [X min] | |
| 3 | [Deploy de la aplicación] | [DevOps] | [X min] | |
| 4 | [Smoke test post-deploy] | [QA] | [X min] | |
| 5 | [Activación de monitoring] | [DevOps] | [X min] | |

### Plan de rollback

**Condición de rollback:** [qué situación activa el rollback automáticamente]

| Paso | Descripción | Responsable | Tiempo estimado |
|------|-------------|-------------|----------------|
| 1 | [Detectar falla] | [Monitoring] | [X min] |
| 2 | [Decisión de rollback] | [Tech Lead] | [X min] |
| 3 | [Ejecutar rollback] | [DevOps] | [X min] |
| 4 | [Verificar estado] | [QA] | [X min] |

**Comunicación de rollback:** [a quién se notifica, cómo]

---

## UAT — User Acceptance Testing

### Resultados por UC / Escenario

| UC / Scenario | Usuarios participantes | Fecha | Resultado | Defectos encontrados |
|---------------|----------------------|-------|-----------|---------------------|
| UC-001: [Nombre] | [N usuarios — roles] | [fecha] | ✅ Aceptado / ⚠️ Observaciones / ❌ Rechazado | [D-001, D-002] |
| UC-002: [Nombre] | | | | |

### Métricas de UAT

| Métrica | Valor |
|---------|-------|
| Usuarios beta participantes | [N] |
| Escenarios ejecutados | [N] |
| Escenarios aceptados | [N / total] |
| Defectos reportados por usuarios beta | [N] |
| Tasa de error en flujos críticos | [%] |
| NPS / Satisfacción (si se midió) | [puntaje] |

### Feedback de usuarios beta

| Área | Feedback positivo | Feedback negativo / Mejora sugerida |
|------|------------------|-------------------------------------|
| Usabilidad | [qué encontraron intuitivo] | [qué fue difícil de usar] |
| Performance percibida | [qué fue rápido] | [qué sintieron lento] |
| Funcionalidad | [qué cubre su necesidad] | [qué faltó o está incompleto] |
| Estabilidad | [qué funcionó sin problemas] | [qué falló o sorprendió negativamente] |

---

## Defect log (post-beta)

| ID | Severity | Descripción | Reportado por | Estado | Versión corregida |
|----|----------|-------------|--------------|--------|------------------|
| D-001 | Severity 1 | [descripción] | [usuario/fecha] | Resuelto ✅ | [v.x.x] |
| D-002 | Severity 2 | [descripción] | | Abierto ⚠️ | [v.x.x target] |

**Resumen de defectos post-beta:**

| Severidad | Encontrados en beta | Resueltos antes PD | Pendientes |
|-----------|--------------------|--------------------|-----------|
| Severity 1 | | | 0 (requerido PD) |
| Severity 2 | | | |
| Severity 3 | | | |

---

## Training realizado

| Audiencia | Formato | Fecha | Participantes | Material entregado |
|-----------|---------|-------|--------------|-------------------|
| Usuarios finales — [área] | [Presencial / Virtual / Video] | [fecha] | [N personas] | [guía de usuario / video] |
| Administradores del sistema | [formato] | [fecha] | [N personas] | [manual de administración] |
| Soporte / Help Desk | [formato] | [fecha] | [N personas] | [runbook de soporte] |

**Feedback del training:**

| Audiencia | ¿Entendieron el sistema? | ¿Pueden operarlo sin ayuda? | Gaps identificados |
|-----------|--------------------------|---------------------------|-------------------|
| Usuarios finales | ✅ / ⚠️ / ❌ | ✅ / ⚠️ / ❌ | [qué necesita refuerzo] |
| Administradores | | | |
| Soporte | | | |

---

## Documentación entregada

| Documento | Audiencia | Estado | Ubicación |
|-----------|-----------|--------|-----------|
| Guía de usuario | Usuarios finales | ✅ / ⏳ | [URL / path] |
| Manual de administración | Admins | ✅ / ⏳ | |
| Runbook de soporte | Soporte / Help Desk | ✅ / ⏳ | |
| Documentación técnica (API, arquitectura) | Equipo técnico | ✅ / ⏳ | |
| Procedimientos de backup y recovery | Operaciones | ✅ / ⏳ | |

---

## Lecciones aprendidas del proyecto

### Inception

| Dimensión | Observación |
|-----------|-------------|
| ¿El Vision Document fue suficientemente claro? | |
| ¿El scope fue el correcto? | |
| ¿Los riesgos críticos fueron identificados correctamente? | |
| ¿Algo que haríamos diferente en Inception? | |

### Elaboration

| Dimensión | Observación |
|-----------|-------------|
| ¿El Architecture Prototype probó los escenarios correctos? | |
| ¿El SAD fue lo suficientemente completo para guiar Construction? | |
| ¿Algo sorprendente descubierto en Elaboration? | |
| ¿Algo que haríamos diferente en Elaboration? | |

### Construction

| Dimensión | Observación |
|-----------|-------------|
| ¿Las iteraciones fueron del tamaño correcto? | |
| ¿La deuda técnica fue manejada bien? | |
| ¿El IOC fue alcanzado en el tiempo estimado? | |
| ¿Algo que haríamos diferente en Construction? | |

### Transition

| Dimensión | Observación |
|-----------|-------------|
| ¿El UAT reveló problemas inesperados? | |
| ¿El training fue suficiente para los usuarios? | |
| ¿El deployment fue suave o problemático? | |
| ¿Algo que haríamos diferente en Transition? | |

### Proceso RUP

| Dimensión | Observación |
|-----------|-------------|
| ¿Qué fase tomó más tiempo del esperado? | |
| ¿Qué milestone fue más difícil de alcanzar? | |
| ¿Qué herramientas fueron más valiosas? | |
| ¿RUP fue la metodología correcta para este proyecto? | |

---

## Product Acceptance Sign-off

| Campo | Detalle |
|-------|---------|
| **Sponsor / Cliente** | [nombre completo] |
| **Rol** | [título / cargo] |
| **Sistema aceptado** | [nombre del sistema v[versión]] |
| **Fecha de aceptación** | [DD/MM/YYYY] |
| **Condiciones de aceptación** | [sin condiciones / con condiciones: descripción] |
| **Defectos pendientes acordados** | [lista de D-NNN acordados como aceptables post-PD] |

---

## Evaluación milestone PD

> Criterios detallados: [pd-criteria.md](../references/pd-criteria.md)

- [ ] Sistema en producción y accesible a usuarios reales
- [ ] Severity 1 = 0 defectos abiertos
- [ ] Product Acceptance Sign-off obtenido del sponsor / cliente
- [ ] Training completado para todas las audiencias
- [ ] Documentación entregada y accesible

**Resultado de la evaluación PD:**

| Criterio | Estado | Observación |
|----------|--------|-------------|
| Sistema en producción | ✅ / ⚠️ / ❌ | |
| Severity 1 = 0 | ✅ / ⚠️ / ❌ | |
| Product Acceptance Sign-off | ✅ / ⚠️ / ❌ | |
| Training completado | ✅ / ⚠️ / ❌ | |
| Documentación entregada | ✅ / ⚠️ / ❌ | |

---

## Decisión

- [ ] **PD alcanzado — proyecto cerrado** — Todos los criterios ✅
- [ ] **Nueva iteración de Transition** — Motivo: [defectos críticos en beta / UAT reveló problemas mayores / training insuficiente]
