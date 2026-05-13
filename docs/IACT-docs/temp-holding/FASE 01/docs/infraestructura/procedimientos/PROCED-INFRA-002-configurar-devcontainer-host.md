---
id: PROCED-INFRA-002
tipo: procedimiento
categoria: infraestructura
subcategoria: devcontainer
version: 1.0.0
fecha_creacion: 2025-11-18
autor: Claude Code (Haiku 4.5)
estado: activo
relacionados: ["TASK-045", "PROCED-INFRA-001"]
---

# PROCED-INFRA-002: Configurar DevContainer Host

## Objetivo

Proporcionar pasos detallados y paso a paso para configurar el host del DevContainer, incluyendo instalación de Docker, Docker Compose, requisitos de red, configuración de permisos, validación de recursos y setup de entorno de desarrollo.

Este es un procedimiento operacional (CÓMO configurar), no un proceso de alto nivel (QUÉ configurar).

---

## Alcance

Este procedimiento cubre:
- Verificación de pre-requisitos (Docker, Docker Compose)
- Instalación y validación de Docker
- Configuración de Docker Daemon
- Instalación de Docker Compose
- Configuración de permisos y networking
- Setup de volúmenes compartidos
- Validación de recursos disponibles
- Testing de conectividad
- Troubleshooting de problemas comunes
- Rollback a estado anterior

**NO cubre**:
- Instalación inicial del SO base
- Configuración de firewall avanzada
- Deployment a producción
- Customización avanzada de Docker

---

## Pre-requisitos

Antes de ejecutar este procedimiento, verificar:

### Hardware
- [ ] CPU con virtualización habilitada (VT-x o AMD-V)
- [ ] Mínimo 8 GB RAM disponible
- [ ] Mínimo 50 GB espacio libre en disco
- [ ] Conexión a Internet estable

### Software Requerido
- [ ] Sistema operativo Linux (Ubuntu 20.04+ o similar)
- [ ] Git instalado
- [ ] Curl o Wget disponible
- [ ] Acceso sudo en el sistema

### Verificación de Requisitos

```bash
# Verificar sistema operativo
lsb_release -a
# Esperado: Ubuntu 20.04 LTS o superior

# Verificar virtualizacion
grep -c vmx /proc/cpuinfo
# Esperado: > 0

# Verificar espacio disco
df -h /
# Esperado: >= 50GB disponible

# Verificar RAM
free -h
# Esperado: >= 8GB total
```

### Conocimiento Requerido
- Línea de comandos Linux/bash
- Conceptos básicos de Docker
- Networking TCP/IP básico
- SSH y gestión de permisos Linux

---

## Roles y Responsabilidades

| Rol | Responsabilidad |
|-----|-----------------|
| **DevOps Engineer** | Ejecuta procedimiento, configura Docker, troubleshooting |
| **Developer** | Valida funcionalidad, prueba DevContainer |
| **Tech Lead** | Aprueba cambios, revisa logs |

---

## Procedimiento Detallado

### PASO 1: Verificar Pre-requisitos del Sistema

#### 1.1 Validar versión del SO

```bash
# Obtener información del SO
lsb_release -a

# Esperado:
# Ubuntu 20.04 LTS o superior
```

#### 1.2 Verificar virtualizacion habilitada

```bash
# Linux
grep -c vmx /proc/cpuinfo
# Esperado: > 0

# Si virtualizacion NO habilitada:
# Reiniciar y entrar BIOS, habilitar VT-x o AMD-V
```

#### 1.3 Validar espacio en disco

```bash
# Ver espacio disponible
df -h

# Esperado: >= 50GB en partición raíz
```

#### 1.4 Validar RAM disponible

```bash
# Ver memoria
free -h

# Esperado: >= 8GB total
```

---

### PASO 2: Actualizar Sistema Operativo

#### 2.1 Actualizar paquetes

```bash
# Actualizar índice de paquetes
sudo apt-get update

# Actualizar paquetes existentes
sudo apt-get upgrade -y

# Esperado: sin errores, todos los paquetes actualizados
```

#### 2.2 Instalar dependencias base

```bash
# Instalar paquetes requeridos
sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  wget \
  git \
  build-essential

# Esperado: todos los paquetes instalados exitosamente
```

---

### PASO 3: Instalar Docker Engine

#### 3.1 Agregar repositorio Docker

