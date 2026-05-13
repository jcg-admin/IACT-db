```yml
created_at: 2026-05-01 06:33:29
project: IACT-docs
work_package: 2026-05-01-06-33-29-uc-auth-01-analisis
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Borrador
version: 1.0.0
language: es
target_uc: UC_AUTH_01
methodology_source: source/base-cognitiva/_uml/uml-06-introduccion-casos-uso.rst
```

# Análisis UC_AUTH_01 — desde UML_06 (introducción a casos de uso)

> Análisis del UC más fundamental del catálogo IACT
> aplicando la metodología introductoria de
> :doc:`/base-cognitiva/_uml/uml-06-introduccion-casos-uso`.
> Foco: vista del usuario, actores, escenarios
> candidatos, inclusiones / extensiones,
> beneficiarios. **No** desarrolla flujos
> detallados — ese trabajo va en otro WP.

----

## 1. Encuadre del UC en el sistema

UC_AUTH_01 "Iniciar Sesion" es la **entrada
universal** al sistema IACT. Su existencia es
condición previa para que cualquier otro caso
de uso operativo (59 de los 61) pueda ejecutarse
— no porque otros UCs lo invoquen como
``<<include>>`` (no lo hacen), sino porque
**la pre-condición de sesión activa**
(transversal T-01 según
:doc:`/arquitectura-tecnica/matriz-dependencias-uc-iact`)
existe únicamente como consecuencia de este UC.

En vocabulario de UML_06: este UC inicia un
**escenario** que produce un resultado de valor
(``Session.state = ACTIVE``) que el resto del
sistema consume como pre-condición.

## 2. Punto de vista del usuario

UML_06 enfatiza que la finalidad del análisis de
casos de uso es comprender **lo que el usuario
intenta hacer**, no lo que el sistema sabe hacer.
Para UC_AUTH_01 las preguntas clave son:

- **¿Qué quiere el usuario al iniciar la
  interacción?** Acceder al sistema con su
  identidad. No quiere "validar credenciales" —
  eso es lo que el sistema hace; el usuario
  quiere "entrar a IACT para hacer su trabajo".
- **¿Qué obtiene cuando el caso de uso termina
  con éxito?** Una sesión utilizable que le da
  acceso a las funcionalidades autorizadas
  según su perfil. Puede ver el dashboard, los
  reportes, las alertas, la auditoría — todo
  según las funciones RBAC asignadas.
- **¿Qué obtiene si falla?** Un mensaje claro de
  por qué no entró: credenciales incorrectas,
  cuenta bloqueada por throttling, password
  expirado, primer login con cambio forzado, o
  cuenta inactiva.

El **valor entregado** (en lenguaje UML_06)
no es "tokens JWT generados", sino "acceso
funcional al sistema". Los tokens son el
**mecanismo**, no el resultado para el usuario.

## 3. Actores

UML_06 define al **actor** como toda entidad
(persona, sistema, hardware, lapso de tiempo) que
**inicia** una secuencia y/o se beneficia de
ella.

### 3.1 Actor primario

**Usuario** (cualquier usuario registrado en el
sistema). Es quien inicia la secuencia.

Sub-tipos según el perfil operativo (AccessGroup
del modelo de dominio). Los nombres canónicos
viven en
:doc:`/arquitectura-tecnica/rbac/modelo-rbac-iact`
v5.4.0 catálogo de agrupadores (líneas 1090-1135):

- ``AGR-001 basic_operator_group`` — utiliza
  IACT para tareas operativas básicas (ver
  dashboard, ver alertas activas).
- ``AGR-002 report_viewer_group`` — maneja
  reportes históricos y vistas guardadas.
- ``AGR-003 quality_supervisor_group`` — opera
  reportes específicos, programa, comparte,
  reconoce alertas.
- ``AGR-004 data_exporter_group`` — exporta
  datos.
- ``AGR-005 alert_manager_group`` — configura
  umbrales y suscripciones.
- ``AGR-006 user_admin_group`` — administra
  usuarios.
- ``AGR-007 permission_admin_group`` —
  administra funciones RBAC.
- ``AGR-008 auditor_group`` — consulta
  auditoría inmutable.
