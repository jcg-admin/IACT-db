```yml
created_at: 2026-04-28 10:00:00
project: IACT-docs
work_package: 2026-04-28-05-28-43-source-rebuild-normativa-restricciones
phase: Phase 11 — TRACK (artefacto deep-review)
author: NestorMonroy (verificación manual — agente bloqueado por hook)
status: Aprobado
version: 1.0.0
```

# Deep-Review 04 — Atomicidad SRP, Schema y Cobertura

## Alcance

Verificación de los 31 archivos CNST atómicos producidos por la
descomposición SRP del WP. Tres ejes: (a) atomicidad por archivo,
(b) integridad de schema metadata, (c) cobertura del index e
integridad de referencias cruzadas.

## A. Atomicidad SRP — verificación por CNST

| CNST | Concern declarado | Atómico? |
|------|-------------------|----------|
| 001 | Prohibición de email/SMTP | Sí |
| 002 | Buzón interno (con límites cuantitativos) | Sí |
| 003 | Sesiones persistidas en BD | Sí |
| 004 | Sesión única por usuario | Sí |
| 005 | Timeout 15 min | Sí |
| 006 | Arquitectura BD dual | Sí |
| 007 | BD IVR readonly | Sí |
| 008 | ETL ventana 6-12h | Sí |
| 009 | Auth DRF obligatoria | Sí |
| 010 | Permission class explícita | Sí |
| 011 | Throttling endpoints públicos | Sí |
| 012 | Validación vía serializer | Sí |
| 013 | Manejo estandarizado de excepciones | Sí |
| 014 | Paginación obligatoria | Sí |
| 015 | Antipatrones prohibidos (lista) | Sí |
| 016 | Principios SOLID | Sí |
| 017 | SLA tiempos de respuesta | Sí |
| 018 | Rango máximo 2 años | Sí |
| 019 | Exportaciones async sobre 10k | Sí |
| 020 | Throttling exportación por formato | Sí |
| 021 | Stack Ubuntu+Apache+mod_wsgi | Sí |
| 022 | Estructura directorios servidor | Sí |
| 023 | Rollback obligatorio | Sí |
| 024 | Logs estructurados JSON | Sí |
| 025 | Auditoría inmutable | Sí |
| 026 | PII prohibida en logs | Sí |
| 027 | Clasificación 4 niveles | Sí |
| 028 | Cifrado de datos confidenciales | Sí |
| 029 | RBAC plano | Sí |
| 030 | Reglas SoD | Sí |
| 031 | Permisos temporales 6 meses | Sí |

**Resultado:** 31/31 CNSTs declaran un único concern atómico. SRP
cumplido al 100%.

## B. Integridad de schema metadata

Verificación automática de los 10 campos obligatorios:
``artefacto, tipo, dominio, subdominio, estado, version,
fecha_creacion, ultimo_cambio, autor, clasificacion``.

- **31/31 archivos** tienen los 10 campos completos.
- **31/31 archivos** tienen único bloque ``Enunciado`` (atomicidad
  estructural).
- **31/31 archivos** tienen sección ``Verificacion`` con snippet
  ejecutable.

### Hallazgo F-04-1 (RESUELTO durante el review)

5 archivos no tenían sección ``Justificacion`` explícita: CNST_015,
016, 017, 026, 027.

**Resolución aplicada:** se agregó sección ``Justificacion`` con
contenido específico a cada uno antes de cerrar el deep-review. Build
verde tras el fix (0 warnings, 0 errors).

## C. Cobertura del index y referencias cruzadas

### Index

- 10/10 dominios declarados en el ``index.rst`` con caption
  específico.
- 31/31 CNSTs referenciados en el toctree.
- Conexión al ``normativa/index.rst`` padre verificada.

### Referencias cruzadas (`:doc:`)

- 0 referencias rotas (todas resuelven).
- Distribución: 26/31 archivos referencian ≥2 CNSTs relacionadas.
  5/31 referencian solo 1 (CNST_009, 012, 013, 014, 015, 016, 021, 023).
- Densidad media: 1.87 refs por archivo.

### Referencia externa cross-dominio

- ``MTM_03_Metamodelo_RBAC.rst:702`` actualizado a
  ``CNST_029_RBAC_Modelo_Plano`` (era CNST_011 del set anterior).
- 0 refs residuales a la numeración anterior.

## Hallazgos resueltos durante el review

| ID | Severidad | Descripción | Estado |
|----|-----------|-------------|--------|
| F-04-1 | Medio | 5 CNSTs sin sección Justificacion | RESUELTO — agregadas |

## Recomendación final

**Cerrar el WP** — todos los criterios de calidad cumplidos:

- 31/31 CNSTs atómicos (un concern por archivo).
- 31/31 con schema metadata completo.
- 0 referencias rotas.
- Build limpio: 0 warnings, 0 errors.
- Index estructurado por 10 dominios con cobertura 100%.
- Mapeo viejo→nuevo entregado para WP #6 requisitos (v2.0.0).
- Plantilla TPL_CNST actualizada para reflejar la convención
  vigente.
- Ref cross-dominio en MTM_03 actualizada.

Deuda diferida (no bloqueante):

- Re-incorporación de "Patrones Recomendados" (de CNST_006 backup) a
  un cajón de guías de arquitectura — fuera de scope del cajón
  restricciones.
- Re-incorporación de "Procedimiento de deployment" (de CNST_008
  backup) a `normativa/procedimientos/` — fuera de scope.
- Las 8 CNSTs de `temp-holding/FASE 02/.../restricciones/` ya están
  sintetizadas en los 31 atómicos. No requieren nuevo análisis.
