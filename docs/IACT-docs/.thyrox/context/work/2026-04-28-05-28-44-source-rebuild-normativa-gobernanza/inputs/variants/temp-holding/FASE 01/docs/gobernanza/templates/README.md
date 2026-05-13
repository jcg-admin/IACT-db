# Templates de Artefactos de Requisitos

Este directorio contiene plantillas reutilizables para todos los tipos de artefactos de requisitos definidos en los ADRs de gobernanza del proyecto IACT.

**Fecha de creación**: 2025-11-17
**Versión**: 1.0.0
**Autor**: Claude Code (Sonnet 4.5)

## Resumen Ejecutivo

Se han creado **11 templates** que cubren todos los niveles de la jerarquía de requisitos definida en ADR-GOB-005:

- 5 templates para Reglas de Negocio (RN)
- 1 template para Casos de Uso (UC)
- 1 template para Requisitos Funcionales (RF)
- 1 template para Atributos de Calidad (RNF)
- 2 templates para Diagramas PlantUML (UCD, ACT)
- 1 template para Matrices de Trazabilidad

## Inventario de Templates

### Reglas de Negocio (5 templates)

Basados en ADR-GOB-006: Clasificación y Documentación de Reglas de Negocio

#### 1. RN-hecho-template.md
- **Tamaño**: 3.0 KB
- **Propósito**: Plantilla para documentar hechos (verdades inmutables del negocio)
- **Secciones principales**:
  - Tipo: Hecho
  - Declaración del hecho
  - Elementos relacionados (términos comerciales)
  - Justificación
  - Fuente (regulación, política, estándar)
  - Impacto en requisitos (trazabilidad)
- **Palabras clave**: "cada... tiene...", "todos... deben tener...", "debe existir..."
- **Instrucciones inline**: Comentarios HTML con ejemplos

#### 2. RN-restriccion-template.md
- **Tamaño**: 4.6 KB
- **Propósito**: Plantilla para documentar restricciones (limitaciones de acciones)
- **Secciones principales**:
  - Tipo: Restricción
  - Declaración con palabras clave obligatorias (debe, no debe, no puede, solo puede)
  - Alcance (a qué/quién aplica)
  - Matriz de Roles y Permisos (incluida en template)
  - Justificación (seguridad, regulación, política)
  - Excepciones
  - Validación
  - Consecuencias de incumplimiento
- **Características especiales**:
  - Incluye template de matriz de permisos con ejemplo
  - Instrucciones sobre palabras clave obligatorias según tipo de restricción
  - Tabla de roles vs operaciones (✓ permitido, ✗ no permitido)

#### 3. RN-desencadenador-template.md
- **Tamaño**: 5.3 KB
- **Propósito**: Plantilla para documentar desencadenadores de acción
- **Secciones principales**:
  - Tipo: Desencadenador de Acción
  - Declaración en formato SI-ENTONCES (donde "entonces" es una ACCIÓN)
  - Condición de activación (detallada)
  - Acción(es) desencadenada(s)
  - Frecuencia esperada
  - Prioridad
  - Actores involucrados
  - Ejemplo concreto
- **Diferenciación clave**:
  - Clarificación explícita de diferencia con inferencias
  - Tabla comparativa desencadenador vs inferencia
  - Ejemplos inline de acciones (enviar, notificar, bloquear, etc.)

#### 4. RN-inferencia-template.md
- **Tamaño**: 6.5 KB
- **Propósito**: Plantilla para documentar inferencias (conocimiento derivado)
- **Secciones principales**:
  - Tipo: Inferencia (Conocimiento Derivado)
  - Declaración en formato SI-ENTONCES (donde "entonces" es NUEVO CONOCIMIENTO)
  - Hechos de entrada
  - Conocimiento derivado
  - Regla de derivación (lógica)
  - Persistencia (si se guarda, dónde, por cuánto tiempo)
  - Uso del conocimiento derivado
  - Ejemplo concreto
- **Diferenciación clave**:
  - Instrucciones CRÍTICAS sobre diferencia con desencadenadores
  - Las inferencias crean CONOCIMIENTO, los desencadenadores crean ACCIONES
  - Ejemplos de palabras clave: "es", "está", "tiene", "se marca como"

