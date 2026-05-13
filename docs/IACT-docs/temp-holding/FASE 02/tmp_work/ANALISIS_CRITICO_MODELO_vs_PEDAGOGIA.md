# ANÁLISIS CRÍTICO: MODELO DOCUMENTAL IACT v2.2.0 vs Pedagogía Actual

**Fecha:** 2026-01-08  
**Objetivo:** Identificar TODAS las desconexiones entre el modelo documental oficial del proyecto y la documentación pedagógica (base_cognitiva/ y PARTES)

---

## RESUMEN EJECUTIVO

**HALLAZGO CRÍTICO:**

Existe una **desconexión total** entre:

1. **MODELO_DOCUMENTAL_IACT v2.2.0** (la VERDAD del proyecto):
   - 49 UC v4.0.0 con nomenclatura UC_[MOD]_[NN]
   - 20 BR reales del proyecto IACT (sistema IVR)
   - Dominio: Análisis de llamadas IVR / Call Center
   - 8 módulos funcionales reales

2. **base_cognitiva/ actual**:
   - Ejemplos con nomenclatura v2.0 (UC-XXX)
   - Rangos incorrectos mezclando módulos
   - Referencias a UC que NO existen

3. **PARTES pedagógicas** (PARTE 0, PARTE 1):
   - Dominio: Gestión de Químicos en Laboratorio
   - Ejemplos: BR-028 (productos químicos), UC-04 (solicitar químico)
   - Actores: Coordinador Seguridad, Propietario, Certificación OSHA

**PROBLEMA:**

El equipo está aprendiendo metodología con ejemplos de un dominio COMPLETAMENTE DIFERENTE al proyecto real.

**SOLUCIÓN:**

Reescritura integral de base_cognitiva/ y PARTES usando:
- Nomenclatura v4.0.0
- UC reales del MODELO_DOCUMENTAL_IACT
- Dominio IVR/Call Center
- 20 BR reales del proyecto

---

## PARTE 1: MODELO DOCUMENTAL IACT v2.2.0 (LA VERDAD)

### 1.1 Estructura Real del Proyecto

**5 Dominios:**
```
IACT/
├── base_cognitiva/                   # Conocimiento fundamental
├── requisitos/                       # Especificación del sistema
├── arquitectura_tecnica/             # Diseño e implementación
├── normativa/                        # Estándares y políticas
└── evidencia/                        # Verificación y trazabilidad
```

**8 Módulos Funcionales Reales:**

| Módulo | Prefijo | App Django | # UC | FR Gen | Estado |
|--------|---------|------------|------|--------|--------|
| MOD_Auth | UC_AUTH_ | apps.auth | 5 | 21 | ✅ |
| MOD_Users | UC_USR_ | apps.users | 4 | 17 | ✅ |
| MOD_Access | UC_ACC_ | apps.access | 9 | 17 | 🔄 |
| MOD_Pipeline | UC_PIP_ | apps.pipeline | 4 | 0 | ⏳ |
| MOD_Reports | UC_RPT_ | apps.reports | 14 | 0 | ⏳ |
| MOD_Alerts | UC_ALR_ | apps.alerts | 5 | 0 | ⏳ |
| MOD_Audit | UC_AUD_ | apps.audit | 4 | 0 | ⏳ |
| MOD_Logs | UC_LOG_ | apps.logs | 4 | 0 | ⏳ |
| **TOTAL** | — | — | **49** | **55** | **14%** |

### 1.2 Nomenclatura Real v4.0.0

**Formato de UC:**
```
UC_[MOD]_[NN]

Ejemplos:
- UC_AUTH_01: Iniciar Sesión
- UC_USR_02: Modificar Usuario
- UC_ACC_05: Configurar SoD
- UC_RPT_01: Ver Dashboard Principal
- UC_PIP_01: Monitorear ETL
```

**NO existe:**
- UC-XXX (formato v2.0)
- UC-010, UC-015, UC-040, UC-043 (referencias en base_cognitiva/)
- Rangos como "UC-005 a UC-011" (mezclan módulos)

### 1.3 Los 20 BR Reales del Proyecto

