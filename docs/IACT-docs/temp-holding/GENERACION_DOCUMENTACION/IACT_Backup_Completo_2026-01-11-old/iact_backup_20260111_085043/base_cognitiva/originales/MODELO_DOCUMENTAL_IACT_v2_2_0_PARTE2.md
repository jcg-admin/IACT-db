
---

# 11. ÁRBOL DE DIRECTORIOS (Resumen) 🆕 v2.2.0

## 11.1 Estructura de Alto Nivel

```
IACT/
├── conf.py
├── index.rst
│
├── base_cognitiva/                   # Conocimiento fundamental
│   ├── _metadata/                    # 5 META
│   ├── glosario/                     # 1 GLOS
│   ├── _fundamentos_conceptuales/    # 7 FND
│   ├── _ontologia_sbvr/              # 5 SBVR
│   ├── _taxonomias_y_metamodelos/    # 3 TXM + 3 MTM
│   └── _metodologias_analiticas/     # 3 METH
│
├── requisitos/                       # Especificación del sistema
│   ├── objetivos_negocio/            # 8 BReq
│   ├── reglas_negocio/               # 20 BR [CONGELADO]
│   ├── casos_uso/                    # 49 UC (8 módulos)
│   │   ├── auth/                     # 5 UC
│   │   ├── users/                    # 4 UC
│   │   ├── access/                   # 9 UC
│   │   ├── ...
│   │   └── logs/                     # 4 UC
│   ├── funcionales/                  # 55 FR (en progreso)
│   │   ├── auth/                     # 21 FR ✅
│   │   ├── users/                    # 17 FR ✅
│   │   ├── access/                   # 17 FR 🔄
│   │   └── ...                       # ⏳ pendientes
│   └── no_funcionales/               # ~20 NFR
│
├── arquitectura_tecnica/             # Diseño e implementación
│   ├── modulos/                      # 8 MOD [CONGELADO]
│   ├── restricciones/                # 10 CNST [CONGELADO]
│   ├── decisiones/                   # 5 ADR
│   ├── vistas/                       # 5 VIEW
│   ├── flujos_datos/                 # 12 FD
│   ├── apis/                         # 8 API
│   └── modelos_datos/                # 3 MDL
│
├── normativa/                        # 🆕 EXPANDIDO v2.2.0
│   ├── estandares/                   # 6 STD
│   │   └── plantillas/               # 🆕 17 TPL (antes 6)
│   │       ├── TPL_BReq_Objetivos_Negocio_1_0_0.rst
│   │       ├── TPL_BR_Business_Rules_1_0_0.rst
│   │       ├── ...
│   │       └── TPL_INDEX_Indices_1_0_0.rst
│   ├── procedimientos/               # 🆕 38 PROC (antes 3)
│   │   ├── PROC_Generacion_FR_1_0_0.rst
│   │   ├── PROC_Derivacion_UC_FR_1_0_0.rst
│   │   ├── ...
│   │   └── PROC_Auditoria_Documental_1_0_0.rst
│   └── politicas/                    # 2 POL
│
└── evidencia/                        # Verificación y trazabilidad
    ├── pruebas/                      # TST (pendiente)
    └── trazabilidad/                 # RTM, COV
```

## 11.2 Árbol Completo

> 📎 **Ver [ANEXO_A: Árbol Completo del Modelo Documental](ANEXO_A_ARBOL_COMPLETO_v2_2_0.md)** para el detalle con todos los artefactos individuales.

El anexo incluye:
- **17 Templates (TPL)** con nomenclatura versionada
- **38 Procedimientos (PROC)** con nomenclatura versionada  
- Todos los artefactos por dominio (~293 archivos)
- ~600 líneas de árbol detallado

---

# 12. MÉTRICAS DE COBERTURA

## 12.1 Estado Actual del Proyecto (v2.2.0)

| Métrica | v2.1.1 | v2.2.0 | Cambio |
|---------|--------|--------|--------|
| BReq documentados | 8 | 8 | = |
| BR documentadas | 20 | 20 | = |
| UC generados | 49 | 49 | = |
| Líneas UC | 23,401 | 23,401 | = |
| Diagramas PlantUML | 147 | 147 | = |
| FR generados | 55 | 55 | = |
| STD documentados | 6 | 6 | = |
| **TPL documentados** | 6 | **17** | **+11** 🆕 |
| **PROC documentados** | 3 | **38** | **+35** 🆕 |
| TST creados | 0 | 0 | = |

