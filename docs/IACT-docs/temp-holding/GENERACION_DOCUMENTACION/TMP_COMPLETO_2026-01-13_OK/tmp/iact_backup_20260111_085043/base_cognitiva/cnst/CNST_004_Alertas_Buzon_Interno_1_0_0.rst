.. _CNST_004:

============================================================
CNST_004 - Alertas Buzón Interno, Máximo 50 Destinatarios
============================================================

:Restricción: CNST_004
:Versión: 1.0.0
:Fecha: 2026-01-11
:Estado: VIGENTE
:Prioridad: ALTA
:Ámbito: MOD_Alerts - Sistema de alertas y notificaciones
:Fundamento: Control de sobrecarga y uso responsable
:Proyecto: IACT-2025-001
:Relacionado_Con: CNST_001 (NO Email), CNST_003 (Datos desfasados)

.. contents:: Tabla de Contenido
   :depth: 4
   :local:

============================================================
1. RESUMEN EJECUTIVO
============================================================

1.1 Definición de la Restricción
----------------------------------

   **El Sistema IACT gestiona alertas con las siguientes restricciones 
   obligatorias:**
   
   1. **Buzón Interno Exclusivo:** Las alertas se entregan ÚNICAMENTE 
      a través del buzón interno de la aplicación (CNST_001). NO por 
      email, SMS, push notifications u otros canales.
   
   2. **Máximo 50 Destinatarios:** Una alerta NO puede tener más de 50 
      destinatarios simultáneos. Esto previene sobrecarga del sistema 
      y uso inadecuado.
   
   3. **Consolidación de Alertas:** Alertas del mismo tipo y métrica 
      que se disparan múltiples veces en corto tiempo (< 1 hora) se 
      consolidan en una sola notificación.
   
   4. **NO Real-Time Extremo:** Las alertas se evalúan cada 5-15 minutos, 
      NO en tiempo real extremo (segundos). Alineado con CNST_003 
      (datos desfasados 6-12h).

1.2 Justificación
------------------

**Control de Sobrecarga:**

- Prevenir saturación del buzón interno
- Evitar "alert fatigue" (fatiga de alertas)
- Mantener performance del sistema
- Proteger BD de escrituras masivas

**Uso Responsable:**

- Límite de 50 destinatarios fuerza diseño cuidadoso de alertas
- Usuario piensa en quién realmente necesita la alerta
- Prevenir spam interno
- Fomentar segmentación adecuada de equipos

**Calidad de Alertas:**

- Consolidación reduce ruido
- Usuario ve solo alertas relevantes
- Menor overhead de procesamiento
- Mejor experiencia de usuario

**Alineación con Arquitectura:**

- Coherente con CNST_001 (NO email)
- Coherente con CNST_003 (datos desfasados, no real-time)
- Simplifica infraestructura (no push notifications)

1.3 Impacto General
--------------------

.. list-table:: Impacto de CNST_004
   :header-rows: 1
   :widths: 30 70

   * - Aspecto
     - Impacto
   * - **Usuario Final**
     - • Alertas solo en buzón interno
       • Máximo 50 destinatarios por alerta configurada
       • Alertas consolidadas (no repetidas cada minuto)
       • Evaluación cada 5-15 min (no instantánea)
   * - **Módulo Afectado**
     - MOD_Alerts (todas las funciones)
   * - **Funciones RBAC**
     - • ALR-002: configura_alertas (límite 50)
       • ALR-003: configura_alertas_equipo (límite 50)
       • ALR-001, ALR-004, ALR-005, ALR-006 (recepción)
   * - **Infraestructura**
     - • NO requiere servicio de email/SMS/push
       • Cron job cada 5-15 min para evaluar alertas
       • Tabla de consolidación de alertas
   * - **Performance**
     - • Escrituras a BD limitadas (max 50/alerta)
       • Evaluación periódica (no continua)
       • Cache de última evaluación por alerta

============================================================
2. ESPECIFICACIÓN TÉCNICA
============================================================

2.1 Límite de 50 Destinatarios
--------------------------------

.. code-block:: yaml

   Regla: MAX_DESTINATARIOS_POR_ALERTA = 50
   
   Validación:
     - Al configurar alerta (ALR-002, ALR-003)
     - Al agregar destinatario a alerta existente
     - Al disparar alerta masiva
   
   Comportamiento:
     - Si destinatarios > 50:
       → Rechazar operación
       → Mensaje: "Máximo 50 destinatarios por alerta (CNST_004)"
       → Sugerir: Segmentar en múltiples alertas
     
     - Si destinatarios <= 50:
       → Aceptar operación
       → Registrar count de destinatarios
   
   Excepciones: NINGUNA
   
   Justificación del límite:
     - 50 usuarios = equipo grande/departamento
     - >50 = probablemente mal diseñada (demasiado genérica)
     - Fuerza segmentación por rol/segmento/centro

**Ejemplo de error:**

