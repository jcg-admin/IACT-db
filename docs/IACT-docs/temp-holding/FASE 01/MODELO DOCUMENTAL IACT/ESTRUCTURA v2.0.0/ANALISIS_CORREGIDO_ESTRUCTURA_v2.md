# ANÁLISIS CORREGIDO: BASADO EN ESTRUCTURA v2.0.0
## Fuente de Verdad Oficial del Proyecto IACT

**Fecha:** 2025-12-22
**Basado en:** ESTRUCTURA_COMPLETA_-_MODELO_DOCUMENTAL_IACT_v2_0_0.txt
**Estado:** Análisis Definitivo

---

## 1. LO QUE DICE ESTRUCTURA v2.0.0 (FUENTE DE VERDAD)

### 1.1 Modelo Oficial del Proyecto

```
ESTRUCTURA v2.0.0 define:

5 DOMINIOS:
├── base_cognitiva/           # Dominio 1: Conocimiento Fundamental
├── requisitos/               # Dominio 2: Requerimientos
├── arquitectura_tecnica/     # Dominio 3: Arquitectura
├── normativa/                # Dominio 4: Estándares y Políticas
└── evidencia/                # Dominio 5: Verificación

14 SUBDOMINIOS:
- base_cognitiva:        3 (+1 privado _metadata)
- requisitos:            4 (reglas_negocio, requisitos_negocio, casos_uso, requisitos_funcionales)
- arquitectura_tecnica:  3 (arquitectura, diseno_detallado, restricciones)
- normativa:             2 (estandares, politicas)
- evidencia:             2 (pruebas, trazabilidad)

62 DOCUMENTOS TOTALES:
- Completados: 16 (~12,121 líneas)
- Pendientes:  46 (~12,450 líneas)
```

### 1.2 Flujo de Derivación OFICIAL

```
ESTRUCTURA v2.0.0 define claramente:

CNST (10 docs COMPLETADOS)
    │
    │ informan
    ▼
BR (3 docs PENDIENTES)
    │ BR_001_Inmutabilidad_Fuente     ← CNST-003
    │ BR_002_ETL_Nocturno             ← CNST-004
    │ BR_003_RBAC_Flat                ← CNST-005
    │
    │ derivan
    ▼
BReq (3 docs PENDIENTES)
    │ BReq_001_Visualizar_Metricas    ← BR_001
    │ BReq_002_Exportar_Datos         ← BR_001
    │ BReq_003_Gestionar_Accesos      ← BR_003
    │
    │ derivan
    ▼
UC (3 docs PENDIENTES)
    │ UC_001_Consultar_Dashboard      ← BReq_001
    │ UC_002_Exportar_Reporte         ← BReq_002
    │ UC_003_Gestionar_Roles          ← BReq_003
    │
    │ derivan
    ▼
FR (5 docs PENDIENTES)
    │ FR_001_Cargar_Dashboard         ← UC_001
    │ FR_002_Filtrar_Metricas         ← UC_001
    │ FR_003_Generar_Excel            ← UC_002
    │ FR_004_Crear_Usuario            ← UC_003
    │ FR_005_Asignar_Rol              ← UC_003
    │
    │ verifican
    ▼
TST (3 docs PENDIENTES)
    │
    │ registran en
    ▼
RTM (1 doc PENDIENTE)
```

---

## 2. RESOLUCIÓN DE DISCREPANCIAS

### 2.1 ¿Existe requisitos_negocio/ (BReq)?

```
RESPUESTA: SÍ EXISTE

ESTRUCTURA v2.0.0 líneas 48-52:
├── requisitos_negocio/                  # [CONGELADO]
│   ├── index.rst
│   ├── BReq_001_Visualizar_Metricas.rst     # PENDIENTE (deriva BR_001)
│   ├── BReq_002_Exportar_Datos.rst          # PENDIENTE (deriva BR_001)
│   └── BReq_003_Gestionar_Accesos.rst       # PENDIENTE (deriva BR_003)

CONCLUSIÓN: 
- requisitos_negocio/ ES un subdominio oficial
- Contiene 3 artefactos BReq_
- Estado: CONGELADO
- PROC_05 Fase 2 es CORRECTA
```

### 2.2 ¿Cuántos UC tiene el proyecto?

