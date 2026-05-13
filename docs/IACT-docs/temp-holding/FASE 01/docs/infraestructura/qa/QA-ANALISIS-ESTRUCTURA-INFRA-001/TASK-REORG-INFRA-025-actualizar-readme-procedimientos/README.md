---
id: TASK-REORG-INFRA-025
titulo: Actualizar README procedimientos/
fase: FASE_2_REORGANIZACION_CRITICA
subcategoria: Actualizar READMEs Vacios
prioridad: CRITICA (P0)
duracion_estimada: 2 horas
estado: Pendiente
tipo: Documentacion
dependencias:
  - FASE_1_completada
tecnica_prompting: Chain-of-Thought (CoT)
fecha_creacion: 2025-11-18
autor: QA Infraestructura
tags:
  - documentacion
  - readme
  - procedimientos
  - fase-2
---

# TASK-REORG-INFRA-025: Actualizar README procedimientos/

## Descripción

Actualizar el README actualmente vacío de la carpeta `/docs/infraestructura/procedimientos/` con contenido completo que describa el propósito, estructura, nomenclatura y contenido de los procedimientos operativos de infraestructura.

## Objetivo

Crear documentación completa para la carpeta `procedimientos/` que sirva como guía para entender, navegar y crear nuevos procedimientos operativos de infraestructura.

## Técnica de Prompting: Chain-of-Thought (CoT)

### Aplicación de Chain-of-Thought

**Chain-of-Thought (CoT)** documenta el razonamiento paso a paso para estructurar y completar el README, asegurando que toda la información necesaria esté presente y bien organizada.

#### Razonamiento para Estructura del README

```
PREGUNTA: ¿Qué debe contener un README de carpeta procedimientos/?

PASO 1: Identificar Audiencia
├─ ¿Quién leerá este README?
│   ├─ Desarrolladores que ejecutan procedimientos
│   ├─ DevOps que crean nuevos procedimientos
│   └─ QA que valida procedimientos
└─ Conclusión: Necesita ser técnico pero accesible

PASO 2: Identificar Propósito de Procedimientos
├─ ¿Qué es un procedimiento?
│   → Documento paso a paso para operación específica
├─ ¿En qué se diferencia de un proceso?
│   → Proceso = flujo conceptual
│   → Procedimiento = pasos ejecutables específicos
└─ Conclusión: Enfatizar naturaleza ejecutable

PASO 3: Definir Nomenclatura
├─ ¿Cómo nombrar procedimientos?
│   → PROCED-INFRA-XXX-nombre-descriptivo.md
├─ ¿Por qué esta convención?
│   ├─ PROCED: Identifica como procedimiento
│   ├─ INFRA: Ámbito de infraestructura
│   ├─ XXX: Número secuencial para orden
│   └─ nombre-descriptivo: snake_case para claridad
└─ Conclusión: Documentar convención y razones

PASO 4: Crear Índice de Procedimientos
├─ ¿Qué procedimientos existen?
│   → Listar procedimientos actuales en carpeta
├─ ¿Cómo categorizarlos?
│   ├─ Por tipo: Provisión, Configuración, Mantenimiento
│   ├─ Por componente: VM, DevContainer, CI/CD
│   └─ Por frecuencia: Diario, Semanal, Eventual
└─ Conclusión: Usar tabla con categorías claras

PASO 5: Documentar Plantilla
├─ ¿Cómo crear nuevo procedimiento?
│   → Plantilla en /plantillas/procedimientos/
├─ ¿Qué secciones tiene?
│   ├─ Frontmatter YAML
│   ├─ Descripción y objetivo
│   ├─ Prerrequisitos
│   ├─ Pasos detallados
│   ├─ Verificación
│   └─ Troubleshooting
└─ Conclusión: Referenciar plantilla y explicar secciones

RESULTADO: README con 5 secciones principales
1. Propósito de Procedimientos
2. Nomenclatura y Convenciones
3. Índice de Procedimientos Existentes
4. Estructura de Plantilla
5. Cómo Crear Nuevo Procedimiento
```

## Pasos de Ejecución

### 1. Analizar Contenido Actual de Carpeta (20 min)

