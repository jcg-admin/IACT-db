# ANÁLISIS COMPLETO: ESTRUCTURA DE DOCUMENTACIÓN SPHINX PARA IACT

**Versión:** 1.0.0  
**Fecha:** 2026-01-07  
**Analista:** Sistema de Análisis Documental  
**Proyecto:** IACT-2025-001

---

## RESUMEN EJECUTIVO

Este documento analiza la estructura de documentación actual del proyecto IACT y proporciona un plan completo para integrar los archivos raíz (readme, authors, licence, prerequisites) en el sistema Sphinx según el Modelo Documental v2.2.0.

### Hallazgos Principales

1. **Estructura Actual:** Basada en 5 dominios + 23 subdominios (~293 artefactos)
2. **Sistema de Build:** Sphinx 8.2.3 con múltiples extensiones
3. **Archivos Raíz Pendientes de Integración:** 4 archivos (.rst)
4. **Gap Identificado:** Falta el index.rst principal y los index.rst de cada dominio
5. **Convenciones:** Nomenclatura versionada (TPL, PROC, CNST, BR, UC, FR)

---

## 1. INVENTARIO DE ARCHIVOS ACTUALES

### 1.1 Archivos de Configuración (Raíz del Proyecto)

| Archivo | Estado | Ubicación Actual | Acción Requerida |
|---------|--------|------------------|------------------|
| Makefile | ✅ Listo | Raíz | Ninguna |
| requirements.txt | ✅ Listo | Raíz | Ninguna |
| conf.py | ⚠️ Falta | source/conf.py | CREAR |
| .readthedocs.yaml | ❌ Eliminar | Raíz | ELIMINAR |

### 1.2 Archivos Raíz de Información General

| Archivo | Estado | Líneas | Propósito |
|---------|--------|--------|-----------|
| readme.rst | ✅ Actualizado | 445 | Descripción del proyecto |
| prerequisites.rst | ✅ Actualizado | 650+ | Requisitos técnicos |
| authors.rst | ✅ Actualizado | 90 | Equipo del proyecto |
| licence.rst | ✅ Actualizado | 120 | Información legal |

### 1.3 Documentos de Modelo y Especificación

| Archivo | Tamaño | Formato | Integración |
|---------|--------|---------|-------------|
| MODELO_DOCUMENTAL_IACT_v2_2_0 | 2 partes | Markdown | Convertir a RST |
| ANEXO_A_ARBOL_COMPLETO | 2 partes | Markdown | Convertir a RST |
| RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md | Grande | Markdown | Convertir a RST |
| MODELO_RBAC_IACT_v5_1_1.md | Grande | Markdown | Convertir a RST |

---

## 2. ESTRUCTURA OBJETIVO SEGÚN MODELO v2.2.0

### 2.1 Árbol de Directorios Completo

