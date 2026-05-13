Identificación y Modelado Avanzado de Casos de Uso - 5b45
UID: 20251207235535593839
date: 2025-12-07


## FASE 2: Identificación y Profundización en Diagramas UML de Casos de Uso

Vamos a ver lo que es **identificando **_Casos de Uso_**:** cómo **identificar** estos **_Casos de Uso_**. Es decir, desde el momento en que nos dan un **problema** o tenemos una **problemática**, cómo nosotros **descomponer** esta **problemática** y empezar a **identificar** los **_Casos de Uso_**. Vamos a **profundizar** sobre los *_Diagramas UML de **_Casos de Uso_**_. La clase pasada estuvimos profundizando sobre la **Especificación de **_Casos de Uso_**; ahora vamos a profundizar sobre *_Diagramas UML de **_Casos de Uso_**_.

### **Métodos para la Identificación de Casos de Uso**

¿Cómo es la **identificación de **_Casos de Uso_****?

La mayoría de los autores establecen, comentan o proponen que existen **diferentes maneras** de poder *_identificar **_Casos de Uso_**_:

#### **1. Identificación Basada en Actores (Actor-Goal Identification)**

La primera forma es **identificando primero los Actores**. Una vez que nosotros identificamos los **Actores** de un **sistema** o de una **problemática**, empezamos a **exponer** o a tratar de **buscar** lo que son los **procesos del negocio** y la **relación** que va a existir entre estos **Actores** y estos **procesos**. A partir de esto, nosotros **definimos** los **_Casos de Uso_**.

- **Procedimiento:**
    
    1. Identificar a los **Actores** relacionados en el **proceso del negocio**.
        
    2. Buscar las **actividades** de estos **Actores** en esos **procesos**.
        
    3. A partir de ahí, identificar los **_Casos de Uso_**.
        

#### **2. Identificación Basada en Escenarios**

Otra forma de que nosotros podemos identificar **_Casos de Uso_** es a través de la **creación de Escenarios**. Es decir, nosotros tenemos la **problemática** y, a partir de esta **problemática**, empezamos a **crear Escenarios** para **ilustrar cada uno de los procesos** de este **negocio**.

- **Procedimiento:**
    
    1. Crear los **Escenarios**.
        
    2. A través de estos **Escenarios**, localizar lo que son los **_Casos de Uso_**.
        
    3. Identificar los **Actores** que están involucrados en este **_Caso de Uso_**.
        
    
    - Abordamos la problemática **al revés**: creamos los **Escenarios**, y a partir de estos **Escenarios** identificamos los **Actores**.
        

#### **3. Identificación por Descripción de Procesos de Negocio**

Otra manera de identificar **_Casos de Uso_** es utilizando una **descripción de procesos de negocio**.

- **Procedimiento:**
    
    1. Preguntarnos: **¿Qué tareas se deben de realizar para completar este proceso o convertir estas entradas en salidas?**
        
    2. A partir de este **análisis**, desglosar los **_Casos de Uso_**.
        

#### **4. Identificación Basada en Eventos Externos**

Otra manera de identificar **_Casos de Uso_** es **identificar eventos externos a los que el sistema debe de responder** y **relacionar** estos **eventos** con **Actores participantes** y **_Casos de Uso_** **específicos**.

- **Procedimiento:**
    
    1. Nuestro **contexto** va hacia **afuera**.
        
    2. Identificar los **eventos** que pueden ocurrir en el proceso.
        
    3. A partir de estos **eventos**, relacionar con los **Actores** que existen y los **_Casos de Uso_** **específicos**.
        

#### **5. Identificación Mediante Análisis CRUD (Create, Read, Update, Delete)** 🏆

Una de las maneras **más sencillas** o **más utilizadas** para poder identificar **_Casos de Uso_** es la siguiente (una de las que más se utiliza):

- Hacer un **análisis CRUD**.
    
- **Análisis CRUD:** Identificar **entidades de datos** que requieran **_Casos de Uso_** para: **Crear (Create)**, **Leer (Read)**, **Actualizar (Update)**, **Eliminar (Delete)** o **Manipular datos**.
    
- A partir de este análisis, se identifican los **_Casos de Uso_**.
    

Otra manera es **examinando el **_Diagrama de Contexto_** y preguntar: ¿Qué objetivos quieren lograr cada una de estas entidades externas con la ayuda del sistema?**

En sí, la manera **más utilizada**, como se comenta, es utilizando un **análisis CRUD**. También pueden empezar haciéndolo con lo que viene siendo **identificar primero los Actores**.

---

### **Procedimiento Básico para la Identificación**

El **procedimiento básico** es el siguiente:

1. **Elegir el Límite del Sistema:** Delimitar el sistema (es solo una aplicación móvil, de escritorio, web, o implica hardware y software).
    
2. **Identificar los Actores Principales:** Aquellos que tienen **metas de usuario** que se cumplen mediante el uso de los **servicios del sistema** (o aquellos que van a estar **ejecutando** los **_Casos de Uso_**).
    
3. **Identificar los Objetivos para cada Actor Principal:** ¿Qué es lo que ellos van a recibir a cambio o el **valor** que van a tener a través de la ejecución de estos **_Casos de Uso_**?
    
4. **Definir los Casos de Uso:** Aquellos que **satisfagan** esos **objetivos**. Al momento en que el **Actor** ejecute este **_Caso de Uso_**, debe estar **relacionado** con el **objetivo** que él quiere hacer. Debemos de **nombrarlos de acuerdo al objetivo**.
    

> **Nota:** Los **Actores** y las **Metas** dependen del **alcance** y los **límites del sistema**.

Vamos a analizar este **diagrama** que tenemos aquí.

En el **centro**, tenemos lo que viene siendo un **_Sistema de Punto de Venta_**, el cual tiene un **alcance** que viene siendo este.

- En este **alcance** está relacionado un **Actor** (el **Cajero**). El **Cajero** actúa sobre este **Punto de Venta**; este es su **alcance**.
    
    - El **objetivo** del **Cajero** o su **alcance** es **procesar las ventas** sobre el **Punto de Venta**.
        
- Pero, viéndolo hacia **afuera**, tenemos que este **Punto de Venta** está dentro de **otro sistema** o un **servicio** llamado **Check-Out** o de **Salida** o de **Venta de Productos**, y está relacionado con un **Actor** que es un **_Sistema de Actividad de Ventas_**.
    
    - El objetivo del **_Sistema de Actividad de Ventas_** es **analizar las ventas** y el **desempeño de los datos** sobre el **Servicio de Check-Out**.
        
- Estos otros dos **Actores** actúan o tienen su **alcance** sobre un **_Sistema Empresarial de Vender Cosas_**, que a su vez se relaciona con estos **Actores** o **sistemas**.
    
    - ¿Cuáles son los **objetivos** de estos **Actores superiores**? Uno es (supongamos, esta que es como tipo **Agencia de Impuestos** o de **Impuestos sobre la venta**): su **objetivo** es **recolectar los impuestos sobre ventas**.
        
    - Otro es el **Cliente** y su **objetivo** es **comprar artículos**.
        

**Conclusión:** Los **Actores** y las **Metas** dependen del **alcance** y los **límites del sistema** con el que están interactuando.

> **Pregunta:** ¿Los Actores deben ser personas o pueden ser sistemas como programas?

> **Respuesta:** Pueden ser **Actores** como **personas** y también pueden ser como **sistemas** o **programas** o **aplicaciones** o **bases de datos**. También pueden ser **Actores**.

Como lo vemos en el ejemplo:

- Este **Actor** es un **Sistema** (**_Sistema de Actividad de Ventas_**).
    
- Este otro **Actor** **no es un sistema** ni una **persona**, pero es una **entidad** o una **institución** que, en este caso, viene siendo la **Agencia de Recolección de Impuestos de Ventas**. Viéndolo aquí en México sería como **Hacienda**. **Hacienda** viene siendo un **Actor** sobre un **sistema para vender cosas**.
    

---

## 📐 Profundización en Diagramas UML de Casos de Uso

Vamos a profundizar sobre los *_Diagramas UML de **_Casos de Uso_**_.

### **UML: Un Lenguaje de Modelado Estándar**

Como acordamos, los **Diagramas UML** tienen **14 tipos de diagramas**, divididos en **dos grandes categorías**:

1. **Categoría de Estructura (Structural):** Diagramas de **Clases**, **Componentes**, **Objetos**, **Paquetes**, **Composición**, etc.
    
2. **Categoría de Comportamiento (Behavioral):** Diagramas de **Actividades**, **_Casos de Uso_**, **Secuencia**, **Estado**, **Interacción**, etc.
    

|**Categoría**|**Ejemplos de Diagramas**|
|---|---|
|**Estructural**|Clases, Componentes, Objetos, Paquetes|
|**Comportamiento**|Actividades, **Casos de Uso**, Secuencia, Estado|

#### **¿Qué es UML?**

**UML** (**_Unified Modeling Language_**) es un **Lenguaje de Modelado Unificado**. Se trata de un **lenguaje estandarizado** de **diseño de software** de **uso general**.

- **Estandarizado:** La forma en que nosotros lo utilicemos es la manera en que lo van a estar utilizando en otras organizaciones; es el **estándar para el mundo**.
    
- **Creado por:** El **Object Management Group (OMG)**.
    
- **Incluye:** Un conjunto de **técnicas de notación gráfica** (Ojo aquí: **Notación Gráfica**) para **crear modelos visuales de sistemas de software** orientados a **objetos**.
    
- **Utilidad:** **UML** incluye *_Diagramas de **_Casos de Uso_**_, que son **útiles para especificar los requerimientos de usuario**.
    

Cuando nosotros hablamos de un **_Modelo de Casos de Uso Completo_**, decimos que este está compuesto de:

$$\text{Modelo de Caso de Uso Completo} = \text{Diagrama UML de Caso de Uso} + \text{Especificación de Caso de Uso}$$

### **Componentes y Relaciones Clave en Diagramas UML**

Vamos a analizar lo que son los **Diagramas de **_Casos de Uso_** a profundidad**.

#### **1. Límite del Sistema y Actores**

En este ejemplo tenemos el **Límite del Sistema**, que viene siendo un **Punto de Venta**. Está delimitado por nuestro **rectángulo**.

- Dentro, tenemos un **Cajero**, que viene siendo un **Actor**.
    
- Este **Actor** puede ejecutar lo que son el **_Caso de Uso_** para **Escanear Artículos** y el **_Caso de Uso_** para **Totalizar Artículos**.
    

#### **2. Asociaciones (Associations)**

Dentro de los **Diagramas UML**, tenemos lo que son llamadas las **Asociaciones** (las líneas entre **Actor** y el **_Caso de Uso_**).

- **Definición:** **Resumen las interacciones gráficamente**. Los **Actores** y los **_Casos de Uso_** **intercambian información** para lograr la meta, pero los **detalles de la interacción no se muestran**.
    
- **Significado:** La **Asociación** significa que el **Actor** está **participando** o **comunicando** con el **sistema** vía el **_Caso de Uso_**.
    
- **Notación:** Se denota como una **flecha simple**. Es el tipo de **relación más básica** que indica la **invocación** desde un **Actor** o **_Caso de Uso_** a **otra operación** u *_otro **_Caso de Uso_**_.
    

#### **3. Dependencia o Instanciación (Dependency)**

- **Definición:** Es una **forma muy particular de relación** entre **clases**, en la cual **una clase depende de otra** (es decir, se **instancia** o se **crea**).
    
- **Notación:** Dicha relación se denota con una **flecha punteada**. (Esto se ve en la **Programación Orientada a Objetos** cuando hacemos una **instanciación de una clase**).
    

#### **4. Generalización (Generalization) / Herencia**

Este tipo de **relaciones** es uno de los **más utilizados** y cumple una **doble función**:

1. **De Uso (Use):** `<<include>>` o `<<extend>>`.
    
2. **De Herencia (Inheritance):** **Generalización/Especialización** de Actores o Casos de Uso.
    

> **Importante:** Esta relación (Generalización de Uso) está orientada exclusivamente para **_Casos de Uso_** y **no para Actores**.

**Relaciones entre Casos de Uso:**

|**Relación**|**Propósito**|**Notación/Punto Clave**|
|---|---|---|
|**<<extend>>**|Se utiliza cuando un **_Caso de Uso_** es **similar** a otro o sus **características son similares**. **Agrega** o **reemplaza** comportamiento de otro.|Requiere un **punto de extensión** y una **condición**.|
|**<<include>>**|Se utiliza cuando se tiene un **conjunto de características similares** en *_más de un **_Caso de Uso_**_ y se desea **reutilizar** la descripción de la característica.|Permite **reusar la funcionalidad**. La **flecha va del **_Caso de Uso_** que incluye hacia el **_Caso de Uso_** incluido**.|

Los **_Casos de Uso_** que usan estas relaciones se llaman **_Casos de Uso Secundarios_** o de **Soporte**.

### **Consideraciones Visuales y Buenas Prácticas**

Un **Diagrama de **_Casos de Uso_** es una excelente fotografía del contexto del sistema**, porque a través de un simple diagrama mostramos todo el contexto.

|**Elemento**|**Buena Práctica / Notación**|
|---|---|
|**Actores Humanos**|Se ilustra a través de un **"monito de palo"** (Stick Figure).|
|**Actores No Humanos/Sistemas**|Se ilustra a través de un **rectángulo**. (Sigue siendo un Actor, pero este es un sistema de recursos humanos, por ejemplo).|
|**Estereotipos**|Utilizar **Estereotipos** (`<<actor>>`) para categorizar los elementos.|
|**Posición de Actores**|Los **Actores Principales** dentro de un diagrama se ponen del **lado izquierdo**. Los **Actores de Soporte** (Secundarios) al **lado derecho**.|

> **Nota sobre Posición:** Si bien es una **buena práctica** poner a los Actores Principales a la izquierda y Secundarios a la derecha, la **dirección de la flecha** es lo que **define su rol** (Actor $\to$ UC = Primario; UC $\to$ Actor = Secundario).

#### **Especialización de Actores (Inheritance)**

Un **Actor** puede ser una **especialización** de otro.

- **Notación:** Una **flecha direccionada** apunta hacia el **Actor general** (el **padre**).
    

**Ejemplo de Especialización de Actores:**

Fragmento de código

```
[ Actor General: Staff de Ventas ]  <-- (Especialización) -- [ Actor Especializado: Administrador ]
```

Esto significa que el **Administrador** es una **especialización** de otro **Actor** de tipo **Staff de Ventas**. El **Administrador** sigue siendo parte del **Staff de Ventas**, pero tiene una **especialización** (otros atributos o comportamientos).

- _Analogía:_ Es como la **herencia** en la **Programación Orientada a Objetos**. Un **Usuario Premium** se **especializa** de un **Usuario Normal**; hereda todas sus características, pero añade otras.
    

#### **Generalización de Casos de Uso (Herencia)**

La **Generalización** (herencia y especialización) indica que **un **_Caso de Uso_** es simplemente un tipo especial de otro**.

**Ejemplo de Generalización (Especialización de Pago):**

Fragmento de código

```
                      [ UC: Aceptar Pago ]
                               ^
                              /|\
                            /  |  \
                          /    |    \
 [ UC: Aceptar Efectivo ] [ UC: Aceptar Cheque ] [ UC: Aceptar Tarjeta de Crédito ]
```

El **Cajero** está relacionado con el **_Caso de Uso_** **Aceptar Pago**. Los **_Casos de Uso_** de la parte inferior se **especializan** de **Aceptar Pago**.

#### **Relación `<<include>>` (Inclusión) 🤝**

- **Definición:** Es un **comportamiento de **_Casos de Uso_** frecuentemente utilizado** que nos permite **reutilizar la funcionalidad** por múltiples **_Casos de Uso_**.
    
- **Flecha:** La flecha va **del **_Caso de Uso_** que va a incluir** hacia el **_Caso de Uso_** **incluido**.
    

**Ejemplo con Escenarios (Tomar Orden del Cliente):**

|**Flujo Básico (Tomar Orden del Cliente)**|**Ilustración de Flujo <<include>>**|
|---|---|
|1. El Actor registra los detalles del cliente. **<<include>> Identificar Cliente.**|El paso 1 **ejecuta** forzosamente los pasos de "Identificar Cliente" y **regresa** para continuar el flujo.|
|2. El Actor introduce el código del producto.||
|3. El Sistema muestra los detalles del producto.||
|4. El Actor introduce la cantidad requerida.||
|5. El Actor introduce los detalles de pago.||
|6. El Sistema guarda las órdenes del cliente.||

**Análisis:** Si el **Actor** ejecutara **Regresar Artículos**, en alguna parte de este **_Caso de Uso_** tendría que tener un `<<include>>` hacia **Identificar Cliente** (es lógico: si hacemos un regreso de artículos, nos tendrían que identificar).

#### **Relación `<<extend>>` (Extensión) ⚙️**

- **Definición:** Indica que un **_Caso de Uso_** **agrega** o **reemplaza** **comportamiento** de otros.
    
- **Punto Clave:** Debe de tener un **punto de extensión asociado** y debe de tener una **condición**.
    

**Ejemplo con Escenarios (Extensión Condicional):**

Tenemos el **_Caso de Uso_** **Tomar Orden del Cliente** que **extiende** el **_Caso de Uso_** **Especificar Producto por Cliente**.

|**Flujo Normal (Tomar Orden del Cliente)**|**Flujo Alternativo (Extensión)**|
|---|---|
|**Paso 1:** ... incluye **Identificar Cliente**.|**Flujo Alternativo (Producto Especificado por Cliente):**|
|**Paso 2:** El Actor introduce el código del producto.|**Punto de Extensión (Paso 3):** Si el producto requiere características específicas por el cliente, **<<extend>> Caso de Uso Producto Especificado por Cliente**.|
|**Paso 3:** El Sistema muestra detalles del producto.|**3.1:** El Actor introduce las características especificadas (ej. tamaño y color).|
|...|**3.2:** El Sistema guarda esta información.|

**Análisis:** El `<<extend>>` es una **condición** (se puede ejecutar o no se puede ejecutar), a diferencia del `<<include>>` que es **forzoso**. _Ejemplo:_ En una compra de carro en línea, especificar el color y tamaño es una **condicional** que **extiende** el **_Caso de Uso_** principal.

