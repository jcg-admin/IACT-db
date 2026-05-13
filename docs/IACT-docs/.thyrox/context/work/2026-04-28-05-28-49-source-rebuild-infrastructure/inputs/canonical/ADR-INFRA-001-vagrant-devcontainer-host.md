---
id: ADR-INFRA-001
estado: propuesta
propietario: equipo-arquitectura
ultima_actualizacion: 2025-11-18
relacionados: ["DOC-ARQ-DEVCONTAINER-HOST-VAGRANT", "DOC-INFRA-INDEX"]
---

# ADR-INFRA-001: Vagrant como DevContainer Host (sin Docker en Host Físico)

**Estado:** propuesta

**Fecha:** 2025-11-18

**Decisores:** Equipo de Arquitectura, Equipo de DevOps

**Contexto técnico:** Infrastructure

## 1. Contexto y Problema

### 1.1 Situación Actual

El proyecto IACT necesita un entorno de desarrollo local reproducible que permita a los desarrolladores trabajar con **DevContainers** sin instalar Docker directamente en su máquina física.

**Restricciones iniciales:**
- No todos los desarrolladores pueden instalar Docker en el host (limitaciones de licencia, configuración corporativa, conflictos con otras herramientas)
- Se requiere un ambiente **consistente** entre development, CI/CD y producción
- La solución debe funcionar en **Windows, macOS y Linux**
- No se pueden contaminar máquinas host con servicios de contenedores

### 1.2 Problema

**Pregunta principal:** ¿Cómo ejecutar DevContainers en entornos donde Docker no puede instalarse en el host físico?

**Sub-preguntas:**
- ¿Cómo garantizar consistency entre desarrollo y CI/CD sin Docker en host?
- ¿Cómo reproducir el entorno de manera determinística?
- ¿Cómo mantener la máquina host limpia de dependencias de infraestructura?
- ¿Cómo gestionar un DevContainer Host de forma auditable y versionada?

### 1.3 Impacto

- **Desarrollo:** Inconsistencias entre máquinas de desarrolladores → bugs por diferencias de ambiente
- **Onboarding:** Proceso complejo, propenso a errores, requiere 2-3 días
- **CI/CD:** Divergencia entre pipelines locales y remotas
- **Operaciones:** Dificultad en troubleshooting por falta de reproducibilidad

### 1.4 Preguntas Clave Respondidas

| Pregunta | Respuesta |
|----------|-----------|
| ¿Qué problema estamos resolviendo? | Necesidad de DevContainers sin Docker en host físico |
| ¿Por qué es importante ahora? | Restricciones de licencia y configuración corporativa |
| ¿Cuáles son las restricciones? | Windows/macOS/Linux, sin servicios en host, reproducible |
| ¿Qué impacto tiene? | Onboarding, consistency, operaciones, debugging |

---

## 2. Factores de Decisión

Criterios evaluados para tomar la decisión:

| Factor | Peso | Descripción |
|--------|------|-------------|
| **Environmental Consistency** | Alto | Mismo ambiente en desarrollo, testing y CI/CD |
| **Operational Equivalence** | Alto | Operaciones predecibles e idénticas |
| **Deterministic Execution** | Alto | Reproducibilidad garantizada |
| **Cross-Platform Compatibility** | Alto | Funciona en Windows, macOS, Linux |
| **Resource Overhead** | Medio | RAM, CPU, disco utilizado |
| **Onboarding Simplicity** | Medio | Facilidad para nuevos desarrolladores |
| **Maintenance Burden** | Medio | Costo de mantener la solución |
| **Security Posture** | Medio | Seguridad del aislamiento de contenedores |
| **Community & Support** | Bajo | Documentación, soporte disponible |
| **Cost (Licensing)** | Bajo | Impacto en costos operacionales |

### Detalle de Factores

- **Environmental Consistency:** Asegurar que el toolchain, dependencias de sistema y configuración sean idénticas entre development, CI/CD y producción
- **Operational Equivalence:** Operaciones de build, test, deploy deben ser exactas sin variaciones
- **Deterministic Execution:** Mismas instrucciones produzcan mismo resultado cada vez
- **Cross-Platform:** Sin limitaciones por SO del desarrollador
- **Resource Overhead:** Aceptable (<30% del sistema disponible)
- **Onboarding:** Reducir tiempo de setup de 2-3 días a < 1 hora
- **Maintenance:** Scripts versionados, auditable, documentado
- **Security:** Contenedores aislados sin acceso a host físico
- **Community:** Vagrant tiene documentación amplia y comunidad activa
- **Cost:** Vagrant y VirtualBox son open source

