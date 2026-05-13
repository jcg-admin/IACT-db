# Diseño de APIs - Backend IACT

Especificaciones OpenAPI y documentación de APIs REST del backend.

## Contenido

Este directorio contiene:

- **OpenAPI Specifications**: Definiciones YAML de las APIs REST
- **Ejemplos de APIs**: Casos de uso y ejemplos de implementación
- **Documentación de endpoints**: Referencias detalladas de cada endpoint

## Archivos

- `openapi_permisos.yaml`: Especificación OpenAPI para módulo de permisos
- `openapi_prioridad_02.yaml`: Especificación OpenAPI para módulo Prioridad 02
- `ejemplos_rest_apis.md`: Ejemplos y guías de uso de las APIs REST

## Estructura de APIs

Las APIs del backend IACT siguen los principios REST y están documentadas usando OpenAPI 3.0.

### Convenciones

1. **Versionado**: Todas las APIs usan versionado semántico en la URL (`/api/v1/`)
2. **Autenticación**: Token-based authentication (JWT)
3. **Formato**: JSON como formato de intercambio de datos
4. **Códigos HTTP**: Uso estándar de códigos de estado HTTP

## Gobernanza

Consulta **primero** la gobernanza global:
- [Diseño Global de APIs](../../../gobernanza/diseno/)
- [Lineamientos de APIs REST](../../lineamientos_codigo.md)

## Herramientas

### Validación de Schemas OpenAPI

```bash
# Validar schema OpenAPI
swagger-cli validate openapi_permisos.yaml

# Generar documentación interactiva
redoc-cli bundle openapi_permisos.yaml
```

### Generación de Clientes

```bash
# Generar cliente Python desde OpenAPI
openapi-generator-cli generate -i openapi_permisos.yaml -g python -o client/
```

## Referencias

- [OpenAPI Specification](https://swagger.io/specification/)
- [REST API Best Practices](https://restfulapi.net/)
- [Plantilla API Reference](../../plantilla_api_reference.md)

## Estado Actual

- [OK] OpenAPI spec para módulo de permisos
- [OK] OpenAPI spec para módulo Prioridad 02
- [OK] Ejemplos y guías de uso
- En desarrollo: Validación automática de schemas
- Pendiente: Generación automática de documentación

## Próximos Pasos

1. Completar especificaciones OpenAPI para todos los módulos
2. Implementar validación automática en CI/CD
3. Generar documentación interactiva (Swagger/ReDoc)
4. Crear tests de contrato basados en OpenAPI specs