| BR | Nombre | Tipo | Dominio |
|----|--------|------|---------|
| BR_001 | Fuente Operacional Inmutable | Restricción | ETL |
| BR_002 | ETL Batch Nocturno | Desencadenador | ETL |
| BR_003 | Usuario Inactivo 90 Días | Inferencia | Usuarios |
| BR_004 | Comunicaciones Internas Only | Restricción | Alertas |
| BR_005 | Sesión Única por Usuario | Restricción | Auth |
| BR_006 | RBAC Flat NIST | Hecho | Access |
| BR_007 | Separación Funciones SoD | Restricción | Access |
| BR_008 | Permisos con Vencimiento | Restricción | Access |
| BR_009 | Bajas Lógicas | Restricción | Usuarios |
| BR_010 | Auditoría Inmutable | Restricción | Audit |
| BR_011 | Límites de Exportación | Restricción | Reports |
| BR_012 | Usuario-Segmento Único | Hecho | Access |
| BR_013 | Username Único | Hecho | Usuarios |
| BR_014 | Alerta por Umbral | Desencadenador | Alertas |
| BR_015 | Bloqueo Intentos Fallidos | Desencadenador | Auth |
| BR_016 | Tasa de Abandono | Cálculo | Reports |
| BR_017 | Tiempo Promedio Espera | Cálculo | Reports |
| BR_018 | Índice de Eficiencia | Cálculo | Reports |
| BR_019 | Retención 2 Años | Restricción | Logs |
| BR_020 | Clasificación de Datos | Restricción | Access |

**NO existe:**
- BR-028 (Solicitudes >$500 requieren aprobación) — Ejemplo pedagógico de químicos
- BR-031 (Notificar vencimiento de químico) — Ejemplo pedagógico de químicos
- BR-046 (Marcar químico como caduco) — Ejemplo pedagógico de químicos
- BR-087 (Certificación OSHA) — Ejemplo pedagógico de químicos

### 1.4 Dominio Real: Sistema IVR / Call Center

**Contexto del proyecto:**
- Sistema de análisis de llamadas IVR
- Dashboard de métricas de call center
- ETL de datos de centralita telefónica
- Reportes de disponibilidad, abandono, transferencias
- Alertas sobre umbrales de KPIs
- Auditoría de acceso a datos sensibles

**Conceptos clave del dominio:**
- Llamadas (entrantes/salientes)
- Agentes
- Colas IVR
- Métricas: Tasa de abandono, Tiempo de espera, Eficiencia
- Pipeline ETL nocturno
- Segmentos de datos (centros de llamadas)
- Dashboard con gráficos por hora/día
- Reportes trimestrales

**NO existe en el proyecto:**
- Productos químicos
- Contenedores
- Certificaciones OSHA
- Coordinador de Seguridad (de laboratorio)
- Vencimientos de químicos
- Propietarios de contenedores

### 1.5 Modelo RBAC Real v5.1.1

**10 Agrupadores Reales:**

| ID | Código | Descripción | # Funciones |
|----|--------|-------------|-------------|
| AGR-001 | agr_superadmin | Acceso total al sistema | 44 |
| AGR-002 | agr_admin_usuarios | Gestión de usuarios | 8 |
| AGR-003 | agr_admin_roles | Gestión de roles/permisos | 6 |
| AGR-004 | agr_operador_etl | Supervisión ETL | 4 |
| AGR-005 | agr_analista | Visualización y reportes | 12 |
| AGR-006 | agr_auditor | Auditoría y compliance | 4 |
| AGR-007 | agr_supervisor | Alertas y monitoreo | 5 |
| AGR-008 | agr_exportador | Exportación de datos | 3 |
| AGR-009 | agr_viewer | Solo lectura básica | 3 |
| AGR-010 | agr_soporte | Soporte técnico (logs) | 4 |

**Reglas SoD Reales:**

| Regla | Conflicto |
|-------|-----------|
| SoD-001 | agr_admin_usuarios ↔ agr_auditor |
| SoD-002 | agr_admin_roles ↔ agr_auditor |
| SoD-003 | agr_operador_etl ↔ agr_analista |

**NO existe:**
- Roles de laboratorio
- Certificaciones de manejo de químicos
- Permisos de solicitud de productos

