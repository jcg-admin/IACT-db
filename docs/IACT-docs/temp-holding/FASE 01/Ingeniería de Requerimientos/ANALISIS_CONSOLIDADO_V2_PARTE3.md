# ANÁLISIS CONSOLIDADO V2.0 - PARTE 3

(Continuación de ANALISIS_CONSOLIDADO_V2_PARTE2.md)

---

# PARTE III: METODOLOGÍAS

## 13. PROCESO END-TO-END

### 13.1. Flujo Integrado Completo

**Síntesis de los 3 documentos en proceso unificado**:

```
╔══════════════════════════════════════════════════════════════╗
║ FASE 1: ANÁLISIS DE REQUISITOS (Doc 3 - BR→Sistema)          ║
╠══════════════════════════════════════════════════════════════╣
║                                                               ║
║ ENTRADA:                                                      ║
║ • Stakeholders                                                ║
║ • Documentación del negocio                                   ║
║ • Regulaciones                                                ║
║ • Políticas corporativas                                      ║
║                                                               ║
║ ACTIVIDADES:                                                  ║
║ ┌─────────────────────────────────────────────────────┐      ║
║ │ 1.1. Elicitar Business Rules                        │      ║
║ │      - 6 preguntas estratégicas                     │      ║
║ │      - Entrevistas con expertos del dominio         │      ║
║ │      - Revisión de documentación                    │      ║
║ │      Output: ~45 BR identificadas                   │      ║
║ │                                                      │      ║
║ │ 1.2. Clasificar BR en 5 tipos                       │      ║
║ │      - Hechos                                        │      ║
║ │      - Restricciones                                 │      ║
║ │      - Desencadenadores ⭐                           │      ║
║ │      - Inferencias                                   │      ║
║ │      - Cálculos                                      │      ║
║ │      Output: Taxonomía completa                     │      ║
║ │                                                      │      ║
║ │ 1.3. Documentar BR con plantilla estándar           │      ║
║ │      - Definición                                    │      ║
║ │      - Tipo                                          │      ║
║ │      - Fuente                                        │      ║
║ │      - Razón                                         │      ║
║ │      - Fecha vigencia                                │      ║
║ │      - Estática (Sí/No)                              │      ║
║ │      Output: Catálogo de BR                         │      ║
║ └─────────────────────────────────────────────────────┘      ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────┐      ║
║ │ 1.4. Transformar BR → UC (PARTE 2)                  │      ║
║ │      - Aplicar 5 patrones de transformación          │      ║
║ │      - Desencadenadores → UC completos               │      ║
║ │      - Restricciones → Precondiciones                │      ║
║ │      - Cálculos → Pasos en flujos                    │      ║
║ │      Output: ~10 UC derivados de BR (22%)           │      ║
║ └─────────────────────────────────────────────────────┘      ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────┐      ║
║ │ 1.5. Identificar UC adicionales (PARTE 3)           │      ║
║ │      Técnica 1 - CRUD (40%):                        │      ║
║ │        - Listar entidades del modelo                │      ║
║ │        - Clasificar (Maestro/Transaccional/Técnica) │      ║
║ │        - Aplicar reglas de decisión                 │      ║
║ │        Output: ~18 UC                               │      ║
║ │                                                      │      ║
║ │      Técnica 2 - Larman (36%):                      │      ║
║ │        - 2.1. Eventos del sistema                   │      ║
║ │        - 2.2. Operaciones del sistema               │      ║
║ │        - 2.3. Responsabilidades del sistema         │      ║
║ │        Output: ~16 UC                               │      ║
║ │                                                      │      ║
║ │      Técnica 3 - UI-Driven (9%):                    │      ║
║ │        - Crear mockups                              │      ║
║ │        - Identificar interacciones significativas   │      ║
║ │        Output: ~4 UC                                │      ║
║ │                                                      │      ║
║ │      Técnica 4 - Stakeholders (9%):                 │      ║
║ │        - Entrevistas directas                       │      ║
║ │        - Necesidades específicas                    │      ║
║ │        Output: ~4 UC                                │      ║
║ │                                                      │      ║
║ │      CONSOLIDACIÓN:                                 │      ║
║ │        - Eliminar duplicados                        │      ║
║ │        - Fusionar similares                         │      ║
║ │        - 52 UC brutos → 45 UC consolidados          │      ║
║ └─────────────────────────────────────────────────────┘      ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────┐      ║
║ │ 1.6. Derivar Functional Requirements                │      ║
║ │      - Descomponer pasos de UC en RF                │      ║
║ │      - 1 paso UC → 1-7 RF típicamente               │      ║
║ │      - Especificación detallada implementable       │      ║
║ │      Output: ~200 RF                                │      ║
║ └─────────────────────────────────────────────────────┘      ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────┐      ║
║ │ 1.7. Establecer trazabilidad                        │      ║
║ │      - Matriz BR → UC → RF                          │      ║
║ │      - Forward y backward                           │      ║
║ │      Output: Matriz completa                        │      ║
║ └─────────────────────────────────────────────────────┘      ║
║                                                               ║
║ SALIDA:                                                       ║
║ • SRS (Software Requirements Specification) completo         ║
║ • Catálogo de 45 BR                                           ║
║ • 45 UC completos                                             ║
║ • 200 RF detallados                                           ║
║ • Matriz de trazabilidad                                      ║
║ • Modelo de dominio inicial                                   ║
║                                                               ║
║ DURACIÓN: 7-8 semanas                                         ║
╚══════════════════════════════════════════════════════════════╝
                           ↓
╔══════════════════════════════════════════════════════════════╗
║ FASE 2: MODELADO CONCEPTUAL (Doc 1 - MDA/MDE)                ║
╠══════════════════════════════════════════════════════════════╣
║                                                               ║
║ ENTRADA:                                                      ║
║ • SRS de FASE 1                                               ║
║ • Modelo de dominio inicial                                   ║
║                                                               ║
║ ACTIVIDADES:                                                  ║
║ ┌─────────────────────────────────────────────────────┐      ║
║ │ 2.1. Definir/Seleccionar Metamodelo del Dominio     │      ║
║ │      Opciones:                                       │      ║
║ │      a) Usar estándar existente (UML, BPMN)         │      ║
║ │      b) Adaptar metamodelo (Perfil UML)             │      ║
║ │      c) Crear DSL desde cero (ej. CRIO)             │      ║
║ │                                                      │      ║
║ │      Pasos para crear DSL:                          │      ║
║ │      1. Identificar conceptos del dominio           │      ║
║ │      2. Definir sintaxis abstracta (metamodelo)     │      ║
║ │      3. Definir sintaxis concreta (notación)        │      ║
║ │      4. Definir semántica                           │      ║
║ │                                                      │      ║
║ │      Herramienta: EMF (Eclipse Modeling Framework)  │      ║
║ │      Output: Metamodelo en Ecore                    │      ║
║ └─────────────────────────────────────────────────────┘      ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────┐      ║
║ │ 2.2. Crear Modelo PIM desde Requisitos              │      ║
║ │      - Mapear RF → Elementos del modelo             │      ║
║ │      - Crear diagrama conceptual                    │      ║
║ │      - Modelo independiente de plataforma           │      ║
║ │      - Usar editor gráfico (GMF) o textual (Xtext)  │      ║
║ │      Output: Modelo PIM conforme a metamodelo       │      ║
║ └─────────────────────────────────────────────────────┘      ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────┐      ║
║ │ 2.3. Especificar Restricciones (OCL/EVL)            │      ║
║ │      - Traducir BR → Restricciones formales         │      ║
║ │      - Invariantes de clase                         │      ║
║ │      - Pre/postcondiciones de operaciones           │      ║
║ │      - Restricciones de integridad                  │      ║
║ │      Output: Restricciones OCL/EVL                  │      ║
║ └─────────────────────────────────────────────────────┘      ║
║                                                               ║
║ SALIDA:                                                       ║
║ • Metamodelo del dominio (Ecore)                              ║
║ • Modelo PIM validado                                         ║
║ • Restricciones formales (OCL/EVL)                            ║
║                                                               ║
║ DURACIÓN: 3-4 semanas                                         ║
╚══════════════════════════════════════════════════════════════╝
                           ↓
╔══════════════════════════════════════════════════════════════╗
║ FASE 3: VALIDACIÓN SINTÁCTICA (Doc 2 - CRIO/Janeiro)         ║
╠══════════════════════════════════════════════════════════════╣
║                                                               ║
║ ENTRADA:                                                      ║
║ • Modelo PIM                                                  ║
║ • Metamodelo del dominio                                      ║
║ • Restricciones OCL/EVL                                       ║
║                                                               ║
║ ACTIVIDADES:                                                  ║
║ ┌─────────────────────────────────────────────────────┐      ║
║ │ 3.1. Definir Reglas de Validación EVL               │      ║
║ │      Ejemplo (adaptado de 8 reglas CRIO):           │      ║
║ │                                                      │      ║
║ │      constraint ExistenciaElementos {                │      ║
║ │        check: self.elementos.notEmpty()             │      ║
║ │        message: 'Debe tener al menos un elemento'   │      ║
║ │      }                                               │      ║
║ │                                                      │      ║
║ │      constraint UnicidadNombres {                   │      ║
║ │        check: self.elementos->isUnique(e|e.nombre)  │      ║
║ │        message: 'Nombres duplicados detectados'     │      ║
║ │      }                                               │      ║
║ │                                                      │      ║
║ │      [... 6 reglas más según dominio]               │      ║
║ │                                                      │      ║
║ │      Output: Archivo .evl con reglas                │      ║
║ └─────────────────────────────────────────────────────┘      ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────┐      ║
║ │ 3.2. Ejecutar Validación                            │      ║
║ │      - Validar modelo contra metamodelo             │      ║
║ │      - Ejecutar reglas EVL                          │      ║
║ │      - Generar reporte de errores/warnings          │      ║
║ │      - Iterar hasta modelo válido                   │      ║
║ │      Output: Modelo validado sintácticamente        │      ║
║ └─────────────────────────────────────────────────────┘      ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────┐      ║
║ │ 3.3. Validar Restricciones Semánticas (OCL)         │      ║
║ │      - Evaluar invariantes OCL                      │      ║
║ │      - Verificar pre/postcondiciones                │      ║
║ │      - Validar reglas de negocio                    │      ║
║ │      Output: Modelo validado semánticamente         │      ║
║ └─────────────────────────────────────────────────────┘      ║
║                                                               ║
║ SALIDA:                                                       ║
║ • Modelo PIM validado (sintáctica + semánticamente)           ║
║ • Reporte de validación                                       ║
║ • Modelo conforme a todas las restricciones                   ║
║                                                               ║
║ DURACIÓN: 1-2 semanas (iterativo)                             ║
╚══════════════════════════════════════════════════════════════╝
                           ↓
╔══════════════════════════════════════════════════════════════╗
║ FASE 4: TRANSFORMACIÓN PIM → PSM (Doc 1 - MDA/MDE)           ║
╠══════════════════════════════════════════════════════════════╣
║                                                               ║
║ ENTRADA:                                                      ║
║ • Modelo PIM validado                                         ║
║ • Modelo de plataforma destino                                ║
║                                                               ║
║ ACTIVIDADES:                                                  ║
║ ┌─────────────────────────────────────────────────────┐      ║
║ │ 4.1. Definir Transformación ATL/QVT                 │      ║
║ │      - Mapear conceptos PIM → conceptos PSM         │      ║
║ │      - Escribir matched rules                       │      ║
║ │      - Escribir lazy rules (si necesario)           │      ║
║ │      - Definir helpers                              │      ║
║ │                                                      │      ║
║ │      Ejemplo:                                        │      ║
║ │      rule Entidad2Clase {                           │      ║
║ │        from e : PIM!Entidad                         │      ║
║ │        to   c : PSM!Clase (                         │      ║
║ │          nombre <- e.nombre,                        │      ║
║ │          atributos <- e.atributos,                  │      ║
║ │          anotaciones <- e.mapearAnotaciones()       │      ║
║ │        )                                             │      ║
║ │      }                                               │      ║
║ │                                                      │      ║
║ │      Output: Archivo .atl con transformación        │      ║
║ └─────────────────────────────────────────────────────┘      ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────┐      ║
║ │ 4.2. Ejecutar Transformación                        │      ║
║ │      - Cargar PIM                                    │      ║
║ │      - Cargar modelo de plataforma                  │      ║
║ │      - Ejecutar transformación ATL                  │      ║
║ │      - Generar PSM                                   │      ║
║ │      Output: Modelo PSM                             │      ║
║ └─────────────────────────────────────────────────────┘      ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────┐      ║
║ │ 4.3. Validar PSM Generado                           │      ║
║ │      - Verificar conformidad con metamodelo destino │      ║
║ │      - Validar restricciones de plataforma          │      ║
║ │      - Revisar trazabilidad PIM → PSM               │      ║
║ │      Output: PSM validado                           │      ║
║ └─────────────────────────────────────────────────────┘      ║
║                                                               ║
║ SALIDA:                                                       ║
║ • Modelo PSM (ej. Java, .NET, CORBA)                          ║
║ • Trazabilidad PIM ↔ PSM                                      ║
║                                                               ║
║ DURACIÓN: 2-3 semanas (primera vez), luego automático         ║
╚══════════════════════════════════════════════════════════════╝
                           ↓
╔══════════════════════════════════════════════════════════════╗
║ FASE 5: GENERACIÓN DE CÓDIGO (Doc 2 - CRIO/Janeiro)          ║
╠══════════════════════════════════════════════════════════════╣
║                                                               ║
║ ENTRADA:                                                      ║
║ • Modelo PSM                                                  ║
║                                                               ║
║ ACTIVIDADES:                                                  ║
║ ┌─────────────────────────────────────────────────────┐      ║
║ │ 5.1. Definir Templates de Generación (M2T)          │      ║
║ │      Herramientas: Acceleo, Xtend, Xpand            │      ║
║ │                                                      │      ║
║ │      Ejemplo Acceleo:                                │      ║
║ │      [template public generateClass(c : Class)]     │      ║
║ │      [file (c.nombre + '.java', false, 'UTF-8')]    │      ║
║ │      public class [c.nombre/] {                     │      ║
║ │        [for (a : Atributo | c.atributos)]           │      ║
║ │        private [a.tipo/] [a.nombre/];               │      ║
║ │        [/for]                                        │      ║
║ │                                                      │      ║
║ │        // Getters y Setters                         │      ║
║ │        [c.generarGettersSetters()/]                 │      ║
║ │      }                                               │      ║
║ │      [/file]                                         │      ║
║ │      [/template]                                     │      ║
║ │                                                      │      ║
║ │      Output: Templates .mtl                         │      ║
║ └─────────────────────────────────────────────────────┘      ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────┐      ║
║ │ 5.2. Ejecutar Generadores                           │      ║
║ │      - Procesar PSM con templates                   │      ║
║ │      - Generar código fuente                        │      ║
║ │      - Generar archivos de configuración            │      ║
║ │      - Generar scripts de build                     │      ║
║ │      Output: Código fuente completo                 │      ║
║ └─────────────────────────────────────────────────────┘      ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────┐      ║
║ │ 5.3. Compilar y Desplegar                           │      ║
║ │      - Compilar código generado                     │      ║
║ │      - Ejecutar tests unitarios                     │      ║
║ │      - Empaquetar aplicación                        │      ║
║ │      - Desplegar en ambiente de pruebas             │      ║
║ │      Output: Sistema ejecutable                     │      ║
║ └─────────────────────────────────────────────────────┘      ║
║                                                               ║
║ SALIDA:                                                       ║
║ • Código fuente (Java, C#, Python, etc.)                      ║
║ • Binarios compilados                                         ║
║ • Sistema desplegado                                          ║
║                                                               ║
║ DURACIÓN: Automático (minutos) una vez configurado            ║
╚══════════════════════════════════════════════════════════════╝
                           ↓
╔══════════════════════════════════════════════════════════════╗
║ FASE 6: VALIDACIÓN COMPLETA (Integración de los 3 docs)      ║
╠══════════════════════════════════════════════════════════════╣
║                                                               ║
║ ENTRADA:                                                      ║
║ • Sistema ejecutable                                          ║
║ • Trazabilidad completa BR→UC→RF→PIM→PSM→Código               ║
║                                                               ║
║ ACTIVIDADES:                                                  ║
║ ┌─────────────────────────────────────────────────────┐      ║
║ │ 6.1. Validación de Trazabilidad                     │      ║
║ │      Forward:                                        │      ║
║ │        Si BR_028 cambia → identificar impacto       │      ║
║ │        UC_04 → RF_205-209 → Modelo → Código         │      ║
║ │                                                      │      ║
║ │      Backward:                                       │      ║
║ │        Código validarCertificado() → ¿de dónde viene?│     ║
║ │        RF_205 → UC_04 → BR_087 → OSHA 1910.1200     │      ║
║ │                                                      │      ║
║ │      Output: Matriz de trazabilidad verificada      │      ║
║ └─────────────────────────────────────────────────────┘      ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────┐      ║
║ │ 6.2. Validación de Cumplimiento de BR               │      ║
║ │      Para cada BR:                                   │      ║
║ │        ¿Existe UC que la implementa?                │      ║
║ │        ¿UC deriva RF correctos?                     │      ║
║ │        ¿Código implementa RF?                       │      ║
║ │        ¿Comportamiento cumple BR original?          │      ║
║ │                                                      │      ║
║ │      Método: Revisión manual + Tests automáticos    │      ║
║ │      Output: Reporte de cumplimiento                │      ║
║ └─────────────────────────────────────────────────────┘      ║
║                                                               ║
║ ┌─────────────────────────────────────────────────────┐      ║
║ │ 6.3. Auditoría de Conformidad                       │      ║
║ │      - Demostrar cumplimiento de regulaciones       │      ║
║ │      - Presentar trazabilidad completa              │      ║
║ │      - Documentar decisiones de diseño              │      ║
║ │      - Certificar sistema                           │      ║
║ │      Output: Certificado de conformidad             │      ║
║ └─────────────────────────────────────────────────────┘      ║
║                                                               ║
║ SALIDA:                                                       ║
║ • Sistema validado y certificado                              ║
║ • Trazabilidad completa verificada                            ║
║ • Cumplimiento de BR demostrado                               ║
║ • Documentación completa                                      ║
║                                                               ║
║ DURACIÓN: 2-3 semanas                                         ║
╚══════════════════════════════════════════════════════════════╝
```