```bash
cd /home/user/IACT/docs/infraestructura/procedimientos

# Listar procedimientos existentes
ls -la *.md 2>/dev/null | tee /tmp/procedimientos-existentes.txt

# Analizar cada procedimiento
for file in PROCED-INFRA-*.md; do
  if [ -f "$file" ]; then
    echo "=== $file ===" >> /tmp/analisis-procedimientos.txt
    # Extraer título del frontmatter o primer encabezado
    grep -m1 "^titulo:" "$file" || grep -m1 "^# " "$file" >> /tmp/analisis-procedimientos.txt
    echo "" >> /tmp/analisis-procedimientos.txt
  fi
done

# Identificar categorías naturales
echo "Categorías identificadas:" >> /tmp/analisis-procedimientos.txt
ls PROCED-INFRA-*.md 2>/dev/null | sed 's/PROCED-INFRA-[0-9]*-//;s/.md//' | \
  cut -d'-' -f1 | sort -u >> /tmp/analisis-procedimientos.txt
```

**CoT - Razonamiento:**
```
ANÁLISIS: ¿Qué procedimientos tenemos?
- Si hay PROCED-INFRA-001-provision-vm.md
  → Categoría: Provisión
- Si hay PROCED-INFRA-002-config-devcontainer.md
  → Categoría: Configuración
- Si hay PROCED-INFRA-003-backup-datos.md
  → Categoría: Mantenimiento

PATRÓN DETECTADO:
- Procedimientos siguen nomenclatura consistente
- Nombres descriptivos indican acción (provision, config, backup)
- Posible categorización por verbo de acción

DECISIÓN:
Crear índice categorizado por tipo de operación
```

### 2. Diseñar Estructura del README (30 min)

**Estructura Propuesta (CoT):**

```markdown
# README Procedimientos de Infraestructura

## 1. Propósito
[¿Para qué sirve esta carpeta?]

## 2. ¿Qué es un Procedimiento?
[Definición y diferencia con proceso]

## 3. Nomenclatura y Convenciones
[PROCED-INFRA-XXX-nombre-descriptivo.md]

## 4. Índice de Procedimientos
[Tabla categorizada]

## 5. Estructura de Procedimientos
[Secciones de plantilla]

## 6. Cómo Crear Nuevo Procedimiento
[Pasos para usar plantilla]

## 7. Relación con Otras Carpetas
[Enlaces a procesos/, plantillas/, etc.]
```

**Razonamiento de Diseño:**
```
PREGUNTA: ¿Por qué este orden de secciones?

1. Propósito PRIMERO
   → Usuario necesita contexto inmediato
   → "¿Estoy en el lugar correcto?"

2. Definiciones SEGUNDO
   → Aclarar conceptos antes de convenciones
   → Evitar confusión procedimiento vs proceso

3. Nomenclatura TERCERO
   → Usuario ahora entiende qué es, puede aprender cómo nombrar
   → Preparación para entender índice

4. Índice CUARTO
   → Con contexto previo, puede navegar efectivamente
   → Lista de procedimientos tiene sentido

5. Estructura QUINTO
   → Usuario ya vio ejemplos, ahora aprende plantilla
   → Preparación para creación

6. Creación SEXTO
   → Culminación: cómo contribuir
   → Usuarios avanzados llegan aquí

7. Relaciones ÚLTIMO
   → Navegación a contenido relacionado
   → Para exploración adicional
```

### 3. Redactar Contenido del README (60 min)

