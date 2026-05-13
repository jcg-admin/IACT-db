# ANÁLISIS PROFUNDO: PROC_05 Y DISCREPANCIAS DEL MODELO
## Revisión Crítica del Procedimiento y Coherencia Documental

**Fecha:** 2025-12-22
**Versión:** 1.0.0
**Estado:** Análisis Crítico

---

## 1. DISCREPANCIA CRÍTICA #1: BReq en el ÁRBOL vs ESTRUCTURA

### 1.1 Lo que dice FND_05 (Jerarquía 4 Niveles)

```
FND_05 define EXPLÍCITAMENTE 4 niveles:

   Nivel 0: BR   (Business Rules)      → POR QUÉ esta restricción
   Nivel 1: BReq (Business Req.)       → POR QUÉ este proyecto
   Nivel 2: UC   (Use Cases)           → QUÉ hace el usuario
   Nivel 3: FR   (Functional Req.)     → CÓMO lo hace el sistema

   Flujo: BR → BReq → UC → FR
```

### 1.2 Lo que dice ÁRBOL_COMPLETO v2.0.0

```
ÁRBOL dice en requisitos/:

   SUBDOMINIO #11: reglas_negocio/     (BR_)
   SUBDOMINIO #12: casos_uso/          (UC_)
   SUBDOMINIO #13: requisitos_funcionales/ (FR_)
   SUBDOMINIO #14: requisitos_no_funcionales/ (RNF_)
   SUBDOMINIO #15: rtm/                (RTM_)

   ⚠️ NO EXISTE: requisitos_negocio/ (BReq_)

   Trazabilidad declarada: "BR → UC → FR → RNF"
   (Omite BReq del flujo)
```

### 1.3 Lo que dice ESTRUCTURA v2.0.0

```
ESTRUCTURA SÍ incluye requisitos_negocio/:

   requisitos/
   ├── reglas_negocio/           # BR_
   ├── requisitos_negocio/       # BReq_  ← SÍ EXISTE AQUÍ
   ├── casos_uso/                # UC_
   └── requisitos_funcionales/   # FR_

   Con artefactos:
   - BReq_001_Visualizar_Metricas.rst
   - BReq_002_Exportar_Datos.rst
   - BReq_003_Gestionar_Accesos.rst
```

### 1.4 Diagnóstico

```
╔══════════════════════════════════════════════════════════════════════════╗
║                    INCONSISTENCIA IDENTIFICADA                           ║
╠══════════════════════════════════════════════════════════════════════════╣
║                                                                          ║
║  FND_05:     BR → BReq → UC → FR (4 niveles, BReq explícito)             ║
║  ÁRBOL:      BR → UC → FR (3 niveles, BReq OMITIDO)                      ║
║  ESTRUCTURA: BR → BReq → UC → FR (4 niveles, BReq incluido)              ║
║                                                                          ║
║  ÁRBOL v2.0.0 tiene 21 subdominios pero NO lista requisitos_negocio/     ║
║  ESTRUCTURA v2.0.0 SÍ lo lista como subdominio separado                  ║
║                                                                          ║
║  PREGUNTA: ¿Cuál es la fuente de verdad?                                 ║
║                                                                          ║
╚══════════════════════════════════════════════════════════════════════════╝
```

### 1.5 Impacto en PROC_05

El procedimiento PROC_05 asume que requisitos_negocio/ (BReq_) existe como
subdominio separado, siguiendo FND_05 y ESTRUCTURA. Si ÁRBOL es la fuente
de verdad, el procedimiento tiene una fase completa (Fase 2) que no aplica.

---

## 2. DISCREPANCIA CRÍTICA #2: Conteo de Subdominios

### 2.1 ÁRBOL dice "5+21+6"

```
ÁRBOL_COMPLETO v2.0.0:
- 5 Dominios Primarios
- 21 Subdominios
- 6 Subcarpetas Organizativas
```

### 2.2 Verificación de los 21 Subdominios en ÁRBOL