### **Consideraciones Finales sobre Diagramas UML**

- Los **Diagramas UML de **_Casos de Uso_** no representan el flujo de información o secuencia de eventos**. Dentro de nuestro **Diagrama UML** no existe una **secuencia** (no está demostrando una secuencia).
    
- No representan la **comunicación** entre **Actores**.
    
- Los **Actores** no son siempre **roles desempeñados por una persona**. Los **Actores** pueden representar el papel desempeñado por **cualquier cosa** que actúe sobre el **sistema** (otro **sistema**, una **base de datos**, una **organización**, una **instancia**, etc.).
    


## 🛠️ Corrección y Reorganización Estructural (`<<include>>`)

La sección sobre el `<<include>>` ha sido corregida para separar la descripción tabular de la representación gráfica ASCII, mejorando la claridad en la **reutilización de funcionalidad**.

### Relación `<<include>>` (Inclusión) 🤝

- **Definición:** Es un **comportamiento de **_Casos de Uso_** frecuentemente utilizado** que nos permite **reutilizar la funcionalidad** por múltiples **_Casos de Uso_**.
    
- **Flecha:** La flecha va **del **_Caso de Uso_** que va a incluir** hacia el **_Caso de Uso_** **incluido**.
    

#### **Flujo Básico y Reutilización (Tomar Orden del Cliente)**

En este ejemplo, el **Caso de Uso** `Tomar Orden del Cliente` (o `Regresar Artículos`) **reutiliza** la lógica de `Identificar Cliente`.

|**Paso Clave**|**Acción del Actor / Sistema**|**Lógica de Inclusión**|
|---|---|---|
|**Paso 1**|El Actor registra los detalles del cliente.|**<<include>> Identificar Cliente.**|
|**Resultado**|Se ejecuta la secuencia completa de pasos del Caso de Uso `Identificar Cliente`.|Esta reutilización evita la duplicación de lógica de pasos.|

#### **Representación UML (Inclusión ASCII)**

El **Actor Asistente de Ventas** invoca **Tomar Orden del Cliente**, el cual **incluye forzosamente** la lógica de **Identificar Cliente**.

Fragmento de código

```
                      [ UC: Identificar Cliente ]
                                 ^
                                 |  <<include>>
                                 |
[ Actor: Asistente de Ventas ] ----> [ UC: Tomar Orden del Cliente ]
                                 |
                                 |  <<include>>
                                 |
                                 v
                      [ UC: Regresar Artículos ]
```

**Análisis:** Si el **Actor** ejecutara **Regresar Artículos**, en alguna parte de este **_Caso de Uso_** tendría que tener un `<<include>>` hacia **Identificar Cliente** (es lógico: si hacemos un regreso de artículos, nos tendrían que identificar).




## 📝 Tarea / Ejercicio

**Ejercicio:** **Realizar un Diagrama** del documento que se encuentra en **Classroom**. La **fecha límite** es para el **lunes 11 de mayo**, porque el **martes** se trabajará sobre este documento (se realizará el ejercicio en clase).

¿Tiene alguna duda sobre el ejercicio? Simplemente lo que van a hacer es el **diagrama**.


## 📄 FASE 2: Ejecución de Traducción Rigurosa (Segmento 5: Proceso Unificado RUP)

**¿Quiénes de ustedes han trabajado con RUP, con el Proceso Unificado de Rational (Rational Unified Process)?**

> **Ideas fundamentales:** Yo no. Yo tampoco.

**No, no, okay. RUP es una metodología** que es **orientada a objetos**. RUP fue un **precursor** del **ágil**. **RUP** era un **proceso iterativo** e **incremental**.

### **RUP: Un Proceso Iterativo e Incremental**

**¿Qué significa Iterativo e Incremental?**

- **Iterativo:** Se realizan **iteraciones** o **ciclos** en los que se trabaja una **pequeña parte del sistema** a lo largo del **tiempo**.
    
- **Incremental:** Se van **agregando funcionalidades** al **sistema** en cada **iteración**.
    

Entonces, **RUP** es un **proceso** que tiene un **enfoque por fases**. **RUP** tiene **cuatro fases**, y cada una de ellas se **divide** en **iteraciones**.

![[Pasted image 20251208001844.png]]




**Fases de RUP:**

1. **Incepción (Inception):**
    
    - Es la **fase inicial**.
        
    - **Objetivo:** Definir el **alcance** del proyecto y obtener la **aprobación** para seguir adelante.
        
    - **Actividades principales:** **Modelado de Casos de Uso** (se identifican todos los **Actores** y todos los **Casos de Uso**), se evalúan los **riesgos** y se **estima** la **inversión** y el **retorno de inversión (ROI)**.
        
2. **Elaboración (Elaboration):**
    
    - **Objetivo:** **Analizar** el **dominio del problema** a profundidad y **diseñar** la arquitectura de _software_ del sistema.
        
    - **Actividades principales:** **Especificación de Casos de Uso** (se especifican a detalle los **Casos de Uso**), **diseño de la arquitectura**, y se **mitigan** los **riesgos principales**.
        
3. **Construcción (Construction):**
    
    - **Objetivo:** **Desarrollar** el _software_ y **verificar** que cumple con los **requisitos**.
        
    - **Actividades principales:** **Implementación** (codificación) y **pruebas unitarias/de integración**. Es donde se lleva a cabo la **mayor parte del desarrollo**.
        
4. **Transición (Transition):**
    
    - **Objetivo:** **Desplegar** el _software_ y **entregarlo** a los **usuarios finales**.
        
    - **Actividades principales:** **Despliegue**, **entrenamiento** del usuario y **ajustes finales** basados en la **retroalimentación** del usuario.
        

**RUP** tiene **disciplinas** o **flujos de trabajo** que se realizan en **todas las fases**, pero su **intensidad** o **énfasis** **varía** según la **fase**.

|**Flujos de Trabajo Centrales (Core Workflows)**|
|---|
|**Modelado de Negocio** (Business Modeling)|
|**Requerimientos** (Requirements)|
|**Análisis y Diseño** (Analysis & Design)|
|**Implementación** (Implementation)|
|**Prueba** (Test)|
|**Despliegue** (Deployment)|

### **Énfasis en la Fase de Requerimientos (Requirements)**

Como vemos en la gráfica, la **Fase de Requerimientos** tiene su **pico de intensidad** en la **Fase de Elaboración**.

**¿Cuáles son los artefactos (artefacts) de RUP en la Fase de Requerimientos?**

1. **_Modelo de Caso de Uso_**: Ya vimos que está compuesto por el **Diagrama UML** y la **Especificación** del **_Caso de Uso_**.
    
2. **Glosario del Dominio (Domain Glossary)**.
    
3. **Modelo de Negocio (Business Model)**.
    
4. **Modelo de Datos (Data Model)**.
    
5. **Prototipo de Interfaz de Usuario (User Interface Prototype)**.
    

Entonces, el **_Modelo de Caso de Uso_** es el **artefacto principal** de la **Fase de Requerimientos** de **RUP**. Por eso es que es tan **importante** que ustedes lo **conozcan** y lo **dominen**.

---

## 3. 📝 FASE 3: Glosario Final (R9)

|**Término Original (R1)**|**Traducción Consistente (R5)**|**Definición (Contextual)**|
|---|---|---|
|**RUP (Rational Unified Process)**|**_RUP (Proceso Unificado de Rational)_**|Metodología de desarrollo de _software_ orientada a objetos, iterativa e incremental, precursora de las metodologías ágiles.|
|**Iterative**|**_Iterativo_**|Se refiere a la realización de ciclos o iteraciones a lo largo del tiempo, donde se trabaja una pequeña parte del sistema.|
|**Incremental**|**_Incremental_**|Se refiere a la adición sucesiva de nuevas funcionalidades al sistema en cada iteración.|
|**Inception Phase**|**_Fase de Incepción_**|Fase inicial de RUP; objetivo: definir el alcance y viabilidad del proyecto (se identifican todos los Casos de Uso).|
|**Elaboration Phase**|**_Fase de Elaboración_**|Fase de RUP; objetivo: analizar el dominio, diseñar la arquitectura y especificar a detalle los Casos de Uso.|
|**Artefactos (Artefacts)**|**_Artefactos_**|Productos de trabajo documentados generados durante el proceso de desarrollo, siendo el Modelo de Caso de Uso el principal en la fase de Requerimientos de RUP.|

---

La traducción del segmento sobre el **Proceso Unificado de Rational (RUP)** ha sido completada, incluyendo la definición de sus fases y el rol central del Modelo de Caso de Uso.




## 📄 FASE 2: Ejecución de Traducción Rigurosa (Segmento 6: Actores de RUP y Riesgos)

**¿Quiénes son los Actores dentro de RUP?**

Entonces, **RUP** también tiene **Actores** que están **involucrados** en el **proceso**. Estos **Actores** son:

|**Rol (Actor RUP)**|**Responsabilidad Principal**|
|---|---|
|**Director de Proyecto** (Project Manager)|Responsable del **planeamiento** y la **ejecución** del proyecto.|
|**Analista de Negocio** (Business Analyst)|Responsable de la **obtención** y **documentación** de los requerimientos.|
|**Arquitecto** (Architect)|Responsable de la **Arquitectura de _Software_**.|
|**Diseñador** (Designer)|Responsable del **Diseño Detallado** de componentes.|
|**Desarrollador** (Developer)|Responsable de la **Implementación** (codificación).|
|**Probador/Tester** (Tester)|Responsable de la **Verificación** del sistema.|

**RUP** es un **proceso** que es **dirigido por los casos de uso** (**Use Case Driven**). **El Modelado de Casos de Uso** se utiliza como el **mecanismo** para **impulsar** la **mayoría** de las **actividades** del **proceso de desarrollo**.

### **RUP Dirigido por Casos de Uso**

**¿Qué queremos decir con que RUP está dirigido por los casos de uso?**

- Los **_Casos de Uso_** son la **herramienta clave** para **capturar** los **requerimientos funcionales**.
    
- El **análisis** y el **diseño** están **basados** en los **_Casos de Uso_**. Es decir, los **objetos** o **clases** que nosotros vamos a **crear** van a estar **basados** en el **_Modelo de Casos de Uso_**.
    
- La **implementación** se **organiza** alrededor de los **_Casos de Uso_**.
    
- Las **pruebas** se **planean** alrededor de los **_Casos de Uso_**.
    

> **Concepto clave:** La **Especificación** del **_Caso de Uso_** **se convierte en el plan de pruebas** o el **escenario de pruebas** que el **Probador/Tester** va a utilizar.

Si yo soy el **Analista** y le doy mi **Especificación de Caso de Uso** al **Probador**, este **Probador** va a **utilizar** cada uno de los **pasos** que yo definí para **crear** su **plan de pruebas**.

### **RUP Dirigido por la Arquitectura**

**RUP** también es un **proceso** que es **dirigido por la arquitectura** (**Architecture Centric**).

- **¿Qué significa?** Enfatiza el **diseño** y la **validación** de la **arquitectura de _software_**.
    
- La **arquitectura** es **vital** para la **integridad** y la **calidad** del sistema.
    
- La **arquitectura** se **refina** y **valida** en cada **iteración**.
    

### **RUP Dirigido por Riesgos**

**RUP** es un **proceso** que es **dirigido por riesgos** (**Risk Driven**).

- **¿Qué significa?** Se **priorizan** las **actividades de desarrollo** que **mitigan** los **riesgos más importantes** en las **primeras iteraciones**.
    

**¿Qué son los Riesgos?**

> Un **Riesgo** es un **evento incierto** que, si **ocurre**, tiene un **efecto positivo** o **negativo** en los **objetivos** del proyecto.

Nosotros debemos de preguntarnos: **¿Qué puede salir mal?** Si la respuesta es: "Este **evento** tiene una **alta probabilidad** de **ocurrir** y si **ocurre** tiene un **gran impacto** en mi **proyecto**", entonces es un **Riesgo** que debo de **tratar**.

#### **Tipos de Riesgos**

- **Riesgos Técnicos:** Relacionados con la **tecnología** (ej. la tecnología que se está utilizando es nueva o no está probada).
    
- **Riesgos de Negocio:** Relacionados con la **viabilidad** del proyecto (ej. el producto no tiene demanda en el mercado).
    
- **Riesgos Organizacionales:** Relacionados con los **recursos humanos** o la **estructura** del proyecto (ej. falta de personal capacitado).
    
- **Riesgos del Cronograma:** Relacionados con el **tiempo** (ej. los plazos son demasiado ajustados).
    

En **RUP**, el **objetivo** es **abordar** y **mitigar** los **riesgos más importantes** en la **Fase de Elaboración**, para **evitar** que se conviertan en **problemas** en la **Fase de Construcción**.

---

## 3. 📝 FASE 3: Glosario Final (R9)

|**Término Original (R1)**|**Traducción Consistente (R5)**|**Definición (Contextual)**|
|---|---|---|
|**Use Case Driven**|**_Dirigido por Casos de Uso_**|Enfoque de RUP donde los Casos de Uso impulsan la captura de requerimientos, el análisis, el diseño, la implementación y las pruebas.|
|**Architecture Centric**|**_Dirigido por la Arquitectura_**|Enfoque de RUP que enfatiza el diseño, la validación y el refinamiento continuo de la arquitectura de _software_.|
|**Risk Driven**|**_Dirigido por Riesgos_**|Enfoque de RUP donde las actividades se priorizan para mitigar los riesgos más importantes en las primeras iteraciones.|
|**Risk**|**_Riesgo_**|Un evento incierto que, de ocurrir, afecta positiva o negativamente los objetivos del proyecto. Se clasifican típicamente en Técnicos, de Negocio, Organizacionales y de Cronograma.|
|**Tester**|**_Probador/Tester_**|Actor de RUP responsable de la verificación del sistema. Utiliza la Especificación de Caso de Uso como plan de pruebas.|

---

La traducción del segmento sobre los **Actores de RUP** y los **tres principios rectores** (**Dirigido por Casos de Uso, Dirigido por la Arquitectura y Dirigido por Riesgos**) ha sido completada.





## 📄 FASE 2: Ejecución de Traducción Rigurosa (Segmento 7: Diseño Orientado a Objetos - GRASP)

**¿Quién de ustedes ha trabajado con lo que viene siendo el diseño orientado a objetos con los principios de diseño de GRASP (General Responsibility Assignment Software Patterns)?**

> **Ideas fundamentales:** Yo no. Yo no.

**No, no, okay.** Entonces, vamos a ver qué son los **principios de diseño de GRASP**.

Los **patrones GRASP** son un **conjunto de patrones** que se utilizan para **asignar responsabilidades a las clases** en un **diseño orientado a objetos**.

### **Principios de Diseño GRASP**

**GRASP** tiene **nueve principios de diseño** o **nueve patrones de diseño**. Estos **patrones** nos dicen **cómo crear** estas **clases** y **cómo** estas **clases** deben de **interactuar** entre sí.

|**Patrón GRASP**|**Objetivo Principal**|
|---|---|
|**Experto en Información** (Information Expert)|**Asignar** la **responsabilidad** a la **clase** que tiene la **información necesaria** para cumplir con esa responsabilidad.|
|**Creador** (Creator)|**Asignar** la **responsabilidad** de **crear** una **instancia** de **Clase B** a la **Clase A** si la **Clase A** **contiene** o **agrega** la **Clase B**.|
|**Controlador** (Controller)|**Asignar** la **responsabilidad** de **manejar** los **eventos del sistema** a una **Clase Controlador**.|
|**Acoplamiento Bajo** (Low Coupling)|**Mantener** el **acoplamiento** entre las **clases lo más bajo posible**.|
|**Alta Cohesión** (High Cohesion)|**Mantener** la **cohesión** dentro de una **Clase lo más alta posible**.|
|**Polimorfismo** (Polymorphism)|**Asignar** la **responsabilidad** de un **comportamiento variante** a la **clase** de donde ocurre el **comportamiento**.|
|**Indirección** (Indirection)|**Asignar** la **responsabilidad** a un **objeto intermedio** para **reducir el acoplamiento**.|
|**Cambio Protegido** (Protected Variations)|**Proteger** los **elementos** de **cambios futuros** mediante la **creación de interfaces** o **clases abstractas**.|
|**Conocimiento Puro** (Pure Fabrication)|**Crear** una **Clase** que **no representa** un **concepto del dominio** pero que se usa para **lograr una alta cohesión** o **bajo acoplamiento**.|

### **Patrones GRASP y Casos de Uso**

Nosotros nos vamos a **enfocar** en el **Patrón Experto en Información** (**_Information Expert_**) y en el **Patrón Controlador** (**_Controller_**).

#### **1. Patrón Controlador (Controller)**

- El **Patrón Controlador** nos dice que la **primera Clase** que **recibe** la **interacción** del **_Caso de Uso_** es el **Controlador**.
    
- El **Controlador** es la **Clase** que **maneja** los **eventos del sistema** que ocurren durante un **_Caso de Uso_**.
    

**Ejemplo de Controlador:**

Si yo tengo un **_Caso de Uso_** llamado **Procesar Venta** (que involucra muchos **eventos** o **pasos**), el **Controlador** de este **_Caso de Uso_** es el que **recibe** las **solicitudes** de este **caso de uso** y **direcciona** las **solicitudes** a las **clases adecuadas**.

La **Regla de Oro** para el **Controlador** es:

> Debe haber **un Controlador** por **Caso de Uso Principal** o por **un conjunto de **_Casos de Uso_** relacionados**.

- Si tenemos *_muchos **_Casos de Uso_**_ **no relacionados**, es mejor tener **un Controlador para cada uno**.
    
- Si tenemos **_Casos de Uso_** **relacionados** (ej. **Procesar Venta**, **Anular Venta**, **Devolver Artículo**), estos pueden ser **manejados** por un **único Controlador**, llamado **_Controlador de Venta_**.
    

**¿Qué pasa si tenemos un Controlador para todo?**

Si tenemos una **sola Clase** que es el **Controlador de todo**, se convierte en un **Problema de Diseño**.

- Esta **Clase** es **demasiado grande** y tiene **muchas responsabilidades**.
    
