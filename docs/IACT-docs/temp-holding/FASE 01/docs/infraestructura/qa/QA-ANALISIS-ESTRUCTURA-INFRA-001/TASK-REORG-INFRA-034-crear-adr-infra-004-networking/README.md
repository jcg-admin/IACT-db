---
id: TASK-REORG-INFRA-034
tipo: tarea_contenido
categoria: adr
fase: FASE_3_CONTENIDO_NUEVO
prioridad: ALTA
duracion_estimada: 4h
estado: pendiente
dependencias: [TASK-REORG-INFRA-031, TASK-REORG-INFRA-033]
tags: [adr, networking, vm, vagrant, decision, infraestructura]
tecnica_prompting: Template-based Prompting + Auto-CoT + Self-Consistency
fecha_creacion: 2025-11-18
---

# TASK-REORG-INFRA-034: Crear ADR-INFRA-004 (Estrategia de Networking en VM)

## Auto-CoT: Razonamiento de la Decisión

### 1. Identificación del Problema
- **Pregunta central:** ¿Cómo comunicarse entre la máquina host, la VM Vagrant y los contenedores?
- **Contexto:** TASK-031/033 establecieron VM + Podman, pero sin definir networking
- **Requisito:** Comunicación host ↔ VM ↔ DevContainer, acceso a servicios de desarrollo

### 2. Opciones Consideradas (Evaluación por Chain-of-Thought)

**Paso 1: Definir requisitos de networking**
```
- Host debe acceder a VM via SSH
- Host debe acceder a DevContainer via VS Code Remote
- VM debe acceder a contenedores (Podman)
- Host opcional: directamente a contenedores
- Considerar: Performance, seguridad, complejidad
```

**Paso 2: Evaluar opciones**
- **Opción A:** NAT (default Vagrant) → Acceso unidireccional, host solo via SSH
- **Opción B:** Host-only network → Aislamiento completo, sin acceso internet
- **Opción C:** Bridged network → Máxima compatibilidad, pero expone VM
- **Opción D:** Combinada NAT + Host-only (RECOMENDADA) → Seguridad + usabilidad

**Paso 3: Evaluar impacto en casos de uso**
```
VS Code Development:
- host SSH to VM [OK]
- VS Code Remote SSH in VM [OK]
- Podman containers in VM [OK]
- Host access to services (via port forward) [OK]

CI/CD Integration:
- GitHub Actions → VM [OK]
- Local testing → VM [OK]
- Cross-VM communication (future) [OK]

Verdict: Opción D satisface todos los requisitos
```

### 3. Impacto en Arquitectura
- **Positivo:** Aislamiento de VM del host físico
- **Positivo:** Seguridad mejorada (NAT + internal network)
- **Positivo:** Determinístico y reproducible
- **Negativo:** Requiere port forwarding explícito
- **Neutral:** Documentación de networking map necesaria

## Descripción de la Tarea

Esta tarea documenta formalmente la estrategia de **networking entre host, VM Vagrant y contenedores**, garantizando comunicación segura y determinística para development, testing y CI/CD.

Es el **cuarto ADR formal de infraestructura**, definiendo el modelo de red para el DevContainer Host.

## Objetivo

Crear un Architecture Decision Record (ADR) que:
- Documente requisitos de networking
- Presente opciones de configuración Vagrant (NAT, host-only, bridged)
- Justifique la elección de estrategia combinada
- Describa arquitectura de red (diagramas)
- Establezca criterios de validación de conectividad

## Alineación

**Canvases de referencia:**
- `/docs/infraestructura/diseno/arquitectura/devcontainer-host-vagrant.md`

**Decisión:** ADR-INFRA-004 especifica networking del DevContainer Host.

## Contenido a Generar

### Archivo Principal
- **Ubicación:** `/docs/infraestructura/adr/ADR-INFRA-004-estrategia-networking-vm.md`
- **Formato:** Markdown con frontmatter YAML + Diagramas ASCII
- **Secciones:** 8 secciones completas

### Estructura del ADR

1. **Contexto y Problema**
   - Requisitos de networking (host ↔ VM ↔ containers)
   - Casos de uso: development, testing, CI/CD
   - Consideraciones de seguridad y performance

2. **Factores de Decisión**
   - Connectivity (host to VM to containers) (Alto)
   - Security (isolation, firewall rules) (Alto)
   - Performance (latency, bandwidth) (Medio)
   - Determinism (reproducible config) (Medio)
   - Scalability (future multi-VM) (Bajo)

3. **Opciones Consideradas**
   - NAT (default Vagrant)
   - Host-only network
   - Bridged network
   - Combinada NAT + Host-only (RECOMENDADA)

4. **Decisión**
   - Estrategia de networking: NAT (default) + Host-only (internal)

5. **Justificación**
   - NAT: Aislamiento de VM, seguridad
   - Host-only: Comunicación VM ↔ Host sin exposición
   - Combination: Máxima seguridad y usabilidad

