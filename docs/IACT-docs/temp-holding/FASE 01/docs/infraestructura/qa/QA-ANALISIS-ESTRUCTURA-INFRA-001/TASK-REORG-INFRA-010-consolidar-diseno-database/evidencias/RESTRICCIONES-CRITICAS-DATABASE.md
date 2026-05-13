# Restricciones Críticas de Base de Datos (RNF)

## Resumen Ejecutivo

Existen **2 restricciones críticas** que gobiernan el diseño e implementación de base de datos en IACT. Estas deben estar **explícitamente documentadas y referenciables** en `diseno/database/estrategia/restricciones_criticas.md`.

---

## RESTRICCIÓN 1: RNF-002 - Sesiones en MySQL (NO Redis)

### Definición Formal

**RNF-002**: Las sesiones de usuario DEBEN almacenarse en base de datos MySQL/MariaDB. Está **PROHIBIDO** usar Redis o sistemas de caché distribuido para almacenar sesiones.

### Justificación

1. **Persistencia**: Las sesiones deben sobrevivir reinicio de servicios
2. **Auditoría**: Facilita auditoría y trazabilidad de sesiones
3. **Integridad**: Vinculación fuerte a tabla de usuarios y permisos
4. **Compliance**: Algunos requisitos de cumplimiento requieren persistencia

### Implementación Actual

```python
# En settings.py:
SESSION_ENGINE = 'django.contrib.sessions.backends.db'

# Tabla de sesiones:
TABLE: django_session
FIELDS:
  - session_key (PK)
  - session_data (TEXT BLOB)
  - expire_date (DATETIME)

# Configuración de optimización:
- ÍNDICE en expire_date para limpeza automática
- ÍNDICE en session_key para búsquedas
```

### Impacto en Consolidación

En `diseno/database/estrategia/restricciones_criticas.md` incluir:
- [ ] Referencia explícita a RNF-002
- [ ] Documentar que NO se puede usar Redis
- [ ] Mostrar configuración Django correcta
- [ ] Índices requeridos en tabla de sesiones
- [ ] Política de expiración de sesiones
- [ ] Scripts de limpieza de sesiones expiradas

### Testing de Consolidación

```bash
# Validar que RNF-002 está documentado
grep -r "RNF-002\|NO Redis\|sesiones.*MySQL" diseno/database/

# Validar que NO hay mención a Redis para sesiones
grep -i "redis.*session\|session.*redis" docs/ || echo "✓ Restricción respetada"
```

---

## RESTRICCIÓN 2: Integridad Referencial y Reversibilidad de Migraciones

### Definición Formal

**RESTRICCIÓN-INTEGRIDAD**:
1. Todas las migraciones deben ser **reversibles** (implementar reverse_code)
2. No se permiten migraciones destructivas sin reversión
3. Las foreign keys deben mantenerse en MySQL
4. Testing es **obligatorio** antes de cualquier deploy
5. Backups automáticos son **requisito** pre-migración

### Justificación

1. **Safety**: Rollback rápido en caso de problemas
2. **Testing**: Garantiza testing en stage antes de producción
3. **Compliance**: Algunos requisitos de auditoría requieren poder "deshacer"
4. **Disaster Recovery**: Backup pre-migración es defensa crucial

### Implementación Actual

```python
# Ejemplo de migración reversible:

from django.db import migrations, models

class Migration(migrations.Migration):
    dependencies = [
        ('app', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Example',
            fields=[
                ('id', models.AutoField(primary_key=True)),
                ('name', models.CharField(max_length=100)),
            ],
        ),
    ]

    def reverse(self, state):
        # Implementar reverse_code
        pass
```

### Workflow Obligatorio

```bash
# 1. Crear migración
python manage.py makemigrations --name descriptive_name

# 2. Revisar SQL generado (OBLIGATORIO)
python manage.py sqlmigrate app_name 0001

# 3. Ejecutar en desarrollo
python manage.py migrate

# 4. Testing (OBLIGATORIO)
pytest tests/migrations/

# 5. Deploy con backup (OBLIGATORIO)
./scripts/migrate_production.sh  # Incluye backup
```

### Impacto en Consolidación

En `diseno/database/estrategia/migraciones_django.md` incluir:
- [ ] Workflow completo de migraciones (7 pasos)
- [ ] Requerimiento de testing
- [ ] Backup strategy
- [ ] Rollback procedures
- [ ] Scripts de migración segura
- [ ] Validaciones previas a deploy

### Testing de Consolidación

```bash
# Validar que workflow está documentado
grep -r "sqlmigrate\|pytest.*migrations\|backup\|rollback" diseno/database/

# Validar que workflow es accesible desde raíz del proyecto
test -f diseno/database/estrategia/migraciones_django.md && echo "✓ Documentado"
```

---

## Matriz de Restricciones

| Restricción | Dominio | Severidad | Fase Enforcement | Documentación |
|------------|---------|-----------|-----------------|---------------|
| RNF-002 | Persistencia | CRÍTICA | Diseño/Código | restricciones_criticas.md |
| Integridad Referencial | Datos | CRÍTICA | Diseño/Deploy | migraciones_django.md |
| Reversibilidad | Deploy | CRÍTICA | Testing/Deploy | migraciones_django.md |
| Backup Pre-Migración | Operaciones | CRÍTICA | Deploy | migraciones_django.md |
| Testing Obligatorio | QA | CRÍTICA | Pre-Deploy | migraciones_django.md |

---

## Validación de Consolidación (Self-Consistency)

### Checklist 1: RNF-002 Está Explícito