- ``AGR-009 pipeline_admin_group`` — supervisa
  ETL.
- ``AGR-010 system_admin_group`` — administra
  infraestructura y monitoreo técnico.

> **Hallazgo H-A06-06 (OBSERVABLE) — deuda
> técnica de naming en cuerpos de UCs**: el
> cuerpo de varios UCs vigentes en
> ``source/requisitos/casos-uso/`` cita los AGR
> en español residual (``agr_operador_basico``,
> ``agr_supervisor``, ``agr_admin_acceso``,
> ``agr_admin_usuarios``, ``agr_admin_pipeline``,
> etc.). Estos nombres son obsoletos respecto al
> catálogo canónico inglés de
> ``modelo-rbac-iact.rst`` v5.4.0. Es deuda
> análoga a la que Z.1.C resolvió para nombres
> de funciones RBAC (de ``crea_usuarios`` a
> ``create_users``) pero **no aplicada** a los
> nombres descriptivos de los agrupadores.
> Recomendación: WP de saneamiento posterior
> (similar a Z.1.C) que normalice todos los
> cuerpos de UCs y artefactos relacionados al
> catálogo canónico inglés.

UC_AUTH_01 es **público en su acceso** (cualquier
usuario registrado puede invocarlo). El AGR del
usuario sólo determina **qué puede hacer
después** de iniciada la sesión, no si puede
iniciarla.

### 3.2 Actor secundario

**Sistema** — entidad interna que valida
credenciales, consulta el catálogo de usuarios,
genera tokens JWT, registra el evento de
auditoría, y aplica las reglas de sesión única
(CNST-003) y throttling (CNST-011).

UML_06 reconoce el sistema como actor cuando
ejecuta validaciones automáticas que no son
acciones del usuario sino del proceso —
exactamente el rol del Sistema aquí.

### 3.3 Actor temporal implícito

**Caducidad de sesión** (CNST-002). UML_06
admite "el paso del tiempo" como actor — para
UC_AUTH_01 esta dimensión es explícita: la
sesión generada por este UC tiene una duración
limitada, tras la cual se invalida y se requiere
re-invocación de UC_AUTH_01.

## 4. Conjunto candidato de escenarios

UML_06 sugiere que cada caso de uso es una
**colección de situaciones** sobre el uso del
sistema; cada escenario es una secuencia de
eventos. Para UC_AUTH_01 se identifican los
siguientes escenarios candidatos (sin desarrollar
flujos):

### 4.1 Escenario nominal — login exitoso de usuario activo

El usuario presenta credenciales válidas; su
cuenta está activa; las restricciones CNST-003
(sesión única) y CNST-011 (throttling) se
satisfacen. Se genera Session válida y se
registra evento ``LOGIN`` en AuditEvent.

### 4.2 Escenarios alternos

Variaciones que **no son falla**, sino caminos
distintos hacia el éxito o hacia un siguiente
caso de uso:

- **FA-01 Primer login con cambio forzado**:
  el usuario ingresa por primera vez; CNST-003
  exige cambio de contraseña inmediato. La
  secuencia de UC_AUTH_01 desemboca en
  ``<<extend>>`` hacia UC_AUTH_04.
- **FA-02 Password próximo a expirar**: el
  sistema detecta ventana de aviso y ofrece al
  usuario cambiar contraseña; si el usuario
  acepta, ``<<extend>>`` hacia UC_AUTH_04. Si
  declina, sesión continúa.
- **FA-03 Sesión previa activa (CNST-003)**: el
  usuario ya tiene una Session activa en otro
  dispositivo; el sistema cierra la anterior
  (por CNST-003 sesión única) y crea la nueva.

### 4.3 Escenarios de excepción

Caminos hacia falla con diagnóstico claro:

- **EX-01 Usuario inexistente**: el username no
  está en el catálogo.
- **EX-02 Password incorrecto**: incrementa el
  contador de intentos fallidos.
- **EX-03 Cuenta bloqueada por throttling
  (CNST-011)**: 5 intentos fallidos en 5
  minutos.
- **EX-04 Cuenta inactiva**: ``User.state =
  INACTIVE`` (BR-009 v2.0.0 soft-delete).
- **EX-05 Cuenta bloqueada manualmente**:
  ``User.state = BLOCKED``.

