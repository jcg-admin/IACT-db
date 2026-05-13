---
id: PROC-INFRA-004
tipo: proceso
categoria: infraestructura
subcategoria: change_management
version: 1.0.0
fecha_creacion: 2025-11-18
autor: Claude Code (Haiku 4.5)
estado: activo
aprobado_por: pendiente
relacionados: ["PROC-INFRA-001", "PROC-INFRA-002", "PROC-INFRA-003", "PROC-INFRA-005"]
---

# PROCESO: Gestión de Cambios de Infraestructura

## Objetivo

Definir el flujo formal para proponer, revisar, autorizar, implementar y validar cambios en infraestructura, minimizando riesgos de disrupciones, asegurando trazabilidad completa, y manteniendo documentación actualizada de la infraestructura actual.

---

## Propósito (QUÉ)

Establecer un proceso controlado para:

1. **Proponer** cambios de infraestructura con justificación clara
2. **Analizar** impacto y riesgos de cambios
3. **Planificar** implementación y rollback
4. **Autorizar** cambios según políticas de control
5. **Implementar** cambios en forma controlada
6. **Validar** que cambios fueron exitosos
7. **Documentar** cambios aplicados
8. **Aprender** de cambios para mejora continua

Este es un proceso de **nivel estratégico/operativo** (alto nivel). Para detalles técnicos (CÓMO), ver procedimientos relacionados.

---

## Alcance

### Incluye

- **Cambios planificados**: Updates de dependencias, nueva infraestructura, reconfiguración
- **Cambios emergentes**: Hotfixes de seguridad, parches críticos
- **Todos los componentes**: VMs, DevContainers, Networking, Storage, Configuración
- **Ciclo completo**: Propuesta → Análisis → Autorización → Implementación → Validación → Documentación
- **Trazabilidad**: Registro de cambios, quien, cuándo, por qué, qué
- **Rollback planning**: Procedimientos para revertir si es necesario
- **Comunicación**: Notificaciones a equipos afectados

### NO Incluye

- **Emergencias críticas**: Fire-fighting de incidents (ver PROC-INCIDENT-RESPONSE)
- **Monitoreo post-cambio**: Responsabilidad de PROC-INFRA-005
- **Capacidad de hardware**: Ver PROC-GOBERNANZA-INFRA
- **Política de cambios**: Definida en PROC-GOBERNANZA-CAMBIOS (por crear)
- **Seguridad avanzada**: Ver PROC-SEGURIDAD-INFRA

---

## Roles y Responsabilidades

### Developer / Solicitante (Propone cambio)

**Responsabilidades**:
- Identificar necesidad de cambio
- Completar formulario de cambio
- Justificar con claridad
- Estimar impacto
- Proporcionar detalles técnicos
- Participar en validación post-cambio

**Frecuencia**: Ocasional (cuando identifica necesidad)

---

### DevOps Engineer (Implementador)

**Responsabilidades**:
- Analizar factibilidad técnica
- Planificar implementación
- Ejecutar cambio según plan
- Validar que cambio exitoso
- Documentar pasos realizados
- Comunicar status
- Ejecutar rollback si es necesario

**Frecuencia**: Continua

---

### Tech Lead / Infrastructure Manager (Aprobador)

**Responsabilidades**:
- Revisar solicitud de cambio
- Evaluar impacto en equipo
- Aprobar o rechazar cambio
- Autorizar cambios de alto riesgo
- Resolver conflicts
- Revisar este proceso

**Frecuencia**: Variable (1-5 cambios por semana típicamente)

---

### CTO / Director de Ingeniería (Autoridad final)

**Responsabilidades**:
- Aprobar cambios de muy alto riesgo
- Revisar cambios que afecten múltiples equipos
- Autorizar cambios con downtime esperado
- Aprobar excepciones a políticas

**Frecuencia**: Raro (cambios mayores solamente)

---

## Entradas (Inputs)

### Solicitud de Cambio

1. **Formulario de Cambio** con:
   - Descripción clara del cambio
   - Justificación técnica o negocio
   - Componentes afectados
   - Fecha/ventana propuesta
   - Duración estimada
   - Impacto esperado
   - Plan de rollback

