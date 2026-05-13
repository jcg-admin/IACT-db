# ANÁLISIS PROFUNDO: Decisiones de Módulos del Sistema IACT

**Fecha de análisis:** 2025-12-22
**Basado en:** 18 documentos de decisiones arquitectónicas (fechados 2025-12-09)
**Propósito:** Identificar la decisión FINAL sobre la cantidad y estructura de módulos

---

## 1. RESUMEN EJECUTIVO

### HALLAZGO CRÍTICO

Existe una **INCONSISTENCIA** entre los documentos analizados. Hay **dos listas finales diferentes** que compiten:

| Fuente | Cantidad | SEC_RULES como módulo |
|--------|----------|----------------------|
| "Orden correcto de módulos" | 9 módulos | SÍ (MOD-09 separado) |
| "Identificando los módulos funcionales" | 8 módulos | NO (integrado en RBAC_CORE) |
| "Análisis módulo por módulo" | 9 módulos | SÍ (MOD-09 separado) |

### DECISIÓN DOCUMENTADA (pero contradictoria)

En **"Identificando los módulos funcionales"** se llegó a la conclusión de **8 módulos**:

> "SEC_RULES (tu módulo 09 previo) **integrado como capa automática**, NO visible para usuarios."

Pero en **"Análisis módulo por módulo"** se mantiene como **9 módulos** con SEC_RULES separado (MOD-09).

---

## 2. EVOLUCIÓN CRONOLÓGICA DE DECISIONES

### Fase 1: Lista Inicial (10 módulos)
**Documento:** "Vista general – Módulos del Sistema IACT"

```
MOD-01  Autenticación y Sesiones
MOD-02  Identidades, Roles, Segmentos y Permisos (IAM/RBAC)  ← PROBLEMA
MOD-03  ETL, Calidad y Disponibilidad de Datos
MOD-04  Reportes Operativos del IVR (basados en SQL)
MOD-05  Dashboards Operativos basados en Consultas SQL Definidas
MOD-06  Alertas Internas y Notificaciones
MOD-07  Auditoría Funcional
MOD-08  Bitácoras Técnicas y Monitoreo del Sistema
MOD-09  Restricciones y Reglas de Seguridad (Enforcers)
```

**Problema identificado:** MOD-02 "IAM_RBAC" era un "God Module" que violaba SRP.

---

### Fase 2: División de IAM_RBAC
**Documento:** "MOD-02 – Identidades, Roles, Segmentos y Permisos - Viola tus principios"

Se decidió dividir MOD-02 en:
- **MOD-02 – USER_IDENTITY**: Gestión de cuentas de usuario
- **MOD-10 – RBAC_CORE**: Administración de roles, segmentos y permisos

**Resultado:** 10 módulos temporalmente.

---

### Fase 3: Unificación REPORTS + DASHBOARDS
**Documento:** "MOD-04 – Visualización y Reportes Operativos del IVR (módulo unificado)"

Se decidió fusionar:
- MOD-04 REPORTS
- MOD-05 DASHBOARDS_SQL

En un solo módulo:
- **MOD-04 VIS_REPORTS**: Visualización y Reportes Operativos del IVR

**Resultado:** 9 módulos.

---

### Fase 4: Debate sobre SEC_RULES
**Documentos clave:**
- "MOD-10 – RBAC_CORE vs MOD-09 – SEC_RULES"
- "RBAC_CORE – Lo que el usuario ve y administra"
- "Aplicando ejemplos de Prompts"

**Argumentos para SEC_RULES como módulo separado:**
- RBAC_CORE = Configuración estática ("quién tiene qué permisos")
- SEC_RULES = Validación en tiempo real ("¿esta acción está permitida?")

**Argumentos para integrar SEC_RULES en RBAC_CORE:**
- SEC_RULES NO tiene UI
- SEC_RULES NO tiene UC visibles
- SEC_RULES es una "capa transversal automática"
- El usuario nunca "entra" a SEC_RULES

**Conclusión documentada:**
> "SEC_RULES debe ser descrito como **capa interna de enforcement** dentro de ese mismo dominio, NO como módulo funcional separado."

---

### Fase 5: Lista Final de 8 Módulos
**Documento:** "Identificando los módulos funcionales"