```
IACT/
├── Makefile                          ✅ Existente
├── requirements.txt                  ✅ Existente
├── .gitignore                        ⚠️ CREAR
├── readme.rst                        ✅ Actualizado
├── authors.rst                       ✅ Actualizado
├── licence.rst                       ✅ Actualizado
├── prerequisites.rst                 ✅ Actualizado
│
├── source/                           ⚠️ CREAR ESTRUCTURA COMPLETA
│   ├── conf.py                       ⚠️ CREAR (crítico)
│   ├── index.rst                     ⚠️ CREAR (crítico)
│   │
│   ├── _static/                      ⚠️ CREAR
│   │   ├── css/
│   │   │   └── custom.css
│   │   ├── js/
│   │   │   └── custom.js
│   │   └── img/
│   │       └── logo_iact.png
│   │
│   ├── _templates/                   ⚠️ CREAR
│   │   ├── sidebar/
│   │   ├── base.html
│   │   └── page.html
│   │
│   ├── base_cognitiva/               ⚠️ CREAR TODO
│   │   ├── index.rst                 # 27 artefactos
│   │   ├── _metadata/                # 5 META (privado)
│   │   ├── glosario/                 # 1 GLOS
│   │   ├── _fundamentos_conceptuales/ # 7 FND (privado)
│   │   ├── _ontologia_sbvr/          # 5 SBVR (privado)
│   │   ├── _taxonomias_y_metamodelos/ # 6 TXM+MTM (privado)
│   │   └── _metodologias_analiticas/ # 3 METH (privado)
│   │
│   ├── requisitos/                   ⚠️ CREAR TODO
│   │   ├── index.rst                 # ~142 artefactos
│   │   ├── objetivos_negocio/        # 8 BReq
│   │   │   └── index.rst
│   │   ├── reglas_negocio/           # 20 BR [CONGELADO]
│   │   │   └── index.rst
│   │   ├── casos_uso/                # 49 UC (8 módulos)
│   │   │   ├── index.rst
│   │   │   ├── auth/                 # 5 UC
│   │   │   ├── users/                # 4 UC
│   │   │   ├── access/               # 9 UC
│   │   │   ├── pipeline/             # 4 UC
│   │   │   ├── reports/              # 14 UC
│   │   │   ├── alerts/               # 5 UC
│   │   │   ├── audit/                # 4 UC
│   │   │   └── logs/                 # 4 UC
│   │   ├── funcionales/              # 55 FR (en progreso)
│   │   │   ├── index.rst
│   │   │   ├── auth/                 # 21 FR ✅
│   │   │   ├── users/                # 17 FR ✅
│   │   │   ├── access/               # 17 FR 🔄
│   │   │   └── [otros módulos]       # ⏳
│   │   └── no_funcionales/           # ~20 NFR
│   │       └── index.rst
│   │
│   ├── arquitectura_tecnica/         ⚠️ CREAR TODO
│   │   ├── index.rst                 # ~51 artefactos
│   │   ├── modulos/                  # 8 MOD [CONGELADO]
│   │   │   └── index.rst
│   │   ├── restricciones/            # 10 CNST [CONGELADO]
│   │   │   └── index.rst
│   │   ├── decisiones/               # 5 ADR
│   │   │   └── index.rst
│   │   ├── vistas/                   # 5 VIEW
│   │   │   └── index.rst
│   │   ├── flujos_datos/             # 12 FD
│   │   │   └── index.rst
│   │   ├── apis/                     # 8 API
│   │   │   └── index.rst
│   │   └── modelos_datos/            # 3 MDL
│   │       └── index.rst
│   │
│   ├── normativa/                    ⚠️ CREAR TODO
│   │   ├── index.rst                 # ~63 artefactos
│   │   ├── estandares/               # 6 STD
│   │   │   ├── index.rst
│   │   │   └── plantillas/           # 17 TPL
│   │   │       └── index.rst
│   │   ├── procedimientos/           # 38 PROC
│   │   │   └── index.rst
│   │   └── politicas/                # 2 POL
│   │       └── index.rst
│   │
│   └── evidencia/                    ⚠️ CREAR TODO
│       ├── index.rst                 # ~10 artefactos
│       ├── pruebas/                  # TST (pendiente)
│       │   └── index.rst
│       └── trazabilidad/             # RTM, COV
│           └── index.rst
│
└── build/                            ⚠️ Generado automáticamente
    └── html/
```

---

## 3. ANÁLISIS DE NAVEGACIÓN SPHINX

### 3.1 Sistema de TOC Tree (Table of Contents)

Sphinx usa el concepto de **toctree** (table of contents tree) para construir la navegación:

```rst
.. toctree::
   :maxdepth: 2
   :caption: Nombre de la Sección
   
   archivo1
   archivo2
   carpeta/index
```

**Características:**
- `:maxdepth:` controla cuántos niveles de profundidad mostrar
- `:caption:` es el título de la sección en el menú
- Los archivos se referencian sin la extensión .rst
- Los subdirectorios se referencian con su index

### 3.2 Jerarquía de TOC Tree para IACT

#### Nivel 1: index.rst Principal (Raíz)
```
source/index.rst
├── Información General (caption)
│   ├── readme
│   ├── prerequisites
│   ├── authors
│   └── licence
├── Dominios del Proyecto (caption)
│   ├── base_cognitiva/index
│   ├── requisitos/index
│   ├── arquitectura_tecnica/index
│   ├── normativa/index
│   └── evidencia/index
└── Documentación de Referencia (caption)
    ├── modelo_documental
    ├── anexo_a_arbol
    ├── restricciones_sistema
    └── modelo_rbac
```