2. **Documentación Técnica**:
   - Especificaciones de cambio
   - Configuración nueva
   - Scripts de provisión
   - Documentación de validación

3. **Contexto**:
   - Estado actual de infraestructura
   - Dependencias existentes
   - Usuarios/equipos afectados
   - Políticas de cambios

---

## Salidas (Outputs)

### Cambio Implementado y Documentado

1. **Cambio Ejecutado**:
   - Infraestructura actualizada
   - Configuración aplicada
   - Validación completada
   - Monitoreo activo

2. **Documentación de Cambio**:
   - Registro formal de cambio
   - Pasos ejecutados
   - Resultados de validación
   - Fecha y hora del cambio
   - Responsable de ejecución

3. **Comunicación**:
   - Notificación a equipos afectados
   - Documentación de usuario si aplica
   - Status en dashboard de cambios

4. **Aprendizaje**:
   - Issues encontrados y resueltos
   - Oportunidades de mejora
   - Documentación de lecciones aprendidas

---

## FLUJO DEL PROCESO

### ETAPA 1: PROPUESTA E IDENTIFICACIÓN

**Objetivo**: Capturar solicitud de cambio con detalles suficientes

**Duración estimada**: 1-2 horas

**Actividades**:

1. **Identificar Necesidad de Cambio**
   - Developer/DevOps identifica que algo necesita cambiar
   - Puede ser: security patch, nueva feature, optimización, deprecación
   - Documenta necesidad inicial

2. **Completar Formulario de Cambio**
   - Descripción clara (1-3 párrafos)
   - Justificación (por qué es necesario)
   - Componentes afectados (VM, DevContainer, etc.)
   - Fecha propuesta y ventana de tiempo
   - Duración estimada de implementación
   - Impacto esperado en equipo
   - Plan preliminar de rollback

3. **Categorizar Cambio**
   - **CRITICAL**: Seguridad crítica, downtime esperado
   - **MAJOR**: Feature nueva, cambio significativo
   - **MINOR**: Optimización, actualización de versión
   - **STANDARD**: Cambio rutinario, bajo riesgo

4. **Asignación Inicial**
   - Asignar a DevOps Lead como propietario de cambio
   - Registrar en sistema de tracking (GitHub issues, Jira, etc.)
   - Crear timeline de cambio

**Criterios de Salida**:
- [ ] Solicitud completada con todos los detalles
- [ ] Categoría asignada
- [ ] Propietario designado
- [ ] Registrado en sistema de tracking

**Procedimientos Relacionados**:
- PROCED-CREAR-SOLICITUD-CAMBIO-001

---

### ETAPA 2: ANÁLISIS E IMPACTO

**Objetivo**: Evaluar viabilidad, riesgos e impacto del cambio

**Duración estimada**: 1-4 horas

**Actividades**:

1. **Análisis Técnico**
   - Revisar cambio propuesto en detalle
   - Identificar dependencias (qué más podría afectar)
   - Evaluar complejidad de implementación
   - Identificar recursos necesarios
   - Revisar precedentes (¿se ha hecho antes?)

2. **Análisis de Riesgos**
   - Identificar riesgos potenciales
   - Evaluar probabilidad y impacto de cada riesgo
   - Calificar riesgo general (bajo/medio/alto)
   - Proponer mitigaciones

3. **Análisis de Impacto**
   - Identificar equipos afectados
   - Evaluar downtime esperado
   - Impacto en desarrollo (¿rompe código?)
   - Impacto en testing/CI
   - Impacto en usuarios finales

4. **Validación de Factibilidad**
   - ¿Tenemos los recursos necesarios?
   - ¿Tenemos las herramientas?
   - ¿Hay versión compatible disponible?
   - ¿Impacto en timeline del proyecto?

5. **Plan Detallado de Rollback**
   - Pasos específicos para revertir
   - Criterios para ejecutar rollback
   - Tiempo estimado de rollback
   - Validación post-rollback

6. **Documentar Análisis**
   - Resumen de análisis
   - Riesgos y mitigaciones identificados
   - Impacto estimado
   - Recomendación (proceder/posponer/rechazar)