### 13.2. Métricas del Proceso Integrado

**Tiempos típicos**:

| Fase | Duración | % Total | Automatizable |
|------|---------|---------|--------------|
| 1. Análisis Requisitos | 7-8 sem | 40% | 10% |
| 2. Modelado Conceptual | 3-4 sem | 20% | 30% |
| 3. Validación Sintáctica | 1-2 sem | 10% | 80% |
| 4. Transformación PIM→PSM | 2-3 sem | 15% | 90% (después 1ª vez) |
| 5. Generación Código | Automático | <5% | 100% |
| 6. Validación Completa | 2-3 sem | 15% | 40% |
| **TOTAL** | **17-22 sem** | **100%** | **~50%** (promedio) |

**Esfuerzo por rol**:

| Rol | Fase 1 | Fase 2 | Fase 3 | Fase 4 | Fase 5 | Fase 6 |
|-----|--------|--------|--------|--------|--------|--------|
| **Analista de Negocio** | ✅✅✅ | ✅ | ⚫ | ⚫ | ⚫ | ✅ |
| **Ingeniero de Requisitos** | ✅✅✅ | ✅✅ | ✅ | ⚫ | ⚫ | ✅✅ |
| **Arquitecto de Software** | ✅ | ✅✅✅ | ✅✅ | ✅✅✅ | ✅ | ✅ |
| **Ingeniero de Modelos** | ⚫ | ✅✅✅ | ✅✅✅ | ✅✅✅ | ✅✅ | ✅ |
| **Desarrollador** | ⚫ | ✅ | ✅ | ✅ | ✅✅✅ | ✅✅ |
| **QA/Tester** | ⚫ | ⚫ | ✅ | ✅ | ✅✅ | ✅✅✅ |
| **Auditor/Compliance** | ✅ | ⚫ | ⚫ | ⚫ | ⚫ | ✅✅✅ |

