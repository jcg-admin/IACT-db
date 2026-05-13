Análisis módulo por módulo  - v.0.0.1 - 249fbe

date: 2025-12-09

Va, vamos módulo por módulo y te digo **concreto** si hay riesgo de que violen el orden / responsabilidades, y qué _no_ deben hacer para mantenerse limpios.

Tomamos este orden actual:

1. MOD-01 – AUTH
    
2. MOD-02 – USER_IDENTITY
    
3. MOD-03 – RBAC_CORE
    
4. MOD-04 – ETL_MONITORING
    
5. MOD-05 – VIS_REPORTS
    
6. MOD-06 – ALERTS
    
7. MOD-07 – AUDIT
    
8. MOD-08 – SYS_LOGS
    
9. MOD-09 – SEC_RULES
    

---

## 🔹 MOD-01 – Autenticación y Sesiones (AUTH)

**Rol en la arquitectura**

- Login, logout, expiración de sesión.
    
- Gestión de JWT, refresh tokens, sesión única, timeout 15 min.
    
- Validación IP + User-Agent (según restricciones).
    

**✅ No viola el orden si:**

- Solo **autentica**: UC-001, UC-002, UC-003, UC-004, UC-005.
    
- Usa lo que diga RBAC, pero **no define roles ni permisos**.
    
- No implementa reglas avanzadas de acceso (eso es SEC_RULES / RBAC_CORE).
    

**🚫 Violaciones típicas:**

- Si en AUTH empiezas a meter cosas como:
    
    - “Si es ADMIN puede ver X módulo” → eso es de RBAC_CORE.
        
    - “Si no tiene rol R017 no puede ver auditoría” → eso es RBAC_CORE/SEC_RULES.
        
- Meter lógica de alertas (“si falla muchas veces, generar alerta UC-036”) → eso es MOD-06.
    

👉 AUTH solo responde:  
**¿Quién eres? ¿Tu sesión es válida?**  
Lo demás lo decide RBAC_CORE + SEC_RULES.

---

## 🔹 MOD-02 – USER_IDENTITY (Gestión de identidades y cuentas)

**Rol en la arquitectura**

- Alta, baja lógica, modificación de usuario.
    
- Preguntas de seguridad, estado del usuario, datos básicos.
    
- Asocia usuario con _referencias_ a roles/segmentos, pero no hace la lógica compleja.
    

**✅ No viola el orden si:**

- Se limita a:
    
    - UC-006, UC-007, UC-008, UC-009 (gestión de usuarios).
        
    - Asociar “usuario ↔ roles” como _relación_, sin decidir permisos efectivos.
        
- No implementa lógica de precedencia, ni cálculo de permisos efectivos.
    

**🚫 Violaciones típicas:**

- Que USER_IDENTITY tenga lógica tipo:
    
    - “Si el usuario tiene rol X y segmento Y, entonces puede acceder a Z”.
        
    - Validaciones complejas de SoD (conflicto entre roles), eso es RBAC_CORE.
        
- Que defina enums / catálogos de permisos → eso también es RBAC_CORE.
    

👉 USER_IDENTITY responde:  
**¿Qué usuarios existen y con qué atributos/relaciones?**  
No responde: **¿qué pueden hacer?**

---

## 🔹 MOD-03 – RBAC_CORE (Núcleo de Roles, Segmentos y Permisos)

**Rol en la arquitectura**

- Define:
    
    - Catálogo de roles (R001–R0xx).
        
    - Catálogo de permisos.
        
    - Segmentos de datos.
        
    - Precedencias (Directo > Rol > Segmento).
        
    - Reglas SoD (conflicto entre roles).
        
- Calcula permisos efectivos para un usuario + contexto.
    

**✅ No viola el orden si:**

- **No muestra UI funcional final** (reportes, alertas, etc.).
    
- No implementa en sí mismo lógica de negocio de reportes, ETL, etc.
    
- Solo expone:
    
    - “Este usuario puede /no puede hacer X en módulo Y con segmento Z”.
        

**🚫 Violaciones típicas:**

- Si aquí metes:
    
    - Lógica de filtrado de datos para reportes (“aplicar este filtro SQL concreto”).
        
    - Lógica de seguridad avanzada tipo “si más de 5 fallos → bloquear IP” → eso es SEC_RULES.
        