```
MOD-01  AUTH              - Sesiones y autenticación
MOD-02  USER_IDENTITY     - Usuarios / identidades
MOD-03  ETL_MONITORING    - Monitoreo ETL (renumerado desde MOD-04)
MOD-04  VIS_REPORTS       - Dashboards + Reportes + Exportaciones (renumerado desde MOD-05)
MOD-06  ALERTS            - Alertas internas
MOD-07  AUDIT             - Auditoría funcional
MOD-08  SYS_LOGS          - Bitácoras técnicas
MOD-09  RBAC_CORE         - Roles, segmentos, permisos (SEC_RULES incorporado)
```

**NOTA:** Hay un salto de MOD-04 a MOD-06 (MOD-05 se fusionó en MOD-04).

---

### Fase 6: CONTRADICCIÓN
**Documento:** "Análisis módulo por módulo" y "Orden correcto de módulos"

Estos documentos posteriores vuelven a listar **9 módulos** con SEC_RULES separado:

```
MOD-01  AUTH
MOD-02  USER_IDENTITY
MOD-03  RBAC_CORE
MOD-04  ETL_MONITORING
MOD-05  VIS_REPORTS
MOD-06  ALERTS
MOD-07  AUDIT
MOD-08  SYS_LOGS
MOD-09  SEC_RULES
```

---

## 3. ANÁLISIS DE CONTRADICCIONES

### Contradicción 1: Número de Módulos

| Documento | Módulos | RBAC posición | SEC_RULES |
|-----------|---------|---------------|-----------|
| Identificando módulos funcionales | 8 | MOD-09 | Integrado |
| Orden correcto de módulos | 9 | MOD-03 | MOD-09 separado |
| Análisis módulo por módulo | 9 | MOD-03 | MOD-09 separado |

### Contradicción 2: Posición de RBAC_CORE

- En "Identificando módulos funcionales": **MOD-09**
- En "Orden correcto de módulos": **MOD-03**
- En "Análisis módulo por módulo": **MOD-03**

### Contradicción 3: Numeración

La lista de 8 módulos tiene un **salto** (MOD-04 → MOD-06), lo cual es incoherente.

---

## 4. ARGUMENTOS TÉCNICOS EXTRAÍDOS

### A FAVOR de SEC_RULES como módulo separado (9 módulos):

1. **Separación de responsabilidades clara:**
   - RBAC_CORE = "Qué roles tiene el usuario" (configuración)
   - SEC_RULES = "¿Con esos roles, esta exportación está permitida hoy?" (runtime)

2. **Documentado en "MOD-10 – RBAC_CORE vs MOD-09 – SEC_RULES":**
   > "No se pisan: RBAC_CORE lo usa el admin para configurar. SEC_RULES se ejecuta en cada operación."

3. **Orden correcto de módulos (documento final) mantiene 9:**
   > "MOD-09 – Restricciones y Reglas de Seguridad (SEC_RULES) → SEC_RULES siempre se queda al final porque actúa como enforcer transversal."

### A FAVOR de SEC_RULES integrado en RBAC_CORE (8 módulos):

1. **SEC_RULES NO es un módulo funcional:**
   > "SEC_RULES no es un módulo funcional. Nadie debe 'entrar' a SEC_RULES."

2. **Es una subcapa técnica:**
   > "SEC_RULES es una subcapa técnica dentro del mismo dominio de acceso, NO un módulo funcional aparte."

3. **Decisión explícita en "Identificando módulos funcionales":**
   > "El módulo 'SEC_RULES' debería vivir dentro de RBAC"

4. **Implementación sugerida:**
   ```python
   # App `access_control`
   services/rbac_core.py  → lógica de administración
   services/sec_rules.py  → motor de enforcement
   permissions.py         → DRF permissions que llaman a sec_rules
   ```

---

## 5. DECISIÓN PROPUESTA

Basándome en el análisis de TODOS los documentos, la decisión más **coherente** y **técnicamente correcta** es:

### **8 MÓDULOS FUNCIONALES**

Con SEC_RULES como **subcapa interna** de RBAC_CORE, no como módulo separado.

**Justificación:**
1. Un módulo debe tener UI y/o UC visibles para el usuario
2. SEC_RULES NO tiene UI ni UC propios
3. SEC_RULES es middleware/enforcement automático
4. Documentalmente se puede describir SEC_RULES como sección dentro de RBAC_CORE

### **LISTA CORREGIDA Y RENUMERADA:**

```
ARQ_MOD_001  AUTH              - Autenticación y Sesiones
ARQ_MOD_002  USER_IDENTITY     - Gestión de Identidades y Cuentas
ARQ_MOD_003  RBAC_CORE         - Roles, Segmentos, Permisos (incluye SEC_RULES)
ARQ_MOD_004  ETL_MONITORING    - Supervisión del ETL
ARQ_MOD_005  VIS_REPORTS       - Visualización y Reportes
ARQ_MOD_006  ALERTS            - Alertas y Notificaciones
ARQ_MOD_007  AUDIT             - Auditoría Funcional
ARQ_MOD_008  SYS_LOGS          - Bitácoras Técnicas
```