Leyenda: ✅✅✅ = Muy alto, ✅✅ = Alto, ✅ = Medio, ⚫ = Nulo/Mínimo

**Beneficios cuantificables**:

```
SIN METODOLOGÍA INTEGRADA:
  - Tiempo desarrollo: 30-40 semanas
  - Defectos en producción: 50 bugs/KLOC
  - Regresiones por cambios: 30%
  - Capacidad de auditoría: Baja
  - Mantenibilidad: Difícil

CON METODOLOGÍA INTEGRADA:
  - Tiempo desarrollo: 17-22 semanas ✅ (-35% tiempo)
  - Defectos en producción: 15 bugs/KLOC ✅ (-70% defectos)
  - Regresiones por cambios: 10% ✅ (-67% regresiones)
  - Capacidad de auditoría: Alta ✅ (trazabilidad completa)
  - Mantenibilidad: Excelente ✅ (análisis impacto sistemático)
  
ROI: Inversión 8 semanas análisis → Ahorro 13-18 semanas desarrollo
```

**Mapeo a carpeta**: `_metodologias/proceso_end_to_end/`

---

## 14. METODOLOGÍA BR → UC → RF

### 14.1. PARTE 1: Identificar Business Rules

**Objetivo**: Extraer y documentar TODAS las BR del proyecto.

