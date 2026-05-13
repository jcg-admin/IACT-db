```yml
created_at: 2026-04-29 00:45:00
project: IACT-docs
status: Aprobado
version: 1.0.0
```

# Gap UCs en .md vs .rst canonicos

## Resumen

- UCs canonicos en `.rst` (backup): **49**
- UCs documentados en `.md` (filename o H1): **18**
- UCs en .md AND en .rst (alineados): **0**
- **UCs SOLO en .md (gap real)**: **18**

## Gap por categoria

### Legacy v2 numerico O pedagogico (2)

| UC ID | Archivo (sample) | # apariciones |
|-------|------|----|
| `UC_001` | `2026-04-28-05-28-48-source-rebuild-frontend/inputs/canonical/UC-001-ejemplo.md` | 3 |
| `UC_010` | `2026-04-28-05-28-45-source-rebuild-requisitos/inputs/canonical/UC-010_REGISTRAR_LLAMADA_ENTRANTE_FINAL.md` | 2 |

### Otros (6)

| UC ID | Archivo (sample) | # apariciones |
|-------|------|----|
| `UC_BACK_001` | `2026-04-28-05-28-44-source-rebuild-normativa-gobernanza/inputs/canonical/UC-BACK-001-iniciar-sesion.md` | 1 |
| `UC_CALL_001` | `2026-04-28-05-28-44-source-rebuild-normativa-gobernanza/inputs/canonical/UC-CALL-001_registrar_llamada_entrante.md` | 1 |
| `UC_CALL_002` | `2026-04-28-05-28-44-source-rebuild-normativa-gobernanza/inputs/canonical/UC-CALL-002_atender_llamada.md` | 1 |
| `UC_CALL_003` | `2026-04-28-05-28-44-source-rebuild-normativa-gobernanza/inputs/canonical/UC-CALL-003_transferir_llamada.md` | 1 |
| `UC_CALL_004` | `2026-04-28-05-28-44-source-rebuild-normativa-gobernanza/inputs/canonical/UC-CALL-004_generar_reporte_rendimiento.md` | 1 |
| `UC_FRONT_001` | `2026-04-28-05-28-44-source-rebuild-normativa-gobernanza/inputs/canonical/UC-FRONT-001-ejemplo-sin-referencias.md` | 1 |

### UC_PERM_* (sub-dominio de ACC, candidato a fusionar) (10)

| UC ID | Archivo (sample) | # apariciones |
|-------|------|----|
| `UC_PERM_001` | `2026-04-28-05-28-44-source-rebuild-normativa-gobernanza/inputs/canonical/UC-PERM-001_asignar_grupo_a_usuario.md` | 2 |
| `UC_PERM_002` | `2026-04-28-05-28-44-source-rebuild-normativa-gobernanza/inputs/canonical/UC-PERM-002_revocar_grupo_a_usuario.md` | 2 |
| `UC_PERM_003` | `2026-04-28-05-28-44-source-rebuild-normativa-gobernanza/inputs/canonical/UC-PERM-003_conceder_permiso_excepcional.md` | 2 |
| `UC_PERM_004` | `2026-04-28-05-28-44-source-rebuild-normativa-gobernanza/inputs/canonical/UC-PERM-004_revocar_permiso_excepcional.md` | 2 |
| `UC_PERM_005` | `2026-04-28-05-28-44-source-rebuild-normativa-gobernanza/inputs/canonical/UC-PERM-005_crear_grupo_permisos.md` | 2 |
| `UC_PERM_006` | `2026-04-28-05-28-44-source-rebuild-normativa-gobernanza/inputs/canonical/UC-PERM-006_asignar_capacidades_grupo.md` | 2 |
| `UC_PERM_007` | `2026-04-28-05-28-44-source-rebuild-normativa-gobernanza/inputs/canonical/UC-PERM-007_verificar_permiso_usuario.md` | 2 |
| `UC_PERM_008` | `2026-04-28-05-28-44-source-rebuild-normativa-gobernanza/inputs/canonical/UC-PERM-008_generar_menu_dinamico.md` | 2 |
| `UC_PERM_009` | `2026-04-28-05-28-48-source-rebuild-frontend/inputs/canonical/UC-PERM-009_auditar_acceso.md` | 2 |
| `UC_PERM_010` | `2026-04-28-05-28-44-source-rebuild-normativa-gobernanza/inputs/canonical/UC-PERM-010_consultar_auditoria.md` | 2 |

