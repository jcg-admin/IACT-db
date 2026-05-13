---
id: RS-002
tipo: stakeholder
titulo: Usuarios requieren acceso rapido menor 2 segundos
dominio: backend
owner: equipo-ba
prioridad: alta
estado: aprobado
fecha_creacion: 2025-11-06
fecha_aprobacion: 2025-11-06

# Stakeholder principal
stakeholder_primario: usuario-final-agente-callcenter
stakeholder_tipo: usuario_final

# Trazabilidad Upward
trazabilidad_upward:
 - N-001 # Prevenir accesos fraudulentos mediante autenticacion robusta
 - RN-001 # Sistema de autenticacion seguro con prevencion de fraude

# Trazabilidad Downward
trazabilidad_downward:
 - RF-001 # Login con credenciales
 - RF-002 # Tokens JWT
 - RNF-001 # Tiempo respuesta login menor 2 segundos

# Stakeholders secundarios
stakeholders_secundarios:
 - supervisores-callcenter
 - gerentes-operaciones

# Contexto de uso
contexto_uso: Inicio de turno diario y reautenticacion tras sesion expirada
frecuencia_uso: diaria
criticidad_operacional: alta

# Conformidad ISO 29148
iso29148_clause: "9.4" # Stakeholder Requirements Specification
babok_knowledge_area: "Requirements Analysis and Design Definition"
verificacion_metodo: test

# Experiencia de usuario
categoria_ux: performance
impacto_experiencia: alto
date: 2025-11-13
---

# RS-002: Usuarios requieren acceso rapido menor 2 segundos

## 1. Descripcion del Requisito de Stakeholder

### 1.1 Declaracion del Requisito

**Como** agente de call center,
**Necesito** iniciar sesion en el sistema IACT en menos de 2 segundos desde que ingreso mis credenciales,
**Para** comenzar a atender llamadas inmediatamente al iniciar mi turno y minimizar tiempos muertos que afectan mi productividad y metas de atencion.

### 1.2 Descripcion Narrativa

**Que necesita el stakeholder:**
El agente de call center necesita un proceso de autenticacion rapido y fluido que no genere friccion al inicio del turno. El usuario debe:
- Ingresar username y password en pantalla de login
- Presionar "Iniciar sesion"
- Ser redirigido al dashboard principal en menos de 2 segundos
- No experimentar pantallas de carga prolongadas
- No tener que reintentar login por timeouts

**Por que lo necesita:**
Los agentes de call center trabajan en turnos con horarios estrictos y metas de atencion (ej: 40 llamadas/turno). Cada minuto cuenta. Un proceso de login lento impacta:
- Productividad: Demora en comenzar a atender llamadas
- Experiencia de usuario: Frustracion al inicio del turno
- Metricas de negocio: Menor cantidad de llamadas atendidas
- Moral del equipo: Percepcion de sistema ineficiente

Actualmente, algunos usuarios reportan login que toma 4-6 segundos, lo cual genera:
- Quejas a supervisores: 15-20 tickets/mes sobre "login lento"
- Perdida de tiempo acumulada: 4 minutos/dia × 200 usuarios × 22 dias = 293 horas/mes

**Cuando y donde lo necesita:**
- Inicio de turno: 2-3 veces/dia (turno manana, tarde, noche)
- Tras sesion expirada: 1-2 veces/dia (sesion expira tras 30 min inactividad)
- Dispositivos: Desktop PC en oficina (Windows 10, Chrome)
- Conectividad: Red LAN corporativa (alta velocidad)

---

## 2. Perfil del Stakeholder

### 2.1 Informacion del Stakeholder

| Atributo | Valor |
|----------|-------|
| **Nombre/Rol** | Agente de Call Center |
| **Departamento/Area** | Operaciones / Atencion al Cliente |
| **Nivel jerarquico** | Operacional |
| **Experiencia tecnica** | Baja (usuario basico de software) |
| **Frecuencia de interaccion con sistema** | Diaria (8 horas/dia) |
| **Canales de acceso** | Desktop (Windows 10, Chrome) |
| **Idioma preferido** | Espanol |
| **Necesidades de accesibilidad** | No |

