---
id: PROCED-INFRA-005
tipo: procedimiento
categoria: infraestructura
subcategoria: troubleshooting
version: 1.0.0
fecha_creacion: 2025-11-18
autor: Claude Code (Haiku 4.5)
estado: activo
relacionados: ["TASK-048", "PROCED-INFRA-002"]
---

# PROCED-INFRA-005: Troubleshooting DevContainer

## Objetivo

Proporcionar pasos detallados y paso a paso para diagnosticar y resolver problemas comunes en DevContainers, incluyendo problemas de configuración, conectividad, permisos, recursos, y performance.

Este es un procedimiento de troubleshooting sistemático y lógico basado en sintomatología.

---

## Alcance

Este procedimiento cubre:
- Diagnóstico de estado DevContainer
- Problemas de configuración devcontainer.json
- Problemas de conectividad de red
- Problemas de volúmenes compartidos
- Problemas de permisos y acceso
- Problemas de recursos (RAM, CPU, disk)
- Problemas de performance
- Problemas de extensiones VS Code
- Logs y debugging
- Recuperación y reset

**NO cubre**:
- Problemas específicos de aplicaciones (Django, React, etc.)
- Configuración inicial (ver PROCED-INFRA-002)
- Deployment de DevContainer
- Troubleshooting de frameworks específicos

---

## Pre-requisitos

Antes de ejecutar este procedimiento, verificar:

### Hardware
- [ ] VM/Host disponible y accesible
- [ ] Suficiente RAM (mínimo 8 GB)
- [ ] Suficiente espacio en disco (10 GB libre mínimo)

### Software Requerido
- [ ] Docker instalado y corriendo
- [ ] Docker Compose disponible
- [ ] VS Code instalado (opcional)
- [ ] Remote Containers extension (para VS Code)

### Conocimiento Requerido
- Docker y Docker Compose básico
- Comandos de debugging Linux
- Lectura e interpretación de logs
- Redes TCP/IP conceptos básicos

---

## Roles y Responsabilidades

| Rol | Responsabilidad |
|-----|-----------------|
| **Developer** | Reporta síntomas y problemas, valida fix |
| **DevOps Engineer** | Diagnostica, aplica fix, documenta solución |
| **Tech Lead** | Revisa logs, aprueba cambios importantes |

---

## Procedimiento Detallado

### PASO 1: Diagnosticar Estado del Contenedor

#### 1.1 Verificar que Docker está corriendo

```bash
# Verificar daemon Docker
sudo systemctl status docker

# Esperado: active (running)

# Si no está running:
sudo systemctl start docker
sudo systemctl enable docker
```

#### 1.2 Verificar DevContainer en VS Code

```bash
# En VS Code, abrir Command Palette (Ctrl+Shift+P)
# Escribir: "Dev Containers: Show Log"

# O desde terminal:
cd /home/user/IACT

# Ver contenedores corriendo
docker ps

# Ver contenedores parados
docker ps -a

# Filtrar por IACT
docker ps -a | grep -i iact

# Esperado: contenedor visible con estado (running/exited/created)
```

#### 1.3 Ver logs del contenedor

```bash
# Obtener ID del contenedor
CONTAINER_ID=$(docker ps -aq -f label=devcontainer.metadata)

# Ver logs últimas 100 líneas
docker logs --tail=100 $CONTAINER_ID

# Ver logs con timestamp
docker logs --timestamps $CONTAINER_ID

# Ver logs en tiempo real
docker logs -f $CONTAINER_ID

# Esperado: logs visibles sin errores críticos
```

#### 1.4 Inspeccionar configuración del contenedor

```bash
# Ver información del contenedor
docker inspect $CONTAINER_ID | less

# Ver solo configuración de red
docker inspect $CONTAINER_ID | grep -A 20 '"Networks"'

# Ver volúmenes montados
docker inspect $CONTAINER_ID | grep -A 20 '"Mounts"'

# Esperado: configuración accesible
```

---

### PASO 2: Diagnosticar Problemas de Configuración

#### 2.1 Validar devcontainer.json

```bash
# Navegar a directorio DevContainer
cd /home/user/IACT/.devcontainer

# Validar sintaxis JSON
python3 -m json.tool devcontainer.json > /dev/null && echo "OK" || echo "ERROR"

# Ver contenido
cat devcontainer.json | head -30

# Verificar campos obligatorios
grep -E '"image"|"build"|"name"' devcontainer.json

# Esperado: JSON válido, campos presentes
```

#### 2.2 Validar Dockerfile del DevContainer

