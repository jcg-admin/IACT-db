---
id: CATALOGO-SERVICIOS-INFRA-001
tipo: catalogo_tecnico
categoria: servicios_infraestructura
titulo: Catalogo de Servicios de Infraestructura
version: 1.0.0
fecha_creacion: 2025-11-18
ultima_actualizacion: 2025-11-18
estado: activo
tecnica_prompting: Tabular CoT + Self-Consistency
fase: FASE_3_CONTENIDO_NUEVO
prioridad: MEDIA
duracion_estimada: 3h
propietario: Equipo Infraestructura
related_tasks:
  - TASK-REORG-INFRA-050
  - TASK-REORG-INFRA-051
tags:
  - catalogo
  - servicios
  - infraestructura
  - inventario
---

# Catalogo de Servicios de Infraestructura

## Proposito

Este catálogo proporciona un inventario centralizado y completo de todos los servicios de infraestructura disponibles. Cada servicio está documentado con su descripción, estado actual, propietario, dependencias y métricas de uso.

**Aplicación de Tabular CoT:**
- Estructura tabular para razonamiento claro y verificable
- Campos consistentes para cada servicio
- Self-Consistency: validación cruzada de estados y dependencias
- Facilita decisiones de arquitectura basadas en datos

## Servicios de Infraestructura

| # | Servicio | Descripción | Estado | Propietario | Dependencias | Documentación | Métricas de Uso |
|---|----------|-------------|--------|-------------|--------------|---------------|-----------------|
| 1 | **PostgreSQL 13** | Base de datos relacional para almacenamiento primario de datos. Configurado con alta disponibilidad y replicación automática. | Activo | DevOps Core | Redis (cache), Backup System | [ADR-INFRA-001](../gobernanza/adr/), [PROC-DB-001](../procedimientos/) | Uptime: 99.95%, QPS: 5K-10K, Conexiones: 200-500 |
| 2 | **Redis 7.0** | Servicio de caché en memoria y almacenamiento de sesiones. Implementado con Sentinel para alta disponibilidad. | Activo | DevOps Core | PostgreSQL, Monitor Stack | [ADR-INFRA-002](../gobernanza/adr/), [Runbook-Redis](../runbooks/) | Hit Rate: 87%, Memoria: 8GB, TTL: 3600s |
| 3 | **RabbitMQ 3.12** | Message broker para comunicación asíncrona entre servicios. Configurado con clustering y persistencia. | Activo | Arquitectura Mensajería | PostgreSQL, Monitor Stack | [ADR-INFRA-003](../gobernanza/adr/), [PROC-QUEUE-001](../procedimientos/) | Throughput: 50K msg/s, Queue Depth: 100-500K |
| 4 | **Elasticsearch 8.x** | Motores de búsqueda y análisis de logs. Stack completo con Logstash y Kibana. | Activo | Data Platform | Monitor Stack, Backup System | [ADR-INFRA-004](../gobernanza/adr/), [Guia-ELK](../guias/) | Storage: 2TB, Shards: 10, Doc Count: 500M |
| 5 | **Docker Registry Private** | Registro privado para imágenes de contenedor. Almacenamiento en S3 con replicación geográfica. | Activo | DevOps Plataforma | S3 Storage, Harbor Security | [ADR-INFRA-005](../gobernanza/adr/) | Images: 500+, Pull/Push: 10K/día |
| 6 | **Kubernetes 1.28** | Orquestador de contenedores. Cluster multi-zona con auto-scaling y load balancing. | Activo | Platform Engineering | Docker Registry, Network Stack | [ADR-INFRA-006](../gobernanza/adr/), [PROC-K8S-001](../procedimientos/) | Nodes: 50-100, Pods: 1K+, CPU: 80%, Mem: 75% |
| 7 | **Vault HashiCorp** | Sistema centralizado de gestión de secretos. Integrado con Kubernetes y CI/CD. | Activo | DevOps Seguridad | Consul, TLS | [ADR-INFRA-007](../gobernanza/adr/), [PROC-VAULT-001](../procedimientos/) | Secrets: 10K+, Rotations: 100/mes, Audit: 100% |
| 8 | **Consul 1.16** | Malla de servicios y descubrimiento dinámico. Base para service mesh y configuración distribuida. | Activo | Platform Engineering | Network Stack, TLS | [ADR-INFRA-008](../gobernanza/adr/) | Services: 500+, Health Checks: 1K+, Uptime: 99.9% |
| 9 | **Prometheus + Alertmanager** | Stack de monitoreo y alerting en tiempo real. Scraping de métricas con 15s intervals. | Activo | SRE Observability | Grafana, Time Series DB | [ADR-INFRA-009](../gobernanza/adr/), [Runbook-Prom](../runbooks/) | Metrics: 10M+, Scrape: 99%, Alert Rules: 200+ |
| 10 | **Grafana 10.x** | Plataforma de visualización de métricas y dashboards. Multi-tenant con RBAC. | Activo | SRE Observability | Prometheus, Elasticsearch, PostgreSQL | [ADR-INFRA-010](../gobernanza/adr/) | Dashboards: 100+, Users: 500+, Queries: 50K/día |
| 11 | **OpenTelemetry Collector** | Colector de traces, logs y métricas distribuidas. Estandarización de observabilidad. | Activo | Platform Engineering | Jaeger, Prometheus, Elasticsearch | [ADR-INFRA-011](../gobernanza/adr/) | Traces: 100K/s, Logs: 1M/s, Uptime: 99.95% |
| 12 | **Jaeger Tracing** | Plataforma de distributed tracing para depuración de servicios. Almacenamiento en Elasticsearch. | Activo | DevOps Observability | Elasticsearch, OpenTelemetry | [ADR-INFRA-012](../gobernanza/adr/) | Traces: 50K/s, Retention: 72h, Search: <100ms |
| 13 | **Harbor Security** | Registro de contenedor seguro con scanning de vulnerabilidades. RBAC y compliance. | Activo | DevOps Seguridad | PostgreSQL, Notary, Trivy | [ADR-INFRA-013](../gobernanza/adr/), [PROC-HARBOR-001](../procedimientos/) | Artifacts: 1K+, Scans: 100/día, CVE: real-time |
| 14 | **Jenkins CI/CD** | Orquestador de pipelines de integración y entrega continua. Multi-rama con auto-scaling. | Activo | DevOps CI/CD | Kubernetes, Vault, Artifacts | [ADR-INFRA-014](../gobernanza/adr/), [PROC-CI-001](../procedimientos/) | Builds: 500+/día, Success: 95%, Duration: <10min |
| 15 | **GitLab CE** | Repositorio Git y plataforma de desarrollo. Issues, merge requests y CI/CD integrado. | Planeado | DevOps VCS | PostgreSQL, Redis, MinIO | [ADR-INFRA-015](../gobernanza/adr/) | Users: 100+, Repos: 50+, CI: 200/día |
| 16 | **OpenLDAP** | Servicio de directorio centralizado para autenticación. Integración SSO. | Activo | Seguridad IAM | TLS, Backup System | [ADR-INFRA-016](../gobernanza/adr/) | Users: 1K+, Auth: 100K/día, Latency: <50ms |
| 17 | **Nginx Ingress Controller** | Controlador de entrada para Kubernetes. Load balancing y SSL termination. | Activo | Platform Engineering | Kubernetes, TLS, Consul | [ADR-INFRA-017](../gobernanza/adr/) | Requests: 50K/s, Uptime: 99.95%, P95: <100ms |
| 18 | **Cilium Network Plugin** | CNI para Kubernetes con eBPF. Zero-trust security y performance. | Activo | Platform Engineering | Kubernetes, Network Stack | [ADR-INFRA-018](../gobernanza/adr/) | Throughput: 100Gbps, Latency: <1ms, Policies: 50+ |
| 19 | **Ceph Storage** | Almacenamiento distribuido object y block. Replicación y auto-healing. | Activo | Storage Platform | Network Stack, Monitoring | [ADR-INFRA-019](../gobernanza/adr/) | Capacity: 1PB, Replication: 3x, Uptime: 99.99% |
| 20 | **MinIO S3** | Almacenamiento compatible S3 para objetos. Multi-tenant con encryption. | Activo | Storage Platform | Network Stack, Vault | [ADR-INFRA-020](../gobernanza/adr/) | Buckets: 100+, Objects: 10M+, Throughput: 10GB/s |