```
DOMINIO 1: base_cognitiva/ (6 subdominios)
  #1  _metadata/
  #2  glosario/
  #3  fundamentos_conceptuales/
  #4  ontologia_sbvr/
  #5  taxonomias_y_metamodelos/
  #6  metodologias/

DOMINIO 2: normativa/ (4 subdominios)
  #7  procedimientos/
  #8  estandares/
  #9  gobernanza/
  #10 restricciones/

DOMINIO 3: requisitos/ (5 subdominios según ÁRBOL)
  #11 reglas_negocio/
  #12 casos_uso/
  #13 requisitos_funcionales/
  #14 requisitos_no_funcionales/
  #15 rtm/

DOMINIO 4: arquitectura_tecnica/ (3 subdominios)
  #16 arquitectura/
  #17 diseno_detallado/
  #18 integraciones/

DOMINIO 5: evidencia/ (3 subdominios)
  #19 pruebas/
  #20 trazabilidad_evidencias/
  #21 validaciones/

TOTAL: 6 + 4 + 5 + 3 + 3 = 21 subdominios ✓
```

### 2.3 Pero ESTRUCTURA v2.0.0 tiene requisitos_negocio/

```
Si agregamos requisitos_negocio/ a requisitos/:

DOMINIO 3: requisitos/ (6 subdominios)
  #11 reglas_negocio/
  #12 requisitos_negocio/        ← ADICIONAL
  #13 casos_uso/
  #14 requisitos_funcionales/
  #15 requisitos_no_funcionales/
  #16 rtm/

TOTAL: 6 + 4 + 6 + 3 + 3 = 22 subdominios

Esto rompe el modelo "5+21+6" → sería "5+22+6"
```

### 2.4 Diagnóstico

```
╔══════════════════════════════════════════════════════════════════════════╗
║                         OPCIONES DE RESOLUCIÓN                           ║
╠══════════════════════════════════════════════════════════════════════════╣
║                                                                          ║
║  OPCIÓN A: requisitos_negocio/ NO existe (ÁRBOL es verdad)               ║
║  ─────────────────────────────────────────────────────────               ║
║  - BReq se fusiona con BR en reglas_negocio/                             ║
║  - Flujo real: CNST → BR → UC → FR                                       ║
║  - BReq es concepto lógico, no subdominio físico                         ║
║  - PROC_05 debe eliminar Fase 2                                          ║
║                                                                          ║
║  OPCIÓN B: requisitos_negocio/ SÍ existe (ESTRUCTURA es verdad)          ║
║  ─────────────────────────────────────────────────────────────           ║
║  - ÁRBOL debe actualizarse a "5+22+6"                                    ║
║  - BReq es nivel separado con su propio subdominio                       ║
║  - Flujo real: CNST → BR → BReq → UC → FR                                ║
║  - PROC_05 es correcto                                                   ║
║                                                                          ║
║  OPCIÓN C: requisitos_negocio/ es SECCIÓN de reglas_negocio/             ║
║  ─────────────────────────────────────────────────────────────           ║
║  - BReq_ vive dentro de reglas_negocio/ como sección                     ║
║  - Mantiene "5+21+6"                                                     ║
║  - Pero viola definición de Sección (no introduce prefijo nuevo)         ║
║                                                                          ║
╚══════════════════════════════════════════════════════════════════════════╝
```

---

## 3. DISCREPANCIA #3: CNST en el Flujo

### 3.1 El Procedimiento Propone

```
PROC_05 Fase 0: CNST → BR

Implica que CNST (Restricciones) son ENTRADA para crear BR
```

### 3.2 Pero FND_05 dice

```
FND_05 Nivel 0 (BR):
"Las Business Rules son declaraciones sobre como opera la organizacion.
 No son creadas por el proyecto de software; existen INDEPENDIENTEMENTE
 y el software debe conformarse a ellas."

FUENTES de BR según FND_05:
- Leyes
- Regulaciones
- Estándares
- Contratos
- Políticas
- Procedimientos

NO menciona CNST_ como fuente de BR
```

### 3.3 ¿Qué son realmente los CNST?

```
Según ÁRBOL, restricciones/ está en arquitectura_tecnica/:

arquitectura_tecnica/
└── restricciones/               ← SUBDOMINIO #10
    ├── CNST_001 a CNST_010      (técnicas)

Según su PROPÓSITO:
"Límites documentales, técnicos, seguridad (AppSec)"

Los CNST son RESTRICCIONES TÉCNICAS, no políticas de negocio.
```

### 3.4 Diagnóstico

