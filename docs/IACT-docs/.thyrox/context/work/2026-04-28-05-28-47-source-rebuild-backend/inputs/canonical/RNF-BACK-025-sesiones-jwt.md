---
id: RNF-BACK-025
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

# RNF-BACK-025: Sesiones JWT Seguras

## Categoría

Seguridad

## Descripción

El sistema backend debe implementar autenticación con JWT (JSON Web Tokens) de forma segura, balanceando seguridad con experiencia de usuario mediante access tokens de corta duración y refresh tokens de larga duración.

## Métrica Medible

**Métrica**: Tiempos de expiración de tokens JWT

**Valor objetivo**:
- Access Token: 15 minutos
- Refresh Token: 7 días

**Condiciones**:
- Access token firmado con HS256 (HMAC SHA-256)
- Refresh token almacenado en HttpOnly cookie
- Secret key >= 256 bits de entropía
- Rotación de refresh token en cada uso

## Método de Medición

**Herramienta de medición**:
- Análisis de tokens generados (decode JWT)
- Tests automatizados de expiración
- Revisión de configuración djangorestframework-simplejwt

**Frecuencia de medición**: Por cada release + tests automatizados

**Proceso de medición**:
1. Generar access token y verificar campo `exp`
2. Calcular tiempo hasta expiración (debe ser ~15 min)
3. Generar refresh token y verificar expiración (~7 días)
4. Intentar usar access token después de 16 minutos (debe fallar)
5. Verificar que refresh token rota al usarse

**Responsable de medición**: Equipo Backend + Seguridad

## Criterios de Aceptación

**Criterios de cumplimiento**:
1. **Access Token**: Expira en 15 minutos
2. **Refresh Token**: Expira en 7 días
3. **Algoritmo**: HS256 (HMAC SHA-256)
4. **Claims**: Incluir user_id, exp, iat, jti (JWT ID)
5. **Storage**: Refresh token en HttpOnly, Secure, SameSite=Strict cookie
6. **Rotación**: Refresh token se renueva en cada uso

**Umbrales**:
- **Access Token**: 15 min (no modificable por seguridad)
- **Refresh Token**: 7 días (ajustable según política)

## Alcance

**Aplica a**: Todos los endpoints de autenticación

**Módulos/Componentes afectados**:
- `/api/auth/login/` - Genera access + refresh tokens
- `/api/auth/refresh/` - Renueva access token
- `/api/auth/logout/` - Invalida refresh token
- Todos los endpoints protegidos (requieren access token válido)

**Excepciones**:
- Endpoints públicos (no requieren autenticación)

## Trazabilidad

### Trazabilidad Ascendente

**Aplica a Casos de Uso**:
- UC-AUTH-001: Iniciar Sesión (genera tokens)
- UC-AUTH-002: Cerrar Sesión (invalida tokens)
- UC-AUTH-004: Renovar Sesión (refresh token)

**Derivado de Reglas de Negocio**:
- RN-SEC-006: Sesiones deben ser seguras y limitadas en tiempo

**Relacionado con Requerimientos de Negocio**:
- RNEG-SEC-002: Prevenir acceso no autorizado

### Trazabilidad Descendente

**Implementado en Requisitos Funcionales**:
- RF-BACK-150: Configurar djangorestframework-simplejwt
- RF-BACK-151: ACCESS_TOKEN_LIFETIME = 15 minutos
- RF-BACK-152: REFRESH_TOKEN_LIFETIME = 7 días
- RF-BACK-153: ROTATE_REFRESH_TOKENS = True
- RF-BACK-154: BLACKLIST_AFTER_ROTATION = True

**Tests de Validación**:
- TS-RNF-025-001: Test access token expira en 15 min
- TS-RNF-025-002: Test refresh token expira en 7 días
- TS-RNF-025-003: Test refresh token rota al usarse
- TS-RNF-025-004: Test logout invalida refresh token

## Impacto en Arquitectura

**Decisiones arquitectónicas influenciadas**:
- Usar djangorestframework-simplejwt
- Implementar token blacklist para logout
- Almacenar refresh token en HttpOnly cookie (NO localStorage)
- Rotación automática de refresh tokens

**Componentes/Patrones requeridos**:
- djangorestframework-simplejwt: JWT implementation
- Token Blacklist: Para invalidar tokens en logout
- HttpOnly Cookies: Almacenamiento seguro de refresh token
- Redis (opcional): Caché de blacklist para performance

## Validación

**Tipo de validación**: Tests automatizados de tokens

**Frecuencia de validación**: Por cada release + CI/CD

**Criterio de éxito de validación**:
- Access token decode muestra exp = iat + 15 min
- Refresh token decode muestra exp = iat + 7 días
- Token expirado es rechazado con HTTP 401

**Acción si no se cumple**:
- Bloquear release si configuración de tokens es incorrecta
- Corregir SIMPLE_JWT settings
- Actualizar tests

## Prioridad y Riesgos

**Prioridad**: Alta

**Justificación de prioridad**:
JWT mal configurados comprometen toda la seguridad de autenticación

**Riesgos si no se cumple**:
- Access tokens de larga duración: Mayor ventana de ataque si son robados
- Sin rotación: Refresh tokens comprometidos son válidos indefinidamente
- Almacenamiento inseguro: Tokens robados por XSS

**Impacto de no cumplimiento**: Crítico

## Estado de Cumplimiento

**Estado actual**: Implementado

**Última medición**: 2025-01-17

**Último valor medido**: Access=15min, Refresh=7días, Rotación=True

**Comparación con objetivo**: Cumple

**Acciones correctivas**:
- Ninguna (ya implementado correctamente)
- Considerar: Monitorear intentos de uso de tokens expirados

## Dependencias

**Dependencias técnicas**:
- djangorestframework-simplejwt
- Redis (opcional, para blacklist cache)
- Cookies (HttpOnly, Secure, SameSite)

**Dependencias de otros RNF**:
- RNF-BACK-026: HTTPS obligatorio (cookies Secure requieren HTTPS)
- RNF-BACK-024: Auditoría (loguear login/logout)

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | 15min/7días |

## Aprobación

**Especificado por**: Equipo de Seguridad + Arquitectura IACT

**Revisado por**: Pendiente

**Aprobado por**: Pendiente

**Validado por**: Pendiente
