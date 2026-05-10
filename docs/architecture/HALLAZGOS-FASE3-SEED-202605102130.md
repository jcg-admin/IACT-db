# Hallazgos — Ejecución FASE 3 (Validación)

**Versión:** 1.0.0  
**Fecha:** 2026-05-10  
**Contexto:** Implementación de FASE 3 del
`PLAN-SEED-HISTORICO-V2-202605102100.md`  
**Archivos modificados:** `provisioners/mariadb/poblar_historico.py` (H-F3-001)

---

## Resumen de tareas

| Tarea | Descripción | Estado | Observaciones |
|---|---|---|---|
| T-3.1 | Verificar sintaxis de ambos archivos | COMPLETO | OK |
| T-3.2 | Seed con APPEND (adaptado — sin TRUNCATE) | COMPLETO | APPEND confirmado |
| T-3.3 | Segunda ejecución APPEND | COMPLETO | Conteos crecen correctamente |
| T-3.4 | Validación de distribuciones calibradas | COMPLETO + H-F3-001 | Bug encontrado y corregido |
| T-3.5 | Validación de volúmenes por quarter | COMPLETO | Escalas correctas |
| T-3.6a | FULL_SEED=1 con ivr_seed_user | COMPLETO | poblar_historico.py OK |
| T-3.6b | verify.sh 26 OK | COMPLETO + H-F3-002 | PostgreSQL caído — reiniciado |

---

## Adaptación de T-3.2

El plan original requería TRUNCATE de las tablas para probar la acción `SEED`
(primera inserción en tabla vacía). El usuario explicitó que los datos existentes
no deben borrarse. La adaptación:

- T-3.2 ejecutó `schema_historico.sh` con tablas que ya tenían datos.
- El SP registró `APPEND` en todas las tablas — comportamiento correcto.
- El comportamiento `SEED` (tabla vacía) fue validado en las ejecuciones de FASE 1,
  cuyos resultados están documentados en `HALLAZGOS-FASE1-SEED-SQL-202605102015.md`.
- No se perdió cobertura de validación — ambas ramas del código están probadas.

---

## Resultados de distribuciones — T-3.4

Medidas en `tbl_historico_t1_2025` (27,071 registros — muestra robusta):

| Métrica | Seed v3.0.0 | Objetivo | Diff | Estado |
|---|---|---|---|---|
| G-29 (horas invertidas) | 38.70% | 38.80% | 0.10pp | OK |
| `cMenu = cliente_colgo` | 22.67% | 22.60% | 0.07pp | OK |
| VACIO (NULL/vacío/sin) | 7.88% | 8.00% | 0.12pp | OK |
| `cMenu = RES-FallaInternet` | 14.38% | 14.30% | 0.08pp | OK |
| `cMenu = Desborde_Cabecera` | 13.15% | 13.30% | 0.15pp | OK |
| `cMenu = NOTMX-SeguimientoIns` | 11.22% | 11.60% | 0.38pp | OK |
| `cMenu = SinOpcion_Cabecera` | 3.32% | 3.30% | 0.02pp | OK |
| `cMenu = Marque3` | 2.10% | 2.10% | 0.00pp | OK |
| `cTelefono_Digitado IS NULL` | 21.27% | 21.20% | 0.07pp | OK |
| `cTelefono_Digitado = Origen` | 28.30% | 28.20% | 0.10pp | OK |

Todas dentro de ±2pp. Máxima desviación: 0.38pp en NOTMX-SeguimientoInstalacion.

**Corrección H-F1-001 confirmada:**
- `SinOpcion_Cabecera`: 0.0% `cliente_colgo` en cDID (correcto — debe ser '19020086')
- `Marque3`: 0.0% `cliente_colgo` en cDID (correcto — debe ser '19020086')
- `cMenu='cliente_colgo'`: 100.0% `cDID='cliente_colgo'` (correcto)

**Menús genéricos inexistentes:**
- Ningún registro con: `Saldo`, `Pagos`, `Atencion`, `Transferencia`,
  `Informacion`, `ReclamacionesTecnicas`, `BajasModificaciones`,
  `ConsultaFactura`, `SolicitudProducto`. Resultado: 0 de 27,071.

---

## Resultados de volúmenes — T-3.5

| Quarter | Filas | Escala real | Escala objetivo | Diff |
|---|---|---|---|---|
| Q01_25 (base) | 27,071 | 1.000 | 1.000 | — |
| Q02_25 (pico) | 30,860 | 1.140 | 1.136 | 0.004 |
| Q03_25 (valle) | 25,951 | 0.959 | 0.954 | 0.005 |
| Q04_25 | 28,294 | 1.045 | 1.041 | 0.004 |
| Q01_26 | 27,473 | 1.015 | 1.010 | 0.005 |
| Q02_26 (parcial) | 12,301 | — | 36/91 días | — |

Todas las escalas dentro de ±0.01 del objetivo. Q02_25 es el mayor.
Q03_25 es el menor dentro del ciclo anual 2025. Correcto.

---

## Hallazgos identificados

