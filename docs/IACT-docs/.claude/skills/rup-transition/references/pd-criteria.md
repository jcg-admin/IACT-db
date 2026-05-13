# PD Criteria — Product Release Milestone

> Reference for rup:transition. PD is the gate that closes the RUP project.
> Decision: declare PD (project closed) OR iterate Transition.

---

## ¿Qué es el PD?

El **Product Release (PD)** milestone es el cierre formal del proyecto RUP. Significa que el sistema fue entregado a los usuarios finales, aceptado formalmente por el sponsor / cliente, y la responsabilidad del sistema se transfirió al equipo de operaciones o mantenimiento.

**Pregunta central del PD:** *"¿El cliente / sponsor acepta formalmente el sistema como la solución al problema definido en Inception?"*

PD ≠ sistema sin bugs. PD = sistema aceptado con calidad suficiente para operar, con defectos restantes documentados y acotados.

---

## Criterios de evaluación PD

### Criterio 1: Sistema en producción y accesible

| Sub-criterio | Evidencia requerida | Red Flag |
|-------------|--------------------|---------:|
| Deployment en producción completo | URL / endpoint de producción activo | Sistema en staging "que funciona como producción" |
| Usuarios reales pueden acceder | Al menos N usuarios beta usan el sistema | Solo el equipo técnico verificó |
| Monitoring activo | Dashboard de monitoring con alertas configuradas | Deployment sin monitoring |
| Rollback probado | Plan de rollback ejecutado en staging | Rollback no probado |

### Criterio 2: Severity 1 = 0

> Misma clasificación de severidad que en IOC.

| Severity | Requerimiento PD |
|---------|-----------------|
| **Severity 1 — Critical** | = 0 absoluto — no se puede declarar PD |
| **Severity 2 — Major** | = 0 preferido; si hay, requieren sign-off del sponsor |
| **Severity 3 — Minor** | Documentados con workaround |
| **Severity 4 — Trivial** | No bloquea PD |

> Si hay Severity 2 al PD: el sponsor puede aceptar formalmente con esos defectos si hay un plan de corrección con fecha comprometida.

### Criterio 3: Product Acceptance Sign-off

| Sub-criterio | Evidencia requerida | Red Flag |
|-------------|--------------------|---------:|
| Sponsor / cliente firmó | Documento de aceptación con firma | Email informal "parece bien" |
| Defectos pendientes acordados | Lista explícita de D-NNN aceptados | Aceptación sin listar lo que queda |
| Condiciones documentadas | Sin condiciones o condiciones explícitas | "Aceptamos si arreglan esto" sin fecha |
| Fecha formal de aceptación | Timestamp del sign-off | "La próxima semana lo formalizo" |

**Formato mínimo del Product Acceptance Sign-off:**

```markdown
## Product Acceptance Sign-off

Yo, [nombre], en mi rol de [rol] para el proyecto [nombre del proyecto],
acepto formalmente la entrega del sistema [nombre del sistema] versión [X.Y.Z]
según las condiciones acordadas en el Project Charter aprobado en [fecha del LCO].

**Sistema en producción:** [URL / descripción]
**Versión aceptada:** [X.Y.Z]
**Fecha de aceptación:** [DD/MM/YYYY]

**Defectos pendientes aceptados:**
- D-NNN: [descripción] — plan de corrección: [versión / fecha]

**Condiciones post-PD (si aplica):**
- [Condición acordada con fecha]

Firma: _________________ Fecha: _________________
```

### Criterio 4: Training completado

| Audiencia | Requerimiento PD |
|-----------|-----------------|
| **Usuarios finales** | 100% del equipo que usará el sistema en el primer día | Obligatorio |
| **Administradores** | Todos los admins del sistema | Obligatorio |
| **Soporte / Help Desk** | Equipo de 1er nivel de soporte | Obligatorio si hay soporte |
| **Equipo de mantenimiento** | Desarrolladores que mantendrán el sistema | Recomendado |

| Sub-criterio | Evidencia requerida | Red Flag |
|-------------|--------------------|---------:|
| Training ejecutado | Lista de asistentes con fecha | "Enviamos el manual por email" |
| Material entregado | Guía de usuario / manual / runbook | Training sin material escrito |
| Feedback positivo | ≥ 80% de participantes confirman entendimiento | Participantes confundidos al final |
| Gaps cubiertos | Re-entrenamiento si hubo gaps | Gaps identificados sin acción |

### Criterio 5: Documentación entregada

