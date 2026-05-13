# ANÁLISIS CONSOLIDADO COMPLETO v2.0 - PARTE 5

**RBAC v5.1.1, CNST v1.1.0, UC v4.0 - Análisis Técnico Detallado**

---

## PARTE 3: NORMATIVAS Y SISTEMAS ACTUALIZADOS

### 3.1 RBAC v5.1.1: SISTEMA DE FUNCIONES ATÓMICAS

#### Cambio Arquitectónico Principal

```
┌──────────────────────────────────────────────────────────┐
│         DE ROLES FIJOS A FUNCIONES ATÓMICAS               │
├──────────────────────────────────────────────────────────┤
│                                                           │
│  RBAC v4.0 (OBSOLETO)          RBAC v5.1.1 (VIGENTE)    │
│  ════════════════════           ═══════════════════      │
│                                                           │
│  18 roles fijos                 44 funciones atómicas    │
│  R001-R018                      Distribuidas en 8 módulos │
│  Nomenclatura genérica          Nomenclatura descriptiva │
│  Basado en "quién es"           Basado en "qué hace"     │
│  Sin temporalidad               Con expiración opcional  │
│                                                           │
│  EJEMPLO:                                                 │
│  R004: REPORTS_VIEWER           ve_reportes              │
│         (rol con pretensiones)  exporta_csv              │
│                                 filtra_reportes          │
│                                 (funciones sin pretensiones)│
└──────────────────────────────────────────────────────────┘
```

#### Distribución de las 44 Funciones