```bash
# Si usa build en lugar de image, validar Dockerfile
cd /home/user/IACT/.devcontainer

if [ -f Dockerfile ]; then
  # Validar sintaxis
  docker build --dry-run .

  # Esperado: salida de build sin errores
fi
```

#### 2.3 Validar docker-compose.yml

```bash
# Si el proyecto usa docker-compose
cd /home/user/IACT

# Validar sintaxis
docker-compose config > /dev/null && echo "OK" || echo "ERROR"

# Ver servicios definidos
docker-compose config | grep "services" -A 20

# Esperado: YAML válido, servicios definidos
```

---

### PASO 3: Diagnosticar Problemas de Red

#### 3.1 Verificar conectividad entre contenedores

```bash
# Entrar al contenedor
docker exec -it $CONTAINER_ID bash

# Dentro del contenedor:

# Verificar conectividad básica
ping -c 4 8.8.8.8

# Verificar resolución DNS
nslookup github.com

# Verificar puertos abiertos
netstat -tlnp | grep LISTEN

# Salir
exit
```

#### 3.2 Verificar port forwarding

```bash
# Ver puertos mapeados
docker inspect $CONTAINER_ID | grep -A 10 '"PortBindings"'

# Probar conexión a puerto específico
curl http://localhost:8000
curl http://localhost:3000

# Esperado: puertos accesibles desde host
```

#### 3.3 Verificar conectividad de red en VS Code

```bash
# Abrir VS Code y conectar a DevContainer
# Click en esquina inferior izquierda: "><"
# Seleccionar "Dev Container: Reopen in Container"

# Si falla, ver logs en: View > Output > Dev Containers

# Esperado: conexión exitosa
```

---

### PASO 4: Diagnosticar Problemas de Volúmenes

#### 4.1 Verificar volúmenes montados

```bash
# Ver volúmenes definidos
docker volume ls

# Inspeccionar volumen específico
docker volume inspect <volume_name>

# Verificar punto de montaje en host
ls -la /var/lib/docker/volumes/<volume_name>/_data

# Esperado: volúmenes existen y accesibles
```

#### 4.2 Validar bind mounts

```bash
# Ver bind mounts del contenedor
docker inspect $CONTAINER_ID | jq '.Mounts[] | select(.Type=="bind")'

# Verificar que directorios fuente existen
ls -la /home/user/IACT/

# Verificar permisos
stat /home/user/IACT/

# Esperado: directorios existen con permisos correctos
```

#### 4.3 Test de lectura/escritura en volúmenes

```bash
# Crear archivo de prueba
docker exec -it $CONTAINER_ID touch /workspace/test-file.txt

# Verificar archivo en host
ls -l /home/user/IACT/test-file.txt

# Crear archivo desde host
touch /home/user/IACT/host-test-file.txt

# Verificar en contenedor
docker exec -it $CONTAINER_ID ls /workspace/host-test-file.txt

# Limpiar
rm -f /home/user/IACT/test-file.txt /home/user/IACT/host-test-file.txt

# Esperado: lectura/escritura funciona bidireccionalmente
```

---

### PASO 5: Diagnosticar Problemas de Permisos

#### 5.1 Verificar permisos del usuario en contenedor

```bash
# Entrar al contenedor
docker exec -it $CONTAINER_ID bash

# Dentro del contenedor:

# Ver usuario actual
whoami

# Ver grupos
groups

# Ver UID/GID
id

# Salir
exit
```

#### 5.2 Verificar permisos de archivos compartidos

```bash
# En host, verificar permisos
ls -la /home/user/IACT/

# Problemas comunes:
# - Archivos propiedad de root
# - Permisos 600 (solo lectura)

# Solución: cambiar propiedad/permisos
sudo chown -R $USER:$USER /home/user/IACT/
chmod -R u+w /home/user/IACT/

# Esperado: usuario puede leer/escribir archivos
```

#### 5.3 Verificar permisos de Docker socket

```bash
# Si DevContainer accede a Docker daemon

# Ver socket
ls -la /var/run/docker.sock

# Verificar grupo docker
groups $USER
# Esperado: docker en la lista

# Si no está, agregar
sudo usermod -aG docker $USER

# Aplicar cambios
newgrp docker

# Esperado: usuario puede ejecutar docker
```

---

### PASO 6: Diagnosticar Problemas de Recursos

#### 6.1 Verificar límites de recursos

