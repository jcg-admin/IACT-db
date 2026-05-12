# Hallazgos — Ejecución FASE 9 (Plan corrección bugs CNST-003)

**Versión:** 1.0.0  
**Fecha:** 2026-05-12  
**Plan de referencia:** `PLAN-CORRECCION-BUGS-CNST003-202605120300.md` FASE 9  
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Resultado de las tareas

| Tarea | Descripción | Estado | Hallazgo detectado |
|---|---|---|---|
| T-9.1 | `poblar_historico.py` — eliminar `f` en 4 f-strings (BUG-010) | COMPLETO | — |
| T-9.1 ext. | `poblar_historico.py` — eliminar `import date` sin uso (no en el plan) | COMPLETO | H-F9-001 |
| T-9.2 | Perfiles proxy — `__all__` + `# noqa: F401` (BUG-011) | COMPLETO | H-F9-002 |
| T-9.3 | Verificación pyflakes limpio en todos los archivos | PASA | — |

---

## H-F9-001 — `poblar_historico.py` tiene un import sin uso no contemplado en el plan

**Detectado en:** T-9.1, durante la ejecución de pyflakes antes de aplicar cualquier cambio  
**Severidad:** BAJA — import muerto que confunde al lector  
**Estado:** RESUELTO en T-9.1

### Descripción

La ejecución de `python3 -m pyflakes provisioners/mariadb/poblar_historico.py` antes
de cualquier cambio produjo cinco advertencias, no cuatro como documentaba el plan:

```
poblar_historico.py:86:1: 'datetime.date' imported but unused
poblar_historico.py:408:15: f-string is missing placeholders
poblar_historico.py:415:15: f-string is missing placeholders
poblar_historico.py:504:11: f-string is missing placeholders
poblar_historico.py:557:19: f-string is missing placeholders
```

La quinta advertencia (`'datetime.date' imported but unused`) no estaba en el
catálogo de bugs del plan.

**Análisis:** La línea 86 es:

```python
from datetime import date, datetime, timedelta
```

Se buscaron todos los usos del nombre `date` en el archivo:
- `datetime(fecha.year, fecha.month, fecha.day)` en L180 usa `datetime`, no `date`
- No existe ningún `date(...)`, ni anotación `: date`, ni comparación `isinstance(..., date)`

pyflakes tiene razón: `date` está importado y nunca se usa en el módulo. Los
perfiles en `perfiles/` tienen su propio `from datetime import date` independiente.

**Corrección:**

```python
# Antes:
from datetime import date, datetime, timedelta

# Después:
from datetime import datetime, timedelta
```

La corrección es segura: eliminar `date` del import de `poblar_historico.py`
no afecta a ningún perfil ni a ningún otro archivo, ya que cada perfil importa
`date` directamente desde `datetime`.

---

## H-F9-002 — `# noqa: F401` no suprime warnings en pyflakes puro; requiere `__all__`

**Detectado en:** T-9.2, durante la verificación con pyflakes después de aplicar `# noqa`  
**Severidad:** ALTA — el fix del plan era incorrecto para la herramienta real disponible  
**Estado:** RESUELTO en T-9.2 con `__all__` + `# noqa`

### Descripción

El plan de FASE 9 propuso `# noqa: F401` como corrección para los imports sin
uso en los perfiles proxy (`q01_2026.py`, `q02_2026.py`, `q04_2025.py`).

Después de aplicar los `# noqa: F401`, `python3 -m pyflakes` siguió reportando
exactamente los mismos warnings. La investigación reveló la causa:

**`# noqa` es una directiva de `flake8`, no de `pyflakes`.**

- `pyflakes` (standalone): ignora completamente los comentarios `# noqa`
- `flake8` (que envuelve pyflakes): procesa `# noqa` y suprime las advertencias
- `ruff`: procesa `# noqa` y también las suprime

`flake8` no está instalado en el entorno de desarrollo. La verificación del plan
con `python3 -m pyflakes` no puede validar que `# noqa` funcione.

### Patrón proxy — por qué pyflakes reporta falso positivo

Los tres archivos implementan el patrón "módulo proxy": no declaran propios los
nombres `MENUS` y `VDN_POR_MENU`, sino que los re-exportan para que
`perfiles/__init__.py` pueda importarlos con alias:

```python
# q01_2026.py:
from perfiles.q01_2025 import MENUS, VDN_POR_MENU  # ← importados aquí

# perfiles/__init__.py:
from perfiles.q01_2026 import MENUS as M_Q01_26, VDN_POR_MENU as V_Q01_26  # ← usados aquí
```

