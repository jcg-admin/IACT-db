---
id: TASK-REORG-BACK-043
tipo: tarea
categoria: plantillas
titulo: Crear plantilla-adr-backend.md
fase: FASE_3
prioridad: ALTA
duracion_estimada: 20min
estado: pendiente
dependencias: []
metodologia: Auto-CoT, Self-Consistency
---

# TASK-REORG-BACK-043: Crear plantilla-adr-backend.md

**Fase:** FASE 3 - Plantillas y Documentacion Estructurada
**Prioridad:** ALTA
**Duracion Estimada:** 20 minutos
**Responsable:** Tech Writer
**Estado:** PENDIENTE
**Metodologia:** Auto-CoT (Auto-Chain of Thought), Self-Consistency

---

## Objetivo

Crear una plantilla estandarizada para Architecture Decision Records (ADR) especifica para decisiones de arquitectura del backend, permitiendo documentar decisiones tecnicas de manera consistente y trazable.

---

## Auto-CoT: Razonamiento en Cadena

### Paso 1: Analizar necesidades de ADR backend
**Pregunta:** ¿Que elementos son criticos en un ADR de backend?
**Razonamiento:**
- Contexto tecnico (frameworks, patrones, infraestructura)
- Decisiones de arquitectura (monolito vs microservicios, base de datos, APIs)
- Trade-offs especificos del backend (performance, escalabilidad, seguridad)
- Impacto en CI/CD y deployment

### Paso 2: Identificar componentes clave
**Pregunta:** ¿Que secciones debe tener la plantilla?
**Razonamiento:**
- Metadata (ID, fecha, estado, autores)
- Contexto y problema
- Opciones consideradas
- Decision tomada con justificacion
- Consecuencias (positivas y negativas)
- Referencias y validaciones

### Paso 3: Validar con Self-Consistency
**Perspectiva 1 - Arquitecto:** Necesita ver trade-offs tecnicos claros
**Perspectiva 2 - Desarrollador:** Necesita entender el "por que" de la decision
**Perspectiva 3 - DevOps:** Necesita conocer impacto en infraestructura
**Consenso:** La plantilla debe ser completa pero concisa, con enfasis en justificacion y consecuencias

---

## Prerequisitos

- [ ] Acceso a docs/backend/arquitectura/decisions/
- [ ] Revision de ADRs existentes en el proyecto
- [ ] Conocimiento de estandar ADR (Michael Nygard)
- [ ] Comprension de stack tecnologico del backend

---

## Pasos de Ejecucion

### Paso 1: Investigar Estructura ADR Estandar
```bash
# Buscar ADRs existentes en el proyecto
find /home/user/IACT -name "*adr*.md" -o -name "*decision*.md"

# Revisar ejemplos de ADR en comunidad
# https://github.com/joelparkerhenderson/architecture-decision-record
```

**Resultado Esperado:** Lista de ADRs existentes y ejemplos de referencia

### Paso 2: Definir Estructura de Plantilla
Crear estructura con secciones:
1. **Metadata:** ID, fecha, estado, autores, tags
2. **Titulo:** Descripcion corta de la decision
3. **Contexto:** Situacion y fuerzas que motivan la decision
4. **Opciones Consideradas:** Alternativas evaluadas con pros/cons
5. **Decision:** Opcion elegida y justificacion detallada
6. **Consecuencias:** Impactos positivos, negativos y riesgos
7. **Validacion:** Como se valida la decision
8. **Referencias:** Links, documentos, discusiones

**Resultado Esperado:** Esquema claro de la plantilla

### Paso 3: Crear Archivo plantilla-adr-backend.md
```bash
# Ubicacion objetivo
touch /home/user/IACT/docs/backend/arquitectura/decisions/plantilla-adr-backend.md
```

