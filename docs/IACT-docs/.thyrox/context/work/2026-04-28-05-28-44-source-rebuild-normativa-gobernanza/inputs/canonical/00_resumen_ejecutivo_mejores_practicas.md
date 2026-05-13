---
id: DOC-GOB-MARCO-00
estado: activo
propietario: equipo-ba
ultima_actualizacion: 2025-11-05
relacionados: 
  - DOC-GOB-MARCO-01
  - DOC-GOB-MARCO-02
  - DOC-GOB-MARCO-03
  - DOC-GOB-MARCO-04
  - DOC-GOB-MARCO-05
  - DOC-GOB-MARCO-06
estandares: ["ISO/IEC/IEEE 29148:2018", "BABOK v3", "UML 2.5"]
---

# Resumen Ejecutivo: Marco Integrado de Análisis de Negocio - IACT

**VERSION:** 1.0  
**FECHA:** 2025-11-05  
**ESTADO:** Activo  
**PROPOSITO:** Resumen ejecutivo del marco integrado de análisis de negocio aplicado al proyecto IACT

---

## Navegación del Marco Integrado

Este documento es parte de una serie de 7 documentos que conforman el Marco Integrado de Análisis de Negocio para IACT:

- **[00] Resumen Ejecutivo** (este documento)
- [01 - Marco Conceptual IACT](01_marco_conceptual_iact.md)
- [02 - Relaciones Fundamentales IACT](02_relaciones_fundamentales_iact.md)
- [03 - Matrices de Trazabilidad IACT](03_matrices_trazabilidad_iact.md)
- [04 - Metodología de Análisis IACT](04_metodologia_analisis_iact.md)
- [05 - Casos Prácticos IACT](05_casos_practicos_iact.md)
- [06 - Plantillas Integradas IACT](06_plantillas_integradas_iact.md)

---

## Propósito del Marco Integrado

Este marco documenta cómo **todos los conceptos de análisis de negocio se relacionan e integran** en el proyecto IACT, estableciendo:

1. **Trazabilidad completa** desde necesidades de negocio hasta implementación
2. **Metodología reproducible** para derivar requisitos
3. **Patrones probados** con ejemplos reales del proyecto
4. **Conformidad** con ISO/IEC/IEEE 29148:2018 y BABOK v3

---

## Visión General del Ecosistema IACT

### El Flujo Completo

```
NECESIDADES DE NEGOCIO (N-XXX)
    |
    v [derivan]
REGLAS DE NEGOCIO (RN-XXX)
    |
    v [restringen]
PROCESOS DE NEGOCIO (BPMN)
    |
    v [se descomponen en]
CASOS DE USO (UC-XXX)
    |
    v [generan]
REQUISITOS (RF-XXX, RNF-XXX)
    |
    v [se detallan en]
PROCEDIMIENTOS (PROC-XXX)
    |
    v [se implementan en]
CODIGO + TESTS
```

### Jerarquía de Requisitos BABOK v3

Implementada en IACT según BABOK v3 y documentada en `docs/gobernanza/procesos/procedimiento_trazabilidad_requisitos.md`:

```
N-001 (Necesidad)
  |
  +-- RN-001 (Requisito de Negocio)
       |
       +-- RS-001 (Requisito de Stakeholder)
            |
            +-- RF-001 (Requisito Funcional)
            +-- RNF-001 (Requisito No Funcional)
```

**Ejemplo Real IACT:**

```
N-001: Control de acceso granular
  |
  +-- RN-C01-01: Login con credenciales locales
       |
       +-- RS-001: Usuario requiere acceso 24/7
            |
            +-- RF-005: API de login con username/password
            +-- RNF-001: Tiempo de autenticación < 500ms
```

---

## Puntos Clave del Marco

### 1. TODO ESTA CONECTADO

Cada elemento tiene trazabilidad bidireccional:

- **Upward (hacia arriba)**: Cada RF-XXX sabe de qué RN-XXX proviene
- **Downward (hacia abajo)**: Cada RF-XXX sabe qué TEST-XXX lo verifica

**Herramienta:** Frontmatter YAML en cada documento de requisito.

**Ejemplo Real:**

```yaml
---
id: RF-001
trazabilidad_upward:
  - N-001  # Necesidad de control de acceso
trazabilidad_downward:
  - TEST-001  # test_permission_precedence.py
---
```

Archivo: `docs/implementacion/backend/requisitos/funcionales/rf001_evaluacion_permisos_tres_niveles.md`

### 2. LA TRAZABILIDAD ES ESENCIAL

Sin trazabilidad:
- Requisitos huérfanos (no se sabe por qué existen)
- Tests sin requisito (no se sabe qué verifican)
- Cambios sin impacto conocido

Con trazabilidad (IACT):
- 100% de RF trazan a RN o N
- 95%+ de RF tienen tests
- Cambios con análisis de impacto automático

**Herramienta:** Scripts de validación en `scripts/validate_traceability.py` (a implementar según PROC-TRAZABILIDAD-001).

### 3. ITERACION ES CLAVE

El análisis NO es lineal:

```
Analizar -> Modelar -> Especificar -> Validar -> REPETIR
```

**En IACT:**
- Sprint 1: Análisis inicial de RN-C01 (autenticación)
- Sprint 2: Derivación de RF-005 a RF-010
- Sprint 3: Refinamiento tras tests fallidos
- Sprint 4: Ajuste de RN-C01-06 (timeout de sesión)

### 4. REGLAS DE NEGOCIO SON TRANSVERSALES

Las reglas atraviesan TODOS los niveles:

**Ejemplo RN-C01-01 (Login con Credenciales Locales):**

```
RN-C01-01 IMPACTA:
|
+-- PROCESO: "Autenticación de Usuario" (BPMN)
|    |-- Actividad: "Validar Credenciales"
|
+-- CASO DE USO: UC-001 "Iniciar Sesión"
|    |-- Precondición: Usuario tiene credenciales locales
|
+-- REQUISITOS:
|    |-- RF-005: API POST /api/v1/auth/login
|    |-- RNF-001: Tiempo de respuesta < 500ms
|
+-- PROCEDIMIENTOS:
     |-- PROC-LOGIN-001: Pasos detallados de login
```

Fuente: `docs/implementacion/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md`

### 5. CONFORMIDAD CON ESTANDARES

IACT implementa:

- **ISO/IEC/IEEE 29148:2018**: Clause 5.2.8 (Trazabilidad), Clause 9 (Documentos BRS, StRS, SRS)
- **BABOK v3**: Jerarquía N->RN->RS->RF->RNF
- **UML 2.5**: Casos de uso, diagramas de secuencia

**Evidencia:** `docs/gobernanza/procesos/procedimiento_trazabilidad_requisitos.md:33-43`

---

## Herramientas de Trazabilidad en IACT

### 1. Frontmatter YAML

Cada requisito tiene metadatos estructurados:

```yaml
---
id: RF-001
tipo: funcional
trazabilidad_upward: [N-001, RN-XXX]
trazabilidad_downward: [TEST-001, DESIGN-001]
iso29148_clause: "9.6.4"
---
```

### 2. Matrices de Trazabilidad

Generadas automáticamente (a implementar):

- **RTM (Requirements Traceability Matrix)**: `docs/requisitos/matriz_trazabilidad_rtm.md`
- **Matriz Proceso-UC-Requisito**: Ver [03_matrices_trazabilidad_iact.md](03_matrices_trazabilidad_iact.md)

### 3. Scripts de Validación

- `scripts/validate_traceability.py`: Detecta requisitos huérfanos, ciclos
- CI/CD: GitHub Actions valida en cada PR

**Estado:** Documentado en PROC-TRAZABILIDAD-001, pendiente de implementación.

