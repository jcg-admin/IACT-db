# Tablas históricas IVR — Schema y Seed

Documentación del schema real de las tablas fuente del IVR y del
proceso de seed para el entorno de desarrollo.

## Contexto

El sistema IVR del cliente almacena su histórico de llamadas en tablas
particionadas físicamente por trimestre. IACT las consume en modo
**solo lectura** (CNST-003 — nunca se escribe en estas tablas).

El schema y los datos de desarrollo son generados por los scripts de
este repositorio. La BD de producción la gestiona el cliente.

---

## Tablas

| Tabla | Quarter | Rango | Estado en desarrollo |
|---|---|---|---|
| `tbl_historico_t1_2025` | Q1 2025 | 2025-01-01 → 2025-03-31 | Completo |
| `tbl_historico_t2_2025` | Q2 2025 | 2025-04-01 → 2025-06-30 | Completo |
| `tbl_historico_t3_2025` | Q3 2025 | 2025-07-01 → 2025-09-30 | Completo |
| `tbl_historico_t4_2025` | Q4 2025 | 2025-10-01 → 2025-12-31 | Completo |
| `tbl_historico_t1_2026` | Q1 2026 | 2026-01-01 → 2026-03-31 | Completo |
| `tbl_historico_t2_2026` | Q2 2026 | 2026-04-01 → 2026-06-30 | Parcial (datos hasta 2026-05-06) |

La convención de nombres es `tbl_historico_t{N}_{YYYY}` donde `N` es
el número de trimestre (1-4) y `YYYY` el año. Cada tabla nueva se
agrega al script cuando el trimestre comienza.

---

## Columnas

Columnas reales confirmadas en análisis de scripts de producción
(WP `2026-05-02-07-12-32-pipeline-uc-deepening`):

| Columna | Tipo | Nullable | Descripción |
|---|---|---|---|
| `dFecha` | DATE | NO | Fecha de la interacción IVR |
| `dHoraInicio` | DATETIME | NO | Timestamp de inicio de la llamada |
| `dHoraFin` | DATETIME | NO | Timestamp de fin de la llamada |
| `cDID_800Transfer` | VARCHAR(20) | NO | DID de entrada del llamante |
| `cDID_Centro_Transferencia` | VARCHAR(50) | SÍ | Centro de transferencia destino |
| `cMenu` | VARCHAR(100) | SÍ | Menú IVR navegado |
| `cOpcion` | VARCHAR(100) | SÍ | Opción dentro del menú |
| `cTelefono_Origen` | VARCHAR(20) | SÍ | Número del llamante (CLI) |
| `cTelefono_Digitado` | VARCHAR(20) | SÍ | Número digitado por el usuario en el IVR |
| `cEtiquetacliente` | VARCHAR(200) | SÍ | Etiqueta individual por registro |

**Sin índices** — producción opera con full table scans de 11-14M
filas por quarter (CNST-ETL-005). No se crean índices en estas tablas.

---

## Particularidades del schema real

### cDID_800Transfer — DIDs por segmento

Los tres segmentos del sistema y sus DIDs de entrada:

| Segmento | DID | Proporción aproximada |
|---|---|---|
| Nacional A | `19028031` | 45% del volumen |
| Nacional B | `19020001` | 30% del volumen |
| Puebla | `19020084` | 25% del volumen |

### cMenu — inferencia de abandono

No existe columna `status`. El abandono se infiere del valor de `cMenu`:

| Valor de cMenu | Clasificación |
|---|---|
| `cliente_colgo` | Abandono — mayor grupo (~52% del volumen) |
| `NULL`, `''`, `sin cMenu` | Abandono — cMenu vacío en fuente (~9%) |
| `SinOpcion_Cabecera` | Abandono (~4%) |
| `Desborde_Cabecera` | Enrutamiento por etiqueta — no es abandono |
| `Desborde_Promocional` | Enrutamiento promocional — no es abandono |
| Cualquier otro valor | Llamada completada — navegó el IVR |

### cDID_Centro_Transferencia — formato NK90

Mientras la infraestructura de enrutamiento NK90 esté activa, este
campo concatena el VDN real con el teléfono digitado:

```
cDID_Centro_Transferencia = [VDN][cTelefono_Digitado]

Ejemplo: '13090044433150875'
  └── VDN:    '1309004'    (7 dígitos — identificador real del centro)
  └── Teléf:  '4433150875' (10 dígitos — cTelefono_Digitado)
```