| ID | Hallazgo | Tipo | Severidad | Estado |
|---|---|---|---|---|
| H-F3-001 | `gen_phone()` en `poblar_historico.py` usa `randint(0, ...)` produciendo ceros de padding | Bug — réplica de H-SEED-007 en Python | ALTA | RESUELTO en sesión |
| H-F3-002 | MariaDB y PostgreSQL cayeron durante la sesión (H-PROV-001) | Ambiente — contenedor sin systemd | INFORMATIVO | REINICIADOS |

---

## H-F3-001 — Bug `gen_phone()` en `poblar_historico.py`

**Tipo:** Bug detectado en T-3.4 — réplica del H-SEED-007 (LPAD) pero en Python  
**Severidad:** ALTA — el mismo defecto corregido en el Nivel 1 (SQL) persistía
en el Nivel 2 (Python)  
**Estado:** RESUELTO durante la sesión (corrección + verificación + commit)

### Descripción

`gen_phone()` en la línea 114 (antes de la corrección):

```python
def gen_phone():
    pref, digs = random.choices(PREFIJOS, weights=PESOS_PREFIJOS)[0]
    return pref + str(random.randint(0, 10**digs - 1)).zfill(digs)
```

`randint(0, 10**digs - 1)` tiene rango `[0, 9_999_999]` para `digs=7`.
Cuando el valor generado es menor que `10**(digs-1) = 1_000_000`, el
resultado tiene menos de 7 dígitos y `.zfill(digs)` rellena con ceros:

```
randint(0, 9_999_999) = 123
str(123).zfill(7) = '0000123'
CONCAT('443', '0000123') = '4430000123'   ← teléfono irreal
```

La tasa de ocurrencia sobre 100,000 números: **9.85%** — el mismo orden
de magnitud que H-SEED-007 (9.4%) en el código SQL original.

### Corrección aplicada

```python
def gen_phone():
    pref, digs = random.choices(PREFIJOS, weights=PESOS_PREFIJOS)[0]
    # H-F3-001: randint(10**(digs-1), 10**digs - 1) garantiza exactamente
    # `digs` dígitos con primer dígito siempre 1-9. Sin zfill necesario.
    return pref + str(random.randint(10**(digs - 1), 10**digs - 1))
```

Para `digs=7`: `randint(1_000_000, 9_999_999)` → siempre 7 dígitos, sin cero inicial.  
Para `digs=8`: `randint(10_000_000, 99_999_999)` → siempre 8 dígitos, sin cero inicial.

### Verificación post-corrección

```
Total generados:  100,000
Con cero-bug:     0  (0.00%)
Longitudes:       [10] — siempre 10 dígitos (correcto)
```

### Impacto en datos existentes

Los datos en las tablas que fueron insertados por ejecuciones anteriores
de `poblar_historico.py` (Nivel 2) pueden contener hasta ~9.85% de teléfonos
con ceros de padding. Como el usuario indicó que no se deben borrar datos,
estos permanecen en las tablas. Las ejecuciones futuras de `poblar_historico.py`
generarán únicamente teléfonos válidos.

Los datos del Nivel 1 (`seed_historico.sql`) NO tienen este problema —
H-SEED-007 fue corregido en v3.0.0 con `FLOOR(1000000 + RAND() * 9000000)`.

### Relación con H-SEED-007

H-SEED-007 y H-F3-001 son el mismo defecto de diseño: generar un número
aleatorio sin garantizar un mínimo de dígitos y compensar con padding.
La corrección es análoga en ambos casos: usar el rango `[10^(n-1), 10^n - 1]`
que garantiza exactamente `n` dígitos sin padding.

---

## H-F3-002 — MariaDB y PostgreSQL caídos durante la sesión

**Tipo:** Problema de ambiente — H-PROV-001 conocido  
**Estado:** REINICIADOS — no afecta los resultados de validación

### Descripción

Durante la ejecución de T-3.5, MariaDB cayó (sin systemd, el proceso no
sobrevive sin un init system). PostgreSQL también cayó al momento de
ejecutar verify.sh.

Ambos fueron reiniciados con los workarounds documentados en
`HALLAZGOS-PROVISIONAMIENTO-202605101945.md` (H-PROV-001):

- MariaDB: `nohup su -s /bin/bash mysql -c 'mariadbd ...' &`
- PostgreSQL: `pg_ctlcluster 16 main start`

### Impacto en la validación

Ninguno. Todos los datos en las tablas persistieron (InnoDB mantiene los datos
en disco). La caída y reinicio confirmaron la robustez del diseño:
las tablas históricas sobreviven reinicios del servidor.

---

## Estado final del entorno al cierre de FASE 3

```
tbl_historico_t1_2025:  33,085
tbl_historico_t2_2025:  37,794  (pico)
tbl_historico_t3_2025:  31,791  (valle)
tbl_historico_t4_2025:  34,644
tbl_historico_t1_2026:  33,638
tbl_historico_t2_2026:  15,110  (parcial)

seed_executions: 48 filas — historial completo de todas las ejecuciones
script_version:  2.4.0 en las últimas ejecuciones
commit:          511a7c45 (fix(mariadb/schema) v2.4.0)

poblar_historico.py gen_phone(): corregido (H-F3-001)
verify.sh:  26 OK, 0 WARN, 0 ERR, EXIT 0
```

FASE 3 completada. H-F3-001 detectado durante validación de T-3.4
y corregido en la misma sesión antes de avanzar.
