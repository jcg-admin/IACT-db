```yml
created_at: 2026-04-28 07:30:00
project: IACT-docs
work_package: 2026-04-28-05-28-41-source-rebuild-normativa-estandares
phase: Phase 11 — TRACK (artefacto deep-review)
agent_id: a24e303723c3877d1
invocation_bound: 5 artefactos · 6 ejes · ≤8 gaps · ≤500 palabras
author: deep-review agent (invocado por orquestador)
status: Aprobado
version: 1.0.0
```

# Deep-Review 01 — Cobertura de Inputs WP #2

Output verbatim del agente `deep-review` invocado para verificar
que todo el material relevante de temp-backup y temp-holding fue
considerado/incorporado en el WP.

## Cobertura buena

- **Templates v1.3.0 set curado**: 12 incorporados al 100%
  (TPL_BR_Decision_Tipo, 3×FR, TRZ_Matriz_RTM, 7×UC).
- **Backup canónico**: 16/18 templates renombrados e incorporados;
  2 descartes justificados (TPL_002_Plantilla_UC_v2,
  TPL_RTM_Trazabilidad por fusión con TPL_TRZ).
- **STDs heredados**: STD_006, STD_007, STD_001 (v2.0.0
  Sin_Emojis canónico), STD_Naming_Identificadores,
  STD_Profesional_Documentacion presentes.
- **NOM_001 → STD_002**: renombrado correctamente con
  justificación documentada (F-NE-5/D-NE-1).
- **Guías auxiliares**: GUIA_ESTILO, estandares_codigo,
  shell_scripting_guide presentes en source.
- **Total**: 39 archivos en source/normativa/estandares/ —
  coincide con §5 del discover.

## Gaps detectados

### Gap 1 — STD_007 §4.1 lista 11 prefijos; faltan templates [MEDIA]

Discover §2.5 cita catálogo: UC, BR, BReq, CNST, **META**,
**FND**, **SBVR**, **MTM**, **TXM**, **GOB**, STD, TPL. Source
tiene templates para UC, BR, BReq, CNST, STD; **NO hay TPL_META,
TPL_FND, TPL_SBVR, TPL_MTM, TPL_TXM, TPL_GOB**. Discover no
aborda esta brecha — la lista no fue cruzada contra el inventario
final. Impacto: WP #6 y dominios técnicos no tienen molde para
artefactos META/FND/SBVR/MTM/TXM/GOB.

### Gap 2 — Renombrado de guías auxiliares no aplicado [BAJA]

Discover §4.1 instruye renombrar:

- ``GUIA_ESTILO.rst`` → ``guia-estilo.rst``
- ``estandares_codigo.rst`` → ``estandares-codigo.rst``
- ``shell_scripting_guide.rst`` → ``shell-scripting-guide.rst``

(kebab-case por STD_007 §4.4). Source mantiene los nombres legacy.
Decisión documentada vs ejecución divergen.

### Gap 3 — Numeración STD_003/004/005 sin resolver [MEDIA]

F-NE-4 dice "investigar si STD_002..STD_005 existen". Solo se
resolvió STD_002 (← NOM_001). En temp-holding no aparecen
STD_003/004/005. Discover §5 dice "1 reservado" pero hay 3 huecos
numerados (003-005) sin política documentada (¿reserva? ¿renumerar
STD_006/007?).

### Gap 4 — README.txt del set curado v1.3.0 no incorporado ni descartado [BAJA]

``temp-holding/.../iact_templates_v1_3_0/README.txt`` mencionado en
discover §2.2 (13 archivos = 12 templates + README) — no aparece
decisión sobre incorporarlo o descartarlo. No está en source.

### Gap 5 — Análisis previos del ejecutor: lectura no evidenciada [MEDIA]

Discover §2.4 enumera los 5 inputs obligatorios pero solo hay una
frase agregada ("estos análisis confirman que los templates v1.3.0
son la versión curada"). No hay extracción de hallazgos por
documento ni evidencia de que las 10 PROPUESTA_TEMPLATE_*.txt
aporten o no tipos nuevos. Riesgo de pérdida silenciosa de input.

### Gap 6 — Solapamiento STD_002 vs STD_Naming_Identificadores [MEDIA]

Ambos tratan nomenclatura de identificadores. Discover §2.5 los
justifica como complementarios. NO hay tabla explícita de límites
— inevitable colisión cuando WP #6 los aplique. Pendiente: matriz
de scope cruzado.

### Gap 7 — TPL v1.4.0 existe en temp-holding, se usó v1.3.0 [BAJA]

``GENERACION_DOCUMENTACION/FASE 13/TPL_BR_Decision_Tipo_1_4_0.rst``
y ``TPL_UC_Construccion_7_Pasos_1_4_0.rst`` existen. Discover §2.2
declaró v1.3.0 como "más reciente" sin verificar FASE 13. Falta
nota explícita "v1.4.0 descartado por X".

### Gap 8 — STD_001: 6 ubicaciones distintas; diff no auditado [BAJA]

Discover §2.3 lista las 6 versiones y elige v2.0.0 Sin_Emojis. No
hay verificación de que las versiones 1.1.0 en otras ubicaciones
sean idénticas — podría haber addenda perdido al elegir solo el
Sin_Emojis.

## Recomendaciones

1. Agregar sub-análisis con matriz "11 prefijos STD_007 §4.1 ×
   templates en source" — cerrar Gap 1.
2. Aplicar renombrado a kebab-case de las 3 guías (Gap 2).
3. Documentar política de numeración STD (Gap 3).
4. Crear apartado "Inputs leídos" en discover (Gap 5).
5. Tabla de límites STD_002 vs STD_Naming_Identificadores (Gap 6).
6. Notas defensivas sobre v1.4.0 descartado (Gap 7) y diff de
   STD_001 (Gap 8).
7. Decisión sobre README.txt (Gap 4).

**Recomendación final del agente:** WP #2 está **operativamente
cerrado** (build verde) pero quedan **2 gaps medios accionables
sin esfuerzo grande** (Gap 1 catalog coverage, Gap 5 input
traceability) que conviene resolver con un addendum a
``discover/normativa-estandares-analysis.md`` antes de declarar el
WP definitivamente sellado.
