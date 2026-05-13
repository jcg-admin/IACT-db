## CLEAN CODE NAMING PRINCIPLES

### **FUNDAMENTO CIENTÍFICO:**

**Robert Martin**: _"En el software, los nombres son omnipresentes. Aparecen en variables, funciones, argumentos, clases y paquetes. Usamos nombres constantemente. Por ello, debemos hacerlo bien."_

### **1. USAR NOMBRES QUE REVELEN INTENCIONES**

**Martin's Definition**: _"El nombre debe indicar por qué existe, qué hace y cómo se usa. Si un nombre requiere un comentario, significa que no revela su cometido."_

**Aplicación**: Los nombres deben ser tan descriptivos que eliminen la necesidad de comentarios explicativos. El nombre debe comunicar inmediatamente el propósito.




### **2. EVITAR LA DESINFORMACIÓN**

**Martin's Principle**: _"No haga referencia a un grupo de cuentas como accountList a menos que realmente sea una lista. Evite usar nombres con variaciones mínimas."_

**Aplicación**: Los nombres deben ser precisos y no sugerir características que el script no posee. Las abreviaciones ambiguas generan confusión y malinterpretaciones.

### **3. REALIZAR DISTINCIONES CON SENTIDO**

**Martin's Warning**: _"No basta con añadir series de números o palabras adicionales. Info y Data son palabras adicionales, como a, an y the."_

**Aplicación**: Cada palabra en el nombre debe añadir valor semántico real. Las palabras como "info", "data", "stuff" son ruido que no aportan claridad.

### **4. USAR NOMBRES QUE SE PUEDAN PRONUNCIAR**

**Martin's Insight**: _"Si no lo puede pronunciar, no podrá explicarlo sin parecer tonto. La programación es una actividad social."_

**Aplicación**: La capacidad de pronunciar nombres facilita la comunicación en equipos. Los nombres pronunciables mejoran la colaboración y reducen malentendidos.

### **5. USAR NOMBRES QUE SE PUEDAN BUSCAR**

**Martin's Rule**: _"Los nombres extensos superan a los breves y cualquier nombre que se pueda buscar supera a una constante. La longitud de un nombre debe corresponderse al tamaño de su ámbito."_

**Aplicación**: Los nombres deben ser únicos y específicos para facilitar búsquedas en proyectos grandes. La longitud del nombre debe reflejar su scope de uso.

### **6. EVITAR CODIFICACIONES**

**Martin's Warning**: _"No parece razonable que todos los nuevos empleados tengan que aprender otro lenguaje de codificación. Los nombres codificados resultan impronunciables."_

**Aplicación**:Se deben usar lenguaje natural sin sistemas de codificación que requieran aprendizaje adicional. La claridad prevalece sobre la brevedad.

### **7. EVITAR ASIGNACIONES MENTALES**

**Martin's Principle**: _"Los lectores no tienen que traducir mentalmente sus nombres en otros que ya conocen. La claridad es lo que importa."_

**Aplicación**: Los nombres deben ser directamente comprensibles sin requerir conocimiento contextual adicional o traducción mental de códigos internos.

### **8. UNA PALABRA POR CONCEPTO**

**Martin's Consistency Rule**: _"Elija una palabra por cada concepto abstracto y manténgala. Resulta confuso usar fetch, retrieve y get como métodos equivalentes."_

**Aplicación**: Mantener consistencia en el vocabulario reduce la carga cognitiva y mejora la predictibilidad del sistema de naming.


### **9. ARCHITECTURE REVEALS INTENT**

**Uncle Bob's Question**: _"Why isn't it telling me what it does at its very highest level? Why is it telling me how it's made?"_

**Uncle Bob's Insight**: _"Architecture is about intent. The architecture of the building tells you not what it's made of, not what its architectural frameworks were. It tells you its intent."_

### **10. FRAMEWORKS ARE PLUGINS**

**Uncle Bob's Principle**: _"The web should be a plugin to your application. Not one line of code should know the web exists."_


**Uncle Bob's Vision**: _"I want you to write your applications such that all the business rules are contained in a component or set of components and then I want all the UI stuff to be plugins to those components."_

**Aplicación**: Los scripts deben ser independientes de frameworks específicos. Los frameworks (incluyendo systems de tasks) deben ser plugins a los componentes, no al revés.



### **11. DEPENDENCIES POINT INWARD**

**Uncle Bob's Dependency Rule**: _"Across that black line all dependencies must point inwards towards the application."_

**Uncle Bob's Explanation**: _"Nothing in an inner circle can know anything about something in an outer circle."_

**Aplicación**: Los scripts de componentes deben ser el centro estable, con las implementaciones específicas de tasks dependiendo de ellos, no al revés.

### **12. USE CASES DRIVE ARCHITECTURE**

**Uncle Bob's Reference to Jacobson**: _"Use cases drive the architecture. A use case is a description of an action that a user will perform on a system."_

**Jacobson's Original Insight**: _"Use cases written by Jacobson might look like this: a use case is a description of an action that a user will perform on a system."_

**Aplicación**: Los scripts deben organizarse por casos de uso del negocio (validar git, setup hardware), no por cronologías de proyectos.

### **13. TESTABILITY WITHOUT FRAMEWORK**

**Uncle Bob's Goal**: _"You should be able to test all your business rules without the web server running. Web servers are a pain, they get in the way."_

**Uncle Bob's Vision**: _"I would like to just test all my business rules by passing a data structure in, getting a data structure out, real easy, without any other stuff running."_

**Aplicación**: Los scripts de componentes deben ser testeable independientemente, sin requerir setup de frameworks o contextos de tasks específicos.