**Técnicas de Elicitación - Las 6 Preguntas Estratégicas**:

```
┌──────────────────────────────────────────────────────────┐
│ PREGUNTA 1: ¿Qué RIGE el negocio?                        │
│                                                           │
│ Buscar:                                                   │
│ • Políticas corporativas                                 │
│ • Regulaciones externas (OSHA, EPA, FDA, SOX, etc.)     │
│ • Estándares industriales (ISO, IEEE, etc.)             │
│ • Leyes aplicables                                       │
│                                                           │
│ Ejemplo identificado:                                     │
│ BR_087: "Solo personal capacitado según OSHA 1910.1200   │
│          puede manipular químicos peligrosos clase 1-4"  │
│ Fuente: Regulación federal OSHA                          │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│ PREGUNTA 2: ¿Qué RESTRINGE las operaciones?              │
│                                                           │
│ Buscar:                                                   │
│ • Quién puede hacer qué (autorización)                   │
│ • Límites, umbrales, topes                               │
│ • Condiciones obligatorias                               │
│ • Restricciones de tiempo                                │
│                                                           │
│ Ejemplo identificado:                                     │
│ BR_028: "Solicitudes >$500 requieren aprobación          │
│          del gerente de departamento"                    │
│ Tipo: Restricción                                        │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│ PREGUNTA 3: ¿Qué DESENCADENA acciones automáticas?       │
│                                                           │
│ Buscar:                                                   │
│ • Eventos que activan comportamientos                    │
│ • Notificaciones automáticas                             │
│ • Procesamiento batch/scheduled                          │
│ • Alertas y alarmas                                      │
│                                                           │
│ Ejemplo identificado:                                     │
│ BR_045: "SI contenedor alcanza fecha vencimiento         │
│          ENTONCES notificar a propietario y coordinador" │
│ Tipo: Desencadenador ⭐ (genera UC completo)             │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│ PREGUNTA 4: ¿Qué se CALCULA y cómo?                      │
│                                                           │
│ Buscar:                                                   │
│ • Fórmulas de negocio                                    │
│ • Algoritmos de pricing                                  │
│ • Deducciones, descuentos                                │
│ • Cálculos financieros, actuariales                      │
│                                                           │
│ Ejemplo identificado:                                     │
│ BR_052: "Precio total = Suma(items) - Descuento + IVA    │
│          (16% del subtotal) + Envío"                     │
│ Tipo: Cálculo                                            │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│ PREGUNTA 5: ¿Qué CAMBIA internamente sin que usuario vea?│
│                                                           │
│ Buscar:                                                   │
│ • Estados derivados                                      │
│ • Clasificaciones automáticas                            │
│ • Banderas internas                                      │
│ • Categorizaciones                                       │
│                                                           │
│ Ejemplo identificado:                                     │
│ BR_046: "SI contenedor alcanza vencimiento               │
│          ENTONCES marcar status como 'Caduco'"           │
│ Tipo: Inferencia (NO genera UC)                         │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│ PREGUNTA 6: ¿Qué es VERDAD sobre el dominio?             │
│                                                           │
│ Buscar:                                                   │
│ • Estructura de datos                                    │
│ • Relaciones obligatorias                                │
│ • Unicidades                                             │
│ • Multiplicidades                                        │
│                                                           │
│ Ejemplo identificado:                                     │
│ BR_010: "Cada contenedor tiene código único alfanumérico"│
│ Tipo: Hecho                                              │
└──────────────────────────────────────────────────────────┘
```