- Si RBAC_CORE empieza a meter validaciones propias del dominio (por ejemplo, reglas propias del IVR, menús, etc.).
    

👉 RBAC_CORE responde:  
**¿Qué puede hacer este usuario en este módulo, sobre qué datos?**

---

## 🔹 MOD-04 – ETL_MONITORING (Supervisión del ETL, Calidad y Disponibilidad)

**Rol en la arquitectura**

- Supervisar el _pipeline ETL_ (no hacer análisis avanzado).
    
- Ver disponibilidad de datos, fechas cargadas, última ejecución.
    
- Ver errores del ETL (a nivel funcional, no log técnico bruto).
    
- Respetar las restricciones de BD dual y solo lectura.
    

**✅ No viola el orden si:**

- Se limita a UC tipo:
    
    - UC-050–052, pero orientados a:
        
        - Ver que el ETL corrió.
            
        - Ver qué fechas/quincenas/trimestres están disponibles.
            
        - Consultar si hubo errores de carga.
            
- NO hace:
    
    - Reportes de negocio (eso es VIS_REPORTS).
        
    - Consultas directas al IVR más allá de la vista `vw_llamadas`.
        

**🚫 Violaciones típicas:**

- Si ETL_MONITORING empieza a:
    
    - Generar tablas y gráficos operativos para el usuario final (eso es VIS_REPORTS).
        
    - Exponer logs técnicos crudos del sistema (eso es SYS_LOGS).
        
    - Definir reglas de seguridad (“si falla N veces, bloquear algo”) → eso es SEC_RULES.
        

👉 ETL_MONITORING responde:  
**¿El ETL está bien, cuándo corrió, qué datos tengo disponibles y qué falló?**

---

## 🔹 MOD-05 – VIS_REPORTS (Visualización y Reportes Operativos del IVR)

**Rol en la arquitectura**

- Punto único para:
    
    - Dashboards (UC-025, UC-027–029).
        
    - Reportes tabulares (UC-017–024).
        
    - Exportaciones (CSV, Excel, PDF) cumpliendo límites + restricciones.
        

**✅ No viola el orden si:**

- Solo **consume**:
    
    - Datos ya procesados en BD Analytics.
        
    - Permisos efectivos de RBAC_CORE para:
        
        - Mostrar/ocultar dashboards.
            
        - Habilitar/deshabilitar exportaciones.
            
- El flujo que tú dijiste se cumple:
    
    1. Usuario entra a VIS_REPORTS.
        
    2. El sistema filtra qué dashboards/reportes puede ver (segmentos + permisos).
        
    3. Si tiene `view` → ve tablas/gráficas.  
        Si además tiene `export` → ve botones de CSV/Excel/PDF.
        

**🚫 Violaciones típicas:**

- Si VIS_REPORTS:
    
    - Ejecuta ETL o agenda jobs (eso es ETL_MONITORING / backend scheduler).
        
    - Implementa lógica de RBAC (resolver roles, precedencia, etc.).
        
    - Rompe restricciones de real-time:
        
        - WebSockets, SSE, auto-refresh constante → viola las restricciones de “NO tiempo real”.
            

👉 VIS_REPORTS responde:  
**¿Qué ve el usuario y qué puede descargar, según sus permisos, con datos del ETL?**

---

## 🔹 MOD-06 – ALERTS (Alertas internas y buzón)

**Rol en la arquitectura**

- Sistema de alertas que respeta **NO EMAIL**.
    
- Buzón interno (InternalMessage).
    
- Reglas de alertas basadas en métricas (pero usando datos ya procesados).
    

**✅ No viola el orden si:**

- Usa datos que vienen:
    
    - De BD Analytics (ya transformados).
        
    - De VIS_REPORTS / ETL como fuente de métricas, pero sin reimplementar reportes.
        
- Respeta:
    
    - Todas las notificaciones se entregan via **buzón interno**.
        
    - Reglas declarativas, pero sin reescribir RBAC o SEC_RULES.
        

**🚫 Violaciones típicas:**

- Si ALERTS:
    
    - Hace consultas directas a BD IVR saltándose el ETL.
        
    - Intenta mandar email (viola restricción crítica).
        
    - Implementa lógica de permisos (“solo admin ve estas alertas”) sin pasar por RBAC_CORE.
        