```bash
# Agregar GPG key de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Agregar repositorio
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Actualizar índice
sudo apt-get update

# Esperado: repositorio agregado sin errores
```

#### 3.2 Instalar Docker Engine

```bash
# Instalar Docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Verificar versión
sudo docker --version

# Esperado: Docker version 20.10+ o superior
```

#### 3.3 Iniciar Docker daemon

```bash
# Iniciar servicio Docker
sudo systemctl start docker

# Habilitar servicio en boot
sudo systemctl enable docker

# Verificar estado
sudo systemctl status docker

# Esperado: "active (running)"
```

---

### PASO 4: Configurar Permisos Docker

#### 4.1 Crear grupo docker

```bash
# Crear grupo si no existe
sudo groupadd docker

# Agregar usuario actual al grupo
sudo usermod -aG docker $USER

# Esperado: sin errores
```

#### 4.2 Aplicar cambios de grupo

```bash
# Opción 1: Logout y login nuevamente
# (Más seguro, requiere cerrar sesión)

# Opción 2: Activar cambios en sesión actual
newgrp docker

# Verificar que funciona sin sudo
docker ps

# Esperado: lista vacía (sin errores de permisos)
```

#### 4.3 Verificar configuración

```bash
# Ver información de Docker
docker info | grep -A5 "Storage Driver"

# Esperado: storage driver (overlay2, aufs, etc.)
```

---

### PASO 5: Instalar Docker Compose

#### 5.1 Descargar Docker Compose

```bash
# Obtener versión más reciente
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')

# Descargar binario
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Hacer ejecutable
sudo chmod +x /usr/local/bin/docker-compose

# Verificar versión
docker-compose --version

# Esperado: Docker Compose version 2.0+ o superior
```

#### 5.2 Crear enlace simbólico (alternativo)

```bash
# Si es necesario enlace en /usr/bin
sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

# Verificar
which docker-compose
# Esperado: /usr/bin/docker-compose o /usr/local/bin/docker-compose
```

---

### PASO 6: Configurar Docker Daemon

#### 6.1 Crear configuración personalizada

```bash
# Crear directorio de configuración
sudo mkdir -p /etc/docker

# Crear archivo daemon.json
sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "debug": false,
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2",
  "live-restore": true,
  "userland-proxy": false,
  "icc": true,
  "insecure-registries": [],
  "registry-mirrors": []
}
EOF

# Esperado: archivo creado sin errores
```

#### 6.2 Validar sintaxis JSON

```bash
# Validar JSON
python3 -m json.tool /etc/docker/daemon.json > /dev/null

# Esperado: sin errores
```

#### 6.3 Recargar configuración

```bash
# Recargar daemon
sudo systemctl daemon-reload

# Reiniciar Docker
sudo systemctl restart docker

# Verificar estado
sudo systemctl status docker

# Esperado: "active (running)"
```

---

### PASO 7: Verificar Instalación de Docker

#### 7.1 Test hello-world

```bash
# Ejecutar imagen de prueba
docker run --rm hello-world

# Esperado:
# Hello from Docker!
# This message shows that your installation appears to be working correctly.
```

#### 7.2 Verificar recursos Docker

```bash
# Ver información del sistema
docker system df

# Esperado:
# TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE
# Images              1                   0                   13.26kB             13.26kB
```

#### 7.3 Listar imágenes y contenedores

```bash
# Listar imágenes
docker images

# Listar contenedores (todos)
docker ps -a

# Esperado: al menos hello-world imagen visible
```

---

### PASO 8: Configurar DevContainer

#### 8.1 Clonar repositorio IACT

```bash
# Navegar a directorio home
cd ~

# Clonar si no está clonado
git clone https://github.com/2-Coatl/IACT.git
cd IACT

# Verificar rama
git branch -a

# Esperado: repositorio clonado
```

#### 8.2 Verificar estructura DevContainer

```bash
# Buscar archivos DevContainer
find .devcontainer -type f 2>/dev/null | head -10

# Esperado: archivos devcontainer.json, Dockerfile, etc.
```

#### 8.3 Instalar extensión Remote Containers (VS Code)

```bash
# Si usa VS Code (opcional, no en terminal)
# Instalar extensión: "ms-vscode-remote.remote-containers"

# Desde terminal, validar estructura
ls -la .devcontainer/

# Esperado: devcontainer.json presente
```

---

