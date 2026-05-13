---
id: ADR-TEMPLATE
estado: plantilla
propietario: equipo-arquitectura
ultima_actualizacion: 2025-11-02
relacionados: ["DOC-ARQ-INDEX"]
date: 2025-11-13
---
# ADR-YYYY-NNN: [Título Corto de la Decisión]

**Estado:** [propuesta | aceptada | rechazada | deprecada | reemplazada por ADR-XXX]

**Fecha:** YYYY-MM-DD

**Decisores:** [Lista de personas involucradas en la decisión]

**Contexto técnico:** [Backend | Frontend | Infrastructure | Full-stack]

## Contexto y Problema

Describe el contexto y el problema que estamos enfrentando. Esta sección debe ser lo suficientemente clara para que alguien que no esté familiarizado con el proyecto pueda entender el problema.

**Preguntas clave:**
- ¿Qué problema estamos tratando de resolver?
- ¿Por qué es importante resolver esto ahora?
- ¿Cuáles son las restricciones actuales?
- ¿Qué impacto tiene este problema?

## Factores de Decisión

Lista de factores que influyen en la decisión:

- **Performance**: Impacto en rendimiento del sistema
- **Escalabilidad**: Capacidad de crecer con la demanda
- **Complejidad**: Curva de aprendizaje y mantenibilidad
- **Costo**: Recursos necesarios (tiempo, dinero, personas)
- **Seguridad**: Implicaciones de seguridad
- **Compatibilidad**: Integración con sistemas existentes
- **Madurez**: Estabilidad de la tecnología/solución
- **Comunidad**: Soporte y documentación disponible

## Opciones Consideradas

### Opción 1: [Nombre de la Opción]

**Descripción:**
[Explicación detallada de esta opción]

**Pros:**
- OK Ventaja 1
- OK Ventaja 2
- OK Ventaja 3

**Contras:**
- NO Desventaja 1
- NO Desventaja 2
- NO Desventaja 3

**Ejemplo/Implementación:**
```python
# Código de ejemplo si aplica
```

---

### Opción 2: [Nombre de la Opción]

**Descripción:**
[Explicación detallada de esta opción]

**Pros:**
- OK Ventaja 1
- OK Ventaja 2

**Contras:**
- NO Desventaja 1
- NO Desventaja 2

**Ejemplo/Implementación:**
```python
# Código de ejemplo si aplica
```

---

### Opción 3: [Nombre de la Opción]

[Repetir estructura anterior...]

## Decisión

**Opción elegida:** "[Nombre de la opción]"

**Justificación:**
Explica por qué se eligió esta opción sobre las demás. Debe ser claro y convincente.

- Razón principal 1
- Razón principal 2
- Trade-offs aceptados

## Consecuencias

### Positivas
- OK Beneficio inmediato 1
- OK Beneficio a largo plazo 2
- OK Mejora en aspecto 3

### Negativas
- WARNING Costo o limitación 1
- WARNING Deuda técnica introducida 2
- WARNING Riesgo identificado 3

### Neutrales
- INFO Cambio necesario 1
- INFO Consideración adicional 2

## Plan de Implementación

1. **Fase 1: [Nombre]**
   - Acción específica 1
   - Acción específica 2
   - Timeframe: [X semanas]

2. **Fase 2: [Nombre]**
   - Acción específica 1
   - Acción específica 2
   - Timeframe: [X semanas]

3. **Fase 3: [Nombre]**
   - Acción específica 1
   - Acción específica 2
   - Timeframe: [X semanas]

## Validación y Métricas

**Criterios de Éxito:**
- Métrica 1: [Valor objetivo]
- Métrica 2: [Valor objetivo]
- Métrica 3: [Valor objetivo]

**Cómo medir:**
- Herramienta/método para medición 1
- Herramienta/método para medición 2

**Revisión:**
- Fecha de revisión programada: [YYYY-MM-DD]
- Responsable de seguimiento: [Nombre/Equipo]

## Alternativas Descartadas (Opcional)

### [Nombre de alternativa descartada tempranamente]

**Por qué se descartó:**
- Razón 1
- Razón 2

## Referencias

- [Enlace a documentación relevante]
- [Issue de GitHub relacionado]
- [RFC o propuesta original]
- [Artículo técnico o paper]
- [Documentación de herramienta/librería]

## Notas Adicionales

Información contextual adicional que puede ser útil:
- Fecha de discusión inicial
- Participantes en reuniones
- Links a conversaciones en Slack/Teams
- Experimentos o POCs realizados

---

## Instrucciones de Uso

1. **Copiar esta plantilla** para crear un nuevo ADR
2. **Nombrar el archivo**: `adr_YYYY_NNN_titulo_corto.md`
   - YYYY: Año (ej: 2025)
   - NNN: Número secuencial (001, 002, etc.)
   - titulo_corto: Descripción breve en snake_case
3. **Completar todas las secciones** relevantes
4. **Actualizar el frontmatter** con ID único
5. **Crear PR** para revisión del equipo de arquitectura
6. **Actualizar estado** a "aceptada" después de aprobación

## Ejemplo de Nomenclatura

```
ADR_2025_001-vagrant-mod-wsgi.md
adr_2025_002_django_rest_framework.md
adr_2025_003_postgresql_partitioning.md
```

## Enlaces Relacionados

- [Índice de Arquitectura](../README.md)
- [ADR_2025_001: Vagrant + mod_wsgi](ADR_2025_001-vagrant-mod-wsgi.md) (ejemplo existente)
- [Gobernanza](../../gobernanza/README.md)