### 4. Índices ISO 29148

Generados automáticamente:

- **BRS** (Business Requirements Specification): docs/requisitos/brs_business_requirements.md
- **StRS** (Stakeholder Requirements): docs/requisitos/strs_stakeholder_requirements.md
- **SRS** (Software Requirements): docs/requisitos/srs_software_requirements.md

**Estado:** Especificado en PROC-TRAZABILIDAD-001:441-513, pendiente de implementación.

---

## Mejores Prácticas Aplicadas en IACT

### Práctica 1: Reglas de Negocio Primero

**SIEMPRE** identificar RN-XXX antes de diseñar:

```
INCORRECTO:
1. Diseñar login form
2. Implementar API
3. Descubrir que necesita bcrypt (regla de seguridad)
4. Refactorizar

CORRECTO (IACT):
1. Identificar RN-C01-10: "Hash seguro con bcrypt cost 12"
2. Diseñar API considerando la regla
3. Implementar según diseño
4. Validar cumplimiento
```

**Fuente:** RN-C01-10 en `docs/implementacion/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md:1424-1524`

### Práctica 2: Casos de Uso con Formato Estándar

**SIEMPRE** usar formato de dos columnas:

```markdown
## Flujo Principal

| Actor | Sistema |
|-------|---------|
| 1. Usuario ingresa credenciales | |
| | 2. Sistema valida credenciales [RN-C01-02] |
| | 3. Sistema genera tokens JWT [RN-C01-03] |
| | 4. Sistema retorna tokens |
```

**Guía:** `docs/gobernanza/casos_de_uso_guide.md:158-179`

### Práctica 3: Derivación Sistemática de Requisitos

De cada paso del caso de uso que involucre al SISTEMA, derivar RF-XXX:

```
UC-001 Paso 2: "Sistema valida credenciales"
  --> RF-005: API debe validar username/password contra PostgreSQL
  --> RN-C01-02: Validación con bcrypt cost 12

UC-001 Paso 3: "Sistema genera tokens"
  --> RF-006: API debe generar JWT con djangorestframework-simplejwt
  --> RN-C01-03: Access token 15 min, Refresh token 7 días
```

**Metodología:** Ver [04_metodologia_analisis_iact.md](04_metodologia_analisis_iact.md) Fase 3.

### Práctica 4: Validación con Matrices

**SIEMPRE** validar completitud con matrices:

```
MATRIZ DE VALIDACION:

| Necesidad | RN derivados | UC derivados | RF derivados | Tests |
|-----------|--------------|--------------|--------------|-------|
| N-001     | RN-C01-01    | UC-001       | RF-005       | TEST-001 |
|           | RN-C01-02    |              | RF-006       | TEST-002 |
|           | RN-C01-03    |              | RF-007       | TEST-003 |
```

Si alguna celda está vacía, hay un gap.

**Herramienta:** Ver [03_matrices_trazabilidad_iact.md](03_matrices_trazabilidad_iact.md).

### Práctica 5: Procedimientos con Pantallas Reales

Los procedimientos NO son genéricos, especifican:

- Pantalla exacta (FRM-LOGIN-001)
- Campo exacto (txtUsername)
- Validación específica ("Mínimo 8 caracteres")
- Mensaje de error exacto ("Contraseña debe tener 8+ caracteres")

**Ejemplo:** Ver PROC-LOGIN-001 en [05_casos_practicos_iact.md](05_casos_practicos_iact.md) Sección 5.1.

---

## Workflow Recomendado para Nuevas Funcionalidades

### Fase 1: Discovery (1-2 semanas)

```
1. Identificar necesidad de negocio (N-XXX)
   - Entrevistas con stakeholders
   - Análisis de problema
   - Documento: docs/implementacion/backend/requisitos/necesidades/n_XXX.md

2. Identificar reglas de negocio aplicables (RN-XXX)
   - Leyes, regulaciones
   - Políticas organizacionales
   - Documento: docs/implementacion/backend/requisitos/negocio/rn_XXX.md

3. Modelar proceso actual (AS-IS) y futuro (TO-BE)
   - BPMN
   - Identificar actividades que requieren sistema
```

