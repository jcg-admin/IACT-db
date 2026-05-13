# Procesos de Infraestructura

Este directorio contiene los procesos formales de infraestructura del proyecto IACT. Los procesos definen el QUE hacer a nivel estratégico/operativo para gestionar el ciclo de vida completo de la infraestructura de desarrollo.

## Navegación

- [Índice de Procesos](INDICE_PROCESOS.md) - Vista completa de todos los procesos disponibles
- [Procesos Disponibles](#procesos-disponibles)
- [Diferencia: Procesos vs Procedimientos](#diferencia-procesos-vs-procedimientos)
- [Cómo Usar los Procesos](#como-usar-los-procesos)
- [Estructura de un Proceso](#estructura-de-un-proceso)

---

## Procesos Disponibles

### PROC-INFRA-001: Gestión de Infraestructura de Máquinas Virtuales

Flujo completo de gestión del ciclo de vida de VMs desde solicitud hasta descommission.

**Archivo**: [PROC-INFRA-001-gestion-infraestructura-vm.md](PROC-INFRA-001-gestion-infraestructura-vm.md)

**Etapas**: Solicitud → Provisión → Configuración → Validación → Entrega → Monitoreo → Descommission

**Responsable**: DevOps Lead

---

### PROC-INFRA-002: Gestión de Configuración de DevContainers

Gestión de configuraciones de DevContainers, features y control de cambios.

**Archivo**: [PROC-INFRA-002-gestion-configuracion-devcontainers.md](PROC-INFRA-002-gestion-configuracion-devcontainers.md)

**Etapas**: Identificación → Implementación → Validación → Code Review → Merge → Adopción → Mantenimiento

**Responsable**: DevOps Lead

---

### PROC-INFRA-003: Hardening y Seguridad de Infraestructura

Aplicación de políticas de seguridad, hardening, auditorías y gestión de vulnerabilidades.

**Archivo**: [PROC-INFRA-003-hardening-seguridad-infraestructura.md](PROC-INFRA-003-hardening-seguridad-infraestructura.md)

**Etapas**: Políticas → Hardening → Scanning → Remediación → Auditoría → Incident Response → Mejora Continua

**Responsable**: DevOps Lead (Security Owner)

---

### PROC-INFRA-004: Backup y Recuperación de Infraestructura

Respaldo de configuraciones, datos críticos y procedimientos de recuperación ante desastres.

**Archivo**: [PROC-INFRA-004-backup-recuperacion-infraestructura.md](PROC-INFRA-004-backup-recuperacion-infraestructura.md)

**Etapas**: Planificación → Implementación → Ejecución → Validación → Gestión → Recuperación → DR Drills

**Responsable**: DevOps Lead (Backup Administrator)

---

### PROC-INFRA-005: Monitoreo y Observabilidad de Infraestructura

Configuración de métricas, logging, alertas y análisis de rendimiento.

**Archivo**: [PROC-INFRA-005-monitoreo-observabilidad-infraestructura.md](PROC-INFRA-005-monitoreo-observabilidad-infraestructura.md)

**Etapas**: Estrategia → Métricas → Logging → Alertas → Dashboards → Análisis → Respuesta

**Responsable**: DevOps Lead (Monitoring Owner)

---

## Diferencia: Procesos vs Procedimientos

### Procesos (PROC-*)

- **QUE hacer**: Definen el flujo de trabajo de alto nivel
- **Nivel**: Estratégico/Operativo
- **Audiencia**: Management, Tech Leads, todo el equipo
- **Contenido**: Etapas, roles, responsabilidades, KPIs, criterios de entrada/salida
- **Ejemplo**: PROC-INFRA-001 define QUE etapas seguir para gestionar VMs

### Procedimientos (PROCED-*)

- **COMO hacer**: Definen steps técnicos específicos
- **Nivel**: Táctico/Técnico
- **Audiencia**: Ejecutores (DevOps, Developers)
- **Contenido**: Comandos exactos, configuraciones, troubleshooting
- **Ejemplo**: PROCED-PROVISIONAR-VM-VAGRANT-001 define COMO ejecutar vagrant para crear VM

### Relación

Los procesos referencian procedimientos para detalles de implementación.

```
PROC-INFRA-001 (Gestión de VMs)
  └─ ETAPA 2: Provisión Automatizada
       └─ Procedimientos Relacionados:
            ├─ PROCED-PROVISIONAR-VM-VAGRANT-001
            └─ PROCED-VALIDAR-PROVISION-VM-001
```

---

## Cómo Usar los Procesos

### Para Developers

1. **Identificar el proceso relevante**: Busca en el [Índice de Procesos](INDICE_PROCESOS.md)
2. **Leer el flujo completo**: Entiende todas las etapas del proceso
3. **Identificar tu rol**: Revisa qué se espera de ti en cada etapa
4. **Seguir las etapas**: Ejecuta según el flujo definido
5. **Consultar procedimientos**: Si necesitas detalles técnicos del COMO

### Para DevOps

1. **Usar como guía operativa**: Los procesos definen tu trabajo diario
2. **Seguir las etapas**: Asegura consistencia en operaciones
3. **Medir KPIs**: Reporta métricas definidas en procesos
4. **Crear procedimientos**: Documenta el COMO basado en estos procesos
5. **Proponer mejoras**: Actualiza procesos basado en aprendizajes

### Para Management

1. **Entender flujos de trabajo**: Conoce cómo opera infraestructura
2. **Revisar KPIs**: Evalúa efectividad usando métricas definidas
3. **Aprobar cambios**: Revisa y aprueba modificaciones a procesos
4. **Asegurar recursos**: Garantiza recursos para cumplir procesos
5. **Validar compliance**: Verifica que procesos se siguen

---

## Estructura de un Proceso

Todos los procesos siguen una estructura estándar:

### 1. Metadata (YAML frontmatter)

```yaml
---
id: PROC-INFRA-XXX
tipo: proceso
categoria: infraestructura
subcategoria: xxx
version: 1.0.0
fecha_creacion: 2025-11-18
autor: Claude Code (Sonnet 4.5)
estado: activo
aprobado_por: pendiente
relacionados: ["PROC-YYY", "PROC-ZZZ"]
---
```

### 2. Título y Objetivo

- Título claro del proceso
- Objetivo de alto nivel

### 3. Propósito (QUE)

- Lista de qué se busca lograr con el proceso
- Nivel estratégico/operativo

### 4. Alcance

- Qué incluye el proceso
- Qué NO incluye (fuera de alcance)

### 5. Roles y Responsabilidades

- Quién participa en el proceso
- Qué hace cada rol
- Frecuencia de participación

### 6. Entradas y Salidas

- **Inputs**: Qué se necesita para iniciar
- **Outputs**: Qué se produce al final

### 7. Flujo del Proceso (Etapas)

Cada etapa incluye:
- Objetivo de la etapa
- Duración estimada
- Actividades principales
- Criterios de salida
- Procedimientos relacionados

### 8. Diagrama de Flujo

Representación visual del flujo (ASCII art)

### 9. Criterios de Entrada/Salida por Etapa

Tabla resumen de gates del proceso

### 10. Métricas y KPIs

- Métricas principales (targets)
- Métricas secundarias
- Reporte mensual

### 11. Herramientas y Tecnologías

Herramientas usadas en el proceso

### 12. Excepciones y Casos Especiales

Variaciones del flujo estándar

### 13. Interacción con Otros Procesos

Cómo este proceso se relaciona con otros

### 14. Controles y Validaciones

Puntos de control y validaciones

### 15. Troubleshooting

Problemas comunes y soluciones

### 16. Mejora Continua

- Retrospectivas
- Revisión periódica del proceso

### 17. Referencias y Guías

Links a documentación externa

### 18. Historial de Cambios

Versionado del proceso

---

## Métricas Agregadas de Procesos

Resumen de KPIs principales de todos los procesos:

| Proceso | KPI Principal | Target | Frecuencia |
|---------|---------------|--------|-----------|
| PROC-INFRA-001 | VM Uptime | > 99% | Mensual |
| PROC-INFRA-002 | Tiempo de Rebuild | < 5 min | Por cambio |
| PROC-INFRA-003 | Vulnerabilidades Críticas | 0 | Semanal |
| PROC-INFRA-004 | Backup Success Rate | > 99% | Diario |
| PROC-INFRA-005 | MTTR (Mean Time to Resolve) | < 30 min | Por incidente |

---

## Proceso de Revisión

Todos los procesos se revisan periódicamente:

### Revisión Mensual (Informal)

- DevOps Lead revisa efectividad
- Identifica problemas o gaps
- Propone ajustes menores

### Revisión Trimestral (Formal)

- DevOps Lead + Tech Lead + Stakeholders
- Análisis de métricas del trimestre
- Actualización de procesos según aprendizajes
- Aprobación de cambios significativos

### Revisión Anual (Estratégica)

- Revisión completa de todos los procesos
- Evaluación de nuevas herramientas/tecnologías
- Alineación con objetivos estratégicos
- Actualización mayor si necesario

---

## Contribución

### Cómo Proponer Mejoras

1. **Identifica el problema**: Documenta qué no funciona bien
2. **Propón solución**: Describe cómo mejorar el proceso
3. **Justifica el cambio**: Explica beneficios esperados
4. **Crea issue o discute**: Con DevOps Lead o Tech Lead
5. **Implementa cambio**: Si aprobado, actualiza proceso
6. **Comunica**: Notifica al equipo sobre cambio

### Cómo Crear Nuevo Proceso

1. **Valida necesidad**: ¿Realmente se necesita un proceso nuevo?
2. **Revisa procesos existentes**: ¿Alguno cubre esto parcialmente?
3. **Sigue plantilla estándar**: Usa estructura definida arriba
4. **Documenta QUE, no COMO**: Nivel estratégico/operativo
5. **Obtén aprobación**: Tech Lead debe aprobar
6. **Agrega al índice**: Actualiza INDICE_PROCESOS.md
7. **Comunica al equipo**: Capacita en nuevo proceso

---

## Documentos Relacionados

### Dentro de Infraestructura

- **Procedimientos**: `docs/infraestructura/procedimientos/` - Detalles del COMO
- **ADRs**: `docs/infraestructura/adrs/` - Decisiones arquitectónicas
- **Plantillas**: `docs/infraestructura/qa/plantillas/` - Templates estándar
- **Análisis**: `docs/infraestructura/analisis/` - Documentos de análisis

### Gobernanza

- **Guías**: `docs/gobernanza/guias/` - Guías y estándares
- **Procesos de Desarrollo**: `docs/gobernanza/procesos/` - Procesos de dev

---

## Preguntas Frecuentes

### ¿Cuándo uso un proceso vs un procedimiento?

- **Proceso**: Cuando necesitas entender el flujo completo y roles
- **Procedimiento**: Cuando necesitas ejecutar una tarea técnica específica

### ¿Son obligatorios los procesos?

Sí, los procesos definen cómo opera la infraestructura del proyecto. Seguirlos asegura:
- Consistencia en operaciones
- Calidad predecible
- Trazabilidad de cambios
- Compliance con estándares

### ¿Qué hago si un proceso no aplica a mi caso?

1. Revisa sección "Excepciones y Casos Especiales" del proceso
2. Si no está cubierto, consulta con DevOps Lead
3. Documenta la excepción y justificación
4. Obtén aprobación antes de proceder
5. Considera actualizar proceso para incluir caso

### ¿Cómo sé qué proceso seguir?

Consulta el [Índice de Procesos](INDICE_PROCESOS.md) y busca por:
- Título del proceso
- Categoría (Gestión, Seguridad, Operaciones)
- Descripción breve

### ¿Con qué frecuencia se actualizan los procesos?

- **Revisión trimestral**: Ajustes basados en aprendizajes
- **Revisión anual**: Actualización estratégica
- **Ad-hoc**: Si cambio significativo en tecnología/organización

---

## Contacto

Para preguntas, sugerencias o problemas con los procesos:

- **DevOps Lead**: Responsable principal de procesos de infraestructura
- **Tech Lead**: Aprobación de cambios significativos
- **Equipo**: Slack/Teams canal de infraestructura

---

## Historial de Cambios

### v1.0.0 (2025-11-18)

- Creación inicial del README
- Documentación de 5 procesos de infraestructura
- Estructura estándar definida
- Guía de uso para diferentes roles
- Links a índice y procesos individuales

**Creado por**: Claude Code (Sonnet 4.5)
**Técnica de prompting**: Auto-CoT + Template-based

---

**Última actualización**: 2025-11-18
**Próxima revisión**: 2026-02-18