### 1.6 Los 10 CNST (Restricciones Arquitectónicas)

| CNST | Nombre | Descripción |
|------|--------|-------------|
| CNST-001 | Comunicaciones Prohibidas | Sin email/SMS, solo in-app |
| CNST-002 | Gestión Sesiones BD | Sesiones en PostgreSQL |
| CNST-003 | BD Dual Inmutable | MySQL readonly, PG transaccional |
| CNST-004 | Actualización ETL | Solo batch nocturno 2:00 AM |
| CNST-005 | Seguridad DRF | RBAC, SoD, permisos temporales |
| CNST-006 | Retención Datos | 2 años máximo |
| CNST-007 | Límites Exportación | 100,000 registros máx |
| CNST-008 | Infraestructura | Docker, Nginx, Gunicorn |
| CNST-009 | Auditoría Inmutable | user_action_log sin UPDATE/DELETE |
| CNST-010 | Clasificación Datos | 4 niveles de sensibilidad |

---

## PARTE 2: base_cognitiva/ ACTUAL (DESACTUALIZADA)

### 2.1 Nomenclatura Incorrecta Detectada

**En FND_03_Casos_de_Uso.rst:**
```
Línea 265-274: Tabla de agrupadores UC-006 a UC-040
```

**PROBLEMA:**
- Usa formato v2.0: UC-XXX (guion medio)
- Formato correcto v4.0.0: UC_XXX_XX (guion bajo + módulo)

**En TXM_01_Taxonomia_Requisitos.rst:**
```
Rangos por Dominio:
  UC-005 a UC-011: Gestión de Acceso
  UC-012 a UC-024: Operaciones
```

**PROBLEMA:**
- Mezcla UC de diferentes módulos en un solo rango
- En v4.0.0, los rangos son POR MÓDULO:
  * MOD_Auth: UC_AUTH_01 a UC_AUTH_05
  * MOD_Users: UC_USR_01 a UC_USR_04
  * MOD_Access: UC_ACC_01 a UC_ACC_09

### 2.2 Referencias a UC No Existentes

**En base_cognitiva/:**

| Referencia | Archivo | Problema |
|-----------|---------|----------|
| UC-040 | FND_01 línea 316 | NO existe en v4.0.0 |
| UC-015 | FND_01 línea 490 | NO existe, probablemente UC_RPT_XX |
| UC-043 | FND_03 línea 100 | NO existe, probablemente UC_ACC_05 (SoD) |
| UC-050 / UC-ETL | FND_03 línea 277 | NO existe, probablemente UC_PIP_01 |
| UC_010 | MTM_01, MTM_02 (9 refs) | NO existe, probablemente UC_ACC_01 |

**Correcto en v4.0.0:**
- UC_AUTH_01 a UC_AUTH_05 (Autenticación)
- UC_USR_01 a UC_USR_04 (Usuarios)
- UC_ACC_01 a UC_ACC_09 (Control Acceso)
- UC_PIP_01 a UC_PIP_04 (Pipeline ETL)
- UC_RPT_01 a UC_RPT_14 (Reportes)
- UC_ALR_01 a UC_ALR_05 (Alertas)
- UC_AUD_01 a UC_AUD_04 (Auditoría)
- UC_LOG_01 a UC_LOG_04 (Logs)

### 2.3 Ejemplos Pedagógicos Desconectados

**FND_03 usa ejemplos de:**
- UC-043: Configurar SoD
- UC-001/002/003: Autenticación
- UC-006 a UC-009: Gestión Usuarios

**PROBLEMA:**
- Mezcla nomenclatura v2.0 con conceptos v4.0.0
- Algunos UC coinciden conceptualmente (UC-043 ≈ UC_ACC_05)
- Pero la PRESENTACIÓN es inconsistente

### 2.4 Subdominios Privados con Prefijo `_`

**Correcta:** Decisión de marcar subdominios privados con `_`

Subdominios privados (no indexados en TOC):
- `_metadata/`
- `_fundamentos_conceptuales/`
- `_ontologia_sbvr/`
- `_taxonomias_y_metamodelos/`
- `_metodologias_analiticas/`

Subdominio público (indexado):
- `glosario/`