**Criterios de Salida**:
- [ ] Análisis técnico completado
- [ ] Riesgos identificados y mitigados
- [ ] Impacto estimado y comunicado
- [ ] Factibilidad confirmada
- [ ] Plan de rollback detallado
- [ ] Recomendación documentada

**Procedimientos Relacionados**:
- PROCED-ANALIZAR-IMPACTO-CAMBIO-001
- PROCED-EVALUAR-RIESGOS-001

---

### ETAPA 3: AUTORIZACIÓN Y APROBACIÓN

**Objetivo**: Obtener aprobaciones requeridas según política

**Duración estimada**: 30 minutos - 2 días

**Actividades**:

1. **Cadena de Aprobación**
   - **MINOR**: Aprobación de Tech Lead suficiente
   - **MAJOR**: Tech Lead + CTO
   - **CRITICAL**: Tech Lead + CTO + Director
   - **Security hotfix**: Solo DevOps Lead (post-mortem después)

2. **Revisión de Aprobadores**
   - Revisar análisis de riesgos
   - Validar plan de rollback
   - Evaluar impacto en equipo
   - Hacer preguntas si es necesario

3. **Decisión Final**
   - [COMPLETADO] **APROBADO**: Proceder a implementación
   - ⏸️ **APROBADO CON CONDICIONES**: Requiere cambios
   - ⏹️ **RECHAZADO**: Explicar razones, proponer alternativa

4. **Registro de Aprobación**
   - Guardar evidencia de aprobaciones
   - Timestamp de cada aprobación
   - Comentarios de aprobadores
   - Fecha autorizada para ejecución

**Criterios de Salida**:
- [ ] Aprobaciones requeridas obtenidas
- [ ] Cambios (si los hay) documentados
- [ ] Fecha de ejecución confirmada
- [ ] Equipos afectados notificados (información preliminar)

**Procedimientos Relacionados**:
- PROCED-SOLICITAR-APROBACION-CAMBIO-001

---

### ETAPA 4: PLANIFICACIÓN Y COMUNICACIÓN

**Objetivo**: Coordinar ejecución del cambio y comunicar a impactados

**Duración estimada**: 1-2 horas

**Actividades**:

1. **Planificación Detallada**
   - Crear plan paso-a-paso de ejecución
   - Incluir validación después de cada paso crítico
   - Definir puntos de no retorno
   - Estimar duración real
   - Asignar responsables de cada paso

2. **Preparación de Ambiente**
   - Pre-staging de cambios (si aplica)
   - Preparar scripts de ejecución
   - Validar que todos los recursos están listos
   - Backup final si es necesario

3. **Ventana de Cambio**
   - Reservar ventana de tiempo acordada
   - Notificar a todos los stakeholders
   - Coordinar con otros equipos
   - Asegurar que on-call disponible

4. **Comunicación a Equipos Afectados**
   - Email detallado con:
     - Qué se va a cambiar
     - Cuándo (fecha y hora exacta)
     - Cuánto tiempo durará
     - Qué impacto esperado
     - Plan de rollback si falla
     - Punto de contacto durante ventana

5. **Preparación de Equipo**
   - Briefing final de equipo implementador
   - Revisar plan juntos
   - Resolver dudas
   - Confirmar que alguien documentará en tiempo real

**Criterios de Salida**:
- [ ] Plan detallado de ejecución
- [ ] Ambiente preparado
- [ ] Ventana reservada
- [ ] Equipos notificados
- [ ] Equipo ready para ejecutar

**Procedimientos Relacionados**:
- PROCED-PLANIFICAR-CAMBIO-001
- PROCED-COMUNICAR-CAMBIO-001

---

### ETAPA 5: IMPLEMENTACIÓN

**Objetivo**: Ejecutar cambio según plan

**Duración estimada**: Variable (30 min - varios horas)

**Actividades**:

1. **Inicio de Ventana**
   - Confirmar que ventana está abierta
   - Notificar a stakeholders que ejecución inicia
   - Comenzar documentación en tiempo real
   - Monitoreo intensivo activo

2. **Ejecución Paso-a-Paso**
   - Ejecutar cada paso del plan
   - Validar antes de continuar al siguiente
   - Documentar cualquier desviación
   - Comunicar progress cada X minutos

