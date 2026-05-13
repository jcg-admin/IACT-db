---
id: RF-BACK-010
tipo: requisito-funcional
categoria: autenticacion
prioridad: alta
version: 1.0.0
fecha: 2025-11-17
---

# RF-BACK-010: Validar Credenciales contra Base de Datos

## Descripción

El sistema debe validar las credenciales de usuario (email y contraseña) contra la base de datos de usuarios registrados.

## Criterios de Aceptación

1. El sistema debe verificar que el email existe en la base de datos
2. El sistema debe comparar la contraseña ingresada con el hash almacenado
3. El sistema debe usar bcrypt o algoritmo equivalente para comparación
4. El sistema debe responder en menos de 500ms
5. El sistema debe registrar intentos fallidos

## Trazabilidad

**Implementa Casos de Uso**:
- UC-BACK-001: Iniciar Sesión

**Derivado de Reglas de Negocio**:
- RN-BACK-001: Usuario debe estar autenticado

**Cumple Atributos de Calidad**:
- RNF-BACK-006: Sistema debe responder en < 2 segundos

**Tests Relacionados**:
- TS-BACK-010-001: Test validación credenciales correctas
- TS-BACK-010-002: Test validación credenciales incorrectas
- TS-BACK-010-003: Test usuario inexistente

## Notas de Implementación

- Usar Django authentication framework
- Implementar rate limiting para prevenir ataques de fuerza bruta
- Registrar en log de auditoría
