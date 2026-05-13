# Referencias - Backend

Este directorio contiene referencias tecnicas externas curadas para el desarrollo backend.

## Proposito

Documentar y organizar:
- Referencias a documentacion oficial
- Articulos tecnicos relevantes
- Best practices de la industria
- Recursos de aprendizaje
- Bibliotecas y frameworks utilizados

## Nomenclatura

```
nombre-tecnologia-referencias.md
nombre-topico-resources.md
```

**Ejemplos:**
- `django-references.md`
- `drf-references.md`
- `python-libraries.md`
- `testing-resources.md`
- `database-references.md`

## Referencias Planificadas

### django-references.md
- Django Documentation oficial
- Django Best Practices
- Django Design Patterns
- Security en Django
- Performance optimization

### drf-references.md
- DRF Documentation
- API Design Best Practices
- Serialization patterns
- Authentication & Permissions
- Throttling & Rate Limiting

### python-libraries.md
- Bibliotecas utilizadas en el proyecto
- Version requirements
- Casos de uso
- Documentacion oficial
- Alternatives consideradas

### testing-resources.md
- pytest Documentation
- Testing Best Practices
- Coverage tools
- Mocking strategies
- Integration testing

### database-references.md
- MySQL Documentation
- Django ORM Best Practices
- Database optimization
- Migration strategies
- Indexing strategies

## Formato de Referencias

```markdown
## [Nombre del Recurso]

**Tipo:** [Documentacion Oficial | Articulo | Tutorial | Video]

**URL:** [URL del recurso]

**Descripcion:** [Breve descripcion del contenido]

**Relevancia para el proyecto:** [Por que es util]

**Temas cubiertos:**
- Tema 1
- Tema 2

**Fecha de consulta:** YYYY-MM-DD

**Estado:** [Activo | Obsoleto | Superseded]
```

## Categorias de Referencias

### Documentacion Oficial
- Django 4.x
- Django REST Framework 3.x
- Python 3.10+
- MySQL 8.x
- pytest

### Articulos y Blogs
- Martin Fowler
- Real Python
- Django Documentation
- Two Scoops of Django

### Libros Tecnicos
- Two Scoops of Django
- Django for APIs
- Test-Driven Development with Python
- Clean Architecture

### Cursos y Tutorialese
- Django REST Framework Course
- Advanced Django Patterns
- Testing in Django

### Herramientas y Librerias
- black (code formatter)
- flake8 (linter)
- mypy (type checker)
- pytest (testing framework)

## Versionado

Mantener referencias actualizadas con versiones:
- Django: 4.x (especificar version exacta)
- DRF: 3.x
- Python: 3.10+
- MySQL: 8.x

## Restricciones del Proyecto

**Referencias NO aplicables:**
- Redis/Celery (no usado en proyecto)
- Email/SMTP backends (no implementado)
- Third-party session backends (usamos MySQL)

**Referencias CRITICAS:**
- MySQL session backend
- Django dual database routing
- Custom permission systems

## Actualizacion

Actualizar referencias cuando:
- Se adopta nueva tecnologia
- Se actualiza version de dependencia
- Se encuentra recurso mejor o mas actualizado
- Recurso existente queda obsoleto

---

**Ultima actualizacion:** 2025-11-18
**Responsable:** Equipo Backend