### 2.5 Archivos SIN Sufijo de Versión

**CRÍTICO:** Ningún archivo en base_cognitiva/ sigue nomenclatura con versión.

**Actual:**
```
FND_01_Concepto_Requisito.rst
FND_03_Casos_de_Uso.rst
MTM_01_Metamodelo_Requisitos.rst
```

**Requerido por NOM_01:**
```
FND_01_Concepto_Requisito_1_0_0.rst
FND_03_Casos_de_Uso_1_0_0.rst
MTM_01_Metamodelo_Requisitos_1_0_0.rst
```

**Opciones:**
- A: Renombrar todos (FASE 0B completa)
- B: Modificar NOM_01 con excepción para subdominios privados `_*`
- C: Híbrido (mantener existentes, solo nuevos con versión)

---

## PARTE 3: PARTES PEDAGÓGICAS (DOMINIO INCORRECTO)

### 3.1 PARTE 0 - Metodología BR→UC→FR

**Dominio usado:** Productos Químicos

**Ejemplos principales:**

| BR | Definición | Tipo |
|----|-----------|------|
| BR-028 | Solicitudes >$500 requieren aprobación | Restricción |
| BR-031 | SI químico vence ENTONCES notificar | Desencadenador |
| BR-046 | SI químico vence ENTONCES marcar caduco | Inferencia |
| BR-087 | Solo certificados OSHA | Restricción |

**UC principal:**
```
UC-04: Solicitar Producto Químico
Actor: Solicitante
Flujo:
  1. Solicitante ingresa código del producto
  2. Sistema muestra información del producto
  3. Solicitante ingresa cantidad y justificación
  4. Sistema verifica capacitación del solicitante (BR-087)
  5. Sistema valida cantidad contra límites permitidos
  6. SI monto >$500 ENTONCES solicitar aprobación gerente (BR-028)
  ...
```

**PROBLEMA:**
- El proyecto IACT NO es gestión de químicos
- El proyecto IACT es análisis IVR de call center
- Los conceptos NO son transferibles directamente

### 3.2 PARTE 1 - Identificar Business Rules

**Dominio usado:** Gestión de Químicos en Laboratorio

**Contexto pedagógico:**
- Universidad con laboratorios
- Productos químicos peligrosos
- Contenedores con códigos de barras
- Certificaciones OSHA
- Coordinador de Seguridad
- Propietarios de contenedores
- Vencimientos de químicos

**Actores del dominio pedagógico:**
1. Solicitante (de productos químicos)
2. Propietario (de contenedor)
3. Coordinador de Seguridad
4. Gerente de Departamento
5. Aprobador

**PROBLEMA:**
Ninguno de estos actores existe en el dominio IVR real:
- Usuario del Sistema
- Analista de Reportes
- Operador ETL
- Administrador de Usuarios
- Auditor
- Supervisor de Monitoreo

### 3.3 Mapeo Conceptual Necesario

| Concepto Químicos (Pedagógico) | Concepto IVR (Real) |
|--------------------------------|---------------------|
| Contenedor de químico | Llamada telefónica |
| Propietario | Agente / Usuario |
| Coordinador Seguridad | Coordinador Técnico / Supervisor |
| Vencimiento | Fallo / Timeout / Degradación |
| Certificación OSHA | Rol / Permiso RBAC |
| Código de barras | call_id (identificador único) |
| Solicitud de compra | Consulta de reporte |
| Gerente | Supervisor de área |
| $500 umbral | 10,000 registros umbral / CPU 80% |
| Stock bajo | Disponibilidad baja / CPU alto |

---

## PARTE 4: ANÁLISIS DE IMPACTO

### 4.1 Impacto en Aprendizaje del Equipo

**PROBLEMA PEDAGÓGICO:**

1. **Confusión Conceptual:**
   - Equipo aprende con ejemplos de químicos
   - Proyecto real es IVR/call center
   - Mapeo mental requerido constantemente

2. **Dificultad de Aplicación:**
   - "¿Cómo aplico BR-028 (químicos) a mi UC_RPT_01 (reportes)?"
   - "¿Qué es el equivalente de 'Coordinador Seguridad' en IVR?"

