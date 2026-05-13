```yml
type: Referencia PHASE 1: ANALYZE
category: Análisis
version: 1.0
purpose: Guía de cómo documentar CÓMO funciona el sistema operacionalmente desde perspectiva usuario.
goal: Describir flujos completos de uso del sistema.
updated_at: 2026-03-25
owner: workflow-discover
```

# Basic Usage (How It Works)

## Propósito

Guía de cómo documentar CÓMO funciona el sistema operacionalmente desde perspectiva usuario.

> Objetivo: Describir flujos completos de uso del sistema.

---

## Estructura Pura de Basic Usage

### 1. Descripción Narrativa Simple

Explicación en prosa clara de cómo opera el sistema.

**Características:**
- Lenguaje simple y directo
- Orientado al usuario, no técnico
- Establece contexto de uso
- Una o dos párrafos máximo

**Ejemplo:**
```
"El objetivo general de HtmlSC es crear reportes ordenados y claros 
que muestren errores dentro de archivos HTML."

"HtmlSC verifica HTML para errores semánticos como enlaces rotos 
e imágenes faltantes. Fue creado para apoyar a autores que crean 
HTML como formato de salida."
```

---

### 2. Secuencia de Pasos Numerados

Proceso paso a paso de cómo funciona.

**Características:**
- Secuencia lógica (1, 2, 3...)
- Cada paso es observable y verificable
- Describe OPERACIÓN, no requisitos
- Puede incluir diagrama visual

**Ejemplo:**
```
Cómo funciona HtmlSC:

1. Los autores escriben en formatos como AsciiDoc, Markdown, etc.
2. Generadores transforman estos formatos a HTML
3. HtmlSC verifica el HTML generado para errores
4. HtmlSC crea un reporte similar a reportes de pruebas unitarias
```

---

### 3. Diagrama de Flujo (Opcional)

Representación visual del flujo de operación.

**Ejemplo:**
```
Autor escribe
    ↓
Generador (AsciiDoc, Markdown) transforma a HTML
    ↓
HtmlSC verifica HTML
    ↓
Reporte de errores
```

**Características:**
- Simple y clara
- Muestra flujo principal
- No entra en detalles técnicos
- Orientada al usuario

---

### 4. Modos de Operación

Diferentes formas de usar el sistema.

**Formato:**
```
Modo 1: [Nombre]
- [Descripción]
- [Cuándo usar]
- [Acceso]

Modo 2: [Nombre]
- [Descripción]
- [Cuándo usar]
- [Acceso]
```

**Características:**
- Diferentes puntos de entrada
- Cada uno es un escenario de uso válido
- Claridad sobre cuándo usar cada uno

**Ejemplo:**
```
Modo 1: Línea de comandos (CLI)
- Usuario configura ubicación de archivos HTML
- Usuario configura directorio de imágenes
- HtmlSC ejecuta y reporta en consola

Modo 2: Plugin Gradle
- Se integra en el proceso de build
- Automático dentro del pipeline
- Reporta resultados como parte del build
```

---

### 5. Resultado Observable

Qué produce el sistema como salida.

**Características:**
- Observable y verificable
- Tangible (usuario puede ver/usar)
- Conecta entrada con salida

**Ejemplo:**
```
Salidas posibles:
- Reporte en consola con lista de errores
- Reporte HTML con errores formateados
- Reporte estructurado para integración
```

---

## Ejemplo: Ecommerce

### Descripción Narrativa

```
El objetivo general del ecommerce es permitir que clientes compren 
productos en línea de forma segura, rápida y confiable.

El sistema cubre todo el ciclo de vida de una compra: desde navegación, 
carrito, checkout, pago, hasta seguimiento de pedidos.
```

### Flujo Principal

```
1. Usuario accede a la plataforma ecommerce
2. Navega y busca productos del catálogo
3. Selecciona producto(s) y agrega al carrito
4. Revisa carrito y procede a checkout
5. Completa información de envío
6. Selecciona método de pago
7. Sistema procesa pago de forma segura
8. Genera confirmación de pedido
9. Usuario puede seguir estado del pedido
```

### Modos de Operación

```
Modo 1: Tienda Web
- Usuario accede vía navegador web
- Interfaz completa con todos los detalles
- Para compras complejas, preferencias

Modo 2: Aplicación Móvil
- Usuario accede vía app móvil
- Interfaz optimizada para pantalla pequeña
- Para compras rápidas, órdenes frecuentes

Modo 3: API REST
- Integradores pueden usar API
- Para terceros que integran ecommerce
- Programático, sin UI
```

### Diagrama de Flujo

```
Usuario
   ↓
Navegación → Búsqueda → Catálogo
              ↓
           Carrito
              ↓
Checkout → Envío → Pago
    ↓
Confirmación
    ↓
Seguimiento
```

### Resultados Observables

```
El usuario observa:
- Confirmación de compra en pantalla
- Email de confirmación recibido
- Pedido aparece en "Mis Pedidos"
- Acceso a seguimiento de envío
```

---

## Checklist para Basic Usage

### Contenido
- [ ] Descripción narrativa clara
- [ ] Pasos numerados y secuenciales
- [ ] Cada paso es observable
- [ ] Flujo completo del sistema
- [ ] Modos de operación descritos
- [ ] Resultados observables

### Estructura
- [ ] Lenguaje simple (no técnico)
- [ ] Orientado a usuario
- [ ] Narrativa coherente
- [ ] Diagrama visual (opcional)
- [ ] Completo pero conciso

### Trazabilidad
- [ ] Conectado a Requirements (1.1)
- [ ] Conectado a Quality Goals (1.2)
- [ ] Diferente de Build View (Section 5)
- [ ] Diferente de Runtime View (Section 6)

---

## Diferencias con Otras Secciones

**Basic Usage (1.1) vs Requirements (1.1):**
- Basic Usage: CÓMO funciona
- Requirements: QUÉ debe hacer

**Basic Usage (1.1) vs Section 5 (Building Block View):**
- Basic Usage: Flujo de usuario
- Building Blocks: Estructura técnica interna

**Basic Usage (1.1) vs Section 6 (Runtime View):**
- Basic Usage: Operación general
- Runtime: Secuencias detalladas de componentes

---

## Errores Comunes a Evitar

### [ERROR] NO hacer:
```
- Detalles técnicos de implementación
- Nombres de clases o métodos
- Diagramas de arquitectura interna
- Pasos que el usuario no ve
- Demasiados pasos (perder el hilo)
- Lenguaje técnico sin explicación
```

### HACER:
```
- Pasos observables por el usuario
- Lenguaje simple y directo
- Narrativa clara
- Conectar a requisitos y objetivos
- Incluir diagrama simple si ayuda
- Mostrar diferentes modos de uso
```

---

## Template para Basic Usage

Usar: [basic-usage.md.template](../assets/basic-usage.md.template)

**Estructura del documento:**
```
# Basic Usage: [Nombre del proyecto]

## Descripción Narrativa
[2-3 párrafos sobre propósito y contexto]

## Flujo Principal de Operación
[Pasos numerados 1, 2, 3, ...]

## Modos de Operación
[Diferentes formas de usar el sistema]

## Diagrama de Flujo
[Visual del flujo principal]

## Resultados Observables
[Qué el usuario ve/obtiene]

## Validación
[Checklist]
```

---

## Próximo Paso

Una vez completado: → Pasar a [constraints](./constraints.md)

---

**Última actualización**: 2026-02-01
