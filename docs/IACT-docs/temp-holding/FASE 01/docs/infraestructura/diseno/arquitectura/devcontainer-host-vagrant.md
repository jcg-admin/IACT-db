---
id: DOC-ARQ-DEVCONTAINER-HOST-VAGRANT
estado: activo
propietario: equipo-plataforma-devops
ultima_actualizacion: 2025-11-20
relacionados: ["DOC-DEVOPS-INDEX", "DOC-INFRA-INDEX", "DOC-ARQ-INFRA"]
---
# Canvas de Arquitectura — DevContainer Host con Vagrant (sin Docker en el host físico)

Documento de referencia para operar DevContainers y pipelines CI/CD en una VM gestionada por Vagrant cuando el workstation no puede instalar Docker. Esta versión consolida el modelo de arquitectura, flujo operativo y ejemplos base para reproducir el host.

## 1. Identificación del artefacto
- **Nombre:** Arquitectura del DevContainer Host con Vagrant
- **Propósito:** Definir la arquitectura técnica para ejecutar DevContainers sin instalar Docker en el host físico del desarrollador.
- **Proyecto:** IACT / Plataforma de Desarrollo y CI/CD
- **Autor:** Equipo de Plataforma / DevOps
- **Versión:** 1.0
- **Estado:** Activo

## 2. Descripción general
Esta arquitectura define un modelo donde:
- Los desarrolladores **no instalan Docker** en su máquina física.
- Todo el entorno de contenedores se ejecuta dentro de una **VM administrada por Vagrant**.
- La VM (DevContainer Host) es la **fuente de verdad del entorno**, donde viven toolchains, runtime de contenedores (Podman o Docker dentro de la VM), DevContainers y, opcionalmente, el runner de CI/CD.
- VS Code se conecta a la VM por **Remote SSH** para abrir y ejecutar el DevContainer.
- Los repositorios se ubican en `/srv/projects` y las imágenes/configuración de contenedores en `/srv/devcontainers`, con almacenamiento de runtime en `/var/lib/containers`.

## 3. Objetivo técnico
Asegurar **environmental consistency**, **operational equivalence**, **deterministic execution** y **unified toolchain** entre el DevContainer de desarrollo, los pipelines de CI/CD y la VM DevContainer Host, todo sin instalar Docker en el host físico.

## 4. Componentes de la arquitectura
### 4.1 Workstation del desarrollador
- SO: Windows / macOS / Linux
- Software: VS Code + Remote SSH + Dev Containers
- Restricción: **No tiene Docker instalado**

### 4.2 DevContainer Host (VM gestionada por Vagrant)
- SO: Ubuntu Server LTS (20.04 o 22.04)
- Recursos: 4 vCPUs, 8 GB RAM, disco 80–120 GB dinámico
- Funciones:
  - Ejecuta el runtime de contenedores (Podman rootless o Docker dentro de la VM)
  - Aloja DevContainers, toolchains y repositorios
  - Puede ejecutar el runner de CI/CD (self-hosted)

### 4.3 Runtime de contenedores dentro de la VM
- **Opción recomendada:** Podman rootless
- **Opción alternativa:** Docker solo dentro de la VM
- Compatibilidad: imágenes OCI, DevContainer CLI, integración estable con VS Code

### 4.4 DevContainer
- Definido por `devcontainer.json`, Dockerfile (si aplica) y scripts de bootstrap
- Incluye toolchain completo, dependencias de sistema y de aplicación
- Reutilizado tanto por desarrollo como por CI/CD

### 4.5 Runner CI/CD (opcional)
- GitHub Actions Self-Hosted Runner o GitLab Runner
- Ejecuta pruebas unitarias, integración, builds y análisis estático
- Usa la misma imagen base y runtime que los DevContainers

## 5. Flujo de trabajo
### 5.1 Desarrollo local (workstation sin Docker)
1. El desarrollador ejecuta `vagrant up iact-devcontainer-host` para provisionar la VM.
2. VS Code se conecta por SSH a `dev@iact-devcontainer-host` usando Remote SSH.
3. Se abre el proyecto en `/srv/projects/iact` dentro de la VM y se inicia el DevContainer.
4. Pruebas, builds y depuración se ejecutan dentro del contenedor en la VM.

### 5.2 CI/CD
1. El runner CI/CD está instalado dentro de la VM.
2. El pipeline utiliza la misma imagen e instrucciones del DevContainer.
3. Las pipelines se ejecutan dentro del mismo entorno que desarrollo, reutilizando caches y toolchains.

## 6. Diagrama de arquitectura (ASCII)
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

## 7. Ejemplos de código
### 7.1 Ejemplo de `Vagrantfile`
```ruby
Vagrant.configure("2") do |config|
  config.vm.define "iact-devcontainer-host" do |vm|
    vm.vm.box = "ubuntu/focal64"
    vm.vm.hostname = "iact-devcontainer-host"
    vm.vm.network "private_network", ip: "192.168.56.10"

    vm.vm.provider "virtualbox" do |vb|
      vb.memory = "8192"
      vb.cpus   = 4
    end

    vm.vm.provision "shell", path: "provision.sh"
  end
end
```

### 7.2 Ejemplo de `provision.sh`
```bash
#!/usr/bin/env bash
set -e

apt update
apt install -y git curl build-essential uidmap

# Instalación de Podman rootless
apt install -y podman

# Crear usuario dev
useradd -m -s /bin/bash dev || true
echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/dev

# Configuración del entorno rootless
loginctl enable-linger dev
```

### 7.3 Estructura base de DevContainer
```json
{
  "name": "IACT Dev Container",
  "image": "localhost/iact-devcontainer:latest",
  "remoteUser": "dev",
  "postCreateCommand": "./bootstrap.sh"
}
```

## 8. Objetivos de calidad
- **Reproducibilidad:** mismo entorno para desarrollo y CI/CD.
- **Aislamiento:** el host físico no maneja contenedores; solo la VM.
- **Portabilidad:** workstation sin dependencias pesadas.
- **Extensibilidad:** se puede añadir runner CI/CD fácilmente.
- **Mantenibilidad:** `Vagrantfile` y scripts de provisión versionados.

## 9. Riesgos y mitigaciones
- **Inconsistencia entre VMs:** versionar `Vagrantfile` y provisioners; programar regeneración (`vagrant destroy && vagrant up`).
- **Degradación de rendimiento:** ajustar RAM/CPU; evitar Docker Desktop; preferir Podman rootless.
- **Configuración duplicada:** el DevContainer define el toolchain una sola vez para desarrollo y CI/CD.

## 10. Checklist de implementación
- [ ] Crear `Vagrantfile` para `iact-devcontainer-host`.
- [ ] Crear `provision.sh` (runtime OCI y usuario `dev`).
- [ ] Instalar runtime OCI (Podman) dentro de la VM.
- [ ] Configurar VS Code Remote SSH.
- [ ] Crear DevContainer base y validarlo en la VM.
- [ ] Registrar runner de CI/CD usando la misma imagen.
- [ ] Documentar flujo completo y troubleshooting de la VM.
- [ ] Automatizar actualización/rotación de la VM.
