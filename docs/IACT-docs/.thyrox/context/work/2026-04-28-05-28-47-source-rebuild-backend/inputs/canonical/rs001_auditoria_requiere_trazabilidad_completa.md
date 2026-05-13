---
id: RS-001
tipo: stakeholder
titulo: Auditoria requiere trazabilidad completa de accesos
dominio: backend
owner: equipo-ba
prioridad: alta
estado: aprobado
fecha_creacion: 2025-11-06
fecha_aprobacion: 2025-11-06

# Stakeholder principal
stakeholder_primario: auditor-interno
stakeholder_tipo: auditor

# Trazabilidad Upward
trazabilidad_upward:
 - N-001 # Prevenir accesos fraudulentos mediante autenticacion robusta
 - RN-001 # Sistema de autenticacion seguro con prevencion de fraude

# Trazabilidad Downward
trazabilidad_downward:
 - RF-001 # Login con credenciales
 - RF-003 # Bloqueo intentos fallidos
 - RF-004 # Sesion unica
 - RF-005 # Logout manual

# Stakeholders secundarios
stakeholders_secundarios:
 - gerente-seguridad
 - compliance-officer

# Contexto de uso
contexto_uso: Auditoria interna trimestral y respuesta a incidentes de seguridad
frecuencia_uso: mensual
criticidad_operacional: alta

# Conformidad ISO 29148
iso29148_clause: "9.4" # Stakeholder Requirements Specification
babok_knowledge_area: "Requirements Analysis and Design Definition"
verificacion_metodo: inspection

# Experiencia de usuario
categoria_ux: usabilidad
impacto_experiencia: alto
date: 2025-11-13
---

# RS-001: Auditoria requiere trazabilidad completa de accesos

## 1. Descripcion del Requisito de Stakeholder

### 1.1 Declaracion del Requisito

**Como** auditor interno,
**Necesito** tener trazabilidad completa e inmutable de todos los intentos de acceso al sistema (exitosos y fallidos), incluyendo quien, cuando, desde donde, y que resultado obtuvo,
**Para** poder verificar compliance con politicas de seguridad corporativas, detectar patrones anomalos, y responder auditorias ISO 27001 en menos de 48 horas.

### 1.2 Descripcion Narrativa

**Que necesita el stakeholder:**
El auditor interno necesita acceso a logs completos y estructurados de todos los eventos de autenticacion del sistema IACT, incluyendo:
- Intentos de login exitosos con timestamp, username, IP origen, user agent
- Intentos de login fallidos con razon del fallo (credenciales invalidas, cuenta bloqueada, usuario inactivo)
- Eventos de bloqueo de cuenta con razon y timestamp
- Eventos de desbloqueo (automatico o manual)
- Cierre de sesiones (manual, por inactividad, por nueva sesion)
- Cambios de password

**Por que lo necesita:**
La organizacion debe demostrar compliance con ISO 27001 clausula A.9.2.4 (Review of user access rights) y A.9.4.1 (Information access restriction). En auditorias trimestrales, el auditor debe poder:
- Generar reportes de accesos en menos de 1 hora
- Identificar cuentas con accesos anomalos (horarios inusuales, multiples fallos, etc.)
- Demostrar que logs son inmutables y no pueden ser alterados
- Rastrear actividad de cualquier usuario en cualquier periodo historico

Sin esta trazabilidad, la organizacion arriesga:
- Fallo en auditorias ISO 27001 (perdida de certificacion)
- Imposibilidad de investigar incidentes de seguridad
- Multas por incumplimiento normativo

**Cuando y donde lo necesita:**
- Auditorias programadas: Trimestralmente
- Investigacion de incidentes: En menos de 2 horas desde alerta
- Reportes compliance: Mensualmente
- Acceso: Desde estacion de trabajo en oficina (no requiere acceso mobile)

---

## 2. Perfil del Stakeholder

### 2.1 Informacion del Stakeholder

