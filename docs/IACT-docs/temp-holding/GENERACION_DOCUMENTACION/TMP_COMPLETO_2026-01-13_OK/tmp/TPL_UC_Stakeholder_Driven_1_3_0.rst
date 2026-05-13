.. meta::
   :Proyecto: IACT
   :Codigo: UC-IACT-MOD-NN
   :Titulo: Nombre del Use Case
   :Version: 4.0.0
   :Actor_Principal: Rol del Actor
   :Tipo: Normal|CRUD|Temporal|UI-Driven
   :Derivado_De: Entrevista con Stakeholder
   :Fecha: YYYY-MM-DD
   :Autor: Nombre del Business Analyst
   :Estado: DRAFT|REVIEW|APPROVED|IMPLEMENTED

======================================================================
UC-IACT-MOD-NN: Nombre del Use Case
======================================================================

**Proyecto:** IACT - IVR Analytics & Customer Tracking  
**Actor Principal:** Rol del Actor Principal  
**Tipo:** Normal|CRUD|Temporal|UI-Driven  
**Derivado De:** Entrevista con Stakeholder - Nombre del Stakeholder  
**Estado:** DRAFT|REVIEW|APPROVED|IMPLEMENTED  
**Prioridad:** Alta|Media|Baja  
**Clasificacion:** C2 - INTERNAL

----------------------------------------------------------------------
INTRODUCCION AL TEMPLATE
----------------------------------------------------------------------

Este template documenta Use Cases que se derivan de narrativas de
stakeholders, tipicamente obtenidas en entrevistas, workshops o
sesiones de elicitacion de requisitos.

**Cuando Usar Este Template:**

Use este template cuando:

1. El UC surge de entrevista con stakeholder
2. Tiene transcripcion o notas de la conversacion
3. Necesita documentar el proceso de extraccion de requisitos
4. Quiere mantener trazabilidad desde narrativa informal a UC formal
5. El stakeholder describe el proceso en sus propias palabras

**Cuando NO Usar Este Template:**

NO use este template para:

- UC derivados de documentacion tecnica existente
- UC derivados de analisis de sistema legacy
- UC que no tienen origen en narrativa de stakeholder

**Valor de Documentar la Narrativa:**

Mantener la narrativa original del stakeholder tiene multiples
beneficios:

1. **Trazabilidad:** Conexion clara entre lo que pidio el stakeholder
   y lo que se implemento
2. **Validacion:** Stakeholder puede revisar su narrativa y confirmar
   que se entendio correctamente
3. **Contexto:** Futuras modificaciones entienden el "por que"
4. **Requisitos ocultos:** La narrativa puede revelar requisitos
   implicitos que no se documentarian en UC formal
5. **Prioridad:** El lenguaje del stakeholder indica prioridades

**Estructura de Este Template:**

1. Contexto del Stakeholder
2. Narrativa Original (transcripcion)
3. Extraccion de Requisitos
4. Mapeo a Componentes de UC
5. UC Formal Resultante

----------------------------------------------------------------------
1. CONTEXTO DEL STAKEHOLDER
----------------------------------------------------------------------

**Proposito:**

Documentar quien es el stakeholder y por que su input es relevante.

**Stakeholder:**

- Nombre completo: Nombre y Apellido
- Rol/Cargo: Titulo del puesto
- Area/Departamento: Departamento de la organizacion
- Email: email@ejemplo.com
- Telefono: Opcional
- Anos en la organizacion: Experiencia

**Fecha de Elicitacion:**

- Fecha: YYYY-MM-DD
- Hora: HH:MM
- Duracion: X minutos/horas

**Metodo de Elicitacion:**

- Entrevista presencial
- Reunion virtual (Zoom, Teams, etc)
- Workshop grupal
- Email/documento escrito
- Observacion directa

**Participantes:**

- Stakeholder(s): Nombre(s)
- Business Analyst(s): Nombre(s)
- Otros: Roles adicionales

**Referencia Documental:**

- Acta de reunion: Archivo o link
- Grabacion: Link si aplica
- Notas: Archivo de notas
- Documento enviado: Si stakeholder envio doc

**EJEMPLO COMPLETO (UC-RPT-01):**

**Stakeholder:**

