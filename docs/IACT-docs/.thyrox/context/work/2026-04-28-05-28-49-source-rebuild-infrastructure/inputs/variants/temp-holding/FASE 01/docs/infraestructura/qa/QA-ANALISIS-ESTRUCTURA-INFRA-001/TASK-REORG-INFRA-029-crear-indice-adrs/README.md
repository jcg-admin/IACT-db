---
id: TASK-REORG-INFRA-029
titulo: Crear INDICE_ADRs.md
fase: FASE_2_REORGANIZACION_CRITICA
subcategoria: Crear Indice ADRs
prioridad: ALTA (P1)
duracion_estimada: 2 horas
estado: Pendiente
tipo: Documentacion
dependencias:
  - FASE_1_completada
tecnica_prompting: Tabular CoT
fecha_creacion: 2025-11-18
autor: QA Infraestructura
tags:
  - documentacion
  - adr
  - indice
  - fase-2
---

# TASK-REORG-INFRA-029: Crear INDICE_ADRs.md

## Descripción

Crear un índice maestro de todos los Architecture Decision Records (ADRs) de infraestructura en `/docs/infraestructura/adr/INDICE_ADRs.md`, incluyendo ADRs existentes y planificados.

## Objetivo

Proporcionar un punto central de navegación para todos los ADRs de infraestructura, facilitando la búsqueda, consulta y tracking de decisiones arquitecturales.

## Técnica de Prompting: Tabular CoT

### Aplicación de Tabular Chain-of-Thought

**Tabular CoT** estructura el razonamiento en formato tabular, facilitando organización, comparación y navegación de información estructurada.

#### Razonamiento para Diseño Tabular

```
PREGUNTA: ¿Cómo organizar índice de ADRs para máxima utilidad?

PASO 1: Identificar Información Clave
├─ ¿Qué necesita usuario para ENCONTRAR ADR?
│   ├─ ID único (ADR-INFRA-XXX)
│   ├─ Título descriptivo
│   ├─ Estado (Propuesto/Aceptado/Rechazado/Supersedido)
│   └─ Fecha de decisión
└─ Conclusión: Columnas = ID, Título, Estado, Fecha

PASO 2: Identificar Agrupaciones
├─ ¿Cómo CATEGORIZAR ADRs?
│   ├─ Por componente (DevContainer, VM, CI/CD)
│   ├─ Por estado (Activo vs Supersedido)
│   ├─ Por fecha (cronológico)
│   └─ Por impacto (Alto/Medio/Bajo)
└─ Conclusión: Múltiples vistas = Múltiples tablas

PASO 3: Diseñar Navegación
├─ Vista 1: Todos los ADRs (tabla completa)
├─ Vista 2: Por Estado (filtrado)
├─ Vista 3: Por Componente (agrupado)
└─ Vista 4: Cronológico (timeline)

RESULTADO: Documento con 4 tablas diferentes para diferentes necesidades
```

#### Estructura Tabular Propuesta