Total: 1 nominal + 3 alternos + 5 excepciones =
**9 escenarios candidatos**.

## 5. Inclusiones (``<<include>>``) y extensiones (``<<extend>>``)

UML_06 distingue dos formas de relación entre
casos de uso: **inclusión** (un caso de uso
**siempre** ejecuta los pasos de otro como parte
de su secuencia) y **extensión** (un caso de uso
**sólo a veces** agrega pasos de otro, según
una condición).

### 5.1 Inclusiones de UC_AUTH_01

UC_AUTH_01 **no incluye** otros casos de uso del
catálogo IACT — sus pasos internos (validar
credenciales, generar tokens, registrar
auditoría) son operaciones del UC mismo, no UCs
separados. Esto es deliberado: subdividirlo en
UCs ``<<include>>`` agregaría ruido sin valor
analítico.

### 5.2 Extensiones de UC_AUTH_01

UC_AUTH_01 **es extendido por** UC_AUTH_04
"Cambiar Contrasena" en dos escenarios alternos:

- **FA-01 Primer login**: extensión obligatoria
  (CNST-003).
- **FA-02 Password próximo a expirar**:
  extensión opcional con consentimiento.

Estas extensiones están bien tipificadas porque
sus condiciones de activación son claras
(``User.first_login = true`` o
``Password.expires_at within window``).

### 5.3 Lo que UC_AUTH_01 produce y otros consumen

Aunque UC_AUTH_01 no es invocado vía
``<<include>>`` por otros UCs (la dependencia
T-01 se modela como pre-condición declarada en
CNST-003, no como flecha de inclusión), su
**efecto** — la Session activa — es consumido por
**todos** los UCs operativos no públicos.

UML_06 prefiere no abusar de ``<<include>>``
cuando la pre-condición es transversal: para
IACT, el middleware Auth (T-01) materializa esta
relación a nivel de infraestructura, no de
diagrama UC.

## 6. Componentes y resultado de valor

UML_06 establece que un caso de uso debe
producir **algo de valor** para el actor que lo
inicia o para otro.

| Aspecto | UC_AUTH_01 |
|---------|------------|
| Actor que inicia | Usuario registrado |
| Trigger | El usuario quiere ingresar a IACT |
| Resultado de valor | Sesión activa que habilita el resto del trabajo del usuario |
| Beneficiarios secundarios | Sistema (puede ahora ejecutar UCs autenticados); Auditor (queda registro inmutable de la entrada) |
| Resultado en caso de falla | Mensaje diagnóstico que permite al usuario corregir (volver a intentar, recuperar contraseña, contactar admin) |

Esta tabla coincide con la definición de UML_06:
**el caso de uso produce un resultado utilizable
y deja en claro qué es ese resultado** — aquí no
hay ambigüedad.

## 7. Vista del usuario y comunicación con stakeholders

UML_06 enfatiza que los casos de uso son
**vehículo de comunicación** entre analista y
usuario, no documento técnico. Por eso UC_AUTH_01
debería ser entendible por:

- **Un nuevo operador** del call center, que
  necesita saber cómo entrar al sistema.
- **Un product owner** que decide políticas de
  contraseña.
- **Un auditor** que verifica el cumplimiento de
  CNST-025.

El nombre canónico — "Iniciar Sesion" — es
intencionadamente neutro y no técnico: no es
"Autenticar JWT" ni "Validar Credenciales", sino
la acción humana que el usuario reconoce.

## 8. Análisis de riesgos del UC

Riesgos específicos identificados en este UC
(complementan los riesgos transversales del
sistema):

- **R-A01 Credenciales en flujo claro**: si el
  flujo no usa HTTPS, las credenciales viajan
  expuestas. Mitigado por la política
  obligatoria de HTTPS (declarada en
  ADR-DEVOPS-001).
- **R-A02 Brute force**: contramedida en
  CNST-011 (5 intentos / 5 minutos throttling).
- **R-A03 Sesión robada**: mitigado parcialmente
  por CNST-002 (caducidad TTL corto) y CNST-003
  (sesión única — invalida sesiones anteriores
  al iniciar una nueva).
