---
id: FASE-4-VALIDACION
tipo: fase
categoria: validacion_limpieza
titulo: FASE 4 - Validación y Limpieza de Infraestructura
descripcion: Cuatro tareas críticas para validar integridad completa de documentación
fase: FASE_4_VALIDACION_Y_LIMPIEZA
duracion_total: 14h
estado: pendiente
dependencias: [FASE-3-CONSOLIDACION]
tecnicas: [Auto-CoT, Self-Consistency, Chain-of-Verification]
---

# FASE 4: VALIDACIÓN Y LIMPIEZA

## Descripción Ejecutiva

La FASE 4 comprende cuatro tareas críticas de validación que garantizan la integridad completa de la documentación de infraestructura tras la reorganización realizada en FASE 3. Cada tarea utiliza técnicas de prompting avanzadas (Auto-CoT + Self-Consistency) para validación múltiple y confiable.

**Duración Total**: 14 horas
**Prioridad**: CRÍTICA (P0) y ALTA (P1)
**Prerequisitos**: FASE 3 completada
**Métricas de Éxito**: 100%, 100%, 90%+, 95%+ según tarea

---

## Tareas de FASE 4

### TASK-062: Validar Integridad de Enlaces (4h)

**Prioridad**: CRÍTICA (P0)
**Técnica**: Chain-of-Verification + Self-Consistency
**Meta**: 100% enlaces válidos (0 rotos)

**Descripción Breve:**
Ejecutar validación completa de enlaces internos en toda la documentación de infraestructura. Identificar y corregir todos los enlaces rotos causados por reorganización o cambios de estructura.

**Componentes:**
- **Herramienta**: Script `/scripts/qa/validate_links.sh`
- **Input**: Directorio `/docs/infraestructura`
- **Output**: Reporte de validación + lista de correcciones

**Metodología:**

```
Chain-of-Verification:
├─ Paso 1: Validación Inicial (Línea Base)
│  ├─ Ejecutar script con output detallado
│  ├─ Capturar resultados iniciales
│  └─ Documentar baseline
│
├─ Paso 2: Análisis y Correcciones
│  ├─ Categorizar tipos de errores
│  ├─ Buscar ubicación correcta de archivos movidos
│  └─ Aplicar correcciones controladamente
│
└─ Paso 3: Re-validación
   ├─ Ejecutar script nuevamente
   ├─ Verificar 0 enlaces rotos
   └─ Documentar cambios exitosos

Self-Consistency (Enfoque Múltiple):
├─ Enfoque 1: Validación cuantitativa (métricas)
├─ Enfoque 2: Validación cualitativa (categorización)
└─ Enfoque 3: Validación cruzada (manual spot-check)
```

**Criterios de Aceptación:**
- [ ] 0 enlaces rotos en documentación crítica
- [ ] ≥95% enlaces válidos en documentación general
- [ ] Todas las correcciones documentadas
- [ ] Self-Consistency convergencia confirmada
- [ ] Chain-of-Verification completada (3 pasos)

**Entregables:**
- `evidencias/01-validacion-inicial.log` - Validación inicial
- `evidencias/02-analisis-hallazgos.md` - Análisis categorizado
- `evidencias/03-correcciones-aplicadas.md` - Lista de cambios
- `evidencias/04-validacion-final-reporte.json` - Reporte final
- `evidencias/05-self-consistency-validacion.md` - Convergencia de enfoques

**Línea Base (Antes):**
```
Total archivos: XXX
Enlaces válidos: YYY
Enlaces rotos: ZZZ
Enlaces externos: NNN
```

**Meta (Después):**
```
Total archivos: XXX
Enlaces válidos: ≥99%
Enlaces rotos: 0
Enlaces externos: NNN
```

---

### TASK-063: Validar READMEs 100% Cobertura (4h)

**Prioridad**: CRÍTICA (P0)
**Técnica**: Self-Consistency + Auto-CoT
**Meta**: 100% carpetas tienen README completo

**Descripción Breve:**
Garantizar que todas las carpetas de documentación de infraestructura tienen README.md completo con estructura consistente, frontmatter YAML, y descripción clara del propósito.

**Componentes:**
- **Input**: Directorio `/docs/infraestructura` (todas las carpetas)
- **Validación**: Presencia + Completitud + Frontmatter
- **Output**: Inventario de READMEs + Reporte de cobertura

**Metodología:**

