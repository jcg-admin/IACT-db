---
id: RNF-BACK-026
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

# RNF-BACK-026: HTTPS Obligatorio (TLS 1.3)

## Categoría

Seguridad

## Descripción

El sistema backend debe forzar el uso de HTTPS en todas las comunicaciones, utilizando TLS 1.3 con configuración segura para proteger la confidencialidad e integridad de los datos en tránsito.

## Métrica Medible

**Métrica**: Porcentaje de tráfico sobre HTTPS con TLS 1.3

**Valor objetivo**: 100% de tráfico sobre HTTPS con TLS 1.3

**Condiciones**:
- HTTP redirige automáticamente a HTTPS (301 permanente)
- TLS versión mínima: 1.3
- Certificado válido y no auto-firmado
- Grade A+ en SSL Labs

## Método de Medición

**Herramienta de medición**:
- SSL Labs Server Test (https://www.ssllabs.com/ssltest/)
- Browser DevTools (Security tab)
- curl -I para verificar redirect HTTP→HTTPS

**Frecuencia de medición**: Por cada release + mensual en producción

**Proceso de medición**:
1. Ejecutar SSL Labs test en dominio de producción
2. Verificar grade = A o A+
3. Verificar TLS versión mínima = 1.3
4. Intentar acceso HTTP y verificar redirect 301 a HTTPS
5. Verificar certificado válido y no expirado

**Responsable de medición**: DevOps + Seguridad

## Criterios de Aceptación

**Criterios de cumplimiento**:
1. **HTTPS Obligatorio**: HTTP redirige a HTTPS (Django SECURE_SSL_REDIRECT=True)
2. **TLS 1.3**: Versión mínima TLS 1.3 (TLS 1.2 aceptable si 1.3 no disponible)
3. **Certificado Válido**: Certificado de CA confiable (NO auto-firmado en prod)
4. **HSTS**: HTTP Strict Transport Security habilitado (max-age >= 31536000)
5. **Cipher Suites**: Solo cipher suites fuertes (NO RC4, NO 3DES)
6. **SSL Labs Grade**: A o A+

**Umbrales**:
- **Mínimo aceptable**: TLS 1.2, Grade B
- **Objetivo**: TLS 1.3, Grade A
- **Óptimo**: TLS 1.3, Grade A+

## Alcance

**Aplica a**: Todas las comunicaciones del backend

**Módulos/Componentes afectados**:
- Nginx/Apache (terminación TLS)
- Django settings (SECURE_* settings)
- Todas las APIs REST y GraphQL
- Django Admin

**Excepciones**:
- Entorno de desarrollo local (puede usar HTTP)
- Health check interno (puede usar HTTP desde localhost)

## Trazabilidad

### Trazabilidad Ascendente

**Aplica a Casos de Uso**:
- Todos los casos de uso (seguridad de comunicaciones)

**Derivado de Reglas de Negocio**:
- RN-SEC-007: Comunicaciones deben estar encriptadas

**Relacionado con Requerimientos de Negocio**:
- RNEG-SEC-001: Cumplir con estándares de seguridad

### Trazabilidad Descendente

**Implementado en Requisitos Funcionales**:
- RF-BACK-160: SECURE_SSL_REDIRECT = True (producción)
- RF-BACK-161: SECURE_HSTS_SECONDS = 31536000
- RF-BACK-162: SECURE_HSTS_INCLUDE_SUBDOMAINS = True
- RF-BACK-163: SESSION_COOKIE_SECURE = True
- RF-BACK-164: CSRF_COOKIE_SECURE = True
- RF-BACK-165: Configurar nginx con TLS 1.3

**Tests de Validación**:
- TS-RNF-026-001: Test HTTP redirige a HTTPS
- TS-RNF-026-002: Test HSTS header presente
- TS-RNF-026-003: Test certificado válido
- TS-RNF-026-004: Test SSL Labs grade >= A

## Impacto en Arquitectura

**Decisiones arquitectónicas influenciadas**:
- Nginx/Apache maneja terminación TLS
- Django configurado para HTTPS forzado
- Certificados renovados automáticamente (Let's Encrypt + certbot)
- HSTS habilitado para prevenir downgrade attacks

**Componentes/Patrones requeridos**:
- Nginx/Apache: Terminación TLS
- Let's Encrypt + Certbot: Certificados gratuitos y auto-renovables
- Django SECURE_* settings: Configuración segura
- HSTS: Prevenir downgrade attacks

## Validación

**Tipo de validación**: SSL Labs test + tests automatizados

**Frecuencia de validación**: Mensual + por cada cambio de configuración

**Criterio de éxito de validación**:
- SSL Labs grade >= A
- HTTP requests redirigen a HTTPS
- HSTS header presente

**Acción si no se cumple**:
- Bloquear deployment si HTTPS no funciona
- Corregir configuración nginx/Apache
- Renovar certificado si está expirado

## Prioridad y Riesgos

**Prioridad**: Alta

**Justificación de prioridad**:
HTTPS es fundamental para proteger credenciales y datos en tránsito

**Riesgos si no se cumple**:
- Credenciales interceptadas (man-in-the-middle)
- Datos sensibles expuestos en tránsito
- Incumplimiento de regulaciones
- Pérdida de confianza de usuarios

**Impacto de no cumplimiento**: Crítico

## Estado de Cumplimiento

**Estado actual**: Implementado

**Última medición**: 2025-01-17

**Último valor medido**: HTTPS habilitado, TLS 1.2, Grade A (estimado)

**Comparación con objetivo**: Cumple parcialmente (necesita TLS 1.3)

**Acciones correctivas**:
- Actualizar nginx para soportar TLS 1.3
- Verificar SSL Labs test en producción
- Configurar auto-renovación de certificados con certbot

## Dependencias

**Dependencias técnicas**:
- Nginx/Apache con soporte TLS 1.3
- Let's Encrypt + Certbot para certificados
- Django SECURE_* settings configurados

**Dependencias de otros RNF**:
- RNF-BACK-021: Encriptación (HTTPS es encriptación en tránsito)
- RNF-BACK-025: Sesiones JWT (cookies Secure requieren HTTPS)

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | TLS 1.3 |

## Aprobación

**Especificado por**: Equipo de Seguridad + DevOps + Arquitectura IACT

**Revisado por**: Pendiente

**Aprobado por**: Pendiente

**Validado por**: Pendiente
