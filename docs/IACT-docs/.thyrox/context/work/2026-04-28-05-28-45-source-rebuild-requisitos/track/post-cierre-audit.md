```yml
created_at: 2026-04-29 04:30:00
project: IACT-docs
work_package: 2026-04-28-05-28-45-source-rebuild-requisitos
phase: Phase 11 — TRACK (audit post-cierre, prematuro)
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Audit retrospectivo del WP #6 — problemas detectados post-cierre

## Premisa

Tras pregunta del ejecutor: "¿que paso con primero arreglar MTM_03
(drift critico) en iteracion v3 rapida del WP #1?". Confirmado: el
WP #6 se cerro **prematuramente** sin atender el drift previo del
WP #1, y sin verificar consistencia interna del propio WP #6.

Este audit identifica 5 problemas que requieren remediation antes de
considerar el rebuild de requisitos verdaderamente cerrado.

## Problemas detectados

### P-1 [CRITICO] Drift MTM_03 sigue presente

**Archivo:** `source/base_cognitiva/_taxonomias_y_metamodelos/metamodelos/MTM_03_Metamodelo_RBAC.rst`

**Cita literal (linea ~684):**
> "CATALOGO CERRADO (18 roles)"

**Problema:** declara modelo v4.0 legacy que fue abandonado en v5.0
(la v5.x usa "42 funciones + 10 grupos predefinidos").

**Impacto:** el metamodelo de base_cognitiva contradice el modelo
v5.2.1 vigente. Cualquier consumidor del MTM_03 (futuros WPs,
auditores, lectores nuevos) recibe info incorrecta.

**Severidad:** CRITICA. WP #1 base_cognitiva esta cerrado v2 — debio
arreglarse en una iteracion v3 ANTES de Phase 2 EXECUTE del WP #6.

**Remediation:** v3 del WP #1 base_cognitiva — reescribir la
seccion "CATALOGO CERRADO" del MTM_03 con el modelo v5.2.x.

### P-2 [ALTO] 515 refs CNST legacy en bodies de UCs no actualizadas

**Archivos:** los 49 UCs canonicos de `source/requisitos/casos_uso/`

**Problema:** el script `map_cnst_refs.py` solo actualizo el campo
`:normativa:` en metadata. **Los bodies del UC contienen 515
referencias adicionales** a CNST-001, CNST-005, CNST-008, CNST-009
que NO se mapearon a la nueva numeracion SRP-31.

**Ejemplo (UC_USR_04_Eliminar_Usuario.rst):**

```
- Baja LOGICA, nunca fisica (CNST-005)         ← legacy
- Registro completo en auditoria (CNST-009)    ← legacy
**Restriccion critica CNST-005:**              ← legacy
CNST-005: Baja LOGICA                          ← legacy
```

**Impacto:** lectores ven refs a CNST-005 / CNST-009 con semantica
del modelo v5.x (Baja Logica / UserActionLog), pero el set canonico
SRP-31 tiene CNST_005 = Timeout Sesion 15min y CNST_029 = Audit
Inmutable. Drift semantico.

**Severidad:** ALTA. Aunque build no falla (no son `:doc:` refs,
son texto literal), la documentacion es internamente inconsistente.

**Remediation:** iteracion v2 del WP #6 actual — script que mapee
refs CNST en bodies con criterio contextual (no solo regex).

### P-3 [ALTO] UC_PERM usan "Capacidad" cuando D-RBAC-1 dice "Funcion"

**Archivos:** los 10 UCs en `source/requisitos/casos_uso/permissions/`

**Problema:** los `.md` originales usaban vocabulario PERM
("capacidad"). La conversion a `.rst` preservo ese termino. Pero
D-RBAC-1 establecio que el termino canonico es **"Funcion"** (en
docs espanol) / **"Function"** (en codigo ingles).

**Conteo:** 123 ocurrencias literales de "capacidad" en los 10
UC_PERM.

**Ejemplo (UC_PERM_01_Asignar_Grupo_a_Usuario.rst):**

```
- El administrador tiene la capacidad
  `sistema.administracion.usuarios.asignar_grupos`