.. code-block:: python

   >>> alerta.agregar_destinatarios(usuarios_ids=[1, 2, 3, ..., 52])
   ValueError: Máximo 50 destinatarios por alerta (CNST_004).
   Actual: 52. Reduce la cantidad o segmenta en múltiples alertas.

2.2 Consolidación de Alertas
------------------------------

.. code-block:: yaml

   Regla: Alertas similares se consolidan en ventana de 1 hora
   
   Criterios de similitud:
     - Misma alerta_id
     - Mismo usuario destinatario
     - Misma métrica
     - Mismo umbral
     - Disparada en ventana < 1 hora
   
   Proceso:
     1. Alerta se dispara a las 10:00
        → Crear notificación en buzón
        → Marcar: ultima_notificacion = 10:00
     
     2. Alerta se dispara nuevamente a las 10:15
        → Verificar: (10:15 - 10:00) < 1 hora → SÍ
        → NO crear nueva notificación
        → Actualizar notificación existente:
          * Incrementar contador: "Disparada 2 veces"
          * Actualizar última ocurrencia: 10:15
     
     3. Alerta se dispara a las 11:05
        → Verificar: (11:05 - 10:00) < 1 hora → NO (1h 5min)
        → Crear NUEVA notificación
        → Reiniciar consolidación
   
   Beneficios:
     - Usuario ve "Alerta X disparada 5 veces en última hora"
     - NO ve 5 notificaciones repetidas
     - Reduce fatiga de alertas
     - Mantiene buzón limpio

**Ejemplo de notificación consolidada:**

.. code-block:: text

   ┌────────────────────────────────────────────────────────┐
   │ ⚠️  Alerta: Llamadas > 10,000                          │
   ├────────────────────────────────────────────────────────┤
   │ Esta alerta se ha disparado 3 veces en la última hora │
   │                                                        │
   │ Primera ocurrencia: 2026-01-11 10:00:00               │
   │ Última ocurrencia:  2026-01-11 10:45:00               │
   │                                                        │
   │ Valores registrados:                                   │
   │   • 10:00 → 10,234 llamadas                           │
   │   • 10:15 → 10,512 llamadas                           │
   │   • 10:45 → 10,891 llamadas                           │
   │                                                        │
   │ [Ver Dashboard] [Pausar Alerta]                       │
   └────────────────────────────────────────────────────────┘

2.3 Frecuencia de Evaluación
------------------------------

.. code-block:: yaml

   Frecuencia: Cada 5-15 minutos
   Motor: Cron job / Celery beat
   
   Proceso de Evaluación:
     1. Obtener alertas activas (no pausadas)
     2. Para cada alerta:
        a. Consultar métrica actual
        b. Comparar con umbral configurado
        c. Si umbral superado:
           - Verificar consolidación (última notificación < 1h)
           - Si consolidar: Actualizar notificación existente
           - Si no: Crear nueva notificación
        d. Si umbral NO superado:
           - No hacer nada (alerta en estado normal)
     3. Registrar evaluación en audit_logs
   
   Configuración:
     - Producción: cada 15 minutos (ligera carga)
     - Dev/Testing: cada 5 minutos (más responsivo)
   
   NO Real-Time:
     - NO evaluar cada segundo/minuto
     - NO usar streaming de datos
     - Coherente con CNST_003 (datos desfasados 6-12h)
   
   Justificación:
     - Alertas de negocio NO requieren tiempo real
     - Decisiones basadas en tendencias, no eventos instantáneos
     - Performance: Evaluar cada 15 min vs cada 1 min = 15x menos carga

2.4 Tipos de Alertas Soportadas
---------------------------------

.. list-table:: Tipos de Alertas IACT
   :header-rows: 1
   :widths: 25 25 50

   * - Tipo
     - Métrica
     - Ejemplo
   * - **Umbral Absoluto**
     - Valor > N
     - Llamadas > 10,000
   * - **Umbral Porcentual**
     - % cambio > N%
     - Abandono > 15%
   * - **Tendencia**
     - ↑ o ↓ por N días
     - Llamadas ↓ 3 días consecutivos
   * - **Disponibilidad**
     - Dato faltante
     - No hay datos de centro X en 24h
   * - **ETL**
     - Estado ETL
     - ETL falló en última ejecución

============================================================
3. FUNCIONES RBAC AFECTADAS
============================================================

3.1 ALR-002: configura_alertas
--------------------------------

.. code-block:: yaml

   Función: configura_alertas
   Capacidad: alerts:configurar
   Módulo: MOD_Alerts
   
   Configuración de alerta personal:
     - Nombre descriptivo (obligatorio)
     - Métrica a monitorear (obligatorio)
     - Tipo de umbral (absoluto, porcentual, tendencia)
     - Valor del umbral (obligatorio)
     - Severidad (INFO, WARNING, CRITICAL)
     - Destinatario: Solo YO (usuario actual)
   
   Restricciones CNST_004:
     ✓ Destinatarios = 1 (solo yo) → OK
     ✓ Canal = Buzón interno (único canal)
     ✓ Evaluación cada 15 minutos
     ✓ Consolidación automática
   
   Proceso:
     1. Validar datos de entrada
     2. Validar métrica existe y es válida
     3. Crear alerta en estado ACTIVO
     4. Registrar en audit_logs
     5. Notificar confirmación en buzón
   
   Caso de Uso: UC-036
   Código de ejemplo: Ver sección 6.1

