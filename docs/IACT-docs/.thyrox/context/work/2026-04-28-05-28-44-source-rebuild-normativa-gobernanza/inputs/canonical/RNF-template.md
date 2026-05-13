---
id: RNF-[DOMINIO]-[###]
tipo: atributo_calidad
subtipo: [rendimiento|seguridad|usabilidad|confiabilidad|mantenibilidad|portabilidad|escalabilidad|disponibilidad]
categoria: [DOMINIO]
version: 1.0.0
fecha_creacion: [YYYY-MM-DD]
ultima_actualizacion: [YYYY-MM-DD]
autor: [NOMBRE_AUTOR]
estado: [borrador|en_revision|aprobado|validado|obsoleto]
prioridad: [alta|media|baja]
---

# RNF-[DOMINIO]-[###]: [Título del Atributo de Calidad]

<!--
INSTRUCCIONES:
- Reemplace [DOMINIO] con: BACK, FRONT, DEVOPS, QA, AI, GOB
- Reemplace [###] con número secuencial: 001, 002, 003, etc.
- Los RNF describen CÓMO debe comportarse el sistema
- También llamados "Requisitos No Funcionales" o "Atributos de Calidad"

CATEGORÍAS COMUNES:
- Rendimiento/Performance: Tiempo de respuesta, throughput, latencia
- Seguridad: Autenticación, autorización, encriptación, protección de datos
- Usabilidad: Facilidad de uso, accesibilidad, experiencia de usuario
- Confiabilidad: Disponibilidad, tolerancia a fallos, recuperación
- Mantenibilidad: Facilidad de mantenimiento, modularidad, documentación
- Portabilidad: Compatibilidad con plataformas, navegadores, dispositivos
- Escalabilidad: Capacidad de crecer, usuarios concurrentes
- Disponibilidad: Uptime, SLA

CARACTERÍSTICAS CRÍTICAS:
- DEBE SER MEDIBLE (incluir métrica específica)
- Evitar términos vagos como "rápido", "fácil", "seguro" sin definir qué significan
- Incluir valores numéricos específicos cuando sea posible
-->

## Categoría

[Rendimiento | Seguridad | Usabilidad | Confiabilidad | Mantenibilidad | Portabilidad | Escalabilidad | Disponibilidad]

## Descripción

<!--
Describa el atributo de calidad de manera clara.
¿Qué aspecto de la calidad del sistema se está especificando?
-->

El sistema debe [describir el atributo de calidad que el sistema debe cumplir]

## Métrica Medible

<!--
CRÍTICO: Todo RNF DEBE tener una métrica medible.
Sin métrica, no se puede validar si se cumple el requisito.

Use el formato: [Métrica] [Operador] [Valor] [Unidades] [Condiciones]

Ejemplos:
- Tiempo de respuesta < 2 segundos bajo carga normal
- Disponibilidad >= 99.9% mensual
- Contraseña debe tener >= 8 caracteres
- Soporte para >= 1000 usuarios concurrentes
- Cobertura de tests >= 80% de líneas de código
-->

**Métrica**: [Qué se mide]

**Valor objetivo**: [Operador] [Número] [Unidades]

**Condiciones**: [Bajo qué condiciones aplica esta métrica]

<!--
EJEMPLO (Rendimiento):
Métrica: Tiempo de respuesta de API
Valor objetivo: < 2 segundos
Condiciones: Bajo carga de hasta 1000 usuarios concurrentes, percentil 95

EJEMPLO (Seguridad):
Métrica: Longitud de contraseña
Valor objetivo: >= 8 caracteres
Condiciones: Para todas las contraseñas de usuarios

EJEMPLO (Disponibilidad):
Métrica: Uptime del sistema
Valor objetivo: >= 99.9%
Condiciones: Medido mensualmente, excluyendo mantenimientos programados
-->

## Método de Medición

<!--
¿Cómo se mide si este atributo se cumple?
¿Qué herramientas o técnicas se usan?
-->

**Herramienta de medición**: [Nombre de herramienta o método]

**Frecuencia de medición**: [Continua | Diaria | Semanal | Mensual | Por release]

**Proceso de medición**:
1. [Paso 1 para medir]
2. [Paso 2 para medir]
3. [Paso 3 para medir]

**Responsable de medición**: [Quién mide o valida]

<!--
EJEMPLO (Rendimiento):
Herramienta de medición: JMeter, New Relic APM
Frecuencia de medición: Continua en producción, tests de carga en cada release
Proceso de medición:
1. Configurar test de carga con 1000 usuarios virtuales concurrentes
2. Ejecutar escenarios típicos de uso durante 30 minutos
3. Recolectar tiempo de respuesta para cada request
4. Calcular percentil 95 de tiempos de respuesta
5. Verificar que percentil 95 < 2 segundos
Responsable de medición: Equipo de QA + DevOps
-->

## Criterios de Aceptación

<!--
¿Cómo se valida que este atributo de calidad se cumple?
Sea específico y medible.
-->

**Criterios de cumplimiento**:
1. [Criterio 1 medible y específico]
2. [Criterio 2 medible y específico]
3. [Criterio 3 medible y específico]

**Umbrales**:
- **Mínimo aceptable**: [Valor mínimo para considerar cumplido]
- **Objetivo**: [Valor objetivo deseado]
- **Óptimo**: [Valor ideal]

<!--
EJEMPLO (Rendimiento):
Criterios de cumplimiento:
1. El 95% de requests deben completarse en < 2 segundos
2. El 99% de requests deben completarse en < 5 segundos
3. No debe haber requests que tarden > 10 segundos

Umbrales:
- Mínimo aceptable: 95% < 3 segundos
- Objetivo: 95% < 2 segundos
- Óptimo: 95% < 1 segundo
-->

## Alcance

<!--
¿A qué parte del sistema aplica este RNF?
¿Es para todo el sistema o solo módulos específicos?
-->

**Aplica a**: [Todo el sistema | Módulo específico | Casos de uso específicos | Componente específico]

**Módulos/Componentes afectados**:
- [Módulo 1]
- [Módulo 2]
- [Módulo 3]

**Excepciones**:
<!--
Si hay partes del sistema que NO deben cumplir este RNF, especifique aquí.
Si no hay excepciones, elimine este apartado.
-->
- [Excepción 1]: [Por qué no aplica]
- [Excepción 2]: [Por qué no aplica]

## Trazabilidad

<!--
Relacione este RNF con otros artefactos de requisitos.
-->

### Trazabilidad Ascendente

**Aplica a Casos de Uso**:
- [UC-DOMINIO-###]: [Nombre del caso de uso]
- [UC-DOMINIO-###]: [Nombre del caso de uso]

<!--
Ejemplo:
- UC-BACK-001: Iniciar Sesión
- UC-BACK-002: Cerrar Sesión
- UC-BACK-003: Cambiar Contraseña
-->

**Derivado de Reglas de Negocio**:
- [RN-DOMINIO-###]: [Nombre de la regla]

<!--
Ejemplo:
- RN-BACK-001: Usuario debe estar autenticado (implica requisitos de seguridad)
-->

**Relacionado con Requerimientos de Negocio**:
- [RNEG-DOMINIO-###]: [Nombre]

### Trazabilidad Descendente

**Implementado en Requisitos Funcionales**:
- [RF-DOMINIO-###]: [Qué RF implementa o soporta este RNF]
- [RF-DOMINIO-###]: [Qué RF implementa o soporta este RNF]

<!--
Ejemplo (para RNF de contraseña >= 8 caracteres):
- RF-BACK-015: Validar formato de contraseña
- RF-BACK-016: Rechazar contraseñas que no cumplan requisitos
-->

**Tests de Validación**:
- [TS-RNF-###-001]: [Descripción del test]
- [TS-RNF-###-002]: [Descripción del test]

<!--
Ejemplo:
- TS-RNF-005-001: Test que contraseña < 8 caracteres es rechazada
- TS-RNF-005-002: Test que contraseña >= 8 caracteres es aceptada
- TS-RNF-005-003: Test de performance con 1000 usuarios concurrentes
-->

## Impacto en Arquitectura

<!--
OPCIONAL pero RECOMENDADO: ¿Cómo afecta este RNF las decisiones de arquitectura?
Los RNF frecuentemente son los que más impactan la arquitectura del sistema.
-->

**Decisiones arquitectónicas influenciadas**:
- [Decisión 1]: [Cómo este RNF afecta la arquitectura]
- [Decisión 2]: [Cómo este RNF afecta la arquitectura]

**Componentes/Patrones requeridos**:
- [Componente/Patrón 1]: [Por qué es necesario para cumplir este RNF]
- [Componente/Patrón 2]: [Por qué es necesario para cumplir este RNF]

<!--
EJEMPLO (para RNF de rendimiento < 2 segundos):
Decisiones arquitectónicas influenciadas:
- Implementar caché de queries frecuentes (Redis)
- Usar CDN para contenido estático
- Implementar paginación en todas las listas

Componentes/Patrones requeridos:
- Redis: Para caché de resultados de consultas
- CDN (CloudFlare/CloudFront): Para servir assets estáticos
- Índices de base de datos: En campos frecuentemente consultados
-->

## Validación

<!--
¿Cómo y cuándo se valida que este RNF se cumple?
-->

**Tipo de validación**: [Tests de performance | Tests de seguridad | Auditoría de código | Prueba de usabilidad | Análisis estático | Monitoreo en producción]

**Frecuencia de validación**: [Por cada PR | Por cada release | Mensual | Trimestral | Continua]

**Criterio de éxito de validación**:
[Qué debe pasar en la validación para considerar que el RNF se cumple]

**Acción si no se cumple**:
[Qué sucede si la validación falla]

<!--
EJEMPLO (Rendimiento):
Tipo de validación: Tests de carga con JMeter
Frecuencia de validación: Por cada release + monitoreo continuo en producción
Criterio de éxito: Tests de carga muestran 95% de requests < 2 segundos
Acción si no se cumple: Bloquear release hasta que se corrija el problema de rendimiento
-->

## Prioridad y Riesgos

**Prioridad**: [Alta | Media | Baja]

**Justificación de prioridad**:
[Por qué este RNF tiene esta prioridad]

**Riesgos si no se cumple**:
- [Riesgo 1]: [Qué puede pasar]
- [Riesgo 2]: [Qué puede pasar]

**Impacto de no cumplimiento**: [Crítico | Alto | Medio | Bajo]

<!--
EJEMPLO:
Prioridad: Alta
Justificación: Los usuarios abandonan el sistema si es muy lento
Riesgos si no se cumple:
- Pérdida de usuarios por mala experiencia
- Incumplimiento de SLA con clientes
- Daño a reputación de la marca
Impacto de no cumplimiento: Alto
-->

## Estado de Cumplimiento

**Estado actual**: [No implementado | Parcialmente implementado | Implementado | Validado | En riesgo | No cumple]

**Última medición**: [Fecha de última medición]

**Último valor medido**: [Valor obtenido en última medición]

**Comparación con objetivo**: [Cumple | No cumple | En progreso]

**Acciones correctivas** (si no cumple):
- [Acción 1 para lograr cumplimiento]
- [Acción 2 para lograr cumplimiento]

## Dependencias

**Dependencias técnicas**:
<!--
Qué se necesita técnicamente para cumplir este RNF
-->
- [Dependencia 1]
- [Dependencia 2]

**Dependencias de otros RNF**:
<!--
Otros RNF que deben cumplirse para que este también se cumpla
-->
- [RNF-DOMINIO-###]: [Cómo se relaciona]

## Notas Adicionales

<!--
OPCIONAL: Cualquier información adicional relevante.
Elimine esta sección si no es necesaria.
-->

[Notas, observaciones, consideraciones especiales]

## Historial de Cambios

| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | [YYYY-MM-DD] | [Autor] | Versión inicial | N/A | [Valor inicial] |

<!--
IMPORTANTE: Para RNF, es crítico trackear cambios en valores/métricas.
Ejemplo:
| Versión | Fecha | Autor | Cambios | Valor Anterior | Valor Nuevo |
|---------|-------|-------|---------|----------------|-------------|
| 1.0.0 | 2025-01-15 | Juan Pérez | Versión inicial | N/A | < 2 seg |
| 1.1.0 | 2025-03-20 | María López | Ajuste por crecimiento | < 2 seg | < 3 seg |
-->

## Aprobación

**Especificado por**: [Nombre]

**Revisado por**: [Nombre] - [Fecha]

**Aprobado por**: [Nombre] - [Fecha]

**Validado por** (cumplimiento confirmado): [Nombre] - [Fecha]