---

## 3. Opciones Consideradas

### Opción 1: Docker Desktop en Host Físico

**Descripción:**
Instalar Docker Desktop directamente en la máquina del desarrollador para ejecutar DevContainers.

**Pros:**

- OK: Rendimiento directo (sin overhead de virtualización completa)
- OK: Integración nativa con VS Code Dev Containers
- OK: Bajo overhead de recursos en macOS M1/M2
- OK: Comunidad grande y documentación amplia
- OK: Setup rápido (`docker-compose up`)

**Contras:**

- NO: Docker Desktop requiere licencia comercial para empresas grandes
- NO: Conflictos en Windows con Hyper-V y WSL2
- NO: No funciona en todas las máquinas corporativas (restricciones IT)
- NO: Contamina host físico con servicios de contenedores
- NO: Problemas de performance en Windows (WSL2 <> Windows sync)

**Limitación Crítica:** No es viable para equipos con restricciones de licencia

---

### Opción 2: Vagrant + VM con Podman/Docker (RECOMENDADA)

**Descripción:**
Usar Vagrant para provisionar una VM (Ubuntu Server) que aloja el runtime de contenedores (Podman rootless o Docker). El desarrollador se conecta vía SSH.

**Pros:**

- OK: Docker/Podman solo dentro de la VM, no en host
- OK: Completamente aislado: host permanece limpio
- OK: Funciona en Windows, macOS, Linux sin restricciones
- OK: Vagrant es open source (sin costos de licencia)
- OK: VirtualBox es libre y multiplataforma
- OK: Vagrantfile versionado = reproducibilidad garantizada
- OK: Environmental consistency perfecta entre dev y CI/CD
- OK: Operaciones predecibles: misma image, misma provisión
- OK: Deterministic execution: VM idéntica cada vez
- OK: Fácil rollback: `vagrant destroy && vagrant up`
- OK: Escalable: agregar runners CI/CD sin cambios mayores

**Contras:**

- NO: Overhead de virtualización (RAM: ~2-4 GB, CPU: ~1-2 cores)
- NO: Boot time más lento que Docker Desktop (~30-60 segundos)
- NO: Requiere VirtualBox instalado (software adicional)
- NO: Curva de aprendizaje con Vagrant/SSH vs Docker local
- NO: Mayor complejidad en troubleshooting vs Docker Desktop

---

### Opción 3: WSL2 + Docker (Windows Only)

**Descripción:**
En Windows, usar WSL2 (Windows Subsystem for Linux 2) con Docker instalado en WSL2.

**Pros:**

- OK: Integración nativa en Windows
- OK: Mejor performance que Hyper-V puro
- OK: Acceso a Docker desde Windows

**Contras:**

- NO: Solo para Windows, no para macOS/Linux
- NO: Requiere Windows 10/11 versión específica
- NO: Issues de sincronización de archivos entre Windows y WSL2
- NO: Requiere Docker Desktop (mismo problema de licencia)
- NO: Inconsistente con experiencia de desarrolladores en macOS/Linux

**Limitación Crítica:** No es multi-plataforma

---

### Opción 4: Instalación Nativa (RECHAZADA)

**Descripción:**
Cada desarrollador instala Podman/Docker localmente en su SO.

**Pros:**

- OK: Máxima performance (sin overhead)
- OK: Setup directo

**Contras:**

- NO: Inconsistencia total entre máquinas
- NO: Conflictos de versiones
- NO: Onboarding complejo (2-3 días)
- NO: Contaminación de host
- NO: Imposible versionar

**Decisión:** RECHAZADA por inconsistencia

---

## 4. Decisión

**Opción elegida:** **Opción 2: Vagrant + VM con Podman/Docker**

**Ratificado por:** Equipo de Arquitectura, Equipo de DevOps

**Fecha de aceptación:** 2025-11-18

---

## 5. Justificación

### 5.1 Razones Principales