```bash
# Crear README con contenido completo
cat > README.md << 'EOF'
---
tipo: readme
carpeta: procedimientos
proposito: Documentar procedimientos operativos de infraestructura
fecha_actualizacion: 2025-11-18
responsable: QA Infraestructura
---

# README: Procedimientos de Infraestructura

## Propósito

Esta carpeta contiene **procedimientos operativos** de infraestructura: guías paso a paso para ejecutar operaciones específicas relacionadas con la infraestructura del proyecto IACT.

**Objetivos:**
- Estandarizar operaciones de infraestructura
- Documentar pasos ejecutables y verificables
- Facilitar onboarding de nuevos miembros del equipo
- Reducir errores operativos mediante procedimientos probados
- Mantener conocimiento operativo centralizado

## ¿Qué es un Procedimiento?

Un **procedimiento** es un documento detallado que describe **cómo ejecutar una operación específica**, paso a paso.

### Diferencia: Proceso vs Procedimiento

| Aspecto | Proceso | Procedimiento |
|---------|---------|---------------|
| **Nivel** | Conceptual, alto nivel | Operativo, bajo nivel |
| **Contenido** | Flujo, fases, responsabilidades | Pasos concretos, comandos |
| **Objetivo** | Describir QUÉ hacer y CUÁNDO | Describir CÓMO hacer exactamente |
| **Ejemplo** | "Proceso de CI/CD DevContainer" | "Procedimiento: Configurar Jenkins Pipeline" |
| **Carpeta** | `/procesos/` | `/procedimientos/` |

**Regla simple:**
- **Proceso** = Diagrama de flujo
- **Procedimiento** = Checklist ejecutable

## Nomenclatura y Convenciones

### Formato de Nombres

```
PROCED-INFRA-XXX-nombre-descriptivo-operacion.md
```

**Componentes:**
- `PROCED`: Prefijo que identifica documento como procedimiento
- `INFRA`: Ámbito de infraestructura
- `XXX`: Número secuencial (001, 002, 003...)
- `nombre-descriptivo-operacion`: Descripción en snake_case

**Ejemplos válidos:**
- `PROCED-INFRA-001-provision-vm-vagrant.md`
- `PROCED-INFRA-002-configurar-devcontainer-vscode.md`
- `PROCED-INFRA-003-backup-configuraciones-infraestructura.md`

### Convenciones de Contenido

Cada procedimiento debe incluir:
1. **Frontmatter YAML completo** (ver plantilla)
2. **Objetivo claro** (¿qué logra este procedimiento?)
3. **Prerrequisitos** (¿qué se necesita antes de ejecutar?)
4. **Pasos numerados** (instrucciones ejecutables)
5. **Verificación** (¿cómo confirmar éxito?)
6. **Troubleshooting** (problemas comunes y soluciones)

## Índice de Procedimientos

### Por Categoría

#### Provisión de Infraestructura

| ID | Procedimiento | Descripción | Estado |
|----|---------------|-------------|--------|
| PROCED-INFRA-001 | [Provisión VM Vagrant](./PROCED-INFRA-001-provision-vm-vagrant.md) | Crear VM con Vagrant para DevContainer Host | Activo |

#### Configuración de Entornos

| ID | Procedimiento | Descripción | Estado |
|----|---------------|-------------|--------|
| PROCED-INFRA-002 | [Configurar DevContainer](./PROCED-INFRA-002-configurar-devcontainer-vscode.md) | Setup de DevContainer en VS Code | Planificado |

#### Mantenimiento y Operaciones

| ID | Procedimiento | Descripción | Estado |
|----|---------------|-------------|--------|
| PROCED-INFRA-003 | [Backup Configuraciones](./PROCED-INFRA-003-backup-configuraciones-infraestructura.md) | Backup de configs de infraestructura | Planificado |

### Todos los Procedimientos (Alfabético)

[Lista completa de procedimientos en orden alfabético]

## Estructura de Procedimientos

Todos los procedimientos siguen la plantilla estándar ubicada en:
`/docs/infraestructura/plantillas/procedimientos/`

### Secciones Principales

```markdown
---
# Frontmatter YAML
id: PROCED-INFRA-XXX
titulo: [Título descriptivo]
categoria: [Provisión/Configuración/Mantenimiento/etc]
duracion_estimada: [X horas/minutos]
complejidad: [Baja/Media/Alta]
prerrequisitos: [Lista de prerequisitos]
---

# [Título del Procedimiento]

## Objetivo
[¿Qué logra este procedimiento?]

## Alcance
[¿Qué cubre y qué NO cubre?]

## Prerrequisitos
- Requisito 1
- Requisito 2

## Procedimiento

### Paso 1: [Acción]
[Instrucciones detalladas]

### Paso 2: [Acción]
[Instrucciones detalladas]

## Verificación
[¿Cómo confirmar que funcionó?]

## Troubleshooting
[Problemas comunes y soluciones]

## Referencias
[Enlaces relevantes]
```

## Cómo Crear un Nuevo Procedimiento

### Proceso de Creación (CoT)

```
PASO 1: Identificar Necesidad
├─ ¿Qué operación necesita documentarse?
├─ ¿Se ejecuta repetidamente?
└─ ¿Requiere precisión para evitar errores?

PASO 2: Verificar No Existe
├─ Revisar índice de procedimientos existentes
└─ Evitar duplicación

PASO 3: Usar Plantilla
├─ Copiar plantilla desde /plantillas/procedimientos/
└─ Renombrar según convención PROCED-INFRA-XXX

