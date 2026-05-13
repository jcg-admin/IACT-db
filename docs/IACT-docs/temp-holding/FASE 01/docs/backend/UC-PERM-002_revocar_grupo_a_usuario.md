---
id: UC-PERM-002
tipo: caso_de_uso
nombre: Revocar Grupo de Permisos a Usuario
actor_primario: Administrador de Sistema
nivel: usuario
prioridad: alta
estado: aprobado
trazabilidad_upward: [PRIORIDAD_01, RNF-002]
trazabilidad_downward: [RF-PERM-002, TEST-PERM-002]
date: 2025-11-13
---

# UC-PERM-002: Revocar Grupo de Permisos a Usuario

## 1. Resumen

El Administrador de Sistema revoca un grupo de permisos previamente asignado a un usuario, desactivando todos los permisos asociados a ese grupo.

## 2. Actores

- **Actor Primario**: Administrador de Sistema
- **Actores Secundarios**: Usuario afectado

## 3. Precondiciones

| ID | Descripción |
|----|-------------|
| PRE-002.1 | El administrador está autenticado en el sistema |
| PRE-002.2 | El administrador tiene la capacidad `sistema.administracion.usuarios.editar` |
| PRE-002.3 | El usuario objetivo existe en el sistema |
| PRE-002.4 | El usuario tiene al menos un grupo asignado activo |
| PRE-002.5 | El grupo a revocar está actualmente asignado y activo |

## 4. Postcondiciones

| ID | Descripción |
|----|-------------|
| POST-002.1 | La asignación del grupo se marca como `activo=False` |
| POST-002.2 | El usuario pierde acceso a todas las capacidades del grupo revocado |
| POST-002.3 | Se registra un evento de auditoría con la revocación |
| POST-002.4 | El timestamp `updated_at` se actualiza |
| POST-002.5 | El usuario recibe notificación de revocación de permisos |

## 5. Flujo Principal

| Paso | Actor | Acción | Sistema |
|------|-------|--------|---------|
| 1 | Admin | Accede al módulo de gestión de usuarios | Muestra lista de usuarios |
| 2 | Admin | Selecciona usuario objetivo | Muestra perfil del usuario con grupos asignados |
| 3 | Admin | Visualiza grupos activos del usuario | Muestra lista de grupos con estado activo |
| 4 | Admin | Selecciona grupo a revocar | Muestra confirmación con impacto de revocación |
| 5 | Admin | Ingresa motivo de revocación | Valida que el motivo no esté vacío |
| 6 | Admin | Confirma revocación | Verifica permiso `sistema.administracion.usuarios.editar` |
| 7 | Sistema | Marca asignación como `activo=False` | Actualiza registro en tabla `usuarios_grupos` |
| 8 | Sistema | Registra evento en auditoría | Inserta en tabla `auditoria_permisos` |
| 9 | Sistema | Invalida cache de permisos del usuario | Elimina entradas de cache relacionadas |
| 10 | Sistema | Envía notificación al usuario | Envía email/notificación interna |
| 11 | Sistema | Muestra confirmación de éxito | Mensaje: "Grupo revocado exitosamente" |

## 6. Flujos Alternativos

### FA-002.1: Usuario no tiene el grupo asignado

| Paso | Descripción |
|------|-------------|
| 4a | Sistema detecta que el usuario no tiene el grupo asignado |
| 4b | Sistema muestra error: "El usuario no tiene este grupo asignado" |
| 4c | Flujo termina |

### FA-002.2: Grupo ya está inactivo

| Paso | Descripción |
|------|-------------|
| 6a | Sistema detecta que el grupo ya está marcado como `activo=False` |
| 6b | Sistema muestra advertencia: "Este grupo ya está revocado" |
| 6c | Admin puede confirmar para actualizar motivo o cancelar |
| 6d | Si confirma, continúa en paso 7 |

### FA-002.3: Usuario es el último administrador

| Paso | Descripción |
|------|-------------|
| 6a | Sistema detecta que el usuario es el único con grupo de administradores |
| 6b | Sistema muestra error crítico: "No se puede revocar. Usuario es el último administrador del sistema" |
| 6c | Flujo termina |

## 7. Flujos de Excepción

### FE-002.1: Error de permisos

| Paso | Descripción |
|------|-------------|
| 6a | Sistema detecta que el administrador no tiene permiso `sistema.administracion.usuarios.editar` |
| 6b | Sistema retorna HTTP 403 Forbidden |
| 6c | Mensaje: "No tiene permisos para revocar grupos" |
| 6d | Flujo termina |

### FE-002.2: Error de base de datos

| Paso | Descripción |
|------|-------------|
| 7a | Error al actualizar registro en base de datos |
| 7b | Sistema ejecuta rollback de transacción |
| 7c | Sistema retorna HTTP 500 Internal Server Error |
| 7d | Sistema registra error en logs |
| 7e | Mensaje: "Error al revocar grupo. Intente nuevamente" |
| 7f | Flujo termina |

## 8. Reglas de Negocio

| ID | Regla | Tipo |
|----|-------|------|
| RN-002.1 | No se puede revocar el último grupo de administradores del sistema | Crítica |
| RN-002.2 | El motivo de revocación es obligatorio | Alta |
| RN-002.3 | La revocación no elimina el registro, solo lo marca como inactivo | Alta |
| RN-002.4 | La revocación es inmediata (no hay período de gracia) | Media |
| RN-002.5 | Se debe notificar al usuario afectado | Media |

## 9. Requisitos No Funcionales

