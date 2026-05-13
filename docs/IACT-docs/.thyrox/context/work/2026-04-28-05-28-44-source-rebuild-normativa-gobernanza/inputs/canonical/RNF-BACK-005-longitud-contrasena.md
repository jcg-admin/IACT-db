---
id: RNF-BACK-005
tipo: atributo-calidad
categoria: seguridad
subcategoria: autenticacion
prioridad: alta
version: 1.0.0
fecha: 2025-11-17
---

# RNF-BACK-005: Contraseña Mínimo 8 Caracteres

## Descripción

Toda contraseña en el sistema debe tener una longitud mínima de 8 caracteres y cumplir con requisitos de complejidad.

## Atributo de Calidad

**Categoría**: Seguridad
**Subcategoría**: Autenticación

## Requisitos Específicos

1. Longitud mínima: 8 caracteres
2. Debe incluir al menos:
   - Una letra mayúscula
   - Una letra minúscula
   - Un número
   - Un carácter especial
3. No debe ser igual a contraseñas anteriores (últimas 3)
4. No debe contener información personal obvia (nombre, email)

## Trazabilidad

**Aplica a Casos de Uso**:
- UC-BACK-001: Iniciar Sesión
- UC-BACK-003: Cambiar Contraseña
- UC-BACK-004: Recuperar Contraseña

**Derivado de Reglas de Negocio**:
- RN-BACK-001: Usuario debe estar autenticado

**Implementado en Requisitos Funcionales**:
- RF-BACK-015: Validar formato de contraseña

**Tests Relacionados**:
- TS-RNF-005-001: Test contraseña con < 8 caracteres es rechazada
- TS-RNF-005-002: Test contraseña con >= 8 caracteres es aceptada
- TS-RNF-005-003: Test contraseña sin mayúsculas es rechazada
- TS-RNF-005-004: Test contraseña sin números es rechazada

## Estándares Relacionados

- OWASP Password Guidelines
- NIST SP 800-63B