#### 5. RN-calculo-template.md
- **Tamaño**: 8.8 KB
- **Propósito**: Plantilla para documentar cálculos computacionales
- **Secciones principales**:
  - Tipo: Cálculo Computacional
  - Declaración en lenguaje natural
  - Fórmula matemática (en bloque de código)
  - Variables de entrada (tabla completa)
  - Variables de salida (tabla completa)
  - Constantes (tabla con origen y frecuencia de cambio)
  - Tabla de valores (para cálculos basados en rangos)
  - Ejemplo de cálculo (OBLIGATORIO, paso a paso)
  - Reglas de redondeo (CRÍTICO)
  - Fuente de la fórmula (ley, regulación, política)
  - Frecuencia de actualización
  - Validación del cálculo
- **Características especiales**:
  - Template de tabla para descuentos/tarifas por rangos
  - Ejemplos numéricos concretos inline
  - Énfasis en precisión y eliminación de ambigüedades

### Casos de Uso (1 template)

Basado en ADR-GOB-007: Especificación de Casos de Uso (Formato Completo)

#### 6. UC-template-completo.md
- **Tamaño**: 13 KB
- **Propósito**: Plantilla para especificación completa de casos de uso
- **Secciones principales**:
  - Información General
  - Actores (primarios y secundarios)
  - Descripción
  - Desencadenador (trigger)
  - Precondiciones (0 o más)
  - Postcondiciones
  - Flujo Normal en formato tabla dos columnas
  - Flujos Alternos (patrón #.#)
  - Excepciones (patrón #.#.#)
  - Requisitos Especiales
  - Reglas de Negocio Relacionadas
  - Requerimientos de Negocio Relacionados
  - Requisitos Funcionales Derivados
  - Atributos de Calidad Relacionados
  - Diagrama de Casos de Uso (referencia)
  - Diagrama de Actividad (referencia)
  - Información Adicional (prioridad, frecuencia, complejidad)
- **Características especiales**:
  - **Formato de DOS COLUMNAS obligatorio** para flujo normal:
    - Columna 1: ACCIONES DEL ACTOR
    - Columna 2: RESPONSABILIDADES DEL SISTEMA
  - Instrucciones extensivas sobre principio QUÉ vs CÓMO
  - Nomenclatura VERBO+OBJETO con ejemplos correctos e incorrectos
  - Diferenciación clara entre flujos alternos y excepciones
  - Trazabilidad completa (ascendente y descendente)

### Requisitos Funcionales (1 template)

Basado en ADR-GOB-005 (nivel 4 de jerarquía)

#### 7. RF-template.md
- **Tamaño**: 9.3 KB
- **Propósito**: Plantilla para especificación de requisitos funcionales
- **Secciones principales**:
  - Descripción (formato "El sistema debe...")
  - Criterios de Aceptación (formato Dado-Cuando-Entonces)
  - Entradas (tabla completa con validaciones)
  - Salidas (tabla completa con condiciones)
  - Reglas de Procesamiento
  - Trazabilidad (ascendente y descendente)
    - Implementa Casos de Uso
    - Derivado de Reglas de Negocio
    - Cumple Atributos de Calidad
    - Tests Relacionados
  - Restricciones
  - Supuestos
  - Notas de Implementación
  - Estado de Implementación (tracking)
  - Validación y Testing
  - Información Adicional
- **Características especiales**:
  - Énfasis en principio QUÉ vs CÓMO
  - Criterios de aceptación en formato BDD
  - Tablas detalladas para entradas/salidas
  - Trazabilidad completa en ambas direcciones
  - Tracking de estado de implementación

### Atributos de Calidad (1 template)

Basado en ADR-GOB-005 (nivel 5 de jerarquía)

#### 8. RNF-template.md
- **Tamaño**: 11 KB
- **Propósito**: Plantilla para especificación de requisitos no funcionales
- **Secciones principales**:
  - Categoría (rendimiento, seguridad, usabilidad, etc.)
  - Descripción
  - **Métrica Medible** (CRÍTICO - obligatorio)
  - Método de Medición
  - Criterios de Aceptación (con umbrales: mínimo, objetivo, óptimo)
  - Alcance (qué parte del sistema)
  - Trazabilidad (ascendente y descendente)
  - Impacto en Arquitectura
  - Validación
  - Prioridad y Riesgos
  - Estado de Cumplimiento (con última medición)
  - Dependencias
- **Características especiales**:
  - **ÉNFASIS CRÍTICO en métricas medibles**
  - Instrucciones sobre evitar términos vagos ("rápido", "fácil", "seguro")
  - Categorías comunes pre-definidas
  - Tabla de umbrales (mínimo/objetivo/óptimo)
  - Tracking de cumplimiento con valores históricos

### Diagramas PlantUML (2 templates)

Basados en ADR-GOB-008: Diagramas UML de Casos de Uso

#### 9. UCD-template.puml
- **Tamaño**: 5.9 KB
- **Propósito**: Template para diagramas UML de casos de uso
- **Elementos incluidos**:
  - Configuración de tema (plain)
  - Dirección (left to right)
  - Definición de actores (sintaxis comentada)
  - Límite del sistema (rectángulo obligatorio)
  - Casos de uso (óvalos)
  - Relaciones Actor → UC (actor primario)
  - Relaciones UC → Actor (actor secundario)
  - Relaciones entre casos de uso (include, extend, generalización)
  - Notas explicativas
- **Características especiales**:
  - **REGLA DE ORO claramente documentada**:
    - Actor → UC = Actor PRIMARIO
    - UC → Actor = Actor SECUNDARIO
  - Comentarios extensivos con ejemplos
  - Secciones claramente separadas
  - Ejemplos completos inline

#### 10. ACT-template.puml
- **Tamaño**: 8.6 KB
- **Propósito**: Template para diagramas de actividad
- **Elementos incluidos**:
  - Configuración de tema
  - Título y header con metadata
  - Start/stop
  - Actividades simples
  - Condicionales (if-then-else)
  - Condicionales anidadas
  - Múltiples caminos (switch-like)
  - Bucles (while)
  - Actividades paralelas (fork-join)
  - Particiones/swimlanes
  - Notas explicativas
- **Características especiales**:
  - Instrucciones sobre cuándo crear diagrama de actividad
  - Sintaxis comentada para cada elemento
  - Ejemplo completo de UC-BACK-004
  - Guía de buenas prácticas

### Matrices de Trazabilidad (1 template)

Basado en ADR-GOB-009: Trazabilidad entre Artefactos de Requisitos

#### 11. MATRIZ-trazabilidad-template.md
- **Tamaño**: 12 KB
- **Propósito**: Template para matrices de trazabilidad
- **Tipos de matrices incluidos**:
  1. **Matriz Vertical** (jerarquía completa RN → RNEG → UC → RF → RNF)
  2. **Matriz Horizontal** (todos los artefactos relacionados con un UC específico)
  3. **Matriz de Cobertura** (identificación de gaps)
- **Secciones principales**:
  - Información General
  - Resumen Ejecutivo (totales y cobertura)
  - Matriz Vertical con leyenda
  - Matriz Horizontal por caso de uso
  - Matriz de Cobertura (RN→UC, UC→RF, RF→Tests)
  - Análisis de Impacto (para cambios propuestos)
  - Visualización Gráfica (referencia a diagramas)
  - Notas y Observaciones
  - Mantenimiento de la Matriz
  - Historial de Cambios
- **Características especiales**:
  - Tres tipos de matrices diferentes para diferentes propósitos
  - Tablas de cobertura con cálculo de porcentajes
  - Identificación de gaps con acciones requeridas
  - Tracking de impacto de cambios

## Técnicas Aplicadas

### Auto-CoT (Chain of Thought)

Para cada template, se razonó:

1. **Secciones obligatorias vs opcionales**:
   - Reglas de Negocio: Tipo, Declaración, Justificación, Fuente = OBLIGATORIAS
   - Casos de Uso: Flujo Normal, Actores = OBLIGATORIOS; Flujos Alternos = OPCIONALES
   - RF: Descripción, Criterios de Aceptación, Trazabilidad = OBLIGATORIOS
   - RNF: Métrica Medible = CRÍTICA Y OBLIGATORIA

2. **Ejemplos inline que ayudan al usuario**:
   - Todos los templates incluyen ejemplos específicos inline
   - Matrices incluyen tablas pre-pobladas con ejemplos
   - Diagramas PlantUML incluyen ejemplos completos comentados

3. **Instrucciones/comentarios en los templates**:
   - Uso de comentarios HTML `<!-- -->` en archivos Markdown
   - Uso de comentarios PlantUML `/' '/` en archivos .puml
   - Instrucciones claras sobre qué reemplazar: [PLACEHOLDER]
   - Explicaciones de por qué ciertas secciones son importantes

4. **Prevención de errores comunes**:
   - **RN-desencadenador vs RN-inferencia**: Diferenciación CRÍTICA claramente documentada
   - **UC nomenclatura**: Ejemplos CORRECTOS e INCORRECTOS explícitos
   - **UC QUÉ vs CÓMO**: Múltiples ejemplos de qué evitar
   - **RNF sin métricas**: Énfasis repetido en necesidad de métricas medibles
   - **UCD dirección de flechas**: REGLA DE ORO documentada prominentemente

### Self-Consistency

Para cada sección del template:

1. **Validación de consistencia con ADRs**:
   - RN: 5 tipos exactos de ADR-GOB-006
   - UC: Formato de dos columnas de ADR-GOB-007
   - UCD: Convenciones de flechas de ADR-GOB-008
   - Trazabilidad: Referencias bidireccionales de ADR-GOB-009

2. **Verificación de claridad de instrucciones**:
   - Cada placeholder claramente marcado: [PLACEHOLDER]
   - Instrucciones en lenguaje imperativo ("Reemplace...", "Escriba...", "Liste...")
   - Ejemplos en bloques de comentarios separados

3. **No contradicción con ADRs**:
   - Ningún template sugiere prácticas contrarias a los ADRs
   - Nomenclaturas consistentes con ADR-GOB-005
   - Formatos alineados con decisiones arquitectónicas

## Decisiones Importantes Tomadas

### 1. Uso Extensivo de Comentarios HTML en Markdown

**Decisión**: Incluir instrucciones dentro de comentarios HTML `<!-- -->` en lugar de texto visible.

**Razón**:
- No contamina el documento final cuando se renderiza
- Guía al usuario mientras edita
- Puede eliminarse fácilmente si se desea

**Ejemplo**:
```markdown
<!--
INSTRUCCIONES:
- Reemplace [DOMINIO] con: BACK, FRONT, DEVOPS, QA, AI, GOB
-->
```

### 2. Diferenciación Explícita Desencadenador vs Inferencia

**Decisión**: Incluir sección prominente con tabla comparativa y advertencias en MAYÚSCULAS.

**Razón**:
- Es una confusión EXTREMADAMENTE común en la industria
- La diferencia es crítica para correcta implementación
- ADR-GOB-006 la menciona pero no enfatiza suficientemente

**Implementación**:
- Tabla comparativa en ambos templates
- Ejemplos contrastando ambos tipos
- Palabras clave específicas para cada uno

### 3. Template de Dos Columnas para Casos de Uso

**Decisión**: Incluir tabla pre-formateada y múltiples ejemplos de uso.

**Razón**:
- ADR-GOB-007 establece que es OBLIGATORIO
- Separación visual hace obvias las responsabilidades
- Usuarios podrían no entender cómo estructurar la tabla

**Implementación**:
- Tabla con columnas claramente etiquetadas
- Ejemplo inline mostrando cómo llenar
- Instrucciones sobre numeración de pasos

### 4. Métricas Medibles en RNF

**Decisión**: Hacer la sección "Métrica Medible" prominente y con énfasis en CRÍTICO/OBLIGATORIO.

**Razón**:
- RNF sin métricas son inútiles (no se pueden validar)
- Error EXTREMADAMENTE común: "el sistema debe ser rápido" sin definir "rápido"
- ADR-GOB-005 menciona que deben ser medibles pero no enfatiza suficientemente

**Implementación**:
- Sección con etiqueta **CRÍTICO**
- Instrucciones sobre evitar términos vagos
- Ejemplos de métricas correctas e incorrectas
- Tabla de umbrales (mínimo/objetivo/óptimo)

### 5. Tres Tipos de Matrices en un Solo Template

**Decisión**: Incluir Matriz Vertical, Horizontal y de Cobertura en un solo archivo.

**Razón**:
- Cada tipo sirve un propósito diferente
- Usuario puede elegir cuál usar o usar varias
- Consolidación reduce número de archivos

**Implementación**:
- Secciones claramente separadas
- Instrucciones sobre cuándo usar cada tipo
- Ejemplos para cada tipo

### 6. Ejemplos Completos en Templates PlantUML

**Decisión**: Incluir ejemplos completos comentados dentro de los templates.

**Razón**:
- PlantUML tiene sintaxis no intuitiva para principiantes
- Comentarios `/' '/` permiten incluir ejemplos sin afectar el rendering
- Usuario puede descomentar y modificar en lugar de escribir desde cero

**Implementación**:
- Sección de ejemplos al final del template
- Ejemplos reales del proyecto (UC-BACK-004, módulo de autenticación)
- Cada elemento sintáctico comentado con su propósito

### 7. Frontmatter YAML Completo

**Decisión**: Incluir frontmatter YAML completo en todos los templates Markdown.

**Razón**:
- Permite procesamiento automatizado
- Consistencia entre todos los artefactos
- Facilita búsqueda y filtrado

**Implementación**:
- Campos estándar: id, tipo, categoria, version, fecha, autor, estado
- Campos específicos según tipo de artefacto
- Placeholders claramente marcados

### 8. No Incluir Emojis

**Decisión**: No usar emojis en ningún template.

**Razón**:
- Instrucción explícita del usuario
- Mayor profesionalismo
- Compatibilidad con sistemas que no renderizan emojis

**Excepciones**:
- Checkmarks (✓, ✗) en matrices de permisos y cobertura (no son emojis, son símbolos Unicode estándar)

## Problemas Encontrados y Soluciones

### Problema 1: Redundancia en Trazabilidad

**Problema**: La trazabilidad bidireccional implica que UC lista RF y RF lista UC (redundancia).

**Solución**:
- Se mantiene la redundancia porque es intencional (ADR-GOB-009)
- Se agrega nota en template de matriz explicando que es normal
- Se sugiere generar matrices automáticamente para evitar inconsistencias

### Problema 2: Complejidad del Template de UC

**Problema**: UC-template-completo.md es muy extenso (13 KB) y podría intimidar.

**Solución**:
- Se marcan claramente secciones OBLIGATORIAS vs OPCIONALES
- Se incluyen instrucciones sobre qué eliminar si no aplica
- Se enfatiza que no todo UC necesita todas las secciones

### Problema 3: Diferenciación Desencadenador/Inferencia

**Problema**: Riesgo de que usuarios sigan confundiendo a pesar de instrucciones.

**Solución**:
- Se crea tabla comparativa en AMBOS templates
- Se usan MAYÚSCULAS para énfasis en diferencia clave
- Se proporcionan múltiples ejemplos contrastando ambos tipos
- Se usan palabras clave específicas para cada tipo

### Problema 4: Fórmulas Matemáticas en RN-calculo

**Problema**: Markdown no renderiza LaTeX por defecto, fórmulas pueden verse mal.

**Solución**:
- Se usan bloques de código con sintaxis simple (no LaTeX)
- Se enfatiza claridad sobre notación matemática formal
- Se incluye ejemplo paso a paso con números

### Problema 5: Matrices en Markdown

**Problema**: Tablas de Markdown se vuelven difíciles de mantener con muchas columnas.

**Solución**:
- Se limita número de columnas en matriz vertical (5 máximo: RN, RNEG, UC, RF, RNF)
- Se usan múltiples filas en lugar de múltiples columnas
- Se sugiere generación automática para matrices grandes

## Casos de Uso de los Templates

### Caso de Uso 1: Documentar Nueva Regla de Negocio

1. Identificar tipo de regla (hecho, restricción, desencadenador, inferencia, cálculo)
2. Copiar template correspondiente
3. Renombrar según nomenclatura: `RN-DOMINIO-###-descripcion.md`
4. Llenar frontmatter YAML
5. Seguir instrucciones inline comentadas
6. Eliminar secciones opcionales que no apliquen
7. Eliminar comentarios de instrucciones si se desea

### Caso de Uso 2: Especificar Nuevo Caso de Uso

1. Copiar `UC-template-completo.md`
2. Renombrar según patrón VERBO+OBJETO: `UC-DOMINIO-###-verbo-objeto.md`
3. Llenar frontmatter
4. Definir actores (primarios y secundarios)
5. Escribir flujo normal en formato de dos columnas
6. Agregar flujos alternos si existen
7. Agregar excepciones si existen
8. Establecer trazabilidad (RN, RNEG, RF, RNF)

### Caso de Uso 3: Crear Diagrama UML de Casos de Uso

1. Copiar `UCD-template.puml`
2. Renombrar según nomenclatura: `UCD-DOMINIO-###-descripcion.puml`
3. Definir actores
4. Definir casos de uso dentro del límite del sistema
5. Conectar actores primarios → casos de uso
6. Conectar casos de uso → actores secundarios
7. Agregar relaciones entre casos de uso si existen
8. Generar SVG para inclusión en documentos

### Caso de Uso 4: Crear Matriz de Trazabilidad de Módulo

1. Copiar `MATRIZ-trazabilidad-template.md`
2. Renombrar: `MATRIZ-DOMINIO-###-nombre-modulo.md`
3. Decidir qué tipo de matriz usar (vertical, horizontal, cobertura, o varias)
4. Llenar resumen ejecutivo con totales
5. Completar matriz(ces) con IDs de artefactos
6. Identificar gaps
7. Documentar acciones requeridas

## Mantenimiento de los Templates

### Versionamiento

Los templates siguen versionamiento semántico:

- **MAJOR**: Cambios que rompen compatibilidad (nuevas secciones obligatorias)
- **MINOR**: Nuevas secciones opcionales, mejoras a instrucciones
- **PATCH**: Correcciones de typos, aclaraciones

**Versión actual**: 1.0.0

### Proceso de Actualización

1. Identificar necesidad de cambio (feedback de usuarios, cambio en ADRs)
2. Crear branch para actualización
3. Modificar template(s)
4. Actualizar este README
5. Actualizar versión en frontmatter del template
6. Crear PR con descripción de cambios
7. Revisión y aprobación
8. Merge y comunicación a equipo

### Responsables

- **Creación inicial**: Claude Code (Sonnet 4.5)
- **Mantenimiento**: [A DEFINIR]
- **Revisión de cambios**: [A DEFINIR]

## Referencias

### ADRs Relacionados

- [ADR-GOB-005: Jerarquía de Requerimientos en 5 Niveles](../docs/gobernanza/adr/ADR-GOB-005-jerarquia-requerimientos-5-niveles.md)
- [ADR-GOB-006: Clasificación y Documentación de Reglas de Negocio](../docs/gobernanza/adr/ADR-GOB-006-clasificacion-reglas-negocio.md)
- [ADR-GOB-007: Especificación de Casos de Uso](../docs/gobernanza/adr/ADR-GOB-007-especificacion-casos-uso.md)
- [ADR-GOB-008: Diagramas UML de Casos de Uso](../docs/gobernanza/adr/ADR-GOB-008-diagramas-uml-casos-uso.md)
- [ADR-GOB-009: Trazabilidad entre Artefactos de Requisitos](../docs/gobernanza/adr/ADR-GOB-009-trazabilidad-artefactos-requisitos.md)

### Guías de Uso

Para guías detalladas sobre cómo usar estos templates, consulte:
- [Guía de Documentación de Requisitos](../docs/gobernanza/guias/) (cuando se cree)

## Changelog del Directorio de Templates

| Versión | Fecha | Cambios |
|---------|-------|---------|
| 1.0.0 | 2025-11-17 | Creación inicial de 11 templates |

## Feedback y Mejoras

Si encuentra problemas con los templates o tiene sugerencias de mejora:

1. Abra un issue en el repositorio
2. Use etiqueta `templates` y `documentacion`
3. Describa el problema o sugerencia claramente
4. Proporcione ejemplos si es posible

## Licencia

Estos templates son parte del proyecto IACT y siguen la misma licencia del proyecto.
