---
id: UC-[DOMINIO]-[###]
tipo: caso_uso
categoria: [DOMINIO]
version: 1.0.0
fecha_creacion: [YYYY-MM-DD]
ultima_actualizacion: [YYYY-MM-DD]
autor: [NOMBRE_AUTOR]
estado: [borrador|en_revision|aprobado|obsoleto]
---

# UC-[DOMINIO]-[###]: [VERBO Objeto]

<!--
INSTRUCCIONES GENERALES:
- Reemplace [DOMINIO] con: BACK, FRONT, DEVOPS, QA, AI, GOB
- Reemplace [###] con número secuencial: 001, 002, 003, etc.
- NOMENCLATURA OBLIGATORIA: El título DEBE seguir el patrón VERBO + OBJETO

  Ejemplos CORRECTOS:
  - Iniciar Sesión
  - Gestionar Permisos
  - Solicitar Producto Químico
  - Generar Reporte
  - Cambiar Contraseña

  Ejemplos INCORRECTOS:
  - Login (no es verbo+objeto)
  - El usuario inicia sesión (incluye sujeto)
  - Sistema de autenticación (es un sistema, no una acción)

PRINCIPIO QUÉ vs CÓMO:
- Los casos de uso describen QUÉ debe hacer el sistema, NO CÓMO lo hará
- CORRECTO: "El sistema guarda la venta"
- INCORRECTO: "El sistema escribe la venta en base de datos SQL con INSERT"
- Evite mencionar tecnologías, algoritmos, componentes internos

FORMATO DE DOS COLUMNAS:
- Use tabla con dos columnas para separar claramente:
  * Columna 1: ACCIONES DEL ACTOR
  * Columna 2: RESPONSABILIDADES DEL SISTEMA
- Esto hace obvio quién hace qué
-->

## Información General

**ID**: UC-[DOMINIO]-[###]

**Nombre**: [VERBO Objeto]

**Creado por**: [Nombre del autor]

**Fecha de creación**: [YYYY-MM-DD]

**Última actualización**: [YYYY-MM-DD]

**Estado**: [borrador | en_revision | aprobado | obsoleto]

## Actores

<!--
INSTRUCCIONES:
- Actores Primarios: Quiénes ejecutan/disparan el caso de uso
- Actores Secundarios: Quiénes proporcionan soporte (otros usuarios, sistemas externos)
- Use roles de negocio, NO roles técnicos
  CORRECTO: "Gerente de Laboratorio", "Cliente", "Cajero"
  INCORRECTO: "Usuario con rol admin_lab", "Base de Datos MySQL"
-->

**Actores Primarios**: [Actor que ejecuta el caso de uso]

**Actores Secundarios**: [Actores de apoyo, sistemas externos - si no hay, escriba "Ninguno"]

## Descripción

<!--
Escriba 1-3 párrafos describiendo:
- El propósito del caso de uso
- El objetivo que el actor busca lograr
- Contexto general
-->

[Describa aquí el propósito y objetivo del caso de uso desde la perspectiva del usuario]

## Desencadenador

<!--
¿Qué evento o condición inicia este caso de uso?

Ejemplos:
- "El solicitante indica una solicitud de un producto químico"
- "El sistema detecta que la fecha de vencimiento ha sido alcanzada"
- "El cajero presiona el botón 'Nueva Venta'"
-->

[Describa qué dispara el inicio de este caso de uso]

## Precondiciones

<!--
IMPORTANTE: Pueden haber 0 o más precondiciones. No es obligatorio tenerlas.

Liste las condiciones que deben ser verdaderas ANTES de iniciar el caso de uso.

Ejemplos:
- El usuario debe estar autenticado en el sistema
- Debe existir un catálogo de productos disponible
- El inventario debe estar actualizado

Si NO hay precondiciones, escriba "Ninguna" o elimine esta sección.
-->

- [Precondición 1]
- [Precondición 2]
- [Precondición 3]

<!-- O si no hay: -->
<!-- Ninguna -->

## Postcondiciones

<!--
Describa el estado del sistema DESPUÉS de completar exitosamente el caso de uso.
Esto aplica al flujo normal (happy path) o caminos alternos exitosos.

Ejemplos:
- La venta ha sido registrada en el sistema
- El inventario ha sido actualizado
- El recibo ha sido impreso
- El usuario ha sido notificado
-->

- [Postcondición 1: Estado del sistema después de éxito]
- [Postcondición 2]
- [Postcondición 3]

## Flujo Normal (Happy Path)

<!--
FORMATO DE DOS COLUMNAS OBLIGATORIO:
- Columna 1: ACCIONES DEL ACTOR
- Columna 2: RESPONSABILIDADES DEL SISTEMA

REGLAS:
1. Numere los pasos secuencialmente
2. Separe claramente acciones de actor vs. sistema
3. Un paso = una acción concreta (no "el sistema hace A, B, C y D" - divida en pasos 1, 2, 3, 4)
4. Evite detalles de implementación (CÓMO)
5. Use verbos en presente

EJEMPLO:
| ACCIONES DEL ACTOR | RESPONSABILIDADES DEL SISTEMA |
|---|---|
| 1. El cajero comienza una nueva venta | |
| 2. El cajero introduce el identificador del artículo | 3. El sistema guarda el artículo<br>4. El sistema muestra descripción y subtotal |
| El cajero repite pasos 2-4 hasta terminar | |
| 5. El cajero indica fin de captura | 6. El sistema muestra total con impuestos calculados |
| 7. El cajero solicita método de pago al cliente | |
| 8. El cliente proporciona pago | 9. El sistema procesa el pago<br>10. El sistema registra la venta<br>11. El sistema actualiza inventario<br>12. El sistema imprime recibo |
-->

| ACCIONES DEL ACTOR | RESPONSABILIDADES DEL SISTEMA |
|---|---|
| 1. [Primera acción del actor] | |
| 2. [Segunda acción del actor] | 3. [Primera respuesta del sistema]<br>4. [Segunda respuesta del sistema] |
| 5. [Siguiente acción del actor] | 6. [Respuesta del sistema] |
| | 7. [Otra acción del sistema] |
| 8. [Acción final del actor] | 9. [Procesamiento del sistema]<br>10. [Finalización] |

<!-- Agregue o elimine filas según sea necesario -->

## Flujos Alternos

<!--
INSTRUCCIONES:
Los flujos alternos son caminos válidos diferentes al flujo normal que también llevan a éxito
(o a una conclusión válida diferente).

Estructura para cada flujo alterno:
- Número: Use patrón #.# (ej: 4.1, 4.2 si se bifurca después del paso 4)
- Nombre descriptivo
- Punto de entrada: Después de qué paso se bifurca
- Condición: Qué dispara este flujo alterno
- Pasos: Secuencia de pasos del flujo alterno
- Punto de retorno: A qué paso regresa o si termina

Si NO hay flujos alternos, escriba "No hay flujos alternos" o elimine esta sección.
-->

### Flujo Alterno [#.#]: [Nombre Descriptivo]

**Punto de entrada**: Después del paso [#] del flujo normal

**Condición**: [Qué condición dispara este flujo alterno]

**Pasos**:
- [#.#.1] [Primer paso del flujo alterno]
- [#.#.2] [Segundo paso del flujo alterno]
- [#.#.3] [Tercer paso del flujo alterno]

**Punto de retorno**: [Regresa al paso # | El caso de uso termina exitosamente | El caso de uso termina sin éxito]

<!--
EJEMPLO:
### Flujo Alterno 4.1: Producto No Disponible

Punto de entrada: Después del paso 4 del flujo normal

Condición: El producto solicitado no está en stock

Pasos:
- 4.1.1 El sistema muestra mensaje "Producto no disponible"
- 4.1.2 El sistema sugiere productos alternativos
- 4.1.3 El solicitante puede seleccionar un producto alternativo

Punto de retorno: Regresa al paso 5 si selecciona alternativa, o termina caso de uso si cancela
-->

<!-- Agregue más flujos alternos según sea necesario -->

## Excepciones

<!--
INSTRUCCIONES:
Las excepciones son situaciones de ERROR que típicamente terminan el caso de uso sin éxito completo.

Diferencia con Flujos Alternos:
- Flujos Alternos: Caminos válidos que llevan a éxito
- Excepciones: Situaciones de error/fallo

Estructura para cada excepción:
- Número: Use patrón #.#.# (ej: 3.1.1)
- Nombre de la excepción
- Punto de entrada: Durante qué paso puede ocurrir
- Condición: Qué error se presenta
- Pasos: Cómo se maneja el error
- Resultado: Qué pasa después (generalmente el caso de uso termina)

Si NO hay excepciones documentadas, escriba "No hay excepciones documentadas" o elimine esta sección.
-->

### Excepción [#.#.#]: [Nombre de la Excepción]

**Punto de entrada**: Durante el paso [#.#]

**Condición de error**: [Qué error o situación excepcional ocurre]

**Pasos de manejo**:
- [#.#.#.1] [Cómo se maneja el error - paso 1]
- [#.#.#.2] [Cómo se maneja el error - paso 2]

**Resultado**: [El caso de uso termina sin éxito | Se registra error y regresa a paso # | Usuario es notificado]

<!--
EJEMPLO:
### Excepción 3.1.1: Error de Conexión a Base de Datos

Punto de entrada: Durante el paso 3 (validación de credenciales)

Condición de error: El sistema no puede conectarse a la base de datos de usuarios

Pasos de manejo:
- 3.1.1.1 El sistema muestra mensaje de error técnico al usuario
- 3.1.1.2 El sistema registra el error en log
- 3.1.1.3 El sistema notifica al equipo de soporte

Resultado: El caso de uso termina sin éxito. Usuario debe reintentar más tarde.
-->

<!-- Agregue más excepciones según sea necesario -->

## Requisitos Especiales

<!--
INSTRUCCIONES:
Liste aquí Requerimientos No Funcionales (RNF) y restricciones específicos de este caso de uso.
Solo liste los que aplican ESPECÍFICAMENTE a este caso de uso, no todos los del sistema.

Si no hay requisitos especiales, escriba "Ninguno" o elimine esta sección.
-->

**Requerimientos No Funcionales Relacionados**:
- [RNF-DOMINIO-###]: [Descripción breve del atributo de calidad]
- [RNF-DOMINIO-###]: [Descripción breve del atributo de calidad]

**Restricciones**:
- [Restricción técnica o de negocio específica 1]
- [Restricción técnica o de negocio específica 2]

<!--
Ejemplos:
Requerimientos No Funcionales Relacionados:
- RNF-BACK-006: El sistema debe responder en < 2 segundos
- RNF-BACK-007: La sesión expira después de 30 minutos de inactividad

Restricciones:
- Solo disponible durante horario laboral (8am-6pm)
- Requiere conexión a internet estable
-->

## Reglas de Negocio Relacionadas

<!--
INSTRUCCIONES:
Liste las Reglas de Negocio (RN) que influyen en este caso de uso.
Esto establece trazabilidad ascendente (hacia niveles superiores).
-->

- [RN-DOMINIO-###]: [Nombre de la regla de negocio]
- [RN-DOMINIO-###]: [Nombre de la regla de negocio]
- [RN-DOMINIO-###]: [Nombre de la regla de negocio]

<!--
Ejemplo:
- RN-BACK-001: Usuario debe estar autenticado
- RN-BACK-028: Solo usuarios activos pueden iniciar sesión
-->

## Requerimientos de Negocio Relacionados

<!--
OPCIONAL: Liste los Requerimientos de Negocio (RNEG) relacionados.
Esto ayuda a entender el "por qué" de alto nivel de este caso de uso.

Si no es relevante o no se ha documentado, elimine esta sección.
-->

- [RNEG-DOMINIO-###]: [Nombre del requerimiento de negocio]

## Requisitos Funcionales Derivados

<!--
INSTRUCCIONES:
Liste los Requisitos Funcionales (RF) que se derivan de este caso de uso.
Esto establece trazabilidad descendente.

Los RF son funciones específicas que el sistema debe implementar para soportar este caso de uso.
-->

- [RF-DOMINIO-###]: [Descripción breve del requisito funcional]
- [RF-DOMINIO-###]: [Descripción breve del requisito funcional]
- [RF-DOMINIO-###]: [Descripción breve del requisito funcional]

<!--
Ejemplo:
- RF-BACK-010: Validar credenciales contra base de datos
- RF-BACK-011: Generar token JWT con expiración de 15 minutos
- RF-BACK-012: Registrar intento de login en log de auditoría
-->

## Atributos de Calidad Relacionados

<!--
OPCIONAL: Si hay Atributos de Calidad (RNF) específicos no listados en "Requisitos Especiales",
inclúyalos aquí.

Si ya están en "Requisitos Especiales" o no hay, elimine esta sección.
-->

- [RNF-DOMINIO-###]: [Descripción breve]
- [RNF-DOMINIO-###]: [Descripción breve]

## Diagrama de Casos de Uso

<!--
OPCIONAL: Si existe un diagrama UML de casos de uso que ilustra este UC, referencie aquí.
Los diagramas complementan la especificación textual.
-->

![Diagrama de Casos de Uso](../diagramas/casos_uso/UCD-[DOMINIO]-[###]-[descripcion].svg)

**Fuente**: [UCD-[DOMINIO]-[###]-[descripcion].puml](../diagramas/casos_uso/UCD-[DOMINIO]-[###]-[descripcion].puml)

## Diagrama de Actividad

<!--
OPCIONAL: Si este caso de uso tiene flujos complejos (>= 3 flujos alternos, condicionales anidadas,
bucles), incluya un diagrama de actividad.

Elimine esta sección si no existe el diagrama.
-->

![Diagrama de Actividad](../diagramas/actividad/ACT-[DOMINIO]-[###]-[descripcion].svg)

**Fuente**: [ACT-[DOMINIO]-[###]-[descripcion].puml](../diagramas/actividad/ACT-[DOMINIO]-[###]-[descripcion].puml)

## Información Adicional

**Prioridad**: [Alta | Media | Baja]

<!--
Alta: Funcionalidad crítica, core del sistema
Media: Importante pero no crítica
Baja: Nice to have
-->

**Frecuencia de uso**: [Diaria | Semanal | Mensual | Ocasional]

<!--
Ayuda a entender qué tan frecuentemente se ejecuta este caso de uso
-->

**Complejidad estimada**: [Baja | Media | Alta]

<!--
Estimación de cuán complejo es implementar este caso de uso
-->

**Suposiciones**:
<!--
Liste suposiciones que se hacen al especificar este caso de uso.
Si no hay, elimine este apartado.
-->
- [Suposición 1]
- [Suposición 2]

**Notas**:
<!--
Cualquier nota adicional relevante.
Si no hay, elimine este apartado.
-->
- [Nota 1]
- [Nota 2]

## Historial de Cambios

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0.0 | [YYYY-MM-DD] | [Autor] | Versión inicial |

<!-- Agregue nuevas filas para cambios posteriores -->

## Aprobación

**Especificado por**: [Nombre]

**Revisado por**: [Nombre] - [Fecha]

**Aprobado por**: [Nombre] - [Fecha]

**Fecha de próxima revisión**: [YYYY-MM-DD]
