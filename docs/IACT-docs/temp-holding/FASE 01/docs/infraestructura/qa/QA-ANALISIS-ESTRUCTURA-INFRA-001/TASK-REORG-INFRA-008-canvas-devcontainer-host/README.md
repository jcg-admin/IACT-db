---
id: TASK-REORG-INFRA-008
tipo: tarea_contenido
categoria: arquitectura
nombre: Crear Canvas DevContainer Host
titulo: Crear Canvas DevContainer Host
fase: FASE_3_CONTENIDO_NUEVO
prioridad: ALTA
duracion_estimada: 6h
estado: pendiente
dependencias: [TASK-REORG-INFRA-006]
tecnica_prompting: Template-based Prompting, Auto-CoT, Self-Consistency
tags: [canvas, arquitectura, devcontainer, vagrant, infraestructura]
---

# TASK-REORG-INFRA-008: Crear Canvas DevContainer Host

**Objetivo:** Documentar la arquitectura completa de un DevContainer Host gestionado por Vagrant, sin Docker en el host físico. Crear artefacto Canvas con las 10 secciones obligatorias, incluyendo diagrama ASCII, ejemplos de código (Vagrantfile y provision.sh) y checklist de implementación.

**Responsable:** Equipo de Plataforma / DevOps
**Restricciones:** 10 secciones Canvas completas, diagramas ASCII, ejemplos funcionales, cobertura de riesgos.
**Técnica de prompting:** Template-based Prompting + Auto-CoT + Self-Consistency.

---

## Alcance

Esta tarea documentará el artefacto Canvas que define:
- Arquitectura técnica para ejecutar DevContainers sin instalar Docker en máquinas físicas
- Modelo donde la VM Vagrant es fuente de verdad del entorno contenido
- Flujo operativo de desarrollo y CI/CD integrado
- Especificación técnica (Vagrantfile, provision.sh, bootstrap.sh)
- Mitigación de riesgos y checklist operacional

**Ubicación destino:** `docs/infraestructura/diseno/arquitectura/canvas-devcontainer-host-vagrant.md`

---

## Contenido del Canvas (10 secciones)

### 1. Identificación del artefacto
- Nombre: Arquitectura del DevContainer Host con Vagrant
- Propósito: Definir arquitectura técnica para ejecutar DevContainers sin Docker en host físico
- Proyecto: IACT / Plataforma de Desarrollo y CI/CD
- Autor: Equipo de Plataforma / DevOps
- Versión: 1.0
- Estado: Activo

### 2. Descripción general
- Desarrolladores NO instalan Docker en máquina física
- Todo entorno de contenedores ejecuta en VM administrada por Vagrant
- VM (DevContainer Host) = fuente de verdad del entorno
- VS Code se conecta por Remote SSH para abrir DevContainer
- Repositorios en `/srv/projects`, DevContainers en `/srv/devcontainers`
- Runtime de contenedores en `/var/lib/containers`

### 3. Objetivo técnico
Asegurar:
- **Environmental consistency:** mismo entorno para desarrollo y CI/CD
- **Operational equivalence:** uniformidad entre pipelines
- **Deterministic execution:** ejecución predecible y reproducible
- **Unified toolchain:** herramientas centralizadas sin Docker local

### 4. Componentes de la arquitectura
#### 4.1 Workstation del desarrollador
- SO: Windows / macOS / Linux
- Software: VS Code + Remote SSH + Dev Containers
- Restricción: **No tiene Docker instalado**

#### 4.2 DevContainer Host (VM Vagrant)
- SO: Ubuntu Server LTS (20.04 o 22.04)
- Recursos: 4 vCPUs, 8 GB RAM, disco 80–120 GB dinámico
- Funciones: ejecuta runtime OCI, aloja DevContainers y repositorios

#### 4.3 Runtime de contenedores
- Opción recomendada: Podman rootless
- Opción alternativa: Docker dentro de VM
- Compatibilidad: imágenes OCI, DevContainer CLI

#### 4.4 DevContainer
- Definido por: devcontainer.json, Dockerfile, scripts bootstrap
- Incluye: toolchain completo, dependencias sistema y aplicación
- Reutilizado: desarrollo + CI/CD

#### 4.5 Runner CI/CD (opcional)
- GitHub Actions Self-Hosted Runner o GitLab Runner
- Usa: misma imagen base y runtime que DevContainers

