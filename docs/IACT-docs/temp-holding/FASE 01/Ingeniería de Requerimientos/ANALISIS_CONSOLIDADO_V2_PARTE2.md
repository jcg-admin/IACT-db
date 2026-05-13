# ANÁLISIS CONSOLIDADO V2.0 - PARTE 2

(Continuación de ANALISIS_CONSOLIDADO_V2_COMPLETO.md)

---

## 7. TRANSFORMACIONES

### 7.1. Concepto Universal de Transformación

**Definición integrada** (de Doc 1 + Doc 3):

```
Una transformación es el proceso de convertir un modelo/artefacto 
de un sistema en otro modelo/artefacto del mismo sistema.

Componentes:
  - Modelo origen (conforme a metamodelo origen)
  - Modelo destino (conforme a metamodelo destino)
  - Reglas de transformación (mapeo)
  - Parámetros (opcional)
```

**Perspectivas de los 3 documentos**:

| Documento | Tipo de transformación | Notación |
|-----------|----------------------|----------|
| **MDA/MDE** | PIM → PSM | ATL, QVT |
| **BR→Sistema** | BR → UC → RF | Patrones textuales |
| **CRIO/Janeiro** | Modelo → Código | [Generadores] |

### 7.2. Los 5 Patrones de Transformación BR → UC

**Del documento BR→Sistema - Esencial para metodología completa**:

```
┌──────────────────────────────────────────────────────────┐
│ PATRÓN 1: HECHOS → MODELO DE DOMINIO                     │
│                                                           │
│ BR (Hecho):                                               │
│   "Cada contenedor químico tiene código único"           │
│                                                           │
│ Transformación:                                           │
│   → Modelo Dominio: Entidad "Contenedor"                 │
│                     Atributo "código" (String, unique)   │
│   → RF: "Sistema valida unicidad de código"              │
│                                                           │
│ NO genera UC completo (solo estructura de datos)         │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│ PATRÓN 2: RESTRICCIONES → PRECONDICIONES/POSTCONDICIONES │
│                                                           │
│ BR (Restricción):                                         │
│   "Solicitudes >$500 requieren aprobación"               │
│                                                           │
│ Transformación:                                           │
│   → UC existente: Paso 6 - Validar monto                 │
│      6.1. SI monto >$500 ENTONCES Flujo Alterno FA-1     │
│   → FA-1: Solicitar Aprobación Gerente                   │
│   → RF: "Comparar con umbral", "Enviar notificación"     │
│                                                           │
│ NO genera UC nuevo (se integra en UC existente)          │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│ PATRÓN 3: DESENCADENADORES → UC COMPLETOS ✨              │
│                                                           │
│ BR (Desencadenador):                                      │
│   "SI contenedor vence ENTONCES notificar propietario"   │
│                                                           │
│ Transformación:                                           │
│   → GENERA UC-07: Notificar Vencimiento Químico          │
│      Actor: Sistema (batch)                              │
│      Desencadenador: Fecha vencimiento = HOY             │
│      Flujo: Identificar → Generar mensaje → Enviar       │
│   → RF múltiples (identificar, generar, enviar, log)     │
│                                                           │
│ SÍ genera UC completo nuevo (acción observable)          │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│ PATRÓN 4: INFERENCIAS → LÓGICA INTERNA                   │
│                                                           │
│ BR (Inferencia):                                          │
│   "SI contenedor vence ENTONCES marcar 'Caduco'"         │
│                                                           │
│ Transformación:                                           │
│   → NO genera UC propio                                  │
│   → Se integra en UC existente como paso:                │
│      "2.7. Sistema actualiza status a 'Caduco'"          │
│   → RF: "Sistema actualiza campo status"                 │
│                                                           │
│ NO genera UC (solo cambio estado interno)                │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│ PATRÓN 5: CÁLCULOS → PASOS EN FLUJOS                     │
│                                                           │
│ BR (Cálculo):                                             │
│   "Precio = Items - Desc + IVA + Envío"                  │
│                                                           │
│ Transformación:                                           │
│   → UC existente: Paso 4 - Calcular precio               │
│      4.1. Sumar items                                    │
│      4.2. Aplicar descuento                              │
│      4.3. Calcular IVA (16%)                             │
│      4.4. Sumar envío                                    │
│   → RF: "Sistema calcula IVA como 16% subtotal"          │
│                                                           │
│ NO genera UC nuevo (se integra como pasos)               │
└──────────────────────────────────────────────────────────┘
```

**Matriz de decisión rápida**:

| Tipo BR | ¿Observable externamente? | ¿Genera UC completo? | ¿Dónde se mapea? |
|---------|--------------------------|---------------------|------------------|
| **Hecho** | N/A | ❌ | Modelo dominio + RF validación |
| **Restricción** | Sí (validación) | ❌ | Precondición/Paso en UC existente |
| **Desencadenador** | ✅ SÍ | ✅ SÍ | UC NUEVO completo |
| **Inferencia** | ❌ NO | ❌ | Paso interno en UC existente |
| **Cálculo** | Sí (resultado) | ❌ | Pasos en UC existente |

### 7.3. Transformaciones M2M en MDA

**Del documento MDA/MDE - ATL (Atlas Transformation Language)**:

**Estructura general**:
```atl
module NombreTransformacion;
create OUT : TargetMetamodel from IN : SourceMetamodel;

-- Regla matched (automática)
rule ClaseATabla {
    from
        c : SourceMM!Clase
    to
        t : TargetMM!Tabla (
            nombre <- c.nombre,
            columnas <- c.atributos
        )
}

-- Regla lazy (manual)
lazy rule AtributoAColumna {
    from
        a : SourceMM!Atributo
    to
        col : TargetMM!Columna (
            nombre <- a.nombre,
            tipo <- a.tipo.mapeoTipo()
        )
}

-- Helper (función auxiliar)
helper context SourceMM!Tipo def: mapeoTipo() : String =
    if self.nombre = 'String' then 'VARCHAR(255)'
    else if self.nombre = 'Integer' then 'INT'
    else 'TEXT'
    endif endif;
```