3. **Pérdida de Contexto:**
   - Ejemplos pedagógicos no se conectan con el trabajo diario
   - Documentación técnica (base_cognitiva/) usa ejemplos irrelevantes

**SOLUCIÓN:**

Reescribir TODAS las PARTES y base_cognitiva/ con ejemplos del dominio IVR real:

**PARTE 1 reescrita:**
- BR_IACT_002: ETL Batch Nocturno (Desencadenador real del proyecto)
- BR_IACT_007: Separación SoD (Restricción real del proyecto)
- BR_IACT_016: Tasa de Abandono (Cálculo real del proyecto)
- UC_PIP_01: Monitorear ETL (caso real del proyecto)
- UC_ACC_05: Configurar SoD (caso complejo real del proyecto)

### 4.2 Impacto en base_cognitiva/

**Archivos Afectados:**

| Archivo | Cambios Requeridos | Esfuerzo |
|---------|-------------------|----------|
| FND_01_..._1_0_0.rst | Renombrar + 2 ejemplos | 1-2h |
| FND_03_..._1_0_0.rst | Renombrar + tabla agrupadores + 5 ejemplos | 3-4h |
| MTM_01_..._1_0_0.rst | Renombrar + 6 referencias + diagramas | 2-3h |
| MTM_02_..._1_0_0.rst | Renombrar + 9 referencias + tablas RTM | 2-3h |
| MTM_03_..._1_0_0.rst | Renombrar + rangos | 1h |
| TXM_01_..._1_0_0.rst | Renombrar + REESCRITURA COMPLETA | 4-5h |
| TXM_03_..._1_0_0.rst | Renombrar + ejemplos BR | 1-2h |
| **TOTAL** | **Renombrar 23 + reescribir contenido** | **14-20h** |

**Cambios específicos:**

1. **Renombrado masivo** (23 archivos):
   ```
   FND_01_Concepto_Requisito.rst → FND_01_Concepto_Requisito_1_0_0.rst
   ```

2. **Actualización nomenclatura UC:**
   ```
   UC-010 → UC_ACC_01
   UC-043 → UC_ACC_05
   UC-050 → UC_PIP_01
   UC-015 → UC_RPT_XX
   ```

3. **Reescritura de rangos** (TXM_01):
   ```
   ANTES (v2.0 - INCORRECTO):
     UC-005 a UC-011: Gestión de Acceso
   
   DESPUÉS (v4.0.0 - CORRECTO):
     MOD_Auth: UC_AUTH_01 a UC_AUTH_05
     MOD_Users: UC_USR_01 a UC_USR_04
     MOD_Access: UC_ACC_01 a UC_ACC_09
     MOD_Pipeline: UC_PIP_01 a UC_PIP_04
     MOD_Reports: UC_RPT_01 a UC_RPT_14
     MOD_Alerts: UC_ALR_01 a UC_ALR_05
     MOD_Audit: UC_AUD_01 a UC_AUD_04
     MOD_Logs: UC_LOG_01 a UC_LOG_04
   ```

4. **Reemplazo de ejemplos:**
   - FND_01: UC-40 → UC_AUTH_01 (Iniciar Sesión, ejemplo simple)
   - FND_03: UC-043 → UC_ACC_05 (Gestionar SoD, ejemplo complejo)
   - MTM_01: UC_010 → UC_ACC_01 (Asignar Funciones)
   - MTM_02: 9 referencias UC_010 → UC_ACC_01

### 4.3 Impacto en PARTES Pedagógicas

**PARTE 0:** ~18,000 palabras de metodología BR→UC→FR

**Cambios:**
- Mantener metodología (estructura correcta)
- Reemplazar TODOS los ejemplos de químicos con IVR
- Usar los 20 BR reales del MODELO_DOCUMENTAL_IACT
- Usar los 49 UC reales v4.0.0

**PARTE 1:** ~25,000 palabras sobre identificación de BR