## 12.2 Umbrales de Cobertura

| Cobertura | Umbral | Actual | Estado |
|-----------|--------|--------|--------|
| BReq → UC | 100% | 100% | ✅ |
| BR → UC | 100% | 100% | ✅ |
| CNST → UC | 100% | 100% | ✅ |
| UC → FR | 100% | 14% | 🔄 |
| FR → CODE | 90% | 0% | ⏳ |
| FR → TEST | 80% | 0% | ⏳ |

## 12.3 Progreso de Generación FR

```
GENERACIÓN FR: ██░░░░░░░░░░░░░░░░░░░░░░░░ 14% (55/~392)

MOD_Auth:    ████████████████████ 100% (21/~40)  ✅
MOD_Users:   ████████████████████ 100% (17/~32)  ✅
MOD_Access:  █████░░░░░░░░░░░░░░░  24% (17/~72)  🔄
MOD_Pipeline:░░░░░░░░░░░░░░░░░░░░   0% (0/~32)   ⏳
MOD_Reports: ░░░░░░░░░░░░░░░░░░░░   0% (0/~112)  ⏳
MOD_Alerts:  ░░░░░░░░░░░░░░░░░░░░   0% (0/~40)   ⏳
MOD_Audit:   ░░░░░░░░░░░░░░░░░░░░   0% (0/~32)   ⏳
MOD_Logs:    ░░░░░░░░░░░░░░░░░░░░   0% (0/~32)   ⏳
```

## 12.4 Progreso de Templates y Procedimientos 🆕 v2.2.0

```
TEMPLATES (TPL):     ████████████████████ 100% (17/17) ✅
PROCEDIMIENTOS (PROC): ████████████████████ 100% (38/38) ✅

Líneas generadas:
- TPL: ~8,918 líneas
- PROC: ~11,873 líneas
- Total normativa: ~20,791 líneas
```

---

# 13. TEMPLATES Y PROCEDIMIENTOS (v2.2.0) 🆕

## 13.1 Catálogo de 17 TPL

| # | TPL | Categoría | Líneas |
|---|-----|-----------|--------|
| 1 | TPL_BReq_Objetivos_Negocio_1_0_0.rst | Requisitos | 450 |
| 2 | TPL_BR_Business_Rules_1_0_0.rst | Requisitos | 580 |
| 3 | TPL_UC_Casos_de_Uso_2_0_0.rst | Requisitos | 620 |
| 4 | TPL_FR_Requisitos_Funcionales_1_0_0.rst | Requisitos | 533 |
| 5 | TPL_NFR_No_Funcionales_1_0_0.rst | Requisitos | 520 |
| 6 | TPL_CNST_Restricciones_1_0_0.rst | Arquitectura | 440 |
| 7 | TPL_MOD_Modulos_1_0_0.rst | Arquitectura | 480 |
| 8 | TPL_ADR_Decisiones_Arquitectonicas_1_0_0.rst | Arquitectura | 470 |
| 9 | TPL_FD_Fichas_Dominio_1_0_0.rst | Arquitectura | 520 |
| 10 | TPL_VIEW_Vistas_Arquitectonicas_1_0_0.rst | Arquitectura | 510 |
| 11 | TPL_API_Documentacion_API_1_1_0.rst | Arquitectura | 650 |
| 12 | TPL_STD_Estandares_1_0_0.rst | Normativa | 617 |
| 13 | TPL_PROC_Procedimientos_1_0_0.rst | Normativa | 578 |
| 14 | TPL_POL_Politicas_1_0_0.rst | Normativa | 490 |
| 15 | TPL_TST_Pruebas_1_0_0.rst | Evidencia | 580 |
| 16 | TPL_RTM_Trazabilidad_1_0_0.rst | Evidencia | 576 |
| 17 | TPL_INDEX_Indices_1_0_0.rst | Utilitario | 304 |

## 13.2 Catálogo de 38 PROC por Categoría

### Preparación y Apoyo (4)

| PROC | Propósito | Líneas |
|------|-----------|--------|
| PROC_Revision_UC_Previo_Derivacion_1_0_0.rst | Revisar UC antes de derivar FR | 375 |
| PROC_Revision_TPL_Previo_Generacion_1_0_0.rst | Revisar TPL antes de generar | 355 |
| PROC_Crear_Estructura_Directorios_Tmp_1_0_0.rst | Crear carpetas en /tmp | 393 |
| PROC_Crear_Plan_Analisis_1_0_0.rst | Crear documentos de análisis | 150 |

