```yml
type: Architectural Decision Record
category: Decisión Técnica
version: 1.0
purpose: Documentar decisión sobre formato de documentación
goal: Establecer Markdown como estándar de documentación
updated_at: 2026-03-25
```

# ADR-001: Markdown para Documentación

## Metadatos

**ADR ID:** ADR-001<br>
**Título:** Markdown para Documentación<br>
**Fecha:** 2025-03-24<br>
**Status:** Aprobado<br>
**Owner:** User<br>
**Revisor:** Team

---

## Contexto

Necesitamos elegir formato para documentación del proyecto THYROX.

**Drivers de negocio:**
- Documentación debe ser mantenible
- Debe estar versionada en Git
- Debe ser accesible sin herramientas especiales

**Restricciones técnicas:**
- Debe integrarse con GitHub
- Debe soportar código embebido
- Debe soportar tablas y referencias

---

## Opciones Consideradas

### Opción 1: Markdown

**Descripción:**
Usar Markdown como formato estándar para toda documentación.

**Ventajas:**<br>
+ Simple de escribir y leer<br>
+ Versionable en Git<br>
+ GitHub lo renderiza nativamente<br>
+ Fácil de convertir a otros formatos (HTML, PDF)<br>
+ No requiere herramientas especiales<br>
+ Legible en texto plano<br>
+ Amplio ecosistema de herramientas

**Desventajas:**<br>
- No hay UI visual para edición<br>
- Requiere git knowledge para contribuir<br>
- Requiere disciplina para mantener actualizado

---

### Opción 2: Confluence

**Descripción:**
Usar Confluence como wiki centralizado.

**Ventajas:**<br>
+ Interfaz visual amigable<br>
+ Búsqueda centralizada<br>
+ Permisos granulares<br>
+ Colaboración en tiempo real

**Desventajas:**<br>
- No versionable (sin historial claro)<br>
- Requiere suscripción pagada<br>
- Lock-in a plataforma Atlassian<br>
- No se integra bien con Git<br>
- Difícil de exportar/migrar

---

### Opción 3: Notion

**Descripción:**
Usar Notion como base de conocimiento.

**Ventajas:**<br>
+ Interfaz hermosa y moderna<br>
+ Flexible (bases de datos, wikis, etc)<br>
+ Colaboración integrada

**Desventajas:**<br>
- Completamente cerrado (no versionable)<br>
- Requiere suscripción<br>
- Difícil de consultar sin acceso<br>
- No se integra con Git<br>
- Imposible auditar cambios

---

## Decisión

**Se elige:** Markdown

**Razón principal:** Markdown es la única opción que permite documentación versionada, sin dependencias externas, y completamente integrada con Git.

---

## Justificación

Markdown cumple todos nuestros requisitos:

1. **Versionable** - Historial completo en Git
2. **Accesible** - Legible en cualquier editor de texto
3. **GitHub-native** - Renderizado automático
4. **No requiere herramientas** - Solo Git
5. **Conversión fácil** - A HTML, PDF, etc
6. **Estándar de industria** - Ampliamente adoptado

**Trade-offs aceptados:**
- Perdemos UI visual bonita (compensado por simplicidad)
- Perdemos búsqueda centralizada (compensado por Git grep)
- Requiere git knowledge (mitigado con documentación clara)

---

## Consecuencias

### Positivas

+Documentación versionada y auditables<br>
+Sin dependencia de servicios externos<br>
+Bajo costo (sin suscripciones)<br>
+Fácil de mantener en el repositorio<br>
+Excelente para proyectos de código abierto

### Negativas

-Requiere disciplina para mantener actualizado<br>
-No hay UI visual tipo Confluence<br>
-Requiere git knowledge de contributors<br>
-Búsqueda menos potente que plataformas especializadas

### Mitigaciones

Falta de actualización → ROADMAP.md como single source of truth<br>
Falta de UI visual → GitHub README improvements<br>
Git knowledge requerido → CONTRIBUTING.md con guías claras<br>
Búsqueda débil → GitHub search + grep scripts

---

## Impacto

**Áreas afectadas:**<br>
- Documentación del proyecto<br>
- Proceso de onboarding<br>
- Herramientas de documentación

**Esfuerzo de implementación:** Bajo<br>
**Fecha planeada:** 2025-03-24<br>
**Fecha real de implementación:** 2025-03-24

---

## Implementación

**Pasos:**<br>
1. Crear estructura de directorios (/docs, /reference)<br>
2. Convertir documentación existente a Markdown<br>
3. Crear CONTRIBUTING.md con guías<br>
4. Configurar GitHub Pages (opcional)<br>
5. Entrenar al equipo en Markdown

**Responsables:**<br>
- User: Arquitectura y decisión<br>
- Team: Implementación y mantenimiento

**Criterios de éxito:**<br>
- [ ] Toda documentación en Markdown<br>
- [ ] Visible en GitHub<br>
- [ ] CONTRIBUTING.md actualizado<br>
- [ ] Team puede escribir docs

---

## Referencias

- [CommonMark Specification](https://spec.commonmark.org/)
- [GitHub Flavored Markdown](https://github.github.com/gfm/)
- [Markdown Best Practices](https://www.markdownguide.org/basics/)

---

## Historial de Cambios

| Versión | Fecha | Cambios | Autor |
|---------|-------|---------|-------|
| 1.0 | 2025-03-24 | Versión inicial | User |

---

## Aprobaciones

| Rol | Nombre | Fecha | Firma |
|-----|--------|-------|-------|
| Owner | User | 2025-03-24 | +|

---

**Última Actualización:** 2026-03-25<br>
**Estado:** Activo en producción
