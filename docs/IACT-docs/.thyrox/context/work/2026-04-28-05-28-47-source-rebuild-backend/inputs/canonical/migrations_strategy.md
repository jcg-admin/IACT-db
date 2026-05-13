---
title: Estrategia de Migraciones Django
date: 2025-11-13
domain: backend
status: active
---

# Estrategia de Migraciones Django

**Autor**: Backend Team
**Fecha**: 2025-11-09
**Estado**: ACTIVO

## Indice

- [Resumen Ejecutivo](#resumen-ejecutivo)
- [Estado Actual](#estado-actual)
- [Estrategia de Migraciones](#estrategia-de-migraciones)
- [Buenas Practicas](#buenas-practicas)
- [Procedimientos de Rollback](#procedimientos-de-rollback)
- [Checklist de Migracion](#checklist-de-migracion)
- [Referencias](#referencias)

---

## Resumen Ejecutivo

Este documento define la estrategia de migraciones de base de datos para el proyecto IACT. Las migraciones Django son el mecanismo para evolucionar el esquema de base de datos de manera controlada, versionada y reproducible.

**Objetivo principal**: Garantizar que cambios en el esquema de base de datos sean seguros, reversibles, y auditables.

**Alcance**: Todas las apps Django del proyecto (11 apps en total).

---

## Estado Actual

### Migraciones Existentes

| App | Migraciones | Estado | Modelos |
|-----|-------------|--------|---------|
| **configuration** | 2 | COMPLETO | Configuracion, ConfiguracionHistorial |
| **dashboard** | 1 | COMPLETO | DashboardConfiguracion |
| **users** | 1 | COMPLETO | 8 tablas (permisos granulares) |
| **common** | 0 | N/A | Abstract models (no DB tables) |
| **analytics** | 0 | PENDIENTE | CallAnalytics, DailyMetrics |
| **audit** | 0 | PENDIENTE | AuditLog |
| **authentication** | 0 | PENDIENTE | SecurityQuestion, LoginAttempt |
| **etl** | 0 | PENDIENTE | ETL jobs, extractors, loaders |
| **ivr_legacy** | 0 | N/A | managed=False (legacy DB) |
| **notifications** | 0 | PENDIENTE | InternalMessage |
| **reports** | 0 | PENDIENTE | ReportTemplate, GeneratedReport |

### Estadisticas

- **Total apps**: 11
- **Apps con migraciones**: 3 (configuration, dashboard, users)
- **Apps pendientes de migracion**: 6
- **Apps sin necesidad**: 2 (common, ivr_legacy)

---

## Estrategia de Migraciones

### 1. Filosofia de Migraciones

**Principios fundamentales**:

1. **Inmutabilidad**: Migraciones aplicadas NUNCA se modifican
2. **Versionamiento**: Cada cambio de esquema genera nueva migracion
3. **Atomicidad**: Cada migracion es una transaccion atomica
4. **Documentacion**: Cada migracion tiene docstring explicando proposito
5. **Reversibilidad**: Planear rollback desde el inicio
6. **Testing**: Migraciones se prueban en entorno de desarrollo antes de produccion

### 2. Ciclo de Vida de una Migracion

```
[Cambio en models.py]
 |
 v
[makemigrations] -----> [Revision manual]
 | |
 | v
 | [Ajustar si necesario]
 | |
 v v
[Commit migracion] -----> [Testing en dev]
 | |
 | v
 | [Aplicar en staging]
 | |
 v v
[Deploy a produccion] <--- [Validacion exitosa]
```

### 3. Tipos de Migraciones

#### 3.1 Migraciones de Esquema (Schema Migrations)

**Proposito**: Cambios en estructura de tablas (CREATE, ALTER, DROP)

**Ejemplos**:
- Crear nueva tabla
- Agregar columna
- Modificar tipo de dato
- Agregar indice
- Crear foreign key

**Consideraciones**:
- Validar impacto en performance (LOCK de tabla)
- Crear indices en transaccion separada si tabla grande (> 1M rows)
- Usar `db_index=True` para indices simples
- Usar `migrations.AddIndex()` para indices compuestos

#### 3.2 Migraciones de Datos (Data Migrations)

**Proposito**: Transformar o migrar datos existentes

**Ejemplos**:
- Poblar tabla nueva con datos de tabla antigua
- Transformar valores (ej: normalizar formato)
- Migrar datos entre columnas
- Seed de datos iniciales

**Consideraciones**:
- Usar `migrations.RunPython()` para logica compleja
- SIEMPRE incluir funcion inversa para rollback
- Evitar imports directos de models (usar `apps.get_model()`)
- Procesar en batches si volumen grande (> 100K rows)

#### 3.3 Migraciones de Indice (Index Migrations)

**Proposito**: Crear o eliminar indices para performance

**Ejemplos**:
```python
migrations.AddIndex(
 model_name='configuracion',
 index=models.Index(fields=['categoria', 'activa'], name='config_cat_act_idx'),
)
```

**Consideraciones**:
- Indices compuestos ANTES de indices simples
- En produccion: usar `CONCURRENTLY` (PostgreSQL) para evitar locks

---

## Buenas Practicas

### 1. Naming Conventions

**Migraciones autogeneradas**: Django genera nombres automaticos
```
0001_initial.py
0002_alter_configuracion_valor.py
0003_add_field_categoria.py
```

**Migraciones custom**: Usar nombres descriptivos
```
0001_initial_permisos_granular.py
0002_configuracion_historial.py
0003_seed_capacidades_default.py
```

### 2. Docstrings Obligatorios

**Template**:
```python
"""
Breve descripcion del cambio.

Explica el proposito, impacto, y consideraciones especiales.

Referencia: docs/X o issue #Y
"""
```

**Ejemplo real**:
```python
"""
Migracion inicial del sistema de permisos granular.

Crea 8 tablas base:
1. funciones - Recursos del sistema
2. capacidades - Acciones granulares
3. funcion_capacidades - Relacion N:M funciones-capacidades
4. grupos_permisos - Grupos funcionales sin jerarquia
5. grupo_capacidades - Relacion N:M grupos-capacidades
6. usuarios_grupos - Relacion N:M usuarios-grupos
7. permisos_excepcionales - Permisos temporales o permanentes
8. auditoria_permisos - Log de accesos

Referencia: docs/backend/requisitos/prioridad_01_estructura_base_datos.md
"""
```

### 3. Fields Best Practices

**Siempre incluir**:
- `help_text`: Descripcion del campo
- `db_index=True`: Si campo se usa en filtros/busquedas
- `null=True, blank=True`: Si campo opcional
- `default`: Valor por defecto si aplica

**Ejemplo**:
```python
('categoria', models.CharField(
 max_length=50,
 db_index=True,
 choices=CATEGORIA_CHOICES,
 help_text='Categoria de la configuracion',
))
```

### 4. Indices

**Cuando crear indice**:
- Campos en WHERE clauses frecuentes
- Foreign keys (Django NO crea indice automatico)
- Campos en ORDER BY
- Campos en JOIN conditions

**Indices compuestos**:
```python
migrations.AddIndex(
 model_name='configuracionhistorial',
 index=models.Index(fields=['clave', '-timestamp'], name='config_hist_clave_ts_idx'),
)
```

**Naming convention indices**: `{app}_{model}_{fields}_idx`
- Ejemplo: `config_cat_act_idx` = configuration + categoria + activa + idx

### 5. Relaciones

**Foreign Keys**:
- SIEMPRE definir `on_delete` explicito
- Usar `SET_NULL` si registro padre puede eliminarse pero hijo debe preservarse
- Usar `CASCADE` si hijo debe eliminarse con padre
- Usar `PROTECT` si eliminacion padre debe bloquearse si tiene hijos

**Many-to-Many**:
- Preferir `through` explicito para metadata adicional
- Naming convention tabla through: `{app1}_{model1}_{app2}_{model2}`

### 6. Data Migrations

**Template**:
```python
from django.db import migrations

def migrate_data_forward(apps, schema_editor):
 """Aplicar cambio de datos"""
 Model = apps.get_model('app_name', 'ModelName')
 # Logica de migracion
 pass

def migrate_data_backward(apps, schema_editor):
 """Revertir cambio de datos"""
 Model = apps.get_model('app_name', 'ModelName')
 # Logica de rollback
 pass

class Migration(migrations.Migration):
 dependencies = [
 ('app_name', '0001_previous_migration'),
 ]

 operations = [
 migrations.RunPython(migrate_data_forward, migrate_data_backward),
 ]
```

**IMPORTANTE**:
- NO importar models directamente (`from myapp.models import MyModel`)
- USAR `apps.get_model()` para obtener version historica del modelo
- INCLUIR funcion backward (reverse) SIEMPRE

---

## Procedimientos de Rollback

### 1. Rollback Local (Development)

**Rollback ultima migracion**:
```bash
python manage.py migrate app_name <previous_migration_number>
```

**Ejemplo**:
```bash
# Revertir configuration a 0001
python manage.py migrate configuration 0001

# Revertir TODAS las migraciones de configuration
python manage.py migrate configuration zero
```

### 2. Rollback Staging/Production

**Procedimiento**:

1. **Verificar estado actual**:
```bash
python manage.py showmigrations app_name
```

2. **Planear rollback**:
 - Identificar migracion objetivo (previous working state)
 - Verificar que migracion tiene operacion `reverse` definida
 - Revisar impacto en datos (posible perdida de datos)

3. **Backup ANTES de rollback**:
```bash
# PostgreSQL
pg_dump -U postgres -d iact_db > backup_pre_rollback_$(date +%Y%m%d_%H%M%S).sql

# MySQL (IVR legacy)
mysqldump -u root -p ivr_legacy > backup_ivr_$(date +%Y%m%d_%H%M%S).sql
```

4. **Ejecutar rollback**:
```bash
python manage.py migrate app_name <target_migration>
```

5. **Validar estado**:
```bash
# Verificar migraciones aplicadas
python manage.py showmigrations app_name

# Verificar datos criticos
python manage.py shell
# >>> from app_name.models import ModelName
# >>> ModelName.objects.count()
```

6. **Monitorear logs**:
 - Verificar logs de Cassandra (errores de aplicacion)
 - Verificar logs de PostgreSQL (errores de queries)

### 3. Rollback Parcial (Selective)

**Escenario**: Revertir migracion especifica sin revertir posteriores

**NO RECOMENDADO** - Puede causar inconsistencia

**Alternativa**: Crear nueva migracion que deshaga cambio especifico

### 4. Rollback Imposible

**Casos donde rollback NO es posible**:
- Migracion DROP table (datos perdidos)
- Migracion ALTER column con perdida de datos (ej: VARCHAR -> INT)
- Migracion sin funcion backward definida

**Mitigacion**:
- Restore desde backup
- Re-aplicar migraciones desde zero
- Crear migracion manual de recovery

---

## Checklist de Migracion

### Pre-Migration

- [ ] Cambios en `models.py` revisados y validados
- [ ] Ejecutar `makemigrations` localmente
- [ ] Revisar archivo de migracion generado
- [ ] Agregar docstring explicando cambio
- [ ] Verificar dependencies correctas
- [ ] Si data migration, incluir funcion backward
- [ ] Testing en entorno local:
 - [ ] `python manage.py migrate`
 - [ ] Verificar datos en DB
 - [ ] Ejecutar tests: `pytest`
- [ ] Commit migracion a git

### Pre-Deploy (Staging)

- [ ] Pull ultima version con migraciones
- [ ] Backup de base de datos staging
- [ ] Aplicar migraciones: `python manage.py migrate`
- [ ] Verificar migraciones aplicadas: `showmigrations`
- [ ] Ejecutar tests de integracion
- [ ] Validar funcionalidad afectada manualmente
- [ ] Verificar performance (si cambios de indice)

### Deploy (Production)

- [ ] Comunicar ventana de mantenimiento (si downtime necesario)
- [ ] Backup COMPLETO de base de datos produccion
- [ ] Aplicar migraciones con monitoring:
 ```bash
 python manage.py migrate --verbosity=2
 ```
- [ ] Verificar migraciones aplicadas
- [ ] Smoke tests de funcionalidad critica
- [ ] Monitorear logs (5-10 minutos post-deploy)
- [ ] Verificar metricas de performance (query time, DB load)

### Post-Deploy

- [ ] Documentar issues encontrados (si aplica)
- [ ] Actualizar runbook si procedimiento cambio
- [ ] Notificar equipo de deploy exitoso

---

## Migraciones Pendientes

### Apps Que Requieren Migracion Inicial

1. **analytics** (PRIORIDAD: ALTA)
 - Modelos: CallAnalytics, DailyMetrics
 - Complejidad: MEDIA
 - Indices necesarios: timestamp, call_id

2. **audit** (PRIORIDAD: ALTA)
 - Modelos: AuditLog (inmutable)
 - Complejidad: BAJA
 - Consideracion: JSONField para data

3. **authentication** (PRIORIDAD: ALTA)
 - Modelos: SecurityQuestion, LoginAttempt
 - Complejidad: BAJA
 - Indices necesarios: user_id, timestamp

4. **notifications** (PRIORIDAD: MEDIA)
 - Modelos: InternalMessage
 - Complejidad: BAJA
 - Indices necesarios: recipient, read_status

5. **reports** (PRIORIDAD: MEDIA)
 - Modelos: ReportTemplate, GeneratedReport
 - Complejidad: MEDIA
 - Consideracion: FileField para PDF storage

6. **etl** (PRIORIDAD: BAJA)
 - Modelos: ETLJob, ETLLog (en desarrollo)
 - Complejidad: ALTA
 - Recomendacion: Esperar a finalizacion de diseño

---

## Migraciones Especiales

### 1. Squash Migrations

**Cuando aplicar**:
- Mas de 50 migraciones en app
- Migraciones acumuladas reducen performance de `migrate`

**Como ejecutar**:
```bash
python manage.py squashmigrations app_name 0001 0050
```

**Post-squash**:
- Eliminar migraciones originales (SOLO despues de aplicar squashed en produccion)
- Actualizar `replaces` en migracion squashed

### 2. Fake Migrations

**Cuando usar**:
- Base de datos ya tiene tabla creada manualmente
- Sincronizar estado de migraciones sin aplicar cambios

**Ejemplo**:
```bash
python manage.py migrate app_name 0001 --fake
```

**WARNING**: Solo usar en casos especiales (debugging, recovery)

### 3. Empty Migrations

**Proposito**: Crear migracion vacia para data migration o RunPython

**Como crear**:
```bash
python manage.py makemigrations app_name --empty --name seed_initial_data
```

---

## Comandos Utiles

### Diagnostico

```bash
# Ver estado de migraciones de todas las apps
python manage.py showmigrations

# Ver SQL de migracion sin aplicarla
python manage.py sqlmigrate app_name 0001

# Ver plan de migraciones pendientes
python manage.py migrate --plan
```

### Desarrollo

```bash
# Crear migraciones para cambios en models
python manage.py makemigrations

# Crear migracion para app especifica
python manage.py makemigrations app_name

# Aplicar todas las migraciones pendientes
python manage.py migrate

# Aplicar migraciones de app especifica
python manage.py migrate app_name
```

### Troubleshooting

```bash
# Ver lista de migraciones aplicadas en DB
python manage.py showmigrations --list

# Marcar migracion como aplicada SIN ejecutarla (fake)
python manage.py migrate app_name 0001 --fake

# Revertir TODAS las migraciones de app
python manage.py migrate app_name zero
```

---

## Referencias

### Documentacion Interna

- [PLAN_MAESTRO_PRIORIDAD_02.md](../PLAN_MAESTRO_PRIORIDAD_02.md) - Tareas de migracion
- [docs/backend/arquitectura/configuration.md](arquitectura/configuration.md) - App configuration
- [docs/backend/arquitectura/users.md](arquitectura/users.md) - Sistema de permisos granulares

### Django Documentation

- [Django Migrations Official Guide](https://docs.djangoproject.com/en/4.2/topics/migrations/)
- [Django Migration Operations Reference](https://docs.djangoproject.com/en/4.2/ref/migration-operations/)
- [Django Schema Editor](https://docs.djangoproject.com/en/4.2/ref/schema-editor/)

### Best Practices

- [Real Python: Django Migrations Primer](https://realpython.com/django-migrations-a-primer/)
- [Django Migrations Anti-Patterns](https://adamj.eu/tech/2023/02/23/django-migrations-dont-modify-past/)

---

## Changelog

### v1.0.0 (2025-11-09)
- Version inicial de estrategia de migraciones
- Documentacion de estado actual (4 migraciones existentes)
- Procedimientos de rollback
- Buenas practicas y checklist
- Identificacion de 6 apps pendientes de migracion

---

**Ultima actualizacion**: 2025-11-09
**Mantenedor**: Backend Team
**Estado de documentacion**: COMPLETO