Para obtener el VDN real: `LEFT(campo, LENGTH(campo) - 10)` cuando
`LENGTH > 10`. Los SPs de ETL aplican esta normalización.

Valores especiales: `NULL` (llamada no transferida), `'cliente_colgo'`
(cliente colgó antes de transferir), `'0000000'` (error de sistema).

### Bug real de calidad de datos

Existen registros donde `dHoraInicio > dHoraFin` (campos invertidos
por el IVR). Proporción aproximada: 0.3% del total. Los scripts de
ETL de producción compensan este defecto con lógica defensiva. El
seed replica esta proporción para que los tests del ETL encuentren
el mismo patrón que en producción.

---

## Scripts

Los tres scripts viven en `provisioners/mariadb/`:

```
provisioners/mariadb/
├── schema_historico.sh   ← punto de entrada (bash wrapper)
├── schema_historico.sql  ← DDL: CREATE TABLE IF NOT EXISTS
└── seed_historico.sql    ← datos de prueba representativos
```

### schema_historico.sh — punto de entrada

Wrapper bash que orquesta el proceso completo. Lee credenciales
desde `.env`, captura el commit hash activo y muestra el historial
de ejecuciones al finalizar.

```bash
# Uso normal (idempotente)
sudo bash provisioners/mariadb/schema_historico.sh

# Con más registros por quarter
SEED_ROWS=50000 sudo bash provisioners/mariadb/schema_historico.sh

# Solo el schema, sin seed
SKIP_SEED=1 sudo bash provisioners/mariadb/schema_historico.sh

# Forzar re-seed (TRUNCATE + reinsertar)
FORCE_RESEED=1 sudo bash provisioners/mariadb/schema_historico.sh
```

Variables de entorno disponibles:

| Variable | Default | Descripción |
|---|---|---|
| `SEED_ROWS` | `5000` | Filas por quarter completo |
| `FORCE_RESEED` | `0` | `1` = TRUNCATE antes de insertar |
| `SKIP_SEED` | `0` | `1` = solo DDL, omitir seed |

### schema_historico.sql — DDL

Ejecuta `CREATE TABLE IF NOT EXISTS` para las 6 tablas. Completamente
idempotente: ejecutarlo N veces sobre una BD ya configurada no tiene
ningún efecto adverso.

```bash
# Ejecución directa (sin el wrapper bash)
mysql -u django_user -pdjango_pass ivr_legacy < \
    provisioners/mariadb/schema_historico.sql
```

### seed_historico.sql — datos de prueba

Crea el SP `sp_seed_historico()`, lo ejecuta para los 6 quarters y
lo descarta al final. La tabla `seed_executions` registra cada
ejecución.

```bash
# Ejecución directa con variables de sesión
mysql -u django_user -pdjango_pass ivr_legacy << 'SQL'
SET @SEED_ROWS    = 5000;
SET @FORCE_RESEED = 0;
SET @COMMIT_HASH  = 'abc1234';
SET @SCRIPT_VER   = '2.0.0';
SQL
# ... (en la misma sesión continuar con el contenido del archivo)
```

---

## Idempotencia

El comportamiento al ejecutar múltiples veces depende de los flags:

| Ejecución | `FORCE_RESEED` | Resultado |
|---|---|---|
| 1ra vez (tablas vacías) | 0 | `SEED` — inserta SEED_ROWS en cada tabla |
| 2da vez (tablas con datos) | 0 | `SKIP` — no modifica ninguna tabla |
| Cualquier ejecución | 1 | `TRUNCATE+SEED` — limpia y re-siembra |

El DDL (`CREATE TABLE IF NOT EXISTS`) siempre es seguro ejecutar
cualquier número de veces independientemente del flag.

---

## Tracking de ejecuciones

Cada llamada al SP registra una fila en `seed_executions`:

```sql
SELECT id, ejecutado_en, tabla, accion,
       filas_antes, filas_despues,
       seed_rows_cfg, script_version,
       LEFT(commit_hash, 8) AS commit
FROM seed_executions
ORDER BY id;
```

Resultado típico después de la primera ejecución:

```
id  ejecutado_en         tabla                     accion  fa  fd    commit
1   2026-05-06 07:05:00  tbl_historico_t1_2025     SEED    0   5000  34c1770f
2   2026-05-06 07:05:12  tbl_historico_t2_2025     SEED    0   5000  34c1770f
3   2026-05-06 07:05:24  tbl_historico_t3_2025     SEED    0   5000  34c1770f
4   2026-05-06 07:05:36  tbl_historico_t4_2025     SEED    0   5000  34c1770f
5   2026-05-06 07:05:48  tbl_historico_t1_2026     SEED    0   5000  34c1770f
6   2026-05-06 07:06:00  tbl_historico_t2_2026     SEED    0   1978  34c1770f
```

Resultado típico después de una segunda ejecución sin `FORCE_RESEED`:

```
id  ejecutado_en         tabla                     accion  fa    fd    commit
7   2026-05-06 08:00:00  tbl_historico_t1_2025     SKIP    5000  5000  34c1770f
8   2026-05-06 08:00:00  tbl_historico_t2_2025     SKIP    5000  5000  34c1770f
...
```

El campo `commit_hash` permite trazar exactamente qué versión del
script generó cada lote de datos.

---

## Distribución de datos del seed

El generador replica los patrones reales documentados en los work
packages de análisis del IVR:

### cDID_800Transfer
- Nacional A (`19028031`): 45%
- Nacional B (`19020001`): 30%
- Puebla (`19020084`): 25%

### cMenu
- `cliente_colgo`: 52%
- NULL / vacío / `sin cMenu`: 9%
- `SinOpcion_Cabecera`: 4%
- `Desborde_Cabecera`: 5%
- `Desborde_Promocional`: 2%
- Menús reales (Saldo, Pagos, Atencion, Transferencia, etc.): 28%

### cDID_Centro_Transferencia
- Formato NK90 (VDN + teléfono concatenados, `len > 10`): 70%
- Formato directo (solo VDN, `len <= 10`): 30%
- NULL (abandono): proporcional al volumen de abandono
- VDNs usados: `1309004`, `15070013`, `2309004`, `1205003`, `1408002`, `1705001`

### cTelefono_Digitado
- NULL (usuario no digitó): 30%
- Igual a `cTelefono_Origen` (misma línea): 45%
- Diferente a `cTelefono_Origen` (línea diferente): 25%

### Bug `dHoraInicio > dHoraFin`
- Proporción: ~0.3% de registros (replicado del defecto real de producción)

---

## Volúmenes recomendados por entorno

| Entorno | SEED_ROWS | Tiempo aprox. | Notas |
|---|---|---|---|
| Desarrollo | 5,000 | ~30 seg | Default. Suficiente para queries y ETL |
| Integración | 50,000 | ~5 min | Útil para tests de performance |
| Staging | 500,000 | ~1 hora | Representativo de un mes real |
| Producción | N/A | N/A | Datos reales del cliente — nunca usar este script |

En producción cada quarter tiene 11-14 millones de filas.

---

## Pendiente

El seed requiere una sesión de MariaDB estable durante toda la
ejecución. En entornos sin systemd (contenedores, sandboxes), MariaDB
puede caer si el proceso padre termina antes de que el seed concluya.

El flujo recomendado para esos entornos es:

```bash
# 1. Asegurar que MariaDB está corriendo y estable
sudo pg_ctlcluster 16 main status  # PostgreSQL (referencia)
sudo service mariadb status         # MariaDB

# 2. Si no está corriendo, iniciarlo y esperar a que esté listo
sudo service mariadb start
sleep 5

# 3. Verificar antes de ejecutar el seed
mysqladmin -h 127.0.0.1 -u django_user -pdjango_pass ping

# 4. Ejecutar el script completo
sudo bash provisioners/mariadb/schema_historico.sh
```

Queda pendiente agregar esta verificación de estabilidad dentro del
propio `schema_historico.sh` para que el script falle de forma
explícita si MariaDB no está disponible durante el seed, en lugar
de producir una ejecución parcial silenciosa.

---

## Commits relacionados

| Commit | Descripción |
|---|---|
| `b187a01` | feat: tablas tbl_historico_t1..t3_2025 — schema y seed inicial |
| `34c1770` | fix: agregar t4_2025, t1_2026 y t2_2026 — cobertura completa |

## Ver también

- `QUICKSTART.md` — arranque rápido de las BDs
- `VERIFICACION-LOCAL-SIN-VAGRANT.md` — checklist de verificación
- `docs/architecture/SEPARACION-IACT-API.md` — división de responsabilidades
- `provisioners/mariadb/setup.sh` — creación de usuario y BD