Contenido de la plantilla (usar formato Markdown con frontmatter):
```markdown
---
id: ADR-XXX
fecha: YYYY-MM-DD
estado: [propuesta|aceptada|rechazada|deprecada|reemplazada]
autores: [nombre1, nombre2]
tags: [backend, arquitectura, categoria-especifica]
reemplaza: ADR-YYY (opcional)
reemplazado_por: ADR-ZZZ (opcional)
---

# ADR-XXX: [Titulo Descriptivo de la Decision]

## Estado
**PROPUESTA** | ACEPTADA | RECHAZADA | DEPRECADA | REEMPLAZADA

Fecha: YYYY-MM-DD
Autores: [nombres]
Revisores: [nombres]

---

## Contexto

### Problema
[Descripcion clara del problema o necesidad que motiva esta decision]

### Fuerzas en Juego
- [Fuerza tecnica 1: ej. necesidad de escalabilidad]
- [Fuerza de negocio 1: ej. time-to-market]
- [Restriccion 1: ej. presupuesto, equipo]
- [Consideracion de seguridad/compliance]

### Antecedentes
[Decisiones previas relacionadas, contexto historico del proyecto]

---

## Opciones Consideradas

### Opcion 1: [Nombre de la Opcion]
**Descripcion:** [Breve descripcion de esta alternativa]

**Pros:**
- [Ventaja 1]
- [Ventaja 2]

**Cons:**
- [Desventaja 1]
- [Desventaja 2]

**Complejidad:** BAJA | MEDIA | ALTA
**Costo:** $ | $$ | $$$
**Tiempo de Implementacion:** [estimacion]

### Opcion 2: [Nombre de la Opcion]
[Repetir estructura...]

### Opcion 3: [Nombre de la Opcion]
[Repetir estructura...]

---

## Decision

**Opcion Elegida:** [Nombre de la opcion seleccionada]

### Justificacion
[Explicacion detallada de POR QUE se eligio esta opcion sobre las otras.
Debe incluir:
- Analisis de trade-offs
- Alineacion con objetivos del proyecto
- Consideraciones de largo plazo
- Factores que inclinaron la balanza]

### Supuestos
- [Supuesto 1: condicion que asumimos verdadera]
- [Supuesto 2: ej. "el trafico no superara X req/seg en 2 anos"]

### Restricciones
- [Restriccion 1: limitacion tecnica o de negocio]
- [Restriccion 2: ej. "debe ser compatible con sistema legacy X"]

---

## Consecuencias

### Positivas
- [Beneficio 1: ej. "mejora performance en 40%"]
- [Beneficio 2: ej. "reduce complejidad de deployment"]
- [Beneficio 3: ej. "facilita testing"]

### Negativas
- [Costo 1: ej. "aumenta dependencias externas"]
- [Costo 2: ej. "requiere capacitacion del equipo"]
- [Costo 3: ej. "lock-in con proveedor X"]

### Riesgos
| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| [Riesgo 1] | BAJA/MEDIA/ALTA | BAJO/MEDIO/ALTO | [Plan de mitigacion] |
| [Riesgo 2] | ... | ... | ... |

### Impacto en Componentes

#### Backend
- [Cambio en modulo X]
- [Nuevo servicio Y]

#### Base de Datos
- [Migracion de esquema]
- [Nuevas tablas/indices]

#### CI/CD
- [Cambios en pipeline]
- [Nuevos jobs de testing]

#### Infraestructura
- [Recursos adicionales necesarios]
- [Cambios en configuracion]

---

## Plan de Implementacion

### Fase 1: Preparacion
- [ ] [Tarea 1]
- [ ] [Tarea 2]

### Fase 2: Desarrollo
- [ ] [Tarea 3]
- [ ] [Tarea 4]

### Fase 3: Testing y Validacion
- [ ] [Tarea 5]
- [ ] [Tarea 6]

### Fase 4: Deployment
- [ ] [Tarea 7]
- [ ] [Tarea 8]

**Duracion Estimada:** [X semanas/sprints]
**Recursos Necesarios:** [personas, infraestructura, presupuesto]

---

## Validacion

### Criterios de Exito
- [ ] [Metrica 1: ej. "latencia p95 < 200ms"]
- [ ] [Metrica 2: ej. "0 errores criticos en produccion por 30 dias"]
- [ ] [Metrica 3: ej. "cobertura de tests > 80%"]

### Metricas de Monitoreo
- [Metrica tecnica 1: ej. throughput, latencia]
- [Metrica de negocio 1: ej. conversion, satisfaccion usuario]
- [Metrica de calidad 1: ej. error rate, uptime]

### Plan de Rollback
```bash
# Pasos para revertir la decision si falla
[Comando 1]
[Comando 2]
```

**Condiciones de Rollback:**
- [Condicion 1: ej. "si error rate > 5%"]
- [Condicion 2: ej. "si latencia p99 > 1s"]

---

## Referencias

### Documentacion Tecnica
- [Link a RFC, documentacion oficial, etc.]
- [Link a issue/ticket relacionado]

### Discusiones
- [Link a discussion en GitHub/Slack]
- [Link a meeting notes]

### ADRs Relacionados
- ADR-XXX: [Titulo - relacion]
- ADR-YYY: [Titulo - relacion]

### Recursos Externos
- [Blog post, paper, conferencia]
- [Ejemplo de implementacion en otro proyecto]

---

## Anexos

### Diagramas
[Incluir o linkear diagramas de arquitectura, flujo, etc.]

### Benchmarks
[Incluir resultados de pruebas de performance, comparativas]

### Analisis de Costos
[Desglose financiero si aplica]

---

## Historial de Cambios

| Fecha | Autor | Cambio | Version |
|-------|-------|--------|---------|
| YYYY-MM-DD | [Nombre] | Creacion inicial | 0.1 |
| YYYY-MM-DD | [Nombre] | Revision tras feedback | 0.2 |
| YYYY-MM-DD | [Nombre] | Aceptada | 1.0 |

---

## Notas

[Cualquier nota adicional, consideraciones especiales, lecciones aprendidas]

---

**Documento creado:** YYYY-MM-DD
**Ultima actualizacion:** YYYY-MM-DD
**Version:** 1.0.0
**Estado:** PROPUESTA
```

