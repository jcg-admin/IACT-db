# ANÁLISIS PARA ACTUALIZACIÓN DEL MODELO DOCUMENTAL IACT
## De v2.1.1 a v2.2.0

**Fecha:** 2026-01-07  
**Autor:** Equipo IACT  
**Propósito:** Documentar cambios requeridos para actualizar el MODELO_DOCUMENTAL_IACT

---

## 1. RESUMEN EJECUTIVO

### 1.1 Cambio Principal

La sección **"11. ÁRBOL COMPLETO v2.1.1"** será reorganizada:

| Aspecto | v2.1.1 | v2.2.0 |
|---------|--------|--------|
| Árbol en sección 11 | Completo (196 líneas) | Resumido (~50 líneas) |
| Anexo | No existe | **ANEXO_A: Árbol Completo** |
| TPL en árbol | 6 TPL antiguos | **17 TPL nuevos** |
| PROC en árbol | 3 PROC antiguos | **38 PROC nuevos** |

### 1.2 Justificación del Cambio

- El árbol completo pasará de ~196 líneas a ~600+ líneas
- Incluir 38 PROC + 17 TPL en línea haría el documento principal inmanejable
- Separar en anexo permite mantener el modelo principal legible

### 1.3 Incremento de Versión

Según **STD_006 Versionado Semántico**:
- Cambio estructural (nueva sección Anexo) = **MINOR**
- Nueva versión: **v2.2.0**

---

## 2. CAMBIOS EN ARTEFACTOS

### 2.1 Templates (TPL) - De 6 a 17

| Estado | Antes (v2.1.1) | Después (v2.2.0) |
|--------|----------------|------------------|
| Existentes | 6 TPL | 6 TPL (renombrar) |
| Nuevos | 0 | 11 TPL |
| **Total** | **6** | **17** |

**TPL Existentes (renombrar nomenclatura):**
```
TPL_001_Plantilla_BR.rst      → TPL_BR_Business_Rules_1_0_0.rst
TPL_002_Plantilla_UC.rst      → TPL_UC_Casos_de_Uso_2_0_0.rst
TPL_003_Plantilla_FR.rst      → TPL_FR_Requisitos_Funcionales_1_0_0.rst
TPL_004_Plantilla_ADR.rst     → TPL_ADR_Decisiones_Arquitectonicas_1_0_0.rst
TPL_005_Plantilla_CNST.rst    → TPL_CNST_Restricciones_1_0_0.rst
TPL_006_Plantilla_MOD.rst     → TPL_MOD_Modulos_1_0_0.rst
```

**TPL Nuevos (11):**
```
TPL_BReq_Objetivos_Negocio_1_0_0.rst
TPL_NFR_No_Funcionales_1_0_0.rst
TPL_TST_Pruebas_1_0_0.rst
TPL_STD_Estandares_1_0_0.rst
TPL_PROC_Procedimientos_1_0_0.rst
TPL_POL_Politicas_1_0_0.rst
TPL_FD_Fichas_Dominio_1_0_0.rst
TPL_VIEW_Vistas_Arquitectonicas_1_0_0.rst
TPL_API_Documentacion_API_1_1_0.rst
TPL_RTM_Trazabilidad_1_0_0.rst
TPL_INDEX_Indices_1_0_0.rst
```

### 2.2 Procedimientos (PROC) - De 3 a 38

| Estado | Antes (v2.1.1) | Después (v2.2.0) |
|--------|----------------|------------------|
| Existentes | 3 PROC | 3 PROC (renombrar) |
| Nuevos | 0 | 35 PROC |
| **Total** | **3** | **38** |

**PROC Existentes (renombrar nomenclatura):**
```
PROC_001_Cambio_Requisitos.rst      → PROC_Cambio_Requisitos_1_0_0.rst
PROC_002_Revision_Artefactos.rst    → PROC_Revision_Artefactos_1_0_0.rst
PROC_003_Aprobacion_Documentos.rst  → PROC_Aprobacion_Documentos_1_0_0.rst
```

**PROC Nuevos por Categoría (35):**

| Categoría | Cantidad | PROC |
|-----------|----------|------|
| Preparación | 4 | Revision_UC_Previo_Derivacion, Revision_TPL_Previo_Generacion, Crear_Estructura_Directorios_Tmp, Crear_Plan_Analisis |
| Generación | 13 | Generacion_BReq, BR, UC, FR, NFR, TST, CNST, MOD, ADR, STD, POL, FD, VIEW, API, RTM, Index |
| Derivación | 5 | Derivacion_BReq_BR, BR_UC, UC_FR, FR_TST, FR_CODE |
| Gobernanza | 4 | Versionado_Semantico, Congelamiento_Subdominio, Descongelamiento_Subdominio, Actualizacion_Modelo_Documental |
| Transferencia | 3 | Copiar_Tmp_Outputs, Validacion_Sphinx, Publicacion_Documentacion |
| Trazabilidad | 3 | Verificacion_Cobertura, Auditoria_Documental, Identificar_Gaps_Huerfanos |