```
RESPUESTA: 3 UC OFICIALES (según ESTRUCTURA)

ESTRUCTURA v2.0.0 líneas 54-58:
├── casos_uso/                           # [CONGELADO]
│   ├── index.rst
│   ├── UC_001_Consultar_Dashboard.rst       # PENDIENTE (deriva BReq_001)
│   ├── UC_002_Exportar_Reporte.rst          # PENDIENTE (deriva BReq_002)
│   └── UC_003_Gestionar_Roles.rst           # PENDIENTE (deriva BReq_003)

PERO: Tu catálogo Obsidian tiene ~42 UC

INTERPRETACIÓN:
- ESTRUCTURA define 3 UC de ALTO NIVEL (casi épicas)
- Tu catálogo tiene UC OPERATIVOS (detallados)
- Pueden coexistir: UC_001 puede descomponerse en UC_001.01, UC_001.02...

DECISIÓN REQUERIDA:
□ Opción A: Seguir ESTRUCTURA (3 UC macro)
□ Opción B: Expandir ESTRUCTURA con tus 42 UC
□ Opción C: Los 42 UC son sub-UC de los 3 macro
```

### 2.3 ¿CNST es la única fuente de BR?

```
RESPUESTA: SEGÚN ESTRUCTURA, SÍ

ESTRUCTURA muestra:
- BR_001 ← CNST-003
- BR_002 ← CNST-004  
- BR_003 ← CNST-005

Cada BR deriva EXPLÍCITAMENTE de un CNST.

PERO: FND_05 menciona otras fuentes (leyes, regulaciones, políticas)

RESOLUCIÓN:
Para IACT específicamente, los 3 BR definidos derivan de CNST.
Esto no impide que futuros BR vengan de otras fuentes.
```

---

## 3. ESTADO ACTUAL DEL PROYECTO

### 3.1 Lo que está COMPLETADO

```
16 documentos (~12,121 líneas):

CNST (10 docs, 9,621 líneas) - arquitectura_tecnica/restricciones/
├── CNST_001_Comunicaciones_Prohibidas.rst
├── CNST_002_Gestion_Sesiones_BD.rst
├── CNST_003_Base_Datos_Dual_Inmutable.rst
├── CNST_004_Actualizacion_Datos_ETL.rst
├── CNST_005_Seguridad_DRF_Checklist.rst
├── CNST_006_Antipatrones_Arquitectura.rst
├── CNST_007_Limites_Performance_SLA.rst
├── CNST_008_Infraestructura_Deployment.rst
├── CNST_009_Logging_Auditoria_Inmutable.rst
└── CNST_010_Clasificacion_Proteccion_Datos.rst

_metadata (6 docs, ~2,500 líneas) - base_cognitiva/_metadata/
├── 00_indice.rst
├── 01_sbvr_fundamentos.rst
├── 02_larman_metodologia.rst
├── 03_derivacion_br_uc.rst
├── 04_derivacion_uc_fr.rst
└── 05_trazabilidad_rtm.rst
```

### 3.2 Lo que está PENDIENTE (en orden de creación sugerido)

```
FASE 2: Estándares (STD) - 5 docs
1. STD-003 Clean Code Naming       (~500 líneas)
2. STD-004 Nomenclatura Proyecto   (~300 líneas)
3. STD-001 Suite Calidad Código    (~400 líneas)
4. STD-005 Estilo Doc Sphinx       (~350 líneas)
5. STD-002 Metodología SBVR        (~600 líneas)

FASE 3: Reglas de Negocio (BR) - 3 docs
1. BR_001 Inmutabilidad Fuente
2. BR_002 ETL Nocturno
3. BR_003 RBAC Flat

FASE 4: Flujo Completo UC - 11 docs
1. BReq_001, BReq_002, BReq_003
2. UC_001, UC_002, UC_003
3. FR_001 a FR_005

FASE 5: Arquitectura - 14 docs
1. ADR_001, ADR_002, ADR_003
2. ARQ_VIS_001, ARQ_VIS_002, ARQ_VIS_003
3. API_001, API_002, API_003
4. DSC_MOD_001, DSC_MOD_002, DSC_MOD_003
5. ESQ_001, ESQ_002

FASE 6: Evidencia y Trazabilidad - 4 docs
1. TST_001, TST_002, TST_003
2. RTM_Master_v1_0_0

FASE 7: Complementarios - 9 docs
1. TPL_001 a TPL_004
2. POL_001, POL_002
3. GLO_001, TAX_001, META_001
```

---

## 4. CORRECCIÓN A PROC_05

### 4.1 Lo que PROC_05 tiene CORRECTO