### 2.2 Contexto de Trabajo del Stakeholder

**Entorno de trabajo:**
Piso de call center con 50-100 estaciones de trabajo. Ambiente con ruido de fondo, multiples llamadas simultaneas, presion por cumplir metas de atencion.

**Flujo de trabajo tipico (inicio de turno):**
1. Agente llega a estacion de trabajo 5 minutos antes de inicio de turno
2. Enciende PC (si esta apagado) o activa pantalla
3. **Abre navegador Chrome y accede a IACT**
4. **Ingresa username y password**
5. **Hace clic en "Iniciar sesion"**
6. **Sistema autentica y redirige a dashboard (DEBE SER RAPIDO)**
7. Agente activa estatus "Disponible" en softphone
8. Sistema comienza a enrutar llamadas a agente
9. Agente atiende primera llamada del turno

**Requisito encaja en pasos 3-6**: Proceso de login debe ser menor 2 segundos.

**Herramientas que usa actualmente:**
- Sistema IACT (dashboard de metricas y reportes)
- Softphone para atencion de llamadas
- CRM corporativo (Salesforce)
- Herramientas internas de chat

**Puntos de dolor actuales:**
- Login lento (4-6 segundos) genera frustracion al inicio del turno
- Ocasionalmente debe reintentar login por timeout
- Sesion expira cada 30 minutos de inactividad (debe volver a autenticarse)
- Percepcion de sistema "antiguo" y "lento"

---

## 3. Criterios de Aceptacion del Stakeholder

### 3.1 Criterios en Formato Gherkin

#### Escenario 1: Login exitoso rapido al inicio de turno

```gherkin
Given soy un agente de call center con credenciales validas
 And abro navegador Chrome y accedo a URL de IACT
 And la pantalla de login se carga correctamente
When ingreso mi username "carlos.rodriguez"
 And ingreso mi password correcta
 And hago clic en boton "Iniciar sesion"
Then el sistema valida mis credenciales
 And el sistema me redirige al dashboard principal
 And el tiempo total desde clic en "Iniciar sesion" hasta ver dashboard es menor a 2 segundos
 And no veo pantallas de carga prolongadas ni spinners por mas de 1 segundo
 And veo mi nombre y rol en header del dashboard
```

#### Escenario 2: Reautenticacion tras sesion expirada

```gherkin
Given estoy autenticado en IACT
 And mi sesion expiro por inactividad (30 minutos sin uso)
When intento acceder a cualquier pantalla del sistema
Then el sistema detecta que mi sesion expiro
 And el sistema me redirige a pantalla de login
 And veo mensaje: "Tu sesion expiro. Por favor inicia sesion nuevamente."
When ingreso nuevamente mis credenciales validas
Then el sistema me autentica en menos de 2 segundos
 And me redirige a la pantalla que estaba intentando acceder (no a dashboard inicial)
```

#### Escenario 3: Login rapido incluso con alta concurrencia

```gherkin
Given son las 8:00 AM (inicio de turno matutino)
 And 50 agentes intentan iniciar sesion simultaneamente
When ingreso mis credenciales validas durante este pico de uso
Then el sistema me autentica en menos de 2 segundos
 And la concurrencia no degrada el performance del login
 And no experimento timeouts ni errores por sobrecarga
```

### 3.2 Criterios de Satisfaccion del Stakeholder

El stakeholder considerara este requisito satisfactorio cuando:

- **Performance consistente**: 95% de logins en menos de 2 segundos (P95)
- **Sin timeouts**: Tasa de exito de login mayor a 99.5%
- **Experiencia fluida**: No hay pantallas de carga molestas ni delays perceptibles
- **Confirmacion visual**: Feedback inmediato al hacer clic en "Iniciar sesion"
- **Reduccion de quejas**: De 15-20 tickets/mes a menos de 2 tickets/mes

---

## 4. Valor para el Stakeholder

### 4.1 Beneficios Directos