---

## 3. ESTRUCTURA DE LA SECCIÓN 11 (NUEVA)

### 3.1 Sección 11 Resumida (~50 líneas)

```markdown
# 11. ÁRBOL DE DIRECTORIOS (Resumen)

## 11.1 Estructura de Alto Nivel

\`\`\`
IACT/
├── conf.py
├── index.rst
├── base_cognitiva/           # Conocimiento fundamental
│   ├── _metadata/            # 5 META
│   ├── glosario/             # 1 GLOS
│   ├── _fundamentos/         # 7 FND
│   └── ...
├── requisitos/               # Especificación del sistema
│   ├── objetivos_negocio/    # 8 BReq
│   ├── reglas_negocio/       # 20 BR
│   ├── casos_uso/            # 49 UC (8 módulos)
│   ├── funcionales/          # 55 FR (en progreso)
│   └── no_funcionales/       # ~20 NFR
├── arquitectura_tecnica/     # Diseño e implementación
│   ├── modulos/              # 8 MOD
│   ├── restricciones/        # 10 CNST
│   ├── decisiones/           # 5 ADR
│   └── ...
├── normativa/                # Estándares y políticas
│   ├── estandares/           # 6 STD
│   │   └── plantillas/       # 🆕 17 TPL
│   ├── procedimientos/       # 🆕 38 PROC
│   └── politicas/            # 2 POL
└── evidencia/                # Verificación y trazabilidad
    ├── pruebas/              # TST (pendiente)
    └── trazabilidad/         # RTM, COV
\`\`\`

> 📎 **Ver ANEXO_A** para el árbol completo con todos los artefactos.
```

### 3.2 Referencia al Anexo

Al final de la sección 11:

```markdown
## 11.2 Árbol Completo

El árbol completo con todos los artefactos individuales se encuentra en:

**[ANEXO_A: Árbol Completo del Modelo Documental](#anexo-a-árbol-completo)**

Este anexo incluye:
- 17 Templates (TPL) con nomenclatura versionada
- 38 Procedimientos (PROC) con nomenclatura versionada
- Todos los artefactos por dominio
```

---

## 4. ESTRUCTURA DEL ANEXO A

### 4.1 Contenido del Anexo

El **ANEXO_A** contendrá:

1. Árbol completo del DOMINIO 1: BASE COGNITIVA
2. Árbol completo del DOMINIO 2: REQUISITOS
3. Árbol completo del DOMINIO 3: ARQUITECTURA TÉCNICA
4. Árbol completo del DOMINIO 4: NORMATIVA (expandido con 17 TPL y 38 PROC)
5. Árbol completo del DOMINIO 5: EVIDENCIA

### 4.2 Estimación de Tamaño

| Dominio | Líneas Estimadas |
|---------|------------------|
| Base Cognitiva | ~50 |
| Requisitos | ~120 |
| Arquitectura Técnica | ~60 |
| **Normativa** | **~250** (17 TPL + 38 PROC) |
| Evidencia | ~30 |
| **Total Anexo** | **~510 líneas** |

---

## 5. CAMBIOS EN OTRAS SECCIONES

### 5.1 Sección 1.1 Fórmula del Modelo

**Antes (v2.1.1):**
```
5 DOMINIOS + 21 SUBDOMINIOS + 6 SUBCARPETAS + 49 UC + 55 FR + 20 BR + 6 STD
```

**Después (v2.2.0):**
```
5 DOMINIOS + 21 SUBDOMINIOS + 6 SUBCARPETAS + 49 UC + 55 FR + 20 BR + 6 STD + 17 TPL + 38 PROC
```

### 5.2 Sección 13 (Procedimientos Pendientes)

**Antes (v2.1.1):**
```
| Categoría | Existentes | Necesarios | Gap |
|-----------|------------|------------|-----|
| PROC | 3 | 19 | -16 |
| TPL | 6 | 11 | -5 |
```

**Después (v2.2.0):**
```
| Categoría | Existentes | Necesarios | Gap |
|-----------|------------|------------|-----|
| PROC | 38 | 38 | ✅ 0 |
| TPL | 17 | 17 | ✅ 0 |
```