```
╔══════════════════════════════════════════════════════════════════════════╗
║                    CONFUSIÓN CONCEPTUAL IDENTIFICADA                     ║
╠══════════════════════════════════════════════════════════════════════════╣
║                                                                          ║
║  CNST_ (Restricciones Técnicas):                                         ║
║  - "BD IVR es solo lectura"                                              ║
║  - "Sincronización nocturna 00:00-06:00"                                 ║
║  - Son LIMITACIONES del sistema, no reglas de negocio                    ║
║  - Viven en arquitectura_tecnica/restricciones/                          ║
║                                                                          ║
║  BR_ (Business Rules):                                                   ║
║  - "Cliente DEBE autenticarse antes de operar"                           ║
║  - "Solo usuarios con rol X pueden ver reporte Y"                        ║
║  - Son POLÍTICAS del negocio, no limitaciones técnicas                   ║
║  - Viven en requisitos/reglas_negocio/                                   ║
║                                                                          ║
║  RELACIÓN CORRECTA:                                                      ║
║  - CNST puede INFLUIR en BR (restricción técnica afecta regla)           ║
║  - Pero BR también viene de OTRAS fuentes (políticas, regulaciones)      ║
║  - No todo BR deriva de CNST                                             ║
║  - No todo CNST genera BR                                                ║
║                                                                          ║
╚══════════════════════════════════════════════════════════════════════════╝
```

---

## 4. DISCREPANCIA #4: Numeración de UC

### 4.1 ESTRUCTURA v2.0.0 propone

```
casos_uso/
├── UC_001_Consultar_Dashboard.rst       # Deriva BReq_001
├── UC_002_Exportar_Reporte.rst          # Deriva BReq_002
└── UC_003_Gestionar_Roles.rst           # Deriva BReq_003

Solo 3 UC (muy alto nivel, casi BReq disfrazados)
```

### 4.2 Tu catálogo real tiene

```
UC-001 a UC-016 (Autenticación, Usuarios, Módulos)
UC-041, UC-042 (Segmentos)
+ Exportaciones, Reportes, Dashboard
= ~42 UC (nivel operativo detallado)
```

### 4.3 Diagnóstico

```
╔══════════════════════════════════════════════════════════════════════════╗
║                    DIFERENCIA DE GRANULARIDAD                            ║
╠══════════════════════════════════════════════════════════════════════════╣
║                                                                          ║
║  ESTRUCTURA v2.0.0:                                                      ║
║  - 3 UC muy generales ("Consultar Dashboard", "Exportar Reporte")        ║
║  - Nivel de abstracción cercano a BReq                                   ║
║  - Cada UC podría descomponerse en 10-15 UC operativos                   ║
║                                                                          ║
║  TU CATÁLOGO REAL:                                                       ║
║  - 42+ UC operativos ("Iniciar Sesión", "Crear Usuario")                 ║
║  - Nivel de abstracción correcto para derivar FR                         ║
║  - Alineado con PARTE_2 y PARTE_3 (técnicas CRUD, Larman, etc.)          ║
║                                                                          ║
║  PREGUNTA: ¿ESTRUCTURA es un modelo simplificado o el modelo real?       ║
║                                                                          ║
║  RESPUESTA PROBABLE:                                                     ║
║  ESTRUCTURA v2.0.0 es un MODELO EJEMPLO, no el catálogo final.           ║
║  Tu catálogo de 42 UC es el catálogo REAL del proyecto.                  ║
║                                                                          ║
╚══════════════════════════════════════════════════════════════════════════╝
```

---

## 5. ANÁLISIS DEL PROC_05 CREADO

### 5.1 Fortalezas

```
✅ FORTALEZAS DEL PROCEDIMIENTO:

1. INTEGRACIÓN DE FUENTES
   - Referencia todas las fuentes normativas
   - FND_03, FND_05, FND_06, FND_07
   - PARTE_1, PARTE_2, PARTE_3, PARTE_4
   - DEFINICIONES, ÁRBOL

2. FASES CLARAS
   - Fase 0: CNST (verificación)
   - Fase 1: BR (reglas)
   - Fase 2: BReq (objetivos)
   - Fase 3: UC (casos)
   - Fase 4: FR (funcionales)
   - Fase 5: RTM (trazabilidad)

3. ESTRUCTURA DE ARTEFACTOS
   - Plantillas RST completas para cada tipo
   - Sigue formato de FND_03, FND_07

4. MÉTRICAS
   - Ratios esperados (UC:FR)
   - Tiempos estimados
   - Criterios de salida por fase

5. TRAZABILIDAD
   - Cadena completa: CNST → BR → BReq → UC → FR → TST
   - Matriz RTM integrada
```