```
✅ Fase 0: CNST → BR (ESTRUCTURA confirma esta relación)
✅ Fase 1: Crear BR (3 BR definidos en ESTRUCTURA)
✅ Fase 2: Crear BReq (requisitos_negocio/ EXISTE en ESTRUCTURA)
✅ Fase 3: Crear UC (3 UC definidos en ESTRUCTURA)
✅ Fase 4: Derivar FR (5 FR definidos en ESTRUCTURA)
✅ Fase 5: Actualizar RTM (RTM_Master definido en ESTRUCTURA)
```

### 4.2 Lo que PROC_05 necesita AJUSTAR

```
⚠️ AJUSTE 1: Alcance de UC
   PROC_05 habla de 42 UC (tu catálogo)
   ESTRUCTURA define solo 3 UC
   
   SOLUCIÓN: PROC_05 debe seguir los 3 UC de ESTRUCTURA
   O: ESTRUCTURA debe actualizarse para incluir más UC

⚠️ AJUSTE 2: Orden de Fases
   ESTRUCTURA sugiere crear STD ANTES de BR
   PROC_05 empieza con CNST → BR
   
   SOLUCIÓN: Agregar Fase 0.5 para STD (plantillas necesarias)

⚠️ AJUSTE 3: Plantillas
   PROC_05 asume que TPL_*.rst existen
   ESTRUCTURA dice que están PENDIENTES (Fase 7)
   
   SOLUCIÓN: Crear plantillas ANTES de ejecutar Fase 1
```

---

## 5. PREGUNTA CRÍTICA: ¿QUÉ PASA CON TUS 42 UC?

### 5.1 El Conflicto

```
ESTRUCTURA v2.0.0:           TU CATÁLOGO OBSIDIAN:
────────────────────         ────────────────────────
3 UC de alto nivel           42 UC operativos

UC_001_Consultar_Dashboard   UC-001 Iniciar Sesión
UC_002_Exportar_Reporte      UC-002 Cerrar Sesión
UC_003_Gestionar_Roles       UC-003 Recuperar Contraseña
                             UC-004 Cambiar Contraseña
                             UC-005 Gestión Sesiones
                             UC-006 Crear Usuario
                             ...
                             UC-042 Gestionar Permisos Directos
```

### 5.2 Opciones de Resolución

```
OPCIÓN A: ESTRUCTURA es ejemplo mínimo
─────────────────────────────────────
- Los 3 UC son ejemplos representativos
- Tu catálogo de 42 UC es el REAL
- Actualizar ESTRUCTURA para reflejar los 42 UC
- PROC_05 aplica a los 42 UC

OPCIÓN B: ESTRUCTURA es modelo macro
─────────────────────────────────────
- Los 3 UC son de ALTO NIVEL (épicas)
- Tus 42 UC son SUB-UC que descomponen los 3 macro
- Crear jerarquía: UC_001 → UC_001.01, UC_001.02...
- PROC_05 crea primero macro, luego detalle

OPCIÓN C: Dos niveles separados
───────────────────────────────
- Los 3 UC de ESTRUCTURA son BReq disfrazados
- Tus 42 UC son los UC reales
- Renumerar: ESTRUCTURA.UC → BReq, TuCatálogo.UC → UC
- PROC_05 se ajusta a esta interpretación
```

### 5.3 Mi Recomendación

```
RECOMIENDO OPCIÓN A:

Razón: ESTRUCTURA v2.0.0 es un MODELO de ejemplo.
       Lista "3 documentos" como ejemplo representativo.
       La sección 5.1 dice "UC | 0 | 3 | 3" (3 pendientes).
       
       Tu catálogo de 42 UC es el CATÁLOGO REAL del proyecto.
       ESTRUCTURA debe actualizarse para reflejar la realidad.

ACCIÓN: 
1. Actualizar ESTRUCTURA v2.0.0 → v2.1.0
2. Reemplazar los 3 UC ejemplo por los 42 UC reales
3. Recalcular totales (46 pendientes → ~85 pendientes)
```

---

## 6. PLAN DE ACCIÓN INMEDIATO

### 6.1 Decisión Requerida del Usuario

```
PREGUNTA: ¿Cómo tratamos los 42 UC de tu catálogo?

□ A) Los 42 UC REEMPLAZAN a los 3 UC de ESTRUCTURA
      → Actualizo ESTRUCTURA v2.1.0

□ B) Los 42 UC son SUB-UC de los 3 UC de ESTRUCTURA
      → Creo jerarquía UC_001 → UC_001.01...

□ C) Los 3 UC de ESTRUCTURA son en realidad BReq
      → Renombro y reestructuro

□ D) Otra interpretación
      → Explícame
```

### 6.2 Mientras tanto, puedo hacer

