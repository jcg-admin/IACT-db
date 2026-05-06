# Análisis de grafo de dependencias — ETL IVR Pipeline v2.0

**Fecha:** 2026-05-06
**Nodos:** 47 | **Aristas:** 74 | **Niveles:** 7

---

## Estructura del grafo

```
Nivel 0        Nivel 1         Nivel 2         Nivel 3        Nivel 4        Nivel 5a       Nivel 5b       Nivel 6
(fuentes)      (funciones)     (tablas)        (ETL SPs)      (RPT SPs)      (Dj servicios) (Dj vistas)    (schedulers)

6 nodos        7 nodos         5 nodos         5 nodos        7 nodos        6 nodos        9 nodos        2 nodos
read-only      utilidad        IACT-owned      pipeline       reporte        services+cmd   views          disparadores
```

Los aristas van del nodo DEPENDIENTE al nodo DEL QUE DEPENDE.
Seguir una arista hacia la izquierda muestra qué necesita un nodo.
Seguir aristas hacia la derecha muestra qué usa un nodo.

---

## Métricas por nodo

| Nodo | Tipo | Entradas | Salidas | Total | Impacto si falla |
|---|---|---|---|---|---|
| `services/ivr_reports.py` | dj_svc | 7 | 8 | **15** | 9 nodos |
| `sp_etl_base_detalle` | sp_etl | 2 | 12 | **14** | 8 nodos |
| `sp_etl_base_clientes` | sp_etl | 2 | 9 | **11** | 8 nodos |
| `base_ivr_detalle` | tbl_base | 8 | 0 | **8** | **22 nodos** |
| `sp_etl_maestro` | sp_etl | 2 | 6 | **8** | 8 nodos |
| `sp_rpt_centros_xsegmento` | sp_rpt | 1 | 5 | **6** | 2 nodos |
| `job_execution_log` | tbl_ctrl | 5 | 0 | **5** | **10 nodos** |
| `services/ivr_pipeline.py` | dj_svc | 2 | 3 | **5** | 4 nodos |
| `run_etl command` | dj_cmd | 2 | 3 | **5** | 4 nodos |
| `ivr_es_dia_habil` | fn_base | 4 | 0 | **4** | **18 nodos** |

---

## Top 5 nodos por impacto de fallo

El impacto se calcula como BFS hacia arriba (¿cuántos nodos dejan de funcionar si este falla?):

### 1. base_ivr_detalle — 22 nodos afectados

Es el nodo con mayor impacto de todo el grafo. Recibe escrituras de
dos SPs ETL (`sp_etl_base_detalle`, `sp_etl_validar`) y es leído por
6 SPs de reporte más `sp_etl_validar`. Si `base_ivr_detalle` está
corrupta o vacía, los 7 SPs de reporte fallan, los 7 servicios Django
que los llaman fallan, las 7 vistas DRF fallan, y los 7 endpoints HTTP
retornan error.

```
base_ivr_detalle
    → sp_etl_validar
    → sp_rpt_cen, sp_rpt_aba, sp_rpt_men, sp_rpt_mce, sp_rpt_err, sp_rpt_seg
        → dj_svc_rpt (llama a los 6)
            → dj_view_cli..dj_view_seg (7 vistas)
    → sp_rpt_centros_xsegmento
        → dj_view_seg
```

**Mitigación:** El ETL usa `ON DUPLICATE KEY UPDATE` y `DELETE` por mes
antes de insertar. Un fallo a mitad no corrompe datos anteriores —
hace ROLLBACK al estado previo.

---

### 2. ivr_es_dia_habil — 18 nodos afectados

Función raíz de la cadena de días hábiles. Si esta función retorna
resultados incorrectos (por ejemplo, un festivo no catalogado), el error
se propaga silenciosamente a:
- `ivr_contar_dias_habiles` y `ivr_agregar_dias_habiles`
- `sp_etl_base_detalle` (columnas `llamadas_dias_habiles` erróneas)
- `sp_rpt_centros_xsegmento` (clasificación SLA incorrecta)
- Todos los endpoints que consumen `sp_rpt_centros_xsegmento`

A diferencia de un fallo de conectividad, este error es **silencioso**:
las queries retornan datos con clasificaciones SLA incorrectas sin
lanzar excepciones.

---

### 3. base_ivr_clientes — 17 nodos afectados

Solo 3 filas por quarter, pero si están vacías o incorrectas:
- `sp_etl_validar` falla (check de 3 filas esperadas)
- `sp_rpt_clientes` retorna vacío
- `sp_etl_maestro` reporta `status='PARTIAL'`
- `ETLEstadoView` muestra estado de error

---

### 4. IVRRouter — 12 nodos afectados

Si el router de Django no enruta correctamente a la BD `'ivr'`, todas
las llamadas a `connections['ivr'].cursor()` fallan. El motor `_call_sp()`
falla, y con él los 7 servicios de reporte y sus vistas.

---

### 5. _call_sp() — 11 nodos afectados

Motor común de todos los servicios de reporte. Un bug en este método
(por ejemplo, manejo incorrecto de `cursor.description` cuando el SP
retorna vacío) afecta los 7 servicios y sus 7 vistas.

---

## Nodos raíz (sin dependencias externas)