**Plantilla de documentación estándar**:

```markdown
BR_XXX:
  Definición: [Declaración clara y concisa de la regla]
  
  Tipo: [Hecho | Restricción | Desencadenador | Inferencia | Cálculo]
  
  Fuente: [Documento, regulación, política de donde proviene]
          [Incluir sección específica si aplica]
  
  Razón: [Por qué existe esta regla, qué problema resuelve]
  
  Fecha vigencia: [YYYY-MM-DD desde cuando aplica]
  
  Estática: [Sí | No - ¿La regla puede cambiar?]
  
  Responsable: [Rol/persona que puede autorizar cambios]
  
  Relacionadas: [Otras BR que dependen/influyen]
  
  Aplicabilidad: [Condiciones bajo las cuales aplica]
  
  Excepciones: [Casos donde NO aplica, si los hay]
  
  Penalización: [Consecuencias de incumplimiento, si aplica]
```

**Ejemplo completo documentado**:

```markdown
BR_028:
  Definición: "Solicitudes de compra de productos químicos que 
               excedan $500 USD requieren aprobación explícita 
               del gerente del departamento solicitante"
  
  Tipo: Restricción
  
  Fuente: Política Financiera Corporativa v2.3, Sección 4.2
          "Control de Gastos en Productos Controlados"
          Aprobada por CFO en Junta Directiva del 2023-01-15
  
  Razón: Implementar control de gastos en productos de alto valor
         y cumplir con requerimientos de auditoría interna según
         norma ISO 9001:2015
  
  Fecha vigencia: 2023-01-01
  
  Estática: No (puede cambiar por decisión del CFO)
  
  Responsable: CFO (Chief Financial Officer)
  
  Relacionadas: 
    - BR_029: Flujo de aprobación (define cómo aprobar)
    - BR_030: Notificaciones (define cómo notificar)
    - BR_031: Timeout de aprobación (48 horas)
  
  Aplicabilidad: Todos los departamentos excepto:
    - Mantenimiento (tiene pre-aprobación anual)
    - I+D (tiene presupuesto independiente)
  
  Excepciones: 
    - Emergencias declaradas oficialmente
    - Órdenes de compra recurrentes pre-aprobadas
  
  Penalización: 
    - Solicitud rechazada automáticamente
    - Registro en historial del solicitante
    - Escalación a supervisor si reincidencia
```

**Entregables de PARTE 1**:

1. **Catálogo de Business Rules** (Excel/CSV)
   - Columnas: ID, Definición, Tipo, Fuente, Responsable, Estática
   - ~45 BR típicamente para sistema mediano

2. **Matriz de Roles y Permisos** (si aplica)
   - Qué roles pueden realizar qué acciones
   - Derivado de BR tipo Restricción

3. **Modelo de Dominio Inicial**
   - Diagrama conceptual
   - Derivado de BR tipo Hecho

4. **Glosario de Términos**
   - Vocabulario del dominio
   - Definiciones unívocas

**Mapeo a carpeta**: `_metodologias/br_a_sistema/parte1_identificar_br.md`

### 14.2. PARTE 2: Transformar BR → UC

**Aplicación de los 5 Patrones de Transformación**:

**Matriz de decisión**:

