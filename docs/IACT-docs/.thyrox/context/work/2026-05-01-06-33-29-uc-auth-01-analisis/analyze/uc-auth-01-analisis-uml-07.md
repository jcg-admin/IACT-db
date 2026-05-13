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
methodology_source: source/base-cognitiva/_uml/uml-07-diagramas-casos-uso.rst
```

# Análisis UC_AUTH_01 — desde UML_07 (diagramas de casos de uso)

> Análisis complementario al
> ``uc-auth-01-analisis-uml-06.md``. Aplica la
> metodología de **diagramas** de
> :doc:`/base-cognitiva/_uml/uml-07-diagramas-casos-uso`.
> Foco: representación gráfica, secuencia de
> pasos en escenarios, notación de relaciones,
> lugar del UC en el proceso de análisis del
> sistema. **No** desarrolla la spec completa
> del UC.

----

## 1. Representación gráfica del UC

UML_07 establece la notación canónica del
diagrama de caso de uso: una **elipse** para el
UC, una **figura agregada** para cada actor, una
**línea asociativa** para la comunicación, y un
**rectángulo** para el confín del sistema.

Aplicada a UC_AUTH_01 esta notación produce el
diagrama mínimo:

.. uml::

   @startuml
   !include ../../../../source/_static/plantuml-styles.puml

   left to right direction

   actor "Usuario\n(registrado)" as U
   actor "Sistema" as S <<system>>
   actor "Auditor" as A

   rectangle "IACT — MOD_Auth" {
     usecase "UC_AUTH_01\nIniciar Sesion" as UC01
   }

   U  --> UC01 : credenciales
   UC01 --> S  : valida + emite tokens
   UC01 --> A  : registra evento LOGIN
   @enduml

Lectura del diagrama:

- El actor **Usuario** está a la izquierda
  porque **inicia** la secuencia.
- El actor **Sistema** y el actor **Auditor**
  están a la derecha porque **reciben** valor —
  el Sistema obtiene una sesión que registrar y
  proteger; el Auditor obtiene un evento
  inmutable más en el log.
- El rectángulo "IACT — MOD_Auth" delimita el
  confín del sistema. El UC vive dentro; los
  actores fuera.

Nota práctica: el diagrama vigente del UC
(``uc-auth-01-iniciar-sesion.rst`` § 3) incluye
sub-pasos dentro del rectángulo (Validar
Credenciales, Generar Tokens JWT, Cerrar
Sesiones Anteriores, Registrar Auditoria). UML_07
**desaconseja** esa práctica para el diagrama
canónico — esos sub-pasos son detalles del flujo,
no UCs separados. La descomposición correcta es:
diagrama UC con un único nodo, y los sub-pasos
en el diagrama de secuencia / actividad
posterior. Ver § 6 (decisiones para diseño).

## 2. Secuencia de pasos en los escenarios

UML_07 enseña que **cada UC es una colección de
escenarios** y que **cada escenario es una
secuencia de pasos** que **no aparecen en el
diagrama UC**, sino en otros artefactos
(diagrama de secuencia, actividad, tabla
narrativa).

Para UC_AUTH_01 los **9 escenarios candidatos**
identificados en el análisis UML_06 § 4 se
representan como secuencias de pasos
independientes. Ejemplo del **escenario nominal**
(sin desarrollar a nivel de implementación, sólo
como secuencia conceptual):

::

   1. Usuario presenta credenciales (username, password)
   2. Sistema localiza al Usuario en el catálogo
   3. Sistema verifica que la cuenta esté en estado ACTIVE
   4. Sistema valida el password (hash bcrypt)
   5. Sistema chequea contador de intentos (CNST-011)
   6. Sistema cierra sesiones anteriores del Usuario
      (CNST-003 sesión única)
   7. Sistema crea Session nueva (state = ACTIVE)
   8. Sistema emite tokens JWT (access + refresh)
   9. Sistema registra AuditEvent LOGIN (CNST-025)
   10. Usuario recibe respuesta con tokens y queda en sesión

Cada escenario alterno y de excepción tiene su
propia secuencia. UML_07 enfatiza que estos
pasos **no se ponen en el diagrama** — viven en
el documento del UC bajo secciones "Flujo
Normal", "Flujos Alternos", "Excepciones".

## 3. Relaciones entre casos de uso

UML_07 define dos relaciones entre UCs:

- ``<<include>>`` — flecha discontinua que
  apunta al UC incluido (siempre se ejecuta).
- ``<<extend>>`` — flecha discontinua que
  apunta al UC extendido (sólo se ejecuta bajo
  condición).

Para UC_AUTH_01 las relaciones identificadas
(consistentes con el análisis UML_06 § 5) se
notan como:

.. uml::

   @startuml
   !include ../../../../source/_static/plantuml-styles.puml

   left to right direction

   actor "Usuario" as U

   rectangle "IACT — MOD_Auth" {
     usecase "UC_AUTH_01\nIniciar Sesion" as UC01
     usecase "UC_AUTH_04\nCambiar\nContrasena" as UC04
   }

   U --> UC01

   UC04 ..> UC01 : <<extend>>\n[primer login\no expirado]

   note bottom of UC04
     Extiende UC_AUTH_01 cuando:
     - User.first_login = true (CNST-003), o
     - Password.expires_at within window
   end note

   @enduml

Lectura:

- La flecha ``<<extend>>`` va **desde** UC_AUTH_04
  **hacia** UC_AUTH_01 (UC_AUTH_04 es la
  extensión, UC_AUTH_01 el extendido). UML_07
  insiste en esta dirección — es contraintuitivo
  para muchos lectores y debe verificarse en
  cada redacción.
- La condición de activación está en una nota
  adjunta (no en el diagrama mismo) per UML_07.
- No hay flecha ``<<include>>`` saliendo de
  UC_AUTH_01: ningún sub-paso interno se modela
  como UC separado.

### 3.1 Lo que NO está en el diagrama (decisión)

UC_AUTH_01 **no muestra** la dependencia
transversal T-01 (sesión activa requerida por
otros 59 UCs) ni T-02 (verificación de permiso).
Estas dependencias no son ``<<include>>`` —
existen como pre-condiciones declaradas en
constraints (CNST-003, CNST-030) y materializadas
en middleware. Incluirlas como flechas saturaría
el diagrama de los 59 UCs no públicos sin valor
analítico.

UML_07 admite explícitamente esta separación:
las dependencias transversales se modelan en
otros tipos de diagrama (componentes, despliegue)
o como restricciones declaradas, no en el
diagrama UC.

## 4. Confín del sistema (system boundary)

UML_07 dedica énfasis al **rectángulo del confín
del sistema** porque marca qué está dentro
(modelado como UCs) y qué está fuera (modelado
como actores).

Para UC_AUTH_01 el confín del sistema IACT
contiene:

- El UC ``UC_AUTH_01 Iniciar Sesion`` (objeto
  del diagrama).
- Servicios internos invocados por el UC:
  ``UsernameGenerator``, ``PasswordValidator``,
  ``TokenService``, ``InternalMessage``,
  ``UserActionLog`` (presentes en el diagrama
  de secuencia del UC vigente, no en este
  diagrama UC).
- La base de datos analítica (donde se
  persisten ``Session`` y ``AuditEvent``).

Fuera del confín:

- El **Usuario** (humano).
- El **Sistema externo** que opera como actor
  validador (LDAP corporativo si se integra,
  proveedor de SSO si aplica — fuera de scope
  v1.0 del producto).
- Los servicios de **infraestructura** que no
  son objeto del análisis funcional (Apache,
  mod_wsgi, MySQL — quedan en ADR-DEVOPS-001).

## 5. Lugar de UC_AUTH_01 en el proceso de análisis del sistema

UML_07 sitúa los diagramas UC en una fase
temprana del proceso de análisis: tras
identificar el conjunto candidato de UCs y los
actores, y antes del diseño detallado.

Para IACT, UC_AUTH_01 ocupa un lugar singular en
ese proceso:

- **Es un UC de "infraestructura
  funcional"** — no resuelve un problema de
  negocio del call center (eso lo hacen
  UC_RPT_*, UC_ALR_*, UC_PIP_*) sino un problema
  de habilitación. Sin él, ninguno de los UCs
  de negocio puede ejecutarse.
- **Es la pieza que tradicionalmente se
  documenta primero** porque toca actores
  externos directamente y porque su
  comportamiento es relativamente
  estandarizado.
- **Su diagrama es el más pequeño** del
  catálogo (un único UC más una extensión hacia
  UC_AUTH_04). Su complejidad real está en los
  flujos internos (9 escenarios), no en sus
  relaciones con otros UCs.

## 6. Decisiones de diagrama pendientes para Stage 7 DESIGN

El UC vigente
(``uc-auth-01-iniciar-sesion.rst`` § 3) incluye
**5 nodos UC** dentro del rectángulo del sistema:

::

   usecase "UC_AUTH_01\nIniciar Sesion"           as UC01
   usecase "Validar\nCredenciales"                as VAL
   usecase "Generar\nTokens JWT"                  as TOK
   usecase "Cerrar Sesiones\nAnteriores"          as CLOSE
   usecase "Registrar\nAuditoria"                 as AUD

Y conecta UC01 con cada uno vía ``<<include>>``.

Este modelado **no sigue UML_07**. Los cuatro
sub-nodos (Validar, Generar, Cerrar, Registrar)
no son UCs — son **pasos del flujo** o
**operaciones internas** del UC_AUTH_01. Modelar
cada uno como UC separado:

- Sobrecarga el diagrama.
- Sugiere falsamente que cada uno es un caso de
  uso autónomo (lo cual implicaría que un actor
  podría iniciarlos directamente).
- Confunde la separación entre vista de UC y
  vista de secuencia / actividad.

### Decisión propuesta

**D-A07-01**: en una próxima iteración del UC
(no en este WP), reemplazar los 4 sub-nodos por:

- Una sola elipse para UC_AUTH_01.
- Las cuatro operaciones (validar, generar,
  cerrar, registrar) trasladadas al diagrama de
  secuencia (sección 6 del UC vigente, ya
  presente).
- Una nota adjunta al UC con las invariantes
  (CNST-003, CNST-011, CNST-025).

Esto alinearía el UC con UML_07 y reduciría
ruido sin pérdida de información.

### Decisión propuesta

**D-A07-02**: añadir un actor ``<<system>>``
explícito (Sistema) y un actor ``<<system>>``
secundario (Auditor) en el diagrama UC, ambos a
la derecha como **beneficiarios**. UML_07
admite múltiples actores receptores; el diagrama
vigente sólo muestra al Usuario y al Sistema, y
omite al Auditor pese a que CNST-025 lo declara
beneficiario directo del evento LOGIN.

## 7. Aplicación al modelo IACT

UML_07 cierra con el principio de que los
diagramas UC son **una vista entre varias** del
mismo modelo del sistema. Para UC_AUTH_01 las
otras vistas relevantes son:

| Vista | Documento del UC vigente | Cubre |
|-------|--------------------------|-------|
| Diagrama UC | § 3 | Actores y relaciones inter-UC (este análisis) |
| Diagrama de secuencia | § 6 | Pasos en orden temporal del escenario nominal |
| Diagrama de actividad | § 9 | Decisiones y bifurcaciones del flujo (decision points) |
| Tabla de flujos alternos | § 7 | Texto narrativo de FA-01, FA-02 |
| Tabla de excepciones | § 8 | Texto narrativo de EX-01..EX-05 |
| Trazabilidad | § 13 | Vínculos a BR, FR, CNST, clases del modelo |

Las cinco vistas son **consistentes entre sí**
(o deberían serlo). El presente WP analítico no
las reescribe, sólo identifica qué dice UML_07
sobre la primera (diagrama UC) y qué decisiones
quedan pendientes.

## 8. Hallazgos del análisis

| ID | Tipo | Descripción |
|----|------|-------------|
| H-A07-01 | OBSERVABLE | El diagrama UC vigente de UC_AUTH_01 modela 4 sub-pasos como UCs separados con ``<<include>>``. UML_07 desaconseja esa práctica para sub-pasos del flujo. Decisión propuesta: D-A07-01. |
| H-A07-02 | OBSERVABLE | El diagrama vigente omite al Auditor como beneficiario explícito; CNST-025 lo declara como receptor del evento LOGIN. Decisión propuesta: D-A07-02. |
| H-A07-03 | OBSERVABLE | La extensión hacia UC_AUTH_04 está bien modelada en el diagrama vigente (la flecha ``<<extend>>`` va de UC_AUTH_04 hacia UC_AUTH_01, dirección correcta per UML_07). |
| H-A07-04 | OBSERVABLE | Las dependencias transversales T-01 y T-02 no aparecen en el diagrama UC ni deberían — su lugar canónico son las restricciones declaradas (CNST-003, CNST-030) y la documentación de middleware. Coherente con UML_07. |
| H-A07-05 | INFERRED | El diagrama UC mínimo de UC_AUTH_01 (1 elipse + 1 extensión) es consistente con la sencillez relativa del UC en el catálogo: aunque es CRÍTICO por su universalidad, su grafo de relaciones inter-UC es pequeño. La complejidad vive en los escenarios internos, no en las relaciones externas. |

Cero SPECULATIVE. Gate I-012 satisfecho.

## 9. Trazabilidad

- Metodología:
  :doc:`/base-cognitiva/_uml/uml-07-diagramas-casos-uso`
  v1.0.0.
- UC vigente:
  ``source/requisitos/casos-uso/auth/uc-auth-01-iniciar-sesion.rst``
  v4.0.0 § 3 (diagrama de caso de uso).
- Análisis hermano:
  ``uc-auth-01-analisis-uml-06.md`` (en este
  mismo WP).
- Modelo de dominio: ``Session``, ``User``,
  ``InternalMailbox``, ``AuditEvent``,
  ``Function``, ``Assignment`` —
  :doc:`/arquitectura-tecnica/modelo-dominio-iact`
  v1.0.0.
- Constraints: CNST-001, CNST-002, CNST-003,
  CNST-011, CNST-025, CNST-030.
- Matriz dependencias:
  :doc:`/arquitectura-tecnica/matriz-dependencias-uc-iact`
  § 1.2.1, § 4 (T-01, T-02, T-03).

## 10. Síntesis del WP

Este WP cierra con dos análisis complementarios
sobre UC_AUTH_01:

- ``uc-auth-01-analisis-uml-06.md`` —
  introductorio: actores, escenarios candidatos,
  inclusiones / extensiones, valor entregado al
  usuario.
- ``uc-auth-01-analisis-uml-07.md`` (este
  archivo) — diagramático: notación,
  representación gráfica, confín del sistema,
  decisiones pendientes para iteración futura
  del diagrama UC.

Ningún flujo detallado, ningún diagrama de
secuencia / actividad / estados se desarrolló en
este WP — esos pertenecen a otro WP de
especificación completa, posterior y separado.

Las **decisiones D-A06-01..D-A06-04** del primer
análisis y **D-A07-01..D-A07-02** del segundo
forman el insumo a esa fase de spec completa
cuando se abra.