```
Self-Consistency (Enfoque Múltiple):
├─ Enfoque 1: Búsqueda Sistemática (find)
│  ├─ find -name "README.md"
│  ├─ find -iname "readme.md"
│  └─ find -name "README*"
│
├─ Enfoque 2: Búsqueda por Contenido
│  ├─ Búsqueda por frontmatter YAML
│  ├─ Búsqueda por estructura markdown
│  └─ Validación de contenido mínimo
│
└─ Enfoque 3: Validación Manual
   ├─ Seleccionar 10% de carpetas
   ├─ Verificar manualmente
   └─ Documentar hallazgos

Auto-CoT:
├─ Entender: Propósito de READMEs
├─ Mapear: Estructura de carpetas
├─ Buscar: Ubicar READMEs
├─ Analizar: Identificar gaps
├─ Decidir: Qué carpetas necesitan
├─ Crear: READMEs faltantes
├─ Validar: Revalidar cobertura
└─ Documentar: Excepciones
```

**Criterios de Aceptación:**
- [ ] 100% carpetas con contenido tienen README.md
- [ ] 100% READMEs contienen frontmatter YAML válido
- [ ] 100% READMEs contienen descripción de propósito
- [ ] ≥90% READMEs contienen estructura/navegación
- [ ] Self-Consistency convergencia confirmada (3 enfoques)

**Entregables:**
- `evidencias/01-inventario-carpetas-inicial.txt` - Lista de carpetas
- `evidencias/02a-busqueda-find-results.txt` - Resultados de find
- `evidencias/02b-busqueda-contenido-results.txt` - Búsqueda por contenido
- `evidencias/02c-validacion-manual-results.md` - Validación manual
- `evidencias/03-readmes-faltantes.md` - Identificación de gaps
- `evidencias/04-readmes-creados-actualizados.md` - Cambios aplicados
- `evidencias/05-validacion-final-reporte.json` - Reporte final

**Línea Base (Antes):**
```
Total carpetas: XXX
Carpetas con README: YYY (YY%)
Carpetas sin README: ZZZ (ZZ%)
```

**Meta (Después):**
```
Total carpetas: XXX
Carpetas con README: XXX (100%)
Cobertura: 100%
```

---

### TASK-064: Validar Metadatos YAML 90%+ (4h)

**Prioridad**: ALTA (P1)
**Técnica**: Chain-of-Verification + Auto-CoT
**Meta**: ≥90% documentos con frontmatter válido

**Descripción Breve:**
Ejecutar validación de frontmatter YAML en documentos de infraestructura. Corregir metadatos inválidos, campos faltantes, e IDs duplicados. Alcanzar ≥90% de documentos con gobernanza visible.

**Componentes:**
- **Herramienta**: Script `/scripts/qa/validate_frontmatter.py`
- **Input**: Directorio `/docs/infraestructura`
- **Validación**: YAML válido + Campos requeridos + Valores permitidos
- **Output**: Reporte de cobertura de metadatos

**Metodología:**

```
Chain-of-Verification:
├─ Paso 1: Validación Inicial (Línea Base)
│  ├─ Ejecutar script con verbose
│  ├─ Ejecutar script con JSON
│  └─ Capturar métricas iniciales
│
├─ Paso 2: Análisis y Correcciones
│  ├─ Categorizar tipos de errores
│  ├─ Priorizar correcciones (YAML → IDs → Campos)
│  └─ Aplicar cambios graduados
│
└─ Paso 3: Re-validación
   ├─ Ejecutar script nuevamente
   ├─ Comparar métricas
   └─ Confirmar meta ≥90%

Auto-CoT:
├─ Entender: Propósito de metadatos
├─ Preparar: Script y validación
├─ Ejecutar: Línea base
├─ Analizar: Categorizar errores
├─ Planificar: Estrategia de corrección
├─ Corregir: Aplicar cambios
├─ Re-validar: Verificar mejoras
└─ Documentar: Excepciones

Self-Consistency:
├─ Enfoque 1: 3 ejecuciones independientes
├─ Enfoque 2: Validación manual de muestra
└─ Enfoque 3: Análisis de patrones
```

**Campos Requeridos:**
```yaml
id: IDENTIFICADOR-UNICO
tipo: [tarea|documentacion|adr|procedimiento]
titulo: "Descripción breve"
estado: [pendiente|en_progreso|completada|archivado]
categoria: [arquitectura|procedimiento|configuracion]
```