1. **Environmental Consistency**
   - VM = fuente de verdad única
   - Mismo SO (Ubuntu Server) para todos
   - Mismo runtime (Podman o Docker en VM)
   - Desarrollo = CI/CD: operaciones idénticas

2. **Operational Equivalence**
   - Vagrantfile versionado = reproducibilidad
   - Scripts de provisión = deterministic
   - Misma image base → mismo comportamiento
   - No hay "funciona en mi máquina"

3. **Deterministic Execution**
   - Cada `vagrant up` produce VM idéntica
   - No hay variables de ambiente del host
   - Versiones de servicios controladoras
   - Rollback simple: destroy + up

4. **Multi-Platform Support**
   - Windows, macOS, Linux (sin variación)
   - Ningún SO especial requerido
   - Vagrant abstrae diferencias

5. **No Licenciamiento**
   - Vagrant: open source
   - VirtualBox: open source
   - Podman: open source
   - Zero licensing costs

6. **Host Físico Limpio**
   - No instalar Docker en host
   - No contaminar máquina de desarrollo
   - Host = utilidades de desarrollo únicamente
   - VM = infraestructura

### 5.2 Trade-offs Aceptados

| Trade-off | Razón |
|-----------|-------|
| Overhead de virtualización (~3GB RAM) | Compensado por consistency y isolation |
| Boot time (~30-60s) | Aceptable, se ejecuta 1x al inicio |
| Complejidad adicional (Vagrant + SSH) | Documentación y scripts automatizar setup |
| Requiere VirtualBox | Open source, ampliamente disponible |

### 5.3 Alineación Estratégica

Esta decisión **alinea** con:
- Canvas de Arquitectura: `devcontainer-host-vagrant.md` [OK]
- Principio DevOps: Infrastructure as Code [OK]
- Principio de Automatización: Scripts versionados [OK]
- Principio de Reproducibilidad: Deterministic execution [OK]

---

## 6. Consecuencias

### 6.1 Positivas

- **OK: Onboarding acelerado**
  - De 2-3 días a <1 hora
  - `vagrant up` automatiza todo
  - Documentación clear

- **OK: Consistency garantizada**
  - Mismo ambiente todos los desarrolladores
  - Cero "funciona en mi máquina"
  - Debugging simplificado

- **OK: CI/CD equivalente**
  - Runner usa misma image que development
  - Pipelines reproducibles
  - No hay sorpresas en CI

- **OK: Host limpio**
  - Máquina de desarrollo sin Docker/Podman
  - Sin conflictos de puerto/versión
  - Fácil rollback (vagrant destroy)

- **OK: Versionable y auditable**
  - Vagrantfile en Git
  - Scripts de provisión documentados
  - Historial de cambios

- **OK: Seguridad mejorada**
  - Aislamiento de contenedores en VM
  - Host no expuesto
  - Sandbox completo

### 6.2 Negativas

- **WARNING: Overhead de recursos**
  - VM requiere ~3GB RAM (sobre base system)
  - Máquinas con <8GB RAM pueden ser lentas
  - Mitigación: documentar requisitos mínimos

- **WARNING: Boot time**
  - Primera ejecución: ~1-2 minutos
  - Subsecuentes: ~30-60 segundos
  - Mitigación: no es frecuente; documentar

- **WARNING: Complejidad operacional**
  - Curva de aprendizaje con Vagrant
  - Troubleshooting requiere conocimiento de SSH/VM
  - Mitigación: documentación, runbooks, scripts helpers

- **WARNING: Performance disk I/O**
  - Sincronización de archivos host <-> VM puede ser lenta
  - Mitigación: usar NFS mount o /srv/projects en VM

- **WARNING: Requiere software adicional**
  - VirtualBox debe estar instalado
  - Vagrant must be in PATH
  - Mitigación: install scripts automatizados

### 6.3 Neutrales

- **INFO: Cambio en workflow**
  - Desarrolladores acostumbrados a Docker Desktop necesitan adaptar
  - `vagrant up` vs `docker-compose up`
  - Se aprende rápido con documentación

- **INFO: Mantenimiento de Vagrantfile**
  - Scripts de provisión deben actualizarse con nuevas dependencias
  - Mitigación: CI/CD valida provision.sh

- **INFO: Escalabilidad de VM**
  - Si proyecto crece, puede requerir más recursos
  - Mitigación: fácil ajustar CPU/RAM en Vagrantfile

