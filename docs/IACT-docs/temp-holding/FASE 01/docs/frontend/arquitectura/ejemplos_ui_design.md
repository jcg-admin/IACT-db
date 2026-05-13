---
id: DOC-FRONTEND-UI-PROMPTS
estado: activo
propietario: equipo-frontend
ultima_actualizacion: 2025-11-09
relacionados:
  - DOC-ARQ-FRONTEND
  - DOC-FRONTEND-INDEX
  - DOC-PROMPT-ENGINEERING
date: 2025-11-13
---
# Ejemplos avanzados de prompt engineering para UI design

Este compendio recopila estrategias y prompts reutilizables para diseñar interfaces gráficas mediante modelos generativos, integrando las técnicas avanzadas definidas en los artefactos de *Prompt Engineering* y las capacidades específicas del asistente Claude. El objetivo es acelerar la ideación, prototipado y validación de la experiencia de usuario minimizando riesgos de alucinación y asegurando cumplimiento de accesibilidad.

## Principios rectores

1. **Cadenas de pensamiento controladas**: Solicitar razonamientos paso a paso para auditar decisiones de UX (Auto-CoT + Self-Consistency).  
2. **Roles especializados**: Encapsular perspectiva (UI designer, UX researcher, frontend engineer) para cada etapa del proceso.  
3. **Uso estratégico de Artifacts**: Reservar componentes React o prototipos interactivos para momentos donde se necesita validación visual inmediata; preferir la modalidad *update* para iteraciones pequeñas.  
4. **Prevención de alucinaciones**: Exigir fuentes verificables, verificar estándares (WCAG, Material 3, design tokens corporativos) y bloquear referencias inexistentes.  
5. **Documentación viva**: Registrar decisiones clave mediante ADRs o comentarios contextuales, manteniendo trazabilidad entre prompts, entregables y cambios de código.

## Plantilla base de prompt modular

```text
<rol>: {UI designer | UX researcher | Frontend architect}
<contexto>: descripción breve del producto, usuarios y restricciones
<objetivo>: qué entregable se espera (wireframe textual, árbol de componentes, tokens)
<restricciones>: browser storage, datos reales/mocks, lineamientos de marca
<metodología>: aplicar Auto-CoT + Self-Consistency, validar accesibilidad, mencionar riesgos de alucinación
<salida>: formato esperado (tabla, JSON, markdown, artifact React)
```

## Cadena de prompts recomendada

1. **Descubrimiento UX** (role: UX researcher)  
   Prompt para mapear usuarios, tareas y pain points, citando fuentes y marcando supuestos a validar.
2. **Arquitectura de información** (role: Information architect)  
   Solicitar mapa del sitio, flujos y jerarquía de navegación con anotaciones de accesibilidad.  
3. **Wireframing textual** (role: UI designer)  
   Generar wireframes en formato texto/ASCII indicando layout responsive y breakpoints.  
4. **Design tokens** (role: Design system lead)  
   Definir paleta, tipografía, spacing y estados interactivos usando JSON o YAML compatible con tooling existente.  
5. **Componentización** (role: Frontend architect)  
   Listar componentes atómicos → moleculares → organismos, especificando props, variantes y contratos con el backend o mocks.  
6. **Prototipo interactivo (Artifact)** (role: UI engineer)  
   Cuando se requiera validar comportamientos, crear artifact React solicitando explícitamente `update` para iterar sin sobrescribir toda la estructura.  
7. **Pruebas de usabilidad y accesibilidad** (role: QA a11y)  
   Pedir checklist WCAG 2.2 AA, sugerir tests automáticos (axe, pa11y) y scripts de Cypress/Playwright.  
8. **Plan de implementación frontend** (role: Tech lead)  
   Generar backlog priorizado alineado con TDD y cobertura mínima del 80 %, conectando tareas con mocks del backend.

## Ejemplos concretos

### 1. Generación de wireframes responsivos

```text
Actúa como UI designer senior.
Contexto: Dashboard de call center con métricas en tiempo real.
Objetivo: Proponer wireframes responsive para desktop (≥1440px), tablet (768–1024px) y móvil (375px).
Restricciones: Branding corporativo azul, dark mode opcional, datos backend incompletos → usar mocks validados.
Metodología: Auto-CoT + Self-Consistency, justificar decisiones, marcar supuestos.
Salida: Markdown con secciones "Layout", "Interacciones", "Accesibilidad".
```

### 2. Blueprint de componentes con contrato backend

