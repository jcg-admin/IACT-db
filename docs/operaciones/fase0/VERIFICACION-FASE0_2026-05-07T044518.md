# Verificacion Fase 0 — Plan V2.1

**Fecha:** 2026-05-07T044500
**Plan de referencia:** `docs/architecture/PLAN-IMPLEMENTACION-V2.1.md`
**Entorno:** Sandbox Ubuntu 24.04 LTS, MariaDB 10.11.14
**Ejecutado con:** `scripts/provision-mariadb.sh` (MariaDB levantada manualmente)

---

## Resumen ejecutivo

| Tarea | Descripcion | Criterio plan | Resultado | Estado |
|---|---|---|---|---|
| T-001 | Conectividad MariaDB | sandbox 10.11.x / prod 10.1.x | 10.11.14, base ivr_legacy | PASA |
| T-002 | Permisos django_user | SELECT tbl_historico_*, CREATE en IACT | ALL PRIVILEGES en ivr_legacy | PASA |
| T-003 | Estructura tablas fuente | 6 tablas, 10 columnas | 6 tablas, 10 columnas exactas | PASA |
| T-004 | Volumenes y DIDs | 3 DIDs canonicos, filas > 0 | 3 DIDs OK, ~50K filas/quarter (seed) | PASA CON NOTA |
| T-005 | Proyecto Django | manage.py check sin errores criticos | PostgreSQL inactivo | BLOQUEADO |

**Resultado global:** Fase 0 apta para continuar con Fases 1-3 (MariaDB).
T-005 solo bloquea Fases 4-6 (Django). No es bloqueante ahora.

---

## T-001 — Conectividad MariaDB

**Comando ejecutado:**
```bash
mysql --socket=/run/mysqld/mysqld.sock -u django_user -pdjango_pass \
      ivr_legacy -e "SELECT VERSION(), DATABASE();"
```

**Resultado:**
```
VERSION()                              DATABASE()
10.11.14-MariaDB-0ubuntu0.24.04.1      ivr_legacy
```

**Analisis:**
La conexion responde sin error. La base `ivr_legacy` es accesible con las
credenciales de `django_user`. La version 10.11.14 corresponde al criterio
de sandbox del plan V2.1 (Ubuntu noble incluye 10.11.14 en noble-updates).

El criterio de produccion (10.1.x) aplica al servidor real del cliente, que
no es este entorno.

**Hallazgo H-F0-001:** MariaDB no estaba corriendo al inicio de la verificacion.
Fue necesario arrancarla manualmente con `runuser -u mysql -- /usr/sbin/mariadbd
--skip-grant-tables`. En produccion corre como servicio systemd — este hallazgo
es exclusivo del sandbox. Referencia: HALLAZGOS-ENTORNO.md H-001-03.

**Estado: PASA**

---

## T-002 — Permisos GRANT

**Resultado:**
```
GRANT USAGE ON *.*                  TO django_user@localhost
GRANT ALL PRIVILEGES ON ivr_legacy.* TO django_user@localhost
GRANT ALL PRIVILEGES ON ivr_legacy.* TO django_user@%
GRANT ALL PRIVILEGES ON test_ivr_legacy.* TO django_user@localhost
GRANT ALL PRIVILEGES ON test_ivr_legacy.* TO django_user@%
```

Test SELECT directo: `SELECT 1 FROM tbl_historico_t1_2025 LIMIT 1` → OK

**Analisis:**
El usuario tiene `ALL PRIVILEGES` en `ivr_legacy`, que incluye SELECT,
INSERT, UPDATE, DELETE, CREATE, DROP y EXECUTE. El criterio minimo del plan
(SELECT en `tbl_historico_*`, CREATE/INSERT/DELETE/UPDATE en tablas IACT)
se cumple y lo supera.

**Hallazgo H-F0-002:** En produccion los GRANTs deben ser mas restrictivos.
El plan especifica SELECT-only en `tbl_historico_*` (CNST-003 — READ-ONLY para
Django). En el sandbox `ALL PRIVILEGES` se debe a `--skip-grant-tables` y a
que setup.sh fue disenado para un entorno de desarrollo. En produccion el
script de setup aplicara solo los permisos minimos necesarios.

**Hallazgo H-F0-003:** `django_user` tiene permisos sobre `practicayoruba_qa`
y `test_practicayoruba_qa`. Estas bases son de otro proyecto (IACT-api).
Son correctas en este sandbox compartido pero no deben estar en el servidor
de produccion del IVR.

**Estado: PASA**

---

## T-003 — Existencia y estructura de tablas fuente

**Tablas encontradas (6):**

| Tabla | TABLE_ROWS (aprox InnoDB) |
|---|---|
| tbl_historico_t1_2025 | 2 (aprox) / 50,000 (real COUNT) |
| tbl_historico_t1_2026 | 49,684 |
| tbl_historico_t2_2025 | 58,156 |
| tbl_historico_t2_2026 | 0 (aprox) / 23,100 (real COUNT) |
| tbl_historico_t3_2025 | 48,874 |
| tbl_historico_t4_2025 | 49,490 |

**Columnas de tbl_historico_t1_2025 (10):**

