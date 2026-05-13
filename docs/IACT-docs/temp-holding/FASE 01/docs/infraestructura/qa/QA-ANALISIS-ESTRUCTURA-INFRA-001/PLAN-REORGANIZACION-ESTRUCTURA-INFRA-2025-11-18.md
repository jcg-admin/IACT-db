---
id: PLAN-REORG-INFRA-001
tipo: plan_ejecucion
categoria: documentacion_estructura
titulo: Plan Ejecutable de Reorganizacion Estructural docs/infraestructura
version: 1.0.0
fecha_creacion: 2025-11-18
estado: propuesta
responsable: equipo-infraestructura
prioridad: alta
relacionados:
  - QA-ANALISIS-ESTRUCTURA-INFRA-001
  - README-REORGANIZACION-ESTRUCTURA.md
  - docs/gobernanza/qa/QA-ANALISIS-RAMAS-001
  - docs/backend/qa/PLAN-REORGANIZACION-ESTRUCTURA-BACKEND-2025-11-18.md
tags:
  - reorganizacion
  - estructura
  - infraestructura
  - plan-ejecucion
  - qa
---

# PLAN-REORG-INFRA-001: Plan Ejecutable de Reorganizacion Estructural docs/infraestructura

**ID:** PLAN-REORG-INFRA-001
**Version:** 1.0.0
**Fecha:** 2025-11-18
**Categoria:** Documentacion / Infraestructura / Reorganizacion Estructural

---

## 1. RESUMEN EJECUTIVO

### 1.1 Proposito del Plan

Este plan ejecutable documenta las 65 tareas concretas para reorganizar completamente la estructura de `docs/infraestructura/`, alineandola con el modelo consolidado y probado de `docs/gobernanza/`.

### 1.2 Objetivos Principales

1. **Alineacion con Gobernanza**: Estructura identica a `docs/gobernanza/` para consistencia
2. **Environmental Consistency**: Documentar infraestructura de forma deterministica
3. **Operational Equivalence**: Procedimientos reproducibles y documentados
4. **Completitud Documental**: 100% carpetas con READMEs, 90%+ frontmatter YAML
5. **Trazabilidad Completa**: Matrices vinculando ADRs-requisitos-implementacion

### 1.3 Metricas de Transformacion

| Metrica | Baseline | Objetivo | Delta |
|---------|----------|----------|-------|
| Carpetas principales | 22 | 33+ | +11 |
| Archivos markdown | 95 | 180+ | +85 |
| READMEs completos | 70% | 100% | +30% |
| Frontmatter YAML | 15% | 90%+ | +75% |
| ADRs formales | 1 | 8+ | +7 |
| Procesos documentados | 0 | 5+ | +5 |
| Procedimientos | 0 | 6+ | +6 |
| Plantillas | 4 | 12+ | +8 |
| Puntuacion calidad | 60-65 | 85-90 | +25 |

### 1.4 Alcance Temporal

- **Preparacion**: 1 semana (5 tareas)
- **Reorganizacion Critica**: 2 semanas (25 tareas)
- **Contenido Nuevo**: 2 semanas (24 tareas)
- **Validacion y Limpieza**: 1 semana (11 tareas)
- **TOTAL**: 6 semanas (65 tareas)

### 1.5 Esfuerzo Estimado

- **Total persona-dias**: 28-38 dias
- **Recursos**: 1-2 agentes trabajando en paralelo
- **Buffer incluido**: 20% para imprevistos

---

## 2. ANALISIS DE SITUACION ACTUAL

### 2.1 Estructura Existente docs/infraestructura/

```
docs/infraestructura/
├── README.md (sin frontmatter)
├── INDEX.md (desactualizado)
├── adr/ (1 ADR, sin indice)
├── checklists/ (README vacio)
├── cpython_precompilado/ (7 archivos - bien documentado)
├── devops/ (README vacio)
├── diseno/ (5 archivos - sin organizacion interna)
├── plan/ (sin estructura formal)
├── procedimientos/ (README vacio - CRITICO)
├── qa/ (31 archivos - mejor documentado)
├── requisitos/ (18 archivos - bien estructurado)
├── specs/ (sin README)
└── 15 archivos en raiz sin categorizar
```

**Total carpetas actuales:** 22
**Total archivos markdown:** 95
**Archivos con frontmatter:** 14/95 (15%)

### 2.2 Problemas Criticos Identificados

#### P0 - CRITICOS (requieren accion inmediata)

1. **Duplicacion de contenido**
   - `index.md` y `spec_infra_001_cpython_precompilado.md` duplicados en raiz
   - Archivos: 2 identificados

2. **READMEs vacios o ausentes**
   - `procedimientos/README.md` - VACIO
   - `devops/README.md` - VACIO
   - `checklists/README.md` - VACIO
   - `solicitudes/README.md` - VACIO
   - `specs/` - SIN README
   - Carpetas afectadas: 5

3. **ADRs sin estructura**
   - Solo 1 ADR visible: `ADR-INFRA-001-vagrant-devcontainer-host.md`
   - Falta `INDICE_ADRs.md`
   - No hay proceso formal de ADRs

4. **Procesos y procedimientos ausentes**
   - 0 documentos PROC-INFRA-XXX.md
   - 0 documentos PROCED-INFRA-XXX.md
   - Operaciones sin documentar formalmente

#### P1 - ALTOS (importantes para calidad)

1. **Carpetas faltantes vs gobernanza**: 13 carpetas no existen
2. **Sin frontmatter YAML**: 81/95 archivos (85%)
3. **15 archivos raiz sin categorizar**: Necesitan ubicacion apropiada
4. **Canvas de arquitectura faltantes**: DevContainer Host, Pipeline CI/CD
5. **Matrices de trazabilidad incompletas**: RTM ADR-planes-requisitos

#### P2 - MEDIOS (mejoras continuas)

1. **Nomenclatura inconsistente**: Mezcla snake_case/kebab-case
2. **Enlaces no validados**: Sin script de validacion
3. **Plantillas incompletas**: Solo 4 de 12+ necesarias
4. **Catalogos faltantes**: Sin inventario de servicios/componentes

### 2.3 Estructura Objetivo (Basada en docs/gobernanza/)

```
docs/infraestructura/
├── README.md
├── INDEX.md
├── CHANGELOG.md (nuevo)
├── ROADMAP.md (nuevo)
├── adr/ (8+ ADRs formales)
├── catalogos/ (NUEVO - 4+ catalogos)
├── checklists/ (mejorado)
├── ci_cd/ (NUEVO - pipelines CI/CD)
├── diseno/
│   ├── arquitectura/ (consolidado)
│   ├── detallado/
│   └── database/
├── ejemplos/ (NUEVO)
├── estilos/ (NUEVO - guias IaC)
├── glosarios/ (NUEVO)
├── gobernanza/ (NUEVO - marco infra)
├── guias/ (NUEVO - operacionales)
├── metodologias/ (NUEVO - IaC, GitOps)
├── planificacion/ (consolidado)
├── plans/ (NUEVO)
├── plantillas/ (12+ plantillas)
├── procedimientos/ (6+ PROCED-INFRA-XXX)
├── procesos/ (NUEVO - 5+ PROC-INFRA-XXX)
├── qa/ (mejorado)
├── referencias/ (NUEVO)
├── requisitos/ (mejorado)
├── seguridad/ (NUEVO - CRITICO)
├── sesiones/ (mejorado)
├── solicitudes/ (mejorado)
├── templates/ (NUEVO)
├── testing/ (NUEVO)
├── trazabilidad/ (NUEVO - matrices RTM)
└── vision_y_alcance/ (NUEVO - vision estrategica)
```

**Total carpetas objetivo:** 33+
**Carpetas nuevas a crear:** 13
**Carpetas a consolidar:** 6

---

## 3. FASES DE EJECUCION

### FASE 1: PREPARACION Y FUNDAMENTOS

**Duracion:** 1 semana
**Tareas:** 5
**Esfuerzo:** 5-7 persona-dias
**Objetivo:** Preparar entorno sin modificar archivos existentes

#### TASK-001: Crear backup completo de docs/infraestructura/

**ID:** TASK-INFRA-REORG-001
**Prioridad:** P0
**Duracion:** 4 horas
**Prerequisitos:** Ninguno
**Tecnica de Prompting:** Execution Pattern

**Descripcion:**
Crear punto de restauracion completo antes de iniciar reorganizacion.

**Comandos:**
```bash
# Crear tag de backup
git tag -a QA-INFRA-REORG-BACKUP-2025-11-18 \
  -m "Backup completo pre-reorganizacion docs/infraestructura/"

# Verificar tag creado
git tag -l "QA-INFRA-REORG-*"

# Push tag al remoto (opcional, pero recomendado)
git push origin QA-INFRA-REORG-BACKUP-2025-11-18
```

**Criterios de Aceptacion:**
- [ ] Tag Git creado exitosamente
- [ ] Tag visible en `git tag -l`
- [ ] Tag pusheado a remoto (si aplica)
- [ ] Documentado en CHANGELOG.md del plan

**Evidencias:**
Capturar en `evidencias/TASK-001-backup.md`:
- Output de `git tag -l`
- Hash del commit respaldado
- Fecha y hora del backup

---

#### TASK-002: Crear estructura de carpetas nuevas (13 carpetas)

**ID:** TASK-INFRA-REORG-002
**Prioridad:** P0
**Duracion:** 8 horas
**Prerequisitos:** TASK-001
**Tecnica de Prompting:** Template-based Generation

**Descripcion:**
Crear las 13 carpetas faltantes con READMEs basicos usando plantilla estandar.

**Carpetas a crear:**
1. `catalogos/`
2. `ci_cd/`
3. `ejemplos/`
4. `estilos/`
5. `glosarios/`
6. `gobernanza/`
7. `guias/`
8. `metodologias/`
9. `planificacion/`
10. `plans/`
11. `seguridad/`
12. `testing/`
13. `vision_y_alcance/`

**Comandos:**
```bash
cd /home/user/IACT/docs/infraestructura/

# Crear todas las carpetas
mkdir -p {catalogos,ci_cd,ejemplos,estilos,glosarios,gobernanza,guias,metodologias,planificacion,plans,seguridad,testing,vision_y_alcance}

# Verificar creacion
ls -ld {catalogos,ci_cd,ejemplos,estilos,glosarios,gobernanza,guias,metodologias,planificacion,plans,seguridad,testing,vision_y_alcance}
```

**Template README.md a usar:**
```markdown
---
id: README-INFRA-[CARPETA]
tipo: readme
categoria: infraestructura
version: 1.0.0
fecha_creacion: 2025-11-18
estado: activo
---

# [Nombre de Carpeta]

## Proposito

[Descripcion breve del proposito de esta carpeta]

## Contenido

[Descripcion del tipo de contenido esperado]

## Convenciones

- Nomenclatura: [patron de nombres]
- Metadatos: Frontmatter YAML obligatorio
- Referencias: Enlaces a documentos relacionados

## Referencias

- docs/gobernanza/[carpeta-equivalente]/
```

**Criterios de Aceptacion:**
- [ ] 13 carpetas creadas en `/home/user/IACT/docs/infraestructura/`
- [ ] Cada carpeta tiene README.md con frontmatter YAML
- [ ] READMEs describen proposito y contenido esperado
- [ ] Estructura verificada con `tree -L 1`

**Evidencias:**
- Output de `tree -L 1 docs/infraestructura/`
- Screenshots de READMEs creados

---

#### TASK-003: Crear matriz de mapeo de migracion

**ID:** TASK-INFRA-REORG-003
**Prioridad:** P0
**Duracion:** 4 horas
**Prerequisitos:** TASK-002
**Tecnica de Prompting:** Tabular CoT (Chain of Thought)

**Descripcion:**
Documentar mapeo completo archivo-origen → archivo-destino para trazabilidad.