- Nombre: Maria Rodriguez
- Rol: Gerente de Operaciones
- Area: Call Center Operations
- Email: maria.rodriguez@iact.com
- Telefono: +52 55 1234 5678
- Anos en organizacion: 8 anos

**Biografia Breve:**

Maria ha trabajado en call centers por 15 anos, ultimos 8 en IACT.
Responsable de un equipo de 50 agentes y 5 supervisores. Maneja
metricas operacionales diarias y reporta a Direccion General
mensualmente.

**Fecha de Elicitacion:**

- Fecha: 2024-11-15
- Hora: 10:00 AM
- Duracion: 90 minutos

**Metodo:**

Entrevista presencial en oficina de Maria, formato semi-estructurado.

**Participantes:**

- Stakeholder: Maria Rodriguez (Gerente Operaciones)
- Business Analyst: Carlos Martinez
- Observador: Ana Lopez (Product Owner)

**Referencia Documental:**

- Acta: ACTA_REUNION_OPS_2024_11_15.docx
- Notas: Notas_Entrevista_Maria_RPT.md
- Email confirmacion: "RE: Requerimientos Performance Reportes"
  enviado 2024-11-16

**Objetivo de la Sesion:**

Entender necesidades de reportes operacionales para metricas IVR
y problemas actuales con performance del sistema de consultas.

----------------------------------------------------------------------
2. NARRATIVA ORIGINAL DEL STAKEHOLDER
----------------------------------------------------------------------

**Proposito:**

Capturar la narrativa del stakeholder en sus propias palabras,
lo mas literal posible.

**Formato:**

Usar formato de transcripcion con:

- BA: Business Analyst
- Stakeholder: Nombre del stakeholder
- Obs: Observaciones del analista

**NARRATIVA COMPLETA (UC-RPT-01):**

**Contexto Inicial:**

BA: "Maria, gracias por recibirnos. Nos gustaria entender mejor
como trabajas con los reportes de metricas IVR y que problemas
enfrentas actualmente."

Maria: "Con gusto. Mira, yo necesito sacar reportes de metricas del
IVR constantemente. Principalmente veo metricas trimestrales porque
asi reporto a direccion, pero a veces necesito mensual o incluso
semanal si hay algun problema."

BA: "Que tipo de metricas especificamente?"

**Descripcion de Metricas:**

Maria: "Lo basico: cuantas llamadas tuvimos, cuantas se completaron,
cuantas se abandonaron. Eso es critico porque el abandono es un KPI
que direccion me mide mucho. Si la tasa de abandono sube mucho,
tengo que dar explicaciones."

Maria: "Tambien veo la duracion promedio de las llamadas porque me
ayuda a planear staffing. Si las llamadas duran mas de lo normal,
necesito mas agentes."

Obs: Maria menciona que direccion le pide tasa de abandono menor
al 15%. Actualmente estan en 12-13%.

**Proceso Actual:**

BA: "Como generas estos reportes hoy?"

Maria: "Entro al sistema, voy a la seccion de reportes, lleno un
formulario con el trimestre que quiero, el ano, y el segmento.
Nosotros trabajamos con dos segmentos: OP que son las operaciones
normales, y MG que son llamadas de management."

Maria: "Luego le doy en Generar Reporte y espero... y a veces espero
mucho."

BA: "Cuanto tiempo esperas?"

**Problema Principal:**

Maria: "Ahi esta el problema! A veces son 3-4 segundos y esta bien,
pero otras veces se tarda 20, 30 segundos, o peor, se cuelga el
sistema y me dice timeout. Eso es muy frustrante porque pierdo
tiempo y a veces tengo que hacer el reporte urgente para una junta."

Maria: "Y no soy solo yo. Mis supervisores tambien sacan reportes
y cuando varios estamos sacando reportes al mismo tiempo, el sistema
se pone lentisimo para todos."

BA: "Cuando suele pasar esto de los timeouts?"

Maria: "Principalmente cuando pido reportes de todo un trimestre
o de todo el ano. Por ejemplo, si pido Q3 completo, son como 90
dias de datos, miles de llamadas, y ahi es cuando truena."

**Propuesta de Maria:**

BA: "Que te gustaria que pasara en esos casos?"

