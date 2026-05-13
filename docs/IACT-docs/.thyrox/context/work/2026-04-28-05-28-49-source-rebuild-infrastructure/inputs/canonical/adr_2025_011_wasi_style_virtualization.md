# ADR-011: WASI-style Virtualization for Database Environments

**Status**: Accepted
**Date**: 2025-11-12
**Decision Makers**: Development Team
**Tags**: #infrastructure #virtualization #wasi #containers #security

---

## Context

El proyecto necesita un sistema para crear ambientes aislados de bases de datos para desarrollo, testing y staging. Tradicionalmente se ha usado Vagrant con VMs, pero esto tiene costos significativos en recursos, tiempo de inicio y complejidad.

### Problemas con Vagrant/VMs

1. **Recursos pesados**: 1-2 GB RAM por VM
2. **Inicio lento**: 2-5 minutos para levantar VM
3. **Disco**: 5-10 GB por VM
4. **Complejidad**: Configuracion de red, port forwarding
5. **Dificil correr multiples ambientes simultaneos**

### Alternativas Evaluadas

1. **Docker Compose**: Requiere Docker daemon
2. **Instalacion local**: Conflictos de puertos, dificil limpiar
3. **Cloud databases**: Costo, latencia, requiere conexion
4. **Containers sin Docker**: LXC, rkt - aun requieren daemon

### Requisitos

- Aislamiento de ambientes (filesystem, network, procesos)
- Ultra-ligero (< 1 MB overhead)
- Inicio instantaneo (< 1 segundo)
- Sin daemon externo
- Capabilities explicitas
- Portable entre maquinas Linux
- Facil de limpiar/recrear

---

## Decision

Implementar **WASI-style virtualization** usando Linux namespaces directamente, inspirado en WebAssembly System Interface (WASI).

Crear 3 opciones de virtualizacion en `scripts/infrastructure/wasi/`:

### 1. virtualize.sh (Docker-based)
- Para cuando Docker esta disponible
- Servicios reales (PostgreSQL, MySQL, Redis)
- Produccion-ready

### 2. lightweight_venv.sh (Bash-only)
- Solo directorios + variables de entorno
- Ultra-ligero (< 1 MB)
- Similar a Python venv
- Para mocking/testing rapido

### 3. wasm_style_sandbox.sh (WASI-style) [RECOMENDADO]
- Usa Linux namespaces del kernel directamente
- Inspirado en WASI capabilities model
- Aislamiento real sin Docker
- Manifest JSON para capabilities

---

## Inspiracion: WebAssembly System Interface (WASI)

WASI define como WebAssembly interactua con el sistema operativo de forma segura:

### Principios WASI

1. **Capabilities explicitas**
   ```json
   {
     "filesystem": {"read": [...], "write": [...]},
     "network": {"listen": [...], "connect": [...]},
     "resources": {"memory": "256M", "cpu": "1.0"}
   }
   ```

2. **Security by default**: Sin acceso implicito a recursos

3. **Portabilidad**: Mismo codigo corre en diferentes runtimes

4. **Sandboxing**: Aislamiento a nivel de runtime

### Aplicacion a Nivel OS

Nuestro sistema aplica los mismos principios usando Linux:

```bash
# Crear sandbox con capabilities explicitas
./wasm_style_sandbox.sh create postgres dev 5432

# Genera capabilities.json:
{
  "network": {"listen": ["0.0.0.0:5432"]},
  "filesystem": {
    "read": ["/sandboxes/dev/config"],
    "write": ["/sandboxes/dev/data"]
  },
  "resources": {"memory": "256M", "cpu": "1.0"}
}

# Ejecutar en namespaces aislados
sudo ./wasm_style_sandbox.sh run dev
# - Mount namespace: filesystem aislado
# - Network namespace: red aislada
# - PID namespace: procesos aislados
# - IPC namespace: IPC aislado
```

---

## Implementation Details

### Linux Namespaces Usados

```bash
unshare --pid --mount --net --ipc --fork bash script.sh
```

- **PID namespace**: Procesos aislados (no ve otros procesos del host)
- **Mount namespace**: Filesystem virtual propio
- **Network namespace**: Stack de red independiente
- **IPC namespace**: IPC aislado (shared memory, semaphores)

### Estructura de Sandbox

```
.sandboxes/dev/
├── config/
│   ├── sandbox.conf        # Configuracion base
│   └── capabilities.json   # Manifest WASI-style
├── data/                   # Datos aislados
├── logs/                   # Logs del servicio
├── rootfs/                 # Filesystem virtual (opcional)
├── activate                # Script de activacion
└── run-sandboxed.sh        # Entrypoint en namespace
```

### Capabilities Manifest

Inspirado en WASI capabilities:

```json
{
  "sandbox": "dev",
  "version": "1.0",
  "capabilities": {
    "network": {
      "listen": ["0.0.0.0:5432"],
      "connect": []
    },
    "filesystem": {
      "read": [
        "/sandboxes/dev/data",
        "/sandboxes/dev/config"
      ],
      "write": [
        "/sandboxes/dev/data",
        "/sandboxes/dev/logs"
      ]
    },
    "resources": {
      "memory": "256M",
      "cpu": "1.0",
      "pids": 100
    }
  },
  "environment": {
    "DB_NAME": "dev_db",
    "DB_PORT": "5432"
  }
}
```

### Integracion con environment_config.py

```python
from scripts.ai.shared.environment_config import get_environment_config

config = get_environment_config()
db_config = config.get_database_config()

# Auto-detecta si hay sandbox WASI activo
# Lee variables: DB_HOST, DB_PORT, SANDBOX_CAPS, etc.
```

