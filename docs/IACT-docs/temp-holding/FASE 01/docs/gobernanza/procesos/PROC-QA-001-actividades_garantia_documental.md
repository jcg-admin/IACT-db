---
id: PROC-QA-001
tipo: proceso
categoria: qa
subcategoria: garantia-documental
estado: activo
version: 1.0.0
fecha_creacion: 2025-02-19
autor: lider-qa
relacionados: ["PROC-007", "GUIA-002"]
---
# Actividades de control documental

Plan operativo para asegurar que las reglas de documentación, requisitos y casos de uso se apliquen de forma consistente en todo el repositorio.

## Página padre
- [`readme.md`](readme.md)

## Objetivos
- Garantizar que cada modificación en `docs/` pase por revisiones estructuradas.
- Confirmar el uso de plantillas oficiales para requisitos, casos de uso y matrices.
- Mantener trazabilidad completa entre reglas de negocio, requisitos, casos de uso y pruebas.

## Actividades recurrentes
### 1. Revisión de calidad editorial
- Ejecutar el checklist corporativo descrito en [`../documentacion_corporativa.md`](../documentacion_corporativa.md) antes de aprobar un cambio.
- Validar que los documentos incluyan secciones de limitaciones y distinción explícita entre QUÉ y CÓMO.
- Registrar hallazgos en la bitácora de QA si se detectan incumplimientos.

### 2. Verificación de estructura y plantillas
- Confirmar que las nuevas entradas utilicen plantillas de [`../plantillas/`](../plantillas/) según el tipo de artefacto.
- Revisar que cada caso de uso documente precondiciones, flujos y excepciones con la nomenclatura UC-XXX.
- Escalar al equipo de producto cuando falten campos obligatorios en requisitos o casos de uso.

### 3. Auditoría de trazabilidad
- Actualizar [`../requisitos/trazabilidad.md`](../requisitos/trazabilidad.md) con cualquier relación nueva entre reglas, requisitos, casos de uso y pruebas.
- Verificar que la cadena RN → N → RB → RS → UC → RF → TEST esté completa para cada iniciativa en curso.
- Programar una revisión cruzada semanal con producto y arquitectura para cerrar brechas detectadas.

## Actividades por entrega
| Momento | Responsables | Acción | Evidencia |
| --- | --- | --- | --- |
| Inicio de iteración | Producto + QA | Revisar backlog y asegurar que cada requisito tenga plantilla base completada. | Notas en ritual de planificación. |
| Durante desarrollo | QA | Corroborar que los casos de uso reflejen reglas de negocio activas y generen requisitos funcionales claros. | Comentarios en pull requests. |
| Pre-cierre | QA + Arquitectura | Ejecutar auditoría de trazabilidad y documentar ajustes. | Actualización firmada en `trazabilidad.md`. |
| Post-cierre | QA | Publicar resumen de hallazgos y acciones correctivas. | Entrada en `qa/registros/`. |

## Métricas de seguimiento
| Métrica | Objetivo | Fuente |
| --- | --- | --- |
| Revisiones documentales cumplidas | 100 % de los cambios en `docs/` | Historial de PR y checklist QA. |
| Plantillas utilizadas sin modificaciones estructurales | ≥ 95 % | Auditoría mensual del repositorio. |
| Cadena de trazabilidad completa | 100 % de iniciativas activas | [`../requisitos/trazabilidad.md`](../requisitos/trazabilidad.md). |

## Procedimiento de escalamiento
1. Registrar el incumplimiento en la bitácora de QA.
2. Notificar al responsable del documento mediante comentario en PR.
3. Programar reunión de ajuste si el bloqueo persiste por más de dos días hábiles.
4. Actualizar la matriz de trazabilidad con el resultado final.

## Histórico de revisiones
- **2025-02-19:** Documento inicial que formaliza actividades de control documental coordinadas por QA.
