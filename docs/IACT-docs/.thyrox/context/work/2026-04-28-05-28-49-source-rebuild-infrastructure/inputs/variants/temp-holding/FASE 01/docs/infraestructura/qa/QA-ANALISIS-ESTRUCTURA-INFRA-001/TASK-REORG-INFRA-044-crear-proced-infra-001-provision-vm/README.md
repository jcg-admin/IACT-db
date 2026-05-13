---
id: TASK-REORG-INFRA-044
tipo: tarea_contenido
categoria: procedimiento
titulo: Crear PROCED-INFRA-001 (Procedimiento de Provision de VM Vagrant)
fase: FASE_3_CONTENIDO_NUEVO
prioridad: ALTA
duracion_estimada: 5h
estado: pendiente
dependencias: [TASK-REORG-INFRA-039]
tags: [procedimiento, provision, vagrant, vm, infraestructura]
tecnica_prompting: Decomposed Prompting, Auto-CoT, Self-Consistency
---

# TASK-REORG-INFRA-044: Crear PROCED-INFRA-001 (Provisión de VM Vagrant)

**Fase:** FASE 3 - Contenido Nuevo
**Prioridad:** ALTA
**Duración Estimada:** 5 horas
**Responsable:** Infrastructure Documentation Team
**Estado:** PENDIENTE

---

## Objetivo

Crear el primer procedimiento formal de infraestructura (PROCED-INFRA-001) que documenta los pasos EXACTOS y DETALLADOS para provisionar una VM con Vagrant, incluyendo validaciones, troubleshooting y rollback.

Este procedimiento es diferente de un proceso (QUE hacemos) ya que es un conjunto de instrucciones PASO A PASO (COMO lo hacemos).

---

## Rationale: Auto-CoT + Self-Consistency

**Auto-CoT (Automatic Chain-of-Thought)**:
1. Lee sobre procedimientos en `docs/gobernanza/procedimientos/`
2. Razona sobre los pasos de provisión de VM Vagrant
3. Define procedimiento paso a paso basado en realidad técnica
4. Documenta con comandos exactos (copy-paste)

**Self-Consistency**:
- Verificar que sea PROCEDIMIENTO (COMO), no proceso (QUE)
- Verificar que tenga comandos ejecutables
- Verificar criterios de éxito claros
- Verificar troubleshooting práctico

---

## Prerequisitos

- [x] Lectura de PROCED-GOB-002 (estructura procedimientos)
- [x] Lectura de PROCED-DEVOPS-001 (deployment procedimiento)
- [x] Lectura de README procedimientos (`docs/gobernanza/procedimientos/README.md`)
- [x] Conocimiento de Vagrant/VirtualBox
- [x] Acceso a docs/infraestructura/vagrant-dev/

---

## Contenido a Crear

### Archivo Principal

**Ubicación**: `/home/user/IACT/docs/infraestructura/procedimientos/PROCED-INFRA-001-provision-vm-vagrant.md`

**Estructura Requerida**:

```
1. Frontmatter YAML (metadatos)
2. Título: PROCED-INFRA-001
3. Objetivo (CÓMO provisionar VM paso a paso)
4. Alcance (qué cubre y qué no)
5. Pre-requisitos (Vagrant, VirtualBox, etc.)
6. Roles y Responsabilidades
7. Procedimiento Detallado (7-10 pasos)
   - Paso 1: Verificar prerequisitos
   - Paso 2: Crear/obtener Vagrantfile
   - Paso 3: Configurar bootstrap.sh
   - Paso 4: Ejecutar vagrant up
   - Paso 5: Verificar provisión
   - Paso 6: SSH y validaciones
   - Paso 7: Crear snapshot
   - Paso 8: Tests finales
8. Comandos Exactos (copy-paste listos)
9. Validaciones por Paso
10. Troubleshooting (problemas comunes + soluciones)
11. Rollback (cómo deshacer)
12. Criterios de Éxito
13. Tiempo Estimado
14. Checklist
15. Historial de Cambios
```