**Tipos de reglas**:

1. **Matched Rules**:
   - Se ejecutan automáticamente
   - Cuando hay coincidencia con patrón
   - Un elemento origen → Un elemento destino

2. **Lazy Rules**:
   - Se ejecutan solo cuando se invocan
   - Útiles para transformaciones condicionales
   - Invocación: `thisModule.NombreRegla(param)`

3. **Unique Lazy Rules**:
   - Como lazy pero con caching
   - Segunda invocación mismos parámetros → mismo resultado
   - No crea nuevos elementos

### 7.4. Transformaciones PIM → PSM

**Proceso general**:

```
┌─────────────────────────────────────┐
│ PIM (Platform Independent Model)    │
│ - Modelo conceptual del dominio     │
│ - Sin dependencias de plataforma    │
│ - Ejemplo: Modelo CRIO de MicroGrid │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│ TRANSFORMACIÓN T                     │
│ - Reglas de mapeo PIM → PSM         │
│ - Parametrizada por plataforma      │
│ - Ejemplo: ATL/QVT                  │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│ PSM (Platform Specific Model)       │
│ - Modelo adaptado a plataforma      │
│ - Ejemplo: Agentes Java, .NET, etc. │
└─────────────────────────────────────┘
```

**Parámetros de transformación**:
- Modelo de plataforma destino
- Configuración de usuario
- Restricciones técnicas
- Optimizaciones

**Mapeo a carpeta**: `_fundamentos_conceptuales/transformaciones/`

---

## 8. TRAZABILIDAD

### 8.1. Trazabilidad Bidireccional Integrada

**Síntesis de los 3 documentos**:

```
┌───────────────────────────────────────────────────────────┐
│ TRAZABILIDAD FORWARD (Análisis de Impacto)                │
│                                                            │
│ Pregunta: "Si X cambia, ¿qué debo actualizar?"            │
│                                                            │
│ Regulación OSHA 1910.1200                                 │
│     ↓ genera                                              │
│ BR_087: "Solo personal capacitado OSHA..."               │
│     ↓ transforma                                          │
│ UC_04: Solicitar Químico (Paso 4: Verificar capacitación)│
│     ↓ deriva                                              │
│ RF_205: "Sistema valida certificado OSHA vigente"        │
│     ↓ modela                                              │
│ Modelo PIM: Entidad "Solicitante.certificadoOSHA"        │
│     ↓ transforma                                          │
│ Modelo PSM: Clase Java "Solicitante"                     │
│     ↓ genera                                              │
│ Código: if (solicitante.hasCertificadoOSHA()) {...}      │
│                                                            │
│ Si regulación cambia → Rastrear e identificar TODO        │
└───────────────────────────────────────────────────────────┘

┌───────────────────────────────────────────────────────────┐
│ TRAZABILIDAD BACKWARD (Justificación)                     │
│                                                            │
│ Pregunta: "¿Por qué existe este código?"                  │
│                                                            │
│ Código: if (solicitante.hasCertificadoOSHA()) {...}      │
│     ↑ implementa                                          │
│ Modelo PSM: Clase Java "Solicitante"                     │
│     ↑ deriva de                                           │
│ Modelo PIM: Entidad "Solicitante.certificadoOSHA"        │
│     ↑ especifica                                          │
│ RF_205: "Sistema valida certificado OSHA vigente"        │
│     ↑ deriva de                                           │
│ UC_04: Solicitar Químico (Paso 4)                        │
│     ↑ implementa                                          │
│ BR_087: "Solo personal capacitado OSHA..."               │
│     ↑ proviene de                                         │
│ Regulación OSHA 29 CFR 1910.1200                         │
│                                                            │
│ Justificación completa desde código hasta fuente legal   │
└───────────────────────────────────────────────────────────┘
```

### 8.2. Matriz de Trazabilidad Multi-Nivel

**Estructura integrada**:

| BR | UC | RF | Modelo PIM | Modelo PSM | Código | Prueba |
|----|----|----|-----------|-----------|--------|--------|
| BR_087 | UC_04 | RF_205, RF_206 | Solicitante.certificado | SolicitanteBean.cert | validarCertificado() | testValidacion() |
| BR_028 | UC_04 | RF_207, RF_208 | Solicitud.monto | SolicitudBean.monto | verificarMonto() | testUmbral() |
| BR_045 | UC_07 | RF_301, RF_302 | Contenedor.fechaVenc | ContenedorEntity.date | notificarVencimiento() | testNotificacion() |

**Niveles de trazabilidad**:

```
Nivel 1: BR ↔ UC           (Doc 3 - BR→Sistema)
Nivel 2: UC ↔ RF           (Doc 3 - BR→Sistema)
Nivel 3: RF ↔ Modelo PIM   (Doc 1 - MDA/MDE)
Nivel 4: PIM ↔ PSM         (Doc 1 - MDA/MDE)
Nivel 5: PSM ↔ Código      (Doc 2 - CRIO/Janeiro)
Nivel 6: Código ↔ Prueba   (Implícito)
```

### 8.3. Propagación de Cambios

**Escenario completo**:

