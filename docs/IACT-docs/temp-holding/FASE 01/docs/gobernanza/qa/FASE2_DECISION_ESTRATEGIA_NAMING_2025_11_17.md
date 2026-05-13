---
id: FASE2-ESTRATEGIA-NAMING-001
tipo: analisis
categoria: arquitectura
subcategoria: estandares
version: 1.0.0
fecha_analisis: 2025-11-17
analista: Claude Code (Sonnet 4.5)
fase: FASE 2 - Decision Go/No-Go + Estrategia de Naming
estado: completado
relacionado_con: ["FASE1-INVEST-APPS-DUP-001"]
---

# FASE 2: DECISION ESTRATEGIA DE NAMING Y GO/NO-GO

## RESUMEN EJECUTIVO

**Contexto**: El proyecto IACT no tiene base de datos en produccion aun, por lo tanto no se puede verificar si existen datos en las tablas duplicadas. Esto abre la oportunidad para tomar decisiones arquitectonicas fundamentales ANTES de deployment.

**Decision tomada**: Aprovechar que no hay datos en produccion para establecer estrategia de naming definitiva y resolver apps duplicadas en un solo refactoring.

---

## PARTE 1: ESTADO DE BASE DE DATOS

### 1.1 Verificacion de Queries (NO EJECUTABLE)

**Queries planeadas**:
```sql
SELECT COUNT(*) FROM configuracion_sistema;
SELECT COUNT(*) FROM auditoria_configuracion;
```

**Estado**: NO EJECUTABLE - No hay base de datos en produccion

**Implicacion**:
- POSITIVO: No hay datos que migrar
- POSITIVO: No hay riesgo de perdida de datos
- POSITIVO: Podemos hacer cambios arquitectonicos sin migracion
- DECISION: GO - Proceder con eliminacion SIN necesidad de migracion

---

## PARTE 2: ESTRATEGIA DE NAMING

### 2.1 Propuesta del Usuario

**Naming convention propuesta**:
- Tablas: INGLES
- Clases: INGLES
- Funciones: INGLES
- Metodos: INGLES
- Variables: INGLES
- Comentarios: ESPANOL
- Docstrings: ESPANOL

**Ejemplo**:
```python
class UserPermission(models.Model):
    """
    Modelo que representa permisos granulares de usuario.

    Este modelo almacena las capacidades especificas que tiene
    cada usuario en el sistema.
    """

    user = models.ForeignKey(User, on_delete=models.CASCADE)  # Usuario propietario
    capability = models.CharField(max_length=100)  # Capacidad especifica
    is_active = models.BooleanField(default=True)  # Estado de la capacidad

    def check_permission(self, action):
        """
        Verifica si el usuario tiene permiso para ejecutar una accion.

        Args:
            action (str): Accion a verificar

        Returns:
            bool: True si tiene permiso, False en caso contrario
        """
        # Verificar si la capacidad esta activa
        if not self.is_active:
            return False

        # Buscar coincidencia con la accion
        return self.capability == action
```

---

### 2.2 Analisis de Mejores Practicas

#### 2.2.1 Ventajas de Codigo en Ingles

**Interoperabilidad**:
- Frameworks estan en ingles (Django, DRF)
- Librerias estan en ingles
- Stack traces mas legibles
- Git diffs mas claros

**Estandar de Industria**:
- 90% de proyectos open source en ingles
- Facilita contribuciones internacionales
- Compatibilidad con tooling (IDEs, linters)

**Consistencia**:
- Django models en ingles (User, Group, Permission)
- DRF classes en ingles (ModelSerializer, ViewSet)
- Mezclar ingles/espanol genera inconsistencia

**Ejemplos de inconsistencia a evitar**:
```python
# MAL: Mezcla confusa
from django.contrib.auth.models import User
from apps.usuarios.models import Usuario

# BIEN: Todo en ingles
from django.contrib.auth.models import User
from apps.users.models import UserProfile
```

