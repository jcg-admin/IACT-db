---
id: UC-PERM-003
tipo: caso_de_uso
nombre: Conceder Permiso Excepcional
actor_primario: Administrador de Sistema
nivel: usuario
prioridad: alta
estado: aprobado
trazabilidad_upward: [PRIORIDAD_01, RNF-002]
trazabilidad_downward: [RF-PERM-003, TEST-PERM-003]
date: 2025-11-13
---

# UC-PERM-003: Conceder Permiso Excepcional

## 1. Resumen

El Administrador de Sistema concede una capacidad específica a un usuario de manera excepcional, sin modificar sus grupos de permisos. Útil para casos temporales o situaciones especiales.

## 2. Actores

- **Actor Primario**: Administrador de Sistema
- **Actores Secundarios**: Usuario beneficiado

## 3. Precondiciones

| ID | Descripción |
|----|-------------|
| PRE-003.1 | El administrador está autenticado |
| PRE-003.2 | El administrador tiene `sistema.administracion.permisos.excepcionales.conceder` |
| PRE-003.3 | El usuario objetivo existe |
| PRE-003.4 | La capacidad a conceder existe y está activa |
| PRE-003.5 | El usuario NO tiene ya esta capacidad (ni por grupo ni por excepción) |

## 4. Postcondiciones

| ID | Descripción |
|----|-------------|
| POST-003.1 | Se crea registro en `permisos_excepcionales` con tipo='conceder' |
| POST-003.2 | El usuario gana acceso a la capacidad especificada |
| POST-003.3 | Se registra evento de auditoría |
| POST-003.4 | Cache de permisos del usuario se invalida |
| POST-003.5 | Usuario recibe notificación de nuevo permiso |

## 5. Flujo Principal

| Paso | Actor | Acción | Sistema |
|------|-------|--------|---------|
| 1 | Admin | Accede a módulo de permisos excepcionales | Muestra interfaz de gestión |
| 2 | Admin | Selecciona usuario objetivo | Muestra perfil con capacidades actuales |
| 3 | Admin | Busca capacidad a conceder | Muestra capacidades disponibles (filtradas) |
| 4 | Admin | Selecciona capacidad específica | Valida que usuario no la tenga ya |
| 5 | Admin | Ingresa motivo de concesión (obligatorio) | Valida longitud mínima (20 chars) |
| 6 | Admin | Opcionalmente establece fecha de expiración | Valida que fecha sea futura |
| 7 | Admin | Confirma concesión | Verifica permiso de administrador |
| 8 | Sistema | Crea registro en permisos_excepcionales | INSERT con tipo='conceder', activo=True |
| 9 | Sistema | Registra evento en auditoría | Detalla capacidad concedida y motivo |
| 10 | Sistema | Invalida cache de permisos | DELETE de cache del usuario |
| 11 | Sistema | Envía notificación al usuario | Email con detalle del nuevo permiso |
| 12 | Sistema | Muestra confirmación | Mensaje: "Permiso excepcional concedido" |

## 6. Flujos Alternativos

### FA-003.1: Usuario ya tiene la capacidad

| Paso | Descripción |
|------|-------------|
| 4a | Sistema detecta que usuario ya tiene la capacidad (por grupo o excepción) |
| 4b | Sistema muestra advertencia con origen del permiso |
| 4c | Admin puede cancelar o confirmar para reforzar |
| 4d | Si confirma, continúa en paso 5 |

### FA-003.2: Permiso temporal con fecha de expiración

| Paso | Descripción |
|------|-------------|
| 6a | Admin establece `fecha_fin` en el futuro |
| 6b | Sistema valida que sea al menos 1 hora en el futuro |
| 6c | Sistema programa job para revocar automáticamente al expirar |
| 6d | Continúa en paso 7 |

### FA-003.3: Capacidad ya existe pero está inactiva

| Paso | Descripción |
|------|-------------|
| 8a | Sistema detecta registro previo con activo=False |
| 8b | Sistema reactiva registro en vez de crear nuevo |
| 8c | UPDATE activo=True, actualiza motivo y fecha_inicio |
| 8d | Continúa en paso 9 |

## 7. Flujos de Excepción

### FE-003.1: Sin permisos

| Paso | Descripción |
|------|-------------|
| 7a | Sistema detecta falta de permiso para conceder |
| 7b | HTTP 403 Forbidden |
| 7c | Mensaje: "No tiene permisos para conceder excepciones" |
| 7d | Flujo termina |

### FE-003.2: Capacidad no existe

| Paso | Descripción |
|------|-------------|
| 8a | Sistema no encuentra capacidad con código especificado |
| 8b | HTTP 404 Not Found |
| 8c | Mensaje: "Capacidad no encontrada" |
| 8d | Flujo termina |

## 8. Reglas de Negocio

| ID | Regla | Tipo |
|----|-------|------|
| RN-003.1 | Motivo es obligatorio y mínimo 20 caracteres | Crítica |
| RN-003.2 | Fecha de expiración debe ser futura (si se especifica) | Alta |
| RN-003.3 | No se puede conceder capacidad inactiva | Alta |
| RN-003.4 | Concesión es inmediata (toma efecto al instante) | Media |
| RN-003.5 | Sistema debe auditar TODAS las concesiones excepcionales | Crítica |