---

## 7. Plan de Implementación

### 7.1 Fase 1: Preparación y Baselines (1 semana)

**Objetivo:** Crear Vagrantfile base y provision.sh funcional

**Acciones:**

1. **Crear Vagrantfile**
   - Definir box: `ubuntu/focal64` o `ubuntu/jammy64`
   - Configurar VM: 4 vCPUs, 8GB RAM, 80GB disco
   - Networking: IP privada `192.168.56.10`, SSH forward
   - File sharing: /srv/projects, /srv/devcontainers

2. **Crear provision.sh**
   - Actualizar sistema (`apt update && apt upgrade`)
   - Instalar Podman + dependencies
   - Configurar usuario `dev` con sudo
   - Habilitar `loginctl enable-linger dev` (rootless)
   - Instalar Docker CLI (opcional)

3. **Crear usuario dev**
   - Home en `/home/dev`
   - SSH key-based auth
   - Sudoers sin password

**Deliverables:**
- Vagrantfile versionado
- provision.sh testeable
- Base documentation

**Timeframe:** 1 semana

---

### 7.2 Fase 2: DevContainer Base y Validación (1 semana)

**Objetivo:** Crear DevContainer funcional y validar en VM

**Acciones:**

1. **Crear devcontainer.json base**
   ```json
   {
     "name": "IACT Development",
     "image": "ubuntu:22.04",
     "features": {...},
     "remoteUser": "dev",
     "postCreateCommand": "./scripts/bootstrap.sh"
   }
   ```

2. **Crear Dockerfile para DevContainer**
   - Base: ubuntu:22.04
   - Instalar toolchain (Python, Node, Git, etc.)
   - Instalar herramientas de desarrollo (pytest, linting, etc.)
   - Configurar entrypoint

3. **Validar en VM**
   - `vagrant up`
   - SSH a VM: `vagrant ssh`
   - Ejecutar DevContainer: `devcontainer open`
   - Pruebas básicas (Python, Node, Git)

4. **Documentar troubleshooting común**
   - Permisos de usuario
   - Mount issues
   - Network issues
   - SSH auth issues

**Deliverables:**
- Dockerfile funcional
- devcontainer.json
- Validation scripts
- Troubleshooting guide

**Timeframe:** 1 semana

---

### 7.3 Fase 3: CI/CD Integration y Documentación (1 semana)

**Objetivo:** Integrar con CI/CD y documentar completamente

**Acciones:**

1. **Setup CI/CD Runner**
   - GitHub Actions Self-Hosted Runner (opcional)
   - Usa misma image que development
   - Ejecuta en /srv/projects/ci

2. **Documentación completa**
   - README: instalación y quick start
   - Architecture document: explicar design
   - Troubleshooting guide: problemas comunes
   - Developer guide: workflow diario

3. **Crear helper scripts**
   - `scripts/vagrant-init.sh`: setup inicial
   - `scripts/vagrant-clean.sh`: cleanup
   - `scripts/devcontainer-validate.sh`: validation

4. **Testing en múltiples plataformas**
   - Windows 10/11 + Vagrant + VirtualBox
   - macOS (Intel + M1)
   - Linux (Ubuntu 20.04+)

**Deliverables:**
- Complete documentation
- Helper scripts
- CI/CD runner config
- Platform test results

**Timeframe:** 1 semana

---

### 7.4 Timeline Resumido

```
Semana 1: Vagrantfile + provision.sh
Semana 2: DevContainer base + validación
Semana 3: CI/CD + documentación
Semana 4: Testing multi-plataforma + review
```

**Total:** ~4 semanas (FASE_3_CONTENIDO_NUEVO)

---

## 8. Validación y Métricas

### 8.1 Criterios de Éxito

| Criterio | Métrica Objetivo | Método de Medición |
|----------|-----------------|-------------------|
| Reproducibilidad VM | 100% consistent | `vagrant up` x5, checksum validate |
| Onboarding time | <1 hora | Cronometrar nuevo dev |
| First execution success | >95% | Beta testing con 5+ devs |
| Vagrant up time (first) | <2 minutos | Cronometrar con timing |
| Vagrant up time (subsec) | <1 minuto | Cronometrar con timing |
| DevContainer startup | <30 segundos | `devcontainer open` timing |
| CI/CD parity | 100% | Mismo output dev vs CI |
| Documentation completeness | 100% | Checklist coverage |

