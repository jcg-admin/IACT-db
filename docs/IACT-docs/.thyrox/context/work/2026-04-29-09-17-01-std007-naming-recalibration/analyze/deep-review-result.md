```yml
created_at: 2026-04-29 09:17:01
project: IACT-docs
work_package: 2026-04-29-09-17-01-std007-naming-recalibration
phase: Phase 3 — ANALYZE
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Deep-Review — Propuesta unificacion naming snake+PascalCase

Output verbatim del agente `deep-dive` invocado contra la
propuesta del ejecutor.

## Tabla resumen

| # | Pregunta | Veredicto | Resumen |
|---|----------|-----------|---------|
| 1 | ¿Contradiccion §3.3 vs §4.2 es real? | **FALSE** | §3.3 enuncia regla general + lista permisos estructurales; §4.2 especializa. No hay contradiccion logica, hay redaccion ambigua. |
| 2 | ¿snake+PascalCase es mejor que kebab para Sphinx? | **FALSE** | Kebab es la convencion dominante del ecosistema Sphinx/RTD/mkdocs. snake+Pascal degrada URLs y portabilidad cross-OS. |
| 3 | ¿La unificacion agrega valor real? | **FALSE** | El corpus cumple 4 reglas estables. Costo 125 renames + 343 refs vs problema=0 incidentes documentados. Ceremonia. |
| 4 | ¿Hay alternativa menos invasiva? | **TRUE** | Re-redactar §3.3 para redirigir explicitamente a §4.2 resuelve el defecto sin tocar archivos. |
| 5 | ¿Es analogo a I-017 (realismo performativo)? | **TRUE** | Deteccion correcta de defecto + solucion desproporcionada = mismo patron. |

## Detalle por pregunta

### 1. Contradiccion §3.3 vs §4.2 — FALSE

§3.3 prohibe la mezcla DENTRO de un mismo nombre y enumera
kebab puro como caso permitido — es un **enunciado de
coexistencia**, no una regla general que §4.2 contradiga. La
estructura es: "regla universal (no mezclar) + enumeracion de
los dialectos validos (snake+Pascal, kebab puro, mixed FR,
kebab guias)". §4.2 es la **especializacion** de uno de esos
dialectos.

Lo que SI existe: redaccion ambigua. El lector puede
interpretar §3.3 como "kebab puro es opcion generica" cuando
en realidad esta reservado a las categorias de §4.2.

**Patron detectado:** inflacion de severidad — escalar un
defecto editorial a defecto arquitectonico para justificar
una intervencion mayor.

### 2. snake+PascalCase mejor para Sphinx — FALSE

Convenciones del ecosistema (verificable):
- Sphinx oficial (docs.sphinx-doc.org): kebab-case y
  lowercase en todos los archivos de su propio repo.
- ReadTheDocs docs: kebab-case dominante.
- mkdocs, Material for MkDocs, Hugo, Jekyll: kebab-case.
- GitHub Pages: URLs kebab por defecto en Jekyll.

URL slugs RST→HTML: `Descripcion_Larga_Con_Muchas_Palabras.html`
es menos legible y mas propenso a errores de tipeo que
`descripcion-larga-con-muchas-palabras.html`.

Case sensitivity: macOS HFS+ default = case-insensitive,
Windows NTFS = case-insensitive. PascalCase introduce riesgo
de colisiones invisibles (`Descripcion.rst` vs `descripcion.rst`
indistinguibles en macOS/Windows, distintos en Linux CI).
Kebab-lowercase elimina el riesgo.

snake+Pascal es convencion de identifiers de codigo (Python
classes), NO de filenames de documentacion.

### 3. Valor real de la unificacion — FALSE (ceremonia)

342 archivos cumplen sus reglas respectivas (89.7% del
corpus tipado). Cero incidentes citados de confusion, links
rotos por naming, o errores de contributors atribuibles a
la heterogeneidad.

Lo que el rename SI rompe:
- Historial git (los renames degradan `git log --follow`).
- URLs publicas si el sitio esta publicado (linkrot externo).
- ~343 referencias internas que pueden quedar mal auditadas.
- Memoria muscular de contributors actuales.

### 4. Alternativa menos invasiva — TRUE

Edit quirurgico de STD_007 v1.0.0 → v1.1.0:

§3.3 reescrito:
> NO mezclar `-` y `_` dentro de un mismo dialecto. Los
> dialectos permitidos estan enumerados taxativamente en
> §4.1–§4.5. Kebab-case solo aplica a las categorias de §4.2
> (ADR/PROCED/PROC/RNF) y §4.4 (guias generales). Para
> cualquier otra categoria, el dialecto por defecto es
> snake+PascalCase (§4.1).

Costo: 1 archivo editado, 0 renames, 0 referencias rotas, 0
toctrees tocados.

### 5. Analogo a I-017 — TRUE

| Componente I-017 | Instancia en propuesta naming |
|---|---|
| Defecto real detectado | §3.3 redaccion ambigua (real) |
| Inflacion de severidad | "ambiguedad" → "contradiccion" → "unificacion total" |
| Solucion desproporcionada | rename de 125 archivos + 343 refs por 1 parrafo ambiguo |
| Justificacion performativa | "consistencia del corpus" sin metrica de daño actual |
| Ausencia de observable de costo evitado | cero incidentes documentados |
| Etiqueta como licencia de confianza | "STD_007 unificado" suena mas riguroso que "STD_007 con 4 dialectos" |

## Conclusion final del deep-dive

**La propuesta es OVER-ENGINEERING.** Detecta un defecto real
(§3.3 ambigua) pero responde con una intervencion cuya
magnitud excede el defecto en ~2 ordenes de magnitud (1
parrafo a editar vs 125 archivos + 343 refs).

## Recomendacion operativa

1. **NO ejecutar** los 125 renames.
2. **SI editar** STD_007 §3.3 con redaccion explicita de
   redireccion a §4.2/§4.4.
3. Bump STD_007 a v1.1.0 (MINOR — clarifica sin contradecir).
4. Registrar el analisis como ADR
   `adr-naming-conventions-heterogeneity-accepted.md` en
   `.thyrox/context/decisions/` documentando: defecto
   detectado, alternativa descartada (rename masivo),
   alternativa elegida (redaccion), evidencia de ecosistema
   (Sphinx/RTD usan kebab).
5. Patron a nombrar en el ADR: **inflacion de severidad
   editorial a arquitectonica** — sub-instancia de realismo
   performativo metodologico (I-017).

## Estado de aprobacion

Pendiente del ejecutor. Si aprueba la recomendacion: ejecutar
A1+A2 (edit §3.3 + ADR). Si quiere insistir en rename
masivo: ejecutar el plan original con plena conciencia de
los riesgos catalogados aqui.
