---
id: UC-PERM-007
tipo: caso_de_uso
nombre: Verificar Permiso de Usuario
actor_primario: Sistema / Usuario
nivel: subfunción
prioridad: crítica
estado: aprobado
trazabilidad_upward: [PRIORIDAD_01, RNF-002]
trazabilidad_downward: [RF-PERM-007]
---

# UC-PERM-007: Verificar Permiso de Usuario

## 1. Resumen

El sistema verifica si un usuario tiene una capacidad específica, evaluando en orden: revocaciones excepcionales, concesiones excepcionales, y grupos asignados.

## 2. Precondiciones

- Usuario autenticado
- Capacidad a verificar existe

## 3. Algoritmo de Verificación (Orden de Precedencia)

```
1. SI existe revocación excepcional activa → DENEGAR (prioridad máxima)
2. SI existe concesión excepcional activa → CONCEDER
3. SI usuario tiene capacidad por algún grupo activo → CONCEDER
4. SINO → DENEGAR
```

## 4. Performance Target

- **Con SQL Function**: 5-10ms
- **Con ORM**: 30-50ms
- **Con Cache**: < 1ms

## 5. SQL Function

```sql
CREATE OR REPLACE FUNCTION usuario_tiene_permiso(
    p_usuario_id INTEGER,
    p_capacidad_codigo VARCHAR(200)
) RETURNS BOOLEAN AS $$
DECLARE
    v_tiene_permiso BOOLEAN;
BEGIN
    -- Verificar usando vista optimizada
    SELECT EXISTS (
        SELECT 1 FROM vista_capacidades_usuario
        WHERE usuario_id = p_usuario_id
          AND capacidad_codigo = p_capacidad_codigo
    ) INTO v_tiene_permiso;

    RETURN v_tiene_permiso;
END;
$$ LANGUAGE plpgsql STABLE PARALLEL SAFE;
```

## 6. API Endpoint

```
GET /api/permisos/verificar/{usuario_id}/tiene-permiso/?capacidad={codigo}
Authorization: Bearer <token>

Response:
{
  "usuario_id": 123,
  "capacidad": "sistema.vistas.dashboards.ver",
  "tiene_permiso": true,
  "origen": "grupo",  // o "excepcional_conceder" o "excepcional_revocar"
  "verificado_en": "2025-01-09T12:00:00Z"
}
```

## 7. Casos de Uso

### Caso 1: Usuario con capacidad por grupo
- Given: Usuario en grupo "Agentes" que tiene "dashboards.ver"
- When: Verificar "dashboards.ver"
- Then: tiene_permiso=true, origen="grupo"

### Caso 2: Usuario con revocación excepcional
- Given: Usuario en grupo con capacidad, PERO tiene revocación excepcional
- When: Verificar esa capacidad
- Then: tiene_permiso=false, origen="excepcional_revocar"

### Caso 3: Usuario con concesión excepcional
- Given: Usuario sin grupo que tenga la capacidad, PERO tiene concesión
- When: Verificar esa capacidad
- Then: tiene_permiso=true, origen="excepcional_conceder"

## 8. Integración

Este caso de uso es invocado por:
- Decoradores (@require_permission)
- Permission classes (DRF)
- Frontend (hooks usePermisos)
- Middleware de auditoría

## Changelog

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-01-09 | Sistema | Creación inicial |
