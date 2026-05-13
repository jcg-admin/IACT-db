# ANÁLISIS REAL: ESTRUCTURA SPHINX EXISTENTE vs MODELO DOCUMENTAL v2.2.0

**Versión:** 1.0.0  
**Fecha:** 2026-01-07  
**Estado:** Análisis de estructura REAL existente

---

## RESUMEN DE HALLAZGOS

### ✅ LO QUE YA TIENEN (FUNCIONAL)

```
documentacion/
├── source/
│   ├── conf.py                    ✅ YA EXISTE
│   ├── index.rst                  ✅ YA EXISTE
│   ├── _static/                   ✅ YA EXISTE
│   ├── _templates/                ✅ YA EXISTE
│   ├── arquitectura_tecnica/      ✅ YA EXISTE
│   ├── base_cognitiva/            ✅ YA EXISTE
│   ├── gestion/                   ✅ YA EXISTE (no en modelo v2.2.0)
│   ├── normativa/                 ✅ YA EXISTE
│   └── requisitos/                ✅ YA EXISTE
├── build/html/                    ✅ BUILD FUNCIONAL
├── Makefile                       ✅ YA EXISTE
├── requirements.txt               ✅ YA EXISTE
├── readme.rst                     🔄 REEMPLAZAR con versión actualizada
├── prerequisites.rst              🔄 REEMPLAZAR con versión actualizada
├── authors.rst                    🔄 REEMPLAZAR con versión actualizada
└── licence.rst                    🔄 REEMPLAZAR con versión actualizada
```

### 🔍 ESTADO DEL BUILD ACTUAL

**Build:** ✅ Exitoso (294 warnings, 1 error menor)  
**Servidor:** ✅ Live reload funcionando en http://127.0.0.1:8000  
**Warnings principales:** Referencias a UCs no creados todavía (normal en desarrollo)

---

## 1. COMPARACIÓN: ESTRUCTURA REAL vs MODELO v2.2.0

### 1.1 Dominios Principales