**Cambios:**
- Mantener taxonomía de 5 tipos (correcto)
- Reemplazar TODOS los ejemplos:
  * BR-028 (químicos) → BR_016 (Tasa Abandono IVR)
  * BR-031 (químicos) → BR_002 (ETL Batch) o BR_014 (Alerta Umbral)
  * BR-046 (químicos) → BR_003 (Usuario Inactivo)
  * UC-04 (químicos) → UC_RPT_01 (Dashboard) o UC_PIP_01 (ETL)
  * UC-07 (químicos) → UC_ALR_XX (Alertas)

**Esfuerzo estimado:**
- PARTE 0: 8-10h de reescritura
- PARTE 1: 10-14h de reescritura
- **TOTAL PARTES: 18-24h**

---

## PARTE 5: PLAN DE CORRECCIÓN INTEGRAL

### 5.1 Opción Recomendada: REESCRITURA COMPLETA

**Justificación:**

1. **Consistencia Total:**
   - Base pedagógica (PARTES) alineada con proyecto real
   - Base técnica (base_cognitiva/) usando nomenclatura correcta
   - Equipo aprende con casos que van a implementar

2. **Elimina Confusión:**
   - NO más mapeo mental "químicos → IVR"
   - Ejemplos directamente aplicables
   - Documentación técnica = Realidad del código

3. **Valor a Largo Plazo:**
   - Nuevos miembros del equipo entienden inmediatamente
   - Documentación sirve como referencia técnica real
   - Metodología + Proyecto = Un solo documento integrado

**Contra:**
- Esfuerzo significativo: ~32-44 horas totales

### 5.2 Fases de Implementación

**FASE 0A: Decisión de Nomenclatura (1h)**
```
Decisión: ¿Renombrar archivos base_cognitiva/ con sufijo versión?

Opción B (Recomendada):
- Modificar NOM_01 con excepción para subdominios privados `_*`
- Archivos en `_fundamentos_conceptuales/` NO requieren sufijo
- Solo archivos públicos (glosario, índices) con sufijo
- Ahorra ~6-7h de renombrado
```

**FASE 0B: Auditoría Completa (2-3h)**
```
1. Listar 49 UC reales del MODELO_DOCUMENTAL_IACT
2. Listar 20 BR reales con tipos
3. Mapear conceptos Químicos → IVR
4. Seleccionar 5-10 UC representativos para ejemplos
5. Documentar plan de reemplazo detallado
```

**FASE 1: Reescritura PARTE 0 (8-10h)**
```
1. Mantener metodología BR→UC→FR (correcta)
2. Reemplazar BR-028 → BR_016 (Tasa Abandono)
3. Reemplazar BR-031/046 → BR_002/014 (ETL/Alertas)
4. Reemplazar UC-04 → UC_RPT_01 o UC_PIP_01
5. Actualizar diagramas PlantUML con nomenclatura v4.0.0
6. Validar que ejemplos son 100% del proyecto IACT
```

**FASE 2: Reescritura PARTE 1 (10-14h)**
```
1. Mantener taxonomía de 5 tipos (correcta)
2. Reemplazar TODOS los ejemplos de químicos:
   - Sección 4 (Taxonomía): 5 tipos con ejemplos IVR
   - Sección 5 (Desenc vs Inf): Ejemplos comparativos IVR
   - Sección 7 (Documentación): Plantillas con ejemplos IVR
   - Sección 11 (Ejercicios): TODOS los ejercicios con IVR
3. Actualizar actores: Solicitante → Analista, Coordinador → Supervisor
4. Actualizar dominio: Químicos → IVR/Call Center
```

