# ANÁLISIS COMPLETO: MODELO DOCUMENTAL OFICIAL IACT
## Considerando DEFINICIONES OFICIALES v2.0.0 + ÁRBOL + FND_

**Fecha:** 2025-12-22
**Versión:** 2.0.0
**Estado:** Análisis Integral

---

## 1. FUENTES NORMATIVAS IDENTIFICADAS

```
╔══════════════════════════════════════════════════════════════════════════╗
║                    JERARQUÍA DE FUENTES NORMATIVAS                       ║
╠══════════════════════════════════════════════════════════════════════════╣
║                                                                          ║
║  NIVEL 1: DEFINICIONES OFICIALES v2.0.0 (1,180 líneas)                   ║
║  ──────────────────────────────────────────────────────                  ║
║  Define: Dominio, Subdominio, Subcarpeta, Sección, Artefacto             ║
║  Define: Estados CONGELADO/DESCONGELADO                                  ║
║  Define: Proceso de Descongelamiento                                     ║
║  CARÁCTER: NORMATIVO Y VINCULANTE                                        ║
║                                                                          ║
║  NIVEL 2: ÁRBOL COMPLETO v2.0.0 (1,312 líneas)                           ║
║  ──────────────────────────────────────────────────                      ║
║  Define: Estructura 5 Dominios + 21 Subdominios + 6 Subcarpetas          ║
║  Define: Justificación de cada elemento                                  ║
║  Define: Prefijos, Templates, Estados por subdominio                     ║
║                                                                          ║
║  NIVEL 3: FND_ (Fundamentos Conceptuales)                                ║
║  ──────────────────────────────────────────                              ║
║  FND_03: Estructura de Casos de Uso (830 líneas)                         ║
║  FND_05: Jerarquía 4 Niveles BR→BReq→UC→FR (576 líneas)                  ║
║  FND_06: Derivación vs Transformación (520 líneas)                       ║
║  FND_07: Requisitos Funcionales SMART (617 líneas)                       ║
║                                                                          ║
║  NIVEL 4: ESTRUCTURA v2.0.0                                              ║
║  ──────────────────────────                                              ║
║  Define: Árbol de archivos pendientes/existentes                         ║
║                                                                          ║
║  NIVEL 5: PARTE 1-4 (Metodología)                                        ║
║  ──────────────────────────────                                          ║
║  Define: Proceso de elaboración detallado                                ║
║  NOTA: FND_ ya consolidó los conceptos clave de PARTE 1-4                ║
║                                                                          ║
╚══════════════════════════════════════════════════════════════════════════╝
```

---

## 2. DOMINIO requisitos/ - ESTRUCTURA OFICIAL

### 2.1 Según ÁRBOL COMPLETO v2.0.0

```
requisitos/                                  ← DOMINIO PRIMARIO #3
│
│ PROPÓSITO: Producto funcional — qué debe hacer el sistema
│ OWNER: Business Analyst Lead / Product Owner
│ ESTADO: CONGELADO (todos subdominios en estructura plana)
│
├── index.rst
│
├── reglas_negocio/                          ← SUBDOMINIO #11 (CONGELADO)
│   │ PREFIJOS: BR_
│   │ TEMPLATE: TPL_Regla_Negocio.rst
│   │ TRAZABILIDAD: BR → UC
│   │ ESTADO: Estructura plana, <30 BRs típicamente
│   │
│   ├── index.rst
│   ├── BR_001_*.rst
│   ├── BR_002_*.rst
│   └── ...
│
├── casos_uso/                               ← SUBDOMINIO #12 (CONGELADO)
│   │ PREFIJOS: UC_
│   │ TEMPLATE: TPL_Caso_Uso.rst
│   │ TRAZABILIDAD: BR → UC → FR
│   │ ESTADO: Estructura plana, <50 UCs típicamente
│   │
│   ├── index.rst
│   ├── UC_001_Iniciar_Sesion.rst
│   ├── UC_002_Consultar_Dashboard.rst
│   ├── UC_003_Generar_Reporte.rst
│   └── ... (20-100 UCs)
│
├── requisitos_funcionales/                  ← SUBDOMINIO #13 (CONGELADO)
│   │ PREFIJOS: FR_
│   │ TEMPLATE: TPL_Requisito_Funcional.rst
│   │ TRAZABILIDAD: UC → FR → RNF
│   │ ESTADO: Estructura plana, 100-500 FRs
│   │
│   ├── index.rst
│   ├── FR_001_*.rst
│   └── ... (100-500 FRs)
│
├── requisitos_no_funcionales/               ← SUBDOMINIO #14 (CONGELADO)
│   │ PREFIJOS: RNF_
│   │ ESTADO: Estructura plana, 20-50 RNFs
│   │
│   ├── index.rst
│   └── RNF_*.rst
│
└── rtm/                                     ← SUBDOMINIO #15 (CONGELADO)
    │ PREFIJOS: RTM_
    │
    ├── index.rst
    └── RTM_01_Matriz_Trazabilidad_Global.rst
```

