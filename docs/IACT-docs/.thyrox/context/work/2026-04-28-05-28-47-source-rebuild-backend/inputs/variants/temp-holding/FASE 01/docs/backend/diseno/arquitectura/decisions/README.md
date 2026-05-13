# Architecture Decision Records (ADR) - Backend

Registro de decisiones arquitectónicas importantes del backend.

---

## ¿Qué es un ADR?

Un Architecture Decision Record (ADR) es un documento que captura una decisión arquitectónica importante junto con su contexto y consecuencias. Los ADRs ayudan a:

- **Documentar el "por qué"** detrás de decisiones técnicas importantes
- **Comunicar decisiones** al equipo y futuros desarrolladores
- **Evitar re-decisiones** de temas ya analizados
- **Proveer contexto histórico** sobre la evolución del sistema
- **Facilitar onboarding** de nuevos miembros del equipo

---

## Cómo Usar

### 1. ¿Cuándo crear un ADR?

Crea un ADR cuando tomes una decisión que:

- [ ] Tenga **impacto significativo** en la arquitectura del backend
- [ ] Afecte **múltiples componentes** o servicios
- [ ] Tenga **consecuencias a largo plazo**
- [ ] Involucre **trade-offs importantes**
- [ ] Sea **difícil o costosa de revertir**
- [ ] Requiera **justificación** para stakeholders

**Ejemplos de decisiones que requieren ADR:**
- Elegir un framework (Django vs FastAPI vs Flask)
- Estrategia de base de datos (SQL vs NoSQL, partitioning)
- Patrón de arquitectura (monolito vs microservicios)
- Tecnología de caching (Redis vs Memcached)
- Estrategia de autenticación (JWT vs sessions)
- Patrón de comunicación entre servicios (REST vs GraphQL vs gRPC)

**Ejemplos que NO requieren ADR:**
- Nombrar una variable
- Elegir una librería menor
- Decisiones reversibles fácilmente
- Cambios localizados a un solo componente pequeño

### 2. Proceso de Creación

```bash
# Paso 1: Copiar la plantilla
cp plantilla-adr-backend.md ADR-BACKEND-XXX-titulo-descriptivo.md

# Paso 2: Completar el ADR
# - Reemplazar XXX con el siguiente número secuencial
# - Llenar todas las secciones relevantes
# - Documentar opciones consideradas con pros/cons
# - Justificar la decisión tomada

# Paso 3: Crear PR
git checkout -b adr/backend-xxx-titulo
git add ADR-BACKEND-XXX-titulo-descriptivo.md
git commit -m "docs(adr): añadir ADR-BACKEND-XXX sobre [tema]"
git push origin adr/backend-xxx-titulo

# Paso 4: Revisión
# - Solicitar revisión de Tech Lead y/o Arquitecto
# - Presentar en reunión de arquitectura si es necesario
# - Incorporar feedback

# Paso 5: Aprobación y Merge
# - Actualizar estado a "ACEPTADA" tras aprobación
# - Mergear PR
# - Comunicar decisión al equipo
```

### 3. Numeración de ADRs

- Formato: `ADR-BACKEND-001`, `ADR-BACKEND-002`, etc.
- **Números secuenciales** (no reutilizar números)
- Ver último ADR para siguiente número disponible
- Usar números con 3 dígitos con padding de ceros (001, 002, ... 010, 011)

### 4. Estados de un ADR

- **PROPUESTA:** En discusión, esperando feedback
- **ACEPTADA:** Aprobada e implementada (o en implementación)
- **RECHAZADA:** Evaluada pero no se implementará
- **DEPRECADA:** Ya no aplica al sistema actual
- **REEMPLAZADA:** Sustituida por ADR-BACKEND-XXX

**Importante:** Los ADRs son **inmutables** una vez aceptados. No edites un ADR aceptado para cambiar la decisión. En su lugar:
1. Crea un nuevo ADR con la nueva decisión
2. Marca el ADR antiguo como "REEMPLAZADA"
3. Referencia el nuevo ADR en ambos documentos

---

## Plantillas Disponibles

- [`plantilla-adr-backend.md`](./plantilla-adr-backend.md) - Plantilla estándar para ADRs de backend

---

## Índice de ADRs

### ADRs Activas (ACEPTADAS)

Agregar aquí los ADRs conforme se van creando:

| ID | Título | Fecha | Estado | Área |
|----|--------|-------|--------|------|
| [ADR-BACKEND-001](./ADR-BACKEND-001-ejemplo.md) | Ejemplo de ADR | 2025-11-18 | PROPUESTA | Ejemplo |

<!-- Añadir nuevos ADRs aquí -->

### ADRs Deprecadas/Reemplazadas

| ID | Título | Estado | Reemplazada por |
|----|--------|--------|-----------------|
| - | - | - | - |

---

## Mejores Prácticas

### Al Escribir un ADR

1. **Ser conciso pero completo:** No escribir un libro, pero tampoco ser demasiado breve
2. **Documentar opciones descartadas:** Ayuda a no re-evaluar lo mismo en el futuro
3. **Incluir código de ejemplo:** Si aplica, muestra cómo se vería la implementación
4. **Cuantificar cuando sea posible:** "Reduce latencia en 40%" es mejor que "mejora performance"
5. **Considerar todas las perspectivas:** Desarrollo, operaciones, seguridad, negocio
6. **Documentar supuestos:** ¿Qué condiciones asumimos que son verdaderas?
7. **Incluir plan de rollback:** ¿Cómo revertir si algo sale mal?

### Al Revisar un ADR

1. **Validar el problema:** ¿El problema está bien definido?
2. **Evaluar alternativas:** ¿Se consideraron suficientes opciones?
3. **Cuestionar supuestos:** ¿Son válidos los supuestos?
4. **Verificar consecuencias:** ¿Se identificaron todos los impactos?
5. **Validar implementabilidad:** ¿Es realista el plan de implementación?

---

## Mantenimiento

### Revisión Periódica

- Revisar ADRs antiguas **cada 6-12 meses**
- Actualizar estado si ya no aplican (DEPRECADA)
- Crear nuevo ADR si la decisión cambió (marcar antigua como REEMPLAZADA)

### Actualización del Índice

- Actualizar el índice de ADRs cuando se añada/cambie un ADR
- Mantener ADRs ordenadas por número
- Separar ADRs activas de deprecadas

---

## Referencias

- [Plantilla ADR General](../../../../gobernanza/adr/plantilla_adr.md)
- [ADR GitHub](https://adr.github.io/)
- [Architecture Decision Records by Michael Nygard](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions)
- [Documentando Decisiones de Arquitectura](https://18f.gsa.gov/2021/07/06/architecture_decision_records_helpful_now_invaluable_later/)

---

## Contacto

**Maintainer:** Tech Lead Backend
**Revisores:** Arquitecto de Software, Tech Lead
**Slack:** #backend-architecture
**Issues:** Reportar en GitHub con label `adr`

---

**Última actualización:** 2025-11-18
**Versión:** 1.0.0
