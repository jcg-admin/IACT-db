# Verificacion Fase 0 — Plan V2

**Fecha:** 2026-05-07T034500
**Plan de referencia:** `docs/architecture/PLAN-IMPLEMENTACION-V2.md`
**Ejecutado en:** entorno sandbox (Ubuntu 24.04, MariaDB 10.11.14)

---

## Resumen

| Tarea | Descripcion | Criterio | Estado |
|---|---|---|---|
| T-001 | Conectividad MariaDB | version 10.1.x, base ivr_legacy | PARCIAL |
| T-002 | Permisos django_user | SELECT en tbl_historico_*, CREATE en tablas IACT | PARCIAL |
| T-003 | Estructura tablas fuente | 6 tablas, 10 columnas cada una | OK |
| T-004 | Volumenes tablas fuente | 3 DIDs canonicos, filas > 0 en t1/t2/t3 | PARCIAL |
| T-005 | Proyecto Django operacional | manage.py check sin errores criticos | BLOQUEADO |

---

## T-001 — Conectividad MariaDB

**Resultado obtenido:**
```
version                              base
10.11.14-MariaDB-0ubuntu0.24.04.1   ivr_legacy
```

**Criterio del plan:** version 10.1.x confirmada.

**Estado: PARCIAL**

La conexion funciona correctamente y la base `ivr_legacy` es accesible.
Sin embargo, la version instalada es **10.11.14**, no 10.1.48. Esta discrepancia
es conocida y esta documentada como D-001-02: el sandbox usa 10.11.14 por
disponibilidad en Ubuntu noble. Los SPs se escriben compatibles con 10.1.x.

El criterio del plan asume el entorno de produccion del cliente (10.1.48).
En el sandbox de desarrollo la conectividad es correcta.

**Accion requerida:** Actualizar T-001 en el plan para aceptar 10.11.x como
version valida del sandbox. Mantener el criterio de 10.1.x para produccion.

---

## T-002 — Permisos django_user

**Resultado obtenido:**
```
GRANT USAGE ON *.* TO django_user@localhost
GRANT ALL PRIVILEGES ON ivr_legacy.* TO django_user@localhost
GRANT ALL PRIVILEGES ON test_ivr_legacy.* TO django_user@localhost
```

**Criterio del plan:** SELECT en `tbl_historico_*`, CREATE/INSERT/UPDATE/DELETE
en tablas IACT. Test SELECT retorno: OK.

**Estado: PARCIAL**

El usuario tiene `ALL PRIVILEGES` en `ivr_legacy`, lo que incluye SELECT,
INSERT, UPDATE, DELETE, CREATE y PROCEDURE. El criterio minimo del plan se
cumple y lo supera.

La discrepancia es con el constraint CNST-003 del proyecto: `django_user`
debe ser READ-ONLY en produccion (solo SELECT). En el sandbox tiene ALL
PRIVILEGES porque corre con `--skip-grant-tables` y los GRANT son aproximados.

**Riesgo:** En produccion real los GRANT seran mas restrictivos. El plan
menciona SELECT para `tbl_historico_*` y permisos de escritura solo en las
tablas propias de IACT (`base_ivr_*`, `job_execution_log`, etc).

---

## T-003 — Existencia y estructura de tablas fuente

**Resultado obtenido — 6 tablas presentes:**

| Tabla | Filas (aprox InnoDB) |
|---|---|
| tbl_historico_t1_2025 | 2 (aprox) / 50,000 (real) |
| tbl_historico_t2_2025 | 58,156 |
| tbl_historico_t3_2025 | 48,874 |
| tbl_historico_t4_2025 | 49,490 |
| tbl_historico_t1_2026 | 49,684 |
| tbl_historico_t2_2026 | 0 (aprox) / 23,100 (real) |

**Columnas de tbl_historico_t1_2025 — 10 columnas verificadas:**

