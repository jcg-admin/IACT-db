```yml
type: Referencia PHASE 1: ANALYZE
category: Casos de Uso
version: 1.0
purpose: Documentar casos de uso y flujos principales del sistema
goal: Proporcionar visión clara de interacciones usuario-sistema
updated_at: 2026-03-25
owner: workflow-discover
```

# Casos de Uso

## Propósito

Documentación de los casos de uso principales del proyecto. Define los flujos y escenarios donde los usuarios interactúan con el sistema.

> Objetivo: Capturar los comportamientos esperados del sistema desde la perspectiva del usuario.

---

## Estructura de Caso de Uso

Cada caso de uso debe incluir:

**ID:** UC-NNN (ej: UC-001)<br>
**Nombre:** [Descripción clara de la acción]<br>
**Actor Primario:** [Quién inicia el caso de uso]<br>
**Precondiciones:** [Estado requerido antes de ejecutar]<br>
**Flujo Principal:** [Pasos numerados]<br>
**Flujos Alternativos:** [Variaciones del flujo principal]<br>
**Postcondiciones:** [Estado después de completar]<br>
**Notas:** [Información adicional]

---

## Formato de Flujo

### Flujo Principal

```
1. [Actor] realiza [acción]
2. [Sistema] responde con [resultado]
3. [Actor] [siguiente acción]
4. [Sistema] [reacción]
...
```

### Flujos Alternativos

```
Alternativa 2a: Si [condición]
  2a.1. [Actor/Sistema] [acción alternativa]
  2a.2. [Continúa en paso X del flujo principal]
```

---

## Ejemplo: Caso de Uso Simple

**UC-001: Crear Proyecto**

**Actor Primario:** User<br>
**Precondiciones:** Usuario autenticado, en página de inicio<br>

**Flujo Principal:**
```
1. Usuario selecciona "Crear Nuevo Proyecto"
2. Sistema muestra formulario con campos: nombre, descripción, stack
3. Usuario completa formulario y hace click en "Crear"
4. Sistema valida datos
5. Sistema crea proyecto y muestra confirmación
6. Sistema redirige a página de configuración del proyecto
```

**Flujo Alternativo 4a: Validación fallida**
```
4a.1. Sistema encuentra errores en los datos
4a.2. Sistema muestra mensajes de error
4a.3. Usuario corrige datos
4a.4. Continúa en paso 3 del flujo principal
```

**Postcondiciones:** Proyecto creado y visible en dashboard<br>
**Notas:** El proyecto inicia en estado "Borrador"

---

## Relación con PHASE 1: ANALYZE

Los casos de uso son parte crítica del ANALYZE porque:

+**Capturan requisitos funcionales:** Qué debe hacer el sistema
+**Desde perspectiva del usuario:** No desde la técnica
+**Trazabilidad:** Cada requisito puede vincularse a un caso de uso
+**Validación:** Los casos de uso se usan para aceptación
+**Comunicación:** Claros para stakeholders

---

## Relación con Otros Documentos

- **requirements-analysis.md:** Los casos de uso detallan cómo se satisfacen los requisitos
- **quality-goals.md:** Los casos de uso deben cumplir los objetivos de calidad
- **stakeholders.md:** Cada actor en un caso de uso corresponde a un stakeholder

---

## Reglas de Nombrado

+IDs: UC-001, UC-002, etc. (sin prefijos adicionales)<br>
+Nombres: Verbo + Objeto (ej: "Crear Proyecto", "Editar Configuración")<br>
+Actores: Roles, no nombres específicos (User, Admin, System)<br>
+Pasos: Acción clara, sujeto explícito

---

---

## Próximo Paso

Una vez completado: → Pasar a [quality-goals](./quality-goals.md)

---

**Última Actualización:** 2026-03-27