```text
Role: Frontend architect.
Contexto: Módulo "Gestión de llamadas" del call center.
Objetivo: Definir componentes (átomo → organismo) y props requeridas.
Restricciones: Backend api/callcentersite aún sin endpoints finales; usar `ui/src/mocks` como fallback.
Metodología: Explica cómo `createResilientService` orquesta mocks, documenta riesgos de alucinación de datos.
Salida: Tabla Markdown con columnas [Componente, Nivel, Props, Datos, Estrategia Resiliente].
```

### 3. Critique guiada de interfaz existente

```text
Role: UX researcher.
Contexto: Revisar `HomeModule` actual.
Objetivo: Identificar problemas de usabilidad y accesibilidad, priorizados por impacto.
Restricciones: No inventar métricas; referenciar heurísticas de Nielsen y WCAG 2.2.
Metodología: Auto-CoT para cada hallazgo, etiquetar confianza (alta/media/baja) para detectar alucinaciones.
Salida: Lista numerada con [Problema, Evidencia, Recomendación, Confianza].
```

### 4. Prompt para artifacts React controlados

```text
Actúa como UI engineer.
Solicito un Artifact React que represente la tarjeta "Resumen de Llamadas".
Contexto: Datos provienen de `CallsService` con fallback a mocks.
Restricciones: No usar APIs experimentales, mantener estado local con hooks básicos.
Instrucciones Artifact: crea primero la estructura base; para modificaciones posteriores usar "update" especificando el bloque a cambiar.
Metodología: Explica cómo validar el artifact con pruebas unitarias antes de integrarlo.
Salida: Artifact React + checklist de test (`npm run test:coverage`).
```

### 5. Evaluación de accesibilidad automatizada

```text
Role: QA a11y.
Contexto: Nuevo banner de datos simulados.
Objetivo: Diseñar plan de validación WCAG 2.2 nivel AA.
Restricciones: Utilizar `jest-axe` o `axe-core` en pipeline CI.
Metodología: Auto-CoT detallando reglas WCAG relevantes, indicar cómo evitar falsos positivos (alucinaciones de herramientas).
Salida: Plan paso a paso con scripts, criterios de aceptación y métricas.
```

## Validación y debugging de prompts

- **Auto-CoT + Self-Consistency**: ejecutar al menos tres rutas de razonamiento y comparar conclusiones; si divergen, consolidar con síntesis crítica.  
- **Listas de verificación anti-alucinación**: confirmar existencia de componentes, librerías y estándares citados; contrastar con documentación interna (`docs/frontend/arquitectura/estrategia_integracion_backend.md`).  
- **Pruebas piloto**: antes de adoptar un prompt en producción, generar ejemplo con datos reales y revisar con equipo UX.  
- **Parámetros de control**: ajustar temperatura baja (≤0.3) para entregables precisos; subir (0.5–0.7) solo para ideación temprana.  
- **Retroalimentación iterativa**: Documentar resultados en ADR o changelog cuando un prompt modifica decisiones arquitectónicas relevantes.

## Riesgos comunes de alucinación en UI design

| Riesgo | Ejemplo | Mitigación |
| --- | --- | --- |
| Componentes inexistentes | "Material UI TablePlus" | Solicitar enlaces oficiales y validar en repositorio de la librería. |
| Métricas ficticias | "Satisfacción NPS 92" sin fuente | Pedir origen de datos y marcar como hipótesis. |
| Pautas obsoletas | Referencias a WCAG 1.0 | Exigir versión y fecha, rechazar si no es ≥2.1. |
| CSS inválido | Propiedades con prefijos inexistentes | Ejecutar lint (`stylelint`) o sandbox CSS. |
| Tokens de diseño inventados | `--brand-gradient-rainbow` sin definición | Verificar contra design tokens oficiales.

## Evaluación continua

1. **Retroalimentación del equipo**: sesiones quincenales para revisar prompts efectivos.  
2. **Métricas**: tiempo de generación de wireframes, número de iteraciones requeridas, bugs detectados por falta de alineación con backend.  
3. **Repositorio de ejemplos**: mantener este documento actualizado, versionado y enlazado desde el índice de arquitectura.  
4. **Integración con TDD**: cada componente derivado de prompts debe venir acompañado de tests unitarios previos, manteniendo cobertura ≥80 %.

## Recursos complementarios

- [Guía de estrategia de integración backend](estrategia_integracion_backend.md) para alinear mocks y resiliencia.  
- [`ui/src/services/createResilientService.js`](../../ui/src/services/createResilientService.js) como referencia de contratos frontend ↔ mocks.  
- ADRs y backlog en `TODO.md` para priorizar la adopción de estos prompts en tareas concretas.  
- Documentación de accesibilidad corporativa y WCAG 2.2 AA.