| Documento | Para quién | Requerimiento |
|-----------|-----------|---------------|
| Guía de usuario | Usuarios finales | Obligatorio |
| Manual de administración | Admins | Obligatorio si el sistema tiene admins |
| Runbook de soporte (nivel 1) | Help Desk | Obligatorio si hay soporte |
| Documentación de API | Integradores | Obligatorio si hay integraciones |
| Guía de deployment / operaciones | Operaciones / DevOps | Obligatorio |
| Documentación técnica (arquitectura) | Equipo de mantenimiento | Recomendado |

---

## Checklist de aceptación post-deployment (primeras 48h)

### Día 1 (primeras 8h en producción)

- [ ] Sistema accesible por usuarios reales
- [ ] Monitoring muestra métricas normales (no alertas críticas)
- [ ] Primer login de usuarios reales exitoso
- [ ] Flujo de negocio más crítico ejecutado por usuario real
- [ ] Sin Severity 1 reportados

### Día 2 (24-48h en producción)

- [ ] Volumen normal de uso sin degradación de performance
- [ ] Sin nuevos Severity 1 o 2
- [ ] Equipo de soporte atendiendo tickets sin escalamiento al equipo de desarrollo
- [ ] Backup automático ejecutado correctamente (si aplica)
- [ ] Sponsor notificado del status post-deployment

---

## User acceptance criteria — ¿cuándo un usuario "acepta" un UC?

| Criterio de aceptación | Evidencia |
|----------------------|-----------|
| **Funcional** | El UC produce el output esperado para todos los inputs probados | Checklist de escenarios ejecutados |
| **Performance percibida** | El usuario no percibe latencia inaceptable | Tiempo de respuesta ≤ 3s para operaciones comunes |
| **Usabilidad** | El usuario completa el flujo sin ayuda o guía | Observación directa en UAT |
| **Correctitud** | Los datos producidos son correctos vs expectativa del negocio | Validación de datos de muestra |
| **Integridad** | Operaciones previas no son afectadas por las nuevas | Regresión de UC anteriores |

---

## Checklist de concurrencia — ¿quiénes deben aprobar el PD?

| Rol | Aprueba | Criterios que valida |
|-----|---------|---------------------|
| **Sponsor / Cliente** | Obligatorio | Product Acceptance Sign-off, funcionalidad entregada |
| **Product Owner** | Obligatorio | UC Must Have completos y aceptados |
| **QA Lead** | Obligatorio | Defect status (Severity 1 = 0) |
| **Tech Lead** | Obligatorio | Documentación técnica, deuda técnica comunicada |
| **Project Manager** | Obligatorio | Cierre formal del proyecto, lecciones aprendidas |
| **Equipo de operaciones** | Si aplica | Runbook recibido, monitoring configurado |

---

## Decisiones típicas en el PD

### Decisión 1: PD alcanzado — proyecto cerrado

**Condición:** Todos los criterios ✅.

**Acciones de cierre:**
1. Archivar artefactos del proyecto (Vision, SAD, UC Model, Risk List)
2. Documentar lecciones aprendidas (obligatorio — no saltear por presión de cierre)
3. Cerrar el Work Package THYROX con Stage 12 STANDARDIZE
4. Transferir la responsabilidad formalmente al equipo de operaciones / mantenimiento

### Decisión 2: Nueva iteración de Transition

**Causa → Acción:**

| Criterio fallido | Acción recomendada | Duración típica |
|-----------------|-------------------|----------------|
| Severity 1 descubierto en beta | Hotfix urgente + re-deploy | 1-3 días |
| UAT reveló problemas mayores en UC Must Have | Corregir + re-ejecutar UAT | 1-2 semanas |
| Sponsor rechaza Product Acceptance | Identificar gap exacto + corrección | 1 semana por gap |
| Training insuficiente | Re-training + material mejorado | 3-5 días |

---

## Límites de tiempo para Transition

| Tamaño del proyecto | Duración máxima Transition |
|--------------------|---------------------------|
| Pequeño (< 6 meses) | 1-2 semanas |
| Mediano (6-18 meses) | 2-4 semanas |
| Grande (> 18 meses) | 4-8 semanas |

> **Regla del 20%:** Transition no debe superar el 20% del esfuerzo total del proyecto.
> Si se supera, Construction fue incompleto o los requisitos no fueron correctamente validados en Elaboration.

---

## Señales de PD fallido (post-hoc)

| Señal post-PD | Causa probable en Transition |
|--------------|------------------------------|
| Usuarios no adoptan el sistema | Training insuficiente o usabilidad crítica no corregida |
| Soporte abrumado el primer mes | Documentación de soporte insuficiente |
| Rollback de producción la primera semana | Tests de staging insuficientes antes del deploy |
| Sponsor insatisfecho aunque firmó | Sign-off sin revisión real de los criterios |
| Equipo de mantenimiento no puede modificar el sistema | Documentación técnica y deuda técnica no comunicadas |