```
CAMBIO EN BR_028: Umbral $500 → $1,000

PROPAGACIÓN SISTEMÁTICA:

1. Actualizar BR_028:
   Definición: "Solicitudes >$1,000 requieren aprobación"
   
2. Actualizar UC_04 Paso 6:
   "SI monto >$1,000 ENTONCES..."
   
3. Actualizar RF_207:
   "Comparar monto con $1,000"
   
4. Actualizar Modelo PIM:
   Constraint: solicitud.monto > 1000
   
5. Actualizar Modelo PSM:
   Clase SolicitudBean: UMBRAL_APROBACION = 1000
   
6. Regenerar código:
   if (solicitud.getMonto() > 1000) { ... }
   
7. Actualizar tests:
   testUmbralAprobacion_1000()
   
8. Actualizar documentación:
   Manual usuario, ayuda en línea

BENEFICIO: Identificación sistemática de TODO lo afectado
COSTO: Tiempo de análisis (minutos)
AHORRO: Evita regresiones (semanas de debugging)
```

**Mapeo a carpeta**: `_fundamentos_conceptuales/trazabilidad/`

---

# PARTE II: ONTOLOGÍA Y TERMINOLOGÍA

## 9. ONTOLOGÍA FUNDAMENTAL

### 9.1. Categorías Ontológicas Integradas

**ENTIDAD 1: Business Rule**

```
Definición: Declaración sobre cómo opera la organización

Modo de ser: NORMATIVO
  - Prescribe (no describe)
  - Establece lo que DEBE ser
  - Independiente del sistema

Existencia: INDEPENDIENTE
  - Existe antes del sistema
  - Proviene de fuentes externas
  - Sobrevive al sistema

Origen:
  - Regulaciones (OSHA, EPA, FDA, etc.)
  - Políticas corporativas
  - Estándares industriales
  - Mejores prácticas

Cambio: LENTO
  - Controlado externamente
  - Requiere autorización (CFO, legal, etc.)
  - Impacta múltiples sistemas

Ejemplo:
  BR_028: "Solicitudes >$500 requieren aprobación gerente"
  Fuente: Política Financiera Corporativa v2.3
```

**Mapeo ontológico**:
```
BR pertenece a mundo normativo (deber-ser)
BR NO pertenece a mundo físico (ser)
BR trasciende implementaciones particulares
```

**ENTIDAD 2: User Requirement (Caso de Uso)**

```
Definición: Comportamiento observable del sistema

Modo de ser: BEHAVIORAL (descriptivo-conductual)
  - Describe comportamiento desde perspectiva usuario
  - Observable externamente
  - Interacción completa

Existencia: DEPENDIENTE de BR
  - Deriva de BR mediante transformación
  - Puede derivar de técnicas (CRUD, Larman, etc.)
  
Origen:
  - Transformación de BR (22%)
  - Análisis CRUD (40%)
  - Técnicas Larman (36%)
  - UI-Driven (9%)
  - Stakeholders (9%)

Cambio: MEDIO
  - Más frecuente que BR
  - Menos que RF
  - Sigue cambios en BR

Ejemplo:
  UC_04: Solicitar Producto Químico
  Actor: Solicitante
  Flujo: 8 pasos incluyendo validaciones
```

**Mapeo ontológico**:
```
UC pertenece a mundo behavioral (comportamiento)
UC es puente entre normativo (BR) y especificativo (RF)
UC representa interacción usuario-sistema
```

**ENTIDAD 3: Functional Requirement**

```
Definición: Especificación detallada de lo que sistema debe hacer

Modo de ser: ESPECIFICATIVO
  - Especifica con precisión
  - Nivel de detalle implementable
  - Qué debe hacer el sistema

Existencia: DEPENDIENTE de UC
  - Deriva de pasos de UC
  - Descomposición de comportamientos

Origen:
  - Derivación desde UC
  - Paso X del UC → RF_Y, RF_Z

Cambio: RÁPIDO
  - Evoluciona con tecnología
  - Ajustes frecuentes durante desarrollo
  - Refactorings

Ejemplo:
  RF_205: "Sistema compara monto con umbral $500"
  Derivado de: UC_04, Paso 6
  Implementa: BR_028
```

**Mapeo ontológico**:
```
RF pertenece a mundo especificativo (implementación)
RF es más concreto que UC
RF es puente entre UC y código
```

**ENTIDAD 4: Modelo**

```
Definición: Representación abstracta de un sistema

Modo de ser: REPRESENTACIONAL
  - Representa (no ES el sistema)
  - Abstrae características esenciales
  - Desde un punto de vista

Existencia: CONFORME a metamodelo
  - Todos los elementos del modelo ∈ conceptos del metamodelo
  - Relaciones respetan metamodelo
  - Restricciones cumplidas

Origen:
  - Modelado desde requisitos
  - Refinamiento progresivo

Cambio: MEDIO
  - Sigue evolución de requisitos
  - Validación contra metamodelo

Ejemplo:
  Modelo MicroGrid (M1)
  Conforme a: CRIO (M2)
  Representa: Sistema multi-agente para gestión energética
```

**Mapeo ontológico**:
```
Modelo pertenece a mundo representacional
Modelo ≠ Sistema (mapa ≠ territorio)
Modelo es abstracción intencional
```

**ENTIDAD 5: Metamodelo**

```
Definición: Modelo de un lenguaje de modelado

Modo de ser: DEFINITORIO
  - Define lenguaje
  - Establece qué es válido
  - Normativo para modelos

Existencia: CONFORME a MOF/Ecore
  - Todos los metamodelos conforman a M3
  - Cierre reflexivo en M3

Origen:
  - Diseño de DSL
  - Captura de conceptos del dominio

Cambio: LENTO
  - Estable (es un estándar)
  - Cambios afectan muchos modelos
  - Requiere versioning cuidadoso

Ejemplo:
  CRIO (M2)
  Conforme a: Ecore (M3)
  Define: Lenguaje para SMA organizacionales
```