## 9. Requisitos No Funcionales

| ID | Requisito | Valor Objetivo |
|----|-----------|----------------|
| RNF-003.1 | Tiempo de respuesta | < 300ms |
| RNF-003.2 | Disponibilidad | 99.9% |
| RNF-003.3 | Auditoría | 100% de concesiones |
| RNF-003.4 | Notificaciones | > 95% entregadas |

## 10. Datos de Entrada

```json
{
 "usuario_id": 456,
 "capacidad_codigo": "sistema.vistas.reportes.exportar",
 "tipo": "conceder",
 "motivo": "Necesita exportar reportes urgentes para auditoría externa del próximo lunes",
 "fecha_fin": "2025-01-15T23:59:59Z", // Opcional
 "asignado_por_id": 1
}
```

## 11. Datos de Salida

### Caso Exitoso (HTTP 201)

```json
{
 "success": true,
 "message": "Permiso excepcional concedido exitosamente",
 "data": {
 "id": 789,
 "usuario_id": 456,
 "usuario_username": "maria.fernandez",
 "capacidad_codigo": "sistema.vistas.reportes.exportar",
 "capacidad_nombre": "Exportar Reportes",
 "tipo": "conceder",
 "motivo": "Necesita exportar reportes urgentes para auditoría...",
 "fecha_inicio": "2025-01-09T10:45:00Z",
 "fecha_fin": "2025-01-15T23:59:59Z",
 "activo": true,
 "asignado_por": "admin_user"
 }
}
```

## 12. Especificaciones Técnicas

### API Endpoint

```
POST /api/permisos/excepcionales/
Authorization: Bearer <token>
Content-Type: application/json

Body:
{
 "usuario_id": 456,
 "capacidad_codigo": "sistema.vistas.reportes.exportar",
 "tipo": "conceder",
 "motivo": "Necesita exportar reportes urgentes...",
 "fecha_fin": "2025-01-15T23:59:59Z"
}
```

### SQL Operation

```sql
-- Conceder permiso excepcional
INSERT INTO permisos_excepcionales (
 usuario_id,
 capacidad_id,
 tipo,
 motivo,
 fecha_inicio,
 fecha_fin,
 asignado_por_id,
 activo
) VALUES (
 456,
 (SELECT id FROM capacidades WHERE codigo = 'sistema.vistas.reportes.exportar'),
 'conceder',
 'Necesita exportar reportes urgentes...',
 NOW(),
 '2025-01-15 23:59:59',
 1,
 TRUE
);

-- Registrar auditoría
INSERT INTO auditoria_permisos (
 usuario_id,
 accion,
 capacidad_codigo,
 detalle,
 realizado_por_id,
 timestamp
) VALUES (
 456,
 'CONCEDER_EXCEPCIONAL',
 'sistema.vistas.reportes.exportar',
 '{"motivo": "...", "fecha_fin": "2025-01-15T23:59:59Z"}',
 1,
 NOW()
);
```

### Performance

- **Target**: < 300ms end-to-end
- **SQL INSERT**: 5-10ms
- **Cache invalidation**: < 50ms
- **Notification**: Async (no bloquea respuesta)

## 13. Escenarios de Prueba

### Caso de Prueba 1: Concesión exitosa temporal

```yaml
Given:
 - Usuario 456 existe
 - Capacidad "sistema.vistas.reportes.exportar" existe
 - Usuario NO tiene esta capacidad
 - Admin tiene permiso de conceder
When:
 - Admin concede capacidad con fecha_fin = "2025-01-15T23:59:59Z"
Then:
 - Se crea registro en permisos_excepcionales
 - activo=True, tipo='conceder'
 - Usuario puede usar capacidad inmediatamente
 - HTTP 201 Created
```

### Caso de Prueba 2: Usuario ya tiene la capacidad

```yaml
Given:
 - Usuario 456 tiene "sistema.vistas.reportes.exportar" por grupo
When:
 - Admin intenta conceder la misma capacidad
Then:
 - HTTP 400 Bad Request
 - Mensaje: "Usuario ya tiene esta capacidad (origen: grupo 'Coordinadores')"
 - No se crea registro
```

### Caso de Prueba 3: Motivo muy corto

```yaml
Given:
 - Datos válidos pero motivo = "urgente" (< 20 chars)
When:
 - Admin intenta conceder
Then:
 - HTTP 400 Bad Request
 - Mensaje: "El motivo debe tener al menos 20 caracteres"
 - No se crea registro
```

## 14. Trazabilidad

### Upward

- **PRIORIDAD_01**: Sistema de Permisos Granular
- **RNF-002**: Performance < 500ms

### Downward

- **RF-PERM-003**: Implementación de permisos excepcionales
- **TEST-PERM-003**: Tests para concesión excepcional
- **API-PERM-003**: POST /api/permisos/excepcionales/

### Related

- **UC-PERM-004**: Revocar Permiso Excepcional (caso inverso)
- **UC-PERM-007**: Verificar Permiso (incluye excepcionales)

## Changelog

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-01-09 | Sistema | Creación inicial |
