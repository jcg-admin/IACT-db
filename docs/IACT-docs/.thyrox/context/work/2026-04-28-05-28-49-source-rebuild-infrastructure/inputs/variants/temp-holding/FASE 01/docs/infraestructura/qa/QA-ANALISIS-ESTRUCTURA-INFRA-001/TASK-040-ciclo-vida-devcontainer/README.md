---
id: PROC-INFRA-002
tipo: proceso
categoria: infraestructura
subcategoria: devcontainer_lifecycle
version: 1.0.0
fecha_creacion: 2025-11-18
autor: Claude Code (Haiku 4.5)
estado: activo
aprobado_por: pendiente
relacionados: ["PROC-INFRA-001", "PROC-DEVOPS-001"]
---

# PROCESO: Ciclo de Vida de DevContainers

## Objetivo

Definir el flujo completo de gestión del ciclo de vida de DevContainers, desde su inicialización hasta su deprecación, asegurando consistencia de desarrollo, reproducibilidad de ambientes y facilidad de onboarding para nuevos desarrolladores en el proyecto IACT.

---

## Propósito (QUÉ)

Establecer un proceso formal y estandarizado para:

1. **Diseñar** DevContainers con configuraciones específicas del proyecto
2. **Inicializar** DevContainers con herramientas y dependencias requeridas
3. **Configurar** ambiente de desarrollo dentro del contenedor
4. **Validar** que el DevContainer cumple con especificaciones de desarrollo
5. **Mantener** DevContainers actualizados y funcionales
6. **Deprecar** DevContainers cuando se requieran cambios mayores
7. **Reemplazar** con versiones mejoradas de forma controlada

Este es un proceso de **nivel estratégico/operativo** (alto nivel). Para detalles de implementación (CÓMO), ver procedimientos relacionados.

---

## Alcance

### Incluye

- **Definición de DevContainers**: Dockerfile, devcontainer.json, docker-compose.yml
- **Ciclo completo**: Creación → Configuración → Validación → Mantenimiento → Deprecación
- **Herramientas estándar**: VS Code DevContainers, GitHub Codespaces (futuro)
- **Lenguajes y frameworks**: Python, Node.js, Java, dependencias específicas de IACT
- **Sincronización de cambios**: Actualizaciones de dependencias, cambios en requisitos
- **Documentación de DevContainer**: Especificaciones, versiones, instrucciones de uso
- **Onboarding**: Guías para nuevos desarrolladores usando DevContainers

### NO Incluye

- **Gestión de infraestructura VM host**: Ver PROC-INFRA-001
- **Pipeline CI/CD**: Ver PROC-INFRA-003
- **Monitoreo de contenedores en producción**: Ver PROC-INFRA-005
- **Orquestación Kubernetes**: Fuera del alcance actual
- **Seguridad avanzada (secrets management)**: Ver PROC-SEGURIDAD-CONTENEDORES (por crear)

---

## Roles y Responsabilidades

### Developer (Usuario)

**Responsabilidades**:
- Usar DevContainer para desarrollo local
- Reportar problemas o cambios necesarios
- Proporcionar feedback sobre usabilidad
- Mantener DevContainer actualizado en su máquina
- Solicitar nuevas herramientas o dependencias

**Frecuencia**: Diaria (mientras desarrolla)

---

### DevOps Engineer / Tech Lead (Mantenedor)

**Responsabilidades**:
- Diseñar y mantener Dockerfile y devcontainer.json
- Añadir nuevas herramientas requeridas por el equipo
- Validar cambios antes de aplicarlos
- Documentar cambios y versiones
- Proporcionar guías de troubleshooting
- Evaluar nuevas herramientas o extensiones

**Frecuencia**: Continua (semanal/mensual)

---

### Tech Lead / CTO (Revisor)

**Responsabilidades**:
- Revisar cambios significativos al DevContainer
- Aprobar nuevas herramientas o dependencias
- Asegurar cumplimiento de políticas de seguridad
- Revisar y aprobar cambios a este proceso

**Frecuencia**: Según sea necesario (típicamente 1 vez por mes)

---

## Entradas (Inputs)

### Solicitud de Cambio/Nueva Herramienta

1. **Formulario de Solicitud** con:
   - Herramienta o dependencia a agregar
   - Versión específica (si aplica)
   - Justificación técnica
   - Impacto esperado en el equipo
   - Usuario solicitante

2. **Contexto del Proyecto**:
   - Requerimientos técnicos actuales de IACT
   - Políticas de seguridad y compatibilidad
   - Versiones compatibles con infraestructura existente

