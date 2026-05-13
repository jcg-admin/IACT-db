# Reglas de Negocio en Ingeniería de Requerimientos - IACT

**Documento:** Guía Integral de Reglas de Negocio
**Proyecto:** IACT (Django 5 + React + PostgreSQL + MariaDB)
**Versión:** 1.0
**Última actualización:** 2025-11-14
**Audiencia:** Analistas de Requerimientos, Arquitectos de Software, Desarrolladores

---

## Índice

1. [Introducción a las Reglas de Negocio](INTRODUCCION.md)
2. [Tipos de Reglas: Hechos y Restricciones](HECHOS_RESTRICCIONES.md)
3. [Tipos Avanzados: Activadores, Inferencias y Cálculos](TIPOS_AVANZADOS.md)
4. [Aplicación en el Proyecto IACT](APLICACION_IACT.md)

---

## ¿Qué son las Reglas de Negocio?

**Definición:** Las reglas de negocio son políticas, leyes y estándares de la industria bajo los cuales se rige cada organización para operar de manera efectiva y conforme a las regulaciones.

**También conocidas como:** Lógica de negocio (business logic)

---

## Jerarquía de Requerimientos en IACT

```
Nivel 1: REGLAS DE NEGOCIO
         |
         v
Nivel 2: REQUERIMIENTOS DE NEGOCIO (Objetivos organizacionales)
         |
         v
Nivel 3: REQUERIMIENTOS DE USUARIO (Necesidades específicas)
         |
         v
Nivel 4: REQUERIMIENTOS FUNCIONALES (Funcionalidades del sistema)
         |
         v
Nivel 5: ATRIBUTOS DE CALIDAD (Características no funcionales)
```

---

## Funciones Principales

1. **Restricción de acceso:** Restringen quién puede realizar ciertos casos de uso
2. **Control de funcionalidad:** Dictan qué funcionalidad debe continuar el sistema para cumplir con las normas pertinentes

---

## Cinco Tipos de Reglas de Negocio

### 1. Hechos
Declaraciones verdaderas sobre el negocio en un punto específico del tiempo.

**Ejemplo IACT:**
- Cada operador IVR debe tener una extensión única
- Cada llamada registrada debe asociarse a un agente específico
- Cada campaña debe tener una fecha de inicio y finalización

### 2. Restricciones
Sentencias que restringen las acciones que el sistema o usuarios pueden realizar.

**Ejemplo IACT:**
- Solo supervisores pueden reasignar llamadas de otros agentes
- Un agente no puede tener más de 5 llamadas activas simultáneamente
- Los reportes financieros solo pueden ser generados por gerentes

### 3. Desencadenadores de Acción (Activadores)
Reglas que activan alguna actividad si condiciones específicas son verdaderas.

**Ejemplo IACT:**
- Si una llamada supera los 20 minutos, entonces notificar al supervisor
- Si un agente tiene más de 10 llamadas en cola, entonces redistribuir a otros agentes

### 4. Inferencias
Crean un hecho nuevo a partir de otros hechos existentes.

**Ejemplo IACT:**
- Si un agente no responde 3 llamadas consecutivas, entonces marcar como "No Disponible"
- Si una campaña no tiene llamadas en 48 horas, entonces marcar como "Inactiva"

### 5. Cálculos Computacionales
Transforman datos existentes en nuevos datos usando fórmulas matemáticas o algoritmos.

**Ejemplo IACT:**
- Tiempo promedio de llamada = Suma(duración_llamadas) / Cantidad(llamadas)
- Tasa de conversión = (Llamadas exitosas / Total llamadas) × 100

---

## Influencia en los Requerimientos IACT

| Tipo de Requerimiento | Cómo Influyen las Reglas | Ejemplo IACT |
|----------------------|-------------------------|-------------|
| **Requerimientos de Negocio** | Regulaciones conducen a objetivos necesarios | El sistema debe cumplir con LFPDPPP para protección de datos personales |
| **Requerimientos de Usuario** | Políticas dictan qué usuarios pueden hacer tareas | Supervisores pueden acceder a grabaciones de llamadas |
| **Requerimientos Funcionales** | Políticas establecen procesos específicos | Toda llamada debe registrar: hora inicio, duración, agente, resultado |
| **Atributos de Calidad** | Regulaciones dictan requisitos de seguridad | Sistema debe encriptar datos personales de clientes (LFPDPPP) |

---

## Documentos Relacionados

- [Casos de Uso](../CASOS_USO.md) - Metodología y especificación de casos de uso
- [Constitución del Proyecto](../../../../.constitucion.yaml) - Reglas R1-R6
- [ADR-010: Organización por Dominio](../../adr/ADR_010_organizacion_proyecto_por_dominio.md)
- [Estrategia de IA](../../ai/ESTRATEGIA_IA.md)

---

## Referencias Externas

- **LFPDPPP:** Ley Federal de Protección de Datos Personales en Posesión de los Particulares (México)
- **ISO/IEC 25010:** Estándares de calidad de software
- **BABOK:** Business Analysis Body of Knowledge

---

**Mantenedor:** Equipo de Arquitectura IACT
**Última revisión:** 2025-11-14