```
┌─────────────────┬──────────────┬──────────────┬─────────────────┐
│ Tipo BR         │ Genera UC    │ Se integra   │ Output          │
│                 │ completo     │ en UC        │                 │
├─────────────────┼──────────────┼──────────────┼─────────────────┤
│ Hecho           │ ❌ NO        │ ⚫ N/A        │ Modelo dominio  │
│                 │              │              │ + RF validación │
├─────────────────┼──────────────┼──────────────┼─────────────────┤
│ Restricción     │ ❌ NO        │ ✅ SÍ        │ Precondición o  │
│                 │              │              │ paso validación │
├─────────────────┼──────────────┼──────────────┼─────────────────┤
│ Desencadenador  │ ✅ SÍ        │ ⚫ N/A        │ UC NUEVO        │
│ ⭐              │              │              │ completo        │
├─────────────────┼──────────────┼──────────────┼─────────────────┤
│ Inferencia      │ ❌ NO        │ ✅ SÍ        │ Paso interno    │
│                 │              │              │ (lógica)        │
├─────────────────┼──────────────┼──────────────┼─────────────────┤
│ Cálculo         │ ❌ NO        │ ✅ SÍ        │ Pasos de        │
│                 │              │              │ cálculo         │
└─────────────────┴──────────────┴──────────────┴─────────────────┘
```

**Proceso detallado para Desencadenadores**:

```
ENTRADA: BR tipo Desencadenador
  "SI [condición] ENTONCES [comportamiento observable]"

PASO 1: Identificar componentes
  - Condición: ¿Cuándo se activa?
  - Comportamiento: ¿Qué acción observable ocurre?
  
PASO 2: Identificar actor
  Opciones:
    - Sistema (proceso batch)
    - Sistema (evento tiempo real)
    - Sistema externo (trigger externo)
    
PASO 3: Crear estructura de UC

  UC_XXX: [Nombre descriptivo del comportamiento]
  
  Actor Primario: [Sistema | Sistema Externo | Tiempo]
  
  Objetivo: [Qué se logra con este UC]
  
  Desencadenador: [La condición de la BR]
  
  Precondiciones:
    - [Condiciones que deben cumplirse ANTES]
  
  Flujo Normal:
    1. [Sistema detecta condición]
    2. [Para cada elemento afectado:]
       2.1. [Identificar destinatarios/afectados]
       2.2. [Generar mensaje/acción]
       2.3. [Ejecutar acción observable]
       2.4. [Registrar acción ejecutada]
    3. [Generar reporte/log]
  
  Flujos Alternos:
    FA-1: [Si no hay elementos afectados]
    FA-2: [Si falla notificación/acción]
  
  Flujos Excepcionales:
    FE-1: [Errores críticos]
  
  Postcondiciones:
    - [Estados garantizados al terminar]
  
  Business Rules aplicadas: BR_XXX

PASO 4: Derivar Functional Requirements
  - Por cada paso del flujo → 1-N RF
  - Especificación detallada implementable
```

**Ejemplo completo**:

```
ENTRADA:
  BR_045: "SI un contenedor de químico alcanza su fecha de 
           vencimiento ENTONCES el sistema debe notificar al 
           propietario del contenedor y al coordinador de 
           seguridad"

TRANSFORMACIÓN:

UC_07: Notificar Vencimiento de Producto Químico

Actor Primario: Sistema (Proceso Batch Diario)

Objetivo: Alertar a propietarios y coordinador de seguridad 
          sobre productos químicos que han alcanzado su fecha 
          de vencimiento

Desencadenador: Proceso batch ejecutado diariamente a las 06:00 AM

Precondiciones:
  - Sistema debe tener acceso a catálogo de contenedores
  - Fechas de vencimiento deben estar actualizadas
  - Configuración de email debe estar operativa

Flujo Normal:
  1. Sistema identifica contenedores con fechaVencimiento = FECHA_HOY
  
  2. Para cada contenedor identificado:
     2.1. Sistema recupera información del propietario del contenedor
     2.2. Sistema recupera información del coordinador de seguridad
     2.3. Sistema genera mensaje de notificación con:
          - Código del contenedor
          - Nombre del producto químico
          - Ubicación del contenedor
          - Fecha de vencimiento
          - Acciones recomendadas (disposición segura)
     2.4. Sistema envía email al propietario del contenedor
     2.5. Sistema envía email al coordinador de seguridad
     2.6. Sistema registra en log:
          - ID notificación
          - Contenedor notificado
          - Destinatarios
          - Timestamp de envío
          - Estado (exitoso/fallido)
  
  3. Sistema genera reporte diario con:
     - Total de contenedores vencidos notificados
     - Lista de destinatarios contactados
     - Notificaciones fallidas (si las hay)
  
  4. Sistema envía reporte al coordinador de seguridad

Flujos Alternos:
  FA-1: No hay contenedores vencidos
    1.1. Sistema genera log indicando "Sin vencimientos hoy"
    1.2. Sistema NO envía notificaciones
    1.3. Caso de uso termina
  
  FA-2: Falla envío de email a propietario
    2.1. Sistema reintenta envío (máximo 3 intentos)
    2.2. Si sigue fallando:
         - Sistema marca notificación como "Fallida"
         - Sistema incluye en reporte de notificaciones fallidas
         - Sistema envía alerta al coordinador de seguridad
    2.3. Continúa con siguiente contenedor

Flujos Excepcionales:
  FE-1: Error crítico en sistema de email
    1.1. Sistema suspende proceso de notificación
    1.2. Sistema registra error en log de sistema
    1.3. Sistema envía alerta al administrador de sistema
    1.4. Caso de uso termina con error

Postcondiciones:
  - Todos los propietarios de contenedores vencidos han sido 
    notificados (o intentos registrados)
  - Coordinador de seguridad ha recibido todas las notificaciones
  - Log de notificaciones está actualizado
  - Reporte diario ha sido generado

Business Rules aplicadas: BR_045

Requerimientos No Funcionales relacionados:
  - RNF-12: Proceso debe ejecutarse en <10 minutos
  - RNF-13: Emails deben enviarse en <30 segundos
  - RNF-14: Log debe conservarse por 7 años (cumplimiento OSHA)

DERIVACIÓN A FUNCTIONAL REQUIREMENTS:

RF_301: "Sistema debe ejecutar proceso batch diariamente 
         a las 06:00 AM para identificar contenedores con 
         fechaVencimiento = FECHA_ACTUAL"

RF_302: "Para cada contenedor vencido, sistema debe recuperar 
         propietario mediante relación Contenedor.propietario"

RF_303: "Sistema debe generar mensaje de notificación con 
         formato estándar incluyendo: código, nombre producto, 
         ubicación, fecha vencimiento, acciones recomendadas"

RF_304: "Sistema debe enviar email a propietario usando 
         dirección Empleado.emailCorporativo"

RF_305: "Sistema debe enviar copia de email a coordinador 
         de seguridad (obtenido de configuración sistema)"

RF_306: "Sistema debe registrar cada notificación en tabla 
         LogNotificaciones con campos: id, contenedorID, 
         destinatario, timestamp, estado"

RF_307: "SI envío de email falla ENTONCES sistema debe 
         reintentar 3 veces con intervalo de 30 segundos"

RF_308: "Sistema debe generar reporte diario en formato PDF 
         con estadísticas de notificaciones enviadas/fallidas"

RF_309: "Sistema debe conservar logs de notificaciones por 
         7 años según requerimiento OSHA"

Trazabilidad establecida:
  BR_045 → UC_07 → RF_301, RF_302, RF_303, RF_304, RF_305, 
                    RF_306, RF_307, RF_308, RF_309
```

