---
id: DOC-MIGRATION-FROM-LEGACY
estado: activo
propietario: equipo-arquitectura
fecha_creacion: 2025-11-04
relacionados: ["DOC-IMPLEMENTACION-INDEX", "DOC-PROPUESTA-FINAL-REESTRUCTURACION"]
date: 2025-11-13
---
# Guía de Migración desde Estructura Legacy

Esta guía ayuda a migrar requisitos desde la estructura legacy (`docs/backend/requisitos/`, `docs/frontend/requisitos/`, etc.) hacia la nueva estructura unificada en `docs/implementacion/`.

---

## Tabla de Contenidos

1. [Contexto](#contexto)
2. [Estructura Legacy vs Nueva](#estructura-legacy-vs-nueva)
3. [Proceso de Migración](#proceso-de-migración)
4. [Checklist de Migración](#checklist-de-migración)
5. [Ejemplos Prácticos](#ejemplos-prácticos)
6. [Preguntas Frecuentes](#preguntas_frecuentes)

---

## Contexto

### ¿Por qué migrar?

La estructura legacy tenía varios problemas:

PROBLEMA: **Duplicación masiva**: Requisitos repetidos en backend/, frontend/, infrastructure/
PROBLEMA: **Sin trazabilidad**: No había jerarquía clara NECESIDAD → REQUISITO → IMPLEMENTACIÓN
PROBLEMA: **No conforme ISO**: No seguía ISO/IEC/IEEE 29148:2018
PROBLEMA: **Búsqueda difícil**: Requisitos dispersos en múltiples ubicaciones

### Beneficios de la nueva estructura

BENEFICIO: **Source of Truth único**: Un solo lugar para cada requisito
BENEFICIO: **Trazabilidad completa**: Frontmatter YAML con upward/downward
BENEFICIO: **Conforme ISO 29148**: Full conformance auditable
BENEFICIO: **Co-localización con código**: Requisitos cerca de implementación
BENEFICIO: **Índices auto-generados**: BRS, StRS, SyRS, SRS, RTM

---

## Estructura Legacy vs Nueva

### Estructura Legacy (Antigua)

```
docs/
├── backend/
│   ├── requisitos/
│   │   ├── rq_plantilla.md
│   │   ├── trazabilidad.md
│   │   └── _MOVIDO_A_IMPLEMENTACION.md
│   └── [otras carpetas...]
├── frontend/
│   └── requisitos/
│       └── README.md
└── infrastructure/
    └── requisitos/
        └── README.md
```

**Problemas:**
- Sin clasificación BABOK (Business/Stakeholder/Functional/Non-Functional)
- Sin convención de nombrado clara
- Sin trazabilidad estructurada
- Duplicación entre dominios

### Estructura Nueva (Actual)

```
docs/
└── implementacion/
    ├── backend/
    │   └── requisitos/
    │       ├── necesidades/       N-001, N-002
    │       ├── negocio/           RN-001, RN-002
    │       ├── stakeholders/      RS-001, RS-002
    │       ├── funcionales/       RF-001, RF-002
    │       └── no_funcionales/    RNF-001, RNF-002
    ├── frontend/
    │   └── requisitos/
    │       ├── _necesidades_vinculadas.md (enlaza, no duplica)
    │       ├── stakeholders/      RS-010, RS-011
    │       ├── funcionales/       RF-010, RF-011
    │       └── no_funcionales/    RNF-010, RNF-011
    └── infrastructure/
        └── requisitos/
            ├── _necesidades_vinculadas.md (enlaza, no duplica)
            ├── funcionales/       RF-020, RF-021
            └── no_funcionales/    RNF-020, RNF-021
```

**Beneficios:**
- Clasificación clara por tipo BABOK
- Convención de nombrado consistente
- Trazabilidad en frontmatter YAML
- Sin duplicación (necesidades solo en backend)

---

## Proceso de Migración

### Fase 1: Inventario (1-2 días)

1. **Identifica requisitos existentes** en estructura legacy:
   ```bash
   # Buscar archivos de requisitos legacy
   find docs/backend/requisitos -name "*.md" ! -name "README.md"
   find docs/frontend/requisitos -name "*.md" ! -name "README.md"
   find docs/infraestructura/requisitos -name "*.md" ! -name "README.md"
   ```

2. **Crea un inventario** en una hoja de cálculo:
   | Archivo Legacy | Tipo | Dominio | ID Nuevo | Estado |
   |----------------|------|---------|----------|--------|
   | backend/requisitos/api_stock.md | Funcional | backend | RF-001 | Pendiente |

### Fase 2: Clasificación (2-3 días)

Para cada requisito legacy, determina:

1. **¿Qué tipo es?** (según BABOK/ISO 29148)
   - **Necesidad de Negocio** (N-XXX): Problema u oportunidad del negocio
   - **Requisito de Negocio** (RN-XXX): Objetivos y metas organizacionales
   - **Requisito de Stakeholder** (RS-XXX): Necesidades de usuarios específicos
   - **Requisito Funcional** (RF-XXX): Qué debe hacer el sistema
   - **Requisito No Funcional** (RNF-XXX): Cómo debe comportarse (calidad)

2. **¿Qué dominio?**
   - Backend, Frontend, Infrastructure

3. **¿Cuál es su ID único?**
   - Usa rangos: Backend (001-009), Frontend (010-019), Infrastructure (020-029)

### Fase 3: Migración Individual (Iterativa)

Para cada requisito:

#### Paso 1: Crear archivo nuevo

```bash
# Ejemplo: Migrar requisito funcional backend
cd docs/backend/requisitos/funcionales/

# Copiar plantilla
cp ../../../../plantillas/template_requisito_funcional.md rf001_api_calcular_stock.md
```

#### Paso 2: Completar frontmatter YAML

```yaml
---
id: RF-001
tipo: funcional
titulo: API para cálculo de stock mínimo
dominio: backend
owner: equipo-backend
prioridad: alta
estado: implementado

# Trazabilidad Upward
trazabilidad_upward:
  - N-001  # Necesidad: Reducir roturas de stock
  - RN-001 # Requisito negocio: Sistema alertas

# Trazabilidad Downward
trazabilidad_downward:
  - TEST-001  # Test de integración API
  - TASK-123  # Issue GitHub implementación

stakeholders:
  - gerente-compras
  - analista-inventario
---
```

#### Paso 3: Migrar contenido

Copia el contenido del archivo legacy y adapta al formato de la plantilla:

- Descripción clara
- Criterios de aceptación (Gherkin)
- Método de verificación
- Supuestos y dependencias

#### Paso 4: Marcar legacy como obsoleto

Añade al archivo legacy una nota:

```markdown
> **ADVERTENCIA: ARCHIVO OBSOLETO**
>
> Este requisito se ha migrado a la nueva estructura:
> - **Nuevo ubicación**: `docs/backend/requisitos/funcionales/rf001_api_calcular_stock.md`
> - **Fecha migración**: 2025-11-04
> - **ID nuevo**: RF-001
>
> Este archivo se mantendrá por 3 meses para referencia histórica.
```

### Fase 4: Validación (1 día)

1. Verifica trazabilidad completa
2. Ejecuta generador de índices ISO
3. Revisa enlaces en documentación

```bash
# Generar índices
python .github/workflows/scripts/generate_requirements_index.py

# Verificar enlaces
cd docs && grep -r "\[.*\](.*requisitos.*)" --include="*.md"
```

### Fase 5: Archivo Legacy (Al finalizar)

Cuando toda la migración esté completa:

1. Mueve archivos legacy a carpeta archivo
2. Actualiza README de legacy con redirección
3. Commit y documentar

```bash
mkdir -p docs/legacy_requirements_archive
mv docs/backend/requisitos/*.md docs/legacy_requirements_archive/
mv docs/frontend/requisitos/*.md docs/legacy_requirements_archive/
mv docs/infraestructura/requisitos/*.md docs/legacy_requirements_archive/
```

---

## Checklist de Migración

### Por Requisito

- [ ] Archivo legacy identificado
- [ ] Tipo BABOK clasificado correctamente
- [ ] ID único asignado (no duplicado)
- [ ] Dominio determinado (backend/frontend/infrastructure)
- [ ] Plantilla correcta copiada
- [ ] Frontmatter YAML completo
- [ ] Trazabilidad upward documentada
- [ ] Trazabilidad downward documentada
- [ ] Contenido migrado y adaptado
- [ ] Criterios aceptación en Gherkin
- [ ] Stakeholders identificados
- [ ] Archivo legacy marcado como obsoleto
- [ ] Links actualizados en docs relacionados

### Por Dominio

- [ ] Todos los requisitos backend migrados
- [ ] Todos los requisitos frontend migrados
- [ ] Todos los requisitos infrastructure migrados
- [ ] Índices ISO generados correctamente
- [ ] RTM validada con trazabilidad completa
- [ ] Tests de requisitos actualizados

---

## Ejemplos Prácticos

### Ejemplo 1: Migrar Requisito Funcional Backend

**Archivo legacy**: `docs/backend/requisitos/api_stock.md`

**Contenido legacy**:
```markdown
# API de cálculo de stock

La API debe calcular el stock mínimo basado en ventas históricas.

- Debe responder en menos de 200ms
- Debe considerar estacionalidad
```

**Nuevo archivo**: `docs/backend/requisitos/funcionales/rf001_api_calcular_stock.md`

```markdown
---
id: RF-001
tipo: funcional
titulo: API para cálculo de stock mínimo
dominio: backend
owner: equipo-backend
prioridad: alta
estado: implementado

trazabilidad_upward:
  - N-001
  - RN-001

trazabilidad_downward:
  - TEST-001
  - RNF-001

stakeholders:
  - gerente-compras
---

# RF-001: API para cálculo de stock mínimo

## Descripción

El sistema debe proporcionar una API REST que calcule el stock mínimo requerido para cada producto basándose en datos históricos de ventas y patrones de estacionalidad.

## Criterios de Aceptación

```gherkin
Given un producto con historial de ventas de 12 meses
When se invoca la API con el ID del producto
Then el sistema retorna el stock mínimo calculado
And el tiempo de respuesta es menor a 200ms
And se consideran patrones de estacionalidad
```

## Método de Verificación

- **Tipo**: Test (automatizado)
- **Referencia**: TEST-001 (test_api_stock_minimo.py)
- **Cobertura**: 95%

## Supuestos

- Datos históricos disponibles en base de datos
- Patrón estacional identificado previamente

## Dependencias

- RNF-001: Requisito de performance < 200ms
- Base de datos con índices optimizados
```

### Ejemplo 2: Migrar Necesidad de Negocio

**Legacy**: Documentado solo como comentario en código

**Nuevo**: `docs/backend/requisitos/necesidades/n001_reducir_roturas_stock.md`

```markdown
---
id: N-001
tipo: necesidad
titulo: Reducir roturas de stock en productos críticos
dominio: backend
owner: gerente-compras
fecha_identificacion: 2025-01-15

trazabilidad_downward:
  - RN-001
---

# N-001: Reducir roturas de stock en productos críticos

## Contexto del Negocio

La empresa experimenta roturas de stock frecuentes en productos críticos, resultando en pérdida de ventas estimada en $50,000 mensuales.

## Problema Actual

- Roturas de stock en 15% de productos críticos
- Tiempo promedio de detección: 48 horas
- Impacto: Pérdida de clientes y reputación

## Oportunidad

Implementar sistema de alertas predictivas que anticipe roturas con 7 días de antelación.

## Beneficio Esperado

- Reducir roturas de stock: 15% → 3%
- Reducir pérdidas: $50,000/mes → $10,000/mes
- ROI esperado: 400% en 12 meses

## Stakeholders

- Gerente de Compras (primario)
- Analista de Inventario (secundario)
- CFO (aprobador presupuesto)
```

---

## Preguntas Frecuentes

### ¿Debo migrar todo de una vez?

**No.** Se recomienda migración incremental:
1. Empezar con 1-2 requisitos piloto
2. Validar proceso
3. Migrar por dominio (backend → frontend → infrastructure)
4. 5-10 requisitos por semana

### ¿Qué hago con requisitos duplicados?

Si el mismo requisito aparece en backend/ y frontend/:
1. Identifica el dominio "dueño" (generalmente backend)
2. Migra una sola vez al dominio dueño
3. Desde el otro dominio, crea un requisito que **referencia** al principal

### ¿Cómo manejo requisitos muy antiguos?

Si el requisito tiene >2 años sin cambios:
1. Verifica si sigue vigente (preguntar al owner)
2. Si está implementado, márcalo como `estado: implementado`
3. Si está obsoleto, mueve directo a archivo con nota explicativa

### ¿Puedo mantener ambas estructuras?

Temporalmente sí (coexistencia durante migración), pero:
- **NO** edites archivos legacy después de migrar
- Establece fecha límite para archivar legacy (ej: 3 meses)
- Comunica claramente qué estructura usar

### ¿Qué hago con los enlaces rotos?

Busca y reemplaza en toda la documentación:

```bash
# Buscar referencias a estructura legacy
grep -r "docs/backend/requisitos" docs/ --include="*.md"

# Actualizar manualmente o con script sed
```

---

## Script de Ayuda

Puedes usar este script para ayudar con la migración:

```bash
#!/bin/bash
# migrate_requisito.sh

echo "=== Migrador de Requisitos Legacy ==="
echo ""

read -p "Ruta archivo legacy: " LEGACY_FILE
read -p "Tipo (necesidad|negocio|stakeholder|funcional|no_funcional): " TIPO
read -p "Dominio (backend|frontend|infrastructure): " DOMINIO
read -p "ID nuevo (ej: RF-001): " ID

# Determinar carpeta destino
case $TIPO in
  necesidad) CARPETA="necesidades" ;;
  negocio) CARPETA="negocio" ;;
  stakeholder) CARPETA="stakeholders" ;;
  funcional) CARPETA="funcionales" ;;
  no_funcional) CARPETA="no_funcionales" ;;
esac

# Crear archivo desde plantilla
TEMPLATE="docs/plantillas/template_requisito_${TIPO}.md"
DEST="docs/implementacion/${DOMINIO}/requisitos/${CARPETA}/${ID,,}_descripcion.md"

cp "$TEMPLATE" "$DEST"

echo "SUCCESS: Archivo creado: $DEST"
echo "ADVERTENCIA: Ahora completa manualmente:"
echo "   1. Frontmatter YAML"
echo "   2. Contenido del requisito"
echo "   3. Trazabilidad upward/downward"
```

---

## 📞 Soporte

Si tienes dudas durante la migración:

- **Canal Slack**: #proyecto-iact-docs
- **Responsable**: equipo-arquitectura
- **Documentación**: [Propuesta de Reestructuración](../PROPUESTA_FINAL_REESTRUCTURACION.md)

---

**Última actualización**: 2025-11-04
**Owner**: equipo-arquitectura
**Versión**: 1.0