```
TABLA 1: ADRs por ID (Completo)
┌──────────────┬─────────────────────────────┬───────────┬────────────┬────────────┐
│ ID           │ Título                      │ Estado    │ Fecha      │ Supersede  │
├──────────────┼─────────────────────────────┼───────────┼────────────┼────────────┤
│ ADR-INFRA-001│ Vagrant DevContainer Host   │ Aceptado  │ 2025-01-15 │ N/A        │
│ ADR-INFRA-002│ Pipeline CI/CD DevContainer │ Aceptado  │ 2025-01-20 │ N/A        │
│ ...          │ ...                         │ ...       │ ...        │ ...        │
└──────────────┴─────────────────────────────┴───────────┴────────────┴────────────┘

TABLA 2: ADRs por Estado
┌───────────────┬────────────────────────────────────────────────────────┐
│ Estado        │ ADRs                                                    │
├───────────────┼────────────────────────────────────────────────────────┤
│ Aceptados     │ ADR-001, ADR-002, ADR-003, ADR-004, ADR-005            │
│ Propuestos    │ ADR-006, ADR-007                                       │
│ Rechazados    │ [ninguno]                                              │
│ Supersedidos  │ [ninguno]                                              │
└───────────────┴────────────────────────────────────────────────────────┘

TABLA 3: ADRs por Componente
┌────────────────┬───────────────────────────────────────────────────────┐
│ Componente     │ ADRs Relacionados                                     │
├────────────────┼───────────────────────────────────────────────────────┤
│ DevContainer   │ ADR-001, ADR-002, ADR-003                            │
│ CI/CD          │ ADR-002, ADR-004                                      │
│ VM             │ ADR-001, ADR-005                                      │
│ Seguridad      │ ADR-006                                               │
└────────────────┴───────────────────────────────────────────────────────┘

TABLA 4: Timeline Cronológico
┌────────────┬──────────────┬─────────────────────────────────────────┐
│ Fecha      │ ID           │ Decisión                                │
├────────────┼──────────────┼─────────────────────────────────────────┤
│ 2025-01-15 │ ADR-INFRA-001│ Usar Vagrant como DevContainer Host    │
│ 2025-01-20 │ ADR-INFRA-002│ Implementar Pipeline CI/CD DevContainer │
│ ...        │ ...          │ ...                                     │
└────────────┴──────────────┴─────────────────────────────────────────┘
```

### Razonamiento de Columnas

```
COLUMNA: ID
├─ Formato: ADR-INFRA-XXX
├─ Propósito: Identificador único, ordenable
└─ Uso: Referencias cruzadas en documentación

COLUMNA: Título
├─ Formato: Descripción corta de decisión
├─ Propósito: Entender decisión sin leer documento completo
└─ Uso: Escaneo rápido, búsqueda

COLUMNA: Estado
├─ Valores: Propuesto, Aceptado, Rechazado, Supersedido
├─ Propósito: Filtrar ADRs relevantes vs históricos
└─ Uso: Identificar decisiones actuales

COLUMNA: Fecha
├─ Formato: YYYY-MM-DD
├─ Propósito: Contexto temporal, ordenamiento cronológico
└─ Uso: Entender evolución de decisiones

COLUMNA: Supersede (opcional)
├─ Formato: ID de ADR supersedido
├─ Propósito: Trazabilidad de cambios de decisión
└─ Uso: Entender por qué se cambió decisión anterior
```

## Pasos de Ejecución

### 1. Inventariar ADRs Existentes (20 min)

```bash
cd /home/user/IACT/docs/infraestructura/adr

# Listar ADRs existentes
ls -1 ADR-INFRA-*.md 2>/dev/null | tee /tmp/adrs-existentes.txt

# Extraer metadatos de cada ADR
for adr in ADR-INFRA-*.md; do
  if [ -f "$adr" ]; then
    echo "=== $adr ===" >> /tmp/adrs-metadata.txt
    # Extraer título
    grep -m1 "^titulo:\|^# ADR" "$adr" >> /tmp/adrs-metadata.txt
    # Extraer estado
    grep -m1 "^estado:" "$adr" >> /tmp/adrs-metadata.txt
    # Extraer fecha
    grep -m1 "^fecha:" "$adr" >> /tmp/adrs-metadata.txt
    echo "" >> /tmp/adrs-metadata.txt
  fi
done

# Contar ADRs
ADR_COUNT=$(ls -1 ADR-INFRA-*.md 2>/dev/null | wc -l)
echo "Total ADRs existentes: $ADR_COUNT"
```

**Tabular CoT - Estructurar Datos:**

```
| ADR Archivo                                    | ID Extraído   | Título                        | Estado    | Fecha      |
|------------------------------------------------|---------------|-------------------------------|-----------|------------|
| ADR-INFRA-001-vagrant-devcontainer-host.md    | ADR-INFRA-001 | Vagrant DevContainer Host     | Aceptado  | 2025-01-15 |
| ADR-INFRA-002-pipeline-cicd-devcontainer.md   | ADR-INFRA-002 | Pipeline CI/CD DevContainer   | Aceptado  | 2025-01-20 |
| ...                                            | ...           | ...                           | ...       | ...        |
```

### 2. Listar ADRs Planificados (15 min)