### 5. Flujo de trabajo

#### 5.1 Desarrollo local (workstation sin Docker)
1. Ejecutar: `vagrant up iact-devcontainer-host`
2. VS Code conecta por SSH a `dev@iact-devcontainer-host`
3. Abrir proyecto en `/srv/projects/iact` dentro de VM
4. Iniciar DevContainer
5. Pruebas, builds y depuración dentro del contenedor

#### 5.2 CI/CD
1. Runner CI/CD instalado dentro de VM
2. Pipeline utiliza misma imagen del DevContainer
3. Ejecución dentro del mismo entorno que desarrollo
4. Reutilización de caches y toolchains

### 6. Diagrama de arquitectura (ASCII)
```
+-----------------------------------------------------------+
|        Workstation del Desarrollador (sin Docker)        |
|-----------------------------------------------------------|
|  VS Code + Remote SSH                                     |
|  VS Code + Dev Containers                                 |
+-------------+---------------------------------------------+
              |
              | SSH
              v
+-----------------------------------------------------------+
|                Vagrant VM: DevContainer Host              |
|-----------------------------------------------------------|
|  SO: Ubuntu Server                                        |
|  Runtime Contenedores (Podman rootless / Docker en VM)    |
|                                                           |
|   +----------------------+     +-----------------------+  |
|   | DevContainer         |     | Runner CI/CD         |  |
|   | - toolchain          |     | - usa misma imagen   |  |
|   | - dependencias       |     | - ejecuta pruebas    |  |
|   +----------------------+     +-----------------------+  |
+-----------------------------------------------------------+
```

### 7. Especificación de código

#### 7.1 Vagrantfile
```ruby
Vagrant.configure("2") do |config|
  config.vm.define "iact-devcontainer-host" do |vm|
    vm.vm.box = "ubuntu/focal64"
    vm.vm.hostname = "iact-devcontainer-host"
    vm.vm.network "private_network", ip: "192.168.56.10"

    vm.vm.provider "virtualbox" do |vb|
      vb.memory = "8192"
      vb.cpus   = 4
      vb.name   = "IACT-DevContainer-Host"
    end

    vm.vm.provision "shell", path: "provision.sh"

    # Sincronizar carpeta de proyectos
    vm.vm.synced_folder ".", "/vagrant", disabled: false
  end
end
```

#### 7.2 provision.sh
```bash
#!/usr/bin/env bash
set -e

# Actualizar sistema
apt-get update
apt-get upgrade -y
apt-get install -y \
  git \
  curl \
  build-essential \
  uidmap \
  wget \
  ca-certificates \
  gnupg \
  lsb-release

# Instalación de Podman (rootless)
apt-get install -y podman podman-plugins

# Crear usuario dev
useradd -m -s /bin/bash dev || true
echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/dev

# Configuración del entorno rootless para Podman
loginctl enable-linger dev || true
mkdir -p /home/dev/.local/share/containers
mkdir -p /home/dev/.config/containers
chown -R dev:dev /home/dev/.local /home/dev/.config

# Crear directorios de proyecto
mkdir -p /srv/projects
mkdir -p /srv/devcontainers
mkdir -p /var/lib/containers

# Permisos apropiados
chown dev:dev /srv/projects
chown dev:dev /srv/devcontainers
chmod 755 /srv/projects /srv/devcontainers

# Instalar DevContainer CLI (opcional, pero recomendado)
npm install -g @devcontainers/cli || true

echo "[OK] Provisioning completado exitosamente"
```

#### 7.3 Estructura base de DevContainer (devcontainer.json)
```json
{
  "name": "IACT Dev Container",
  "image": "localhost/iact-devcontainer:latest",
  "remoteUser": "dev",
  "postCreateCommand": "./bootstrap.sh",
  "features": {
    "ghcr.io/devcontainers/features/git:1": {},
    "ghcr.io/devcontainers/features/python:1": {
      "version": "3.11"
    }
  },
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-python.python",
        "ms-python.vscode-pylance",
        "github.copilot"
      ]
    }
  }
}
```

#### 7.4 bootstrap.sh (dentro del DevContainer)
```bash
#!/usr/bin/env bash
set -e

echo "→ Bootstrap del DevContainer iniciado..."

# Instalar dependencias de aplicación
pip install --upgrade pip
pip install -r requirements.txt

# Instalar herramientas de desarrollo
pip install pytest pytest-cov black flake8 mypy

echo "[OK] Bootstrap completado"
```