Maria: "Pues mira, entiendo que si voy a pedir un reporte muy grande,
va a tardar. Lo que me gustaria es que el sistema me avise antes
de intentar ejecutarlo. Que me diga 'oye Maria, esto va a retornar
muchos datos, seguro lo quieres?'"

Maria: "Y mejor aun, si es muy grande, que me pida aprobacion. Por
ejemplo, que le mande notificacion a mi supervisor para que el
autorice la consulta grande. Porque a veces mis analistas piden
reportes de todo el ano cuando en realidad solo necesitan un mes.
Si yo pudiera revisar eso antes, evitariamos cargar el sistema."

BA: "Entiendo. Y que seria 'muy grande' para ti?"

**Definicion de Umbral:**

Maria: "Mmm, buena pregunta. Yo diria que si va a retornar mas de
10,000 registros, ya es grande. La mayoria de nuestros reportes
normales del dia a dia tienen menos de eso. Los trimestrales normales
tienen como 5,000-8,000 llamadas. Pero cuando alguien pide todo
el ano o parametros muy amplios, pueden ser 30,000, 50,000 registros,
y ahi es cuando hay problemas."

BA: "Perfecto. Y si el sistema requiere aprobacion, quien deberia
aprobar?"

Maria: "Deberia ser el supervisor del analista que esta pidiendo
el reporte. En mi caso, yo soy supervisora de 5 personas, entonces
si ellos piden algo grande, yo deberia aprobar. Y si yo pido algo
grande, deberia ser mi jefe quien apruebe."

**Flujo Deseado:**

BA: "Describenos como te gustaria que funcionara este flujo."

Maria: "Ok, imaginalo asi: Yo entro al sistema, lleno el formulario
con trimestre Q3, ano 2024, segmento OP. Le doy en Generar Reporte."

Maria: "El sistema primero calcula cuantos registros va a retornar.
Si son menos de 10,000, perfecto, ejecuta la consulta y me muestra
los resultados en una tabla y graficos como siempre."

Maria: "Pero si son mas de 10,000, en lugar de intentar ejecutar y
tronarse, el sistema me muestra un mensaje que dice 'Tu consulta
va a retornar 25,000 registros (o los que sean), requiere aprobacion
de supervisor. Hemos enviado la solicitud.' Y me muestra a quien
se le envio."

Maria: "Luego mi supervisor recibe una notificacion en su bandeja
de entrada del sistema, ve los detalles de mi consulta, y puede
aprobarla o rechazarla. Si la aprueba, el sistema ejecuta el reporte
y me notifica que ya esta listo. Si la rechaza, me notifica tambien
y me explica por que."

BA: "Y cuanto tiempo esperarias para la aprobacion?"

Maria: "Pues depende de la urgencia. Lo normal seria 2-4 horas.
Si es urgente, le puedo llamar a mi supervisor por telefono y el
puede aprobar mas rapido."

**Beneficios Esperados:**

BA: "Y que beneficios ves con este cambio?"

Maria: "Varios. Primero, el sistema no se va a congelar o dar
timeouts tan seguido porque vamos a controlar las consultas grandes.
Segundo, yo voy a poder revisar que mis analistas realmente necesiten
reportes tan grandes antes de que los ejecuten, eso evita consultas
innecesarias. Tercero, podemos programar consultas grandes para
horarios de baja carga, como 6-7 AM, para no afectar a otros usuarios."

**Cierre:**

BA: "Excelente Maria, esto es muy claro. Alguna otra cosa que
agregar sobre reportes?"

Maria: "Solo que me gustaria poder exportar los reportes a Excel
para compartirlos con direccion. Ahorita tengo que hacer screenshots
o copiar y pegar en Excel manualmente."

BA: "Perfecto, lo notamos. Gracias por tu tiempo."

----------------------------------------------------------------------
3. EXTRACCION DE REQUISITOS
----------------------------------------------------------------------

**Proposito:**

Analizar la narrativa y extraer elementos estructurados: actores,
pasos, reglas de negocio, requisitos funcionales y no funcionales.

**Metodologia:**

1. Leer narrativa completa
2. Marcar conceptos clave (actores, acciones, condiciones, datos)
3. Identificar verbos → Acciones/Pasos
4. Identificar sustantivos → Entidades/Datos
5. Identificar condicionales → Reglas de negocio
6. Identificar frustraciones → Requisitos no funcionales

