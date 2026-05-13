```yml
created_at: 2026-05-01 03:29:03
project: IACT-docs
work_package: 2026-05-01-03-29-03-uc-corrections-against-canonical-model
phase: Phase 11 — TRACK/EVALUATE
author: NestorMonroy
status: Aprobado
version: 1.0.0
language: es
```

# Lessons Learned — Corrección sistemática de los 61 UCs

Cierre del WP. El scope era *"correr todos los UCs
contra el modelo canónico, decisiones autónomas,
loop hasta que estén corregidos"* — declarado por
el ejecutor el 2026-05-01.

## Resultado

**61 / 61 UCs corregidos** contra
``modelo-dominio-iact.rst`` v1.0.0 y
``modelo-rbac-iact.rst`` v5.4.0. Build incremental
0/0/0 al cierre.

Sweep final automatizado:

- 0 menciones residuales a ``Segmento`` /
  ``segmento`` / ``SegmentoDatos``.
- 0 referencias colgantes a UCs eliminados
  (UC_ACC_06, UC_ACC_07, BR-012).
- 0 UCs sin fila ``Clase de Dominio`` en su
  Trazabilidad.

## Defectos resueltos por categoría

| Código | Tipo | UCs afectados | Resueltos |
|--------|------|--------------:|:---------:|
| D-01 | Función RBAC obsoleta (inglés viejo) | 2 | 2 |
| D-02 | Función RBAC obsoleta (español pre-Z.1.C) | ~12 | todos |
| D-03 | Mención al concepto eliminado ``Segmento`` | 22 | 22 |
| D-04 | Referencia a archivo eliminado | 1 | 1 |
| D-05 | Campo "UC Relacionados" vacío | 15 | 15 |
| D-06 | Constraint en versión obsoleta | 3 | 3 |
| D-07 | Sin cita a clase canónica | 61 | 61 |

## Decisiones tomadas (DEC-01..DEC-08)

### DEC-01 — Política de "vacío + AGR" para Segmento

El concepto ``Segmento`` quedó descartado por
Z.1.C Camino C. Donde el corpus citaba "filtro
por segmento del usuario" como semántica
operativa, se reemplazó por "filtro por
agrupador (AGR)" — la combinación AGR + MOD +
Función cubre la separación funcional sin
necesidad del atributo segmento. Donde la
mención era solo histórica, se eliminó.

### DEC-02 — Renombrado de funciones a inglés
canónico v5.4.0

Todas las citas a funciones RBAC con nombres
viejos se actualizaron al canónico vigente:

- ``manage_sessions`` → ``view_own_sessions``
- ``view_active_sessions`` → ``view_all_active_sessions``
- ``delete_users`` → ``deactivate_users``
- ``crea_usuarios`` → ``create_users``
- ``asigna_funciones`` → ``assign_functions``
- ``revoca_funciones`` → ``revoke_functions``
- ``ve_asignaciones`` → ``view_assignments``
- ``asigna_agrupadores`` → ``assign_function_groups``
- ``gestiona_sod`` → ``view_separation_rules``
- ``ve_estado_etl`` → ``view_etl_executions``
- ``ve_errores_etl`` → ``view_etl_errors``
- ``ve_disponibilidad_datos`` → ``check_availability``
- ``solicita_reintento_etl`` → ``request_retry``
- ``consulta_auditoria`` → ``view_audit_log``
- ``busca_auditoria`` → ``search_audit_log``
- ``exporta_auditoria`` → ``export_audit_log``
- ``genera_compliance`` → ``generate_compliance_report``
- ``consulta_logs_sistema`` → ``view_application_logs``
- ``ve_reportes`` → ``view_reports``

### DEC-03 — Patrón uniforme para "Clase de
Dominio"

Se introdujo una fila estándar
``* - **Clase de Dominio**`` en la sección
Trazabilidad de cada UC (excepto PERM, que tiene
estructura distinta y recibió subsecciones
``Vista`` / ``Clase de Dominio`` / ``Funcion RBAC
Backing``). Cada UC cita su clase primaria y las
secundarias relevantes per ``modelo-dominio-iact``
v1.0.0.

### DEC-04 — Reemplazo de UC_ACC_07 en USR_01

El único UC con referencia colgante (uc-usr-01
citaba UC_ACC_07 "Asignar Segmento" inexistente)
se actualizó a UC_ACC_04 "Asignar Agrupador" —
la funcionalidad equivalente vigente.

### DEC-05 — Constraints en versiones vigentes

Las citas a CNST-019, CNST-020, BR-009, BR-011 se
actualizaron a las versiones vigentes
(v3.0.0, v3.0.0, v2.0.0, v2.0.0 respectivamente)
allí donde aparecían con versiones obsoletas o
sin versión.

### DEC-06 — PERM como vista técnica del RBAC

Los 10 UCs PERM no exponen "Actor Principal" en
su meta y tienen estructura no-estándar. Se
documentó esto explícitamente en cada UC PERM
con una subsección ``Vista`` que cita Z.2.A
Cat 5 + ADR-GOB-008 (coexistencia ACC↔PERM). El
reemplazo del campo "UC Relacionados" se hizo
mediante UC Relacionados a otros UCs PERM y/o
ACC equivalentes según la operación.