### 8. Objetivos de calidad

| Objetivo | Descripción | Métrica |
|----------|-------------|---------|
| **Reproducibilidad** | Mismo entorno para desarrollo y CI/CD | Vagrantfile + provision.sh versionados |
| **Aislamiento** | Host físico no maneja contenedores; solo VM | No Docker en workstation |
| **Portabilidad** | Workstation sin dependencias pesadas | DevContainer CLI + Remote SSH |
| **Extensibilidad** | Fácil añadir runner CI/CD | Plugin system en provision.sh |
| **Mantenibilidad** | Scripts y configuración versionados | Git hooks + tests de provision |
| **Determinismo** | Ejecución predecible y reproducible | Pinned versions en Dockerfile |

### 9. Riesgos y mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|-------------|--------|-----------|
| **Inconsistencia entre VMs** | Media | Alta | Versionar Vagrantfile y provisioners; programar regeneración (`vagrant destroy && vagrant up`) |
| **Degradación de rendimiento** | Media | Media | Ajustar RAM/CPU según proyecto; evitar Docker Desktop; preferir Podman rootless |
| **Configuración duplicada** | Baja | Media | DevContainer define toolchain una sola vez para desarrollo y CI/CD |
| **Sincronización de archivos lenta** | Media | Baja | Usar rsync o NFS en lugar de shared folders si es crítico |
| **Acceso SSH sin configuración** | Alta | Media | Generar pares SSH automáticamente; documentar setup inicial |
| **VM con espacio insuficiente** | Baja | Alta | Monitorear `/var/lib/containers`; implementar limpieza de capas antiguas |

### 10. Checklist de implementación

#### Fase de Preparación
- [ ] Revisar restricciones del proyecto (sin Docker en host)
- [ ] Validar SO soportados: Windows (WSL2), macOS, Linux
- [ ] Confirmar Virtualbox / Hyper-V / KVM disponible

#### Fase de Creación (Infraestructura)
- [ ] Crear `Vagrantfile` con configuración correcta de recursos
- [ ] Crear `provision.sh` con instalación de Podman rootless
- [ ] Crear usuario `dev` con permisos sudoers sin contraseña
- [ ] Validar directorios `/srv/projects`, `/srv/devcontainers`, `/var/lib/containers`
- [ ] Instalar DevContainer CLI en VM (opcional)

#### Fase de Contenedor
- [ ] Crear `devcontainer.json` con imagen base
- [ ] Crear Dockerfile para imagen `iact-devcontainer:latest`
- [ ] Crear `bootstrap.sh` dentro del contenedor
- [ ] Validar que DevContainer se inicia correctamente

#### Fase de Configuración SSH
- [ ] Generar pares SSH en workstation
- [ ] Configurar VS Code Remote SSH extension
- [ ] Validar conexión SSH a `dev@iact-devcontainer-host`
- [ ] Conectar DevContainer desde VS Code

#### Fase de CI/CD (opcional)
- [ ] Registrar GitHub Actions Self-Hosted Runner en VM
- [ ] Crear workflow que use misma imagen DevContainer
- [ ] Validar que pipeline ejecuta en el mismo entorno

#### Fase de Documentación y Testing
- [ ] Documentar flujo completo en troubleshooting
- [ ] Crear scripts de testing para validar provision.sh
- [ ] Crear guía de recovery ante fallos
- [ ] Validar que 10 secciones del Canvas están completas
- [ ] Realizar audit de seguridad (SSH keys, permisos)

#### Fase de Cierre
- [ ] Generar evidencias de ejecución completa
- [ ] Actualizar checklist con resultados
- [ ] Documentar lecciones aprendidas
- [ ] Versionar todo en Git

---

## Pasos principales

1. **Analizar estructura Canvas existente:** Validar que el archivo `docs/infraestructura/diseno/arquitectura/devcontainer-host-vagrant.md` contiene las 10 secciones completas.

2. **Validar secciones Canvas con Self-Consistency:**
   - Sección 1: Identificación [OK]
   - Sección 2: Descripción general [OK]
   - Sección 3: Objetivo técnico [OK]
   - Sección 4: Componentes [OK]
   - Sección 5: Flujo de trabajo [OK]
   - Sección 6: Diagrama ASCII [OK]
   - Sección 7: Especificación de código [OK]
   - Sección 8: Objetivos de calidad [OK]
   - Sección 9: Riesgos y mitigaciones [OK]
   - Sección 10: Checklist de implementación [OK]