**Criterios de Aceptación:**
- [ ] ≥90% documentos con frontmatter YAML válido
- [ ] 0 YAML inválido (sintaxis correcta en 100%)
- [ ] 0 IDs duplicados
- [ ] Campos requeridos en ≥90% de documentos
- [ ] Valores válidos según enumeración definida
- [ ] Self-Consistency convergencia confirmada
- [ ] Chain-of-Verification completada

**Entregables:**
- `evidencias/01-validacion-inicial.log` - Validación inicial
- `evidencias/01-validacion-inicial.json` - Métricas en JSON
- `evidencias/02-analisis-hallazgos.md` - Análisis categorizado
- `evidencias/03-plan-correcciones.md` - Plan de acción
- `evidencias/04-correcciones-aplicadas.md` - Cambios realizados
- `evidencias/05-validacion-final.json` - Reporte final
- `evidencias/06-excepciones-documentadas.md` - Documentación de excepciones
- `evidencias/07-self-consistency-reporte.md` - Convergencia de enfoques

**Línea Base (Antes):**
```
Total archivos: XXX
Frontmatter válido: YYY (YY%)
Errores: ZZZ
```

**Meta (Después):**
```
Total archivos: XXX
Frontmatter válido: ≥90%
Errores: Minimizados
Excepciones documentadas: Sí
```

---

### TASK-065: Validar Nomenclatura snake_case (2h)

**Prioridad**: ALTA (P1)
**Técnica**: Auto-CoT + Self-Consistency
**Meta**: ≥95% archivos/carpetas en snake_case

**Descripción Breve:**
Validar que archivos y carpetas en infraestructura siguen convención snake_case (lowercase-with-dashes). Cambiar nombres inválidos, actualizar referencias, documentar excepciones permitidas.

**Componentes:**
- **Herramienta**: Script `/scripts/qa/validate_naming.sh`
- **Input**: Directorio `/docs/infraestructura`
- **Validación**: Nomenclatura consistente (snake_case)
- **Output**: Reporte de cumplimiento + Cambios aplicados

**Convención:**
```
[COMPLETADO] Válido (snake_case):
- archivo-documento.md
- carpeta-principal
- script-validacion.sh
- index-tareas.json

[ERROR] Inválido:
- archivoDocumento.md (camelCase)
- ARCHIVO-DOCUMENTO.md (UPPERCASE)
- archivo documento.md (espacios)

[COMPLETADO] Excepciones Permitidas:
- README.md, README.en.md
- LICENSE, CHANGELOG
- Dockerfile, docker-compose.yml
- Makefile, .gitignore, .env
```

**Metodología:**

```
Auto-CoT:
├─ Entender: Propósito de convención
├─ Preparar: Script y excepciones
├─ Validar: Línea base
├─ Analizar: Patrones de violación
├─ Categorizar: Por criticidad
├─ Planificar: Orden de cambios
├─ Aplicar: Cambios graduados
├─ Re-validar: Verificar mejoras
└─ Documentar: Excepciones

Self-Consistency (Enfoque Múltiple):
├─ Enfoque 1: Validación por tipo (archivos vs carpetas)
├─ Enfoque 2: Validación manual (20 elementos aleatorios)
└─ Enfoque 3: Análisis histórico (git log patterns)
```

**Criterios de Aceptación:**
- [ ] ≥95% archivos/carpetas en snake_case
- [ ] 0 archivos con espacios en nombre
- [ ] 0 archivos con caracteres especiales problemáticos
- [ ] Excepciones permitidas documentadas
- [ ] Referencias actualizadas si cambios aplicados
- [ ] Self-Consistency convergencia confirmada
- [ ] Chain-of-Verification completada

**Entregables:**
- `evidencias/01-validacion-inicial.log` - Validación inicial
- `evidencias/01-validacion-inicial-verbose.log` - Detalles del script
- `evidencias/02-analisis-patrones-nomenclatura.md` - Patrones identificados
- `evidencias/03-plan-cambios-nomenclatura.md` - Plan de renombraciones
- `evidencias/04-cambios-aplicados.md` - Cambios realizados
- `evidencias/05-validacion-final.log` - Re-validación
- `evidencias/06-excepciones-documentadas.md` - Excepciones justificadas
- `evidencias/07-self-consistency-reporte.md` - Convergencia de enfoques
- `evidencias/08-reporte-final.json` - Reporte final

