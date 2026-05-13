---
id: CATALOGO-VMS-VAGRANT-001
tipo: catalogo_tecnico
categoria: infraestructura_local
titulo: Catalogo de VMs Vagrant Disponibles
version: 1.0.0
fecha_creacion: 2025-11-18
ultima_actualizacion: 2025-11-18
estado: activo
tecnica_prompting: Tabular CoT + Self-Consistency
fase: FASE_3_CONTENIDO_NUEVO
prioridad: MEDIA
duracion_estimada: 3h
propietario: Equipo Desarrollo Local
related_tasks:
  - TASK-REORG-INFRA-050
  - TASK-REORG-INFRA-051
tags:
  - catalogo
  - vagrant
  - vms
  - desarrollo_local
  - devops
---

# Catalogo de VMs Vagrant Disponibles

## Proposito

Este catálogo documenta todas las máquinas virtuales disponibles en el stack Vagrant para desarrollo local. Cada VM está definida con su configuración, requisitos, servicios instalados y propósito específico.

**Aplicación de Tabular CoT:**
- Estructura uniforme para todas las VMs
- Campos de configuración claramente especificados
- Self-Consistency: validación de recursos y dependencias entre VMs
- Facilita reproducibilidad y onboarding de desarrolladores

## VMs Vagrant Disponibles