3. **Especificación de DevContainer**:
   - Dockerfile actual
   - devcontainer.json actual
   - docker-compose.yml (si aplica)
   - Variables de entorno requeridas

### Actualizaciones de Dependencias

- Notificaciones de security patches
- Cambios en dependencias del proyecto
- Nuevos requisitos técnicos

---

## Salidas (Outputs)

### DevContainer Actualizado

1. **Archivos de Configuración**:
   - Dockerfile mejorado
   - devcontainer.json actualizado
   - docker-compose.yml (si aplica)
   - .devcontainer/Makefile para comandos comunes

2. **Documentación**:
   - Changelog de cambios
   - Guía de migración (si es versión major)
   - Versión del DevContainer
   - Herramientas incluidas con versiones

3. **Validación Completada**:
   - Tests pasando en nuevo DevContainer
   - Herramientas funcionando correctamente
   - Performance baseline

4. **Comunicación**:
   - Notificación a desarrolladores
   - Instrucciones para actualizar local
   - Fecha de deprecación de versión anterior

---

## FLUJO DEL PROCESO

### ETAPA 1: SOLICITUD Y ANÁLISIS

**Objetivo**: Identificar necesidad y evaluar impacto

**Duración estimada**: 1 hora

**Actividades**:

1. **Developer solicita cambio**
   - Propone herramienta o dependencia
   - Justifica necesidad técnica
   - Especifica versión (si aplica)

2. **DevOps evalúa solicitud**
   - Verifica compatibilidad con SO base
   - Evalúa impacto en tiempo de build
   - Revisa requerimientos de seguridad
   - Identifica dependencias transversales

3. **Decisión de viabilidad**
   - Solicitud aprobada o rechazada
   - Si rechazada: proporcionar alternativa
   - Si aprobada: continuar a implementación

**Criterios de Salida**:
- [ ] Solicitud completa y válida
- [ ] Compatibilidad verificada
- [ ] Impacto estimado
- [ ] Aprobación registrada

**Procedimientos Relacionados**:
- PROCED-SOLICITAR-CAMBIO-DEVCONTAINER-001

---

### ETAPA 2: DESARROLLO Y TESTING LOCAL

**Objetivo**: Implementar y validar cambios en ambiente local

**Duración estimada**: 2-4 horas

**Actividades**:

1. **Clonar repositorio de DevContainer**
   - Obtener versión actual del código
   - Crear rama de trabajo (ej: feature/add-postgresql)
   - Documentar cambios planeados

2. **Modificar Dockerfile**
   - Añadir herramienta o dependencia
   - Incluir comandos de instalación
   - Optimizar layers para caché
   - Documentar versión instalada

3. **Actualizar devcontainer.json**
   - Añadir nuevas extensiones (si VS Code)
   - Configurar variables de entorno
   - Actualizar forwarding de puertos
   - Añadir features nuevas

4. **Testing Local**
   - Construir imagen: `docker build`
   - Ejecutar contenedor localmente
   - Verificar herramienta instalada correctamente
   - Ejecutar tests del proyecto
   - Validar performance

5. **Documentar Cambios**
   - Registrar versiones instaladas
   - Documentar configuraciones nuevas
   - Preparar changelog

**Criterios de Salida**:
- [ ] Dockerfile compilado sin errores
- [ ] Herramientas funcionan en contenedor
- [ ] Tests pasando
- [ ] Performance aceptable (build < 10 min)
- [ ] Cambios documentados

**Procedimientos Relacionados**:
- PROCED-CONSTRUIR-DEVCONTAINER-001
- PROCED-TESTING-DEVCONTAINER-001

---

### ETAPA 3: REVISIÓN Y APROBACIÓN

**Objetivo**: Validar cambios antes de aplicar en el equipo

**Duración estimada**: 1 hora

**Actividades**:

1. **Pull Request**
   - Crear PR con cambios en .devcontainer/
   - Incluir descripción de cambios
   - Referenciar solicitud original
   - Documentar razón del cambio

2. **Code Review**
   - Tech Lead revisa Dockerfile
   - Valida prácticas de seguridad
   - Verifica claridad del código
   - Revisa impacto en equipo

3. **Testing en CI/CD**
   - Pipeline construye nueva imagen
   - Tests ejecutan en nueva imagen
   - Reporte de éxito/fallo
   - Feedback automático

4. **Aprobación Final**
   - Reviewer aprueba cambios
   - Merge a rama principal (main/develop)
   - Tag de versión creado (ej: v1.2.0)

**Criterios de Salida**:
- [ ] PR completo con descripción
- [ ] Code review completado
- [ ] Tests pasando en CI
- [ ] Cambios aprobados
- [ ] Mergeado a main

