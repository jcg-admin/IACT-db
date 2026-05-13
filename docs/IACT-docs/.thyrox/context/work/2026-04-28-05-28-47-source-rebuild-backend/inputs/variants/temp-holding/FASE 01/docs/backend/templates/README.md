# Templates - Backend

Este directorio contiene templates adicionales y reutilizables del backend.

## Proposito

Almacenar templates especificos que complementan las plantillas documentales:
- Templates de codigo (Python, Django)
- Templates de configuracion
- Templates de scripts
- Templates de tests

## Diferencia: Templates vs Plantillas

### Templates (codigo y configuracion)
- Templates de archivos de codigo
- Configuraciones reutilizables
- Scripts de automatizacion
- Almacenados en `templates/`

### Plantillas (documentacion)
- Plantillas de documentos markdown
- Estructuras de documentacion
- Formatos de reportes
- Almacenados en `plantillas/`

## Nomenclatura

```
template-tipo-nombre.py
template-tipo-nombre.yml
template-tipo-nombre.sh
```

**Ejemplos:**
- `template-django-app.py`
- `template-viewset-crud.py`
- `template-test-case.py`
- `template-settings.py`
- `template-docker-compose.yml`

## Templates Planificados

### Templates de Codigo Python

#### template-django-app.py
Estructura base para nueva Django app:
```python
# models.py
# views.py
# serializers.py
# urls.py
# admin.py
# tests.py
```

#### template-viewset-crud.py
ViewSet completo con CRUD operations

#### template-model.py
Modelo Django con best practices

#### template-serializer.py
Serializer DRF con validaciones

### Templates de Tests

#### template-test-case.py
Test case con patron AAA

#### template-test-api.py
Test de API con APIClient

#### template-test-factory.py
Factory para fixtures

### Templates de Configuracion

#### template-settings.py
Settings de Django con:
- Base de datos dual
- Sesiones en MySQL
- Sin Redis
- Sin SMTP

#### template-docker-compose.yml
Docker compose para entorno local

#### template-github-actions.yml
Workflow de CI/CD

### Templates de Scripts

#### template-management-command.py
Management command de Django

#### template-migration-script.py
Script de migracion de datos

#### template-validation-script.sh
Script de validaciones

## Uso de Templates

1. Copiar template relevante
2. Renombrar segun funcionalidad
3. Adaptar a caso de uso especifico
4. Completar TODOs y placeholders
5. Ejecutar tests

## Placeholders en Templates

Templates usan placeholders:
```python
# TODO: Replace with actual implementation
# FIXME: Adapt to your use case
# NOTE: Consider project restrictions
```

## Restricciones en Templates

Templates deben implementar:
- **NO Redis:** Comentar out o eliminar referencias Redis
- **NO SMTP:** No incluir configuracion email
- **MySQL Sessions:** Template de session configuration
- **Dual DB:** Template de database routing

## Templates de Referencia

Templates relacionados en otros directorios:
- `ejemplos/`: Ejemplos completos de uso
- `plantillas/`: Plantillas documentales
- `procedimientos/`: Scripts procedimentales

---

**Ultima actualizacion:** 2025-11-18
**Responsable:** Equipo Backend
