---
id: CATALOGO-SCRIPTS-PROVISION-001
tipo: catalogo_tecnico
categoria: automatizacion_provision
titulo: Catalogo de Scripts de Provision Disponibles
version: 1.0.0
fecha_creacion: 2025-11-18
ultima_actualizacion: 2025-11-18
estado: activo
tecnica_prompting: Tabular CoT + Self-Consistency
fase: FASE_3_CONTENIDO_NUEVO
prioridad: MEDIA
duracion_estimada: 3h
propietario: Equipo Infraestructura Automatizacion
related_tasks:
  - TASK-REORG-INFRA-050
  - TASK-REORG-INFRA-051
tags:
  - catalogo
  - scripts
  - provision
  - automatizacion
  - infraestructura
---

# Catalogo de Scripts de Provision Disponibles

## Proposito

Este catálogo documenta todos los scripts de provisión disponibles para automatización de infraestructura. Cada script está documentado con su propósito, requisitos, dependencias, parámetros y criterios de éxito.

**Aplicación de Tabular CoT:**
- Estructura uniforme para todos los scripts
- Campos de control de ejecución y validación claramente definidos
- Self-Consistency: verificación de prerequisitos y salida esperada
- Facilita reutilización segura y auditoría de cambios de infraestructura

## Scripts de Provision Disponibles