#### Nivel 2: Índices de Dominio

**Ejemplo: requisitos/index.rst**
```
requisitos/index.rst
├── objetivos_negocio/index
├── reglas_negocio/index
├── casos_uso/index
├── funcionales/index
└── no_funcionales/index
```

#### Nivel 3: Índices de Subdominio

**Ejemplo: requisitos/casos_uso/index.rst**
```
casos_uso/index.rst
├── auth/index
├── users/index
├── access/index
├── pipeline/index
├── reports/index
├── alerts/index
├── audit/index
└── logs/index
```

#### Nivel 4: Archivos Individuales

**Ejemplo: casos_uso/auth/index.rst**
```
auth/index.rst
├── UC_AUTH_01_Iniciar_Sesion
├── UC_AUTH_02_Cerrar_Sesion
├── UC_AUTH_03_Recuperar_Contrasena
├── UC_AUTH_04_Cambiar_Contrasena
└── UC_AUTH_05_Gestionar_Sesiones
```

---

## 4. CONFIGURACIÓN DE SPHINX (conf.py)

### 4.1 Configuración Mínima Requerida

```python
# conf.py
project = 'Sistema IACT'
copyright = '2025-2026, [Nombre de tu Empresa]'
author = 'Equipo IACT'
version = '1.0'
release = '1.0.0'

extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.napoleon',
    'sphinx.ext.viewcode',
    'sphinx.ext.todo',
    'sphinx.ext.graphviz',
    'sphinx_design',
    'sphinx_copybutton',
    'sphinx_tabs.tabs',
    'myst_parser',
]

templates_path = ['_templates']
exclude_patterns = []
html_theme = 'furo'
html_static_path = ['_static']
html_logo = '_static/img/logo_iact.png'
html_title = 'Sistema IACT - Documentación'

# MyST Parser
myst_enable_extensions = [
    "colon_fence",
    "deflist",
]

# Furo theme options
html_theme_options = {
    "sidebar_hide_name": False,
    "navigation_with_keys": True,
}
```

### 4.2 Extensiones Instaladas (requirements.txt)

Todas estas extensiones ya están en tu requirements.txt:
- ✅ Sphinx 8.2.3
- ✅ Furo 2025.9.25 (tema moderno)
- ✅ MyST Parser 4.0.1 (Markdown support)
- ✅ sphinx_design 0.6.1 (componentes UI)
- ✅ sphinx_copybutton 0.5.2
- ✅ sphinx_tabs 3.4.5
- ✅ sphinx-autodoc-typehints 3.5.2
- ✅ sphinxcontrib-openapi 0.8.4

---

## 5. ARCHIVOS QUE APARECEN EN EL MENÚ

### 5.1 Reglas de Visibilidad

Un archivo aparece en el menú de navegación SI Y SOLO SI:

1. **Está incluido en un toctree** de algún index.rst
2. **O** está referenciado desde otro documento visible

**Archivos que NO aparecen:**
- Archivos en carpetas con prefijo `_` (privadas)
- Archivos no incluidos en ningún toctree
- Archivos con `:hidden:` en el toctree


### 5.2 Ejemplo de Visibilidad

```
source/
├── index.rst                    # VISIBLE (entrada principal)
│   └── toctree: base_cognitiva/index
│
├── base_cognitiva/
│   ├── index.rst                # VISIBLE (referenciado desde raíz)
│   │   └── toctree: glosario/GLOS_001
│   │
│   ├── glosario/
│   │   └── GLOS_001.rst         # VISIBLE (en toctree)
│   │
│   └── _metadata/               # CARPETA PRIVADA (prefijo _)
│       └── META_01.rst          # NO VISIBLE (carpeta privada)
```

### 5.3 Carpetas Privadas en IACT (Prefijo `_`)

Según el modelo documental, estas carpetas son privadas:

| Carpeta | Ubicación | Artefactos | Razón |
|---------|-----------|------------|-------|
| `_metadata/` | base_cognitiva/ | 5 META | Información interna |
| `_fundamentos_conceptuales/` | base_cognitiva/ | 7 FND | Teoría de soporte |
| `_ontologia_sbvr/` | base_cognitiva/ | 5 SBVR | Documentación técnica |
| `_taxonomias_y_metamodelos/` | base_cognitiva/ | 6 TXM+MTM | Modelos internos |
| `_metodologias_analiticas/` | base_cognitiva/ | 3 METH | Metodologías |
| `_static/` | source/ | CSS/JS/IMG | Recursos Sphinx |
| `_templates/` | source/ | HTML | Plantillas Sphinx |

**Total:** ~26 artefactos privados

---

## 6. CONVENCIONES Y NOMENCLATURA

### 6.1 Nomenclatura de Archivos por Tipo

| Tipo | Patrón | Ejemplo | Versión |
|------|--------|---------|---------|
| Business Requirement | `BReq_[MOD]_[Nombre].rst` | `BReq_AUTH_Autenticacion.rst` | No |
| Business Rule | `BR_[NNN]_[Nombre].rst` | `BR_001_Fuente_Operacional_Inmutable.rst` | No |
| Caso de Uso | `UC_[MOD]_[NN]_[Nombre].rst` | `UC_AUTH_01_Iniciar_Sesion.rst` | No |
| Requisito Funcional | `FR_UC[MOD]_[NN]_[NN].rst` | `FR_UCAUTH_01_01_Validar_Username.rst` | No |
| Requisito No Funcional | `NFR_[CAT]_[NNN]_[Nombre].rst` | `NFR_PERF_001_Tiempo_Respuesta.rst` | No |
| Restricción | `CNST_[NNN]_[Nombre].rst` | `CNST_001_Comunicaciones_Prohibidas.rst` | No |
| Módulo | `MOD_[Nombre].rst` | `MOD_Auth.rst` | No |
| ADR | `ADR_[NNN]_[Nombre].rst` | `ADR_001_Stack_Python_Django.rst` | No |
| Estándar | `STD_[NNN]_[Nombre].rst` | `STD_006_Versionado_Semantico.rst` | No |
| Template | `TPL_[Tipo]_[Nombre]_X_Y_Z.rst` | `TPL_FR_Requisitos_Funcionales_1_0_0.rst` | Sí |
| Procedimiento | `PROC_[Nombre]_X_Y_Z.rst` | `PROC_Generacion_FR_1_0_0.rst` | Sí |
| Política | `POL_[NNN]_[Nombre].rst` | `POL_001_Seguridad_Informacion.rst` | No |

### 6.2 Nomenclatura de Índices

| Archivo | Propósito | Patrón toctree |
|---------|-----------|----------------|
| `source/index.rst` | Índice raíz principal | Referencias a dominios |
| `[dominio]/index.rst` | Índice de dominio | Referencias a subdominios |
| `[subdominio]/index.rst` | Índice de subdominio | Referencias a artefactos individuales |
| `[módulo]/index.rst` | Índice de módulo (UC, FR) | Referencias a casos de uso |

### 6.3 Estructura de un index.rst Típico

```rst
====================
Título del Dominio
====================

Breve descripción del dominio/sección.

Contenido
=========

.. toctree::
   :maxdepth: 2
   :caption: Subsección 1
   
   subdominio1/index
   subdominio2/index

.. toctree::
   :maxdepth: 1
   :caption: Subsección 2
   
   archivo1
   archivo2
   archivo3

Referencias
===========

Enlaces a documentos relacionados.
```

---

## 7. INTEGRACIÓN DE ARCHIVOS RAÍZ

### 7.1 Ubicación de los 4 Archivos Principales

#### Opción A: Referenciados desde index.rst Principal (RECOMENDADO)

**Ventajas:**
- Acceso inmediato desde la página principal
- Clara separación entre "información general" y "dominios"
- Sigue convenciones estándar de Sphinx