**Mapeo ontológico**:
```
Metamodelo pertenece a mundo definitorio (lenguaje)
Metamodelo es modelo de segundo orden
Metamodelo establece "gramática" de modelos
```

**ENTIDAD 6: Transformación**

```
Definición: Proceso de convertir modelo en otro modelo

Modo de ser: FUNCIONAL (proceso)
  - Entrada → Salida
  - Determinístico o parametrizado
  - Preserva semántica

Existencia: ENTRE metamodelos
  - Definida desde metamodelo origen a destino
  - Reglas de mapeo

Origen:
  - Diseño de proceso
  - Especificación en ATL/QVT

Cambio: MEDIO
  - Evoluciona con metamodelos
  - Optimizaciones

Ejemplo:
  Transformación PIM → PSM
  Lenguaje: ATL
  Reglas: 15 matched rules, 5 lazy rules
```

**Mapeo ontológico**:
```
Transformación pertenece a mundo funcional (procesos)
Transformación es función entre espacios de modelos
Transformación preserva propiedades esenciales
```

### 9.2. Jerarquía Ontológica

```
NIVEL ONTOLÓGICO 1: NORMATIVO
├─ Business Rules
├─ Regulaciones
└─ Políticas

NIVEL ONTOLÓGICO 2: BEHAVIORAL  
├─ User Requirements (UC)
├─ Casos de Uso
└─ Escenarios

NIVEL ONTOLÓGICO 3: ESPECIFICATIVO
├─ Functional Requirements
├─ Especificaciones detalladas
└─ Contratos

NIVEL ONTOLÓGICO 4: REPRESENTACIONAL
├─ Modelos (PIM, PSM)
├─ Diagramas
└─ Vistas

NIVEL ONTOLÓGICO 5: DEFINITORIO
├─ Metamodelos
├─ Lenguajes
└─ Gramáticas

NIVEL ONTOLÓGICO 6: FUNCIONAL
├─ Transformaciones
├─ Procesos
└─ Algoritmos

NIVEL ONTOLÓGICO 7: MATERIAL
├─ Código
├─ Binarios
└─ Sistemas ejecutando
```

**Mapeo a carpeta**: `_ontologia_terminologia/entidades_fundamentales/`

---

## 10. TAXONOMÍA INTEGRADA

### 10.1. Taxonomía de Business Rules (5 tipos)

**Del documento BR→Sistema - Clasificación fundamental**:

```
┌─────────────────────────────────────────────────────────────┐
│ TIPO 1: HECHOS (Facts)                                       │
│                                                              │
│ Definición: Verdades sobre el dominio                        │
│ Efecto: Estructuran modelo de datos                          │
│ Ejemplo: "Cada contenedor tiene código único"                │
│ Genera: Validaciones de integridad                           │
│ Genera UC: ❌ NO                                              │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ TIPO 2: RESTRICCIONES (Constraints)                          │
│                                                              │
│ Definición: Limitaciones obligatorias                        │
│ Efecto: Qué DEBE/NO DEBE pasar                               │
│ Ejemplo: "Solo gerentes aprueban >$500"                      │
│ Genera: Precondiciones, validaciones, controles de acceso    │
│ Genera UC: ❌ NO (se integra en UC existentes)                │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ TIPO 3: DESENCADENADORES (Triggers) ⭐ CRÍTICO              │
│                                                              │
│ Definición: SI [condición] ENTONCES [COMPORTAMIENTO]         │
│ Efecto: Genera acciones OBSERVABLES externamente             │
│ Ejemplo: "SI vence químico ENTONCES notificar"               │
│ Genera: Casos de Uso COMPLETOS                               │
│ Genera UC: ✅ SÍ                                              │
│                                                              │
│ Ejemplos de comportamientos observables:                     │
│ • Enviar notificación                                        │
│ • Generar reporte                                            │
│ • Bloquear cuenta                                            │
│ • Activar alarma                                             │
│ • Crear registro auditoría                                   │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ TIPO 4: INFERENCIAS (Inferences)                             │
│                                                              │
│ Definición: SI [condición] ENTONCES [NUEVO HECHO]            │
│ Efecto: Solo cambio de estado INTERNO                        │
│ Ejemplo: "SI >30 días impago ENTONCES marcar deudor"         │
│ Genera: Lógica interna, cambios de estado                    │
│ Genera UC: ❌ NO (solo paso interno en UC existente)          │
│                                                              │
│ Ejemplos de nuevos hechos internos:                          │
│ • Marcar como VIP                                            │
│ • Clasificar como riesgoso                                   │
│ • Etiquetar como inactivo                                    │
│ • Categorizar como premium                                   │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ TIPO 5: CÁLCULOS (Computations)                              │
│                                                              │
│ Definición: Fórmulas y algoritmos                            │
│ Efecto: Transformaciones de datos                            │
│ Ejemplo: "Precio = Items - Desc + IVA + Envío"               │
│ Genera: Algoritmos específicos en pasos de UC                │
│ Genera UC: ❌ NO (se integra como pasos en UC existente)      │
└─────────────────────────────────────────────────────────────┘
```

**Test de decisión - Desencadenador vs Inferencia**:

```
┌─────────────────────────────────────────────┐
│ Business Rule con SI...ENTONCES             │
└─────────────────────────────────────────────┘
              ↓
┌─────────────────────────────────────────────┐
│ ¿El resultado es OBSERVABLE externamente?   │
│ (¿Usuario/sistema externo puede VER         │
│  que algo ocurrió?)                         │
└─────────────────────────────────────────────┘
       ↙                        ↘
    SÍ                          NO
    ↓                           ↓
┌──────────────────┐   ┌──────────────────┐
│ DESENCADENADOR   │   │ INFERENCIA       │
│ Genera UC nuevo  │   │ NO genera UC     │
└──────────────────┘   └──────────────────┘
```