### Generación de Artefactos (16)

| PROC | Propósito | Líneas |
|------|-----------|--------|
| PROC_Generacion_BReq_1_0_0.rst | Generar objetivos de negocio | 162 |
| PROC_Generacion_BR_1_0_0.rst | Generar reglas de negocio | 393 |
| PROC_Generacion_UC_1_0_0.rst | Generar casos de uso | 441 |
| PROC_Generacion_FR_1_0_0.rst | Generar requisitos funcionales | 459 |
| PROC_Generacion_NFR_1_0_0.rst | Generar requisitos no funcionales | 402 |
| PROC_Generacion_TST_1_0_0.rst | Generar casos de prueba | 509 |
| PROC_Generacion_CNST_1_0_0.rst | Generar restricciones | 175 |
| PROC_Generacion_MOD_1_0_0.rst | Generar especificaciones de módulo | 190 |
| PROC_Generacion_ADR_1_0_0.rst | Generar decisiones arquitectónicas | 180 |
| PROC_Generacion_STD_1_0_0.rst | Generar estándares | 411 |
| PROC_Generacion_POL_1_0_0.rst | Generar políticas | 165 |
| PROC_Generacion_FD_1_0_0.rst | Generar fichas de dominio | 164 |
| PROC_Generacion_VIEW_1_0_0.rst | Generar vistas arquitectónicas | 178 |
| PROC_Generacion_API_1_0_0.rst | Generar documentación de API | 463 |
| PROC_Generacion_RTM_1_0_0.rst | Generar matrices de trazabilidad | 446 |
| PROC_Generacion_Index_1_0_0.rst | Generar archivos index | 398 |

### Derivación (5)

| PROC | Propósito | Líneas |
|------|-----------|--------|
| PROC_Derivacion_BReq_BR_1_0_0.rst | Derivar BReq → BR | 177 |
| PROC_Derivacion_BR_UC_1_0_0.rst | Derivar BR → UC | 187 |
| PROC_Derivacion_UC_FR_1_0_0.rst | Derivar UC → FR | 485 |
| PROC_Derivacion_FR_TST_1_1_0.rst | Derivar FR → TST | 440 |
| PROC_Derivacion_FR_CODE_1_0_0.rst | Derivar FR → CODE | 184 |

### Gobernanza Documental (7)

| PROC | Propósito | Líneas |
|------|-----------|--------|
| PROC_Versionado_Semantico_1_0_0.rst | Aplicar versionado semántico | 372 |
| PROC_Congelamiento_Subdominio_1_0_0.rst | Congelar subdominios | 388 |
| PROC_Descongelamiento_Subdominio_1_0_0.rst | Descongelar subdominios | 386 |
| PROC_Actualizacion_Modelo_Documental_1_0_0.rst | Actualizar modelo documental | 389 |
| PROC_Cambio_Requisitos_1_0_0.rst | Gestionar cambios en requisitos | 351 |
| PROC_Revision_Artefactos_1_0_0.rst | Revisar artefactos | 403 |
| PROC_Aprobacion_Documentos_1_0_0.rst | Aprobar documentos | 402 |

### Transferencia y Publicación (3)

| PROC | Propósito | Líneas |
|------|-----------|--------|
| PROC_Copiar_Tmp_Outputs_1_0_0.rst | Copiar de /tmp a /outputs | 389 |
| PROC_Validacion_Sphinx_1_0_0.rst | Validar con Sphinx | 175 |
| PROC_Publicacion_Documentacion_1_0_0.rst | Publicar documentación | 179 |

### Trazabilidad y Verificación (3)

| PROC | Propósito | Líneas |
|------|-----------|--------|
| PROC_Verificacion_Cobertura_1_0_0.rst | Verificar cobertura de requisitos | 190 |
| PROC_Auditoria_Documental_1_0_0.rst | Auditar modelo documental | 183 |
| PROC_Identificar_Gaps_Huerfanos_1_0_0.rst | Identificar gaps y huérfanos | 184 |

---

# 14. CATÁLOGO DE PREFIJOS

## 14.1 Por Dominio

| Dominio | Prefijos | Cantidad Est. |
|---------|----------|---------------|
| base_cognitiva | META, GLOS, FND, SBVR, TXM, MTM, METH | ~27 |
| requisitos | BReq, BR, UC, FR, NFR | ~142 |
| arquitectura_tecnica | MOD, CNST, ADR, VIEW, FD, API, MDL | ~51 |
| normativa | STD, PROC, POL, TPL | **~63** 🆕 |
| evidencia | TST, RTM, COV | ~10 |
| **TOTAL** | — | **~293** |