- **R-A04 Primer login sin cambio de
  contraseña**: violaría CNST-003. La extensión
  FA-01 es **obligatoria**, no opcional —
  decisión de diseño que debe verificarse en el
  flujo.

## 9. Decisiones pendientes para Stage 7 DESIGN

Decisiones que el WP siguiente (cuando se
desarrollen los flujos completos) debe resolver
con criterio explícito:

- **D-A01 Mensaje genérico vs específico en
  excepciones**: ¿el sistema dice "credenciales
  incorrectas" para EX-01 y EX-02 (anti
  enumeración de usernames) o diferencia entre
  "usuario no existe" y "password incorrecto"?
  La práctica de seguridad recomienda mensaje
  genérico; revisar contra usabilidad.
- **D-A02 Implementación de throttling
  (CNST-011)**: por IP, por username, o
  combinado. Decisión técnica que afecta el
  flujo de excepción.
- **D-A03 Cómo se entrega el aviso de password
  próximo a expirar (FA-02)**: ¿al login (cuando
  CNST-001 prohíbe email externo)? ¿en
  InternalMailbox post-login?
- **D-A04 Comportamiento ante CNST-003 con
  sesión activa de otro dispositivo**: ¿se
  notifica al usuario que la otra sesión se va
  a invalidar? ¿se le pide confirmación?

## 10. Trazabilidad

- UC vigente:
  ``source/requisitos/casos-uso/auth/uc-auth-01-iniciar-sesion.rst``
  v4.0.0.
- Metodología:
  :doc:`/base-cognitiva/_uml/uml-06-introduccion-casos-uso`
  v1.0.0.
- Modelo de dominio: ``Session``, ``User``,
  ``InternalMailbox``, ``AuditEvent`` —
  :doc:`/arquitectura-tecnica/modelo-dominio-iact` v1.0.0.
- Constraints: CNST-001, CNST-002, CNST-003,
  CNST-011, CNST-025.
- Matriz dependencias:
  :doc:`/arquitectura-tecnica/matriz-dependencias-uc-iact`
  § 1.2.1 (CRÍTICO), § 4.3 (T-01 detalle).
- Función RBAC: pública (post-login establece
  AUTH-001 ``view_own_sessions``).

## 11. Hallazgos del análisis

| ID | Tipo | Descripción |
|----|------|-------------|
| H-A06-01 | OBSERVABLE | UC_AUTH_01 produce el efecto T-01 que 59 UCs consumen como pre-condición; sin embargo no aparece como ``<<include>>`` en ninguno. La relación se modela como pre-condición transversal en CNST-003, no como flecha del diagrama UC. Coherente con la guía UML_06 (no abusar de ``<<include>>`` cuando es pre-condición transversal). |
| H-A06-02 | OBSERVABLE | UC_AUTH_01 tiene 9 escenarios candidatos (1 nominal + 3 alternos + 5 excepciones). Es el UC con mayor diversidad de caminos del cluster AUTH. Esto justifica su Complejidad MEDIA (5 días estimados) y su criticidad. |
| H-A06-03 | OBSERVABLE | Las dos extensiones (FA-01 y FA-02) hacia UC_AUTH_04 son del tipo ``<<extend>>`` correctamente — la condición de activación es objetiva y verificable (``first_login = true`` o ``expires_at within window``). |
| H-A06-04 | INFERRED | El nombre canónico "Iniciar Sesion" cumple con el principio de UML_06 de comunicación con usuarios no técnicos. Cambiarlo a algo como "Autenticar Usuario" empeoraría la comunicación. Decisión preservada. |
| H-A06-05 | OBSERVABLE | Las 4 decisiones pendientes (D-A01..D-A04) afectan principalmente seguridad y UX; ninguna afecta el modelo de dominio canónico. Esto significa que el modelo está estable; lo que cambia con la decisión es el detalle del flujo, no las clases. |

Cero SPECULATIVE. Gate I-012 satisfecho.

## 12. Próximo paso

Análisis complementario en
``analyze/uc-auth-01-analisis-uml-07.md``:
representación gráfica del UC, secuencia de
pasos en los escenarios, relaciones tipificadas
en notación de diagrama, lugar de UC_AUTH_01 en
el proceso de análisis del sistema.
