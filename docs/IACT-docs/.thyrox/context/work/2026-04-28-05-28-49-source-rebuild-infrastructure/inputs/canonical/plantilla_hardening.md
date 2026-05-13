---
id: PLANTILLA-INFRA-HARDENING
estado: pendiente
responsable: definir
fecha: 2025-11-18
version: 1.0.0
trazabilidad:
  tareas: ["TASK-INFRA-QA-002"]
  adrs: []
---

# Checklist de hardening

## Alcance
Asegurar controles de seguridad mínimos en sistemas operativos, contenedores y redes antes de exponer servicios.

## Checklist base
- [ ] Aplicar baseline CIS o equivalente al sistema operativo.
- [ ] Endurecimiento de contenedores: imágenes minimalistas, usuario no root, escaneo de vulnerabilidades.
- [ ] Políticas de red: segmentación, listas de control, cifrado en tránsito y en reposo.
- [ ] Gestión de secretos: rotación y acceso auditado.
- [ ] Validación de cumplimiento automatizada (por ejemplo, `./scripts/validate_security_config.sh`).

## Evidencias esperadas
- Reportes de escaneo con fecha y versión de imagen.
- Registro de desviaciones y remediaciones en `qa/registros/`.
- Resultados de validación automática adjuntos a la tarea activa.

## Validaciones automáticas
- Ejecutar `./scripts/validate_security_config.sh` y anexar resultados.
- Incluir pruebas de configuración en pipelines con cobertura mínima de 80%.

## Trazabilidad
- Documentar excepciones en ADRs y enlazar con `qa/tareas_activas.md`.
- Mantener históricos en `qa/registros/` para auditorías.
