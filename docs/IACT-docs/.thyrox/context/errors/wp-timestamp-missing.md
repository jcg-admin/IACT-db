```yml
id: ERR-025
created_at: 2026-03-28
type: Inconsistencia en naming
severity: Media
status: Detectado
```

# ERR-025: Work packages creados sin timestamp completo

## Qué pasó

Al crear el work package para skill-testing, usé `2026-03-28-100000-skill-testing/` con timestamp inventado (100000) en vez del timestamp real YYYY-MM-DD-HH-MM-SS.

Lo mismo pasó con `2026-03-28-093000-skill-rewrite/` — el 093000 fue estimado, no real.

## Por qué es un error

El SKILL.md y CLAUDE.md dicen: `context/work/YYYY-MM-DD-HH-MM-SS-nombre/`. La sesión anterior (ERR de los work packages) se corrigió usando timestamps reales de git. Pero en esta sesión volví al hábito de inventar timestamps.

## Causa raíz

No tengo un mecanismo para capturar el timestamp real al momento de crear el directorio. Debería usar `date +%Y-%m-%d-%H-%M-%S` en el momento de creación.

## Qué hacer próxima vez

Antes de `mkdir`, capturar el timestamp real:
```bash
TS=$(date +%Y-%m-%d-%H-%M-%S)
mkdir -p context/work/${TS}-nombre/
```
