---
id: RNF-BACK-023
tipo: atributo_calidad
subtipo: seguridad
categoria: BACK
version: 1.0.0
fecha_creacion: 2025-01-17
ultima_actualizacion: 2025-01-17
autor: Sistema de Gobernanza IACT
estado: borrador
prioridad: alta
---

# RNF-BACK-023: Rate Limiting

## Categoría

Seguridad

## Descripción

El sistema backend debe implementar rate limiting para proteger contra ataques de denegación de servicio, brute force, y abuso de recursos, limitando la cantidad de requests que un cliente puede realizar en un período de tiempo.

## Métrica Medible

**Métrica**: Límite de requests por IP y por endpoint

**Valor objetivo**: 100 req/min por IP (general), 5 req/min para login

**Condiciones**:
- Medido por dirección IP de origen
- Diferentes límites según criticidad del endpoint
- Ventana deslizante de 1 minuto

## Método de Medición

**Herramienta de medición**:
- Tests automatizados que intentan exceder límites
- Logs de rate limiting en producción
- Monitoreo de IPs bloqueadas

**Frecuencia de medición**: Por cada release + monitoreo continuo

**Proceso de medición**:
1. Test: Realizar 101 requests en 1 minuto desde misma IP
2. Verificar que request #101 recibe HTTP 429 (Too Many Requests)
3. Test: 6 intentos de login en 1 minuto
4. Verificar que intento #6 recibe HTTP 429
5. Verificar que límite se resetea después de 1 minuto

**Responsable de medición**: Equipo Backend + QA + DevOps

## Criterios de Aceptación

**Criterios de cumplimiento**:
1. **Endpoints generales**: Máximo 100 req/min por IP
2. **Login/Auth**: Máximo 5 req/min por IP
3. **Registro**: Máximo 3 req/hora por IP
4. **Respuesta**: HTTP 429 con header Retry-After
5. **Whitelist**: IPs internas/confiables exentas

**Umbrales**:
- **Login**: 5 req/min (estricto)
- **APIs generales**: 100 req/min (normal)
- **Reportes**: 10 req/min (costosos)

## Alcance

**Aplica a**: Todos los endpoints públicos del backend

**Módulos/Componentes afectados**:
- `/api/auth/login/` - 5 req/min
- `/api/auth/register/` - 3 req/hora
- `/api/auth/password-reset/` - 3 req/hora
- Todos los demás endpoints - 100 req/min

**Excepciones**:
- IPs de servidores internos (whitelist)
- Health check endpoints (sin límite)

## Trazabilidad

### Trazabilidad Ascendente

**Aplica a Casos de Uso**:
- UC-AUTH-001: Iniciar Sesión (proteger contra brute force)
- UC-USER-001: Registrar Usuario (proteger contra spam)

**Derivado de Reglas de Negocio**:
- RN-SEC-004: Proteger contra abuse y DoS

**Relacionado con Requerimientos de Negocio**:
- RNEG-SEC-003: Garantizar disponibilidad del servicio

### Trazabilidad Descendente

**Implementado en Requisitos Funcionales**:
- RF-BACK-130: Implementar django-ratelimit en todos los endpoints
- RF-BACK-131: Configurar whitelist de IPs internas
- RF-BACK-132: Retornar HTTP 429 con Retry-After header
- RF-BACK-133: Loguear IPs que exceden rate limit

**Tests de Validación**:
- TS-RNF-023-001: Test exceder rate limit login (debe recibir 429)
- TS-RNF-023-002: Test rate limit se resetea después de 1 min
- TS-RNF-023-003: Test whitelist IPs no tienen rate limit

## Impacto en Arquitectura

**Decisiones arquitectónicas influenciadas**:
- Implementar django-ratelimit con backend Redis
- Configurar diferentes límites por tipo de endpoint
- Implementar whitelist de IPs confiables
- Loguear intentos de abuse

**Componentes/Patrones requeridos**:
- django-ratelimit: Decoradores de rate limiting
- Redis: Storage de contadores de rate limiting
- Logging: Auditoría de IPs bloqueadas
- Whitelist: Configuración de IPs exentas

## Validación

**Tipo de validación**: Tests automatizados + monitoreo de abuse

**Frecuencia de validación**: Por cada release + monitoreo continuo

**Criterio de éxito de validación**:
Tests que intentan exceder límites reciben HTTP 429 correctamente

**Acción si no se cumple**:
- Bloquear release si rate limiting no funciona
- Ajustar límites si hay falsos positivos
- Investigar patrones de abuse

## Prioridad y Riesgos

**Prioridad**: Alta

**Justificación de prioridad**:
Rate limiting es defensa fundamental contra brute force y DoS

**Riesgos si no se cumple**:
- Ataques de brute force exitosos
- Denegación de servicio por abuse
- Costos elevados de infraestructura por tráfico malicioso
- Cuentas comprometidas

**Impacto de no cumplimiento**: Alto

## Estado de Cumplimiento

**Estado actual**: No implementado

**Última medición**: N/A

**Último valor medido**: N/A

**Comparación con objetivo**: No cumple

**Acciones correctivas**:
- Instalar django-ratelimit
- Configurar Redis como backend
- Implementar decoradores en endpoints críticos
- Configurar whitelist de IPs internas

## Dependencias

**Dependencias técnicas**:
- django-ratelimit
- Redis (para almacenar contadores)
- django-environ (para configurar whitelist)

**Dependencias de otros RNF**:
- RNF-BACK-022: Política contraseñas (complementa protección brute force)
- RNF-BACK-024: Auditoría (loguear intentos de abuse)

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | 100 req/min |

## Aprobación

**Especificado por**: Equipo de Seguridad + Arquitectura IACT

**Revisado por**: Pendiente

**Aprobado por**: Pendiente

**Validado por**: Pendiente