- Se convierte en una **Clase con bajo acoplamiento** y **baja cohesión** (contradice los principios GRASP).
    

**El Patrón Controlador** nos dice: **No debes tener una Clase que lo haga todo**. Debes tener una **Clase** que **reciba** la **solicitud** y que **la delegue a las Clases que son Expertas en Información**.

#### **2. Patrón Experto en Información (Information Expert)**

- Este **Patrón** nos dice que la **responsabilidad** de **realizar una tarea** debe **asignarse** a la **Clase** que tiene la **información** necesaria para realizar esa **tarea**.
    

**Ejemplo de Experto en Información:**

Si en mi **sistema** necesito **calcular el total de una venta**, ¿quién debe tener la **responsabilidad** de **calcular ese total**?

- La **Clase** `Venta` (Sale), ya que la **Clase** `Venta` tiene la **información** de los **Artículos** vendidos, las **Cantidades** y los **Precios**.
    
- Si la **Clase** `Venta` **necesita más información** (ej. el **Impuesto**) para **calcular** el **total**, la **Clase** `Venta` le debe **solicitar esa información** a la **Clase Experta** en **Impuestos**.
    

> **Concepto clave:** Las **Clases** se **convierten** en **Expertas en Información** cuando **almacenan los datos** y **realizan las operaciones** relacionadas con esos **datos**.

### **Relación Final: RUP $\to$ GRASP**

Entonces, la **Especificación de Caso de Uso** (que es un **artefacto clave de RUP**) se **utiliza** como la **base** para **aplicar** los **principios de diseño de GRASP**.

- El **Escenario de Caso de Uso** (**Paso 1, Paso 2, Paso 3**) le **indica** al **Diseñador** **qué interacciones** deben **ocurrir**.
    
- El **Diseñador** utiliza **GRASP** para **decidir** **a qué Clases asignar esas responsabilidades** (ej. ¿Quién es el **Controlador**? ¿Quién es el **Experto en Información**?).
    

---

## 3. 📝 FASE 3: Glosario Final (R9)

|**Término Original (R1)**|**Traducción Consistente (R5)**|**Definición (Contextual)**|
|---|---|---|
|**GRASP (General Responsibility Assignment Software Patterns)**|**_GRASP (Patrones Generales de Asignación de Responsabilidades)_**|Conjunto de nueve patrones de diseño fundamentales para asignar responsabilidades a las clases en el diseño orientado a objetos.|
|**Information Expert**|**_Experto en Información_**|Patrón GRASP que asigna la responsabilidad de una operación a la clase que posee la información necesaria para llevarla a cabo.|
|**Controller**|**_Controlador_**|Patrón GRASP que asigna la responsabilidad de manejar o delegar los eventos del sistema ocurridos durante un Caso de Uso.|
|**Low Coupling**|**_Acoplamiento Bajo_**|Principio GRASP que busca minimizar las dependencias o conexiones entre las clases para hacer el sistema más mantenible y flexible.|
|**High Cohesion**|**_Alta Cohesión_**|Principio GRASP que busca que las responsabilidades de una clase estén fuertemente relacionadas entre sí, para que la clase sea clara y enfocada.|

---

La traducción del segmento sobre los **Patrones de Diseño GRASP** y su aplicación desde los **Casos de Uso** ha sido completada.


## 📄 FASE 2: Ejecución de Traducción Rigurosa (Segmento 8: Comunicación y Despedida)

Entonces, como ven, los **_Casos de Uso_** son una **herramienta muy importante** que nosotros vamos a estar utilizando en el **desarrollo de _software_**.

### **Casos de Uso como Herramienta de Comunicación**

Y lo **más importante** es que es una **herramienta de comunicación** . ¿Por qué es una **herramienta de comunicación**?

- Porque el **_Caso de Uso_** es el **vínculo** entre el **Analista**, el **Probador/Tester** y el **Desarrollador**.
    
- Los **_Casos de Uso_** son la **herramienta clave** para que el **Analista le comunique** al **Desarrollador** **qué tiene que hacer**.
    
- Y a su vez, para que el **Analista le comunique** al **Probador** **qué tiene que probar**.
    

> **Concepto clave:** Si nosotros **perdemos** esta **comunicación**, podemos **crear sistemas** que **no satisfagan** las **necesidades de los _stakeholders_** (interesados) o los **objetivos de negocio**.

Y si nosotros **perdemos** los **objetivos de negocio**, el **proyecto** es un **fracaso**.

Es por eso que es **muy importante** que ustedes **dominen** la **especificación** y los **diagramas** de **_Casos de Uso_**.

**¿Tienen alguna duda o comentario sobre este tema o los temas anteriores?**

> **Ideas fundamentales:** No. Todo bien.

**Okay.** Pues **muchísimas gracias** por su **tiempo**. **Nos vemos la próxima semana**. Recuerden que tienen una **tarea pendiente**. Les voy a estar **subiendo** las **clases** que **faltan** de **subir** en estos **días**. **Muchísimas gracias**. **Nos vemos**.

---

## 3. 📝 FASE 3: Glosario Final (R9)

|**Término Original (R1)**|**Traducción Consistente (R5)**|**Definición (Contextual)**|
|---|---|---|
|**Communication Tool**|**_Herramienta de Comunicación_**|Función primordial del Caso de Uso, actuando como el **vínculo formal** para asegurar que el **Analista**, el **Desarrollador** y el **Probador** compartan un entendimiento común de los requisitos del sistema.|
|**Stakeholders**|**_Interesados / _Stakeholders__**|Cualquier persona, grupo u organización que puede afectar o ser afectada por las decisiones, actividades o resultados de un proyecto.|

---

Con esto, he completado la traducción rigurosa de todo el texto original proporcionado. Hemos cubierto:

1. **Fundamentos de Casos de Uso** (Nomenclatura, Estructura).
    
2. **Trazabilidad de Requerimientos** (Jerarquía, BRs).
    
3. **Especificación de Calidad** (Técnica SMART, Escenarios QA).
    
4. **Identificación y Diagramas UML** (CRUD, Asociaciones, Include/Extend).
    
5. **Metodología RUP** (Fases y Principios).
    
6. **Diseño Orientado a Objetos** (Patrones GRASP).
    
7. **Rol de Comunicación** del Caso de Uso.



## 📄 FASE 2: Ejecución de Traducción Rigurosa (Segmento 9: Atributos de Calidad y Priorización)

Entonces, tenemos nuestro **diagrama**. Tenemos en esta parte lo que son los **_Atributos de Calidad_**. Como vemos, estos **influyen** o están **especificados** en lo que viene siendo nuestro **Diseño (Design)**, nuestro **Análisis (Analysis)**, nuestro **Riesgo (Risk)**, etc. Poco a poco ya vamos **llenando** lo que viene siendo nuestro **programa** o ir **contemplando** todos los **tópicos**. Ya vimos **Reglas de Negocio**, **Requerimientos de Negocio**, **Requerimientos de Usuario** a través de los **_Casos de Uso_**, lo que viene siendo el **Documento de Visión y Alcance**.

### **Requerimiento de Usuario vs. Atributos de Calidad**

Tenemos estos **dos sistemas** (vehículos). Con el **Requerimiento de Usuario**, ustedes creen: ¿Para qué sirven estos dos sistemas? ¿Cuál creen que sea la **necesidad** o cuál es el **motivo** por el que existen estos sistemas? ¿Cuáles son los **Requerimientos de Usuario**?

> **Análisis:** Lo que tratan de hacer o lo que deben de hacer estos sistemas es **transportar una persona de un lugar a otro**. Estamos de acuerdo. Ese es el **Requerimiento de Usuario**: **transportar una persona de un lugar a otro**.

> **Requerimientos de Usuario:** Describen los **comportamientos del sistema vistos desde una perspectiva de los usuarios**. Es cómo el sistema se debe de **comportar**. Los **Requerimientos de Usuario** son generalmente descritos en **_Casos de Uso_** (como ya lo vimos) o en lo que vienen siendo **Historias de Usuario** (si estamos utilizando un modelo ágil).

#### **Atributos de Calidad**

Si decimos que la **funcionalidad** de estos vehículos es **transportar a una persona de un lugar a otro**, ¿qué los hace **diferentes**? ¿Cuál de estos dos creen que es **mejor**?

|**Vehículo 1 (Scooter/Patineta)**|**Vehículo 2 (Auto Lujoso)**|
|---|---|
|**Pequeño**|**Bonito**|
|**Económico**|**Seguro**|
||**Rápido**|
||**Caro**|

**Análisis:** Los dos tienen la **misma funcionalidad** (transportan una persona de un lugar a otro). El auto lujoso es mejor, porque está **más perfeccionado** que la patineta motorizada.

**Conclusión:** ¿Cuál es mejor? Es un poco **ambiguo**, pero **depende de las necesidades**.

### **Requerimientos No Funcionales / Atributos de Calidad**

Nuestros **_Atributos de Calidad_** también son llamados **Requerimientos No Funcionales del Sistema**.

- **Definición:** Son **características medibles** que permiten **verificar** y **medir** el **grado de satisfacción** de los **usuarios** o los **diseñadores** (es decir, la **calidad** con respecto al sistema).
    
- **Esencia:** Es el **grado de satisfacción** que siente un **usuario** o también un **desarrollador** al estar **trabajando** con este sistema. Si un software nos gusta y nos agrada, la sensación de satisfacción es gracias a los **_Atributos de Calidad_**.
    
- **Ejemplos:** Desempeño, rigidez, robustez.
    

#### **Categorías Comunes de Atributos de Calidad**

Existen ciertas categorías que son comúnmente utilizadas y existe cierto consenso con respecto a su significado:

|**Categoría**|**Descripción**|**Relación Clave**|
|---|---|---|
|**Disponibilidad** (Availability)|El tiempo que el sistema está en **estado operacional** (ej. en servidores de Internet).|Tiempo en línea / Trabajando|
|**Desempeño** (Performance)|El **tiempo de respuesta** del sistema a las peticiones; qué tan **rápido** y **eficiente** es al momento de solicitar algo y obtener la respuesta.|Velocidad / Eficiencia de Respuesta|
|**Seguridad** (Security)|La **habilidad** del sistema de **resistir usos no autorizados** mientras sigue proveyendo servicios a usuarios legítimos.|Resistencia a usos no autorizados|
|**Usabilidad** (Usability)|Qué tan **sencillo** les resulta a los usuarios realizar **operaciones** en el sistema (relacionado con **UX/UI**).|Comodidad / Facilidad de uso|
|**Facilidad de Mantenimiento** (Maintainability)|El **costo asociado** a la realización de **cambios** en el sistema; qué tan fácil y barato es hacer un cambio.|Facilidad / Costo de Modificación|
|**Facilidad de Prueba** (Testability)|Qué tan **fácil** es lograr que el sistema **exhiba fallos** a través de la realización de pruebas.|Capacidad de Exponer Fallos|
|**Interoperabilidad** (Interoperability)|El **grado** en el que **varios sistemas pueden intercambiar información** entre ellos (ej. conexión entre un carrito de compras y una pasarela de cobro vía **APIs**).|Intercambio de Información|

### **División de Atributos: Externos vs. Internos**

Existe una división en dos grandes grupos de **_Atributos de Calidad_**:

#### **1. Atributos de Calidad Externa (External QAs)**

- **Observación:** Describen **características** que se **observan** cuando el **software se está ejecutando**.
    
- **Impacto:** Influyen profundamente en la **experiencia del usuario** y la **percepción del usuario de la calidad** del sistema.
    
- **Ejemplos:** Disponibilidad, Instalabilidad (qué tan fácil es instalar/desinstalar), Integridad (que no haya pérdida de datos, que sean correctos), Interoperabilidad, Desempeño, Seguridad (**Security** y **Safety**).
    

> **Aclaración de Seguridad (Safety vs. Security):**
> 
> - **Safety (Seguridad Física/Operacional):** Protección del sistema para **daño físico** o **percance** (ej. fenómenos meteorológicos, accidentes).
>     
> - **Security (Seguridad de Datos/Accesos):** Qué tan bien el sistema se protege para **accesos no autorizados** a las aplicaciones o datos (ej. hackers/crackers).
>     

#### **2. Atributos de Calidad Interna (Internal QAs)**

- **Observación:** **No son directamente observables** durante la **ejecución** del software.
    
- **Impacto:** Son **propiedades** que el **Desarrollador** o el **Programador** percibe al **examinar el diseño** o el **código**.
    
- **Ejemplos:** **Eficiencia**, **Modificabilidad** (facilidad de hacer cambios), **Portabilidad** (usar el software en diferente hardware o SO, ej. Xbox $\to$ PlayStation), **Reutilizabilidad** (tomar componentes y usarlos en otra parte del software o aplicación), **Escalabilidad** (manejar más usuarios/transacciones/servidores de manera sencilla), **Verificabilidad** (qué tan fácil los desarrolladores y testers pueden confirmar que el software está implementado correctamente).
    

### **Exploración y Priorización de Atributos de Calidad**

En un **universo ideal**, cada sistema exhibiría el **máximo valor posible** para todos sus atributos. Pero, como la perfección es **inalcanzable**, debemos **determinar qué atributos son más importantes** para el **éxito del proyecto**.

**Diferentes proyectos** exigirán **diferentes conjuntos de **_Atributos de Calidad_** para el éxito**.

**Enfoque Práctico para Identificar y Especificar Atributos (basado en Bass et al. 2010):**

#### **Paso 1: Comenzar con una Taxonomía Amplia**

- Tomar **todos** los **_Atributos de Calidad_** (**Interoperabilidad**, **Integridad**, **Desempeño**, **Seguridad**, etc.).
    

#### **Paso 2: Reducir la Lista**

- **Involucrar** a un grupo representativo de **_Stakeholders_** para **evaluar** cuáles son los **más importantes** para el proyecto.
    
- _Ejemplo:_ Un **kiosco de _check-in_** de un aeropuerto debe enfatizar la **Usabilidad** (manejo sencillo/fácil), ya que el usuario final lo usará directamente.
    

#### **Paso 3: Priorizar los Atributos**

- Utilizar una **Matriz de Priorización** (Matriz de Riesgos/Impacto, usando una hoja de cálculo/Excel) para hacer una **evaluación comparativa**.
    

**Proceso de Evaluación:**

1. Se comparan los **_Atributos de Calidad_** **uno a uno** (fila vs. columna).
    
2. Se define **cuál es más importante** que el otro (ej. ¿Disponibilidad vs. Integridad?).
    
3. La herramienta genera un **Score** o **resultado** para cada atributo.
    
4. El atributo con el **Score más alto** es aquel en el que se debe hacer **más énfasis** (Ej. para el kiosco, la **Seguridad**).
    

> Razón de la Priorización: No podemos tenerlos todos al máximo.
> 
> Ejemplo: Más Seguridad de dos pasos (móvil, SMS, código) implica un proceso más lento (menor Desempeño). Existe una compensación (trade-off) entre atributos.
> 
> _Es crucial que los **_Stakeholders_** estén **involucrados** en esta etapa de **priorización**._

#### **Paso 4: Traducirlos en Criterios Cuantificables**

- **Evitar ambigüedades** (Ejemplo de las alitas: "bien cocidas" vs. "**bien fritas por 17 minutos**").
    

|**Atributo de Calidad No Útil**|**Problema**|**Atributo Útil (SMART)**|
|---|---|---|
|El sistema será **fácil de usar**.|Demasiado **subjetivo**.|El 95% de los usuarios nuevos completará el _check-in_ en menos de 90 segundos.|
|El sistema estará disponible **24/7**.|Muy **raro** y **raramente realista**.|El sistema debe estar disponible un 99.9% del tiempo de operación.|

Los **Requerimientos** o los **_Atributos de Calidad_** deben de estar enfocados con la **Técnica SMART**, que lo que busca es que sean:

- **Específicos** (Specific)
    
- **Mensurables** (Measurable)
    
- **Alcanzables** (Achievable)
    
- **Relevantes** (Relevant)
    
- **Sensibles al Tiempo** (Time-sensitive)
    

> **Nota:** En la próxima clase se propondrá una técnica para escribir los **_Atributos de Calidad_** de una manera **mensurable** o de **tipo SMART**.

---

## 3. 📝 FASE 3: Glosario Final (R9)

|**Término Original (R1)**|**Traducción Consistente (R5)**|**Definición (Contextual)**|
|---|---|---|
|**Quality Attributes (QAs)**|**_Atributos de Calidad_**|También llamados **Requerimientos No Funcionales**; características medibles que definen el grado de satisfacción del usuario y del desarrollador (la calidad del sistema).|
|**SMART Technique**|**_Técnica SMART_**|Acrónimo utilizado para estructurar los atributos de calidad de forma que sean Específicos, Mensurables, Alcanzables, Relevantes y Sensibles al Tiempo.|
|**Trade-off**|**_Compensación_**|El equilibrio necesario al priorizar atributos, donde mejorar un atributo (ej. Seguridad) puede implicar disminuir otro (ej. Desempeño o velocidad).|
|**Usability**|**_Usabilidad_**|Grado en que el sistema es sencillo, cómodo e intuitivo para el usuario (relacionado con UX/UI).|
|**Integrity**|**_Integridad_**|Atributo de calidad externa que asegura que los datos sean correctos y no haya pérdida de estos.|

---

Hemos completado la traducción rigurosa de todo el material proporcionado.


## 🔒 Atributos de Calidad: Integridad y Totalidad (Completitud)

En el ámbito de la calidad de los datos y la seguridad, estos dos atributos se enfocan en la confiabilidad y validez de la información.

### 1. Integridad (Integrity)

La integridad es un atributo de **Calidad Externa**, observable por el usuario final o el analista de datos. Se refiere a la **confiabilidad** y **corrección** de los datos.

|**Característica**|**Descripción Técnica**|
|---|---|
|**Enfoque**|Asegurar que los datos sean **precisos**, **consistentes** y que no hayan sido **alterados** o **perdidos** de forma no autorizada o accidental.|
|**Contexto**|Se aplica a las **reglas del negocio** que mantienen la validez de los datos (ej. un campo de edad debe ser mayor a 0 y menor a 150).|
|**Impacto**|Si la integridad falla, el usuario podría ver **transacciones incorrectas** o **datos inconsistentes** (ej. la suma del carrito no concuerda con la suma de los productos).|
|**Ejemplo Cuantificable (SMART)**|"El sistema garantizará que las transacciones financieras cumplan con las reglas de balanceo contable en el 100% de los casos antes de ser confirmadas, manteniendo la **coherencia** con los datos históricos."|