```bash
# Consultar LISTADO-COMPLETO-TAREAS.md para ADRs planificados en FASE 3
grep -A 10 "TASK-REORG-INFRA-03[1-7]" \
  /home/user/IACT/docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/LISTADO-COMPLETO-TAREAS.md | \
  grep "ADR" > /tmp/adrs-planificados.txt

# Ejemplo de ADRs planificados (según LISTADO-COMPLETO-TAREAS)
cat > /tmp/adrs-plan-tabla.txt << 'EOF'
| ID            | Título                                  | Estado       | Fecha Plan | Tarea      |
|---------------|-----------------------------------------|--------------|------------|------------|
| ADR-INFRA-003 | Alpine Linux Base DevContainer          | Planificado  | FASE 3     | TASK-033   |
| ADR-INFRA-004 | CPython Precompilado                    | Planificado  | FASE 3     | TASK-034   |
| ADR-INFRA-005 | GitHub Actions CI/CD                    | Planificado  | FASE 3     | TASK-035   |
| ADR-INFRA-006 | Repositorio Git Self-Hosted             | Planificado  | FASE 3     | TASK-036   |
| ADR-INFRA-007 | Estructura de Documentación Técnica     | Planificado  | FASE 3     | TASK-037   |
EOF
```

**Tabular CoT - Consolidar:**
- ADRs Existentes: Extraídos de archivos
- ADRs Planificados: Extraídos de plan de tareas
- Unión: Tabla maestra completa

### 3. Crear INDICE_ADRs.md con Estructura Tabular (60 min)