---

#### 2.2.2 Ventajas de Comentarios en Espanol

**Claridad para Equipo Local**:
- Equipo trabaja en espanol
- Documentacion de negocio en espanol
- Reglas de negocio en espanol

**Mantenibilidad**:
- Comentarios complejos mas claros en idioma nativo
- Reduce ambiguedad en logica de negocio

**Ejemplos**:
```python
def calculate_overtime_pay(hours_worked, base_salary):
    """
    Calcula el pago por horas extras segun legislacion mexicana.

    Las primeras 9 horas extras se pagan al doble.
    Las horas adicionales se pagan al triple.
    """
    # Calcular horas extras
    overtime_hours = max(0, hours_worked - 40)

    # Aplicar tasa diferencial
    if overtime_hours <= 9:
        return overtime_hours * (base_salary * 2)
    else:
        # Primeras 9 horas al doble
        first_nine = 9 * (base_salary * 2)
        # Horas adicionales al triple
        additional = (overtime_hours - 9) * (base_salary * 3)
        return first_nine + additional
```

---

### 2.3 Estado Actual del Proyecto IACT

#### 2.3.1 Apps Actuales

**Apps en ESPANOL** (mayoria):
- llamadas
- reportes
- notifications (ingles pero concepto espanol)
- audit (ingles)
- dashboard (ingles)
- etl (ingles)
- analytics (ingles)
- usuarios (espanol)
- permisos (espanol)
- configuracion (espanol)
- excepciones (espanol)
- alertas (espanol)
- tickets (espanol)
- equipos (espanol)
- horarios (espanol)
- clientes (espanol)
- presupuestos (espanol)
- politicas (espanol)
- metricas (espanol)

**Analisis**: ~70% apps en espanol, 30% en ingles

#### 2.3.2 Modelos Actuales

**Modelos en ESPANOL**:
- Usuario (deberia ser User)
- Configuracion (deberia ser Configuration)
- Llamada (deberia ser Call)
- Reporte (deberia ser Report)
- Excepcion (deberia ser Exception)

**Modelos en INGLES**:
- User (Django built-in)
- InternalMessage
- HistorialAcceso
- DashboardConfiguracion

**Analisis**: MEZCLA INCONSISTENTE

---

### 2.4 Recomendacion: Migracion a Ingles con Comentarios en Espanol

#### 2.4.1 Scope de Cambios

**Cambiar a INGLES**:
```
Apps:
- llamadas → calls
- reportes → reports
- usuarios → users
- permisos → permissions
- configuracion → configuration
- excepciones → exceptions
- alertas → alerts
- tickets → tickets (ya en ingles)
- equipos → teams
- horarios → schedules
- clientes → clients
- presupuestos → budgets
- politicas → policies
- metricas → metrics

Modelos:
- Usuario → User (usar Django built-in)
- Configuracion → Configuration
- ConfiguracionSistema → SystemConfiguration
- Llamada → Call
- Reporte → Report
- Excepcion → Exception (cuidado: palabra reservada Python)
- Alerta → Alert
- Equipo → Team
- Horario → Schedule
- Cliente → Client
- Presupuesto → Budget
- Politica → Policy
- Metrica → Metric

Tablas de BD:
- configuracion → configuration
- configuracion_sistema → system_configuration
- configuracion_historial → configuration_history
- auditoria_configuracion → configuration_audit
- llamadas → calls
- reportes → reports
```

**Mantener en ESPANOL**:
```
Comentarios:
  # Verificar si el usuario tiene permisos

Docstrings:
  """
  Calcula el total de horas trabajadas en un periodo.
  """

Documentacion:
  docs/ (ya en espanol)

Messages/Logs:
  logger.info("Usuario autenticado correctamente")
```

---

#### 2.4.2 Ejemplo de Refactoring