### 2. Totalidad / Completitud (Completeness)

La Totalidad o Completitud es un atributo de **Calidad Externa** o **Interna** (dependiendo de si se evalúa desde el _output_ para el usuario o desde la _data store_ para el desarrollador). Se refiere a si **todos los datos requeridos** están presentes y son suficientes.

|**Característica**|**Descripción Técnica**|
|---|---|
|**Enfoque**|Asegurar que la **información** o el **conjunto de datos** esté **completo** y no le falten partes esenciales para el negocio o para la operación.|
|**Contexto**|Se aplica a si el sistema maneja la **ausencia de datos** (nulos) o si un reporte crucial **omite campos** necesarios.|
|**Impacto**|Si la Completitud falla, el sistema o el usuario final podrían tomar **decisiones equivocadas** por falta de información (ej. un reporte de ventas no incluye la región de origen).|
|**Ejemplo Cuantificable (SMART)**|"El sistema de registro de usuarios requerirá que los campos 'Nombre', 'Correo electrónico' y 'Número de teléfono' contengan información **válida y no nula** para el 98% de los registros ingresados."|

---

### Diferencia Clave

|**Atributo**|**Pregunta que Responde**|**Analogía**|
|---|---|---|
|**Integridad**|¿Son **correctos** y **consistentes** los datos que tengo?|¿El libro tiene las páginas en el **orden correcto** y el **contenido no está alterado**?|
|**Totalidad / Completitud**|¿Tengo **todos** los datos que debería tener?|¿El libro **tiene todas las páginas**, desde el prólogo hasta el índice?|

Ambos atributos son cruciales y a menudo se abordan juntos en el diseño de bases de datos y en el modelado de reglas de negocio para asegurar la calidad global de la información.



A continuación, presento un resumen estructurado y organizado de todos los temas cubiertos en la traducción, manteniendo la terminología técnica clave.

---

# 📚 Compilación y Resumen de la Traducción Técnica Rigurosa

Esta compilación abarca los conceptos clave de la Ingeniería de Requisitos y el Diseño Orientado a Objetos tratados en los segmentos traducidos, incluyendo la metodología RUP y los patrones de diseño GRASP.

## I. Fundamentos de Requerimientos y Casos de Uso

### A. Trazabilidad con Reglas de Negocio (BRs)

- **Concepto:** Las **Reglas de Negocio (BRs)** son normas, políticas o restricciones que definen un aspecto del negocio.
    
- **Relación con UC:** Las BRs deben ser **validadas** en los escenarios del Caso de Uso (UC). Indican dónde deben existir **ramificaciones** o **excepciones** dentro del flujo de un UC.
    
- **Ejemplo:** Si el UC4 (Solicitar Químico) se ve afectado por BR28 ("Solicitudes mayores a $500 requieren aprobación"), la BR actúa como una condición para un Flujo Alternativo.
    

### B. Identificación de Casos de Uso (UC)

Se propusieron varias metodologías para identificar UC a partir de una problemática:

- **Basada en Actores:** Identificar Actores $\to$ Buscar sus Actividades $\to$ Definir UC.
    
- **Basada en Escenarios:** Crear Escenarios $\to$ Localizar UC $\to$ Identificar Actores.
    
- **Basada en Procesos:** Preguntar: ¿Qué tareas se necesitan para completar este proceso? $\to$ Desglosar UC.
    
- **Análisis CRUD (Create, Read, Update, Delete):** La forma **más utilizada**. Identificar entidades de datos y definir los UC necesarios para manipularlas.
    
- **Procedimiento Básico:** Delimitar el sistema $\to$ Identificar Actores Principales $\to$ Identificar Objetivos $\to$ Nombrar los UC según esos objetivos.
    
    > **Nota:** Un Actor puede ser una persona, un sistema, una base de datos o una organización (ej. Hacienda).
    

---

## II. Diagramación y Relaciones UML

El **Modelo de Caso de Uso Completo** se compone del **Diagrama UML** y la **Especificación de Caso de Uso**.

### A. Relaciones Clave en UML (Solo entre Casos de Uso)

|**Relación**|**Propósito**|**Notación**|
|---|---|---|
|**Generalización (Herencia)**|Indica que un UC es una **especialización** de otro (Ej. Aceptar Efectivo es un tipo especial de Aceptar Pago).|Flecha dirigida al UC general.|
|**`<<include>>` (Inclusión)**|**Reutiliza** un conjunto de funcionalidades comunes en varios UC. Es **forzoso**.|Flecha del UC base **hacia** el UC incluido.|
|**`<<extend>>` (Extensión)**|**Agrega** comportamiento a un UC base solo si se cumple una **condición**. Es **condicional**.|Flecha del UC extendido **hacia** el UC base (el que se extiende).|

### B. Posicionamiento y Actores

- **Actores Primarios:** Colocados por **buenas prácticas** al **lado izquierdo**. La flecha va **del Actor al UC**.
    
- **Actores Secundarios/Soporte:** Colocados por **buenas prácticas** al **lado derecho**. La flecha va **del UC al Actor**.
    
- **Especialización de Actores:** Un Actor puede ser una especialización de otro (Ej. Administrador es un tipo de Staff de Ventas).
    

---

## III. Atributos de Calidad (Requerimientos No Funcionales)

Los QAs son características **medibles** que definen qué tan bien el sistema cumple con su funcionalidad.

### A. Taxonomía y División

|**Categoría**|**Descripción**|**Ejemplos**|
|---|---|---|
|**Externos**|Se observan cuando el software está **ejecutando**. Influyen en la percepción del usuario.|Disponibilidad, Interoperabilidad, Desempeño, Usabilidad, Integridad.|
|**Internos**|Propiedades que el **Desarrollador** o **Tester** perciben al examinar el diseño/código.|Modificabilidad, Portabilidad, Reutilizabilidad, Escalabilidad, Verificabilidad.|

### B. Especificación y Priorización de QAs

1. **Evitar Ambigüedad:** Los QAs deben ser **cuantificables** (Ej. No decir "fácil de usar", sino "el 95% de los usuarios completará X tarea en menos de 90 segundos").
    
2. **Técnica SMART:** Los QAs deben ser: **E**specíficos, **M**ensurables, **A**lcanzables, **R**elevantes y **S**ensibles al **T**iempo.
    
3. **Priorización (Dirigida por Riesgos):** Utilizar una matriz de priorización con _stakeholders_ para identificar los QAs más importantes, reconociendo que existe **compensación (trade-off)** entre ellos (Ej. Más Seguridad $\to$ Menos Desempeño).
    

---

## IV. Metodología y Diseño

### A. Proceso Unificado de Rational (RUP)

- **Definición:** Metodología iterativa e incremental dirigida a objetos, precursora del desarrollo ágil.
    
- **Fases Principales:** **Incepción** (Alcance, ROI) $\to$ **Elaboración** (Arquitectura, Especificación detallada, Mitigación de riesgos) $\to$ **Construcción** (Implementación) $\to$ **Transición** (Despliegue).
    
- **Principios Rectores:**
    
    1. **Dirigido por Casos de Uso:** Los UC impulsan todas las fases (diseño, implementación, pruebas).
        
    2. **Dirigido por la Arquitectura:** Énfasis en el diseño y validación continua de la arquitectura.
        
    3. **Dirigido por Riesgos:** Priorizar actividades para mitigar los riesgos más importantes en las primeras iteraciones.
        

### B. Patrones de Diseño GRASP

Los UC son la base para aplicar los patrones GRASP en el **Diseño Orientado a Objetos** para asignar responsabilidades a las clases.

- **Controlador (Controller):** Clase que recibe la primera interacción del UC y delega la responsabilidad a otras clases. (Regla: Un controlador por UC principal o por conjunto de UC relacionados).
    
- **Experto en Información (Information Expert):** Asigna la responsabilidad de una tarea a la clase que posee la **información necesaria** para completarla (Ej. la clase `Venta` calcula el total, pues contiene los artículos y precios).
    

---

**Conclusión:** Los **Casos de Uso** actúan como una **Herramienta de Comunicación** clave, sirviendo como el **vínculo** entre el Analista, el Desarrollador y el Probador para asegurar que el sistema satisfaga los objetivos de negocio.


Comprendido. Procederé a generar la **versión completa y final de la traducción rigurosa** de todos los segmentos proporcionados, manteniendo la estructura técnica, el formato jerárquico y el glosario especializado.

---

# 📜 TRADUCCIÓN TÉCNICA RIGUROSA COMPLETA

Esta es la traducción consolidada de todos los segmentos del texto original, aplicando el Protocolo de Traducción Rigurosa.

## I. Especificación de Calidad: La Técnica SMART y Escenarios

### A. La Estructura de un Atributo de Calidad (QA)

Una técnica para **escribir** los **_Atributos de Calidad_** de una **manera mensurable** o de **tipo SMART** utiliza cinco componentes esenciales:

|**Componente**|**Definición**|
|---|---|
|**Fuente de Estímulo** (Stimulus Source)|Actor, sistema externo o factor temporal que inicia la acción.|
|**Estímulo** (Stimulus)|La acción o evento que ocurre.|
|**Elemento de Software** (System)|La parte del Sistema afectada.|
|**Respuesta** (Response)|La acción o resultado que el Sistema debe entregar.|
|**Medida de Respuesta** (Response Measure)|La métrica cuantificable (el qué tan bien) que define el éxito.|

**Ejemplo Completo (Desempeño):** **_"Cuando un usuario solicita generar un reporte, el Sistema de Reportes genera el reporte en menos de 10 segundos."_** Esto es **mucho más específico** que decir: _"El sistema será rápido"_.

### B. Escenarios y Restricción Funcional

Nosotros tenemos **dos tipos de escenarios**: *_Escenarios de **_Casos de Uso_**_ (la historia de la interacción del usuario con el sistema, Ej. Paso 1, 2, 3) y *_Escenarios de **_Atributos de Calidad_**_ (la especificación formal de los QAs).

- **Punto Clave:** Los **_Atributos de Calidad_**, a través de sus escenarios, **restringen** a los **_Requerimientos Funcionales_**. **No restringen** al **_Caso de Uso_**.
    
- **Concepto:** Los **_Atributos de Calidad_** **restringen la implementación** de los **_Requerimientos Funcionales_**.
    

Fragmento de código

```
[ CASO DE USO ]
      |
      v
[ ESCENARIOS DE CASO DE USO ]
      |
      v
[ REQUERIMIENTOS FUNCIONALES (Pasos) ]
          ^
          | (RESTRICCIÓN: Medida de Respuesta)
 [ ESCENARIOS DE ATRIBUTOS DE CALIDAD (QA) ]
```

---

## II. Identificación y Diagramas UML de Casos de Uso

### A. Métodos de Identificación de Casos de Uso

|**Método**|**Enfoque**|
|---|---|
|**Basada en Actores**|Identificar Actores, luego Procesos de Negocio, luego UC.|
|**Basada en Escenarios**|Crear Escenarios ilustrativos, luego localizar UC, luego Actores.|
|**Basada en Eventos Externos**|Identificar eventos que el sistema debe responder, luego relacionarlos con Actores y UC.|
|**Análisis CRUD (Create, Read, Update, Delete)**|**Método más utilizado.** Identificar entidades de datos y definir UC necesarios para manipularlas.|

**Procedimiento Básico:** 1) Elegir el Límite del Sistema. 2) Identificar Actores Principales. 3) Identificar Objetivos de los Actores. 4) Definir UC que satisfagan esos objetivos.

> **Nota:** Los **Actores** pueden ser personas, sistemas, programas, aplicaciones o instituciones (ej. una agencia de impuestos).

### B. Diagramas UML y Relaciones

El **Modelo de Caso de Uso Completo** se compone del **Diagrama UML** y la **Especificación de Caso de Uso**.

|**Elemento**|**Definición y Notación**|
|---|---|
|**Asociación**|Relación básica entre Actor y UC. Resume la interacción gráficamente (línea simple).|
|**Generalización (Herencia)**|Indica que un UC es un tipo especial de otro (la flecha apunta al UC general/padre).|
|**Especialización de Actor**|Un actor hereda responsabilidades de un actor general (la flecha apunta al actor general/padre).|
|**Actores Principales**|Colocados al lado izquierdo; la flecha va **Actor $\to$ UC**.|
|**Actores de Soporte**|Colocados al lado derecho; la flecha va **UC $\to$ Actor**.|

#### **Relaciones de Uso entre Casos de Uso**

1. **`<<include>>` (Inclusión)**
    
    - **Propósito:** Reutilizar funcionalidad de un UC secundario en múltiples UC principales. Es **obligatorio** en el flujo.
        
    - **Notación:** Flecha del UC base **hacia** el UC incluido.
        
2. **`<<extend>>` (Extensión)**
    
    - **Propósito:** Agregar comportamiento **opcional** o **alternativo** a un UC base, sujeto a una **condición**.
        
    - **Notación:** Flecha del UC extendido **hacia** el UC base (el que se extiende).
        

---

## III. Proceso de Desarrollo y Diseño Orientado a Objetos

### A. Proceso Unificado de Rational (RUP)

**RUP** es una metodología **iterativa** (ciclos de trabajo) e **incremental** (agregar funcionalidad en cada ciclo), con un enfoque por fases.

#### **Fases de RUP**

1. **Incepción:** Definir el alcance, viabilidad, estimar ROI, **Modelado de Casos de Uso** (identificación).
    
2. **Elaboración:** Analizar el dominio, **diseñar la arquitectura**, **Especificación de Casos de Uso** (detalle), mitigar riesgos principales.
    
3. **Construcción:** Desarrollo (implementación/codificación) y pruebas unitarias/integración.
    
4. **Transición:** Despliegue, entrenamiento del usuario y ajustes finales.
    

#### **Principios Rectores de RUP**

1. **Dirigido por Casos de Uso (Use Case Driven):** Los UC impulsan todas las actividades (requerimientos, análisis, diseño, implementación y pruebas).
    
    > _La **Especificación** del UC **se convierte en el plan de pruebas** para el Probador._
    
2. **Dirigido por la Arquitectura (Architecture Centric):** Enfatiza el diseño y validación de la arquitectura de _software_ a lo largo de las iteraciones.
    
3. **Dirigido por Riesgos (Risk Driven):** Prioriza actividades que mitigan los riesgos más importantes en las primeras fases (Elaboración).
    

### B. Patrones de Diseño GRASP

Los patrones **GRASP (General Responsibility Assignment Software Patterns)** son un conjunto de nueve principios para asignar responsabilidades a las clases en el diseño orientado a objetos.

|**Patrón GRASP**|**Objetivo y Aplicación**|
|---|---|
|**Controlador (Controller)**|**Maneja los eventos del sistema** iniciados por un UC. Es la primera clase en recibir la solicitud. **Regla:** Un controlador por UC principal o por conjunto de UC relacionados.|
|**Experto en Información (Information Expert)**|Asigna la **responsabilidad** de una tarea a la **clase que posee la información** necesaria para ejecutarla (Ej. la clase `Venta` calcula el total, pues contiene precios y cantidades).|

---

## IV. Atributos de Calidad y Priorización Detallada

### A. Categorías de Atributos de Calidad

|**Grupo**|**Ejemplos Clave**|**Enfoque**|
|---|---|---|
|**Externos**|Disponibilidad, Desempeño, Seguridad (Security/Safety), Usabilidad, Interoperabilidad, Integridad.|Características **percibidas por el usuario** durante la ejecución.|
|**Internos**|Modificabilidad, Portabilidad, Reutilizabilidad, Escalabilidad, Verificabilidad.|Propiedades **observables por el desarrollador/tester** en el diseño y código.|

### B. El Proceso de Exploración y Priorización

Como la perfección es inalcanzable, se debe priorizar. El enfoque práctico es:

1. **Comenzar con una Taxonomía Amplia** (tomar todos los QAs posibles).
    
2. **Reducir la Lista** (involucrar a _stakeholders_ para evaluar cuáles son más relevantes, Ej. un kiosco necesita alta **Usabilidad**).
    
3. **Priorizar los Atributos** (usar una **Matriz de Priorización** para comparar QAs uno a uno y obtener un _score_ que revele los QAs críticos, entendiendo la **compensación/trade-off**).
    
4. **Traducirlos en Criterios Cuantificables** (utilizar la **Técnica SMART** para asegurar que los QAs sean Específicos, Mensurables, Alcanzables, Relevantes y Sensibles al Tiempo).
    

---

## V. Glosario Técnico Consolidado

|**Término Original**|**Traducción Consistente**|**Definición Clave**|
|---|---|---|
|**Stimulus Source**|**_Fuente de Estímulo_**|Actor, sistema o tiempo que inicia una acción en el sistema.|
|**Response Measure**|**_Medida de Respuesta_**|Métrica cuantificable que define el éxito del Atributo de Calidad (parte de la técnica SMART).|
|**CRUD Analysis**|**_Análisis CRUD_**|Identificación de UC basada en la manipulación de datos (Crear, Leer, Actualizar, Eliminar).|
|**<<include>> / <<extend>>**|**_Inclusión / Extensión_**|Relaciones de uso entre Casos de Uso. El primero es obligatorio, el segundo es condicional.|
|**RUP**|**_Proceso Unificado de Rational_**|Metodología de desarrollo iterativa, incremental y dirigida por Casos de Uso.|
|**Use Case Driven**|**_Dirigido por Casos de Uso_**|Principio de RUP donde los UC impulsan el análisis, diseño e implementación.|
|**GRASP**|**_Patrones Generales de Asignación de Responsabilidades_**|Principios de diseño OO para asignar responsabilidades a clases (ej. Controller, Information Expert).|
|**Information Expert**|**_Experto en Información_**|Patrón GRASP que asigna la responsabilidad a la clase que posee los datos para ejecutar la tarea.|
|**SMART Technique**|**_Técnica SMART_**|Estructura para escribir QAs de forma Específica, Mensurable, Alcanzable, Relevante y Sensible al Tiempo.|
|**Low Coupling**|**_Acoplamiento Bajo_**|Principio de diseño que busca minimizar las dependencias entre las clases.|
|**High Cohesion**|**_Alta Cohesión_**|Principio de diseño que busca que las responsabilidades de una clase estén fuertemente relacionadas entre sí.|


