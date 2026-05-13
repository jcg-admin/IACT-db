---
id: UC-PERM-005
tipo: caso_de_uso
nombre: Crear Grupo de Permisos
actor_primario: Administrador de Sistema
nivel: usuario
prioridad: alta
estado: aprobado
trazabilidad_upward: [PRIORIDAD_01]
trazabilidad_downward: [RF-PERM-005, TEST-PERM-005]
---

# UC-PERM-005: Crear Grupo de Permisos

## 1. Resumen

El Administrador crea un nuevo grupo de permisos que agrupa múltiples capacidades relacionadas, facilitando la asignación masiva de permisos a usuarios.

## 2. Precondiciones

- Admin autenticado con `sistema.administracion.grupos.crear`
- Código del grupo no existe

## 3. Flujo Principal

| Paso | Actor | Sistema |
|------|-------|---------|
| 1 | Accede a gestión de grupos | Muestra formulario |
| 2 | Ingresa código único (ej: "agentes_nivel_2") | Valida formato y unicidad |
| 3 | Ingresa nombre descriptivo | Valida no vacío |
| 4 | Opcionalmente ingresa descripción | Valida longitud |
| 5 | Selecciona capacidades a incluir (búsqueda) | Muestra capacidades disponibles |
| 6 | Confirma creación | Valida al menos 1 capacidad |
| 7 | - | Crea grupo (INSERT) |
| 8 | - | Asocia capacidades (INSERT en grupo_capacidades) |
| 9 | - | Registra en auditoría |
| 10 | - | Muestra confirmación |

## 4. Reglas de Negocio

| ID | Regla |
|----|-------|
| RN-005.1 | Código del grupo debe ser único y alfanumérico con guiones bajos |
| RN-005.2 | Debe tener al menos 1 capacidad asociada |
| RN-005.3 | Nombre y descripción son obligatorios |

## 5. Datos de Entrada

```json
{
  "codigo": "analistas_calidad",
  "nombre": "Analistas de Calidad",
  "descripcion": "Grupo para analistas que revisan calidad de llamadas",
  "activo": true,
  "capacidades_codigos": [
    "sistema.vistas.calidad.ver",
    "sistema.vistas.calidad.evaluar",
    "sistema.vistas.reportes.calidad.ver"
  ]
}
```

## 6. Datos de Salida

```json
{
  "success": true,
  "data": {
    "id": 15,
    "codigo": "analistas_calidad",
    "nombre": "Analistas de Calidad",
    "descripcion": "Grupo para analistas...",
    "activo": true,
    "total_capacidades": 3,
    "created_at": "2025-01-09T11:30:00Z"
  }
}
```

## 7. API Endpoint

```
POST /api/permisos/grupos/
Authorization: Bearer <token>

Body: Ver sección 5
```

## 8. SQL Operation

```sql
BEGIN;

-- Crear grupo
INSERT INTO grupos_permisos (codigo, nombre, descripcion, activo)
VALUES ('analistas_calidad', 'Analistas de Calidad', '...', TRUE)
RETURNING id;

-- Asociar capacidades
INSERT INTO grupo_capacidades (grupo_id, capacidad_id)
SELECT 15, id FROM capacidades
WHERE codigo IN ('sistema.vistas.calidad.ver', ...);

COMMIT;
```

## 9. Escenarios de Prueba

### Caso 1: Creación exitosa
- Given: Código único, 3 capacidades válidas
- When: Admin crea grupo
- Then: HTTP 201, grupo creado con 3 capacidades

### Caso 2: Código duplicado
- Given: Código "agentes_nivel_1" ya existe
- When: Admin intenta crear grupo con mismo código
- Then: HTTP 400, error de unicidad

### Caso 3: Sin capacidades
- Given: Grupo sin capacidades
- When: Admin intenta crear
- Then: HTTP 400, "Debe seleccionar al menos 1 capacidad"

## Changelog

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-01-09 | Sistema | Creación inicial |
