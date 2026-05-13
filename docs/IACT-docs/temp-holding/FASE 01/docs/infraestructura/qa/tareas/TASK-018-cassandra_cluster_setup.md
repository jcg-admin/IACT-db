---
id: TASK-018-cassandra-cluster-setup
tipo: documentacion_infraestructura
categoria: infraestructura
prioridad: P2
story_points: 5
estado: completado
fecha_inicio: 2025-11-07
fecha_fin: 2025-11-07
asignado: devops-lead
relacionados: ["TASK-017", "ADR-004"]
---

# TASK-018: Cassandra Cluster Setup

Configuracion y tuning de cluster Cassandra 3 nodos para logs de infraestructura (Layer 3).

## Cluster Configuration

**Nodos:** 3 (cassandra-1, cassandra-2, cassandra-3)
**Replication Factor:** 3
**Consistency Level:** ONE (writes), QUORUM (reads criticos)
**Ports:**
- CQL: 9042-9044
- JMX: 7199-7201
- Inter-node: 7000-7002


## Técnicas de Prompt Engineering para Agente

Las siguientes técnicas deben aplicarse al ejecutar esta tarea con un agente:

1. **Tool-use Prompting** (knowledge_techniques.py)
   - Ejecutar comandos de setup y configuracion de infraestructura

2. **Expert Prompting** (specialized_techniques.py)
   - Aplicar conocimiento experto de Cassandra, MySQL y arquitectura distribuida

3. **Task Decomposition** (structuring_techniques.py)
   - Dividir deployment en fases (setup, config, validation)

4. **Constitutional AI** (optimization_techniques.py)
   - Validar compliance con politicas de seguridad e infraestructura

5. **Simulation** (specialized_techniques.py)
   - Simular cargas y escenarios de fallo antes de produccion

Agente recomendado: SDLCDesignAgent o PDCAAutomationAgent
## Performance Tuning

**Heap Size:**
- MAX_HEAP_SIZE: 2G
- HEAP_NEWSIZE: 400M

**Compaction:**
- Strategy: TimeWindowCompactionStrategy
- Window: 1 day

**Monitoring:** JMX (sin Prometheus, RNF-002 compliant)

## Deployment

```bash
# Iniciar cluster
docker-compose -f docker-compose.cassandra.yml up -d

# Verificar status
docker exec cassandra-1 nodetool status

# Crear keyspace y tables
cqlsh -f scripts/cassandra/schemas/infrastructure_logs.cql
```

## Health Checks

```bash
# Status del cluster
nodetool status

# Verificar replication
nodetool describecluster
```

**Documentacion completa:** Ver docker-compose.cassandra.yml y scripts/cassandra/

---

**VERSION:** 1.0.0
**ESTADO:** COMPLETADO
**STORY POINTS:** 5 SP
**FECHA:** 2025-11-07
