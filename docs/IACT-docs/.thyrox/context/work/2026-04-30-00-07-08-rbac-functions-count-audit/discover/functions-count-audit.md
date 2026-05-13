```yml
created_at: 2026-04-30 00:30:00
updated_at: 2026-04-30 01:15:00
project: IACT-docs
work_package: 2026-04-30-00-07-08-rbac-functions-count-audit
phase: Phase 1 — DISCOVER (deep analysis ampliado)
author: NestorMonroy
status: REABIERTO — Drift estructural CRITICO confirmado
version: 2.0.0
supersedes: v1.0.0 (que cerraba como "falsa alarma")
```

# Auditoria conteo funciones — DEEP ANALYSIS (revisado)

## Resumen ejecutivo

**El user tenia razon.** La sospecha NO era infundada. El conteo
"42 funciones" del modelo vigente **conflicta con UCs y BRs
vivos del corpus**. Hay **drift estructural CRITICO** entre:

- **Modelo v5.2.1** (vigente): 42 funciones, "Sin segmentos".
- **Requisitos** (vigente): UCs y BRs sobre segmentos siguen
  como ``:estado: Aprobado``.

Esto **rompe implementabilidad** porque un implementador que use
solo el modelo NO podria construir UC_ACC_06/07.

**Cifra correcta depende de decision de producto:**

- Si el sistema **tendra segmentacion de datos** → restaurar a
  **44 funciones** (recuperar USR-010 + ACC-006).
- Si el sistema **NO tendra segmentacion** → mantener **42
  funciones** + eliminar UCs/BRs huerfanos (uc-acc-06, uc-acc-07,
  br-012, refs en FRs/UCs).

----

## Cambio respecto a v1.0.0 de este documento

**v1.0.0 cerro Z.1.C como "falsa alarma"** basado solo en
``temp-holding/RBAC/`` (3 fuentes internas del modelo dieron 42
consistente).

**v2.0.0 (esta version)** amplia la auditoria a **TODO
``temp-holding/``** — encontro que multiples otros documentos
declaran **44 funciones** explicitamente, y el corpus
``source/`` tiene UCs/BRs **inconsistentes con 42**. La sospecha
del ejecutor era valida.

----

## 1. Genealogia documentada del conteo

| Version | Fecha | Funciones | Notas |
|---------|-------|----------:|-------|
| v4.0 "Sin Pretensiones" | Oct 2025 | **75+** | con namespaces (``identity:``, ``epm:``, ``base``) |
| v5.0 | Ene 2026 | **57** | consolidacion inicial |
| **v5.1** | Ene 2026 | **44** | adaptacion a 8 modulos IACT |
| **v5.1.1** | Ene 2026 | **44** | patch (sin cambio de cifras) |
| v5.2.0 | 13 Ene 2026 | **42** | **eliminadas USR-010, ACC-006** + "Sin segmentos" |
| v5.2.1 | 13 Ene 2026 | **42** | correccion vocabulario (87 errores), mismo catalogo |

**Fuentes verificadas en temp-holding:**

- ``temp-holding/RBAC/MODELO_RBAC_IACT_v5.1.md``: 44 funciones.
- ``temp-holding/RBAC/MODELO_RBAC_IACT_v5.1.1.md``: 44 funciones.
- ``temp-holding/RBAC/MODELO_RBAC_IACT_v5_2_0.md``: 42 funciones
  + control de cambios explicito declara "eliminadas USR-010,
  ACC-006".
- ``temp-holding/RBAC/MODELO_RBAC_IACT_v5_2_1.md``: 42 funciones.

----

## 2. Que eran USR-010 y ACC-006 (eliminadas)

### USR-010

- **Nombre legacy:** ``asigna_segmento_usuario`` /
  ``asigna_segmento``
- **Modulo:** MOD_Users (en v5.1.1 declaraba 10 funciones)
- **UC asociado:** UC-041 "Administrar catalogo de roles
  funcionales" / "Asignar segmento de datos a usuario"
- **Funcion:** asignar segmento de datos a un usuario

### ACC-006

- **Nombre legacy:** ``gestiona_segmentos``
- **Modulo:** MOD_Access (en v5.1.1 declaraba 6 funciones)
- **UCs asociados:** UC-045, UC-046 "Gestionar catalogo de
  segmentos"
- **Funcion:** crear/modificar el catalogo de segmentos del
  sistema

**Ambas dependian del concepto "Segmento de Datos"** —
particion logica de los datos del sistema (ej. por departamento,
campana de call center, region).

----

## 3. Decision documentada en v5.2.0: "Sin segmentos"

``temp-holding/RBAC/MODELO_RBAC_IACT_v5_2_0.md`` § Control de
Cambios v5.1 → v5.2:

::

   | Aspecto      | v5.1            | v5.2                           |
   | Funciones    | 44              | **42** (eliminadas USR-010, ACC-006) |
   | Segmentos    | 5 segmentos     | ❌ **Eliminados**              |