```bash
# Ver limites de contenedor
docker inspect $CONTAINER_ID | grep -A 10 '"Resources"'

# Verificar CPU limits
docker stats $CONTAINER_ID --no-stream

# Ver memoria disponible en host
free -h

# Esperado: recursos suficientes asignados
```

#### 6.2 Aumentar límites si es necesario

```bash
# Editar devcontainer.json para agregar límites
cat /home/user/IACT/.devcontainer/devcontainer.json

# Agregar:
# "features": {
#   "docker-in-docker": "latest"
# },
# "hostRequirements": {
#   "cpus": 4,
#   "memory": "8gb"
# }

# Reconstruir contenedor
# En VS Code: Dev Containers: Rebuild Container
```

#### 6.3 Verificar espacio en disco

```bash
# Espacio total
df -h

# Espacio usado por Docker
docker system df

# Si espacio bajo, limpiar
docker system prune -a

# Esperado: >= 10 GB libres
```

---

### PASO 7: Diagnosticar Problemas de Performance

#### 7.1 Monitorear recursos en tiempo real

```bash
# Ver uso de recursos
docker stats $CONTAINER_ID

# Ver procesos en contenedor
docker top $CONTAINER_ID

# Esperar Ctrl+C para salir
```

#### 7.2 Analizar logs de performance

```bash
# Ver logs con timestamp
docker logs --timestamps $CONTAINER_ID | tail -50

# Buscar errores
docker logs $CONTAINER_ID | grep -i error

# Buscar warnings
docker logs $CONTAINER_ID | grep -i warning

# Esperado: sin errores que causen ralentización
```

#### 7.3 Test de I/O

```bash
# Entrar a contenedor
docker exec -it $CONTAINER_ID bash

# Dentro del contenedor:

# Test lectura
time dd if=/var/lib/docker/volumes/test/_data/largefile of=/dev/null bs=1M

# Test escritura
time dd if=/dev/zero of=/workspace/test-file.img bs=1M count=100

# Limpiar
rm /workspace/test-file.img

# Salir
exit

# Esperado: velocidades razonables (> 50 MB/s)
```

---

### PASO 8: Diagnosticar Problemas de Extensiones VS Code

#### 8.1 Ver extensiones instaladas

```bash
# En VS Code, abrir Extensions (Ctrl+Shift+X)
# Ver extensiones locales vs remotas

# O desde terminal:
code --list-extensions

# Esperado: extensiones clave presentes
```

#### 8.2 Validar extensiones en DevContainer

```bash
# En VS Code, conectar a DevContainer
# Abrir Extensions nuevamente
# Ver pestaña "In Dev Container"

# Reinstalar extensiones si faltan
# Click "Install in Dev Container" en extensión

# Esperado: extensiones instaladas remotamente
```

#### 8.3 Resetear configuración de extensiones

```bash
# Si extensión malconfigured, resetear
# En VS Code, Command Palette: "Preferences: Reset Settings"

# O eliminar archivos de configuración
rm -rf ~/.config/Code/User/

# Esperado: configuración limpia
```

---

### PASO 9: Debugging Avanzado

#### 9.1 Acceso a shell del contenedor

```bash
# Entrar a shell interactivo
docker exec -it $CONTAINER_ID bash

# O usar sh si bash no disponible
docker exec -it $CONTAINER_ID sh

# Dentro del contenedor, explorar:
# - /home/vscode (usuario principal)
# - /workspace (directorio del proyecto)
# - /root (root home)

# Ver variables de entorno
env | grep -i docker

# Salir
exit
```

#### 9.2 Ejecutar comandos específicos para debugging

```bash
# Verificar que Python/Node están disponibles
docker exec $CONTAINER_ID python --version
docker exec $CONTAINER_ID node --version

# Ejecutar comando de test
docker exec $CONTAINER_ID npm test

# Ver estado de servidor
docker exec $CONTAINER_ID netstat -tlnp

# Esperado: comandos se ejecutan sin errores
```

#### 9.3 Capturar salida de comando para debugging

```bash
# Ejecutar comando y guardar salida
docker exec $CONTAINER_ID bash -c "npm install 2>&1" > /tmp/npm-install.log

# Ver archivo de log
cat /tmp/npm-install.log

# Buscar errores específicos
grep -i error /tmp/npm-install.log

# Esperado: log completo para análisis
```

---

### PASO 10: Recuperación y Reset

#### 10.1 Restart del contenedor

```bash
# Detener contenedor
docker stop $CONTAINER_ID

# Iniciar nuevamente
docker start $CONTAINER_ID

# O usar restart
docker restart $CONTAINER_ID

# Verificar estado
docker ps | grep $CONTAINER_ID

# Esperado: contenedor running nuevamente
```