| Beneficio | Descripcion | Impacto | Medicion |
|-----------|-------------|---------|----------|
| Inicio de turno mas rapido | Ahorrar 2-4 segundos por login × 3 logins/dia = 6-12 seg/dia | Medio | Encuesta satisfaccion usuario |
| Menos frustracion | Percepcion de sistema moderno y eficiente | Alto | NPS usuarios internos |
| Mayor productividad | Comenzar a atender llamadas mas rapido | Medio | Metricas de atencion |

### 4.2 Impacto en el Trabajo del Stakeholder

**Antes (sin este requisito):**
- Tiempo invertido: 4-6 segundos por login × 3 logins/dia = 12-18 seg/dia
- Errores: 1-2% de logins fallan por timeout
- Frustracion: 15-20 tickets/mes de quejas sobre performance

**Despues (con este requisito):**
- Tiempo invertido: Menor 2 segundos por login × 3 logins/dia = menor 6 seg/dia (reduccion 50-70%)
- Errores: Menor 0.5% de logins fallan
- Satisfaccion: Menos de 2 tickets/mes (reduccion 90%)

### 4.3 Costo de NO tener este Requisito

**Para el stakeholder:**
- Frustracion diaria al inicio de turno
- Percepcion de sistema ineficiente
- Perdida de tiempo acumulada (6-12 segundos/dia × 200 usuarios = 1200-2400 seg/dia = 20-40 min/dia)

**Para el negocio:**
- 293 horas/mes de tiempo perdido en logins lentos (costo: $7.3K/mes a $25/hora)
- 15-20 tickets/mes de soporte (costo: $1.5K/mes en atencion)
- Moral de equipo afectada por percepcion de herramientas ineficientes

---

## 5. Derivacion a Requisitos de Sistema/Software

### 5.1 Requisitos Funcionales Derivados

Este requisito de stakeholder se implementa mediante:

- **RF-001**: Login con credenciales username/password
 - Dominio: backend
 - Relacion: Proceso de validacion debe ser optimizado para menos de 2 seg

- **RF-002**: Generacion de tokens JWT
 - Dominio: backend
 - Relacion: Generacion de tokens debe ser rapida (menos de 100ms)

### 5.2 Requisitos No Funcionales Derivados

- **RNF-001**: Tiempo de respuesta login menor 2 segundos (P95)
 - Medicion: Desde POST /api/v1/auth/login hasta respuesta HTTP 200
 - Target: 95% de requests en menos de 2000ms
 - Incluye: Validacion credenciales + generacion JWT + respuesta

---

## 6. Trazabilidad

### 6.1 Trazabilidad Upward (Origen)

Este requisito de stakeholder deriva de:

| Tipo | ID | Titulo | Justificacion |
|------|----|----|---------------|
| Necesidad | [N-001](../necesidades/n001_autenticacion_robusta_prevenir_fraude.md) | Prevenir accesos fraudulentos | RS-002 balancea seguridad con usabilidad |
| Req. Negocio | [RN-001](../negocio/rn001_sistema_autenticacion_seguro_prevencion_fraude.md) | Sistema autenticacion seguro | RS-002 asegura que controles de seguridad no degraden experiencia de usuario |

### 6.2 Trazabilidad Downward (Implementacion)

Este requisito se implementa mediante:

**Requisitos Funcionales:**
- [RF-001](../funcionales/rf001_login_credenciales.md) - Login con credenciales
- [RF-002](../funcionales/rf002_jwt_tokens.md) - Tokens JWT

**Requisitos No Funcionales:**
- [RNF-001](../no_funcionales/rnf001_tiempo_respuesta_login.md) - Performance login

---

## 7. Aprobaciones

| Rol | Nombre | Fecha | Firma/Estado |
|-----|--------|-------|--------------|
| **Stakeholder Primario** | Representante Agentes | 2025-11-06 | Aprobado |
| **Product Owner** | Product Manager | 2025-11-06 | Aprobado |
| **Business Analyst** | BA Lead | 2025-11-06 | Documentado |

---

## Control de Cambios

| Version | Fecha | Autor | Descripcion del Cambio | Stakeholder Notificado |
|---------|-------|-------|------------------------|------------------------|
| 1.0 | 2025-11-06 | BA Team | Creacion inicial validada con agentes de call center | Si |