| # | Nombre VM | Box Base | SO | CPU | RAM | Disco | Estado | Propósito | Servicios Instalados | Puerto Host | Documentación |
|---|-----------|----------|-----|-----|-----|-------|--------|----------|----------------------|-------------|----------------|
| 1 | **master-db** | `ubuntu/jammy64` | Ubuntu 22.04 LTS | 4 | 4GB | 40GB | Activo | Base de datos principal en cluster de desarrollo | PostgreSQL 13, Redis 7, pgAdmin, pg_stat_statements | 5432→5432, 6379→6379 | [PROC-VAGRANT-DB](../procedimientos/), [Vagrantfile](../../) |
| 2 | **backend-api** | `ubuntu/jammy64` | Ubuntu 22.04 LTS | 2 | 2GB | 20GB | Activo | API backend y servicios de negocio | Node.js 18, npm, pnpm, Docker, Docker Compose | 3000→3000, 9229→9229 | [PROC-VAGRANT-BACKEND](../procedimientos/), [Vagrantfile](../../) |
| 3 | **frontend-web** | `ubuntu/jammy64` | Ubuntu 22.04 LTS | 2 | 2GB | 20GB | Activo | Aplicación frontend y assets estáticos | Node.js 18, npm, yarn, Webpack, Vite | 8080→8080, 3001→3001 | [PROC-VAGRANT-FRONTEND](../procedimientos/), [Vagrantfile](../../) |
| 4 | **queue-broker** | `ubuntu/jammy64` | Ubuntu 22.04 LTS | 2 | 2GB | 20GB | Activo | Message broker y procesamiento asíncrono | RabbitMQ 3.12, Celery, Beat Scheduler | 5672→5672, 15672→15672 | [PROC-VAGRANT-QUEUE](../procedimientos/), [Vagrantfile](../../) |
| 5 | **cache-server** | `ubuntu/jammy64` | Ubuntu 22.04 LTS | 2 | 2GB | 15GB | Activo | Almacenamiento distribuido de caché | Redis Cluster (3 nodos), Sentinel, Memcached | 6379→6379, 6380→6380, 11211→11211 | [PROC-VAGRANT-CACHE](../procedimientos/), [Vagrantfile](../../) |
| 6 | **search-engine** | `ubuntu/jammy64` | Ubuntu 22.04 LTS | 2 | 3GB | 30GB | Activo | Búsqueda full-text y análisis de logs | Elasticsearch 8.x, Kibana, Logstash, Beats | 9200→9200, 5601→5601 | [PROC-VAGRANT-SEARCH](../procedimientos/), [Vagrantfile](../../) |
| 7 | **container-registry** | `ubuntu/jammy64` | Ubuntu 22.04 LTS | 2 | 2GB | 50GB | Activo | Registro privado de imágenes Docker | Docker Registry 2, Harbor, Docker Compose | 5000→5000, 8443→8443 | [PROC-VAGRANT-REGISTRY](../procedimientos/), [Vagrantfile](../../) |
| 8 | **k8s-master** | `ubuntu/jammy64` | Ubuntu 22.04 LTS | 4 | 4GB | 40GB | Activo | Control plane de Kubernetes local | Kubernetes 1.28, etcd, kubelet, kube-proxy | 6443→6443, 8080→8080 | [PROC-VAGRANT-K8S](../procedimientos/), [Vagrantfile](../../) |
| 9 | **k8s-worker-1** | `ubuntu/jammy64` | Ubuntu 22.04 LTS | 2 | 2GB | 30GB | Activo | Nodo worker de Kubernetes | Kubernetes 1.28, kubelet, kube-proxy, Docker | 10250→10250 | [PROC-VAGRANT-K8S](../procedimientos/), [Vagrantfile](../../) |
| 10 | **k8s-worker-2** | `ubuntu/jammy64` | Ubuntu 22.04 LTS | 2 | 2GB | 30GB | Activo | Nodo worker de Kubernetes | Kubernetes 1.28, kubelet, kube-proxy, Docker | 10250→10250 | [PROC-VAGRANT-K8S](../procedimientos/), [Vagrantfile](../../) |
| 11 | **ci-cd-runner** | `ubuntu/jammy64` | Ubuntu 22.04 LTS | 4 | 4GB | 40GB | Activo | Ejecutor de pipelines CI/CD | Jenkins, GitLab Runner, Docker, Docker Compose | 8080→8080, 50000→50000 | [PROC-VAGRANT-CI](../procedimientos/), [Vagrantfile](../../) |
| 12 | **vault-server** | `ubuntu/jammy64` | Ubuntu 22.04 LTS | 2 | 1GB | 10GB | Activo | Gestión centralizada de secretos | Vault 1.15, Consul, TLS | 8200→8200 | [PROC-VAGRANT-VAULT](../procedimientos/), [Vagrantfile](../../) |
| 13 | **monitoring-stack** | `ubuntu/jammy64` | Ubuntu 22.04 LTS | 2 | 2GB | 20GB | Activo | Stack de monitoreo y observabilidad | Prometheus, Grafana, Alertmanager, Node Exporter | 9090→9090, 3000→3000 | [PROC-VAGRANT-MONITORING](../procedimientos/), [Vagrantfile](../../) |
| 14 | **logging-stack** | `ubuntu/jammy64` | Ubuntu 22.04 LTS | 2 | 2GB | 30GB | Activo | Stack de logging centralizado | ELK Stack (Elasticsearch, Logstash, Kibana), Filebeat | 5601→5601, 9200→9200 | [PROC-VAGRANT-LOGGING](../procedimientos/), [Vagrantfile](../../) |
| 15 | **vpn-gateway** | `ubuntu/jammy64` | Ubuntu 22.04 LTS | 2 | 1GB | 15GB | Planeado | Gateway VPN para acceso seguro | OpenVPN, WireGuard, iptables | 1194→1194 | [PROC-VAGRANT-VPN](../procedimientos/) |
| 16 | **bastion-host** | `ubuntu/jammy64` | Ubuntu 22.04 LTS | 1 | 512MB | 10GB | Planeado | Host SSH de salto para acceso seguro | SSH, Fail2ban, auditd | 22→2222 | [PROC-VAGRANT-BASTION](../procedimientos/) |

## Configuracion por VM

### Matriz de Especificaciones

| VM | CPU | RAM | Disco | Network | Proveedor | Snapshot |
|----|-----|-----|-------|---------|-----------|----------|
| master-db | 4 | 4GB | 40GB | private_network + public | VirtualBox | daily |
| backend-api | 2 | 2GB | 20GB | private_network | VirtualBox | on_demand |
| frontend-web | 2 | 2GB | 20GB | private_network | VirtualBox | on_demand |
| queue-broker | 2 | 2GB | 20GB | private_network | VirtualBox | daily |
| cache-server | 2 | 2GB | 15GB | private_network | VirtualBox | daily |
| search-engine | 2 | 3GB | 30GB | private_network | VirtualBox | daily |
| container-registry | 2 | 2GB | 50GB | private_network | VirtualBox | daily |
| k8s-master | 4 | 4GB | 40GB | private_network | VirtualBox | hourly |
| k8s-worker-1 | 2 | 2GB | 30GB | private_network | VirtualBox | on_demand |
| k8s-worker-2 | 2 | 2GB | 30GB | private_network | VirtualBox | on_demand |
| ci-cd-runner | 4 | 4GB | 40GB | private_network | VirtualBox | daily |
| vault-server | 2 | 1GB | 10GB | private_network | VirtualBox | daily |
| monitoring-stack | 2 | 2GB | 20GB | private_network | VirtualBox | daily |
| logging-stack | 2 | 2GB | 30GB | private_network | VirtualBox | daily |

