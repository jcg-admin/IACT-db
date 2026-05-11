"""
Simulación de producción — Job ETL IVR (5 escenarios)

Replica el comportamiento exacto de manage.py run_etl para verificar
que el pipeline ETL funciona correctamente en el entorno de desarrollo.

Escenarios:
  A — Ejecución normal via evt_etl_diario (solo sp_etl_maestro, sin etl_runs)
  B — Ejecución normal via manage.py run_etl (etl_runs + heartbeat + sp_etl_maestro)
  C — Protección de concurrencia (job RUNNING → SKIP)
  D — Job deshabilitado (job_config.is_enabled=0 → SKIP)
  E — Detección de timeout por heartbeat

Uso:
  python3 test/simular_job.py

Prerequisito:
  MariaDB activa con ivr_legacy aprovisionado (verify.sh → 27 OK)
  Tablas tbl_historico_* con datos (schema_historico.sh ejecutado)

Relación con el código de producción:
  - Escenario B replica manage.py run_etl de IACT-api
  - El heartbeat usa timeout=3s (producción: 60s) para acelerar la simulación
  - trigger_source='django_command' en etl_runs (igual que producción)
"""

import subprocess
import threading
import time
from datetime import date

SOCK = "/run/mysqld/mysqld.sock"
DB   = "ivr_legacy"
CMD  = ["mysql", "--socket", SOCK, DB]
ROOT = ["mysql", "--socket", SOCK]

SEP  = "=" * 68
SEP2 = "-" * 68


def query(sql, db=True):
    cmd = CMD if db else ROOT
    r = subprocess.run(cmd + ["-N", "-e", sql],
                       capture_output=True, text=True)
    return r.stdout.strip()


def query_show(sql, db=True):
    cmd = CMD if db else ROOT
    subprocess.run(cmd + ["-e", sql])


def ts():
    return time.strftime("%H:%M:%S")


def header(title):
    print(f"\n{SEP}")
    print(f"  {title}")
    print(SEP)


# ---------------------------------------------------------------------------
# ESCENARIO A — evt_etl_diario: solo llama sp_etl_maestro, sin etl_runs
# ---------------------------------------------------------------------------
header("ESCENARIO A — evt_etl_diario (MySQL Event, 02:00 AM)")
print("  El event scheduler llama CALL sp_etl_maestro() directamente.")
print("  NO registra en etl_runs — solo en job_execution_log.")
print(f"\n  [{ts()}] CALL sp_etl_maestro() ...")

before_log = int(query("SELECT COUNT(*) FROM job_execution_log") or 0)
before_etl = int(query("SELECT COUNT(*) FROM etl_runs") or 0)

# Limpiar run anterior de Q02_26 para que no haya desfase
query("DELETE FROM base_ivr_detalle WHERE trimestre='Q02_26'")
query("DELETE FROM base_ivr_clientes WHERE trimestre='Q02_26'")

t0 = time.time()
query(
    "CALL sp_etl_maestro(); "
    "SELECT quarter_name, step_name, status, records_procesados "
    "FROM job_execution_log ORDER BY id DESC LIMIT 3;"
)
elapsed = time.time() - t0

after_log = int(query("SELECT COUNT(*) FROM job_execution_log") or 0)
after_etl = int(query("SELECT COUNT(*) FROM etl_runs") or 0)

print(f"  [{ts()}] Completado en {elapsed:.1f}s")
print(f"\n  job_execution_log: {before_log} → {after_log} (+{after_log - before_log} filas)")
print(f"  etl_runs:          {before_etl} → {after_etl} (sin cambio — esperado)")

q26 = query("SELECT SUM(total_llamadas) FROM base_ivr_detalle WHERE trimestre='Q02_26'")
print(f"\n  Q02_26 en base_ivr_detalle: {q26} llamadas procesadas")

print(f"\n  Checkpoints registrados:")
rows = query(
    "SELECT id, step_name, status, records_procesados, duracion_seg "
    "FROM job_execution_log ORDER BY id DESC LIMIT 3"
).split("\n")
for r in rows:
    print(f"    {r}")


# ---------------------------------------------------------------------------
# ESCENARIO B — manage.py run_etl: etl_runs + heartbeat + sp_etl_maestro
# ---------------------------------------------------------------------------
header("ESCENARIO B — manage.py run_etl (heartbeat real)")
print("  Replica el código EXACTO de run_etl.py:")
print("  1. INSERT etl_runs con timeout_at = NOW() + 30 MIN")
print("  2. threading.Thread heartbeat cada 60s")
print("  3. callproc sp_etl_maestro()")
print("  4. UPDATE etl_runs en finally\n")

quarter = f"Q0{((date.today().month - 1) // 3) + 1}_{str(date.today().year)[2:]}"
print(f"  quarter_activo(): {quarter}  ({date.today()})")

