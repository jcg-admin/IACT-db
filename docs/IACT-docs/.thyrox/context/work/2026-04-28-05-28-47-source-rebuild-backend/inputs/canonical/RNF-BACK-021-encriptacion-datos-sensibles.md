---
id: RNF-BACK-021
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

# RNF-BACK-021: Encriptación de Datos Sensibles

## Categoría

Seguridad

## Descripción

El sistema backend debe encriptar todos los datos sensibles tanto en reposo (base de datos) como en tránsito (comunicaciones), utilizando algoritmos de encriptación fuertes y probados para proteger la confidencialidad de la información.

## Métrica Medible

**Métrica**: Porcentaje de datos sensibles encriptados

**Valor objetivo**: 100% de datos sensibles encriptados con AES-256

**Condiciones**:
- Datos en reposo: AES-256 en base de datos
- Datos en tránsito: TLS 1.3
- Gestión de claves: Secure key storage (no hardcoded)

## Método de Medición

**Herramienta de medición**:
- Auditoría de código para identificar datos sensibles
- Análisis de BD para verificar encriptación
- SSL Labs para validar TLS configuration

**Frecuencia de medición**: Auditoría trimestral + por cada release

**Proceso de medición**:
1. Identificar campos sensibles en modelos (passwords, tokens, PII)
2. Verificar que usan django-cryptography o similar
3. Verificar que SECRET_KEY no está hardcoded
4. Validar configuración TLS en nginx/Apache
5. Confirmar que 100% de datos sensibles están encriptados

**Responsable de medición**: Equipo de Seguridad + Backend

## Criterios de Aceptación

**Criterios de cumplimiento**:
1. **Contraseñas**: Hashed con Argon2 (NUNCA plaintext)
2. **Tokens/API Keys**: Encriptados con AES-256 en BD
3. **PII** (emails, teléfonos): Encriptados en BD si regulación lo requiere
4. **Comunicaciones**: HTTPS con TLS 1.3 obligatorio
5. **Secretos**: Almacenados en variables de entorno, NO en código

**Umbrales**:
- **Mínimo aceptable**: 95% de datos sensibles encriptados
- **Objetivo**: 100% de datos sensibles encriptados
- **Óptimo**: 100% + rotación automática de claves

## Alcance

**Aplica a**: Todos los datos sensibles del sistema

**Módulos/Componentes afectados**:
- Modelo User (contraseñas)
- Tokens de autenticación (JWT secrets)
- Configuración de conexiones a BD (credenciales)
- API keys para servicios externos
- Logs (NO loguear datos sensibles sin redactar)

**Excepciones**:
- Datos ya públicos no requieren encriptación

## Trazabilidad

### Trazabilidad Ascendente

**Aplica a Casos de Uso**:
- UC-AUTH-001: Iniciar Sesión (contraseñas)
- UC-AUTH-002: Cambiar Contraseña
- UC-INTEGRATION-001: Conectar con IVR (API keys)

**Derivado de Reglas de Negocio**:
- RN-SEC-002: Datos sensibles deben estar protegidos

**Relacionado con Requerimientos de Negocio**:
- RNEG-SEC-001: Cumplir con regulaciones de protección de datos

### Trazabilidad Descendente

**Implementado en Requisitos Funcionales**:
- RF-BACK-110: Usar Argon2PasswordHasher en Django
- RF-BACK-111: Implementar django-cryptography para campos sensibles
- RF-BACK-112: Almacenar SECRET_KEY en variable de entorno
- RF-BACK-113: Configurar HTTPS obligatorio (SECURE_SSL_REDIRECT)

**Tests de Validación**:
- TS-RNF-021-001: Test que contraseñas nunca se almacenan en plaintext
- TS-RNF-021-002: Test que SECRET_KEY no está en código
- TS-RNF-021-003: Test de SSL/TLS configuration con SSL Labs

## Impacto en Arquitectura

**Decisiones arquitectónicas influenciadas**:
- Usar django-cryptography para campos encriptados en BD
- Usar Argon2 (NO MD5, NO SHA1) para passwords
- Configurar TLS 1.3 en nginx/Apache
- Usar django-environ para gestión de secretos

**Componentes/Patrones requeridos**:
- django-cryptography: Encriptación transparente de campos
- Argon2: Password hashing seguro
- TLS 1.3: Encriptación en tránsito
- django-environ: Gestión de secretos desde env vars

## Validación

**Tipo de validación**: Auditoría de seguridad + análisis de código

**Frecuencia de validación**: Trimestral + por cada release

**Criterio de éxito de validación**:
- 0 contraseñas en plaintext en BD
- 0 secretos hardcoded en código
- SSL Labs grade A+ para configuración TLS

**Acción si no se cumple**:
- Bloquear release si hay secretos hardcoded
- Encriptar inmediatamente datos sensibles encontrados en plaintext
- Remediar configuración TLS débil

## Prioridad y Riesgos

**Prioridad**: Alta

**Justificación de prioridad**:
Encriptación es fundamental para proteger datos de clientes

**Riesgos si no se cumple**:
- Exposición de credenciales en breach de BD
- Incumplimiento de regulaciones (GDPR, etc.)
- Pérdida de confianza de clientes
- Responsabilidad legal

**Impacto de no cumplimiento**: Crítico

## Estado de Cumplimiento

**Estado actual**: Parcialmente implementado

**Última medición**: 2025-01-17

**Último valor medido**: ~80% (contraseñas OK, algunos tokens sin encriptar)

**Comparación con objetivo**: No cumple

**Acciones correctivas**:
- Auditar todos los campos sensibles en modelos
- Implementar django-cryptography para tokens/API keys
- Verificar que SECRET_KEY está en env var
- Configurar TLS 1.3 en servidor web

## Dependencias

**Dependencias técnicas**:
- django-cryptography
- Argon2-cffi (para password hashing)
- django-environ
- nginx/Apache con soporte TLS 1.3

**Dependencias de otros RNF**:
- RNF-BACK-026: HTTPS obligatorio (TLS 1.3)

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | AES-256 |

## Aprobación

**Especificado por**: Equipo de Seguridad + Arquitectura IACT

**Revisado por**: Pendiente

**Aprobado por**: Pendiente

**Validado por**: Pendiente
