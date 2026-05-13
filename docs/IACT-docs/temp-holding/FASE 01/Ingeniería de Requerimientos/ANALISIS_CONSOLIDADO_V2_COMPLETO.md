# ANÁLISIS CONSOLIDADO VERSIÓN 2.0: FRAMEWORK INTEGRADO DE INGENIERÍA DIRIGIDA POR MODELOS

**Integración de**:
- Documento 1: MDA/MDE (Desarrollo de Software Dirigido por Modelos)
- Documento 2: CRIO/Janeiro (Validación Sintáctica de SMA)
- Documento 3: BR → Sistema (Reglas de Negocio a Sistema Completo)

**Autores originales**:
- Francisco Durán Muñoz, Javier Troya Castilla, Antonio Vallecillo Moreno (MDA/MDE)
- Marcela Araujo & Alejandro Rodríguez, UTN Tucumán (CRIO)
- Nestor Monroy (BR → Sistema)

**Análisis y síntesis**: Claude (Anthropic)
**Fecha**: 2026-01-12
**Versión**: 2.0 - Consolidación Integrada

---

## TABLA DE CONTENIDOS MAESTRA

### PARTE 0: META-ANÁLISIS
1. [Visión Integradora](#1-visión-integradora)
2. [Estructura del Framework Consolidado](#2-estructura-del-framework-consolidado)
3. [Mapeo a Carpetas Conceptuales](#3-mapeo-a-carpetas-conceptuales)

### PARTE I: FUNDAMENTOS CONCEPTUALES
4. [Pirámide de Universalidad](#4-pirámide-de-universalidad)
5. [Abstracción como Principio Unificador](#5-abstracción-como-principio-unificador)
6. [Modelos y Metamodelos](#6-modelos-y-metamodelos)
7. [Transformaciones](#7-transformaciones)
8. [Trazabilidad](#8-trazabilidad)

### PARTE II: ONTOLOGÍA Y TERMINOLOGÍA
9. [Ontología Fundamental](#9-ontología-fundamental)
10. [Taxonomía Integrada](#10-taxonomía-integrada)
11. [Glosario Unificado](#11-glosario-unificado)
12. [Relaciones Ontológicas](#12-relaciones-ontológicas)

### PARTE III: METODOLOGÍAS
13. [Proceso End-to-End](#13-proceso-end-to-end)
14. [Metodología BR → UC → RF](#14-metodología-br-uc-rf)
15. [Metodología PIM → PSM → Código](#15-metodología-pim-psm-código)
16. [Metodología de Validación](#16-metodología-de-validación)

### PARTE IV: TAXONOMÍAS Y METAMODELOS
17. [Jerarquía de Metamodelos](#17-jerarquía-de-metamodelos)
18. [Taxonomía de Business Rules](#18-taxonomía-de-business-rules)
19. [Taxonomía de Transformaciones](#19-taxonomía-de-transformaciones)
20. [Taxonomía de Validaciones](#20-taxonomía-de-validaciones)

### PARTE V: APLICABILIDAD TRANS-DOMINIO
21. [Matriz de Aplicabilidad Universal](#21-matriz-de-aplicabilidad-universal)
22. [Casos de Estudio Multi-Dominio](#22-casos-de-estudio-multi-dominio)
23. [Patrón de Replicación](#23-patrón-de-replicación)

### PARTE VI: SÍNTESIS Y CONCLUSIONES
24. [Framework Consolidado](#24-framework-consolidado)
25. [Roadmap de Implementación](#25-roadmap-de-implementación)
26. [Contribuciones y Futuro](#26-contribuciones-y-futuro)

---

# PARTE 0: META-ANÁLISIS

## 1. VISIÓN INTEGRADORA

### 1.1. Los Tres Pilares del Framework

Este análisis integra **tres perspectivas complementarias** sobre ingeniería dirigida por modelos:

```
┌─────────────────────────────────────────────────────────────┐
│ PILAR 1: FUNDAMENTOS TEÓRICOS (MDA/MDE)                     │
│                                                              │
│ Qué proporciona:                                             │
│ • Marco conceptual universal (M0-M3)                         │
│ • Teoría de transformaciones de modelos                      │
│ • Lenguajes estándar (UML, OCL, MOF, ATL)                   │
│ • Principios de metamodelado                                 │
│                                                              │
│ Nivel de abstracción: MÁXIMO (filosófico-metodológico)      │
│ Aplicabilidad: 100% universal (conceptos)                   │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ PILAR 2: INGENIERÍA DE REQUISITOS (BR → Sistema)            │
│                                                              │
│ Qué proporciona:                                             │
│ • Metodología de elicitación de BR                           │
│ • Patrones de transformación BR→UC→RF                        │
│ • Técnicas de identificación completa de UC                  │
│ • Trazabilidad bidireccional                                 │
│                                                              │
│ Nivel de abstracción: MEDIO (metodológico-práctico)         │
│ Aplicabilidad: 95% (casi toda ingeniería de software)       │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ PILAR 3: IMPLEMENTACIÓN PRÁCTICA (CRIO/Janeiro)             │
│                                                              │
│ Qué proporciona:                                             │
│ • Herramientas concretas (EMF, GMF, EVL, RCP)                │
│ • Metamodelo específico (CRIO para SMA)                      │
│ • Validación sintáctica implementada                         │
│ • Generación de código desde modelos                         │
│                                                              │
│ Nivel de abstracción: MÍNIMO (implementación específica)    │
│ Aplicabilidad: 30% (dominio SMA, replicable a otros)        │
└─────────────────────────────────────────────────────────────┘
```

### 1.2. Cómo se Complementan

**Integración conceptual**:

```
MDA/MDE define:          BR→Sistema aplica:        CRIO/Janeiro implementa:
─────────────────────────────────────────────────────────────────────────
Qué es un metamodelo  →  Cómo elicitar reglas   →  Metamodelo CRIO concreto
Qué es transformación →  Patrones BR→UC→RF      →  Generación código agentes
Qué es trazabilidad   →  Matriz BR↔UC↔RF↔Código →  Validación EVL
Jerarquía M0-M3       →  BR→UC→RF→Código        →  Organización→Role→Código
Conformidad           →  BR deriva UC           →  Modelo conforme a CRIO
PIM → PSM             →  UC independiente→RF    →  Modelo Org→Impl. agentes
```

**Proceso completo end-to-end**:

```
FASE 1: ANÁLISIS (BR → Sistema)
├─ Elicitar Business Rules del dominio
├─ Clasificar en 5 tipos (Hecho, Restricción, Desencadenador, Inferencia, Cálculo)
├─ Transformar BR → User Requirements (UC)
├─ Derivar UC → Functional Requirements (RF)
├─ Completar con técnicas CRUD, Larman, UI, Stakeholders
└─ Output: SRS (Software Requirements Specification) completo

FASE 2: MODELADO CONCEPTUAL (MDA/MDE)
├─ Definir metamodelo del dominio (ej. CRIO para SMA)
├─ Crear modelo PIM desde SRS
├─ Especificar restricciones (OCL/EVL)
├─ Validar modelo contra metamodelo
└─ Output: Modelo PIM validado

FASE 3: DISEÑO ARQUITECTÓNICO (CRIO/Janeiro para SMA)
├─ Modelar organizaciones, roles, capacidades
├─ Definir protocolos e interacciones
├─ Validar sintaxis con 8 reglas EVL
├─ Refinar modelo hasta conformidad
└─ Output: Modelo arquitectónico validado

FASE 4: TRANSFORMACIÓN (MDA/MDE)
├─ Definir transformaciones PIM → PSM (ATL/QVT)
├─ Parametrizar por plataforma destino
├─ Ejecutar transformaciones
├─ Validar PSM generado
└─ Output: PSM específico de plataforma

FASE 5: GENERACIÓN (CRIO/Janeiro)
├─ Generar código desde PSM (ej. agentes Java)
├─ Compilar y desplegar
├─ Ejecutar pruebas
└─ Output: Sistema ejecutable con trazabilidad completa

FASE 6: VALIDACIÓN (Integrado)
├─ Verificar trazabilidad BR→UC→RF→PIM→PSM→Código
├─ Validar cumplimiento de BR originales
├─ Auditar conformidad con regulaciones
└─ Output: Sistema validado y certificado
```

### 1.3. Beneficio de la Integración

**Sin integración** (documentos aislados):
- MDA/MDE: Teoría desconectada de requisitos
- BR→Sistema: Metodología que termina en RF, sin diseño
- CRIO/Janeiro: Herramientas sin proceso de requisitos

**Con integración** (framework unificado):
- **Trazabilidad completa**: Regulación → BR → UC → RF → PIM → PSM → Código
- **Validación multi-nivel**: Sintáctica (EVL) + Semántica (OCL) + Negocio (BR)
- **Proceso completo**: Desde elicitación hasta implementación
- **Justificación total**: Cada línea de código rastreable a fuente de negocio

---

## 2. ESTRUCTURA DEL FRAMEWORK CONSOLIDADO

### 2.1. Arquitectura Conceptual del Framework

```
╔══════════════════════════════════════════════════════════════╗
║                    NIVEL FILOSÓFICO                           ║
║          (Principios universales - 100% aplicable)            ║
╠══════════════════════════════════════════════════════════════╣
║                                                               ║
║  FUNDAMENTOS CONCEPTUALES (_fundamentos_conceptuales/)       ║
║  ┌─────────────────────────────────────────────────────┐    ║
║  │ • Abstracción como herramienta cognitiva             │    ║
║  │ • Modelos como representaciones de sistemas          │    ║
║  │ • Transformaciones como refinamiento progresivo      │    ║
║  │ • Trazabilidad como gestión de dependencias          │    ║
║  │ • Validación como verificación de conformidad        │    ║
║  └─────────────────────────────────────────────────────┘    ║
║                                                               ║
╚══════════════════════════════════════════════════════════════╝
                           ↓
╔══════════════════════════════════════════════════════════════╗
║                  NIVEL METODOLÓGICO                           ║
║        (Procesos sistemáticos - 90% aplicable)                ║
╠══════════════════════════════════════════════════════════════╣
║                                                               ║
║  METODOLOGÍAS (_metodologias/)                                ║
║  ┌─────────────────────────────────────────────────────┐    ║
║  │ METODOLOGÍA 1: BR → UC → RF → Código                 │    ║
║  │   - Elicitación de reglas de negocio                 │    ║
║  │   - Transformación sistemática con patrones          │    ║
║  │   - Completitud con 4 técnicas                       │    ║
║  │                                                       │    ║
║  │ METODOLOGÍA 2: PIM → PSM → Implementación            │    ║
║  │   - Modelado independiente de plataforma             │    ║
║  │   - Transformación parametrizada                     │    ║
║  │   - Generación de código                             │    ║
║  │                                                       │    ║
║  │ METODOLOGÍA 3: Validación Multi-Nivel                │    ║
║  │   - Validación sintáctica (estructura)               │    ║
║  │   - Validación semántica (restricciones)             │    ║
║  │   - Validación de negocio (BR)                       │    ║
║  └─────────────────────────────────────────────────────┘    ║
║                                                               ║
╚══════════════════════════════════════════════════════════════╝
                           ↓
╔══════════════════════════════════════════════════════════════╗
║            NIVEL ONTOLÓGICO Y TAXONÓMICO                      ║
║         (Clasificaciones y relaciones - 80% aplicable)        ║
╠══════════════════════════════════════════════════════════════╣
║                                                               ║
║  ONTOLOGÍA Y TERMINOLOGÍA (_ontologia_terminologia/)          ║
║  ┌─────────────────────────────────────────────────────┐    ║
║  │ ENTIDADES FUNDAMENTALES:                             │    ║
║  │ • Business Rule (normativa)                          │    ║
║  │ • User Requirement (behavioral)                      │    ║
║  │ • Functional Requirement (especificativa)            │    ║
║  │ • Modelo (representacional)                          │    ║
║  │ • Metamodelo (definitoria)                           │    ║
║  │ • Transformación (funcional)                         │    ║
║  │                                                       │    ║
║  │ RELACIONES ONTOLÓGICAS:                              │    ║
║  │ • Conformidad (modelo ↔ metamodelo)                  │    ║
║  │ • Generación (BR → UC)                               │    ║
║  │ • Derivación (UC → RF)                               │    ║
║  │ • Implementación (RF → Código)                       │    ║
║  │ • Trazabilidad (bidireccional)                       │    ║
║  └─────────────────────────────────────────────────────┘    ║
║                                                               ║
║  TAXONOMÍAS (_taxonomias_y_metamodelos/taxonomias/)          ║
║  ┌─────────────────────────────────────────────────────┐    ║
║  │ • 5 tipos de Business Rules                          │    ║
║  │ • 3 tipos de Transformaciones (M2M, M2T, T2M)        │    ║
║  │ • 3 niveles de Validación (sintáctica, semántica, BR)│    ║
║  │ • 4 técnicas de identificación de UC                 │    ║
║  └─────────────────────────────────────────────────────┘    ║
║                                                               ║
║  METAMODELOS (_taxonomias_y_metamodelos/metamodelos/)        ║
║  ┌─────────────────────────────────────────────────────┐    ║
║  │ M3: MOF/Ecore (metametamodelo)                       │    ║
║  │ M2: UML, CRIO, DSLs específicos (metamodelos)        │    ║
║  │ M1: Modelos concretos (PIM, PSM)                     │    ║
║  │ M0: Sistemas ejecutando                              │    ║
║  └─────────────────────────────────────────────────────┘    ║
║                                                               ║
╚══════════════════════════════════════════════════════════════╝
                           ↓
╔══════════════════════════════════════════════════════════════╗
║                  NIVEL TÉCNICO                                ║
║      (Tecnologías específicas - 60% con adaptación)           ║
╠══════════════════════════════════════════════════════════════╣
║                                                               ║
║  HERRAMIENTAS Y TECNOLOGÍAS                                   ║
║  ┌─────────────────────────────────────────────────────┐    ║
║  │ • EMF (Eclipse Modeling Framework)                   │    ║
║  │ • GMF (Graphical Modeling Framework)                 │    ║
║  │ • EVL (Epsilon Validation Language)                  │    ║
║  │ • OCL (Object Constraint Language)                   │    ║
║  │ • ATL (Atlas Transformation Language)                │    ║
║  │ • QVT (Query View Transformation)                    │    ║
║  │ • Eclipse RCP (Rich Client Platform)                 │    ║
║  └─────────────────────────────────────────────────────┘    ║
║                                                               ║
╚══════════════════════════════════════════════════════════════╝
                           ↓
╔══════════════════════════════════════════════════════════════╗
║                NIVEL DE IMPLEMENTACIÓN                        ║
║          (Dominios específicos - 20-40% aplicable)            ║
╠══════════════════════════════════════════════════════════════╣
║                                                               ║
║  CASOS DE ESTUDIO                                             ║
║  ┌─────────────────────────────────────────────────────┐    ║
║  │ • Sistema de Gestión de Químicos (BR→Sistema)        │    ║
║  │ • MicroGrid (CRIO/Janeiro - SMA)                     │    ║
║  │ • Sistemas Multi-Agente Organizacionales (CRIO)      │    ║
║  │ • [Adaptable a otros dominios]                       │    ║
║  └─────────────────────────────────────────────────────┘    ║
║                                                               ║
╚══════════════════════════════════════════════════════════════╝
```

### 2.2. Niveles de Abstracción Integrados

| Nivel | Doc 1 (MDA/MDE) | Doc 2 (CRIO) | Doc 3 (BR→Sistema) | Framework Integrado |
|-------|-----------------|--------------|-------------------|---------------------|
| **M3** | MOF | Ecore | [Implícito] | Metametamodelo universal |
| **M2** | UML, SPEM | CRIO | Taxonomía BR | Metamodelos de dominio |
| **M1** | Diagrama UML | Modelo MicroGrid | Business Rules | Modelos independientes (PIM) |
| **M1'** | PSM | [Impl. agentes] | User Requirements | Modelos dependientes (PSM) |
| **M1''** | [Código] | [Código Java] | Functional Req | Especificaciones detalladas |
| **M0** | Sistema ejecutando | Agentes ejecutando | Sistema funcionando | Implementación física |

### 2.3. Flujo de Información Integrado

```
ENTRADA DEL PROCESO:
┌────────────────────────────────────────┐
│ FUENTES EXTERNAS                        │
│ • Regulaciones (OSHA, EPA, etc.)        │
│ • Políticas corporativas                │
│ • Estándares industriales               │
│ • Stakeholders del negocio              │
└────────────────────────────────────────┘
              ↓
┌────────────────────────────────────────┐
│ NIVEL 0: BUSINESS RULES                 │
│ (Doc 3 - BR→Sistema)                    │
│                                         │
│ BR_001, BR_002, ... BR_045              │
│ Clasificadas en 5 tipos                 │
│ Documentadas con plantilla estándar     │
└────────────────────────────────────────┘
              ↓ [transformación con patrones]
┌────────────────────────────────────────┐
│ NIVEL 1: USER REQUIREMENTS              │
│ (Doc 3 - BR→Sistema)                    │
│                                         │
│ UC_001, UC_002, ... UC_045              │
│ Derivados de BR + 4 técnicas            │
│ Casos de uso completos                  │
└────────────────────────────────────────┘
              ↓ [derivación]
┌────────────────────────────────────────┐
│ NIVEL 2: FUNCTIONAL REQUIREMENTS        │
│ (Doc 3 - BR→Sistema)                    │
│                                         │
│ RF_001, RF_002, ... RF_200              │
│ Especificaciones detalladas             │
│ Lógica implementable                    │
└────────────────────────────────────────┘
              ↓ [modelado]
┌────────────────────────────────────────┐
│ NIVEL 3: MODELO PIM                     │
│ (Doc 1 - MDA/MDE)                       │
│                                         │
│ Modelo conceptual del dominio           │
│ Independiente de plataforma             │
│ Conforme a metamodelo (ej. CRIO)        │
└────────────────────────────────────────┘
              ↓ [validación sintáctica]
┌────────────────────────────────────────┐
│ VALIDACIÓN CON EVL/OCL                  │
│ (Doc 2 - CRIO/Janeiro)                  │
│                                         │
│ 8 reglas EVL para CRIO                  │
│ Restricciones OCL genéricas             │
│ Verificación de conformidad             │
└────────────────────────────────────────┘
              ↓ [transformación]
┌────────────────────────────────────────┐
│ NIVEL 4: MODELO PSM                     │
│ (Doc 1 - MDA/MDE)                       │
│                                         │
│ Modelo específico de plataforma         │
│ Ejemplo: Agentes Java, .NET, etc.       │
│ Parametrizado por tecnología            │
└────────────────────────────────────────┘
              ↓ [generación]
┌────────────────────────────────────────┐
│ NIVEL 5: CÓDIGO EJECUTABLE              │
│ (Doc 2 - CRIO/Janeiro)                  │
│                                         │
│ Código fuente generado                  │
│ Ejemplo: Clases de agentes Java         │
│ Compilado y desplegado                  │
└────────────────────────────────────────┘
              ↓ [ejecución]
┌────────────────────────────────────────┐
│ NIVEL 6: SISTEMA EJECUTANDO             │
│ (Todos los documentos convergen)        │
│                                         │
│ Sistema funcionando en producción       │
│ Trazabilidad completa a BR originales   │
│ Cumplimiento demostrable                │
└────────────────────────────────────────┘
```

---

## 3. MAPEO A CARPETAS CONCEPTUALES

### 3.1. Estructura de Carpetas del Framework

```
framework_mde_integrado/
│
├── _fundamentos_conceptuales/
│   ├── README.md
│   ├── abstraccion.md
│   │   ├── definicion_dijkstra.md
│   │   ├── niveles_abstraccion.md
│   │   └── ejemplos_trans_dominio.md
│   │
│   ├── modelos_metamodelos.md
│   │   ├── que_es_modelo.md
│   │   ├── que_es_metamodelo.md
│   │   ├── jerarquia_m0_m3.md
│   │   └── conformidad.md
│   │
│   ├── transformaciones.md
│   │   ├── concepto_transformacion.md
│   │   ├── tipos_transformaciones.md
│   │   ├── lenguajes_transformacion.md
│   │   └── patrones_transformacion_br.md
│   │
│   ├── trazabilidad.md
│   │   ├── trazabilidad_forward.md
│   │   ├── trazabilidad_backward.md
│   │   ├── matrices_trazabilidad.md
│   │   └── propagacion_cambios.md
│   │
│   ├── validacion.md
│   │   ├── validacion_sintactica.md
│   │   ├── validacion_semantica.md
│   │   ├── validacion_negocio.md
│   │   └── lenguajes_validacion.md
│   │
│   ├── expresividad.md
│   ├── complejidad.md
│   └── reutilizacion.md
│
├── _metodologias/
│   ├── README.md
│   │
│   ├── br_a_sistema/
│   │   ├── parte1_identificar_br.md
│   │   │   ├── 6_preguntas_estrategicas.md
│   │   │   ├── plantilla_documentacion.md
│   │   │   └── herramientas_elicitacion.md
│   │   │
│   │   ├── parte2_transformar_br_uc.md
│   │   │   ├── patron_hechos.md
│   │   │   ├── patron_restricciones.md
│   │   │   ├── patron_desencadenadores.md
│   │   │   ├── patron_inferencias.md
│   │   │   ├── patron_calculos.md
│   │   │   └── distincion_desencadenador_inferencia.md
│   │   │
│   │   ├── parte3_identificar_uc_adicionales.md
│   │   │   ├── tecnica_crud.md
│   │   │   ├── tecnica_larman.md
│   │   │   ├── tecnica_ui_driven.md
│   │   │   ├── tecnica_stakeholders.md
│   │   │   └── consolidacion_priorizacion.md
│   │   │
│   │   └── workflow_completo.md
│   │
│   ├── mda_mde/
│   │   ├── proceso_mda.md
│   │   │   ├── modelado_pim.md
│   │   │   ├── transformacion_pim_psm.md
│   │   │   ├── generacion_codigo.md
│   │   │   └── mantenimiento.md
│   │   │
│   │   ├── metamodelado.md
│   │   │   ├── definir_sintaxis_abstracta.md
│   │   │   ├── definir_sintaxis_concreta.md
│   │   │   └── definir_semantica.md
│   │   │
│   │   └── definicion_dsl.md
│   │       ├── directamente_desde_mof.md
│   │       ├── perfiles_uml.md
│   │       └── extension_pesada_uml.md
│   │
│   ├── validacion_multi_nivel/
│   │   ├── validacion_sintactica_evl.md
│   │   │   ├── 8_reglas_crio.md
│   │   │   └── escribir_reglas_evl.md
│   │   │
│   │   ├── validacion_semantica_ocl.md
│   │   │   ├── restricciones_invariantes.md
│   │   │   ├── pre_postcondiciones.md
│   │   │   └── navegacion_colecciones.md
│   │   │
│   │   └── validacion_negocio.md
│   │       └── verificar_cumplimiento_br.md
│   │
│   ├── proceso_end_to_end/
│   │   ├── flujo_integrado.md
│   │   ├── sincronizacion_artefactos.md
│   │   └── gestion_cambios.md
│   │
│   └── mejores_practicas/
│       ├── documentacion.md
│       ├── nomenclatura.md
│       ├── versionado.md
│       └── revision.md
│
├── _ontologia_terminologia/
│   ├── README.md
│   │
│   ├── entidades_fundamentales/
│   │   ├── business_rule.md
│   │   │   ├── definicion.md
│   │   │   ├── modo_ser_normativo.md
│   │   │   └── fuentes_br.md
│   │   │
│   │   ├── user_requirement.md
│   │   │   ├── definicion.md
│   │   │   ├── modo_ser_behavioral.md
│   │   │   └── casos_uso.md
│   │   │
│   │   ├── functional_requirement.md
│   │   │   ├── definicion.md
│   │   │   ├── modo_ser_especificativo.md
│   │   │   └── derivacion_desde_uc.md
│   │   │
│   │   ├── modelo.md
│   │   │   ├── definiciones_multiples.md
│   │   │   ├── definicion_consolidada.md
│   │   │   ├── caracteristicas_selic.md
│   │   │   └── funciones_modelos.md
│   │   │
│   │   ├── metamodelo.md
│   │   │   ├── definicion.md
│   │   │   ├── relacion_con_modelo.md
│   │   │   └── ejemplos.md
│   │   │
│   │   ├── transformacion.md
│   │   │   ├── definicion.md
│   │   │   ├── tipos.md
│   │   │   └── lenguajes.md
│   │   │
│   │   └── plataforma.md
│   │
│   ├── relaciones_ontologicas/
│   │   ├── conformidad.md
│   │   ├── generacion.md
│   │   ├── derivacion.md
│   │   ├── implementacion.md
│   │   ├── influencia.md
│   │   └── trazabilidad.md
│   │
│   ├── ontologia_modal/
│   │   ├── necesidades.md
│   │   ├── posibilidades.md
│   │   └── contingencias.md
│   │
│   ├── glosario/
│   │   ├── glosario_mda_mde.md
│   │   │   ├── mbe_mde_mdd_mda.md
│   │   │   ├── pim_psm.md
│   │   │   ├── m2m_m2t_t2m.md
│   │   │   └── dsl.md
│   │   │
│   │   ├── glosario_br_sistema.md
│   │   │   ├── business_rule.md
│   │   │   ├── user_requirement.md
│   │   │   ├── functional_requirement.md
│   │   │   └── trazabilidad.md
│   │   │
│   │   └── glosario_crio.md
│   │       ├── organization.md
│   │       ├── role.md
│   │       ├── capacity.md
│   │       ├── protocol.md
│   │       └── interaction.md
│   │
│   └── comparacion_terminologias/
│       ├── mda_vs_br_sistema.md
│       ├── crio_vs_mda.md
│       └── terminologia_unificada.md
│
├── _taxonomias_y_metamodelos/
│   ├── README.md
│   │
│   ├── taxonomias/
│   │   ├── taxonomia_br/
│   │   │   ├── clasificacion_5_tipos.md
│   │   │   ├── hechos.md
│   │   │   ├── restricciones.md
│   │   │   ├── desencadenadores.md
│   │   │   ├── inferencias.md
│   │   │   ├── calculos.md
│   │   │   └── decision_tree_clasificacion.md
│   │   │
│   │   ├── taxonomia_transformaciones/
│   │   │   ├── por_direccion.md
│   │   │   │   ├── horizontales.md
│   │   │   │   └── verticales.md
│   │   │   │
│   │   │   ├── por_tipo_fuente_destino.md
│   │   │   │   ├── m2m.md
│   │   │   │   ├── m2t.md
│   │   │   │   └── t2m.md
│   │   │   │
│   │   │   └── por_metamodelos.md
│   │   │       ├── endogenas.md
│   │   │       └── exogenas.md
│   │   │
│   │   ├── taxonomia_validaciones/
│   │   │   ├── validacion_sintactica.md
│   │   │   ├── validacion_semantica.md
│   │   │   └── validacion_negocio.md
│   │   │
│   │   ├── taxonomia_uc/
│   │   │   ├── por_origen.md
│   │   │   │   ├── derivados_br.md
│   │   │   │   ├── crud.md
│   │   │   │   ├── larman.md
│   │   │   │   ├── ui_driven.md
│   │   │   │   └── stakeholders.md
│   │   │   │
│   │   │   └── por_tipo_actor.md
│   │   │       ├── actor_humano.md
│   │   │       ├── actor_sistema.md
│   │   │       └── actor_tiempo.md
│   │   │
│   │   └── taxonomia_modelos/
│   │       ├── por_nivel_abstraccion.md
│   │       ├── por_proposito.md
│   │       └── por_dominio.md
│   │
│   └── metamodelos/
│       ├── jerarquia_omg/
│       │   ├── m3_mof.md
│       │   ├── m2_uml.md
│       │   ├── m2_spem.md
│       │   ├── m2_cwm.md
│       │   └── relaciones.md
│       │
│       ├── jerarquia_eclipse/
│       │   ├── m3_ecore.md
│       │   ├── m2_crio.md
│       │   ├── m1_microgrid.md
│       │   └── relaciones.md
│       │
│       ├── crio_detallado/
│       │   ├── diagrama_metamodelo.md
│       │   ├── conceptos_principales.md
│       │   │   ├── organization.md
│       │   │   ├── role.md
│       │   │   ├── capacity.md
│       │   │   ├── protocol.md
│       │   │   └── interaction.md
│       │   │
│       │   ├── relaciones.md
│       │   └── restricciones.md
│       │
│       ├── lenguajes_restricciones/
│       │   ├── ocl/
│       │   │   ├── sintaxis.md
│       │   │   ├── tipos_expresiones.md
│       │   │   ├── colecciones.md
│       │   │   └── navegacion.md
│       │   │
│       │   └── evl/
│       │       ├── sintaxis.md
│       │       ├── estructura_constraint.md
│       │       ├── mensajes_personalizados.md
│       │       └── comparacion_con_ocl.md
│       │
│       ├── lenguajes_transformacion/
│       │   ├── atl/
│       │   │   ├── sintaxis.md
│       │   │   ├── matched_rules.md
│       │   │   ├── lazy_rules.md
│       │   │   ├── unique_lazy_rules.md
│       │   │   └── helpers.md
│       │   │
│       │   └── qvt/
│       │       ├── qvt_relations.md
│       │       ├── qvt_core.md
│       │       └── qvt_operational.md
│       │
│       └── ejemplos_metamodelos_dominio/
│           ├── sma_crio.md
│           ├── procesos_quimicos.md
│           ├── sistemas_financieros.md
│           └── [adaptable_otros].md
│
├── _casos_estudio/
│   ├── README.md
│   │
│   ├── sistema_gestion_quimicos/
│   │   ├── contexto.md
│   │   ├── business_rules.md
│   │   ├── casos_uso.md
│   │   ├── requerimientos_funcionales.md
│   │   ├── modelo_dominio.md
│   │   └── trazabilidad_completa.md
│   │
│   ├── microgrid_sma/
│   │   ├── contexto.md
│   │   ├── modelo_crio.md
│   │   ├── validacion_evl.md
│   │   ├── generacion_codigo.md
│   │   └── trazabilidad.md
│   │
│   ├── proceso_quimico_industrial/
│   │   ├── contexto.md
│   │   ├── br_procesos.md
│   │   ├── transformacion_uc.md
│   │   ├── metamodelo_proceso.md
│   │   └── sistema_control.md
│   │
│   ├── sistema_financiero/
│   │   ├── contexto.md
│   │   ├── br_regulatorias.md
│   │   ├── casos_uso.md
│   │   └── compliance.md
│   │
│   └── template_nuevo_dominio/
│       ├── 01_analizar_dominio.md
│       ├── 02_identificar_br.md
│       ├── 03_transformar_uc.md
│       ├── 04_crear_metamodelo.md
│       ├── 05_validar.md
│       └── 06_implementar.md
│
├── _aplicabilidad_trans_dominio/
│   ├── README.md
│   │
│   ├── matriz_aplicabilidad/
│   │   ├── matriz_completa.md
│   │   ├── por_nivel_abstraccion.md
│   │   └── por_dominio.md
│   │
│   ├── patron_replicacion/
│   │   ├── fase1_analisis_dominio.md
│   │   ├── fase2_definicion_metamodelo.md
│   │   ├── fase3_sintaxis_concreta.md
│   │   ├── fase4_transformaciones.md
│   │   ├── fase5_herramienta_case.md
│   │   └── fase6_validacion.md
│   │
│   ├── factores_exito/
│   │   ├── facilitadores.md
│   │   └── barreras.md
│   │
│   └── dominios_especificos/
│       ├── ingenieria_software.md
│       ├── ingenieria_sistemas.md
│       ├── ingenieria_electrica.md
│       ├── ingenieria_mecanica.md
│       ├── ingenieria_quimica.md
│       ├── arquitectura_edificios.md
│       ├── medicina_protocolos.md
│       ├── derecho_sistemas.md
│       └── [otros].md
│
├── _herramientas/
│   ├── README.md
│   │
│   ├── eclipse_ecosystem/
│   │   ├── emf.md
│   │   ├── gmf.md
│   │   ├── epsilon_evl.md
│   │   ├── atl.md
│   │   └── rcp.md
│   │
│   ├── omg_standards/
│   │   ├── uml.md
│   │   ├── mof.md
│   │   ├── ocl.md
│   │   ├── qvt.md
│   │   └── xmi.md
│   │
│   ├── janeiro_studio/
│   │   ├── instalacion.md
│   │   ├── uso_basico.md
│   │   ├── modelado_crio.md
│   │   └── validacion_evl.md
│   │
│   └── alternativas/
│       ├── metaedit.md
│       ├── xtext.md
│       └── otros.md
│
├── _integracion/
│   ├── README.md
│   │
│   ├── workflow_integrado/
│   │   ├── fase1_requisitos.md
│   │   ├── fase2_modelado.md
│   │   ├── fase3_diseno.md
│   │   ├── fase4_transformacion.md
│   │   ├── fase5_generacion.md
│   │   └── fase6_validacion.md
│   │
│   ├── sincronizacion_artefactos/
│   │   ├── br_uc_sincronizados.md
│   │   ├── uc_rf_sincronizados.md
│   │   ├── rf_modelo_sincronizados.md
│   │   └── modelo_codigo_sincronizados.md
│   │
│   └── gestion_cambios/
│       ├── cambio_en_br.md
│       ├── cambio_en_modelo.md
│       ├── cambio_en_plataforma.md
│       └── estrategias_migracion.md
│
└── _referencias/
    ├── bibliografia_mda_mde.md
    ├── bibliografia_br_sistema.md
    ├── bibliografia_crio.md
    ├── articulos_clave.md
    ├── libros_recomendados.md
    └── recursos_online.md
```

### 3.2. Mapeo de Conceptos a Carpetas

**TABLA MAESTRA DE MAPEO**:

| Concepto | Carpeta Principal | Subcarpeta | Archivo |
|----------|------------------|-----------|---------|
| **Abstracción (Dijkstra)** | `_fundamentos_conceptuales/` | `abstraccion/` | `definicion_dijkstra.md` |
| **Jerarquía M0-M3** | `_fundamentos_conceptuales/` | `modelos_metamodelos/` | `jerarquia_m0_m3.md` |
| **Conformidad** | `_ontologia_terminologia/` | `relaciones_ontologicas/` | `conformidad.md` |
| **5 tipos de BR** | `_taxonomias_y_metamodelos/` | `taxonomias/taxonomia_br/` | `clasificacion_5_tipos.md` |
| **Desencadenador vs Inferencia** | `_taxonomias_y_metamodelos/` | `taxonomias/taxonomia_br/` | `decision_tree_clasificacion.md` |
| **Patrones transformación BR→UC** | `_metodologias/` | `br_a_sistema/parte2_transformar_br_uc/` | `patron_desencadenadores.md` |
| **Técnica CRUD** | `_metodologias/` | `br_a_sistema/parte3_identificar_uc_adicionales/` | `tecnica_crud.md` |
| **Validación EVL** | `_metodologias/` | `validacion_multi_nivel/` | `validacion_sintactica_evl.md` |
| **8 reglas CRIO** | `_metodologias/` | `validacion_multi_nivel/validacion_sintactica_evl/` | `8_reglas_crio.md` |
| **Metamodelo CRIO** | `_taxonomias_y_metamodelos/` | `metamodelos/crio_detallado/` | `diagrama_metamodelo.md` |
| **OCL colecciones** | `_taxonomias_y_metamodelos/` | `metamodelos/lenguajes_restricciones/ocl/` | `colecciones.md` |
| **ATL matched rules** | `_taxonomias_y_metamodelos/` | `metamodelos/lenguajes_transformacion/atl/` | `matched_rules.md` |
| **Trazabilidad forward** | `_fundamentos_conceptuales/` | `trazabilidad/` | `trazabilidad_forward.md` |
| **Proceso PIM→PSM** | `_metodologias/` | `mda_mde/proceso_mda/` | `transformacion_pim_psm.md` |
| **Caso MicroGrid** | `_casos_estudio/` | `microgrid_sma/` | `contexto.md` |
| **Aplicabilidad Ing. Química** | `_aplicabilidad_trans_dominio/` | `dominios_especificos/` | `ingenieria_quimica.md` |

### 3.3. Contenido de Archivos README.md

**`_fundamentos_conceptuales/README.md`**:
```markdown
# Fundamentos Conceptuales

Esta carpeta contiene los **principios universales** (100% aplicables a todo dominio) 
que sustentan el framework de ingeniería dirigida por modelos.

## Contenido

### 1. Abstracción
Principio fundamental de destacar características esenciales desde un punto de vista,
ignorando lo irrelevante. Base de todo modelado.

- **Definición de Dijkstra**: "Ser abstracto no significa ser impreciso"
- **Niveles de abstracción**: M0 (sistema) → M1 (modelo) → M2 (metamodelo) → M3 (MOF)
- **Ejemplos trans-dominio**: Planos de ciudad, arquitectura de edificios, procesos químicos

### 2. Modelos y Metamodelos
Representaciones de sistemas y definiciones de lenguajes de modelado.

- **¿Qué es un modelo?**: Especificación/descripción de un sistema desde un punto de vista
- **¿Qué es un metamodelo?**: Modelo de un lenguaje de modelado
- **Jerarquía M0-M3**: La organización de 4 niveles de la OMG
- **Relación de conformidad**: Modelo conforme a metamodelo

### 3. Transformaciones
Proceso de convertir un modelo en otro modelo del mismo sistema.

- **Concepto**: Conjunto de reglas que describen cómo transformar modelos
- **Tipos**: M2M, M2T, T2M, horizontales, verticales, endógenas, exógenas
- **Lenguajes**: ATL, QVT, ETL
- **Patrones**: Los 5 patrones de transformación BR→UC

### 4. Trazabilidad
Capacidad de rastrear relaciones entre elementos en diferentes niveles.

- **Forward tracing**: Análisis de impacto (BR cambia → ¿qué actualizar?)
- **Backward tracing**: Justificación (Código → ¿de dónde viene?)
- **Matrices**: BR ↔ UC ↔ RF ↔ Código
- **Propagación de cambios**: Actualización coordinada

### 5. Validación
Verificación de conformidad de modelos contra reglas.

- **Validación sintáctica**: Estructura correcta (EVL)
- **Validación semántica**: Restricciones cumplidas (OCL)
- **Validación de negocio**: BR respetadas

## Origen de conceptos

- **Abstracción, Expresividad, Complejidad, Reutilización**: MDA/MDE (Doc 1)
- **Transformaciones, Trazabilidad**: BR→Sistema (Doc 3) + MDA/MDE (Doc 1)
- **Validación multi-nivel**: CRIO/Janeiro (Doc 2)
- **Integración**: Framework consolidado
```

**`_metodologias/README.md`**:
```markdown
# Metodologías

Esta carpeta contiene los **procesos sistemáticos** (90% aplicables) para
transformar desde requisitos hasta implementación.

## Metodologías Principales

### 1. BR → UC → RF (Ingeniería de Requisitos)
**Origen**: Documento "De Reglas de Negocio a Sistema Completo"

Proceso de 3 partes:
- **PARTE 1**: Identificar Business Rules (6 preguntas estratégicas)
- **PARTE 2**: Transformar BR → UC (5 patrones de transformación)
- **PARTE 3**: Identificar UC adicionales (4 técnicas: CRUD, Larman, UI, Stakeholders)

**Aplicabilidad**: 95% (casi todo software empresarial)

### 2. PIM → PSM → Código (Model-Driven Architecture)
**Origen**: Documento "MDA/MDE"

Proceso MDA:
- **Modelado PIM**: Independiente de plataforma
- **Transformación**: PIM → PSM parametrizada
- **Generación**: PSM → Código

**Aplicabilidad**: 90% (toda ingeniería de software)

### 3. Validación Multi-Nivel
**Origen**: Documento "CRIO/Janeiro" + Integración

Validación en 3 niveles:
- **Sintáctica**: Estructura (EVL con 8 reglas para CRIO)
- **Semántica**: Restricciones (OCL)
- **Negocio**: Cumplimiento de BR

**Aplicabilidad**: 100% (universal)

## Proceso Integrado End-to-End

1. Elicitar BR (Metodología 1)
2. Transformar BR → UC → RF (Metodología 1)
3. Modelar PIM desde RF (Metodología 2)
4. Validar PIM (Metodología 3)
5. Transformar PIM → PSM (Metodología 2)
6. Generar código desde PSM (Metodología 2)
7. Validar trazabilidad completa (Metodología 3)

## Mejores Prácticas

- **Documentación**: Plantillas estándar para BR, UC, RF
- **Nomenclatura**: Convenciones consistentes
- **Versionado**: Control de cambios en todos los niveles
- **Revisión**: Checklist de calidad
```

**`_ontologia_terminologia/README.md`**:
```markdown
# Ontología y Terminología

Esta carpeta contiene las **definiciones formales** y **clasificaciones** de
entidades y relaciones del framework.

## Entidades Fundamentales

### Business Rule (Normativa)
- **Modo de ser**: Normativo (prescribe, no describe)
- **Existencia**: Independiente del sistema
- **Origen**: Regulaciones, políticas, estándares
- **Cambio**: Lento, controlado externamente

### User Requirement (Behavioral)
- **Modo de ser**: Descriptivo (comportamiento observable)
- **Existencia**: Dependiente de BR
- **Origen**: Transformación de BR
- **Cambio**: Medio

### Functional Requirement (Especificativa)
- **Modo de ser**: Especificativo (qué debe hacer)
- **Existencia**: Dependiente de UR
- **Origen**: Derivación de UR
- **Cambio**: Rápido

### Modelo (Representacional)
- **Modo de ser**: Representacional (abstracción de sistema)
- **Existencia**: Conforme a metamodelo
- **Origen**: Modelado desde requisitos
- **Cambio**: Medio

### Metamodelo (Definitoria)
- **Modo de ser**: Definitorio (define lenguaje)
- **Existencia**: Conforme a MOF/Ecore
- **Origen**: Diseño de DSL
- **Cambio**: Lento

### Transformación (Funcional)
- **Modo de ser**: Funcional (entrada → salida)
- **Existencia**: Entre metamodelos
- **Origen**: Diseño de proceso
- **Cambio**: Medio

## Relaciones Ontológicas

- **Conformidad**: Modelo ↔ Metamodelo
- **Generación**: BR → UC (con patrones)
- **Derivación**: UC → RF (descomposición)
- **Implementación**: RF → Código
- **Influencia**: BR ⇢ múltiples aspectos
- **Trazabilidad**: Bidireccional en todos los niveles

## Ontología Modal

### Necesidades (DEBE)
- Todo UR DEBE derivar de BR o técnica sistemática
- Todo FR DEBE derivar de UR
- Trazabilidad DEBE ser bidireccional

### Posibilidades (PUEDE)
- Un BR PUEDE generar múltiples UR
- Un UR PUEDE derivar múltiples FR
- Trazabilidad PUEDE automatizarse

### Contingencias (Decisiones)
- Qué técnica usar para UC adicionales
- Cómo priorizar UC
- Qué herramientas usar

## Glosarios

### Documento MDA/MDE
- MBE, MDE, MDD, MDA
- PIM, PSM, CIM
- M2M, M2T, T2M
- DSL, MOF, UML, OCL, ATL, QVT

### Documento BR → Sistema
- Business Rule, User Requirement, Functional Requirement
- Desencadenador vs Inferencia
- CRUD, Larman, UI-Driven, Stakeholders

### Documento CRIO
- Organization, Role, Capacity, Protocol, Interaction
- EVL, Constraint, Check, Fix
```

**`_taxonomias_y_metamodelos/README.md`**:
```markdown
# Taxonomías y Metamodelos

Esta carpeta contiene **clasificaciones sistemáticas** y **definiciones formales**
de lenguajes de modelado.

## Taxonomías

### 1. Taxonomía de Business Rules (5 tipos)
- **Hechos**: Verdades sobre el dominio
- **Restricciones**: Limitaciones obligatorias
- **Desencadenadores**: Condición → Comportamiento observable
- **Inferencias**: Condición → Nuevo hecho interno
- **Cálculos**: Fórmulas y algoritmos

**Criterio de clasificación**: Naturaleza y efecto de la regla

### 2. Taxonomía de Transformaciones
**Por dirección**:
- Horizontales (mismo nivel abstracción)
- Verticales (cambian nivel)

**Por tipo de fuente/destino**:
- M2M (modelo a modelo)
- M2T (modelo a texto)
- T2M (texto a modelo)

**Por metamodelos**:
- Endógenas (mismo metamodelo)
- Exógenas (diferente metamodelo)

### 3. Taxonomía de Validaciones
- **Sintáctica**: Estructura correcta
- **Semántica**: Restricciones cumplidas
- **Negocio**: BR respetadas

### 4. Taxonomía de Casos de Uso
**Por origen**:
- Derivados de BR (22%)
- CRUD (40%)
- Larman (36%)
- UI-Driven (9%)
- Stakeholders (9%)

**Por tipo de actor**:
- Actor humano
- Actor sistema
- Actor tiempo (eventos temporales)

## Metamodelos

### Jerarquía OMG
- **M3**: MOF (Meta-Object Facility)
- **M2**: UML, SPEM, CWM
- **M1**: Diagramas UML específicos
- **M0**: Sistemas ejecutando

### Jerarquía Eclipse
- **M3**: Ecore
- **M2**: CRIO, otros DSLs
- **M1**: Modelos concretos (ej. MicroGrid)
- **M0**: Agentes ejecutando

### CRIO Detallado
Metamodelo para Sistemas Multi-Agente Organizacionales

**Conceptos principales**:
- Organization (contenedor)
- Role (comportamiento esperado)
- Capacity (know-how)
- Protocol (interacción)
- Interaction (secuencia de eventos)

**Relaciones**:
- Organization ⊃ Roles [1..*]
- Role → Capacity [0..*]
- Protocol ⊃ Interactions [1..*]

**8 Reglas EVL**:
1. Existencia de roles
2. Unicidad de nombres
3. Cardinalidades correctas
4. Referencias válidas
5. Atributos obligatorios
6. Tipos compatibles
7. Consistencia relaciones
8. Completitud del modelo

### Lenguajes de Restricciones
- **OCL**: Estándar OMG, complejo pero potente
- **EVL**: Epsilon, modular, mensajes personalizables

### Lenguajes de Transformación
- **ATL**: Declarativo + imperativo, ampliamente adoptado
- **QVT**: Estándar OMG, 3 variantes (Relations, Core, Operational)

## Ejemplos de Metamodelos de Dominio

- **SMA**: CRIO
- **Procesos químicos**: (ejemplo en casos de estudio)
- **Sistemas financieros**: (ejemplo en casos de estudio)
- **[Otros dominios]**: Patrón replicable
```

---

# PARTE I: FUNDAMENTOS CONCEPTUALES

## 4. PIRÁMIDE DE UNIVERSALIDAD

### 4.1. Los 4 Niveles de Abstracción

```
┌─────────────────────────────────────────────────────────────┐
│ NIVEL 1: FILOSÓFICO                                          │
│ Universalidad: 100%                                          │
│                                                              │
│ PRINCIPIOS FUNDAMENTALES                                     │
│ • Abstracción como herramienta cognitiva                     │
│ • Modelos como representaciones de sistemas                  │
│ • Transformaciones como refinamiento progresivo              │
│ • Separación de concerns (qué vs cómo)                       │
│ • Trazabilidad como gestión de dependencias                  │
│                                                              │
│ Aplicable a: TODO el conocimiento humano                     │
│ Origen: Filosofía de la ciencia, epistemología               │
│ Documentos: Todos (implícito en fundamentos)                 │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ NIVEL 2: METODOLÓGICO                                        │
│ Universalidad: 90%                                           │
│                                                              │
│ PATRONES Y PROCESOS                                          │
│ • Patrón PIM → PSM → Código                                  │
│ • Transformación sistemática con reglas                      │
│ • Validación mediante restricciones                          │
│ • Trazabilidad bidireccional                                 │
│ • Metamodelado para definir lenguajes                        │
│                                                              │
│ Aplicable a: Toda ingeniería (software, sistemas, procesos)  │
│ Origen: Ingeniería de software, MDA/MDE                      │
│ Documentos: MDA/MDE + BR→Sistema (metodologías)              │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ NIVEL 3: TÉCNICO                                             │
│ Universalidad: 50-70% (con adaptación)                       │
│                                                              │
│ TECNOLOGÍAS GENÉRICAS                                        │
│ • EMF (metamodelado)                                         │
│ • OCL/EVL (restricciones)                                    │
│ • ATL/QVT (transformaciones)                                 │
│ • GMF (editores gráficos)                                    │
│ • Jerarquía M0-M3                                            │
│                                                              │
│ Aplicable a: Dominios formalizables                          │
│ Origen: Eclipse ecosystem, estándares OMG                    │
│ Documentos: MDA/MDE + CRIO/Janeiro (herramientas)            │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│ NIVEL 4: IMPLEMENTACIÓN                                      │
│ Universalidad: 20-40% (dominio-específico)                   │
│                                                              │
│ SOLUCIONES CONCRETAS                                         │
│ • CRIO (SMA organizacionales)                                │
│ • Janeiro Studio (herramienta específica)                    │
│ • Sistema gestión químicos (caso concreto)                   │
│ • MicroGrid (modelo específico)                              │
│                                                              │
│ Aplicable a: Dominio específico (SMA, químicos, etc.)        │
│ Origen: Implementaciones particulares                        │
│ Documentos: CRIO/Janeiro + BR→Sistema (casos de estudio)     │
└─────────────────────────────────────────────────────────────┘
```

### 4.2. Mapeo de Documentos a Niveles

| Documento | Nivel 1 (Filosófico) | Nivel 2 (Metodológico) | Nivel 3 (Técnico) | Nivel 4 (Implementación) |
|-----------|---------------------|----------------------|------------------|-------------------------|
| **MDA/MDE** | ✅✅✅ (principios universales) | ✅✅✅ (patrón PIM→PSM) | ✅✅✅ (EMF, OCL, ATL) | ✅ (ejemplos genéricos) |
| **BR→Sistema** | ✅✅ (abstracción, trazabilidad) | ✅✅✅ (metodología 3 partes) | ✅✅ (plantillas, técnicas) | ✅✅✅ (caso químicos) |
| **CRIO/Janeiro** | ✅ (implícito) | ✅✅ (proceso validación) | ✅✅✅ (EVL, GMF, RCP) | ✅✅✅ (CRIO, MicroGrid) |
| **Framework integrado** | ✅✅✅ (síntesis conceptual) | ✅✅✅ (proceso end-to-end) | ✅✅✅ (stack completo) | ✅✅✅ (múltiples dominios) |

### 4.3. Principios del Nivel Filosófico (100% Universal)

**PRINCIPIO 1: Abstracción**

**Definición (Dijkstra)**:
> "Ser abstracto no significa en absoluto ser impreciso [...] El principal propósito de la abstracción es definir un nivel semántico en el que poder ser totalmente preciso."

**Aplicabilidad universal**:
```
Ingeniería Software:   Modelo UML abstrae clases y relaciones
Ingeniería Química:    Diagrama P&ID abstrae equipos y flujos
Arquitectura:          Plano conceptual abstrae espacios y funciones
Medicina:              Protocolo abstrae tratamiento genérico
Derecho:               Norma abstrae comportamiento regulado
```

**Mapeo a carpeta**: `_fundamentos_conceptuales/abstraccion/`

**PRINCIPIO 2: Modelos como Representaciones**

**Definición consolidada** (desde Doc 1):
> "Un modelo de un cierto <X> es una especificación o descripción de ese <X> desde un determinado punto de vista, expresado en un lenguaje bien definido y con un propósito determinado."

**Características universales** (Bran Selic):
1. Adecuados (propósito concreto)
2. Abstractos (enfatizan lo importante)
3. Comprensibles (lenguaje entendible)
4. Precisos (representan fielmente)
5. Predictivos (responden preguntas)
6. Rentables (más baratos que construir el sistema)

**Aplicabilidad universal**:
```
TODO dominio que involucre diseño/construcción/análisis de sistemas complejos
puede beneficiarse de modelos como representaciones.
```

**Mapeo a carpeta**: `_fundamentos_conceptuales/modelos_metamodelos/`

**PRINCIPIO 3: Transformaciones como Refinamiento**

**Concepto universal**:
```
Modelo abstracto (alto nivel)
    ↓ [refinamiento progresivo]
Modelo concreto (bajo nivel)
    ↓ [refinamiento final]
Implementación (sistema físico)
```

**Ejemplos trans-dominio**:
```
Software:      PIM → PSM → Código
Arquitectura:  Boceto → Planos técnicos → Construcción
Ing. Química:  Proceso conceptual → Diseño planta → Operación
Música:        Idea → Partitura → Interpretación
```

**Mapeo a carpeta**: `_fundamentos_conceptuales/transformaciones/`

**PRINCIPIO 4: Trazabilidad como Gestión de Dependencias**

**Concepto universal**:
```
Fuente original ←→ Derivaciones
                ↕
        Bidireccionalidad
```

**Preguntas universales**:
- **Forward**: Si fuente cambia, ¿qué actualizar?
- **Backward**: ¿De dónde viene este elemento?

**Aplicabilidad**:
```
Software:      Regulación ← BR ← UC ← RF ← Código
Construcción:  Normativa ← Especificación ← Planos ← Edificio
Farmacia:      Ensayo clínico ← Protocolo ← Medicamento ← Uso
```

**Mapeo a carpeta**: `_fundamentos_conceptuales/trazabilidad/`

**PRINCIPIO 5: Separación de Concerns**

**Concepto**:
```
QUÉ (funcionalidad) ≠ CÓMO (implementación)
```

**Manifestaciones**:
```
MDA:          PIM (qué) vs PSM (cómo)
BR→Sistema:   UC (qué hace usuario) vs RF (cómo lo hace sistema)
Arquitectura: Programa arquitectónico (qué) vs diseño técnico (cómo)
```

**Beneficio universal**: Permite evolución independiente de aspectos.

---

## 5. ABSTRACCIÓN COMO PRINCIPIO UNIFICADOR

### 5.1. Abstracción en los 3 Documentos

**Documento 1 (MDA/MDE)**:

**Definición explícita**:
> "Abstraer significa destacar una serie de características esenciales de un sistema u objeto, desde un determinado punto de vista, ignorando aquellas otras características que no son relevantes desde esa perspectiva."

**Niveles de abstracción en MDA**:
```
M3 (Metametamodelo):  Mayor abstracción
M2 (Metamodelo):      Define lenguajes
M1 (Modelo):          Instancias de lenguaje
M0 (Sistema):         Menor abstracción (realidad física)
```

**Ejemplos**:
- Planos de ciudad (metro, callejero, topográfico, ruido)
- Cada uno abstrae aspectos diferentes

**Documento 2 (CRIO/Janeiro)**:

**Abstracción implícita**:
```
CRIO (metamodelo) abstrae conceptos de SMA organizacionales:
  - Organization (estructura colectiva)
  - Role (comportamiento esperado)
  - Capacity (know-how)
  
Ignora detalles de implementación:
  - Lenguaje de programación
  - Plataforma de agentes
  - Protocolos de comunicación de bajo nivel
```

**Documento 3 (BR→Sistema)**:

**Jerarquía de abstracción**:
```
Business Rules (más abstracto, estable)
    ↓
Business Requirements (objetivos de proyecto)
    ↓
User Requirements (comportamientos observables)
    ↓
Functional Requirements (especificaciones detalladas)
    ↓
Código (menos abstracto, cambiante)
```

**Principio común**: Cada nivel abstrae características apropiadas para su propósito.

### 5.2. Abstracción Trans-Dominio

**Patrón universal**:

```python
class DomainAbstraction:
    """Patrón universal de abstracción para cualquier dominio"""
    
    def __init__(self, domain, viewpoint, purpose):
        self.domain = domain              # Qué se modela
        self.viewpoint = viewpoint         # Desde qué perspectiva
        self.purpose = purpose             # Para qué propósito
        self.essential_features = []       # Qué se incluye
        self.ignored_features = []         # Qué se ignora
        
    def abstract(self, system):
        """Crear abstracción del sistema"""
        model = Model()
        
        for feature in system.features:
            if self.is_relevant(feature, self.viewpoint, self.purpose):
                model.add(feature, abstracted=True)
            else:
                # Ignorar característica irrelevante
                self.ignored_features.append(feature)
        
        return model
    
    def is_relevant(self, feature, viewpoint, purpose):
        """Determinar si característica es relevante"""
        # Lógica específica del dominio
        return feature.is_essential_for(viewpoint, purpose)
```

**Ejemplos de uso**:

```python
# Ingeniería de Software
abstraccion_sw = DomainAbstraction(
    domain="Sistema bancario",
    viewpoint="Operaciones de negocio",
    purpose="Especificar funcionalidad"
)
# Abstrae: Casos de uso, entidades, flujos
# Ignora: Lenguaje programación, base de datos, UI

# Ingeniería Química
abstraccion_quimica = DomainAbstraction(
    domain="Planta química",
    viewpoint="Proceso productivo",
    purpose="Diseñar proceso"
)
# Abstrae: Operaciones unitarias, corrientes, T/P
# Ignora: Materiales de construcción, instrumentación, válvulas

# Arquitectura
abstraccion_arquitectura = DomainAbstraction(
    domain="Edificio residencial",
    viewpoint="Distribución espacial",
    purpose="Diseño conceptual"
)
# Abstrae: Espacios, relaciones, flujos
# Ignora: Materiales, estructuras, instalaciones
```

### 5.3. Criterios de Buena Abstracción

**Del documento MDA/MDE** (Bran Selic):

1. **Adecuada**: ¿Es apropiada para el propósito?
2. **Abstracta**: ¿Oculta lo irrelevante?
3. **Comprensible**: ¿Entendible para usuarios?
4. **Precisa**: ¿Representa fielmente?
5. **Predictiva**: ¿Permite inferir conclusiones?
6. **Rentable**: ¿Más barata que construir el sistema?

**Checklist de validación**:

```markdown
□ ¿El modelo tiene un propósito CLARO?
□ ¿El punto de vista está BIEN DEFINIDO?
□ ¿Las características esenciales están PRESENTES?
□ ¿Las características irrelevantes están AUSENTES?
□ ¿Es COMPRENSIBLE para el usuario objetivo?
□ ¿Es más PRECISO que ambiguo?
□ ¿Permite RAZONAR sobre el sistema?
□ ¿Es más BARATO que construir/experimentar con el sistema real?
```

**Mapeo a carpeta**: `_fundamentos_conceptuales/abstraccion/criterios_buena_abstraccion.md`

---

## 6. MODELOS Y METAMODELOS

### 6.1. Definición Consolidada de Modelo

**Síntesis de definiciones** (de Doc 1 - MDA/MDE):

```
DEFINICIÓN CONSOLIDADA:

"Un modelo de un cierto <X> es una especificación o descripción de 
ese <X> desde un determinado punto de vista, expresado en un lenguaje 
bien definido y con un propósito determinado."

Donde:
  <X> = Sistema existente o imaginario que se modela
  Especificación = Cuando <X> no existe todavía (diseño)
  Descripción = Cuando <X> ya existe (análisis)
  Punto de vista = Perspectiva desde la que se abstrae
  Lenguaje = UML, CRIO, BPMN, o cualquier DSL
  Propósito = Para qué se crea el modelo
```

**Fuentes integradas**:
- Warmer & Kleppe (2003): "Descripción en lenguaje bien definido"
- OMG (2001): "Representación de funcionalidad/estructura/comportamiento"
- OMG (2003): "Descripción para cierto propósito"
- OMG UML (2010): "Vista con propósito que determina contenido"
- Seidewitz (2003): "Conjunto de sentencias sobre sistema"
- Ross & Minsky (1960): "M es modelo de S si responde preguntas sobre S"

### 6.2. Definición Consolidada de Metamodelo

**Del documento MDA/MDE**:

```
DEFINICIÓN:

"Un metamodelo es un modelo que especifica los conceptos de un lenguaje, 
las relaciones entre ellos y las reglas estructurales que restringen los 
posibles elementos de los modelos válidos, así como aquellas combinaciones 
entre elementos que respetan las reglas semánticas del dominio."

En otras palabras:
  Metamodelo = Modelo de un lenguaje de modelado
```

**Componentes de un metamodelo**:

```
┌─────────────────────────────────────────┐
│ METAMODELO                               │
│                                          │
│ 1. CONCEPTOS (vocabulario)               │
│    - Clases abstractas                   │
│    - Atributos                           │
│                                          │
│ 2. RELACIONES (estructura)               │
│    - Asociaciones                        │
│    - Composiciones                       │
│    - Herencia                            │
│                                          │
│ 3. RESTRICCIONES (reglas)                │
│    - Cardinalidades                      │
│    - Tipos                               │
│    - OCL/EVL                             │
└─────────────────────────────────────────┘
```

**Ejemplo - Metamodelo UML**:
```
Conceptos: Package, Classifier, Class, Operation, Association, etc.
Relaciones: Class hereda de Classifier, Operation pertenece a Class
Restricciones: "Asociaciones solo conectan classifiers, no paquetes"
```

**Ejemplo - Metamodelo CRIO** (Doc 2):
```
Conceptos: Organization, Role, Capacity, Protocol, Interaction
Relaciones: Organization ⊃ Role [1..*], Role → Capacity [0..*]
Restricciones: 8 reglas EVL (existencia, unicidad, cardinalidad, etc.)
```

### 6.3. Jerarquía M0-M1-M2-M3

**De MDA/MDE - La organización en 4 niveles de la OMG**:

```
╔═══════════════════════════════════════════════════════════════╗
║ M3: METAMETAMODELO                                             ║
║     (MOF, Ecore)                                               ║
║     • Define lenguaje para describir metamodelos               ║
║     • Conforme a SÍ MISMO (cierre reflexivo)                   ║
║     • Ejemplos: MOF (OMG), Ecore (Eclipse)                     ║
╚═══════════════════════════════════════════════════════════════╝
                       ↑ conforme a (auto-referencia)
                       │
╔═══════════════════════════════════════════════════════════════╗
║ M2: METAMODELO                                                 ║
║     (UML, CRIO, SPEM, CWM, DSLs)                               ║
║     • Define lenguajes de modelado específicos                 ║
║     • Conforme a M3                                            ║
║     • Ejemplos: UML (software), CRIO (SMA), BPMN (procesos)    ║
╚═══════════════════════════════════════════════════════════════╝
                       ↑ conforme a
                       │
╔═══════════════════════════════════════════════════════════════╗
║ M1: MODELO                                                     ║
║     (Diagramas UML, Modelo MicroGrid, etc.)                    ║
║     • Instancias de lenguajes M2                               ║
║     • Conforme a metamodelo M2                                 ║
║     • Ejemplos: Diagrama clases de app bancaria, MicroGrid     ║
╚═══════════════════════════════════════════════════════════════╝
                       ↑ representa
                       │
╔═══════════════════════════════════════════════════════════════╗
║ M0: SISTEMA                                                    ║
║     (Objetos en ejecución, agentes funcionando)                ║
║     • Sistema real ejecutándose                                ║
║     • Instancias del modelo M1                                 ║
║     • Ejemplos: App bancaria ejecutando, Agentes MicroGrid     ║
╚═══════════════════════════════════════════════════════════════╝
```

**Analogía con lenguajes de programación**:

| Nivel Modelos | Nivel Programación | Ejemplo |
|---------------|-------------------|---------|
| **M3** | EBNF (gramática de gramáticas) | Define cómo escribir gramáticas |
| **M2** | Gramática Java | Define sintaxis de Java |
| **M1** | Programa Java | Código fuente concreto |
| **M0** | Programa ejecutando | Proceso en memoria |

### 6.4. Relación de Conformidad

**Definición**:
```
Un modelo M es CONFORME a un metamodelo MM si:
  1. Todos los elementos de M son instancias de conceptos definidos en MM
  2. Todas las relaciones de M respetan las relaciones definidas en MM
  3. Todas las restricciones de MM se cumplen en M
```

**Nota importante** (del Doc 1):
> "Hay gente que suele decir que un modelo es una 'instancia' de su metamodelo, 
> pero eso es similar a decir que un programa es una instancia de su gramática, 
> lo cual no es del todo correcto."

**Terminología correcta**:
- ✅ "Modelo **conforme a** metamodelo"
- ❌ "Modelo **instancia de** metamodelo" (impreciso)

**Verificación de conformidad**:
```
Herramientas:
  - OCL: Restricciones declarativas
  - EVL: Validación modular con mensajes personalizados
  - Validadores de Eclipse EMF
```

**Ejemplos**:

```
Ejemplo 1:
  Modelo MicroGrid (M1) conforme a CRIO (M2)
  Verificación: 8 reglas EVL + restricciones implícitas

Ejemplo 2:
  CRIO (M2) conforme a Ecore (M3)
  Verificación: CRIO definido como modelo Ecore válido
```

**Mapeo a carpeta**: `_fundamentos_conceptuales/modelos_metamodelos/conformidad.md`

---

(continuará en siguiente sección del archivo debido a límite de longitud)

