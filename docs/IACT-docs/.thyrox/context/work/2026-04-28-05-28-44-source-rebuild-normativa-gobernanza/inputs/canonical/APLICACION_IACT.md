# Aplicación de Reglas de Negocio en el Proyecto IACT

**Documento:** Parte 4 - Guía de Implementación IACT
**Versión:** 1.0
**Última actualización:** 2025-11-14

---

## Tabla de Contenidos

1. [Introducción](#introducción)
2. [Arquitectura del Proyecto](#arquitectura-del-proyecto)
3. [Implementación por Dominio](#implementación-por-dominio)
4. [Mapeo Reglas a Código](#mapeo-reglas-a-código)
5. [Casos de Uso Completos](#casos-de-uso-completos)
6. [Validación y Testing](#validación-y-testing)
7. [Compliance y Auditoría](#compliance-y-auditoría)

---

## Introducción

> **Concepto Clave:** Este documento traduce las reglas de negocio abstractas en implementaciones concretas dentro de la arquitectura Django + React del proyecto IACT.

### Objetivos

- **Mapear** reglas de negocio a componentes técnicos
- **Implementar** cada tipo de regla en el stack tecnológico
- **Validar** cumplimiento con herramientas automatizadas
- **Garantizar** trazabilidad entre requerimientos y código

### Stack Tecnológico IACT

```
Frontend:  React 18.2 + Redux Toolkit + TypeScript
Backend:   Django 5.0 + Django REST Framework 3.14
Database:  PostgreSQL 15 (analytics) + MariaDB 10.11 (IVR read-only)
Cache:     Redis 7.2
Queue:     Celery + RabbitMQ
```

---

## Arquitectura del Proyecto

### Organización por Dominio (ADR-010)

```
IACT---project/
├── api/callcentersite/          # Backend Django
│   ├── agentes/                 # Dominio: Gestión de agentes
│   ├── llamadas/                # Dominio: Gestión de llamadas
│   ├── campanas/                # Dominio: Gestión de campañas
│   ├── clientes/                # Dominio: Gestión de clientes
│   ├── reportes/                # Dominio: Reportería y analytics
│   └── auth_permissions/        # Dominio: Autenticación y permisos
├── frontend/src/
│   ├── features/                # Features por dominio
│   │   ├── agents/
│   │   ├── calls/
│   │   ├── campaigns/
│   │   └── reports/
│   └── shared/                  # Componentes compartidos
└── docs/gobernanza/requisitos/reglas_negocio/  # Este directorio
```

### Flujo de Datos

```
┌─────────────┐
│   Usuario   │
└──────┬──────┘
       │
       v
┌─────────────────────────────────────────┐
│         React Frontend                  │
│  - Validaciones UI (Restricciones)      │
│  - Cálculos en tiempo real (Cálculos)   │
│  - Estado derivado (Inferencias)        │
└──────────────┬──────────────────────────┘
               │ API REST
               v
┌─────────────────────────────────────────┐
│      Django REST Framework              │
│  - Serializers (Validaciones)           │
│  - ViewSets (Lógica de negocio)         │
│  - Permissions (Restricciones de acceso)│
└──────────────┬──────────────────────────┘
               │
               v
┌─────────────────────────────────────────┐
│         Django Models                   │
│  - Hechos (Estructura de datos)         │
│  - Validaciones (Constraints)           │
│  - Signals (Desencadenadores)           │
│  - Properties (Inferencias)             │
│  - Methods (Cálculos)                   │
└──────────────┬──────────────────────────┘
               │
               v
┌─────────────────────────────────────────┐
│    PostgreSQL + MariaDB                 │
│  - Constraints (DB level)               │
│  - Triggers (Desencadenadores DB)       │
└─────────────────────────────────────────┘
```

---

## Implementación por Dominio

### Dominio: Agentes (api/callcentersite/agentes/)

#### HECHOS: Modelos de Datos

```python
# api/callcentersite/agentes/models.py

from django.db import models
from django.contrib.auth.models import User

class Agente(models.Model):
    """
    HECHO: Cada agente tiene una extensión telefónica única
    HECHO: Cada agente está asignado a exactamente un equipo
    HECHO: Cada agente tiene un supervisor directo
    """
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    extension = models.CharField(max_length=10, unique=True)
    equipo = models.ForeignKey('Equipo', on_delete=models.PROTECT)
    supervisor = models.ForeignKey(
        'self',
        on_delete=models.SET_NULL,
        null=True,
        related_name='agentes_supervisados'
    )
    estado = models.CharField(
        max_length=20,
        choices=[
            ('disponible', 'Disponible'),
            ('en_llamada', 'En Llamada'),
            ('descanso', 'Descanso'),
            ('offline', 'Offline')
        ],
        default='offline'
    )

    class Meta:
        verbose_name = 'Agente'
        verbose_name_plural = 'Agentes'
        db_table = 'agentes'
```

#### RESTRICCIONES: Validaciones y Permisos

```python
# api/callcentersite/agentes/serializers.py

from rest_framework import serializers

class AgenteSerializer(serializers.ModelSerializer):
    """
    RESTRICCIÓN: Un agente debe estar logueado para recibir llamadas
    """
    def validate_estado(self, value):
        if value == 'en_llamada' and self.instance.estado == 'offline':
            raise serializers.ValidationError(
                "El agente debe estar disponible antes de recibir llamadas"
            )
        return value

# api/callcentersite/agentes/permissions.py

from rest_framework import permissions

class AgentePermissions(permissions.BasePermission):
    """
    RESTRICCIÓN: Un agente no puede acceder a grabaciones de otros agentes
    RESTRICCIÓN: Un supervisor puede acceder a grabaciones de su equipo
    """
    def has_object_permission(self, request, view, obj):
        user = request.user

        # Agentes solo pueden ver sus propios datos
        if user.groups.filter(name='Agente').exists():
            return obj.user == user

        # Supervisores pueden ver datos de su equipo
        if user.groups.filter(name='Supervisor').exists():
            return obj.equipo.supervisor == user.agente

        # Gerentes pueden ver todos
        if user.groups.filter(name='Gerente').exists():
            return True

        return False
```

#### DESENCADENADORES: Django Signals

```python
# api/callcentersite/agentes/signals.py

from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import Agente, SesionAgente
from .tasks import notificar_supervisor

@receiver(post_save, sender=SesionAgente)
def detectar_inactividad(sender, instance, **kwargs):
    """
    DESENCADENADOR: Si agente lleva > 15 min sin llamadas, notificar
    """
    if instance.tiempo_sin_llamada > 900:  # 15 minutos
        notificar_supervisor.delay(
            agente_id=instance.agente.id,
            motivo="inactividad_prolongada"
        )
```

#### INFERENCIAS: Propiedades Calculadas

```python
# api/callcentersite/agentes/models.py (continuación)

class Agente(models.Model):
    # ... campos anteriores ...

    @property
    def nivel_rendimiento(self):
        """
        INFERENCIA: Clasificación automática de rendimiento
        SI FCR > 85% AND AHT < 5min AND CSAT > 4.5 ENTONCES "Excelente"
        """
        metricas = self.calcular_metricas_mes_actual()

        if (metricas['fcr'] > 85 and
            metricas['aht'] < 300 and  # 5 minutos en segundos
            metricas['csat'] > 4.5):
            return 'Excelente'
        elif (metricas['fcr'] > 70 and
              metricas['aht'] < 420 and  # 7 minutos
              metricas['csat'] > 4.0):
            return 'Bueno'
        elif metricas['fcr'] > 60:
            return 'Aceptable'
        else:
            return 'Requiere Mejora'

    @property
    def disponibilidad_real(self):
        """
        INFERENCIA: Estado de disponibilidad real vs declarado
        """
        if self.estado == 'disponible' and self.tiempo_sin_llamada > 900:
            return 'Inactivo'
        return self.estado
```

#### CÁLCULOS: Métodos de Análisis

```python
# api/callcentersite/agentes/models.py (continuación)

from django.db.models import Avg, Count, Q
from datetime import datetime, timedelta

class Agente(models.Model):
    # ... campos y propiedades anteriores ...

    def calcular_aht(self, fecha_inicio=None, fecha_fin=None):
        """
        CÁLCULO: Average Handle Time (AHT)
        AHT = (tiempo_conversacion + tiempo_post_llamada) / total_llamadas
        """
        llamadas = self.llamadas.filter(
            estado='finalizada',
            timestamp__gte=fecha_inicio or datetime.now() - timedelta(days=30),
            timestamp__lte=fecha_fin or datetime.now()
        )

        return llamadas.aggregate(
            aht=Avg('duracion_total')
        )['aht'] or 0

    def calcular_fcr(self, fecha_inicio=None, fecha_fin=None):
        """
        CÁLCULO: First Call Resolution (FCR)
        FCR = (llamadas_resueltas_primer_contacto / total_llamadas) × 100
        """
        llamadas = self.llamadas.filter(
            timestamp__gte=fecha_inicio or datetime.now() - timedelta(days=30),
            timestamp__lte=fecha_fin or datetime.now()
        )

        total = llamadas.count()
        resueltas_primer_contacto = llamadas.filter(
            resolucion_primer_contacto=True
        ).count()

        return (resueltas_primer_contacto / total * 100) if total > 0 else 0

    def calcular_metricas_mes_actual(self):
        """
        CÁLCULO: Conjunto de métricas del mes actual
        """
        inicio_mes = datetime.now().replace(day=1, hour=0, minute=0, second=0)

        return {
            'aht': self.calcular_aht(inicio_mes),
            'fcr': self.calcular_fcr(inicio_mes),
            'csat': self.calcular_csat(inicio_mes),
            'total_llamadas': self.llamadas.filter(
                timestamp__gte=inicio_mes
            ).count()
        }
```

### Dominio: Llamadas (api/callcentersite/llamadas/)

#### Implementación Completa de Reglas

```python
# api/callcentersite/llamadas/models.py

class Llamada(models.Model):
    """
    HECHOS:
    - Cada llamada registrada debe asociarse a un agente específico
    - Cada llamada tiene una duración medida en segundos
    - Cada llamada debe tener un estado
    """
    agente = models.ForeignKey('agentes.Agente', on_delete=models.PROTECT)
    cliente = models.ForeignKey('clientes.Cliente', on_delete=models.CASCADE)
    timestamp_inicio = models.DateTimeField(auto_now_add=True)
    timestamp_fin = models.DateTimeField(null=True, blank=True)
    duracion = models.IntegerField(default=0, help_text="Duración en segundos")
    estado = models.CharField(
        max_length=20,
        choices=[
            ('en_curso', 'En Curso'),
            ('finalizada', 'Finalizada'),
            ('abandonada', 'Abandonada'),
            ('transferida', 'Transferida')
        ],
        default='en_curso'
    )
    clasificacion = models.ForeignKey(
        'ClasificacionLlamada',
        on_delete=models.SET_NULL,
        null=True,
        blank=True
    )
    resolucion_primer_contacto = models.BooleanField(default=False)
    grabacion_url = models.URLField(max_length=500, blank=True)

    # RESTRICCIÓN a nivel de modelo
    def clean(self):
        """
        RESTRICCIÓN: Una llamada no puede cerrarse sin clasificación
        """
        if self.estado == 'finalizada' and not self.clasificacion:
            raise ValidationError({
                'clasificacion': 'Debe seleccionar una clasificación antes de cerrar la llamada'
            })

    # DESENCADENADOR
    def save(self, *args, **kwargs):
        """
        DESENCADENADOR: Al cerrar llamada, calcular duración
        """
        if self.estado == 'finalizada' and self.timestamp_fin:
            self.duracion = (self.timestamp_fin - self.timestamp_inicio).total_seconds()
        super().save(*args, **kwargs)

    # INFERENCIA
    @property
    def requiere_seguimiento(self):
        """
        INFERENCIA: Determinar si llamada requiere seguimiento
        SI no_resuelto_primer_contacto AND cliente_importante ENTONCES True
        """
        return (
            not self.resolucion_primer_contacto and
            self.cliente.categoria in ['VIP', 'Premium']
        )

    # CÁLCULO
    def calcular_tiempo_espera(self):
        """
        CÁLCULO: Tiempo que cliente esperó antes de ser atendido
        """
        if hasattr(self, 'cola_espera'):
            return (self.timestamp_inicio - self.cola_espera.timestamp_ingreso).total_seconds()
        return 0

# Signals para desencadenadores
@receiver(post_save, sender=Llamada)
def escalar_llamada_larga(sender, instance, **kwargs):
    """
    DESENCADENADOR: Si llamada > 20 minutos, notificar supervisor
    """
    if instance.duracion > 1200 and instance.estado == 'en_curso':
        from .tasks import notificar_supervisor_llamada_larga
        notificar_supervisor_llamada_larga.delay(instance.id)
```

### Dominio: Campañas (api/callcentersite/campanas/)

```python
# api/callcentersite/campanas/models.py

class Campana(models.Model):
    """
    HECHOS:
    - Cada campaña debe tener fecha de inicio y finalización
    - Cada campaña se asocia a uno o más productos/servicios
    """
    nombre = models.CharField(max_length=200)
    descripcion = models.TextField()
    fecha_inicio = models.DateTimeField()
    fecha_fin = models.DateTimeField()
    productos = models.ManyToManyField('productos.Producto')
    activa = models.BooleanField(default=True)

    # RESTRICCIÓN a nivel de validación
    def clean(self):
        """
        RESTRICCIÓN: Fecha inicio no puede ser posterior a fecha fin
        """
        if self.fecha_inicio >= self.fecha_fin:
            raise ValidationError({
                'fecha_fin': 'Fecha de fin debe ser posterior a fecha de inicio'
            })

    # INFERENCIA
    @property
    def estado(self):
        """
        INFERENCIA: Estado derivado de fechas y llamadas pendientes
        SI fecha_fin < hoy AND llamadas_pendientes = 0 ENTONCES "Finalizada"
        """
        from django.utils import timezone
        ahora = timezone.now()

        if self.fecha_fin < ahora and self.llamadas_pendientes == 0:
            return 'Finalizada'
        elif self.fecha_inicio > ahora:
            return 'Programada'
        elif not self.activa:
            return 'Pausada'
        else:
            return 'Activa'

    @property
    def efectividad(self):
        """
        INFERENCIA: Clasificación de efectividad
        SI tasa_conversion > 15% AND cpa < promedio ENTONCES "Alta"
        """
        tc = self.tasa_conversion
        cpa = self.calcular_cpa()
        promedio_industria = 50  # USD, ejemplo

        if tc > 15 and cpa < promedio_industria:
            return 'Alta'
        elif tc > 8:
            return 'Media'
        else:
            return 'Baja'

    # CÁLCULOS
    def calcular_tasa_conversion(self):
        """
        CÁLCULO: Tasa de conversión
        tasa = (llamadas_exitosas / total_llamadas) × 100
        """
        total = self.llamadas.count()
        exitosas = self.llamadas.filter(
            clasificacion__es_exitosa=True
        ).count()

        return (exitosas / total * 100) if total > 0 else 0

    def calcular_cpa(self):
        """
        CÁLCULO: Costo por Adquisición
        CPA = costo_total / total_conversiones
        """
        conversiones = self.llamadas.filter(
            clasificacion__es_exitosa=True
        ).count()

        return (self.costo_total / conversiones) if conversiones > 0 else 0

    def calcular_roi(self):
        """
        CÁLCULO: Retorno de Inversión
        ROI = ((ingresos - costos) / costos) × 100
        """
        ingresos = self.llamadas.filter(
            clasificacion__es_exitosa=True
        ).aggregate(
            total=Sum('monto_venta')
        )['total'] or 0

        return ((ingresos - self.costo_total) / self.costo_total * 100) if self.costo_total > 0 else 0

# Desencadenadores
@receiver(post_save, sender=Campana)
def pausar_campana_bajo_rendimiento(sender, instance, **kwargs):
    """
    DESENCADENADOR: Pausar campaña si tasa conversión < 2% con >100 llamadas
    """
    if instance.activa:
        total_llamadas = instance.llamadas.count()
        if total_llamadas > 100:
            tasa = instance.calcular_tasa_conversion()
            if tasa < 2:
                instance.activa = False
                instance.save()
                notificar_gerente.delay(
                    campana_id=instance.id,
                    motivo="baja_conversion"
                )
```

---

## Mapeo Reglas a Código

### Matriz de Implementación

| Tipo de Regla | Backend Django | Frontend React | Base de Datos |
|---------------|----------------|----------------|---------------|
| **Hechos** | Models (campos, relaciones) | TypeScript interfaces | Tablas, FK, constraints |
| **Restricciones** | Permissions, Validators | Form validation, guards | CHECK constraints, triggers |
| **Desencadenadores** | Signals, Celery tasks | useEffect hooks, middlewares | DB triggers |
| **Inferencias** | @property, methods | Computed selectors, useMemo | Views, computed columns |
| **Cálculos** | Model methods, aggregates | Redux selectors, utilities | Aggregate functions, stored procedures |

### Ejemplo de Flujo Completo: Cierre de Llamada

```
┌────────────────────────────────────────────────────────────────┐
│ 1. Usuario hace clic en "Cerrar Llamada" (React)              │
└────────────────┬───────────────────────────────────────────────┘
                 │
                 v
┌────────────────────────────────────────────────────────────────┐
│ 2. RESTRICCIÓN (Frontend): Validar clasificación seleccionada │
│    if (!clasificacion) { showError("Seleccione clasificación")│
└────────────────┬───────────────────────────────────────────────┘
                 │
                 v
┌────────────────────────────────────────────────────────────────┐
│ 3. API Request: PATCH /api/llamadas/{id}/                     │
└────────────────┬───────────────────────────────────────────────┘
                 │
                 v
┌────────────────────────────────────────────────────────────────┐
│ 4. RESTRICCIÓN (Backend): Permissions - verificar rol usuario │
│    has_object_permission(request, view, obj)                  │
└────────────────┬───────────────────────────────────────────────┘
                 │
                 v
┌────────────────────────────────────────────────────────────────┐
│ 5. RESTRICCIÓN (Serializer): Validar clasificación obligatoria│
│    validate_clasificacion(value)                              │
└────────────────┬───────────────────────────────────────────────┘
                 │
                 v
┌────────────────────────────────────────────────────────────────┐
│ 6. CÁLCULO (Model.save): Calcular duración de llamada        │
│    self.duracion = (timestamp_fin - timestamp_inicio).seconds  │
└────────────────┬───────────────────────────────────────────────┘
                 │
                 v
┌────────────────────────────────────────────────────────────────┐
│ 7. HECHO: Llamada guardada en DB con estado "finalizada"     │
└────────────────┬───────────────────────────────────────────────┘
                 │
                 v
┌────────────────────────────────────────────────────────────────┐
│ 8. DESENCADENADOR (Signal): post_save → actualizar métricas  │
│    actualizar_metricas_agente.delay(agente_id)                │
└────────────────┬───────────────────────────────────────────────┘
                 │
                 v
┌────────────────────────────────────────────────────────────────┐
│ 9. INFERENCIA: Recalcular nivel_rendimiento del agente       │
│    agente.nivel_rendimiento (property calculada)             │
└────────────────┬───────────────────────────────────────────────┘
                 │
                 v
┌────────────────────────────────────────────────────────────────┐
│ 10. CÁLCULO: Actualizar AHT, FCR del día                     │
│     agente.calcular_aht(), agente.calcular_fcr()             │
└────────────────────────────────────────────────────────────────┘
```

---

## Casos de Uso Completos

### Caso de Uso 1: Login de Agente

**Actores:** Agente, Sistema

**Reglas Aplicadas:**
- **H1 (Hecho):** Cada agente tiene credenciales únicas
- **R1 (Restricción):** Agente debe autenticarse para acceder al sistema
- **D1 (Desencadenador):** Al login exitoso, cambiar estado a "disponible"
- **I1 (Inferencia):** Si login en horario fuera de turno, marcar como "fuera_horario"
- **C1 (Cálculo):** Registrar timestamp y calcular tiempo de sesión

**Implementación:**

```python
# Backend: api/callcentersite/auth_permissions/views.py
from rest_framework_simplejwt.views import TokenObtainPairView

class CustomTokenObtainPairView(TokenObtainPairView):
    def post(self, request, *args, **kwargs):
        response = super().post(request, *args, **kwargs)

        if response.status_code == 200:
            # DESENCADENADOR: Cambiar estado a disponible
            agente = Agente.objects.get(user=request.user)
            agente.estado = 'disponible'
            agente.save()

            # DESENCADENADOR: Crear sesión
            SesionAgente.objects.create(
                agente=agente,
                timestamp_login=timezone.now()
            )

            # INFERENCIA: Verificar horario
            if not agente.en_horario_turno():
                agente.marca_atencion = 'fuera_horario'
                agente.save()

        return response
```

### Caso de Uso 2: Reasignación de Llamada

**Actores:** Supervisor, Sistema

**Reglas Aplicadas:**
- **R2 (Restricción):** Solo supervisores pueden reasignar llamadas
- **R3 (Restricción):** Agente destino debe estar disponible
- **H2 (Hecho):** Llamada transferida mantiene grabación continua
- **D2 (Desencadenador):** Notificar a agente destino de nueva llamada
- **C2 (Cálculo):** Actualizar tiempo en cola del cliente

**Implementación:**

```python
# Backend: api/callcentersite/llamadas/views.py
from rest_framework.decorators import action

class LlamadaViewSet(viewsets.ModelViewSet):

    @action(detail=True, methods=['post'],
            permission_classes=[IsSupervisor])
    def reasignar(self, request, pk=None):
        """
        RESTRICCIÓN: Solo supervisores pueden reasignar
        """
        llamada = self.get_object()
        nuevo_agente_id = request.data.get('nuevo_agente_id')

        try:
            nuevo_agente = Agente.objects.get(id=nuevo_agente_id)
        except Agente.DoesNotExist:
            return Response(
                {'error': 'Agente no encontrado'},
                status=status.HTTP_404_NOT_FOUND
            )

        # RESTRICCIÓN: Verificar disponibilidad
        if nuevo_agente.estado != 'disponible':
            return Response(
                {'error': 'Agente no está disponible'},
                status=status.HTTP_400_BAD_REQUEST
            )

        # HECHO: Transferir manteniendo grabación
        llamada.agente_anterior = llamada.agente
        llamada.agente = nuevo_agente
        llamada.estado = 'transferida'
        llamada.save()

        # DESENCADENADOR: Notificar nuevo agente
        notificar_agente_nueva_llamada.delay(
            agente_id=nuevo_agente.id,
            llamada_id=llamada.id
        )

        # CÁLCULO: Actualizar tiempo en cola
        llamada.tiempo_total_cola += llamada.calcular_tiempo_transferencia()
        llamada.save()

        return Response({'status': 'Llamada reasignada exitosamente'})
```

### Caso de Uso 3: Generación de Reporte de Rendimiento

**Actores:** Gerente, Sistema

**Reglas Aplicadas:**
- **R4 (Restricción):** Solo gerentes pueden generar reportes completos
- **C3 (Cálculo):** Calcular métricas DORA (AHT, FCR, CSAT, etc.)
- **I2 (Inferencia):** Clasificar agentes por nivel de rendimiento
- **C4 (Cálculo):** Comparar contra promedios del equipo

**Implementación:**

```python
# Backend: api/callcentersite/reportes/views.py

class ReporteRendimientoViewSet(viewsets.ViewSet):
    permission_classes = [IsGerente]

    @action(detail=False, methods=['get'])
    def rendimiento_equipo(self, request):
        """
        RESTRICCIÓN: Solo gerentes pueden acceder
        """
        equipo_id = request.query_params.get('equipo_id')
        fecha_inicio = request.query_params.get('fecha_inicio')
        fecha_fin = request.query_params.get('fecha_fin')

        agentes = Agente.objects.filter(equipo_id=equipo_id)

        reporte = []
        for agente in agentes:
            # CÁLCULOS: Métricas individuales
            metricas = {
                'agente_id': agente.id,
                'nombre': agente.user.get_full_name(),
                'aht': agente.calcular_aht(fecha_inicio, fecha_fin),
                'fcr': agente.calcular_fcr(fecha_inicio, fecha_fin),
                'csat': agente.calcular_csat(fecha_inicio, fecha_fin),
                'total_llamadas': agente.llamadas.filter(
                    timestamp__range=[fecha_inicio, fecha_fin]
                ).count()
            }

            # INFERENCIA: Clasificación de rendimiento
            metricas['nivel_rendimiento'] = agente.nivel_rendimiento

            reporte.append(metricas)

        # CÁLCULO: Promedios del equipo
        promedios = {
            'aht_promedio': sum(r['aht'] for r in reporte) / len(reporte),
            'fcr_promedio': sum(r['fcr'] for r in reporte) / len(reporte),
            'csat_promedio': sum(r['csat'] for r in reporte) / len(reporte),
        }

        return Response({
            'agentes': reporte,
            'promedios_equipo': promedios,
            'fecha_inicio': fecha_inicio,
            'fecha_fin': fecha_fin
        })
```

---

## Validación y Testing

### Validación Automática con Business Rules Validator Agent

```bash
# Ejecutar validación de documentación
python3 scripts/coding/ai/automation/business_rules_validator_agent.py \
  --docs-dir docs/gobernanza/requisitos/reglas_negocio \
  --verbose

# Salida esperada:
# Status: VALID
# Files checked: 4 (README.md, INTRODUCCION.md, HECHOS_RESTRICCIONES.md,
#                   TIPOS_AVANZADOS.md, APLICACION_IACT.md)
# Errors: 0
# Warnings: 0
```

### Testing de Reglas de Negocio

```python
# Backend: api/callcentersite/agentes/tests/test_business_rules.py

from django.test import TestCase
from ..models import Agente, Equipo

class AgenteBusinessRulesTest(TestCase):
    """Test de reglas de negocio para Agentes"""

    def test_restriccion_extension_unica(self):
        """RESTRICCIÓN: Extensión debe ser única"""
        equipo = Equipo.objects.create(nombre="Equipo 1")
        Agente.objects.create(
            user=self.user1,
            extension="1001",
            equipo=equipo
        )

        # Debe fallar al crear agente con misma extensión
        with self.assertRaises(IntegrityError):
            Agente.objects.create(
                user=self.user2,
                extension="1001",
                equipo=equipo
            )

    def test_inferencia_nivel_rendimiento(self):
        """INFERENCIA: Nivel de rendimiento basado en métricas"""
        agente = Agente.objects.get(pk=1)

        # Mock de métricas excelentes
        with patch.object(agente, 'calcular_metricas_mes_actual') as mock:
            mock.return_value = {
                'fcr': 90,
                'aht': 240,  # 4 minutos
                'csat': 4.8
            }

            self.assertEqual(agente.nivel_rendimiento, 'Excelente')

    def test_calculo_aht(self):
        """CÁLCULO: Average Handle Time correcto"""
        agente = Agente.objects.get(pk=1)

        # Crear llamadas de prueba
        for duracion in [180, 240, 300]:  # 3, 4, 5 minutos
            Llamada.objects.create(
                agente=agente,
                duracion=duracion,
                estado='finalizada'
            )

        aht = agente.calcular_aht()
        self.assertEqual(aht, 240)  # Promedio: 4 minutos

    def test_desencadenador_notificacion_inactividad(self):
        """DESENCADENADOR: Notificar supervisor si inactividad > 15 min"""
        agente = Agente.objects.get(pk=1)
        sesion = SesionAgente.objects.create(agente=agente)

        # Simular 16 minutos sin llamadas
        sesion.tiempo_sin_llamada = 960
        sesion.save()

        # Verificar que se creó tarea de notificación
        self.assertTrue(
            notificar_supervisor.delay.called_with(
                agente_id=agente.id
            )
        )
```

### Testing Frontend (React)

```typescript
// frontend/src/features/calls/tests/businessRules.test.tsx

describe('Llamada Business Rules', () => {

  it('RESTRICCIÓN: No permite cerrar llamada sin clasificación', () => {
    const { getByRole } = render(<CallScreen />);
    const cerrarButton = getByRole('button', { name: /cerrar llamada/i });

    fireEvent.click(cerrarButton);

    expect(screen.getByText(/debe seleccionar una clasificación/i))
      .toBeInTheDocument();
  });

  it('CÁLCULO: Muestra duración de llamada actualizada', () => {
    const mockCall = {
      timestamp_inicio: new Date('2025-11-14T10:00:00'),
      timestamp_fin: new Date('2025-11-14T10:05:30')
    };

    const { getByTestId } = render(<CallDuration call={mockCall} />);

    expect(getByTestId('call-duration')).toHaveTextContent('5:30');
  });

  it('INFERENCIA: Muestra badge de seguimiento requerido', () => {
    const mockCall = {
      resolucion_primer_contacto: false,
      cliente: { categoria: 'VIP' }
    };

    const { getByText } = render(<CallCard call={mockCall} />);

    expect(getByText(/requiere seguimiento/i)).toBeInTheDocument();
  });
});
```

---

## Compliance y Auditoría

### LFPDPPP (Ley Federal de Protección de Datos Personales)

#### Datos Personales Protegidos

```python
# Backend: api/callcentersite/clientes/models.py

from django.db import models
from encrypted_model_fields.fields import EncryptedCharField

class Cliente(models.Model):
    """
    RESTRICCIÓN LFPDPPP: Datos personales deben estar encriptados
    """
    nombre_completo = EncryptedCharField(max_length=200)
    rfc = EncryptedCharField(max_length=13)
    curp = EncryptedCharField(max_length=18)
    telefono = EncryptedCharField(max_length=15)
    direccion = EncryptedCharField(max_length=500)

    # Datos no sensibles sin encriptar
    fecha_registro = models.DateTimeField(auto_now_add=True)
    categoria = models.CharField(max_length=20)

    class Meta:
        db_table = 'clientes'
        verbose_name = 'Cliente'
```

#### Registro de Auditoría

```python
# Backend: api/callcentersite/auditoria/models.py

class LogAuditoria(models.Model):
    """
    RESTRICCIÓN LFPDPPP: Todo acceso a datos personales debe registrarse
    """
    usuario = models.ForeignKey(User, on_delete=models.PROTECT)
    accion = models.CharField(max_length=50)  # lectura, modificacion, eliminacion
    recurso_tipo = models.CharField(max_length=50)
    recurso_id = models.IntegerField()
    timestamp = models.DateTimeField(auto_now_add=True)
    ip_address = models.GenericIPAddressField()
    user_agent = models.TextField()

    class Meta:
        db_table = 'auditoria_logs'
        ordering = ['-timestamp']

# Middleware para logging automático
class AuditoriaMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        response = self.get_response(request)

        # DESENCADENADOR: Registrar acceso a datos personales
        if request.path.startswith('/api/clientes/'):
            LogAuditoria.objects.create(
                usuario=request.user,
                accion=request.method,
                recurso_tipo='Cliente',
                recurso_id=self.extract_id(request.path),
                ip_address=self.get_client_ip(request),
                user_agent=request.META.get('HTTP_USER_AGENT', '')
            )

        return response
```

#### Restricción de Visualización

```python
# Backend: api/callcentersite/clientes/serializers.py

class ClienteSerializer(serializers.ModelSerializer):
    """
    RESTRICCIÓN: Mostrar solo últimos 4 dígitos de RFC/CURP en UI
    """
    rfc_masked = serializers.SerializerMethodField()
    curp_masked = serializers.SerializerMethodField()

    def get_rfc_masked(self, obj):
        """Mostrar solo últimos 4 dígitos"""
        rfc_completo = obj.rfc  # Desencripta automáticamente
        return f"****{rfc_completo[-4:]}"

    def get_curp_masked(self, obj):
        """Mostrar solo últimos 4 dígitos"""
        curp_completo = obj.curp
        return f"****{curp_completo[-4:]}"

    class Meta:
        model = Cliente
        fields = ['id', 'nombre_completo', 'rfc_masked', 'curp_masked',
                  'telefono', 'categoria']
        # Excluir campos sensibles completos
        exclude = ['rfc', 'curp', 'direccion']
```

### Matriz de Compliance

| Regulación | Regla de Negocio | Implementación | Validación |
|------------|------------------|----------------|------------|
| LFPDPPP Art. 19 | Encriptación de datos personales | EncryptedCharField (AES-256) | Test unitario + auditoría |
| LFPDPPP Art. 13 | Consentimiento explícito | Campo `consiente_uso_datos` | Form validation |
| LFPDPPP Art. 22 | Registro de accesos | LogAuditoria + Middleware | Business Rules Validator |
| LFPDPPP Art. 34 | Derechos ARCO | Endpoints /api/clientes/{id}/arco/ | Integration tests |
| Telecomunicaciones | Grabación con consentimiento | `grabacion_consentida` flag | Pre-save hook |

---

## Resumen

### Beneficios de la Implementación

1. **Trazabilidad Completa:** Cada regla de negocio está mapeada a código específico
2. **Validación Automatizada:** Business Rules Validator Agent garantiza cumplimiento
3. **Testing Exhaustivo:** Tests unitarios validan cada tipo de regla
4. **Compliance Garantizado:** LFPDPPP implementado en múltiples capas
5. **Mantenibilidad:** Documentación sincronizada con código

### Próximos Pasos

1. **Expandir Coverage:** Agregar más dominios (Productos, Facturación)
2. **Performance Tuning:** Optimizar cálculos con caching (Redis)
3. **ML/AI Integration:** Inferencias avanzadas con modelos predictivos
4. **Real-time Monitoring:** Dashboard de compliance en tiempo real

---

## Documentos Relacionados

- [Casos de Uso](../CASOS_USO.md) - Integración de reglas en casos de uso
- [Introducción a las Reglas de Negocio](INTRODUCCION.md)
- [Tipos Básicos: Hechos y Restricciones](HECHOS_RESTRICCIONES.md)
- [Tipos Avanzados: Desencadenadores, Inferencias y Cálculos](TIPOS_AVANZADOS.md)
- [Constitución del Proyecto](../../../../.constitucion.yaml)
- [ADR-010: Organización por Dominio](../../adr/ADR_010_organizacion_proyecto_por_dominio.md)

---

**Mantenedor:** Equipo de Arquitectura IACT
**Última revisión:** 2025-11-14