**Procedimientos Relacionados**:
- PROCED-REVIEW-DEVCONTAINER-001

---

### ETAPA 4: COMUNICACIÓN Y ROLLOUT

**Objetivo**: Informar al equipo y coordinar actualización

**Duración estimada**: 1 hora

**Actividades**:

1. **Notificación al equipo**
   - Enviar mensaje con cambios
   - Incluir changelog
   - Explicar beneficios
   - Proporcionar instrucciones de actualización

2. **Crear Documentación**
   - Actualizar README del DevContainer
   - Documentar herramientas incluidas
   - Crear guía de troubleshooting
   - Versionar documentación

3. **Soporte a Developers**
   - Disponible para preguntas
   - Recopilar feedback
   - Documentar problemas encontrados
   - Proporcionar workarounds si es necesario

4. **Monitoreo Inicial**
   - Verificar que equipo actualiza sin problemas
   - Registrar issues reportados
   - Resolver issues críticos rápidamente

**Criterios de Salida**:
- [ ] Equipo notificado
- [ ] Documentación actualizada
- [ ] Soporte disponible
- [ ] Issues iniciales resueltos

**Procedimientos Relacionados**:
- PROCED-COMUNICAR-CAMBIOS-DEVCONTAINER-001

---

### ETAPA 5: MANTENIMIENTO Y MONITOREO

**Objetivo**: Mantener DevContainer funcional y actualizado

**Duración estimada**: Continuo (semanal/mensual)

**Actividades**:

1. **Monitoreo de Compatibilidad**
   - Seguimiento de vulnerabilidades en dependencias
   - Monitoreo de nuevas versiones de herramientas
   - Evaluación de cambios en SO base (Ubuntu, etc.)

2. **Actualizaciones de Seguridad**
   - Aplicar parches de seguridad mensualmente
   - Revisar vulnerabilidades CVE
   - Actualizar versiones de dependencias críticas
   - Documentar actualizaciones

3. **Feedback del Equipo**
   - Recopilar solicitudes de nuevas herramientas
   - Registrar problemas encontrados
   - Analizar tendencias de uso
   - Planificar mejoras

4. **Optimización**
   - Revisar tiempo de build (target: < 5 min)
   - Optimizar capas del Dockerfile
   - Mejorar manejo de caché
   - Reducir tamaño de imagen

5. **Documentación**
   - Mantener README actualizado
   - Documentar cambios mensuales
   - Mantener changelog
   - Registrar versiones disponibles

**Criterios de Salida**:
- [ ] DevContainer construye exitosamente
- [ ] Tests pasando regularmente
- [ ] Vulnerabilidades parcheadas
- [ ] Documentación actualizada
- [ ] Feedback recopilado

**Procedimientos Relacionados**:
- PROCED-ACTUALIZAR-DEPENDENCIAS-DEVCONTAINER-001
- PROCED-PARCHES-SEGURIDAD-DEVCONTAINER-001

---

### ETAPA 6: DEPRECACIÓN Y MIGRACIÓN

**Objetivo**: Coordinar transición a nueva versión

**Duración estimada**: 2 semanas (aviso previo)

**Actividades**:

1. **Anuncio de Deprecación**
   - Notificar equipo con 2 semanas de anticipación
   - Documentar razón de cambio
   - Proporcionar roadmap de migración
   - Explicar beneficios de nueva versión

2. **Soporte Dual**
   - Mantener versión anterior por 2 semanas
   - Permitir transición gradual del equipo
   - Proporcionar troubleshooting para ambas versiones
   - Documentar guía de migración

3. **Migración Completa**
   - Actualizar documentación oficial
   - Remover referencias a versión antigua
   - Archivar configuración anterior
   - Registrar fecha de deprecación

4. **Post-Migración**
   - Verificar que todo el equipo ha migrado
   - Recopilar feedback sobre nueva versión
   - Documentar lecciones aprendidas
   - Planificar mejoras futuras

**Criterios de Salida**:
- [ ] Equipo migrado exitosamente
- [ ] Versión anterior removida
- [ ] Documentación archivada
- [ ] Feedback registrado
- [ ] Lecciones documentadas

**Procedimientos Relacionados**:
- PROCED-DEPRECAR-DEVCONTAINER-001

---

## DIAGRAMA DE FLUJO

