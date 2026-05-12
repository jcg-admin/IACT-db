# `provisioners/mariadb/poblar_historico.py`

**Lenguaje:** Python 3  
**Dependencias:** PyMySQL, módulo local `perfiles/`

---

## Propósito

Genera datos sintéticos calibrados en las tablas `tbl_historico_tN_YYYY`.
Los datos replican las distribuciones reales de producción (distribución de
menús, DID, comportamiento de cTelefono, anomalías de cMenu, etc.) con
escalas ajustadas por quarter.

---

## Uso

```bash
python3 provisioners/mariadb/poblar_historico.py \
    --quarter Q02_26 \
    --rows 100000 \
    --chunk 5000 \
    [--truncate]

# Ver todos los quarters disponibles:
python3 provisioners/mariadb/poblar_historico.py --status
```

---

## Arquitectura

```
poblar_historico.py
  └── perfiles/            # perfiles por quarter
        ├── __init__.py    # PERFILES dict con todos los quarters
        ├── q01_2025.py    # Distribuciones base Q1 2025 (datos reales)
        ├── q02_2025.py    # Acumuladas Q1+Q2
        ├── q03_2025.py    # Acumuladas Q1+Q2+Q3
        ├── q04_2025.py    # Proxy de q03_2025 (sin datos reales Q4)
        ├── q01_2026.py    # Proxy de q01_2025 con escala +3.9%
        └── q02_2026.py    # Proxy de q02_2025, quarter parcial
```

---

## Perfiles proxy

`q04_2025.py`, `q01_2026.py` y `q02_2026.py` no tienen datos reales —
re-exportan distribuciones de quarters base con escala ajustada. Cada uno
declara `__all__ = ['MENUS', 'VDN_POR_MENU']` para documentar la
re-exportación y suprimir el warning F401 de pyflakes (FASE 9).

---

## Correcciones aplicadas (FASE 9)

- 4 f-strings sin placeholders → strings literales (BUG-010)
- `import date` sin uso → eliminado
- `__all__` en los 3 perfiles proxy (BUG-011)