**Archivo a crear:** `MAPEO-MIGRACION-DOCS-INFRA.md`

**Estructura del mapeo:**
```markdown
# Matriz de Mapeo de Migracion - docs/infraestructura/

| Ubicacion Actual | Ubicacion Nueva | Accion | Prioridad | Fase |
|------------------|-----------------|--------|-----------|------|
| /index.md | /diseno/cpython_precompilado/index.md | Mover | P0 | 2 |
| /spec_infra_001*.md | /specs/spec_infra_001*.md | Mover | P0 | 2 |
| /diseno/*.md | /diseno/arquitectura/*.md | Consolidar | P1 | 2 |
| ... | ... | ... | ... | ... |
```

**Secciones del documento:**
1. Archivos a mover (raiz → carpetas)
2. Archivos a consolidar (fusionar carpetas)
3. Archivos a duplicar como plantillas
4. Archivos a eliminar (duplicados)
5. Enlaces a actualizar

**Criterios de Aceptacion:**
- [ ] Matriz completa de todos los 95 archivos actuales
- [ ] Cada archivo mapeado a ubicacion final
- [ ] Prioridades asignadas (P0/P1/P2)
- [ ] Fases de ejecucion especificadas
- [ ] Validado contra estructura objetivo

**Evidencias:**
- Documento `MAPEO-MIGRACION-DOCS-INFRA.md` completo
- Tabla con 95+ filas documentadas

---

#### TASK-004: Configurar herramientas de validacion

**ID:** TASK-INFRA-REORG-004
**Prioridad:** P1
**Duracion:** 4 horas
**Prerequisitos:** TASK-002
**Tecnica de Prompting:** Tool-use Pattern

**Descripcion:**
Preparar scripts de validacion automatizada para enlaces, frontmatter y nomenclatura.

**Scripts a crear/configurar:**

1. **validate_links_infra.sh**
```bash
#!/bin/bash
# Validar enlaces en docs/infraestructura/

find docs/infraestructura -name "*.md" -exec grep -H '\[.*\](.*\.md)' {} \; | \
while IFS=: read -r file link; do
  # Extraer ruta del enlace
  # Validar si archivo existe
  # Reportar enlaces rotos
done
```

2. **validate_frontmatter_infra.py**
```python
#!/usr/bin/env python3
# Validar frontmatter YAML en docs criticos

import yaml
import glob

REQUIRED_FIELDS = ['id', 'tipo', 'version', 'fecha_creacion']

for md_file in glob.glob('docs/infraestructura/**/*.md', recursive=True):
    # Parsear frontmatter
    # Validar campos requeridos
    # Reportar documentos sin frontmatter
```

3. **validate_naming_infra.sh**
```bash
#!/bin/bash
# Validar nomenclatura consistente

# ADRs: ADR-INFRA-###-titulo.md
# Procesos: PROC-INFRA-###-titulo.md
# Procedimientos: PROCED-INFRA-###-titulo.md
```

**Criterios de Aceptacion:**
- [ ] 3 scripts creados en `docs/infraestructura/qa/scripts/`
- [ ] Scripts ejecutables (`chmod +x`)
- [ ] Scripts probados en subset de archivos
- [ ] Documentacion de uso en README de scripts

**Evidencias:**
- Scripts creados con permisos de ejecucion
- Output de ejecucion de prueba

---

#### TASK-005: Comunicar inicio de reorganizacion

**ID:** TASK-INFRA-REORG-005
**Prioridad:** P1
**Duracion:** 2 horas
**Prerequisitos:** TASK-001, TASK-002
**Tecnica de Prompting:** Communication Pattern

**Descripcion:**
Notificar a stakeholders inicio de reorganizacion, timeline y puntos de contacto.

**Acciones:**
1. Crear anuncio en `docs/infraestructura/ANUNCIO-REORGANIZACION.md`
2. Actualizar README.md principal con banner de reorganizacion
3. Documentar canal de comunicacion para dudas

**Template de anuncio:**
```markdown
# ANUNCIO: Reorganizacion de docs/infraestructura/ en Progreso

**Fecha inicio:** 2025-11-18
**Duracion estimada:** 6 semanas
**Impacto:** Cambios en ubicacion de documentos

## Que esta cambiando

- Estructura de carpetas alineada con docs/gobernanza/
- 13 carpetas nuevas creadas
- Archivos reorganizados segun dominio

## Timeline

- Semana 1: Preparacion
- Semanas 2-3: Reorganizacion critica
- Semanas 4-5: Contenido nuevo
- Semana 6: Validacion

## Que hacer

- Consultar MAPEO-MIGRACION-DOCS-INFRA.md para ubicaciones nuevas
- Reportar enlaces rotos en [canal/issue]
- Evitar crear nuevos documentos durante reorganizacion

## Contacto

- Responsable: Equipo Infraestructura
- Dudas: [canal de Slack / issue tracker]
```

**Criterios de Aceptacion:**
- [ ] Anuncio creado y commiteado
- [ ] README.md actualizado con banner
- [ ] Stakeholders notificados (si aplica)

---

### RESUMEN FASE 1

| Tarea | Duracion | Estado |
|-------|----------|--------|
| TASK-001: Backup completo | 4h | Pendiente |
| TASK-002: Crear carpetas nuevas | 8h | Pendiente |
| TASK-003: Matriz de mapeo | 4h | Pendiente |
| TASK-004: Scripts validacion | 4h | Pendiente |
| TASK-005: Comunicacion | 2h | Pendiente |
| **TOTAL FASE 1** | **22h** | **0/5** |

---

## FASE 2: REORGANIZACION CRITICA

**Duracion:** 2 semanas
**Tareas:** 25
**Esfuerzo:** 10-14 persona-dias
**Objetivo:** Mover archivos criticos, consolidar carpetas, eliminar duplicados

### 2.1 CONSOLIDACION DE diseno/

#### TASK-006: Crear subcarpetas en diseno/

**ID:** TASK-INFRA-REORG-006
**Prioridad:** P0
**Duracion:** 2 horas
**Prerequisitos:** TASK-002
**Tecnica de Prompting:** Hierarchical Organization

**Descripcion:**
Crear estructura jerarquica dentro de diseno/ para organizar arquitectura, detallado, database.

**Comandos:**
```bash
cd /home/user/IACT/docs/infraestructura/diseno/

mkdir -p {arquitectura,detallado,database}

# Crear READMEs en cada subcarpeta
for dir in arquitectura detallado database; do
  cat > $dir/README.md <<EOF
---
id: README-INFRA-DISENO-${dir^^}
tipo: readme
categoria: diseno
version: 1.0.0
fecha_creacion: 2025-11-18
---

# Diseno: ${dir^}

## Proposito
Documentos de diseno de ${dir} de infraestructura.

## Contenido
- Diagramas de arquitectura
- Especificaciones tecnicas
- Decisiones de diseno

## Convenciones
- Usar PlantUML para diagramas
- Frontmatter YAML obligatorio
EOF
done
```

**Criterios de Aceptacion:**
- [ ] 3 subcarpetas creadas en `diseno/`
- [ ] Cada subcarpeta tiene README.md
- [ ] Estructura visible con `tree diseno/`

---

#### TASK-007: Mover archivos de diseno/ a arquitectura/

**ID:** TASK-INFRA-REORG-007
**Prioridad:** P0
**Duracion:** 3 horas
**Prerequisitos:** TASK-006
**Tecnica de Prompting:** File Organization

**Descripcion:**
Mover archivos de diseno arquitectonico general a diseno/arquitectura/.

**Archivos a mover:**
- `arquitectura-infraestructura-vm.md`
- `diseno-arquitectonico-*.md`
- Diagramas de alto nivel

**Comandos:**
```bash
cd /home/user/IACT/docs/infraestructura/diseno/

# Mover archivos arquitectonicos
mv arquitectura-infraestructura-vm.md arquitectura/
mv diseno-arquitectonico-*.md arquitectura/

# Actualizar enlaces internos (manual o script)
```

**Post-movimiento:**
- Actualizar enlaces en README.md de diseno/
- Verificar que archivos movidos mantienen contenido intacto

**Criterios de Aceptacion:**
- [ ] Todos los archivos arquitectonicos en `diseno/arquitectura/`
- [ ] Enlaces internos actualizados
- [ ] README de arquitectura/ lista archivos movidos

---

#### TASK-008: Crear canvas de arquitectura DevContainer Host

**ID:** TASK-INFRA-REORG-008
**Prioridad:** P1
**Duracion:** 6 horas
**Prerequisitos:** TASK-007
**Tecnica de Prompting:** Canvas Generation + PlantUML

**Descripcion:**
Crear canvas completo de arquitectura del DevContainer Host con Vagrant.

**Archivo a crear:** `diseno/arquitectura/canvas-devcontainer-host-vagrant.md`

**Estructura del canvas:**
```markdown
---
id: CANVAS-INFRA-001
tipo: canvas_arquitectura
categoria: diseno
titulo: Canvas Arquitectura DevContainer Host con Vagrant
version: 1.0.0
fecha_creacion: 2025-11-18
estado: activo
relacionados: ["ADR-INFRA-001", "requisitos/REQ-INFRA-VM-001"]
---

# Canvas: DevContainer Host con Vagrant

## 1. CONTEXTO

### 1.1 Problema
[Descripcion del problema que resuelve]

### 1.2 Stakeholders
- Desarrolladores
- DevOps
- QA Engineers

## 2. SOLUCION ARQUITECTONICA

### 2.1 Componentes Principales
- Vagrant Box (ubuntu/jammy64)
- VirtualBox Provider
- DevContainer CLI
- Podman / Docker Engine

### 2.2 Diagrama de Arquitectura

\`\`\`plantuml
@startuml
!include <C4/C4_Container>

Person(dev, "Desarrollador")
System_Boundary(host, "Host Machine") {
  Container(vagrant, "Vagrant", "VM Orchestrator")
  Container(vbox, "VirtualBox", "Hypervisor")
}

System_Boundary(vm, "Ubuntu VM") {
  Container(devcontainer, "DevContainer CLI", "Container Manager")
  Container(podman, "Podman", "Container Runtime")
  ContainerDb(data, "Shared Data", "9p/NFS")
}

Rel(dev, vagrant, "vagrant up")
Rel(vagrant, vbox, "creates VM")
Rel(vbox, devcontainer, "runs inside")
Rel(devcontainer, podman, "orchestrates")
@enduml
\`\`\`

## 3. DECISIONES CLAVE

### 3.1 Vagrant como Orquestador
- **Decision:** Usar Vagrant para provision de VM
- **Rationale:** Reproducibilidad, portabilidad, infraestructura como codigo
- **Alternativas:** Docker Desktop, Multipass, Manual setup
- **Referencia:** ADR-INFRA-001

### 3.2 Podman vs Docker
- **Decision:** Soportar ambos, preferir Podman
- **Rationale:** Rootless, daemonless, compatible OCI
- **Alternativas:** Solo Docker
- **Referencia:** ADR-INFRA-003

## 4. FLUJOS OPERACIONALES

### 4.1 Provision Inicial
1. Desarrollador: `vagrant up`
2. Vagrant: Descarga box, crea VM
3. Vagrant: Ejecuta scripts de provision
4. VM: Instala DevContainer CLI, Podman
5. VM: Configura networking, storage

### 4.2 Desarrollo Diario
1. Desarrollador: `vagrant ssh`
2. Desarrollador: `devcontainer up`
3. DevContainer: Crea containers basados en .devcontainer.json
4. Desarrollador: Trabaja dentro del container

## 5. COMPONENTES TECNICOS

| Componente | Version | Proposito |
|------------|---------|-----------|
| Vagrant | 2.4.0+ | VM orchestration |
| VirtualBox | 7.0+ | Hypervisor |
| Ubuntu Jammy | 22.04 LTS | Guest OS |
| DevContainer CLI | latest | Container dev env |
| Podman | 4.0+ | Container runtime |

## 6. REQUISITOS NO FUNCIONALES

### 6.1 Performance
- VM startup: < 5 minutos
- Container build: < 10 minutos (cached)
- File I/O: Aceptable con shared folders

### 6.2 Seguridad
- Rootless containers (Podman)
- Network isolation por defecto
- Secrets management via .env files

### 6.3 Mantenibilidad
- Provision idempotente
- Scripts reproducibles
- Documentacion completa

## 7. TRAZABILIDAD

### 7.1 Requisitos Cubiertos
- REQ-INFRA-VM-001: Entorno reproducible
- REQ-INFRA-VM-002: Portabilidad entre hosts
- REQ-INFRA-VM-003: Aislamiento de desarrollo

### 7.2 ADRs Relacionados
- ADR-INFRA-001: Vagrant como DevContainer Host
- ADR-INFRA-003: Podman vs Docker

## 8. REFERENCIAS

- infrastructure/vagrant/Vagrantfile
- infrastructure/provision/install_devcontainer.sh
- docs/infraestructura/requisitos/
```

