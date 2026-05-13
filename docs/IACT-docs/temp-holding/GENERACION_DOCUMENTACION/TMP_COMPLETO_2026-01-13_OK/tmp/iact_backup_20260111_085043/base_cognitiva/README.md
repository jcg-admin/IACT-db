# BASE COGNITIVA IACT
## Integrated Analysis and Contextual Traceability

**Versión:** 2.0.0  
**Fecha Actualización:** 2026-01-09  
**Estado:** ACTUALIZADO - Nomenclatura NOM_001 v2.0.0 aplicada

---

## 📚 DESCRIPCIÓN

La Base Cognitiva IACT es el repositorio completo de conocimiento del proyecto **IACT - IVR Analytics & Customer Tracking**. Contiene:

- Material pedagógico completo (PARTES 0-6)
- Estándares y nomenclatura del proyecto
- Metamodelo de documentación
- Templates reutilizables
- Ejemplos y casos prácticos

---

## 📁 ESTRUCTURA DEL REPOSITORIO

```
source/base_cognitiva/
├── fundacionales/          # Estándares y Nomenclatura
│   ├── STD_001_Estandares_Documentacion_1_1_0.rst
│   └── NOM_001_Nomenclatura_Proyecto_2_0_0.rst
│
├── pedagogico/             # Material Pedagógico (PARTES 0-6)
│   ├── PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md
│   ├── PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md
│   ├── PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md
│   ├── PARTE_2B_Construccion_Detallada_IACT_1_0_0.md
│   ├── PARTE_2C_Casos_Especiales_Validacion_IACT_1_0_0.md
│   ├── PARTE_3A_Introduccion_CRUD_IACT_1_0_0.md
│   ├── PARTE_3B_Tecnica_Larman_IACT_1_0_0.md
│   ├── PARTE_3C_UI_Stakeholders_IACT_1_0_0.md
│   ├── PARTE_3D_Consolidacion_Resumen_IACT_1_0_0.md
│   ├── PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md
│   ├── PARTE_5_Trazabilidad_Gestion_IACT_1_0_0.md
│   └── PARTE_6_Casos_Practicos_Completos_IACT_1_0_0.md
│
├── originales/             # Base Cognitiva Legacy (FND, META, MTM)
│   ├── FND_01_Concepto_Requisito.rst
│   ├── FND_03_Casos_de_Uso.rst
│   ├── FND_04_Trazabilidad.rst
│   ├── META_01_Identidad_Proyecto.rst
│   ├── MTM_02_Metamodelo_Trazabilidad.rst
│   └── MODELO_*.md
│
├── templates/              # Templates Reutilizables (PENDIENTE FASE 13)
│   ├── TPL_BR_Decision_Tipo_1_0_0.rst
│   ├── TPL_UC_Construccion_7_Pasos_1_0_0.rst
│   └── TPL_FR_Documentacion_10_Componentes_1_0_0.rst
│
├── indices/                # Índices y Navegación (PENDIENTE FASE 14)
│   ├── INDICE_MAESTRO_DOCUMENTACION_IACT_1_0_0.md
│   └── MAPA_REFERENCIAS_CRUZADAS_IACT_1_0_0.md
│
└── ejemplos/               # Ejemplos Reales BR, UC, FR del Proyecto
    ├── BR_IACT_028_Aprobacion_Consultas_1_0_0.rst
    ├── UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst
    └── FR_RPT_01_07_Calcular_Count_1_0_0.rst
```

---

## 🚀 GUÍA DE USO

### Para Estudiantes

**Ruta de Aprendizaje Recomendada:**

1. **Fundacionales (2 horas)**
   - Lee `fundacionales/STD_001_Estandares_Documentacion_1_1_0.rst`
   - Lee `fundacionales/NOM_001_Nomenclatura_Proyecto_2_0_0.rst`

2. **Material Pedagógico (40 horas)**
   - PARTE 0: Contexto y Fundamentos (4h)
   - PARTE 1: Identificar Business Rules (6h)
   - PARTE 2A-C: Transformación BR → UC (12h)
   - PARTE 3A-D: Construcción de UC (8h)
   - PARTE 4: Requisitos Funcionales (6h)
   - PARTE 5: Trazabilidad (4h)
   - PARTE 6: Casos Prácticos Completos (20h)

3. **Práctica con Ejemplos**
   - Estudia ejemplos reales en `ejemplos/`
   - Replica usando templates de `templates/`

### Para Business Analysts

**Consulta Rápida:**

- **Identificar BR:** `pedagogico/PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md`
- **Construir UC:** `pedagogico/PARTE_2B_Construccion_Detallada_IACT_1_0_0.md`
- **Trazabilidad:** `pedagogico/PARTE_5_Trazabilidad_Gestion_IACT_1_0_0.md`
- **Templates:** `templates/TPL_BR_Decision_Tipo_1_0_0.rst`

### Para Desarrolladores

**Referencias Técnicas:**

