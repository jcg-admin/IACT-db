# Scripts SQL archivados — historico/

## seed_historico_real.sql

**Archivado:** 2026-05-11  
**Origen:** `provisioners/mariadb/seed_historico_real.sql`  
**Razón:** Obsoleto. Referenciaba `@FORCE_RESEED` y `sp_seed_historico_real`
que fueron eliminados en las versiones actuales del sistema de seed.

### Reemplazado por

- **Nivel 1 — Seed sintético:** `provisioners/mariadb/seed_historico.sql` v3.0.0  
  Datos genéricos. Ejecutado automáticamente por `schema_historico.sh`.

- **Nivel 2 — Seed con perfiles calibrados:** `provisioners/mariadb/poblar_historico.py` v1.1.0  
  Usa distribuciones por quarter (`perfiles/q0N_YYYY.py`).
  Ejecutado automáticamente por `schema_historico.sh`.

### Por qué no se elimina

El archivo contiene datos de referencia sobre distribuciones reales de producción
Q1-Q3 2025 (menús, VDNs, etiquetas) que pueden ser útiles para futura calibración
de perfiles o documentación del dominio.

### Dependencias eliminadas

- `@FORCE_RESEED` — eliminado en `seed_historico.sql` v3.0.0 (H-SEED-002)
- `sp_seed_historico_real` — stored procedure nunca desplegado en producción
- No está referenciado en ningún script activo del proyecto