### 2.2 Lo que NOTA el ÁRBOL

```
CANTIDADES TÍPICAS:

- BR:  10-50 (tipicamente <30)
- UC:  20-100 (tipicamente <50)
- FR:  100-500
- RNF: 20-50
- RTM: 5-10 matrices

ESTADO: TODOS CONGELADOS
- Estructura PLANA
- Sin subcarpetas organizativas
- Sin secciones por módulo
```

---

## 3. DISCREPANCIA: TU CATÁLOGO VS ÁRBOL OFICIAL

### 3.1 El Problema

```
TU CATÁLOGO (de Obsidian):              ÁRBOL OFICIAL v2.0.0:
────────────────────────────            ─────────────────────────
UC-001 a UC-016                         UC_001_Iniciar_Sesion
UC-041 a UC-042                         UC_002_Consultar_Dashboard
+ Exportaciones                         UC_003_Generar_Reporte
+ Reportes                              ...
+ Visualización                         (estructura plana, sin categorías)

~42 UC con categorías                   ~20-100 UC sin categorías
```

### 3.2 El ÁRBOL dice ESTRUCTURA PLANA

```
casos_uso/                               ← CONGELADO = PLANO
├── index.rst
├── UC_001_*.rst
├── UC_002_*.rst
├── UC_003_*.rst
├── ...
└── UC_042_*.rst                         (TODOS directamente aquí)

NO HAY:
├── autenticacion/                       ← NO permitido (CONGELADO)
├── usuarios/                            ← NO permitido (CONGELADO)
└── reportes/                            ← NO permitido (CONGELADO)
```

### 3.3 ¿Qué pasa con las SECCIONES?

Según DEFINICIONES OFICIALES v2.0.0, Sección 4:

```
SECCIÓN (OPCIONAL):
- Carpeta de agrupación temática
- NO introduce prefijo nuevo
- NO requiere descongelamiento
- Puede crearse libremente por owner

PERO solo cuando:
- Subdominio tiene >30 artefactos
- Son del mismo tipo (mismo prefijo)
- Mejora legibilidad

EJEMPLO VÁLIDO:
casos_uso/                               ← SUBDOMINIO (CONGELADO)
├── autenticacion/                       ← SECCIÓN (agrupa UCs por módulo)
│   ├── UC_001_Login.rst
│   └── UC_002_Logout.rst
└── dashboard/                           ← SECCIÓN
    ├── UC_010_Consultar.rst
    └── UC_011_Filtrar.rst
```

---

## 4. DECISIÓN REQUERIDA

### 4.1 Opción A: Estructura Plana (ÁRBOL estricto)

```
casos_uso/
├── index.rst
├── UC_001_Iniciar_Sesion.rst
├── UC_002_Cerrar_Sesion.rst
├── UC_003_Recuperar_Contrasena.rst
├── UC_004_Cambiar_Contrasena.rst
├── UC_005_Gestion_Sesiones.rst
├── UC_006_Crear_Usuario.rst
├── ...
└── UC_042_Gestionar_Permisos_Directos.rst

PROS:
✓ 100% compliant con ÁRBOL OFICIAL
✓ Máxima simplicidad
✓ Trazabilidad trivial

CONTRAS:
✗ 42 archivos en una carpeta
✗ Difícil navegación
```

### 4.2 Opción B: Estructura con Secciones (DEFINICIONES permite)