---

## Sub-tareas

### 1. Analizar estructura de procedimientos
- [ ] Leer PROCED-GOB-002 (estructura, formato, contenido)
- [ ] Leer PROCED-DEVOPS-001 (pasos detallados, comandos, validaciones)
- [ ] Leer README de procedimientos (diferencia proceso vs procedimiento)

### 2. Razonar sobre pasos de provisión
- [ ] Identificar pasos técnicos reales
- [ ] Definir comandos exactos
- [ ] Identificar posibles problemas
- [ ] Definir validaciones por paso

### 3. Crear procedimiento PROCED-INFRA-001
- [ ] Crear archivo en `docs/infraestructura/procedimientos/`
- [ ] Agregar frontmatter YAML (id, tipo, versión, etc.)
- [ ] Documentar objetivo y alcance
- [ ] Documentar pre-requisitos (Vagrant 2.3+, VirtualBox 6+)
- [ ] Documentar roles y responsabilidades
- [ ] Documentar pasos detallados (7-10 pasos)
- [ ] Agregar comandos exactos (listos para copy-paste)
- [ ] Documentar validaciones por paso
- [ ] Agregar troubleshooting (mín. 5 problemas comunes)
- [ ] Agregar rollback (cómo deshacer)
- [ ] Agregar criterios de éxito
- [ ] Agregar checklist
- [ ] Agregar historial de cambios

### 4. Validar contenido
- [ ] Procedimiento describe COMO (pasos), no QUE (procesos)
- [ ] Todos los comandos son ejecutables
- [ ] Criterios de éxito son claros y verificables
- [ ] Troubleshooting es práctico
- [ ] Rollback es posible
- [ ] Formato es consistente con otros procedimientos

### 5. Crear evidencia
- [ ] Guardar archivo creado
- [ ] Commit con mensaje descriptivo
- [ ] Actualizar este README con evidencia

---

## Pasos de Provisión (Razonamiento)

**Análisis de pasos reales basado en Vagrant workflow**:

1. **Verificar Prerequisitos** (5-10 min)
   - Validar Vagrant versión >= 2.3.0
   - Validar VirtualBox versión >= 6.0
   - Validar plugins necesarios

2. **Crear/Obtener Vagrantfile** (2-5 min)
   - Obtener Vagrantfile de repositorio
   - O crear nuevo desde plantilla
   - Validar sintaxis Ruby

3. **Configurar bootstrap.sh** (5-10 min)
   - Revisar script de aprovisionamiento
   - Validar permisos de ejecución
   - Preparar variables de entorno

4. **Ejecutar vagrant up** (10-20 min)
   - Descargar base box si es necesario
   - Crear VM en VirtualBox
   - Ejecutar aprovisionamiento
   - Port forwarding configurado

5. **Verificar Provisión** (5-10 min)
   - SSH a la VM
   - Verificar servicios corriendo
   - Verificar directorios/archivos creados

6. **Validaciones de Servicios** (5-10 min)
   - Test PostgreSQL conexión
   - Test MariaDB conexión
   - Test scripts instalados

7. **Crear Snapshot** (2-5 min)
   - Pausar VM
   - Crear snapshot de estado limpio
   - Reanudar VM

8. **Tests Finales** (10-15 min)
   - Ejecutar test suite bootstrap_test.sh
   - Verificar health checks
   - Verificar datos de prueba (seed)

**Tiempo Total Estimado**: 45-90 minutos (primer run)

---

## Criterios de Éxito de la Tarea

- [x] Archivo PROCED-INFRA-001-provision-vm-vagrant.md creado
- [x] Frontmatter YAML completo y correcto
- [x] Descripción de objetivo (CÓMO, no QUE)
- [x] Alcance y pre-requisitos definidos
- [x] 8-10 pasos documentados con detalle
- [x] Todos los pasos tienen comandos ejecutables
- [x] Mínimo 5 problemas comunes documentados con solución
- [x] Rollback claramente documentado
- [x] Criterios de éxito verificables
- [x] Validaciones por paso
- [x] Checklist de provisión
- [x] Formato consistente con PROCED-GOB-002 y PROCED-DEVOPS-001
- [x] Sin emojis en el contenido
- [x] Historial de cambios incluido