# 📖 Traducción Técnica Rigurosa: Ingeniería de Requisitos y Diseño

Este documento consolida la traducción y estructuración de todo el material original, cubriendo **Casos de Uso**, **Metodologías (RUP)**, **Diseño Orientado a Objetos (GRASP)** y **Atributos de Calidad (QAs)**.

---

## I. Fundamentos y Especificación de Casos de Uso (UC)

### A. Definición y Composición

- Un **_Caso de Uso_** describe la **secuencia de interacciones** entre un **Sistema** y un **Actor** que resulta en que el Actor logre un **resultado de valor**.
    
- El **Modelado de Casos de Uso** se compone de dos partes esenciales: el **Diagrama UML** (la ilustración) y la **Especificación de Caso de Uso** (el documento de texto).
    
- **Nomenclatura:** El nombre de un UC siempre debe ser **Verbo + Objeto** (Ej. **Registrar** Equipaje, **Procesar** Venta).
    

### B. Elementos de la Especificación Completa

La especificación completa (formato de dos columnas) contiene:

|**Elemento**|**Definición y Función**|
|---|---|
|**ID y Nombre**|Identificador único para **trazabilidad**.|
|**Actores**|**Primario** (quien ejecuta el UC) y **Secundario** (quien soporta o proporciona un servicio).|
|**Precondiciones**|El estado que debe ser **cierto antes** de que el UC comience.|
|**Post-condiciones**|El estado garantizado **al finalizar con éxito** el UC.|
|**Curso Normal (Happy Path)**|El escenario de **éxito principal** (flujo de pasos Actor/Sistema).|
|**Cursos Alternos / Extensiones**|Secuencias de pasos que se toman si ocurre una **condición** o **excepción**.|
|**Requisitos Especiales**|Los **_Requerimientos No Funcionales_** o **Atributos de Calidad (QAs)** específicos para este UC.|
|**Reglas de Negocio (BRs)**|Identificadores de las reglas que **restringen** o **influyen** en el flujo de este UC.|

> **Regla de Diseño:** La especificación debe indicar **QUÉ** debe hacer el sistema, no **CÓMO** (no incluir detalles de diseño como comandos SQL).

### C. Diagramación y Relaciones UML

|**Relación**|**Propósito**|**Regla de Dirección**|
|---|---|---|
|**Asociación**|Interacción básica entre Actor y UC.|**Actor Primario** $\to$ **UC**; **UC** $\to$ **Actor Secundario**.|
|**Generalización**|Un UC es una **especialización** de otro (Herencia).|Apunta al UC general/padre.|
|**`<<include>>` (Inclusión)**|Reutilizar funcionalidad común de un UC. Es **obligatorio**.|Del UC base **hacia** el UC incluido.|
|**`<<extend>>` (Extensión)**|Agregar comportamiento **opcional** bajo una condición.|Del UC extendido **hacia** el UC base.|

---

## II. Metodología y Diseño Orientado a Objetos

### A. El Proceso Unificado de Rational (RUP)

RUP es una metodología **iterativa** (en ciclos) e **incremental** (agregando funcionalidad) dirigida a objetos.

#### 1. Fases de RUP

- **Incepción:** Definir alcance, viabilidad, estimar ROI, **Modelado de Casos de Uso** (identificación).
    
- **Elaboración:** Diseñar arquitectura, **Especificación de Casos de Uso** (detalle), mitigar riesgos.
    
- **Construcción:** Implementación y pruebas.
    
- **Transición:** Despliegue y entrenamiento de usuarios.
    

#### 2. Principios Rectores

1. **Dirigido por Casos de Uso (Use Case Driven):** Los UC impulsan todas las actividades de desarrollo, desde la captura de requerimientos hasta las pruebas.
    
2. **Dirigido por la Arquitectura (Architecture Centric):** Se enfoca en el diseño y validación de la arquitectura desde el inicio.
    
3. **Dirigido por Riesgos (Risk Driven):** Se priorizan las actividades que mitigan los riesgos más importantes en las primeras fases.
    

### B. Patrones de Diseño GRASP

Los **Patrones GRASP (General Responsibility Assignment Software Patterns)** son principios para asignar responsabilidades a las clases, basándose en la especificación del Caso de Uso.

|**Patrón**|**Enfoque**|
|---|---|
|**Controlador (Controller)**|Clase que recibe la **interacción inicial** del UC y **delega** la tarea. (Debe haber **uno por UC principal** o conjunto de UC relacionados).|
|**Experto en Información (Information Expert)**|Asigna la responsabilidad de una operación a la **clase que posee la información** necesaria para ejecutarla (Ej. la clase `Venta` calcula el total, pues contiene la lista de artículos).|
|**Acoplamiento Bajo / Alta Cohesión**|Principios que buscan minimizar dependencias entre clases y enfocar las responsabilidades dentro de una clase, respectivamente.|

---

## III. Requerimientos No Funcionales (Atributos de Calidad)

Los **_Atributos de Calidad (QAs)_** definen cómo el sistema debe ser, son **medibles** y determinan el grado de satisfacción.

### A. Taxonomía de Atributos

|**Tipo**|**Observación**|**Ejemplos**|
|---|---|---|
|**Externos**|Perceptibles por el **Usuario** durante la ejecución.|**Usabilidad**, **Desempeño**, **Disponibilidad**, **Integridad**, **Seguridad (Security)**, **Completitud (Totalidad)**.|
|**Internos**|Perceptibles por el **Desarrollador** al examinar el código/diseño.|**Modificabilidad**, **Portabilidad**, **Reutilizabilidad**, **Escalabilidad**.|

> **Diferencia Seguridad:** **Security** (Acceso no autorizado) vs. **Safety** (Daño físico/operacional).

### B. El Proceso de Priorización y Especificación

1. **Priorización (Dirigida por Riesgos):** Utilizar una matriz de comparación entre _stakeholders_ para identificar los QAs críticos, reconociendo el **Trade-off (Compensación)** inherente (Ej. mejorar Seguridad puede disminuir Desempeño).
    
2. **Especificación Cuantificable:** Evitar la ambigüedad (Ej. "fácil de usar") y utilizar la **Técnica SMART** para que los QAs sean:
    
    - **E**specíficos
        
    - **M**ensurables (Medibles)
        
    - **A**lcanzables
        
    - **R**elevantes
        
    - **T** Sensibles al Tiempo (Time-sensitive)
        

---

## IV. Glosario Técnico Consolidado

|**Término (Original)**|**Traducción Consistente**|**Contexto de Uso**|
|---|---|---|
|**Stakeholders**|**_Interesados_**|Cualquier persona o entidad afectada por el proyecto.|
|**Use Case Driven**|**_Dirigido por Casos de Uso_**|Principio de RUP donde el diseño y pruebas se basan en los UC.|
|**Information Expert**|**_Experto en Información_**|Patrón GRASP que asigna la responsabilidad a la clase con los datos.|
|**Testability**|**_Facilidad de Prueba_**|Atributo de Calidad (Interno) que mide la facilidad para exhibir fallos.|
|**Interoperability**|**_Interoperabilidad_**|Atributo de Calidad (Externo) que mide la facilidad de intercambio de información con otros sistemas (Ej. vía API).|
|**SMART Technique**|**_Técnica SMART_**|Estructura para escribir requerimientos **Mensurables** (Measurable).|
|**Trade-off**|**_Compensación_**|El equilibrio de diseño entre atributos que se oponen (Ej. Seguridad vs. Desempeño).|

---

Espero que esta consolidación clara y estructurada cumpla con su requerimiento. ¿Desea que revise o amplíe alguna de las secciones presentadas?


## 🔁 Flujo Alternativo con Retorno al Curso Normal

El objetivo de un **Flujo Alternativo** es manejar una condición o excepción (que puede ser de éxito o fracaso) y, una vez resuelta, permitir que el usuario **continúe** con la meta principal del Caso de Uso.

### Ejemplo Detallado: Caso de Uso "Procesar Venta"

Tomemos como ejemplo el Caso de Uso: **Procesar Venta**.

|**Paso**|**Acción del Actor (Cajero)**|**Responsabilidad del Sistema**|
|---|---|---|
|**Flujo Normal (Curso 1)**|||
|1|El Cajero inicia una nueva venta.|El Sistema registra la hora de inicio de la venta.|
|2|El Cajero ingresa el identificador de un artículo.|El Sistema busca el producto y agrega la línea de detalle a la venta.|
|3|El Cajero repite el paso 2 hasta finalizar los artículos.|El Sistema calcula el subtotal y el total con impuestos.|
|**4**|El Cajero pregunta el método de pago al Cliente.|El Sistema muestra el total a pagar.|
|**Flujo Alternativo (4.1): Artículo No Encontrado**|||
|**4.1 a**|**(Punto de Extensión)** El Sistema detecta que el identificador no existe o está inactivo.|**El Sistema muestra un mensaje de error:** "Artículo Inactivo/Desconocido. ¿Desea intentarlo de nuevo?".|
|**4.1 b**|El Cajero reingresa el identificador.|El Sistema procesa el identificador reingresado.|
|**4.1 c**|**(Retorno)** El flujo **regresa al Paso 3 del Flujo Normal** (repetición de ingreso de artículos).||
|**Flujo Normal (Continuación)**|||
|5|El Cliente indica el pago con Tarjeta de Crédito.|El Sistema solicita la autorización a un **Sistema Externo de Pagos**.|
|6||El Sistema registra el pago y emite el recibo.|
|7|El Cajero entrega el recibo y los artículos al Cliente.|El Sistema finaliza la venta.|

### Diagrama de Actividad Simplificado

En este ejemplo:

- La **Condición** del Flujo Alternativo (4.1) se dispara cuando el Sistema no encuentra el artículo.
    
- La **Manipulación** del Flujo Alternativo (4.1 a, b) gestiona el error y pide una corrección.
    
- El flujo alternativo **regresa al Paso 3** del flujo principal, permitiendo que la meta final (procesar la venta) se complete con éxito.
    

---

## 🎭 Actores Primarios vs. Actores Secundarios en UML

En un **Diagrama UML de Caso de Uso**, la diferencia entre los Actores Primarios y Secundarios (o de Soporte) se establece por la **dirección de la flecha de asociación**. Esto refleja **quién inicia** la interacción y **quién proporciona** un servicio.

### Reglas de Dirección

|**Tipo de Actor**|**Propósito**|**Notación en Diagrama**|
|---|---|---|
|**Actor Primario**|El actor que tiene un **objetivo de negocio** y **ejecuta el Caso de Uso** para lograrlo. Es el **desencadenador** o iniciador principal.|La flecha de asociación va **del Actor $\to$ al Caso de Uso**.|
|**Actor Secundario (Soporte)**|El actor (humano o sistema) que **proporciona servicios, información, o recursos** al sistema durante la ejecución del Caso de Uso. **No inicia** el proceso.|La flecha de asociación va **del Caso de Uso $\to$ al Actor Secundario**.|

### Ejemplo de Diagrama

En el ejemplo anterior de **Procesar Venta**:

- **Cajero (Actor Primario):** La flecha va del **Cajero** al óvalo **Procesar Venta**. El Cajero es quien inicia la venta.
    
- **Sistema de Pagos Externo (Actor Secundario):** La flecha va del óvalo **Procesar Venta** al **Sistema de Pagos Externo**. El Caso de Uso necesita que este sistema provea un servicio (autorización de tarjeta) para poder completarse.
    

¿Le gustaría que ejemplifiquemos el Flujo Alternativo con una excepción de **fracaso** (donde no se regresa al flujo normal, sino que se termina)?


## 🛑 Flujo Alternativo con Excepción de Fracaso

En este escenario, el flujo alternativo no resuelve una condición para volver al curso normal, sino que se encuentra con un **error crítico** o una **regla de negocio infranqueable** que impide la finalización exitosa del Caso de Uso.

### Ejemplo Detallado: Caso de Uso "Retirar Efectivo"

Tomemos como ejemplo el Caso de Uso: **Retirar Efectivo** de un cajero automático (ATM).

|**Paso**|**Acción del Actor (Cliente)**|**Responsabilidad del Sistema**|
|---|---|---|
|**Flujo Normal (Curso 1)**|||
|1|El Cliente inserta la tarjeta.|El Sistema valida la tarjeta e inicia la sesión.|
|2|El Cliente ingresa el PIN.|El Sistema valida el PIN y muestra el menú principal.|
|**3**|El Cliente selecciona "Retiro" e ingresa la cantidad ($500).|El Sistema solicita la cantidad de dinero.|
|**Flujo Alternativo (3.1): Fondos Insuficientes (Fracaso)**|||
|**3.1 a**|**(Punto de Extensión)** El Sistema detecta que la cuenta tiene menos de $500.|**El Sistema consulta el saldo de la cuenta.**|
|**3.1 b**|El Sistema detecta que el saldo es insuficiente.|**El Sistema muestra un mensaje de error crítico:** "Fondos insuficientes. Intente con una cantidad menor."|
|**3.1 c**|El Cliente presiona el botón "Cancelar".|El Sistema expulsa la tarjeta.|
|**3.1 d**|**(Terminación)** El flujo **termina aquí**, ya que el objetivo principal (Retirar Efectivo) **no se logró**.|El Sistema registra la transacción fallida y el UC finaliza.|
|**Flujo Normal (Continuación NO aplica)**|_(No se puede continuar con el paso 4 o 5)_|_(El Caso de Uso ha terminado sin éxito)_|

### Diagrama de Actividad Simplificado

En este ejemplo:

- La **Condición** del Flujo Alternativo (3.1) es la detección de que el **saldo es insuficiente**.
    
- La **Manipulación** del Flujo Alternativo (3.1 a, b, c) gestiona la excepción y avisa al cliente.
    
- El flujo alternativo conduce directamente a una **terminación del Caso de Uso**, señalizando que el objetivo del Actor Primario no se pudo alcanzar. Este final se marca con un **nodo final** (un círculo con un círculo concéntrico lleno).


# 📜 TRADUCCIÓN TÉCNICA RIGUROSA COMPLETA (VERSIÓN CONSOLIDADA)

Este documento es la consolidación y traducción estructural de todos los segmentos del texto original, abarcando la Ingeniería de Requerimientos, Modelado UML, RUP, GRASP, y Atributos de Calidad.

## I. Fundamentos, Especificación y Modelado de Casos de Uso (UC)

### A. Definición y Composición

- Un **_Caso de Uso_** es un término de ingeniería de software que describe una **secuencia de interacciones** entre un **Sistema** y un **Actor** que resulta en que el Actor sea capaz de lograr un **resultado de valor**.
    
- Los UC fueron introducidos en 1986 por **Ivar Jacobson**.
    
- **Diferenciación:**
    
    - **Especificación de Caso de Uso:** Es el **documento de texto** que describe la secuencia de interacciones.
        
    - **Modelado de Diagramas UML de Casos de Uso:** Es la **ilustración gráfica** de los nombres de los UC, los actores y sus relaciones en una sola vista (fotografía).
        
- **Nomenclatura:** El nombre de un UC siempre se escribe en la forma de **Verbo + Objeto** (Ej. **Registrar** en Vuelo, **Imprimir** Pases de Abordar).
    

### B. Métodos de Identificación de Casos de Uso

La identificación se basa en Actores, Escenarios, o Procesos. El método más utilizado es el **Análisis CRUD** (**Create, Read, Update, Delete**) sobre las entidades de datos del sistema.

### C. Actores y Rol en el Diagrama

Los Actores son entes (persona, otro sistema, hardware, base de datos) que interactúan con el sistema.

| Tipo de Actor | Función | Dirección de la Flecha (Asociación) |

| :--- | :--- | :--- |

| Primario | Tiene un objetivo específico, ejecuta el UC y lo dispara. | Actor $\to$ Caso de Uso |

| Secundario | Proporciona un servicio (información, soporte) al sistema. | Caso de Uso $\to$ Actor |

### D. Elementos de la Especificación Completa

El formato completo se utiliza en el curso y contiene:

1. **ID y Nombre:** Identificador único para trazabilidad.
    
2. **Actores Primarios/Secundarios:** Identificación de quién interactúa.
    
3. **Descripción y Lanzador (Trigger):** Descripción general del objetivo y la acción que inicia el UC.
    
4. **Precondiciones:** El estado que debe ser **cierto antes** de la ejecución del UC (0 o más).
    
5. **Post-condiciones:** El estado garantizado **al finalizar con éxito** el UC.
    
6. **Flujo Normal (Curso Normal / Happy Path):** La secuencia típica de éxito (en **formato de dos columnas**: Acción del Actor | Responsabilidad del Sistema).
    
7. **Flujos Alternos / Extensiones:** Escenarios secundarios, incluyendo éxito o fracaso. Tienen una **condición** (detectada por el sistema) y una **manipulación** (pasos para manejarla).
    
8. **Requisitos Especiales / Reglas de Negocio:** **Requerimientos No Funcionales** o **BRs** específicas relacionadas con ese UC.
    

> **Regla de Especificación:** Los escenarios deben especificar **QUÉ** hace el sistema, **sin describir CÓMO se hará** (evitar detalles de diseño o implementación).

### E. Relaciones de Uso entre Casos de Uso (UML)

|**Relación**|**Propósito**|**Regla de Obligatoriedad**|**Notación**|
|---|---|---|---|
|**`<<include>>`**|Reutilizar funcionalidad común de un UC.|**Obligatorio/Forzoso**|Del UC base **hacia** el UC incluido.|
|**`<<extend>>`**|Agregar comportamiento **opcional** o alternativo condicional.|**Condicional/Opcional**|Del UC extendido **hacia** el UC base.|
|**Generalización**|Un UC es una **especialización** de otro (Herencia).|N/A|Flecha dirigida al UC general/padre.|

---

## II. Metodología RUP y Diseño OO con GRASP