**Salida de PARTE 2**:

- **10-15 UC derivados de BR** (típicamente 22% del total)
- **50-100 RF derivados de estos UC**
- **Tabla de transformación BR → UC**
- **Matriz de trazabilidad BR ↔ UC ↔ RF**

**Mapeo a carpeta**: `_metodologias/br_a_sistema/parte2_transformar_br_uc.md`

### 14.3. PARTE 3: Identificar UC Adicionales

**Las 4 técnicas complementarias**:

**TÉCNICA 1: CRUD (40% de UC adicionales)**

Proceso:
```
1. Listar entidades del modelo de dominio
   Fuente: Modelo conceptual de PARTE 1
   
2. Clasificar entidades:
   MAESTROS:
     - Datos relativamente estáticos
     - Alta frecuencia de consulta
     - Baja frecuencia de modificación
     - Ejemplos: Productos, Empleados, Proveedores
   
   TRANSACCIONALES:
     - Datos dinámicos
     - Representan eventos de negocio
     - No se modifican (solo se crean)
     - Ejemplos: Solicitudes, Pedidos, Facturas
   
   TÉCNICAS:
     - Datos de sistema
     - Generados automáticamente
     - Ejemplos: Logs, Sesiones, Auditoría

3. Aplicar reglas de decisión:
   
   ┌─────────────┬────┬────┬────┬────┐
   │ Tipo        │ C  │ R  │ U  │ D  │
   ├─────────────┼────┼────┼────┼────┤
   │ Maestro     │ ✅ │ ✅ │ ✅ │ ⚠️ │
   │ Transac     │ ✅ │ ✅ │ ❌ │ ❌ │
   │ Técnica     │ 🤖 │ ✅ │ 🤖 │ 🤖 │
   └─────────────┴────┴────┴────┴────┘
   
   Leyenda:
   ✅ = Generar UC
   ❌ = NO generar UC
   ⚠️ = Eliminación lógica (no física)
   🤖 = Automático (no requiere UC)

4. Generar UC por operación
   
   Nomenclatura:
   UC-XXX: Registrar [Entidad]       (Create)
   UC-XXX: Consultar [Entidad]       (Read)
   UC-XXX: Actualizar [Entidad]      (Update)
   UC-XXX: Eliminar [Entidad]        (Delete - lógico)
   
   O fusionado:
   UC-XXX: Gestionar [Entidad]
     Subflujo A: Registrar
     Subflujo B: Consultar
     Subflujo C: Actualizar
     Subflujo D: Dar de baja

5. Asignar actores
   - Típicamente: Administrador, Usuario con permisos
```

Ejemplo:
```
Entidad: Producto Químico (MAESTRO)

UC generados:
  UC-10: Registrar Producto Químico
    Actor: Administrador de Catálogo
    Objetivo: Dar de alta nuevo producto en catálogo
    
  UC-11: Consultar Producto Químico
    Actor: Usuario General
    Objetivo: Ver información de producto
    
  UC-12: Actualizar Producto Químico
    Actor: Administrador de Catálogo
    Objetivo: Modificar datos de producto
    
  UC-13: Eliminar Producto Químico (lógico)
    Actor: Administrador de Catálogo
    Objetivo: Dar de baja producto (marca como inactivo)
```

**TÉCNICA 2: LARMAN (36% de UC adicionales)**

**Subtécnica 2.1: Eventos del Sistema**

```
Proceso:
1. Identificar actores (primarios y secundarios)
2. Por cada actor, listar eventos que puede generar
3. Filtrar eventos significativos (no triviales)
4. Generar UC por evento complejo

Ejemplo:
  Actor: Solicitante
  
  Eventos generados:
    - Solicita producto químico → UC-04 (ya existe de BR)
    - Consulta estado de solicitud → UC-15 (NUEVO)
    - Cancela solicitud → UC-16 (NUEVO)
    - Descarga certificado de capacitación → UC-17 (NUEVO)
    - Actualiza datos de contacto → UC-18 (NUEVO)
```

**Subtécnica 2.2: Operaciones del Sistema**

