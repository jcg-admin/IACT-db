---
id: UC-PERM-004
tipo: caso_de_uso
nombre: Revocar Permiso Excepcional
actor_primario: Administrador de Sistema
nivel: usuario
prioridad: alta
estado: aprobado
trazabilidad_upward: [PRIORIDAD_01]
trazabilidad_downward: [RF-PERM-004, TEST-PERM-004]
date: 2025-11-13
---

# UC-PERM-004: Revocar Permiso Excepcional

## 1. Resumen

El Administrador de Sistema crea una excepción de tipo "revocar" que BLOQUEA una capacidad específica que el usuario tendría por sus grupos. Tiene prioridad sobre las concesiones de grupos.

## 2. Actores

- **Actor Primario**: Administrador de Sistema
- **Actores Secundarios**: Usuario afectado

## 3. Precondiciones

| ID | Descripción |
|----|-------------|
| PRE-004.1 | Admin autenticado con `sistema.administracion.permisos.excepcionales.revocar` |
| PRE-004.2 | Usuario objetivo existe |
| PRE-004.3 | Usuario TIENE la capacidad (por grupo) que se desea revocar |
| PRE-004.4 | No existe ya una revocación excepcional activa para esta capacidad |

## 4. Postcondiciones

| ID | Descripción |
|----|-------------|
| POST-004.1 | Se crea registro en `permisos_excepcionales` con tipo='revocar' |
| POST-004.2 | Usuario pierde acceso a la capacidad INMEDIATAMENTE |
| POST-004.3 | Revocación tiene prioridad sobre cualquier concesión de grupo |
| POST-004.4 | Se registra en auditoría |
| POST-004.5 | Cache de permisos se invalida |

## 5. Flujo Principal

| Paso | Actor | Acción | Sistema |
|------|-------|--------|---------|
| 1 | Admin | Accede a gestión de excepcionales | Muestra interfaz |
| 2 | Admin | Selecciona usuario | Muestra capacidades actuales del usuario |
| 3 | Admin | Selecciona capacidad a revocar | Valida que usuario la tenga por grupo |
| 4 | Admin | Ingresa motivo de revocación (obligatorio) | Valida longitud mínima |
| 5 | Admin | Opcionalmente establece fecha_fin | Valida fecha futura |
| 6 | Admin | Confirma revocación | Verifica permisos de admin |
| 7 | Sistema | Crea registro tipo='revocar', activo=True | INSERT en permisos_excepcionales |
| 8 | Sistema | Invalida cache del usuario | DELETE cache |
| 9 | Sistema | Registra en auditoría | INSERT con tipo='REVOCAR_EXCEPCIONAL' |
| 10 | Sistema | Notifica usuario | Email con explicación |
| 11 | Sistema | Confirma revocación | Mensaje de éxito |

## 6. Reglas de Negocio

| ID | Regla | Tipo |
|----|-------|------|
| RN-004.1 | Revocación excepcional SIEMPRE tiene prioridad sobre grupos | Crítica |
| RN-004.2 | Usuario debe tener la capacidad por grupo para poder revocarla | Alta |
| RN-004.3 | Motivo obligatorio mínimo 20 caracteres | Alta |
| RN-004.4 | Revocación es inmediata | Alta |

## 7. Datos de Entrada

```json
{
 "usuario_id": 456,
 "capacidad_codigo": "sistema.administracion.usuarios.eliminar",
 "tipo": "revocar",
 "motivo": "Usuario no debe eliminar usuarios durante período de auditoría por política de seguridad corporativa",
 "fecha_fin": "2025-02-01T00:00:00Z",
 "asignado_por_id": 1
}
```

## 8. Datos de Salida

```json
{
 "success": true,
 "message": "Permiso excepcional revocado",
 "data": {
 "id": 999,
 "usuario_id": 456,
 "capacidad_codigo": "sistema.administracion.usuarios.eliminar",
 "tipo": "revocar",
 "motivo": "Usuario no debe eliminar...",
 "fecha_inicio": "2025-01-09T11:00:00Z",
 "fecha_fin": "2025-02-01T00:00:00Z",
 "activo": true
 }
}
```

## 9. Especificaciones Técnicas

### API Endpoint

```
POST /api/permisos/excepcionales/
Content-Type: application/json

{
 "usuario_id": 456,
 "capacidad_codigo": "sistema.administracion.usuarios.eliminar",
 "tipo": "revocar",
 "motivo": "...",
 "fecha_fin": "2025-02-01T00:00:00Z"
}
```

### Lógica de Verificación

```sql
-- Al verificar permiso, primero verificar revocaciones
SELECT EXISTS (
 SELECT 1 FROM permisos_excepcionales
 WHERE usuario_id = 456
 AND capacidad_id = (SELECT id FROM capacidades WHERE codigo = '...')
 AND tipo = 'revocar'
 AND activo = TRUE
 AND (fecha_fin IS NULL OR fecha_fin > NOW())
) AS esta_revocado;

-- Si esta_revocado = TRUE, denegar acceso inmediatamente
-- Sin importar grupos o concesiones
```

## Changelog

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-01-09 | Sistema | Creación inicial |