### 5.3 Sección 14.1 Catálogo de Prefijos

**Actualizar cantidad estimada:**

| Dominio | Prefijos | Antes | Después |
|---------|----------|-------|---------|
| normativa | STD, PROC, POL, TPL | ~17 | **~63** |
| **TOTAL** | — | ~569 | **~615** |

### 5.4 Sección 12.1 Métricas

Agregar filas:

| Métrica | v2.1.1 | v2.2.0 | Cambio |
|---------|--------|--------|--------|
| TPL documentados | 6 | **17** | **+11** |
| PROC documentados | 3 | **38** | **+35** |

---

## 6. CHANGELOG v2.2.0

```markdown
| Versión | Cambio |
|---------|--------|
| **v2.2.0** | **🆕 Sección 11 resumida, árbol completo movido a ANEXO_A** |
| **v2.2.0** | **🆕 17 TPL con nomenclatura versionada (antes 6)** |
| **v2.2.0** | **🆕 38 PROC con nomenclatura versionada (antes 3)** |
| **v2.2.0** | **🆕 Gap de PROC cerrado: 38/38 (100%)** |
| **v2.2.0** | **🆕 Gap de TPL cerrado: 17/17 (100%)** |
| **v2.2.0** | **🆕 Nueva nomenclatura: PROC_[Nombre]_X_Y_Z.rst** |
| **v2.2.0** | **🆕 Nueva nomenclatura: TPL_[Tipo]_[Nombre]_X_Y_Z.rst** |
```

---

## 7. PLAN DE EJECUCIÓN

### 7.1 Archivos a Generar

1. **MODELO_DOCUMENTAL_IACT_v2_2_0.md** - Documento principal actualizado
2. **ANEXO_A_ARBOL_COMPLETO_v2_2_0.md** - Anexo con árbol detallado

### 7.2 Orden de Generación

```
1. Generar ANEXO_A (por partes si es necesario)
   ├── Parte 1: Dominios 1-2 (Base Cognitiva, Requisitos)
   ├── Parte 2: Dominio 3 (Arquitectura Técnica)
   ├── Parte 3: Dominio 4 (Normativa - TPL + PROC)
   └── Parte 4: Dominio 5 (Evidencia)

2. Generar MODELO_DOCUMENTAL_IACT_v2_2_0.md
   └── Con sección 11 resumida y referencia al anexo
```

---

## 8. LISTA DE VERIFICACIÓN

### 8.1 Pre-generación

- [x] Análisis de cambios documentado
- [x] Nueva versión determinada (v2.2.0)
- [x] Estructura del anexo definida
- [x] Lista completa de 38 PROC
- [x] Lista completa de 17 TPL

### 8.2 Post-generación

- [ ] ANEXO_A generado completo
- [ ] MODELO_DOCUMENTAL actualizado
- [ ] Sección 11 resumida
- [ ] Métricas actualizadas
- [ ] CHANGELOG actualizado
- [ ] Referencias cruzadas verificadas

---

## 9. CATÁLOGO COMPLETO DE 38 PROC (Nueva Nomenclatura)

### 9.1 Preparación y Apoyo (4)

| # | PROC | Líneas |
|---|------|--------|
| 1 | PROC_Revision_UC_Previo_Derivacion_1_0_0.rst | 375 |
| 2 | PROC_Revision_TPL_Previo_Generacion_1_0_0.rst | 355 |
| 3 | PROC_Crear_Estructura_Directorios_Tmp_1_0_0.rst | 393 |
| 4 | PROC_Crear_Plan_Analisis_1_0_0.rst | 150 |

### 9.2 Generación de Artefactos (16)

| # | PROC | Líneas |
|---|------|--------|
| 5 | PROC_Generacion_BReq_1_0_0.rst | 162 |
| 6 | PROC_Generacion_BR_1_0_0.rst | 393 |
| 7 | PROC_Generacion_UC_1_0_0.rst | 441 |
| 8 | PROC_Generacion_FR_1_0_0.rst | 459 |
| 9 | PROC_Generacion_NFR_1_0_0.rst | 402 |
| 10 | PROC_Generacion_TST_1_0_0.rst | 509 |
| 11 | PROC_Generacion_CNST_1_0_0.rst | 175 |
| 12 | PROC_Generacion_MOD_1_0_0.rst | 190 |
| 13 | PROC_Generacion_ADR_1_0_0.rst | 180 |
| 14 | PROC_Generacion_STD_1_0_0.rst | 411 |
| 15 | PROC_Generacion_POL_1_0_0.rst | 165 |
| 16 | PROC_Generacion_FD_1_0_0.rst | 164 |
| 17 | PROC_Generacion_VIEW_1_0_0.rst | 178 |
| 18 | PROC_Generacion_API_1_0_0.rst | 463 |
| 19 | PROC_Generacion_RTM_1_0_0.rst | 446 |
| 20 | PROC_Generacion_Index_1_0_0.rst | 398 |