### PASO 9: Testing de Conectividad y Recursos

#### 9.1 Test de conectividad a Docker Hub

```bash
# Intentar pull de imagen pequeña
docker pull alpine:latest

# Verificar
docker images | grep alpine

# Esperado: imagen alpine presente
```

#### 9.2 Validar recursos disponibles

```bash
# Ver información del sistema
docker info | grep -E "Containers|Images|Memory|CPU"

# Esperado: mostrar recursos disponibles
```

#### 9.3 Test de volúmenes compartidos

```bash
# Crear volumen de prueba
docker volume create test-volume

# Listar volúmenes
docker volume ls | grep test-volume

# Limpiar volumen de prueba
docker volume rm test-volume

# Esperado: operaciones exitosas
```

---

### PASO 10: Validación Final

#### 10.1 Ejecutar test de configuración

```bash
# Crear script de test
cat > /tmp/docker-test.sh << 'EOF'
#!/bin/bash

echo "=== Docker Configuration Test ==="
echo

# Test 1: Docker daemon running
if sudo systemctl is-active --quiet docker; then
  echo "[PASS] Docker daemon is running"
else
  echo "[FAIL] Docker daemon is NOT running"
  exit 1
fi

# Test 2: Docker socket accessible
if docker ps > /dev/null 2>&1; then
  echo "[PASS] Docker socket is accessible"
else
  echo "[FAIL] Docker socket is NOT accessible"
  exit 1
fi

# Test 3: Docker Compose installed
if docker-compose --version > /dev/null 2>&1; then
  echo "[PASS] Docker Compose is installed"
else
  echo "[FAIL] Docker Compose is NOT installed"
  exit 1
fi

# Test 4: Can pull images
if docker pull alpine:latest > /dev/null 2>&1; then
  echo "[PASS] Can pull from Docker Hub"
else
  echo "[FAIL] Cannot pull from Docker Hub"
  exit 1
fi

# Test 5: Can run containers
if docker run --rm alpine echo "test" > /dev/null 2>&1; then
  echo "[PASS] Can run containers"
else
  echo "[FAIL] Cannot run containers"
  exit 1
fi

echo
echo "=== All tests PASSED ==="
EOF

# Ejecutar test
bash /tmp/docker-test.sh

# Esperado: todos los tests PASS
```

#### 10.2 Validar configuración de red

```bash
# Ver configuración de red Docker
docker network ls

# Crear red de prueba
docker network create test-network

# Verificar
docker network inspect test-network | grep -E "Name|Subnet"

# Limpiar
docker network rm test-network

# Esperado: operaciones exitosas
```

---

## Validaciones por Paso

| Paso | Validación | Comando |
|------|-----------|---------|
| **1** | OS es Ubuntu 20.04+ | `lsb_release -a` |
| **1** | Virtualizacion habilitada | `grep -c vmx /proc/cpuinfo` (>0) |
| **1** | Espacio disco >= 50GB | `df -h /` |
| **1** | RAM >= 8GB | `free -h` |
| **2** | Paquetes actualizados | `apt-get upgrade` sin errores |
| **2** | Dependencias instaladas | `curl -V`, `git --version` |
| **3** | Docker instalado | `docker --version` |
| **3** | Docker daemon corriendo | `sudo systemctl status docker` |
| **4** | Usuario en grupo docker | `groups $USER` contiene docker |
| **4** | Permisos correctos | `docker ps` sin sudo |
| **5** | Docker Compose instalado | `docker-compose --version` |
| **6** | daemon.json sintaxis OK | `python3 -m json.tool /etc/docker/daemon.json` |
| **6** | Docker activo tras reconfig | `sudo systemctl status docker` |
| **7** | hello-world funciona | `docker run hello-world` sin errores |
| **8** | Repositorio clonado | `ls .devcontainer/` |
| **9** | Alpine pull exitoso | `docker images | grep alpine` |
| **9** | Recursos disponibles | `docker info` |
| **10** | Test script todo PASS | `/tmp/docker-test.sh` exit 0 |

---

## Troubleshooting

### Problema 1: Docker daemon no inicia

**Síntomas**:
```
Job for docker.service failed because the control process exited with error code.
```

**Causa**: Conflicto con puerto o archivo de socket corrupto