**Criterios de Aceptacion:**
- [ ] Canvas completo con 8 secciones
- [ ] Diagrama PlantUML incluido
- [ ] Trazabilidad a requisitos y ADRs
- [ ] Frontmatter YAML completo
- [ ] Validado contra estructura de canvas de gobernanza

---

#### TASK-009: Crear canvas de arquitectura Pipeline CI/CD

**ID:** TASK-INFRA-REORG-009
**Prioridad:** P1
**Duracion:** 6 horas
**Prerequisitos:** TASK-008
**Tecnica de Prompting:** Canvas Generation

**Descripcion:**
Crear canvas de arquitectura del pipeline CI/CD sobre DevContainer Host.

**Archivo a crear:** `diseno/arquitectura/canvas-pipeline-cicd-devcontainer.md`

**Componentes a documentar:**
- GitHub Actions workflows
- DevContainer como entorno de CI
- Test execution pipeline
- Deployment pipeline
- Artifact management

**Criterios de Aceptacion:**
- [ ] Canvas completo paralelo a TASK-008
- [ ] Diagrama de pipeline CI/CD
- [ ] Integracion con DevContainer documentada
- [ ] Trazabilidad a ADR-INFRA-002

---

#### TASK-010: Consolidar archivos de diseno/detallado/

**ID:** TASK-INFRA-REORG-010
**Prioridad:** P1
**Duracion:** 2 horas
**Prerequisitos:** TASK-006
**Tecnica de Prompting:** File Consolidation

**Descripcion:**
Mover archivos de diseno detallado/low-level a diseno/detallado/.

**Archivos a identificar:**
- Documentos de diseno tecnico especifico
- Especificaciones de componentes
- Diagramas de secuencia detallados

**Comandos:**
```bash
cd /home/user/IACT/docs/infraestructura/diseno/

# Identificar archivos de diseno detallado
grep -l "diseno detallado\|low-level\|implementacion" *.md

# Mover a subcarpeta
mv [archivos-identificados] detallado/
```

**Criterios de Aceptacion:**
- [ ] Archivos de diseno detallado consolidados
- [ ] README de detallado/ actualizado
- [ ] Enlaces internos validados

---

#### TASK-011: Crear diseno/database/ para database design

**ID:** TASK-INFRA-REORG-011
**Prioridad:** P1
**Duracion:** 3 horas
**Prerequisitos:** TASK-006
**Tecnica de Prompting:** Domain Organization

**Descripcion:**
Organizar documentos de diseno de bases de datos (MariaDB/PostgreSQL).

**Archivos a mover/crear:**
- Esquemas de BD (si existen)
- Estrategias de migracion
- Decisiones de dual-database

**Estructura de database/:
```
diseno/database/
├── README.md
├── database-schema-mariadb.md
├── database-schema-postgresql.md
├── migrations-strategy.md
└── ADR-dual-database-rationale.md (referencia)
```

**Criterios de Aceptacion:**
- [ ] Subcarpeta database/ creada
- [ ] Documentos de BD organizados
- [ ] Referencias a ADR-INFRA-007

---

### 2.2 CONSOLIDACION DE planificacion/

#### TASK-012: Crear subcarpetas en planificacion/

**ID:** TASK-INFRA-REORG-012
**Prioridad:** P1
**Duracion:** 2 horas
**Prerequisitos:** TASK-002
**Tecnica de Prompting:** Hierarchical Organization

**Descripcion:**
Organizar planificacion/ con subcarpetas para diferentes tipos de planificacion.

**Subcarpetas a crear:**
```bash
mkdir -p planificacion/{roadmap,releases,sprints}
```

**Contenido esperado:**
- `roadmap/`: Planificacion estrategica de infraestructura
- `releases/`: Planificacion de releases
- `sprints/`: Planificacion iterativa (si aplica)

**Criterios de Aceptacion:**
- [ ] 3 subcarpetas creadas
- [ ] READMEs en cada subcarpeta

---

#### TASK-013: Consolidar archivos de plan/ a planificacion/

**ID:** TASK-INFRA-REORG-013
**Prioridad:** P1
**Duracion:** 3 horas
**Prerequisitos:** TASK-012
**Tecnica de Prompting:** File Migration

**Descripcion:**
Mover archivos de plan/ a planificacion/ con organizacion apropiada.

**Comandos:**
```bash
cd /home/user/IACT/docs/infraestructura/

# Revisar contenido de plan/
ls -la plan/

# Mover archivos segun tipo
mv plan/*roadmap* planificacion/roadmap/
mv plan/*release* planificacion/releases/
mv plan/*.md planificacion/ # archivos genericos
```

**Criterios de Aceptacion:**
- [ ] Todos los archivos de plan/ movidos
- [ ] Carpeta plan/ vacia (lista para eliminar)
- [ ] Enlaces actualizados

---

### 2.3 REORGANIZACION DE sesiones/

#### TASK-014: Crear estructura de sesiones/

**ID:** TASK-INFRA-REORG-014
**Prioridad:** P2
**Duracion:** 2 horas
**Prerequisitos:** TASK-002
**Tecnica de Prompting:** Temporal Organization

**Descripcion:**
Organizar sesiones de trabajo con estructura consistente.

**Estructura propuesta:**
```
sesiones/
├── README.md
├── 2025/
│   └── 11/
│       ├── SESION-2025-11-18/
│       └── SESION-2025-11-XX/
├── templates/
│   └── plantilla-sesion.md
└── INDICE-SESIONES.md
```

**Criterios de Aceptacion:**
- [ ] Estructura jerarquica por fecha
- [ ] Plantilla de sesion creada
- [ ] Indice de sesiones actualizable

---

#### TASK-015: Reorganizar sesiones existentes

**ID:** TASK-INFRA-REORG-015
**Prioridad:** P2
**Duracion:** 3 horas
**Prerequisitos:** TASK-014
**Tecnica de Prompting:** Archive Organization

**Descripcion:**
Mover sesiones existentes a estructura jerarquica.

**Criterios de Aceptacion:**
- [ ] Sesiones organizadas por fecha
- [ ] Nomenclatura SESION-YYYY-MM-DD consistente

---

### 2.4 MOVIMIENTO DE ARCHIVOS RAIZ

#### TASK-016: Identificar y categorizar 15 archivos raiz

**ID:** TASK-INFRA-REORG-016
**Prioridad:** P0
**Duracion:** 2 horas
**Prerequisitos:** TASK-003
**Tecnica de Prompting:** Classification

**Descripcion:**
Categorizar los 15 archivos en raiz segun su contenido y destino apropiado.

**Proceso:**
1. Listar archivos en raiz: `ls *.md`
2. Leer cada archivo para determinar categoria
3. Asignar carpeta destino
4. Documentar en matriz de mapeo

**Categorias posibles:**
- Diseno → diseno/
- Requisitos → requisitos/
- Procedimientos → procedimientos/
- Especificaciones → specs/
- Otros → [determinar]

**Criterios de Aceptacion:**
- [ ] 15 archivos categorizados
- [ ] Destinos asignados en matriz de mapeo
- [ ] Rationale documentado para cada movimiento

---

#### TASK-017 a TASK-020: Mover archivos raiz (4 tareas)

**Descripcion:** Ejecutar movimientos de archivos raiz a carpetas apropiadas segun categorizacion de TASK-016.

**TASK-017:** Mover archivos de diseno (3-4 archivos)
**TASK-018:** Mover archivos de requisitos (2-3 archivos)
**TASK-019:** Mover archivos de specs (2-3 archivos)
**TASK-020:** Mover archivos varios (resto)

**Criterios comunes:**
- [ ] Archivos movidos con `git mv`
- [ ] Enlaces internos actualizados
- [ ] README de carpeta destino actualizado

---

### 2.5 ELIMINACION DE DUPLICADOS

#### TASK-021: Eliminar duplicado index.md

**ID:** TASK-INFRA-REORG-021
**Prioridad:** P0
**Duracion:** 1 hora
**Prerequisitos:** TASK-017
**Tecnica de Prompting:** Deduplication

**Descripcion:**
Eliminar archivo duplicado index.md de raiz (si contenido esta en otro lugar).

**Proceso:**
1. Comparar `/index.md` con `/cpython_precompilado/index.md`
2. Verificar que contenido esta duplicado
3. Si duplicado, eliminar de raiz
4. Si contenido unico, mover a ubicacion apropiada

**Comandos:**
```bash
# Comparar archivos
diff index.md cpython_precompilado/index.md

# Si duplicado exacto:
git rm index.md
git commit -m "Remove duplicate index.md (content preserved in cpython_precompilado/)"
```

**Criterios de Aceptacion:**
- [ ] Duplicacion confirmada
- [ ] Archivo eliminado con `git rm`
- [ ] Contenido preservado en ubicacion correcta

---

#### TASK-022: Eliminar duplicado spec_infra_001_cpython_precompilado.md

**ID:** TASK-INFRA-REORG-022
**Prioridad:** P0
**Duracion:** 1 hora
**Prerequisitos:** TASK-019
**Tecnica de Prompting:** Deduplication

**Descripcion:**
Eliminar archivo duplicado de especificacion CPython precompilado.

**Proceso similar a TASK-021:**
- Comparar archivos
- Verificar duplicacion
- Eliminar si duplicado exacto
- Preservar contenido en ubicacion correcta

**Criterios de Aceptacion:**
- [ ] Duplicado eliminado
- [ ] Contenido preservado en specs/

---

### 2.6 COMPLETAR READMEs VACIOS

#### TASK-023: Completar README de procedimientos/

**ID:** TASK-INFRA-REORG-023
**Prioridad:** P0
**Duracion:** 2 horas
**Prerequisitos:** TASK-002
**Tecnica de Prompting:** Template-based Generation

**Descripcion:**
Completar README vacio de procedimientos/ con contenido estructurado.

**Estructura del README:**
```markdown
---
id: README-INFRA-PROCEDIMIENTOS
tipo: readme
categoria: procedimientos
version: 1.0.0
fecha_creacion: 2025-11-18
---

# Procedimientos de Infraestructura

## Proposito

Procedimientos operacionales step-by-step para tareas de infraestructura.

## Contenido

### Procedimientos Documentados

- PROCED-INFRA-001: Provision de VM Vagrant
- PROCED-INFRA-002: Configurar DevContainer Host
- PROCED-INFRA-003: Ejecutar Pipeline CI/CD
- PROCED-INFRA-004: Backup y Restauracion de VM
- PROCED-INFRA-005: Troubleshooting DevContainer
- PROCED-INFRA-006: Actualizar Toolchain CPython

## Convenciones

### Nomenclatura
PROCED-INFRA-###-titulo-snake-case.md

### Estructura de Procedimiento
1. Objetivo
2. Prerequisitos
3. Pasos (numerados, deterministicos)
4. Validacion
5. Rollback (si aplica)
6. Troubleshooting

### Metadatos Requeridos
- id: PROCED-INFRA-###
- tipo: procedimiento
- categoria: [provision|configuracion|deployment|troubleshooting]
- version: X.Y.Z
- estado: [activo|obsoleto]

## Plantillas

Ver: `/plantillas/plantilla-procedimiento-infra.md`

## Referencias

- docs/gobernanza/procedimientos/ (modelo)
- PROC-GOB-007: Procedimiento de consolidacion
```