**Estructura:**
```
source/
├── index.rst         # Referencia a readme, prerequisites, authors, licence
├── readme.rst        # Copiado desde raíz
├── prerequisites.rst # Copiado desde raíz
├── authors.rst       # Copiado desde raíz
├── licence.rst       # Copiado desde raíz
└── [5 dominios]/
```

**index.rst principal:**
```rst
.. toctree::
   :maxdepth: 2
   :caption: Información General
   
   readme
   prerequisites
   authors
   licence

.. toctree::
   :maxdepth: 2
   :caption: Dominios del Proyecto
   
   base_cognitiva/index
   requisitos/index
   arquitectura_tecnica/index
   normativa/index
   evidencia/index
```

#### Opción B: Crear Dominio Nuevo `informacion_general/`

**Ventajas:**
- Más consistencia con la estructura de 5 dominios
- Permite agregar más documentación general fácilmente

**Desventajas:**
- Un poco más de profundidad en la navegación
- Menos estándar en proyectos Sphinx

**Estructura:**
```
source/
├── index.rst
├── informacion_general/
│   ├── index.rst
│   ├── readme.rst
│   ├── prerequisites.rst
│   ├── authors.rst
│   └── licence.rst
└── [5 dominios]/
```

### 7.2 Decisión Recomendada: OPCIÓN A

**Razón:** Los archivos raíz son meta-información sobre el proyecto, no un "dominio" funcional. Sphinx tradicionalmente los coloca en el nivel raíz del source/.

---

## 8. DOCUMENTOS MARKDOWN A INTEGRAR

### 8.1 Documentos Grandes que Requieren Conversión

| Documento | Tamaño Est. | Formato Actual | Destino |
|-----------|-------------|----------------|---------|
| MODELO_DOCUMENTAL_IACT_v2_2_0 | ~400 líneas × 2 | Markdown (2 partes) | `normativa/estandares/` |
| ANEXO_A_ARBOL_COMPLETO | ~250 líneas × 2 | Markdown (2 partes) | `normativa/estandares/` |
| RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT | ~1130 líneas | Markdown | `arquitectura_tecnica/restricciones/` |
| MODELO_RBAC_IACT_v5_1_1 | ~1650 líneas | Markdown | `arquitectura_tecnica/modulos/` |

### 8.2 Proceso de Conversión Markdown → RST

**Herramientas:**
1. **pandoc** (recomendado)
2. **Conversión manual** para control total

**Comando pandoc:**
```bash
pandoc -f markdown -t rst input.md -o output.rst
```

**Post-conversión requerida:**
- Ajustar encabezados a convención Sphinx
- Verificar tablas
- Ajustar bloques de código
- Validar referencias internas

### 8.3 Ubicación Final de Documentos Convertidos

| Documento Original | Documento RST | Ubicación Final |
|-------------------|---------------|-----------------|
| MODELO_DOCUMENTAL_IACT_v2_2_0 | `MODELO_DOCUMENTAL_v2_2_0.rst` | `normativa/estandares/` |
| ANEXO_A_ARBOL_COMPLETO | `ANEXO_A_Arbol_Completo_v2_2_0.rst` | `normativa/estandares/` |
| RESTRICCIONES_COMPLETAS | `RESTRICCIONES_SISTEMA_COMPLETAS_v1_0_0.rst` | `arquitectura_tecnica/restricciones/` |
| MODELO_RBAC | `MODELO_RBAC_v5_1_1.rst` | `arquitectura_tecnica/modulos/` |

---

## 9. ESTADO DE CONGELAMIENTO

### 9.1 Subdominios Congelados (NO MODIFICAR)

Según el modelo documental, estos subdominios están **CONGELADOS**:

| Subdominio | Dominio | Artefactos | Razón |
|------------|---------|------------|-------|
| `glosario/` | base_cognitiva | 1 GLOS | Glosario estable |
| `reglas_negocio/` | requisitos | 20 BR | Reglas de negocio finalizadas |
| `modulos/` | arquitectura_tecnica | 8 MOD | Módulos del sistema definidos |
| `restricciones/` | arquitectura_tecnica | 10 CNST | Restricciones establecidas |
| `politicas/` | normativa | 2 POL | Políticas aprobadas |
| `trazabilidad/` | evidencia | 6 RTM/COV | Matrices de trazabilidad |