### 8.2 Cómo Medir

**Reproducibilidad:**
```bash
# Crear VM 5 veces, validar hash de configuración
for i in {1..5}; do
  vagrant destroy -f
  vagrant up
  vagrant ssh -c "sha256sum /etc/os-release"
done
```

**Onboarding:**
- Cronometrar nuevo developer: "Desde clone repo hasta primer test passing"
- Target: <1 hora

**Success Rate:**
- Beta testing con 5+ desarrolladores
- Count: cuántos logran `vagrant up && devcontainer open` sin intervención

**Performance:**
```bash
time vagrant up      # First execution
time vagrant up      # Cached execution
```

**CI/CD Parity:**
- Ejecutar mismo test en dev y CI
- Comparar output: debe ser idéntico

### 8.3 Revisión Programada

- **Fecha de revisión:** 2025-12-15 (4 semanas post-implementación)
- **Responsable:** Equipo DevOps
- **Stakeholders:** Equipo de Arquitectura, Developers
- **KPIs a revisar:**
  - Adopción (% de devs usando la VM)
  - Issue frequency (problemas reportados)
  - Onboarding success rate
  - Performance metrics

### 8.4 Criterios de Aceptación

Para considerar implementación **exitosa**:

- [OK] Vagrantfile pasa validación en Windows/macOS/Linux
- [OK] provision.sh ejecuta sin errores
- [OK] DevContainer inicia en <30s
- [OK] Onboarding <1 hora
- [OK] >95% primera ejecución exitosa
- [OK] Documentación 100% completa
- [OK] CI/CD ejecuta con parity

---

## Referencias

### Documentación Interna

- [Canvas Arquitectura DevContainer Host Vagrant](/docs/infraestructura/diseno/arquitectura/devcontainer-host-vagrant.md)
- [Canvas CI/CD Pipeline DevContainer](/docs/infraestructura/diseno/arquitectura/devcontainer-host-vagrant-pipeline.md)
- [Plantilla ADR](/docs/gobernanza/adr/plantilla_adr.md)
- [Índice ADRs](/docs/gobernanza/adr/README.md)

### Referencias Técnicas

- [Vagrant Official Docs](https://www.vagrantup.com/docs)
- [VirtualBox Documentation](https://www.virtualbox.org/wiki/Documentation)
- [Podman Rootless Setup](https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md)
- [Dev Containers Specification](https://containers.dev/)
- [VS Code Remote SSH](https://code.visualstudio.com/docs/remote/ssh)

### Estándares de Proyecto

- [ADR-DEVOPS-001: Vagrant + mod_wsgi](/docs/gobernanza/adr/ADR-DEVOPS-001-vagrant-mod-wsgi.md)
- [ADR-GOB-002: Organización por Dominios](/docs/gobernanza/adr/ADR-GOB-002-organizacion-proyecto-por-dominio.md)

---

## Notas Adicionales

### Fecha de Discusión Inicial

- **Discusión:** 2025-11-10
- **Decisión formal:** 2025-11-18

### Participantes

- Equipo de Arquitectura
- Equipo de DevOps
- Tech Lead Infrastructure

### Alternativas Tempranas Descartadas

1. **Kubernetes en Desktop**
   - Descartado: Overhead prohibitivo para desarrollo local

2. **Colima (Container runtime para macOS)**
   - Descartado: Solo para macOS, no multi-plataforma

3. **GitHub Codespaces**
   - Descartado: Costo operacional, dependencia de cloud

### Evolución Futura

**Posibles mejoras post-implementación:**

1. **Automatización de snapshot/restore**
   - Crear snapshots de VM limpia
   - Restaurar rápidamente para fresh start

2. **Multi-version VM support**
   - Mantener varias versiones de toolchain
   - Facilitar testing en diferentes versiones

3. **Distributed DevContainer Host**
   - Si el equipo crece, considerar hosts compartidos
   - Escalabilidad horizontal

4. **Performance optimization**
   - Investigar NFS mounts vs VirtualBox shared folders
   - Minimizar overhead I/O

---

**Versión:** 1.0
**Última actualización:** 2025-11-18
**Estado:** Propuesta
**Próximo hito:** Revisión de Arquitectura (2025-12-01)
