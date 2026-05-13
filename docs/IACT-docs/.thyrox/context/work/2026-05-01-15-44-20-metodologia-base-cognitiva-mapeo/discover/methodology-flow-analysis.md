```yml
created_at: 2026-05-01 15:46:00
project: IACT-docs
work_package: 2026-05-01-15-44-20-metodologia-base-cognitiva-mapeo
phase: Phase 1 — DISCOVER
author: NestorMonroy
status: Borrador
version: 1.0.0
```

# Analisis del flujo de metodologia base-cognitiva

Insumos canonicos leidos:

- `source/base-cognitiva/_fundamentos-conceptuales/fnd-05-jerarquia-4-niveles.rst` (jerarquia BR-BReq-UC-FR)
- `source/base-cognitiva/_fundamentos-conceptuales/fnd-04-trazabilidad.rst` (RTM y enlaces)
- `source/base-cognitiva/_fundamentos-conceptuales/fnd-06-derivacion-vs-transformacion.rst` (derivar != transformar)
- `source/base-cognitiva/_taxonomias-y-metamodelos/metamodelos/mtm-02-metamodelo-trazabilidad.rst`

## 1. Niveles de la jerarquia (FND_05)

La metodologia define **4 niveles de requisitos** + 2 niveles operativos = 6 capas totales:

| Nivel | Artefacto | Pregunta que responde | Cantidad IACT (FND_05 §1.3) |
|-------|-----------|------------------------|---------------------------|
| **0** | **BR** Business Rules | ¿Por que esta restriccion? | 20 |
| **1** | **BReq** Business Requirements | ¿Por que este proyecto? | 5 |
| **2** | **UC** Use Cases | ¿Que hace el usuario? | 49 (oficial) / 61 (real, post matriz) |
| **3** | **FR** Functional Requirements | ¿Como lo hace el sistema? | ~400 (estimado: 1 UC : 8 FR) |
| 4 | CODE | implementacion | n/a |
| 5 | TEST | verificacion | n/a |

**Gradiente** (FND_05 §7.2):

```
NIVEL 0 (BR) ── NIVEL 1 (BReq) ── NIVEL 2 (UC) ── NIVEL 3 (FR)

mas abstracto      ───────────────────────>      mas concreto
mas estable        ───────────────────────>      mas cambiante
mayor alcance      ───────────────────────>      menor alcance
menos cantidad     ───────────────────────>      mas cantidad
```

**Ratios canonicos IACT** (FND_05 §7.2):

- BR : BReq = 4 : 1
- BReq : UC = 1 : 10
- UC : FR = 1 : 8

## 2. Tipos de enlaces (FND_04 §2.1, MTM_02 §2)

La trazabilidad NO es lineal — son **7 tipos de enlace** con semantica distinta:

| # | Enlace | Origen | Destino | Cardinalidad | Semantica |
|---|--------|--------|---------|--------------|-----------|
| 1 | influye | BR | BReq | 0..* : 0..* | BR afecta objetivo sin generar directamente |
| 2 | genera | BReq | UC | 1 : 1..* | Objetivo de negocio genera multiples UCs |
| 3 | genera | BR (Trigger) | UC | 0..1 : 0..1 | BR tipo Desencadenador genera 1 UC |
| 4 | deriva | UC | FR | 1 : 1..* | Cada paso "Sistema [verbo]" del UC deriva FR (ratio ~1:8) |
| 5 | implementa | FR | CODE | 1 : 0..* | FR se codifica en modulo/funcion |
| 6 | verifica | TEST | FR | 1..* : 1 | Multiples tests verifican 1 FR |
| 7 | satisface | UC | BReq | many : many | UC cumple parcialmente objetivo |

**Diagrama vertical de derivacion** (FND_04 §2.3, MTM_02 §1.2):

```
   BR  ──influye──> BReq
                     │
                     │ genera
                     ▼
                    UC ◄── genera ──── BR (Trigger)
                     │
                     │ deriva
                     ▼
                    FR
                     │
                     │ implementa
                     ▼
                   CODE
                     │
                     │ (verifica reverso)
                     ▼
                   TEST
```

## 3. Distincion clave: derivar != transformar (FND_06)

La metodologia es categorica: **"los FR ya estan DENTRO del UC, solo no estan suficientemente detallados"**.

| Concepto | Significado |
|----------|-------------|
| **Transformar** (PROHIBIDO conceptualmente) | Convertir algo en otra cosa de naturaleza diferente (Fourier, compilacion) |
| **Derivar** (correcto) | Hacer explicito lo implicito; descubrir, no inventar; mantener esencia, cambiar nivel de detalle |

**Implicacion practica para el WP**:

- Los **52 BReqs huerfanos** referenciados desde UCs NO se inventan — se **derivan hacia atras** (backward derivation): los UCs ya contienen el "por que" de manera implicita; el BReq es la explicitacion de ese por que.
- El backfill es legitimo: hay informacion implicita en cada UC que justifica el BReq; el ejercicio es extraerla.
- Pero hay un caso degenerado: si un UC declara "BReq origen: BRQ-AUTH-002" sin que el UC contenga la informacion que justifique ese BReq, entonces el UC tiene una **referencia muerta** y el BReq tendra que **inventarse** (no derivarse) — eso seria una violacion del principio FND_06.

**Hallazgo H-07**: validar en Phase 3 ANALYZE si los UCs contienen informacion suficiente para derivar los BReqs, o si fueron escritos asumiendo BReqs que nadie escribio.

## 4. Origen del flujo: hacia atras vs hacia adelante

### Flujo canonico (top-down, el ideal):