**ANTES** (estado actual - mezcla):
```python
# callcentersite/apps/usuarios/models.py
class Usuario(models.Model):
    """Usuario del sistema."""

    username = models.CharField(max_length=150)
    email = models.EmailField()
    permisos_granulares = models.ManyToManyField('Capacidad')

    class Meta:
        db_table = 'usuario'
        verbose_name = 'Usuario'
        verbose_name_plural = 'Usuarios'

    def verificar_permiso(self, accion):
        """Verifica si tiene permiso."""
        # Logica de verificacion
        pass
```

**DESPUES** (propuesto - ingles + comentarios espanol):
```python
# callcentersite/apps/users/models.py
class User(AbstractUser):
    """
    Usuario del sistema de call center.

    Extiende el modelo User de Django con campos adicionales
    para permisos granulares.
    """

    # Campos adicionales
    granular_permissions = models.ManyToManyField('Capability')

    class Meta:
        db_table = 'user'
        verbose_name = 'Usuario'  # OK en espanol para Django Admin
        verbose_name_plural = 'Usuarios'

    def check_permission(self, action):
        """
        Verifica si el usuario tiene permiso para ejecutar una accion.

        Args:
            action (str): Accion a verificar (ej: 'create_report')

        Returns:
            bool: True si tiene permiso, False en caso contrario
        """
        # Verificar si el usuario esta activo
        if not self.is_active:
            return False

        # Buscar capacidad correspondiente
        return self.granular_permissions.filter(
            name=action,
            is_active=True
        ).exists()
```

---

### 2.5 Plan de Migracion a Ingles

#### 2.5.1 Estrategia: Incremental vs Big Bang

**OPCION A: Big Bang** (RECOMENDADO - proyecto sin produccion)
```
Ventajas:
- Cambio unico y definitivo
- No hay periodo de transicion confuso
- No hay legacy code en espanol
- Aprovecha que no hay datos en BD

Desventajas:
- Disruptivo (muchos archivos cambian)
- Requiere coordinacion de equipo
- Puede romper branches activos

Esfuerzo: 3-5 dias
Timeline: 1 semana
```

**OPCION B: Incremental**
```
Ventajas:
- Menos disruptivo
- Permite aprender de errores
- Branches activos no se rompen

Desventajas:
- Periodo largo de inconsistencia
- Confusion durante transicion
- Mas esfuerzo total (mantener ambos)

Esfuerzo: 2-3 semanas
Timeline: 1-2 meses
```

**RECOMENDACION**: OPCION A (Big Bang) - aprovechando que no hay produccion

---

#### 2.5.2 Orden de Migracion (Big Bang)

**DIA 1-2: Core Apps**
```
1. users (era: usuarios)
   - Modelos: Usuario → User
   - Tabla: usuario → user
   - Tests: tests/usuarios → tests/users

2. permissions (era: permisos)
   - Modelos: Funcion → Function, Capacidad → Capability
   - Tablas: funcion → function, capacidad → capability
```

**DIA 3: Business Apps**
```
3. calls (era: llamadas)
4. reports (era: reportes)
5. clients (era: clientes)
6. teams (era: equipos)
7. schedules (era: horarios)
```

**DIA 4: Config y Soporte**
```
8. configuration (era: configuracion) - UNIFICAR
9. alerts (era: alertas)
10. exceptions (era: excepciones)
11. policies (era: politicas)
12. metrics (era: metricas)
13. budgets (era: presupuestos)
```

**DIA 5: Tests y Validacion**
```
14. Actualizar todos los tests
15. Ejecutar suite completa
16. Corregir imports rotos
17. Validar migraciones
```

---

#### 2.5.3 Script de Migracion Automatizado

**Scope**: Renombrar archivos y directorios