**FASE 3: Reescritura base_cognitiva/ (14-20h)**
```
Por archivo:

1. FND_01 (1-2h):
   - UC-40 → UC_AUTH_01 (Iniciar Sesión)
   - UC-015 → UC_RPT_01 (Ver Dashboard)
   - Renombrar a FND_01_..._1_0_0.rst (si Opción A)

2. FND_03 (3-4h):
   - Tabla agrupadores: Reescribir con módulos v4.0.0
   - UC-043 → UC_ACC_05 (SoD)
   - UC-001/002/003 → UC_AUTH_01/02/03
   - UC-050 → UC_PIP_01
   - Renombrar a FND_03_..._1_0_0.rst

3. MTM_01 (2-3h):
   - UC_010 → UC_ACC_01 (6 referencias)
   - UC_ETL → UC_PIP_01
   - Diagramas trazabilidad con ejemplos IACT
   - Renombrar a MTM_01_..._1_0_0.rst

4. MTM_02 (2-3h):
   - UC_010 → UC_ACC_01 (9 referencias)
   - Tablas RTM con ejemplos reales:
     BR_002 → UC_PIP_01 → FR_UCPIP_01_XX
   - Renombrar a MTM_02_..._1_0_0.rst

5. MTM_03 (1h):
   - Rangos "UC-005 a UC-011" → Por módulo
   - Renombrar a MTM_03_..._1_0_0.rst

6. TXM_01 (4-5h) - CRÍTICO:
   - REESCRITURA COMPLETA de tabla de rangos:
     ```
     MOD_Auth: UC_AUTH_01 a UC_AUTH_05
     MOD_Users: UC_USR_01 a UC_USR_04
     MOD_Access: UC_ACC_01 a UC_ACC_09
     MOD_Pipeline: UC_PIP_01 a UC_PIP_04
     MOD_Reports: UC_RPT_01 a UC_RPT_14
     MOD_Alerts: UC_ALR_01 a UC_ALR_05
     MOD_Audit: UC_AUD_01 a UC_AUD_04
     MOD_Logs: UC_LOG_01 a UC_LOG_04
     ```
   - Ejemplos por tipo con UC reales
   - Nomenclatura FR: FR_UC[MOD]_[NN]_[MM]
   - Renombrar a TXM_01_..._1_0_0.rst

7. TXM_03 (1-2h):
   - Ejemplos BR con dominio IVR:
     * BR_002: ETL Batch (Desencadenador)
     * BR_007: SoD (Restricción)
     * BR_016: Tasa Abandono (Cálculo)
   - Renombrar a TXM_03_..._1_0_0.rst

8. Otros archivos (META, SBVR, GLOS, METH): 2-4h
   - Actualizar referencias a UC
   - Verificar consistencia
   - Renombrar si Opción A
```

**FASE 4: Validación (2-3h)**
```
1. Build Sphinx completo sin warnings
2. Verificar que TODAS las referencias UC usan v4.0.0
3. Verificar que TODOS los ejemplos son del dominio IVR
4. Verificar consistencia interna entre documentos
5. Testing de navegación y búsqueda
```

**FASE 5: Documentación del Cambio (1h)**
```
1. Actualizar CHANGELOG
2. Documentar decisiones tomadas
3. Crear guía de migración
4. Actualizar README
```

### 5.3 Estimación Total de Esfuerzo

| Fase | Actividad | Horas |
|------|-----------|-------|
| 0A | Decisión Nomenclatura | 1h |
| 0B | Auditoría Completa | 2-3h |
| 1 | Reescritura PARTE 0 | 8-10h |
| 2 | Reescritura PARTE 1 | 10-14h |
| 3 | Reescritura base_cognitiva/ | 14-20h |
| 4 | Validación | 2-3h |
| 5 | Documentación | 1h |
| **TOTAL** | — | **38-51h** |

**Distribución:**
- Auditoría y planificación: 3-4h (8%)
- Reescritura PARTES: 18-24h (47%)
- Reescritura base_cognitiva/: 14-20h (39%)
- Validación y documentación: 3-4h (6%)

### 5.4 Cronograma Sugerido

**Semana 1:**
- FASE 0A y 0B (3-4h)
- FASE 1 inicio (4h)

**Semana 2:**
- FASE 1 finalización (4-6h)
- FASE 2 inicio (6h)

**Semana 3:**
- FASE 2 finalización (4-8h)
- FASE 3 inicio (4h)

**Semana 4:**
- FASE 3 continuación (10h)

**Semana 5:**
- FASE 3 finalización (4-6h)
- FASE 4 Validación (2-3h)
- FASE 5 Documentación (1h)

**Total:** 5 semanas trabajando 8-10h/semana

---

## PARTE 6: DEPENDENCIAS PARA CONTINUAR

Para ejecutar el plan, NECESITO:

### 6.1 Listado Completo de 49 UC Reales