| Atributo | Valor |
|----------|-------|
| **Nombre/Rol** | Auditor Interno / Compliance Officer |
| **Departamento/Area** | Auditoria y Compliance |
| **Nivel jerarquico** | Gerencial |
| **Experiencia tecnica** | Media (conoce SQL, Excel, herramientas BI) |
| **Frecuencia de interaccion con sistema** | Mensual (auditorias), Esporadica (incidentes) |
| **Canales de acceso** | Desktop (Windows 10, Chrome) |
| **Idioma preferido** | Espanol |
| **Necesidades de accesibilidad** | No |

### 2.2 Contexto de Trabajo del Stakeholder

**Entorno de trabajo:**
Oficina corporativa con acceso a herramientas de auditoria (Excel, Power BI, SQL Management Studio). Trabaja con multiples sistemas, IACT es uno de 15 sistemas auditados.

**Flujo de trabajo tipico (auditoria trimestral):**
1. Recibe solicitud de auditoria de Gerente de Seguridad
2. Accede a sistemas auditados y extrae logs de periodo (ej: Q4 2025)
3. Analiza logs buscando patrones anomalos (SQL + Excel + Power BI)
4. Identifica usuarios con accesos fuera de politica
5. Genera reporte ejecutivo con hallazgos y recomendaciones
6. Presenta reporte a Comite de Seguridad
7. **Requisito encaja en paso 2 y 3**: Necesita extraer y analizar logs de autenticacion

**Herramientas que usa actualmente:**
- SQL queries para extraer logs
- Excel para analisis y tablas dinamicas
- Power BI para visualizaciones
- Documento Word/PowerPoint para reportes

**Puntos de dolor actuales:**
- Logs de autenticacion dispersos en multiples archivos
- Formato no estandarizado requiere normalizacion manual
- Imposibilidad de verificar inmutabilidad de logs
- 5-8 horas de trabajo manual para generar reporte de auditoria

---

## 3. Criterios de Aceptacion del Stakeholder

### 3.1 Criterios en Formato Gherkin

#### Escenario 1: Extraer logs de autenticacion para auditoria trimestral

```gherkin
Given soy un auditor interno autenticado en sistema IACT
 And tengo permisos de lectura en modulo de auditoria
 And necesito auditar periodo Q4 2025 (Oct-Nov-Dic)
When accedo al modulo de auditoria y exporto logs de autenticacion
 And especifico rango de fechas: 2025-10-01 a 2025-12-31
Then el sistema genera archivo CSV con todos los eventos de autenticacion del periodo
 And el archivo incluye columnas: timestamp, username, evento, resultado, ip_origen, user_agent, razon
 And el archivo incluye minimo: login_success, login_failure, account_locked, account_unlocked, logout, password_changed
 And el archivo se genera en menos de 2 minutos
 And puedo abrir el archivo en Excel sin errores de formato
```

#### Escenario 2: Identificar cuentas con intentos fallidos anomalos

```gherkin
Given tengo exportacion de logs de autenticacion Q4 2025
 And cargo los logs en Excel
When filtro eventos por tipo: "login_failure"
 And cuento intentos fallidos por usuario
Then puedo identificar usuarios con mas de 10 intentos fallidos en el trimestre
 And puedo ver para cada intento: timestamp, IP origen, razon del fallo
 And puedo correlacionar intentos fallidos con eventos de bloqueo de cuenta
 And puedo identificar patrones (ej: multiples IPs para mismo usuario = cuenta comprometida)
```

#### Escenario 3: Verificar inmutabilidad de logs ante auditoria externa

```gherkin
Given soy auditor externo validando compliance ISO 27001
 And solicito al auditor interno demostrar que logs no han sido modificados
When el auditor interno muestra estructura de logs de auditoria
Then cada log incluye hash criptografico que previene modificaciones
 And logs se almacenan en tabla append-only (sin UPDATE ni DELETE)
 And cualquier intento de modificar logs es detectable
 And auditor externo valida que controles de inmutabilidad cumplen estandar
```

