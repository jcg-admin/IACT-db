# LCO Criteria — Lifecycle Objectives Milestone

> Reference for rup:inception. LCO is the gate between Inception and Elaboration.
> Decision: advance to Elaboration OR iterate Inception.

---

## ¿Qué es el LCO?

El **Lifecycle Objectives (LCO)** milestone es la primera evaluación formal de un proyecto RUP. Determina si el equipo y el sponsor tienen suficiente claridad sobre el sistema para invertir en Elaboration (architecture development).

**Pregunta central del LCO:** *"¿Sabemos lo suficiente para justificar la inversión en construir la arquitectura?"*

---

## Criterios de evaluación LCO

### Criterio 1: Vision Document aprobado

| Sub-criterio | Evidencia requerida | Red Flag |
|-------------|--------------------|---------:|
| Problem Statement sin causa asumida | Texto del Problem Statement | Menciona tecnología o solución |
| Stakeholders identificados | Lista de stakeholders + roles | Solo el sponsor aparece |
| Scope IN/OUT explícito | Tabla de scope | Scope solo tiene IN, sin OUT |
| Key Features coherentes con el problema | Trazabilidad Problem → Features | Features sin conexión al problema |
| Aprobación de stakeholders clave | Sign-off o acta | Solo el PM aprobó |

### Criterio 2: Business Case aprobado por el sponsor

| Sub-criterio | Evidencia requerida | Red Flag |
|-------------|--------------------|---------:|
| Costo del problema cuantificado | $, tiempo, frecuencia | Solo descripción cualitativa |
| ROI estimado con supuestos | Tabla ROI + supuestos | ROI sin desglose |
| Costo de no hacer nada cuantificado | Cifra o descripción cuantificada | Omitido |
| Sponsor firmó el Business Case | Sign-off del sponsor | Sponsor "todavía está revisando" |

### Criterio 3: Risk List inicial completa

| Sub-criterio | Evidencia requerida | Red Flag |
|-------------|--------------------|---------:|
| Riesgos técnicos identificados | ≥ 1 por integración crítica | Lista vacía de riesgos técnicos |
| Riesgos de negocio identificados | ≥ 1 de scope / stakeholders | Solo riesgos técnicos |
| Probabilidad e impacto evaluados | P×I para cada riesgo | Todos evaluados como "Medio" |
| Plan de respuesta inicial | Al menos "investigar en Elaboration" | Sin plan de respuesta |
| Riesgos cancelatorios identificados | Marcados explícitamente | No identificados |

**Clasificación de riesgos por nivel:**

| Nivel | Definición | Acción en Inception |
|-------|-----------|-------------------|
| **Crítico** | P=Alta + I=Alto | Plan de respuesta obligatorio + owner asignado |
| **Mayor** | P=Alta + I=Medio o P=Media + I=Alto | Plan de respuesta + fase target |
| **Menor** | P=Baja o I=Bajo | Documentar + monitorear |
| **Cancelatorio** | Si ocurre → proyecto no viable | Decisión explícita: continuar o cancelar |

### Criterio 4: Use Case Model ≥ 10%

| Sub-criterio | Evidencia requerida | Red Flag |
|-------------|--------------------|---------:|
| UC arquitecturalmente significativos identificados | Lista de UC con criterio de selección | Solo 1-2 UC genéricos |
| UC de alto riesgo identificados | Justificación del riesgo | Sin conexión al Risk List |
| UC críticos para el BC identificados | Trazabilidad BC → UC | UC sin relación con el Business Case |
| Nombre + actor + objetivo por cada UC | Tabla del UC Model | UC con solo nombre |

> **Nota:** El 10% no es un número exacto — significa que los UC críticos están nombrados y justificados, no que el 10% del flujo está especificado. El flujo completo es trabajo de Elaboration.

### Criterio 5: Recursos disponibles para Elaboration