3. **Monitoreo en Vivo**
   - Revisar logs constantemente
   - Monitorear recursos (CPU, disk, memoria)
   - Alertas activadas
   - Persona designada monitoreando sistema

4. **Manejo de Problemas**
   - Si problema menor: intentar solucionar (si plan permite)
   - Si problema mayor: ejecutar rollback
   - Documentar problema y resolución
   - Comunicar a stakeholders

5. **Validación Básica**
   - Confirmar cambio aplicado
   - Health checks iniciales
   - Verificación visual de configuración
   - Confirmación de que sistema respondiendo

6. **Cierre de Ventana**
   - Documentar que ejecución completada
   - Timestamp final
   - Resumen de pasos ejecutados
   - Status general (exitoso/parcial/rollback)

**Criterios de Salida**:
- [ ] Cambio ejecutado según plan
- [ ] Health checks básicos pasando
- [ ] Documentación en tiempo real completada
- [ ] Status comunicado
- [ ] Rollback NOT ejecutado

**Procedimientos Relacionados**:
- PROCED-EJECUTAR-CAMBIO-INFRA-001

---

### ETAPA 6: VALIDACIÓN POST-CAMBIO

**Objetivo**: Verificar que cambio es funcional y sin efectos negativos

**Duración estimada**: 2-4 horas (puede ser más larga)

**Actividades**:

1. **Health Checks Intensivos**
   - Ejecutar todos los health checks relevantes
   - Verificar conectividad de servicios
   - Validar que datos no fueron corruptados
   - Revisar logs de aplicación para errores

2. **Funcionalidad**
   - Verificar que funcionalidad esperada funciona
   - Testing manual de casos críticos
   - Validar que integraciones todavía funcionan
   - Si aplica: developer testing

3. **Performance**
   - Comparar performance vs baseline
   - Revisar CPU/RAM/Disk utilización
   - Validar que tiempos de respuesta aceptables
   - Alertar si degradación significativa

4. **Regresión**
   - Verificar que no se rompió nada más
   - Casos de uso críticos validados
   - Tests automatizados ejecutados
   - Funcionalidad antigua sigue funcionando

5. **Documentación de Validación**
   - Reporte de validación completado
   - Screenshots/evidencia de health checks
   - Resultados de tests
   - Comparativa con baseline

**Criterios de Salida**:
- [ ] Health checks pasando
- [ ] Funcionalidad validada
- [ ] Sin regresiones detectadas
- [ ] Performance aceptable
- [ ] Validación documentada

**Procedimientos Relacionados**:
- PROCED-VALIDAR-CAMBIO-INFRA-001

---

### ETAPA 7: DOCUMENTACIÓN Y REGISTRO

**Objetivo**: Asegurar que cambio esté completamente documentado

**Duración estimada**: 1 hora

**Actividades**:

1. **Registro Formal de Cambio**
   - Crear/actualizar registro de cambios
   - Incluir:
     - ID de cambio único
     - Descripción completa
     - Fecha y hora de ejecución
     - Duración total
     - Responsable de ejecución
     - Status final (éxito/parcial/rollback)

2. **Documentación de Infraestructura**
   - Actualizar versiones documentadas
   - Actualizar configuraciones (si public)
   - Actualizar diagrama de infraestructura
   - Actualizar matriz de responsables

3. **Changelog**
   - Actualizar CHANGELOG.md con entrada
   - Incluir link a registro de cambio
   - Versión del cambio (si aplica)
   - Impacto de cambio

4. **Comunicación Final**
   - Enviar summary a todos los stakeholders
   - Agradecer por su paciencia
   - Informar de cualquier follow-up work
   - Solicitar feedback

5. **Cierre de Tickets**
   - Cerrar solicitud de cambio en sistema de tracking
   - Cerrar relacionados (implementación, testing, etc.)
   - Archivar documentación temporaria
   - Documentar lecciones aprendidas

**Criterios de Salida**:
- [ ] Cambio registrado formalmente
- [ ] Infraestructura documentada actualizada
- [ ] CHANGELOG actualizado
- [ ] Equipo notificado
- [ ] Tickets cerrados

