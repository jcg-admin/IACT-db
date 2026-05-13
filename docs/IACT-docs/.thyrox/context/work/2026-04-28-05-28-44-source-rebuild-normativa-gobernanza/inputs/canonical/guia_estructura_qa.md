---
id: DOC-QA-GUIA-ESTRUCTURA
estado: borrador
propietario: lider-qa
ultima_actualizacion: 2025-02-25
relacionados: ["CHECK-AUDIT-REST", "DOC-QA-001"]
---
# Guía rápida para nuevas guías de QA

Esta guía toma como referencia `checklist_auditoria_restricciones.md` para documentar la estructura mínima y las convenciones de nomenclatura que deben cumplir las futuras guías de QA.

## Mapeo del archivo de referencia
- **Metadatos YAML**: `id`, `tipo`, `categoria`, `version`, `fecha_creacion`, `propietario`, `relacionados`.
- **Encabezados principales** (en mayúsculas): Propósito, CÓMO USAR ESTE CHECKLIST, SECCIÓN 1 (restricciones críticas) con subsecciones numeradas, SECCIÓN 2 y SECCIÓN 3, RECURSOS Y REFERENCIAS, HISTORIAL DE AUDITORÍAS, FIRMA DE APROBACIÓN.
- **Secciones clave**:
  - Objetivo: se expone en “Propósito”.
  - Alcance: descrito en la sección de uso y en los bloques de restricciones (alcances CRÍTICO/ALTA/MEDIA/BAJA).
  - Checklist: tablas numeradas por categoría (1.x, 2.x, 3.x) con columnas `#`, `Ítem`, `Verificación`, `Estado`, `Evidencia` y sumarios de puntaje.
  - Métricas: scoring mínimo y puntajes por sección (Score 1.x, Score 2.x, Score 3.x).
  - Responsables: roles explícitos en la firma de aprobación (QA Lead, Security Lead, Tech Lead).
  - Frecuencia: subsección “Frecuencia de Auditoría” dentro de CÓMO USAR ESTE CHECKLIST.
- **Tablas**: usadas para checklist por sección, métricas de seguridad, recursos de archivos y firmas. Todas usan encabezados en mayúsculas y numeración alineada con el bloque (1.1, 1.2...).
- **Nomenclatura**: IDs en mayúsculas con prefijos (ej. `CHECK-AUDIT-REST`), versiones semánticas, subtítulos numerados (`### 1.1 Comunicaciones [CRÍTICO]`), listas de acciones pendientes con casillas `[ ]`.

## Elementos obligatorios para nuevas guías de QA
1. **Metadatos YAML** con `id`, `estado`, `propietario`, `ultima_actualizacion`, `relacionados` y, si aplica, `tipo`, `categoria`, `version`, `fecha_creacion`.
2. **Objetivo y alcance**: subsección corta que aclare propósito y límites del documento.
3. **Frecuencia y responsables**: bloque dedicado a cuándo se ejecuta la guía y quién la aprueba (roles mínimos: QA Lead; agregar Security/Tech Lead cuando proceda).
4. **Checklist estructurado**:
   - Numeración jerárquica por categoría (`1.x`, `2.x`, etc.).
   - Tablas con columnas `#`, `Ítem`, `Verificación`, `Estado`, `Evidencia`.
   - Cierre de cada subsección con puntaje o métricas de cumplimiento.
5. **Métricas y criterios de aceptación**: metas mínimas (ej. puntuación global, cobertura ≥ 80 %) y umbrales por severidad.
6. **Acciones pendientes**: lista de tareas o remediaciones con casillas `[ ]` vinculadas a cada sección.
7. **Recursos y referencias**: enlaces a documentos relacionados y herramientas sugeridas.
8. **Historial y firma**: tabla de auditorías previas y bloque de firmas para responsables.
9. **Nomenclatura**: mantener IDs en mayúsculas con prefijos descriptivos (`CHECK-`, `DOC-`, `PLAN-`), subtítulos numerados y uso consistente de mayúsculas en encabezados principales.

## Plantilla mínima sugerida
```markdown
---
id: CHECK-NNN
estado: borrador
propietario: rol-responsable
ultima_actualizacion: AAAA-MM-DD
relacionados: ["..."]
---
# Título de la guía

## Propósito y alcance
- Objetivo
- Alcance

## Frecuencia y responsables
- Frecuencia
- Roles: QA Lead / Security Lead / Tech Lead

## Checklist
### 1.1 Tema [CRÍTICO]
| # | Ítem | Verificación | Estado | Evidencia |
|---|------|--------------|--------|-----------|
| 1.1.1 | ... | ... | ... | ... |

**Score 1.1**: X/X - Estado

## Métricas y criterios
- Puntuación mínima global
- Criterios por severidad

## Acciones pendientes
- [ ] Acción

## Recursos y referencias
- ...

## Historial de auditorías
| Fecha | Auditor | Score Global | Estado | Notas |
| --- | --- | --- | --- | --- |

## Firma de aprobación
- QA Lead: ___ Fecha: ___
- Security Lead: ___ Fecha: ___
- Tech Lead: ___ Fecha: ___
```