```bash
# ✓ RNF-002 debe aparecer en:
[ ] diseno/database/estrategia/restricciones_criticas.md
[ ] diseno/database/README.md (referencia)
[ ] Ser searchable con: grep -r "RNF-002"

# ✓ Referencias a Redis para sesiones deben ser CERO
find docs infrastructure -type f -exec grep -l "redis.*session\|session.*redis" {} \; 2>/dev/null
# Resultado esperado: vacío o solo referencias históricas

# ✓ Configuración correcta debe estar documentada
grep -r "SESSION_ENGINE\|django.contrib.sessions" diseno/database/
# Resultado esperado: django.contrib.sessions.backends.db
```

### Checklist 2: Restricciones de Migraciones Están Claras

```bash
# ✓ Workflow de migraciones debe incluir 7 pasos
grep -c "python manage.py makemigrations\|sqlmigrate\|pytest\|backup" diseno/database/estrategia/migraciones_django.md
# Resultado esperado: >= 4

# ✓ Scripts de migración segura deben existir
ls -la scripts/migrate_production.sh  # O referencia en documentación

# ✓ Rollback debe ser revertible
grep -r "reverse\|rollback\|undo" diseno/database/estrategia/migraciones_django.md
# Resultado esperado: contiene instrucciones

# ✓ Testing es documentado como obligatorio
grep -i "obligatorio\|must\|require" diseno/database/estrategia/migraciones_django.md | grep -i test
# Resultado esperado: contiene mención a testing obligatorio
```

### Checklist 3: Separación de Restricciones vs Implementación

```bash
# ✓ Restricciones están SEPARADAS de implementación
# En diseno/database/estrategia/ (RESTRICCIONES - qué no hacer)
[ ] diseno/database/estrategia/restricciones_criticas.md

# En diseno/database/implementacion/ (CÓMO implementar)
[ ] diseno/database/implementacion/devcontainer/mariadb_setup.md
[ ] diseno/database/implementacion/vagrant/mariadb_setup.md
[ ] diseno/database/implementacion/box/mariadb_configuration.md

# ✗ NO debe haber restricciones en implementacion/
# ✗ NO debe haber detalles de implementación en estrategia/
```

---

## Plan de Consolidación de Restricciones

### Fase 1: Documentación Explícita
```markdown
Crear: diseno/database/estrategia/restricciones_criticas.md
├── RNF-002 (Sesiones en MySQL)
│   ├── Definición formal
│   ├── Justificación
│   ├── Configuración Django
│   ├── Índices requeridos
│   └── Validación
│
└── Integridad Referencial (Foreign Keys)
    ├── Definición formal
    ├── Testing obligatorio
    ├── Backup pre-migración
    └── Rollback procedures
```

### Fase 2: Referencias Cruzadas
```markdown
diseno/database/README.md
├── Link a restricciones_criticas.md
└── Punto de entrada para desarrolladores

diseno/database/estrategia/migraciones_django.md
├── Referencia a RNF-002 (sesiones)
└── Referencia a integridad referencial
```

### Fase 3: Validación Automática

```bash
#!/bin/bash
# Script: validate_database_restrictions.sh

# 1. RNF-002
if grep -q "RNF-002\|NO Redis.*sesiones" diseno/database/estrategia/restricciones_criticas.md; then
    echo "✓ RNF-002 documentado"
else
    echo "✗ RNF-002 NO documentado"
    exit 1
fi

# 2. Integridad
if grep -q "reversible\|rollback\|backup" diseno/database/estrategia/migraciones_django.md; then
    echo "✓ Integridad documentada"
else
    echo "✗ Integridad NO documentada"
    exit 1
fi

# 3. No hay datos en lugares equivocados
if grep -r "redis.*session" docs/; then
    echo "✗ Redis para sesiones encontrado (PROHIBIDO)"
    exit 1
else
    echo "✓ NO hay referencias a Redis para sesiones"
fi
```

---

## Impacto en Contenido de diseno/database/

### Documentos que deben incluir referencias a restricciones:

1. **README.md** (maestro)
   - Destacar restricciones críticas
   - Link a restricciones_criticas.md

2. **estrategia/dual_database_strategy.md**
   - Incluir sesiones en MySQL como característica clave

3. **estrategia/migraciones_django.md**
   - Requerimientos de testing
   - Procedimientos de backup
   - Guía de rollback

4. **implementacion/** (todos)
   - Validar que implementan correctamente las restricciones
   - NO permitir Redis para sesiones

5. **gobernanza/adr_dual_database.md**
   - Decisión sobre RNF-002 (sesiones en MySQL)
   - Justificación técnica

---

## Auto-CoT Reasoning: Por Qué Esto Importa

### Paso 1: Identificación
- Existen restricciones críticas que no están explícitamente documentadas
- Se encuentran dispersas en README.md de backend/diseno/database/
- Desarrolladores pueden no estar conscientes de estas limitaciones

### Paso 2: Impacto
- RNF-002 podría ser violado inadvertidamente (alguien intenta usar Redis)
- Migraciones inseguras podrían ejecutarse sin testing
- Rollback podría ser imposible si no hay backup

### Paso 3: Solución
- Crear documento explícito `restricciones_criticas.md`
- Hacer restricciones **searchable** y **referenceable**
- Incluir validación automática
- Documentar consecuencias de violar restricciones

### Paso 4: Validación (Self-Consistency)
- ¿Puedo encontrar RNF-002 desde cualquier ubicación? → `grep -r "RNF-002"`
- ¿Está separado de implementación? → `ls diseno/database/estrategia/restricciones_criticas.md`
- ¿Está respaldado por ADR? → `ls diseno/database/gobernanza/adr_*`

---

**Creado**: 2025-11-18
**Estado**: ANÁLISIS COMPLETADO
**Próxima Acción**: Consolidar en `diseno/database/estrategia/restricciones_criticas.md`