```
1. ✅ Crear TPL_001_Plantilla_BR.rst (necesario para Fase 1)
2. ✅ Crear TPL_002_Plantilla_UC.rst (necesario para Fase 3)
3. ✅ Crear TPL_003_Plantilla_FR.rst (necesario para Fase 4)
4. ✅ Crear BR_001, BR_002, BR_003 (no dependen de UC)

Esto no requiere resolver el conflicto de UC todavía.
```

---

## 7. ESTRUCTURA CORREGIDA (PROPUESTA)

Si eliges **Opción A**, ESTRUCTURA v2.1.0 se vería así:

```
requisitos/                              # DOMINIO 2: Requerimientos
│
├── index.rst
│
├── reglas_negocio/                      # [CONGELADO]
│   ├── index.rst
│   ├── BR_001_Inmutabilidad_Fuente.rst
│   ├── BR_002_ETL_Nocturno.rst
│   └── BR_003_RBAC_Flat.rst
│
├── requisitos_negocio/                  # [CONGELADO]
│   ├── index.rst
│   ├── BReq_001_Visualizar_Metricas.rst
│   ├── BReq_002_Exportar_Datos.rst
│   └── BReq_003_Gestionar_Accesos.rst
│
├── casos_uso/                           # [CONGELADO] - ACTUALIZADO
│   ├── index.rst
│   │
│   ├── UC_001_Iniciar_Sesion.rst
│   ├── UC_002_Cerrar_Sesion.rst
│   ├── UC_003_Recuperar_Contrasena.rst
│   ├── UC_004_Cambiar_Contrasena.rst
│   ├── UC_005_Gestion_Sesiones.rst
│   ├── UC_006_Crear_Usuario.rst
│   ├── UC_007_Modificar_Usuario.rst
│   ├── UC_008_Eliminar_Usuario.rst
│   ├── UC_009_Listar_Usuarios.rst
│   ├── UC_010_Asignar_Roles.rst
│   ├── UC_011_Gestionar_Permisos_Rol.rst
│   │   ...
│   ├── UC_041_Gestionar_Segmentos.rst
│   └── UC_042_Gestionar_Permisos_Directos.rst
│
└── requisitos_funcionales/              # [CONGELADO]
    ├── index.rst
    ├── FR_001_01_Validar_Credenciales.rst
    ├── FR_001_02_Crear_Sesion.rst
    │   ...
    └── FR_042_NN_*.rst

NUEVO CONTEO:
- UC: 42 (antes 3)
- FR: ~500 (antes 5)
- Total pendientes: ~85 (antes 46)
```

---

## 8. CONCLUSIÓN

```
╔══════════════════════════════════════════════════════════════════════════╗
║                    CONCLUSIONES DEL ANÁLISIS                             ║
╠══════════════════════════════════════════════════════════════════════════╣
║                                                                          ║
║  1. ESTRUCTURA v2.0.0 ES la fuente de verdad                             ║
║     - Define 5 dominios, 14 subdominios, 62 documentos                   ║
║     - requisitos_negocio/ (BReq) SÍ existe oficialmente                  ║
║     - PROC_05 está mayormente correcto                                   ║
║                                                                          ║
║  2. HAY UN CONFLICTO DE ALCANCE EN UC                                    ║
║     - ESTRUCTURA: 3 UC ejemplo                                           ║
║     - Tu catálogo: 42 UC reales                                          ║
║     - Requiere decisión: ¿Expandir ESTRUCTURA o jerarquizar?             ║
║                                                                          ║
║  3. ORDEN DE EJECUCIÓN SEGÚN ESTRUCTURA                                  ║
║     - Fase 2: STD (estándares primero)                                   ║
║     - Fase 3: BR (reglas negocio)                                        ║
║     - Fase 4: BReq → UC → FR (flujo completo)                            ║
║     - Fase 5-7: Arquitectura, Evidencia, Complementarios                 ║
║                                                                          ║
║  4. SIGUIENTE PASO                                                       ║
║     - Decidir tratamiento de los 42 UC                                   ║
║     - Crear plantillas TPL_ (bloquean Fase 3)                            ║
║     - Crear BR_001, BR_002, BR_003 (no bloquean nada)                    ║
║                                                                          ║
╚══════════════════════════════════════════════════════════════════════════╝
```

---

**¿Cuál opción eliges para los 42 UC?**

- □ **A:** Los 42 UC reemplazan a los 3 de ESTRUCTURA
- □ **B:** Los 42 UC son sub-UC de los 3 macro
- □ **C:** Los 3 UC son realmente BReq
- □ **D:** Otra interpretación

**Y: ¿Procedo a crear las plantillas TPL_ mientras decides?**