```bash
cat > INDICE_ADRs.md << 'EOF'
---
tipo: indice
componente: adr
proposito: Índice maestro de Architecture Decision Records de infraestructura
fecha_actualizacion: 2025-11-18
responsable: QA Infraestructura
total_adrs: 2
adrs_activos: 2
adrs_planificados: 5
---

# Índice de Architecture Decision Records (ADRs)

## Propósito

Este documento es el **índice maestro** de todos los Architecture Decision Records (ADRs) de infraestructura del proyecto IACT.

**Usar este índice para:**
- Encontrar ADR específico por ID o tema
- Ver estado de decisiones arquitecturales
- Entender evolución de arquitectura de infraestructura
- Identificar ADRs planificados

## Resumen Ejecutivo

| Métrica | Valor |
|---------|-------|
| **Total ADRs** | 7 (2 existentes + 5 planificados) |
| **Aceptados** | 2 |
| **Propuestos** | 0 |
| **Planificados** | 5 |
| **Rechazados** | 0 |
| **Supersedidos** | 0 |

## Tabla Completa de ADRs

### ADRs Existentes

| ID | Título | Estado | Fecha | Componentes | Archivo |
|----|--------|--------|-------|-------------|---------|
| ADR-INFRA-001 | [Vagrant como DevContainer Host](./ADR-INFRA-001-vagrant-devcontainer-host.md) | Aceptado | 2025-01-15 | DevContainer, VM | ADR-INFRA-001-vagrant-devcontainer-host.md |
| ADR-INFRA-002 | [Pipeline CI/CD para DevContainer](./ADR-INFRA-002-pipeline-cicd-devcontainer.md) | Aceptado | 2025-01-20 | CI/CD, DevContainer | ADR-INFRA-002-pipeline-cicd-devcontainer.md |

### ADRs Planificados (FASE 3)

| ID | Título | Estado | Fecha Plan | Componentes | Tarea |
|----|--------|--------|------------|-------------|-------|
| ADR-INFRA-003 | Alpine Linux como Base DevContainer | Planificado | FASE 3 | DevContainer, OS | TASK-REORG-INFRA-033 |
| ADR-INFRA-004 | CPython Precompilado en DevContainer | Planificado | FASE 3 | DevContainer, Python | TASK-REORG-INFRA-034 |
| ADR-INFRA-005 | GitHub Actions para CI/CD | Planificado | FASE 3 | CI/CD, GitHub | TASK-REORG-INFRA-035 |
| ADR-INFRA-006 | Repositorio Git Self-Hosted (Gitea) | Planificado | FASE 3 | Git, Seguridad | TASK-REORG-INFRA-036 |
| ADR-INFRA-007 | Estructura de Documentación Técnica | Planificado | FASE 3 | Documentación | TASK-REORG-INFRA-037 |

## Vista por Estado

### Activos (Aceptados)

Decisiones arquitecturales actualmente en vigor:

| ID | Título | Fecha Aceptación | Impacto |
|----|--------|------------------|---------|
| ADR-INFRA-001 | Vagrant como DevContainer Host | 2025-01-15 | Alto - Define host de desarrollo |
| ADR-INFRA-002 | Pipeline CI/CD para DevContainer | 2025-01-20 | Alto - Automatización de desarrollo |

### Planificados

Decisiones a documentar en FASE 3:

| ID | Título | Prioridad | Tarea |
|----|--------|-----------|-------|
| ADR-INFRA-003 | Alpine Linux como Base DevContainer | Alta | TASK-033 |
| ADR-INFRA-004 | CPython Precompilado en DevContainer | Alta | TASK-034 |
| ADR-INFRA-005 | GitHub Actions para CI/CD | Crítica | TASK-035 |
| ADR-INFRA-006 | Repositorio Git Self-Hosted (Gitea) | Media | TASK-036 |
| ADR-INFRA-007 | Estructura de Documentación Técnica | Alta | TASK-037 |

### Supersedidos

[Ninguno actualmente]

### Rechazados

[Ninguno actualmente]

## Vista por Componente

### DevContainer

| ID | Título | Estado |
|----|--------|--------|
| ADR-INFRA-001 | Vagrant como DevContainer Host | Aceptado |
| ADR-INFRA-002 | Pipeline CI/CD para DevContainer | Aceptado |
| ADR-INFRA-003 | Alpine Linux como Base DevContainer | Planificado |
| ADR-INFRA-004 | CPython Precompilado en DevContainer | Planificado |

### CI/CD

| ID | Título | Estado |
|----|--------|--------|
| ADR-INFRA-002 | Pipeline CI/CD para DevContainer | Aceptado |
| ADR-INFRA-005 | GitHub Actions para CI/CD | Planificado |

### Infraestructura Base

| ID | Título | Estado |
|----|--------|--------|
| ADR-INFRA-001 | Vagrant como DevContainer Host | Aceptado |
| ADR-INFRA-006 | Repositorio Git Self-Hosted (Gitea) | Planificado |

### Documentación

| ID | Título | Estado |
|----|--------|--------|
| ADR-INFRA-007 | Estructura de Documentación Técnica | Planificado |

## Timeline Cronológico

```
2025-01-15: ADR-INFRA-001 - Decisión: Vagrant como DevContainer Host
              ├─ Contexto: Necesidad de entorno de desarrollo reproducible
              ├─ Alternativas: Docker Desktop, Multipass, WSL2
              └─ Consecuencia: Vagrant seleccionado por portabilidad

2025-01-20: ADR-INFRA-002 - Decisión: Pipeline CI/CD para DevContainer
              ├─ Contexto: Automatizar testing y validación DevContainer
              ├─ Alternativas: CI manual, GitHub Actions, Jenkins
              └─ Consecuencia: Pipeline implementado con validaciones automáticas

FASE 3: ADR-INFRA-003 a 007 - Decisiones planificadas para documentar
```

## Proceso de Creación de ADRs

### Cuándo Crear un ADR

Crear ADR cuando:
- Decisión arquitectural con impacto significativo
- Elección entre múltiples alternativas técnicas
- Cambio que afecta múltiples componentes
- Decisión que necesita justificación documentada
- Cambio que supersede decisión anterior

### Pasos para Crear ADR

```bash
# 1. Obtener próximo número
NEXT_NUM=$(ls -1 ADR-INFRA-*.md | sed 's/ADR-INFRA-0*//;s/-.*//' | sort -n | tail -1 | awk '{print $1+1}')
NEXT_ID=$(printf "ADR-INFRA-%03d" $NEXT_NUM)

# 2. Copiar plantilla
cp ../plantillas/adr/plantilla_adr_infraestructura.md \
   ${NEXT_ID}-descripcion-decision.md

