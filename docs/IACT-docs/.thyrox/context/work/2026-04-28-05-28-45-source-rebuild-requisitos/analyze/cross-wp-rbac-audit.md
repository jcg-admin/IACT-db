```yml
created_at: 2026-04-29 03:30:00
project: IACT-docs
work_package: 2026-04-28-05-28-45-source-rebuild-requisitos
phase: Phase 1 — DISCOVER (auditoria cross-WP RBAC)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Auditoria cross-WP del RBAC en source/ actual

## Pregunta del ejecutor

¿`MODELO_RBAC_IACT_v5_2_1.md` esta en source? ¿Como se esta definiendo
ahi? ¿Los otros archivos referenciados ya no tienen problemas?

## Respuesta corta

**NO**, `MODELO_RBAC_IACT_v5_2_1.md` no esta en source. Solo esta en
`temp-holding/RBAC/` y en `inputs/canonical/` del WP arquitectura-
tecnica (#7) pendiente. **Y SI hay problemas** en archivos cerrados
que requieren re-iteracion (v3) cuando se cierre la formalizacion.

## Inventario de archivos RBAC en source/ actual

| Archivo | WP origen | Estado | Problemas detectados |
|---------|-----------|--------|----------------------|
| `source/normativa/restricciones/CNST_029_RBAC_Modelo_Plano.rst` | WP #4 restricciones (cerrado v2) | Vigente | (ver §2) |
| `source/base_cognitiva/_taxonomias_y_metamodelos/metamodelos/MTM_03_Metamodelo_RBAC.rst` | WP #1 base_cognitiva (cerrado v2) | Vigente | (ver §3) — **DRIFT CRITICO** |
| `source/normativa/restricciones/CNST_030_Reglas_de_Separacion_de_Funciones_SoD.rst` | WP #4 | Vigente | (ver §2) |
| `source/normativa/restricciones/CNST_031_Permisos_Temporales_Maximo_6_Meses.rst` | WP #4 | Vigente | (ver §2) |

**No hay** `MODELO_RBAC_IACT_v5_2_1.md` en source/. Tampoco hay
catalogo de las 42 funciones, ni los 10 grupos, ni las 3 reglas SoD
en formato canonico de source. Estan **referenciados pero no
migrados**.

## §2. Problemas en CNST_029, CNST_030, CNST_031

### CNST_029 RBAC Modelo Plano

**Lo que dice (citado):**
> "Unidad atomica: funcion (action sobre un recurso, ej.
> ``alertas.crear``). Grupo: conjunto de funciones agrupadas por
> rol de negocio. Asignacion: usuario en N grupos, no roles directos
> sobre usuario."

**Problemas detectados:**

| # | Problema | Severidad |
|---|----------|-----------|
| P-1 | Origen "MODELO_RBAC_IACT_v5_2_1.md" referenciado pero NO migrado a source/ | Medio (link roto conceptual) |
| P-2 | NO declara vocabulario unificado "Funcion" vs "Capacidad" del sistema PERM | Alto |
| P-3 | NO menciona los 10 grupos predefinidos AGR-001..010 | Medio |
| P-4 | NO menciona la diferencia "system groups" (inmutables) vs "custom groups" (creables — D-RBAC-4 aprobada) | Alto |
| P-5 | NO referencia `obtener_menu_usuario()` ni el menu dinamico (CNST nuevo a crear D-RBAC-5) | Alto |
| P-6 | NO referencia las tablas backend (function_groups, GrupoPermiso, etc.) | Medio |

### CNST_030 Reglas SoD Atomicas

**Problemas detectados:**

| # | Problema | Severidad |
|---|----------|-----------|
| P-7 | NO declara las 3 reglas SoD especificas (SOD-001 pipeline_audit, SOD-002 user_audit, SOD-003 access_audit) | Alto |
| P-8 | NO declara que SoD aplica TAMBIEN a grupos custom creados via UC_PERM_05 (D-RBAC-7 aprobada) | Alto |

### CNST_031 Permisos Temporales

**Problemas detectados:**

| # | Problema | Severidad |
|---|----------|-----------|
| P-9 | OK en general — declara 6 meses + justif >=20 ch + revocacion automatica | (sin problemas mayores) |
| P-10 | NO declara mapeo entre `UC_ACC_08 Permiso Temporal` (vista funcional) y `UC_PERM_03 Conceder Permiso Excepcional` (vista tecnica) | Bajo |

## §3. Problema CRITICO en MTM_03 Metamodelo RBAC

**Cita literal de MTM_03:**
> "CATALOGO CERRADO (18 roles)"

**Esto contradice el modelo v5.2.1 vigente:**

| Concepto | MTM_03 (legacy v4.0) | MODELO_RBAC_IACT_v5_2_1 (vigente) |
|----------|----------------------|----------------------------------|
| Catalogo cerrado | **18 roles** | **42 funciones + 10 grupos** |
| Filosofia | Roles basados en cargos/jerarquia | "Sin Pretensiones" — funciones describen accion |
| Vocabulario | "Roles" | "Funciones" + "Grupos" |

**Severidad: CRITICA.** MTM_03 declara un catalogo de 18 roles que ya
NO es el modelo del proyecto. La v5.0 abandono "roles" en favor de
"funciones". MTM_03 no se actualizo en la iteracion v2 (que solo
arreglo refs CNST_007 → CNST_020 etc.).

**Linea exacta del problema:** ~684 (sub-seccion sobre catalogo
cerrado de roles en `MTM_03_Metamodelo_RBAC.rst`).

## §4. Acciones requeridas (cross-WP)

### Para WP #1 base_cognitiva (cerrado v2 — requiere v3)

| Accion | Archivo |
|--------|---------|
| Reescribir seccion "CATALOGO CERRADO (18 roles)" → "CATALOGO de 42 funciones + 10 grupos" | MTM_03 ~L680-720 |
| Agregar vocabulario unificado al `glosario.rst` (10 terminos canonicos del rbac-formalization §2) | glosario.rst |
| Actualizar refs a `Capacidad` (PERM) → `Funcion` (canonico — D-RBAC-1 aprobada) | cualquiera con esta ref |

### Para WP #4 restricciones (cerrado v2 — requiere v3)

| Accion | Archivo |
|--------|---------|
| Enriquecer CNST_029 con: vocabulario unificado, mencion de los 10 grupos AGR-001..010, distincion system vs custom groups | CNST_029 |
| Enriquecer CNST_030 con: las 3 reglas SoD especificas (SOD-001/002/003 con grupo A y grupo B), aplicabilidad a custom groups | CNST_030 |
| Crear **CNST-NEW-1** (Menu Dinamico Obligatorio) — D-RBAC-5 aprobada | nuevo archivo |
| Crear **CNST-NEW-2** (Vocabulario Unificado RBAC) — D-RBAC-6 aprobada | nuevo archivo |

### Para WP #5 gobernanza (cerrado — requiere v2)

| Accion | Archivo |
|--------|---------|
| Crear **ADR-GOB-008** "RBAC Coexistencia Vista Funcional ↔ Vista Tecnica" | nuevo archivo |

### Para WP #7 arquitectura-tecnica (pendiente, no abierto aun)

| Accion | Archivo |
|--------|---------|
| Migrar MODELO_RBAC_IACT_v5_2_1.md a source/arquitectura_tecnica/rbac/ | (re-autoria con v1.0.0 fresh per Decision 10) |
| Crear catalogo de las 42 funciones | source/arquitectura_tecnica/rbac/Catalogo_Funciones.rst |
| Crear catalogo de los 10 grupos predefinidos | Grupos_Predefinidos.rst |
| Crear modelo de datos (7+4 tablas) | Modelo_Datos.rst |

### Para WP #6 requisitos (este — en curso)

| Accion | Archivo |
|--------|---------|
| Generar UCs MOD_Access (9) y MOD_Permissions (10) | source/requisitos/casos_uso/{access,permissions}/ |

## §5. Convencion ingles/español aplicada

Tras feedback del ejecutor, se confirma la convencion del
`MODELO_RBAC_IACT_v5_2_1.md` § "ESTANDAR DE NOMENCLATURA":

| Tipo de elemento | Idioma | Ejemplo |
|------------------|--------|---------|
| Modelos Django (clases) | Ingles | `class Function`, `class FunctionGroup`, `class UserGroupAssignment` |
| Funciones backend (metodos, funciones SQL) | Ingles | `def has_permission()`, `obtain_user_menu()` |
| Variables en codigo | Ingles | `user_id`, `function_groups`, `expires_at` |
| Codigo de funcion (capability code) | Ingles | `manage_sessions`, `view_reports`, `export_csv` |
| Nombres de grupos | Ingles | `basic_operator_group`, `auditor_group` |
| Nombres de reglas SoD | Ingles | `pipeline_audit_separation` |
| **Comentarios codigo** | Espanol | `"""Grupo de funciones que se asignan juntas."""` |
| **Docstrings/help_text** | Espanol | `help_text="Identificador unico (AGR-001)"` |
| **Documentacion (.rst, .md)** | Espanol | "El sistema IACT permite..." |
| **Metadata fields** (artefacto, dominio) | Espanol | `:tipo: Restriccion` |

**Aplicacion al rbac-formalization.md:** el documento esta correcto
en espanol como documentacion. Cuando llegue Phase 2 EXECUTE para
generar codigo backend, los nombres de modelos seran en ingles.

**Aplicacion al vocabulario unificado §2 del rbac-formalization:** el
termino canonico **`Funcion`** (en docs/comentarios espanol) se
materializa como **`Function`** (clase Django, en codigo ingles). NO
es contradiccion — es la convencion del proyecto.

## §6. Resumen de impacto cross-WP

| WP | Estado actual | Acciones requeridas | Iteracion necesaria |
|----|---------------|---------------------|---------------------|
| #1 base_cognitiva | cerrado v2 | MTM_03 drift critico (18 roles → 42 funciones) + glosario unificado | **v3** |
| #4 restricciones | cerrado v2 | CNST_029/030 enriquecer + 2 CNSTs nuevos (Menu Dinamico, Vocabulario) | **v3** |
| #5 gobernanza | cerrado | ADR-GOB-008 (coexistencia ACC↔PERM) | **v2** |
| #6 requisitos | en curso (este) | Generar UCs ACC + PERM en Phase 2 | **v1 final** |
| #7 arquitectura-tecnica | pendiente abrir | Migrar MODELO_RBAC + 4 docs nuevos | **v1** |

**Total iteraciones cross-WP requeridas:** 3 WPs cerrados requieren
nueva iteracion (#1 v3, #4 v3, #5 v2). El WP #7 cuando se abra
recibira la responsabilidad de migrar el MODELO_RBAC.

## §7. Recomendacion al ejecutor

**Opcion A (formalizacion en cascada, recomendada):**

1. **AHORA** (Phase 2 del WP #6): generar UCs ACC + PERM en source.
2. Cierre WP #6.
3. Re-abrir WP #4 (v3): enriquecer CNST_029/030 + crear 2 CNSTs nuevos.
4. Re-abrir WP #1 (v3): arreglar MTM_03 drift + glosario unificado.
5. Re-abrir WP #5 (v2): crear ADR-GOB-008.
6. Abrir WP #7 (v1): MODELO_RBAC + catalogo funciones + grupos +
   modelo de datos.

**Opcion B (formalizacion paralela en este WP):**

Resolver TODOS los problemas dentro del WP #6 actual (genera UCs +
arregla MTM_03 + enriquece CNSTs + crea ADR + migra MODELO_RBAC).
Mucha carga concentrada, sale del scope original del WP #6.

**Recomendacion: Opcion A** — preserva foco del WP, aplica
remediation en cascada per cada WP correspondiente.