6. **Consecuencias**
   - Positivas: Aislamiento, seguridad, reproducibilidad
   - Negativas: Port forwarding requerido
   - Neutrales: Documentación necesaria

7. **Plan de Implementación**
   - Fase 1: Configuración Vagrantfile (1 día)
   - Fase 2: Setup de host-only network (1 día)
   - Fase 3: Testing de conectividad (1 día)
   - Fase 4: Documentación de network map (1 día)

8. **Validación y Métricas**
   - Criterios: SSH access, port forwarding, DNS resolution
   - Medición: Latency < 10ms host to VM
   - Diagramas: Network topology documentation

## Self-Consistency: Validación de Coherencia

### Checklist de Completitud

- [ ] 8 secciones presentes en el ADR
- [ ] Frontmatter YAML completo
- [ ] Requisitos de networking documentados
- [ ] 4 opciones consideradas con análisis
- [ ] Diagramas de network topology
- [ ] Plan con fases claras
- [ ] Validación y métricas
- [ ] Alineación con ADR-INFRA-001
- [ ] Port forwarding map documentado
- [ ] Troubleshooting networking común

### Alineación Verificada

| Componente | Requisito | ADR | Status |
|-----------|-----------|-----|--------|
| Host → VM SSH | Crítico | [ ] | Pendiente |
| VM → Containers | Crítico | [ ] | Pendiente |
| Port forwarding | Crítico | [ ] | Pendiente |
| Network isolation | Importante | [ ] | Pendiente |
| Network map | Importante | [ ] | Pendiente |

### Coherencia del Razonamiento

**Verificación Chain-of-Thought:**
```
Paso 1: ¿Requisitos claros?
→ Sí: SSH, Podman, port forwarding, aislamiento

Paso 2: ¿Opciones evaluadas?
→ Sí: 4 opciones con pros/contras

Paso 3: ¿Impacto analizado?
→ Sí: Positivos, negativos, neutrales

Paso 4: ¿Alternativa elige mejor opción?
→ Sí: Combinada NAT+Host-only es óptima

Conclusión: Razonamiento lógico y completo
```

## Decisión Capturada (Preliminary)

**Opción elegida:** Networking combinado NAT + Host-only

**Justificación:**
- NAT proporciona aislamiento base
- Host-only permite comunicación VM ↔ Host
- Port forwarding explícito para servicios
- Máxima seguridad sin sacrificar usabilidad

## Network Map (Conceptual)

```
┌─────────────────────────────────────────┐
│ Host Physical Machine (Windows/Mac/Linux)│
├─────────────────────────────────────────┤
│ VS Code Remote SSH                      │
│ │                                       │
│ └──── SSH 192.168.56.10:22 ──────┐     │
│                                   │     │
├───────────────────────────────────┼─────┤
│ VirtualBox VM (Ubuntu Server)     │     │
│ eth0 (NAT) 10.0.2.15              │     │
│ eth1 (Host-only) 192.168.56.10 ←──┘     │
│                                   │     │
│ Vagrant VM                        │     │
│ ├─ Podman daemon                  │     │
│ │  ├─ DevContainer 1              │     │
│ │  ├─ DevContainer 2              │     │
│ │  └─ ...                         │     │
│ └─ Services (dev, db, cache)      │     │
│                                   │     │
├───────────────────────────────────┼─────┤
│ Port Forwarding (Vagrantfile)     │     │
│ Host:3000 → VM:3000               │     │
│ Host:5432 → VM:5432               │     │
│ Host:6379 → VM:6379               │     │
└───────────────────────────────────┴─────┘
```

## Próximos Pasos

1. Desarrollar ADR-INFRA-004 con 8 secciones completas
2. Crear diagramas de network topology
3. Validar Chain-of-Thought
4. Documentar port forwarding map
5. Alineación con ADR-INFRA-001/002/003

## Referencias

- **ADR-INFRA-001:** `/docs/infraestructura/adr/ADR-INFRA-001-vagrant-devcontainer-host.md`
- **Vagrant Networking:** https://www.vagrantup.com/docs/networking
- **VirtualBox Networking:** https://www.virtualbox.org/manual/ch06.html
- **Plantilla ADR:** `/docs/gobernanza/adr/plantilla_adr.md`

## Criterios de Aceptación

- [ ] ADR-INFRA-004 creado con 8 secciones
- [ ] Network topology diagrams
- [ ] Port forwarding map documented
- [ ] Chain-of-Thought validado
- [ ] Self-Consistency al 100%
- [ ] Alineación con ADRs anteriores
- [ ] Revisión completada

---

**Estado:** PENDIENTE
**Fecha Creación:** 2025-11-18
**Fase:** FASE_3_CONTENIDO_NUEVO
**Responsable:** Equipo de Arquitectura + DevOps
