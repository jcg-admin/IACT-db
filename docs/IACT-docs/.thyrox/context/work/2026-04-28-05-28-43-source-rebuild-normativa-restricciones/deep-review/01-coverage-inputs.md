```yml
created_at: 2026-04-28 06:10:00
project: IACT-docs
work_package: 2026-04-28-05-28-43-source-rebuild-normativa-restricciones
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Aprobado
version: 1.0.0
```

# Deep-review — Cobertura de inputs vs rebuild

Compara backup canonico, temp-holding FASE 02 (8 CNST), doc maestro
`RESTRICCIONES_COMPLETAS_DEL_SISTEMA_IACT.md`, propuesta FASE 01 de
actualizacion del arbol y v2.0.0 standalone contra `source/normativa/
restricciones/` (11 CNST + index).

## Cobertura buena

1. **Set canonico al 100%** — `diff -rq` confirma CNST_001..CNST_010 del
   backup en rebuild; cambios acotados a metadata (bloque `.. meta::`
   agregado, frontmatter legacy `:ID:/:Version:` removido).
2. **Renumeracion 012 -> 011 ejecutada** — CNST_012 solo en backup;
   CNST_011_RBAC en rebuild con etiqueta y referencias internas
   re-cableadas (5 hits grep `CNST-011`).
3. **D-CNST-3 honrada** — `CNST_05_Restriccion_Creacion_Iterativa_2_0_0`
   ausente del rebuild (procedimiento, no restriccion del sistema).
4. **Doc maestro cat 1-4, 6-7, 9-10 mapeadas** — discover lineas 27-38
   verifica destino CNST para cada subcategoria tecnica.
5. **Index por dominio (D-CNST-5)** — `index.rst:44-86` agrupa 11 CNST
   en 6 dominios sin subdirectorios; numeracion flat sin gaps (linea 91).

## Gaps detectados

### G-1 — Cat 5 "Funcionales SRS" sin destino [BAJA]
5.1/5.3/5.4/5.5 (alertas: 50 destinatarios, consolidar repetitivas) sin
CNST. Aceptable — son FRQ, no restricciones; redireccion a `requisitos/`
no declarada en D-CNST.

### G-2 — Cat 8 "Coding Standards / Git CI" sin CNST ni decision [MEDIA]
8.1 (PEP8, type hints) y 8.2 (gitflow, CI gates) sin destino. CNST_006
cubre antipatrones de arquitectura, no estilo. **Contradice D-CNST-2**
("ninguna huerfana"): dominio entero sin destino ni redireccion
documentada a `procedimientos/STD_*`.

### G-3 — Cat 11 "Checklist Cumplimiento" no migrado [BAJA]
Checklist pre/post-deploy no incorporado. Operacional, descarte
aceptable, sin anotacion explicita.

### G-4 — Cat 12 "Glosario" no migrado [BAJA]
Terminos (DRF Secure Code, SoD, RBAC) inline por CNST. Perdida menor.

### G-5 — Temp-holding CNST_004 (Alertas Buzon, 1210 lineas) subsumida parcialmente [MEDIA]
D-CNST-2 la subsume en CNST_001. Conceptual SI (prohibicion email,
InternalMessage, UC-036..040); detalle operacional (limite 50,
consolidacion) no trazado linea-a-linea.

### G-6 — Temp-holding CNST_006 (Reportes Rango) subsumida sin auditoria [BAJA]
D-CNST-2 la subsume en CNST_007. Rangos simples/complejos cubiertos;
detalles adicionales (1035 lineas) no validados.

### G-7 — Bump 1.0.x -> 1.1.0 sin justificacion vs propuesta FASE 01 [MEDIA]
Discover linea 100 declara la propuesta "no aplicable", pero el rebuild
bumpeo metadata a `version: 1.1.0` (CNST_001 lineas 1-12). Inconsistencia
entre decision y accion — falta justificar o revertir.

### G-8 — SOLID (Cat 3.3) sin enunciado individual [BAJA]
CNST_006 cubre antipatrones; los 5 principios SOLID como restricciones
individuales no confirmados a grep.

## Recomendacion final

**Avanzar al gate** con dos cierres:

1. **G-2** — anotar en discover que cat 8 queda fuera del cajon
   (pertenece a `procedimientos/STD_*`); cierra contradiccion D-CNST-2.
2. **G-7** — justificar bump 1.0.x -> 1.1.0 o revertir.

G-1/G-3/G-4/G-6/G-8 aceptables (marginales o fuera de alcance). G-5
amerita verificacion futura pero no bloquea. Ningun gap ALTA. **Veredicto:**
rebuild fiel al backup y a D-CNST. Cierre WP recomendado tras G-2 y G-7.