**EXTRACCION COMPLETA (UC-RPT-01):**

**Actores Identificados:**

.. list-table::
   :header-rows: 1
   :widths: 25 50 25

   * - Actor
     - Evidencia en Narrativa
     - Rol en UC
   * - Analista de Operaciones
     - "Yo entro al sistema", "lleno el formulario"
     - Actor Principal
   * - Supervisor de Area
     - "mi supervisor recibe notificacion", "puede aprobar"
     - Actor Secundario
   * - Sistema Analytics
     - "el sistema calcula", "ejecuta la consulta"
     - Actor Secundario

**Pasos/Acciones Identificadas:**

.. list-table::
   :header-rows: 1
   :widths: 10 40 50

   * - Paso
     - Texto de Narrativa
     - Accion Extraida
   * - 1
     - "lleno un formulario con trimestre"
     - Usuario ingresa parametros (trimestre, ano, segmento)
   * - 2
     - "Le doy en Generar Reporte"
     - Usuario hace click en boton Generar
   * - 3
     - "sistema primero calcula cuantos registros"
     - Sistema ejecuta COUNT para estimar volumen
   * - 4
     - "Si son menos de 10,000, ejecuta la consulta"
     - Sistema evalua umbral y decide flujo
   * - 5
     - "me muestra los resultados en tabla y graficos"
     - Sistema muestra reporte con visualizaciones
   * - 6
     - "muestra un mensaje que dice 'requiere aprobacion'"
     - Sistema notifica necesidad de aprobacion
   * - 7
     - "supervisor recibe notificacion"
     - Sistema envia notificacion a supervisor
   * - 8
     - "puede aprobarla o rechazarla"
     - Supervisor toma decision
   * - 9
     - "el sistema ejecuta el reporte y me notifica"
     - Sistema ejecuta tras aprobacion y notifica

**Reglas de Negocio Identificadas:**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Regla
     - Evidencia en Narrativa
   * - BR-IACT-028: Aprobacion Consultas Grandes
     - "si va a retornar mas de 10,000 registros, ya es grande", "requiere aprobacion de supervisor"
   * - BR-IACT-053: Calculo Tasa Abandono
     - "cuantas se abandonaron", "tasa de abandono es un KPI", "menor al 15%"
   * - Umbral = 10,000 registros
     - "si va a retornar mas de 10,000 registros"
   * - Supervisor aprueba
     - "deberia ser el supervisor del analista"

**Datos/Entidades Identificadas:**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Entidad/Campo
     - Evidencia en Narrativa
   * - Trimestre
     - "trimestre que quiero", "Q3 completo"
   * - Ano
     - "el ano", "ano 2024"
   * - Segmento
     - "OP operaciones normales, MG management"
   * - Total Llamadas
     - "cuantas llamadas tuvimos"
   * - Llamadas Completadas
     - "cuantas se completaron"
   * - Llamadas Abandonadas
     - "cuantas se abandonaron"
   * - Tasa Abandono
     - "tasa de abandono es un KPI"
   * - Duracion Promedio
     - "duracion promedio de las llamadas"

**Requisitos No Funcionales:**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - RNF
     - Evidencia en Narrativa
   * - Performance: Tiempo Respuesta
     - "a veces son 3-4 segundos y esta bien", "20, 30 segundos es malo"
   * - Usabilidad: Prevenir Timeouts
     - "se cuelga el sistema y me dice timeout. Eso es muy frustrante"
   * - Usabilidad: Mensajes Claros
     - "que me avise antes", "me muestra un mensaje que dice"
   * - Performance: Evitar Sobrecarga
     - "cuando varios estamos sacando reportes, el sistema se pone lentisimo"

**Requisitos Funcionales Derivados:**

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - FR ID
     - Descripcion
   * - FR-RPT-01-01
     - Validar formato de parametros (trimestre, ano, segmento)
   * - FR-RPT-01-04
     - Calcular COUNT de registros antes de ejecutar query principal
   * - FR-RPT-01-05
     - Evaluar si count excede umbral de 10,000
   * - FR-RPT-01-06
     - Ejecutar query principal si count menor o igual 10,000
   * - FR-RPT-01-08
     - Generar graficos visuales (tabla, graficos)
   * - FR-RPT-01-10
     - Crear solicitud de aprobacion si count mayor 10,000
   * - FR-RPT-01-11
     - Notificar a supervisor sobre solicitud aprobacion
   * - FR-RPT-01-12
     - Exportar reporte a Excel

