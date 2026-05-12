"""
Perfil Q04_2025 — Octubre a Diciembre 2025

PROXY de q03_2025 — no hay datos reales de Q04.
Usa la distribución acumulada de Q01+Q02+Q03 (el estado más reciente conocido).
Escala estimada: promedio Q01+Q03 (sin Q02 que es el pico).
"""
from datetime import date
from perfiles.q03_2025 import MENUS, VDN_POR_MENU  # noqa: F401 — re-exportado por perfiles/__init__.py

# Declarar re-exportación explícita (suprime F401 en pyflakes puro y documentar intención).
# perfiles/__init__.py importa MENUS y VDN_POR_MENU desde este módulo proxy.
__all__ = ["MENUS", "VDN_POR_MENU"]

CONFIG = {
    'tabla':       'tbl_historico_t4_2025',
    'quarter':     'Q04_25',
    'fecha_ini':   date(2025, 10, 1),
    'fecha_fin':   date(2025, 12, 31),
    'escala':      1.069,   # SUPUESTO: Q4 incluye Nov-Dic con pico comercial.
                            # Nov=dia del trabajo, Dic=campanas fin de anio.
                            # +8% sobre Q03_25 (0.986 x 1.084 = 1.069).
                            # Sin datos reales — proxy q03_2025 con volumen ajustado.
    'error_ceros': True,
}