3.2 ALR-003: configura_alertas_equipo
---------------------------------------

.. code-block:: yaml

   Función: configura_alertas_equipo
   Capacidad: alerts:config_equipo
   Módulo: MOD_Alerts
   
   Configuración de alerta para equipo:
     - Similar a ALR-002
     - Destinatarios: Lista de usuarios (max 50)
     - Restricción: Usuarios del mismo segmento
   
   Restricciones CNST_004:
     ✓ Destinatarios <= 50 (OBLIGATORIO)
     ✓ Si >50 → Rechazar con error
     ✓ Canal = Buzón interno (único canal)
     ✓ Evaluación cada 15 minutos
     ✓ Consolidación automática
   
   Validaciones adicionales:
     - Todos los destinatarios deben existir y estar ACTIVOS
     - Usuario creador debe tener función ALR-003
     - Todos los destinatarios deben estar en mismo segmento
   
   Caso de Uso: UC-040

3.3 ALR-001: ve_alertas
------------------------

.. code-block:: yaml

   Función: ve_alertas
   Capacidad: alerts:ver
   Módulo: MOD_Alerts
   
   Visualización de alertas propias:
     - Lista de alertas configuradas por el usuario
     - Estado: ACTIVO, PAUSADO, ELIMINADO
     - Última vez disparada
     - Contador de disparos (últimos 7 días)
     - Destinatarios (solo en alertas de equipo)
   
   Información mostrada:
     - Nombre de la alerta
     - Métrica monitoreada
     - Umbral configurado
     - Severidad
     - Estado actual
     - Última evaluación
     - Última vez disparada
   
   Caso de Uso: UC-039

3.4 ALR-004: pausa_alertas
---------------------------

.. code-block:: yaml

   Función: pausa_alertas
   Capacidad: alerts:pausar
   Módulo: MOD_Alerts
   
   Pausar alertas temporalmente (snooze):
     - Duración: 1h, 4h, 24h, 7 días, indefinido
     - Alerta pausada NO se evalúa
     - Reactivación automática al vencer duración
     - Usuario puede reactivar manualmente antes
   
   Uso típico:
     - Usuario en vacaciones → pausar 7 días
     - Mantenimiento programado → pausar 4h
     - Alerta ruidosa → pausar indefinido (revisar config)
   
   Caso de Uso: UC-038

3.5 ALR-005: elimina_alertas
-----------------------------

.. code-block:: yaml

   Función: elimina_alertas
   Capacidad: alerts:eliminar
   Módulo: MOD_Alerts
   
   Eliminación de alertas propias:
     - Baja lógica (estado = ELIMINADO)
     - NO se borra de BD (auditoría)
     - Deja de evaluarse
     - Histórico se mantiene
   
   Restricción:
     - Solo el creador puede eliminar
     - Alertas de equipo: solo si soy el creador
   
   Caso de Uso: UC-036

3.6 ALR-006: ve_historial_alertas
-----------------------------------

.. code-block:: yaml

   Función: ve_historial_alertas
   Capacidad: alerts:historial
   Módulo: MOD_Alerts
   
   Historial de disparos:
     - Últimos 30 días por defecto
     - Filtros: Por alerta, por severidad, por fecha
     - Información:
       * Timestamp del disparo
       * Valor actual vs umbral
       * Notificación enviada (ID)
       * Consolidada (sí/no)
   
   Caso de Uso: UC-039

============================================================
4. MODELO DE DATOS
============================================================

4.1 Tabla: alertas
-------------------