### 3.2 Criterios de Satisfaccion del Stakeholder

El stakeholder considerara este requisito satisfactorio cuando:

- **100% cobertura**: Todos los eventos de autenticacion registrados (login, logout, fallos, bloqueos)
- **Exportacion rapida**: Generar reporte de 3 meses de logs en menos de 2 minutos
- **Formato usable**: CSV estandarizado compatible con Excel sin transformaciones manuales
- **Inmutabilidad verificable**: Logs no pueden ser modificados post-insercion
- **Reduccion de tiempo**: Preparar auditoria trimestral en 2 horas vs 8 horas actuales

---

## 4. Valor para el Stakeholder

### 4.1 Beneficios Directos

| Beneficio | Descripcion | Impacto | Medicion |
|-----------|-------------|---------|----------|
| Reduccion de tiempo auditoria | De 8 horas a 2 horas por auditoria trimestral | Alto | Timesheet auditor interno |
| Compliance ISO 27001 | Cumplimiento verificable clausula A.9 | Alto | Score auditoria externa |
| Deteccion temprana anomalias | Identificar patrones sospechosos en minutos vs dias | Medio | Tiempo desde incidente hasta deteccion |

### 4.2 Impacto en el Trabajo del Stakeholder

**Antes (sin este requisito):**
- Tiempo invertido: 8 horas/trimestre en extraccion y normalizacion manual de logs
- Errores: Imposibilidad de garantizar completitud (logs dispersos)
- Frustracion: Formato no estandarizado requiere scripts personalizados

**Despues (con este requisito):**
- Tiempo invertido: 2 horas/trimestre (reduccion 75%)
- Errores: 100% cobertura garantizada
- Satisfaccion: Formato estandarizado CSV listo para analisis

### 4.3 Costo de NO tener este Requisito

**Para el stakeholder:**
- 24 horas/anual de trabajo manual en auditorias (6h × 4 trimestres)
- Riesgo de fallo en auditoria externa por logs incompletos
- Estres en investigacion de incidentes por falta de trazabilidad

**Para el negocio:**
- Perdida de certificacion ISO 27001 (impacto: $500K+ en licitaciones perdidas)
- Imposibilidad de investigar incidentes de seguridad (impacto: $80K+ por incidente no resuelto)
- Multas por incumplimiento normativo (impacto: $50K+ potencial)

---

## 5. Escenarios de Uso

### 5.1 Escenario Principal de Uso

**Titulo:** Auditoria trimestral de accesos

**Actor:** Auditor Interno

**Precondiciones:**
- Auditor tiene cuenta activa con rol "Auditor"
- Sistema tiene logs de autenticacion de minimo 3 meses

**Flujo Principal:**
1. Auditor accede a modulo "Auditoria" en menu principal
2. Sistema muestra pantalla con opciones de exportacion
3. Auditor selecciona "Logs de Autenticacion"
4. Auditor especifica rango de fechas (ej: 2025-10-01 a 2025-12-31)
5. Sistema valida rango de fechas (maximo 12 meses)
6. Auditor hace clic en "Exportar CSV"
7. Sistema genera archivo CSV con logs (proceso toma 60-120 segundos)
8. Sistema descarga archivo "audit_auth_logs_20251001_20251231.csv"
9. Auditor abre archivo en Excel
10. Auditor analiza datos con tablas dinamicas

**Postcondiciones:**
- Archivo CSV generado con estructura estandarizada
- Auditor tiene datos para analisis de compliance

**Frecuencia de uso:** 4 veces/anual (auditoria trimestral)

### 5.2 Escenarios Alternativos

#### Escenario Alternativo A: Investigacion de incidente de seguridad

**Descripcion:** Gerente de Seguridad reporta posible acceso no autorizado a cuenta de usuario "maria.lopez" el 2025-11-05.