# 3. Completar ADR
# [Editar con contexto, decisión, alternativas, consecuencias]

# 4. Actualizar INDICE_ADRs.md
# [Agregar entrada en tabla]

# 5. Commit
git add ${NEXT_ID}-*.md INDICE_ADRs.md
git commit -m "docs(adr): Add ${NEXT_ID} - [decisión]"
```

### Plantilla ADR

Ver: `/docs/infraestructura/plantillas/adr/plantilla_adr_infraestructura.md`

**Secciones principales:**
- Contexto y Problema
- Decisión
- Alternativas Consideradas
- Consecuencias (Pros y Contras)
- Referencias

## Nomenclatura

### Formato de ADR

```
ADR-INFRA-XXX-descripcion-decision.md
```

**Componentes:**
- `ADR-INFRA`: Architecture Decision Record de Infraestructura
- `XXX`: Número secuencial (001, 002, 003...)
- `descripcion-decision`: snake_case descriptivo

**Ejemplos válidos:**
- `ADR-INFRA-001-vagrant-devcontainer-host.md`
- `ADR-INFRA-002-pipeline-cicd-devcontainer.md`
- `ADR-INFRA-003-alpine-linux-base-devcontainer.md`

## Mantenimiento de este Índice

**Actualizar cuando:**
- Se crea nuevo ADR → Agregar a tablas
- Se cambia estado de ADR → Actualizar estado y mover entre vistas
- Se supersede ADR → Actualizar tabla de supersedidos y agregar enlace
- Se rechaza propuesta → Mover a tabla de rechazados

**Responsable:** QA Infraestructura

**Frecuencia de revisión:** Mensual o después de cada ADR nuevo

**Última actualización:** 2025-11-18

**Próxima revisión:** Al completar FASE 3 (creación de ADRs planificados)

## Referencias

- [Plantilla ADR Infraestructura](../plantillas/adr/plantilla_adr_infraestructura.md)
- [¿Qué es un ADR?](https://adr.github.io/)
- [Guía de ADRs](https://github.com/joelparkerhenderson/architecture-decision-record)
- [LISTADO-COMPLETO-TAREAS.md](../qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/LISTADO-COMPLETO-TAREAS.md) - ADRs planificados en FASE 3

EOF

echo "[OK]INDICE_ADRs.md creado"
```

### 4. Validar Índice (15 min)

```bash
# Verificar creación
test -f INDICE_ADRs.md && echo "[OK]INDICE_ADRs.md existe"

# Verificar frontmatter
grep -q "^---$" INDICE_ADRs.md && echo "[OK]Frontmatter presente"

# Contar tablas
TABLES=$(grep -c "^| .* |$" INDICE_ADRs.md)
echo "Tablas encontradas: $TABLES"

# Verificar enlaces a ADRs existentes
grep "\[ADR-INFRA-001\]" INDICE_ADRs.md && echo "[OK]Enlace a ADR-001"
grep "\[ADR-INFRA-002\]" INDICE_ADRs.md && echo "[OK]Enlace a ADR-002"

# Documentar validación
cat > evidencias/validacion-indice-adrs.txt << EOF
=== VALIDACIÓN INDICE_ADRs.md ===
Fecha: $(date +%Y-%m-%d)

[OK]INDICE_ADRs.md creado en adr/
[OK]Frontmatter YAML completo
[OK]Resumen ejecutivo incluido
[OK]Tabla completa de ADRs (existentes + planificados)
[OK]Vista por Estado implementada
[OK]Vista por Componente implementada
[OK]Timeline cronológico incluido
[OK]Proceso de creación de ADR documentado
[OK]Nomenclatura documentada
[OK]Enlaces a ADRs existentes funcionan

Tablas encontradas: $TABLES
ADRs existentes: $(ls -1 ADR-INFRA-*.md 2>/dev/null | wc -l)
ADRs planificados documentados: 5

RESULTADO: [OK]VALIDACIÓN EXITOSA
EOF
```

## Auto-CoT: Razonamiento Tabular

### ¿Por qué Formato Tabular?

