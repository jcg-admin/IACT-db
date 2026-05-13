# PARTE 1: IDENTIFICAR REGLAS DE NEGOCIO
## La Base de Todo el Sistema de Requisitos

**Proyecto:** IACT - IVR Analytics & Customer Tracking  
**Documento:** Material Pedagógico - Identificación de BR  
**Versión:** 1.0.0  
**Fecha:** 2026-01-09  
**Clasificación:** C2 - INTERNAL

---

## METADATOS

**Prerequisito:** PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md  
**Siguiente:** PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md  
**Estándares:** STD_001_Estandares_Documentacion_1_1_0.rst  
**Nomenclatura:** NOM_001_Nomenclatura_Proyecto_2_0_0.rst  
**Duración estimada:** 8-10 horas  
**Nivel:** Intermedio

---

## TABLA DE CONTENIDO

1. [Introducción](#1-introduccion)
2. [Taxonomía de BR: Los 5 Tipos](#2-taxonomia-br)
3. [Desencadenadores vs Inferencias](#3-desencadenadores-inferencias)
4. [Técnicas de Elicitación](#4-tecnicas-elicitacion)
5. [Documentación de BR](#5-documentacion-br)
6. [Ejemplos del Proyecto IACT](#6-ejemplos-iact)
7. [Ejercicios Prácticos](#7-ejercicios-practicos)
8. [Errores Comunes](#8-errores-comunes)
9. [Validación de BR](#9-validacion-br)
10. [Plantillas y Templates](#10-plantillas-templates)
11. [Casos Especiales](#11-casos-especiales)
12. [Resumen y Siguientes Pasos](#12-resumen)

---

<a name="1-introduccion"></a>

## 1. INTRODUCCIÓN

### 1.1 Prerequisitos

**CRÍTICO:** Antes de comenzar PARTE 1, debes haber leído:

**Documento obligatorio:**
- PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md (completo)

**Secciones críticas de PARTE 0:**
- Sección 1: "El Problema" - Por qué los proyectos fracasan
- Sección 2: "La Solución" - Jerarquía BR → BReq → UC → FR
- Sección 3: "Transformaciones Clave" - Los 5 tipos de BR
- Sección 3.3: "Desencadenadores vs Inferencias" - Diferencia crítica

**Documentos de referencia:**
- STD_001_Estandares_Documentacion_1_1_0.rst - Estándares del proyecto
- NOM_001_Nomenclatura_Proyecto_2_0_0.rst - Nomenclatura correcta

**Si no has leído PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md:**

DETENTE AHORA. Regresa y lee PARTE 0 primero. Sin ese contexto, PARTE 1 no tendrá sentido.

### 1.2 Objetivos de Aprendizaje

Al completar PARTE 1, serás capaz de:

**Objetivos Primarios:**

1. **Identificar** los 5 tipos de reglas de negocio en cualquier proyecto
2. **Distinguir** Desencadenadores de Inferencias (la habilidad MÁS crítica)
3. **Documentar** BR usando TPL_BR_Decision_Tipo_1_0_0.rst
4. **Aplicar** técnicas de elicitación para descubrir BR ocultas
5. **Validar** BR con stakeholders y PO

**Objetivos Secundarios:**

6. Reconocer BR implícitas en conversaciones con usuarios
7. Clasificar BR por tipo de manera confiable
8. Evitar errores comunes en documentación de BR
9. Crear casos de prueba desde BR
10. Establecer trazabilidad BR → BReq

### 1.3 ¿Qué es una Regla de Negocio?

**Definición Formal:**

> Una Regla de Negocio (BR) es una política, restricción, cálculo o decisión
> del negocio que rige cómo el sistema debe comportarse, expresada en
> lenguaje natural comprensible por stakeholders no técnicos.

**Características de una BR:**

1. **Observable:** Stakeholders pueden verificar si se cumple
2. **Atómica:** Expresa una sola política (no compuesta)
3. **Persistente:** No cambia frecuentemente (no es temporal)
4. **Del negocio:** Viene del dominio, no de decisiones técnicas
5. **Testeable:** Se puede validar con casos de prueba

### 1.4 BR vs Otros Conceptos

**BR vs Business Requirement (BReq):**

```
BReq (Objetivo del negocio):
  "Prevenir sobrecarga del servidor Analytics"
  → Medible, estratégico, de alto nivel
  
BR (Política específica):
  "Consultas >10,000 registros requieren aprobación supervisor"
  → Implementable, específica, observable
```

Ver en PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md sección 2.3 para más detalles.

**BR vs Use Case (UC):**

```
BR (Política):
  "Usuario debe tener nivel_seguridad ≥ 3 para asignar funciones críticas"
  → Enunciado simple
  
UC (Interacción):
  UC_IACT_ACC_01_Asignar_Funciones_4_0_0.rst
  → 11 pasos, precondiciones, flujos alternos
  → IMPLEMENTA la BR
```

Ver en PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md sección 2.4 para más detalles.

**BR vs Functional Requirement (FR):**

```
BR (Política):
  "Sistema marca sesión EXPIRADA si inactividad > 15 minutos"
  → Lenguaje natural
  
FR (Especificación técnica):
  FR_AUTH_08_02_Marcar_Sesiones_Expiradas_1_0_0.rst
  → Query SQL específica
  → Timeout, índices, logs
```

Ver en PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md sección 2.5 para más detalles.

### 1.5 ¿Por Qué Documentar BR?

**Razón 1: Prevenir Retrabajo**

Como viste en PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md sección 1.4:

```
Sin BR documentadas:
  Sprint 2: Desarrollan consulta de reportes SIN validación
  Sprint 5: QA descubre retorna 50,000 registros sin restricción
  Sprint 6: PO dice "Necesita aprobación supervisor"
  Sprint 7: Retrabajo completo (40 horas perdidas)

Con BR documentadas desde inicio:
  Sprint 2: Diseñan UC con flujo de aprobación
  Sprint 3: Implementan tabla approvals
  Sprint 5: QA valida flujo completo
  Costo: 0 horas de retrabajo
```

**Razón 2: Comunicación Clara**

BR es el **lenguaje común** entre:
- Product Owner (define la política)
- Desarrolladores (implementan el código)
- QA (validan el comportamiento)
- Usuarios (experimentan la funcionalidad)

Todos hablan de la misma regla, sin ambigüedades.

**Razón 3: Trazabilidad**

```
Stakeholder dice: "Cambió la regla, ahora son 5,000 en lugar de 10,000"

Con trazabilidad BR → UC → FR → Código:
  1. Actualizar BR_IACT_028_Aprobacion_Consultas_1_0_0.rst
  2. Identificar UC afectados (UC_IACT_RPT_01)
  3. Actualizar FR derivados (FR_RPT_01_07)
  4. Actualizar código (reports/services.py)
  5. Actualizar tests (test_reports.py)
  
Sin trazabilidad:
  "¿Dónde más usamos esa regla? No sé... busquen en el código"
```

**Razón 4: Validación con Stakeholders**

BR documentadas se pueden validar ANTES de escribir código:

```
Analista: "Documenté BR-IACT-028: Aprobación si >10,000 registros"
PO: "Perfecto, correcto"
  
  [2 semanas después]
  
Analista: "Documenté BR-IACT-112: Timeout de 60 segundos en consultas"
PO: "ALTO. Eso está mal. Son 120 segundos, no 60"
Analista: "OK, corrijo la BR antes de implementar"

Costo: 5 minutos de corrección
vs
Costo si se descubre en código: 2 horas de refactoring
```

### 1.6 Nomenclatura de BR en Proyecto IACT

Según NOM_001_Nomenclatura_Proyecto_2_0_0.rst:

**Formato:**

```
BR_IACT_NNN_Nombre_Descriptivo_X_Y_Z.rst

Donde:
  BR: Prefijo (Business Rule)
  IACT: Proyecto
  NNN: Número secuencial 001-999
  Nombre_Descriptivo: CamelCase con guiones bajos
  X_Y_Z: Versionado semántico
  .rst: Extensión (reStructuredText)
```

**Ejemplos del Proyecto IACT:**

```
BR_IACT_028_Aprobacion_Consultas_1_0_0.rst
BR_IACT_031_Notificar_Sesion_Expira_1_0_0.rst
BR_IACT_046_Marcar_Sesion_Expirada_1_0_0.rst
BR_IACT_087_Nivel_Seguridad_Criticas_1_0_0.rst
BR_IACT_053_Calculo_Promedio_Duracion_1_0_0.rst
```

**IMPORTANTE:** Dentro del contenido de la BR, usamos el ID corto:

```
ID: BR-IACT-028        ← Dentro del archivo
Nombre de archivo: BR_IACT_028_Aprobacion_Consultas_1_0_0.rst
```

### 1.7 Estructura de Este Documento

**Secciones 2-3: Teoría**
- Taxonomía de los 5 tipos de BR
- Desencadenadores vs Inferencias (CRÍTICO)

**Secciones 4-5: Práctica**
- Técnicas de elicitación
- Documentación con templates

**Secciones 6-9: Aplicación**
- Ejemplos del proyecto IACT
- Ejercicios prácticos
- Errores comunes
- Validación

**Secciones 10-12: Herramientas**
- Plantillas y templates
- Casos especiales
- Resumen

### 1.8 Metodología de Estudio Recomendada

**Paso 1: Lectura Activa (4 horas)**

- Lee secciones 2-3 completas
- Toma notas de los 5 tipos de BR
- Subraya la diferencia Desencadenadores vs Inferencias

**Paso 2: Práctica Inmediata (2 horas)**

- Completa ejercicio 7.1 (Clasificar 10 BR)
- Valida tus respuestas
- Corrige errores

**Paso 3: Documentación Real (3 horas)**

- Identifica 5 BR de tu proyecto actual
- Documenta usando TPL_BR_Decision_Tipo_1_0_0.rst
- Valida con tu PO

**Paso 4: Revisión (1 hora)**

- Relee sección 3 (Desencadenadores vs Inferencias)
- Revisa tus 5 BR documentadas
- Asegúrate que clasificaste correctamente

**Total:** 10 horas (distribuidas en 2-3 días)

### 1.9 Convenciones de Este Documento

**Bloques de Código:**

```yaml
# Ejemplo de BR en formato YAML
ID: BR-IACT-028
Tipo: Restricción
Enunciado: "..."
```

**Diagramas:**

```
Timeline:
  T+0 min:  Usuario autenticado
  T+12 min: Sistema notifica
  T+15 min: Sesión expira
```

**Referencias:**

- Referencias a PARTE 0: PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md sección X
- Referencias a templates: TPL_BR_Decision_Tipo_1_0_0.rst
- Referencias a ejemplos: BR_IACT_028_Aprobacion_Consultas_1_0_0.rst

**Marcadores de Importancia:**

```
[CRÍTICO] - Concepto fundamental que debes dominar
[IMPORTANTE] - Concepto relevante para el examen
[NOTA] - Aclaración o detalle adicional
[EJEMPLO] - Caso práctico del proyecto IACT
```

### 1.10 Recursos Necesarios

**Herramientas:**

- Editor de texto (VS Code, Sublime, Vim)
- Sphinx (para visualizar RST)
- Git (para versionado)

**Acceso:**

- Product Owner (para validar BR)
- Stakeholders (para elicitación)
- Documentación del negocio

**Templates:**

- TPL_BR_Decision_Tipo_1_0_0.rst (próximo a generar)
- Checklist de validación
- Matriz de trazabilidad

### 1.11 Evaluación de Prerequisitos

**Antes de continuar, verifica que puedes responder:**

1. ¿Cuál es la diferencia entre BR y BReq?
2. ¿Cuáles son los 5 tipos de BR? (mencionados en PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md)
3. ¿Qué es un Desencadenador? ¿Y una Inferencia?
4. ¿Por qué BR-IACT-028 genera un UC completo mientras BR-IACT-046 solo genera un FR?
5. ¿Cuál es el formato de nomenclatura para BR según NOM_001_Nomenclatura_Proyecto_2_0_0.rst?

**Si no puedes responder las 5 preguntas:**

Regresa a PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md y revisa:
- Sección 2: La Solución
- Sección 3: Transformaciones Clave
- Sección 3.3: Desencadenadores vs Inferencias

**Si respondiste todas correctamente:**

¡Perfecto! Estás listo para PARTE 1. Continúa con la sección 2.

---

**[FIN DE SECCIÓN 1]**

**Siguiente:** Sección 2 - Taxonomía de BR: Los 5 Tipos

---

<a name="2-taxonomia-br"></a>

## 2. TAXONOMÍA DE BR: LOS 5 TIPOS

### 2.1 Visión General

Como viste en PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md sección 3.2, existen **5 tipos** de reglas de negocio:

1. **Restricciones** (Constraints)
2. **Cálculos** (Calculations)
3. **Desencadenadores** (Triggers)
4. **Inferencias** (Inferences)
5. **Definiciones** (Definitions)

### 2.2 Tipo 1: RESTRICCIONES

**Definición:** Política que LIMITA el comportamiento del sistema.

**[EJEMPLO] BR-IACT-028: Aprobación de Consultas Grandes**

```yaml
ID: BR-IACT-028
Tipo: Restricción
Enunciado: "Consultas >10,000 registros requieren aprobación supervisor"
```

**Transformación:** Restricción → Precondición + Flujo Alterno en UC

Ver detalles en PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md sección 3.2.

### 2.3 Tipo 2: CÁLCULOS

**Definición:** Fórmula que DERIVA un valor.

**[EJEMPLO] BR-IACT-053: Cálculo Promedio Duración**

```yaml
ID: BR-IACT-053
Tipo: Cálculo
Enunciado: "Promedio = SUM(duracion WHERE duracion>0) / COUNT(*)"
```

**Transformación:** Cálculo → FR con query SQL

### 2.4 Tipo 3: DESENCADENADORES

**Definición:** Inicia una acción OBSERVABLE por el usuario.

**[EJEMPLO] BR-IACT-031: Notificar Sesión por Expirar**

```yaml
ID: BR-IACT-031
Tipo: Desencadenador
Enunciado: "Sistema notifica usuario cuando sesión lleva 12 min inactiva"
Observable: Usuario RECIBE notificación
```

**Transformación:** Desencadenador → UC completo (11 pasos)

### 2.5 Tipo 4: INFERENCIAS

**Definición:** DEDUCE un estado sin que el usuario lo vea.

**[EJEMPLO] BR-IACT-046: Marcar Sesión Expirada**

```yaml
ID: BR-IACT-046
Tipo: Inferencia
Enunciado: "Sesión se considera EXPIRADA si inactividad >15 min"
Observable: NO - Solo campo BD cambia
```

**Transformación:** Inferencia → FR directo (UPDATE automático)

### 2.6 Tipo 5: DEFINICIONES

**Definición:** ACLARA un término del dominio.

**[EJEMPLO] BR-IACT-001: Cliente Activo**

```yaml
ID: BR-IACT-001
Tipo: Definición
Enunciado: "Cliente activo = al menos 1 llamada en últimos 30 días"
```

**Transformación:** Definición → Entrada en Glosario

### 2.7 Tabla Comparativa

| Tipo | Pregunta Clave | Transforma en | Ejemplo IACT |
|------|----------------|---------------|--------------|
| Restricción | ¿Limita algo? | Precondición + FA | BR-IACT-028 |
| Cálculo | ¿Deriva valor? | FR con SQL | BR-IACT-053 |
| Desencadenador | ¿Usuario VE acción? | UC completo | BR-IACT-031 |
| Inferencia | ¿Deduce estado oculto? | FR directo | BR-IACT-046 |
| Definición | ¿Aclara término? | Glosario | BR-IACT-001 |

**[FIN DE SECCIÓN 2]**

**Siguiente:** Sección 3 - Desencadenadores vs Inferencias (CRÍTICO)

---

<a name="3-desencadenadores-inferencias"></a>

## 3. DESENCADENADORES VS INFERENCIAS [CRÍTICO]

### 3.1 Por Qué Esta Sección Es La Más Importante

**[CRÍTICO]** Esta es la distinción MÁS DIFÍCIL y MÁS IMPORTANTE en todo el material de requisitos.

Como se explicó en PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md sección 3.3, confundir Desencadenadores con Inferencias causa:

- UC incorrectos (flujos que no deberían existir)
- FR innecesarios (código que no se necesita)
- Tests erróneos (validando comportamiento incorrecto)
- Horas de retrabajo

**Estadística real:** 60% de los errores en requisitos vienen de esta confusión.

### 3.2 El Test de Observabilidad

**Pregunta clave que debes memorizar:**

> ¿El usuario VE o RECIBE algo como resultado DIRECTO de esta BR?

```
SÍ → Desencadenador
  Ejemplos de "VER/RECIBIR":
    - Usuario RECIBE notificación en buzón
    - Popup aparece en pantalla
    - Email llega a inbox
    - Dashboard se actualiza en tiempo real
    - Alerta suena/parpadea

NO → Inferencia
  Ejemplos de "NO VER":
    - Solo campo BD cambia (session.estado = 'EXPIRED')
    - Flag se actualiza (customer.is_vip = TRUE)
    - Timestamp se registra (call.classified_at = NOW())
    - Estado se calcula (peak = TRUE si hora entre 9-12)
```

### 3.3 Análisis Comparativo Profundo

Vamos a analizar EN DETALLE dos BR que parecen similares pero son fundamentalmente diferentes:

**BR-IACT-031 vs BR-IACT-046**

#### 3.3.1 BR-IACT-031: Notificar Sesión por Expirar (DESENCADENADOR)

**Archivo:** BR_IACT_031_Notificar_Sesion_Expira_1_0_0.rst

```yaml
ID: BR-IACT-031
Nombre: Notificación de Sesión por Expirar
Tipo: Desencadenador
Categoría: User Experience

Enunciado:
  "El sistema debe notificar al usuario cuando su sesión haya estado
   inactiva durante 12 minutos, advirtiéndole que expirará en 3 minutos
   más si no realiza alguna acción."

Observable: SÍ
  Usuario RECIBE notificación en buzón interno
  Notificación dice: "Su sesión expirará en 3 minutos por inactividad"

Timing:
  T+0:   Usuario autenticado, última actividad registrada
  T+12min: DESENCADENADOR SE DISPARA
           Sistema crea InternalMessage
           Usuario VE mensaje en buzón
  T+15min: Si no actúa, sesión expira (BR-IACT-046)

Acción del Usuario:
  Usuario PUEDE actuar:
    - Hacer click en cualquier lugar → Resetea inactividad
    - Ignorar notificación → Sesión expirará a los 15 min

Interacción:
  Sistema ← → Usuario (bidireccional)
```

**¿Por qué es DESENCADENADOR?**

1. Usuario RECIBE algo (notificación visible)
2. Usuario PUEDE actuar (click o ignorar)
3. Hay INTERACCIÓN observable
4. Genera UC completo con actor secundario (Usuario)

**Transformación a UC:**

Esta BR GENERA UC_IACT_AUTH_07_Notificar_Sesion_4_0_0.rst:

```
UC-IACT-AUTH-07: Notificar Sesión por Expirar
Actor Principal: Sistema (Scheduler)
Actor Secundario: Usuario (receptor)
Trigger: Cron job cada 1 minuto

FLUJO NORMAL:
  1. Sistema ejecuta scheduler cada 1 min
  2. Sistema consulta sesiones con last_activity entre (NOW()-13min, NOW()-12min)
  3. Para cada sesión encontrada:
     3a. Sistema crea InternalMessage
     3b. Sistema envía notificación a user_id
     3c. Usuario VE mensaje en buzón
  4. Sistema marca session.notified_expiry = TRUE
  5. Sistema audita evento

FLUJO ALTERNO FA-1: Usuario Hace Click Después de Notificación
  En paso 3c, si usuario hace click antes de 15 min:
    → last_activity se actualiza
    → Sesión NO expira
    → notified_expiry se resetea a FALSE
```

**Implementación (código):**

```python
# File: apps/auth/tasks.py

def notify_expiring_sessions():
    """
    Notifica usuarios con sesiones por expirar.
    Ejecuta cada 1 minuto vía Celery Beat.
    
    Implements: BR-IACT-031
    References: UC_IACT_AUTH_07_Notificar_Sesion_4_0_0.rst
    """
    from datetime import timedelta
    from django.utils import timezone
    
    now = timezone.now()
    threshold_min = now - timedelta(minutes=13)
    threshold_max = now - timedelta(minutes=12)
    
    # Buscar sesiones entre 12-13 minutos inactivas
    sessions = UserSession.objects.filter(
        estado='ACTIVA',
        notified_expiry=False,
        last_activity__gte=threshold_min,
        last_activity__lt=threshold_max
    )
    
    for session in sessions:
        # CREAR NOTIFICACIÓN (observable por usuario)
        InternalMessage.objects.create(
            user=session.user,
            title="Sesión por Expirar",
            message="Su sesión expirará en 3 minutos por inactividad",
            priority="WARNING",
            created_at=now
        )
        
        # Marcar como notificada
        session.notified_expiry = True
        session.save()
        
        # Auditar
        UserActionLog.record(
            user=session.user,
            action='SESSION_EXPIRY_NOTIFIED',
            resource='user_session',
            result='SUCCESS'
        )
```

#### 3.3.2 BR-IACT-046: Marcar Sesión Expirada (INFERENCIA)

**Archivo:** BR_IACT_046_Marcar_Sesion_Expirada_1_0_0.rst

```yaml
ID: BR-IACT-046
Nombre: Marcar Sesión como Expirada
Tipo: Inferencia
Categoría: Security

Enunciado:
  "Una sesión se considera EXPIRADA si han transcurrido más de
   15 minutos desde la última actividad registrada."

Observable: NO
  Solo campo en BD cambia: session.estado = 'EXPIRED'
  Usuario NO ve nada en este momento
  Usuario NO recibe notificación

Timing:
  T+0:   Usuario autenticado
  T+15min: INFERENCIA SE EJECUTA
           UPDATE session SET estado='EXPIRED'
           Campo BD cambia (silencioso)
           Usuario NO se entera
  
  T+17min: Usuario intenta hacer request
           Sistema rechaza: "Sesión expirada"
           AHORA SÍ es observable (el rechazo, no el cambio)

Acción del Usuario:
  Usuario NO PUEDE actuar
  Usuario NO se entera hasta próximo request

Interacción:
  Sistema → BD (unidireccional)
  Sin interacción con usuario
```

**¿Por qué es INFERENCIA?**

1. Usuario NO recibe nada
2. Solo campo BD cambia
3. NO hay interacción observable
4. NO genera UC completo, solo FR

**Transformación a FR:**

Esta BR NO genera UC completo, solo FR_AUTH_08_02_Marcar_Sesiones_Expiradas_1_0_0.rst:

```yaml
FR-AUTH-08-02: Marcar Sesiones Inactivas como Expiradas
Tipo: Background Process
Derivado de: BR-IACT-046 (directamente)

Query SQL:
  UPDATE user_sessions
  SET estado = 'EXPIRED',
      expired_at = CURRENT_TIMESTAMP
  WHERE estado = 'ACTIVA'
    AND last_activity < (CURRENT_TIMESTAMP - INTERVAL '15 minutes')
  RETURNING session_id;

Ejecución:
  - Scheduler: Cada 1 minuto
  - Timeout: 5 segundos
  - Log: Registrar cantidad de sesiones expiradas

Validación:
  - Solo sesiones ACTIVAS se marcan
  - Campo expired_at se actualiza
  - Auditoría con cantidad afectada
```

**Implementación (código):**

```python
# File: apps/auth/tasks.py

def mark_expired_sessions():
    """
    Marca sesiones inactivas >15 min como EXPIRADAS.
    Ejecuta cada 1 minuto vía Celery Beat.
    
    Implements: BR-IACT-046
    References: FR_AUTH_08_02_Marcar_Sesiones_Expiradas_1_0_0.rst
    """
    from datetime import timedelta
    from django.utils import timezone
    from django.db import connection
    
    threshold = timezone.now() - timedelta(minutes=15)
    
    # UPDATE directo en BD (NO hay notificación al usuario)
    with connection.cursor() as cursor:
        cursor.execute("""
            UPDATE user_sessions
            SET estado = 'EXPIRED',
                expired_at = CURRENT_TIMESTAMP
            WHERE estado = 'ACTIVA'
              AND last_activity < %s
            RETURNING session_id
        """, [threshold])
        
        expired_count = cursor.rowcount
    
    # Solo auditar cantidad (no notificar usuarios)
    if expired_count > 0:
        SystemLog.info(
            action='SESSIONS_EXPIRED',
            count=expired_count,
            threshold=threshold
        )
```

### 3.4 Tabla Comparativa Detallada

| Aspecto | Desencadenador (BR-031) | Inferencia (BR-046) |
|---------|-------------------------|---------------------|
| **Observable** | Usuario RECIBE notificación | Solo BD cambia |
| **Actor Usuario** | Presente (recibe notificación) | Ausente |
| **Interacción** | Sistema ↔ Usuario | Sistema → BD |
| **Usuario puede actuar** | Hacer click, ignorar | No se entera |
| **Genera UC** | UC completo (11 pasos) | NO - solo FR |
| **Actor secundario** | Usuario (receptor) | Ninguno |
| **Código** | Crea InternalMessage | UPDATE silencioso |
| **Tests** | test_notification_sent() | test_session_marked() |
| **Timing visible** | T+12min usuario VE | T+15min usuario NO ve |
| **Auditoría** | Evento por usuario | Evento agregado (count) |

### 3.5 Más Ejemplos del Proyecto IACT

#### Ejemplo 3: BR-IACT-104 (Desencadenador)

```yaml
ID: BR-IACT-104
Nombre: Alerta de Llamadas Abandonadas
Tipo: Desencadenador

Enunciado:
  "El sistema debe alertar al supervisor cuando el porcentaje de
   llamadas abandonadas supere el 20% en una ventana de 1 hora."

Observable: SÍ
  Supervisor RECIBE alerta en dashboard
  Alerta dice: "23% llamadas abandonadas en última hora (umbral: 20%)"
  Dashboard parpadea en rojo

Genera:
  UC_IACT_ALR_01_Alertar_Abandonos_4_0_0.rst (UC completo)
  
¿Por qué Desencadenador?
  - Supervisor VE alerta
  - Puede actuar (revisar, silenciar, escalar)
  - Interacción observable
```

#### Ejemplo 4: BR-IACT-091 (Inferencia)

```yaml
ID: BR-IACT-091
Nombre: Clasificación de Horario
Tipo: Inferencia

Enunciado:
  "Una llamada se clasifica como PEAK si ocurre entre 09:00-12:00
   o 14:00-18:00 de lunes a viernes. De lo contrario es OFF-PEAK."

Observable: NO
  Solo campo call.peak_classification se calcula
  Nadie VE este cálculo suceder
  Se usa después en reportes

Genera:
  FR_PIPE_03_05_Clasificar_Horario_1_0_0.rst (solo FR)

¿Por qué Inferencia?
  - Solo campo BD se actualiza
  - Usuario NO recibe notificación
  - Cálculo automático durante ETL
```

### 3.6 Ejercicio de Clasificación

**Clasifica las siguientes BR como Desencadenador o Inferencia:**

**BR-X:**
```
"El sistema debe enviar email al cliente cuando su llamada
 sea transferida a un agente supervisor."
```

**BR-Y:**
```
"Un cliente se considera VIP si ha realizado más de 50
 llamadas en los últimos 3 meses."
```

**BR-Z:**
```
"El sistema debe mostrar popup de satisfacción al final
 de cada llamada de más de 5 minutos."
```

**BR-W:**
```
"Una llamada se marca como RESUELTA si el agente cambia
 el estado a 'Cerrada' y han pasado más de 24 horas."
```

**RESPUESTAS:**

**BR-X: DESENCADENADOR**
```
Razón: Cliente RECIBE email
Observable: Sí
Genera: UC completo de envío de email
```

**BR-Y: INFERENCIA**
```
Razón: Solo campo customer.is_vip se calcula
Observable: No - Cliente NO recibe notificación de que es VIP
Genera: Solo FR de cálculo
```

**BR-Z: DESENCADENADOR**
```
Razón: Usuario VE popup
Observable: Sí
Genera: UC completo con interacción en popup
```

**BR-W: INFERENCIA**
```
Razón: Solo campo call.status cambia a RESUELTA
Observable: No - Sucede automáticamente sin que nadie lo vea
Genera: Solo FR con UPDATE condicional
```

### 3.7 Errores Comunes

**Error 1: Confundir "el sistema hace" con "el usuario ve"**

```
INCORRECTO:
  "El sistema marca sesión expirada" → Desencadenador
  
CORRECTO:
  Pregunta: ¿El usuario VE que la sesión fue marcada?
  Respuesta: NO
  → Inferencia
```

**Error 2: Pensar que todo lo automático es Inferencia**

```
INCORRECTO:
  "El sistema envía notificación automática" → Inferencia
  
CORRECTO:
  Pregunta: ¿El usuario RECIBE la notificación?
  Respuesta: SÍ
  → Desencadenador
```

**Error 3: Confundir el resultado con la acción**

```
BR: "Sistema marca sesión expirada a los 15 min"

Momento 1 (T+15min): UPDATE session.estado = 'EXPIRED'
  ↓ ¿Usuario ve? NO → INFERENCIA (BR-IACT-046)

Momento 2 (T+17min): Usuario hace request
  ↓ Sistema rechaza con "Sesión expirada"
  ↓ ¿Usuario ve? SÍ → Pero esto NO es la BR
  
La BR es Momento 1, no Momento 2
```

### 3.8 Regla Mnemotécnica

**DI-NO-VE:**

```
Desencadenador: Usuario VE algo
Inferencia: Usuario NO ve nada
```

**Tarjeta de Memoria:**

```
┌─────────────────────────────────────┐
│  TEST DE OBSERVABILIDAD             │
├─────────────────────────────────────┤
│                                     │
│  ¿Usuario VE/RECIBE algo?           │
│                                     │
│    SÍ → DESENCADENADOR              │
│         - Genera UC completo        │
│         - Actor: Usuario            │
│         - Interacción observable    │
│                                     │
│    NO  → INFERENCIA                 │
│         - Genera solo FR            │
│         - Sin actor usuario         │
│         - Solo BD cambia            │
│                                     │
└─────────────────────────────────────┘
```

**[FIN DE SECCIÓN 3]**

**Siguiente:** Sección 4 - Técnicas de Elicitación

---

<a name="4-tecnicas-elicitacion"></a>

## 4. TÉCNICAS DE ELICITACIÓN

### 4.1 Entrevistas con Stakeholders

**Preguntas clave para descubrir BR:**

- "¿Qué puede/no puede hacer el usuario?"
- "¿Qué pasa si...?"
- "¿Cuándo el sistema debe...?"
- "¿Quién puede autorizar...?"

### 4.2 Análisis de Documentos

Buscar en:
- Políticas corporativas
- Manuales de procedimientos
- Regulaciones y leyes
- Emails de stakeholders

### 4.3 Observación de Procesos

Observar usuarios trabajando e identificar:
- Validaciones manuales → Restricciones
- Cálculos en Excel → Cálculos
- Notificaciones manuales → Desencadenadores

---

<a name="5-documentacion-br"></a>

## 5. DOCUMENTACIÓN DE BR

### 5.1 Template TPL_BR_Decision_Tipo_1_0_0.rst

Usar template para documentar BR. Campos obligatorios:

```yaml
ID: BR-IACT-NNN
Nombre: Nombre descriptivo
Tipo: [Restricción|Cálculo|Desencadenador|Inferencia|Definición]
Enunciado: "..."
Observable: [SÍ|NO]
Derivado de: BRQ-XXX
Genera: [UC_XXX | FR_XXX | GLOSARIO]
```

---

<a name="6-ejemplos-iact"></a>

## 6. EJEMPLOS DEL PROYECTO IACT

Ver documentos completos:
- BR_IACT_028_Aprobacion_Consultas_1_0_0.rst
- BR_IACT_031_Notificar_Sesion_Expira_1_0_0.rst
- BR_IACT_046_Marcar_Sesion_Expirada_1_0_0.rst
- BR_IACT_087_Nivel_Seguridad_Criticas_1_0_0.rst

---

<a name="7-ejercicios-practicos"></a>

## 7. EJERCICIOS PRÁCTICOS

### Ejercicio 7.1: Clasificar 10 BR

Clasifica las siguientes BR por tipo:

1. "Usuario debe tener permiso RPT-001 para ver reportes"
2. "Promedio duración = SUM/COUNT"
3. "Sistema alerta si CPU >80%"
4. "Cliente activo = llamada en últimos 30 días"
5. "Sesión expira si inactividad >15 min"

**Respuestas:**
1. Restricción
2. Cálculo
3. Desencadenador
4. Definición
5. Inferencia

### Ejercicio 7.2: Documentar 3 BR de Tu Proyecto

Elige 3 BR de tu proyecto actual y documéntalas usando TPL_BR_Decision_Tipo_1_0_0.rst.

---

<a name="8-errores-comunes"></a>

## 8. ERRORES COMUNES

### Error 1: BR Demasiado Técnica

```
INCORRECTO:
  "Campo session.estado debe cambiar a 'EXPIRED' cuando NOW() - last_activity > INTERVAL '15 minutes'"
  
CORRECTO:
  "Sesión se considera expirada si inactividad mayor a 15 minutos"
```

### Error 2: BR Compuesta

```
INCORRECTO:
  "Usuario debe tener nivel ≥3 Y función ACC-001 Y estar en segmento OP"
  
CORRECTO:
  Separar en 3 BR diferentes
```

---

<a name="9-validacion-br"></a>

## 9. VALIDACIÓN DE BR

### 9.1 Checklist de Validación

- [ ] Enunciado claro en lenguaje natural
- [ ] Tipo identificado correctamente
- [ ] Observable por stakeholder
- [ ] Atómica (una sola política)
- [ ] Testeable
- [ ] Trazabilidad a BReq establecida

### 9.2 Validación con PO

Presentar BR documentadas al Product Owner para aprobación.

---

<a name="10-plantillas-templates"></a>

## 10. PLANTILLAS Y TEMPLATES

### Plantilla Disponible

- TPL_BR_Decision_Tipo_1_0_0.rst (por generar en FASE 13)

---

<a name="11-casos-especiales"></a>

## 11. CASOS ESPECIALES

### 11.1 BR con Múltiples Condiciones

Documentar cada condición claramente.

### 11.2 BR Temporales

Si BR cambia cada trimestre, usar versionado semántico.

---

<a name="12-resumen"></a>

## 12. RESUMEN Y SIGUIENTES PASOS

### 12.1 Conceptos Clave

1. **5 tipos de BR:** Restricciones, Cálculos, Desencadenadores, Inferencias, Definiciones
2. **Test de observabilidad:** ¿Usuario VE algo? → Desencadenador vs Inferencia
3. **Transformación:** Cada tipo transforma diferente a UC/FR
4. **Documentación:** Usar TPL_BR_Decision_Tipo_1_0_0.rst

### 12.2 Habilidades Adquiridas

Al completar PARTE 1, ahora puedes:

- [OK] Identificar los 5 tipos de BR
- [OK] Distinguir Desencadenadores de Inferencias
- [OK] Documentar BR con template
- [OK] Aplicar técnicas de elicitación
- [OK] Validar BR con stakeholders

### 12.3 Siguiente Paso

**Continúa con:** PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md

Ahí aprenderás:
- Los 5 patrones de transformación BR → UC
- Construcción detallada de UC paso a paso
- Derivación de FR desde UC
- Trazabilidad bidireccional

### 12.4 Práctica Recomendada

**Antes de continuar con PARTE 2A:**

1. Completa ejercicio 7.2 (documentar 3 BR de tu proyecto)
2. Valida con tu PO
3. Asegúrate de clasificar correctamente Desencadenadores vs Inferencias
4. Revisa sección 3 si tienes dudas

---

## APÉNDICE A: REFERENCIAS RÁPIDAS

**Archivos Relacionados:**
- PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md
- STD_001_Estandares_Documentacion_1_1_0.rst
- NOM_001_Nomenclatura_Proyecto_2_0_0.rst
- TPL_BR_Decision_Tipo_1_0_0.rst

**Próximos Documentos:**
- PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md
- PARTE_2B_Construccion_Detallada_IACT_1_0_0.md

---

## APÉNDICE B: CHECKLIST DE COMPLETITUD

- [OK] Leí PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md
- [OK] Entiendo los 5 tipos de BR
- [OK] Domino Desencadenadores vs Inferencias
- [OK] Documenté 3 BR de mi proyecto
- [OK] Validé con PO
- [OK] Listo para PARTE 2A

---

**FIN DE PARTE 1**

**Versión:** 1.0.0  
**Fecha:** 2026-01-09  
**Siguiente:** PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md

