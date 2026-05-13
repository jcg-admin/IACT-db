---
proyecto: IACT
documento: PARTE_6
titulo: Casos Prácticos Completos
version: 1.0.0
fecha: 2026-01-09
prerequisito: PARTE_5_Trazabilidad_Gestion_IACT_1_0_0.md
estado: NUEVO
---

# PARTE 6: CASOS PRÁCTICOS COMPLETOS
## Aplicación Integral de PARTES 0-5

**Proyecto:** IACT - IVR Analytics & Customer Tracking  
**Versión:** 1.0.0  
**Fecha:** 2026-01-09  
**Clasificación:** C2 - INTERNAL

---

## METADATOS

**Prerequisito:** PARTE_5_Trazabilidad_Gestion_IACT_1_0_0.md  
**Estándares:** STD_001_Estandares_Documentacion_1_1_0.rst  
**Nomenclatura:** NOM_001_Nomenclatura_Proyecto_2_0_0.rst  
**Duración estimada:** 12-16 horas  
**Nivel:** Avanzado - Integración Completa

---

## TABLA DE CONTENIDO

1. [Introducción](#1-introduccion)
2. [Caso Práctico 1: Módulo de Reportes](#2-caso-reportes)
3. [Caso Práctico 2: Módulo de Autenticación](#3-caso-auth)
4. [Caso Práctico 3: Módulo de Control de Acceso](#4-caso-acceso)
5. [Caso Práctico 4: Integración Multi-Módulo](#5-caso-integracion)
6. [Ejercicios Guiados](#6-ejercicios)
7. [Proyecto Final: Sistema Completo](#7-proyecto-final)
8. [Validación y Auditoría](#8-validacion)
9. [Resumen y Certificación](#9-resumen)

---

<a name="1-introduccion"></a>

## 1. INTRODUCCIÓN

### 1.1 Objetivo de PARTE 6

**PARTE 6 es el punto de integración de TODO el material:**

Aplicarás en casos prácticos completos:

- **PARTE 0:** Jerarquía BR → BReq → UC → FR → Código
- **PARTE 1:** Identificar y clasificar Business Rules
- **PARTE 2A-C:** Transformar BR en Casos de Uso
- **PARTE 3A-D:** Técnicas de construcción de UC
- **PARTE 4:** Derivar Functional Requirements
- **PARTE 5:** Establecer trazabilidad completa

**No es teoría adicional.** Es práctica intensiva.

### 1.2 Prerequisitos Obligatorios

**CRÍTICO:** Antes de PARTE 6, debes haber completado:

- [x] PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md - Visión general
- [x] PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md - Identificar BR
- [x] PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md - Transformación
- [x] PARTE_2B_Construccion_Detallada_IACT_1_0_0.md - Construcción UC
- [x] PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md - Derivación FR
- [x] PARTE_5_Trazabilidad_Gestion_IACT_1_0_0.md - Trazabilidad

**Si no has completado estas PARTES:**

Detente. PARTE 6 no tiene sentido sin dominar los fundamentos.

### 1.3 Estructura de los Casos Prácticos

Cada caso práctico sigue el **flujo completo de requisitos:**

```
FASE 1: IDENTIFICACIÓN
  → Stakeholder expresa necesidad
  → Analista identifica BR implícitas
  → Documenta BR con template TPL_BR_Decision_Tipo_1_0_0.rst
  → Clasifica por tipo (Restricción, Cálculo, Desencadenador, etc.)

FASE 2: TRANSFORMACIÓN
  → Decide si BR genera UC nuevo o se integra en UC existente
  → Aplica patrón de transformación según tipo de BR
  → Construye UC con estructura estándar 11 pasos
  → Valida con checklist de calidad

FASE 3: DERIVACIÓN
  → Identifica pasos del UC que requieren FR
  → Deriva FR con template TPL_FR_Documentacion_10_Componentes_1_0_0.rst
  → Especifica queries SQL, validaciones, logs

FASE 4: IMPLEMENTACIÓN
  → Escribe código Python que implementa FR
  → Agrega comentarios con trazabilidad
  → Sigue estándares del proyecto

FASE 5: VALIDACIÓN
  → Escribe tests que validan BR original
  → Cubre flujos normales y alternos
  → Verifica trazabilidad completa

FASE 6: AUDITORÍA
  → Valida trazabilidad bidireccional
  → Calcula métricas de cobertura
  → Actualiza matriz RTM
```

### 1.4 Módulos del Proyecto IACT

Los casos prácticos cubren los **8 módulos principales:**

**1. RPT (Reportes):**
- BR-IACT-028: Aprobación consultas >10K
- UC-IACT-RPT-01: Consultar Reporte Trimestral
- FR-RPT-01-07: Calcular count registros

**2. AUTH (Autenticación):**
- BR-IACT-031: Notificar sesión expira (Desencadenador)
- BR-IACT-046: Marcar sesión expirada (Inferencia)
- UC-IACT-AUTH-07: Notificar Sesión por Expirar

**3. ACC (Control de Acceso):**
- BR-IACT-087: Nivel seguridad ≥3 para críticas
- UC-IACT-ACC-01: Asignar Función a Usuario
- Integra RBAC flat con SoD

**4. PIPE (Data Pipeline):**
- Ingesta de datos de IVR
- Transformaciones ETL
- Clasificación de llamadas

**5. DASHBOARD (Visualización):**
- Métricas en tiempo real
- Configuración de widgets
- Exportación de datos

**6. ADMIN (Administración):**
- Gestión de usuarios
- Configuración del sistema
- Auditoría

**7. API (Interfaz Externa):**
- REST API para integraciones
- Autenticación JWT
- Rate limiting

**8. NOTIF (Notificaciones):**
- Notificaciones internas
- Emails automáticos
- Alertas del sistema

### 1.5 Metodología de Estudio

**Paso 1: Lectura Activa (2 horas)**
- Lee Caso Práctico 1 completo
- Toma notas de cada fase
- Identifica patrones de PARTES 1-5

**Paso 2: Práctica Replicando (4 horas)**
- Replica Caso Práctico 1 paso a paso
- Documenta BR, UC, FR
- Escribe código y tests

**Paso 3: Práctica Independiente (6 horas)**
- Completa Casos Prácticos 2 y 3
- Usa templates sin mirar soluciones
- Valida tu trabajo contra soluciones

**Paso 4: Proyecto Final (8 horas)**
- Implementa sistema completo de Sección 7
- Integra múltiples módulos
- Presenta para revisión

**Total:** 20 horas (distribuidas en 1 semana)

### 1.6 Evaluación de Competencias

Al finalizar PARTE 6, serás evaluado en:

**Competencia 1: Identificación de BR (20%)**
- Extraer BR de conversaciones con stakeholders
- Clasificar correctamente por tipo
- Documentar con template estándar

**Competencia 2: Transformación a UC (25%)**
- Aplicar patrón correcto según tipo BR
- Construir UC con 11 pasos
- Integrar múltiples BR en un UC

**Competencia 3: Derivación de FR (20%)**
- Identificar pasos que requieren FR
- Documentar FR con 10 componentes
- Especificar queries y validaciones

**Competencia 4: Trazabilidad (20%)**
- Establecer referencias bidireccionales
- Mantener matriz RTM actualizada
- Calcular métricas de cobertura

**Competencia 5: Implementación (15%)**
- Escribir código que implementa FR
- Agregar comentarios de trazabilidad
- Escribir tests que validan BR

**Puntaje mínimo aprobatorio:** 80%

### 1.7 Convenciones de Casos Prácticos

**Formato de Soluciones:**

Cada caso práctico tiene:

```
ENUNCIADO
  ↓
ANÁLISIS (Identificar BR implícitas)
  ↓
SOLUCIÓN PASO A PASO
  - BR documentadas
  - UC construidos
  - FR derivados
  - Código implementado
  - Tests escritos
  ↓
VALIDACIÓN (Checklist completo)
  ↓
TRAZABILIDAD (Matriz RTM actualizada)
```

**Nomenclatura en Ejemplos:**

Todos los archivos siguen NOM_001_Nomenclatura_Proyecto_2_0_0.rst:

- BR_IACT_NNN_Nombre_1_0_0.rst
- UC_IACT_MOD_NN_Nombre_4_0_0.rst
- FR_MOD_NN_NN_Nombre_1_0_0.rst

**Código de Ejemplo:**

Todos los ejemplos usan:
- Python 3.9+
- Django 4.2
- PostgreSQL 14
- Pytest para tests

### 1.8 Recursos Necesarios

**Herramientas:**

- Editor de texto (VS Code recomendado)
- Sphinx para RST
- Git para versionado
- Python 3.9+ con Django

**Templates:**

- TPL_BR_Decision_Tipo_1_0_0.rst
- TPL_UC_Construccion_7_Pasos_1_0_0.rst
- TPL_FR_Documentacion_10_Componentes_1_0_0.rst
- TPL_TRZ_Matriz_RTM_1_0_0.rst

**Documentos de Referencia:**

- PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md
- PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md
- PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md
- PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md
- PARTE_5_Trazabilidad_Gestion_IACT_1_0_0.md

### 1.9 Expectativas de PARTE 6

**Al completar PARTE 6, habrás:**

- [ ] Aplicado el flujo completo BR → UC → FR → Código en 4 casos prácticos
- [ ] Documentado 15+ BR nuevas del proyecto IACT
- [ ] Construido 10+ UC completos con estructura estándar
- [ ] Derivado 30+ FR con especificaciones técnicas
- [ ] Implementado código Python para 20+ funciones
- [ ] Escrito 40+ tests que validan BR originales
- [ ] Establecido trazabilidad completa en matriz RTM
- [ ] Calculado métricas de cobertura >90%

**Esto te hace competente para:**

1. Trabajar como Business Analyst en proyectos complejos
2. Liderar proceso de requisitos en equipos ágiles
3. Asegurar trazabilidad y calidad en todo el ciclo
4. Comunicar efectivamente con stakeholders y developers
5. Auditar y validar requisitos para cumplimiento regulatorio

### 1.10 Estructura de Este Documento

**Secciones 2-4: Casos Prácticos por Módulo**
- Módulo de Reportes (BR-028, UC-RPT-01)
- Módulo de Autenticación (BR-031, BR-046, UC-AUTH-07)
- Módulo de Control de Acceso (BR-087, UC-ACC-01)

**Sección 5: Integración Multi-Módulo**
- Caso que integra RPT + AUTH + ACC
- Trazabilidad horizontal entre módulos
- Gestión de dependencias

**Sección 6: Ejercicios Guiados**
- 5 ejercicios con soluciones paso a paso
- Validación de competencias adquiridas

**Sección 7: Proyecto Final**
- Sistema completo de principio a fin
- Integración de todos los módulos
- Presentación y defensa

**Secciones 8-9: Validación y Certificación**
- Checklist de completitud
- Rúbrica de evaluación
- Certificación de competencias

---

**[FIN DE SECCIÓN 1]**

**Siguiente:** Sección 2 - Caso Práctico 1: Módulo de Reportes (Completo)

---

<a name="2-caso-reportes"></a>

## 2. CASO PRÁCTICO 1: MÓDULO DE REPORTES

### 2.1 Enunciado

**Conversación con Product Owner:**

> "Necesitamos que los usuarios puedan consultar reportes trimestrales de llamadas.
> El problema es que algunos analistas están ejecutando consultas enormes que
> bloquean el servidor Analytics. Queremos que consultas grandes requieran
> aprobación del supervisor antes de ejecutarse. Digamos, más de 10,000 registros."

**Tu tarea:**

Aplicar el flujo completo: Identificar BR → Transformar a UC → Derivar FR → Implementar → Validar

### 2.2 FASE 1: Identificación de BR

**Análisis de la conversación:**

Identif icamos **2 Business Rules implícitas:**

**BR-IACT-028: Aprobación de Consultas Grandes**
- **Tipo:** Restricción
- **Enunciado:** "Consultas que retornan más de 10,000 registros requieren aprobación del supervisor"
- **Observable:** Sí (usuario ve modal de aprobación pendiente)
- **¿Genera UC?** Sí (es una Restricción que afecta flujo principal)

**BR-IACT-053: Cálculo de Promedio de Duración**
- **Tipo:** Cálculo
- **Enunciado:** "Promedio de duración = SUM(duracion) / COUNT(*) donde duracion > 0"
- **Observable:** Sí (usuario ve resultado en reporte)
- **¿Genera UC?** No (se integra en paso de UC existente)

### 2.3 FASE 2: Documentar BR

**Archivo:** BR_IACT_028_Aprobacion_Consultas_1_0_0.rst

```rst
.. meta::
   :Proyecto: IACT
   :Codigo: BR-IACT-028
   :Titulo: Aprobación de Consultas Grandes
   :Version: 1.0.0
   :Tipo: Restriccion
   :Genera_UC: UC-IACT-RPT-01

BR-IACT-028: Aprobación de Consultas Grandes
=============================================

Enunciado
---------

Las consultas de reportes que retornen más de 10,000 registros deben ser
aprobadas por el supervisor del área antes de ejecutarse.

Derivado de
-----------

- BRQ-005: Prevenir sobrecarga del servidor Analytics
- Stakeholder: CTO (reunión 2025-11-15)

Criterios de Aceptación
-----------------------

CA-1: Sistema calcula count antes de ejecutar query
CA-2: Si count > 10,000, sistema solicita aprobación
CA-3: Supervisor recibe notificación en buzón interno
CA-4: Usuario ve mensaje: "Su consulta requiere aprobación"
CA-5: Consulta solo se ejecuta si aprobada

Genera UC
---------

- UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst (flujo principal + FA-2)
- UC_IACT_RPT_09_Aprobar_Rechazar_Consulta_4_0_0.rst (UC completo)

Trazabilidad Forward
--------------------

BR-IACT-028
  → UC-IACT-RPT-01 (paso 5)
    → FR-RPT-01-07: Calcular count
      → reports_1_0_0/services.py::execute_report_query
        → tests/test_reports.py::test_large_query_approval
```

### 2.4 FASE 3: Transformar a UC

**Aplicamos Patrón de Restricción (de PARTE_2A):**

Restricción → Precondición + Flujo Alterno en UC

**Archivo:** UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst

```rst
UC-IACT-RPT-01: Consultar Reporte Trimestral Consolidado
=========================================================

Actor Principal
---------------

Analista de Operaciones

Precondiciones
--------------

PC-1: Usuario autenticado en el sistema
PC-2: Usuario tiene permiso RPT-001 asignado
PC-3: Usuario pertenece a segmento OP o MG

Trigger
-------

Usuario hace click en "Reportes > Trimestral Consolidado"

Flujo Normal
------------

1. Sistema muestra formulario de consulta
2. Usuario selecciona trimestre (Q1, Q2, Q3, Q4)
3. Usuario selecciona año (2024, 2025)
4. Usuario hace click en "Generar Reporte"
5. Sistema calcula count de registros (FR-RPT-01-07) [BR-IACT-028]
6. Sistema valida que count ≤ 10,000 [BR-IACT-028]
7. Sistema ejecuta consulta SQL (FR-RPT-01-08)
8. Sistema calcula métricas agregadas (FR-RPT-01-09)
9. Sistema formatea resultados en tabla HTML
10. Sistema muestra reporte con opciones de exportación
11. Caso de uso termina exitosamente

Flujo Alterno FA-1: Sin datos
------------------------------

En paso 7, si query retorna 0 registros:
  7a. Sistema muestra mensaje: "No hay datos para el periodo seleccionado"
  7b. Sistema vuelve a paso 1

Flujo Alterno FA-2: Consulta Requiere Aprobación [BR-IACT-028]
---------------------------------------------------------------

En paso 6, si count > 10,000:
  6a. Sistema crea registro en tabla approvals (FR-RPT-01-10)
  6b. Sistema identifica supervisor del usuario
  6c. Sistema crea notificación para supervisor
  6d. Sistema muestra modal: "Su consulta requiere aprobación. Le notificaremos cuando esté lista."
  6e. Usuario hace click en "OK"
  6f. Sistema redirige a página principal
  6g. Caso de uso termina (continúa en UC-IACT-RPT-09)

Postcondiciones
---------------

PC-1: Reporte generado y mostrado al usuario
PC-2: Consulta registrada en audit_log con resultado SUCCESS
PC-3: Si consulta fue aprobada, approval.status = APPROVED

Implementa BR
-------------

- BR-IACT-028: Paso 5-6 + FA-2
- BR-IACT-053: Paso 8 (cálculo de promedio)
```

### 2.5 FASE 4: Derivar FR

Del UC, identificamos pasos que requieren FR:

**FR-RPT-01-07: Calcular Count de Registros**

```rst
FR-RPT-01-07: Calcular Count de Registros
==========================================

Derivado de
-----------

UC-IACT-RPT-01: Consultar Reporte (paso 5)

Implementa
----------

BR-IACT-028: Aprobación consultas >10,000

Descripción
-----------

El sistema debe calcular el número de registros que retornaría la consulta
ANTES de ejecutarla, para determinar si requiere aprobación.

Query SQL
---------

.. code-block:: sql

   SELECT COUNT(*) as record_count
   FROM ivr_calls c
   INNER JOIN ivr_sessions s ON c.session_id = s.session_id
   WHERE c.call_date >= :start_date
     AND c.call_date < :end_date
     AND s.user_segment IN (:allowed_segments);

Parámetros
----------

- start_date: Inicio del trimestre (DATE)
- end_date: Fin del trimestre (DATE)
- allowed_segments: ['OP', 'MG']

Timeout
-------

5 segundos

Manejo de Errores
-----------------

- Si timeout: Retornar error "Query timeout, intente con rango menor"
- Si DB error: Retornar error "Error de base de datos, contacte soporte"

Logs
----

Log level INFO con:
- user_id
- query_params
- record_count
- execution_time_ms

Tests
-----

- test_count_small_range: 1,000 registros
- test_count_large_range: 50,000 registros
- test_count_timeout: Simular timeout

Implementación
--------------

File: reports_1_0_0/services.py
Function: calculate_query_count(query_params)
```

### 2.6 FASE 5: Implementar Código

**Archivo:** reports_1_0_0/services.py

```python
"""
Servicios de reportes.

Implements: UC_IACT_RPT_01_Consultar_Reporte_4_0_0.rst
"""

from django.db import connection
from django.utils import timezone
import logging

logger = logging.getLogger(__name__)

def calculate_query_count(query_params):
    """
    Calcula count de registros que retornaría consulta.
    
    Implements:
        - FR-RPT-01-07: Calcular Count de Registros
    
    Derived from:
        - UC-IACT-RPT-01: Consultar Reporte (paso 5)
        - BR-IACT-028: Aprobación si >10,000 registros
    
    Args:
        query_params (dict): {
            'start_date': datetime.date,
            'end_date': datetime.date,
            'allowed_segments': list[str]
        }
    
    Returns:
        int: Número de registros
    
    Raises:
        QueryTimeoutError: Si timeout de 5 seg
        DatabaseError: Si error de DB
    
    Tests:
        - tests/test_reports.py::test_calculate_count_small
        - tests/test_reports.py::test_calculate_count_large
        - tests/test_reports.py::test_calculate_count_timeout
    """
    start_time = timezone.now()
    
    query = """
        SELECT COUNT(*) as record_count
        FROM ivr_calls c
        INNER JOIN ivr_sessions s ON c.session_id = s.session_id
        WHERE c.call_date >= %s
          AND c.call_date < %s
          AND s.user_segment IN %s
    """
    
    try:
        with connection.cursor() as cursor:
            cursor.execute(query, [
                query_params['start_date'],
                query_params['end_date'],
                tuple(query_params['allowed_segments'])
            ])
            
            result = cursor.fetchone()
            record_count = result[0]
        
        # Log INFO
        execution_time = (timezone.now() - start_time).total_seconds() * 1000
        logger.info(
            f"Count calculated: {record_count} records, "
            f"time: {execution_time:.2f}ms",
            extra={
                'user_id': query_params.get('user_id'),
                'record_count': record_count,
                'execution_time_ms': execution_time
            }
        )
        
        return record_count
        
    except Exception as e:
        logger.error(f"Error calculating count: {e}")
        raise
```

### 2.7 FASE 6: Escribir Tests

**Archivo:** tests/test_reports.py

```python
"""
Tests para servicios de reportes.

Validates:
    - BR-IACT-028: Aprobación consultas >10K
    - FR-RPT-01-07: Calcular count
"""

import pytest
from datetime import date
from reports_1_0_0.services import calculate_query_count

class TestCalculateCount:
    """
    Tests para calculate_query_count().
    
    Validates: BR-IACT-028, FR-RPT-01-07
    """
    
    def test_calculate_count_small_range(self, db):
        """
        Valida count con rango pequeño (< 10K).
        
        Validates:
            - BR-IACT-028: Umbral de 10,000 registros
            - FR-RPT-01-07: Query correcta
        
        Covers:
            - UC-IACT-RPT-01 paso 5 (flujo normal)
            - UC-IACT-RPT-01 paso 6 (count ≤ 10K)
        """
        # Arrange
        params = {
            'start_date': date(2025, 1, 1),
            'end_date': date(2025, 3, 31),  # Q1 2025
            'allowed_segments': ['OP'],
            'user_id': 'user_123'
        }
        
        # Act
        count = calculate_query_count(params)
        
        # Assert
        assert count < 10000
        assert isinstance(count, int)
    
    def test_calculate_count_large_range(self, db):
        """
        Valida count con rango grande (> 10K).
        
        Validates:
            - BR-IACT-028: Requiere aprobación si >10K
        
        Covers:
            - UC-IACT-RPT-01 FA-2 (count > 10K)
        """
        # Arrange
        params = {
            'start_date': date(2024, 1, 1),
            'end_date': date(2025, 12, 31),  # Todo el año
            'allowed_segments': ['OP', 'MG'],
            'user_id': 'user_456'
        }
        
        # Act
        count = calculate_query_count(params)
        
        # Assert
        assert count > 10000  # Debe disparar BR-IACT-028
```

### 2.8 FASE 7: Trazabilidad

**Actualizar Matriz RTM:**

| ID BR | Tipo | UC | FR | Código | Tests | Cobertura |
|-------|------|----|----|--------|-------|-----------|
| BR-IACT-028 | Restricción | UC-RPT-01 | FR-RPT-01-07 | reports.py:45 | test_reports.py:12 | 100% |

**Validación de Trazabilidad:**

```
BR-IACT-028 (Aprobación >10K)
  ↓ genera
UC-IACT-RPT-01 (paso 5-6 + FA-2)
  ↓ deriva
FR-RPT-01-07 (Calcular count)
  ↓ implementa
reports_1_0_0/services.py::calculate_query_count
  ↓ valida
tests/test_reports.py::test_calculate_count_large

✓ Trazabilidad Forward completa
✓ Trazabilidad Backward completa
✓ Cobertura: 100%
```

---

<a name="3-caso-auth"></a>

## 3. CASO PRÁCTICO 2: MÓDULO DE AUTENTICACIÓN

### 3.1 Enunciado

**Product Owner:**

> "Los usuarios se quejan de que la sesión expira sin avisar. Queremos notificar
> al usuario 3 minutos antes de que expire para que pueda hacer click y mantenerla
> activa. La sesión expira a los 15 minutos de inactividad."

### 3.2 Análisis: Identificar BR

**BR-IACT-031: Notificar Sesión por Expirar (DESENCADENADOR)**
- Usuario RECIBE notificación a los 12 minutos
- Observable: SÍ
- Genera UC completo

**BR-IACT-046: Marcar Sesión Expirada (INFERENCIA)**
- Solo campo BD cambia a los 15 minutos
- Observable: NO (usuario NO ve este cambio)
- NO genera UC, solo FR

### 3.3 Solución Aplicando PARTE 1-5

**BR-IACT-031 → UC-IACT-AUTH-07** (11 pasos completos)

**BR-IACT-046 → FR-AUTH-08-02** (UPDATE silencioso)

**Diferencia crítica:**
- BR-031 es Desencadenador → UC completo con actor Usuario
- BR-046 es Inferencia → Solo FR directo sin UC

(Ver PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md sección 3.3 para análisis detallado)

---

<a name="4-caso-acceso"></a>

## 4. CASO PRÁCTICO 3: CONTROL DE ACCESO

### 4.1 Enunciado

**Stakeholder:**

> "Solo usuarios con nivel de seguridad 3 o superior pueden asignar funciones
> críticas (aquellas con security_level >= 3). Esto es por cumplimiento regulatorio."

### 4.2 Identificar BR

**BR-IACT-087: Nivel Seguridad para Funciones Críticas**
- Tipo: Restricción
- Enunciado: "Usuario debe tener nivel_seguridad ≥ 3 para asignar funciones con security_level ≥ 3"
- Genera: Precondición en UC-IACT-ACC-01

### 4.3 Transformar a UC

**UC-IACT-ACC-01: Asignar Función a Usuario**

```
Precondición:
  - Usuario tiene nivel_seguridad ≥ 3 [BR-IACT-087]
  - Función a asignar tiene security_level ≥ 3 [BR-IACT-087]

Flujo Normal:
  1-11 pasos...
  
Flujo Alterno FA-3: Nivel Insuficiente [BR-IACT-087]
  En paso 4, si user.nivel_seguridad < function.security_level:
    4a. Sistema muestra error: "Nivel de seguridad insuficiente"
    4b. Sistema audita intento con resultado DENIED
    4c. Caso de uso termina sin éxito
```

---

<a name="5-caso-integracion"></a>

## 5. CASO PRÁCTICO 4: INTEGRACIÓN MULTI-MÓDULO

### 5.1 Enunciado

**Caso Complejo:**

Usuario solicita reporte que:
1. Requiere autenticación (AUTH)
2. Validación de permisos (ACC)
3. Aprobación si >10K registros (RPT)
4. Auditoría completa (ADMIN)

### 5.2 Integración de BR

```
BR-IACT-028 (RPT) + BR-IACT-087 (ACC) + BR-IACT-046 (AUTH)
  ↓
UC-IACT-RPT-01 integra las 3 BR
  ↓
Precondición: Sesión válida [BR-046]
Precondición: Permiso RPT-001 [BR-087]
Paso 5-6 + FA-2: Aprobación [BR-028]
```

### 5.3 Trazabilidad Horizontal

```
UC-IACT-RPT-01 (Reportes)
  ← depende de
UC-IACT-AUTH-01 (Login exitoso)
  ← depende de
UC-IACT-ACC-01 (Permisos asignados)
```

---

**[FIN DE SECCIONES 2-5]**

**Siguiente:** Secciones 6-9 (Ejercicios, Proyecto Final, Validación, Certificación)

---

<a name="6-ejercicios"></a>

## 6. EJERCICIOS GUIADOS

### 6.1 Ejercicio 1: Identificar BR en Conversación

**Enunciado:**

Stakeholder: "Queremos que el dashboard muestre una alerta roja cuando el porcentaje
de llamadas abandonadas supere el 20% en la última hora. Y también necesitamos calcular
la tasa de abandono como (abandonadas / total) * 100."

**Tu tarea:**

1. Identificar cuántas BR hay
2. Clasificar cada BR por tipo
3. Determinar cuáles generan UC

**Solución:**

**BR-IACT-104:** Alerta Llamadas Abandonadas >20%
- Tipo: Desencadenador
- Observable: SÍ (usuario VE alerta roja)
- Genera UC completo

**BR-IACT-105:** Cálculo Tasa de Abandono
- Tipo: Cálculo
- Observable: SÍ (usuario VE resultado)
- NO genera UC (se integra en paso de UC existente)

### 6.2 Ejercicio 2: Aplicar Patrón de Transformación

**Dado:** BR-IACT-104 (Desencadenador)

**Tu tarea:** Construir UC completo

**Solución:**

UC-IACT-DASH-05: Alertar Llamadas Abandonadas Altas

```
Actor: Sistema (Scheduler)
Trigger: Cron job cada 5 minutos

Flujo Normal:
  1. Sistema consulta llamadas última hora
  2. Sistema calcula tasa abandono [BR-105]
  3. Sistema valida si tasa > 20% [BR-104]
  4. Sistema crea alerta con prioridad HIGH
  5. Sistema actualiza dashboard (widget parpadea rojo)
  6. Usuario VE alerta en tiempo real
  ...
```

### 6.3 Ejercicio 3: Derivar FR desde UC

**Dado:** UC-IACT-DASH-05 paso 2

**Tu tarea:** Derivar FR completo

**Solución:**

FR-DASH-05-02: Calcular Tasa de Abandono

```rst
Query SQL:
  SELECT 
    COUNT(CASE WHEN status='ABANDONED' THEN 1 END) as abandoned,
    COUNT(*) as total,
    (COUNT(CASE WHEN status='ABANDONED' THEN 1 END)::float / 
     NULLIF(COUNT(*), 0)) * 100 as rate
  FROM ivr_calls
  WHERE call_timestamp >= NOW() - INTERVAL '1 hour';

Timeout: 3 segundos
Logs: INFO con rate calculada
Tests: 3 tests (0%, 15%, 25%)
```

### 6.4 Ejercicio 4: Establecer Trazabilidad

**Dado:** Código implementado

```python
def calculate_abandon_rate():
    # ...código...
```

**Tu tarea:** Agregar comentarios de trazabilidad

**Solución:**

```python
def calculate_abandon_rate():
    """
    Calcula tasa de abandono última hora.
    
    Implements:
        - FR-DASH-05-02: Calcular Tasa de Abandono
    
    Derived from:
        - UC-IACT-DASH-05: Alertar Abandonos (paso 2)
        - BR-IACT-105: Cálculo (abandonadas/total)*100
    
    Tests:
        - tests/test_dashboard.py::test_abandon_rate_zero
        - tests/test_dashboard.py::test_abandon_rate_high
    """
    # ...código...
```

### 6.5 Ejercicio 5: Auditoría de Trazabilidad

**Dado:** Matriz RTM parcial

**Tu tarea:** Identificar problemas de cobertura

**Matriz:**

| BR | UC | FR | Código | Tests |
|----|----|----|--------|-------|
| BR-104 | UC-DASH-05 | FR-DASH-05-02 | dashboard.py:123 | - |

**Problemas identificados:**

1. [ERROR] BR-104 sin tests → Cobertura incompleta
2. [ACCIÓN] Escribir test_alertar_abandon_rate_high()

---

<a name="7-proyecto-final"></a>

## 7. PROYECTO FINAL: SISTEMA COMPLETO

### 7.1 Especificación del Proyecto

**Módulo a Implementar:** Sistema de Gestión de Segmentos de Datos

**Requerimiento del Negocio:**

> "Necesitamos permitir que administradores transfieran segmentos de datos entre
> usuarios, pero solo si ambos usuarios tienen el mismo nivel de seguridad, y
> solo si el segmento no contiene datos críticos (flagged como sensitive=TRUE).
> La transferencia debe registrarse en auditoría con timestamp y razón."

### 7.2 Tareas del Proyecto Final

**Tarea 1: Identificar BR (2 horas)**
- Extraer al menos 4 BR de la especificación
- Clasificar por tipo
- Documentar con template TPL_BR_Decision_Tipo_1_0_0.rst

**Tarea 2: Construir UC (4 horas)**
- UC-IACT-ADMIN-12: Transferir Segmento de Datos
- Estructura completa 11 pasos
- Integrar las 4 BR identificadas
- Al menos 2 flujos alternos

**Tarea 3: Derivar FR (3 horas)**
- Al menos 6 FR derivados del UC
- Especificar queries SQL
- Definir validaciones
- Logs y timeouts

**Tarea 4: Implementar (4 horas)**
- Código Python en admin_1_0_0/services.py
- Comentarios de trazabilidad
- Manejo de errores

**Tarea 5: Tests (3 horas)**
- Al menos 10 tests
- Cubrir flujo normal y alternos
- Validar BR originales

**Tarea 6: Trazabilidad (2 horas)**
- Actualizar matriz RTM
- Validar cobertura >90%
- Generar reporte de trazabilidad

### 7.3 Criterios de Evaluación

| Criterio | Peso | Puntaje |
|----------|------|---------|
| BR correctamente identificadas | 15% | /15 |
| UC bien estructurado | 25% | /25 |
| FR completos con SQL | 20% | /20 |
| Código implementado correctamente | 20% | /20 |
| Tests con cobertura >90% | 10% | /10 |
| Trazabilidad completa | 10% | /10 |
| **TOTAL** | **100%** | **/100** |

**Aprobatorio:** ≥80 puntos

### 7.4 Entregables

1. **Documentos BR (4 archivos RST)**
2. **Documento UC (1 archivo RST)**
3. **Documentos FR (6 archivos RST)**
4. **Código Python (1 archivo .py)**
5. **Tests (1 archivo .py)**
6. **Matriz RTM actualizada (1 archivo CSV)**
7. **Reporte de Trazabilidad (1 archivo MD)**

---

<a name="8-validacion"></a>

## 8. VALIDACIÓN Y AUDITORÍA

### 8.1 Checklist de Completitud PARTE 6

**Casos Prácticos:**

- [ ] Caso 1: Módulo de Reportes (completado)
- [ ] Caso 2: Módulo de Autenticación (completado)
- [ ] Caso 3: Módulo de Control de Acceso (completado)
- [ ] Caso 4: Integración Multi-Módulo (completado)

**Ejercicios:**

- [ ] Ejercicio 1: Identificar BR (completado)
- [ ] Ejercicio 2: Aplicar Patrón (completado)
- [ ] Ejercicio 3: Derivar FR (completado)
- [ ] Ejercicio 4: Trazabilidad (completado)
- [ ] Ejercicio 5: Auditoría (completado)

**Proyecto Final:**

- [ ] Tareas 1-6 completadas
- [ ] Evaluación ≥80 puntos
- [ ] Entregables presentados

### 8.2 Rúbrica de Evaluación

**Nivel 1: Principiante (0-59 puntos)**
- Identifica algunas BR pero con errores de clasificación
- UC incompletos o con estructura incorrecta
- FR sin especificaciones técnicas
- Código sin trazabilidad

**Nivel 2: Competente (60-79 puntos)**
- Identifica la mayoría de BR correctamente
- UC bien estructurados pero con detalles faltantes
- FR completos pero con queries simples
- Código funcional con trazabilidad básica

**Nivel 3: Proficiente (80-89 puntos)**
- Identifica todas las BR correctamente
- UC completos con flujos alternos
- FR detallados con SQL optimizado
- Código robusto con trazabilidad completa
- Tests con >80% cobertura

**Nivel 4: Experto (90-100 puntos)**
- Identifica BR implícitas que otros no ven
- UC profesionales listos para producción
- FR con especificaciones exhaustivas
- Código optimizado con manejo de errores completo
- Tests con >95% cobertura
- Trazabilidad bidireccional perfecta

### 8.3 Validación de Competencias

**Competencias Validadas:**

1. ✓ Identificación de BR desde conversaciones
2. ✓ Clasificación correcta por tipo
3. ✓ Aplicación de patrones de transformación
4. ✓ Construcción de UC estándar
5. ✓ Derivación de FR técnicos
6. ✓ Implementación con trazabilidad
7. ✓ Testing de BR originales
8. ✓ Gestión de trazabilidad completa

---

<a name="9-resumen"></a>

## 9. RESUMEN Y CERTIFICACIÓN

### 9.1 Logros de PARTE 6

Al completar PARTE 6, has:

**Aplicado el Flujo Completo:**
- [OK] Identificado 15+ BR en 4 casos prácticos
- [OK] Construido 10+ UC completos
- [OK] Derivado 30+ FR con SQL
- [OK] Implementado 20+ funciones Python
- [OK] Escrito 40+ tests
- [OK] Establecido trazabilidad bidireccional

**Desarrollado Competencias:**
- [OK] Business Analysis profesional
- [OK] Requirements Engineering
- [OK] Trazabilidad y gestión
- [OK] Implementación técnica
- [OK] Testing y validación

### 9.2 Siguiente Paso: Material Avanzado

Has completado el **Material Pedagógico Fundamental** (PARTES 0-6).

**Próximos pasos opcionales:**

1. **Templates Profesionales** - 12 templates RST reutilizables
2. **Ejemplos Reales** - BR, UC, FR del proyecto IACT
3. **Índices Maestros** - Navegación completa de documentación
4. **Casos Complejos** - Análisis de casos de borde
5. **Automatización** - Scripts de validación y CI/CD

### 9.3 Certificación de Competencias

**CERTIFICADO DE COMPLETITUD**

```
┌────────────────────────────────────────────────────────┐
│                                                        │
│       CERTIFICADO DE COMPETENCIAS IACT                 │
│                                                        │
│  Este documento certifica que:                         │
│                                                        │
│  [NOMBRE DEL ESTUDIANTE]                               │
│                                                        │
│  Ha completado exitosamente el material pedagógico     │
│  IACT - Integrated Analysis and Contextual Traceability│
│                                                        │
│  Comprendiendo:                                        │
│    • PARTE 0: Contexto y Fundamentos                   │
│    • PARTE 1: Identificación de BR                     │
│    • PARTE 2: Transformación BR → UC                   │
│    • PARTE 3: Construcción de UC                       │
│    • PARTE 4: Derivación de FR                         │
│    • PARTE 5: Trazabilidad y Gestión                   │
│    • PARTE 6: Casos Prácticos Completos                │
│                                                        │
│  Nivel alcanzado: [PROFICIENTE / EXPERTO]              │
│  Puntaje final: [___] / 100                            │
│                                                        │
│  Fecha: _______________                                │
│  Firma: _______________                                │
│                                                        │
└────────────────────────────────────────────────────────┘
```

### 9.4 Reconocimiento

**Competencias Certificadas:**

- ✓ **Business Analyst** - Nivel Avanzado
- ✓ **Requirements Engineer** - Nivel Proficiente
- ✓ **Traceability Specialist** - Nivel Experto
- ✓ **Technical Documentation** - Nivel Proficiente

**Proyectos donde puedes aplicar estas habilidades:**

1. Análisis de requisitos en proyectos enterprise
2. Liderazgo de proceso de elicitación
3. Auditoría de trazabilidad regulatoria
4. Mentoría de analistas junior
5. Diseño de sistemas complejos

---

## APÉNDICE A: RECURSOS ADICIONALES

**Documentos de Referencia:**

- PARTE_0_Contexto_Fundamentos_IACT_1_0_0.md
- PARTE_1_Identificar_Reglas_Negocio_IACT_1_0_0.md
- PARTE_2A_Fundamentos_Transformacion_IACT_1_0_0.md
- PARTE_2B_Construccion_Detallada_IACT_1_0_0.md
- PARTE_2C_Casos_Especiales_Validacion_IACT_1_0_0.md
- PARTE_3A_Introduccion_CRUD_IACT_1_0_0.md
- PARTE_3B_Tecnica_Larman_IACT_1_0_0.md
- PARTE_3C_UI_Stakeholders_IACT_1_0_0.md
- PARTE_3D_Consolidacion_Resumen_IACT_1_0_0.md
- PARTE_4_Requisitos_Funcionales_IACT_1_0_0.md
- PARTE_5_Trazabilidad_Gestion_IACT_1_0_0.md

**Templates:**

- TPL_BR_Decision_Tipo_1_0_0.rst
- TPL_UC_Construccion_7_Pasos_1_0_0.rst
- TPL_FR_Documentacion_10_Componentes_1_0_0.rst
- TPL_TRZ_Matriz_RTM_1_0_0.rst

---

## APÉNDICE B: BIBLIOGRAFÍA

**Referencias Académicas:**

1. Wiegers & Beatty (2013). Software Requirements, 3rd Edition
2. Larman (2004). Applying UML and Patterns, 3rd Edition
3. Cockburn (2001). Writing Effective Use Cases
4. IIBA (2015). BABOK v3 - Business Analysis Body of Knowledge

**Referencias Técnicas:**

5. Django Documentation (2024)
6. PostgreSQL Documentation (2024)
7. Pytest Documentation (2024)
8. Python PEP 8 Style Guide

---

**FIN DE PARTE 6**

**Versión:** 1.0.0  
**Fecha:** 2026-01-09  
**Estado:** COMPLETO

**Has completado el Material Pedagógico IACT.**

**¡Felicitaciones!**

