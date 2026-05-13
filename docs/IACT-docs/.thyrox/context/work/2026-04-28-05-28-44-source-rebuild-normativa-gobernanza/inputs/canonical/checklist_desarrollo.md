---
title: Checklist de desarrollo
date: 2025-11-13
domain: gobernanza
status: active
---

# Checklist de desarrollo

## Calidad de Código
- [ ] Pruebas unitarias creadas antes del código (TDD).
- [ ] Cobertura mínima 80% alcanzada.
- [ ] Docstrings en español y formato Google/NumPy.
- [ ] Type hints en funciones públicas (Python).
- [ ] Linters ejecutados sin errores (Black, Flake8, Pylint).
- [ ] Referencia a ADRs relevantes.

## Output Profesional (Regla Fundamental)
- [ ] Scripts NO usan emojis en output (OKNOWARNINGSTART etc.).
- [ ] Se usan prefijos estándar: [INFO], [ERROR], [WARN], [SUCCESS].
- [ ] Separadores usan caracteres ASCII estándar (-, =, _).
- [ ] Logs son parseables con herramientas estándar (grep, awk).

## Documentación
- [ ] Actualización de documentación técnica.
- [ ] README actualizado si aplica.
- [ ] Comentarios de código claros y concisos.

## Recursos
- Ver: [Estándares de Código](../gobernanza/estandares_codigo.md)