### DEC-07 — Build incremental por cluster

Cada cluster (AUTH, USR, ACC, PERM, RPT, ALR,
PIP, AUD, LOG) se commiteó por separado tras
verificar build incremental 0/0/0. Esto permitió
detectar errores estructurales en el momento de
producirlos, sin acumular deuda.

### DEC-08 — Mantener BR-USR-04 con semántica
nueva

BR-USR-04 (era "Segmento Obligatorio") en
uc-usr-01 se preservó pero con semántica nueva:
"Agrupador Inicial Opcional" — registra que el
usuario puede crearse con o sin agrupador, y que
el agrupador puede asignarse después vía
UC_ACC_04. Se evitó renumerar BRs para preservar
trazabilidad downstream.

## Lo que funcionó bien

### LF-01 — Auditoría estructurada antes de actuar

``discover/uc-audit-matrix.md`` mapeó los 7
tipos de defecto a los 61 UCs en una matriz
visual. Permitió priorizar por cluster y verificar
exhaustividad al cierre.

### LF-02 — Sed bulk + Edit surgical

Para defectos repetitivos (renames de funciones,
sustituciones de "segmento" por "agrupador (AGR)")
se usó ``sed`` por cluster. Para inserciones
estructurales (filas Clase de Dominio,
subsecciones PERM) se usó ``Edit`` con contexto.
La combinación rinde 5–10× más que solo Edit
surgical.

### LF-03 — Build 0/0/0 como gate por cluster

Cada cluster verificó build incremental antes de
commitear. Cero clusters introdujeron warnings.
La política "make clean solo en cambios de
estructura" demostró ser suficiente — todos los
builds incrementales detectaron correctamente.

### LF-04 — Importar decisiones del programa Z

El WP usó las 11 decisiones D-01..D-11 + las 5
categorías de Z.2.A como guía operativa.
Aplicar lo ya decidido (no re-decidir) ahorró
tiempo y mantuvo coherencia con el corpus
existente.

## Lo que se debe evitar en futuros WPs

### LE-01 — Sed con patrones no específicos

En la primera iteración sobre RPT, un sed que
buscaba "segmento del usuario" no capturó
variantes como "segmento del segmento" o
"segmento (CNST_008)". Se necesitaron 2-3
iteraciones para cazar todos los casos.
Recomendación: el primer pase de sed debe ser
seguido por ``grep -c`` para verificar que el
patrón cubrió todos los casos.

### LE-02 — Estructura no uniforme entre clusters

Los UCs PERM tienen estructura distinta a
AUTH/USR/ACC/RPT/ALR/PIP/AUD/LOG. Adicionalmente,
uc-rpt-15/16/17 y uc-log-05/06/07 (UCs nuevos de
Z.2) tienen secciones numeradas hasta 9, no 14.
Cada variante requirió leer el final del archivo
antes de aplicar la edición. Recomendación:
estandarizar la estructura en un WP futuro o
tolerarla explícitamente.

### LE-03 — Renumeración silenciosa al eliminar
sub-secciones

Al eliminar EX-03 "Segmento No Valido" en
uc-usr-01, la sub-sección 8.4 quedó como 8.3 sin
actualizar referencias internas. Para este WP
funcionó (no había referencias cruzadas), pero
en general renombrar sub-secciones requiere
buscar referencias entrantes.

## Métricas finales

| Métrica | Valor |
|---------|-------|
| Stages ejecutados | 4 (1, 3, 10 cíclico, 11) |
| Análisis registrados | 1 (audit-matrix) |
| UCs corregidos | 61 / 61 (100 %) |
| Clusters procesados | 9 / 9 |
| Commits del WP | 11 (audit + 9 clusters + cierre) |
| Defectos resueltos | 7 categorías × 61 UCs |
| Build incremental status | 0 warnings, 0 errors |
| Tiempo aproximado | 1 sesión continua |

## Trazabilidad

- WP predecesor (modelo canónico):
  ``2026-05-01-02-01-06-domain-model-canonization``.
- WP previo (relaciones UC, hipotético):
  ``2026-04-30-22-45-55-rm-uc-relationships-analysis``
  (sigue abierto; ahora puede retomarse sobre
  base validada).
- Programa Z padre:
  ``2026-04-29-17-52-15-modelo-rbac-improvement``
  (Z.1.C, Z.2, Z.2.A cerrados).

## Cierre

WP cerrado por orden del ejecutor (I-011) —
condición de cierre satisfecha automáticamente
cuando los 61 UCs estuvieron corregidos. Todos
los gates THYROX cumplidos:

- I-011: cierre por orden explícita.
- I-012: 0 hallazgos SPECULATIVE en el sweep
  final.
- I-013: claims heredados re-verificados (sweep
  automático demuestra 0 residuos).
- I-015: build incremental 0/0/0.