```

**Impacto:** vocabulario inconsistente entre UC_PERM y resto del
proyecto. Drift directo de la decision arquitectonica D-RBAC-1.

**Severidad:** ALTA. Contradice decision aprobada del ejecutor.

**Remediation:** iteracion v2 del WP #6 — replace "capacidad" →
"funcion" en bodies de UC_PERM.

### P-4 [MEDIO] Coexistencia ACC ↔ PERM no documentada en los UCs

**Problema:** la decision arquitectonica clave del WP #6 (Hipotesis
1 — coexistencia) NO se refleja en los propios UCs:

- 0 referencias `UC_PERM` en los 49 UCs canonicos
- 0 referencias `UC_ACC` en los 10 UC_PERM

Un lector de UC_ACC_01 (Asignar Funciones — vista funcional) no
sabe que existe UC_PERM_01 (Asignar Grupo — vista tecnica).

**Impacto:** la coexistencia es invisible para el lector de cualquier
UC individual. Solo se ve en `casos_uso/index.rst` y en el
`rbac-formalization.md` (que no esta en source).

**Severidad:** MEDIA. No rompe nada, pero la decision arquitectonica
no es consultable desde el UC.

**Remediation:** agregar seccion "Vista alternativa (coexistencia
ACC ↔ PERM)" al inicio o final de cada UC_ACC_01..04 y UC_PERM_01..10
con `:doc:` referenciando al UC equivalente.

### P-5 [BAJO] No verifique referencias internas entre los 49 UCs

**Problema:** los UCs canonicos del backup probablemente tienen
referencias a otros UCs (e.g., UC_USR_01 puede mencionar
"asignar grupo via UC_ACC_04"). Como no verifique las referencias
intra-UC, hay riesgo de drift no detectado.

**Severidad:** BAJA (probable, no confirmado).

**Remediation:** scan automatizado de refs `UC_<MOD>_<NN>` en bodies
y verificar que apunten a archivos existentes.

## Tabla resumen

| ID | Severidad | Problema | WP afectado | Estado |
|----|-----------|----------|-------------|--------|
| P-1 | CRITICO | Drift MTM_03 (18 roles legacy) | #1 base_cognitiva | NO atendido |
| P-2 | ALTO | 515 refs CNST legacy en bodies | #6 requisitos | NO atendido |
| P-3 | ALTO | 123 "Capacidad" en UC_PERM (deberia "Funcion") | #6 requisitos | NO atendido |
| P-4 | MEDIO | Coexistencia ACC ↔ PERM invisible en UCs | #6 requisitos | NO atendido |
| P-5 | BAJO | Refs UC-UC no verificadas | #6 requisitos | NO escaneado |

## Plan de remediation propuesto

### Opcion A — En cascada (recomendada, segun convencion del proyecto)

1. **Re-abrir WP #1 base_cognitiva v3:** fix P-1 (drift MTM_03).
   Esfuerzo: 30 min (edit 1 archivo, build, commit).
2. **Re-abrir WP #6 requisitos v2:** fix P-2 + P-3 + P-4 + P-5.
   Esfuerzo: 2-3 h (scripts + edits + cross-refs + verify).
3. Cerrar definitivamente.

### Opcion B — Todo en v2 del WP #6

Atender los 5 problemas en una sola iteracion del WP #6 actual,
incluido fix de MTM_03 (P-1) que tecnicamente pertenece a #1.

**Pro:** una sola iteracion. **Contra:** mezcla scopes.

### Opcion C — Solo P-1 + P-3 ahora, resto diferido

Atender solo lo critico (P-1 drift MTM_03) + alto-vocabulario (P-3
Capacidad → Funcion) ahora. Diferir P-2/P-4/P-5 a iteraciones
futuras documentandolos como deuda.

**Pro:** rapido. **Contra:** deuda acumulada.

## Recomendacion

**Opcion A** — preserva separacion de WPs y atiende los problemas
con el scope correcto. WP #1 v3 (rapido) + WP #6 v2 (mas extenso).

## Hallazgo metodologico

Se cerro WP #6 sin haber atendido el drift critico de WP #1 que
estaba documentado en `cross-wp-rbac-audit.md`. Esto sugiere
agregar al protocolo de cierre de WP una verificacion explicita:

> "**Antes de cerrar un WP**, revisar `analyze/cross-wp-*.md` y
> resolver TODOS los hallazgos de severidad CRITICA en los WPs
> dependientes antes de Phase 11 TRACK."

Documentar este hallazgo en una iteracion futura del THYROX skill
o en una guideline del proyecto.