### **ESTRUCTURA DE ARQ_MOD_003 RBAC_CORE:**

El módulo RBAC_CORE contiene DOS componentes:

1. **RBAC_CORE (Administración)**
   - UI para administrar roles, segmentos, permisos
   - UC visibles: UC_041-UC_047
   - Endpoints de API para CRUD

2. **SEC_RULES (Enforcement Interno)**
   - NO tiene UI
   - NO tiene UC propios
   - Es middleware/decoradores/policies
   - Se ejecuta automáticamente en cada request
   - Aplica: NO email, BD IVR readonly, límites exportación, SoD, etc.

---

## 6. CONTRADICCIONES NO RESUELTAS EN DOCUMENTOS

1. **El documento "Análisis módulo por módulo" asume 9 módulos**, pero fue escrito DESPUÉS de "Identificando módulos funcionales" que decidió 8.

2. **No hay un documento de cierre** que diga explícitamente: "La lista final OFICIAL es X".

3. **La numeración es inconsistente**: algunos documentos saltan de MOD-04 a MOD-06.

---

## 7. RECOMENDACIÓN FINAL

### ACCIÓN REQUERIDA:

**CONFIRMAR** con el stakeholder cuál de estas opciones es la correcta:

**OPCIÓN A: 8 Módulos (SEC_RULES integrado)**
```
ARQ_MOD_001 AUTH
ARQ_MOD_002 USER_IDENTITY
ARQ_MOD_003 RBAC_CORE (incluye SEC_RULES como subcapa)
ARQ_MOD_004 ETL_MONITORING
ARQ_MOD_005 VIS_REPORTS
ARQ_MOD_006 ALERTS
ARQ_MOD_007 AUDIT
ARQ_MOD_008 SYS_LOGS
```

**OPCIÓN B: 9 Módulos (SEC_RULES separado)**
```
ARQ_MOD_001 AUTH
ARQ_MOD_002 USER_IDENTITY
ARQ_MOD_003 RBAC_CORE
ARQ_MOD_004 ETL_MONITORING
ARQ_MOD_005 VIS_REPORTS
ARQ_MOD_006 ALERTS
ARQ_MOD_007 AUDIT
ARQ_MOD_008 SYS_LOGS
ARQ_MOD_009 SEC_RULES (capa transversal)
```

### MI RECOMENDACIÓN TÉCNICA:

**OPCIÓN A (8 módulos)** porque:
- SEC_RULES no cumple la definición de "módulo funcional"
- No tiene UI ni UC
- Es enforcement automático, no interacción de usuario
- Vive mejor como subcapa documentada dentro de RBAC_CORE

---

## 8. ANEXO: Fuentes Consultadas

1. Vista general – Módulos del Sistema IACT - v.0.0.1
2. Primeros módulos comprobados - v.0.0.1
3. Identificando los módulos funcionales - v.0.0.1
4. MOD-02 – Identidades, Roles, Segmentos y Permisos - Viola tus principios
5. MOD-03 – Supervisión del ETL, Calidad y Disponibilidad de Datos - v.0.0.1
6. MOD-03 – Supervisión del ETL - v.0.1.1
7. MOD-04 – Visualización y Reportes Operativos del IVR - v.0.0.1
8. MOD-07 – AUDIT vs MOD-08 – SYS_LOGS - v.0.0.1
9. MOD-10 – RBAC_CORE vs MOD-09 – SEC_RULES - v.0.0.1
10. RBAC_CORE – Lo que el usuario ve y administra - v.0.0.1
11. Orden correcto de módulos - v.0.0.1
12. Conexión de las RESTRICCIONES con los MÓDULOS - v.0.0.1
13. Crítica módulo por módulo - v.0.0.1
14. Análisis módulo por módulo - v.0.0.1
15. Aplicando ejemplos de Prompts - v.0.0.1
16. Flujos de datos principales del sistema IACT - v.0.0.1
17. Lista de Flujos de Datos del Sistema IACT (FD-01 a FD-12) - v.0.0.1
18. FD-04 - Ejecución del ETL (Batch) y Carga de Datos - v.0.0.1

---

*Análisis generado: 2025-12-22*
*Documentos fuente: 18 archivos de decisiones arquitectónicas*