**Ejemplos comparativos**:

| Business Rule | Observable | Tipo |
|--------------|-----------|------|
| SI saldo <0 ENTONCES enviar alerta | ✅ SÍ (email visible) | Desencadenador |
| SI saldo <0 ENTONCES marcar deudor | ❌ NO (flag interno) | Inferencia |
| SI pedido >$1000 ENTONCES aplicar descuento 10% | ✅ SÍ (precio cambia visible) | Desencadenador |
| SI cliente >10 compras ENTONCES etiquetar VIP | ❌ NO (etiqueta interna) | Inferencia |
| SI temperatura >100°C ENTONCES activar alarma | ✅ SÍ (alarma observable) | Desencadenador |
| SI temperatura >100°C ENTONCES clasificar peligroso | ❌ NO (clasificación interna) | Inferencia |

**Mapeo a carpeta**: `_taxonomias_y_metamodelos/taxonomias/taxonomia_br/`

### 10.2. Taxonomía de Transformaciones

**Del documento MDA/MDE**:

**Por dirección**:
```
HORIZONTALES:
  - Mismo nivel de abstracción
  - Ejemplo: Refactoring de modelos
  - Ejemplo: Optimización de diagramas

VERTICALES:
  - Cambian nivel de abstracción
  - Ejemplo: PIM → PSM
  - Ejemplo: PSM → Código
```

**Por tipo de fuente/destino**:
```
M2M (Model-to-Model):
  - Origen: Modelo
  - Destino: Modelo
  - Lenguajes: ATL, QVT, ETL
  - Ejemplo: UML → Ecore

M2T (Model-to-Text):
  - Origen: Modelo
  - Destino: Texto/Código
  - Lenguajes: Acceleo, Xtend
  - Ejemplo: UML → Java

T2M (Text-to-Model):
  - Origen: Texto/Código
  - Destino: Modelo
  - Uso: Ingeniería inversa
  - Ejemplo: Java → UML
```

**Por metamodelos**:
```
ENDÓGENAS (in-place):
  - Mismo metamodelo origen y destino
  - Ejemplo: Optimizar diagrama UML → UML mejorado
  - Uso: Refactorings, normalizaciones

EXÓGENAS:
  - Diferente metamodelo origen y destino
  - Ejemplo: UML → RDBMS
  - Uso: Transformaciones inter-dominio
```

**Taxonomía integrada BR→Sistema**:
```
TRANSFORMACIÓN BR→UC:
  - Origen: Business Rule (texto)
  - Destino: User Requirement (caso de uso)
  - Método: 5 patrones
  - Tipo: T2M + interpretación semántica

DERIVACIÓN UC→RF:
  - Origen: User Requirement (caso de uso)
  - Destino: Functional Requirement (especificación)
  - Método: Descomposición de pasos
  - Tipo: M2M (mismo dominio, mayor detalle)
```

**Mapeo a carpeta**: `_taxonomias_y_metamodelos/taxonomias/taxonomia_transformaciones/`

### 10.3. Taxonomía de Validaciones

```
┌──────────────────────────────────────────────────────────┐
│ VALIDACIÓN SINTÁCTICA                                     │
│                                                           │
│ Qué valida: Estructura correcta del modelo                │
│ Nivel: Conformidad con metamodelo                        │
│ Lenguajes: EVL (Epsilon), validadores EMF                │
│ Ejemplo (CRIO): 8 reglas EVL                             │
│   1. Existencia de roles en organización                 │
│   2. Unicidad de nombres                                 │
│   3. Cardinalidades correctas                            │
│   4. Referencias válidas                                 │
│   5. Atributos obligatorios presentes                    │
│   6. Tipos compatibles                                   │
│   7. Consistencia de relaciones                          │
│   8. Completitud del modelo                              │
│                                                           │
│ Cuándo se ejecuta: Durante modelado, pre-transformación  │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│ VALIDACIÓN SEMÁNTICA                                      │
│                                                           │
│ Qué valida: Restricciones y reglas del dominio           │
│ Nivel: Cumplimiento de invariantes                       │
│ Lenguajes: OCL (Object Constraint Language)             │
│ Ejemplo (Sistema bancario):                              │
│   context Cuenta                                         │
│     inv saldoPositivo: self.saldo >= 0                   │
│     inv limiteDiario: self.retirosDia()->sum() <= 5000   │
│                                                           │
│ Cuándo se ejecuta: Validación continua, pre-persistencia │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│ VALIDACIÓN DE NEGOCIO                                     │
│                                                           │
│ Qué valida: Cumplimiento de Business Rules               │
│ Nivel: Conformidad con regulaciones/políticas            │
│ Método: Trazabilidad BR → UC → RF → Código               │
│ Ejemplo:                                                  │
│   BR_087: "Solo personal capacitado OSHA..."             │
│   Validación: ¿Código implementa verificación OSHA?      │
│   Método: Auditoría de trazabilidad backward             │
│                                                           │
│ Cuándo se ejecuta: Auditorías, certificaciones           │
└──────────────────────────────────────────────────────────┘
```

**Relación entre niveles**:

```
Validación Sintáctica → Base fundamental
    ↓ (si pasa)
Validación Semántica → Restricciones correctas
    ↓ (si pasa)
Validación Negocio → Cumplimiento BR
```

**Mapeo a carpeta**: `_taxonomias_y_metamodelos/taxonomias/taxonomia_validaciones/`

### 10.4. Taxonomía de Casos de Uso

**Por origen** (del documento BR→Sistema):