**Criterios de Aceptacion:**
- [ ] README completo con frontmatter
- [ ] Lista de procedimientos a crear
- [ ] Convenciones documentadas
- [ ] Referencias a plantillas

---

#### TASK-024 a TASK-026: Completar READMEs vacios (3 tareas)

**TASK-024:** Completar README de devops/
**TASK-025:** Completar README de checklists/
**TASK-026:** Completar README de solicitudes/

**Criterios comunes:**
- [ ] README con frontmatter YAML
- [ ] Descripcion de proposito
- [ ] Convenciones documentadas
- [ ] Referencias a plantillas

---

### 2.7 ACTUALIZACION DE ENLACES

#### TASK-027: Ejecutar validacion de enlaces

**ID:** TASK-INFRA-REORG-027
**Prioridad:** P1
**Duracion:** 2 horas
**Prerequisitos:** TASK-004, TASK-017 a TASK-022
**Tecnica de Prompting:** Automated Validation

**Descripcion:**
Ejecutar script de validacion de enlaces para identificar todos los enlaces rotos.

**Comandos:**
```bash
cd /home/user/IACT/docs/infraestructura/

# Ejecutar script de validacion
./qa/scripts/validate_links_infra.sh > enlaces_rotos_reporte.txt

# Revisar reporte
cat enlaces_rotos_reporte.txt
```

**Criterios de Aceptacion:**
- [ ] Script ejecutado exitosamente
- [ ] Reporte de enlaces rotos generado
- [ ] Priorizado por severidad (critico/alto/medio)

---

#### TASK-028: Corregir enlaces rotos (batch 1 - criticos)

**ID:** TASK-INFRA-REORG-028
**Prioridad:** P0
**Duracion:** 4 horas
**Prerequisitos:** TASK-027
**Tecnica de Prompting:** Systematic Fix

**Descripcion:**
Corregir enlaces rotos criticos identificados en TASK-027.

**Proceso:**
1. Filtrar enlaces criticos del reporte
2. Para cada enlace:
   - Identificar ubicacion nueva del archivo referenciado
   - Actualizar enlace en archivo fuente
   - Validar enlace corregido
3. Re-ejecutar validacion

**Criterios de Aceptacion:**
- [ ] 100% enlaces criticos corregidos
- [ ] Validacion confirma enlaces funcionando
- [ ] Commits atomicos por conjunto de fixes

---

#### TASK-029: Corregir enlaces rotos (batch 2 - resto)

**ID:** TASK-INFRA-REORG-029
**Prioridad:** P1
**Duracion:** 4 horas
**Prerequisitos:** TASK-028
**Tecnica de Prompting:** Systematic Fix

**Descripcion:**
Corregir enlaces rotos no-criticos restantes.

**Criterios de Aceptacion:**
- [ ] 95%+ enlaces totales funcionando
- [ ] Enlaces externos documentados si no corregibles

---

#### TASK-030: Actualizar INDEX.md principal

**ID:** TASK-INFRA-REORG-030
**Prioridad:** P1
**Duracion:** 3 horas
**Prerequisitos:** TASK-017 a TASK-029
**Tecnica de Prompting:** Index Generation

**Descripcion:**
Actualizar INDEX.md para reflejar estructura reorganizada.

**Contenido del INDEX.md:**
```markdown
# Indice de Documentacion - docs/infraestructura/

## Estructura de Carpetas

### Core Documentation
- [adr/](adr/README.md) - Architecture Decision Records
- [catalogos/](catalogos/README.md) - Catalogos de componentes
- [diseno/](diseno/README.md) - Diseño arquitectonico
- [procedimientos/](procedimientos/README.md) - Procedimientos operacionales
- [procesos/](procesos/README.md) - Procesos high-level
- [requisitos/](requisitos/README.md) - Requisitos de infraestructura

### Supporting Documentation
- [checklists/](checklists/README.md)
- [ci_cd/](ci_cd/README.md)
- [ejemplos/](ejemplos/README.md)
- [guias/](guias/README.md)
- [plantillas/](plantillas/README.md)
- [qa/](qa/README.md)
- [seguridad/](seguridad/README.md)
- [testing/](testing/README.md)

### Governance
- [gobernanza/](gobernanza/README.md)
- [trazabilidad/](trazabilidad/README.md)
- [vision_y_alcance/](vision_y_alcance/README.md)

## Documentos Clave

### ADRs
- [ADR-INFRA-001: Vagrant como DevContainer Host](adr/ADR-INFRA-001-vagrant-devcontainer-host.md)
- [ADR-INFRA-002: Pipeline CI/CD sobre DevContainer](adr/ADR-INFRA-002-pipeline-cicd-devcontainer.md)
- ...

### Canvas de Arquitectura
- [Canvas: DevContainer Host](diseno/arquitectura/canvas-devcontainer-host-vagrant.md)
- [Canvas: Pipeline CI/CD](diseno/arquitectura/canvas-pipeline-cicd-devcontainer.md)

### Procedimientos
- [PROCED-INFRA-001: Provision VM Vagrant](procedimientos/PROCED-INFRA-001-provision-vm-vagrant.md)
- ...

## Navegacion Rapida

- [Vision y Roadmap](vision_y_alcance/)
- [Requisitos](requisitos/)
- [Diseño](diseno/)
- [Procesos](procesos/)
- [Procedimientos](procedimientos/)
- [Testing](testing/)
- [QA](qa/)
```

**Criterios de Aceptacion:**
- [ ] INDEX.md refleja estructura actual
- [ ] Enlaces a todas las carpetas principales
- [ ] Documentos clave listados
- [ ] Navegacion rapida incluida

---

### RESUMEN FASE 2

| Subcategoria | Tareas | Duracion |
|--------------|--------|----------|
| Consolidacion diseno/ | TASK-006 a TASK-011 | 24h |
| Consolidacion planificacion/ | TASK-012 a TASK-013 | 5h |
| Reorganizacion sesiones/ | TASK-014 a TASK-015 | 5h |
| Movimiento archivos raiz | TASK-016 a TASK-020 | 10h |
| Eliminacion duplicados | TASK-021 a TASK-022 | 2h |
| Completar READMEs | TASK-023 a TASK-026 | 8h |
| Actualizacion enlaces | TASK-027 a TASK-030 | 13h |
| **TOTAL FASE 2** | **25 tareas** | **67h** |

---

## FASE 3: CONTENIDO NUEVO

**Duracion:** 2 semanas
**Tareas:** 24
**Esfuerzo:** 10-14 persona-dias
**Objetivo:** Crear contenido en carpetas nuevas (ADRs, procesos, procedimientos, plantillas, catalogos)

### 3.1 CREACION DE ADRs FORMALES

#### TASK-031: Crear INDICE_ADRs.md

**ID:** TASK-INFRA-REORG-031
**Prioridad:** P0
**Duracion:** 2 horas
**Prerequisitos:** TASK-002
**Tecnica de Prompting:** Index Generation

**Descripcion:**
Crear indice de ADRs con estado y referencias.

**Estructura:**
```markdown
---
id: INDICE-ADRs-INFRA
tipo: indice
categoria: adr
version: 1.0.0
fecha_actualizacion: 2025-11-18
---

# Indice de Architecture Decision Records - Infraestructura

## ADRs Activos

| ID | Titulo | Estado | Fecha | Contexto |
|----|--------|--------|-------|----------|
| ADR-INFRA-001 | Vagrant como DevContainer Host | Aceptada | 2025-11-18 | Entorno dev reproducible |
| ADR-INFRA-002 | Pipeline CI/CD sobre DevContainer | Aceptada | 2025-11-18 | CI/CD consistente |
| ADR-INFRA-003 | Podman vs Docker en VM | Aceptada | 2025-11-18 | Container runtime |
| ADR-INFRA-004 | Estrategia Networking VM | Aceptada | 2025-11-18 | Conectividad VM-Host |
| ADR-INFRA-005 | Gestion de Secretos DevContainer | Aceptada | 2025-11-18 | Seguridad credenciales |
| ADR-INFRA-006 | CPython Precompilado Strategy | Aceptada | 2025-11-18 | Performance builds |
| ADR-INFRA-007 | Dual Database (MariaDB/PostgreSQL) | Aceptada | 2025-11-18 | Flexibilidad DB |
| ADR-INFRA-008 | Estrategia de Backups VM | Propuesta | 2025-11-18 | Disaster recovery |

## ADRs por Categoria

### Virtualizacion
- ADR-INFRA-001, ADR-INFRA-004

### Containerizacion
- ADR-INFRA-002, ADR-INFRA-003, ADR-INFRA-005

### Toolchain
- ADR-INFRA-006

### Database
- ADR-INFRA-007

### Operaciones
- ADR-INFRA-008

## Proceso de ADRs

1. Propuesta: Crear ADR con estado "propuesta"
2. Revision: Equipo revisa y discute
3. Decision: Actualizar estado a "aceptada"/"rechazada"
4. Implementacion: Referenciar en codigo/docs
5. Evolucion: Marcar como "obsoleta" si superseded

## Referencias

- Plantilla: `/plantillas/plantilla-adr-infraestructura.md`
- Proceso: PROC-INFRA-004-gestion-cambios-infraestructura.md
```

**Criterios de Aceptacion:**
- [ ] Indice creado con frontmatter
- [ ] Tabla de ADRs actuales
- [ ] Categorizacion por dominio
- [ ] Proceso de ADRs documentado

---

#### TASK-032: Crear ADR-INFRA-001: Vagrant como DevContainer Host

**ID:** TASK-INFRA-REORG-032
**Prioridad:** P0
**Duracion:** 3 horas
**Prerequisitos:** TASK-031
**Tecnica de Prompting:** ADR Generation

**Descripcion:**
Formalizar decision de usar Vagrant como host para DevContainers.