### 9.3 Derivación (5)

| # | PROC | Líneas |
|---|------|--------|
| 21 | PROC_Derivacion_BReq_BR_1_0_0.rst | 177 |
| 22 | PROC_Derivacion_BR_UC_1_0_0.rst | 187 |
| 23 | PROC_Derivacion_UC_FR_1_0_0.rst | 485 |
| 24 | PROC_Derivacion_FR_TST_1_1_0.rst | 440 |
| 25 | PROC_Derivacion_FR_CODE_1_0_0.rst | 184 |

### 9.4 Gobernanza Documental (7)

| # | PROC | Líneas |
|---|------|--------|
| 26 | PROC_Versionado_Semantico_1_0_0.rst | 372 |
| 27 | PROC_Congelamiento_Subdominio_1_0_0.rst | 388 |
| 28 | PROC_Descongelamiento_Subdominio_1_0_0.rst | 386 |
| 29 | PROC_Actualizacion_Modelo_Documental_1_0_0.rst | 389 |
| 30 | PROC_Cambio_Requisitos_1_0_0.rst | 351 |
| 31 | PROC_Revision_Artefactos_1_0_0.rst | 403 |
| 32 | PROC_Aprobacion_Documentos_1_0_0.rst | 402 |

### 9.5 Transferencia y Publicación (3)

| # | PROC | Líneas |
|---|------|--------|
| 33 | PROC_Copiar_Tmp_Outputs_1_0_0.rst | 389 |
| 34 | PROC_Validacion_Sphinx_1_0_0.rst | 175 |
| 35 | PROC_Publicacion_Documentacion_1_0_0.rst | 179 |

### 9.6 Trazabilidad y Verificación (3)

| # | PROC | Líneas |
|---|------|--------|
| 36 | PROC_Verificacion_Cobertura_1_0_0.rst | 190 |
| 37 | PROC_Auditoria_Documental_1_0_0.rst | 183 |
| 38 | PROC_Identificar_Gaps_Huerfanos_1_0_0.rst | 184 |

**Total PROC: 38 archivos, ~11,873 líneas**

---

## 10. CATÁLOGO COMPLETO DE 17 TPL (Nueva Nomenclatura)

| # | TPL | Líneas | Estado |
|---|-----|--------|--------|
| 1 | TPL_BReq_Objetivos_Negocio_1_0_0.rst | 450 | Nuevo |
| 2 | TPL_BR_Business_Rules_1_0_0.rst | 580 | Renombrado |
| 3 | TPL_UC_Casos_de_Uso_2_0_0.rst | 620 | Renombrado |
| 4 | TPL_FR_Requisitos_Funcionales_1_0_0.rst | 533 | Renombrado |
| 5 | TPL_NFR_No_Funcionales_1_0_0.rst | 520 | Nuevo |
| 6 | TPL_TST_Pruebas_1_0_0.rst | 580 | Nuevo |
| 7 | TPL_CNST_Restricciones_1_0_0.rst | 440 | Renombrado |
| 8 | TPL_MOD_Modulos_1_0_0.rst | 480 | Renombrado |
| 9 | TPL_ADR_Decisiones_Arquitectonicas_1_0_0.rst | 470 | Renombrado |
| 10 | TPL_STD_Estandares_1_0_0.rst | 617 | Nuevo |
| 11 | TPL_PROC_Procedimientos_1_0_0.rst | 578 | Nuevo |
| 12 | TPL_POL_Politicas_1_0_0.rst | 490 | Nuevo |
| 13 | TPL_FD_Fichas_Dominio_1_0_0.rst | 520 | Nuevo |
| 14 | TPL_VIEW_Vistas_Arquitectonicas_1_0_0.rst | 510 | Nuevo |
| 15 | TPL_API_Documentacion_API_1_1_0.rst | 650 | Nuevo |
| 16 | TPL_RTM_Trazabilidad_1_0_0.rst | 576 | Nuevo |
| 17 | TPL_INDEX_Indices_1_0_0.rst | 304 | Nuevo |

**Total TPL: 17 archivos, ~8,918 líneas**

---

*Análisis v1.0.0 - 2026-01-07*
*Preparación para MODELO_DOCUMENTAL_IACT v2.2.0*