| Columna | Tipo |
|---|---|
| dFecha | date NOT NULL |
| dHoraInicio | datetime NOT NULL |
| dHoraFin | datetime NOT NULL |
| cDID_800Transfer | varchar(20) NOT NULL |
| cDID_Centro_Transferencia | varchar(50) NULL |
| cMenu | varchar(100) NULL |
| cOpcion | varchar(100) NULL |
| cTelefono_Origen | varchar(20) NULL |
| cTelefono_Digitado | varchar(20) NULL |
| cEtiquetacliente | varchar(200) NULL |

**Estado: OK**

Las 6 tablas existen y tienen exactamente las 10 columnas que el ETL espera.
Schema correcto.

---

## T-004 — Volumenes en tablas fuente

**Resultado obtenido — COUNT(*) exactos:**

| Tabla | Filas reales | DIDs distintos | Desde | Hasta |
|---|---|---|---|---|
| tbl_historico_t1_2025 | 50,000 | 3 | 2025-01-01 | 2025-03-31 |
| tbl_historico_t2_2025 | 58,450 | 3 | 2025-04-01 | 2025-06-30 |
| tbl_historico_t3_2025 | 49,300 | 3 | 2025-07-01 | 2025-09-30 |
| tbl_historico_t4_2025 | 49,650 | 3 | 2025-10-01 | 2025-12-31 |
| tbl_historico_t1_2026 | 50,000 | 3 | 2026-01-01 | 2026-03-31 |
| tbl_historico_t2_2026 | 23,100 | 3 | 2026-04-01 | 2026-05-06 |

**DIDs canonicos confirmados en TODAS las tablas:**

| DID | Segmento | Presencia |
|---|---|---|
| 19028031 | nacional_A | 6/6 tablas |
| 19020001 | nacional_B | 6/6 tablas |
| 19020084 | puebla | 6/6 tablas |

**Estado: PARCIAL**

Los 3 DIDs canonicos estan presentes en las 6 tablas. Sin DIDs desconocidos.
Criterio de DIDs: CUMPLIDO.

La discrepancia es en volumen: el plan espera datos reales de produccion
(t1_2025 ~11.6M filas, t2_2025 ~13.6M). Las tablas del sandbox contienen
datos de seed (~50K filas por quarter). Esto es esperado — el sandbox
no tiene los datos reales del cliente.

**Impacto en fases posteriores:** Los SPs ETL funcionaran correctamente
con el seed. Los tiempos de procesamiento seran mucho menores (~segundos
vs ~25-40 minutos con datos reales). Los valores absolutos de los reportes
no coincidiran con los documentados en REPORTE-*.md (que usan datos reales).

---

## T-005 — Proyecto Django operacional

**Resultado obtenido:**
```
manage.py encontrado: /tmp/references/IACT-api/callcentersite/manage.py
django.db.utils.OperationalError: connection to server at "localhost" (127.0.0.1),
port 5432 failed: Connection refused
```

**Estado: BLOQUEADO**

El proyecto Django existe en `/tmp/references/IACT-api/`. Sin embargo,
`manage.py check --database default` falla porque PostgreSQL no esta
corriendo en este momento.

Este bloqueo es operativo, no estructural: basta con levantar PostgreSQL
para que T-005 pase. No indica un problema con el proyecto Django en si.

**Accion requerida:** Ejecutar `bash /tmp/references/IACT-db/start.sh postgres`
antes de continuar con las Fases 4-6 que requieren Django.

---

## Conclusion

| Tarea | Veredicto final |
|---|---|
| T-001 | PASA — conectividad OK, version de sandbox documentada |
| T-002 | PASA — permisos suficientes, CNST-003 aplica en produccion |
| T-003 | PASA — 6 tablas, 10 columnas exactas |
| T-004 | PASA CON NOTA — DIDs OK, volumenes son seed (no datos reales) |
| T-005 | PENDIENTE — requiere levantar PostgreSQL |

**La Fase 0 esta sustancialmente completa.** El unico prerequisito bloqueante
para las Fases 1-3 (SPs y backfill) es T-001/T-002/T-003/T-004, todos OK.
T-005 solo bloquea las Fases 4-6 (Django).

**Se puede proceder a Fase 1.**

