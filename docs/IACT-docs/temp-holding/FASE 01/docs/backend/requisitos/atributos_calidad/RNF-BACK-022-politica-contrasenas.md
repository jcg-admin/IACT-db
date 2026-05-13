---
id: RNF-BACK-022
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

# RNF-BACK-022: Política de Contraseñas (NIST 800-63B)

## Categoría

Seguridad

## Descripción

El sistema backend debe implementar una política de contraseñas robusta basada en las recomendaciones de NIST 800-63B, balanceando seguridad con usabilidad y previniendo contraseñas débiles comunes.

## Métrica Medible

**Métrica**: Cumplimiento de criterios de política de contraseñas

**Valor objetivo**: 100% de cumplimiento con NIST 800-63B

**Condiciones**:
- Longitud mínima: >= 8 caracteres
- Longitud máxima: >= 64 caracteres
- NO expiración forzada periódica (NIST 800-63B desaconseja)
- Verificación contra lista de contraseñas comunes
- Hash con Argon2 (NO MD5/SHA1)

## Método de Medición

**Herramienta de medición**:
- Tests automatizados de validación de contraseñas
- Análisis de contraseñas en BD (hashes, nunca plaintext)
- Revisión de código de validators

**Frecuencia de medición**: Por cada release + tests automatizados en CI

**Proceso de medición**:
1. Verificar que PasswordValidator rechaza contraseñas < 8 caracteres
2. Verificar que acepta contraseñas de 64 caracteres
3. Verificar que rechaza contraseñas comunes (ej: "password123")
4. Verificar que usa Argon2PasswordHasher
5. Verificar que NO hay expiración forzada

**Responsable de medición**: Equipo Backend + QA

## Criterios de Aceptación

**Criterios de cumplimiento**:
1. **Longitud**: Mínimo 8 caracteres, máximo >= 64 caracteres
2. **Complejidad**: NO requisitos obligatorios de símbolos/números (NIST desaconseja)
3. **Blacklist**: Rechazar contraseñas en lista de 10,000 más comunes
4. **Hash**: Argon2 con salt aleatorio por contraseña
5. **Expiración**: NO forzar cambio periódico (excepto si hay breach)
6. **Rate limiting**: Máximo 5 intentos fallidos en 5 minutos

**Umbrales**:
- **Mínimo aceptable**: Cumple 4/6 criterios
- **Objetivo**: Cumple 6/6 criterios
- **Óptimo**: 6/6 + verificación breach con Have I Been Pwned API

## Alcance

**Aplica a**: Todas las contraseñas de usuarios del sistema

**Módulos/Componentes afectados**:
- Modelo User de Django
- Formularios de registro y cambio de contraseña
- Endpoints de autenticación
- Password validators de Django

**Excepciones**:
- Contraseñas de servicio/API pueden tener requisitos diferentes

## Trazabilidad

### Trazabilidad Ascendente

**Aplica a Casos de Uso**:
- UC-AUTH-001: Iniciar Sesión
- UC-AUTH-002: Cambiar Contraseña
- UC-USER-001: Registrar Usuario
- UC-AUTH-003: Recuperar Contraseña

**Derivado de Reglas de Negocio**:
- RN-SEC-003: Contraseñas deben ser seguras pero usables

**Relacionado con Requerimientos de Negocio**:
- RNEG-SEC-002: Prevenir acceso no autorizado

### Trazabilidad Descendente

**Implementado en Requisitos Funcionales**:
- RF-BACK-120: Configurar MinimumLengthValidator(8)
- RF-BACK-121: Configurar CommonPasswordValidator
- RF-BACK-122: Configurar Argon2PasswordHasher
- RF-BACK-123: NO implementar expiración de contraseña

**Tests de Validación**:
- TS-RNF-022-001: Test contraseña < 8 caracteres es rechazada
- TS-RNF-022-002: Test contraseña "password123" es rechazada
- TS-RNF-022-003: Test contraseña 64 caracteres es aceptada
- TS-RNF-022-004: Test hash usa Argon2

## Impacto en Arquitectura

**Decisiones arquitectónicas influenciadas**:
- Configurar Django AUTH_PASSWORD_VALIDATORS
- Usar Argon2PasswordHasher (instalar argon2-cffi)
- Implementar rate limiting en endpoint de login
- NO implementar expiración de contraseña

**Componentes/Patrones requeridos**:
- Django Password Validators: MinimumLength, CommonPassword, UserAttribute
- Argon2PasswordHasher: Hash seguro de contraseñas
- django-ratelimit: Limitar intentos de login
- pwned-passwords-django (opcional): Verificar breaches

## Validación

**Tipo de validación**: Tests automatizados de validators

**Frecuencia de validación**: Por cada PR (CI/CD check)

**Criterio de éxito de validación**:
Todos los tests de TS-RNF-022-* pasan exitosamente

**Acción si no se cumple**:
- Bloquear PR si tests de contraseña fallan
- Remediar configuración de validators
- Actualizar documentación de usuario si necesario

## Prioridad y Riesgos

**Prioridad**: Alta

**Justificación de prioridad**:
Contraseñas débiles son vector de ataque principal para cuentas de usuario

**Riesgos si no se cumple**:
- Cuentas comprometidas por brute force
- Acceso no autorizado a datos sensibles
- Incumplimiento de regulaciones de seguridad

**Impacto de no cumplimiento**: Alto

## Estado de Cumplimiento

**Estado actual**: Implementado

**Última medición**: 2025-01-17

**Último valor medido**: 5/6 criterios (falta verificación breach)

**Comparación con objetivo**: Cumple (mínimamente)

**Acciones correctivas**:
- Considerar implementar pwned-passwords-django
- Documentar política de contraseñas para usuarios
- Implementar indicador de fortaleza de contraseña en frontend

## Dependencias

**Dependencias técnicas**:
- argon2-cffi (para Argon2PasswordHasher)
- Django built-in password validators
- django-ratelimit (para rate limiting)
- pwned-passwords-django (opcional)

**Dependencias de otros RNF**:
- RNF-BACK-023: Rate limiting (protege contra brute force)
- RNF-BACK-021: Encriptación (contraseñas hasheadas, nunca plaintext)

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-17 | Sistema Gobernanza IACT | Versión inicial | N/A | NIST 800-63B |

## Aprobación

**Especificado por**: Equipo de Seguridad + Arquitectura IACT

**Revisado por**: Pendiente

**Aprobado por**: Pendiente

**Validado por**: Pendiente
