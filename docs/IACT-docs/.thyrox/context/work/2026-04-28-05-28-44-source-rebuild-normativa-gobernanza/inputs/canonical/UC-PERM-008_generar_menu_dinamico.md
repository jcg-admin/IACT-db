---
id: UC-PERM-008
tipo: caso_de_uso
nombre: Generar Menú Dinámico
actor_primario: Sistema / Frontend
nivel: subfunción
prioridad: alta
estado: aprobado
trazabilidad_upward: [PRIORIDAD_01]
trazabilidad_downward: [RF-PERM-008]
---

# UC-PERM-008: Generar Menú Dinámico

## 1. Resumen

El sistema genera una estructura de menú jerárquica basada en todas las capacidades que tiene un usuario, facilitando la navegación en el frontend.

## 2. Precondiciones

- Usuario autenticado
- Usuario tiene al menos 1 capacidad

## 3. Algoritmo

```
1. Obtener todas las capacidades del usuario (grupos + excepcionales)
2. Para cada capacidad con formato "dominio.subdominio.funcion.accion":
   - Agrupar por dominio → subdominio → funcion → [acciones]
3. Construir estructura jerárquica tipo árbol
4. Retornar JSON con estructura navegable
```

## 4. SQL Function

```sql
CREATE OR REPLACE FUNCTION obtener_menu_usuario(
    p_usuario_id INTEGER
) RETURNS JSONB AS $$
DECLARE
    v_menu JSONB;
BEGIN
    SELECT jsonb_object_agg(
        dominio,
        funciones
    ) INTO v_menu
    FROM (
        SELECT
            split_part(capacidad_codigo, '.', 2) AS dominio,
            jsonb_object_agg(
                split_part(capacidad_codigo, '.', 3),
                array_agg(split_part(capacidad_codigo, '.', 4))
            ) AS funciones
        FROM vista_capacidades_usuario
        WHERE usuario_id = p_usuario_id
        GROUP BY dominio
    ) AS menu_data;

    RETURN COALESCE(v_menu, '{}'::jsonb);
END;
$$ LANGUAGE plpgsql STABLE;
```

## 5. API Endpoint

```
GET /api/permisos/verificar/{usuario_id}/menu/
Authorization: Bearer <token>

Response:
{
  "vistas": {
    "dashboards": ["ver", "editar"],
    "reportes": ["ver", "crear", "exportar"],
    "calidad": ["ver", "evaluar"]
  },
  "administracion": {
    "usuarios": ["ver", "crear", "editar"],
    "grupos": ["ver", "crear"]
  }
}
```

## 6. Performance

- **SQL Function**: 20-40ms (p95)
- **Con Cache (5 min)**: < 5ms
- **Target**: < 50ms

## 7. Uso en Frontend

```typescript
const { menu, loading } = useMenu();

return (
  <nav>
    {Object.entries(menu).map(([dominio, funciones]) => (
      <MenuSection key={dominio} title={dominio}>
        {Object.entries(funciones).map(([funcion, acciones]) => (
          <MenuItem key={funcion}
            to={`/${dominio}/${funcion}`}
            actions={acciones}
          />
        ))}
      </MenuSection>
    ))}
  </nav>
);
```

## 8. Casos de Prueba

### Caso 1: Usuario con múltiples dominios
- Given: Usuario tiene capacidades en "vistas" y "administracion"
- When: Generar menú
- Then: Retorna estructura con 2 dominios principales

### Caso 2: Usuario sin capacidades
- Given: Usuario nuevo sin grupos ni excepciones
- When: Generar menú
- Then: Retorna objeto vacío {}

## Changelog

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-01-09 | Sistema | Creación inicial |