**Procedimientos Relacionados**:
- PROCED-DOCUMENTAR-CAMBIO-001

---

### ETAPA 8: MEJORA CONTINUA Y APRENDIZAJE

**Objetivo**: Capturar lecciones para mejorar próximos cambios

**Duración estimada**: 1-2 horas (post-cambio)

**Actividades**:

1. **Retrospectiva de Cambio**
   - Reunir equipo que ejecutó cambio
   - Qué salió bien
   - Qué podría mejorar
   - Problemas encontrados y soluciones
   - Tiempo real vs estimado

2. **Análisis de Riesgos Realizados**
   - ¿Riesgos predichos se materializaron?
   - ¿Hay riesgos nuevos no anticipados?
   - ¿Mitigaciones fueron efectivas?
   - Actualizar matriz de riesgos

3. **Oportunidades de Automatización**
   - ¿Hay pasos manuales que podrían automatizarse?
   - ¿Hay validaciones que se repetirán?
   - Crear tareas para automatización futura

4. **Mejora de Documentación**
   - Actualizar procedimientos si es necesario
   - Mejorar plan para próximos cambios similares
   - Documentar decisiones tomadas
   - Crear checklist de lecciones aprendidas

5. **Comunicación de Lecciones**
   - Compartir con equipo en próxima reunión
   - Actualizar guías internas
   - Entrenar a nuevos miembros con lecciones
   - Archivar en knowledge base

**Criterios de Salida**:
- [ ] Retrospectiva completada
- [ ] Lecciones documentadas
- [ ] Oportunidades de mejora identificadas
- [ ] Documentación actualizada
- [ ] Equipo informado

**Procedimientos Relacionados**:
- PROCED-RETROSPECTIVA-CAMBIO-001

---

## DIAGRAMA DE FLUJO

```
┌────────────────────────────────────────────────────────────┐
│      GESTIÓN DE CAMBIOS DE INFRAESTRUCTURA - FLUJO         │
└────────────────────────────────────────────────────────────┘

              [Developer / DevOps]
                       │
            Identifica necesidad de cambio
                       │
                       ▼
      ┌────────────────────────────────────┐
      │ ETAPA 1: PROPUESTA E IDENTIFICACIÓN│
      │ - Completar formulario             │
      │ - Categorizar cambio               │
      │ - Asignar propietario              │
      └────────────────────────────────────┘
                       │
                       ▼
      ┌────────────────────────────────────┐
      │ ETAPA 2: ANÁLISIS E IMPACTO        │
      │ - Análisis técnico                 │
      │ - Evaluación de riesgos            │
      │ - Análisis de impacto              │
      │ - Plan de rollback                 │
      └────────────────────────────────────┘
                       │
                       ▼
      ┌────────────────────────────────────┐
      │ ETAPA 3: AUTORIZACIÓN Y APROBACIÓN │
      │ - Cadena de aprobación             │
      │ - Revisión de riesgos              │
      │ - Decisión final                   │
      └────────────────────────────────────┘
                       │
              ¿Cambio aprobado?
              ├─ NO ──► Rechazado (fin)
              │
              └─ SÍ ──► Continuar
                       │
                       ▼
      ┌────────────────────────────────────┐
      │ ETAPA 4: PLANIFICACIÓN             │
      │ - Plan detallado de ejecución      │
      │ - Preparación de ambiente          │
      │ - Comunicación a stakeholders      │
      │ - Equipo ready                     │
      └────────────────────────────────────┘
                       │
                       ▼
      ┌────────────────────────────────────┐
      │ ETAPA 5: IMPLEMENTACIÓN            │
      │ - Ejecutar cambio paso-a-paso      │
      │ - Monitoreo en vivo                │
      │ - Manejo de problemas              │
      │ - Documentación en tiempo real     │
      └────────────────────────────────────┘
                       │
              ¿Implementación OK?
              ├─ NO ──► Ejecutar rollback
              │
              └─ SÍ ──► Continuar
                       │
                       ▼
      ┌────────────────────────────────────┐
      │ ETAPA 6: VALIDACIÓN POST-CAMBIO    │
      │ - Health checks intensivos         │
      │ - Validar funcionalidad            │
      │ - Performance checks               │
      │ - Testing de regresión             │
      └────────────────────────────────────┘
                       │
              ¿Validación OK?
              ├─ NO ──► Ejecutar rollback
              │
              └─ SÍ ──► Continuar
                       │
                       ▼
      ┌────────────────────────────────────┐
      │ ETAPA 7: DOCUMENTACIÓN Y REGISTRO  │
      │ - Registro formal de cambio        │
      │ - Documentación de infra           │
      │ - Actualizar CHANGELOG             │
      │ - Comunicación final               │
      └────────────────────────────────────┘
                       │
                       ▼
      ┌────────────────────────────────────┐
      │ ETAPA 8: MEJORA CONTINUA           │
      │ - Retrospectiva                    │
      │ - Lecciones aprendidas             │
      │ - Oportunidades de automatización  │
      │ - Actualizar documentación         │
      └────────────────────────────────────┘
                       │
                       ▼
                [Cambio Completado [COMPLETADO]]
```