```
┌──────────────────────────────────────────────────────────┐
│ ORIGEN 1: DERIVADOS DE BR (22%)                           │
│                                                           │
│ Fuente: Business Rules tipo Desencadenador               │
│ Método: Transformación con patrón 3                      │
│ Características:                                          │
│ • Actor frecuentemente: Sistema (batch, scheduled)       │
│ • Desencadenador: Evento temporal, condición             │
│ • Críticos para cumplimiento                             │
│                                                           │
│ Ejemplos:                                                 │
│ • UC-07: Notificar Vencimiento Químico                   │
│ • UC-12: Bloquear Cuenta Inactiva                        │
│ • UC-18: Generar Reporte Auditoría                       │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│ ORIGEN 2: CRUD (40%)                                      │
│                                                           │
│ Fuente: Entidades del modelo de dominio                  │
│ Método: Análisis sistemático de entidades                │
│ Reglas de decisión:                                       │
│ • Maestros: C+R+U+D(lógico)                              │
│ • Transaccionales: C+R (no U, no D)                      │
│ • Técnicas: Automático                                   │
│                                                           │
│ Ejemplos:                                                 │
│ • UC-10: Gestionar Productos Químicos (CRUD completo)    │
│ • UC-20: Registrar Solicitud (solo C)                    │
│ • UC-30: Consultar Inventario (solo R)                   │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│ ORIGEN 3: LARMAN (36%)                                    │
│                                                           │
│ Fuente: Análisis de eventos, operaciones, responsabilidades│
│ Subtécnicas:                                              │
│ • 2.1. Eventos del sistema                               │
│ • 2.2. Operaciones del sistema                           │
│ • 2.3. Responsabilidades del sistema                     │
│                                                           │
│ Ejemplos:                                                 │
│ • UC-15: Buscar Producto (operación de consulta)         │
│ • UC-21: Procesar Pago (operación de comando)            │
│ • UC-25: Configurar Parámetros (operación de config)     │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│ ORIGEN 4: UI-DRIVEN (9%)                                  │
│                                                           │
│ Fuente: Mockups de interfaz de usuario                   │
│ Método: Identificar interacciones significativas          │
│ Criterio: ¿Requiere lógica de negocio significativa?     │
│                                                           │
│ Ejemplos:                                                 │
│ • UC-40: Filtrar y Buscar con múltiples criterios        │
│ • UC-41: Exportar a Excel                                │
│ • UC-42: Visualizar Dashboard                            │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│ ORIGEN 5: STAKEHOLDERS (9%)                               │
│                                                           │
│ Fuente: Entrevistas directas con interesados              │
│ Método: Preguntas específicas                            │
│ Enfoque: Necesidades particulares, reportes, análisis    │
│                                                           │
│ Ejemplos:                                                 │
│ • UC-50: Generar Reporte Semanal Vencimientos            │
│ • UC-51: Visualizar Mapa Inventario Peligroso            │
│ • UC-52: Exportar Datos Auditoría Externa                │
└──────────────────────────────────────────────────────────┘
```

**Distribución típica** (sistema de 45 UC):
```
BR:            10 UC (22%)  ←  Críticos para cumplimiento
CRUD:          18 UC (40%)  ←  Mantenimiento básico
Larman:        16 UC (36%)  ←  Operaciones del sistema
UI-Driven:      4 UC (9%)   ←  Usabilidad avanzada
Stakeholders:   4 UC (9%)   ←  Necesidades específicas
──────────────────────────
Total (bruto): 52 UC
Consolidado:   45 UC (100%)
```

**Por tipo de actor**:
```
ACTOR HUMANO:
  - Usuario final
  - Administrador
  - Gerente
  - Auditor

ACTOR SISTEMA:
  - Sistema externo
  - Servicio web
  - API
  - Integración

ACTOR TIEMPO:
  - Proceso batch (diario, semanal)
  - Evento temporal
  - Scheduler
```

**Mapeo a carpeta**: `_taxonomias_y_metamodelos/taxonomias/taxonomia_uc/`

---

## 11. GLOSARIO UNIFICADO

### 11.1. Términos de MDA/MDE

**MBE (Model-Based Engineering)**
```
Definición: Término general para enfoques que usan modelos en procesos/actividades
Alcance: Más amplio que MDE
Incluye: MDE, MDA, MDD, BPM, etc.
Diferencia con MDE: Modelos pueden no ser "motores" del proceso
```

**MDE (Model-Driven Engineering)**
```
Definición: Paradigma que usa modelos y transformaciones como piezas clave 
            para dirigir TODAS las actividades de ingeniería software
Alcance: Más amplio que MDD
Incluye: Desarrollo, mantenimiento, evolución, análisis, reingeniería
Diferencia con MDD: MDE cubre toda ingeniería, MDD solo desarrollo
```

**MDD (Model-Driven Development)**
```
Definición: Paradigma que usa modelos para diseñar a distintos niveles de 
            abstracción y transformaciones para generar código
Alcance: Específico de desarrollo
Enfoque: Descendente (top-down)
Diferencia con MDE: Solo cubre actividades de desarrollo
```

**MDA (Model-Driven Architecture)**
```
Definición: Propuesta concreta de OMG para implementar MDD usando 
            estándares OMG
Alcance: Implementación específica de MDD
Estándares: UML, MOF, OCL, QVT, XMI
Organización: OMG (Object Management Group)
```

**Relación**:
```
MBE ⊃ MDE ⊃ MDD ⊃ MDA

MBE: "Usar modelos en procesos"
MDE: "Modelos dirigen procesos"
MDD: "Modelos dirigen desarrollo"
MDA: "MDD con estándares OMG"
```

**PIM (Platform Independent Model)**
```
Definición: Modelo de sistema independiente de cualquier plataforma
Características:
  - Conceptual
  - No asume tecnología específica
  - Reusable para múltiples plataformas
Ejemplo: Modelo de dominio en UML sin detalles de Java/.NET
```