### 5.2 Debilidades

```
⚠️ DEBILIDADES IDENTIFICADAS:

1. DEPENDENCIA DE BReq (Fase 2)
   - Si ÁRBOL es verdad, BReq no tiene subdominio propio
   - Fase 2 completa podría no aplicar
   - IMPACTO: Alto

2. ASUNCIÓN CNST → BR
   - No todo BR viene de CNST
   - BR también viene de políticas, regulaciones
   - IMPACTO: Medio (Fase 0 incompleta)

3. GRANULARIDAD DE UC
   - ESTRUCTURA tiene 3 UC
   - Catálogo real tiene 42 UC
   - Procedimiento no aclara cuál usar
   - IMPACTO: Alto

4. PLANTILLAS REFERENCIADAS NO EXISTEN
   - TPL_Regla_Negocio.rst
   - TPL_Caso_Uso.rst
   - TPL_Requisito_Funcional.rst
   - Según ESTRUCTURA, están en PENDIENTE
   - IMPACTO: Bloquea ejecución

5. FALTA PROCESO DE MIGRACIÓN
   - ¿Qué hacer con UC existentes en Obsidian?
   - Procedimiento asume creación desde cero
   - IMPACTO: No aplica a situación actual
```

### 5.3 Gaps Críticos

```
🔴 GAPS QUE BLOQUEAN EJECUCIÓN:

GAP 1: ¿Existe requisitos_negocio/ como subdominio?
       Sin resolver → Fase 2 es incierta

GAP 2: ¿Plantillas TPL_*.rst existen?
       Sin resolver → No se pueden crear artefactos

GAP 3: ¿Catálogo UC = 3 o 42?
       Sin resolver → Alcance de Fase 3 desconocido

GAP 4: ¿Cómo migrar UC existentes de Obsidian?
       Sin resolver → Procedimiento no aplica a realidad
```

---

## 6. PROPUESTA DE RESOLUCIÓN

### 6.1 Acciones Inmediatas Requeridas

```
ACCIÓN 1: RESOLVER DISCREPANCIA BReq
──────────────────────────────────────
Pregunta: ¿requisitos_negocio/ (BReq_) existe como subdominio separado?

Opciones:
A) SÍ existe → Actualizar ÁRBOL a "5+22+6"
B) NO existe → Eliminar Fase 2 de PROC_05, fusionar BReq con BR
C) Es sección de reglas_negocio/ → Actualizar PROC_05

TU DECISIÓN: _______________


ACCIÓN 2: CONFIRMAR CATÁLOGO UC
──────────────────────────────────────
Pregunta: ¿Cuántos UC tiene el proyecto realmente?

Opciones:
A) 3 UC (ESTRUCTURA v2.0.0) → PROC_05 aplica como está
B) 42 UC (tu catálogo Obsidian) → PROC_05 necesita sección de migración
C) Ambos (3 macro + 42 detallados) → PROC_05 necesita aclarar niveles

TU DECISIÓN: _______________


ACCIÓN 3: CREAR PLANTILLAS FALTANTES
──────────────────────────────────────
Antes de ejecutar PROC_05, necesitamos:

□ TPL_Regla_Negocio.rst (basado en BR_001 existente o FND_02)
□ TPL_Caso_Uso.rst (basado en FND_03)
□ TPL_Requisito_Funcional.rst (basado en FND_07)

¿Las creo ahora? _______________


ACCIÓN 4: AGREGAR SECCIÓN DE MIGRACIÓN
──────────────────────────────────────
Si tienes 42 UC en Obsidian:

□ Agregar Fase 3.5: "Migración de UC Existentes"
□ Definir proceso: Obsidian/MD → RST
□ Definir mapeo de numeración

¿Agrego esta sección? _______________
```

### 6.2 Modelo de Resolución Propuesto

```
MODELO PROPUESTO (sujeto a tu aprobación):

1. requisitos_negocio/ SÍ existe como subdominio
   - Actualizar ÁRBOL a "5+22+6"
   - Mantener Fase 2 en PROC_05
   - BReq_001, BReq_002, BReq_003 ya creados van aquí

2. Catálogo UC = 42 (tu catálogo real)
   - ESTRUCTURA v2.0.0 es modelo ejemplo
   - Tu catálogo Obsidian es el real
   - Agregar Fase 3.5 de migración

3. Crear plantillas antes de ejecutar
   - Yo creo TPL_*.rst basadas en FND_*
   - Las validamos antes de continuar

4. CNST influye en BR pero no es única fuente
   - Fase 0 se renombra a "Verificar Fuentes"
   - Incluye: CNST + Políticas + Regulaciones
```