### A. El Proceso Unificado de Rational (RUP)

RUP es una metodología **orientada a objetos**, **iterativa** e **incremental** y fue un precursor de las metodologías ágiles.

#### 1. Fases de RUP

1. **Incepción:** Definición de **Alcance**, **ROI**, **Modelado de Casos de Uso** (identificación inicial).
    
2. **Elaboración:** **Diseño de la Arquitectura**, **Especificación detallada de Casos de Uso**, mitigación de **Riesgos principales**.
    
3. **Construcción:** **Implementación** (codificación) y pruebas.
    
4. **Transición:** **Despliegue** y entrega a usuarios finales.
    

#### 2. Principios Rectores

1. **Dirigido por Casos de Uso (Use Case Driven):** Los UC impulsan la captura de requerimientos, análisis, diseño, implementación y pruebas.
    
    > _La **Especificación** del UC se convierte en el plan de pruebas del Probador._
    
2. **Dirigido por la Arquitectura (Architecture Centric):** Enfatiza el diseño y la validación continua de la arquitectura.
    
3. **Dirigido por Riesgos (Risk Driven):** Prioriza las actividades de desarrollo que mitigan los riesgos (evento incierto con impacto positivo/negativo) más importantes en las primeras iteraciones.
    

### B. Patrones de Diseño GRASP

Los **Patrones GRASP (General Responsibility Assignment Software Patterns)** son un conjunto de nueve principios utilizados para **asignar responsabilidades a las clases** en el diseño.

|**Patrón GRASP**|**Objetivo**|**Principio Relacionado**|
|---|---|---|
|**Controlador (Controller)**|Clase que **maneja los eventos del sistema** iniciados por un UC y delega la responsabilidad.|Se relaciona con la **Usabilidad** al centralizar el manejo de interacciones.|
|**Experto en Información (Information Expert)**|Asigna la responsabilidad a la **clase que posee la información** necesaria para cumplirla.|Contribuye a la **Alta Cohesión** y el **Bajo Acoplamiento**.|
|**Acoplamiento Bajo / Alta Cohesión**|Metas principales: **Minimizar dependencias** (Acoplamiento) y **Enfocar responsabilidades** dentro de la clase (Cohesión).|Contribuyen a la **Facilidad de Mantenimiento** y **Modificabilidad**.|

---

## III. Atributos de Calidad (Requerimientos No Funcionales)

### A. Naturaleza y Categorías

- Los **Atributos de Calidad (QAs)** son también llamados **Requerimientos No Funcionales**.
    
- Son **características medibles** que verifican el **grado de satisfacción** de los usuarios y desarrolladores.
    

|**Tipo de QA**|**Observación**|**Ejemplos Clave**|
|---|---|---|
|**Externos**|Se observan cuando el software **se está ejecutando** (experiencia del usuario).|**Usabilidad**, **Desempeño**, **Disponibilidad**, **Integridad**, **Interoperabilidad**, **Seguridad (Security/Safety)**.|
|**Internos**|Propiedades que percibe el **Desarrollador** al examinar el código o diseño.|**Modificabilidad**, **Portabilidad**, **Reutilizabilidad**, **Escalabilidad**, **Verificabilidad**.|

> **Diferenciación de Seguridad:** **Safety** (Seguridad Física/Operacional, protección contra daño) vs. **Security** (Seguridad de Datos, protección contra accesos no autorizados).

### B. Exploración y Especificación

Debido a que la perfección es inalcanzable (existe el **trade-off** o **compensación** entre QAs, Ej. Seguridad vs. Desempeño), la priorización es esencial.

1. **Taxonomía y Reducción:** Iniciar con una lista amplia de QAs y reducirla evaluando su **relevancia** con los _stakeholders_.
    
2. **Priorización:** Utilizar matrices para comparar QAs y obtener un _score_ que determine cuáles son críticos para el proyecto.
    
3. **Cuantificación (Técnica SMART):** Los QAs deben ser escritos de forma:
    
    - **E**specíficos
        
    - **M**ensurables (Medibles)
        
    - **A**lcanzables
        
    - **R**elevantes
        
    - **T** Sensibles al Tiempo (Time-sensitive)
        

---

## IV. Glosario Técnico Completo

| **Término Original**             | **Traducción Consistente**                        | **Definición en Contexto**                                                                  |
| -------------------------------- | ------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| **Scenarios / Flow / Course**    | **_Escenarios / Flujo / Curso_**                  | Una secuencia específica, instancia o "historia" de uso del sistema.                        |
| **Happy Path**                   | **_Curso Normal / Camino Feliz_**                 | El escenario de éxito principal, sin condiciones o ramificaciones.                          |
| **Precondition / Postcondition** | **_Precondición / Post-condición_**               | Estado del sistema antes de iniciar/después de terminar un UC exitoso.                      |
| **Risk Driven**                  | **_Dirigido por Riesgos_**                        | Principio RUP que prioriza las actividades para mitigar eventos inciertos con alto impacto. |
| **Safety / Security**            | **_Seguridad Operacional / Seguridad de Acceso_** | Protección contra daños físicos/percances vs. protección contra usos no autorizados.        |
| **Low Coupling / High Cohesion** | **_Acoplamiento Bajo / Alta Cohesión_**           | Metas de diseño OO para minimizar dependencias y enfocar responsabilidades.                 |
| **Interoperability**             | **_Interoperabilidad_**                           | Grado en que varios sistemas pueden intercambiar información entre sí (Ej. vía API).        |
| **Trade-off**                    | **_Compensación_**                                | El balance necesario al priorizar QAs, donde la mejora de uno afecta negativamente a otro.  |
| **SMART Technique**              | **_Técnica SMART_**                               | Estructura para escribir requerimientos específicos y mensurables.                          |



# 🔎 Identificación y Modelado Avanzado de Casos de Uso

## I. Estrategias de Identificación de Casos de Uso

Existen diversas metodologías para **descomponer una problemática** e identificar los **_Casos de Uso_** que un sistema debe soportar.

|**Estrategia**|**Procedimiento Básico**|**Enfoque**|
|---|---|---|
|**Basada en Actores**|Identificar Actores $\to$ Buscar Actividades en Procesos de Negocio $\to$ Definir UC.|**De afuera hacia adentro.**|
|**Basada en Escenarios**|Crear Escenarios $\to$ Localizar Casos de Uso $\to$ Identificar Actores involucrados.|**De adentro hacia afuera.**|
|**Basada en Procesos**|Preguntar: ¿Qué **tareas** se requieren para completar este proceso o convertir entradas en salidas? $\to$ Desglosar UC.|**Análisis de tareas funcionales.**|
|**Basada en Eventos Externos**|Identificar **eventos** a los que el sistema debe responder $\to$ Relacionar eventos con Actores y UC específicos.|**Análisis de contexto y respuesta.**|
|**Análisis CRUD**|**La más utilizada.** Identificar **entidades de datos** y definir los UC necesarios para **Crear, Leer, Actualizar o Eliminar (Manipular)** datos.|**Análisis enfocado en la manipulación de datos.**|

### A. Procedimiento Básico para la Identificación

1. Elegir el **Límite del Sistema** (hardware, software, web, móvil, etc.).
    
2. Identificar los **Actores Principales** (aquellos con metas que se cumplen con los servicios del sistema).
    
3. Identificar los **Objetivos** de estos Actores.
    
4. Definir y nombrar los **Casos de Uso** que satisfacen esos objetivos (Verbo + Objeto).
    

> **Nota sobre Alcance:** Los **Actores** y sus **Metas** dependen del **Alcance** y los **Límites** del sistema con el que interactúan.

---

## II. Profundización en Diagramas UML de Casos de Uso

El **Lenguaje de Modelado Unificado (UML)** es un **lenguaje estandarizado** de diseño de software (orientado a objetos), creado por el Object Management Group (OMG). UML tiene 14 tipos de diagramas divididos en dos categorías: **Estructural** y **de Comportamiento** (donde se encuentran los diagramas de Casos de Uso).

Un **Modelo de Caso de Uso Completo** está compuesto por el **Diagrama UML de Casos de Uso** y la **Especificación de Caso de Uso**.

### A. Elementos Gráficos y Semántica

|**Elemento**|**Representación**|**Significado Semántico**|
|---|---|---|
|**Límite del Sistema**|Rectángulo.|Delimitación del alcance del sistema.|
|**Caso de Uso**|Óvalo.|Representa el objetivo de valor que el Actor logra.|
|**Actor Humano**|Figura de palo (Stick Figure).|Entidad que interactúa con el sistema.|
|**Actor No Humano**|Rectángulo o Figura de palo con **Estereotipo** (Ej. `<<System>>`).|Entidad de _software_ o institución (Ej. Hacienda, Base de Datos).|
|**Asociación**|Línea simple.|Relación básica; indica que un actor **participa** o **comunica** con el UC, sin mostrar detalles del flujo.|

### B. Posicionamiento y Buenas Prácticas

- **Actores Primarios:** Se colocan, por **buena práctica**, en el **lado izquierdo** (flecha Actor $\to$ UC).
    
- **Actores Secundarios/Soporte:** Se colocan, por **buena práctica**, en el **lado derecho** (flecha UC $\to$ Actor).
    

### C. Especialización de Actores

- Muestra **herencia** donde un Actor es un tipo especializado de otro.
    
- La flecha direccionada **apunta hacia el Actor general/padre**.
    
    > **Ejemplo:** **Administrador** $\leftarrow$ **Staff de Ventas**. (Un Administrador es una especialización, con atributos adicionales, de un Staff de Ventas).
    

---

## III. Relaciones Avanzadas entre Casos de Uso

### A. Generalización de Casos de Uso (Herencia)

- Muestra que un UC es una **especialización** de otro (Ej. Aceptar Efectivo es un tipo especial de Aceptar Pago).
    
- Se utiliza una flecha con punta triangular, dirigida hacia el **UC general/padre**.
    

### B. Inclusión (`<<include>>`)

- **Propósito:** Reutilizar un conjunto de funcionalidades comunes en **múltiples** Casos de Uso.
    
- **Comportamiento:** El UC base **incluye forzosamente** el comportamiento del UC incluido en su flujo.
    
- **Notación:** Flecha **discontinua** con punta de flecha abierta, etiquetada como `<<include>>`, que va **del UC base $\to$ hacia el UC incluido**.
    
    > **Ejemplo:** **Tomar Orden del Cliente** $\to$ `<<include>>` $\to$ **Identificar Cliente**. (En algún paso del flujo de _Tomar Orden_, se reutilizan los pasos completos de _Identificar Cliente_).
    

### C. Extensión (`<<extend>>`)

- **Propósito:** Indicar que un UC agrega o reemplaza comportamiento de otro UC **solo bajo ciertas condiciones**.
    
- **Comportamiento:** Debe tener un **punto de extensión** y una **condición**. Es **opcional/condicional**.
    
- **Notación:** Flecha **discontinua** con punta de flecha abierta, etiquetada como `<<extend>>`, que va **del UC extendido $\to$ hacia el UC base**.
    
    > **Ejemplo:** **Escáner de Productos** $\to$ `<<extend>>` $\to$ **Introducir Código Manualmente**. (El flujo principal solo se extiende a **Introducir Código Manualmente** si el escáner falla [condición]).
    

### D. Consideraciones Finales del Diagrama UML

- El Diagrama UML **no representa el flujo de información** ni la **secuencia de eventos**. No se lee: "UC1 $\to$ UC2 $\to$ UC3".
    
- Los Actores no siempre son personas; pueden ser **sistemas, bases de datos u organizaciones**.
    

---

Todo claro hasta aquí. ¿Necesita que profundice en la aplicación del `<<extend>>` con las condiciones de punto de extensión?



## 🧩 Patrón `<<extend>>`: Condiciones y Puntos de Extensión

El patrón `<<extend>>` modela una relación donde un Caso de Uso **(UC Extensor)** agrega funcionalidades a un Caso de Uso **base (UC Base)** **solo si se cumple una condición específica**.

### 1. Componentes Clave

Para que una relación `<<extend>>` sea válida y útil, requiere la especificación de tres elementos:

|**Componente**|**Definición**|**Requisito**|
|---|---|---|
|**UC Base**|El Caso de Uso principal que tiene un flujo normal.|Debe especificar **Puntos de Extensión**.|
|**UC Extensor**|El Caso de Uso que contiene el comportamiento **opcional** o alternativo.|Debe especificar la **Condición de Extensión**.|
|**Condición de Extensión**|Una regla o _boolean_ que debe ser evaluada como _verdadera_ para que el comportamiento extensor sea inyectado en el flujo base.|Debe ser **medible** y **evaluable** por el sistema.|
|**Punto de Extensión**|Un **punto o paso nombrado** dentro del flujo del UC Base donde la funcionalidad extensor puede ser inyectada.|Permite al extensor **saber dónde inyectar** su funcionalidad.|

---

### 2. Especificación en el Flujo

La clave para aplicar `<<extend>>` es que el **UC Base** (el que se extiende) debe ser **consciente** de dónde se le permite ser extendido.

#### A. Especificación del UC Base (El que es extendido)

El documento de especificación del UC Base debe incluir una sección donde se nombran los puntos específicos de su flujo donde la extensión es posible.

|**Sección**|**Contenido**|
|---|---|
|**Puntos de Extensión**|_Ejemplo:_ 1. **Punto de Ingreso de Código:** Después del paso 3, "El Cajero introduce el identificador del artículo." 2. **Punto de Pago:** Después del paso 6, "El Sistema muestra el total y pregunta por el método de pago."|

#### B. Especificación del UC Extensor (El que extiende)

El UC Extensor especifica:

1. **El UC Base** al que aplica.
    
2. **El Punto de Extensión** exacto (nombre del paso en el UC Base).
    
3. La **Condición** que dispara la extensión.
    

|**Elemento**|**Descripción (Ejemplo: Extender: Ingreso Manual de Código)**|
|---|---|
|**UC Base**|**Escanear Artículos**|
|**Punto de Extensión**|**Punto de Ingreso de Código**|
|**Condición**|_`IF Scanner falla o identificador no es detectado`_|
|**Flujo Extensor**|1. El Cajero introduce el identificador manualmente. 2. El Sistema valida la entrada y regresa al flujo base.|

---

### 3. Ejemplo de Aplicación

Consideremos el ejemplo del escaneo de productos en un punto de venta.

#### ❖ Diagrama y Notación

- La flecha `<<extend>>` va **del UC Extensor** (Introducir Código Manualmente) **hacia el UC Base** (Escanear Artículos).
    
- La relación se etiqueta con la condición que dispara la extensión, generalmente entre llaves: **`{Scanner falla}`**.
    

#### ❖ Semántica Condicional

Si el Flujo Normal del UC Base **Escanear Artículos** llega al **Punto de Ingreso de Código**:

- **Evalúa la Condición:** ¿El escáner falló?
    
    - **Si SÍ** (Condición Verdadera): El comportamiento del UC Extensor **Introducir Código Manualmente** se inyecta en ese punto. El sistema espera la entrada manual.
        
    - **Si NO** (Condición Falsa): El flujo de **Escanear Artículos** **continúa normalmente**, ignorando el UC Extensor.
        

La diferencia crucial con `<<include>>` es que la inclusión es **siempre obligatoria** en el paso definido, mientras que la extensión es **siempre condicional**.









------

### **Segmento 2: Identificación y Diagramas UML de Casos de Uso**

Analizaremos la **identificación de casos de uso**: cómo identificar estos **casos de uso** al recibir un **problema** o una **problemática**, cómo descomponerla y comenzar a identificarlos. Profundizaremos en los **diagramas UML de casos de uso**; si bien en la **clase** pasada profundizamos en la **especificación de casos de uso**, ahora lo haremos en los **diagramas UML de casos de uso**. **Larman** propone diferentes maneras de identificar **casos de uso**. La primera forma es identificando primero los **actores**. Una vez que identificamos los **actores** de un **sistema** o de una **problemática**, buscamos los **procesos del negocio** y la relación que existirá entre estos **actores** y **procesos**. A partir de esto, definimos los **casos de uso**. Por lo tanto, lo primero es identificar a los **actores** relacionados en el **proceso del negocio**. Luego, buscamos las **actividades** de estos **actores** en esos **procesos** y, a partir de ahí, identificamos los **casos de uso**.

Otra forma de identificar **casos de uso** es a través de la **creación de escenarios**. Es decir, tenemos la **problemática** y, a partir de ella, empezamos a crear **escenarios** para ilustrar cada uno de los **procesos** de este **negocio**. Luego, a través de estos **escenarios**, localizamos los **casos de uso** e identificamos los **actores** involucrados. Esto aborda la **problemática** de manera inversa: creamos los **escenarios** y, a partir de ellos, identificamos los **actores**. Una forma más de identificar **casos de uso** es utilizando una **descripción de procesos de negocio**. Debemos preguntarnos qué **tareas** deben realizarse para completar este **proceso** o convertir estas **entradas** en **salidas**. A partir de este **análisis**, podemos desglosar **casos de uso**. Otra técnica es identificar **eventos externos** a los que el **sistema** debe responder y relacionar estos **eventos** con **actores participantes** y **casos de uso** específicos. Esto significa que nuestro **contexto** se enfoca hacia afuera; identificamos los **eventos** que pueden ocurrir en el **proceso** y, a partir de estos **eventos**, los relacionamos con los **actores** y **casos de uso** específicos.