**Línea Base (Antes):**
```
Total elementos: XXX
Válidos (snake_case): YYY (YY%)
Inválidos: ZZZ (ZZ%)
```

**Meta (Después):**
```
Total elementos: XXX
Válidos: ≥95%
Excepciones documentadas: Sí
```

---

## Técnicas de Prompting Utilizadas

### 1. Auto-CoT (Chain-of-Thought)

**Concepto**: Razonamiento paso a paso que descompone el problema en etapas lógicas.

**Aplicación en FASE 4:**
- Entender el propósito de cada validación
- Preparar ambiente y herramientas
- Ejecutar validación inicial
- Analizar resultados
- Planificar correcciones
- Aplicar cambios
- Re-validar
- Documentar conclusiones

**Ventaja**: Explicitud del razonamiento permite verificación y corrección de pasos individuales.

---

### 2. Self-Consistency

**Concepto**: Validación mediante múltiples enfoques independientes que llegan a la misma conclusión.

**Aplicación en FASE 4:**

**TASK-062 (Enlaces):**
- Enfoque 1: Validación cuantitativa (contar enlaces)
- Enfoque 2: Validación cualitativa (categorizar errores)
- Enfoque 3: Validación cruzada (manual spot-check)

**TASK-063 (READMEs):**
- Enfoque 1: Búsqueda sistemática (find command)
- Enfoque 2: Búsqueda por contenido (análisis de archivos)
- Enfoque 3: Validación manual (spot-check 10%)

**TASK-064 (YAML):**
- Enfoque 1: Validación automática (3 ejecuciones)
- Enfoque 2: Validación manual (10 muestras)
- Enfoque 3: Análisis de patrones

**TASK-065 (Nomenclatura):**
- Enfoque 1: Validación por tipo (archivos vs carpetas)
- Enfoque 2: Validación manual (20 muestras)
- Enfoque 3: Análisis histórico (git log)

**Ventaja**: Convergencia de enfoques independientes aumenta confianza en resultados.

---

### 3. Chain-of-Verification (CoVe)

**Concepto**: Validación en múltiples pasos verificables que forma cadena de confianza.

**Aplicación en FASE 4:**

**Estructura General:**
```
Paso 1: Validación Inicial (Línea Base)
   ├─ Ejecutar validación completa
   ├─ Capturar resultados detallados
   └─ Documentar estado actual

Paso 2: Análisis y Correcciones
   ├─ Categorizar problemas encontrados
   ├─ Planificar soluciones
   └─ Aplicar cambios controladamente

Paso 3: Re-validación y Documentación
   ├─ Ejecutar validación nuevamente
   ├─ Comparar con línea base
   └─ Documentar mejoras
```

**Ventaja**: Cada paso es verificable y reversible, permitiendo auditoría completa del proceso.

---

## Integración de Técnicas

```
Auto-CoT (Descomposición)
    ↓
Define estructura paso a paso
    ↓
Chain-of-Verification (Validación)
    ↓
Implementa pasos verificables
    ↓
Self-Consistency (Convergencia)
    ↓
Valida con múltiples enfoques
    ↓
Conclusión Confiable
```

---

## Cronograma de Ejecución

### Día 1 (Lunes)
- **TASK-062**: Validar integridad de enlaces (4h)
  - 09:00 - Preparación y validación inicial (1h)
  - 10:00 - Análisis de hallazgos (1h)
  - 11:00 - Correcciones (1.5h)
  - 12:30 - Re-validación y documentación (0.5h)

### Día 2 (Martes)
- **TASK-063**: Validar READMEs (4h)
  - 09:00 - Búsqueda inicial (enfoque 1) (1h)
  - 10:00 - Búsqueda alternativa (enfoques 2-3) (1.5h)
  - 11:30 - Creación de READMEs faltantes (1h)
  - 12:30 - Re-validación (0.5h)

### Día 3 (Miércoles)
- **TASK-064**: Validar metadatos YAML (4h)
  - 09:00 - Validación inicial (0.5h)
  - 09:30 - Análisis de errores (1h)
  - 10:30 - Correcciones YAML/IDs (1.5h)
  - 12:00 - Re-validación y Self-Consistency (1h)