```bash
#!/bin/bash
# Script de migracion de naming espanol → ingles

set -e  # Exit on error

BACKUP_DIR="backups/naming_migration_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Backup completo
echo "Creando backup en $BACKUP_DIR..."
cp -r api/callcentersite/callcentersite/apps "$BACKUP_DIR/apps"
cp -r api/callcentersite/tests "$BACKUP_DIR/tests"

# Apps: usuarios → users
echo "Migrando app: usuarios → users"
git mv api/callcentersite/callcentersite/apps/usuarios \
       api/callcentersite/callcentersite/apps/users

# Apps: permisos → permissions
echo "Migrando app: permisos → permissions"
git mv api/callcentersite/callcentersite/apps/permisos \
       api/callcentersite/callcentersite/apps/permissions

# Apps: llamadas → calls
echo "Migrando app: llamadas → calls"
git mv api/callcentersite/callcentersite/apps/llamadas \
       api/callcentersite/callcentersite/apps/calls

# Apps: reportes → reports
echo "Migrando app: reportes → reports"
git mv api/callcentersite/callcentersite/apps/reportes \
       api/callcentersite/callcentersite/apps/reports

# Apps: configuracion → configuration (UNIFICADA)
echo "Migrando app: configuracion → configuration (CONSOLIDADA)"
# La app "configuration" ya existe, eliminar "configuracion"
rm -rf api/callcentersite/callcentersite/apps/configuracion

# Apps: excepciones → exceptions
echo "Migrando app: excepciones → exceptions"
git mv api/callcentersite/callcentersite/apps/excepciones \
       api/callcentersite/callcentersite/apps/exceptions

# Apps: alertas → alerts
echo "Migrando app: alertas → alerts"
git mv api/callcentersite/callcentersite/apps/alertas \
       api/callcentersite/callcentersite/apps/alerts

# Apps: equipos → teams
echo "Migrando app: equipos → teams"
git mv api/callcentersite/callcentersite/apps/equipos \
       api/callcentersite/callcentersite/apps/teams

# Apps: horarios → schedules
echo "Migrando app: horarios → schedules"
git mv api/callcentersite/callcentersite/apps/horarios \
       api/callcentersite/callcentersite/apps/schedules

# Apps: clientes → clients
echo "Migrando app: clientes → clients"
git mv api/callcentersite/callcentersite/apps/clientes \
       api/callcentersite/callcentersite/apps/clients

# Apps: presupuestos → budgets
echo "Migrando app: presupuestos → budgets"
git mv api/callcentersite/callcentersite/apps/presupuestos \
       api/callcentersite/callcentersite/apps/budgets

# Apps: politicas → policies
echo "Migrando app: politicas → policies"
git mv api/callcentersite/callcentersite/apps/politicas \
       api/callcentersite/callcentersite/apps/policies

# Apps: metricas → metrics
echo "Migrando app: metricas → metrics"
git mv api/callcentersite/callcentersite/apps/metricas \
       api/callcentersite/callcentersite/apps/metrics

# Tests
echo "Migrando tests..."
git mv api/callcentersite/tests/usuarios api/callcentersite/tests/users
git mv api/callcentersite/tests/llamadas api/callcentersite/tests/calls
git mv api/callcentersite/tests/reportes api/callcentersite/tests/reports
# ... (resto de tests)

echo "Migracion de archivos completada"
echo "SIGUIENTE PASO: Ejecutar script de actualizacion de imports"
```

---

#### 2.5.4 Script de Actualizacion de Imports

**Scope**: Actualizar imports en todo el codigo