----------------------------------------------------------------------
4. MAPEO A COMPONENTES DE UC
----------------------------------------------------------------------

**Proposito:**

Transformar la narrativa informal en componentes formales de UC.

**Mapeo de Narrativa → UC:**

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Elemento de Narrativa
     - Componente de UC
   * - "Yo entro al sistema, lleno formulario"
     - Actor Principal + Trigger
   * - "trimestre, ano, segmento"
     - Parametros/Inputs
   * - "Le doy en Generar Reporte"
     - Trigger especifico
   * - "sistema calcula... si son menos de 10,000"
     - Flujo Normal pasos 3-4
   * - "ejecuta la consulta"
     - Flujo Normal paso 5
   * - "me muestra resultados"
     - Flujo Normal paso 6
   * - "si son mas de 10,000"
     - Condicion para Flujo Alterno
   * - "muestra mensaje requiere aprobacion"
     - Flujo Alterno FA-2
   * - "supervisor recibe notificacion"
     - Flujo Alterno FA-2 continuacion
   * - "se cuelga el sistema, timeout"
     - Flujo de Excepcion FE-1
   * - "mas de 10,000 registros"
     - Business Rule BR-IACT-028
   * - "tasa de abandono menor 15%"
     - Business Rule BR-IACT-053
   * - "3-4 segundos esta bien"
     - RNF Performance p95 menor 5 seg
   * - "exportar a Excel"
     - Extension del UC o UC relacionado

**Transformacion Narrativa → Pasos Formales:**

.. list-table::
   :header-rows: 1
   :widths: 50 50

   * - Narrativa Informal
     - Paso Formal de UC
   * - "lleno un formulario con trimestre Q3"
     - 1. Usuario selecciona parametros de consulta en formulario
   * - "Le doy en Generar Reporte"
     - 2. Usuario hace click en boton "Generar Reporte"
   * - "sistema calcula cuantos registros"
     - 3. Sistema ejecuta COUNT para estimar volumen (FR-RPT-01-04)
   * - "Si son menos de 10,000, ejecuta"
     - 4. Sistema evalua resultado del count (FR-RPT-01-05)
   * - "ejecuta la consulta"
     - 5. Sistema ejecuta query principal (FR-RPT-01-06)
   * - "me muestra resultados en tabla"
     - 6. Sistema muestra resultados en tabla y graficos (FR-RPT-01-08)

**Identificacion de Flujos Alternos:**

.. list-table::
   :header-rows: 1
   :widths: 50 50

   * - Condicion en Narrativa
     - Flujo Alterno
   * - "si son mas de 10,000"
     - FA-2: Consulta Requiere Aprobacion
   * - "supervisor puede rechazarla"
     - FA-3: Supervisor Rechaza Consulta
   * - "se cuelga, timeout"
     - FE-1: Timeout de Base de Datos

----------------------------------------------------------------------
5. UC FORMAL RESULTANTE
----------------------------------------------------------------------

**Proposito:**

Mostrar como la narrativa se convierte en un UC completo y formal.

**UC-IACT-RPT-01: Consultar Reporte Trimestral**

**Actor Principal:** Analista de Operaciones

**Derivado De:**
Entrevista con Maria Rodriguez (Gerente Operaciones) - 2024-11-15

**Precondiciones:**

PC-1: Usuario autenticado en el sistema

PC-2: Usuario tiene permiso RPT-001

PC-3: Segmento valido existe en catalogo

**Trigger:**

Usuario hace click en menu "Reportes > Metricas Trimestrales"

**Flujo Normal:**

1. Usuario selecciona parametros de consulta en formulario:
   - Trimestre: Q1, Q2, Q3, Q4
   - Ano: 2020 a ano actual
   - Segmento: OP o MG

2. Sistema valida formato de parametros (FR-RPT-01-01)

3. Usuario hace click en boton "Generar Reporte"

4. Sistema muestra mensaje "Calculando volumen de datos..."
   (FR-RPT-01-02)