```
Categorías:
  
  CONSULTAS (Queries):
    - Recuperar información sin modificar estado
    - Generar reportes
    - Buscar/filtrar
    
    UC generados:
      UC-20: Buscar Productos por Categoría
      UC-21: Generar Reporte de Inventario
      UC-22: Consultar Historial de Solicitudes
  
  COMANDOS (Commands):
    - Cambiar estado del sistema
    - Procesar transacciones
    - Ejecutar operaciones de negocio
    
    UC generados:
      UC-25: Procesar Devolución de Producto
      UC-26: Registrar Incidente de Seguridad
      UC-27: Aprobar Solicitud en Lote
  
  CONFIGURACIÓN:
    - Ajustar parámetros del sistema
    - Definir reglas de negocio variables
    
    UC generados:
      UC-30: Configurar Umbrales de Alerta
      UC-31: Definir Niveles de Stock Mínimo
      UC-32: Gestionar Calendario de Batch Jobs
```

**Subtécnica 2.3: Responsabilidades del Sistema**

```
Categorías:
  
  CONOCER (Doing - Saber):
    Sistema debe conocer información
    
    UC generados:
      UC-35: Consultar Dashboard de Operaciones
      UC-36: Ver Estadísticas de Uso
      UC-37: Consultar Inventario Valorizado
  
  HACER (Doing - Ejecutar):
    Sistema debe ejecutar procesos
    
    UC generados:
      UC-40: Procesar Nómina
      UC-41: Generar Orden de Compra Automática
      UC-42: Sincronizar con Sistema Externo
  
  DECIDIR (Deciding):
    Sistema debe tomar decisiones
    
    UC generados:
      UC-45: Calcular Stock de Reorden
      UC-46: Asignar Prioridad a Solicitud
      UC-47: Optimizar Rutas de Distribución
```

**TÉCNICA 3: UI-DRIVEN (9% de UC adicionales)**

```
Proceso:
1. Crear mockups de pantallas principales
   Herramientas: Balsamiq, Figma, Sketch
   
2. Identificar interacciones significativas en cada pantalla
   
3. Filtrar interacciones triviales
   Criterio: ¿Requiere lógica de negocio significativa?
   
4. Generar UC por interacción compleja

Ejemplo:
  Pantalla: Dashboard de Solicitudes
  
  Interacciones identificadas:
    - Ver lista de solicitudes → [Trivial, parte de UC-XX]
    - Filtrar por estado → UC-50: Filtrar y Buscar Solicitudes
    - Exportar a Excel → UC-51: Exportar Reporte Solicitudes
    - Ver gráfico tendencias → UC-52: Visualizar Estadísticas
    - Aprobar/Rechazar en lote → UC-53: Procesar Lote Solicitudes
```

**TÉCNICA 4: STAKEHOLDERS (9% de UC adicionales)**

```
Proceso:
1. Identificar stakeholders clave
   - Director de Seguridad
   - Gerente de Operaciones
   - Auditor Interno
   - CFO
   
2. Entrevistar con preguntas específicas:
   • "¿Qué reportes necesita regularmente?"
   • "¿Qué operaciones realiza manualmente que podrían automatizarse?"
   • "¿Qué información necesita para tomar decisiones?"
   • "¿Qué procesos actuales son más problemáticos?"
   • "¿Qué le gustaría que el sistema pudiera hacer?"

3. Documentar necesidades específicas

4. Generar UC por necesidad

Ejemplo:
  Stakeholder: Director de Seguridad
  
  Necesidades expresadas:
    - "Necesito saber qué químicos están por vencer cada semana"
      → UC-60: Generar Reporte Semanal de Vencimientos
    
    - "Quiero ver mapa de ubicaciones de químicos peligrosos"
      → UC-61: Visualizar Mapa de Inventario Peligroso
    
    - "Necesito exportar datos para auditorías externas"
      → UC-62: Exportar Datos para Auditoría
    
    - "Alertas automáticas cuando stock crítico está bajo"
      → UC-63: Configurar Alertas de Stock Crítico
```

**Consolidación final**:

```
ENTRADA:
  - 10 UC de BR (PARTE 2)
  - 18 UC de CRUD
  - 16 UC de Larman
  - 4 UC de UI-Driven
  - 4 UC de Stakeholders
  ─────────────────────
  Total: 52 UC candidatos

PROCESO:
  1. Identificar duplicados
     Ejemplo: UC-A1 "Registrar Empleado" (CRUD)
              UC-A2 "Crear Nuevo Empleado" (Stakeholder)
     Decisión: DUPLICADO → Conservar UC-A1
  
  2. Fusionar similares
     Ejemplo: UC-B1 "Consultar Lista Empleados" (CRUD)
              UC-B2 "Buscar Empleado" (UI)
     Decisión: FUSIONAR → UC-15 "Consultar y Buscar Empleados"
  
  3. Separar si actores diferentes
     Ejemplo: UC-C1 "Modificar Datos Empleado" (Admin)
              UC-C2 "Actualizar Mi Info" (Self-service)
     Decisión: CONSERVAR AMBOS (actores diferentes)

SALIDA:
  45 UC consolidados

Organización por módulos:
  - Catálogo: 10 UC
  - Solicitudes: 8 UC
  - Inventario: 7 UC
  - Usuarios: 6 UC
  - Seguridad: 5 UC
  - Reportería: 6 UC
  - Administración: 7 UC

Priorización MoSCoW:
  - Must Have: 22 UC (49%)
  - Should Have: 15 UC (33%)
  - Could Have: 8 UC (18%)
```

**Mapeo a carpeta**: `_metodologias/br_a_sistema/parte3_identificar_uc_adicionales.md`

---

(Continuará en PARTE 4 del archivo con las secciones restantes: Metodologías de validación, Taxonomías y Metamodelos, Aplicabilidad Trans-Dominio, y Síntesis Final)