```bash
#!/bin/bash
# Script para actualizar imports espanol → ingles

echo "Actualizando imports en codigo..."

# Actualizar imports de apps
find api/callcentersite -name "*.py" -type f -exec sed -i \
  's/callcentersite\.apps\.usuarios/callcentersite.apps.users/g' {} \;

find api/callcentersite -name "*.py" -type f -exec sed -i \
  's/callcentersite\.apps\.permisos/callcentersite.apps.permissions/g' {} \;

find api/callcentersite -name "*.py" -type f -exec sed -i \
  's/callcentersite\.apps\.llamadas/callcentersite.apps.calls/g' {} \;

find api/callcentersite -name "*.py" -type f -exec sed -i \
  's/callcentersite\.apps\.reportes/callcentersite.apps.reports/g' {} \;

find api/callcentersite -name "*.py" -type f -exec sed -i \
  's/callcentersite\.apps\.configuracion/callcentersite.apps.configuration/g' {} \;

find api/callcentersite -name "*.py" -type f -exec sed -i \
  's/callcentersite\.apps\.excepciones/callcentersite.apps.exceptions/g' {} \;

find api/callcentersite -name "*.py" -type f -exec sed -i \
  's/callcentersite\.apps\.alertas/callcentersite.apps.alerts/g' {} \;

find api/callcentersite -name "*.py" -type f -exec sed -i \
  's/callcentersite\.apps\.equipos/callcentersite.apps.teams/g' {} \;

find api/callcentersite -name "*.py" -type f -exec sed -i \
  's/callcentersite\.apps\.horarios/callcentersite.apps.schedules/g' {} \;

find api/callcentersite -name "*.py" -type f -exec sed -i \
  's/callcentersite\.apps\.clientes/callcentersite.apps.clients/g' {} \;

find api/callcentersite -name "*.py" -type f -exec sed -i \
  's/callcentersite\.apps\.presupuestos/callcentersite.apps.budgets/g' {} \;

find api/callcentersite -name "*.py" -type f -exec sed -i \
  's/callcentersite\.apps\.politicas/callcentersite.apps.policies/g' {} \;

find api/callcentersite -name "*.py" -type f -exec sed -i \
  's/callcentersite\.apps\.metricas/callcentersite.apps.metrics/g' {} \;

echo "Imports actualizados"
echo "SIGUIENTE PASO: Actualizar INSTALLED_APPS en settings"
```

---

#### 2.5.5 Actualizacion de INSTALLED_APPS

```python
# callcentersite/settings/base.py

INSTALLED_APPS = [
    # Django apps
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",

    # Third party
    "rest_framework",
    "rest_framework_simplejwt",
    "django_filters",
    "corsheaders",
    "drf_spectacular",

    # Local apps - TODOS EN INGLES
    "callcentersite.apps.users",         # era: usuarios
    "callcentersite.apps.permissions",   # era: permisos
    "callcentersite.apps.authentication",  # (ya en ingles)
    "callcentersite.apps.calls",         # era: llamadas
    "callcentersite.apps.reports",       # era: reportes
    "callcentersite.apps.notifications",  # (ya en ingles)
    "callcentersite.apps.audit",         # (ya en ingles)
    "callcentersite.apps.dashboard",     # (ya en ingles)
    "callcentersite.apps.etl",           # (ya en ingles)
    "callcentersite.apps.analytics",     # (ya en ingles)
    "callcentersite.apps.configuration", # era: configuracion (UNIFICADA)
    "callcentersite.apps.exceptions",    # era: excepciones
    "callcentersite.apps.alerts",        # era: alertas
    "callcentersite.apps.tickets",       # (ya en ingles)
    "callcentersite.apps.teams",         # era: equipos
    "callcentersite.apps.schedules",     # era: horarios
    "callcentersite.apps.clients",       # era: clientes
    "callcentersite.apps.budgets",       # era: presupuestos
    "callcentersite.apps.policies",      # era: politicas
    "callcentersite.apps.metrics",       # era: metricas
    "callcentersite.apps.ivr_legacy",    # (ya en ingles)

    # Monitoring & Metrics
    "dora_metrics",
    "data_centralization",
]
```

---

### 2.6 Decision Final: FASE 2

#### DECISION GO/NO-GO

**STATUS**: GO - Proceder con refactoring completo