```
MOD_Auth (4 funciones)
══════════════════════
AUT-001: gestiona_sesiones
  • Capacidad: auth:sesiones
  • UC: UC-AUTH-05
  • Permite gestionar sesiones activas de otros usuarios

AUT-002: cierra_sesion_usuario
  • Capacidad: auth:cerrar_sesion
  • UC: UC-AUTH-05
  • Cierra sesión de otro usuario (admin)

AUT-003: resetea_password
  • Capacidad: auth:reset_password
  • UC: UC-AUTH-03
  • Genera contraseña temporal
  • CNST_001: Notificación solo buzón interno (NO email)

AUT-004: ve_sesiones_activas
  • Capacidad: auth:ver_sesiones
  • UC: UC-AUTH-05
  • Consulta todas las sesiones activas del sistema

──────────────────────────────────────────────────────────

MOD_Users (10 funciones)
═════════════════════════
USR-001: crea_usuarios
  • Capacidad: users:crear
  • UC: UC-USR-01
  • CNST_001: Notificación por buzón interno
  • CNST_005: Estado inicial PENDIENTE_CONFIGURACION

USR-002: ve_usuarios
  • Capacidad: users:leer
  • UC: UC-USR-02
  • Consulta información de usuarios

USR-003: modifica_usuarios
  • Capacidad: users:modificar
  • UC: UC-USR-03
  • Modifica datos de usuario
  • CNST_009: Auditoría obligatoria

USR-004: elimina_usuarios
  • Capacidad: users:eliminar
  • UC: UC-USR-04
  • Baja LÓGICA (nunca física - CNST_005)

USR-005: lista_usuarios
  • Capacidad: users:listar
  • UC: UC-USR-02
  • Lista con paginación y filtros

USR-006: busca_usuarios
  • Capacidad: users:buscar
  • UC: UC-USR-02
  • Búsqueda por criterios múltiples

USR-007: bloquea_usuarios
  • Capacidad: users:bloquear
  • UC: UC-USR-03
  • Bloquea acceso temporalmente

USR-008: desbloquea_usuarios
  • Capacidad: users:desbloquear
  • UC: UC-USR-03
  • Reactiva acceso bloqueado

USR-009: reactiva_usuarios
  • Capacidad: users:reactivar
  • UC: UC-USR-03
  • Reactiva usuario inactivo/eliminado

USR-010: asigna_segmento
  • Capacidad: users:asignar_segmento
  • UC: UC-ACC-07
  • Asigna segmento de datos

──────────────────────────────────────────────────────────

MOD_Access (6 funciones)
═════════════════════════
ACC-001: asigna_funciones
  • Capacidad: access:asignar
  • UC: UC-ACC-01, UC-ACC-08 (temporal)
  • CNST_005: Validación SoD
  • CNST_005: Permisos temporales con justificación

ACC-002: revoca_funciones
  • Capacidad: access:revocar
  • UC: UC-ACC-02
  • CNST_009: Auditoría crítica

ACC-003: ve_asignaciones
  • Capacidad: access:ver
  • UC: UC-ACC-03
  • Ve permisos efectivos de usuario

ACC-004: asigna_agrupadores
  • Capacidad: access:asignar_agrupador
  • UC: UC-ACC-04
  • Asigna agrupador completo (múltiples funciones)

ACC-005: gestiona_sod
  • Capacidad: access:sod
  • UC: UC-ACC-05
  • Configura restricciones de Separación de Funciones
  • CNST_005: SoD obligatorio

ACC-006: gestiona_segmentos
  • Capacidad: access:segmentos
  • UC: UC-ACC-06
  • Gestiona catálogo de segmentos de datos

──────────────────────────────────────────────────────────

MOD_Pipeline (4 funciones)
═══════════════════════════
PIP-001: ve_estado_etl
  • Capacidad: pipeline:ver_estado
  • UC: UC-PIP-01
  • CNST_003: ETL cada 6-12 horas

PIP-002: ve_errores_etl
  • Capacidad: pipeline:ver_errores
  • UC: UC-PIP-02
  • Consulta errores del ETL

PIP-003: ve_disponibilidad_datos
  • Capacidad: pipeline:disponibilidad
  • UC: UC-PIP-03
  • CNST_003: Datos desfasados según último ETL

PIP-004: solicita_reintento_etl
  • Capacidad: pipeline:reintento
  • UC: UC-PIP-04
  • Solicita reintento controlado (no ejecuta directamente)

──────────────────────────────────────────────────────────

MOD_Reports (8 funciones)
══════════════════════════
RPT-001: ve_reportes
  • Capacidad: reports:ver
  • UC: UC-RPT-01, UC-RPT-02, UC-RPT-03
  • CNST_003: Datos no real-time
  • CNST_006: Rango máximo 2 años

RPT-002: ve_dashboard
  • Capacidad: reports:dashboard
  • UC: UC-RPT-09
  • Dashboard principal con KPIs

RPT-003: filtra_reportes
  • Capacidad: reports:filtrar
  • UC: UC-RPT-04, UC-RPT-05
  • Filtros por fecha, centro, métricas

RPT-004: exporta_csv
  • Capacidad: reports:exportar_csv
  • UC: UC-RPT-06
  • CNST_001: NO envío por email
  • CNST_007: Máx 100,000 registros, 10 export/día

RPT-005: exporta_excel
  • Capacidad: reports:exportar_excel
  • UC: UC-RPT-07
  • CNST_007: Máx 50,000 registros, 5 export/día

RPT-006: exporta_pdf
  • Capacidad: reports:exportar_pdf
  • UC: UC-RPT-08
  • CNST_007: Máx 10,000 registros, 3 export/día

RPT-007: ve_kpis
  • Capacidad: reports:kpis
  • UC: UC-RPT-10
  • KPIs estáticos predefinidos

RPT-008: ve_graficos
  • Capacidad: reports:graficos
  • UC: UC-RPT-12, UC-RPT-13, UC-RPT-14
  • Gráficos por hora, día, centro

──────────────────────────────────────────────────────────

MOD_Alerts (6 funciones)
═════════════════════════
ALR-001: ve_alertas
  • Capacidad: alerts:ver
  • UC: UC-ALR-02
  • Ve alertas propias

ALR-002: configura_alertas
  • Capacidad: alerts:configurar
  • UC: UC-ALR-01
  • CNST_001: Notificación solo buzón interno
  • CNST_004: Máx 50 destinatarios

ALR-003: configura_alertas_equipo
  • Capacidad: alerts:config_equipo
  • UC: UC-ALR-05
  • Alertas para usuarios del mismo segmento

ALR-004: pausa_alertas
  • Capacidad: alerts:pausar
  • UC: UC-ALR-03
  • Snooze temporal de alertas

ALR-005: elimina_alertas
  • Capacidad: alerts:eliminar
  • UC: UC-ALR-04
  • Elimina alertas propias

ALR-006: ve_historial_alertas
  • Capacidad: alerts:historial
  • UC: UC-ALR-02
  • Historial de alertas enviadas

──────────────────────────────────────────────────────────

MOD_Audit (4 funciones)
════════════════════════
AUD-001: ve_auditoria
  • Capacidad: audit:ver
  • UC: UC-AUD-01
  • CNST_008: Solo lectura (inmutable)
  • SoD: ⚔️ Incompatible con administra_sistema

AUD-002: busca_auditoria
  • Capacidad: audit:buscar
  • UC: UC-AUD-01
  • Búsqueda con filtros avanzados

AUD-003: exporta_auditoria
  • Capacidad: audit:exportar
  • UC: UC-AUD-03
  • CNST_001: NO envío por email
  • CNST_008: Sin PII innecesaria

AUD-004: genera_reporte_compliance
  • Capacidad: audit:compliance
  • UC: UC-AUD-02
  • Reportes de cumplimiento regulatorio

──────────────────────────────────────────────────────────

MOD_Logs (2 funciones)
═══════════════════════
LOG-001: ve_logs_tecnicos
  • Capacidad: logs:ver
  • UC: UC-LOG-01, UC-LOG-02
  • CNST_008: PII enmascarada
  • Retención 30-90 días

LOG-002: exporta_logs
  • Capacidad: logs:exportar
  • UC: UC-LOG-03
  • CNST_001: NO envío por email
```