### Día 4 (Jueves)
- **TASK-065**: Validar nomenclatura (2h)
  - 09:00 - Validación inicial (0.5h)
  - 09:30 - Análisis de patrones (0.5h)
  - 10:00 - Aplicación de cambios (0.5h)
  - 10:30 - Re-validación y documentación (0.5h)

### Día 5 (Viernes)
- **Revisión y Cierre de FASE 4** (4h disponibles)
  - Validación cruzada de todas las tareas
  - Generación de reporte integrado
  - Preparación para FASE 5

---

## Métricas de Éxito

| Tarea | Métrica | Línea Base | Meta | Técnica |
|-------|---------|-----------|------|---------|
| TASK-062 | Enlaces rotos | XXX | 0 | CoVe |
| TASK-062 | Cobertura de enlace | YY% | 100% | Self-Consistency |
| TASK-063 | Cobertura de README | XX% | 100% | Self-Consistency |
| TASK-063 | Frontmatter YAML | ZZ% | 100% | Auto-CoT |
| TASK-064 | Metadatos válidos | AA% | ≥90% | CoVe |
| TASK-064 | YAML válido | BB% | 100% | Self-Consistency |
| TASK-064 | IDs duplicados | CC | 0 | Auto-CoT |
| TASK-065 | Nomenclatura correcta | DD% | ≥95% | Self-Consistency |
| TASK-065 | Excepciones documentadas | No | Sí | Auto-CoT |

---

## Dependencias Entre Tareas

```
FASE 3 (Consolidación)
    ↓
TASK-062 (Enlaces)
    ↓
TASK-063 (READMEs)
    ↓
TASK-064 (Metadatos YAML)
    ↓
TASK-065 (Nomenclatura)
    ↓
FASE 5 (Documentación Final)
```

**Nota**: Aunque hay un orden lógico recomendado, las tareas pueden ejecutarse en paralelo en algunas fases si se tienen recursos disponibles.

---

## Documentación de Referencia

Cada tarea tiene su propio README.md con:
- Descripción detallada del propósito
- Auto-CoT paso a paso
- Self-Consistency con múltiples enfoques
- Chain-of-Verification con 3 pasos
- Criterios de aceptación explícitos
- Entregables específicos
- Checklist de ejecución
- Guía de ejecución rápida
- Ejemplos de comandos

**Ubicaciones:**
- `/docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-062-validar-integridad-enlaces/README.md`
- `/docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-063-validar-readmes-cobertura/README.md`
- `/docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-064-validar-metadatos-yaml/README.md`
- `/docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/TASK-065-validar-nomenclatura-snake-case/README.md`

---

## Outputs Integrados

Al completar FASE 4, se generará:

1. **Reporte Ejecutivo de FASE 4**
   - Resumen de cada tarea
   - Métricas finales alcanzadas
   - Problemas encontrados y solucionados
   - Recomendaciones para FASE 5

2. **Dashboard de Gobernanza**
   - Cobertura de documentación (100%)
   - Cobertura de metadatos (≥90%)
   - Integridad de enlaces (100%)
   - Cumplimiento de nomenclatura (≥95%)

3. **Matriz de Evidencias**
   - Todas las evidencias organizadas por tarea
   - Referencias cruzadas
   - Trazabilidad de cambios

---

## Notas Importantes

- **Automatización**: Usar scripts siempre que sea posible para reproducibilidad
- **Documentación**: Cada cambio debe estar documentado
- **Reversibilidad**: Mantener copias de versiones anteriores si es necesario
- **Convergencia**: Verificar que múltiples enfoques llegan a misma conclusión
- **Excepciones**: Documentar y justificar cualquier excepción a las reglas
- **Verificación**: Cada paso debe ser verificable por una segunda persona

---

## Próximas Fases

Una vez completada FASE 4:

- **FASE 5**: Documentación Final y Cierre
- **FASE 6**: Gobernanza y Seguimiento (opcional)

---

## Contactos y Responsabilidades

- **Ejecutor Principal**: @qa-engineer
- **Revisor**: @tech-lead
- **Aprobador**: @project-owner
- **Documentación**: Equipo de QA

---

## Referencias Técnicas

- **Scripts**: `/home/user/IACT/scripts/qa/`
- **Documentación**: `/docs/ai/prompting/`
- **Técnicas**:
  - Auto-CoT: Wei et al. (2022)
  - Self-Consistency: Wang et al. (2022)
  - Chain-of-Verification: Técnica de auditoría
