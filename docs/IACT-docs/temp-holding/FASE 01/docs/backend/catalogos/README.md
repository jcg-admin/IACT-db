# Catalogos - Backend

Este directorio contiene catalogos de componentes, servicios, APIs y recursos del backend.

## Proposito

Mantener inventarios actualizados de:
- APIs y endpoints REST
- Servicios backend
- Modelos de datos Django
- Comandos de gestion (management commands)
- Middlewares
- Tareas asincronas

## Nomenclatura

```
CATALOGO-nombre-recurso.md
```

**Ejemplos:**
- `CATALOGO-APIs.md`
- `CATALOGO-SERVICIOS.md`
- `CATALOGO-MODELOS.md`
- `CATALOGO-ENDPOINTS.md`

## Catalogos Planificados

### CATALOGO-APIs.md
Inventario completo de APIs REST:
- Endpoint
- Metodo HTTP
- Descripcion
- Autenticacion requerida
- Permisos necesarios
- Ejemplo de request/response

### CATALOGO-SERVICIOS.md
Listado de servicios backend:
- Nombre del servicio
- Responsabilidades
- Dependencias
- Ubicacion en codigo

### CATALOGO-MODELOS.md
Modelos Django documentados:
- Nombre del modelo
- App Django
- Campos principales
- Relaciones
- Migraciones asociadas

### CATALOGO-ENDPOINTS.md
Matriz endpoint → vista → permiso:
- Endpoint URL
- Vista asociada
- Permiso requerido
- Casos de uso

## Formato de Catalogos

Los catalogos deben usar formato de tabla markdown para facilitar busqueda:

```markdown
| Nombre | Descripcion | Ubicacion | Estado | Notas |
|--------|-------------|-----------|--------|-------|
| ... | ... | ... | ... | ... |
```

## Actualizacion

Los catalogos deben actualizarse cuando:
- Se agrega un nuevo componente
- Se modifica funcionalidad existente
- Se depreca o elimina un componente

## Restricciones del Proyecto

Considerar en catalogos:
- NO incluir funcionalidad de email/SMTP
- Sesiones gestionadas en MySQL (no Redis)
- Separacion IVR (read) vs Analytics (write)

---

**Ultima actualizacion:** 2025-11-18
**Responsable:** Equipo Backend