**Estructura del ADR:**
```markdown
---
id: ADR-INFRA-001
tipo: adr
categoria: virtualizacion
titulo: Vagrant como DevContainer Host
estado: aceptada
fecha: 2025-11-18
responsable: equipo-infraestructura
relacionados: ["REQ-INFRA-VM-001", "canvas-devcontainer-host-vagrant"]
---

# ADR-INFRA-001: Vagrant como DevContainer Host

## Estado
**Aceptada** - 2025-11-18

## Contexto

Necesitamos un entorno de desarrollo local que:
- Sea reproducible en diferentes sistemas operativos (Windows, macOS, Linux)
- Proporcione aislamiento completo del sistema host
- Soporte DevContainers para desarrollo containerizado
- Sea facil de configurar y mantener
- Permita infraestructura como codigo

## Decision

**Adoptamos Vagrant como orquestador de VMs para alojar DevContainers.**

Usaremos:
- Vagrant 2.4.0+ como orquestador
- VirtualBox 7.0+ como provider (por defecto)
- Ubuntu 22.04 LTS (jammy) como guest OS
- DevContainer CLI dentro de la VM

## Rationale

### Ventajas de Vagrant

1. **Reproducibilidad**: Vagrantfile documenta infraestructura completa
2. **Portabilidad**: Funciona en Windows/macOS/Linux
3. **Madurez**: Herramienta probada con 10+ años de desarrollo
4. **Ecosistema**: Amplia coleccion de boxes y providers
5. **Simplicidad**: `vagrant up` provision completa automatica

### Por que NO alternativas

#### Docker Desktop
- Problemas de licenciamiento (Docker Desktop)
- Menos control sobre VM subyacente
- Networking mas complejo en algunos OS

#### Multipass
- Menos maduro que Vagrant
- Menor ecosistema y documentacion
- Limitado a Ubuntu (menos flexible)

#### Setup Manual
- No reproducible
- Propenso a errores
- Dificil de documentar y mantener

## Consecuencias

### Positivas
- Entorno dev 100% reproducible
- Onboarding simplificado: solo `vagrant up`
- Aislamiento completo del sistema host
- Infraestructura como codigo (Vagrantfile)
- Facil integracion con DevContainers

### Negativas
- Overhead de VM (memoria, CPU)
- Tiempo de provision inicial (~5-10 min)
- Performance I/O con shared folders (mitigable con NFS/rsync)
- Depende de VirtualBox (o provider alternativo)

### Neutras
- Requiere aprender sintaxis Vagrant (curva baja)
- Necesita mantener Vagrantfile actualizado

## Implementacion

1. Crear `infrastructure/vagrant/Vagrantfile`
2. Configurar provision scripts en `infrastructure/provision/`
3. Documentar en `docs/infraestructura/procedimientos/PROCED-INFRA-001`
4. Crear checklist de provision
5. Probar en Windows, macOS, Linux

## Validacion

Entorno considerado exitoso si:
- [ ] `vagrant up` completa sin errores
- [ ] VM accesible via `vagrant ssh`
- [ ] DevContainer CLI funcional dentro de VM
- [ ] Proyecto puede ejecutar `devcontainer up`
- [ ] Tests pasan dentro del DevContainer

## Trazabilidad

### Requisitos Cubiertos
- REQ-INFRA-VM-001: Entorno reproducible
- REQ-INFRA-VM-002: Portabilidad multiplataforma
- REQ-INFRA-VM-003: Aislamiento de desarrollo

### Documentos Relacionados
- Canvas: `diseno/arquitectura/canvas-devcontainer-host-vagrant.md`
- Procedimiento: `procedimientos/PROCED-INFRA-001-provision-vm-vagrant.md`
- Vagrantfile: `infrastructure/vagrant/Vagrantfile`

## Referencias

- [Vagrant Documentation](https://www.vagrantup.com/docs)
- [DevContainer Specification](https://containers.dev/)
- [VirtualBox Manual](https://www.virtualbox.org/manual/)

## Historial

| Version | Fecha | Cambio |
|---------|-------|--------|
| 1.0.0 | 2025-11-18 | Decision inicial aceptada |
```

**Criterios de Aceptacion:**
- [ ] ADR completo con todas las secciones
- [ ] Frontmatter YAML completo
- [ ] Rationale bien documentado
- [ ] Trazabilidad a requisitos
- [ ] Consecuencias positivas/negativas/neutras listadas

---

#### TASK-033 a TASK-038: Crear ADRs restantes (6 tareas)

**TASK-033:** ADR-INFRA-002: Pipeline CI/CD sobre DevContainer
**TASK-034:** ADR-INFRA-003: Podman vs Docker en VM
**TASK-035:** ADR-INFRA-004: Estrategia de Networking VM
**TASK-036:** ADR-INFRA-005: Gestion de Secretos en DevContainer
**TASK-037:** ADR-INFRA-006: CPython Precompilado Strategy
**TASK-038:** ADR-INFRA-007: Dual Database (MariaDB/PostgreSQL)

**Duracion por ADR:** 2-3 horas
**Criterios comunes:**
- [ ] Estructura identica a ADR-INFRA-001
- [ ] Contexto, decision, rationale, consecuencias
- [ ] Trazabilidad a requisitos
- [ ] Referencias a documentos relacionados

---

### 3.2 CREACION DE PROCESOS

#### TASK-039: Crear PROC-INFRA-001: Gestion de Infraestructura VM

**ID:** TASK-INFRA-REORG-039
**Prioridad:** P1
**Duracion:** 4 horas
**Prerequisitos:** TASK-031
**Tecnica de Prompting:** Process Documentation

**Descripcion:**
Documentar proceso high-level de gestion del ciclo de vida de VMs.

**Estructura:**
```markdown
---
id: PROC-INFRA-001
tipo: proceso
categoria: gestion
titulo: Gestion de Infraestructura de VMs
version: 1.0.0
fecha_creacion: 2025-11-18
estado: activo
responsable: equipo-infraestructura
relacionados: ["PROCED-INFRA-001", "PROCED-INFRA-002", "PROCED-INFRA-004"]
---

# PROC-INFRA-001: Gestion de Infraestructura de VMs

## 1. PROPOSITO

Definir el proceso completo de gestion del ciclo de vida de maquinas virtuales usadas como DevContainer hosts.

## 2. ALCANCE

**Incluye:**
- Provision inicial de VMs
- Configuracion de DevContainer hosts
- Actualizaciones y mantenimiento
- Backups y recuperacion
- Decommissioning

**No incluye:**
- Desarrollo dentro de containers (ver PROC-DEV-XXX)
- Gestion de aplicaciones (ver PROC-BACK-XXX)

## 3. ROLES Y RESPONSABILIDADES

| Rol | Responsabilidad |
|-----|-----------------|
| DevOps Engineer | Mantener Vagrantfiles, provision scripts |
| Desarrollador | Usar VMs configuradas, reportar issues |
| Infrastructure Lead | Aprobar cambios a infraestructura base |

## 4. PROCESO

### 4.1 Provision Inicial

**Trigger:** Nuevo desarrollador o nueva maquina host

**Pasos:**
1. Desarrollador ejecuta `vagrant up`
2. Vagrant descarga box (ubuntu/jammy64)
3. Vagrant crea VM en VirtualBox
4. Vagrant ejecuta provision scripts
5. Scripts instalan DevContainer CLI, Podman
6. Desarrollador valida con checklist

**Procedimiento:** PROCED-INFRA-001-provision-vm-vagrant.md

### 4.2 Configuracion de DevContainer Host

**Trigger:** Provision inicial completada

**Pasos:**
1. SSH a VM: `vagrant ssh`
2. Configurar networking
3. Configurar storage shares
4. Validar DevContainer CLI
5. Ejecutar test de integracion

**Procedimiento:** PROCED-INFRA-002-configurar-devcontainer-host.md

### 4.3 Actualizaciones

**Trigger:** Nueva version de box o toolchain

**Pasos:**
1. Actualizar Vagrantfile con nueva version
2. Comunicar cambios al equipo
3. Desarrolladores ejecutan `vagrant box update`
4. `vagrant destroy && vagrant up` (si breaking changes)
5. Validar funcionalidad post-update

**Frecuencia:** Mensual o segun necesidad

### 4.4 Backups

**Trigger:** Antes de cambios mayores, o periodicamente

**Pasos:**
1. Snapshot VM: `vagrant snapshot save <nombre>`
2. Exportar VM via VirtualBox (opcional)
3. Backup de datos compartidos
4. Documentar snapshot en registro

**Procedimiento:** PROCED-INFRA-004-backup-restauracion-vm.md

### 4.5 Recuperacion

**Trigger:** VM corrupta o error critico

**Pasos:**
1. Intentar restaurar snapshot: `vagrant snapshot restore <nombre>`
2. Si falla, `vagrant destroy && vagrant up`
3. Recuperar datos de backups
4. Validar funcionalidad

**Procedimiento:** PROCED-INFRA-004-backup-restauracion-vm.md

### 4.6 Decommissioning

**Trigger:** Desarrollador deja equipo o cambia de maquina

**Pasos:**
1. Backup de datos personales (si aplica)
2. Destruir VM: `vagrant destroy`
3. Limpiar archivos locales
4. Documentar en registro

## 5. METRICAS

| Metrica | Objetivo | Medicion |
|---------|----------|----------|
| Tiempo provision inicial | < 10 min | Automatico en provision |
| Uptime VM | > 99% | vagrant status |
| Tiempo recuperacion | < 5 min | Procedimiento PROCED-INFRA-004 |

## 6. DOCUMENTOS RELACIONADOS

- ADR-INFRA-001: Vagrant como DevContainer Host
- PROCED-INFRA-001: Provision VM Vagrant
- PROCED-INFRA-002: Configurar DevContainer Host
- PROCED-INFRA-004: Backup y Restauracion VM

## 7. CONTROL DE CAMBIOS

| Version | Fecha | Cambio |
|---------|-------|--------|
| 1.0.0 | 2025-11-18 | Creacion inicial |
```

**Criterios de Aceptacion:**
- [ ] Proceso completo con 6 fases
- [ ] Cada fase con procedimiento asociado
- [ ] Metricas definidas
- [ ] Trazabilidad a ADRs y procedimientos

---

#### TASK-040 a TASK-043: Crear procesos restantes (4 tareas)

**TASK-040:** PROC-INFRA-002: Ciclo de Vida DevContainer
**TASK-041:** PROC-INFRA-003: Integracion Continua de Infraestructura
**TASK-042:** PROC-INFRA-004: Gestion de Cambios de Infraestructura
**TASK-043:** PROC-INFRA-005: Monitoreo y Observabilidad

**Duracion:** 3-4h cada uno
**Criterios comunes:**
- [ ] Estructura identica a PROC-INFRA-001
- [ ] Fases bien definidas
- [ ] Procedimientos asociados
- [ ] Metricas de proceso

---

### 3.3 CREACION DE PROCEDIMIENTOS

#### TASK-044: Crear PROCED-INFRA-001: Provision VM Vagrant

**ID:** TASK-INFRA-REORG-044
**Prioridad:** P0
**Duracion:** 4 horas
**Prerequisitos:** TASK-039
**Tecnica de Prompting:** Step-by-Step Documentation

**Descripcion:**
Procedimiento deterministico para provisionar VM Vagrant.

**Estructura:**
```markdown
---
id: PROCED-INFRA-001
tipo: procedimiento
categoria: provision
titulo: Provision de VM Vagrant para DevContainer Host
version: 1.0.0
fecha_creacion: 2025-11-18
estado: activo
responsable: equipo-infraestructura
relacionados: ["PROC-INFRA-001", "ADR-INFRA-001"]
---

# PROCED-INFRA-001: Provision de VM Vagrant para DevContainer Host

## 1. OBJETIVO

Provisionar maquina virtual Ubuntu 22.04 LTS usando Vagrant para alojar DevContainers.

## 2. PREREQUISITOS

### 2.1 Software Requerido
- [ ] Vagrant 2.4.0+ instalado
- [ ] VirtualBox 7.0+ instalado
- [ ] Git instalado
- [ ] 8GB RAM disponible
- [ ] 50GB espacio en disco

### 2.2 Verificacion de Prerequisitos
```bash
# Verificar versiones
vagrant --version  # Debe mostrar 2.4.0+
vboxmanage --version  # Debe mostrar 7.0+
```

## 3. PROCEDIMIENTO

### PASO 1: Clonar Repositorio

```bash
# Clonar repositorio IACT
git clone https://github.com/2-Coatl/IACT.git
cd IACT
```

**Validacion:**
```bash
# Verificar que Vagrantfile existe
ls infrastructure/vagrant/Vagrantfile
```

**Criterio de exito:** Archivo Vagrantfile existe

---

### PASO 2: Configurar Variables (Opcional)

```bash
# Editar Vagrantfile si necesario
cd infrastructure/vagrant
vi Vagrantfile

