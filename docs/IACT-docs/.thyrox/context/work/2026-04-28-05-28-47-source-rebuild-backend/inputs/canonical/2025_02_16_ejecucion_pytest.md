---
id: QA-LOG-20250216
estado: en-progreso
propietario: equipo-qa
ultima_actualizacion: 2025-02-16
relacionados: ["DOC-QA-001"]
date: 2025-11-13
---
# Registro de ejecución de pruebas - 16 feb 2025

## Contexto
- **Suite:** `pytest`
- **Ubicación del proyecto:** `api/callcentersite`
- **Objetivo:** Confirmar estado de la suite automática posterior a los cambios del runbook y scripts de Codespaces.

## Preparación
1. Crear entorno virtual local (`python -m venv .venv`).
2. Activar entorno virtual (`source .venv/bin/activate`).
3. Instalar dependencias de pruebas (`pip install -r api/callcentersite/requirements/test.txt`).

## Resultado
- El paso 3 falló de forma repetida. `pip` intentó descargar `Django<5.3,>=5.2` desde `https://pypi.org/simple/`, pero el entorno devuelve `403 Forbidden` al atravesar el proxy corporativo.
- Debido a la falta de dependencias críticas, no se ejecutó `pytest`.

### Evidencia del fallo
```
WARNING: Retrying ... Tunnel connection failed: 403 Forbidden
ERROR: Could not find a version that satisfies the requirement Django<5.3,>=5.2 (from versions: none)
ERROR: No matching distribution found for Django<5.3,>=5.2
```

## Acciones siguientes
- Escalar al equipo de redes para permitir tráfico HTTPS hacia `pypi.org` y `files.pythonhosted.org` desde el entorno de CI local.
- Registrar un rerun una vez confirmada la apertura de proxy.
- Considerar artifactory interno o mirror permitido como workaround temporal.