**Resultado Esperado:** Archivo plantilla-adr-backend.md creado en docs/backend/arquitectura/decisions/

### Paso 4: Validar Plantilla con Self-Consistency

Validar desde multiples perspectivas:

```bash
# Perspectiva 1: Arquitecto de Software
# ¿La plantilla cubre trade-offs tecnicos?
# ¿Permite evaluar opciones objetivamente?

# Perspectiva 2: Tech Lead
# ¿Es suficientemente detallada para decision-making?
# ¿Incluye plan de implementacion realista?

# Perspectiva 3: Desarrollador
# ¿Es clara y facil de seguir?
# ¿Proporciona contexto suficiente?

# Perspectiva 4: DevOps
# ¿Considera impacto en infraestructura y CI/CD?
# ¿Incluye plan de rollback?
```

**Resultado Esperado:** Plantilla validada desde 4 perspectivas, ajustes realizados

### Paso 5: Crear README en carpeta decisions/
```bash
# Crear README explicando uso de ADRs
cat > /home/user/IACT/docs/backend/arquitectura/decisions/README.md << 'EOF'
# Architecture Decision Records (ADR) - Backend

Registro de decisiones arquitectonicas importantes del backend.

## Como Usar

1. Copiar `plantilla-adr-backend.md`
2. Renombrar a `ADR-XXX-titulo-descriptivo.md`
3. Completar todas las secciones
4. Someter a revision
5. Actualizar estado tras decision

## Numeros de ADR

Formato: ADR-001, ADR-002, etc.
Ver ultimo ADR para siguiente numero.

## Estados

- PROPUESTA: En discusion
- ACEPTADA: Aprobada e implementada
- RECHAZADA: No se implementara
- DEPRECADA: Ya no aplica
- REEMPLAZADA: Sustituida por ADR-XXX
EOF
```

**Resultado Esperado:** README creado explicando workflow de ADRs

### Paso 6: Testear Plantilla con ADR de Ejemplo
```bash
# Crear un ADR de ejemplo usando la plantilla
# ADR-000-ejemplo-uso-plantilla.md
```

**Resultado Esperado:** ADR de ejemplo creado validando que la plantilla funciona

---

## Criterios de Exito