```
BR existe (politicas, regulaciones)
     │ influye
     ▼
BReq se documenta (objetivo del proyecto)
     │ genera
     ▼
UC se especifica (comportamiento)
     │ deriva
     ▼
FR se atomiza (capacidades)
     │ implementa
     ▼
CODE se escribe
     │ verifica
     ▼
TEST se ejecuta
```

### Flujo IACT real (mixto, observado):

```
ESTADO ACTUAL DEL PROYECTO:

BR     ── existe parcialmente (cajon reglas-negocio/)
BReq   ── 1 archivo / 52 referenciados (gap 98%)
UC     ── 60 monoliticos + 5 splitted en 12 partes (61 totales)
FR     ── existe cajon, cobertura no medida en este WP
CODE   ── fuera de scope
TEST   ── fuera de scope
```

El flujo real fue probablemente:

```
ESCRIBIR UCs ──> referenciar "BRQ origen" sin crear el BReq
                    │
                    └──> 52 referencias muertas
```

El backfill tiene que **reconstruir hacia atras** (UC → BReq) usando la informacion implicita en los UCs (FND_06 dice que es legitimo si la informacion existe).

## 5. Aplicacion practica del flujo en este WP

### Phase 1 DISCOVER (en curso) — flujo de exploracion

```
1. Leer FND/MTM/TXM/SBVR/META             ◄── DESCUBRIR la metodologia
2. Inventariar artefactos existentes        ◄── DESCUBRIR el estado real
3. Cruzar 1 vs 2 (gap analysis)            ◄── IDENTIFICAR el delta
```

### Phase 7 DESIGN — flujo del backfill (forward derivation desde UCs hacia BReqs)

Para cada cluster (AUTH, USR, ACC, RPT, ALR, PIP, AUD, LOG):

```
Para cada UC del cluster:
   1. Leer la seccion "Proposito" del UC
   2. Leer la seccion "Trazabilidad → BReq origen: BRQ-XXX-NNN"
   3. Si BRQ no existe:
      a. Extraer informacion implicita del UC sobre el "por que"
      b. Crear stub BReq con esa informacion
      c. Mapear BR (Nivel 0) que influyen este BReq (si los hay)
   4. Validar bidireccionalidad: BReq.UCs debe contener este UC

Para cada BR existente:
   - Identificar a que BReqs influye (enlaces tipo "influye")
   - Documentar la matriz BR → BReq
```

### Phase 10 EXECUTE — orden topologico de creacion

Dado el grafo de dependencias del metamodelo:

```
Orden recomendado de produccion:

  1. BR (Nivel 0)        ── BASELINE: leer existentes, NO crear nuevos en este WP
  2. BReq (Nivel 1)      ── 52 stubs (CORE de este WP)
  3. UC referencia BReq  ── ya existe, validar links
  4. FR (Nivel 3)        ── FUERA DE SCOPE de este WP (otro WP)
  5. RTM consolidada     ── matriz de trazabilidad publicada
```

## 6. Restricciones que impone la metodologia

Estas constraints van a Phase 4 CONSTRAINTS:

| Constraint | Origen | Impacto en el WP |
|------------|--------|------------------|
| Los BReq son **estrategicos**, no tecnicos | FND_05 §3.2 | El stub debe expresar valor de negocio, no implementacion |
| Los BReq son **medibles** | FND_05 §3.2 | Cada BReq debe tener metrica de exito (incluso si es estimada) |
| Los BReq son **influenciados por BR** | FND_05 §3.3 | Cada BReq debe declarar BRs que lo influyen (si las hay) |
| Cada BReq genera **1..N UCs** | FND_04 §2.1 | Cada BReq debe listar los UCs que realiza |
| FR se **deriva** del UC, no se inventa | FND_06 | Si un UC referencia un BReq, debe haber informacion implicita que lo justifique |

## 7. Hallazgos del analisis del flujo

| ID | Hallazgo | Impacto |
|----|----------|---------|
| H-07 | Verificar que los UCs contienen informacion suficiente para derivar el BReq referenciado | Alto — si no, los BReqs serian invenciones, no derivaciones |
| H-08 | El flujo real fue UC → "fake BReq ID" sin crear el BReq, violando el orden topologico | Documentar como deuda historica |
| H-09 | Los BR (Nivel 0) tambien necesitan inventario — la matriz BR→BReq depende de ello | Phase 2 MEASURE |
| H-10 | El cluster PERM no usa la metodologia (usa PRIORIDAD/RNF/N) — anomalia metodologica grave | Phase 3 ANALYZE — registrar como issue separado |
| H-11 | Cada BReq stub debe declarar metrica de exito (FND_05 §3.5 ejemplifica con porcentajes) | Phase 7 DESIGN — incluir campo en plantilla |
| H-12 | El ejemplo BReq-001 (FND_05 §3.4) usa formato narrativo de 4-5 lineas con metrica explicita ("reduciendo... 40%") — modelo a seguir | Phase 7 DESIGN |

## 8. Decision metodologica de este WP

Adoptamos los **6 niveles + 7 enlaces + 3 cardinalidades** de la metodologia tal como estan documentados. NO modificamos la metodologia en este WP — solo la **aplicamos**.

Si descubrimos en Phase 3 ANALYZE que la metodologia tiene contradicciones internas o vacios, los registraremos como hallazgos para WPs futuros, NO los resolveremos aqui.

## 9. Proximo paso

Phase 1 DISCOVER continua con:

- `discover/methodology-survey.md` — inventario completo de lo que prescribe base-cognitiva (FND × 8, TXM × 3, MTM × 3, SBVR × 5, META × 5).
- `discover/coverage-baseline.md` — inventario de lo que existe hoy en el proyecto (BR, BReq, UC, FR por cluster).

Con esos dos documentos cerramos Phase 1 DISCOVER y avanzamos a Phase 2 MEASURE.