```
casos_uso/                               ← SUBDOMINIO (CONGELADO)
│
├── index.rst                            ← Lista TODAS las secciones
│
├── autenticacion/                       ← SECCIÓN (>5 UC del mismo tipo)
│   ├── UC_001_Iniciar_Sesion.rst
│   ├── UC_002_Cerrar_Sesion.rst
│   ├── UC_003_Recuperar_Contrasena.rst
│   ├── UC_004_Cambiar_Contrasena.rst
│   └── UC_005_Gestion_Sesiones.rst
│
├── usuarios/                            ← SECCIÓN
│   ├── UC_010_Crear_Usuario.rst
│   ├── UC_011_Modificar_Usuario.rst
│   ├── UC_012_Desactivar_Usuario.rst
│   ├── UC_013_Listar_Usuarios.rst
│   └── UC_014_Asignar_Roles.rst
│
├── dashboard/                           ← SECCIÓN
│   ├── UC_050_Consultar_Dashboard.rst
│   └── UC_051_Filtrar_Metricas.rst
│
└── ...

PROS:
✓ Mejor organización con 42+ UC
✓ Permite DEFINICIONES OFICIALES (Sección 4)
✓ Navegación por módulo

CONTRAS:
✗ Requiere justificar uso de secciones
✗ Ligeramente más complejo
```

### 4.3 Mi Recomendación

```
OPCIÓN B (Secciones) es VÁLIDA según DEFINICIONES v2.0.0

Justificación:
1. Subdominio casos_uso/ tiene >30 artefactos (42+ UC)
2. Todos son del mismo tipo (prefijo UC_)
3. La agrupación mejora legibilidad
4. NO introduce nuevo prefijo
5. NO requiere descongelamiento
6. Owner (BA Lead) puede crear secciones libremente

PERO: Necesitas confirmar esta interpretación
```

---

## 5. NOMENCLATURA OFICIAL

### 5.1 Según ÁRBOL COMPLETO

```
FORMATO UC:
UC_NNN_Nombre_Descriptivo.rst

EJEMPLOS DEL ÁRBOL:
- UC_001_Iniciar_Sesion.rst
- UC_002_Consultar_Dashboard.rst
- UC_003_Generar_Reporte.rst

OBSERVACIÓN:
- Usa guión bajo (UC_001), no guión (UC-001)
- Numeración secuencial simple (001, 002, 003...)
- NO hay bloques por categoría
```

### 5.2 Mapeo de tu Catálogo

```
TU CATÁLOGO              →    NOMENCLATURA OFICIAL
─────────────────────────────────────────────────────
UC-001 Iniciar Sesión    →    UC_001_Iniciar_Sesion.rst
UC-002 Cerrar Sesión     →    UC_002_Cerrar_Sesion.rst
UC-003 Recuperar Pass    →    UC_003_Recuperar_Contrasena.rst
UC-004 Cambiar Pass      →    UC_004_Cambiar_Contrasena.rst
UC-005 Gestión Sesiones  →    UC_005_Gestion_Sesiones.rst
UC-006 Crear Usuario     →    UC_006_Crear_Usuario.rst
UC-007 Modificar Usuario →    UC_007_Modificar_Usuario.rst
UC-008 Eliminar Usuario  →    UC_008_Eliminar_Usuario.rst
UC-009 Listar Usuarios   →    UC_009_Listar_Usuarios.rst
UC-010 Asignar Roles     →    UC_010_Asignar_Roles.rst
UC-011 Gestionar Permisos→    UC_011_Gestionar_Permisos_Rol.rst
...
UC-041 Gestionar Segmentos→   UC_041_Gestionar_Segmentos.rst
UC-042 Permisos Directos →    UC_042_Gestionar_Permisos_Directos.rst
```

---

## 6. PLANTILLA OFICIAL (FND_03)

### 6.1 Estructura según FND_03