PASO 4: Completar Secciones
├─ Frontmatter con metadatos completos
├─ Objetivo claro y medible
├─ Prerrequisitos específicos
├─ Pasos numerados y ejecutables
├─ Verificación de éxito
└─ Troubleshooting común

PASO 5: Probar Procedimiento
├─ Ejecutar pasos en entorno de prueba
├─ Verificar que instrucciones son suficientes
└─ Ajustar según feedback

PASO 6: Agregar a Índice
├─ Actualizar este README
├─ Agregar entrada en tabla de categoría apropiada
└─ Actualizar tabla alfabética

PASO 7: Commit y PR
├─ Commit con mensaje descriptivo
└─ Crear PR para revisión
```

### Comandos para Crear Procedimiento

```bash
# 1. Obtener próximo número de procedimiento
NEXT_NUM=$(ls -1 PROCED-INFRA-*.md 2>/dev/null | \
           sed 's/PROCED-INFRA-0*//;s/-.*//' | \
           sort -n | tail -1 | awk '{print $1+1}')
NEXT_ID=$(printf "PROCED-INFRA-%03d" $NEXT_NUM)

# 2. Copiar plantilla
cp ../plantillas/procedimientos/plantilla_procedimiento.md \
   ${NEXT_ID}-nombre-descriptivo-operacion.md

# 3. Editar procedimiento
# [Completar contenido según plantilla]

# 4. Actualizar este README
# [Agregar entrada en índice]

# 5. Commit
git add ${NEXT_ID}-*.md README.md
git commit -m "docs(infra): Add ${NEXT_ID} - [descripción]"
```

## Relación con Otras Carpetas

### Carpetas Relacionadas

```
procedimientos/ (esta carpeta)
    ↓ usa plantillas de
plantillas/procedimientos/
    ↓ implementa flujos de
procesos/
    ↓ puede generar tareas en
checklists/
    ↓ relacionado con ops en
devops/
    ↓ puede documentarse en
adr/ (decisiones de procedimientos)
```

**Enlaces Útiles:**
- [Procesos de Infraestructura](../procesos/README.md) - Flujos de alto nivel
- [Plantillas de Procedimientos](../plantillas/procedimientos/) - Templates para crear procedimientos
- [DevOps](../devops/README.md) - Documentación de CI/CD y operaciones
- [Checklists](../checklists/README.md) - Checklists derivados de procedimientos

## Mantenimiento de este README

**Responsable:** QA Infraestructura

**Actualizar cuando:**
- Se crea un nuevo procedimiento → Agregar a índice
- Se modifica un procedimiento → Actualizar descripción si cambió significativamente
- Se depreca un procedimiento → Marcar como "Obsoleto" y agregar referencia a reemplazo
- Cambios en convenciones → Actualizar sección de nomenclatura

**Última actualización:** 2025-11-18
**Próxima revisión:** Trimestral o al agregar 5+ procedimientos nuevos

EOF

echo "[OK] README.md creado exitosamente"
```

### 4. Validar y Refinar README (10 min)

```bash
# Verificar que README fue creado
test -f README.md && echo "[OK] README.md existe" || echo "[ERROR] README.md no encontrado"

# Verificar frontmatter YAML válido
grep -q "^---$" README.md && echo "[OK] Frontmatter presente" || echo "[ERROR] Frontmatter faltante"

# Contar secciones principales (debe tener al menos 6)
SECTIONS=$(grep -c "^## " README.md)
echo "Secciones principales: $SECTIONS"
[ $SECTIONS -ge 6 ] && echo "[OK] Estructura completa" || echo "[WARNING] Verificar secciones"

# Verificar enlaces relativos funcionan
grep -o "](\.\.*/.*\.md)" README.md | while read link; do
  CLEAN_LINK=$(echo "$link" | sed 's/](\.\.\///;s/)$//')
  test -f "../$CLEAN_LINK" && echo "[OK] Enlace válido: $CLEAN_LINK" || echo "[WARNING] Verificar: $CLEAN_LINK"
done
```

## Auto-CoT: Razonamiento Completo Documentado

### Estructura del README