| Sub-criterio | Evidencia requerida | Red Flag |
|-------------|--------------------|---------:|
| Equipo identificado | Roles + disponibilidad confirmada | "Conseguiremos el equipo pronto" |
| Entorno de desarrollo disponible | Acceso confirmado | Sin entorno de desarrollo |
| Herramientas y licencias | Disponibles o en proceso | Sin proceso de adquisición |
| Sponsor autoriza inicio de Elaboration | Confirmación explícita | Sponsor solo "está de acuerdo en principio" |

---

## Checklist de concurrencia — ¿quiénes deben aprobar el LCO?

| Rol | Aprueba | Criterios que valida |
|-----|---------|---------------------|
| **Sponsor** | Obligatorio | Business Case, Vision a nivel de negocio |
| **Arquitecto / Tech Lead** | Obligatorio | Risk List técnica, factibilidad del Use Case Model |
| **Project Manager** | Obligatorio | Plan inicial, recursos disponibles |
| **Stakeholder líder de negocio** | Obligatorio | Vision Document, Problem Statement |
| **Usuarios representativos** | Recomendado | Key Features coherentes con sus necesidades |
| **Equipo legal / compliance** | Si hay regulación | Constraints regulatorios identificados |

---

## Decisiones típicas en el LCO

### Decisión 1: Avanzar a Elaboration (LCO alcanzado)

**Condición:** Todos los criterios evaluados como ✅ o ⚠️ con plan documentado.

**Acción:** Iniciar `rup:elaboration` con:
- Vision Document v1.0 baseline
- Risk List con top riesgos y planes de respuesta
- Plan inicial de proyecto como punto de partida

### Decisión 2: Nueva iteración de Inception

**Condición:** Al menos 1 criterio evaluado como ❌.

| Causa del ❌ | Acción en la próxima iteración |
|------------|-------------------------------|
| Stakeholders no alineados en la visión | Workshop adicional; mediación si conflicto de intereses |
| Business case rechazado por el sponsor | Revisar ROI, ajustar scope, re-presentar |
| Riesgos críticos sin plan | Spikes de investigación; consultar expertos |
| < 10% UC Model | Entrevistas con usuarios; análisis de dominio |
| Recursos no disponibles | Gestión de recursos; escalar al sponsor |

### Decisión 3: Cancelar el proyecto

**Condición:** Riesgo cancelatorio confirmado O business case negativo confirmado.

| Causa | Documentación requerida |
|-------|------------------------|
| ROI negativo confirmado | Análisis cuantitativo + recomendación de cancelación |
| Riesgo cancelatorio realizado | Descripción del riesgo + impacto confirmado |
| Stakeholders irreconciliables | Registro del desacuerdo + intento de resolución |
| Tecnología inviable | Resultado de spike técnico |

---

## Límites de tiempo para Inception

| Tamaño del proyecto | Iteraciones de Inception | Duración total Inception |
|--------------------|------------------------|-------------------------|
| Pequeño (< 6 meses) | 1 iteración | 1-2 semanas |
| Mediano (6-18 meses) | 1-2 iteraciones | 2-4 semanas |
| Grande (> 18 meses) | 1-3 iteraciones | 4-8 semanas |

> **Regla del 10%:** Inception no debe superar el 10% del esfuerzo total del proyecto.
> Si se supera, el problema es falta de claridad en el negocio o falta de acceso a stakeholders — no falta de análisis técnico.

---

## Señales de LCO fallido (post-hoc)

Señales de que Inception fue insuficiente, visibles en Elaboration:

| Señal en Elaboration | Causa probable en Inception |
|---------------------|---------------------------|
| Scope crece significativamente en la primera semana | Vision Document demasiado vago |
| Arquitecto no puede empezar el SAD | Use Case Model insuficiente para guiar la arquitectura |
| Sponsor cuestiona el Business Case en Elaboration | Business Case no fue validado en profundidad |
| Riesgos críticos sin plan bloquean el Architecture Prototype | Risk List incompleta |
| Equipo espera semanas para tener entorno de desarrollo | Recursos no verificados en Inception |
