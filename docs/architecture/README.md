# Arquitectura y Desarrollo

Documentación técnica para desarrolladores y mantenedores.

## Contenido

1. [DEVELOPMENT.md](DEVELOPMENT.md) - Guía de desarrollo
2. [PROVISIONERS.md](PROVISIONERS.md) - Sistema de provisioning
3. [MIGRACION-VAGRANT-A-SHELL.md](MIGRACION-VAGRANT-A-SHELL.md) - Plan de migración de Vagrant a shell scripts puros
4. [SEPARACION-IACT-API.md](SEPARACION-IACT-API.md) - Separación de responsabilidades con IACT-api

## Audiencia

Esta sección es para:
- Desarrolladores modificando el sistema
- Mantenedores del proyecto
- Personas implementando cambios en la arquitectura

## Documentos de Fase O (2026-05-08)

| Documento | Descripción |
|---|---|
| `HALLAZGOS-FASE-O-2026-05-08.md` | 3 bugs de producción y 4 hallazgos de infraestructura encontrados durante los tests de integración IVR |
| `TESTS-INTEGRACION-IVR.md` | Guía de referencia: arquitectura de `test_ivr_legacy`, fixtures, collation, checklist |

## Documentos de sesión 2026-05-09 — Plan v2.1 cierre

| Documento | Descripción |
|---|---|
| `PLAN-IMPLEMENTACION-V2.1.md` | Plan con 66 tareas atómicas para verificar el pipeline ETL IVR completo |
| `FLUJO-ETL-V2.1.md` | Diagrama de flujo del pipeline ETL v2.1 con heartbeat y concurrencia |
| `NOMENCLATURA-TABLAS-BILINGUE.md` | D-NOM-001: decisión de nomenclatura bilingüe — tablas de negocio en español, infraestructura en inglés. SQL del ALTER TABLE de `etl_runs` |
| `AUDITORIA-PLAN-V2.1-2026-05-09.md` | Estado verificado de las 66 tareas del plan v2.1: 66/66 PASS |
| `BITACORA-SESION-2026-05-09.md` | Bitácora cronológica de la sesión: hallazgos retroactivos Fases 1-5, decisiones, próximos pasos |
| `HALLAZGOS-EVENT-SCHEDULER-2026-05-09.md` | 5 hallazgos sobre Event Scheduler y `--skip-grant-tables` (Errores 1577/1227, DEFINER vacío, solución definitiva) + 2 hallazgos sobre aislamiento de funciones en T-019 |
| `HALLAZGOS-PLAN-V2.1-CIERRE-2026-05-09.md` | Consolidación: entorno sandbox, resultados T-082/T-083, arquitectura de configuración IACT-api, estado de tests al cierre |
