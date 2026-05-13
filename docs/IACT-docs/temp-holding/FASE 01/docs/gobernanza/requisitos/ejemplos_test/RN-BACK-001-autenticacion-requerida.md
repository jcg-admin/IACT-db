---
id: RN-BACK-001
tipo: regla-negocio
categoria: seguridad
version: 1.0.0
fecha: 2025-11-17
---

# RN-BACK-001: Usuario Debe Estar Autenticado

## Descripción

Todo acceso al sistema debe requerir autenticación previa del usuario mediante credenciales válidas.

## Tipo de Regla

Restricción

## Justificación

Cumplimiento con políticas de seguridad organizacionales y protección de datos personales según LFPDPPP.

## Impacto en Requisitos

**Requerimientos de Negocio**:
- RNEG-BACK-001: Sistema de autenticación seguro

**Requerimientos de Usuario**:
- UC-BACK-001: Iniciar Sesión
- UC-BACK-003: Cambiar Contraseña

**Requisitos Funcionales**:
- RF-BACK-010: Validar credenciales
- RF-BACK-011: Generar token de sesión

**Atributos de Calidad**:
- RNF-BACK-005: Contraseña debe tener mínimo 8 caracteres
- RNF-BACK-007: Sesión expira después de 30 minutos de inactividad
