---
id: TEMPLATE-SPACE-DOC
estado: borrador
propietario: equipo-documentacion
ultima_actualizacion: 2025-02-18
relacionados: ["DOC-INDEX-GENERAL", "DOC-ROOT-001", "TEMPLATE-README-SPACE"]
---
# Plantilla para espacio documental

Esta plantilla permite replicar la estrategia utilizada en los espacios documentales del repositorio (por ejemplo, `docs/implementacion/infrastructure/`) para cualquier carpeta local que necesite mantenerse alineada con la base documental maestra de IACT. Usa este formato como punto de partida antes de poblar contenidos específicos.

## Instrucciones generales
1. Copia este archivo a la nueva carpeta del espacio y renómbralo como `readme.md`.
2. Ajusta el front matter con el identificador corporativo, propietario oficial y fecha de la última actualización.
3. Declara en `relacionados` los enlaces al espacio maestro o a documentos de sincronización.
4. Revisa que las rutas relativas a otros espacios funcionen tanto en GitHub como en MkDocs.

## Estructura recomendada de carpetas
- `readme.md`: portada con contexto, backlog y relaciones.
- `index.md`: opcional para publicar el árbol del espacio si existe un menú propio.
- Subcarpetas por cada categoría corporativa (p. ej. `meeting_and_discussion_notes/`, `task_report/`).
- Archivos auxiliares (`checklists`, `templates`, `evidences`) cuando el espacio maestro los utilice.

## Secciones sugeridas del contenido
### Rol del espacio
Explica el propósito del espacio y cómo se integra al flujo documental general.

### Árbol de páginas espejo
Lista las páginas del espacio maestro y mapea su equivalente local. Utiliza tablas con columnas `Página origen`, `Ubicación local` y `Estado`.

### Backlog de sincronización
| Identificador | Actividad | Responsable | Estado | Comentarios |
| --- | --- | --- | --- | --- |
| TODO-SYNC-001 | Validar jerarquía frente al repositorio corporativo | TODO-equipo | Pendiente | Ejecutar revisión mensual |
| TODO-SYNC-002 | Actualizar enlaces cruzados en MkDocs | TODO-equipo | Pendiente | Confirmar con equipo de documentación |

### Checklist operativo
- [ ] Confirmar que los metadatos del front matter coinciden con el espacio maestro.
- [ ] Actualizar `ultima_actualizacion` tras cada sincronización.
- [ ] Registrar hallazgos en `../gobernanza/backlog.md` u otro artefacto de gestión.

### Integraciones relevantes
Describe dependencias con otros espacios (`../gerencia/vision_y_alcance/`, `../qa/`, etc.) y qué información consumen o proveen.

## Ejemplo de front matter
```yaml
---
id: DOC-INFRA-INDEX
estado: vigente
propietario: equipo-infraestructura
ultima_actualizacion: 2025-02-18
relacionados:
  - "DOC-INDEX-GENERAL"
  - "DOC-GOB-BACKLOG"
---
```

## Buenas prácticas
- Mantén un registro de cambios en el backlog para facilitar auditorías.
- Incluye referencias cruzadas a plantillas y checklists reutilizables.
- Documenta decisiones relevantes mediante ADR y vincúlalos en `relacionados`.
- Asegura que cualquier nueva subcarpeta tenga su propio `readme.md` o índice.

## Próximos pasos sugeridos
1. Validar con el propietario del espacio que la estructura espejo sea suficiente.
2. Configurar recordatorios de revisión en el calendario del equipo.
3. Integrar evidencias de sincronización (capturas, correos) en una subcarpeta `evidences/` cuando aplique.