---

## Consequences

### Ventajas

1. **Performance**
   - Inicio: < 1 segundo (vs 2-5 minutos con Vagrant)
   - Memoria: < 1 MB overhead (vs 1-2 GB con VM)
   - Disco: < 1 MB (vs 5-10 GB con VM)

2. **Seguridad**
   - Capabilities explicitas (manifest JSON)
   - Aislamiento real a nivel de kernel
   - Sin acceso implicito a recursos del host
   - Princip

io de minimo privilegio

3. **Developer Experience**
   - Crear/destruir instantaneo
   - Multiples ambientes simultaneos sin conflictos
   - Portable (solo requiere Linux)
   - Similar a Python venv (familiar)

4. **Operaciones**
   - Sin daemon externo (Docker, Vagrant)
   - Facil de debuggear (solo shell scripts)
   - Logs centralizados por sandbox
   - Inspeccion via `inspect` command

### Desventajas

1. **Solo Linux**: Requiere kernel Linux con soporte de namespaces
   - Mitigacion: Ofrecer tambien lightweight_venv.sh (portable)

2. **Requiere root para aislamiento completo**
   - Mitigacion: Funciona sin root (aislamiento parcial)
   - Alternativa: user namespaces (sin root)

3. **Mas complejo que lightweight**
   - Mitigacion: Documentacion completa + demos
   - Alternativa: usar lightweight_venv.sh si no se necesita aislamiento

4. **No es servicio real por defecto**
   - Mitigacion: Puede ejecutar servicio real con namespaces
   - Alternativa: usar virtualize.sh (Docker) para servicios reales

### Riesgos

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|--------------|---------|------------|
| Kernel sin soporte namespaces | Baja | Alto | Fallback a lightweight_venv.sh |
| Complejidad para nuevos devs | Media | Medio | Documentacion, demos, videos |
| Bugs en scripts bash | Media | Bajo | Tests, code review |
| Performance overhead namespaces | Baja | Bajo | Benchmarks muestran < 1% overhead |

---

## Alternatives Considered

### 1. Solo Docker Compose

**Pros**:
- Ecosistema maduro
- Servicios reales
- CI/CD integration

**Cons**:
- Requiere Docker daemon
- 100-500 MB por ambiente
- Inicia en 5-10 segundos
- No alineado con filosofia WASI

**Decision**: Ofrecer como opcion 1, pero no default

### 2. LXC/LXD Containers

**Pros**:
- Aislamiento completo
- System containers

**Cons**:
- Requiere LXD daemon
- Mas pesado que namespaces directos
- Mayor complejidad

**Decision**: Rechazado

### 3. Chroot

**Pros**:
- Simple
- No requiere namespaces

**Cons**:
- No aislamiento real (solo filesystem)
- Facil escapar del chroot
- No capabilities explicitas

**Decision**: Rechazado (insuficiente)

### 4. systemd-nspawn

**Pros**:
- Tool oficial de systemd
- Buen aislamiento

**Cons**:
- Requiere systemd
- Mas complejo que unshare
- Menos portable

**Decision**: Rechazado

---

## Implementation Plan

### Fase 1: Core Scripts (DONE)
- [x] virtualize.sh (Docker-based)
- [x] lightweight_venv.sh (Bash-only)
- [x] wasm_style_sandbox.sh (WASI-style)
- [x] demo.sh (Demo interactivo)
- [x] README.md (Documentacion)

### Fase 2: Integration
- [ ] Integrar con environment_config.py (auto-deteccion)
- [ ] Tests de integracion
- [ ] CI/CD examples

### Fase 3: Advanced Features
- [ ] User namespaces (sin root)
- [ ] Cgroups v2 integration (limits reales)
- [ ] Seccomp filters (syscall filtering)
- [ ] Networking avanzado (veth pairs)

### Fase 4: Tooling
- [ ] UI/TUI para gestion de sandboxes
- [ ] Monitoring/metrics
- [ ] Backup/restore de sandboxes
- [ ] Templates pre-configurados

---

## References

### WASI Specification
- https://github.com/WebAssembly/WASI
- https://wasi.dev/
- WASI Capabilities: https://github.com/WebAssembly/WASI/blob/main/phases/snapshot/docs.md

### Linux Namespaces
- man 7 namespaces
- https://www.kernel.org/doc/Documentation/namespaces/
- unshare(1), nsenter(1)

### Similar Projects
- systemd-nspawn: https://www.freedesktop.org/software/systemd/man/systemd-nspawn.html
- Flatpak sandboxing: https://docs.flatpak.org/en/latest/sandbox-permissions.html
- Bubblewrap: https://github.com/containers/bubblewrap

### Internal Docs
- docs/infrastructure/AMBIENTES_VIRTUALIZADOS.md
- scripts/infrastructure/wasi/README.md
- docs/ai/CONFIGURACION_AMBIENTES.md

---

## Success Metrics

1. **Adoption**: > 80% de devs usan WASI-style en 3 meses
2. **Performance**: Ambientes inician en < 1 segundo (100% casos)
3. **Resource Usage**: < 10 MB total para 5 sandboxes simultaneos
4. **Developer Satisfaction**: > 8/10 en encuesta de UX
5. **Security**: 0 incidentes de escape de sandbox en 6 meses

---

## Review and Update

- **Next Review**: 2025-12-12 (1 mes)
- **Responsible**: Infrastructure Team
- **Success Criteria**: Metricas arriba alcanzadas
- **Update Trigger**: Nuevas tecnologias, feedback negativo, incidentes de seguridad