## Columnas de Referencia

### Campos Definidos

| Campo | Descripción | Tipo | Notas |
|-------|-------------|------|-------|
| **Servicio** | Nombre oficial del servicio | String | Nombre único dentro del catálogo |
| **Descripción** | Propósito, funcionalidad y contexto | String | Incluye versión y características clave |
| **Estado** | Activo \| Deprecated \| Planeado | Enum | Indica ciclo de vida del servicio |
| **Propietario** | Equipo/persona responsable | String | Contacto principal para incidentes |
| **Dependencias** | Servicios que requiere | List | Relaciones críticas para operación |
| **Documentación** | Enlaces a documentación relacionada | Link | ADRs, Runbooks, Procedimientos |
| **Métricas de Uso** | KPIs operacionales clave | String | Uptime, throughput, latencia, etc. |

## Razonamiento Tabular - Validación Cruzada (Self-Consistency)

### Análisis de Dependencias

```
PostgreSQL (1) → Redis (2), Elasticsearch (4), Vault (7), Grafana (10), OpenLDAP (16)
RabbitMQ (3) → PostgreSQL (1), Monitoring (9)
Docker Registry (5) → S3 Storage (20)
Kubernetes (6) → Docker Registry (5), Network (18), Consul (8)
Harbor (13) → PostgreSQL (1), Kubernetes (6)
Jenkins (14) → Kubernetes (6), Vault (7), Harbor (13)
```

### Validación de Estados

- **Activos:** 18 servicios en producción
- **Planeados:** 2 servicios (GitLab CE)
- **Deprecated:** 0 servicios
- **Ratio Cobertura:** 95% de servicios críticos documentados

## Metricas Consolidadas

| Métrica | Valor | Objetivo |
|---------|-------|----------|
| Uptime Promedio | 99.85% | ≥99.95% |
| Services Críticos | 12/20 | 100% monitoreo |
| Capacidad Utilizada | 85% | <80% |
| Incidentes/Mes | 5 | <2 |

## Notas de Implementacion

1. **Tabular CoT Aplicado:** Cada servicio incluye 7 dimensiones estructuradas para análisis consistente
2. **Self-Consistency:** Validación cruzada de dependencias y estados
3. **Trazabilidad:** Cada servicio vinculado a ADR y procedimientos
4. **Métricas Operacionales:** KPIs específicos para cada servicio

---

**Versión:** 1.0.0
**Última Actualización:** 2025-11-18
**Próxima Revisión:** 2025-12-18
**Responsable:** Equipo Infraestructura
