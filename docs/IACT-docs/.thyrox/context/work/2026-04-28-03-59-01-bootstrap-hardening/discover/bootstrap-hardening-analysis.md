```yml
created_at: 2026-04-28 03:59:01
project: IACT-docs
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Phase 1 DISCOVER — Bootstrap Hardening

## 1. Problema observado (verificado en sesión anterior)

En la sesión `source-rebuild-strategy` (2026-04-28 02:00–03:55), al
intentar verificar la premisa "source/ tiene 0 warnings/errores":

1. `sphinx-build` no estaba en `PATH` (verificado: `which sphinx-build`
   sin output).
2. Se reaccionó instalando paquetes Python directamente con `pip3`
   en system Python, salteando el flujo oficial.
3. Al primer build se obtuvieron **183 warnings — todas plantuml-related**
   (`plantuml.jar no encontrado en /home/user/IACT-docs/tools/plantuml.jar`).
4. La pista estaba en el mensaje del error: "Ejecutar: bash
   scripts/setup.sh". Una vez ejecutado: `tools/plantuml.jar`
   descargado, JRE confirmado, `uv sync` ejecutado, hooks activados.
5. Re-build: **0 warnings, 0 errors**. Premisa verificada.

**Tiempo perdido por bootstrap implícito:** ~30 minutos de
investigación que no hubiera ocurrido si el flujo `setup.sh primero`
estuviera señalizado en un lugar visible.

## 2. Inventario del estado actual

| Archivo | Contiene flujo de bootstrap | Visibilidad |
|---------|-----------------------------|-------------|
| `scripts/setup.sh` | SÍ — script completo, idempotente, 6 pasos | Solo si el dev lo encuentra |
| `Makefile` (preámbulo) | Menciona `uv sync` y `source .venv/bin/activate` | Solo si el dev lee comentarios |
| `readme.rst` | NO — describe el producto IACT, no el repo | N/A |
| `CONTRIBUTING.md` | No existe | N/A |
| Workflow CI | No conocido | Pendiente verificar |

**Conclusión:** el bootstrap funcional EXISTE y es bueno. El problema
es 100% de **señalización y exigibilidad**, no de implementación.

## 3. Hallazgos

### F-01: `readme.rst` no menciona desarrollo

`readme.rst` describe el producto IACT (call center analytics) para
usuarios finales. Un dev que clona el repo no encuentra una sección
"cómo construir las docs". Es la primera puerta de entrada y está
vacía respecto al flujo de desarrollo.

### F-02: `Makefile` no falla rápido si falta el bootstrap

`make html` invoca `sphinx-build` directamente. Si plantuml.jar no
existe, el build no falla — produce 183 warnings y un sitio HTML
incompleto (los diagramas faltan). Un usuario nuevo puede creer que
"todo funciona" cuando en realidad la docs está rota.

**Mejor comportamiento:** target `html` verifica pre-condiciones
(plantuml.jar, enchant, .venv) y aborta con mensaje accionable
("ejecutá `bash scripts/setup.sh`") si faltan.

### F-03: No hay CI que valide el bootstrap end-to-end

Sin verificar (acción de DISCOVER pendiente), pero a inspección
inicial no parece haber un workflow CI que parta de clone limpio →
setup.sh → make html. Esto significa que un cambio que rompa el
bootstrap puede mergearse sin que nadie lo note hasta que un dev
intente clonar.

### F-04: `setup.sh` instala libsystem (`enchant`) con `apt`/`brew`

El script asume permisos para `apt install` o `brew install`. Para
un dev sin sudo, esto puede fallar. No es un bug — es una restricción
real del proyecto. Decisión a tomar: documentarlo como pre-requisito
o proveer una alternativa (ej. soft-disable de spellcheck si enchant
no está).

### F-05: Hook `pre-push` puede advertir, no bloquear

El git hook `pre-push` (ya activo) podría comprobar que plantuml.jar
y .venv existen y advertir antes de hacer push. No bloquear (el dev
puede estar haciendo cambios que no requieren build), solo advertir.

## 4. Decisiones a tomar (a resolver en strategy o plan)

### D1: ¿`CONTRIBUTING.md` separado o sección en `readme.rst`?

- Opción A: sección "First time setup" al inicio de `readme.rst`.
  Pro: una sola puerta de entrada. Con: mezcla docs de producto con
  docs de desarrollo.
- Opción B: `CONTRIBUTING.md` separado, link prominente desde
  `readme.rst`. Pro: separation of concerns. Con: dos archivos a
  mantener sincronizados.

### D2: ¿Guard en Makefile abort o warn?

- Abort (exit 1) — fail fast, dev tiene que correr setup.sh.
- Warn — build continúa, dev ve warnings de bootstrap pero sigue.

### D3: ¿CI bootstrap completo o smoke test?

- Completo: clone → setup.sh → make html → exit 0.
- Smoke: solo verificar que setup.sh sale OK; no construir docs.

### D4: ¿Soft-disable de spellcheck si enchant no está?

- Sí: el dev puede usar el repo sin enchant para iteración rápida.
- No: enchant es requerido siempre, falta = bootstrap roto.

## 5. Tamaño estimado del WP

**Pequeño-mediano.** Cambios concretos esperados:
- 1 sección nueva o archivo nuevo (readme.rst o CONTRIBUTING.md)
- 1 modificación al Makefile (~10 líneas)
- 1 workflow CI nuevo (~30 líneas YAML)
- Opcional: 1 modificación al pre-push hook

No requiere cambios al código de Sphinx ni a `source/`.

## 6. Pre-condiciones

- WP `source-rebuild-strategy` debe estar en estado estable (Phase 1
  DISCOVER aprobada — ya cumple).
- No requiere completar el rebuild de `source/`.

## 7. Próximo paso

Decisión del ejecutor:

- (A) Avanzar este WP a Phase 5 STRATEGY — investigar las opciones
  D1-D4 y decidir.
- (B) Pausar este WP. Mantenerlo registrado y volver cuando el WP
  padre (`source-rebuild-strategy`) avance más, para no fragmentar
  el foco.