#### 10 Agrupadores RBAC

```
AGR-001: agr_operador_basico (5 funciones)
═══════════════════════════════════════════
Funciones:
  • ve_reportes (RPT-001)
  • ve_dashboard (RPT-002)
  • filtra_reportes (RPT-003)
  • ve_alertas (ALR-001)
  • ve_historial_alertas (ALR-006)

Usuarios estimados: 50-100
Descripción: Consulta básica de reportes y alertas

──────────────────────────────────────────────────────────

AGR-002: agr_operador_reportes (8 funciones)
═════════════════════════════════════════════
Funciones:
  • ve_reportes (RPT-001)
  • ve_dashboard (RPT-002)
  • filtra_reportes (RPT-003)
  • ve_kpis (RPT-007)
  • ve_graficos (RPT-008)
  • ve_alertas (ALR-001)
  • configura_alertas (ALR-002)
  • ve_historial_alertas (ALR-006)

Usuarios estimados: 30-50
Descripción: Acceso completo a reportes sin exportación

──────────────────────────────────────────────────────────

AGR-003: agr_supervisor (12 funciones)
═══════════════════════════════════════
Funciones:
  # Reportes
  • ve_reportes (RPT-001)
  • ve_dashboard (RPT-002)
  • filtra_reportes (RPT-003)
  • exporta_csv (RPT-004)
  • exporta_excel (RPT-005)
  • ve_kpis (RPT-007)
  • ve_graficos (RPT-008)
  # Alertas
  • ve_alertas (ALR-001)
  • configura_alertas (ALR-002)
  • configura_alertas_equipo (ALR-003)
  • pausa_alertas (ALR-004)
  • ve_historial_alertas (ALR-006)

Usuarios estimados: 20-40
Descripción: Supervisor con exportación y alertas de equipo

──────────────────────────────────────────────────────────

AGR-008: agr_auditor (4 funciones)
═══════════════════════════════════
Funciones:
  • ve_auditoria (AUD-001)
  • busca_auditoria (AUD-002)
  • exporta_auditoria (AUD-003)
  • genera_reporte_compliance (AUD-004)

Usuarios estimados: 2-5

SoD OBLIGATORIO (CNST_005):
  ⚔️ Incompatible con agr_admin_usuarios
  ⚔️ Incompatible con agr_admin_pipeline

Descripción: Auditoría y compliance (solo lectura)
```

#### Separación de Funciones (SoD)

```
RESTRICCIONES SoD OBLIGATORIAS (CNST_005)
══════════════════════════════════════════

SOD-001: sod_admin_auditoria
─────────────────────────────
Descripción: Quien opera el sistema NO debe auditarlo

Grupo A (Administración Pipeline):
  • ve_estado_etl (PIP-001)
  • ve_errores_etl (PIP-002)
  • ve_disponibilidad_datos (PIP-003)
  • solicita_reintento_etl (PIP-004)

Grupo B (Auditoría):
  • ve_auditoria (AUD-001)
  • busca_auditoria (AUD-002)
  • exporta_auditoria (AUD-003)
  • genera_reporte_compliance (AUD-004)

Agrupadores afectados:
  agr_admin_pipeline ⚔️ agr_auditor

Validación:
  Sistema rechaza asignación si usuario ya tiene funciones
  del grupo opuesto.

──────────────────────────────────────────────────────────

SOD-002: sod_usuarios_auditoria
────────────────────────────────
Descripción: Quien gestiona usuarios NO debe auditar sus acciones

Grupo A (Gestión Usuarios):
  • crea_usuarios (USR-001)
  • modifica_usuarios (USR-003)
  • elimina_usuarios (USR-004)
  • bloquea_usuarios (USR-007)

Grupo B (Auditoría):
  • ve_auditoria (AUD-001)
  • busca_auditoria (AUD-002)
  • exporta_auditoria (AUD-003)

Agrupadores afectados:
  agr_admin_usuarios ⚔️ agr_auditor
```

