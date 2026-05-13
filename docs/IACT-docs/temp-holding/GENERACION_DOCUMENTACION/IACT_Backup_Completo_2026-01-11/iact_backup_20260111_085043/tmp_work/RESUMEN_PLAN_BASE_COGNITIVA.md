# RESUMEN: PLAN MAESTRO BASE_COGNITIVA/ v3.0.0 FINAL

**Documento:** 50+ páginas, 25,000+ palabras  
**Fecha:** 2026-01-08  
**Estado:** Listo para ejecución

---

## ALCANCE

Reescribir 23 archivos de base_cognitiva/ reemplazando ejemplos de "químicos" con ejemplos del proyecto IACT real (49 UC generados, 23,401 líneas).

---

## NOMENCLATURA OFICIAL

### Casos de Uso (sin versionado en archivo)
```
UC_ALR_01_Configurar_Umbrales.rst
UC_RPT_01_Ver_Dashboard.rst
UC_PIP_01_Supervisar_ETL.rst
```

### Business Rules (20 BR)
```
BR_001, BR_002, ..., BR_020
```

### Restricciones (guión bajo)
```
CNST_001, CNST_003, CNST_004, CNST_007, CNST_009
```

### Agrupadores (guión bajo)
```
AGR_001, AGR_005, AGR_007
```

### Archivos base_cognitiva/ (sin versionado)
```
FND_00_Contexto_y_Jerarquia.rst
FND_03_Taxonomia_BR.rst
MTM_01_BR_a_UC_Trazabilidad.rst
TXM_01_Nomenclatura_UC_FR.rst
```

---

## TABLA DE SUSTITUCIÓN

| Químicos (ELIMINAR) | IACT Real (USAR) | Tipo |
|---------------------|------------------|------|
| UC-07 "Notificar Vencimiento" | UC_ALR_01 "Configurar Umbrales" | UC |
| BR-031 "Notificar 30d" | BR_014 "Alerta por Umbral" | BR |
| UC-04 "Solicitar Químico" | UC_RPT_01 "Ver Dashboard" | UC |
| BR-028 "Aprobación >$500" | BR_011 "Límites Exportación" | BR |
| BR-087 "Certificación OSHA" | BR_007 "Separación Funciones SoD" | BR |
| BR-060 "Descuento volumen" | BR_016 "Tasa Abandono" | BR |
| "Coordinador Seguridad" | AGR_007 (supervisor) | Actor |
| "Propietario" | AGR_005 (analista) | Actor |

---

## PLAN DE 8 FASES

| Fase | Descripción | Archivos | Horas |
|------|-------------|----------|-------|
| 0 | Preparación e inventario | 1 | 1-2h |
| 1 | PARTE 0 (Introducción) | 1 | 3-4h |
| 2 | PARTE 1 (Identificar BR) | 4 | 10-14h |
| 3 | PARTE 2 - UC_ALR_01 | 1 | 6-8h |
| 4 | PARTE 2 - UC_RPT_01 | 1 | 5-6h |
| 5 | PARTE 2 - Otros ejemplos | 3 | 8-12h |
| 6 | Actualización referencias | 16 | 3-4h |
| 7 | Validación final | - | 2h |
| **TOTAL** | **8 Fases** | **27** | **38-52h** |

---

## ARCHIVOS CRÍTICOS (Prioridad 1)

1. **FND_03_Taxonomia_BR.rst** (1500 líneas)
   - Reescribir 5 tipos de BR con ejemplos IACT
   - BR_014 como ejemplo de Desencadenador

2. **TXM_01_Nomenclatura_UC_FR.rst** (2000 líneas)
   - Reescribir UC_ALR_01 completo (200+ líneas)
   - Flujo normal, alternos, diagramas, FR derivados

3. **MTM_01_BR_a_UC_Trazabilidad.rst** (1000 líneas)
   - Matriz completa 20 BR → 49 UC

4. **TXM_04_Proceso_Construccion.rst** (2500 líneas)
   - Construcción paso a paso UC_RPT_01

5. **TXM_03_Patrones_Transformacion.rst** (3000 líneas)
   - 5 patrones con ejemplos IACT

---

## METODOLOGÍA

### Staging con /tmp

```bash
# Crear archivo completo en /tmp
cat > /tmp/FND_03_Taxonomia_BR.rst << 'ENDOFFILE'
[... contenido completo sin límites ...]
ENDOFFILE

# Validar
wc -l /tmp/FND_03_*.rst
grep -n "BR_014" /tmp/FND_03_*.rst

# Copiar a destino
cp /tmp/FND_03_*.rst /mnt/user-data/outputs/base_cognitiva/
```

### Principios

1. Un archivo a la vez
2. Validación después de cada fase crítica
3. Solo ejemplos del proyecto IACT real
4. Coherencia total con 49 UC generados

---

## EJEMPLOS DETALLADOS EN EL PLAN

### UC_ALR_01 (Ejemplo principal)

**Contenido en TXM_01 (200+ líneas):**
- Análisis del desencadenador BR_014
- Flujo normal 10 pasos
- 5 flujos alternos
- Diagrama de secuencia PlantUML
- Derivación de 5 FR con código Python
- Trazabilidad completa (BR, CNST, AGR)

### BR_014 (Ejemplo de Desencadenador)

**Contenido en FND_03:**
- Definición formal
- Patrón SI-ENTONCES
- Métricas monitoreables (BR_016, BR_017, BR_018)
- Flujo del job automático
- Implementación técnica (código Python)
- Diferencia con Restricción
- Diagramas comparativos

---

## CHECKLIST VALIDACIÓN FINAL

```
COHERENCIA:
[ ] 30+ referencias a UC_ALR_01
[ ] 20+ referencias a BR_014
[ ] 50+ referencias a CNST_001 (guión bajo)
[ ] 20+ referencias a AGR_007 (guión bajo)
[ ] 0 referencias a UC-07, BR-028, BR-031
[ ] 0 menciones a "químico", "contenedor"

NOMENCLATURA:
[ ] FND/MTM/TXM sin versionado en archivo
[ ] UC con formato UC_ALR_01 (sin _4_0_0)
[ ] CNST con guión bajo (CNST_001)
[ ] AGR con guión bajo (AGR_007)

COMPILACIÓN:
[ ] make html exitoso
[ ] 0 errores Sphinx
[ ] Diagramas renderizan
```

---

## ENTREGABLES FINALES

1. 23 archivos reescritos/actualizados
2. ~26,400 líneas RST
3. Ejemplos del proyecto IACT real:
   - 49 UC (23,401 líneas)
   - 20 BR
   - 10 AGR
   - 10 CNST
4. Documentación pedagógica completa y coherente

---

## PRÓXIMO PASO

**FASE 0: Preparación (1-2h)**

Crear inventario completo:
- EJEMPLOS_REALES_IACT_COMPLETO.md
- Validar 49 UC generados
- Listar 20 BR, 10 AGR, 10 CNST

**¿Proceder?**