```
PREGUNTA CENTRAL:
¿Cómo crear un README que sea útil TANTO para:
  - Usuario que busca procedimiento específico (navegación)
  - Usuario que quiere entender filosofía de procedimientos (educación)
  - Usuario que quiere crear nuevo procedimiento (contribución)

SOLUCIÓN: Estructura de Embudo
  AMPLIO → Propósito general de carpeta
  MEDIO → Definiciones y conceptos
  ENFOCADO → Índice de procedimientos existentes
  DETALLADO → Cómo usar plantilla
  CONTRIBUTIVO → Cómo crear nuevo procedimiento
  CONEXIONES → Enlaces a contenido relacionado

VALIDACIÓN:
[OK] Usuario casual encuentra lo que busca (índice)
[OK] Usuario nuevo entiende propósito (definiciones)
[OK] Usuario avanzado puede contribuir (proceso de creación)
```

### Nomenclatura

```
DECISIÓN: PROCED-INFRA-XXX-nombre-descriptivo

RAZONAMIENTO:
1. PROCED (no PROC)
   - Evita confusión con carpeta /procesos/
   - Procedimiento tiene más letras que proceso
   - Más explícito

2. INFRA
   - Consistencia con ADR-INFRA-XXX
   - Indica ámbito de infraestructura
   - Permite extensión (PROCED-APP-XXX en futuro)

3. XXX (3 dígitos)
   - Soporta hasta 999 procedimientos
   - Orden alfabético = orden numérico
   - Facilita referencias: "ver PROCED-INFRA-001"

4. snake_case
   - Consistencia con convenciones proyecto
   - Legible en terminal
   - No requiere comillas en comandos
```

## Criterios de Aceptación

- [ ] README.md creado en `/docs/infraestructura/procedimientos/`
- [ ] Frontmatter YAML completo presente
- [ ] Sección "Propósito" claramente descrita
- [ ] Sección "¿Qué es un Procedimiento?" con diferenciación proceso vs procedimiento
- [ ] Nomenclatura PROCED-INFRA-XXX documentada con ejemplos
- [ ] Índice de procedimientos existentes creado (puede estar vacío si no hay procedimientos aún)
- [ ] Estructura de plantilla documentada con secciones principales
- [ ] Proceso de creación de nuevo procedimiento documentado paso a paso
- [ ] Enlaces a carpetas relacionadas funcionan correctamente
- [ ] README sigue convenciones de markdown del proyecto

## Evidencias a Generar

### /docs/infraestructura/procedimientos/README.md

[README completo como se muestra en paso 3]

### evidencias/validacion-readme-procedimientos.txt

```
=== VALIDACIÓN README procedimientos/ ===
Fecha: 2025-11-18

[OK] README.md existe
[OK] Frontmatter YAML presente y válido
[OK] Secciones principales: 7
  - Propósito
  - ¿Qué es un Procedimiento?
  - Nomenclatura y Convenciones
  - Índice de Procedimientos
  - Estructura de Procedimientos
  - Cómo Crear Nuevo Procedimiento
  - Relación con Otras Carpetas

[OK] Nomenclatura documentada: PROCED-INFRA-XXX
[OK] Plantilla referenciada: ../plantillas/procedimientos/
[OK] Enlaces relativos validados:
  - ../procesos/README.md
  - ../plantillas/procedimientos/
  - ../devops/README.md
  - ../checklists/README.md

[OK] VALIDACIÓN EXITOSA
```

## Dependencias

**Requiere completar:**
- FASE 1 completada (estructura de carpetas creada)

**Desbloquea:**
- Creación de procedimientos con nomenclatura estándar
- Navegación efectiva en carpeta procedimientos/

## Notas Importantes

[WARNING] **CRÍTICO - P0**: Este README es punto de entrada para toda la documentación de procedimientos operativos.

 **Tip - Índice Dinámico**: Considerar script para generar índice automáticamente desde frontmatter de procedimientos.

 **Mantenimiento**: Actualizar índice cada vez que se agregue nuevo procedimiento.

## Relación con Otras Tareas

```
TASK-025 (README procedimientos/) ← ESTA TAREA
TASK-026 (README devops/)
TASK-027 (README checklists/)
TASK-028 (README solicitudes/)
    ↓
[Todas completan subcategoría: Actualizar READMEs Vacíos]
```

## Referencias

- LISTADO-COMPLETO-TAREAS.md: Línea 981-1011
- Plantilla de Procedimientos: `/docs/infraestructura/plantillas/procedimientos/`
- Chain-of-Thought: Razonamiento explícito para estructura y nomenclatura
