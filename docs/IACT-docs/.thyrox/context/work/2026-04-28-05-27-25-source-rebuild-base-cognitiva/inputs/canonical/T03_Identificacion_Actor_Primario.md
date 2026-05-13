# TEMPLATE T03: Identificación de Actor Primario

**Versión:** 1.0.0  
**Categoría:** Construcción de UC  
**Fuente:** PARTE 2A, Sección 2.4  
**Uso:** Decidir quién es el actor primario de un UC

---

## ¿CUÁNDO USAR ESTE TEMPLATE?

Usa este template cuando:
- Construyes un UC y necesitas identificar el actor primario
- Hay múltiples candidatos y no está claro quién inicia
- Necesitas justificar tu decisión de actor

---

## LAS 3 PREGUNTAS

```markdown
## IDENTIFICACIÓN DE ACTOR PRIMARIO

**UC:** [Nombre del UC]

### PREGUNTA 1: ¿Quién QUIERE que esto ocurra?

Analizar:
- ¿Quién tiene el objetivo?
- ¿Quién se beneficia de que se ejecute?
- ¿Quién lo solicitó originalmente?

Candidatos:
- [ ] [Actor 1]: [Razón]
- [ ] [Actor 2]: [Razón]
- [ ] Sistema: [Razón]

Respuesta: [El que inicia para lograr SU objetivo]

---

### PREGUNTA 2: ¿CUÁNDO se ejecuta?

- [ ] MANUAL: Actor humano inicia conscientemente
- [ ] AUTOMÁTICO: Sistema inicia sin intervención
- [ ] PROGRAMADO: Sistema inicia en horario/evento
- [ ] REACTIVO: Sistema responde a trigger externo

Respuesta: [Selección]

Si es AUTOMÁTICO/PROGRAMADO → Actor = Sistema/Tiempo

---

### PREGUNTA 3: ¿Quién se BENEFICIA del resultado?

Listar stakeholders con intereses:

- [Stakeholder 1]: [Beneficio específico]
- [Stakeholder 2]: [Beneficio específico]
- [Stakeholder 3]: [Beneficio específico]

El beneficiario principal típicamente es el actor primario
(excepto en UC de servicio donde Sistema es primario)

---

## DECISIÓN FINAL

**Actor Primario:** [Rol seleccionado]

**Justificación en 2-3 oraciones:**
[Explicar por qué este actor y no otro, basado en las 3 preguntas]

**Actores Secundarios:**
- [Actor 1]: [Participa pero no inicia]
- [Actor 2]: [Participa pero no inicia]
```

---

## CASOS ESPECIALES

### Caso 1: Sistema como Actor Primario

El Sistema es actor primario cuando:
- ✅ UC se ejecuta automáticamente (job programado)
- ✅ No requiere intervención humana para iniciar
- ✅ Se ejecuta por trigger temporal o de estado

Ejemplo: UC-IACT-07 (Notificar expiración de sesión)
- Trigger: Cada minuto (automático)
- Actor Primario: Sistema (Scheduler)
- Actor Secundario: Usuario (recibe notificación)

### Caso 2: Múltiples Actores Pueden Iniciar

Si 2+ actores pueden iniciar el MISMO comportamiento con MISMO resultado:

**Opción A:** Un solo UC con múltiples actores primarios
- Usar si flujo es 90%+ idéntico
- Documentar diferencias en pasos específicos

**Opción B:** UC separados por actor
- Usar si flujo diverge significativamente (>30%)
- Mejor mantenibilidad a largo plazo

### Caso 3: Actor vs Rol vs Grouper

En IACT:
- **Actor:** Entidad abstracta (ej: "Administrador")
- **Rol:** NO se usa en IACT (sistema usa Groupers)
- **Grouper:** Implementación concreta (ej: AGR-007 agr_admin_acceso)

Documentar UC con Actor genérico, mapear a Grouper en precondiciones:

```
Actor Primario: Administrador de Acceso
Precondición: Actor tiene grouper AGR-007 (agr_admin_acceso)
```