```
┌────────────────────────────────────────────────────────┐
│         CICLO DE VIDA DE DEVCONTAINERS - FLUJO        │
└────────────────────────────────────────────────────────┘

                    [Developer / Team]
                           │
             Solicita cambio o nueva herramienta
                           │
                           ▼
          ┌────────────────────────────────┐
          │ ETAPA 1: SOLICITUD Y ANÁLISIS  │
          │ - Evaluar compatibilidad       │
          │ - Verificar viabilidad         │
          │ - Estimar impacto              │
          └────────────────────────────────┘
                           │
                  ¿Solicitud viable?
                  ├─ NO ──► Rechazar + proponer alternativa
                  │
                  └─ SÍ ──► Continuar
                           │
                           ▼
          ┌────────────────────────────────┐
          │ ETAPA 2: DESARROLLO Y TESTING  │
          │ - Modificar Dockerfile         │
          │ - Actualizar devcontainer.json │
          │ - Testing local                │
          │ - Documentar cambios           │
          └────────────────────────────────┘
                           │
                  ¿Testing exitoso?
                  ├─ NO ──► Corregir
                  │
                  └─ SÍ ──► Continuar
                           │
                           ▼
          ┌────────────────────────────────┐
          │ ETAPA 3: REVISIÓN Y APROBACIÓN │
          │ - Pull Request                 │
          │ - Code Review                  │
          │ - Testing en CI                │
          │ - Aprobación final             │
          └────────────────────────────────┘
                           │
                  ¿Cambios aprobados?
                  ├─ NO ──► Revisar feedback
                  │
                  └─ SÍ ──► Mergear
                           │
                           ▼
          ┌────────────────────────────────┐
          │ ETAPA 4: COMUNICACIÓN          │
          │ - Notificar equipo             │
          │ - Documentación                │
          │ - Soporte inicial              │
          └────────────────────────────────┘
                           │
                           ▼
          ┌────────────────────────────────┐
          │ ETAPA 5: MANTENIMIENTO         │
          │ - Monitoreo de compatibilidad  │
          │ - Actualizaciones de seguridad │
          │ - Recopilación de feedback     │
          │ - Optimización continua        │
          └────────────────────────────────┘
                           │
              ¿Nueva solicitud o deprecación?
              ├─ Solicitud ──► Volver a ETAPA 1
              │
              └─ Deprecación ──► Continuar
                           │
                           ▼
          ┌────────────────────────────────┐
          │ ETAPA 6: DEPRECACIÓN Y MIGRACIÓN
          │ - Anuncio de deprecación       │
          │ - Soporte dual                 │
          │ - Migración completa           │
          │ - Post-migración               │
          └────────────────────────────────┘
                           │
                           ▼
                   [Nuevo ciclo inicia]
```

---

## CRITERIOS DE ENTRADA Y SALIDA POR ETAPA

| Etapa | Criterio de Entrada | Criterio de Salida |
|-------|---------------------|-------------------|
| 1. Solicitud | Solicitud completada | Viabilidad confirmada, impacto estimado |
| 2. Desarrollo | Solicitud aprobada | Testing exitoso, cambios documentados |
| 3. Revisión | Testing completado | Code review aprobado, CI pasando |
| 4. Comunicación | Cambios mergeados | Equipo notificado, documentación actualizada |
| 5. Mantenimiento | DevContainer en uso | Vulnerabilidades parcheadas, feedback recopilado |
| 6. Deprecación | Nueva versión lista | Equipo migrado, versión anterior archivada |

---

## MÉTRICAS Y KPIs

### Métricas Principales

| Métrica | Target | Frecuencia | Dueño |
|---------|--------|-----------|-------|
| **DevContainer Build Time** | < 5 min | Semanal | DevOps |
| **Image Size** | < 2GB | Mensual | DevOps |
| **Security Patches Applied** | < 7 días | Mensual | DevOps |
| **Developer Onboarding Time** | < 30 min | Por developer | Tech Lead |
| **Change Cycle Time** | 3-5 días | Por cambio | DevOps |
| **Team Satisfaction** | > 80% | Trimestral | Tech Lead |

### Métricas Secundarias

- Número de herramientas incluidas
- Versión más antigua en uso por desarrolladores
- Frecuencia de cambios solicitados
- Tasa de éxito en testing
- Número de issues reportados
- Tiempo promedio de resolución de issues

### Reporte Mensual

Incluir:
- Cambios realizados
- Tiempo de build promedio
- Vulnerabilidades detectadas y parcheadas
- Feedback del equipo
- Recomendaciones de optimización

---

## HERRAMIENTAS Y TECNOLOGÍAS

### Desarrollo de DevContainers

- **Dockerfile**: Definición de imagen base
- **devcontainer.json**: Configuración de VS Code
- **docker-compose.yml**: Orquestación de servicios (base de datos, caché, etc.)
- **Docker**: Construcción y ejecución de contenedores

### Testing