**Solución**:
```bash
# 1. Verificar logs
sudo journalctl -u docker.service | tail -50

# 2. Limpiar socket
sudo rm /var/run/docker.sock

# 3. Reiniciar
sudo systemctl daemon-reload
sudo systemctl restart docker

# 4. Verificar
sudo systemctl status docker
```

---

### Problema 2: Permission Denied al usar docker

**Síntomas**:
```
Got permission denied while trying to connect to the Docker daemon socket
```

**Causa**: Usuario no está en grupo docker o sesión no actualizada

**Solución**:
```bash
# Opción 1: Logout y login
# (Cierra todas las sesiones y vuelve a conectar)

# Opción 2: Activar en sesión actual
newgrp docker

# Opción 3: Forzar actualización de grupos
sudo usermod -aG docker $USER
exec su -l $USER

# Verificar
docker ps
```

---

### Problema 3: No se puede descargar imágenes

**Síntomas**:
```
Error response from daemon: Get "https://registry-1.docker.io/v2/": net/http: request canceled
```

**Causa**: Problema de conectividad o DNS

**Solución**:
```bash
# 1. Verificar conectividad
ping -c 4 8.8.8.8

# 2. Verificar DNS
nslookup docker.io

# 3. Cambiar DNS en daemon.json
sudo nano /etc/docker/daemon.json
# Agregar: "dns": ["8.8.8.8", "8.8.4.4"]

# 4. Reiniciar Docker
sudo systemctl restart docker

# 5. Intentar pull nuevamente
docker pull alpine
```

---

### Problema 4: Espacio insuficiente en disco

**Síntomas**:
```
no space left on device
```

**Causa**: Disco lleno con imágenes o volúmenes Docker

**Solución**:
```bash
# 1. Ver uso de espacio
docker system df

# 2. Limpiar imágenes no usadas
docker image prune -a

# 3. Limpiar volúmenes no usados
docker volume prune

# 4. Limpiar contenedores parados
docker container prune

# 5. Limpiar todo (cuidado)
docker system prune -a

# 6. Verificar espacio
df -h /var/lib/docker
```

---

### Problema 5: Docker Compose versión incompatible

**Síntomas**:
```
docker-compose command not found o versión muy antigua
```

**Causa**: Versión antigua de Docker Compose o no instalada

**Solución**:
```bash
# 1. Verificar versión actual
docker-compose --version

# 2. Si no existe, instalar
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 3. Verificar
docker-compose --version

# 4. Alternativa: usar plugin integrado
docker compose --version
```

---

## Rollback

### Rollback A: Desinstalación Completa

Para revertir a estado anterior a la instalación:

```bash
# 1. Detener Docker
sudo systemctl stop docker

# 2. Desinstalar paquetes
sudo apt-get remove -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 3. Limpiar configuración
sudo rm -rf /etc/docker
sudo rm -rf /var/lib/docker

# 4. Remover grupo docker
sudo groupdel docker

# 5. Remover usuario del grupo (si es necesario)
sudo usermod -G $(groups $USER | sed 's/docker //g') $USER

# 6. Verificar
docker ps
# Esperado: docker: command not found
```

---

### Rollback B: Restablecer Configuración

Para revertir cambios de configuración:

```bash
# 1. Restaurar daemon.json predeterminado
sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{}
EOF

# 2. Recargar
sudo systemctl daemon-reload
sudo systemctl restart docker

# 3. Verificar
sudo systemctl status docker
```

---

### Rollback C: Limpiar Datos Docker

Para limpiar sin desinstalar:

```bash
# 1. Detener todos los contenedores
docker stop $(docker ps -aq) 2>/dev/null

# 2. Eliminar contenedores
docker rm $(docker ps -aq)

# 3. Eliminar imágenes
docker rmi $(docker images -q)

# 4. Eliminar volúmenes
docker volume prune -f

# 5. Verificar
docker ps -a
docker images
docker volume ls
```

---

## Criterios de Éxito

Una configuración exitosa cumple TODOS estos criterios:

- [x] `lsb_release -a` muestra Ubuntu 20.04 o superior
- [x] `docker --version` muestra Docker 20.10 o superior
- [x] `docker-compose --version` muestra Docker Compose 2.0 o superior
- [x] `sudo systemctl status docker` muestra "active (running)"
- [x] `docker ps` funciona sin errores de permisos
- [x] `docker run hello-world` ejecuta exitosamente
- [x] `docker pull alpine:latest` descarga imagen sin errores
- [x] Usuario está en grupo docker (`groups $USER | grep docker`)
- [x] `/etc/docker/daemon.json` tiene sintaxis JSON válida
- [x] Docker daemon acepta conexiones en socket
- [x] Test script `/tmp/docker-test.sh` todos PASS
- [x] `docker network ls` muestra redes disponibles
- [x] `docker system df` muestra información de recursos
- [x] DevContainer repositorio clonado exitosamente
- [x] Logs sin errores críticos en `/var/log/docker.log`

---

## Tiempo Estimado

| Paso | Tiempo | Total |
|------|--------|-------|
| **Paso 1**: Verificar pre-requisitos | 5 min | 5 min |
| **Paso 2**: Actualizar SO | 10-15 min | 15-20 min |
| **Paso 3**: Instalar Docker | 5-10 min | 20-30 min |
| **Paso 4**: Configurar permisos | 2-3 min | 22-33 min |
| **Paso 5**: Instalar Docker Compose | 3-5 min | 25-38 min |
| **Paso 6**: Configurar daemon | 5 min | 30-43 min |
| **Paso 7**: Verificar instalación | 5-10 min | 35-53 min |
| **Paso 8**: Configurar DevContainer | 5-10 min | 40-63 min |
| **Paso 9**: Testing conectividad | 10-15 min | 50-78 min |
| **Paso 10**: Validación final | 5 min | 55-83 min |

**Tiempo Total Estimado**: 55-90 minutos (primera ejecución)
**Siguientes ejecuciones**: 5-10 minutos (si solo verificación)

---

## Checklist de Configuración

```markdown
PRE-CONFIGURACIÓN:
- [ ] OS es Ubuntu 20.04 LTS o superior
- [ ] Virtualizacion habilitada en BIOS
- [ ] >50 GB disco libre
- [ ] >8 GB RAM total
- [ ] Conexión Internet estable

DEPENDENCIAS:
- [ ] Curl/Wget instalados
- [ ] Git instalado
- [ ] Sudo accesible

INSTALACIÓN:
- [ ] Repositorio Docker agregado
- [ ] Docker Engine instalado
- [ ] Docker daemon iniciado y habilitado
- [ ] Docker Compose instalado

CONFIGURACIÓN:
- [ ] Grupo docker creado
- [ ] Usuario agregado a grupo docker
- [ ] daemon.json configurado
- [ ] Permisos validados

VALIDACIÓN:
- [ ] hello-world corre exitosamente
- [ ] Alpine pull exitosamente
- [ ] Contenedores ejecutables
- [ ] Volúmenes creables
- [ ] Redes creables
- [ ] Test script todos PASS

DEVCONTAINER:
- [ ] Repositorio IACT clonado
- [ ] .devcontainer/ accesible
- [ ] Estructura DevContainer válida
```

---

## Comandos Frecuentes (Quick Reference)

```bash
# Verificación rápida
docker ps
docker --version
docker-compose --version

# Gestión de Docker
sudo systemctl start docker
sudo systemctl stop docker
sudo systemctl restart docker
sudo systemctl status docker

# Imágenes
docker images
docker pull <image>
docker rmi <image>

# Contenedores
docker ps
docker ps -a
docker run <image>
docker stop <container>
docker rm <container>

# Limpieza
docker system prune -a
docker image prune
docker volume prune

# Información
docker info
docker system df
docker stats

# Troubleshooting
sudo journalctl -u docker.service
docker logs <container>
docker inspect <container>
```

---

## Referencias

### Documentación Interna
- [PROCED-INFRA-001: Provisión VM Vagrant](./PROCED-INFRA-001-provision-vm-vagrant.md)
- [README DevContainer Setup](../devcontainer/README.md)

### Documentación Externa
- [Docker Official Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Ubuntu Docker Installation](https://docs.docker.com/engine/install/ubuntu/)

### Tareas Relacionadas
- [TASK-045: Crear PROCED-INFRA-002](../qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-045/)

---

## Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-11-18 | Claude Code (Haiku 4.5) | Versión inicial - Procedimiento completo de configuración DevContainer Host |

---

## Aprobación

- **Autor**: Claude Code (Haiku 4.5)
- **Revisado por**: Pendiente
- **Aprobado por**: Pendiente
- **Fecha de próxima revisión**: 2026-02-18
- **Estado**: ACTIVO