# Limpiar Q02_26 para re-procesar
query("DELETE FROM base_ivr_detalle WHERE trimestre='Q02_26'")
query("DELETE FROM base_ivr_clientes WHERE trimestre='Q02_26'")

# 1. Registrar inicio (replica _registrar_inicio de run_etl.py)
query(
    "INSERT INTO etl_runs "
    "  (trimestre, inicio_at, timeout_at, status, trigger_source) "
    f" VALUES ('{quarter}', NOW(), DATE_ADD(NOW(), INTERVAL 30 MINUTE), "
    "         'en_ejecucion', 'django_command')"
)
run_id = int(query("SELECT MAX(id) FROM etl_runs"))
timeout_at = query(f"SELECT timeout_at FROM etl_runs WHERE id={run_id}")
print(f"\n  [{ts()}] etl_runs INSERT: id={run_id}, timeout_at={timeout_at}")
print(f"  [{ts()}] threading.Thread heartbeat iniciado (intervalo=60s)")

# 2. Heartbeat thread
# NOTA: En simulación usa timeout=3s; en producción (run_etl.py) es 60s.
# Ver H-JOB-003: heartbeat_at=NULL cuando SP termina en <3s con datos de seed.
heartbeat_ticks = []
stop_event = threading.Event()


def heartbeat(run_id, stop_event):
    while not stop_event.wait(timeout=3):   # 3s en simulación (60s en producción)
        try:
            query(
                f"UPDATE etl_runs SET heartbeat_at=NOW() "
                f"WHERE id={run_id} AND status='en_ejecucion'"
            )
            timed_out = query(
                f"SELECT COUNT(*) FROM etl_runs "
                f"WHERE id={run_id} AND status='en_ejecucion' AND timeout_at < NOW()"
            )
            hb_val = query(f"SELECT TIME(heartbeat_at) FROM etl_runs WHERE id={run_id}")
            heartbeat_ticks.append(hb_val)
            if timed_out == "1":
                query(
                    f"UPDATE etl_runs SET status='timeout', fin_at=NOW(), "
                    f"error_message='Sin respuesta > 30 min' "
                    f"WHERE id={run_id} AND status='en_ejecucion' AND timeout_at < NOW()"
                )
        except Exception:
            pass


hb_thread = threading.Thread(target=heartbeat, args=(run_id, stop_event), daemon=True)
hb_thread.start()

# 3. Ejecutar SP (replica _ejecutar_sp de run_etl.py)
print(f"  [{ts()}] callproc('sp_etl_maestro', []) ...")
t0 = time.time()
try:
    query("CALL sp_etl_maestro()")
    final_status = "success"
    print(f"  [{ts()}] sp_etl_maestro completado en {time.time()-t0:.1f}s")
except Exception as e:
    final_status = "failed"
    print(f"  [{ts()}] ERROR: {e}")
finally:
    # 4. UPDATE etl_runs en finally (replica _update_run de run_etl.py)
    stop_event.set()
    query(
        f"UPDATE etl_runs SET status='{final_status}', fin_at=NOW() "
        f"WHERE id={run_id}"
    )

time.sleep(1)

print(f"\n  Heartbeat ticks registrados: {len(heartbeat_ticks)}")
for i, t in enumerate(heartbeat_ticks, 1):
    print(f"    tick {i}: heartbeat_at={t}")

print(f"\n  Estado final etl_runs id={run_id}:")
row = query(
    f"SELECT trimestre, inicio_at, fin_at, heartbeat_at, status, trigger_source "
    f"FROM etl_runs WHERE id={run_id}"
)
print(f"    {row}")


# ---------------------------------------------------------------------------
# ESCENARIO C — Protección de concurrencia
# ---------------------------------------------------------------------------
header("ESCENARIO C — Protección de concurrencia (RUNNING → SKIP)")
print("  Si hay un maestro RUNNING en las últimas 6 horas,")
print("  sp_etl_maestro inserta SKIP y no procesa nada.\n")

query(
    "INSERT INTO job_execution_log "
    "  (job_name, quarter_name, step_name, tabla_origen, "
    "   status, start_time, ejecutado_por) "
    "VALUES ('etl_diario','Q02_26','maestro','tbl_historico_t2_2026',"
    "        'RUNNING', NOW(), 'test_concurrencia')"
)
fake_id = query("SELECT MAX(id) FROM job_execution_log")
print(f"  [{ts()}] Insertado RUNNING fake en job_execution_log (id={fake_id})")
print(f"  [{ts()}] CALL sp_etl_maestro() — debería hacer SKIP ...")

before = int(query("SELECT COUNT(*) FROM job_execution_log"))
query("CALL sp_etl_maestro()")
after  = int(query("SELECT COUNT(*) FROM job_execution_log"))

