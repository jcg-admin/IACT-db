---
id: TASK-REORG-INFRA-033
tipo: tarea_contenido
categoria: adr
fase: FASE_3_CONTENIDO_NUEVO
prioridad: ALTA
duracion_estimada: 3h
estado: pendiente
dependencias: [TASK-REORG-INFRA-031]
tags: [adr, podman, docker, container-runtime, decision, infraestructura]
tecnica_prompting: Template-based Prompting + Auto-CoT + Self-Consistency
fecha_creacion: 2025-11-18
---

# TASK-REORG-INFRA-033: Crear ADR-INFRA-003 (Podman vs Docker en VM)

## Auto-CoT: Razonamiento de la Decisión

### 1. Identificación del Problema
- **Pregunta central:** ¿Qué container runtime usar en la VM Vagrant: Podman o Docker?
- **Contexto:** TASK-031 decidió Vagrant + VM pero sin especificar el runtime
- **Requisito:** Elegir entre Podman (rootless) y Docker, considerando seguridad, performance, compatibilidad

### 2. Opciones Consideradas (Evaluación)
- **Opción A:** Docker en VM → Popular, amplio soporte, pero más overhead de seguridad
- **Opción B:** Podman rootless en VM (RECOMENDADA) → Sin daemon, más seguro, compatible con Docker CLI
- **Opción C:** Ambos instalados → Complejidad innecesaria
- **Opción D:** OpenShift Container Runtime → Overhead para proyecto

### 3. Árbol de Decisión (Tree-of-Thought)

```
¿Qué container runtime?
├── Docker
│   ├── Pros: Amplio soporte, documentación
│   ├── Contras: Daemon, más pesado, menos seguro
│   └── Verdict: [ERROR] No óptimo para development
├── Podman (ELEGIDO)
│   ├── Pros: Rootless, sin daemon, Docker-compatible, más seguro
│   ├── Contras: Curva de aprendizaje (mínima)
│   └── Verdict: [OK] Óptimo para development + seguridad
└── Otros
    ├── Pros: Flexibilidad
    ├── Contras: Complejidad innecesaria
    └── Verdict: [ERROR] Descartado
```

### 4. Impacto en Arquitectura
- **Positivo:** Podman rootless = sin escalación de privilegios
- **Positivo:** Compatible con Docker CLI (reducción de learning curve)
- **Positivo:** Menos recursos que Docker daemon
- **Negativo:** Menos documentación que Docker
- **Neutral:** Mitigable con scripting y documentación

## Descripción de la Tarea

Esta tarea documenta formalmente la decisión arquitectónica de utilizar **Podman rootless** como container runtime en la VM Vagrant, en lugar de Docker tradicional.

Es el **tercer ADR formal de infraestructura**, estableciendo el container runtime para el DevContainer Host.

## Objetivo

Crear un Architecture Decision Record (ADR) que:
- Documente el contexto y la necesidad de elegir un container runtime
- Compare Podman vs Docker considerando seguridad, performance, compatibilidad
- Justifique la elección de Podman rootless
- Describa consecuencias operacionales
- Establezca criterios de validación

## Alineación

**Canvases de referencia:**
- `/docs/infraestructura/diseno/arquitectura/devcontainer-host-vagrant.md`

**Decisión:** ADR-INFRA-003 especifica el runtime del DevContainer Host.

## Contenido a Generar

### Archivo Principal
- **Ubicación:** `/docs/infraestructura/adr/ADR-INFRA-003-podman-vs-docker-vm.md`
- **Formato:** Markdown con frontmatter YAML
- **Secciones:** 8 secciones completas

### Estructura del ADR

1. **Contexto y Problema**
   - Necesidad de elegir container runtime
   - Consideraciones de seguridad (rootless vs daemon)
   - Performance y overhead
   - Compatibilidad con DevContainer spec

2. **Factores de Decisión**
   - Security (rootless capability) (Alto)
   - Performance (resource overhead) (Alto)
   - Compatibility (Docker CLI compatibility) (Alto)
   - Community & Support (Medio)
   - Learning Curve (Bajo)