.. code-block:: sql

   CREATE TABLE alertas (
       alerta_id BIGINT AUTO_INCREMENT PRIMARY KEY,
       nombre VARCHAR(200) NOT NULL,
       descripcion TEXT,
       
       -- Configuración de métrica
       metrica VARCHAR(100) NOT NULL,
       tipo_umbral ENUM('absoluto', 'porcentual', 'tendencia', 'disponibilidad') 
           NOT NULL,
       umbral_valor DECIMAL(15, 2),
       umbral_comparacion ENUM('mayor', 'menor', 'igual', 'distinto') 
           DEFAULT 'mayor',
       
       -- Destinatarios
       tipo_alerta ENUM('personal', 'equipo') NOT NULL,
       creador_id INT NOT NULL,
       destinatarios_ids JSON,  -- Array de usuario_ids
       destinatarios_count INT NOT NULL DEFAULT 1,
       
       -- Estado y severidad
       estado ENUM('ACTIVO', 'PAUSADO', 'ELIMINADO') NOT NULL DEFAULT 'ACTIVO',
       severidad ENUM('INFO', 'WARNING', 'CRITICAL') NOT NULL DEFAULT 'WARNING',
       
       -- Control de evaluación
       ultima_evaluacion DATETIME,
       ultima_vez_disparada DATETIME,
       veces_disparada_7d INT DEFAULT 0,  -- Contador últimos 7 días
       
       -- Pausar (snooze)
       pausada_hasta DATETIME,
       motivo_pausa VARCHAR(500),
       
       -- Consolidación
       consolidacion_ventana_minutos INT DEFAULT 60,
       
       -- Auditoría
       fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
       fecha_modificacion DATETIME ON UPDATE CURRENT_TIMESTAMP,
       
       CONSTRAINT fk_alerta_creador FOREIGN KEY (creador_id) 
           REFERENCES usuarios(usuario_id),
       
       -- Validación: Máximo 50 destinatarios
       CONSTRAINT chk_max_50_destinatarios CHECK (
           destinatarios_count <= 50
       ),
       
       INDEX idx_alerta_estado (estado),
       INDEX idx_alerta_creador (creador_id),
       INDEX idx_alerta_proxima_evaluacion (ultima_evaluacion)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

4.2 Tabla: alertas_disparos
-----------------------------

.. code-block:: sql

   CREATE TABLE alertas_disparos (
       disparo_id BIGINT AUTO_INCREMENT PRIMARY KEY,
       alerta_id BIGINT NOT NULL,
       fecha_disparo DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
       
       -- Valores
       valor_actual DECIMAL(15, 2) NOT NULL,
       umbral_configurado DECIMAL(15, 2) NOT NULL,
       
       -- Notificación
       notificacion_enviada BOOLEAN NOT NULL DEFAULT FALSE,
       notificaciones_ids JSON,  -- Array de notificacion_id del buzón
       destinatarios_notificados INT DEFAULT 0,
       
       -- Consolidación
       es_consolidada BOOLEAN NOT NULL DEFAULT FALSE,
       disparo_consolidado_con BIGINT,  -- ID del disparo padre
       ocurrencias_consolidadas INT DEFAULT 1,
       
       -- Metadatos
       metadata JSON,
       
       CONSTRAINT fk_disparo_alerta FOREIGN KEY (alerta_id) 
           REFERENCES alertas(alerta_id),
       CONSTRAINT fk_disparo_consolidado FOREIGN KEY (disparo_consolidado_con)
           REFERENCES alertas_disparos(disparo_id),
       
       INDEX idx_disparo_alerta (alerta_id),
       INDEX idx_disparo_fecha (fecha_disparo DESC)
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

4.3 Vista: Alertas Activas para Evaluación
--------------------------------------------

.. code-block:: sql

   CREATE VIEW vw_alertas_para_evaluar AS
   SELECT 
       a.alerta_id,
       a.nombre,
       a.metrica,
       a.tipo_umbral,
       a.umbral_valor,
       a.umbral_comparacion,
       a.severidad,
       a.destinatarios_ids,
       a.destinatarios_count,
       a.ultima_evaluacion,
       a.ultima_vez_disparada,
       a.consolidacion_ventana_minutos,
       
       -- Debe evaluarse si:
       CASE 
           WHEN a.estado = 'ACTIVO' 
                AND (a.pausada_hasta IS NULL OR a.pausada_hasta < NOW())
                AND (a.ultima_evaluacion IS NULL 
                     OR a.ultima_evaluacion < NOW() - INTERVAL 15 MINUTE)
           THEN TRUE
           ELSE FALSE
       END AS debe_evaluarse,
       
       -- Minutos desde última evaluación
       TIMESTAMPDIFF(MINUTE, a.ultima_evaluacion, NOW()) 
           AS minutos_desde_evaluacion
       
   FROM alertas a
   WHERE a.estado != 'ELIMINADO'
   ORDER BY a.ultima_evaluacion ASC NULLS FIRST;

============================================================
5. IMPLEMENTACIÓN DJANGO
============================================================

5.1 Modelo de Alerta
---------------------

.. code-block:: python

   # file: alerts/models.py
   from django.db import models
   from django.core.validators import MaxValueValidator
   from django.utils import timezone
   import json
   
   class Alerta(models.Model):
       """
       Modelo de alerta del sistema.
       
       Implementa CNST_004: Max 50 destinatarios, buzón interno.
       """
       
       TIPOS_UMBRAL = [
           ('absoluto', 'Absoluto'),
           ('porcentual', 'Porcentual'),
           ('tendencia', 'Tendencia'),
           ('disponibilidad', 'Disponibilidad'),
       ]
       
       ESTADOS = [
           ('ACTIVO', 'Activo'),
           ('PAUSADO', 'Pausado'),
           ('ELIMINADO', 'Eliminado'),
       ]
       
       SEVERIDADES = [
           ('INFO', 'Informativo'),
           ('WARNING', 'Advertencia'),
           ('CRITICAL', 'Crítico'),
       ]
       
       MAX_DESTINATARIOS = 50  # CNST_004
       
       alerta_id = models.BigAutoField(primary_key=True)
       nombre = models.CharField(max_length=200)
       descripcion = models.TextField(blank=True)
       
       # Configuración
       metrica = models.CharField(max_length=100)
       tipo_umbral = models.CharField(max_length=20, choices=TIPOS_UMBRAL)
       umbral_valor = models.DecimalField(max_digits=15, decimal_places=2)
       umbral_comparacion = models.CharField(
           max_length=10, 
           choices=[
               ('mayor', 'Mayor que'),
               ('menor', 'Menor que'),
               ('igual', 'Igual a'),
           ],
           default='mayor'
       )
       
       # Destinatarios
       tipo_alerta = models.CharField(
           max_length=10, 
           choices=[('personal', 'Personal'), ('equipo', 'Equipo')]
       )
       creador = models.ForeignKey(
           'users.Usuario', 
           on_delete=models.CASCADE,
           related_name='alertas_creadas'
       )
       destinatarios_ids = models.JSONField(default=list)
       destinatarios_count = models.IntegerField(
           default=1,
           validators=[MaxValueValidator(MAX_DESTINATARIOS)]
       )
       
       # Estado
       estado = models.CharField(max_length=20, choices=ESTADOS, default='ACTIVO')
       severidad = models.CharField(max_length=20, choices=SEVERIDADES, default='WARNING')
       
       # Evaluación
       ultima_evaluacion = models.DateTimeField(null=True, blank=True)
       ultima_vez_disparada = models.DateTimeField(null=True, blank=True)
       veces_disparada_7d = models.IntegerField(default=0)
       
       # Pausar
       pausada_hasta = models.DateTimeField(null=True, blank=True)
       motivo_pausa = models.CharField(max_length=500, blank=True)
       
       # Consolidación
       consolidacion_ventana_minutos = models.IntegerField(default=60)
       
       # Auditoría
       fecha_creacion = models.DateTimeField(auto_now_add=True)
       fecha_modificacion = models.DateTimeField(auto_now=True)
       
       class Meta:
           db_table = 'alertas'
           ordering = ['-fecha_creacion']
       
       def __str__(self):
           return f"Alerta: {self.nombre}"
       
       def clean(self):
           """Validaciones del modelo."""
           from django.core.exceptions import ValidationError
           
           # Validar máximo 50 destinatarios (CNST_004)
           if self.destinatarios_count > self.MAX_DESTINATARIOS:
               raise ValidationError(
                   f"Máximo {self.MAX_DESTINATARIOS} destinatarios por alerta (CNST_004)"
               )
           
           # Validar coherencia de destinatarios
           if isinstance(self.destinatarios_ids, list):
               if len(self.destinatarios_ids) != self.destinatarios_count:
                   raise ValidationError(
                       "destinatarios_count debe coincidir con len(destinatarios_ids)"
                   )
       
       @property
       def esta_activa(self):
           """True si la alerta debe evaluarse."""
           if self.estado != 'ACTIVO':
               return False
           
           if self.pausada_hasta and self.pausada_hasta > timezone.now():
               return False
           
           return True
       
       @property
       def debe_evaluarse(self):
           """True si debe evaluarse ahora (pasaron >15 min)."""
           if not self.esta_activa:
               return False
           
           if self.ultima_evaluacion is None:
               return True
           
           delta = timezone.now() - self.ultima_evaluacion
           return delta.total_seconds() > 15 * 60  # 15 minutos
       
       def pausar(self, duracion_horas=None, motivo=''):
           """Pausa la alerta."""
           if duracion_horas:
               self.pausada_hasta = timezone.now() + timedelta(hours=duracion_horas)
           else:
               # Pausar indefinidamente
               self.pausada_hasta = timezone.now() + timedelta(days=365)
           
           self.motivo_pausa = motivo
           self.estado = 'PAUSADO'
           self.save(update_fields=['pausada_hasta', 'motivo_pausa', 'estado'])
       
       def reactivar(self):
           """Reactiva una alerta pausada."""
           self.pausada_hasta = None
           self.motivo_pausa = ''
           self.estado = 'ACTIVO'
           self.save(update_fields=['pausada_hasta', 'motivo_pausa', 'estado'])
       
       def eliminar_logico(self):
           """Baja lógica de la alerta."""
           self.estado = 'ELIMINADO'
           self.save(update_fields=['estado'])

5.2 Servicio de Evaluación de Alertas
---------------------------------------

.. code-block:: python

   # file: alerts/evaluator.py
   from django.utils import timezone
   from datetime import timedelta
   from core.buzon_interno import BuzonInterno
   from .models import Alerta, AlertaDisparo
   
   class AlertEvaluator:
       """
       Evaluador de alertas.
       
       Implementa CNST_004: Consolidación, max 50 destinatarios.
       """
       
       @classmethod
       def evaluar_todas_alertas(cls):
           """
           Evalúa todas las alertas activas.
           
           Ejecutar cada 15 minutos vía cron/celery.
           
           Returns:
               dict: Estadísticas de evaluación
           """
           alertas_evaluadas = 0
           alertas_disparadas = 0
           notificaciones_enviadas = 0
           
           # Obtener alertas que deben evaluarse
           alertas = Alerta.objects.filter(
               estado='ACTIVO'
           ).filter(
               models.Q(pausada_hasta__isnull=True) |
               models.Q(pausada_hasta__lt=timezone.now())
           )
           
           for alerta in alertas:
               if alerta.debe_evaluarse:
                   resultado = cls.evaluar_alerta(alerta)
                   alertas_evaluadas += 1
                   
                   if resultado['disparada']:
                       alertas_disparadas += 1
                       notificaciones_enviadas += resultado['notificaciones_enviadas']
           
           return {
               'timestamp': timezone.now(),
               'alertas_evaluadas': alertas_evaluadas,
               'alertas_disparadas': alertas_disparadas,
               'notificaciones_enviadas': notificaciones_enviadas
           }
       
       @classmethod
       def evaluar_alerta(cls, alerta):
           """
           Evalúa una alerta específica.
           
           Args:
               alerta: Instancia de Alerta
           
           Returns:
               dict: Resultado de la evaluación
           """
           # 1. Obtener valor actual de la métrica
           valor_actual = cls._obtener_valor_metrica(alerta.metrica)
           
           # 2. Comparar con umbral
           umbral_superado = cls._comparar_umbral(
               valor_actual,
               alerta.umbral_valor,
               alerta.umbral_comparacion
           )
           
           # 3. Actualizar última evaluación
           alerta.ultima_evaluacion = timezone.now()
           alerta.save(update_fields=['ultima_evaluacion'])
           
           # 4. Si umbral superado, disparar alerta
           if umbral_superado:
               return cls._disparar_alerta(alerta, valor_actual)
           
           return {
               'disparada': False,
               'valor_actual': valor_actual,
               'umbral_superado': False
           }
       
       @classmethod
       def _disparar_alerta(cls, alerta, valor_actual):
           """
           Dispara una alerta (crea notificaciones).
           
           Implementa consolidación (CNST_004).
           """
           # Verificar consolidación
           ventana = timedelta(minutes=alerta.consolidacion_ventana_minutos)
           limite_consolidacion = timezone.now() - ventana
           
           # Buscar disparo reciente del mismo tipo
           disparo_reciente = AlertaDisparo.objects.filter(
               alerta=alerta,
               fecha_disparo__gte=limite_consolidacion,
               es_consolidada=False
           ).order_by('-fecha_disparo').first()
           
           if disparo_reciente:
               # CONSOLIDAR: Actualizar disparo existente
               disparo_reciente.ocurrencias_consolidadas += 1
               disparo_reciente.metadata = disparo_reciente.metadata or {}
               disparo_reciente.metadata['ultimos_valores'] = disparo_reciente.metadata.get('ultimos_valores', [])
               disparo_reciente.metadata['ultimos_valores'].append({
                   'timestamp': timezone.now().isoformat(),
                   'valor': float(valor_actual)
               })
               disparo_reciente.save()
               
               # Actualizar notificación en buzón
               cls._actualizar_notificacion_consolidada(disparo_reciente, valor_actual)
               
               return {
                   'disparada': True,
                   'consolidada': True,
                   'disparo_id': disparo_reciente.disparo_id,
                   'notificaciones_enviadas': 0  # Ya existían
               }
           
           else:
               # CREAR NUEVO DISPARO
               disparo = AlertaDisparo.objects.create(
                   alerta=alerta,
                   valor_actual=valor_actual,
                   umbral_configurado=alerta.umbral_valor,
                   es_consolidada=False,
                   ocurrencias_consolidadas=1
               )
               
               # Enviar notificaciones a destinatarios
               notificaciones_enviadas = cls._enviar_notificaciones(
                   alerta, 
                   disparo, 
                   valor_actual
               )
               
               # Actualizar contador de alerta
               alerta.ultima_vez_disparada = timezone.now()
               alerta.veces_disparada_7d = AlertaDisparo.objects.filter(
                   alerta=alerta,
                   fecha_disparo__gte=timezone.now() - timedelta(days=7)
               ).count()
               alerta.save(update_fields=['ultima_vez_disparada', 'veces_disparada_7d'])
               
               return {
                   'disparada': True,
                   'consolidada': False,
                   'disparo_id': disparo.disparo_id,
                   'notificaciones_enviadas': notificaciones_enviadas
               }
       
       @classmethod
       def _enviar_notificaciones(cls, alerta, disparo, valor_actual):
           """
           Envía notificaciones a destinatarios (CNST_004: max 50).
           """
           destinatarios_ids = alerta.destinatarios_ids
           
           # Validar máximo 50 (por si acaso)
           if len(destinatarios_ids) > 50:
               raise ValueError("Máximo 50 destinatarios (CNST_004)")
           
           # Preparar mensaje
           titulo = f"⚠️ Alerta: {alerta.nombre}"
           mensaje = (
               f"La alerta '{alerta.nombre}' se ha disparado.\n\n"
               f"  • Métrica: {alerta.metrica}\n"
               f"  • Umbral configurado: {alerta.umbral_comparacion} {alerta.umbral_valor}\n"
               f"  • Valor actual: {valor_actual}\n"
               f"  • Timestamp: {timezone.now().strftime('%Y-%m-%d %H:%M:%S')}\n"
               f"  • Severidad: {alerta.severidad}\n\n"
               f"Revisa el dashboard para más detalles."
           )
           
           # Enviar a cada destinatario
           notificaciones_ids = []
           for usuario_id in destinatarios_ids:
               notif = BuzonInterno.enviar_notificacion(
                   usuario_id=usuario_id,
                   tipo='ALERTA',
                   severidad=alerta.severidad,
                   titulo=titulo,
                   mensaje=mensaje,
                   url_accion=f'/alerts/{alerta.alerta_id}/detail',
                   metadata={
                       'alerta_id': alerta.alerta_id,
                       'disparo_id': disparo.disparo_id,
                       'metrica': alerta.metrica,
                       'valor_actual': float(valor_actual)
                   }
               )
               notificaciones_ids.append(notif.notificacion_id)
           
           # Guardar IDs de notificaciones en disparo
           disparo.notificacion_enviada = True
           disparo.notificaciones_ids = notificaciones_ids
           disparo.destinatarios_notificados = len(notificaciones_ids)
           disparo.save()
           
           return len(notificaciones_ids)
       
       @classmethod
       def _obtener_valor_metrica(cls, metrica):
           """Obtiene el valor actual de una métrica."""
           # Implementación específica según métricas disponibles
           # Ejemplo simplificado:
           from reports.services import ReportService
           
           if metrica == 'llamadas_hoy':
               return ReportService.contar_llamadas_hoy()
           elif metrica == 'abandono_porcentaje':
               return ReportService.calcular_abandono_hoy()
           # ... otras métricas
           
           return 0
       
       @classmethod
       def _comparar_umbral(cls, valor, umbral, comparacion):
           """Compara valor con umbral según tipo de comparación."""
           if comparacion == 'mayor':
               return valor > umbral
           elif comparacion == 'menor':
               return valor < umbral
           elif comparacion == 'igual':
               return abs(valor - umbral) < 0.01  # Tolerancia
           
           return False

============================================================
6. EJEMPLOS DE IMPLEMENTACIÓN
============================================================

6.1 Ejemplo: Crear Alerta Personal
------------------------------------

.. code-block:: python

   # file: alerts/views.py
   from rest_framework.decorators import api_view, permission_classes
   from rest_framework.permissions import IsAuthenticated
   from core.decorators import require_function
   
   @api_view(['POST'])
   @permission_classes([IsAuthenticated])
   @require_function('configura_alertas')
   def crear_alerta_personal(request):
       """
       Crea una alerta personal (ALR-002).
       
       POST /api/alerts/personal
       {
           "nombre": "Alertame si llamadas > 10,000",
           "metrica": "llamadas_hoy",
           "tipo_umbral": "absoluto",
           "umbral_valor": 10000,
           "umbral_comparacion": "mayor",
           "severidad": "WARNING"
       }
       """
       from alerts.models import Alerta
       
       # Crear alerta personal (1 destinatario: yo)
       alerta = Alerta.objects.create(
           nombre=request.data['nombre'],
           metrica=request.data['metrica'],
           tipo_umbral=request.data['tipo_umbral'],
           umbral_valor=request.data['umbral_valor'],
           umbral_comparacion=request.data.get('umbral_comparacion', 'mayor'),
           severidad=request.data.get('severidad', 'WARNING'),
           tipo_alerta='personal',
           creador=request.user,
           destinatarios_ids=[request.user.usuario_id],
           destinatarios_count=1,  # CNST_004: Solo 1 destinatario (yo)
           estado='ACTIVO'
       )
       
       return Response({
           'success': True,
           'alerta_id': alerta.alerta_id,
           'mensaje': 'Alerta personal creada exitosamente'
       })

6.2 Ejemplo: Crear Alerta de Equipo
-------------------------------------

.. code-block:: python

   @api_view(['POST'])
   @permission_classes([IsAuthenticated])
   @require_function('configura_alertas_equipo')
   def crear_alerta_equipo(request):
       """
       Crea una alerta para equipo (ALR-003).
       
       POST /api/alerts/equipo
       {
           "nombre": "Alerta equipo ventas",
           "metrica": "llamadas_hoy",
           "umbral_valor": 10000,
           "destinatarios_ids": [1, 2, 3, ..., 45]
       }
       """
       from alerts.models import Alerta
       
       destinatarios_ids = request.data['destinatarios_ids']
       
       # Validar máximo 50 destinatarios (CNST_004)
       if len(destinatarios_ids) > 50:
           return Response({
               'error': 'max_destinatarios_exceeded',
               'message': f'Máximo 50 destinatarios por alerta (CNST_004). Actual: {len(destinatarios_ids)}'
           }, status=400)
       
       # Validar que todos los usuarios existen y están activos
       from users.models import Usuario
       usuarios = Usuario.objects.filter(
           usuario_id__in=destinatarios_ids,
           activo=True
       )
       
       if usuarios.count() != len(destinatarios_ids):
           return Response({
               'error': 'invalid_destinatarios',
               'message': 'Algunos destinatarios no existen o están inactivos'
           }, status=400)
       
       # Crear alerta
       alerta = Alerta.objects.create(
           nombre=request.data['nombre'],
           metrica=request.data['metrica'],
           tipo_umbral=request.data.get('tipo_umbral', 'absoluto'),
           umbral_valor=request.data['umbral_valor'],
           umbral_comparacion=request.data.get('umbral_comparacion', 'mayor'),
           severidad=request.data.get('severidad', 'WARNING'),
           tipo_alerta='equipo',
           creador=request.user,
           destinatarios_ids=destinatarios_ids,
           destinatarios_count=len(destinatarios_ids),
           estado='ACTIVO'
       )
       
       return Response({
           'success': True,
           'alerta_id': alerta.alerta_id,
           'destinatarios_notificados': len(destinatarios_ids),
           'mensaje': 'Alerta de equipo creada exitosamente'
       })

============================================================
7. VALIDACIÓN Y TESTING
============================================================

7.1 Tests Unitarios
--------------------

.. code-block:: python

   # file: tests/test_cnst_004.py
   from django.test import TestCase
   from alerts.models import Alerta
   from users.models import Usuario
   
   class TestCNST004(TestCase):
       """
       Tests para validar CNST_004: Max 50 destinatarios, buzón interno
       """
       
       def test_limite_50_destinatarios(self):
           """Validar que no se pueden agregar >50 destinatarios."""
           usuario = Usuario.objects.create(username='test_user')
           
           # Intentar crear alerta con 51 destinatarios
           destinatarios = list(range(1, 52))  # 51 destinatarios
           
           alerta = Alerta(
               nombre='Alerta test',
               metrica='llamadas_hoy',
               tipo_umbral='absoluto',
               umbral_valor=10000,
               tipo_alerta='equipo',
               creador=usuario,
               destinatarios_ids=destinatarios,
               destinatarios_count=51
           )
           
           # Debe fallar validación
           with self.assertRaises(ValidationError):
               alerta.full_clean()
       
       def test_consolidacion_alertas(self):
           """Validar que alertas se consolidan en ventana de 1h."""
           from alerts.evaluator import AlertEvaluator
           from alerts.models import AlertaDisparo
           
           usuario = Usuario.objects.create(username='test_user')
           
           alerta = Alerta.objects.create(
               nombre='Test consolidación',
               metrica='llamadas_hoy',
               tipo_umbral='absoluto',
               umbral_valor=10000,
               tipo_alerta='personal',
               creador=usuario,
               destinatarios_ids=[usuario.usuario_id],
               destinatarios_count=1,
               consolidacion_ventana_minutos=60
           )
           
           # Disparar alerta 3 veces en 30 minutos
           for i in range(3):
               AlertEvaluator._disparar_alerta(alerta, 10000 + i*100)
           
           # Debe haber solo 1 disparo (consolidado)
           disparos = AlertaDisparo.objects.filter(alerta=alerta)
           self.assertEqual(disparos.count(), 1)
           
           # Verificar consolidación
           disparo = disparos.first()
           self.assertEqual(disparo.ocurrencias_consolidadas, 3)

============================================================
8. REFERENCIAS
============================================================

8.1 Documentos Relacionados
-----------------------------

:CNST_001: NO Email bajo ninguna circunstancia
:CNST_003: BD IVR readonly, ETL 6-12h, NO real-time
:UC_036: Configurar alerta personal
:UC_037: Recibir notificación interna
:UC_038: Pausar alertas
:UC_039: Ver alertas y historial
:UC_040: Gestionar destinatarios de alerta

8.2 Funciones RBAC Relacionadas
---------------------------------

:ALR_001: ve_alertas
:ALR_002: configura_alertas
:ALR_003: configura_alertas_equipo
:ALR_004: pausa_alertas
:ALR_005: elimina_alertas
:ALR_006: ve_historial_alertas

============================================================
9. HISTORIAL DE CAMBIOS
============================================================

.. list-table:: Historial de Versiones
   :header-rows: 1
   :widths: 15 15 70

   * - Versión
     - Fecha
     - Cambios
   * - 1.0.0
     - 2026-01-11
     - Versión inicial. Documentación completa de CNST_004:
       Alertas buzón interno, máx 50 destinatarios, consolidación,
       evaluación cada 15 min. Incluye: modelo de datos,
       evaluador de alertas, ejemplos completos.

============================================================

.. note::
   **RECORDATORIO:**
   
   CNST_004 define restricciones de sistema de alertas:
   - Canal: SOLO buzón interno (CNST_001)
   - Destinatarios: Máximo 50 por alerta
   - Consolidación: Automática en ventana de 1 hora
   - Evaluación: Cada 15 minutos (NO real-time extremo)
   
   Estas restricciones previenen sobrecarga y alert fatigue.

**FIN DEL DOCUMENTO CNST_004**