#### 10.2 Rebuild del DevContainer

```bash
# En VS Code, Command Palette:
# "Dev Containers: Rebuild Container"

# O desde terminal:
cd /home/user/IACT

# Reconstruir imagen
docker-compose down
docker-compose up --build

# Esperado: imagen reconstruida sin errores
```

#### 10.3 Limpieza completa (último recurso)

```bash
# Detener y remover contenedor
docker rm -f $CONTAINER_ID

# Remover imagen
docker rmi iact-dev

# Limpiar volúmenes huérfanos
docker volume prune -f

# Limpiar sistema
docker system prune -a

# Reconstruir desde cero
# En VS Code: Dev Containers: Reopen in Container
# O: docker-compose up --build

# Esperado: entorno limpio y funcionante
```

---

## Matriz de Troubleshooting

| Síntoma | Causa Probable | Solución |
|---------|----------------|----------|
| "Cannot connect to container" | DevContainer no corriendo | `docker ps -a`, verificar status |
| "Mount refused" | Permisos insuficientes | `chmod -R u+w`, `sudo chown` |
| "Network unavailable" | DNS o conectividad | Verificar `/etc/resolv.conf`, ping 8.8.8.8 |
| "Out of memory" | Límites insuficientes | Aumentar RAM en devcontainer.json |
| "Disk full" | Espacio en disco agotado | `docker system prune`, limpiar hosts |
| "Slow I/O" | Shared volumes lento | Usar volúmenes locales si posible |
| "Port conflict" | Puerto en uso | `lsof -i :puerto`, cambiar puerto en config |
| "Extension error" | Extensión corrupta o incompatible | Reinstalar extensión en contenedor |
| "High CPU" | Proceso runaway | `docker top`, identificar y matar proceso |
| "Can't pull image" | Conectividad o autenticación | Verificar DNS, `docker login` |

---

## Validaciones por Paso

| Paso | Validación | Comando |
|------|-----------|---------|
| **1** | Docker running | `sudo systemctl status docker` |
| **1** | Contenedor visible | `docker ps -a \| grep iact` |
| **1** | Logs accesibles | `docker logs $CONTAINER_ID` |
| **2** | devcontainer.json válido | `python3 -m json.tool` |
| **2** | docker-compose válido | `docker-compose config > /dev/null` |
| **3** | Conectividad básica | `ping -c 4 8.8.8.8` (dentro de contenedor) |
| **3** | Puertos mapeados | `docker inspect \| grep PortBindings` |
| **4** | Volúmenes existen | `docker volume ls` |
| **4** | Bind mounts accesibles | `ls -la` en directorios fuente |
| **5** | Permisos correctos | `ls -la /home/user/IACT/` |
| **6** | Recursos disponibles | `docker stats`, `free -h` |
| **7** | Performance aceptable | I/O > 50 MB/s |
| **8** | Extensiones presentes | `code --list-extensions` |
| **9** | Shell accesible | `docker exec $CONTAINER_ID bash` |
| **10** | Contenedor limpio | `docker ps --no-trunc` |

---

## Troubleshooting Rápido

```bash
# RÁPIDO: Estado general
docker ps -a
docker logs <container_id> | tail -20

# RÁPIDO: Problemas de conectividad
docker exec <container_id> ping 8.8.8.8
docker exec <container_id> curl http://localhost:3000

# RÁPIDO: Problemas de archivo
docker exec <container_id> ls -la /workspace
docker exec <container_id> cat /workspace/.env

# RÁPIDO: Rebuild
docker-compose down && docker-compose up --build

# RÁPIDO: Limpieza
docker system prune -a --volumes
```

---

## Referencias

### Documentación Interna
- [PROCED-INFRA-002: Configurar DevContainer Host](./PROCED-INFRA-002-configurar-devcontainer-host.md)

### Documentación Externa
- [VS Code Remote Development Documentation](https://code.visualstudio.com/docs/remote/remote-overview)
- [Dev Containers Specification](https://containers.dev/)
- [Docker Debugging Documentation](https://docs.docker.com/config/containers/logging/)

---

## Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-11-18 | Claude Code (Haiku 4.5) | Versión inicial - Procedimiento completo de Troubleshooting DevContainer |

---

## Aprobación

- **Autor**: Claude Code (Haiku 4.5)
- **Revisado por**: Pendiente
- **Aprobado por**: Pendiente
- **Fecha de próxima revisión**: 2026-02-18
- **Estado**: ACTIVO
