---
id: UC-BACK-001
tipo: caso-uso
categoria: autenticacion
version: 1.0.0
fecha: 2025-11-17
---

# UC-BACK-001: Iniciar Sesión

## Actor Principal

Usuario del sistema

## Precondiciones

- Usuario tiene cuenta registrada en el sistema
- Sistema está disponible

## Flujo Principal

1. Usuario accede a la página de inicio de sesión
2. Sistema solicita credenciales (email y contraseña)
3. Usuario ingresa sus credenciales
4. Sistema valida las credenciales
5. Sistema genera token de sesión
6. Sistema redirige al usuario al dashboard

## Flujo Alternativo: Credenciales Incorrectas

4a. Si las credenciales son inválidas:
   - Sistema muestra mensaje de error
   - Sistema registra intento fallido
   - Retornar al paso 2

## Postcondiciones

- Usuario está autenticado en el sistema
- Token de sesión generado y almacenado
- Evento de login registrado en auditoría

## Reglas de Negocio Relacionadas

- RN-BACK-001: Usuario debe estar autenticado
- RN-BACK-028: Solo usuarios activos pueden iniciar sesión

## Requerimientos de Negocio Relacionados

- RNEG-BACK-001: Sistema de autenticación seguro

## Requisitos Funcionales Derivados

- RF-BACK-010: Validar credenciales contra base de datos
- RF-BACK-011: Generar token JWT con expiración de 15 minutos
- RF-BACK-012: Registrar intento de login en log de auditoría

## Atributos de Calidad Relacionados

- RNF-BACK-005: Contraseña debe tener mínimo 8 caracteres
- RNF-BACK-006: Sistema debe responder en < 2 segundos
- RNF-BACK-007: Sesión expira después de 30 minutos de inactividad