# Configuraciones comunes:
# - v.memory = "4096"  # Ajustar RAM
# - v.cpus = 2         # Ajustar CPUs
```

**Validacion:** Revisar configuracion con cat Vagrantfile

---

### PASO 3: Iniciar Provision

```bash
# Desde infrastructure/vagrant/
vagrant up
```

**Duracion esperada:** 5-10 minutos (primera vez)

**Output esperado:**
```
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'ubuntu/jammy64'...
==> default: Forwarding ports...
==> default: Running provisioner: shell...
==> default: DevContainer CLI installed successfully
```

**Validacion:** Comando completa sin errores

---

### PASO 4: Verificar SSH

```bash
vagrant ssh
```

**Output esperado:**
```
Welcome to Ubuntu 22.04 LTS (GNU/Linux ...)
vagrant@ubuntu-jammy:~$
```

**Validacion:** Acceso SSH exitoso

---

### PASO 5: Validar DevContainer CLI

```bash
# Dentro de la VM (vagrant ssh)
devcontainer --version
```

**Output esperado:**
```
devcontainer 0.x.x
```

**Validacion:** Comando devcontainer disponible

---

### PASO 6: Validar Podman

```bash
# Dentro de la VM
podman --version
podman ps  # Debe mostrar contenedores (vacio inicialmente)
```

**Validacion:** Podman instalado y funcional

---

### PASO 7: Ejecutar Checklist de Validacion

Ver: `/checklists/CHECKLIST-PROVISION-VM.md`

- [ ] VM iniciada (`vagrant status` → running)
- [ ] SSH accesible (`vagrant ssh`)
- [ ] DevContainer CLI instalado
- [ ] Podman instalado y rootless
- [ ] Networking funcional (ping 8.8.8.8)
- [ ] Shared folders montados

---

## 4. ROLLBACK

Si provision falla:

```bash
# Destruir VM
vagrant destroy -f

# Limpiar y reintentar
rm -rf .vagrant
vagrant up
```

## 5. TROUBLESHOOTING

### Problema: "Box ubuntu/jammy64 no encontrado"
**Solucion:**
```bash
vagrant box add ubuntu/jammy64
vagrant up
```

### Problema: "VirtualBox no instalado"
**Solucion:**
- Instalar VirtualBox desde https://www.virtualbox.org/
- Reiniciar sistema
- Reintentar vagrant up

### Problema: "Insufficient memory"
**Solucion:**
- Editar Vagrantfile: reducir v.memory a 2048
- vagrant up

## 6. POST-PROVISION

Siguiente paso: PROCED-INFRA-002-configurar-devcontainer-host.md

## 7. REFERENCIAS

- ADR-INFRA-001: Vagrant como DevContainer Host
- Vagrantfile: `infrastructure/vagrant/Vagrantfile`
- Provision scripts: `infrastructure/provision/`
```

**Criterios de Aceptacion:**
- [ ] Procedimiento con 7 pasos deterministicos
- [ ] Cada paso con validacion
- [ ] Rollback documentado
- [ ] Troubleshooting incluido
- [ ] Enlaces a checklist

---

#### TASK-045 a TASK-049: Crear procedimientos restantes (5 tareas)

**TASK-045:** PROCED-INFRA-002: Configurar DevContainer Host
**TASK-046:** PROCED-INFRA-003: Ejecutar Pipeline CI/CD
**TASK-047:** PROCED-INFRA-004: Backup y Restauracion VM
**TASK-048:** PROCED-INFRA-005: Troubleshooting DevContainer
**TASK-049:** PROCED-INFRA-006: Actualizar Toolchain CPython

**Duracion:** 3-4h cada uno
**Criterios comunes:**
- [ ] Pasos numerados, deterministicos
- [ ] Validacion en cada paso
- [ ] Rollback documentado
- [ ] Troubleshooting incluido

---

### 3.4 CREACION DE CATALOGOS

#### TASK-050: Crear CATALOGO-SERVICIOS-INFRA.md

**ID:** TASK-INFRA-REORG-050
**Prioridad:** P1
**Duracion:** 3 horas
**Prerequisitos:** TASK-002
**Tecnica de Prompting:** Catalog Generation

**Descripcion:**
Inventario completo de servicios de infraestructura.

**Estructura:**
```markdown
# Catalogo de Servicios de Infraestructura

| Servicio | Descripcion | Tecnologia | Estado | Owner |
|----------|-------------|------------|--------|-------|
| DevContainer Host | VM Ubuntu para containers | Vagrant+VirtualBox | Activo | DevOps |
| Pipeline CI/CD | Automatizacion tests/deploy | GitHub Actions | Activo | DevOps |
| Podman Runtime | Container runtime rootless | Podman 4.x | Activo | DevOps |
| CPython Toolchain | Python precompilado | CPython 3.11 | Activo | Backend |
| MariaDB | Database relacional | MariaDB 10.x | Activo | Backend |
| PostgreSQL | Database relacional | PostgreSQL 15.x | Activo | Backend |
```

**Criterios de Aceptacion:**
- [ ] Catalogo con 10+ servicios
- [ ] Estado actualizado
- [ ] Owners asignados

---

#### TASK-051 a TASK-053: Crear catalogos restantes (3 tareas)

**TASK-051:** CATALOGO-VMS-VAGRANT.md
**TASK-052:** CATALOGO-DEVCONTAINER-FEATURES.md
**TASK-053:** CATALOGO-SCRIPTS-PROVISION.md

**Duracion:** 2-3h cada uno

---

### 3.5 CREACION DE PLANTILLAS

#### TASK-054: Crear plantilla-adr-infraestructura.md

**ID:** TASK-INFRA-REORG-054
**Prioridad:** P1
**Duracion:** 2 horas
**Prerequisitos:** TASK-032
**Tecnica de Prompting:** Template Extraction

**Descripcion:**
Extraer plantilla reutilizable de ADR-INFRA-001.

**Criterios de Aceptacion:**
- [ ] Plantilla con placeholders
- [ ] Secciones obligatorias marcadas
- [ ] Ejemplos incluidos

---

#### TASK-055 a TASK-061: Crear plantillas restantes (7 tareas)

**Plantillas a crear:**
- plantilla-procedimiento-infra.md
- plantilla-vm-vagrant.md
- plantilla-devcontainer-feature.md
- plantilla-runbook.md
- plantilla-checklist-provision.md
- plantilla-requisito-no-funcional.md
- plantilla-catalogo-servicios.md

**Duracion:** 1-2h cada una

---

## FASE 4: VALIDACION Y LIMPIEZA

**Duracion:** 1 semana
**Tareas:** 11
**Esfuerzo:** 3-5 persona-dias
**Objetivo:** Validar reorganizacion, limpiar legacy, documentar resultados

### 4.1 VALIDACIONES

#### TASK-062: Validar integridad de enlaces

**ID:** TASK-INFRA-REORG-062
**Prioridad:** P0
**Duracion:** 4 horas
**Prerequisitos:** TASK-029
**Tecnica de Prompting:** Automated Validation

**Descripcion:**
Ejecutar validacion final de todos los enlaces en docs/infraestructura/.

**Comandos:**
```bash
./qa/scripts/validate_links_infra.sh
```

**Criterio de exito:** 95%+ enlaces validos

---

#### TASK-063: Validar READMEs (100% cobertura)

**ID:** TASK-INFRA-REORG-063
**Prioridad:** P0
**Duracion:** 3 horas
**Prerequisitos:** TASK-026

**Criterios:**
- [ ] Todas las carpetas tienen README.md
- [ ] READMEs tienen frontmatter YAML
- [ ] READMEs describen contenido
- [ ] READMEs actualizados

---

#### TASK-064: Validar metadatos YAML

**ID:** TASK-INFRA-REORG-064
**Prioridad:** P1
**Duracion:** 4 horas
**Prerequisitos:** TASK-054 a TASK-061

**Comandos:**
```bash
./qa/scripts/validate_frontmatter_infra.py
```

**Criterio:** 90%+ documentos criticos con frontmatter

---

#### TASK-065: Validar nomenclatura

**ID:** TASK-INFRA-REORG-065
**Prioridad:** P1
**Duracion:** 3 horas

**Validaciones:**
- ADRs: ADR-INFRA-###-titulo.md
- Procesos: PROC-INFRA-###-titulo.md
- Procedimientos: PROCED-INFRA-###-titulo.md
- IDs unicos y secuenciales

---

### 4.2 LIMPIEZA

#### TASK-066: Eliminar carpetas legacy vacias

**ID:** TASK-INFRA-REORG-066
**Prioridad:** P1
**Duracion:** 2 horas
**Prerequisitos:** TASK-017 a TASK-020

**Carpetas a eliminar (si vacias):**
- plan/ (movido a planificacion/)
- Otras carpetas consolidadas

**Comandos:**
```bash
# SOLO si vacias
rmdir plan/
```

**Criterios de Aceptacion:**
- [ ] Solo eliminar si 100% contenido movido
- [ ] Verificado en matriz de mapeo
- [ ] Commit con mensaje descriptivo

---

#### TASK-067: Limpiar emojis de documentacion

**ID:** TASK-INFRA-REORG-067
**Prioridad:** P2
**Duracion:** 1 hora

**Comandos:**
```bash
# Buscar emojis
grep -r "[\u{1F600}-\u{1F64F}]" docs/infraestructura/

# Eliminar manualmente
```

---

### 4.3 DOCUMENTACION FINAL

#### TASK-068: Actualizar README principal

**ID:** TASK-INFRA-REORG-068
**Prioridad:** P0
**Duracion:** 3 horas
**Prerequisitos:** TASK-062 a TASK-067

**Secciones a actualizar:**
- Estructura de carpetas
- Documentos clave
- Navegacion rapida
- Referencias

---

#### TASK-069: Crear CHANGELOG de reorganizacion

**ID:** TASK-INFRA-REORG-069
**Prioridad:** P1
**Duracion:** 2 horas

**Contenido:**
- Fecha de reorganizacion
- Cambios principales
- Carpetas nuevas
- Archivos movidos
- Breaking changes

---

#### TASK-070: Crear guia de navegacion

**ID:** TASK-INFRA-REORG-070
**Prioridad:** P1
**Duracion:** 3 horas

**Archivo:** `GUIA-NAVEGACION-INFRAESTRUCTURA.md`

**Contenido:**
- Como encontrar documentos
- Estructura de carpetas explicada
- Convenciones de nomenclatura
- FAQ

---

#### TASK-071: Actualizar gobernanza/README.md

**ID:** TASK-INFRA-REORG-071
**Prioridad:** P2
**Duracion:** 1 hora

**Accion:** Referenciar docs/infraestructura/ reorganizado

---

#### TASK-072: Crear documento de lecciones aprendidas

**ID:** TASK-INFRA-REORG-072
**Prioridad:** P1
**Duracion:** 3 horas

**Archivo:** `LECCIONES-APRENDIDAS-REORGANIZACION.md`

**Contenido:**
- Problemas encontrados
- Soluciones aplicadas
- Mejoras para futuras reorganizaciones
- Metricas finales

---

### RESUMEN FASE 4

| Categoria | Tareas | Duracion |
|-----------|--------|----------|
| Validaciones | TASK-062 a TASK-065 | 14h |
| Limpieza | TASK-066 a TASK-067 | 3h |
| Documentacion final | TASK-068 a TASK-072 | 12h |
| **TOTAL FASE 4** | **11 tareas** | **29h** |

---

## 4. NOMENCLATURA Y CONVENCIONES

### 4.1 Nomenclatura de Archivos

#### 4.1.1 Architecture Decision Records
```
ADR-INFRA-###-titulo-snake-case.md
```
Ejemplos:
- `ADR-INFRA-001-vagrant-devcontainer-host.md`
- `ADR-INFRA-002-pipeline-cicd-devcontainer.md`

#### 4.1.2 Procesos
```
PROC-INFRA-###-titulo-snake-case.md
```
Ejemplos:
- `PROC-INFRA-001-gestion-infraestructura-vm.md`
- `PROC-INFRA-002-ciclo-vida-devcontainer.md`