- **Docker CLI**: Construcción local
- **Docker Compose**: Testing con servicios dependientes
- **GitHub Actions**: CI/CD para validación
- **bash/makefile**: Scripts de validación

### Documentación

- **Markdown**: Documentación de cambios
- **Git**: Versionado de configuraciones
- **GitHub Releases**: Publicación de versiones
- **README.md**: Guía de uso

### Monitoreo y Seguridad

- **Dependabot**: Detección de vulnerabilidades
- **Docker Hub**: Escaneo de imagen
- **Git hooks**: Validación pre-commit

---

## EXCEPCIONES Y CASOS ESPECIALES

### Caso 1: Actualización de Seguridad Urgente

**Trigger**: CVE crítica afectando herramienta en DevContainer

**Variaciones**:
- Skip ETAPA 1 (evaluación rápida)
- Testing simplificado (focus en el parche)
- Comunicación inmediata al equipo
- Posible actualización forzada

**Duración**: < 2 horas

---

### Caso 2: Cambio Major de SO Base

**Trigger**: Actualización de Ubuntu (ej: 20.04 a 22.04)

**Acciones**:
- ETAPA 1 extendida (análisis de compatibilidad)
- ETAPA 2 extendida (testing exhaustivo)
- ETAPA 6 con 1 mes de aviso previo
- Migración en dos fases (creación de nuevo, deprecación gradual)

---

### Caso 3: Herramienta con Licencia Especial

**Trigger**: Solicitud de software con licencia propietaria

**Acciones**:
- Evaluación de compatibilidad de licencia
- Aprobación de Legal/CTO requerida
- Documentación de limitaciones de uso
- Plan de alternativas open-source

---

## VARIACIONES DEL PROCESO

### Quick Fix (Cambio menor)

**Cuando**: Actualización de versión sin cambios de API

**Diferencias**:
- ETAPA 1: Skip (rápida evaluación)
- ETAPA 2: Testing simplificado
- ETAPA 3: Review rápido
- Duración: 2-3 horas

---

### Major Upgrade

**Cuando**: Cambio significativo (nueva versión major, nuevo SO)

**Diferencias**:
- ETAPA 1 y 2 extendidas
- Testing exhaustivo requerido
- ETAPA 6 con 2-4 semanas de aviso
- Duración: 1-2 semanas

---

## INTERACCIÓN CON OTROS PROCESOS

```
PROC-INFRA-002 (Este proceso)
       │
       ├─► PROC-INFRA-001 (Gestión de VMs Host)
       │      └─ DevContainer corre en VM host
       │
       ├─► PROC-INFRA-003 (CI/CD)
       │      └─ CI usa DevContainer para tests
       │
       ├─► PROC-INFRA-005 (Monitoreo)
       │      └─ Monitoreo de salud del DevContainer
       │
       └─► PROC-DEV-001 (Workflow de desarrollo)
              └─ Developers usan DevContainer diariamente
```

---

## REFERENCIAS A PROCEDIMIENTOS (Por Crear)

Este proceso será soportado por:

- **PROCED-INFRA-003-construir-devcontainer**: Pasos técnicos de Docker
- **PROCED-INFRA-004-testing-devcontainer**: Scripts y validaciones
- **PROCED-INFRA-005-actualizar-local**: Guía para desarrolladores
- **PROCED-INFRA-006-deprecar-devcontainer**: Pasos de migración
- **PROCED-INFRA-007-troubleshooting-devcontainer**: Solución de problemas

---

## REFERENCIAS Y GUÍAS

- [DevContainer Best Practices](https://containers.dev/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [VS Code DevContainer Spec](https://containers.dev/implementors/spec/)
- [PROC-INFRA-001: Gestión de VMs](../procesos/PROC-INFRA-001-gestion-infraestructura-vm.md)
- [PROC-INFRA-003: Integración Continua](../procesos/PROC-INFRA-003-integracion-continua-infra.md)

---

## HISTORIAL DE CAMBIOS

### v1.0.0 (2025-11-18)

- Versión inicial del proceso
- Definición de 6 etapas del ciclo de vida
- Roles y responsabilidades claros
- KPIs medibles
- Casos especiales documentados
- Diagrama ASCII de flujo
- Variaciones del proceso

**Creado por**: Claude Code (Haiku 4.5)
**Técnica de prompting**: Chain-of-Thought + Self-Consistency
**Estado**: Activo (aprobación pendiente)

---

**Próxima revisión**: 2026-02-18 (3 meses)
**Responsable de revisión**: DevOps Lead + Tech Lead
**Aprobación pendiente**: CTO, DevOps Manager, Developer Representatives