| Dominio | En Proyecto Actual | En Modelo v2.2.0 | Estado |
|---------|-------------------|------------------|--------|
| arquitectura_tecnica/ | ✅ Sí | ✅ Sí | ✅ COINCIDE |
| base_cognitiva/ | ✅ Sí | ✅ Sí | ✅ COINCIDE |
| normativa/ | ✅ Sí | ✅ Sí | ✅ COINCIDE |
| requisitos/ | ✅ Sí | ✅ Sí | ✅ COINCIDE |
| **gestion/** | ✅ Sí | ❌ No | ⚠️ EXTRA en tu proyecto |
| **evidencia/** | ❌ No | ✅ Sí | ⚠️ FALTA en tu proyecto |

### 1.2 Subdominios de requisitos/

**Tu estructura actual:**
```
requisitos/
├── casos_uso/
│   ├── access/
│   ├── alerts/
│   ├── auth/
│   ├── audit/
│   ├── logs/
│   ├── pipeline/
│   ├── reports/
│   └── users/
├── objetivos/
├── reglas_negocio/
├── requisitos_funcionales/
│   ├── access/
│   ├── auth/
│   └── users/
├── requisitos_no_funcionales/
└── rtm/
```

**Modelo v2.2.0 espera:**
```
requisitos/
├── objetivos_negocio/      (tú tienes: objetivos/)
├── reglas_negocio/         ✅ Coincide
├── casos_uso/              ✅ Coincide (subdivisión por módulos)
├── funcionales/            (tú tienes: requisitos_funcionales/)
└── no_funcionales/         (tú tienes: requisitos_no_funcionales/)
```

**Diferencia:** Nomenclatura ligeramente diferente pero estructura equivalente.

### 1.3 Subdominios de arquitectura_tecnica/

**Tu estructura actual:**
```
arquitectura_tecnica/
├── arquitectura/
├── despliegue/
└── diseño_detallado/
```

**Modelo v2.2.0 espera:**
```
arquitectura_tecnica/
├── modulos/
├── restricciones/
├── decisiones/
├── vistas/
├── flujos_datos/
├── apis/
└── modelos_datos/
```

**Diferencia:** Estructura completamente diferente. Necesitas decidir:
- Mantener tu estructura actual (más práctica de desarrollo)
- Migrar al modelo v2.2.0 (más teórica/documental)
- Híbrido (ambas coexisten)

### 1.4 Subdominios de normativa/

**Tu estructura actual:**
```
normativa/
├── estandares/
├── gobernanza/
├── procedimientos/
└── restricciones/
```

**Modelo v2.2.0 espera:**
```
normativa/
├── estandares/
│   └── plantillas/   (17 TPL)
├── procedimientos/   (38 PROC)
└── politicas/        (2 POL)
```

**Diferencia:** 
- Tú tienes `gobernanza/` y `restricciones/` como subdominios separados
- Modelo v2.2.0 tiene `plantillas/` dentro de `estandares/`

---

## 2. PROBLEMAS ACTUALES IDENTIFICADOS

### 2.1 Error Crítico (1)

```
requisitos/casos_uso/pipeline/index.rst:3: ERROR: Unexpected indentation.
```

**Acción:** Revisar y corregir indentación en línea 3.

### 2.2 Warnings Principales (294 total)

#### A. Referencias a UCs no existentes (~44 warnings)

Ejemplos:
- `UC_010_Asignar_Funciones` - referenciado pero no existe
- `UC_036_Crear_Alerta` - referenciado pero no existe
- `UC_050_Ejecutar_Pipeline` - referenciado pero no existe

**Razón:** Son UCs pendientes de crear según el modelo v2.2.0.

#### B. Referencias duplicadas (2 warnings)

```
GOB_05_Control_Versiones.rst:200: WARNING: toctree contains reference to nonexisting document
GOB_05_Control_Versiones.rst:12: WARNING: duplicate label gobernanza-index
```

**Acción:** Eliminar referencia duplicada.

#### C. Labels indefinidos (4 warnings)

```
WARNING: undefined label: 'gob-05'
```

**Acción:** Definir label correctamente o usar referencia absoluta.

### 2.3 Deprecation Warning

```
RemovedInSphinx90Warning: The str interface for _JavaScript objects is deprecated.
```

**Razón:** Sphinx Tabs usa API antigua.  
**Acción:** Esperar actualización de `sphinx-tabs` o ignorar (no crítico).

---

## 3. INTEGRACIÓN DE ARCHIVOS ACTUALIZADOS

### 3.1 Archivos Raíz a Reemplazar

Estos archivos YA EXISTEN en tu raíz pero están desactualizados:

| Archivo | Ubicación Actual | Acción | Contenido |
|---------|------------------|--------|-----------|
| readme.rst | `/raíz/` | REEMPLAZAR | Descripción proyecto IACT |
| prerequisites.rst | `/raíz/` | REEMPLAZAR | Requisitos técnicos ejecución |
| authors.rst | `/raíz/` | REEMPLAZAR | Equipo proyecto |
| licence.rst | `/raíz/` | REEMPLAZAR | Información legal |

**Comando:**
```bash
# Desde donde tengas los archivos actualizados
cp readme.rst /d/Estadia_IACT/proyecto/documentacion/
cp prerequisites.rst /d/Estadia_IACT/proyecto/documentacion/
cp authors.rst /d/Estadia_IACT/proyecto/documentacion/
cp licence.rst /d/Estadia_IACT/proyecto/documentacion/
```

### 3.2 ¿Dónde se Muestran en el Menú?

Estos archivos se referencian desde `source/index.rst`. Necesitas verificar si YA están incluidos en el toctree.

**Verifica en `source/index.rst`:**
```rst
.. toctree::
   :maxdepth: 2
   :caption: Información General
   
   ../readme
   ../prerequisites
   ../authors
   ../licence
```

O alternativamente pueden estar en `source/` directamente:
```rst
.. toctree::
   :maxdepth: 2
   :caption: Información General
   
   readme
   prerequisites
   authors
   licence
```

**Acción Requerida:** Necesito ver tu `source/index.rst` para saber cómo están referenciados actualmente.

---

## 4. DOCUMENTOS GRANDES A INTEGRAR

Tienes 4 documentos grandes en Markdown que quieres integrar:

| Documento | Tamaño | Destino Recomendado |
|-----------|--------|---------------------|
| MODELO_DOCUMENTAL_v2_2_0 | ~800 líneas | `normativa/estandares/` |
| ANEXO_A_ARBOL_COMPLETO | ~500 líneas | `normativa/estandares/` |
| RESTRICCIONES_COMPLETAS | ~1130 líneas | `arquitectura_tecnica/restricciones/` o `normativa/restricciones/` |
| MODELO_RBAC_v5_1_1 | ~1650 líneas | `arquitectura_tecnica/` o `base_cognitiva/` |

**Pregunta:** ¿Prefieres mantener estos documentos en Markdown o convertirlos a RST?

---

## 5. DECISIONES ARQUITECTÓNICAS NECESARIAS

### 5.1 Dominio `gestion/` vs `evidencia/`

**Opción A:** Mantener ambos
```
source/
├── gestion/         # Manuales usuarios, PM, evidencia proyecto
└── evidencia/       # Pruebas, trazabilidad (nuevo, según modelo v2.2.0)
```

**Opción B:** Consolidar en uno solo
```
source/
└── gestion/
    ├── evidencia/      # Lo que sería evidencia/pruebas
    ├── manuales_usuarios/
    ├── pm/
    └── trazabilidad/   # Lo que sería evidencia/trazabilidad
```

**Recomendación:** Opción A (mantener ambos) para seguir modelo v2.2.0.

### 5.2 Subdominios de arquitectura_tecnica/

**Opción A:** Mantener tu estructura actual (práctica)
- arquitectura/
- despliegue/
- diseño_detallado/

**Opción B:** Migrar a modelo v2.2.0 (teórica)
- modulos/
- restricciones/
- decisiones/
- etc.

**Opción C:** Híbrido
```
arquitectura_tecnica/
├── arquitectura/           # Tu estructura actual
├── despliegue/
├── diseño_detallado/
├── modulos/                # Agregar del modelo v2.2.0
├── restricciones/
└── decisiones/
```

**Recomendación:** Opción C (híbrido) si el espacio lo permite.

### 5.3 Nomenclatura de subdominios

**Tu nomenclatura:**
- `objetivos/`
- `requisitos_funcionales/`
- `requisitos_no_funcionales/`

**Modelo v2.2.0:**
- `objetivos_negocio/`
- `funcionales/`
- `no_funcionales/`

**Recomendación:** Mantener tu nomenclatura (ya está funcionando). Documentar la diferencia.

---

## 6. PLAN DE ACCIÓN REALISTA

### PASO 1: Correcciones Urgentes (1 hora)

```bash
# 1.1 Corregir error de indentación
# Editar: source/requisitos/casos_uso/pipeline/index.rst línea 3

# 1.2 Corregir label duplicado
# Editar: source/normativa/gobernanza/GOB_05_Control_Versiones.rst línea 12

# 1.3 Reemplazar archivos raíz
cp readme.rst /d/Estadia_IACT/proyecto/documentacion/
cp prerequisites.rst /d/Estadia_IACT/proyecto/documentacion/
cp authors.rst /d/Estadia_IACT/proyecto/documentacion/
cp licence.rst /d/Estadia_IACT/proyecto/documentacion/

# 1.4 Rebuild
make clean
make html
```

**Resultado Esperado:** Reducir warnings de 294 a ~250 (solo los de UCs faltantes).

### PASO 2: Integración de Documentos Grandes (2-3 horas)

```bash
# 2.1 Convertir Markdown a RST (o mantener como Markdown con MyST)
# Ya tienes MyST Parser configurado, así que puedes dejarlo en .md

# 2.2 Copiar a ubicaciones correctas
cp MODELO_DOCUMENTAL_v2_2_0.md source/normativa/estandares/
cp ANEXO_A_ARBOL_COMPLETO.md source/normativa/estandares/
cp RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md source/normativa/restricciones/
cp MODELO_RBAC_IACT_v5_1_1.md source/base_cognitiva/

# 2.3 Actualizar index.rst de cada subdominio para incluirlos
```

### PASO 3: Crear Subdominios Faltantes (opcional, 1-2 horas)

```bash
# Si decides seguir el modelo v2.2.0 completamente:
mkdir -p source/evidencia/{pruebas,trazabilidad}
mkdir -p source/arquitectura_tecnica/{modulos,restricciones,decisiones}

# Crear index.rst para cada uno
```

### PASO 4: Documentar Diferencias (30 min)

Crear un documento que mapee tu estructura actual al modelo v2.2.0:

```markdown
# MAPEO_ESTRUCTURA.md

## Dominios
- gestion/ (nuestro) = evidencia/ (modelo v2.2.0) + gestión proyecto

## Subdominios
- objetivos/ = objetivos_negocio/
- requisitos_funcionales/ = funcionales/
- requisitos_no_funcionales/ = no_funcionales/
```

---

## 7. PRÓXIMOS PASOS INMEDIATOS

1. **Necesito ver tu `source/index.rst`** para saber cómo integrar correctamente los archivos raíz.

2. **Decisión arquitectónica:** ¿Mantienes tu estructura o migras al modelo v2.2.0?

3. **Correcciones urgentes:** Solucionar el error de indentación y labels duplicados.

4. **Integración documentos:** ¿Los quieres en Markdown (.md) o RST (.rst)?

---

**FIN DEL ANÁLISIS REAL**

**Versión:** 1.0.0  
**Fecha:** 2026-01-07  
**Siguiente:** Esperar decisiones del usuario