skip_row = query(
    "SELECT step_name, status, error_message "
    "FROM job_execution_log ORDER BY id DESC LIMIT 1"
)
print(f"  [{ts()}] job_execution_log: {before} → {after} (+{after-before})")
print(f"  Última fila: {skip_row}")

query(f"DELETE FROM job_execution_log WHERE id={fake_id}")
print(f"\n  RUNNING fake eliminado (id={fake_id}) — entorno limpio")


# ---------------------------------------------------------------------------
# ESCENARIO D — Job deshabilitado
# ---------------------------------------------------------------------------
header("ESCENARIO D — job_config.is_enabled = 0 (job deshabilitado)")
print("  Simula mantenimiento o parada planificada del ETL.\n")

query("UPDATE job_config SET is_enabled=0 WHERE job_name='etl_diario'")
print(f"  [{ts()}] job_config: etl_diario.is_enabled = 0")
print(f"  [{ts()}] CALL sp_etl_maestro() — debería hacer SKIP ...")

before = int(query("SELECT COUNT(*) FROM job_execution_log"))
query("CALL sp_etl_maestro()")
after  = int(query("SELECT COUNT(*) FROM job_execution_log"))

skip_row = query(
    "SELECT step_name, status "
    "FROM job_execution_log ORDER BY id DESC LIMIT 1"
)
print(f"  [{ts()}] job_execution_log: {before} → {after} (+{after-before})")
print(f"  Última fila: {skip_row}")

query("UPDATE job_config SET is_enabled=1 WHERE job_name='etl_diario'")
print(f"\n  [{ts()}] job_config: etl_diario.is_enabled = 1 (restaurado)")


# ---------------------------------------------------------------------------
# ESCENARIO E — Detección de timeout por heartbeat
# ---------------------------------------------------------------------------
header("ESCENARIO E — Heartbeat detecta timeout (SP colgado > 30 min)")
print("  Simula un SP que supera el timeout de 30 minutos.\n")

query(
    "INSERT INTO etl_runs "
    "  (trimestre, inicio_at, timeout_at, status, trigger_source) "
    "VALUES ('Q02_26', "
    "        DATE_SUB(NOW(), INTERVAL 35 MINUTE), "
    "        DATE_SUB(NOW(), INTERVAL 5 MINUTE), "
    "        'en_ejecucion', 'test_timeout')"
)
stuck_id = query("SELECT MAX(id) FROM etl_runs")
print(f"  Insertado etl_runs id={stuck_id}:")
print(f"    inicio_at  = NOW() - 35 min")
print(f"    timeout_at = NOW() - 5 min  ← ya expiró")
print(f"    status     = 'en_ejecucion' ← parece colgado")

print(f"\n  [{ts()}] Heartbeat tick — detectando timeout_at < NOW() ...")
timed_out = query(
    f"SELECT COUNT(*) FROM etl_runs "
    f"WHERE id={stuck_id} AND status='en_ejecucion' AND timeout_at < NOW()"
)
print(f"  timeout_at < NOW(): {timed_out == '1'}")

if timed_out == "1":
    query(
        f"UPDATE etl_runs SET status='timeout', fin_at=NOW(), "
        f"error_message='Sin respuesta > 30 min' "
        f"WHERE id={stuck_id} AND status='en_ejecucion' AND timeout_at < NOW()"
    )

final_state = query(
    f"SELECT status, error_message FROM etl_runs WHERE id={stuck_id}"
)
print(f"  [{ts()}] etl_runs id={stuck_id} → {final_state}")


# ---------------------------------------------------------------------------
# RESUMEN FINAL
# ---------------------------------------------------------------------------
header("ESTADO FINAL DEL SISTEMA")

print("\n  job_execution_log — checkpoints recientes (últimas 10 filas):")
rows = query(
    "SELECT id, job_name, quarter_name, step_name, status, "
    "records_procesados, duracion_seg "
    "FROM job_execution_log ORDER BY id DESC LIMIT 10"
).split("\n")
for r in rows:
    print(f"    {r}")

print("\n  etl_runs — todos los registros:")
rows = query(
    "SELECT id, trimestre, TIME(inicio_at), TIME(fin_at), "
    "heartbeat_at IS NOT NULL AS tiene_hb, "
    "status, trigger_source "
    "FROM etl_runs ORDER BY id"
).split("\n")
for r in rows:
    print(f"    {r}")

print("\n  base_ivr_detalle — totales por quarter:")
rows = query(
    "SELECT trimestre, COUNT(*) AS filas, SUM(total_llamadas) AS llamadas "
    "FROM base_ivr_detalle GROUP BY trimestre ORDER BY trimestre"
).split("\n")
for r in rows:
    print(f"    {r}")

print("\n  job_config — estado final:")
rows = query(
    "SELECT job_name, is_enabled, timeout_seconds FROM job_config"
).split("\n")
for r in rows:
    print(f"    {r}")

print(f"\n{SEP}")
print("  Simulación completada")
print(SEP)