- [ ] Archivo plantilla-adr-backend.md creado en docs/backend/arquitectura/decisions/
- [ ] Plantilla incluye todas las secciones: metadata, contexto, opciones, decision, consecuencias, validacion, referencias
- [ ] Frontmatter YAML con campos: id, fecha, estado, autores, tags
- [ ] Seccion de "Opciones Consideradas" con pros/cons estructurados
- [ ] Seccion de "Consecuencias" con impactos positivos, negativos y riesgos
- [ ] Plan de implementacion con fases
- [ ] Criterios de validacion y metricas de exito
- [ ] Plan de rollback documentado
- [ ] README.md creado en carpeta decisions/ explicando workflow
- [ ] Plantilla validada con Self-Consistency desde 4 perspectivas
- [ ] ADR de ejemplo creado usando la plantilla

---

## Validacion

```bash
# Verificar que plantilla existe
ls -lh /home/user/IACT/docs/backend/arquitectura/decisions/plantilla-adr-backend.md

# Verificar estructura del archivo
grep -E "^##|^---" /home/user/IACT/docs/backend/arquitectura/decisions/plantilla-adr-backend.md

# Contar secciones principales (debe tener ~10)
grep "^## " /home/user/IACT/docs/backend/arquitectura/decisions/plantilla-adr-backend.md | wc -l

# Verificar frontmatter YAML
head -10 /home/user/IACT/docs/backend/arquitectura/decisions/plantilla-adr-backend.md | grep -E "^(id|fecha|estado|autores|tags):"

# Verificar README
cat /home/user/IACT/docs/backend/arquitectura/decisions/README.md
```

**Salida Esperada:** Archivo existe, tiene ~10 secciones, frontmatter valido, README presente

---

## Riesgos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|-----------|
| Plantilla demasiado compleja | MEDIA | MEDIO | Simplificar secciones opcionales, marcar campos requeridos vs opcionales |
| No se usa en la practica | ALTA | ALTO | Crear ADR de ejemplo, educar al equipo, incluir en DoD de decisiones arquitectonicas |
| Inconsistencia con ADRs existentes | MEDIA | BAJO | Migrar ADRs viejos gradualmente, documentar diferencias |

---

## Evidencias a Capturar

1. Archivo `plantilla-adr-backend.md` completo
2. README.md en carpeta decisions/
3. ADR de ejemplo (ADR-000)
4. Validacion desde 4 perspectivas (documento o checklist)
5. Screenshot de estructura de carpeta

---

## Notas

- Plantilla basada en formato ADR de Michael Nygard con extensiones para backend
- Usar Auto-CoT para razonar sobre que secciones incluir
- Validar con Self-Consistency desde perspectivas: Arquitecto, Tech Lead, Desarrollador, DevOps
- La plantilla debe ser viviente: actualizar segun feedback del equipo
- Considerar integrar ADRs en proceso de code review
- Los ADRs son INMUTABLES una vez aceptados (solo se pueden deprecar o reemplazar)

---

## Referencias Auto-CoT

**Chain 1 - Arquitectura:**
¿Que decisiones arquitectonicas necesitan documentarse? → Decisiones con impacto de largo plazo → Requieren contexto, opciones, justificacion → ADR es el formato ideal

**Chain 2 - Colaboracion:**
¿Como asegurar que el equipo use ADRs? → Plantilla clara y concisa → Ejemplos de uso → Integracion en workflow → Adopcion natural

**Chain 3 - Mantenibilidad:**
¿Como mantener ADRs actualizados? → ADRs son inmutables → Nuevas decisiones deprecan/reemplazan anteriores → Historial de decisiones trazable

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos
**Desviacion vs Estimado:** +/- __ minutos

---

## Checklist de Finalizacion

- [ ] plantilla-adr-backend.md creado con estructura completa
- [ ] Frontmatter YAML validado
- [ ] Todas las secciones documentadas con ejemplos
- [ ] README.md en carpeta decisions/ creado
- [ ] ADR de ejemplo (ADR-000) creado
- [ ] Validacion Self-Consistency desde 4 perspectivas completada
- [ ] Plantilla revisada por al menos 1 arquitecto
- [ ] Tarea marcada como COMPLETADA en INDICE.md

---

**Tarea creada:** 2025-11-18
**Ultima actualizacion:** 2025-11-18
**Version:** 1.0.0
**Estado:** PENDIENTE