#### 4.1.3 Procedimientos
```
PROCED-INFRA-###-titulo-snake-case.md
```
Ejemplos:
- `PROCED-INFRA-001-provision-vm-vagrant.md`
- `PROCED-INFRA-002-configurar-devcontainer-host.md`

#### 4.1.4 Catalogos
```
CATALOGO-nombre-recurso.md
```
Ejemplos:
- `CATALOGO-SERVICIOS-INFRA.md`
- `CATALOGO-VMS-VAGRANT.md`

#### 4.1.5 Checklists
```
CHECKLIST-nombre-proceso.md
```
Ejemplos:
- `CHECKLIST-PROVISION-VM.md`
- `CHECKLIST-VALIDACION-DEVCONTAINER.md`

### 4.2 Metadatos YAML (Frontmatter)

Todos los documentos principales DEBEN incluir frontmatter YAML:

```yaml
---
id: DOC-INFRA-###
tipo: [adr|proceso|procedimiento|catalogo|plantilla|guia]
categoria: [provision|configuracion|seguridad|testing|qa]
titulo: Titulo del Documento
version: 1.0.0
fecha_creacion: YYYY-MM-DD
fecha_actualizacion: YYYY-MM-DD
estado: [borrador|activo|obsoleto|archivado]
responsable: [equipo-infraestructura|equipo-devops]
relacionados: ["DOC-001", "ADR-002"]
tags: [vagrant, devcontainer, vm, cicd]
---
```

### 4.3 Convenciones de Contenido

1. **NO usar emojis** en documentacion formal
2. **Usar snake_case** para nombres de archivo
3. **Usar kebab-case** para IDs en frontmatter
4. **PlantUML** para diagramas (preferido)
5. **Seccion de Referencias** al final de cada documento
6. **Control de Cambios** en documentos versionados
7. **Indices actualizados**: README.md, INDEX.md, INDICE_*.md
8. **Enlaces relativos**: `[texto](../carpeta/archivo.md)`

### 4.4 Estructura de Documentos

#### ADRs
1. Estado
2. Contexto
3. Decision
4. Rationale
5. Consecuencias (positivas/negativas/neutras)
6. Implementacion
7. Validacion
8. Trazabilidad
9. Referencias

#### Procedimientos
1. Objetivo
2. Prerequisitos
3. Pasos (numerados, deterministicos)
4. Validacion (por paso)
5. Rollback
6. Troubleshooting
7. Post-procedimiento
8. Referencias

#### Procesos
1. Proposito
2. Alcance
3. Roles y responsabilidades
4. Fases del proceso
5. Metricas
6. Documentos relacionados
7. Control de cambios

---

## 5. MATRIZ DE RIESGOS

| ID | Riesgo | Probabilidad | Impacto | Severidad | Mitigacion | Contingencia |
|----|--------|--------------|---------|-----------|------------|--------------|
| R-001 | Enlaces rotos tras movimientos | Alta | Alto | CRITICO | Scripts de validacion automatica | Correccion manual + PR review |
| R-002 | Perdida de contenido | Baja | Critico | ALTO | Backup obligatorio (git tag) | Restaurar desde backup |
| R-003 | Duplicados no identificados | Media | Medio | MEDIO | Matriz de mapeo exhaustiva | Comparacion manual de archivos |
| R-004 | Nomenclatura inconsistente | Media | Bajo | BAJO | Validacion automatizada | Renombrado batch post-reorg |
| R-005 | Tiempo excede estimacion | Alta | Medio | MEDIO | Buffer 20%, trabajo en paralelo | Priorizar P0/P1, diferir P2 |
| R-006 | Confusion del equipo | Media | Medio | MEDIO | Guia de navegacion, comunicacion | Sesion de onboarding |
| R-007 | Conflictos de merge | Alta | Medio | MEDIO | Comunicar ventana de reorganizacion | Resolver conflictos manualmente |
| R-008 | Frontmatter incompleto | Media | Bajo | BAJO | Validacion automatica | Correccion batch |
| R-009 | Drift futuro vs gobernanza | Media | Alto | MEDIO | Validacion trimestral | Auditorias periodicas |
| R-010 | READMEs obsoletos | Media | Medio | MEDIO | Proceso de actualizacion | Revision manual periodica |

### Mapa de Severidad

- **CRITICO**: Probabilidad Alta + Impacto Critico
- **ALTO**: Probabilidad Alta + Impacto Alto, o Probabilidad Baja + Impacto Critico
- **MEDIO**: Probabilidad Media + Impacto Medio/Alto
- **BAJO**: Probabilidad Baja + Impacto Bajo/Medio

---

## 6. PROCEDIMIENTO DE ROLLBACK

### 6.1 Escenario 1: Rollback Completo

**Trigger:**
- 50%+ enlaces rotos confirmados
- Perdida de contenido detectada
- Equipo no puede trabajar

**Procedimiento:**
```bash
# 1. Verificar que tag de backup existe
git tag -l "QA-INFRA-REORG-BACKUP-*"

# 2. Crear branch de respaldo del trabajo actual (por si acaso)
git checkout -b backup-failed-reorganization
git push origin backup-failed-reorganization

# 3. Restaurar desde tag
git checkout main  # o branch principal
git reset --hard QA-INFRA-REORG-BACKUP-2025-11-18

# 4. CUIDADO: Solo si es absolutamente necesario
# git push --force origin main

# 5. Comunicar al equipo
# - Reorganizacion revertida
# - Estado restaurado a [fecha]
# - Trabajo actual preservado en branch backup-failed-reorganization
```

**Criterios de Decision:**
- Aprobacion de Infrastructure Lead requerida
- Documentar causa de rollback
- Analisis post-mortem obligatorio

---

### 6.2 Escenario 2: Rollback Parcial

**Trigger:**
- Fase 1-2 exitosa
- Fase 3 tiene problemas
- Valor suficiente en Fases 1-2

**Procedimiento:**
```bash
# 1. Pausar Fase 3
git checkout -b pause-fase-3

# 2. Validar y estabilizar Fases 1-2
./qa/scripts/validate_links_infra.sh
./qa/scripts/validate_frontmatter_infra.py

# 3. Merge de Fases 1-2 si estables
git checkout main
git merge fase-1-2-completed

# 4. Replantear Fase 3 como mejora futura
# - Crear issues en tracker
# - Documentar en roadmap
# - Priorizar tareas
```

---

### 6.3 Escenario 3: Correccion Rapida

**Trigger:**
- Problema puntual (enlaces rotos en 1-2 archivos)
- No justifica rollback completo

**Procedimiento:**
```bash
# 1. Identificar archivos afectados
./qa/scripts/validate_links_infra.sh | grep BROKEN

# 2. Corregir manualmente
vi [archivo-con-enlaces-rotos]

# 3. Validar correccion
./qa/scripts/validate_links_infra.sh [archivo-corregido]

# 4. Commit atomico
git add [archivo-corregido]
git commit -m "fix: Corregir enlaces rotos en [archivo]"
```

---

## 7. CRITERIOS DE EXITO

### 7.1 Criterios Cuantitativos