### Fase 2: Análisis (2-3 semanas)

```
4. Identificar casos de uso (UC-XXX)
   - De cada actividad del proceso TO-BE
   - Formato: docs/casos_de_uso/uc_XXX.md
   - Usar plantilla de docs/gobernanza/casos_de_uso_guide.md

5. Especificar casos de uso
   - Flujo principal (formato dos columnas)
   - Flujos alternos
   - Excepciones
   - Vincular reglas de negocio

6. Derivar requisitos funcionales (RF-XXX)
   - De cada paso del sistema en casos de uso
   - Documento: docs/implementacion/[dominio]/requisitos/funcionales/rf_XXX.md
   - Incluir trazabilidad_upward en frontmatter

7. Derivar requisitos no funcionales (RNF-XXX)
   - Performance, seguridad, usabilidad
   - Documento: docs/implementacion/[dominio]/requisitos/no_funcionales/rnf_XXX.md
```

### Fase 3: Diseño y Desarrollo (3-6 semanas)

```
8. Diseño técnico
   - Diagramas de secuencia
   - Modelo de datos
   - APIs
   - Documento: docs/implementacion/[dominio]/diseno/DISENO_TECNICO_XXX.md

9. Desarrollo TDD
   - Crear tests basados en criterios de aceptación de RF-XXX
   - Implementar código que pase tests
   - Actualizar trazabilidad_downward en RF-XXX con TEST-XXX

10. Documentar procedimientos (PROC-XXX)
    - Paso a paso para usuarios finales
    - Screenshots de pantallas
    - Validaciones específicas
    - Documento: docs/procedimientos/procesos/proc_XXX.md
```

### Fase 4: Validación (1 semana)

```
11. Validar trazabilidad
    - Ejecutar scripts/validate_traceability.py
    - Revisar matriz de trazabilidad
    - Corregir gaps

12. Revisión con stakeholders
    - Demostración del sistema
    - Validación de casos de uso
    - Confirmación de cumplimiento de RN-XXX

13. Aprobación y despliegue
```

---

## Métricas de Calidad del Análisis

En IACT, medimos:

### Cobertura de Trazabilidad

- **Target:** 100% de RF con trazabilidad_upward
- **Actual:** 100% (todos los RF en docs/implementacion/backend/requisitos/funcionales/)
- **Medición:** Script validate_traceability.py

### Cobertura de Tests

- **Target:** 95% de RF con al menos 1 test
- **Actual:** Variable por componente
- **Medición:** pytest --cov

### Conformidad ISO 29148

- **Target:** Full Conformance (Clause 5.2.8 + Clause 9)
- **Actual:** Parcial (estructura conforme, índices pendientes)
- **Medición:** Checklist en PROC-TRAZABILIDAD-001:587-604

### Completitud de Documentación

- **Target:** Todos los niveles documentados (N->RN->RS->RF->PROC)
- **Actual:** Componente 1 (Autenticación) 100% completo
- **Medición:** Checklist en cada componente

---

## Antipatrones a Evitar

### Antipatrón 1: Requisitos sin Origen

```
INCORRECTO:
RF-099: Sistema debe enviar email de confirmación

¿Por qué? ¿Quién lo pidió? ¿Es obligatorio?

CORRECTO:
RF-099: Sistema debe enviar email de confirmación
trazabilidad_upward:
  - N-005: Necesidad de confirmar acciones críticas
  - RN-012: Email obligatorio para cambio de contraseña
  - RS-003: Usuario de seguridad requiere confirmación
```

### Antipatrón 2: Casos de Uso con Detalles Técnicos

