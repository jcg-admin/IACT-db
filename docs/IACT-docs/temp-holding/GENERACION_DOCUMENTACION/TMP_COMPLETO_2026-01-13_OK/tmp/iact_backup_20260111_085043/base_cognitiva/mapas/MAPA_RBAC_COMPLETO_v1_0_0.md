# MAPA_RBAC_COMPLETO_v1_0_0

**Documento Puente: Navegación Completa de Documentación RBAC IACT**

---

**Metadata del Documento:**
- **Versión:** 1.0.0
- **Fecha:** 2026-01-11
- **Tipo:** Guía de Navegación / Documento Puente
- **Estado:** VIGENTE
- **Propósito:** Conectar documentación conceptual (MODELO_RBAC) con implementación (CNST_005)
- **Audiencia:** Desarrolladores, Arquitectos, Auditores, Project Managers

---

## Tabla de Contenido

1. [Resumen Ejecutivo](#1-resumen-ejecutivo)
2. [Arquitectura Documental RBAC](#2-arquitectura-documental-rbac)
3. [Relación MODELO ↔ CNST](#3-relación-modelo--cnst)
4. [Guías de Navegación por Perfil](#4-guías-de-navegación-por-perfil)
5. [Tabla de Correspondencias](#5-tabla-de-correspondencias)
6. [Casos de Uso de Navegación](#6-casos-de-uso-de-navegación)
7. [Referencias Cruzadas](#7-referencias-cruzadas)
8. [Glosario y Convenciones](#8-glosario-y-convenciones)

---

## 1. RESUMEN EJECUTIVO

### 1.1 ¿Qué es este documento?

Este documento es la **"Piedra Rosetta"** de la documentación RBAC del sistema IACT. 

**Conecta:**
- **MODELO_RBAC_IACT_v5_1_1.md** (¿QUÉ queremos?)
- **CNST_005_RBAC_Flat_SoD_Permisos_v1_0_0.rst** (¿CÓMO lo construimos?)

**Propósito:**
- Clarificar la relación entre documentos
- Proporcionar guías de navegación
- Evitar confusión sobre "¿cuál documento leer?"
- Facilitar onboarding de nuevos desarrolladores

### 1.2 Lectura Rápida (1 minuto)

```
┌─────────────────────────────────────────────────────────┐
│         DOCUMENTACIÓN RBAC - LECTURA RÁPIDA              │
└─────────────────────────────────────────────────────────┘

¿Eres...?                          Lee esto primero:
════════════════════════════════════════════════════════════

🏗️  Arquitecto / PM                → MODELO_RBAC v5.1.1
   "Quiero entender el diseño"      (Conceptual, filosofía)

💻 Desarrollador                   → CNST_005 v1.0.0
   "Quiero implementar"              (Código, SQL, Django)

🔍 Auditor / Compliance            → AMBOS
   "Quiero validar"                  MODELO (diseño) + CNST (impl)

📚 Estudiante / Onboarding         → ESTE DOCUMENTO
   "¿Por dónde empiezo?"            (Guía de navegación)
```

### 1.3 Relación Fundamental

```
MODELO_RBAC v5.1.1           CNST_005 v1.0.0
(¿QUÉ?)                      (¿CÓMO?)
═══════════════════════════════════════════════════

Define modelo conceptual  →  Implementa el modelo
44 funciones (diseño)     →  44 funciones (código)
10 agrupadores (concepto) →  10 agrupadores (SQL)
3 SoD (reglas)            →  3 SoD (validaciones)
5 segmentos (modelo)      →  5 segmentos (Django)

┌──────────────┐              ┌──────────────┐
│   MODELO     │──implements──│    CNST      │
│   (Design)   │              │   (Code)     │
└──────────────┘              └──────────────┘
```

---

## 2. ARQUITECTURA DOCUMENTAL RBAC

### 2.1 Capas de Documentación

La documentación RBAC está organizada en **3 capas**:

```
════════════════════════════════════════════════════════════
CAPA 1: MODELO CONCEPTUAL (Estable, pocas actualizaciones)
════════════════════════════════════════════════════════════

📄 MODELO_RBAC_IACT_v5_1_1.md (1,655 líneas)
   ├─ Filosofía RBAC Flat
   ├─ Principio: "Nombres describen QUÉ hace la función"
   ├─ Catálogo de 44 funciones atómicas
   ├─ Catálogo de 10 agrupadores
   ├─ 3 restricciones SoD (Separation of Duties)
   ├─ 5 segmentos de datos
   └─ Decisiones de diseño y justificaciones

Propósito: Definir QUÉ es el sistema RBAC
Audiencia: Arquitectos, PMs, stakeholders técnicos
Estabilidad: ALTA (cambia solo con rediseños)

────────────────────────────────────────────────────────────
CAPA 2: IMPLEMENTACIÓN DOCUMENTADA (Viva, se actualiza)
────────────────────────────────────────────────────────────

📄 CNST_005_RBAC_Flat_SoD_Permisos_v1_0_0.rst (2,258 líneas)
   ├─ Schema SQL completo
   ├─ Modelos Django (funciones, agrupadores, usuarios)
   ├─ Decorators (@require_function)
   ├─ Middleware (SEC_RULES)
   ├─ Manager class (RBACManager)
   ├─ Tests unitarios
   ├─ Script de migración v4.0 → v5.1.1
   └─ Ejemplos de código funcional

📄 CNST_001 a CNST_008 (7 documentos adicionales)
   └─ Restricciones técnicas complementarias

Propósito: Documentar CÓMO se implementa el sistema
Audiencia: Desarrolladores, testers, DevOps
Estabilidad: MEDIA (se actualiza con cambios de código)

────────────────────────────────────────────────────────────
CAPA 3: NAVEGACIÓN Y REFERENCIAS (A crear)
────────────────────────────────────────────────────────────

📄 MAPA_RBAC_COMPLETO_v1_0_0.md (ESTE DOCUMENTO)
   └─ Conecta MODELO con CNST
   └─ Guías de navegación

📄 INDICE_RBAC_v1_0_0.rst (FASE 14A - pendiente)
   └─ Índice completo de documentación RBAC

Propósito: Facilitar navegación y comprensión
Audiencia: TODOS
Estabilidad: MEDIA (se actualiza con nueva documentación)
════════════════════════════════════════════════════════════
```

### 2.2 Flujo de Lectura Recomendado

```
Nuevo en el proyecto:
═════════════════════
1. Lee ESTE DOCUMENTO (MAPA_RBAC_COMPLETO)
2. Lee MODELO_RBAC v5.1.1 (entender el diseño)
3. Lee CNST_005 v1.0.0 (ver implementación)

Desarrollador experimentado:
════════════════════════════
→ CNST_005 directamente
→ Consulta MODELO solo si necesitas contexto

Auditor / Compliance:
═════════════════════
→ MODELO (validar diseño cumple requerimientos)
→ CNST_005 (validar implementación cumple diseño)
→ Comparar ambos para encontrar desviaciones
```

---

## 3. RELACIÓN MODELO ↔ CNST

### 3.1 Mapeo Conceptual → Implementación

| Concepto en MODELO_RBAC | Implementación en CNST_005 | Ubicación CNST_005 |
|-------------------------|----------------------------|-------------------|
| **Función Atómica** | Tabla `funciones` SQL | Sección 6.1 |
| **Agrupador** | Tabla `agrupadores` + `agrupador_funciones` | Sección 6.2 |
| **Asignación Usuario-Función** | Tabla `usuarios_funciones` | Sección 6.3 |
| **SoD (Separation of Duties)** | Tabla `restricciones_sod` + validaciones | Sección 7 |
| **Segmento de Datos** | Tabla `segmentos_datos` + middleware | Sección 8 |
| **Permiso Temporal** | Campos `fecha_expiracion` + `justificacion` | Sección 9 |
| **Decorator @require_function** | Código Python completo | Sección 10 |
| **RBACManager** | Clase Python con métodos | Sección 11 |

### 3.2 Las 44 Funciones: MODELO vs CNST

**En MODELO_RBAC v5.1.1:**
- Define QUÉ hace cada función
- Ejemplo: `AUT-001: gestiona_sesiones` → "Permite ver y cerrar sesiones activas"

**En CNST_005 v1.0.0:**
- Implementa CÓMO verificar esa función
- Ejemplo SQL:
  ```sql
  INSERT INTO funciones VALUES 
  ('gestiona_sesiones', 'MOD_Auth', 'auth:sesiones', ...);
  ```
- Ejemplo Python:
  ```python
  @require_function('gestiona_sesiones')
  def ver_sesiones_activas(request):
      ...
  ```

**Correspondencia 1:1:**
```
MODELO_RBAC              CNST_005
═══════════════════════════════════════════════════

AUT-001                  Row en tabla funciones
MOD_Auth                 + Decorator en código
gestiona_sesiones        + Test unitario
"Ve y cierra sesiones"   + Ejemplo de uso

│                        │
└──────── 100% ─────────┘
      alineado
```

### 3.3 Ejemplo Completo: Función AUT-001

#### En MODELO_RBAC_IACT_v5_1_1.md (Conceptual):

```markdown
### AUT-001: gestiona_sesiones

**Descripción:**
Permite gestionar sesiones activas del sistema.

**Capacidades:**
- Ver sesiones activas de TODOS los usuarios
- Cerrar sesión de usuario específico
- Ver detalles de cada sesión (IP, timestamp, etc.)

**Asignación típica:**
- Administrador de sistemas
- Equipo de soporte nivel 2

**Regla de negocio:**
Solo usuarios con esta función pueden cerrar sesiones ajenas.
```

#### En CNST_005_RBAC_Flat_SoD_Permisos_v1_0_0.rst (Implementación):

```rst
3.1 AUT-001: gestiona_sesiones

SQL Schema:
-----------
INSERT INTO funciones (
    nombre, modulo, capacidad, descripcion
) VALUES (
    'gestiona_sesiones',
    'MOD_Auth',
    'auth:sesiones',
    'Gestionar sesiones activas del sistema'
);

Código Python:
--------------
@require_function('gestiona_sesiones')
def ver_sesiones_activas(request):
    sesiones = Session.objects.filter(estado='ACTIVE')
    return render(request, 'sesiones.html', {'sesiones': sesiones})

Test:
-----
def test_gestiona_sesiones_requires_permission():
    user_without = User.objects.create(username='test')
    assert not has_function(user_without, 'gestiona_sesiones')
    # Debe lanzar PermissionDenied
```

**Ver cómo están conectados:**
- MODELO define QUÉ hace `gestiona_sesiones`
- CNST muestra CÓMO validar que usuario tiene esa función
- Perfecta correspondencia 1:1

---

## 4. GUÍAS DE NAVEGACIÓN POR PERFIL

### 4.1 Desarrollador Backend (Django/Python)

**Tu misión:** Implementar nueva funcionalidad con control RBAC

**Ruta de lectura:**

```
1. Identifica la función RBAC necesaria
   → Consulta MODELO_RBAC (sección 7: Catálogo de Funciones)
   → Ejemplo: Necesitas "exporta_csv" → Función RPT-004

2. Ve a CNST_005 para ver implementación
   → Sección 3.4 (Funciones MOD_Reports)
   → Encuentra RPT-004

3. Copia el patrón de código
   → Ejemplo en sección 12.4 de CNST_005
   → Decorator @require_function('exporta_csv')

4. Aplica a tu vista/endpoint
   @require_function('exporta_csv')
   def mi_vista_export(request):
       ...
```

**Documentos que usarás más:**
- ⭐⭐⭐ CNST_005 (código, SQL, decorators)
- ⭐⭐ MODELO_RBAC (entender la función conceptualmente)
- ⭐ CNST_001-008 (restricciones adicionales)

### 4.2 Arquitecto / Tech Lead

**Tu misión:** Diseñar nuevas funciones o modificar modelo RBAC

**Ruta de lectura:**

```
1. Estudia filosofía del modelo RBAC
   → MODELO_RBAC sección 2-3 (Filosofía y Principios)
   
2. Entiende funciones existentes
   → MODELO_RBAC sección 7 (Catálogo completo)
   
3. Diseña nueva función siguiendo convenciones
   → Nombrado: "verbo en tercera persona"
   → Ejemplo: "exporta_datos" (NO "exportar_datos")
   
4. Verifica SoD (Separation of Duties)
   → MODELO_RBAC sección 8
   → ¿Tu nueva función conflictúa con alguna existente?
   
5. Documenta en MODELO_RBAC
   → Actualiza catálogo de funciones
   → Nueva versión: v5.1.2 (si es cambio menor)
   
6. Luego actualiza CNST_005
   → Agrega SQL schema
   → Agrega ejemplo de código
   → Nueva versión CNST_005: v1.1.0
```

**Documentos que usarás más:**
- ⭐⭐⭐ MODELO_RBAC (diseño, filosofía)
- ⭐⭐ CNST_005 (validar factibilidad técnica)
- ⭐ REFERENCIA_GLOBAL_MODULOS (contexto de módulos)

### 4.3 Auditor / Compliance

**Tu misión:** Validar que implementación cumple con diseño y políticas

**Ruta de lectura:**

```
1. Lee MODELO_RBAC completo
   → Entiende QUÉ debe hacer el sistema
   → Verifica que diseño cumple con políticas corporativas
   
2. Lee CNST_005 completo
   → Verifica que implementación cumple con diseño
   → Busca desviaciones entre MODELO y CNST
   
3. Valida 1:1 correspondencia
   → Usa Tabla de Correspondencias (sección 5 de ESTE doc)
   → Todas las 44 funciones del MODELO deben estar en CNST
   
4. Verifica SoD (crítico para compliance)
   → MODELO define 3 restricciones SoD
   → CNST debe implementar validaciones técnicas
   → Prueba que sistema RECHAZA violaciones SoD
   
5. Genera reporte de auditoría
   → Desviaciones encontradas
   → Recomendaciones
```

**Documentos que usarás más:**
- ⭐⭐⭐ MODELO_RBAC (baseline de cumplimiento)
- ⭐⭐⭐ CNST_005 (validación de implementación)
- ⭐⭐ CNST_008 (auditoría inmutable)
- ⭐ ESTE DOCUMENTO (correspondencias)

### 4.4 QA / Tester

**Tu misión:** Crear casos de prueba para RBAC

**Ruta de lectura:**

```
1. Para cada función en MODELO_RBAC:
   → Identifica quién DEBE tener acceso
   → Identifica quién NO debe tener acceso
   
2. Consulta CNST_005 para tests existentes
   → Sección 13: Tests de validación
   → Copia patrones de testing
   
3. Crea casos de prueba:
   → Happy path: Usuario CON función → Acceso OK
   → Sad path: Usuario SIN función → PermissionDenied
   → Edge case: Función temporal expirada → Acceso denegado
   
4. Valida SoD:
   → Usuario NO puede tener funciones conflictivas
   → Sistema debe rechazar asignación
```

**Documentos que usarás más:**
- ⭐⭐⭐ CNST_005 (tests, ejemplos)
- ⭐⭐ MODELO_RBAC (casos de uso de negocio)
- ⭐ CNST_005 sección 13 (patterns de testing)

### 4.5 Project Manager / Scrum Master

**Tu misión:** Entender alcance, estimar esfuerzo, comunicar con stakeholders

**Ruta de lectura:**

```
1. Lee ESTE DOCUMENTO (MAPA_RBAC_COMPLETO)
   → Entiendes arquitectura en 10 minutos
   
2. Lee resumen ejecutivo de MODELO_RBAC
   → Sección 1-2 (suficiente para contexto)
   
3. Usa catálogo de funciones como referencia
   → MODELO_RBAC sección 7
   → "Tenemos 44 funciones, 10 agrupadores"
   
4. Para estimación de nuevas funciones:
   → Consulta CNST_005 sección 12 (ejemplos)
   → Estima: ~4-8 horas por función nueva (código + tests)
```

**Documentos que usarás más:**
- ⭐⭐⭐ ESTE DOCUMENTO (overview rápido)
- ⭐⭐ MODELO_RBAC secciones 1-2, 7 (resumen + catálogo)
- ⭐ CNST_005 (solo para estimaciones técnicas)

---

## 5. TABLA DE CORRESPONDENCIAS

### 5.1 Funciones Atómicas (44 total)

| ID | Función | MODELO (página) | CNST_005 (sección) | Implementado |
|----|---------|----------------|-------------------|--------------|
| AUT-001 | gestiona_sesiones | Sec 7.1.1 | Sec 3.1 | ✅ |
| AUT-002 | cierra_sesion_usuario | Sec 7.1.2 | Sec 3.1 | ✅ |
| AUT-003 | resetea_password | Sec 7.1.3 | Sec 3.1 | ✅ |
| AUT-004 | ve_sesiones_activas | Sec 7.1.4 | Sec 3.1 | ✅ |
| USR-001 | crea_usuarios | Sec 7.2.1 | Sec 3.2 | ✅ |
| USR-002 | ve_usuarios | Sec 7.2.2 | Sec 3.2 | ✅ |
| USR-003 | modifica_usuarios | Sec 7.2.3 | Sec 3.2 | ✅ |
| USR-004 | elimina_usuarios | Sec 7.2.4 | Sec 3.2 | ✅ |
| USR-005 | lista_usuarios | Sec 7.2.5 | Sec 3.2 | ✅ |
| USR-006 | busca_usuarios | Sec 7.2.6 | Sec 3.2 | ✅ |
| USR-007 | bloquea_usuarios | Sec 7.2.7 | Sec 3.2 | ✅ |
| USR-008 | desbloquea_usuarios | Sec 7.2.8 | Sec 3.2 | ✅ |
| USR-009 | reactiva_usuarios | Sec 7.2.9 | Sec 3.2 | ✅ |
| USR-010 | asigna_segmento | Sec 7.2.10 | Sec 3.2 | ✅ |
| ACC-001 | asigna_funciones | Sec 7.3.1 | Sec 3.3 | ✅ |
| ACC-002 | revoca_funciones | Sec 7.3.2 | Sec 3.3 | ✅ |
| ACC-003 | ve_asignaciones | Sec 7.3.3 | Sec 3.3 | ✅ |
| ACC-004 | asigna_agrupadores | Sec 7.3.4 | Sec 3.3 | ✅ |
| ACC-005 | gestiona_sod | Sec 7.3.5 | Sec 3.3 | ✅ |
| ACC-006 | gestiona_segmentos | Sec 7.3.6 | Sec 3.3 | ✅ |
| PIP-001 | ve_estado_etl | Sec 7.4.1 | Sec 3.4 | ✅ |
| PIP-002 | ve_errores_etl | Sec 7.4.2 | Sec 3.4 | ✅ |
| PIP-003 | ve_disponibilidad_datos | Sec 7.4.3 | Sec 3.4 | ✅ |
| PIP-004 | solicita_reintento_etl | Sec 7.4.4 | Sec 3.4 | ✅ |
| RPT-001 | ve_reportes | Sec 7.5.1 | Sec 3.5 | ✅ |
| RPT-002 | ve_dashboard | Sec 7.5.2 | Sec 3.5 | ✅ |
| RPT-003 | filtra_reportes | Sec 7.5.3 | Sec 3.5 | ✅ |
| RPT-004 | exporta_csv | Sec 7.5.4 | Sec 3.5 | ✅ |
| RPT-005 | exporta_excel | Sec 7.5.5 | Sec 3.5 | ✅ |
| RPT-006 | exporta_pdf | Sec 7.5.6 | Sec 3.5 | ✅ |
| RPT-007 | ve_kpis | Sec 7.5.7 | Sec 3.5 | ✅ |
| RPT-008 | ve_graficos | Sec 7.5.8 | Sec 3.5 | ✅ |
| ALR-001 | ve_alertas | Sec 7.6.1 | Sec 3.6 | ✅ |
| ALR-002 | configura_alertas | Sec 7.6.2 | Sec 3.6 | ✅ |
| ALR-003 | configura_alertas_equipo | Sec 7.6.3 | Sec 3.6 | ✅ |
| ALR-004 | pausa_alertas | Sec 7.6.4 | Sec 3.6 | ✅ |
| ALR-005 | elimina_alertas | Sec 7.6.5 | Sec 3.6 | ✅ |
| ALR-006 | ve_historial_alertas | Sec 7.6.6 | Sec 3.6 | ✅ |
| AUD-001 | ve_auditoria | Sec 7.7.1 | Sec 3.7 | ✅ |
| AUD-002 | busca_auditoria | Sec 7.7.2 | Sec 3.7 | ✅ |
| AUD-003 | exporta_auditoria | Sec 7.7.3 | Sec 3.7 | ✅ |
| AUD-004 | genera_reporte_compliance | Sec 7.7.4 | Sec 3.7 | ✅ |
| LOG-001 | ve_logs_tecnicos | Sec 7.8.1 | Sec 3.8 | ✅ |
| LOG-002 | exporta_logs | Sec 7.8.2 | Sec 3.8 | ✅ |

**Correspondencia:** 44/44 = **100%** ✅

### 5.2 Agrupadores (10 total)

| ID | Agrupador | MODELO | CNST_005 | Funciones Incluidas |
|----|-----------|--------|----------|-------------------|
| AGR-001 | agr_operador_basico | Sec 9.1 | Sec 4.1 | 5 funciones |
| AGR-002 | agr_operador_reportes | Sec 9.2 | Sec 4.2 | 8 funciones |
| AGR-003 | agr_supervisor | Sec 9.3 | Sec 4.3 | 12 funciones |
| AGR-004 | agr_exportador | Sec 9.4 | Sec 4.4 | 3 funciones |
| AGR-005 | agr_gestor_alertas | Sec 9.5 | Sec 4.5 | 6 funciones |
| AGR-006 | agr_admin_usuarios | Sec 9.6 | Sec 4.6 | 12 funciones |
| AGR-007 | agr_admin_acceso | Sec 9.7 | Sec 4.7 | 6 funciones |
| AGR-008 | agr_auditor | Sec 9.8 | Sec 4.8 | 4 funciones |
| AGR-009 | agr_admin_pipeline | Sec 9.9 | Sec 4.9 | 4 funciones |
| AGR-010 | agr_admin_logs | Sec 9.10 | Sec 4.10 | 2 funciones |

**Correspondencia:** 10/10 = **100%** ✅

### 5.3 Restricciones SoD (3 total)

| ID | SoD | MODELO | CNST_005 | Implementación |
|----|-----|--------|----------|----------------|
| SOD-001 | sod_admin_auditoria | Sec 10.1 | Sec 7.1 | Validación Python + SQL |
| SOD-002 | sod_usuarios_auditoria | Sec 10.2 | Sec 7.2 | Validación Python + SQL |
| SOD-003 | sod_acceso_auditoria | Sec 10.3 | Sec 7.3 | Validación Python + SQL |

**Correspondencia:** 3/3 = **100%** ✅

### 5.4 Segmentos de Datos (5 total)

| Código | Segmento | MODELO | CNST_005 | Middleware |
|--------|----------|--------|----------|------------|
| OP | DATOS_OPERATIVOS | Sec 11.1 | Sec 8.1 | SEC_RULES |
| FI | DATOS_FINANCIEROS | Sec 11.2 | Sec 8.2 | SEC_RULES |
| TE | DATOS_TECNICOS | Sec 11.3 | Sec 8.3 | SEC_RULES |
| SU | DATOS_SUPERVISION | Sec 11.4 | Sec 8.4 | SEC_RULES |
| CA | DATOS_CALIDAD | Sec 11.5 | Sec 8.5 | SEC_RULES |

**Correspondencia:** 5/5 = **100%** ✅

---

## 6. CASOS DE USO DE NAVEGACIÓN

### Caso 1: "Necesito implementar exportación de reportes"

**Pregunta:** ¿Qué función RBAC uso y cómo la implemento?

**Ruta:**

```
1. Busca en MODELO_RBAC sección 7.5 (MOD_Reports)
   → Encuentras RPT-004 (exporta_csv)
   → Lees: "Permite exportar reportes a formato CSV"
   
2. Ve a CNST_005 sección 3.5.4 (RPT-004)
   → Ves el SQL schema
   → Ves ejemplo de decorator
   
3. Copia el patrón:
   
   @require_function('exporta_csv')
   def mi_vista_export_csv(request):
       # Tu código aquí
       ...
   
4. Verifica restricciones adicionales:
   → CNST_007: Límites de exportación (100K registros, 10/día)
   → CNST_006: Rango máximo 2 años
   
5. Implementa validaciones de CNST_007 en tu vista
```

**Tiempo estimado:** 15 minutos de lectura + 2 horas de implementación

### Caso 2: "¿Por qué mi usuario no puede ver reportes?"

**Pregunta:** Debugging de permisos RBAC

**Ruta:**

```
1. Identifica la función requerida
   → Usuario intenta ver /reports/trimestral
   → MODELO_RBAC: Requiere RPT-001 (ve_reportes)
   
2. Verifica asignación en BD
   → CNST_005 sección 6.3: Query SQL de verificación
   
   SELECT * FROM usuarios_funciones
   WHERE usuario_id = <ID> AND funcion_nombre = 've_reportes';
   
   ¿Resultado vacío? → Usuario NO tiene la función
   
3. Opción A: Asignar función directamente
   → Requiere función ACC-001 (asigna_funciones)
   
4. Opción B: Asignar agrupador que incluya RPT-001
   → MODELO_RBAC sección 9.2: agr_operador_reportes
   → Incluye RPT-001, RPT-002, RPT-003, RPT-007, RPT-008
   → Requiere función ACC-004 (asigna_agrupadores)
   
5. Asigna función/agrupador según necesidad
```

**Tiempo estimado:** 5 minutos de debugging

### Caso 3: "¿Puedo asignar auditor + admin_pipeline al mismo usuario?"

**Pregunta:** Validación de SoD (Separation of Duties)

**Ruta:**

```
1. Consulta MODELO_RBAC sección 10 (Restricciones SoD)
   → SOD-001: sod_admin_auditoria
   → "Usuario NO puede tener admin_pipeline Y auditor"
   
2. Respuesta: NO, viola SOD-001
   
3. Verifica implementación técnica en CNST_005 sección 7.1
   → Sistema rechazará la asignación
   → Validación automática en RBACManager.asignar_funcion()
   
4. Alternativa:
   → Usuario A: solo auditor
   → Usuario B: solo admin_pipeline
   → Separación de responsabilidades garantizada
```

**Tiempo estimado:** 2 minutos de consulta

### Caso 4: "Necesito crear una nueva función RBAC"

**Pregunta:** ¿Cómo diseño e implemento una función nueva?

**Ruta:**

```
1. Diseña la función siguiendo filosofía RBAC
   → MODELO_RBAC sección 2-3 (Filosofía y Principios)
   → Nombre: verbo en tercera persona (ej: "genera_backup")
   → Describe QUÉ hace, no QUIÉN la usa
   
2. Documenta en MODELO_RBAC
   → Agrega sección nueva en catálogo de funciones
   → Ejemplo:
   
   ### BKP-001: genera_backup
   
   **Descripción:** Permite generar backup manual de la base de datos.
   **Módulo:** MOD_System
   **Asignación típica:** Administrador de sistemas
   
3. Actualiza MODELO_RBAC a nueva versión
   → v5.1.1 → v5.1.2 (cambio menor: nueva función)
   
4. Implementa en CNST_005
   → Agrega SQL schema
   → Agrega decorator example
   → Agrega test
   
5. Actualiza CNST_005 a nueva versión
   → v1.0.0 → v1.1.0 (cambio minor: nueva funcionalidad)
   
6. Actualiza ESTE DOCUMENTO (MAPA_RBAC_COMPLETO)
   → Agrega BKP-001 a tabla de correspondencias
```

**Tiempo estimado:** 1 hora (diseño) + 4 horas (implementación + tests)

---

## 7. REFERENCIAS CRUZADAS

### 7.1 Documentos del Ecosistema IACT

```
DOCUMENTACIÓN IACT - ÁRBOL COMPLETO
════════════════════════════════════════════════════════

📁 base_cognitiva/
│
├── 📁 modelos/
│   ├── MODELO_RBAC_IACT_v5_1_1.md ⭐⭐⭐
│   └── REFERENCIA_GLOBAL_MODULOS_IACT_v1.md ⭐⭐
│
├── 📁 cnst/
│   ├── CNST_005_RBAC_Flat_SoD_Permisos_v1_0_0.rst ⭐⭐⭐
│   ├── CNST_001_No_Email_Sistema_v1_0_0.rst
│   ├── CNST_002_Sesiones_BD_Timeout_v1_0_0.rst
│   ├── CNST_003_BD_IVR_Readonly_ETL_v1_0_0.rst
│   ├── CNST_004_Alertas_Buzon_Interno_v1_0_0.rst
│   ├── CNST_006_Reportes_Limites_Rango_v1_0_0.rst
│   ├── CNST_007_Limites_Exportacion_Throttling_v1_0_0.rst
│   └── CNST_008_Audit_Inmutable_Logs_PII_v1_0_0.rst
│
├── 📁 mapas/
│   └── MAPA_RBAC_COMPLETO_v1_0_0.md (ESTE DOCUMENTO) ⭐
│
└── 📁 indices/ (Pendiente - FASE 14)
    ├── INDICE_RBAC_v1_0_0.rst
    └── INDICE_RESTRICCIONES_v1_0_0.rst

⭐⭐⭐ = Esencial para RBAC
⭐⭐ = Importante
⭐ = Complementario
```

### 7.2 Referencias Específicas

**De MODELO_RBAC hacia:**
- → CNST_005 (implementación de MODELO)
- → CNST_002 (sesiones, relacionado con AUT-001 a AUT-004)
- → CNST_003 (pipeline, relacionado con PIP-001 a PIP-004)
- → CNST_008 (auditoría, relacionado con AUD-001 a AUD-004)

**De CNST_005 hacia:**
- → MODELO_RBAC (modelo conceptual base)
- → CNST_001 (NO email, afecta notificaciones de asignación)
- → CNST_002 (sesiones, auditoría de login)
- → CNST_008 (auditoría de cambios de permisos)

**De ESTE DOCUMENTO hacia:**
- → Todos los anteriores (documento puente)

---

## 8. GLOSARIO Y CONVENCIONES

### 8.1 Términos Clave

| Término | Definición | Ejemplo |
|---------|-----------|---------|
| **Función Atómica** | Permiso indivisible que representa UNA capacidad específica | `exporta_csv` |
| **Agrupador** | Conjunto de funciones que se asignan en bloque | `agr_operador_reportes` |
| **Capacidad** | Nombre técnico de la función en código (Django permission) | `reports:exportar_csv` |
| **SoD** | Separation of Duties - funciones mutuamente excluyentes | `auditor` ⚔️ `admin_pipeline` |
| **Segmento de Datos** | Partición de datos según clasificación de negocio | `OP`, `FI`, `TE`, `SU`, `CA` |
| **Permiso Temporal** | Función asignada con fecha de expiración | `exporta_csv` hasta 2026-06-30 |

### 8.2 Convenciones de Nombrado

**Funciones:**
- Verbo en tercera persona singular
- Minúsculas con guiones bajos
- Describe QUÉ hace (no QUIÉN la usa)
- Ejemplos: `crea_usuarios`, `exporta_csv`, `ve_reportes`
- ❌ Incorrecto: `crear_usuario`, `Exportar_CSV`, `ReportViewer`

**Agrupadores:**
- Prefijo `agr_`
- Nombre descriptivo del rol
- Ejemplos: `agr_operador_basico`, `agr_auditor`

**Restricciones SoD:**
- Prefijo `sod_`
- Describe las funciones en conflicto
- Ejemplos: `sod_admin_auditoria`, `sod_usuarios_auditoria`

**Códigos de Módulo:**
- 3 letras uppercase
- Ejemplos: `AUT`, `USR`, `ACC`, `PIP`, `RPT`, `ALR`, `AUD`, `LOG`

### 8.3 Símbolos y Notación

```
✅ = Implementado / Correcto
❌ = No implementado / Incorrecto
⭐ = Importante
🔥 = Crítico
⚠️ = Advertencia
⚔️ = Conflicto SoD (Separation of Duties)
→ = Relación / Referencias
↔ = Bidireccional
```

---

## 9. CONTROL DE VERSIONES

### 9.1 Historial de Cambios

| Versión | Fecha | Cambios |
|---------|-------|---------|
| 1.0.0 | 2026-01-11 | Versión inicial del documento puente. Conecta MODELO_RBAC v5.1.1 con CNST_005 v1.0.0. Incluye guías de navegación por perfil, tablas de correspondencias, casos de uso. |

### 9.2 Versionado de Documentos Relacionados

**Sincronización de versiones:**

```
MODELO_RBAC v5.1.1 (2024-12-15)
    │
    ├─── implementado por ───┐
    │                        │
    ▼                        ▼
CNST_005 v1.0.0         ESTE DOC v1.0.0
(2026-01-11)            (2026-01-11)

Regla: 
  Si MODELO cambia → CNST debe actualizarse → Este doc se actualiza
  Si CNST cambia (bug fix) → MODELO puede no cambiar → Este doc se actualiza solo si afecta correspondencias
```

### 9.3 ¿Cuándo Actualizar Este Documento?

**Actualizar a v1.1.0 (minor) cuando:**
- Se agrega nueva función a MODELO + CNST
- Se agrega nuevo agrupador
- Se agregan guías de navegación para nuevo perfil

**Actualizar a v1.0.1 (patch) cuando:**
- Correcciones de typos
- Mejoras de claridad en explicaciones
- Actualización de referencias de sección (si cambió numeración)

**Actualizar a v2.0.0 (major) cuando:**
- Cambio arquitectónico fundamental en RBAC
- Nueva filosofía de permisos
- Rediseño completo del modelo

---

## 10. PREGUNTAS FRECUENTES (FAQ)

### Q1: ¿Por qué dos documentos separados (MODELO y CNST)?

**R:** Separación de responsabilidades:
- **MODELO** = Diseño conceptual (para arquitectos, stakeholders)
- **CNST** = Implementación técnica (para desarrolladores)
- Análogo a: "Plano arquitectónico" vs "Plano de construcción"

### Q2: Si hay conflicto entre MODELO y CNST, ¿cuál prevalece?

**R:** Depende del tipo de conflicto:
- **Si es decisión de diseño:** MODELO prevalece (es la fuente de verdad conceptual)
- **Si es detalle de implementación:** CNST prevalece (es la realidad técnica)
- **Lo ideal:** NO debe haber conflictos. Reportar como bug de documentación.

### Q3: ¿Debo leer ambos documentos completos?

**R:** Depende de tu rol (ver sección 4):
- **Desarrollador:** CNST principalmente, MODELO como referencia
- **Arquitecto:** MODELO principalmente, CNST para validar factibilidad
- **Auditor:** AMBOS completos
- **PM:** Resúmenes de ambos + ESTE documento

### Q4: ¿Cómo sé si una función está implementada?

**R:** Consulta la Tabla de Correspondencias (sección 5.1):
- Si tiene ✅ = Implementada
- Si hay ID en ambas columnas = 100% correspondencia

### Q5: ¿Puedo modificar una función existente?

**R:** Sí, pero sigue el proceso:
1. Actualiza MODELO (documenta el cambio)
2. Actualiza CNST (implementa el cambio)
3. Actualiza tests
4. Incrementa versiones apropiadamente
5. Actualiza ESTE documento

### Q6: ¿Qué hago si necesito una función que no existe?

**R:** Ver Caso de Uso 4 (sección 6.4):
- Diseña en MODELO primero
- Implementa en CNST después
- Mantén coherencia 1:1

---

## 11. RECURSOS ADICIONALES

### 11.1 Contactos

**Para preguntas sobre:**
- **Diseño RBAC:** Arquitecto del Sistema
- **Implementación técnica:** Tech Lead Backend
- **Compliance:** Equipo de Auditoría
- **Este documento:** Mantainer de Documentación

### 11.2 Herramientas

**Visualización de permisos:**
```bash
# Script de utilidad (pendiente)
python manage.py show_rbac_tree --usuario=juan.perez
```

**Validación de SoD:**
```bash
# Script de utilidad (pendiente)
python manage.py validate_sod --all
```

### 11.3 Próximos Documentos

**En desarrollo:**
- INDICE_RBAC_v1_0_0.rst (FASE 14A)
- INDICE_RESTRICCIONES_v1_0_0.rst (FASE 14A)
- UC_001 a UC_047 (FASE 16)

---

## 12. CONCLUSIÓN

### 12.1 Resumen Final

Este documento es tu **brújula** en la documentación RBAC:

```
                    MAPA_RBAC_COMPLETO
                           │
           ┌───────────────┼───────────────┐
           │                               │
           ▼                               ▼
     MODELO_RBAC                      CNST_005
     (¿QUÉ?)                          (¿CÓMO?)
     
     Diseño                           Implementación
     Filosofía                        Código
     Conceptos                        SQL, Python
     Decisiones                       Tests
```

### 12.2 Checklist de Uso

Antes de empezar cualquier trabajo con RBAC:

- [ ] He leído ESTE documento (MAPA_RBAC_COMPLETO)
- [ ] Sé cuál documento consultar según mi rol
- [ ] He identificado las funciones que necesito
- [ ] He verificado SoD si asigno múltiples funciones
- [ ] He consultado restricciones adicionales (CNST_001-008)

### 12.3 Mantenimiento de Este Documento

**Responsabilidad:** Equipo de Arquitectura + Documentación

**Frecuencia de revisión:** Mensual o al agregar nueva función

**Criterio de actualización:** Ver sección 9.3

---

**FIN DEL DOCUMENTO**

---

*Este documento fue generado el 2026-01-11 como parte de FASE 15 del Proyecto IACT-2025-001.*

*Versión: 1.0.0*

*Estado: VIGENTE*