- **FR Specification:** `pedagogico/PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md`
- **Trazabilidad:** `pedagogico/PARTE_5_Trazabilidad_Gestion_IACT_1_0_0.md`
- **Ejemplos de Código:** `pedagogico/PARTE_6_Casos_Practicos_Completos_IACT_1_0_0.md`

---

## 📊 ESTADÍSTICAS

| Categoría | Archivos | Tamaño | Líneas |
|-----------|----------|--------|--------|
| Fundacionales | 2 | 27KB | 1,277 |
| Pedagógico | 12 | 974KB | ~31,000 |
| Originales | 18 | 300KB | ~8,000 |
| Templates | 0 | - | - |
| Índices | 0 | - | - |
| Ejemplos | 0 | - | - |
| **TOTAL** | **32** | **~1.3MB** | **~40,000** |

---

## ✅ ESTADO DE COMPLETITUD

### COMPLETADO ✅

- [x] FASE 0: Infraestructura y Scripts
- [x] FASE 1: Fundacionales (STD_001, NOM_001)
- [x] FASE 2: PARTE_1 (Identificar BR)
- [x] FASES 3-9: PARTES 2A-3D (Transformación y Construcción)
- [x] FASE 10: PARTE_4 (Consolidada - FR)
- [x] FASE 11: PARTE_5 (Trazabilidad)
- [x] FASE 12: PARTE_6 (Casos Prácticos)

**Material Pedagógico COMPLETO:** PARTES 0-6 ✅

### PENDIENTE (Opcional) 🔄

- [ ] FASE 13: Templates (12 archivos RST)
  - TPL_BR_Decision_Tipo_1_0_0.rst
  - TPL_UC_* (7 variantes)
  - TPL_FR_* (3 variantes)
  - TPL_TRZ_Matriz_RTM_1_0_0.rst

- [ ] FASE 14: Índices Maestros (2 archivos)
  - INDICE_MAESTRO_DOCUMENTACION_IACT_1_0_0.md
  - MAPA_REFERENCIAS_CRUZADAS_IACT_1_0_0.md

- [ ] FASE 15: Ejemplos Reales (40+ archivos)
  - 45 BR del proyecto IACT
  - 22 UC completos
  - 156 FR con SQL

---

## 🔧 HERRAMIENTAS

### Scripts de Validación

Ubicación: `/tmp/iact_regeneracion/`

- `validar_nomenclatura.sh` - Valida nombres según NOM_001
- `validar_referencias.sh` - Detecta referencias rotas
- `referencias_maestro.txt` - Mapeo v1.0 → v2.0

### Generación de Documentos

```bash
# Generar matriz RTM
python scripts/generate_rtm.py

# Validar trazabilidad
python scripts/validate_traceability.py

# Generar índice maestro
python scripts/generate_index.py
```

---

## 📖 DOCUMENTACIÓN DE REFERENCIA

### Estándares del Proyecto

- **STD_001:** Estándares de Documentación v1.1.0
  - Reglas de formato (MD vs RST)
  - Prohibición de emojis
  - Metadatos obligatorios
  - Versionado semántico

- **NOM_001:** Nomenclatura del Proyecto v2.0.0
  - Formato: `[PREFIJO]_[Nombre]_[X]_[Y]_[Z].ext`
  - 15 prefijos válidos
  - Catálogo de 40 documentos
  - Ejemplos y casos especiales

### Metamodelo

Archivos en `originales/`:

- **FND_05:** Jerarquía 4 Niveles (BReq → BR → UC → FR)
- **MTM_02:** Metamodelo de Trazabilidad
- **FND_06:** Derivación vs Transformación

---

## 🎓 CERTIFICACIÓN

Al completar TODO el material pedagógico (PARTES 0-6), obtienes competencias en:

- ✓ Business Analysis Profesional
- ✓ Requirements Engineering
- ✓ Use Case Modeling
- ✓ Traceability Management
- ✓ Technical Documentation

Ver `pedagogico/PARTE_6_Casos_Practicos_Completos_IACT_1_0_0.md` sección 9 para certificado.

---

## 📞 CONTACTO Y CONTRIBUCIONES

**Proyecto:** IACT - Integrated Analysis and Contextual Traceability  
**Versión Base Cognitiva:** 2.0.0  
**Última Actualización:** 2026-01-09

**Historial de Cambios:**

- v2.0.0 (2026-01-09): Regeneración completa con nomenclatura NOM_001 v2.0.0
- v1.0.0 (2025-XX-XX): Versión inicial con nombres sin versionado

---

## 📜 LICENCIA

Material pedagógico interno del proyecto IACT.  
Clasificación: C2 - INTERNAL

---

**Para navegar el contenido, consulta:**
- `indices/INDICE_MAESTRO_DOCUMENTACION_IACT_1_0_0.md` (PENDIENTE FASE 14)
- `indices/MAPA_REFERENCIAS_CRUZADAS_IACT_1_0_0.md` (PENDIENTE FASE 14)

**Para empezar a aprender:**
1. Lee este README
2. Lee `fundacionales/STD_001_Estandares_Documentacion_1_1_0.rst`
3. Comienza con `pedagogico/PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md`

¡Bienvenido a la Base Cognitiva IACT!
