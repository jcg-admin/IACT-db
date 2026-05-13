---
title: Guía de Uso de Plantillas
date: 2025-11-16
domain: general
status: active
tipo: guia
---

# Guía de Uso de las Plantillas

### 1. Cuándo Usar Cada Plantilla

| Plantilla | Cuándo Usarla |
|-----------|---------------|
| **Documento Maestro de Análisis** | Al iniciar el análisis de un componente o funcionalidad nueva. Integra todos los artefactos en un solo documento. |
| **Matriz de Trazabilidad (RTM)** | Para validar completitud y trazabilidad de requisitos. Útil en revisiones y auditorías. |
| **Checklist de Completitud** | Al finalizar el análisis, antes de enviar a revisión. Garantiza que no se omitió ningún artefacto. |
| **Regla de Negocio Individual** | Cuando se identifica una regla nueva que debe documentarse rápidamente. |

### 2. Workflow Recomendado

```
1. INICIAR ANÁLISIS
   - Usar Plantilla 1 (Documento Maestro)
   - Completar Sección 1: Contexto

2. IDENTIFICAR PROCESOS Y REGLAS
   - Completar Sección 2 (Procesos)
   - Completar Sección 3 (Reglas)
   - Para cada regla compleja, crear documento individual con Plantilla 4

3. DERIVAR CASOS DE USO
   - Completar Sección 4 (Casos de Uso)

4. ESPECIFICAR REQUISITOS
   - Completar Sección 5 (Requisitos)

5. DOCUMENTAR PROCEDIMIENTOS
   - Completar Sección 6 (Procedimientos)

6. VALIDAR TRAZABILIDAD
   - Completar Sección 7 (Matriz de Trazabilidad)
   - Crear Plantilla 2 (RTM) para análisis detallado

7. DEFINIR PRUEBAS
   - Completar Sección 8 (Pruebas)

8. VALIDAR COMPLETITUD
   - Ejecutar Plantilla 3 (Checklist)
   - Resolver items pendientes

9. ENVIAR A REVISIÓN
   - Completar Sección 11 (Aprobaciones)

10. IMPLEMENTAR
    - Completar Sección 9 (Diseño/Implementación)
    - Actualizar RTM con estado de implementación
```

### 3. Integración con Directorio plantillas/

El proyecto IACT tiene un directorio `docs/plantillas/` con plantillas existentes. Este documento complementa esas plantillas con:

- **Integración de artefactos:** Las plantillas aquí unen procesos, UC, requisitos, y procedimientos en un flujo coherente
- **Trazabilidad:** Las matrices RTM garantizan trazabilidad bidireccional
- **Validación:** El checklist valida completitud antes de implementar

**Relación con plantillas existentes:**

```
docs/plantillas/
├── [plantillas existentes del proyecto]
│
docs/gobernanza/marco_integrado/
├── 06_plantillas_integradas_iact.md (ESTE DOCUMENTO)
    ├── Plantilla 1: Documento Maestro (integra todo)
    ├── Plantilla 2: RTM (trazabilidad)
    ├── Plantilla 3: Checklist (validación)
    └── Plantilla 4: Regla Individual (documentación rápida)
```

### 4. Consejos de Uso

#### Para Analistas de Negocio:

- **Comenzar siempre con el contexto:** Sección 1 del Documento Maestro
- **Documentar reglas ANTES de casos de uso:** Las reglas influyen en los UC
- **Validar con stakeholders temprano:** No esperar a tener todo completo

#### Para Desarrolladores:

- **Revisar trazabilidad:** Usar RTM para entender de dónde viene cada requisito
- **Consultar procedimientos:** Entender el flujo de usuario antes de implementar
- **Actualizar estado de implementación:** Mantener RTM actualizado

#### Para QA:

- **Derivar casos de prueba de criterios de aceptación:** Cada criterio es un caso de prueba potencial
- **Validar cobertura con RTM:** Usar Plantilla 2 para identificar gaps
- **Ejecutar checklist antes de release:** Garantizar que nada quedó sin probar

#### Para Product Owners:

- **Usar RTM para priorización:** Ver qué requisitos tienen más impacto
- **Validar completitud con checklist:** Antes de aceptar un análisis como completo
- **Revisar trazabilidad de necesidades:** Garantizar que necesidades de negocio están cubiertas

---

## Ejemplos de Uso

### Ejemplo 1: Análisis de Nueva Funcionalidad "Recuperación de Contraseña"

**Paso 1:** Crear documento usando Plantilla 1

```markdown
# Análisis Integrado: Recuperación de Contraseña

ID: AI-004
Área: Seguridad

## 1. Contexto
Objetivo: Permitir a usuarios recuperar acceso a su cuenta cuando olvidan contraseña

Stakeholders:
- Usuarios: Requieren proceso simple y seguro
- Admin de Seguridad: Requiere trazabilidad

...
```

**Paso 2:** Identificar reglas de negocio

```markdown
RN-SEC-10: Token de Recuperación Expirable
Tipo: Restricción
Descripción: Token de recuperación debe expirar en 1 hora
```