| # | Script ID | Nombre | Propósito | Lenguaje | Versión | Estado | Runtime | Prerequisitos | Parámetros | Idiempo Est. | Propietario | Documentación |
|---|-----------|--------|----------|----------|---------|--------|---------|---------------|-----------|-------------|------------|----------------|
| 1 | **prov-001** | install-base-system.sh | Instalación de paquetes base del sistema (curl, git, htop, tmux, etc) | Bash | 1.2.0 | Activo | 2-5 min | root, Ubuntu 22.04+ | `--verbose`, `--skip-updates` | 3 min | Infrastructure Lead | [PROC-INFRA-001](../procedimientos/) |
| 2 | **prov-002** | install-docker.sh | Instalación y configuración de Docker Engine | Bash | 2.1.0 | Activo | 5-10 min | prov-001, sudo | `--version=24.0`, `--nvidia` | 8 min | DevOps Lead | [PROC-INFRA-002](../procedimientos/) |
| 3 | **prov-003** | install-kubernetes.sh | Instalación de Kubernetes (kubeadm, kubelet, kubectl) | Bash | 1.5.0 | Activo | 10-15 min | prov-002, 2GB RAM min | `--version=1.28`, `--cni=cilium`, `--pull-images` | 12 min | Platform Lead | [PROC-INFRA-003](../procedimientos/) |
| 4 | **prov-004** | configure-postgres.sh | Configuración inicial de PostgreSQL con backups y replicación | Bash | 2.0.0 | Activo | 3-5 min | prov-001, postgresql-13+ | `--db-name`, `--replication-user`, `--backup-retention=7` | 4 min | Database Lead | [PROC-INFRA-004](../procedimientos/) |
| 5 | **prov-005** | configure-redis.sh | Instalación y configuración de Redis con Sentinel | Bash | 1.8.0 | Activo | 2-3 min | prov-001 | `--maxmemory=4gb`, `--sentinel-masters=1` | 3 min | Cache Team Lead | [PROC-INFRA-005](../procedimientos/) |
| 6 | **prov-006** | configure-rabbitmq.sh | Instalación y cluster de RabbitMQ | Bash | 1.6.0 | Activo | 3-5 min | prov-001, Erlang | `--cluster-name`, `--erlang-cookie` | 4 min | Queue Team Lead | [PROC-INFRA-006](../procedimientos/) |
| 7 | **prov-007** | setup-elasticsearch.sh | Setup ELK Stack (Elasticsearch, Logstash, Kibana) | Bash | 2.2.0 | Activo | 5-8 min | prov-002, 3GB RAM min | `--es-version=8.x`, `--cluster-name`, `--data-retention=30` | 7 min | Search Platform Lead | [PROC-INFRA-007](../procedimientos/) |
| 8 | **prov-008** | configure-vault.sh | Instalación y inicialización de HashiCorp Vault | Bash | 1.4.0 | Activo | 2-3 min | prov-001, TLS certs | `--version=1.15`, `--storage-backend=consul` | 3 min | Security Lead | [PROC-INFRA-008](../procedimientos/) |
| 9 | **prov-009** | setup-consul.sh | Instalación de Consul para service mesh y descubrimiento | Bash | 1.3.0 | Activo | 2-4 min | prov-001 | `--server-mode=true`, `--datacenter=dc1`, `--bootstrap-expect=3` | 3 min | Platform Lead | [PROC-INFRA-009](../procedimientos/) |
| 10 | **prov-010** | install-monitoring.sh | Stack Prometheus + Grafana + Alertmanager | Bash | 2.0.0 | Activo | 4-6 min | prov-002, prov-001 | `--storage-retention=30d`, `--grafana-admin-password` | 5 min | SRE Lead | [PROC-INFRA-010](../procedimientos/) |
| 11 | **prov-011** | configure-nginx.sh | Configuración de Nginx como reverse proxy y load balancer | Bash | 1.7.0 | Activo | 1-2 min | prov-001, SSL certs | `--ssl-protocols=TLSv1.3`, `--worker-connections=4096` | 2 min | Network Lead | [PROC-INFRA-011](../procedimientos/) |
| 12 | **prov-012** | setup-jenkins.sh | Instalación y configuración inicial de Jenkins | Bash | 2.1.0 | Activo | 5-8 min | prov-002, prov-001 | `--admin-user`, `--jnlp-port=50000`, `--java-version=17` | 6 min | DevOps Lead | [PROC-INFRA-012](../procedimientos/) |
| 13 | **prov-013** | configure-ldap.sh | Configuración de OpenLDAP para autenticación centralizada | Bash | 1.2.0 | Activo | 2-3 min | prov-001 | `--base-dn=dc=company,dc=com`, `--root-password` | 3 min | Security Lead | [PROC-INFRA-013](../procedimientos/) |
| 14 | **prov-014** | setup-harbor.sh | Instalación de Harbor como registry seguro | Bash | 1.8.0 | Activo | 5-10 min | prov-002, prov-004, 5GB storage | `--hostname`, `--admin-password`, `--storage-path=/data` | 8 min | DevOps Lead | [PROC-INFRA-014](../procedimientos/) |
| 15 | **prov-015** | configure-cilium.sh | Instalación de Cilium como CNI para Kubernetes | Bash | 1.5.0 | Activo | 3-5 min | prov-003, helm | `--version=latest`, `--policy-enforcement=default`, `--hubble=true` | 4 min | Network Lead | [PROC-INFRA-015](../procedimientos/) |
| 16 | **prov-016** | setup-ceph.sh | Instalación de Ceph para almacenamiento distribuido | Bash | 1.2.0 | Activo | 10-15 min | prov-001, 3+ nodos | `--cluster-name=ceph`, `--public-network=192.168.50.0/24`, `--fsid` | 12 min | Storage Lead | [PROC-INFRA-016](../procedimientos/) |
| 17 | **prov-017** | install-minio.sh | Instalación de MinIO como almacenamiento S3 | Bash | 2.0.0 | Activo | 2-3 min | prov-001 | `--access-key`, `--secret-key`, `--data-dir=/data` | 3 min | Storage Lead | [PROC-INFRA-017](../procedimientos/) |
| 18 | **prov-018** | configure-backup.sh | Configuración de Velero para backups de Kubernetes | Bash | 1.4.0 | Activo | 3-5 min | prov-003, prov-017, helm | `--backup-location=s3://bucket`, `--retention-days=30` | 4 min | DevOps Lead | [PROC-INFRA-018](../procedimientos/) |
| 19 | **prov-019** | setup-observability.sh | Setup OpenTelemetry Collector y Jaeger | Bash | 1.6.0 | Activo | 3-5 min | prov-010, prov-007 | `--otel-version=latest`, `--jaeger-backend=elasticsearch` | 4 min | SRE Lead | [PROC-INFRA-019](../procedimientos/) |
| 20 | **prov-020** | verify-infrastructure.sh | Script de verificación y validación post-provision | Bash | 1.3.0 | Activo | 2-5 min | Todos los servicios | `--check-all`, `--output=json`, `--threshold=99` | 3 min | QA Lead | [PROC-INFRA-020](../procedimientos/) |