**Diferencias con escenario principal:**
- Auditor necesita logs especificos de un usuario (filtro por username)
- Rango de fechas mas acotado (1-2 dias vs 3 meses)
- Analisis inmediato (minutos vs horas)
- Exportacion puede incluir menos de 100 registros (vs miles en auditoria trimestral)

### 5.3 Escenarios de Excepcion

#### Excepcion 1: Rango de fechas invalido

**Situacion:** Auditor especifica rango de fechas mayor a 12 meses o fecha futura

**Expectativa del stakeholder:** Sistema muestra mensaje de error claro: "Rango maximo: 12 meses. No se permiten fechas futuras."

**Recuperacion:** Auditor ajusta rango de fechas y reintenta exportacion

---

## 6. Derivacion a Requisitos de Sistema/Software

### 6.1 Requisitos Funcionales Derivados

Este requisito de stakeholder se implementa mediante:

- **RF-001**: Login con credenciales username/password
 - Dominio: backend
 - Relacion: Cada login exitoso genera evento auditado con username, timestamp, IP, user agent

- **RF-003**: Bloqueo automatico tras 5 intentos fallidos
 - Dominio: backend
 - Relacion: Cada intento fallido y bloqueo genera evento auditado con razon

- **RF-004**: Sesion unica con cierre de sesiones previas
 - Dominio: backend
 - Relacion: Cierre de sesion previa genera evento auditado con razon "nueva_sesion"

- **RF-005**: Logout manual con invalidacion de tokens
 - Dominio: backend
 - Relacion: Logout manual genera evento auditado

### 6.2 Requisitos No Funcionales Derivados

- **RNF-004**: Logs inmutables (append-only) con hash criptografico
- **RNF-005**: Exportacion de logs CSV en menos de 2 minutos para 3 meses de datos
- **RNF-006**: Retencion de logs por 7 anos (cumplimiento normativo)

---

## 7. Trazabilidad

### 7.1 Trazabilidad Upward (Origen)

Este requisito de stakeholder deriva de:

| Tipo | ID | Titulo | Justificacion |
|------|----|----|---------------|
| Necesidad | [N-001](../necesidades/n001_autenticacion_robusta_prevenir_fraude.md) | Prevenir accesos fraudulentos | RS-001 satisface necesidad proporcionando trazabilidad para detectar y prevenir fraude |
| Req. Negocio | [RN-001](../negocio/rn001_sistema_autenticacion_seguro_prevencion_fraude.md) | Sistema autenticacion seguro | RS-001 contribuye a RN-001 habilitando auditoria y compliance |

### 7.2 Trazabilidad Downward (Implementacion)

Este requisito se implementa mediante:

**Requisitos Funcionales:**
- [RF-001](../funcionales/rf001_login_credenciales.md) - Login con credenciales
- [RF-003](../funcionales/rf003_bloqueo_intentos_fallidos.md) - Bloqueo intentos fallidos
- [RF-004](../funcionales/rf004_sesion_unica.md) - Sesion unica
- [RF-005](../funcionales/rf005_logout.md) - Logout manual

**Requisitos No Funcionales:**
- RNF-004 - Logs inmutables
- RNF-005 - Performance exportacion
- RNF-006 - Retencion logs 7 anos

---

## 8. Aprobaciones

| Rol | Nombre | Fecha | Firma/Estado |
|-----|--------|-------|--------------|
| **Stakeholder Primario** | Auditor Interno | 2025-11-06 | Aprobado |
| **Product Owner** | Product Manager | 2025-11-06 | Aprobado |
| **Business Analyst** | BA Lead | 2025-11-06 | Documentado |

---

## Control de Cambios

| Version | Fecha | Autor | Descripcion del Cambio | Stakeholder Notificado |
|---------|-------|-------|------------------------|------------------------|
| 1.0 | 2025-11-06 | BA Team | Creacion inicial validada con Auditor Interno | Si |