---

## CRITERIOS DE ENTRADA Y SALIDA POR ETAPA

| Etapa | Criterio de Entrada | Criterio de Salida |
|-------|---------------------|-------------------|
| 1. Propuesta | Necesidad identificada | Solicitud completada, registrada |
| 2. Análisis | Solicitud registrada | Análisis completado, riesgos identificados |
| 3. Autorización | Análisis completado | Aprobaciones obtenidas, fecha confirmada |
| 4. Planificación | Cambio aprobado | Plan detallado, equipos notificados |
| 5. Implementación | Plan listo, ventana abierta | Cambio ejecutado, validación inicial OK |
| 6. Validación | Cambio ejecutado | Validación completada, sin issues |
| 7. Documentación | Validación completada | Cambio documentado, equipos notificados |
| 8. Mejora | Documentación completada | Lecciones capturadas, mejoras identificadas |

---

## MÉTRICAS Y KPIs

### Métricas Principales

| Métrica | Target | Frecuencia | Dueño |
|---------|--------|-----------|-------|
| **Change Lead Time** | < 1 semana | Por cambio | Tech Lead |
| **Implementation Duration** | < 2 horas | Por cambio | DevOps |
| **Validation Time** | < 4 horas | Por cambio | DevOps |
| **Rollback Success Rate** | 100% | Por rollback | DevOps |
| **Change Success Rate** | > 95% | Mensual | Tech Lead |
| **Documentation Completeness** | 100% | Por cambio | DevOps |

### Métricas Secundarias

- Número de cambios por mes
- Distribución por categoría (CRITICAL/MAJOR/MINOR)
- MTTR (Mean Time To Resolve) post-cambio
- Cambios que requirieron rollback
- Cambios con issues descubiertos en validación
- Tiempo de aprobación promedio

### Reporte Mensual

Incluir:
- Total de cambios ejecutados
- Tasa de éxito
- Rollbacks ejecutados (cantidad y razones)
- Lecciones aprendidas (patrones)
- Optimizaciones implementadas
- Recomendaciones para próximo mes

---

## HERRAMIENTAS Y TECNOLOGÍAS

### Sistema de Tracking de Cambios

- **GitHub Issues / Discussions**: Para cambios internos
- **Jira**: Si lo usa la organización
- **Spreadsheet de cambios**: Fallback simple

### Documentación

- **Markdown**: Planes y reportes
- **Git**: Versionado de documentación
- **Wiki/Confluence**: Knowledge base compartida

### Comunicación

- **Slack**: Notificaciones en vivo
- **Email**: Comunicación formal
- **Calendar**: Reserva de ventanas

### Validación

- **Scripts de health check**: Bash, Python
- **Monitoring tools**: Prometheus, Grafana (futuro)
- **Logs**: Centralizado si disponible

---

## EXCEPCIONES Y CASOS ESPECIALES

### Caso 1: Security Hotfix Crítica

**Trigger**: CVE crítica que requiere fix inmediato

**Variaciones**:
- ETAPA 1 y 2 aceleradas (30 min)
- ETAPA 3 simplificada (solo DevOps lead autoriza)
- Cambio deployed inmediatamente
- Post-mortem después (dentro de 48h)
- Documentación completa después de implementación