3. **Opciones Consideradas**
   - Docker en VM (con daemon)
   - Podman rootless en VM (RECOMENDADA)
   - Ambos instalados en paralelo
   - OpenShift Container Runtime

4. **Decisión**
   - Podman rootless como container runtime

5. **Justificación**
   - Seguridad mejorada (rootless execution)
   - Sin daemon = menos recursos
   - Docker CLI compatible (mitigación de learning curve)
   - Align con philosophía de open source

6. **Consecuencias**
   - Positivas: Seguridad, recursos, compatibilidad
   - Negativas: Menos documentación vs Docker
   - Neutrales: Requiere entrenamiento inicial

7. **Plan de Implementación**
   - Fase 1: Instalación de Podman en provision.sh (1 día)
   - Fase 2: Setup de rootless user (dev) (1 día)
   - Fase 3: Testing y validación (1 día)

8. **Validación y Métricas**
   - Criterios: Podman commands equivalentes a Docker CLI
   - Medición: DevContainer funciona sin cambios
   - Revisión: 2 semanas post-implementación

## Self-Consistency: Validación de Coherencia

### Checklist de Completitud

- [ ] 8 secciones presentes en el ADR
- [ ] Frontmatter YAML completo
- [ ] Contexto y Problema bien definido
- [ ] Comparación detallada de Podman vs Docker
- [ ] Seguridad (rootless) documentada
- [ ] Consecuencias categorizadas
- [ ] Plan de implementación con fases
- [ ] Validación y métricas con criterios
- [ ] Alineación con ADR-INFRA-001
- [ ] Referencias técnicas precisas

### Alineación Verificada

| Concepto | ADR-001 | ADR-003 | Status |
|----------|---------|---------|--------|
| Container runtime needed | [OK] | [ ] | Pendiente |
| Rootless execution | [OK] | [ ] | Pendiente |
| Docker CLI compatible | [OK] | [ ] | Pendiente |
| Secure por defecto | [OK] | [ ] | Pendiente |

### Coherencia del Razonamiento

**Verificación Tree-of-Thought:**
```
Árbol de decisión completo?
├── Opciones: 4 opciones evaluadas [OK]
├── Criterios: 5 factores de decisión [OK]
├── Evaluación: Pros/Contras por opción [OK]
├── Decisión: Podman rootless [OK]
└── Justificación: Razonada [OK]

Conclusión: Razonamiento completo y coherente
```

## Decisión Capturada (Preliminary)

**Opción elegida:** Podman rootless

**Justificación:**
- Seguridad mejorada (sin daemon, sin root escalation)
- Recursos reducidos (sin Docker daemon)
- Compatible con Docker CLI (transición suave)
- Alineado con decisión TASK-031

## Próximos Pasos

1. Desarrollar ADR-INFRA-003 con 8 secciones completas
2. Comparación detallada Podman vs Docker
3. Validar Tree-of-Thought en documentación
4. Alineación con ADR-INFRA-001
5. Revisión de Arquitectura

## Referencias

- **ADR-INFRA-001:** `/docs/infraestructura/adr/ADR-INFRA-001-vagrant-devcontainer-host.md`
- **Podman Docs:** https://podman.io/docs/
- **Docker Docs:** https://docs.docker.com/
- **Plantilla ADR:** `/docs/gobernanza/adr/plantilla_adr.md`

## Criterios de Aceptación

- [ ] ADR-INFRA-003 creado con 8 secciones
- [ ] Comparación detallada Podman vs Docker
- [ ] Tree-of-Thought documentado
- [ ] Self-Consistency validado
- [ ] Alineación con ADR-INFRA-001
- [ ] Revisión completada

---

**Estado:** PENDIENTE
**Fecha Creación:** 2025-11-18
**Fase:** FASE_3_CONTENIDO_NUEVO
**Responsable:** Equipo de Arquitectura
