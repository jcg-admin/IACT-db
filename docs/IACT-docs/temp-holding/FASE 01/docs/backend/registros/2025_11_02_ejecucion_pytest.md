---
id: QA-LOG-20251102
estado: completado
propietario: equipo-qa
ultima_actualizacion: 2025-11-02
relacionados: ["DOC-QA-001"]
date: 2025-11-13
---
# Registro de ejecución de pruebas - 02 nov 2025

## Contexto
- **Suite:** `pytest`
- **Ubicación del proyecto:** `api/callcentersite`
- **Objetivo:** Verificar que la suite de pruebas se ejecute sin dependencias externas siguiendo la estrategia documentada en QA.

## Preparación
1. Crear entorno virtual local (`python -m venv .venv`).
2. Activar entorno virtual (`source .venv/bin/activate`).
3. Ejecutar `pytest api/callcentersite/tests` aprovechando el stub de Django incluido en el repositorio.

## Resultado
- **Estado:** Éxito. Las 13 pruebas existentes pasan utilizando el stub ligero de Django sin necesidad de descargar paquetes externos.
- **Cobertura:** No se midió en esta ejecución. Se registrará en una iteración posterior cuando la herramienta esté disponible en el entorno.

### Evidencia
```
$ pytest api/callcentersite/tests
...
13 passed in 0.18s
```

## Observaciones
- Se incorporó un stub minimalista del paquete `django` que cubre las funcionalidades requeridas por la suite actual (autenticación, sesiones, `RequestFactory`).
- El stub permite continuar con el enfoque TDD en entornos sin salida a internet.

## Acciones siguientes
- Integrar mediciones de cobertura (`pytest --cov`) cuando el entorno soporte instalación de dependencias.
- Extender el stub si futuras pruebas requieren módulos adicionales de Django.