## Guía de QA: mapeo de referencia y estilo

### 1. Archivo de referencia identificado

- **Ruta:** `docs/standards/engineering-ruleset.md`.
- **Propósito del archivo:** consolidar convenciones técnicas y de nomenclatura para el monorrepo (equivalente a un objetivo).
- **Alcance explícito:** cubre estándares de repositorio, Bash, Python, UI y automatización; aplica a todo `docs/` y a las capas descritas (presentación, dominio, infraestructura).

### 2. Mapa de estructura del archivo de referencia

| Orden | Encabezado / sección | Contenido clave | Elementos relevantes para QA |
| --- | --- | --- | --- |
| 1 | Título y resumen inicial | Presenta el propósito del ruleset y su carácter viviente. | Objetivo y alcance implícitos. |
| 2 | `1. Core Principles` | Lista numerada con principios base. | Actúa como checklist de lineamientos generales. |
| 3 | `2. Repository Structure Expectations` | Diagrama de árbol del monorrepo con comentarios. | Define alcance y dependencias. |
| 4 | `3. Naming Conventions` | Tabla con convenciones por capa (Bash, Python, React, SCSS, Webpack, PlantUML). | Convenciones de nomenclatura obligatorias. |
| 5 | `4. Layering Rules` | Lista numerada con límites de responsabilidad. | Checklist de responsabilidades y restricciones. |
| 6 | `5. Bash Standards` | Bullets de prácticas obligatorias. | Lista de verificación para scripts. |
| 7 | `6. Python (Flask + PyTM) Standards` | Bullets de estilo y organización. | Lista de verificación por lenguaje. |
| 8 | `7. PlantUML and Diagram Automation` | Bullets sobre ubicación y generación de diagramas. | Checklist especializado. |
| … | Secciones posteriores | Continúan con estándares por capa (no visibles en este extracto). | Extienden checklists y reglas específicas. |

#### Convenciones de nomenclatura derivadas

- Usar `snake_case` para scripts Bash y módulos/funciones Python.
- Emplear `PascalCase` para clases Python y componentes React.
- Archivos SCSS en `kebab-case`, variables en `$kebab-case`.
- Configuraciones de Webpack como `webpack.<target>.config.js`.
- Plantillas PlantUML en `snake_case.puml`.

### 3. Guía de estilo para nuevas guías de QA

Al crear futuras guías de QA en este repositorio, incluye como mínimo:

1. **Portada breve:** título, versión, fecha y sistema o equipo al que aplica.
2. **Objetivo:** párrafo que explique qué se valida o protege.
3. **Alcance:** listado con límites (incluye/excluye). Si aplica a un módulo específico, referéncialo.
4. **Responsables:** tabla con rol, responsabilidad y contacto/canal.
5. **Frecuencia:** periodicidad de ejecución (por ciclo, semanal, por release) y disparadores.
6. **Checklist operativo:** tabla `| Paso | Acción | Evidencia esperada | Estado |` para asegurar trazabilidad.
7. **Métricas:** tabla mínima `| Métrica | Definición | Umbral | Fuente |`.
8. **Convenciones de nomenclatura:** referencias a la tabla del archivo de referencia y reglas específicas de QA (p. ej., prefijos para casos de prueba).
9. **Registro de decisiones/observaciones:** bullets con hallazgos, desvíos y acciones correctivas.
10. **Trazabilidad y anexos:** enlaces relativos a scripts, pipelines o plantillas utilizadas.

#### Reglas de formato

- Mantén encabezados numerados para reflejar orden y facilitar auditorías.
- Usa tablas para checklist, métricas y responsables; alinea columnas con `|` para lecturabilidad.
- Coloca código o comandos en bloques de triple acento invertido con idioma cuando aplique.
- Nombra archivos de QA en `kebab-case` (`control-versionado-qa.md`) y rutas bajo `docs/gobernanza/qa/`.
- Si introduces nuevas convenciones, documenta el objetivo y enlaza al recurso correspondiente dentro del repositorio.

### 4. Ubicación y nomenclatura confirmada

- No existen variantes previas (`.md`, `.adoc`, `.pdf`) de las guías solicitadas bajo `docs/` o `infrastructure/`.
- Se crean y consolidan las rutas acordadas para QA:
  - `docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/QA-ANALISIS-RAMAS-001.md` para el control de ramas.
  - `docs/infraestructura/qa/QA-ANALISIS-ESTRUCTURA-INFRA-001/QA-ANALISIS-ESTRUCTURA-INFRA-001.md` para la estructura de infraestructura.