**PSM (Platform Specific Model)**
```
Definición: Modelo adaptado a plataforma concreta
Origen: Transformación de PIM
Características:
  - Específico de tecnología
  - Incluye detalles de plataforma
  - Preparado para generación de código
Ejemplo: Modelo con anotaciones JPA para persistencia Java
```

**DSL (Domain-Specific Language)**
```
Definición: Lenguaje específico de dominio que proporciona conceptos y 
            notaciones propias del dominio
Componentes:
  - Sintaxis abstracta (metamodelo)
  - Sintaxis concreta (notación)
  - Semántica (significado)
Ejemplo: CRIO (DSL para SMA), BPMN (DSL para procesos)
```

**M2M, M2T, T2M**
```
M2M (Model-to-Model):
  - Transformación entre modelos
  - Lenguajes: ATL, QVT, ETL
  
M2T (Model-to-Text):
  - Generación de código desde modelo
  - Lenguajes: Acceleo, Xtend
  
T2M (Text-to-Model):
  - Ingeniería inversa
  - Parsers, extractores
```

### 11.2. Términos de BR → Sistema

**Business Rule (BR)**
```
Definición: Declaración sobre cómo opera la organización
Fuentes: Regulaciones, políticas, estándares
Tipos: Hecho, Restricción, Desencadenador, Inferencia, Cálculo
Característica: Externa al sistema, obligatoria, estable
```

**User Requirement (UR / UC)**
```
Definición: Comportamiento observable del sistema
Formato: Casos de Uso (Use Cases)
Componentes: Actor, objetivo, flujo normal, alternos, excepcionales
Origen: Transformación de BR + técnicas adicionales
```

**Functional Requirement (RF)**
```
Definición: Especificación detallada de lo que sistema debe hacer
Origen: Derivación de pasos de UC
Nivel: Implementable directamente
Granularidad: Más fino que UC
```

**Desencadenador vs Inferencia**
```
Desencadenador:
  - SI [condición] ENTONCES [COMPORTAMIENTO OBSERVABLE]
  - Genera UC completo
  - Ejemplo: "SI vence ENTONCES notificar"

Inferencia:
  - SI [condición] ENTONCES [NUEVO HECHO INTERNO]
  - NO genera UC
  - Ejemplo: "SI >30 días ENTONCES marcar deudor"
  
Criterio de distinción: ¿Observable externamente?
```

**CRUD**
```
Definición: Create, Read, Update, Delete
Uso: Identificar UC de mantenimiento desde entidades
Reglas:
  - Maestros: C+R+U+D(lógico)
  - Transaccionales: C+R
  - Técnicas: Automático
```

**Técnicas Larman**
```
Definición: 3 subtécnicas para identificar UC
  1. Eventos del sistema
  2. Operaciones del sistema
  3. Responsabilidades del sistema
Origen: Craig Larman, "Applying UML and Patterns"
Cobertura: ~36% de UC típicamente
```

### 11.3. Términos de CRIO

**Organization**
```
Definición: Estructura colectiva que contiene roles
Propiedades: nombre, descripción
Relaciones: Contiene roles [1..*]
Ejemplo: OrganizaciónMicroGrid
```

**Role**
```
Definición: Comportamiento esperado en la organización
Propiedades: nombre, descripción
Relaciones: Requiere capacidades [0..*], participa en protocolos
Ejemplo: RoleGenerador, RoleConsumidor
```

**Capacity**
```
Definición: Know-how, servicio que un rol puede proporcionar
Propiedades: nombre, tipo, parámetros
Uso: Representa habilidades de roles
Ejemplo: CapacityGenerarEnergía, CapacityAlmacenar
```

**Protocol**
```
Definición: Secuencia de interacciones entre roles
Propiedades: nombre, participantes
Relaciones: Contiene interacciones [1..*]
Ejemplo: ProtocolNegociaciónEnergía
```

**Interaction**
```
Definición: Evento individual en un protocolo
Propiedades: emisor, receptor, mensaje
Orden: Secuencial dentro de protocolo
```

**EVL (Epsilon Validation Language)**
```
Definición: Lenguaje de validación de Epsilon
Características:
  - Modular (constraints independientes)
  - Mensajes personalizables
  - Quick fixes dinámicos
  - Más flexible que OCL para herramientas CASE
```

### 11.4. Términos Comunes

**Trazabilidad**
```
Definición: Capacidad de rastrear relaciones entre elementos
Tipos:
  - Forward: Análisis de impacto
  - Backward: Justificación
Implementación: Matrices, herramientas, metadatos
```

**Conformidad**
```
Definición: Relación entre modelo y metamodelo
Significado: Modelo respeta todas las reglas del metamodelo
Verificación: Validación sintáctica y semántica
```

**Validación**
```
Definición: Verificación de corrección de modelo
Niveles:
  - Sintáctica: Estructura
  - Semántica: Restricciones
  - Negocio: Business Rules
```

**Mapeo a carpeta**: `_ontologia_terminologia/glosario/`

---

## 12. RELACIONES ONTOLÓGICAS

### 12.1. Relación de Conformidad

```
DEFINICIÓN FORMAL:

Modelo M conforme a Metamodelo MM sii:
  ∀e ∈ M : ∃c ∈ MM tal que e es instancia de c
  ∀r ∈ relaciones(M) : r cumple definición en MM
  ∀ inv ∈ restricciones(MM) : M satisface inv

En lenguaje natural:
  - Todos los elementos de M son de tipos definidos en MM
  - Todas las relaciones de M son válidas según MM
  - Todas las restricciones de MM se cumplen en M
```

**Ejemplos**:

```
Ejemplo 1:
  Modelo MicroGrid (M1) conforme a CRIO (M2)
  Verificación:
    - Organización "OrganizaciónMG" ∈ Organization (CRIO)
    - Todos los roles ∈ Role (CRIO)
    - Relaciones Organization ⊃ Role cumplidas
    - 8 reglas EVL satisfechas

Ejemplo 2:
  CRIO (M2) conforme a Ecore (M3)
  Verificación:
    - Organization definida como EClass
    - Todas las relaciones definidas como EReference
    - Estructura válida en Ecore
```

**Propiedad transitiva**:
```
Si M conforme a MM y MM conforme a MMM
Entonces M transitivamente conforme a MMM

Ejemplo:
  MicroGrid conforme a CRIO
  CRIO conforme a Ecore
  ⇒ MicroGrid transitivamente conforme a Ecore
```

### 12.2. Relación de Generación

```
DEFINICIÓN:

BR genera UR mediante transformación con patrones

Notación: BR →[patrón_i]→ UR

Características:
  - No automática (requiere interpretación humana)
  - Usa 5 patrones de transformación
  - Condicional (solo Desencadenadores generan UC completos)
```

**Ejemplos**:

```
BR_045 (Desencadenador) →[patrón_3]→ UC_07
  Entrada: "SI vence ENTONCES notificar"
  Salida: UC completo de notificación
  
BR_028 (Restricción) →[patrón_2]→ Paso en UC_04
  Entrada: "Solicitudes >$500 requieren aprobación"
  Salida: Flujo alterno en UC existente
```

**Cardinalidad**:
```
1 BR → 0..* UC
  - Hechos: 0 UC (solo modelo dominio)
  - Restricciones: 0 UC (pasos en existentes)
  - Desencadenadores: 1 UC (nuevo completo)
  - Inferencias: 0 UC (lógica interna)
  - Cálculos: 0 UC (pasos en existentes)
```

### 12.3. Relación de Derivación

```
DEFINICIÓN:

UC deriva RF mediante descomposición de pasos

Notación: UC →[descomposición]→ RF*

Características:
  - Sistemática (cada paso → múltiples RF)
  - Incrementa nivel de detalle
  - Mantiene trazabilidad
```

**Ejemplo**:

```
UC_04, Paso 6: "Sistema verifica monto"

Deriva en:
  RF_205: "Comparar monto con umbral"
  RF_206: "SI monto > umbral ENTONCES solicitar aprobación"
  RF_207: "Identificar gerente del departamento"
  RF_208: "Enviar notificación a gerente"
  RF_209: "Registrar timestamp de cambio de estado"
```

**Cardinalidad**:
```
1 Paso UC → 1..* RF

Típicamente:
  - Paso simple: 1-2 RF
  - Paso complejo: 3-7 RF
  - Flujo alterno: 5-10 RF
```

### 12.4. Relación de Implementación

```
DEFINICIÓN:

RF implementa mediante código ejecutable

Notación: RF →[coding]→ Código

Características:
  - Múltiples implementaciones posibles
  - Decisiones de diseño intervienen
  - Lenguaje de programación específico
```

**Ejemplo**:

```
RF_205: "Comparar monto con umbral $500"

Implementaciones posibles:
  Java:   if (solicitud.getMonto() > 500) { ... }
  Python: if solicitud.monto > 500: ...
  C#:     if (solicitud.Monto > 500) { ... }

Todas válidas, diferentes sintaxis
```

**Cardinalidad**:
```
1 RF → 1..* Implementaciones
  (dependiendo de plataforma, refactorings, etc.)
```

### 12.5. Relación de Influencia

```
DEFINICIÓN:

BR influye múltiples aspectos del sistema simultáneamente

Notación: BR ⇢ {Business Req, UR, RF, QA, EI, Constraints}

Características:
  - No determinística (influye, no determina)
  - Múltiples targets
  - Impacto transversal
```

**Ejemplo**:

```
BR_028: "Solicitudes >$500 requieren aprobación"

Influye en:
  - Business Requirements: Justifica módulo de aprobaciones
  - UC_04: Genera flujo alterno
  - RF_205-209: Múltiples requerimientos
  - QA-12: "Notificar en <5 segundos"
  - EI-05: Interface con sistema de email
  - Constraint: Sistema debe soportar workflow
```

### 12.6. Diagrama de Relaciones Integrado

```
┌─────────────────────────────────────────────────────────┐
│ REGULACIÓN EXTERNA                                       │
│ (ej. OSHA 1910.1200)                                    │
└─────────────────────────────────────────────────────────┘
              ↓ proviene de
┌─────────────────────────────────────────────────────────┐
│ BUSINESS RULE (BR)                                       │
│ BR_087: "Solo personal capacitado OSHA..."              │
└─────────────────────────────────────────────────────────┘
       ↓ genera             ↘ influye
┌──────────────────┐   ┌──────────────────┐
│ USER REQUIREMENT │   │ BUSINESS REQ     │
│ UC_04            │   │ (justificación)  │
└──────────────────┘   └──────────────────┘
       ↓ deriva
┌──────────────────┐
│ FUNCTIONAL REQ   │
│ RF_205, RF_206   │
└──────────────────┘
       ↓ modela
┌──────────────────┐
│ MODELO PIM       │
│ (Ecore/UML)      │
└──────────────────┘
       ↓ conforme a
┌──────────────────┐
│ METAMODELO       │
│ (CRIO, UML)      │
└──────────────────┘
       ↓ transforma
┌──────────────────┐
│ MODELO PSM       │
│ (específico)     │
└──────────────────┘
       ↓ implementa
┌──────────────────┐
│ CÓDIGO           │
│ (Java, C#, etc.) │
└──────────────────┘
```

**Mapeo a carpeta**: `_ontologia_terminologia/relaciones_ontologicas/`

---

(Continuará en archivo PARTE 3 para completar secciones 13-26)