pyflakes analiza cada módulo de forma aislada. Dentro de `q01_2026.py`, `MENUS`
y `VDN_POR_MENU` no se usan en ninguna expresión — la re-exportación a través
de `__init__.py` es invisible para el análisis estático de un solo archivo.

### Solución: `__all__`

`__all__` es la convención Python estándar para declarar qué nombres un módulo
exporta públicamente. Cuando un módulo define `__all__`, pyflakes considera que
los nombres en `__all__` que fueron importados están siendo "usados" en el
contexto de la interfaz pública del módulo:

```python
from perfiles.q01_2025 import MENUS, VDN_POR_MENU  # noqa: F401 — re-exportado por perfiles/__init__.py

# Declarar re-exportación explícita (suprime F401 en pyflakes puro y documentar intención).
# perfiles/__init__.py importa MENUS y VDN_POR_MENU desde este módulo proxy.
__all__ = ["MENUS", "VDN_POR_MENU"]
```

Verificado empíricamente: con `__all__`, `python3 -m pyflakes` retorna 0
advertencias sin necesidad de `flake8`.

**Ventajas adicionales de `__all__` sobre solo `# noqa`:**

- pyflakes puro lo reconoce directamente
- IDEs (PyCharm, VSCode) usan `__all__` para el autocompletado y las advertencias de importación
- mypy usa `__all__` para verificar que los imports re-exportados son intencionales
- Documenta explícitamente la interfaz pública del módulo proxy
- `# noqa: F401` se mantiene como comentario aclaratorio para linters que sí lo procesan

### Impacto en los imports existentes

Agregar `__all__` a un módulo no afecta los imports ya existentes con nombres
explícitos (`from perfiles.q01_2026 import MENUS as M_Q01_26`). Solo afectaría
a `from perfiles.q01_2026 import *`, que no se usa en ningún archivo del proyecto.

Verificado:
```
Perfiles: ['Q01_25', 'Q02_25', 'Q03_25', 'Q04_25', 'Q01_26', 'Q02_26']
Q01_26 tabla: tbl_historico_t1_2026
Q01_26 menus len: 44
```

---

## Cambios implementados

### `poblar_historico.py` — T-9.1

| Línea | Antes | Después |
|---|---|---|
| L86 | `from datetime import date, datetime, timedelta` | `from datetime import datetime, timedelta` |
| L408 | `print(f"  Sin menús quitados")` | `print("  Sin menús quitados")` |
| L415 | `print(f"  Sin cambios de VDN")` | `print("  Sin cambios de VDN")` |
| L504 | `print(f"  poblar_historico.py")` | `print("  poblar_historico.py")` |
| L557 | `print(f"    TRUNCATE ejecutado")` | `print("    TRUNCATE ejecutado")` |

### `perfiles/q01_2026.py`, `perfiles/q02_2026.py`, `perfiles/q04_2025.py` — T-9.2

```python
# Antes (solo comentario, no suprime pyflakes puro):
from perfiles.qXX_20YY import MENUS, VDN_POR_MENU  # referencia al base

# Después (noqa para flake8/ruff + __all__ para pyflakes puro):
from perfiles.qXX_20YY import MENUS, VDN_POR_MENU  # noqa: F401 — re-exportado por perfiles/__init__.py

# Declarar re-exportación explícita (suprime F401 en pyflakes puro y documentar intención).
# perfiles/__init__.py importa MENUS y VDN_POR_MENU desde este módulo proxy.
__all__ = ["MENUS", "VDN_POR_MENU"]
```

---

## Verificación funcional

```
pyflakes poblar_historico.py: limpio (0 advertencias)
pyflakes perfiles/: limpio (0 advertencias)
py_compile poblar_historico.py: OK
py_compile q01_2026.py, q02_2026.py, q04_2025.py: OK
Todos los perfiles válidos: ['Q01_25', 'Q02_25', 'Q03_25', 'Q04_25', 'Q01_26', 'Q02_26']
verify.sh: 27 OK, 0 WARN, 0 ERR
```

---

## Estado de los bugs del plan tras FASE 9

| Bug | Descripción | Estado |
|---|---|---|
| BUG-010 | `poblar_historico.py` — 4 f-strings sin placeholders | RESUELTO — T-9.1 |
| BUG-010 ext. | `poblar_historico.py` — `import date` sin uso (no en el plan) | RESUELTO — T-9.1 |
| BUG-011 | Perfiles proxy — `imported but unused` | RESUELTO — T-9.2 (`__all__` + `# noqa`) |