## 14.2 Nomenclatura de Archivos

```
Casos de Uso v4.0:
UC_[MOD]_[NN]_[Nombre_Descriptivo].rst

Requisitos Funcionales:
FR_UC[MOD]_[NN]_[NN].rst

Business Rules:
BR_[NNN]_[Nombre_Descriptivo].rst

Estándares:
STD_[NNN]_[Nombre_Descriptivo].rst

Templates (NUEVO v2.2.0):
TPL_[Tipo]_[Nombre]_[MAJOR]_[MINOR]_[PATCH].rst

Procedimientos (NUEVO v2.2.0):
PROC_[Nombre_Descriptivo]_[MAJOR]_[MINOR]_[PATCH].rst

Ejemplos:
- UC_AUTH_01_Iniciar_Sesion.rst
- FR_UCAUTH_01_01_Validar_Username.rst
- BR_016_Tasa_Abandono.rst
- STD_006_Versionado_Semantico.rst
- TPL_FR_Requisitos_Funcionales_1_0_0.rst
- PROC_Generacion_FR_1_0_0.rst
```

---

# 15. ORDEN DE EJECUCIÓN SIGUIENTE

## Fase Actual: GENERACIÓN FR 🔄

```
Completado:
├── FASE 1: MOD_Auth (21 FR) ✅
├── FASE 2: MOD_Users (17 FR) ✅
└── FASE 3: MOD_Access (17 FR parcial) 🔄

Siguiente:
├── FASE 3 (continuar): MOD_Access (~55 FR restantes)
├── FASE 4: MOD_Pipeline (~32 FR)
├── FASE 5: MOD_Reports (~112 FR)
├── FASE 6: MOD_Alerts (~40 FR)
├── FASE 7: MOD_Audit (~32 FR)
└── FASE 8: MOD_Logs (~32 FR)
```

## Fases Posteriores

1. **RTM (Matriz de Trazabilidad)**
   - RTM_Master_v2_0_0.rst
   - COV_001_Reporte_Cobertura.rst

2. **TST (Planes de Prueba)**
   - ~314 tests para 80% cobertura FR

---

# 16. ARCHIVOS DE REFERENCIA

| Archivo | Propósito | Ubicación |
|---------|-----------|-----------|
| MODELO_DOCUMENTAL_IACT_v2_2_0.md | Este documento | /docs/ |
| ANEXO_A_ARBOL_COMPLETO_v2_2_0.md | Árbol detallado | /docs/ |
| MODELO_DOCUMENTAL_IACT_v2_1_1.md | Versión anterior | /uploads/ |
| MODELO_RBAC_IACT_v5_1_1.md | Modelo de permisos | /uploads/ |
| DEFINICIONES_OFICIALES_v2_0_0.md | Definiciones base | /uploads/ |
| STD_006_Versionado_Semantico.rst | Estándar versionado | normativa/estandares/ |
| 38 PROC_*.rst | Procedimientos | normativa/procedimientos/ |
| 17 TPL_*.rst | Templates | normativa/estandares/plantillas/ |

---

# 17. PRINCIPIOS DE EVOLUCIÓN

1. **Compatibilidad hacia atrás**: Nuevas versiones no rompen estructura existente
2. **Versionado semántico**: MAJOR.MINOR.PATCH (ver STD_006)
3. **Trazabilidad total**: Todo cambio documentado en CHANGELOG
4. **Gobernanza**: PMO aprueba cambios estructurales
5. **Nomenclatura Clean Code**: Nombres descriptivos (UC_AUTH_01 vs UC_001)
6. **Ratio 1:8**: Cada UC genera aproximadamente 8 FR
7. **Procedimientos**: Revisar TPL antes de generar artefactos (lección aprendida v2.1.1)
8. **Anexos para detalle**: Información extensa va a anexos (lección aprendida v2.2.0)

---

*Modelo Documental IACT v2.2.0*  
*Proyecto: IACT Call Center Analytics Dashboard*  
*Fecha: 2026-01-07*  
*Estado: 🔄 En Progreso - Generación FR (55/~392 = 14%)*  
*Cambios principales: +11 TPL, +35 PROC, Árbol movido a ANEXO_A*
