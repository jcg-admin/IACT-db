# Project Closure Guide — Guía de referencia

> Reference for pm:closing. Proceso de cierre formal, administración de contratos, lecciones aprendidas efectivas.

---

## ¿Por qué importa el cierre formal?

Un proyecto sin cierre formal genera:
- **Scope creep post-proyecto:** Stakeholders piden trabajo adicional "porque el proyecto no terminó oficialmente"
- **Pérdida de conocimiento:** Lecciones no documentadas → mismos errores en proyectos futuros
- **Riesgo legal:** Contratos no cerrados → disputas sobre deliverables o pagos meses después
- **Recursos atrapados:** Equipo ocupado en un proyecto "muerto" cuando debería estar en otro

---

## Checklist de cierre — paso a paso

### Paso 1: Verificar que todos los deliverables fueron aceptados

| Verificación | Responsable | Señal de completitud |
|-------------|-------------|---------------------|
| Comparar lista de deliverables del Charter vs entregados | PM | 100% aceptados o excepciones documentadas |
| Confirmar que QC aprobó cada deliverable | QA Lead | Cero defectos críticos abiertos |
| Outstanding issues transferidos a operaciones con owner | PM | Owner confirmado para cada issue |

### Paso 2: Obtener Final Acceptance firmado

**Proceso:**
1. Presentar resumen de deliverables completados al sponsor/cliente
2. Confirmar que los acceptance criteria del Charter fueron cumplidos
3. Obtener firma o confirmación escrita con fecha

**¿Qué hacer si el sponsor no quiere firmar?**
- Identificar la objeción específica
- Si es defecto no resuelto → resolver y reintentar
- Si es "hay más trabajo por hacer" → abrir CR o documentar que está fuera del scope original
- Si es ambigüedad del scope → escalar a contrato / acuerdo original

### Paso 3: Consolidar lecciones aprendidas

**Cuándo capturarlas:** Durante todo el proyecto (issue log, risk log) → consolidar en Closing.

**Cómo hacerlas útiles:**
- Escribir en formato "Si vuelvo a hacer X, haré Y en lugar de Z" (accionable)
- Incluir el *contexto* (tamaño del equipo, tipo de proyecto, industria)
- Clasificar por área de conocimiento PMBOK
- Entregar a la PMO para repositorio organizacional

### Paso 4: Archivar artefactos del proyecto

**Repositorio preferido:** Organizacional (no carpeta personal del PM).

**Naming convention:** `[año]-[nombre-proyecto]-[tipo-artefacto].md`

**Retención mínima recomendada:**
- Proyectos regulados: según requisito regulatorio (mínimo 5-7 años)
- Proyectos internos: 2-3 años o hasta el fin del ciclo de vida del producto

### Paso 5: Liberar al equipo

| Actividad | Cuándo | Responsable |
|-----------|--------|-------------|
| Comunicar fecha de release a managers de línea | 2 semanas antes | PM |
| Completar evaluaciones de desempeño | Antes del release | PM |
| Knowledge transfer sobre sistemas entregados | Antes del release | Dev Lead |
| 1:1 de cierre con cada miembro del equipo | Última semana | PM |

### Paso 6: Cerrar contratos (si aplica)

**Para cada contrato con proveedores:**
1. Confirmar que todos los deliverables del contrato fueron recibidos
2. Verificar que todos los pagos están al día
3. Obtener documentación de cierre formal del proveedor
4. Resolver cualquier disputa pendiente antes del cierre

---

## Lecciones aprendidas — cómo hacerlas efectivas

### Por qué las lecciones aprendidas suelen fallar

| Causa | Síntoma | Corrección |
|-------|---------|-----------|
| Se capturan solo al final | "No recordamos qué pasó en el sprint 2" | Capturar durante el proyecto |
| Son demasiado genéricas | "Comunicar mejor" | Ser específico: quién, cuándo, cómo |
| No son accionables | "Estimar mejor" | Formato: "En proyectos de X tipo, usar técnica Y para estimar Z" |
| No se consultan en proyectos futuros | Repositorio que nadie lee | Proceso de onboarding que incluye consulta de lecciones similares |

### Template para lección aprendida efectiva

```
Lección: [nombre descriptivo]
Área: [Integration/Scope/Schedule/Cost/Quality/Resource/Communications/Risk/Stakeholder]
Tipo: [Lo que funcionó / Lo que no funcionó / Sorpresa]

Contexto: [Tipo de proyecto, tamaño del equipo, industria]
Situación: [Qué ocurrió]
Impacto: [Consecuencia para el proyecto]
Acción tomada: [Cómo se manejó en este proyecto]
Recomendación: [Qué hacer diferente en proyectos futuros]
Aplicabilidad: [En qué tipo de proyectos aplica esta lección]
```

---

## Cierre de fase vs cierre de proyecto

| Aspecto | Cierre de fase | Cierre de proyecto |
|---------|---------------|-------------------|
| Cuándo | Al final de cada fase en proyectos multi-fase | Al completar todos los entregables del proyecto |
| Acceptance | Phase exit criteria cumplidos | Final acceptance del producto completo |
| Equipo | Parcial (puede quedar equipo para siguiente fase) | Total release del equipo |
| Contratos | Solo contratos de proveedores de la fase | Todos los contratos del proyecto |
| Siguientes pasos | Iniciar nuevo Initiating para la siguiente fase | Stage TRACK/EVALUATE o STANDARDIZE en THYROX |

---

## Post-implementation review — 30-60 días después

El cierre formal no captura el impacto real del producto en operaciones. Planificar una revisión post-implementación:

| Pregunta | Métricas a evaluar |
|----------|-------------------|
| ¿Se lograron los objetivos de negocio? | KPIs del Charter vs valores reales |
| ¿El producto está siendo usado como se esperaba? | Adoption rate, usage metrics |
| ¿Hay issues post-implementación no previstos? | Incident log, soporte tickets |
| ¿Las lecciones aprendidas aplican a otros proyectos? | Revisar si el equipo de PMO las integró |

---

## Proyectos cancelados — cierre igualmente importante

Un proyecto cancelado también requiere cierre formal:
- Documentar por qué se canceló (business case ya no válido / cambio estratégico / falla técnica)
- Identificar qué deliverables parciales tienen valor y pueden usarse
- Documentar el estado de los contratos y cómo se terminaron
- Capturar lecciones de por qué el proyecto llegó a cancelación (señales que se ignoraron)
- Liberar al equipo formalmente con igual cuidado que en un cierre exitoso