| Criterio | Baseline | Objetivo | Medicion |
|----------|----------|----------|----------|
| Carpetas principales | 22 | 33+ | tree -L 1 -d |
| READMEs completos | 70% | 100% | find . -name README.md \| wc -l |
| Frontmatter YAML | 15% | 90%+ | validate_frontmatter_infra.py |
| ADRs formales | 1 | 8+ | ls adr/ADR-INFRA-*.md \| wc -l |
| Procesos | 0 | 5+ | ls procesos/PROC-INFRA-*.md \| wc -l |
| Procedimientos | 0 | 6+ | ls procedimientos/PROCED-INFRA-*.md \| wc -l |
| Plantillas | 4 | 12+ | ls plantillas/*.md \| wc -l |
| Catalogos | 0 | 4+ | ls catalogos/CATALOGO-*.md \| wc -l |
| Enlaces validos | ~45% | 95%+ | validate_links_infra.sh |
| Nomenclatura correcta | ~60% | 95%+ | validate_naming_infra.sh |
| Puntuacion calidad | 60-65 | 85-90 | Scorecard compuesto |

### 7.2 Criterios Cualitativos

- [ ] Estructura identica a `docs/gobernanza/` (isomorfismo completo)
- [ ] Navegacion intuitiva: usuarios encuentran documentos en <2 min
- [ ] Completitud: Cada componente tiene documentacion completa
- [ ] Consistencia: Nomenclatura y metadatos uniformes
- [ ] Trazabilidad: Matrices vinculan ADRs-requisitos-implementacion
- [ ] Usabilidad: Nuevos miembros onboarding sin ayuda
- [ ] Mantenibilidad: Documentacion facil de actualizar

### 7.3 Checklist de Aceptacion

**Estructura:**
- [ ] 33+ carpetas creadas segun modelo gobernanza
- [ ] 13 carpetas nuevas con READMEs completos
- [ ] 0 carpetas legacy con contenido

**Contenido:**
- [ ] 8+ ADRs formales creados
- [ ] 5+ procesos documentados (PROC-INFRA-XXX)
- [ ] 6+ procedimientos documentados (PROCED-INFRA-XXX)
- [ ] 2 Canvas de arquitectura completos
- [ ] 4+ catalogos tecnicos creados
- [ ] 12+ plantillas reutilizables
- [ ] Matrices de trazabilidad completas

**Calidad:**
- [ ] 100% carpetas tienen README.md completo
- [ ] 90%+ archivos criticos con frontmatter YAML
- [ ] 95%+ enlaces validos
- [ ] 95%+ nomenclatura correcta
- [ ] 0 emojis en documentacion formal
- [ ] 0 duplicados de contenido

**Documentacion:**
- [ ] README.md principal actualizado
- [ ] INDEX.md completo y actualizado
- [ ] CHANGELOG.md creado
- [ ] GUIA-NAVEGACION-INFRAESTRUCTURA.md creada
- [ ] LECCIONES-APRENDIDAS-REORGANIZACION.md documentada

**Validacion:**
- [ ] Scripts de validacion ejecutados
- [ ] Todos los tests de integridad pasan
- [ ] Peer review completado
- [ ] Aprobacion de Infrastructure Lead obtenida

---

## 8. TIMELINE ESTIMADO

### 8.1 Gantt Simplificado

```
Semana 1: FASE 1 - PREPARACION
[===============================] 5 tareas, 22h
TASK-001 ████
TASK-002 ████████
TASK-003 ████
TASK-004 ████
TASK-005 ██

Semanas 2-3: FASE 2 - REORGANIZACION CRITICA
[===============================] 25 tareas, 67h
Consolidacion diseno/           ████████████████████████
Consolidacion planificacion/    █████
Reorganizacion sesiones/        █████
Movimiento archivos raiz        ██████████
Eliminacion duplicados          ██
Completar READMEs               ████████
Actualizacion enlaces           █████████████

Semanas 4-5: FASE 3 - CONTENIDO NUEVO
[===============================] 24 tareas, 80h
ADRs formales (8)               ████████████████████
Procesos (5)                    ████████████
Procedimientos (6)              ██████████████████
Catalogos (4)                   ██████████
Plantillas (8)                  ████████████████

Semana 6: FASE 4 - VALIDACION Y LIMPIEZA
[===============================] 11 tareas, 29h
Validaciones                    ██████████████
Limpieza                        ███
Documentacion final             ████████████
```

### 8.2 Hitos Clave

| Hito | Fecha Estimada | Criterio |
|------|----------------|----------|
| Inicio Oficial | 2025-11-18 | Tag de backup creado |
| Fin Fase 1 | 2025-11-22 | 13 carpetas nuevas creadas |
| Fin Fase 2 | 2025-12-06 | Archivos reorganizados, enlaces corregidos |
| Fin Fase 3 | 2025-12-20 | Contenido nuevo creado |
| Fin Fase 4 | 2025-12-27 | Validacion completa, lecciones documentadas |
| Cierre Formal | 2025-12-27 | Aprobacion de stakeholders |

### 8.3 Dependencias Criticas

```
TASK-001 (Backup)
  └─→ TASK-002 (Carpetas nuevas)
       ├─→ TASK-003 (Matriz mapeo)
       │    └─→ TASK-016 (Categorizar archivos raiz)
       │         └─→ TASK-017-020 (Mover archivos)
       │              └─→ TASK-027 (Validar enlaces)
       │                   └─→ TASK-028-029 (Corregir enlaces)
       ├─→ TASK-006 (Subcarpetas diseno)
       │    └─→ TASK-007-011 (Consolidar diseno)
       │         └─→ TASK-008-009 (Canvas)
       └─→ TASK-031 (Indice ADRs)
            └─→ TASK-032-038 (Crear ADRs)
                 └─→ TASK-039 (Primer proceso)
                      └─→ TASK-044 (Primer procedimiento)
```

---

## 9. RECURSOS NECESARIOS

### 9.1 Recursos Humanos

| Rol | Dedicacion | Duracion | Responsabilidades |
|-----|-----------|----------|-------------------|
| Tech Writer / Documentador | 100% | 6 semanas | Ejecucion de todas las tareas |
| Infrastructure Lead | 25% | 6 semanas | Revision, aprobacion, validacion tecnica |
| QA Engineer | 25% | Semanas 5-6 | Validaciones automatizadas, peer review |
| DevOps Engineer | 10% | Ad-hoc | Consultas tecnicas, validacion de procedimientos |

**Total esfuerzo:** ~28-38 persona-dias

### 9.2 Recursos Tecnicos

**Software:**
- Git (control de versiones)
- Editor de texto (VS Code, vim, etc.)
- Markdown linter (markdownlint-cli)
- Python 3.x (para scripts de validacion)
- Bash (para scripts de validacion)

**Scripts a desarrollar:**
- `validate_links_infra.sh` (validacion de enlaces)
- `validate_frontmatter_infra.py` (validacion YAML)
- `validate_naming_infra.sh` (validacion nomenclatura)
- `clean_emojis.sh` (limpieza de emojis)

### 9.3 Referencias Documentales

**Documentos modelo:**
- `docs/gobernanza/` - Estructura objetivo
- `docs/gobernanza/procedimientos/PROCED-GOB-007.md` - Procedimiento de consolidacion
- `docs/backend/qa/PLAN-REORGANIZACION-ESTRUCTURA-BACKEND-2025-11-18.md` - Plan paralelo

**Plantillas:**
- Plantilla de ADR (a crear)
- Plantilla de procedimiento (a crear)
- Plantilla de proceso (a crear)

---

## 10. COMUNICACION

### 10.1 Plan de Comunicacion

| Fase | Audiencia | Canal | Contenido | Frecuencia |
|------|-----------|-------|-----------|------------|
| Pre-inicio | Todos | Email/Slack | Anuncio inicio, timeline, impactos | Una vez |
| Durante | Equipo Infra | Slack channel | Progreso diario, blockers | Diaria |
| Durante | Stakeholders | Email | Progreso semanal, hitos | Semanal |
| Post-cierre | Todos | Email/Wiki | Resultado final, guia navegacion | Una vez |

### 10.2 Kick-off (Semana 1)

**Agenda:**
1. Presentar plan y justificacion (15 min)
2. Explicar estructura objetivo (15 min)
3. Timeline y fases (10 min)
4. Roles y responsabilidades (10 min)
5. Q&A (10 min)

**Entregables:**
- Slides de presentacion
- Documento de plan compartido
- Canal de Slack creado

### 10.3 Durante Ejecucion

**Actualizaciones semanales:**
```markdown
# Actualizacion Semanal - Reorganizacion docs/infraestructura/

**Semana:** [numero]
**Fecha:** [YYYY-MM-DD]
**Fase:** [1|2|3|4]

## Progreso
- Tareas completadas: X/Y
- Progreso fase actual: XX%
- Progreso total: XX%

## Hitos Alcanzados
- [Hito 1]
- [Hito 2]

## Blockers
- [Blocker 1 - descripcion]

## Proximos Pasos
- [Accion 1]
- [Accion 2]

## Necesitas Ayuda?
- Canal: #reorganizacion-infra
- Responsable: [nombre]
```

### 10.4 Cierre (Semana 6)

**Sesion de capacitacion:**
- Duracion: 2 horas
- Formato: Presentacion + demo + Q&A
- Contenido:
  1. Nueva estructura explicada
  2. Como navegar la documentacion
  3. Convenciones y nomenclatura
  4. Demo de busqueda de documentos
  5. Q&A

**Entregables:**
- GUIA-NAVEGACION-INFRAESTRUCTURA.md
- Video grabado de la sesion
- FAQ documentado

---

## 11. METRICAS Y SEGUIMIENTO

### 11.1 Metricas de Progreso

| Metrica | Formula | Objetivo |
|---------|---------|----------|
| Progreso de tareas | Completadas / Total | 100% |
| Progreso por fase | Tareas fase completadas / Total fase | 100% cada fase |
| Velocidad | Tareas/dia | 2-3 tareas/dia |
| Calidad | Tareas sin re-trabajo / Tareas completadas | >90% |

### 11.2 Dashboard de Seguimiento

```markdown
# Dashboard - Reorganizacion docs/infraestructura/

## Progreso General
- **Tareas completadas:** 0/65 (0%)
- **Fase actual:** 1 - PREPARACION
- **Dias transcurridos:** 0/42
- **Dias restantes:** 42

## Progreso por Fase
- FASE 1: 0/5 (0%)
- FASE 2: 0/25 (0%)
- FASE 3: 0/24 (0%)
- FASE 4: 0/11 (0%)

## Metricas de Calidad
- Enlaces validos: ~45% → objetivo 95%
- READMEs completos: 70% → objetivo 100%
- Frontmatter YAML: 15% → objetivo 90%

## Riesgos Activos
- [R-005] Tiempo excede estimacion: MEDIO
- [R-007] Conflictos de merge: MEDIO
```

### 11.3 Puntos de Control

| Checkpoint | Fecha | Criterio | Accion si Falla |
|------------|-------|----------|-----------------|
| Fin Fase 1 | Semana 1 | 5/5 tareas completadas | Extender Fase 1 3 dias |
| Fin Fase 2 | Semana 3 | 25/25 tareas, 95%+ enlaces OK | Correccion masiva enlaces |
| Fin Fase 3 | Semana 5 | Contenido nuevo completo | Priorizar ADRs/procedimientos |
| Validacion Final | Semana 6 | Todos los criterios de exito | Extender validacion |

---

## 12. REFERENCIAS

### 12.1 Documentos de Referencia

- **Analisis previo:** `README-REORGANIZACION-ESTRUCTURA.md`
- **Modelo estructura:** `docs/gobernanza/` (completo)
- **Modelo plan:** `docs/backend/qa/PLAN-REORGANIZACION-ESTRUCTURA-BACKEND-2025-11-18.md`
- **Procedimiento consolidacion:** `docs/gobernanza/procedimientos/PROCED-GOB-007.md`
- **QA analisis ramas:** `docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/`

### 12.2 Tecnicas de Prompting Aplicadas

Este plan aplica las siguientes tecnicas de prompting documentadas en `docs/ai/prompting/`:

1. **Decomposed Prompting**: Descomposicion de reorganizacion en 65 tareas discretas
2. **Tabular CoT (Chain of Thought)**: Uso extensivo de tablas para analisis
3. **Template-based Generation**: Plantillas para documentos repetitivos
4. **Self-Consistency**: Validacion cruzada de hallazgos y estructura
5. **Chain-of-Verification**: Validacion en multiples niveles (por paso, por fase, final)
6. **Hierarchical Organization**: Organizacion jerarquica de carpetas y contenido
7. **Systematic Planning**: Planificacion sistematica con dependencias explícitas

### 12.3 Herramientas y Scripts

**A desarrollar durante ejecucion:**
- `validate_links_infra.sh` (TASK-004)
- `validate_frontmatter_infra.py` (TASK-004)
- `validate_naming_infra.sh` (TASK-004)
- `clean_emojis.sh` (Fase 4)

**A reutilizar:**
- `markdownlint-cli` (validacion sintaxis Markdown)
- `tree` (visualizacion de estructura)
- Git hooks (pre-commit para validaciones)

---

## 13. APROBACIONES

| Rol | Nombre | Firma | Fecha |
|-----|--------|-------|-------|
| Autor / Tech Writer | Claude Code | [Firmado] | 2025-11-18 |
| Infrastructure Lead | [Pendiente] | ________ | YYYY-MM-DD |
| DevOps Lead | [Pendiente] | ________ | YYYY-MM-DD |
| QA Lead | [Pendiente] | ________ | YYYY-MM-DD |
| Arquitecto | [Pendiente] | ________ | YYYY-MM-DD |

---

## 14. ANEXOS

### Anexo A: Matriz Completa de Mapeo de Migracion

Ver documento separado: `MAPEO-MIGRACION-DOCS-INFRA.md` (a crear en TASK-003)

### Anexo B: Plantillas Completas

Ver carpeta: `docs/infraestructura/plantillas/` (a crear en Fase 3)

### Anexo C: Scripts de Validacion

Ver carpeta: `docs/infraestructura/qa/scripts/` (a crear en TASK-004)

### Anexo D: Checklist Rapido Pre-Ejecucion

**Antes de iniciar:**
- [ ] Plan aprobado por Infrastructure Lead
- [ ] Equipo notificado del inicio
- [ ] Branch de trabajo creado: `feature/qa-reorg-infra-estructura`
- [ ] Backup tag creado (TASK-001)
- [ ] Ventana de tiempo reservada (6 semanas)
- [ ] Recursos asignados (Tech Writer, QA Engineer)

**Prerequisitos tecnicos:**
- [ ] Git configurado correctamente
- [ ] Acceso de escritura a repositorio
- [ ] Editor de texto configurado
- [ ] Python 3.x instalado (para scripts)
- [ ] Bash disponible (para scripts)

**Durante Ejecucion:**
- [ ] Ejecutar tareas en orden segun dependencias
- [ ] Validar criterios de aceptacion de cada tarea
- [ ] Commits atomicos con mensajes convencionales
- [ ] Actualizar dashboard de progreso diariamente
- [ ] Comunicar blockers inmediatamente

**Post-Ejecucion:**
- [ ] Todas las validaciones pasadas
- [ ] Peer review completado
- [ ] Aprobaciones obtenidas
- [ ] Documentacion final actualizada
- [ ] Sesion de capacitacion impartida
- [ ] Feedback recolectado

---

## 15. CONTROL DE CAMBIOS

| Version | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-11-18 | Claude Code | Creacion inicial del plan ejecutable |

---

## 16. CONTACTO Y SOPORTE

**Para preguntas sobre este plan:**
- **Responsable:** Equipo de Infraestructura
- **Canal de Slack:** #reorganizacion-infra (a crear)
- **Email:** [equipo-infra@proyecto.com]
- **Issue tracker:** [link a issues]

**Para reportar problemas durante ejecucion:**
1. Crear issue en tracker con label `reorganizacion-infra`
2. Notificar en canal de Slack
3. Escalar a Infrastructure Lead si bloqueante

---

**Documento creado:** 2025-11-18
**Ultima revision:** 2025-11-18
**Proxima revision programada:** Post-implementacion (2026-01-18)
**Estado:** PROPUESTA - Pendiente de aprobacion
**Version:** 1.0.0
**Ubicacion:** `/home/user/IACT/docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/PLAN-REORGANIZACION-ESTRUCTURA-INFRA-2025-11-18.md`

---

**FIN DEL PLAN EJECUTABLE**