**Paso 3:** Derivar casos de uso

```markdown
UC-015: Solicitar Recuperación de Contraseña
UC-016: Establecer Nueva Contraseña con Token
```

**Paso 4:** Crear RTM usando Plantilla 2 para validar trazabilidad

**Paso 5:** Ejecutar Checklist (Plantilla 3) antes de enviar a revisión

### Ejemplo 2: Auditoría de Requisitos Existentes

**Paso 1:** Crear RTM (Plantilla 2) con todos los requisitos actuales

**Paso 2:** Identificar requisitos huérfanos (sin UC asociado)

**Paso 3:** Identificar UC sin requisitos (derivar requisitos faltantes)

**Paso 4:** Validar cobertura de pruebas

**Paso 5:** Generar reporte de gaps y acciones correctivas

---

## Integración con Herramientas

### Jira / Azure DevOps

- **Requisitos:** Crear User Stories con ID del requisito (RF-XXX)
- **Trazabilidad:** Usar "Linked Issues" para vincular US → UC → Necesidad
- **Pruebas:** Crear Test Cases vinculados a User Stories

### Confluence / Wiki

- **Publicar Documento Maestro:** Crear página por componente
- **Matrices RTM:** Crear tablas dinámicas que se actualicen automáticamente
- **Checklist:** Crear template de página con checklist incorporado

### Git

- **Commit Messages:** Incluir IDs de requisitos en commits
  ```
  feat(auth): implementar validación de token (RF-006)
  ```
- **Pull Requests:** Referenciar casos de uso y requisitos en descripción
- **Issues:** Vincular issues de GitHub a requisitos

---

## Métricas de Calidad del Análisis

### Índice de Completitud del Análisis

```
Completitud = (Artefactos completos / Artefactos obligatorios) * 100

Artefactos Obligatorios:
- Contexto
- Al menos 1 Proceso
- Al menos 1 Regla de Negocio
- Al menos 1 Caso de Uso
- Al menos 1 Requisito Funcional
- Matriz de Trazabilidad

Meta: >= 95%
```

### Índice de Trazabilidad

```
Trazabilidad = (Requisitos con trazabilidad completa / Total requisitos) * 100

Trazabilidad Completa:
- Upward: Requisito → UC → Proceso
- Downward: Requisito → Prueba → Implementación

Meta: >= 95%
```

### Índice de Cobertura de Pruebas

```
Cobertura Pruebas = (Requisitos con prueba / Total requisitos) * 100

Meta: >= 90% (MUST), >= 70% (SHOULD)
```

---

## Apéndice: Referencias Cruzadas

### Documentos del Marco Integrado

1. `00_resumen_ejecutivo_mejores_practicas.md` - Resumen ejecutivo
2. `01_marco_conceptual_iact.md` - Fundamentos teóricos
3. `02_relaciones_fundamentales_iact.md` - Patrones de transformación
4. `03_matrices_trazabilidad_iact.md` - Ejemplos de matrices RTM
5. `04_metodologia_analisis_iact.md` - Metodología de 4 fases
6. `05a_casos_practicos_iact.md` - Casos reales del proyecto
7. `05b_caso_didactico_generico.md` - Caso pedagógico genérico
8. `06_plantillas_integradas_iact.md` - Este documento

### Estándares y Guías del Proyecto

- `docs/gobernanza/casos_de_uso_guide.md` - Guía de casos de uso
- `docs/gobernanza/procesos/procedimiento_trazabilidad_requisitos.md` - Procedimiento de trazabilidad
- `docs/solicitudes/sc00/sc00_documents/guia_documentacion_integrada.md` - Guía de documentación

### Ejemplos Reales

- `docs/implementacion/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md` - 14 reglas de autenticación
- `docs/implementacion/backend/requisitos/funcionales/rf001_evaluacion_permisos_tres_niveles.md` - Requisito funcional completo

---

## Conclusión

Este documento proporciona 4 plantillas reutilizables para aplicar el marco integrado de análisis de negocio en el proyecto IACT:

1. **Documento Maestro** - Integración completa de todos los artefactos
2. **Matriz RTM** - Trazabilidad y validación de completitud
3. **Checklist** - Validación de calidad antes de revisión
4. **Regla Individual** - Documentación rápida de reglas de negocio

**Beneficios de usar estas plantillas:**

- Estandarización de documentación
- Trazabilidad bidireccional garantizada
- Validación de completitud sistemática
- Reducción de tiempo de análisis
- Mejor comunicación entre roles (BA, Dev, QA, PO)
- Conformidad con ISO 29148:2018 y BABOK v3

**Próximos Pasos:**

1. Aplicar plantillas en próximo análisis de componente nuevo
2. Adaptar plantillas según necesidades específicas del equipo
3. Integrar plantillas con herramientas de gestión (Jira, Confluence, etc.)
4. Capacitar al equipo en el uso de las plantillas

---

## Referencias

Esta guía fue extraída de: [06_plantillas_integradas_iact.md](../06_plantillas_integradas_iact.md)

Para más información sobre el marco integrado de análisis, consulte la documentación completa en el directorio padre.