| ID | Requisito | Valor Objetivo |
|----|-----------|----------------|
| RNF-002.1 | Tiempo de respuesta | < 500ms |
| RNF-002.2 | Invalidación de cache | < 100ms |
| RNF-002.3 | Disponibilidad | 99.9% |
| RNF-002.4 | Registro de auditoría | 100% de casos |

## 10. Datos de Entrada

```json
{
 "usuario_id": 123,
 "grupo_id": 5,
 "motivo": "Cambio de rol en la organización",
 "revocado_por_id": 1
}
```

## 11. Datos de Salida

### Caso Exitoso (HTTP 200)

```json
{
 "success": true,
 "message": "Grupo revocado exitosamente",
 "data": {
 "usuario_id": 123,
 "usuario_username": "carlos.ruiz",
 "grupo_id": 5,
 "grupo_nombre": "Coordinadores",
 "fecha_revocacion": "2025-01-09T10:30:00Z",
 "motivo": "Cambio de rol en la organización",
 "revocado_por": "admin_user",
 "capacidades_removidas": 15
 }
}
```

### Caso Error (HTTP 403)

```json
{
 "error": "No tiene permisos para revocar grupos",
 "required_permission": "sistema.administracion.usuarios.editar",
 "code": "PERMISSION_DENIED"
}
```

## 12. Especificaciones Técnicas

### API Endpoint

```
DELETE /api/permisos/usuarios/{usuario_id}/grupos/{grupo_id}/
Authorization: Bearer <token>
Content-Type: application/json

Body:
{
 "motivo": "Cambio de rol en la organización"
}
```

### SQL Operation

```sql
-- Revocar grupo (marcar como inactivo)
UPDATE usuarios_grupos
SET activo = FALSE,
 motivo_revocacion = 'Cambio de rol en la organización',
 revocado_por_id = 1,
 updated_at = NOW()
WHERE usuario_id = 123
 AND grupo_id = 5
 AND activo = TRUE;

-- Registrar en auditoría
INSERT INTO auditoria_permisos (
 usuario_id,
 accion,
 detalle,
 realizado_por_id,
 timestamp
) VALUES (
 123,
 'REVOCAR_GRUPO',
 '{"grupo_id": 5, "grupo_nombre": "Coordinadores", "motivo": "Cambio de rol"}',
 1,
 NOW()
);

-- Invalidar cache
DELETE FROM cache_permisos WHERE usuario_id = 123;
```

### Performance

- **ORM**: 40-60ms (UPDATE + SELECT + cache invalidation)
- **SQL directo**: 15-25ms
- **Target**: < 500ms end-to-end

## 13. Escenarios de Prueba

### Caso de Prueba 1: Revocación exitosa

```yaml
Given:
 - Usuario 123 existe
 - Usuario 123 tiene grupo "Coordinadores" activo
 - Admin tiene permiso "sistema.administracion.usuarios.editar"
When:
 - Admin revoca grupo "Coordinadores" con motivo "Cambio de rol"
Then:
 - Asignación se marca como activo=False
 - Se registra en auditoría
 - Cache se invalida
 - Usuario recibe notificación
 - HTTP 200 con mensaje de éxito
```

### Caso de Prueba 2: Usuario no tiene el grupo

```yaml
Given:
 - Usuario 123 existe
 - Usuario 123 NO tiene grupo "Coordinadores" activo
When:
 - Admin intenta revocar grupo "Coordinadores"
Then:
 - HTTP 400 Bad Request
 - Mensaje: "El usuario no tiene este grupo asignado"
 - No se modifica base de datos
```

### Caso de Prueba 3: Último administrador

```yaml
Given:
 - Usuario 123 es el único con grupo "Administradores"
When:
 - Admin intenta revocar grupo "Administradores"
Then:
 - HTTP 400 Bad Request
 - Mensaje: "No se puede revocar. Usuario es el último administrador"
 - No se modifica base de datos
```

### Caso de Prueba 4: Sin permisos

```yaml
Given:
 - Admin NO tiene permiso "sistema.administracion.usuarios.editar"
When:
 - Admin intenta revocar grupo
Then:
 - HTTP 403 Forbidden
 - Mensaje: "No tiene permisos para revocar grupos"
 - No se modifica base de datos
```

## 14. Trazabilidad

### Upward (Requisitos de Nivel Superior)

- **PRIORIDAD_01**: Estructura Base - Sistema de Permisos Granular
- **RNF-002**: Performance < 500ms para operaciones de permisos

### Downward (Implementación)

- **RF-PERM-002**: Implementación de revocación de grupos
- **TEST-PERM-002**: Suite de tests para revocación
- **API-PERM-002**: Endpoint DELETE /api/permisos/usuarios/{id}/grupos/{grupo_id}/

### Related Use Cases

- **UC-PERM-001**: Asignar Grupo a Usuario (caso inverso)
- **UC-PERM-009**: Auditar Acceso (registra eventos de revocación)

## 15. Notas Adicionales

### Consideraciones de Seguridad

1. **Validar última instancia**: Siempre verificar que no se revoque el último administrador
2. **Auditoría completa**: Registrar quién, cuándo, por qué revocó el grupo
3. **Invalidación inmediata**: Cache debe invalidarse inmediatamente para evitar accesos no autorizados

### Consideraciones de UX

1. **Confirmación con impacto**: Mostrar cuántas capacidades perderá el usuario
2. **Motivo obligatorio**: Forzar explicación para trazabilidad
3. **Notificación clara**: Usuario debe saber por qué perdió permisos

### Casos de Uso Relacionados

- Si usuario necesita recuperar permisos → UC-PERM-001 (reasignar grupo)
- Si necesita permiso temporal → UC-PERM-003 (conceder excepcional)

## Changelog

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-01-09 | Sistema | Creación inicial |