**Duración**: < 2 horas

---

### Caso 2: Cambio de Muy Alto Riesgo

**Trigger**: Cambio que afecta múltiples teams o tiene rollback incierto

**Acciones**:
- ETAPA 1 y 2 más rigurosas
- Aprobación de CTO requerida
- Simulación de rollback antes
- Ventana con full team on-call
- Monitoreo 24h post-cambio
- Posible rolling change (gradual por componente)

---

### Caso 3: Cambio Cosmético/Documentación

**Trigger**: Cambio que no afecta infraestructura running (ej: actualizar README)

**Variaciones**:
- ETAPA 1: Mínimo
- ETAPA 2-6: Skip (documentación no crítica)
- ETAPA 7: Simple
- Duración: 30 minutos

---

## VARIACIONES DEL PROCESO

### Standard Change (bajo riesgo)

**Cuando**: Cambios rutinarios con precedente

**Diferencias**:
- ETAPA 1 y 2 simplificadas
- ETAPA 3: Solo tech lead (sin CTO)
- Ejecutable en cualquier hora
- Documentación mínima

---

### Emergency Change

**Cuando**: Cambio necesario inmediatamente (pero no seguridad crítica)

**Diferencias**:
- ETAPA 1-3 acelerados (skip reviews formales)
- Ejecución inmediata
- Post-mortem después
- Aprobación retroactiva de director

---

## INTERACCIÓN CON OTROS PROCESOS

```
PROC-INFRA-004 (Este proceso)
       │
       ├─► PROC-INFRA-001 (Gestión de VMs)
       │      └─ Cambios en VMs requieren este proceso
       │
       ├─► PROC-INFRA-002 (Ciclo de vida DevContainer)
       │      └─ Cambios en DevContainer requieren este proceso
       │
       ├─► PROC-INFRA-003 (CI/CD)
       │      └─ Cambios en CI/CD requieren este proceso
       │
       ├─► PROC-INFRA-005 (Monitoreo)
       │      └─ Monitoreo post-cambio
       │
       └─► PROC-INCIDENT-RESPONSE (Por crear)
              └─ Cambios de emergencia
```

---

## REFERENCIAS A PROCEDIMIENTOS (Por Crear)

Este proceso será soportado por:

- **PROCED-INFRA-016-solicitud-cambio**: Cómo llenar formulario
- **PROCED-INFRA-017-analizar-impacto**: Análisis de riesgos
- **PROCED-INFRA-018-autorizar-cambio**: Flujo de aprobaciones
- **PROCED-INFRA-019-ejecutar-cambio**: Pasos de implementación
- **PROCED-INFRA-020-validar-cambio**: Testing post-cambio
- **PROCED-INFRA-021-rollback**: Procedimiento de rollback
- **PROCED-INFRA-022-retrospectiva-cambio**: Lecciones aprendidas

---

## REFERENCIAS Y GUÍAS

- [IT Change Management Best Practices](https://en.wikipedia.org/wiki/Change_management)
- [ITIL Change Management](https://www.axelos.com/certifications/itil-foundation)
- [Infrastructure as Code Versioning](https://www.terraform.io/docs/cloud/vcs/index.html)
- [Deployment Strategies](https://martinfowler.com/articles/deployment-pipeline.html)

---

## HISTORIAL DE CAMBIOS

### v1.0.0 (2025-11-18)

- Versión inicial del proceso
- Definición de 8 etapas de gestión de cambios
- Roles y responsabilidades claros
- Categorización de cambios (CRITICAL/MAJOR/MINOR)
- KPIs medibles
- Casos especiales documentados
- Diagrama ASCII de flujo
- Integración con otros procesos

**Creado por**: Claude Code (Haiku 4.5)
**Técnica de prompting**: Chain-of-Thought + Self-Consistency
**Estado**: Activo (aprobación pendiente)

---

**Próxima revisión**: 2026-02-18 (3 meses)
**Responsable de revisión**: Tech Lead + DevOps Manager
**Aprobación pendiente**: CTO, Director de Ingeniería, Tech Lead