```
INCORRECTO:
| | 2. Sistema ejecuta SELECT * FROM users WHERE username = ? |

CORRECTO:
| | 2. Sistema valida credenciales contra base de datos |
```

### Antipatrón 3: Reglas de Negocio Escondidas en Código

```
INCORRECTO:
# código Python
if len(password) < 8:
    raise ValidationError("Password too short")

¿Dónde está documentada la regla de 8 caracteres?

CORRECTO:
Primero: RN-C01-07 en docs/implementacion/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md:1134-1249
Luego: Código que implementa RN-C01-07
```

### Antipatrón 4: Procedimientos Genéricos

```
INCORRECTO:
Paso 1: Abrir módulo de usuarios
Paso 2: Crear nuevo usuario
Paso 3: Guardar

CORRECTO:
Paso 1: En menú principal, clic "Usuarios" > "Nuevo Usuario"
Paso 2: Llenar campo "Username" (txtUsername)
   - Validación: 4-20 caracteres, solo letras y números
   - Si error: mensaje "Username inválido. Use 4-20 caracteres."
Paso 3: Clic botón verde "Guardar" (btnGuardar)
   - Si éxito: modal "Usuario creado exitosamente"
```

---

## Referencias del Proyecto IACT

### Documentos Clave

1. **Procedimiento de Trazabilidad ISO 29148**  
   `docs/gobernanza/procesos/procedimiento_trazabilidad_requisitos.md`

2. **Guía de Casos de Uso**  
   `docs/gobernanza/casos_de_uso_guide.md`

3. **Ejemplo Completo: Componente Autenticación**  
   `docs/implementacion/backend/requisitos/negocio/rn_c01_autenticacion_sesiones.md`

4. **Ejemplo Requisito Funcional con Trazabilidad**  
   `docs/implementacion/backend/requisitos/funcionales/rf001_evaluacion_permisos_tres_niveles.md`

### Plantillas

- Necesidad: `docs/plantillas/template_necesidad.md`
- Requisito de Negocio: `docs/plantillas/template_requisito_negocio.md`
- Requisito de Stakeholder: `docs/plantillas/template_requisito_stakeholder.md`
- Requisito Funcional: `docs/plantillas/template_requisito_funcional.md`

### Estándares

- ISO/IEC/IEEE 29148:2018: Systems and software engineering - Requirements engineering
- BABOK v3 (IIBA): Business Analysis Body of Knowledge
- UML 2.5: Unified Modeling Language

---

## Próximos Pasos para el Equipo

### Corto Plazo (Sprint Actual)

1. Implementar scripts de validación de trazabilidad
2. Generar índices ISO 29148 automáticamente
3. Completar casos de uso faltantes (UC-002, UC-003)

### Mediano Plazo (2-3 Sprints)

1. Documentar componentes 2-12 con mismo nivel de detalle que Componente 1
2. Crear matriz de trazabilidad total del proyecto
3. Configurar CI/CD para validación automática

### Largo Plazo (Release)

1. Full conformance ISO 29148
2. 100% de requisitos con trazabilidad bidireccional
3. 95%+ de cobertura de tests

---

## Conclusión

Este marco integrado proporciona:

- **Metodología reproducible** para análisis de negocio
- **Trazabilidad completa** conforme a ISO 29148
- **Ejemplos reales** del proyecto IACT
- **Plantillas y herramientas** listas para usar

**Para comenzar:**

1. Lee [01_marco_conceptual_iact.md](01_marco_conceptual_iact.md) para entender el ecosistema
2. Revisa [04_metodologia_analisis_iact.md](04_metodologia_analisis_iact.md) para el proceso paso a paso
3. Estudia [05_casos_practicos_iact.md](05_casos_practicos_iact.md) para ver ejemplos completos

---

**Ultima actualizacion:** 2025-11-05  
**Owner:** equipo-ba  
**Revisores:** equipo-arquitectura, equipo-producto