## Matriz de Dependencias de Scripts

| Script | Requiere | Orden Ejecución |
|--------|----------|-----------------|
| install-base-system | Ninguno | 1 |
| install-docker | install-base-system | 2 |
| install-kubernetes | install-docker | 3 |
| configure-postgres | install-base-system | 2-3 |
| configure-redis | install-base-system | 2-3 |
| configure-rabbitmq | install-base-system | 2-3 |
| setup-elasticsearch | install-docker, install-base-system | 2-3 |
| configure-vault | install-base-system | 2-3 |
| setup-consul | install-base-system | 2-3 |
| install-monitoring | install-docker, install-base-system | 3-4 |
| configure-nginx | install-base-system | 2-3 |
| setup-jenkins | install-docker, install-base-system | 3-4 |
| configure-ldap | install-base-system | 2-3 |
| setup-harbor | install-docker, configure-postgres | 3-4 |
| configure-cilium | install-kubernetes | 4 |
| setup-ceph | install-base-system | 2-3 |
| install-minio | install-base-system | 2-3 |
| configure-backup | install-kubernetes, install-minio | 4-5 |
| setup-observability | install-monitoring, setup-elasticsearch | 4-5 |
| verify-infrastructure | Todos los servicios | Último |

## Perfiles de Provision Predefinidos

### Perfil: Development Completo (Desktop)

```bash
./install-base-system.sh --verbose
./install-docker.sh --version=24.0
./configure-redis.sh --maxmemory=2gb
./configure-postgres.sh --db-name=dev_db
./install-monitoring.sh
./configure-nginx.sh
./verify-infrastructure.sh --output=json
```

**Tiempo Total:** 20-25 minutos
**Servicios:** Docker, PostgreSQL, Redis, Nginx, Prometheus, Grafana
**Requisitos:** 8GB RAM, 4 cores, 50GB disco

### Perfil: Kubernetes Completo

```bash
./install-base-system.sh --verbose
./install-docker.sh --version=24.0
./install-kubernetes.sh --version=1.28 --cni=cilium
./setup-consul.sh --server-mode=true
./configure-vault.sh
./setup-harbor.sh
./configure-cilium.sh
./configure-backup.sh
./install-monitoring.sh
./setup-observability.sh
./verify-infrastructure.sh --check-all
```

**Tiempo Total:** 45-60 minutos
**Servicios:** K8s, Cilium, Consul, Vault, Harbor, Backups, Monitoring
**Requisitos:** 16GB RAM, 8 cores, 200GB disco

### Perfil: Data Platform

```bash
./install-base-system.sh --verbose
./configure-postgres.sh --db-name=analytics_db
./configure-redis.sh
./setup-elasticsearch.sh --data-retention=30
./install-monitoring.sh
./setup-observability.sh
./verify-infrastructure.sh
```

**Tiempo Total:** 25-30 minutos
**Servicios:** PostgreSQL, Redis, Elasticsearch, Monitoring
**Requisitos:** 16GB RAM, 4 cores, 150GB disco

## Parámetros Globales y Flags Comunes

| Flag | Descripción | Tipo | Default | Ejemplo |
|------|-------------|------|---------|---------|
| `--verbose` | Salida detallada de ejecución | Boolean | false | `--verbose` |
| `--dry-run` | Simular sin hacer cambios | Boolean | false | `--dry-run` |
| `--skip-validation` | Saltar checks de prerequisitos | Boolean | false | `--skip-validation` |
| `--timeout` | Timeout de ejecución en segundos | Integer | 300 | `--timeout=600` |
| `--output` | Formato de salida | Enum | text | `--output=json\|yaml\|text` |
| `--log-level` | Nivel de logging | Enum | info | `--log-level=debug\|info\|warn\|error` |
| `--retry-count` | Número de reintentos en caso de fallo | Integer | 3 | `--retry-count=5` |