---

### 3.2 CNST v1.0.0 → v1.1.0: ACTUALIZACIÓN DETALLADA

#### Resumen de Cambios

```
┌──────────┬───────┬────────┬─────────┬──────────┬───────────┐
│ Doc      │ v1.0  │ v1.1.0 │ Δ Líneas│ Impacto  │ Prioridad │
├──────────┼───────┼────────┼─────────┼──────────┼───────────┤
│ CNST_001 │  685  │  688   │   +3    │ BAJO     │ MEDIA     │
│ CNST_002 │  840  │  841   │   +1    │ BAJO     │ BAJA      │
│ CNST_003 │  901  │  902   │   +1    │ BAJO     │ BAJA      │
│ CNST_004 │  920  │  921   │   +1    │ BAJO     │ BAJA      │
│ CNST_005 │  994  │ 1,339  │  +345   │ ALTO     │ CRÍTICA   │
│ CNST_006 │ 1,126 │ 1,703  │  +577   │ ALTO     │ CRÍTICA   │
│ CNST_007 │ 1,061 │ 1,062  │   +1    │ BAJO     │ BAJA      │
│ CNST_008 │ 1,019 │ 1,020  │   +1    │ BAJO     │ BAJA      │
│ CNST_009 │ 1,077 │ 1,078  │   +1    │ BAJO     │ BAJA      │
│ CNST_010 │  998  │ 1,002  │   +4    │ MEDIO    │ ALTA      │
│ index    │  253  │  280   │  +27    │ MEDIO    │ IMPORTANTE│
├──────────┼───────┼────────┼─────────┼──────────┼───────────┤
│ TOTAL    │ 9,621 │ 10,543 │  +922   │          │           │
└──────────┴───────┴────────┴─────────┴──────────┴───────────┘
```

#### CNST_005: Cambio Arquitectónico Mayor

**Ampliación: +345 líneas (34.7% incremento)**

**SECCIÓN NUEVA: Permisos Temporales (Sistema completo)**

```python
# api/apps/access/models.py

from django.db import models
from django.utils import timezone
from datetime import timedelta

class UserFunctionAssignment(models.Model):
    """
    Asignación de función atómica a usuario.
    
    RBAC v5.1.1: Soporta permisos temporales con vencimiento.
    CNST_005: Permisos temporales obligatorios para casos especiales.
    """
    
    user = models.ForeignKey(
        'auth.User',
        on_delete=models.CASCADE,
        related_name='function_assignments'
    )
    
    function_code = models.CharField(
        max_length=50,
        help_text='Código función (ej: ve_reportes)'
    )
    
    # Temporalidad
    assigned_at = models.DateTimeField(auto_now_add=True)
    expires_at = models.DateTimeField(
        null=True,
        blank=True,
        help_text='NULL = permanente'
    )
    
    # Auditoría
    assigned_by = models.ForeignKey(
        'auth.User',
        on_delete=models.SET_NULL,
        null=True,
        related_name='functions_assigned_by_me'
    )
    
    reason = models.TextField(
        help_text='Justificación mínimo 20 caracteres (CNST_005)'
    )
    
    # Estado
    is_active = models.BooleanField(default=True)
    revoked_at = models.DateTimeField(null=True)
    revoked_by = models.ForeignKey(
        'auth.User',
        on_delete=models.SET_NULL,
        null=True,
        related_name='functions_revoked_by_me'
    )
    
    class Meta:
        db_table = 'user_function_assignments'
        indexes = [
            models.Index(fields=['user', 'is_active']),
            models.Index(fields=['expires_at']),
        ]
        constraints = [
            models.UniqueConstraint(
                fields=['user', 'function_code'],
                condition=models.Q(is_active=True),
                name='unique_active_function_per_user'
            )
        ]
    
    @property
    def is_expired(self):
        """Verificar si permiso ha expirado."""
        if not self.expires_at:
            return False
        return timezone.now() > self.expires_at
    
    @classmethod
    def assign_temporary(cls, user, function_code, days, 
                        assigned_by, reason):
        """
        Asignar función temporal.
        
        CNST_005: Justificación mínimo 20 chars.
        CNST_005: Vencimiento máximo 6 meses (180 días).
        """
        if len(reason) < 20:
            raise ValidationError(
                "Justificación debe tener mínimo 20 caracteres"
            )
        
        if days > 180:
            raise ValidationError(
                "Vencimiento máximo es 180 días (6 meses)"
            )
        
        expires_at = timezone.now() + timedelta(days=days)
        
        assignment = cls.objects.create(
            user=user,
            function_code=function_code,
            expires_at=expires_at,
            assigned_by=assigned_by,
            reason=reason
        )
        
        # Auditar (CNST_009)
        from apps.common.models import UserActionLog
        UserActionLog.record(
            user=assigned_by,
            action='FUNCTION_ASSIGN_TEMP',
            resource=f"{user.username}:{function_code}",
            result='SUCCESS',
            details={
                'function': function_code,
                'target_user': user.username,
                'duration_days': days,
                'expires_at': expires_at.isoformat(),
                'reason': reason
            }
        )
        
        return assignment
```

