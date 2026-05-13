---
id: UC-PERM-010
tipo: caso_de_uso
nombre: Consultar Auditoría de Permisos
actor_primario: Administrador / Auditor
nivel: usuario
prioridad: media
estado: aprobado
trazabilidad_upward: [PRIORIDAD_01, RNF-003]
trazabilidad_downward: [RF-PERM-010]
date: 2025-11-13
---

# UC-PERM-010: Consultar Auditoría de Permisos

## 1. Resumen

El Administrador o Auditor consulta los registros históricos de verificaciones de permisos para análisis de seguridad, compliance o troubleshooting.

## 2. Actores

- **Actor Primario**: Administrador / Auditor
- **Actor Secundario**: Sistema de Reporting

## 3. Precondiciones

- Actor autenticado con `sistema.administracion.auditoria.ver`
- Registros de auditoría existen

## 4. Flujo Principal

| Paso | Actor | Sistema |
|------|-------|---------|
| 1 | Accede a módulo de auditoría | Muestra interfaz de consulta |
| 2 | Selecciona filtros de búsqueda | Valida parámetros |
| 3 | Opcionalmente define rango de fechas | Valida rango no > 90 días |
| 4 | Ejecuta consulta | Aplica filtros y paginación |
| 5 | - | Retorna resultados (max 1000 registros) |
| 6 | Visualiza resultados | Muestra tabla con datos |
| 7 | Opcionalmente exporta a CSV/Excel | Genera archivo |

## 5. Filtros Disponibles

| Filtro | Tipo | Ejemplo |
|--------|------|---------|
| usuario_id | Integer | 123 |
| capacidad_codigo | String | "sistema.vistas.dashboards.ver" |
| resultado | Boolean | true/false |
| fecha_desde | DateTime | "2025-01-01T00:00:00Z" |
| fecha_hasta | DateTime | "2025-01-09T23:59:59Z" |
| ip_address | String | "192.168.1.100" |
| user_agent__contains | String | "Chrome" |

## 6. API Endpoint

```
GET /api/permisos/auditoria/?usuario_id=123&resultado=false&fecha_desde=2025-01-01
Authorization: Bearer <token>

Response:
{
 "count": 45,
 "next": "/api/permisos/auditoria/?page=2",
 "previous": null,
 "results": [
 {
 "id": 99999,
 "usuario": {
 "id": 123,
 "username": "carlos.ruiz"
 },
 "capacidad_codigo": "sistema.administracion.usuarios.eliminar",
 "resultado": false,
 "ip_address": "192.168.1.100",
 "user_agent": "Mozilla/5.0...",
 "timestamp": "2025-01-09T14:30:15Z",
 "metadatos": {
 "path": "/admin/usuarios/456/delete/",
 "method": "DELETE",
 "latency_ms": 25
 }
 },
 // ... más registros
 ]
}
```

## 7. Casos de Uso Comunes

### Caso 1: Investigar accesos denegados de un usuario

**Objetivo**: Usuario reporta que no puede acceder a un módulo

**Consulta**:
```
GET /api/permisos/auditoria/
 ?usuario_id=123
 &resultado=false
 &fecha_desde=2025-01-09T00:00:00Z
 &limit=50
```

**Análisis**:
- Revisar qué capacidades se denegaron
- Verificar si usuario tiene grupos correctos
- Validar si hay revocaciones excepcionales

### Caso 2: Auditoría de seguridad

**Objetivo**: Detectar intentos de escalación de privilegios

**Consulta**:
```
GET /api/permisos/auditoria/
 ?capacidad_codigo__contains=administracion
 &resultado=false
 &fecha_desde=2025-01-01T00:00:00Z
```

**Análisis**:
- Usuarios que intentaron acceder a capacidades admin
- IPs sospechosas
- Patrones de intentos repetidos

### Caso 3: Compliance Report

**Objetivo**: Generar reporte de accesos a datos sensibles

**Consulta**:
```
GET /api/permisos/auditoria/
 ?capacidad_codigo=sistema.datos.sensibles.ver
 &fecha_desde=2025-01-01
 &fecha_hasta=2025-01-31
 &export=excel
```

**Output**: Excel con todos los accesos a datos sensibles en enero

## 8. Performance

| Escenario | Performance |
|-----------|-------------|
| Consulta simple (< 1000 registros) | 100-200ms |
| Consulta compleja con múltiples filtros | 300-500ms |
| Exportación a Excel (< 10,000 registros) | 2-5s |

## 9. Optimizaciones

### Índices requeridos:

```sql
CREATE INDEX idx_auditoria_usuario_timestamp
 ON auditoria_permisos(usuario_id, timestamp DESC);

CREATE INDEX idx_auditoria_capacidad_timestamp
 ON auditoria_permisos(capacidad_codigo, timestamp DESC);

CREATE INDEX idx_auditoria_resultado_timestamp
 ON auditoria_permisos(resultado, timestamp DESC)
 WHERE resultado = FALSE; -- Partial index para denegados

CREATE INDEX idx_auditoria_timestamp
 ON auditoria_permisos(timestamp DESC);
```

## 10. Reglas de Negocio

| ID | Regla |
|----|-------|
| RN-010.1 | Solo usuarios con permiso `sistema.administracion.auditoria.ver` pueden consultar |
| RN-010.2 | Consultas limitadas a 90 días por performance |
| RN-010.3 | Máximo 1000 registros por página |
| RN-010.4 | Exportaciones limitadas a 10,000 registros |
| RN-010.5 | Auditoría de TODAS las consultas a auditoría (meta-auditoría) |

## 11. Visualizaciones

### Dashboard de Auditoría

**Métricas clave**:
- Total verificaciones últimas 24h
- % Accesos concedidos vs denegados
- Top 10 usuarios más activos
- Top 10 capacidades más verificadas
- Mapa de IPs con accesos denegados
- Timeline de actividad

**Alertas**:
- Picos de accesos denegados
- Accesos fuera de horario
- IPs desconocidas

## 12. Escenarios de Prueba

### Caso 1: Consulta simple
- Given: 100 registros en auditoría
- When: Consultar sin filtros
- Then: Retorna primeros 50 (paginado), HTTP 200

### Caso 2: Filtro por usuario
- Given: Usuario 123 tiene 30 registros
- When: Filtrar por usuario_id=123
- Then: Retorna 30 registros del usuario

### Caso 3: Sin permisos
- Given: Usuario sin `auditoria.ver`
- When: Intentar consultar
- Then: HTTP 403 Forbidden

### Caso 4: Rango muy amplio
- Given: Rango de 120 días
- When: Consultar
- Then: HTTP 400, "Rango máximo 90 días"

## 13. Seguridad

### Consideraciones:

1. **Información sensible**: Los logs pueden contener IPs y user-agents
2. **GDPR**: Implementar anonimización después de 90 días
3. **Retención**: Definir política de retención (sugerido: 1 año)
4. **Acceso restringido**: Solo auditores y admins de seguridad

## 14. Integración con SIEM

La tabla de auditoría puede integrarse con sistemas SIEM externos (Splunk, ELK, etc):

```python
# Ejemplo: Enviar logs a Splunk
@receiver(post_save, sender=AuditoriaPermiso)
def send_to_splunk(sender, instance, created, **kwargs):
 if created:
 splunk_client.send({
 'event': 'permission_check',
 'user_id': instance.usuario_id,
 'permission': instance.capacidad_codigo,
 'result': instance.resultado,
 'ip': instance.ip_address,
 'timestamp': instance.timestamp.isoformat(),
 })
```

## Changelog

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-01-09 | Sistema | Creación inicial |