**Razon**: No hay base de datos en produccion, por lo tanto:
- No hay datos que migrar
- No hay riesgo de perdida de datos
- Oportunidad unica para establecer arquitectura limpia
- Momento ideal para resolver apps duplicadas

---

#### ESTRATEGIA DE NAMING APROBADA

**Codigo**: INGLES
- Apps en ingles
- Modelos en ingles
- Tablas en ingles
- Funciones/metodos en ingles
- Variables en ingles

**Documentacion**: ESPANOL
- Comentarios en codigo: espanol
- Docstrings: espanol
- Documentacion markdown: espanol (ya establecido)
- verbose_name en Admin: espanol (para usuarios finales)
- Log messages: espanol

---

## PARTE 3: PLAN DE ACCION INTEGRADO

### 3.1 Tareas Consolidadas

**TASK UNICA: Refactoring Naming + Eliminacion de Apps Duplicadas**

Combinar:
1. Migracion de naming espanol → ingles
2. Eliminacion de app "configuracion" duplicada
3. Consolidacion en app "configuration"

**Beneficios de hacer todo junto**:
- Un solo periodo de disrupcion
- Un solo conjunto de migraciones
- Un solo commit grande (o PR)
- Arquitectura limpia desde el inicio

---

### 3.2 Checklist de Refactoring

**Pre-refactoring**:
- [ ] Backup completo del proyecto
- [ ] Crear branch: `refactor/english-naming-unified-config`
- [ ] Comunicar a equipo (codigo freeze durante refactoring)
- [ ] Documentar estado actual

**Ejecucion** (5 dias):
- [ ] Dia 1: Renombrar apps core (users, permissions)
- [ ] Dia 2: Renombrar apps business (calls, reports, clients)
- [ ] Dia 3: Consolidar configuration, renombrar support apps
- [ ] Dia 4: Actualizar imports, INSTALLED_APPS, urls
- [ ] Dia 5: Generar migraciones, ejecutar tests

**Post-refactoring**:
- [ ] Tests pasan al 100%
- [ ] Migraciones aplican correctamente
- [ ] Servidor arranca sin errores
- [ ] Documentacion actualizada
- [ ] PR creado y revisado
- [ ] Merge a main

---

### 3.3 Riesgos y Mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigacion |
|--------|-------------|---------|------------|
| Imports rotos | ALTA | ALTO | Script automatizado + grep exhaustivo |
| Migraciones fallan | MEDIA | CRITICO | Dry-run antes, backup de BD |
| Tests fallan | ALTA | MEDIO | Ejecutar suite completa, fix incremental |
| Merge conflicts | MEDIA | MEDIO | Comunicar codigo freeze, coordinar equipo |
| Rollback necesario | BAJA | ALTO | Backup completo, branch separado |

---

## CONCLUSIONES Y RECOMENDACIONES

### Conclusion Principal

**Aprovechar que el proyecto no tiene datos en produccion para**:
1. Establecer naming convention definitiva (ingles)
2. Resolver apps duplicadas (eliminar configuracion)
3. Crear arquitectura limpia y consistente desde el inicio

### Recomendaciones

1. **PROCEDER** con refactoring Big Bang (3-5 dias)
2. **ADOPTAR** naming convention: codigo ingles + comentarios espanol
3. **ELIMINAR** app "configuracion", mantener "configuration"
4. **GENERAR** migraciones limpias para BD nueva
5. **DOCUMENTAR** decision en ADR

### Proxima Accion

**Crear ADR (Architecture Decision Record)** documentando:
- Decision de naming (ingles/espanol)
- Decision de eliminacion de app duplicada
- Justificacion (no hay datos en produccion)
- Consecuencias aceptadas

---

**Fecha de decision**: 2025-11-17
**Aprobacion requerida**: Arquitecto Senior + Tech Lead
**Timeline ejecucion**: 1 semana (5 dias habiles)
**Esfuerzo estimado**: 40 horas (1 desarrollador full-time)