3. **Documentar artefacto:** Generar evidencia de que el Canvas cumple con todas las secciones requeridas.

4. **Crear artefactos complementarios:**
   - Guía de troubleshooting
   - Scripts de validación automatizada
   - Diagrama de estados de VM

5. **Validar completitud:** Checklist de las 10 secciones del Canvas.

---

## Entregables

- **Canvas completo:** `docs/infraestructura/diseno/arquitectura/canvas-devcontainer-host-vagrant.md` (10 secciones)
- **Diagrama ASCII:** Incluido en Sección 6 del Canvas
- **Ejemplos de código:** Vagrantfile, provision.sh, devcontainer.json en Sección 7
- **Guía de implementación:** Checklist operacional en Sección 10
- **Evidencias:** Validación de completitud en `./evidencias/canvas-validation-report.md`

---

## Validación con Self-Consistency

Verificar que el Canvas tiene las 10 secciones completas:

```
[OK] Sección 1: Identificación del artefacto (nombre, propósito, proyecto, versión)
[OK] Sección 2: Descripción general (modelo, componentes principales, flujo alto nivel)
[OK] Sección 3: Objetivo técnico (environmental consistency, deterministic execution)
[OK] Sección 4: Componentes de la arquitectura (workstation, VM, runtime, DevContainer, CI/CD)
[OK] Sección 5: Flujo de trabajo (desarrollo local, CI/CD)
[OK] Sección 6: Diagrama de arquitectura (ASCII visual)
[OK] Sección 7: Especificación de código (Vagrantfile, provision.sh, devcontainer.json, bootstrap.sh)
[OK] Sección 8: Objetivos de calidad (reproducibilidad, aislamiento, portabilidad, extensibilidad, mantenibilidad)
[OK] Sección 9: Riesgos y mitigaciones (tabla con probabilidad, impacto, mitigación)
[OK] Sección 10: Checklist de implementación (5 fases: preparación, infraestructura, contenedor, SSH, CI/CD, docs)
```

---

## Evidencias

Colocar toda evidencia en `./evidencias/canvas-validation-report.md`:
- Timestamp de ejecución de validación
- Lista de 10 secciones verificadas
- Diagrama ASCII validado
- Ejemplos de código probados
- Checklist de implementación revisado
- Referencias a commit donde se documentó el Canvas

---

## Notas técnicas

### Diferencia Docker vs Podman rootless
- **Docker:** Requiere daemon root, disponible solo si se instala en host
- **Podman rootless:** Ejecuta sin permisos root, ideal para entornos compartidos
- **En esta arquitectura:** Ambos se instalan DENTRO de la VM, no en el host

### Ventajas del modelo
1. Workstation limpia de dependencias pesadas
2. Desarrollo en macOS/Windows sin Docker Desktop
3. CI/CD usa exactamente el mismo entorno
4. VM reutilizable entre proyectos

### Consideraciones de seguridad
- Generar SSH keys automáticamente en primer `vagrant up`
- Restringir acceso SSH a red local (private_network)
- No incluir credenciales en Vagrantfile (usar .env local)

---

## Referencias

- **Canvas original:** `docs/infraestructura/diseno/arquitectura/devcontainer-host-vagrant.md`
- **Relacionados:**
  - `TASK-REORG-INFRA-006` (dependencia)
  - `docs/infraestructura/devcontainer/` (implementaciones)
  - `docs/infraestructura/guias/` (tutoriales)

---

## Checklist de salida

- [ ] Canvas de 10 secciones completamente documentado
- [ ] Diagrama ASCII incluido y validado
- [ ] Ejemplos de Vagrantfile, provision.sh, devcontainer.json incluidos
- [ ] Tabla de riesgos y mitigaciones completada
- [ ] Checklist de implementación (5 fases) completo
- [ ] Evidencias documentadas en `./evidencias/canvas-validation-report.md`
- [ ] Referencias cruzadas con tareas relacionadas actualizadas
- [ ] Commit con tag `canvas-devcontainer-host-v1.0`

---

**Fecha creación:** 2025-11-18
**Estado:** Pendiente
**Prioridad:** ALTA
**Duración estimada:** 6 horas
