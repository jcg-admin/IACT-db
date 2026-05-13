---
id: UC-PERM-009
tipo: caso_de_uso
nombre: Auditar Acceso
actor_primario: Sistema / Middleware
nivel: subfunción
prioridad: crítica
estado: aprobado
trazabilidad_upward: [PRIORIDAD_01, RNF-003]
trazabilidad_downward: [RF-PERM-009]
---

# UC-PERM-009: Auditar Acceso

## 1. Resumen

El sistema registra automáticamente cada verificación de permisos en la tabla de auditoría, capturando quién, cuándo, qué capacidad y el resultado.

## 2. Actores

- **Actor Primario**: PermissionAuditMiddleware
- **Invocado por**: Decoradores, Permission classes, verificaciones manuales

## 3. Datos Capturados

| Campo | Descripción | Ejemplo |
|-------|-------------|---------|
| usuario_id | ID del usuario verificado | 123 |
| capacidad_codigo | Capacidad verificada | "sistema.vistas.dashboards.ver" |
| resultado | Concedido (true) o denegado (false) | true |
| ip_address | IP del cliente | "192.168.1.100" |
| user_agent | Navegador/cliente | "Mozilla/5.0..." |
| timestamp | Momento exacto | "2025-01-09T12:30:45Z" |
| metadatos | Info adicional (path, method, latency) | {"path": "/dashboard", "latency_ms": 15} |

## 4. SQL Function

```sql
CREATE OR REPLACE FUNCTION verificar_permiso_y_auditar(
    p_usuario_id INTEGER,
    p_capacidad_codigo VARCHAR(200),
    p_ip_address VARCHAR(45),
    p_user_agent TEXT
) RETURNS BOOLEAN AS $$
DECLARE
    v_tiene_permiso BOOLEAN;
BEGIN
    -- Verificar permiso
    v_tiene_permiso := usuario_tiene_permiso(p_usuario_id, p_capacidad_codigo);

    -- Auditar
    INSERT INTO auditoria_permisos (
        usuario_id,
        capacidad_codigo,
        resultado,
        ip_address,
        user_agent,
        timestamp
    ) VALUES (
        p_usuario_id,
        p_capacidad_codigo,
        v_tiene_permiso,
        p_ip_address,
        p_user_agent,
        NOW()
    );

    RETURN v_tiene_permiso;
END;
$$ LANGUAGE plpgsql;
```

## 5. Performance

- **Síncrono**: 10-15ms (INSERT + verificación)
- **Asíncrono (Celery)**: < 1ms (solo encola task)
- **Target**: No degradar performance de verificación > 10%

## 6. Estrategias de Auditoría

### Opción 1: Auditoría Síncrona (desarrollo/staging)
```python
@require_permission('sistema.vistas.dashboards.ver', audit=True)
def dashboard(request):
    # Auditoría se ejecuta en mismo thread
    return render(request, 'dashboard.html')
```

### Opción 2: Auditoría Asíncrona (producción)
```python
# settings.py
PERMISSION_AUDIT_CONFIG = {
    'async_audit': True,  # Usar Celery
}

# tasks.py
@celery_app.task
def audit_permission_check(usuario_id, capacidad, resultado, ip, user_agent):
    AuditoriaPermiso.objects.create(...)
```

## 7. Retención de Datos

| Período | Acción |
|---------|--------|
| 0-90 días | Online (tabla principal) |
| 91-365 días | Archivo (tabla histórica) |
| > 365 días | Cold storage (S3/Glacier) |

## 8. Consultas de Auditoría

### Consulta 1: Accesos denegados últimas 24h
```sql
SELECT usuario_id, capacidad_codigo, COUNT(*) as intentos
FROM auditoria_permisos
WHERE resultado = FALSE
  AND timestamp > NOW() - INTERVAL '24 hours'
GROUP BY usuario_id, capacidad_codigo
ORDER BY intentos DESC;
```

### Consulta 2: Actividad por usuario
```sql
SELECT
    DATE_TRUNC('hour', timestamp) as hora,
    COUNT(*) as total_verificaciones,
    COUNT(*) FILTER (WHERE resultado = TRUE) as concedidas,
    COUNT(*) FILTER (WHERE resultado = FALSE) as denegadas
FROM auditoria_permisos
WHERE usuario_id = 123
  AND timestamp > NOW() - INTERVAL '7 days'
GROUP BY hora
ORDER BY hora DESC;
```

## 9. Alertas Automáticas

### Alerta 1: Múltiples accesos denegados
- Trigger: > 10 accesos denegados en 5 minutos
- Acción: Enviar alerta a seguridad
- Posible indicador: Ataque de escalación de privilegios

### Alerta 2: Acceso a capacidades críticas
- Trigger: Verificación de capacidades admin fuera de horario
- Acción: Notificar a administradores
- Capacidades críticas: *.usuarios.eliminar, *.permisos.*

## Changelog

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | 2025-01-09 | Sistema | Creación inicial |