Una de las maneras más sencillas o más utilizadas para identificar **casos de uso** es el **análisis CRUD**. El **análisis CRUD** consiste en identificar **entidades de datos** que requieran **casos de uso** para **Crear**, **Leer**, **Actualizar**, **Eliminar** o **Manipular datos**. Es decir, buscamos qué tipo de **procesos** requieren que se **creen**, **lean**, **actualicen**, **eliminen** o **manipulen datos**, y a partir de esto, realizamos el **análisis CRUD** para identificar los **casos de uso**. Otra forma es examinando el **diagrama de contexto** y preguntando qué **objetivos** buscan lograr cada una de estas **entidades externas** con la ayuda del **sistema**. La manera más utilizada es el **análisis CRUD**, aunque también se puede empezar identificando primero los **actores**. El **procedimiento básico** es: primero, debemos elegir el **límite del sistema** (es decir, si es una **aplicación móvil**, una **aplicación de escritorio**, una **aplicación web** o si implica tanto **hardware** como **software**); delimitamos o establecemos un **límite de nuestro sistema**. El segundo paso es identificar los **actores principales**: aquellos que tienen **metas de usuario** que se cumplen mediante el uso de los **servicios del sistema**, o aquellos que ejecutarán los **casos de uso**. Identificamos los **actores principales** y, para cada uno de ellos, sus **objetivos** (es decir, el **valor** que obtendrán a través de la **ejecución de estos casos de uso**). Finalmente, definimos los **casos de uso** que satisfagan esos **objetivos**, de modo que al momento en que el **usuario** o el **actor** ejecute este **caso de uso**, esté relacionado con el **objetivo** que desea lograr. Debemos nombrarlos de acuerdo al **objetivo**.


Una **nota**: los **actores** y las **metas** dependen del **alcance** y los **límites del sistema**. Analicemos este **diagrama** . En el centro tenemos un **sistema de punto de venta**, el cual tiene un **alcance** delimitado. En este **alcance**, el **actor** **Cajero** actúa sobre este **punto de venta**; este es su **alcance**. **Entonces**, la **meta** y el **alcance** de este **actor** están limitados por el **sistema de punto de venta**. Viéndolo hacia afuera, tenemos que este **punto de venta** está dentro de otro **sistema** o un **servicio** llamado **Check Out** o de salida o de **venta de productos**. Está relacionado con un **actor**, que es un **Sistema de Actividad de Ventas**. Las **metas** y el **alcance** de este **Sistema de Actividad de Ventas** son específicos. Por lo tanto, el **objetivo** o **alcance** del **Cajero** es **procesar las ventas** sobre el **punto de venta**. El **objetivo** del **Sistema de Actividad de Ventas** es **analizar las ventas** y el **desempeño de los datos** sobre el **servicio de Check Out**. Estos otros dos **actores** actúan o tienen su **alcance** sobre un **sistema empresarial de venta**, el cual, a su vez, se relaciona con estos **actores** o **sistemas**. ¿Cuáles son los **objetivos** de estos **actores** superiores? Uno de ellos, supongamos que es una **Agencia de Impuestos sobre la Venta**, su **objetivo** es **recolectar los impuestos sobre ventas**. El otro es el **Cliente**, cuyo **objetivo** es **comprar artículos**. En resumen, los **actores** y las **metas** dependen del **alcance** y los **límites del sistema** con el que interactúan. ¿Queda claro? **Los actores** pueden ser **personas** o **sistemas** (como **programas**, **aplicaciones** o **bases de datos**). Como vemos en el ejemplo, este **actor** es un **sistema**. Este otro **actor** no es un **sistema** ni una **persona**, sino una **entidad** o una **institución** que es la **Agencia de Recolección de Impuestos de Ventas** (en **México** sería **Hacienda**), que actúa como **actor** sobre un **sistema de venta**. ¿Queda claro? **Continuemos**.