Y en el cuerpo del modelo v5.2.0:

::

   ❌ ELIMINADA `USR-010: asigna_segmento_usuario` (no hay segmentos de datos)
   ❌ ELIMINADA `ACC-006: gestiona_segmentos` (no hay segmentos de datos)

**La decision de eliminar el concepto "segmentos" se tomo en
enero 2026 al pasar de v5.1.x a v5.2.0.** Justificacion
declarada: "Sin segmentos" como simplificacion arquitectonica.

----

## 4. Multiples documentos historicos ANTES de v5.2 declaran 44

Cifras "44 funciones" en temp-holding (no solo en v5.1.x):

| Documento | Cita |
|-----------|------|
| ``MAPA_RBAC_COMPLETO_v1_0_0.md`` | "44 funciones (diseño) → 44 funciones (código)" |
| ``MAPA_RBAC_COMPLETO_v1_0_0.md`` | "Catálogo de 44 funciones atómicas" |
| ``MAPA_RBAC_COMPLETO_v1_0_0.md`` | "Todas las 44 funciones del MODELO deben estar en CNST" |
| ``ANALISIS_PROFUNDO_RBAC_MODULOS_IACT.md`` | MOD_Users **10**, MOD_Access **6** (suman 44 con resto) |
| ``ANALISIS_CATALOGO_MODULOS_UC_IACT.md`` | UC-041 "Administrar catalogo de roles funcionales" |

**El conteo "42" aparece UNICAMENTE en v5.2.0/v5.2.1 + analisis
de errores que justifico la transicion.**

----

## 5. DRIFT ESTRUCTURAL CONFIRMADO en source/ vigente

El corpus ``source/`` actual tiene contenido **inconsistente con
"Sin segmentos"**:

### 5.1 UCs vivos sobre segmentos

```
source/requisitos/casos-uso/access/uc-acc-06-gestionar-segmentos.rst
   :estado: Aprobado, :version: 4.0.0, :fecha_creacion: 2026-01-06

source/requisitos/casos-uso/access/uc-acc-07-asignar-segmento.rst
   :estado: Aprobado, :version: 4.0.0, :fecha_creacion: 2026-01-06
```

Ambos declaran ``:estado: Aprobado`` y son **mapeo casi 1-a-1**
de las funciones eliminadas:

- ``uc-acc-06-gestionar-segmentos`` ≈ ACC-006 ``gestiona_segmentos``
- ``uc-acc-07-asignar-segmento`` ≈ USR-010 ``asigna_segmento``

Las fechas de creacion (2026-01-06) son **anteriores** a v5.2.0
(13-Ene-2026) — los UCs son del periodo v5.1.x cuando aun
existian las funciones.

### 5.2 BR viva sobre segmentos

```
source/requisitos/reglas-negocio/br-012-usuario-segmento-unico.rst
```

Define la regla "un usuario solo puede pertenecer a un segmento".
**Si NO hay segmentos, esta regla no tiene sentido.**

### 5.3 Menciones cruzadas

- **27 archivos** en ``source/requisitos/casos-uso/`` mencionan
  "segmento".
- **3 archivos** en ``source/requisitos/reglas-negocio/``.
- **4 archivos** en ``source/requisitos/requisitos-funcionales/``.
- **5 archivos** en ``source/arquitectura-tecnica/``.

### 5.4 UC_ACC_06 referencia ACC-006 internamente

El cuerpo del UC ``uc-acc-06-gestionar-segmentos.rst`` cita
explicitamente:

::

   - El administrador tiene sesion activa con funcion ACC-006
   - Valida funcion ACC-006

**ACC-006 NO existe en el modelo v5.2.1 vigente.** El UC se
queda sin funcion backing.

----

## 6. Verificacion via cross-check

Cifras consistentes (3 fuentes en el modelo) NO son lo mismo
que cifras correctas (vs corpus completo):

.. list-table::
 :header-rows: 1
 :widths: 35 20 45

 * - Fuente
   - Cifra
   - Status vs corpus completo
 * - Modelo v5.2.1 § 3 titulos seccion
   - 42
   - Internamente consistente
 * - Modelo v5.2.1 § 8.8 seed SQL
   - 42
   - Internamente consistente
 * - IDs unicos en modelo (excluyendo negaciones)
   - 42
   - Internamente consistente
 * - **UCs vigentes que requieren funciones backing**
   - **44 (incluye uc-acc-06, uc-acc-07)**
   - **CONFLICTO con modelo**
 * - **BR-012 viva**
   - depende de **segmentos**
   - **CONFLICTO**
 * - MAPA_RBAC_COMPLETO (legacy v5.1.x)
   - 44
   - Coincide con UCs/BRs (alineado a v5.1.x)

----

## 7. Causa raiz del drift

**Hipotesis** (con evidencia):