**Total:** 47 artefactos congelados

### 9.2 Subdominios Descongelados (EN DESARROLLO)

| Subdominio | Dominio | Estado Actual |
|------------|---------|---------------|
| `objetivos_negocio/` | requisitos | ✅ Completo (8 BReq) |
| `casos_uso/` | requisitos | ✅ Completo (49 UC) |
| `funcionales/` | requisitos | 🔄 En progreso (55/~392 FR, 14%) |
| `decisiones/` | arquitectura_tecnica | ✅ Completo (5 ADR) |
| `vistas/` | arquitectura_tecnica | ✅ Completo (5 VIEW) |
| `flujos_datos/` | arquitectura_tecnica | ✅ Completo (12 FD) |
| `apis/` | arquitectura_tecnica | ✅ Completo (8 API) |
| `estandares/` | normativa | ✅ Completo (6 STD + 17 TPL) |
| `procedimientos/` | normativa | ✅ Completo (38 PROC) |
| `pruebas/` | evidencia | ⏳ Pendiente (0 TST) |

---

## 10. PRIORIDADES DE CONSTRUCCIÓN

### 10.1 Fases de Implementación

#### FASE 0: Preparación (CRÍTICO)
- [ ] Crear estructura de directorios base
- [ ] Configurar conf.py
- [ ] Crear .gitignore
- [ ] Verificar requirements.txt

#### FASE 1: Archivos Raíz y Configuración (ALTA PRIORIDAD)
- [ ] Crear source/index.rst principal
- [ ] Copiar readme.rst, prerequisites.rst, authors.rst, licence.rst
- [ ] Crear _static/ y _templates/
- [ ] Primer build de prueba: `make html`

#### FASE 2: Dominios Principales (ALTA PRIORIDAD)
- [ ] Crear índices de los 5 dominios
- [ ] Crear subdominios con índices
- [ ] Verificar navegación

#### FASE 3: Conversión de Documentos Markdown (MEDIA PRIORIDAD)
- [ ] Convertir MODELO_DOCUMENTAL
- [ ] Convertir ANEXO_A
- [ ] Convertir RESTRICCIONES_COMPLETAS
- [ ] Convertir MODELO_RBAC

#### FASE 4: Integración de Artefactos Existentes (BAJA PRIORIDAD)
- [ ] Migrar 20 BR
- [ ] Migrar 49 UC
- [ ] Migrar 55 FR existentes
- [ ] Migrar 10 CNST
- [ ] Migrar 8 MOD

#### FASE 5: Población de Subdominios Vacíos (FUTURA)
- [ ] Crear artefactos pendientes en funcionales/
- [ ] Crear artefactos en pruebas/
- [ ] Completar base_cognitiva/

---

## 11. PROBLEMAS POTENCIALES Y SOLUCIONES

### 11.1 Problema: Archivos Muy Grandes

**Síntoma:** Error "An error occurred while attempting to create the file"

**Causa:** Límite de tamaño en create_file tool

**Solución: Staging con /tmp**

```bash
# Crear archivo en partes en /tmp
cat > /tmp/archivo_parte1.rst << 'ENDOFPART1'
[contenido parte 1]
ENDOFPART1

cat >> /tmp/archivo_parte1.rst << 'ENDOFPART2'
[contenido parte 2]

### 11.1 Problema: Archivos Muy Grandes

**Síntoma:** Error "An error occurred while attempting to create the file"

**Causa:** Límite de tamaño en create_file tool

**Solución: Staging con /tmp**

```bash
# Crear archivo en partes en /tmp
cat > /tmp/archivo.rst << 'DELIM1'
contenido parte 1
DELIM1

cat >> /tmp/archivo.rst << 'DELIM2'
contenido parte 2
DELIM2

# Luego copiar a destino
cp /tmp/archivo.rst /mnt/user-data/outputs/
```

---

**FIN DEL ANÁLISIS**

**Versión:** 1.0.0
**Fecha:** 2026-01-07
**Documento Relacionado:** MODELO_DOCUMENTAL_IACT_v2_2_0.md