**Middleware de Auto-Expiración:**

```python
# api/apps/access/middleware.py

class ExpireTemporaryPermissionsMiddleware:
    """
    Middleware para auto-expirar permisos temporales vencidos.
    
    CNST_005: Precedencia: Permiso Temporal > Función Permanente.
    """
    
    def __init__(self, get_response):
        self.get_response = get_response
    
    def __call__(self, request):
        if request.user.is_authenticated:
            # Desactivar permisos expirados
            UserFunctionAssignment.objects.filter(
                user=request.user,
                is_active=True,
                expires_at__lt=timezone.now()
            ).update(
                is_active=False,
                revoked_at=timezone.now()
            )
        
        return self.get_response(request)
```

---

### 3.3 UC v4.0.0: REGENERACIÓN DE 49 CASOS DE USO

#### Plantilla Estándar (14 Secciones)

```rst
.. meta::
   :project: IACT - IVR Analytics & Customer Tracking
   :version: 4.0.0
   :date: 2026-01-06
   :status: Aprobado
   :module: MOD_xxx
   :uc_id: UC_[MOD]_[NN]
   :normativa: CNST-xxx, CNST-yyy

UC_[MOD]_[NN]: [Título del Caso de Uso]
════════════════════════════════════════

1. Resumen
──────────
.. list-table::
   :widths: 25 75

   * - **ID**
     - UC_[MOD]_[NN]
   * - **Nombre**
     - [Título]
   * - **Actor Principal**
     - [AGR-00x]: [nombre_agrupador]
   * - **Función RBAC**
     - [XXX-NNN]: [nombre_funcion]
   * - **Prioridad**
     - [Alta/Media/Baja]

2. Descripción
──────────────
[Descripción detallada con CNST aplicables]

3. Diagrama de Caso de Uso
──────────────────────────
.. uml::
   [PlantUML con agrupadores AGR-00x]

4. Contexto de Ejecución
────────────────────────
4.1 Precondiciones
4.2 Trigger
4.3 Postcondiciones

5. Flujo Normal (Camino Feliz)
──────────────────────────────
[8-15 pasos típicos]

6. Diagrama de Secuencia
────────────────────────
.. uml::
   [PlantUML con notas CNST]

7. Flujos Alternos
──────────────────
[4-6 flujos alternos típicos]

8. Excepciones
──────────────
[2-3 excepciones típicas]

9. Diagrama de Actividad
────────────────────────
.. uml::
   [PlantUML]

10. Reglas de Negocio
─────────────────────
[BR aplicables con trazabilidad]

11. Restricciones de Arquitectura
─────────────────────────────────
.. list-table::
   :header-rows: 1

   * - CNST
     - Aplicación en este UC
   * - CNST-001
     - [Cómo se aplica]

12. Requisitos Funcionales Derivados
────────────────────────────────────
[FR-xxx derivados de este UC]

13. Trazabilidad
────────────────
BReq: [BRQ-xxx]
BR: [BR-xxx]
UC: [Este UC]
FR: [FR-xxx a FR-yyy]
Actor: [AGR-00x]
Función: [XXX-NNN]

14. Historial de Cambios
────────────────────────
[Versiones del UC]
```

#### Distribución de los 49 UC

```
MOD_Auth (5 UC)    → 25-30 min generación
MOD_Users (4 UC)   → 20-25 min generación
MOD_Access (9 UC)  → 45-55 min generación
MOD_Pipeline (4 UC) → 20-25 min generación
MOD_Reports (14 UC) → 70-85 min generación ← Mayor módulo
MOD_Alerts (5 UC)   → 25-30 min generación
MOD_Audit (4 UC)    → 20-25 min generación
MOD_Logs (4 UC)     → 20-25 min generación

TOTAL: 4-5 horas generación completa (~5-6 min por UC)
```

---

[FIN DE PARTE 5 - CONTINÚA CON PLAN 157H EN PARTE 6]