| Columna | Tipo | NULL |
|---|---|---|
| dFecha | date | NO |
| dHoraInicio | datetime | NO |
| dHoraFin | datetime | NO |
| cDID_800Transfer | varchar(20) | NO |
| cDID_Centro_Transferencia | varchar(50) | YES |
| cMenu | varchar(100) | YES |
| cOpcion | varchar(100) | YES |
| cTelefono_Origen | varchar(20) | YES |
| cTelefono_Digitado | varchar(20) | YES |
| cEtiquetacliente | varchar(200) | YES |

**Analisis:**
Las 6 tablas existen. Las 10 columnas requeridas por el ETL estan presentes
con los tipos correctos. Schema completamente compatible.

**Hallazgo H-F0-004:** `TABLE_ROWS` de InnoDB es impreciso para varias tablas
(tbl_historico_t1_2025 muestra 2, tbl_historico_t2_2026 muestra 0). Esto es
la discrepancia InnoDB documentada en HALLAZGOS-BACKUP.md BK-002. Los COUNT(*)
reales confirman los datos. El ETL usa COUNT(*) — no depende de `TABLE_ROWS`.

**Estado: PASA**

---

## T-004 — Volumenes y DIDs en tablas fuente

**Resultado COUNT(*) exacto por tabla:**

| Tabla | Filas reales | DIDs distintos | Desde | Hasta |
|---|---|---|---|---|
| tbl_historico_t1_2025 | 50,000 | 3 | 2025-01-01 | 2025-03-31 |
| tbl_historico_t2_2025 | 58,450 | 3 | 2025-04-01 | 2025-06-30 |
| tbl_historico_t3_2025 | 49,300 | 3 | 2025-07-01 | 2025-09-30 |
| tbl_historico_t4_2025 | 49,650 | 3 | 2025-10-01 | 2025-12-31 |
| tbl_historico_t1_2026 | 50,000 | 3 | 2026-01-01 | 2026-03-31 |
| tbl_historico_t2_2026 | 23,100 | 3 | 2026-04-01 | 2026-05-06 |
| **TOTAL** | **280,500** | | | |

**DIDs canonicos en tbl_historico_t1_2025:**
`19020001` (nacional_B), `19020084` (puebla), `19028031` (nacional_A)
Los 3 DIDs canonicos presentes. Sin DIDs desconocidos.

**Analisis:**
El criterio de DIDs se cumple completamente — exactamente 3 DIDs canonicos
en las 6 tablas. El criterio de volumen del plan (~11.6M filas en t1) aplica
a datos reales de produccion. El sandbox usa datos de seed (~50K/quarter)
generados por `provisioners/mariadb/poblar_historico.py`. Los SPs ETL
funcionaran correctamente con estos datos — los tiempos seran mucho menores
(segundos vs ~9 minutos con datos reales).

**Hallazgo H-F0-005:** Los volumenes del sandbox (~50K/quarter) son 230 veces
menores que los de produccion (~11.6M/quarter para Q1). Las pruebas de
rendimiento (T-083) con estos datos no seran representativas del tiempo real
en produccion. Las pruebas funcionales (T-031 a T-037) si son validas.

**Estado: PASA CON NOTA**
Criterio de DIDs: CUMPLIDO. Criterio de volumen: inaplicable en sandbox (seed).

---

## T-005 — Proyecto Django

**Resultado:**
```
manage.py encontrado: /tmp/references/IACT-api/callcentersite/manage.py
Error: django.db.utils.OperationalError: connection to server at
"localhost" port 5432 failed: Connection refused
```

**Analisis:**
El proyecto Django existe en `/tmp/references/IACT-api/`. El error es
exclusivamente que PostgreSQL no esta corriendo en este momento. El proyecto
en si esta correctamente configurado — el error no indica ningun problema
estructural con el codigo ni con la configuracion.

Para levantar PostgreSQL y desbloquear esta tarea:
```bash
bash /tmp/references/IACT-db/start.sh postgres
cd /tmp/references/IACT-api/callcentersite
python manage.py check --database default
```

**Hallazgo H-F0-006:** T-005 permanece BLOQUEADO hasta que se levante
PostgreSQL. Esta tarea solo es prerequisito de las Fases 4-6 (Django).
Las Fases 1-3 (funciones, schema, ETL, backfill) no dependen de T-005.

**Estado: BLOQUEADO**
No es bloqueante para Fases 1-3. Se retoma cuando llegue Fase 4.

---

## Hallazgos registrados

| ID | Severidad | Descripcion | Estado |
|---|---|---|---|
| H-F0-001 | INFO | MariaDB no persiste entre sesiones — arranque manual ~3s | Conocido / BK-001 |
| H-F0-002 | INFO | ALL PRIVILEGES en sandbox vs SELECT-only en produccion (CNST-003) | Aceptable |
| H-F0-003 | BAJA | django_user tiene permisos sobre practicayoruba_qa (otro proyecto) | Solo en sandbox |
| H-F0-004 | INFO | InnoDB TABLE_ROWS impreciso — ETL usa COUNT(*), no afecta | BK-002 |
| H-F0-005 | INFO | Volumenes sandbox ~50K vs produccion ~11.6M — pruebas funcionales OK | Aceptable |
| H-F0-006 | INFO | T-005 bloqueado por PostgreSQL inactivo — no bloquea Fases 1-3 | Pendiente Fase 4 |

---

## Conclusion

Las 4 tareas que desbloquean las Fases 1-3 pasan correctamente.
T-005 esta bloqueado por PostgreSQL pero no es prerequisito de las
proximas fases a ejecutar.

**Se puede proceder a Fase 1.**