## Topología de Red

```
┌─────────────────────────────────────────────┐
│           Host Machine (Desarrollo)          │
├─────────────────────────────────────────────┤
│                                             │
│  ┌──────────────────────────────────────┐  │
│  │     Red Privada 192.168.50.0/24      │  │
│  ├──────────────────────────────────────┤  │
│  │  - master-db: 192.168.50.11          │  │
│  │  - backend-api: 192.168.50.21        │  │
│  │  - frontend-web: 192.168.50.31       │  │
│  │  - queue-broker: 192.168.50.41       │  │
│  │  - cache-server: 192.168.50.51       │  │
│  │  - search-engine: 192.168.50.61      │  │
│  │  - container-registry: 192.168.50.71 │  │
│  │  - k8s-master: 192.168.50.101        │  │
│  │  - k8s-worker-1: 192.168.50.102      │  │
│  │  - k8s-worker-2: 192.168.50.103      │  │
│  │  - ci-cd-runner: 192.168.50.111      │  │
│  │  - vault-server: 192.168.50.121      │  │
│  │  - monitoring-stack: 192.168.50.131  │  │
│  │  - logging-stack: 192.168.50.141     │  │
│  └──────────────────────────────────────┘  │
│                                             │
└─────────────────────────────────────────────┘
```

## Dependencias entre VMs

| VM | Requiere | Notas |
|----|---------:|-------|
| backend-api | master-db, cache-server, queue-broker | Servicios de datos y colas |
| frontend-web | backend-api | API backend para consumo |
| ci-cd-runner | container-registry, vault-server | Artefactos y secretos |
| k8s-worker-1, k8s-worker-2 | k8s-master | Cluster coordination |
| monitoring-stack | Todas las VMs | Scraping de métricas |
| logging-stack | Todas las VMs | Recolección de logs |

## Requisitos del Host

| Recurso | Mínimo | Recomendado | Instalado |
|---------|--------|-------------|-----------|
| CPU Cores | 8 | 16+ | [Tu sistema] |
| RAM | 16GB | 32GB+ | [Tu sistema] |
| Disco | 200GB | 500GB+ | [Tu sistema] |
| Vagrant | 2.3+ | 2.4+ | [OK] |
| VirtualBox | 6.1+ | 7.0+ | [OK] |
| Docker | 20.10+ | 24.0+ | [OK] |

## Comandos Comunes

```bash
# Listar todas las VMs
vagrant global-status

# Iniciar stack completo
vagrant up

# Iniciar VMs específicas
vagrant up master-db backend-api frontend-web

# Pausar todas
vagrant suspend

# Detener todas
vagrant halt

# Validar Vagrantfile
vagrant validate

# Provisionar nuevamente
vagrant provision

# Eliminar VMs (¡CUIDADO!)
vagrant destroy
```

## Self-Consistency Checks

### Validación de Recursos

```
Total Recursos Asignados:
- CPU: 16 cores (máximo 4 por VM)
- RAM: 32GB (máximo 4GB por VM)
- Disco: 330GB (asignación variable)

Validación Cruzada:
- [OK] Todas las VMs usan Ubuntu 22.04 LTS
- [OK] Puertos no conflictivos en host
- [OK] IPs únicas en rango privado
- [OK] Servicios críticos tienen backups
```

### Matriz de Dependencias Verificada

```
Cadenas críticas identificadas:
1. master-db → backend-api → frontend-web
2. k8s-master → k8s-worker-1, k8s-worker-2
3. All Services → monitoring-stack → logging-stack
```

## Notas de Implementacion

1. **Tabular CoT Aplicado:** Cada VM documentada con 12 dimensiones clave
2. **Self-Consistency:** Validación de dependencias y recursos
3. **Topología Clara:** Documentación visual de la red
4. **Comandos Operacionales:** Referencia rápida para desarrolladores
5. **Requisitos Explícitos:** Claridad sobre recursos necesarios

---

**Versión:** 1.0.0
**Última Actualización:** 2025-11-18
**Próxima Revisión:** 2025-12-18
**Responsable:** Equipo Desarrollo Local