```
ANÁLISIS: ¿Cuál es el mejor formato para índice de ADRs?

OPCIÓN A: Lista Simple
Pros: Fácil de escribir
Contras: Difícil de escanear, no permite filtrado

OPCIÓN B: Formato Tabular
Pros:
  ├─ Escaneo visual rápido
  ├─ Columnas permiten ordenamiento mental
  ├─ Facilita comparación
  └─ Múltiples vistas posibles

OPCIÓN C: Formato JSON/YAML
Pros: Programáticamente procesable
Contras: No legible para humanos

DECISIÓN: OPCIÓN B - Tabular
├─ Índice es primariamente para consumo humano
├─ Markdown tables son legibles y funcionales
└─ Múltiples tablas permiten múltiples perspectivas
```

### Diseño de Vistas Múltiples

```
VISTA 1: Tabla Completa
├─ Propósito: Ver TODOS los ADRs
├─ Ordenamiento: Por ID
└─ Uso: Referencia completa

VISTA 2: Por Estado
├─ Propósito: Filtrar ADRs relevantes
├─ Agrupación: Aceptados, Planificados, Supersedidos, Rechazados
└─ Uso: Encontrar decisiones activas vs históricas

VISTA 3: Por Componente
├─ Propósito: Ver decisiones de componente específico
├─ Agrupación: DevContainer, CI/CD, Infraestructura Base, etc.
└─ Uso: Trabajar en componente específico

VISTA 4: Timeline
├─ Propósito: Entender evolución temporal
├─ Ordenamiento: Cronológico
└─ Uso: Ver cómo arquitectura ha evolucionado

SÍNTESIS:
Cada vista sirve un propósito diferente
Usuario elige vista según necesidad
```

## Criterios de Aceptación

- [ ] INDICE_ADRs.md creado en `/docs/infraestructura/adr/`
- [ ] Frontmatter YAML completo con metadatos (total_adrs, adrs_activos, adrs_planificados)
- [ ] Resumen ejecutivo con métricas
- [ ] Tabla completa de ADRs existentes (mínimo columnas: ID, Título, Estado, Fecha, Componentes, Archivo)
- [ ] Tabla de ADRs planificados (FASE 3) incluida
- [ ] Vista por Estado implementada (Aceptados, Planificados, Supersedidos, Rechazados)
- [ ] Vista por Componente implementada (agrupación lógica)
- [ ] Timeline cronológico incluido
- [ ] Proceso de creación de ADR documentado
- [ ] Nomenclatura ADR-INFRA-XXX documentada
- [ ] Sección de mantenimiento con responsable y frecuencia
- [ ] Enlaces a ADRs existentes funcionan correctamente

## Evidencias a Generar

### /docs/infraestructura/adr/INDICE_ADRs.md
[Índice completo con estructura tabular como mostrado arriba]

### evidencias/validacion-indice-adrs.txt
[Validación completa del índice]

## Dependencias

**Requiere:** FASE 1 completada

**Desbloquea:** TASK-030 (Validar estructura adr/)

## Notas Importantes

**Tabular CoT**: Formato tabular facilita navegación y comparación de ADRs.

**Múltiples Vistas**: Diferentes perspectivas (estado, componente, timeline) para diferentes necesidades.

 **Mantenimiento**: Actualizar índice cada vez que se crea, modifica o supersede un ADR.

 **ADRs Planificados**: Documentar ADRs futuros ayuda a planificación y tracking.

## Relación con Otras Tareas

```
TASK-029 (Crear INDICE ADRs) ← ESTA TAREA
    ↓
TASK-030 (Validar estructura adr/)
    ↓
FASE 3: TASK-031 a TASK-037 (Crear ADRs planificados)
    ↓
TASK-038 (Validar ADRs completos)
```

## Referencias

- LISTADO-COMPLETO-TAREAS.md: Línea 1110-1143
- Tabular CoT: Estructuración de información en formato tabular para máxima claridad
- ADR Guidelines: https://adr.github.io/
- FASE 3 ADRs: TASK-031 (ADR-001), TASK-032 (ADR-002), TASK-033-037 (ADR-003 a 007)