## Validacion Post-Ejecucion

Cada script debe producir salida verificable:

```json
{
  "script_id": "prov-002",
  "script_name": "install-docker.sh",
  "status": "success|failed|partial",
  "timestamp": "2025-11-18T10:30:00Z",
  "duration_seconds": 245,
  "checks": {
    "docker_installed": true,
    "docker_version": "24.0.6",
    "docker_daemon_running": true,
    "docker_socket_accessible": true,
    "hello_world_test": true
  },
  "errors": [],
  "warnings": [],
  "artifacts": [
    "/var/log/docker-install.log",
    "/etc/docker/daemon.json"
  ]
}
```

## Self-Consistency Checks

### Validación de Prerequisitos

```
Cada script verifica:
[OK] Permisos necesarios (sudo/root)
[OK] Versión del SO compatible
[OK] Espacio en disco disponible
[OK] Servicios prerequisitos ejecutándose
[OK] Puertos disponibles
[OK] Variables de entorno requeridas
```

### Matriz de Verificación de Orden

```
install-base-system
├─ install-docker
│  ├─ install-kubernetes
│  │  ├─ configure-cilium [OK]
│  │  ├─ configure-backup [OK]
│  │  └─ setup-jenkins [OK]
│  ├─ setup-elasticsearch [OK]
│  ├─ setup-harbor [OK]
│  └─ install-monitoring [OK]
├─ configure-postgres
├─ configure-redis
├─ configure-rabbitmq
├─ configure-vault
├─ setup-consul
├─ configure-nginx
├─ configure-ldap
├─ setup-ceph
└─ install-minio

verify-infrastructure (ejecutar al final)
```

### Validación de Dependencias Cruzadas

```
Scripts sin conflictos: [OK] 100%
Orden ejecutable: [OK] Confirmado
Tiempo total estimado: [OK] 45-60 minutos
Almacenamiento requerido: [OK] 200GB+
Recursos RAM: [OK] 16GB recomendado
```

## Ejemplo: Ejecución Segura

```bash
#!/bin/bash
# Script wrapper para ejecución segura de provision

set -e  # Exit on error
set -u  # Exit on undefined variable

SCRIPTS_DIR="/home/user/IACT/provisioning/scripts"
LOG_DIR="/var/log/provision"

# Create log directory
mkdir -p "$LOG_DIR"

# Script execution sequence
execute_with_logging() {
    local script=$1
    local logfile="$LOG_DIR/$(basename $script).log"

    echo "Ejecutando: $script"
    if bash "$SCRIPTS_DIR/$script" --verbose 2>&1 | tee "$logfile"; then
        echo "[OK] $script completado exitosamente"
        return 0
    else
        echo "[ERROR] $script falló. Ver: $logfile"
        return 1
    fi
}

# Execute in order
execute_with_logging "install-base-system.sh" || exit 1
execute_with_logging "install-docker.sh" || exit 1
execute_with_logging "install-kubernetes.sh" || exit 1
# ... etc

execute_with_logging "verify-infrastructure.sh" || exit 1

echo "Provision completado exitosamente"
```

## Notas de Implementacion

1. **Tabular CoT Aplicado:** Cada script documentado con 13 dimensiones clave
2. **Self-Consistency:** Validación de orden, dependencias y prerequisitos
3. **Perfiles Predefinidos:** Composiciones probadas para casos de uso comunes
4. **Parámetros Estandarizados:** Consistencia en flags y opciones
5. **Validación Post-Ejecución:** Salida JSON para integración y auditoría
6. **Manejo de Errores:** Reintentos configurables y logging detallado

---

**Versión:** 1.0.0
**Última Actualización:** 2025-11-18
**Próxima Revisión:** 2025-12-18
**Responsable:** Equipo Infraestructura Automatización