**es que es UML** **UML** es un **lenguaje de modelado unificado** esas son sus significados de sus siglas un **lenguaje de modelado unificado** se trata de un **lenguaje estandarizado de diseño de software** de uso general que quiero decir con **estandarizado** quiere decir que la forma en que nosotros lo utilicemos es la manera en que lo van a estar utilizando en otras **organizaciones** o es la manera en que es **estándar** para el **mundo** por quien fue creado por el **Object Management Group** y que incluye un conjunto de **técnicas de notación gráfica** **ojo aquí** **notación gráfica** para crear **modelos visuales de sistema de software** cuáles **sistemas de software** o de qué tipo los que son **orientados a objetos** **entonces UML** incluye **diagramas de casos de uso** que son **útiles para especificar los requerimientos de usuario** cuando nosotros hablamos de un **modelo de casos de uso completo** o un **modelo de casos de uso** **decimos que** éste está compuesto de qué del **diagrama UML de casos de uso** y de la **especificación de casos de uso** de estos dos **componentes** es lo que está ahora sí que completado un **modelo de casos de uso** | Profundizaremos en los **diagramas UML de casos de uso**. Como se acordó, los **diagramas UML** tienen **14 tipos de diagramas** divididos en dos grandes categorías: **estructural** (o de **estructura**) y de **comportamiento**. **UML** tiene **14 tipos diferentes de diagramas** divididos en estas dos categorías. Dentro de la categoría **estructural** tenemos: **diagramas de clases**, **diagramas de componentes**, **diagramas de objetos** y **paquetes de diagramas**. Estos **diagramas estructurales** son comunes y algunos han trabajado o trabajarán con ellos (ej., **diagramas de clases**, **diagramas de objetos**, **diagramas de componentes**). También tenemos los **diagramas de comportamiento**, entre ellos los **diagramas de actividad** y los **diagramas de casos de uso**, en los que nos enfocaremos. **UML** (siglas de **Lenguaje de Modelado Unificado**) es un **lenguaje de modelado unificado**. Se trata de un **lenguaje estandarizado de diseño de software** de uso general. **Estandarizado** significa que la forma en que lo utilizamos es la forma **estándar** global. Fue creado por el **Object Management Group** e incluye un conjunto de **técnicas de notación gráfica** (es importante: **notación gráfica**) para crear **modelos visuales de sistemas de software**, específicamente aquellos **orientados a objetos**. **UML** incluye **diagramas de casos de uso** que son **útiles para especificar los requerimientos de usuario**. Un **modelo de casos de uso completo** está compuesto por dos **componentes**: el **diagrama UML de casos de uso** y la **especificación de casos de uso**. | | vamos a analizar **entonces** lo que son los **diagramas de casos de uso** a profundizar sobre ellos en este ejemplo tenemos el **límite del sistema** que viene siendo un **punto de venta** está delimitado por nuestro cuadradito nuestro **rectángulo** en el cual nosotros tenemos un **cajero** que viene siendo un **actor** este **cajero** o este **actor** qué es lo que puede realizar puede ejecutar lo que son el **caso de uso** para **escanear artículos** y puede ejecutar lo que es el **caso de uso** para **totalizar artículos** dentro de los **diagramas UML** tenemos lo que son llamadas las **asociaciones** que son **como ésta está esta está esta ésta** y estos **tipos de asociaciones** las **asociaciones** son **líneas** entre **actor** y el **caso de uso** y resumen **interacciones** gráficamente los **actores** y los **casos de uso** intercambian **información** para lograr la **meta** pero los detalles de la **interacción** no se muestran qué quiere decir esto nosotros ilustramos gráficamente la **asociación** que existe entre el **cajero** y este **caso de uso** **escanear ítems** pero no estamos describiendo los **detalles de la interacción** que existe por ejemplo como el **cajero** ejecuta **escanear sistema** si es a través de un **procedimiento** si es a través de una **función** si es a través de **etcétera etcétera etcétera** nosotros no nos metemos a ese **tipo de detalles** simplemente decimos que existe una **interacción** la **asociación** significa que el **actor** está **participando** o **comunicando** con el **sistema** vía el **caso de uso** **entonces** la **asociación** es el **tipo de relación más básica** que indica la **invocación** desde un **actor** o **caso de uso** a otra **operación** o a otro **caso de uso** dicha relación se denota como una **flecha simple** la **asociación** se denota como una **flecha** si la **dependencia** o **instanciación** es una **forma muy particular de relación** entre **clases** en las cuales una **clase** depende después de depender de otra **es decir** se **instancia** o se **crea** y dicha relación se denota con una **flecha punteada** esto nosotros lo vemos en la **programación orientada a objetos** cuando hacemos una **instanciación** de una **clase** | **Analicemos** los **diagramas de casos de uso**. En este ejemplo , el **límite del sistema** es un **punto de venta**, delimitado por un **rectángulo**. Dentro de él, tenemos un **actor**, el **Cajero**, que puede ejecutar los **casos de uso** para **Escanear artículos** y **Totalizar artículos**. Dentro de los **diagramas UML** existen las **asociaciones**, que son **líneas** entre el **actor** y el **caso de uso** y resumen **interacciones** gráficamente. Los **actores** y los **casos de uso** intercambian **información** para lograr la **meta**, pero los detalles de la **interacción** no se muestran. Esto significa que ilustramos gráficamente la **asociación** entre el **Cajero** y el **caso de uso** **Escanear ítems**, pero no describimos los **detalles de la interacción** (por ejemplo, si el **Cajero** ejecuta **Escanear sistema** a través de un **procedimiento** o una **función**; no profundizamos en esos **detalles**), simplemente indicamos que existe una **interacción**. La **asociación** significa que el **actor** está **participando** o **comunicando** con el **sistema** vía el **caso de uso**. Por lo tanto, la **asociación** es el **tipo de relación más básica** que indica la **invocación** desde un **actor** o **caso de uso** a otra **operación** u otro **caso de uso**. Esta relación se denota como una **flecha simple**. Por otro lado, la **dependencia** o **instanciación** es una **forma particular de relación** entre **clases** en las que una **clase** depende de otra (es decir, se **instancia** o se **crea**), y se denota con una **flecha punteada**. Esto se observa en la **programación orientada a objetos** al realizar una **instanciación** de una **clase**. | | tenemos lo que son la **generalización** este **tipo de relaciones** es uno de los más utilizados cumple una **doble función** **ojo aquí** la **generalización** tiene **doble función** dependiendo de lo que lo vamos a estar utilizando una puede ser de **uso** **es decir** **uses** o **include** y otra de **herencia** **extend** este **tipo de relación** está orientada exclusivamente para **casos de uso** y no para **actores** **entonces** esta **relación** nosotros lo usamos entre **casos de uso** hacemos lo que viene siendo el **include** entre **casos de uso** y hacemos lo que viene siendo el **extend** entre **casos de uso**, no entre **actores** estas son **relaciones entre casos de uso** para qué sirve el **extend** se recomienda utilizar cuando un **caso de uso** es similar a otra o sus **características** son similares nosotros utilizamos el **extend** más adelante vamos a empezar a ver algún **ejemplo** que nos va a quedar más claro incluso **uses** se recomienda utilizar cuando se tiene un **conjunto de características** que son similares en más de un **caso de uso** y no se desea más y se desea mantener una **copia la descripción de la característica** **es decir** hacemos un **include** de algo que ya está los **casos de uso** que está en **relaciones** que usan estas **relaciones de casos** se llaman **casos de uso secundarios** o de **soporte** **entonces decimos que** un **diagrama de casos de uso** es una **excelente fotografía del contexto del sistema** **por qué** porque nosotros a través de un de un simple **diagrama** **como si fuera una fotografía** mostramos todo el **contexto de nuestro sistema** **también** nos ayuda a ilustrar los **actores** del **sistema** informáticos en una **notación diferente** a los **actores humanos** por ejemplo este es un **actor** y este es un **actor** de la pregunta que me hacían sobre los **actores humanos** y los **actores no humanos** o **actores diferentes a humanos** la forma o una de las maneras que nosotros podemos ilustrarlo es uno el **humano** a través de un **monito de palo** y el **no humano** a través de un **rectángulo** sigue siendo un **actor** pero este es un **sistema de recursos humanos** y este es un **actor humano de administrador del sistema** otra cosa que hacemos es utilizar **estereotipos** para categorizar los **elementos** de alguna manera por ejemplo **actor** otra cosa que hacemos es que los **actores principales** dentro de un **diagrama** los ponemos del **lado izquierdo** y los **actores del soporte** al **lado derecho** | Tenemos la **generalización**. Este **tipo de relaciones** es uno de los más utilizados y cumple una **doble función** (es importante notar la **doble función**), dependiendo de su uso: **uso** (**uses** o **include**) y **herencia** (**extend**). Este **tipo de relación** está orientada exclusivamente a **casos de uso** y no a **actores**. Por lo tanto, la usamos entre **casos de uso** para realizar el **include** y el **extend**. El **extend** se recomienda cuando un **caso de uso** o sus **características** son similares a las de otro **caso de uso**. Más adelante veremos un **ejemplo** que lo aclarará. El **include** (**uses**) se recomienda cuando se tiene un **conjunto de características** similares en más de un **caso de uso** y se desea mantener una **única descripción de la característica**; es decir, hacemos un **include** de algo que ya existe. Los **casos de uso** que utilizan estas **relaciones** se llaman **casos de uso secundarios** o de **soporte**. Un **diagrama de casos de uso** es una **excelente fotografía del contexto del sistema**, ya que a través de un simple **diagrama**, **como si fuera una fotografía**, se muestra todo el **contexto de nuestro sistema**. También es útil para ilustrar los **actores** del **sistema** informático con una **notación diferente** a los **actores humanos**. Por ejemplo, un **actor humano** se representa con una **figura de palo** y un **actor no humano** con un **rectángulo**. Ambos son **actores** (ej. **Sistema de Recursos Humanos** es un **actor no humano**, y **Administrador del Sistema** es un **actor humano**). También utilizamos **estereotipos** (ej., **`<<actor>>`**) para categorizar los **elementos**. Otra convención es colocar los **actores principales** dentro de un **diagrama** al **lado izquierdo** y los **actores de soporte** al **lado derecho**. | | **queda claro esto** **todo bien** **por qué no** **porque no quedó claro qué es lo que se dificulta se pueden escribir en el chat por favor** **eso es bueno la pregunta de ese sume estando en la posición acomodo no podemos organizarlo de otra manera** **es por así decirlo** una **buena práctica** realizarlo de esta manera los **actores principales** de la mañana del **lado izquierdo** y los **actores secundarios** del **lado derecho** **si bien recuerdan que también está influenciado de nuestra flecha** **es decir** si nuestra **flecha** está dirigida del **actor** hacia el **caso de uso** quiere decir que este es un **actor primario** o un **actor principal** si nuestra **flecha** va dirigida del **caso de uso** hacia el **actor** quiere decir que este **actor** es un **actor secundario** ustedes podrían por ejemplo acomodar un **actor secundario** de este lado y poner la **flecha** **así** eso quiere decir que este **actor** es un **actor secundario** de este **caso de uso** y **en cambio** ustedes podrían poner de este lado un **actor** y la **flecha** dirigida hacia el **caso de uso** y significa que este **actor** es un **actor principal** de este **caso de uso** simplemente es una **buena práctica** poner los **actores principales** del **lado izquierdo** y los **actores secundarios** o de **soporte** del **lado derecho** una **buena práctica** y alguna otra **duda** **ok entonces continuamos** | ¿Queda claro esto? ¿Todo bien? Si hay dudas, por favor, escriban en el chat. La pregunta sobre si la posición es obligatoria es buena. Es una **buena práctica** colocar los **actores principales** al **lado izquierdo** y los **actores secundarios** al **lado derecho**. Esto está influenciado por la **flecha**: si la **flecha** va dirigida del **actor** hacia el **caso de uso**, es un **actor primario** o **principal**. Si la **flecha** va dirigida del **caso de uso** hacia el **actor**, es un **actor secundario**. Un **actor secundario** puede ser colocado en cualquier lado, siempre que la **flecha** indique que es un **actor secundario** de ese **caso de uso** (flecha del **caso de uso** al **actor**). Un **actor principal** puede ser colocado en cualquier lado, siempre que la **flecha** se dirija al **caso de uso**. Simplemente, es una **buena práctica** alinear a los **actores principales** al **lado izquierdo** y a los **actores secundarios** o de **soporte** al **lado derecho**. ¿Alguna otra **duda**? **Continuemos**. | | tenemos lo que es la **especialización de actores** **es decir** un **actor** puede ser una **especialización de otro** una **flecha direccionada** apunta hacia el **actor general** vamos a ver el **ejemplo** nosotros tenemos dos **actores** que tienen una **relación** que esta **relación** es de **tipo especialización** eso significa que este **actor** es una **especialización** de este otro **actor** en este caso el **administrador** o el **manager** es una **especialización** de otro **actor** de **tipo Staff** o de **tipo staff de ventas** qué quiere decir que el **administrador** se especializa de una **base** que es un **actor de ventas** un **administrador** sigue siendo un **actor de ventas** pero tiene una **especialización** que es de **tipo administrador** es **como tipo** en la **programación orientada a objetos** la **herencia** **no** y alguien un **objeto** hereda ciertas cosas de otro **objeto** alguna **duda** supongamos vamos a verlo en un **ejemplo real** supongamos que dentro de la **universidad** en la **base de datos de la universidad** de la **universidad central** existen lo que viene siendo un **listado de personas** en ese **listado de personas** están lo que son **alumnos** están lo que son **maestros** y están lo que son **administrativos** qué tipo de **atributos** tienen estas **personas** **nombre** todas tienen **nombre** todos tienen **apellido** todas tienen **apellido materno** **apellido paterno** todos tienen una **dirección** pero cada una de ellas tiene otros **atributos especiales** por ejemplo un **maestro** tiene una **especialización** no tiene un **atributo** tiene más **atributos** que un **alumno** pero sin embargo siguen siendo **personas** lo podemos ver de esta manera la **especialización de actores** es que un **administrador** sigue siendo parte del **staff de ventas** pero está **especializado** tiene otros **atributos** o tiene otras **cosas** y **queda claro** la **especialización de actores** **bueno vamos a continuar** **no muy bien ok** vamos a verlo en su **proyecto** en su **proyecto del Case** dentro del **proyecto del Case** la mayoría de los **equipos** tenían dos **actores**: un **actor** que viene siendo **como el administrador** o la **administradora del café** y otro **actor** que viene siendo **como los supervisores** de las **casas de estudiantes** **entonces** la **administradora** es una **especialización** de un **supervisor** el **supervisor** es la **base** a partir de éste nosotros **especializamos** otro **actor** que viene siendo el de **administrador** **por ver por decirlo de esa manera** un **usuario Premium** que **hereda** o se **especializa** de un **usuario normal** existe lo que es un **usuario normal** y tenemos un **usuario Premium** pero el **usuario Premium** se **especializa** de el **usuario normal** **como por así decirlo** **así quedó más claro** **ok entonces continuamos** | Tenemos la **especialización de actores**. Un **actor** puede ser una **especialización de otro**. Una **flecha direccionada** apunta hacia el **actor general**. En este **ejemplo**, tenemos dos **actores** con una **relación de tipo especialización**. Esto significa que este **actor** es una **especialización** de este otro **actor**. El **Administrador** (**Manager**) es una **especialización** de un **actor tipo Staff** o **Staff de Ventas**. Esto implica que el **Administrador** se especializa de una **base** que es un **Actor de Ventas**. Un **Administrador** sigue siendo un **Actor de Ventas**, pero con una **especialización** de **tipo Administrador**. Esto es similar a la **herencia** en la **programación orientada a objetos**, donde un **objeto** hereda ciertas características de otro **objeto**. La **especialización de actores** significa que un **Administrador** sigue siendo parte del **Staff de Ventas**, pero está **especializado** y tiene otros **atributos** o **características**. ¿Queda clara la **especialización de actores**? **Continuemos**. Analicémoslo con un **ejemplo real**. En la **base de datos** de una **universidad**, existe un **listado de personas** que incluye **alumnos**, **maestros** y **administrativos**. Todos comparten **atributos** como **nombre**, **apellido materno**, **apellido paterno** y **dirección**, pero cada grupo tiene **atributos especiales**. Por ejemplo, un **Maestro** tiene más **atributos** que un **Alumno**, pero siguen siendo **personas**. La **especialización de actores** se ve de esta manera: un **Administrador** sigue siendo parte del **Staff de Ventas**, pero está **especializado**. Viéndolo en el **proyecto del Case**: la mayoría de los **equipos** tenían dos **actores** (la **Administradora del Café** y los **Supervisores** de las **casas de estudiantes**). La **Administradora** es una **especialización** del **Supervisor** (**Supervisor** es la **base** a partir de la cual especializamos otro **actor**, el **Administrador**). Otro ejemplo: un **Usuario Premium** que **hereda** o se **especializa** de un **Usuario Normal**. Existe un **Usuario Normal** y un **Usuario Premium**, pero el **Usuario Premium** se **especializa** del **Usuario Normal**. ¿Quedó más claro así? **Continuemos**. | | la **generalización de casos de uso** qué es lo que hace la **generalización** muestra **herencia** y **especialización** un **caso de uso** es simplemente un **tipo especial de otro** vamos a ver el **ejemplo** tenemos mi **actor cajero** que está relacionado con el **caso de uso Aceptar pago** pero **Aceptar pago** muestra una **generalización**, no muestra **generalizaciones**, cuáles son **Aceptar efectivo**, **Aceptar cheques** y **Aceptar tarjetas de crédito** todos estos **casos de uso** están relacionados con **Aceptar pago** **es decir** muestra lo que viene siendo una **herencia** y muestra lo que viene siendo una **especialización** estos **casos de uso** se **especializan** de **Aceptar pagos** puede ser a través de **efectivo**, puede ser a través de **cheque** y puede ser a través de **tarjeta de crédito** **duda con esto** **necesito que tengan muy muy en claro esto porque vamos a hacer unos ejercicios entonces necesito que tengan muy en claro toda esta parte véanlo como programación orientada a objetos es decir estos casos de uso que tenemos en la parte inferior se especializan de este y el cajero está relacionado con este simplemente con Aceptar pago después habrá una forma que diga aceptar con efectivo aceptar con cheque o aceptar con tarjeta de crédito **entonces** nuestro tipo de **generalización** **include** que es un **include** es un **comportamiento de casos de uso frecuentemente utilizado** este nos permite **reusar la funcionalidad** por **múltiples casos de uso** | La **generalización de casos de uso** muestra **herencia** y **especialización**: un **caso de uso** es simplemente un **tipo especial de otro**. Analicemos el **ejemplo** . Tenemos el **actor Cajero** que está relacionado con el **caso de uso Aceptar pago**. **Aceptar pago** muestra **generalizaciones** que son: **Aceptar efectivo**, **Aceptar cheques** y **Aceptar tarjetas de crédito**. Todos estos **casos de uso** están relacionados con **Aceptar pago**; es decir, muestran **herencia** y **especialización**. Estos **casos de uso** se **especializan** de **Aceptar pago** (puede ser a través de **efectivo**, **cheque** o **tarjeta de crédito**). Es crucial tener esto muy claro, ya que haremos **ejercicios**; véanlo como **programación orientada a objetos**. Los **casos de uso** en la parte inferior se **especializan** del **caso de uso** superior, y el **Cajero** está relacionado solo con **Aceptar pago**. | | vamos a verlo nosotros tenemos nuestro **actor** que es un **asistente de ventas** que este **asistente de ventas** está relacionado con este **caso de uso** que se llama **Tomar orden de cliente** y **Regresar artículos** o **Regreso de artículos** pero estos **casos de uso** este y este tienen una **relación** o una **generalización** de **tipo include** hay que tener **ojo en esto** la **flecha** va del **caso de uso** hacia el **caso de uso** que va a **incluir** cómo funciona vamos a verlo en **escenarios** tenemos lo que es el **caso de uso Tomar orden del cliente** en dentro de sus **escenarios** o su **especificación de casos de uso** tiene un **flujo básico** el primer **paso** que contendría a este **caso de uso** sería el **actor** **registra los detalles del cliente** **include** o **incluye** en este **caso de uso Identificar cliente** e **include Identificar clientes** **entonces** en el **paso número 1** hace el **include** de el **caso de uso Identificar cliente** qué es lo que hace a partir de aquí del **paso 1** se va a mi siguiente **caso de uso** que es **Identificar cliente** y se ejecutan estos **pasos**: el **primer paso** el **actor** introduce la **critería de búsqueda** que es el **nombre** y el **código postal**, **segundo paso** el **sistema** muestra los **resultados** por así decirlo de los **clientes**, el **actor** selecciona el **cliente**, el **cuarto paso** el **sistema** muestra los **detalles del cliente** y el **quinto paso** el **actor** confirma el **cliente** vayan solo **imaginando** vamos de nuevo el **primer paso** el **actor registra los detalles de un cliente** y me dice **incluye este caso de uso** **porque** porque estamos haciendo un **include** qué es lo que me dice que hace el **include** **reutilizado** **es decir** **reutilizar los escenarios** o el **caso de uso** **entonces** estoy **reutilizando Identificar cliente** ejecuta lo que tiene que ejecutar y regresa después el **segundo paso** el **actor** introduce el **código del producto requerido** recuerden cuál es el **objetivo** de este **caso de uso** es **Tomar la orden del cliente** este es el **objetivo** **entonces** el **actor** introduce el **código del producto** el **paso número 3** el **sistema** muestra los **detalles del producto** el **paso número 4** el **actor** introduce la **cantidad requerida** el **paso número 5** el **actor** introduce los **detalles de pago** el **paso número 6** el **sistema** guarda las **órdenes del cliente** guarda la **orden del cliente** se dan cuenta cómo funciona **si queda claro esta parte o no queda claro** **porque** simplemente estamos haciendo una **reutilización** del **caso de uso Identificar cliente** que está relacionado a través de un **include** con lo que viene siendo **Tomar orden del cliente** y **Regresar artículos** si el **actor de ventas** o **sales assistant** ejecutara **Tomar orden del cliente** este en un **paso** incluye forzosamente **Identificar al cliente** se ejecuta **Identificar el cliente** y continúa con los **pasos** si el **actor** ejecutara **Regresar artículos** en alguna parte de este **caso de uso** tendría que tener un **include** hacia **Identificar cliente** y **suena lógico** si nosotros hacemos un **regreso de artículos** en alguna **tienda** nos tendrían que **identificar quiénes somos** **entonces** utilizarían lo que viene siendo **Identificar el cliente** **dudas** | Analicemos el **include**. Tenemos un **actor**, el **Asistente de Ventas** (**Sales Assistant**), que está relacionado con los **casos de uso Tomar orden de cliente** y **Regresar artículos**. Estos **casos de uso** tienen una **relación de tipo include**. Es importante: la **flecha** va **del caso de uso hacia el caso de uso que se va a incluir**. . **Funciona** así en los **escenarios**: El **caso de uso Tomar orden del cliente** tiene un **flujo básico** en su **especificación de casos de uso**. El **paso número 1** sería: el **actor registra los detalles del cliente** e **incluye** (**include**) el **caso de uso Identificar cliente**. A partir del **paso 1**, el flujo se dirige al **caso de uso Identificar cliente** y se ejecutan sus **pasos**: **1.** El **actor** introduce la **critería de búsqueda** (**nombre** y **código postal**). **2.** El **sistema** muestra los **resultados** de los **clientes**. **3.** El **actor** selecciona el **cliente**. **4.** El **sistema** muestra los **detalles del cliente**. **5.** El **actor** confirma el **cliente**. Una vez finalizado el **include**, el flujo regresa al **caso de uso Tomar orden del cliente**. El **include** permite **reutilizar los escenarios** o el **caso de uso**. Se **reutiliza Identificar cliente**, se ejecuta y luego se continúa. El **segundo paso** en la orden es: el **actor** introduce el **código del producto requerido**. (El **objetivo** de este **caso de uso** es **Tomar la orden del cliente**). **Paso 3:** El **sistema** muestra los **detalles del producto**. **Paso 4:** El **actor** introduce la **cantidad requerida**. **Paso 5:** El **actor** introduce los **detalles de pago**. **Paso 6:** El **sistema** guarda la **orden del cliente**. De esta manera, se **reutiliza el caso de uso Identificar cliente** que está relacionado mediante un **include** con **Tomar orden del cliente** y **Regresar artículos**. Si el **Asistente de Ventas** ejecutara **Tomar orden del cliente**, este **caso de uso** incluiría forzosamente **Identificar al cliente**, ejecutaría la identificación y continuaría con los **pasos**. Si el **actor** ejecutara **Regresar artículos**, en alguna parte del **caso de uso** tendría que haber un **include** hacia **Identificar cliente** (lo cual es lógico, ya que para **regresar artículos** en una **tienda** tendrían que **identificar quiénes somos**). ¿Queda clara esta parte? ¿Hay **dudas**? | | **ok esto es lo relacionado con lo que es el include** ahora vamos a ver lo que es el **extend** qué es lo que se hace el **extend** indica que un **caso de uso** agrega o reemplaza **comportamiento de otros** **punto clave** debe de tener un **punto de extensión asociado** y debe de tener una **condición** supongamos vamos a ver es este mismo **ejemplo** pero le vamos a agregar el **caso de uso** tenemos mi **actor** que este **actor** ejecuta este **caso de uso** y ejecuta este otro **caso de uso** este **caso de uso** tiene un **include** vean la **flecha** hacia dónde va cuando es **include** la flecha va del **caso de uso** hacia el otro **caso de uso** ese es en el **include** **es decir** que **Customer Order** **incluye** **Identify Customer** pero **también** tenemos que este **caso de uso** **Take Customer Order** **extiende** o **extend** de **Search Customer Specific Product** que es otro **caso de uso** vamos a verlo en el **ejemplo** tenemos nuestro **flujo normal** nuevamente que es el de **Take Customer Order** como lo acabamos de ver son los **pasos** que tiene que hacer para que el **actor** tome la **orden del cliente** vemos que en el **punto número 1** **incluye** lo que es **Identify Customer** **es decir** de aquí en el **paso uno** se va acá termina lo que tiene que terminar y se va acá de nuevo y en el **paso 2** dice el **actor** introduce lo que viene siendo el **código del producto** pero tenemos lo que es un **flujo alternativo** que se llama **Producto especificado por el cliente** que es este es un **flujo alternativo** donde nos dice en el **paso 3** si el **producto** requiere **características específicas por el cliente** es una **condición** si el **producto** si el **cliente** requiere **características específicas** **entonces** **extiende** **caso de uso Producto especificado por el cliente** vamos a hacerlo **paso a paso** el **actor** **registra los detalles del cliente** e **incluye** lo que viene siendo el **caso de uso Identify Customer** termina se va al **paso número 2** el **actor** introduce el **código del producto** el **paso 3** el **sistema** muestra **detalles del producto** pero me dice si en el **caso 3** si el **cliente** que necesita ciertas **características especiales** por ese **producto** **entonces** ejecuta esto y le dice **3.1** el **actor** introduce las **características especificadas por el cliente** cuál es el **actor** introduce los **requerimientos específicos** como **tamaño** y **color** **punto número 2** el **sistema** guarda esta **información** **si queda claro** te los voy a poner a **manera de ejemplo** supongamos que nosotros hacemos una **compra** podríamos hacer **compras de carros en línea** un **carro** no sé un **vochito** **entonces** nosotros podemos hacer el que la **compra del vochito en línea** al momento en que nosotros estamos escogiendo el **vochito** nosotros decimos que queremos **especificar** lo que viene siendo el **tamaño** y el **color del vochito** **entonces** es una **condicional** donde nosotros **extenderíamos** este **caso de uso** hay una **condición** donde nosotros tenemos que manejarla por eso es que entra el **flujo alternativo** que nos dice que ejecute este **caso de uso** **si quedo más claro** de esta manera es una **condición** se puede ejecutar o no se puede ejecutar a diferencia del **include** si lo **incluye** que sí le dice **agarra esto y hazlo** este no el **extend** es una **condición** | Ahora veremos el **extend**. El **extend** indica que un **caso de uso** agrega o reemplaza el **comportamiento de otros**. **Punto clave**: debe tener un **punto de extensión asociado** y una **condición**. . En este **ejemplo**, el **actor** ejecuta este **caso de uso** y este otro **caso de uso**. El primer **caso de uso** tiene un **include** (la **flecha** va **del caso de uso hacia el caso de uso que va a incluir**): **Take Customer Order** **incluye** **Identify Customer**. Pero **Take Customer Order** también **extiende** (**extend**) de **Search Customer Specific Product**, que es otro **caso de uso**. Nuestro **flujo normal** es el de **Take Customer Order** (los **pasos** que el **actor** debe seguir para tomar la **orden del cliente**). En el **punto número 1**, **incluye Identify Customer**. El flujo va de aquí al **caso de uso incluido**, termina, y regresa al **paso 2**, donde el **actor** introduce el **código del producto**. En el **paso 3**, el **sistema** muestra **detalles del producto**. Pero tenemos un **flujo alternativo** llamado **Producto especificado por el cliente**. En el **paso 3** del flujo normal se establece la **condición**: si el **producto** requiere **características específicas por el cliente** (**condición**), **entonces extiende** el **caso de uso Producto especificado por el cliente**. **Paso a paso**: El **actor registra los detalles del cliente** e **incluye Identify Customer**. El flujo vuelve. El **actor** introduce el **código del producto**. El **sistema** muestra **detalles del producto**. Si en el **paso 3** el **cliente** necesita **características especiales** para ese **producto**, **entonces** se ejecuta el **flujo alternativo**: **3.1.** El **actor** introduce las **características especificadas por el cliente** (ej., **tamaño** y **color**). **3.2.** El **sistema** guarda esta **información**. Esto es una **condicional** donde nosotros **extenderíamos** este **caso de uso**. El **extend** es una **condición** que se puede ejecutar o no; a diferencia del **include**, que es forzoso. **Ejemplo**: Si hacemos la **compra de un carro en línea** (ej., un **vochito**). Al escoger el **vochito**, podemos **especificar** el **tamaño** y el **color del vochito**. Esta es una **condicional** donde **extenderíamos** este **caso de uso**. Es una **condición** que hay que manejar, por eso entra el **flujo alternativo** y ejecuta el **caso de uso extendido**. ¿Quedó más claro? El **extend** es una **condición** que se puede o no ejecutar. **Ejemplo** de **extend** en un **cajero**: El **cajero** utiliza **Identificar productos**. Hay un **punto de extensión** o una **condicional** para introducir los datos. Se hace un **extend** que puede ser a través de un **escáner** (como en **Oxxo**) o a través de **introducción manual** (cuando el **escáner** falla e introducen el **código** con el **teclado**). El **extend** se aplica tanto al **escaneo** como a la **introducción manual**. | | **entonces** algunas **consideraciones** que debemos de tener sobre los **diagramas UML de casos de uso** éstos no representan el **flujo de información** o **secuencia de eventos** **es decir** dentro de nuestro **diagrama UML** no existe una **secuencia** no es que yo diga primero esto hace esto luego esto luego esto luego esto y luego esto no no está demostrando ni siquiera está especificando una **secuencia** no representan la **comunicación entre actores** los **actores** no son siempre **roles** desempeñados por una **persona** los **actores** pueden representar el **papel** desempeñado por **cualquier cosa** que actúe sobre el **sistema** tal como otro **sistema** tal como una **base de datos** tal como una **organización** una **instancia** **entonces** vamos a hacer un **ejercicio** este **ejercicio** es en **manera de equipo de proyecto** es un **ejercicio** **pues por decirlo amplio** qué es lo que van a hacer van a realizar un **diagrama** del **documento** que se encuentra en **Classroom** creo que ella se actualizó sí yo creo que ya está disponible la **fecha límite** es para el **lunes 11 de mayo** **porque** porque el **martes** vamos a trabajar sobre este **documento** **es decir** ustedes suben los de su **trabajo** y el **martes** realizamos el **ejercicio en clase** tienen alguna **duda** sobre el **ejercicio** simplemente lo que van a hacer es el **diagrama** | **Consideraciones** sobre los **diagramas UML de casos de uso**: * No representan el **flujo de información** o **secuencia de eventos**. Dentro del **diagrama UML**, no se especifica una **secuencia** (no indica que esto se hace primero, luego esto, y así sucesivamente). * No representan la **comunicación entre actores**. * Los **actores** no siempre son **roles** desempeñados por una **persona**. Los **actores** pueden representar el **papel** desempeñado por **cualquier cosa** que actúe sobre el **sistema**, como otro **sistema**, una **base de datos**, una **organización** o una **instancia**. **Ejercicio**: Se realizará un **ejercicio en equipo de proyecto** (amplio). Deben realizar un **diagrama** del **documento** que se encuentra en **Classroom** (ya debe estar disponible). La **fecha límite** es el **lunes 11 de mayo**, ya que el **martes** se trabajará sobre este **documento**; es decir, subirán su **trabajo** y el **martes** se realizará el **ejercicio en clase**. ¿Alguna **duda** sobre el **ejercicio**? Simplemente deben realizar el **diagrama**. |




-----