Estos nodos no dependen de ningún otro nodo del sistema. Son los
puntos de entrada del grafo:

| Nodo | Tipo | Camino más largo hasta hoja |
|---|---|---|
| `AbandonadasView` | dj_view | 4 niveles |
| `CentrosView` | dj_view | 4 niveles |
| `ClientesView` | dj_view | 4 niveles |
| `CMENUErrorView` | dj_view | 4 niveles |
| `MenuCentroView` | dj_view | 4 niveles |
| `MenuRedirigidosView` | dj_view | 4 niveles |
| `ETLReintentarView` | dj_view | 4 niveles |
| `CentrosXSegmentoView` | dj_view | 4 niveles |
| `ETLEstadoView` | dj_view | 3 niveles |
| `APScheduler` | scheduler | 4 niveles |
| `evt_etl_diario` | scheduler | 3 niveles |
| `sp_etl_historico` | sp_etl | 2 niveles |

---

## Nodos hoja (sin dependientes — no son usados por nadie)

Estos nodos son los más fundamentales. Ningún otro nodo del sistema
los usa como entrada. Son las fuentes de datos o los conceptos base:

```
tbl_historico_t1_2025 .. tbl_historico_t2_2026  (datos crudos del cliente)
fn_normalizar_menu    (usada solo por sp_etl_base_detalle)
fn_normalizar_centro  (usada solo por sp_etl_base_detalle)
fn_duracion_seg       (usada solo por sp_rpt_centros_xsegmento)
job_config            (leída solo por sp_etl_maestro)
IVRRouter             (configurado solo por _call_sp)
base_ivr_detalle      (escrita por ETL, leída por 6 SPs)
base_ivr_clientes     (escrita por ETL, leída por 1 SP)
job_execution_log     (escrito por 3 SPs, leído por ivr_pipeline.py)
etl_runs              (escrito por 2 componentes, leído por ivr_pipeline.py)
```

---

## Tipos de aristas y su distribución

| Tipo | Count | Descripción | Color |
|---|---|---|---|
| `reads` | 14 | SP lee tabla (SELECT) | azul discontinuo |
| `writes` | 10 | SP escribe tabla (INSERT/UPDATE/DELETE) | rojo sólido |
| `calls` | 12 | SP llama a otro SP | verde sólido |
| `uses_fn` | 13 | SP usa función de utilidad | teal discontinuo |
| `fn_uses_fn` | 2 | Función llama a otra función | teal largo discontinuo |
| `triggers` | 4 | Scheduler/vista dispara un componente | ámbar grueso |
| `http` | 9 | Vista Django llama a servicio | morado discontinuo |
| `cfg` | 1 | Componente depende de configuración | gris |
| **Total** | **74** | | |

---

## Cadenas críticas de dependencia

### Cadena ETL principal (ruta más larga)
```
evt_etl_diario
  → sp_etl_maestro
    → sp_etl_base_detalle
      → [fn_did_segmento, fn_normalizar_menu, fn_normalizar_centro, ivr_es_dia_habil]
      → [tbl_historico_t1_2025 .. tbl_historico_t2_2026]  (lee)
      → base_ivr_detalle  (escribe)
      → job_execution_log (escribe)
```

### Cadena de reporte SLA (la más compleja)
```
CentrosXSegmentoView
  → services/ivr_reports.py
    → _call_sp()
      → IVRRouter
    → sp_rpt_centros_xsegmento
      → base_ivr_detalle
      → [ivr_es_dia_habil → ivr_contar_dias_habiles]
      → [ivr_es_dia_habil → ivr_agregar_dias_habiles]
      → fn_duracion_seg
```
Esta cadena toca 11 nodos distintos — la más larga del sistema.

### Cadena de reintento manual
```
ETLReintentarView
  → services/ivr_pipeline.py → etl_runs (escribe)
  → run_etl command
    → sp_etl_maestro (misma cadena que arriba)
    → etl_runs (escribe)
    → heartbeat_thread → etl_runs (escribe si timeout)
```

---

## Implicaciones para el orden de implementación

El grafo confirma el orden de PLAN-IMPLEMENTACION.md:

1. Las **funciones de utilidad** (Nivel 1) no dependen de nada del sistema.
   Son seguras de crear primero en cualquier entorno.

2. Las **tablas** (Nivel 2) no dependen de las funciones para su DDL,
   pero los SPs que las usan sí. El DDL puede crearse en paralelo con
   las funciones.

3. Los **SPs ETL** (Nivel 3) requieren funciones + tablas. No se puede
   crear `sp_etl_base_detalle` sin `fn_did_segmento`.

4. Los **SPs de reporte** (Nivel 4) solo requieren que `base_ivr_detalle`
   exista. No necesitan datos para crearse — solo para ser llamados.

5. La **capa Django** (Nivel 5) puede desarrollarse en paralelo con los
   SPs, pero solo puede testearse end-to-end cuando los SPs tienen datos.

6. Los **schedulers** (Nivel 6) deben configurarse al final, cuando todo
   lo demás está verificado.

---

## Ver también

- `FLUJO-ETL-V2.md` — arquitectura que este grafo describe
- `PLAN-IMPLEMENTACION.md` — 58 tareas en 6 fases
- `ANALISIS-ARQUITECTURA-ETL.md` — problemas que motivaron el diseño