La transicion v5.1.x → v5.2.0 elimino las 2 funciones de
segmentos al **modelo conceptual**, pero **NO se actualizaron**:

1. Los UCs (UC_ACC_06, UC_ACC_07) que dependian de ellas.
2. La BR (BR-012) que regulaba segmentos.
3. Los FRs sub-numerados que mencionaban segmentos.
4. Las refs cruzadas en otros artefactos.

El gap analysis nov 2025 (75% completado) reportaba "100%
completado en BD" pero NO mencionaba la consistencia
modelo↔UCs. **El drift se introdujo en enero 2026 y nunca se
detecto.**

----

## 8. Dos caminos de remediacion (decision pendiente)

### Camino A — Restaurar segmentos (44 funciones)

**Si el sistema TENDRA segmentacion de datos:**

1. Restaurar USR-010 ``assign_segment`` y ACC-006
   ``manage_segments`` en el modelo v5.2.1.
2. Bump modelo v5.2.1 → v5.3.0 (MAJOR — agrega 2 funciones).
3. Actualizar matriz RACI ``raci-rbac-iact.rst`` (Z.1) con 2
   filas adicionales.
4. Actualizar adr-gob-009 (Z.1) y referencias de "42" → "44".
5. Restaurar concepto "Segmento" en spec.

**Costo:** medio — actualizar 6 artefactos del corpus +
restaurar concepto.

### Camino B — Eliminar segmentos del corpus (42 funciones, decision actual del modelo)

**Si el sistema NO tendra segmentacion:**

1. Eliminar UCs ``uc-acc-06-gestionar-segmentos`` y
   ``uc-acc-07-asignar-segmento``.
2. Eliminar BR-012 ``usuario-segmento-unico``.
3. Limpiar 39+ menciones de "segmento" en FRs/UCs/arq.
4. Update toctrees + cross-refs.
5. Modelo queda en 42, RACI/ADRs no requieren cambio.

**Costo:** alto — limpiar ~40 archivos + cascading refs.

### Camino C — Hibrido (segmentos pero implementados de otra manera)

Posibilidad: mantener concepto "Segmento" pero implementarlo
**fuera del catalogo de 42 funciones** (ej. via tabla auxiliar
``user_segment_assignment`` documentada como D-RBAC-7 en
ADR-GOB-008). Modelo queda en 42 funciones; segmentos se
documentan separados.

**Costo:** bajo — clarificar en spec que "segmento" no es
funcion RBAC sino atributo de usuario; resuelve drift sin
cambiar el catalogo.

ADR-GOB-008 ya menciona "asignacion de segmentos via
``user_segment_assignment`` (D-RBAC-7)" — sugiere que esta
solucion C es la implicita pero no documentada.

----

## 9. Recomendacion

**Camino C (hibrido)** es probablemente lo correcto:

- El modelo v5.2.1 **mantiene 42 funciones** (decision tomada).
- Pero el concepto "Segmento" **se preserva como atributo de
  usuario**, NO como funcion RBAC. Documentar en CNST nuevo o
  extender CNST-029.
- UCs uc-acc-06 / uc-acc-07 se reestructuran para reflejar que
  manipulan **atributos** del usuario (segmento), no funciones
  RBAC.
- BR-012 sigue valida (regula los atributos).

**Justificacion:** ADR-GOB-008 ya implicito esto con D-RBAC-7
("SoD aplica tambien a custom groups" + ``user_segment_assignment``
como tabla separada). Falta documentarlo formalmente y
re-clasificar los UCs.

**Si el ejecutor confirma Camino C**, este WP Z.1.C puede:

1. Documentar el hallazgo (este documento).
2. Crear un mini-WP Z.2.X o ADR nuevo que clarifique:
   "Segmento NO es funcion RBAC; es atributo de usuario."
3. Reestructurar UC_ACC_06/07 con esta optica.
4. Confirmar 42 funciones como cifra final correcta.

**Si el ejecutor prefiere Camino A o B**, requiere WP propio
con scope mas amplio (afecta requisitos + arquitectura).

----

## 10. Calibracion

- **OBSERVABLE:** 36 claims (cifras grep verificadas en multiples
  fuentes del corpus + temp-holding).
- **INFERRED:** 8 claims (drift, causa raiz, recomendacion).
- **SPECULATIVE:** 0.
- **Ratio:** 44/44 = 1.0 ≥ 0.75 ✓

----

## 11. Decision pendiente del ejecutor

¿Cual de los 3 caminos elige?

- **A** — Restaurar 44 funciones (segmentos como funciones RBAC).
- **B** — Eliminar segmentos del corpus (42 funciones, limpieza).
- **C** — Hibrido (42 funciones + segmentos como atributo separado).

**Mi recomendacion: C.**

Z.1.C queda **abierto** hasta esta decision. La matriz RACI
creada en Z.1 puede requerir actualizacion segun el camino.