---

## MATRIZ DE DECISIÓN

| Pregunta | Respuesta | Implica Actor |
|----------|-----------|---------------|
| P1: ¿Quién quiere? | Usuario | Probablemente Usuario |
| P1: ¿Quién quiere? | Nadie específico | Probablemente Sistema |
| P2: ¿Cuándo? | Manual | Humano |
| P2: ¿Cuándo? | Automático | Sistema/Tiempo |
| P3: ¿Quién beneficia? | Mismo que P1 | Confirma P1 |
| P3: ¿Quién beneficia? | Diferente a P1 | Revisar P1 |

---

## EJEMPLOS RESUELTOS

### Ejemplo 1: UC Asignar Funciones

**P1:** ¿Quién quiere?
- Administrador de Acceso (quiere asignar permisos)

**P2:** ¿Cuándo?
- Manual (admin hace clic en botón)

**P3:** ¿Quién beneficia?
- Administrador (cumple su trabajo)
- Usuario destino (recibe funciones)

**Decisión:** Actor Primario = Administrador de Acceso
- Él inicia la acción
- Es manual
- Él tiene el objetivo (gestionar permisos)

---

### Ejemplo 2: UC Notificar Expiración de Sesión

**P1:** ¿Quién quiere?
- Usuario (quiere saber que va a expirar)
- Sistema (quiere mantener sesiones limpias)

**P2:** ¿Cuándo?
- Automático, cada minuto (job programado)

**P3:** ¿Quién beneficia?
- Usuario (no pierde trabajo)
- Administrador (sesiones zombie reducidas)

**Decisión:** Actor Primario = Sistema (Scheduler)
- Aunque usuario beneficia, NO inicia
- Es automático (P2 definitivo)
- Sistema monitorea y ejecuta

---

### Ejemplo 3: UC Consultar Historial (Ambiguo)

**P1:** ¿Quién quiere?
- Admin (ver historial de cualquier usuario)
- Usuario (ver su propio historial)

**P2:** ¿Cuándo?
- Manual (ambos hacen clic)

**P3:** ¿Quién beneficia?
- Ambos por igual

**Decisión:** UN UC con DOBLE actor primario
- Flujo 90% idéntico
- Solo difiere: filtro de user_id
- Documentar como: "Actor Primario: Admin o Usuario"
- Ver Template T08 para múltiples actores

---

## ERRORES COMUNES

❌ **Error 1:** Confundir actor primario con beneficiario
- Incorrecto: "Usuario es primario porque recibe el beneficio"
- Correcto: "Sistema es primario porque INICIA automáticamente"

❌ **Error 2:** Múltiples actores primarios sin justificar
- Documentar por qué el UC no se dividió
- Verificar que flujo es realmente idéntico

❌ **Error 3:** Actor primario sin permisos
- Si actor es humano, verificar que tiene función necesaria
- Documentar en precondiciones

✅ **Corrección:** Aplicar las 3 preguntas siempre, en orden

---

## CHECKLIST DE VALIDACIÓN

Antes de finalizar, verificar:

☐ Actor primario claramente identificado
☐ Las 3 preguntas respondidas
☐ Justificación documentada
☐ Actores secundarios listados (si hay)
☐ Si es Sistema, especificar trigger exacto
☐ Si es humano, verificar permisos en precondiciones
☐ Stakeholders identificados con intereses

---

## REFERENCIAS

- **Documento fuente:** PARTE_2A_FUNDAMENTOS_IACT.md, Sección 2.4
- **Ejemplos completos:**
  - UC-IACT-04: Actor = Admin (manual)
  - UC-IACT-07: Actor = Sistema (automático)
  - UC-IACT-18: Actor = Admin O Usuario (dual)
- **Templates relacionados:**
  - T02: Construcción de UC (7 pasos)
  - T08: UC con Múltiples Actores

---

**Versión:** 1.0.0  
**Última actualización:** 2026-01-08  
**Mantenido por:** Equipo IACT