---

## 7. DIAGRAMA DE FLUJO CORREGIDO

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     FLUJO CORREGIDO DE REQUISITOS                           │
│                                                                             │
│                                                                             │
│   FUENTES EXTERNAS              DOMINIO requisitos/                         │
│   ─────────────────             ─────────────────────                       │
│                                                                             │
│   ┌──────────────┐                                                          │
│   │    CNST_     │─────┐                                                    │
│   │ (Restricc.)  │     │                                                    │
│   └──────────────┘     │        ┌──────────────┐                            │
│                        ├───────►│    BR_       │                            │
│   ┌──────────────┐     │        │ reglas_neg/  │                            │
│   │  Políticas   │─────┤        └──────┬───────┘                            │
│   │  Corporat.   │     │               │                                    │
│   └──────────────┘     │               │ influye                            │
│                        │               ▼                                    │
│   ┌──────────────┐     │        ┌──────────────┐                            │
│   │ Regulaciones │─────┘        │   BReq_      │                            │
│   │   Legales    │              │ req_negocio/ │                            │
│   └──────────────┘              └──────┬───────┘                            │
│                                        │                                    │
│                                        │ implementado por                   │
│   ┌──────────────┐                     ▼                                    │
│   │  Catálogo    │              ┌──────────────┐                            │
│   │  Obsidian    │─────────────►│    UC_       │                            │
│   │  (42 UC)     │  migrar      │  casos_uso/  │                            │
│   └──────────────┘              └──────┬───────┘                            │
│                                        │                                    │
│                                        │ deriva                             │
│                                        ▼                                    │
│                                 ┌──────────────┐                            │
│                                 │    FR_       │                            │
│                                 │ req_func/    │                            │
│                                 └──────┬───────┘                            │
│                                        │                                    │
│                                        │ verifica                           │
│                                        ▼                                    │
│                                 ┌──────────────┐                            │
│                                 │    TST_      │                            │
│                                 │  evidencia/  │                            │
│                                 └──────────────┘                            │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 8. PREGUNTAS PARA RESOLVER

```
╔══════════════════════════════════════════════════════════════════════════╗
║                    PREGUNTAS PENDIENTES                                  ║
╠══════════════════════════════════════════════════════════════════════════╣
║                                                                          ║
║  1. ¿requisitos_negocio/ (BReq_) existe como subdominio separado?        ║
║     □ SÍ (actualizar ÁRBOL)                                              ║
║     □ NO (eliminar Fase 2)                                               ║
║     □ Es sección de reglas_negocio/                                      ║
║                                                                          ║
║  2. ¿Cuál es el catálogo real de UC?                                     ║
║     □ 3 UC (ESTRUCTURA)                                                  ║
║     □ 42 UC (tu Obsidian)                                                ║
║     □ Ambos (3 macro + 42 detalle)                                       ║
║                                                                          ║
║  3. ¿Creo las plantillas TPL_*.rst ahora?                                ║
║     □ SÍ, antes de continuar                                             ║
║     □ NO, ya existen en otro lugar                                       ║
║                                                                          ║
║  4. ¿Agrego sección de migración Obsidian → RST?                         ║
║     □ SÍ                                                                 ║
║     □ NO (crearemos UC desde cero)                                       ║
║                                                                          ║
║  5. ¿CNST es la única fuente de BR?                                      ║
║     □ SÍ (Fase 0 correcta)                                               ║
║     □ NO (Fase 0 debe incluir otras fuentes)                             ║
║                                                                          ║
╚══════════════════════════════════════════════════════════════════════════╝
```

---

## 9. CONCLUSIÓN

El procedimiento PROC_05 es **estructuralmente sólido** pero tiene 
**dependencias no resueltas** que deben clarificarse antes de ejecutarlo.

Las discrepancias entre ÁRBOL, ESTRUCTURA y FND_05 deben resolverse
para tener un modelo coherente.

**Recomendación:** Resolver las 5 preguntas del punto 8 antes de
aprobar y ejecutar el procedimiento.