👉 ALERTS responde:  
**¿Qué condiciones disparan alertas y qué mensajes internos se envían a los usuarios?**

---

## 🔹 MOD-07 – AUDIT (Auditoría Funcional)

**Rol en la arquitectura**

- Registra **acciones de negocio**:
    
    - Login/logout.
        
    - Creación y modificación de usuarios.
        
    - Asignación de roles/segmentos.
        
    - Exportaciones de reportes.
        
    - Cambios de configuración.
        

**✅ No viola el orden si:**

- Solo escribe:
    
    - Quién, qué, cuándo, desde dónde, resultado.
        
- No se usa como “log técnico”, sino como:
    
    - Bitácora de **acciones funcionales**.
        

**🚫 Violaciones típicas:**

- Si en AUDIT empiezas a guardar:
    
    - Stack traces, errores de bajo nivel, traza técnica → eso es SYS_LOGS.
        
- Si AUDIT define reglas de acceso (“solo auditor ve esto”) → eso lo decide RBAC_CORE / SEC_RULES.
    

👉 AUDIT responde:  
**¿Qué acciones de negocio relevantes se hicieron en el sistema?**

---

## 🔹 MOD-08 – SYS_LOGS (Bitácoras Técnicas y Monitoreo del Sistema)

**Rol en la arquitectura**

- Logs técnicos:
    
    - Errores de servidor.
        
    - Tracebacks.
        
    - Estado de servicios.
        
    - Integración con monitoring/observability (si aplica).
        

**✅ No viola el orden si:**

- Solo maneja:
    
    - Logs estructurados, niveles (INFO/WARN/ERROR).
        
    - Logs de infraestructura (up/down, fallos, timeouts).
        
- Es consumido por:
    
    - Administradores/técnicos con permisos específicos (definidos en RBAC_CORE).
        

**🚫 Violaciones típicas:**

- Si SYS_LOGS:
    
    - Intenta registrar cosas de negocio tipo “Usuario exportó reporte X” → eso va a AUDIT.
        
    - Define reglas de seguridad (“si hay muchos errores de login, bloquear usuario”) → eso es SEC_RULES.
        
    - Exponer PII sin enmascarar → viola restricciones de logging.
        

👉 SYS_LOGS responde:  
**¿Qué está pasando a nivel técnico con el sistema y sus componentes?**

---

## 🔹 MOD-09 – SEC_RULES (Restricciones y Reglas de Seguridad – Enforcers)

**Rol en la arquitectura**

- Aplica **automáticamente** las restricciones críticas:
    
    - NO email.
        
    - BD IVR solo lectura.
        
    - No real-time.
        
    - Sesiones en BD.
        
    - Límites de exportación, throttling, etc.
        

**✅ No viola el orden si:**

- Opera como **capa transversal**:
    
    - Middleware, validadores, decoradores, policies.
        
- Se invoca desde otros módulos, pero **no tiene UI propia**.
    

**🚫 Violaciones típicas:**

- Si SEC_RULES:
    
    - Se expone como módulo “visible” para muchos usuarios (no tiene sentido).
        
    - Empieza a redefinir permisos (eso es RBAC_CORE).
        
    - Implementa lógica de dominio que no sea de seguridad.
        

👉 SEC_RULES responde:  
**¿Se están cumpliendo las restricciones y políticas globales en cada request/operación?**

---

## ✅ Conclusión del análisis

Con el orden que tienes ahora, **ningún módulo está obligado a violar el orden**, **siempre y cuando**:

- **RBAC_CORE solo calcule permisos** (no muestra negocio, no toca seguridad avanzada).
    
- **SEC_RULES solo aplique restricciones y políticas globales**, sin redefinir permisos.
    
- **VIS_REPORTS** no haga ETL, ni defina permisos, ni use real-time.
    
- **ETL_MONITORING** supervise, pero no se convierta en módulo de reportes.
    
- **AUDIT** y **SYS_LOGS** se mantengan bien separados:
    
    - AUDIT = acciones de negocio.
        
    - SYS_LOGS = eventos técnicos.
        

Si quieres, en el siguiente paso puedo:

- Tomar **cada módulo** y generar una mini-ficha tipo:
    

> _“Este módulo PUEDE hacer X, NO PUEDE hacer Y, y DEPENDE de Z”_

para que lo pegues tal cual en tu documentación de arquitectura.