**YA TENGO del MODELO_DOCUMENTAL_IACT v2.2.0:**
- ✅ UC_AUTH_01 a UC_AUTH_05 (5 UC)
- ✅ UC_USR_01 a UC_USR_04 (4 UC)
- ✅ UC_ACC_01 a UC_ACC_09 (9 UC)
- ✅ UC_PIP_01 a UC_PIP_04 (4 UC)
- ✅ UC_RPT_01 a UC_RPT_14 (14 UC)
- ✅ UC_ALR_01 a UC_ALR_05 (5 UC)
- ✅ UC_AUD_01 a UC_AUD_04 (4 UC)
- ✅ UC_LOG_01 a UC_LOG_04 (4 UC)

**Total: 49 UC con nombres completos** ✅

### 6.2 Archivos UC Individuales (Representativos)

**NECESITO acceso a al menos 5-10 UC para entender contexto:**

Prioritarios:
1. UC_AUTH_01_Iniciar_Sesion.rst (caso simple, fundamental)
2. UC_ACC_05_Configurar_SoD.rst (caso complejo, SoD)
3. UC_RPT_01_Ver_Dashboard_Principal.rst (caso reportes)
4. UC_PIP_01_Monitorear_ETL.rst (caso pipelines)
5. UC_ALR_01_Crear_Alerta.rst (caso alertas)

Opcionales:
6. UC_USR_01_Crear_Usuario.rst
7. UC_AUD_01_Consultar_Auditoria.rst
8. UC_LOG_01_Consultar_Logs.rst

### 6.3 Las 20 BR Reales Documentadas

**YA TENGO del MODELO_DOCUMENTAL_IACT v2.2.0:**
- ✅ Listado completo de 20 BR
- ✅ Tipo de cada BR
- ✅ Dominio de cada BR
- ✅ Fórmulas de BR de cálculo (BR_016, BR_017, BR_018)

**¿EXISTEN archivos individuales BR_XXX.rst?**
- Si SÍ: Necesito acceso a 5-10 representativos
- Si NO: Puedo inferir contenido del MODELO_DOCUMENTAL

### 6.4 Confirmación de Dominio

**YA CONFIRMADO:**
- ✅ IACT = Sistema de análisis de llamadas IVR
- ✅ Dominio: Call Center / Telecomunicaciones
- ✅ Conceptos clave: Llamadas, Agentes, Colas, ETL, Dashboard, Métricas

**Conceptos adicionales del dominio:**
- Tasa de abandono
- Tiempo promedio de espera
- Índice de eficiencia
- Transferencias de llamadas
- Problemas de menú IVR
- Segmentos (centros de llamadas)
- Reportes trimestrales

---

## CONCLUSIÓN

**HALLAZGO PRINCIPAL:**

Existe una **desconexión total crítica** entre:

1. **MODELO_DOCUMENTAL_IACT v2.2.0** (LA VERDAD del proyecto):
   - 49 UC v4.0.0 reales
   - 20 BR reales del sistema IVR
   - Dominio: Call Center / Análisis de llamadas

2. **base_cognitiva/ + PARTES pedagógicas** (DESACTUALIZADAS):
   - Nomenclatura v2.0
   - Ejemplos de dominio de Químicos
   - Referencias a UC inexistentes
   - Rangos incorrectos

**SOLUCIÓN REQUERIDA:**

Reescritura integral (~38-51h) de:
1. PARTE 0 (metodología con ejemplos IVR)
2. PARTE 1 (identificación BR con ejemplos IVR)
3. base_cognitiva/ (actualización nomenclatura + ejemplos IVR)

**BENEFICIO:**

- Equipo aprende con casos REALES del proyecto
- Documentación técnica = Código real
- Eliminación de confusión conceptual
- Base sólida para onboarding de nuevos miembros

**PRÓXIMO PASO:**

1. Decisión sobre Opción A (renombrar) vs Opción B (excepción NOM_01)
2. Acceso a 5-10 archivos UC representativos (si disponibles)
3. Autorización para ejecutar reescritura integral
4. Cronograma de implementación (5 semanas sugeridas)

---

**FIN DEL ANÁLISIS**

**Versión:** 1.0.0  
**Fecha:** 2026-01-08  
**Próxima Revisión:** Post-decisión sobre plan de corrección