5. Sistema ejecuta COUNT para estimar volumen de registros
   (FR-RPT-01-04)
   
   Implementa BR-IACT-028: Aprobacion Consultas Grandes

6. Sistema evalua resultado del count (FR-RPT-01-05)
   
   Si count menor o igual 10,000 → Continua paso 7
   Si count mayor 10,000 → FA-2: Requiere Aprobacion

7. Sistema ejecuta query principal de reporte (FR-RPT-01-06)

8. Sistema procesa resultados y calcula metricas derivadas
   (FR-RPT-01-07)
   
   Implementa BR-IACT-053: Calculo Tasa Abandono

9. Sistema genera graficos visuales (FR-RPT-01-08)

10. Sistema muestra tabla de resultados con graficos (FR-RPT-01-09)

11. Sistema registra consulta en audit log (FR-RPT-01-10)

12. UC termina exitosamente

**Flujos Alternos:**

FA-2: Consulta Requiere Aprobacion del Supervisor

En paso 6, si count mayor 10,000 registros:

  6a. Sistema NO ejecuta query principal
  
  6b. Sistema crea solicitud de aprobacion (FR-RPT-01-11)
  
  6c. Sistema identifica supervisor del usuario
  
  6d. Sistema notifica a supervisor (FR-RPT-01-12)
  
  6e. Sistema muestra modal al usuario:
      
      "Su consulta requiere aprobacion del supervisor debido al
      volumen de datos (count registros).
      
      Le notificaremos cuando sea aprobada o rechazada.
      
      Tiempo estimado: 2-4 horas."
  
  6f. Usuario hace click en OK
  
  6g. UC termina, usuario debe esperar aprobacion

**Flujos de Excepcion:**

FE-1: Timeout de Base de Datos

En paso 7, si query principal no responde en 30 segundos:

  7a. Sistema cancela query
  
  7b. Sistema registra error en log
  
  7c. Sistema muestra mensaje al usuario:
      
      "La consulta tardo demasiado. Intente reducir el rango de
      fechas o consultar en horario de menor carga."
  
  7d. UC termina con falla

**Postcondiciones:**

Exito:
- Reporte generado y mostrado
- Audit log actualizado

Falla:
- Log de error registrado
- Usuario ve mensaje descriptivo

**RNF:**

RNF-Performance-1: Tiempo de respuesta p95 menor 5 segundos

RNF-Performance-2: Consultas hasta 10K registros sin degradacion

RNF-Usabilidad-1: Mensajes claros y accionables

**Reglas de Negocio:**

BR-IACT-028: Aprobacion de Consultas Grandes (umbral 10,000)

BR-IACT-053: Calculo de Tasa de Abandono

----------------------------------------------------------------------
REFERENCIAS
----------------------------------------------------------------------

**Estandares:**

- STD_001_Estandares_Documentacion_1_1_0.rst
- NOM_001_Nomenclatura_Proyecto_2_0_0.rst

**Material Pedagogico:**

- PARTE_2_Documentar_Use_Cases_IACT_1_0_0.md
- PARTE_0_Elicitacion_Requisitos_1_0_0.md (si existe)

**Documentos Relacionados:**

- ACTA_REUNION_OPS_2024_11_15.docx
- Notas_Entrevista_Maria_RPT.md
- UC-IACT-RPT-01-Consultar-Reporte-Trimestral-4-0-0.rst (UC formal)

----------------------------------------------------------------------

.. note::
   CHECKLIST STAKEHOLDER-DRIVEN:
   
   - Contexto del stakeholder completo
   - Narrativa original transcrita literalmente
   - Extraccion de requisitos sistematica:
     * Actores identificados
     * Pasos/acciones extraidos
     * Reglas de negocio marcadas
     * Datos/entidades listados
     * RNF capturados
   - Mapeo narrativa → componentes UC
   - UC formal resultante completo
   - Trazabilidad clara desde narrativa a UC

----------------------------------------------------------------------

**Archivo:** TPL_UC_Stakeholder_Driven_1_3_0.rst  
**Version Template:** 1.3.0  
**Fecha Creacion Template:** 2026-01-11  
**Autor Template:** Sistema de Regeneracion IACT  
**Lineas Totales:** aproximadamente 600