```rst
UC-NNN: [Nombre del Caso de Uso]

IDENTIFICACION:
  ID:              UC-NNN
  Nombre:          [Verbo + Objeto]
  Actor Primario:  [Rol que inicia]
  Actores Secundarios: [Otros roles involucrados]

CONTEXTO:
  Objetivo:        [Meta del actor]
  Precondiciones:  [Que debe ser verdad ANTES]
  Postcondiciones: [Que sera verdad DESPUES - exito]
  Trigger:         [Evento que inicia el UC]

FLUJOS:
  Flujo Normal:    [Pasos 1, 2, 3... secuencia exitosa]
  Flujos Alternos: [Variaciones del flujo normal]
  Excepciones:     [Errores y como manejarlos]

TRAZABILIDAD:
  Business Rules:  [BR que aplican]
  FR Derivados:    [FR que se generan de este UC]
```

### 6.2 ¿Existe TPL_Caso_Uso.rst?

Según ÁRBOL, debería existir en:
```
normativa/estandares/plantillas/TPL_Caso_Uso.rst
```

**PREGUNTA:** ¿Tienes este archivo? Si no, lo creo basado en FND_03.

---

## 7. PROCESO DE EJECUCIÓN ACTUALIZADO

### 7.1 Fase 0: Decisiones (HOY)

```
□ 1. Confirmar OPCIÓN A o B (plana vs secciones)
□ 2. Confirmar numeración (UC_001 secuencial)
□ 3. Confirmar si existe TPL_Caso_Uso.rst
□ 4. Subir 2-3 UC de Obsidian para ver formato actual
```

### 7.2 Fase 1: Migración de UC

```
Por cada UC de tu catálogo Obsidian:

1. Renombrar: UC-001 → UC_001_Iniciar_Sesion.rst
2. Convertir contenido a formato FND_03
3. Agregar trazabilidad BR → UC
4. Colocar en carpeta correcta (plana o sección)
5. Actualizar index.rst
```

### 7.3 Fase 2: Derivar FR

```
Por cada UC migrado:

1. Analizar cada paso del Flujo Normal
2. Derivar FR atómicos (FND_06: derivar, no transformar)
3. Aplicar criterios SMART (FND_07)
4. Colocar en requisitos_funcionales/
5. Actualizar RTM
```

---

## 8. PREGUNTAS FINALES

```
1. ¿OPCIÓN A (plana) o B (secciones) para casos_uso/?

2. ¿Existe TPL_Caso_Uso.rst en tu repositorio?

3. ¿Puedes subir 2-3 archivos UC de Obsidian?
   - Para ver si ya siguen FND_03
   - O necesitan adaptación

4. ¿La numeración de tu catálogo (UC-001 a UC-042) es final?
   - O hay más UC que no listaste

5. ¿BReq_ existe como subdominio separado?
   - FND_05 menciona 4 niveles: BR → BReq → UC → FR
   - ÁRBOL solo muestra: BR → UC → FR
   - ¿Se fusionó BReq con BR?
```

---

## 9. RESUMEN EJECUTIVO

```
╔══════════════════════════════════════════════════════════════════════════╗
║                         LO QUE AHORA SÉ                                  ║
╠══════════════════════════════════════════════════════════════════════════╣
║                                                                          ║
║  1. DEFINICIONES OFICIALES v2.0.0 es la FUENTE DE VERDAD                 ║
║     - Define estados CONGELADO/DESCONGELADO                              ║
║     - Permite SECCIONES en subdominios congelados (>30 artefactos)       ║
║                                                                          ║
║  2. ÁRBOL COMPLETO v2.0.0 define la estructura                           ║
║     - casos_uso/ es CONGELADO (estructura plana)                         ║
║     - Prefijo: UC_                                                       ║
║     - Template: TPL_Caso_Uso.rst                                         ║
║                                                                          ║
║  3. FND_03 define la plantilla interna de UC                             ║
║     - Identificación, Contexto, Flujos, Trazabilidad                     ║
║                                                                          ║
║  4. Tu catálogo de 42+ UC es VÁLIDO                                      ║
║     - Solo necesita migrar formato y nomenclatura                        ║
║     - PUEDE usar secciones si >30 UC (DEFINICIONES lo permite)           ║
║                                                                          ║
║  5. PENDIENTE: Tu confirmación de decisiones                             ║
║                                                                          ║
╚══════════════════════════════════════════════════════════════════════════╝
```

---

**¿Confirmas las decisiones del punto 8?**