---

## Validación Final

Para validar que la tarea está completa:

```bash
# 1. Verificar archivo existe
test -f /home/user/IACT/docs/infraestructura/procedimientos/PROCED-INFRA-001-provision-vm-vagrant.md && echo "OK: Archivo existe"

# 2. Verificar frontmatter YAML
grep -q "id: PROCED-INFRA-001" /home/user/IACT/docs/infraestructura/procedimientos/PROCED-INFRA-001-provision-vm-vagrant.md && echo "OK: ID correcto"

# 3. Verificar contiene secciones principales
grep -q "## Objetivo" /home/user/IACT/docs/infraestructura/procedimientos/PROCED-INFRA-001-provision-vm-vagrant.md && echo "OK: Tiene Objetivo"
grep -q "## Pre-requisitos" /home/user/IACT/docs/infraestructura/procedimientos/PROCED-INFRA-001-provision-vm-vagrant.md && echo "OK: Tiene Pre-requisitos"
grep -q "## Procedimiento Detallado" /home/user/IACT/docs/infraestructura/procedimientos/PROCED-INFRA-001-provision-vm-vagrant.md && echo "OK: Tiene Procedimiento"
grep -q "## Troubleshooting" /home/user/IACT/docs/infraestructura/procedimientos/PROCED-INFRA-001-provision-vm-vagrant.md && echo "OK: Tiene Troubleshooting"
grep -q "## Rollback" /home/user/IACT/docs/infraestructura/procedimientos/PROCED-INFRA-001-provision-vm-vagrant.md && echo "OK: Tiene Rollback"

# 4. Verificar pasos (al menos 8)
paso_count=$(grep -c "### Paso [0-9]" /home/user/IACT/docs/infraestructura/procedimientos/PROCED-INFRA-001-provision-vm-vagrant.md)
if [ $paso_count -ge 8 ]; then echo "OK: $paso_count pasos encontrados"; else echo "ERROR: Solo $paso_count pasos"; fi

# 5. Verificar criterios de éxito
grep -q "## Criterios de Éxito" /home/user/IACT/docs/infraestructura/procedimientos/PROCED-INFRA-001-provision-vm-vagrant.md && echo "OK: Tiene Criterios de Éxito"

# 6. Verificar checklist
grep -q "## Checklist" /home/user/IACT/docs/infraestructura/procedimientos/PROCED-INFRA-001-provision-vm-vagrant.md && echo "OK: Tiene Checklist"
```

---

## Historial de Ejecución

**Inicio de Tarea**: 2025-11-18 12:45 UTC
**Estimado Fin**: 2025-11-18 17:45 UTC

---

## Notas Importantes

- **Procedimiento vs Proceso**: Este procedimiento es CÓMO (pasos detallados), no QUÉ (visión general)
- **Comandos Copy-Paste**: Todos los comandos deben ser ejecutables tal cual
- **Validaciones Prácticas**: Cada validación debe ser verificable
- **Troubleshooting Real**: Problemas basados en experiencia real
- **Rollback Claro**: Debe ser posible deshacer todo
- **Sin Emojis**: Mantener professionalism

---

## Dependencias

- [x] TASK-REORG-INFRA-039 (tarea anterior)
- [x] Documentos base: docs/gobernanza/procedimientos/README.md
- [x] Documentos de referencia: PROCED-GOB-002, PROCED-DEVOPS-001
- [x] Vagrant development docs: docs/infraestructura/vagrant-dev/README.md

---

**Versión:** 1.0.0
**Técnica de Prompting:** Decomposed Prompting + Auto-CoT + Self-Consistency
**Estado:** PENDIENTE → EN_PROGRESO → COMPLETADA
**Última Actualización:** 2025-11-18
