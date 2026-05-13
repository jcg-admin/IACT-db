# Implementación de Scripts de Trazabilidad

**Documento**: Reporte de Implementación
**Fecha**: 2025-11-17
**Basado en**: ADR-GOB-009 - Trazabilidad entre Artefactos de Requisitos
**Estado**: ✅ Completado

---

## Resumen Ejecutivo

Se han implementado exitosamente 2 scripts completos para gestión de trazabilidad de requisitos:

1. **validar-trazabilidad.sh** (Bash) - Validación de integridad
2. **generar-matriz-trazabilidad.py** (Python) - Generación de matrices

Ambos scripts son funcionales, robustos, y cumplen con todas las especificaciones del ADR-GOB-009.

---

## 1. validar-trazabilidad.sh

### Ubicación
```
/home/user/IACT---project/scripts/validar-trazabilidad.sh
```

### Características Implementadas

✅ **Extracción de IDs**
- Busca IDs en frontmatter (campo `id:`)
- Busca IDs en nombre de archivo
- Busca IDs en títulos markdown
- Patrón: `TIPO-DOMINIO-###`

✅ **Validación de Formato**
- Tipos válidos: RN, RNEG, UC, RF, RNF
- Dominios válidos: BACK, FRONT, DEVOPS, QA, AI, GOB
- Números: 001-999

✅ **Detección de Problemas**
- Referencias rotas (IDs mencionados que no existen)
- IDs duplicados (mismo ID en múltiples archivos)
- Artefactos huérfanos (sin referencias entrantes)
- Artefactos sin referencias salientes (UC/RF sin trazabilidad)

✅ **Features Adicionales**
- Modo verbose (`-v`)
- Directorio personalizable (`-d`)
- Colores en terminal (desactivables con `--no-color`)
- Exit codes apropiados (0=OK, 1=ERROR, 2=USO_INCORRECTO)
- Mensaje de ayuda (`--help`)

### Tecnología

- **Lenguaje**: Bash 4+
- **Dependencias**: Solo comandos estándar (grep, find, sed)
- **Compatible con**: Linux, macOS, WSL
- **Tamaño**: 14 KB
- **Líneas de código**: ~400

### Output de Ejemplo

```
Validando trazabilidad de requisitos...

[OK] IDs existentes encontrados: 6
[OK] Referencias totales encontradas: 36

[ERROR] Referencia rota: UC-BACK-003 mencionado en RNF-BACK-005 pero no existe
[WARNING] Artefacto huérfano: UC-FRONT-001 - no hay referencias desde otros

═══════════════════════════════════════════════════════════
           REPORTE DE VALIDACIÓN DE TRAZABILIDAD
═══════════════════════════════════════════════════════════

IDs únicos encontrados:      6
Referencias verificadas:     36
IDs duplicados:              0
Artefactos huérfanos:        1
Sin referencias salientes:   1

✗ Resultado: FALLIDO
  Total de errores: 17
  Total de warnings: 9
```

### Casos de Prueba Ejecutados

| Caso | Descripción | Resultado |
|------|-------------|-----------|
| TC-01 | Detectar IDs válidos | ✅ PASS - Detectó 6 IDs válidos |
| TC-02 | Detectar IDs inválidos | ✅ PASS - Reportó 7 warnings |
| TC-03 | Detectar referencias rotas | ✅ PASS - Encontró 16 rotas |
| TC-04 | Detectar huérfanos | ✅ PASS - Encontró 1 huérfano |
| TC-05 | Detectar sin refs salientes | ✅ PASS - Encontró 1 sin refs |
| TC-06 | Modo verbose | ✅ PASS - Mostró detalles |
| TC-07 | Sin colores | ✅ PASS - Output sin ANSI |
| TC-08 | Help message | ✅ PASS - Mensaje completo |

---

## 2. generar-matriz-trazabilidad.py

### Ubicación
```
/home/user/IACT---project/scripts/generar-matriz-trazabilidad.py
```

### Características Implementadas

✅ **Construcción de Grafo**
- Parseo de archivos markdown
- Extracción de IDs y referencias
- Construcción de grafo bidireccional
- Tracking de referencias entrantes y salientes

✅ **Tipos de Matrices**

**1. Matriz Vertical**
- Cadena completa: RN → RNEG → UC → RF → RNF
- Filtrable por dominio
- Estadísticas por tipo
- Detalles de cada artefacto

**2. Matriz Horizontal**
- Análisis de un artefacto específico
- Referencias salientes (qué referencia)
- Referencias entrantes (quién lo referencia)
- Cadena ascendente (por qué existe)
- Cadena descendente (qué implementa)

**3. Matriz de Dominio**
- Análisis completo de un dominio
- Resumen ejecutivo
- Tabla de contenidos
- Artefactos por tipo
- Análisis de cobertura

✅ **Análisis Avanzado**
- Navegación jerárquica (ascendente/descendente)
- Detección de artefactos sin referencias
- Conteo de relaciones por artefacto
- Identificación de referencias rotas

✅ **Features Adicionales**
- Output a archivo o stdout
- Solo stdlib Python (sin deps externas)
- Manejo robusto de errores
- Docstrings completos
- Type hints en funciones críticas

### Tecnología

- **Lenguaje**: Python 3.8+
- **Dependencias**: Solo stdlib (pathlib, re, argparse, datetime)
- **Compatible con**: Cualquier sistema con Python 3.8+
- **Tamaño**: 23 KB
- **Líneas de código**: ~600

### Outputs de Ejemplo

#### Matriz Vertical

```markdown
| RN | RNEG | UC | RF | RNF |
|----|------|----|----|-----|
| RN-BACK-001 | RNEG-BACK-001 | UC-BACK-001 | RF-BACK-010 | RNF-BACK-005 |
```

#### Matriz Horizontal

```markdown
# Matriz de Trazabilidad: UC-BACK-001

## Referencias Salientes
- RF-BACK-010: Validar Credenciales
- RN-BACK-001: Usuario Debe Estar Autenticado

## Referencias Entrantes
- RNEG-BACK-001: Sistema de Autenticación Seguro

## Cadena Ascendente (Por qué existe)
- RN-BACK-001: Usuario Debe Estar Autenticado

## Cadena Descendente (Qué implementa)
- RF-BACK-010: Validar Credenciales
```

#### Matriz de Dominio

```markdown
# Matriz de Trazabilidad - Dominio BACK

## Resumen Ejecutivo

| Tipo | Cantidad | Descripción |
|------|----------|-------------|
| RN | 1 | Reglas de Negocio |
| RNEG | 1 | Requerimientos de Negocio |
| UC | 1 | Casos de Uso |
| RF | 1 | Requisitos Funcionales |
| RNF | 1 | Atributos de Calidad |

## Análisis de Cobertura

### Artefactos Sin Referencias Salientes
*Todos los artefactos tienen referencias salientes.*

### Artefactos Sin Referencias Entrantes (Huérfanos)
*Todos los artefactos tienen referencias entrantes.*
```

### Casos de Prueba Ejecutados

| Caso | Descripción | Resultado |
|------|-------------|-----------|
| TC-09 | Escanear archivos | ✅ PASS - 19 archivos, 6 IDs |
| TC-10 | Construir grafo | ✅ PASS - 30 referencias |
| TC-11 | Matriz vertical | ✅ PASS - Output correcto |
| TC-12 | Matriz horizontal | ✅ PASS - Cadenas OK |
| TC-13 | Matriz dominio | ✅ PASS - Archivo generado |
| TC-14 | Detectar refs rotas | ✅ PASS - Marca "no encontrado" |
| TC-15 | Análisis cobertura | ✅ PASS - Detectó sin refs |
| TC-16 | Help message | ✅ PASS - Mensaje completo |

---

## Archivos de Prueba Creados

Para validar los scripts, se crearon 6 archivos de ejemplo en:
```
docs/gobernanza/requisitos/ejemplos_test/
```

### Archivos Creados

1. **RN-BACK-001-autenticacion-requerida.md**
   - Tipo: Regla de Negocio
   - Referencias: RNEG-BACK-001, UC-BACK-001, UC-BACK-003, RF-BACK-010, RF-BACK-011, RNF-BACK-005, RNF-BACK-007

2. **RNEG-BACK-001-sistema-autenticacion.md**
   - Tipo: Requerimiento de Negocio
   - Referencias: RN-BACK-001, RN-BACK-002, UC-BACK-001-004

3. **UC-BACK-001-iniciar-sesion.md**
   - Tipo: Caso de Uso
   - Referencias: RN-BACK-001, RN-BACK-028, RNEG-BACK-001, RF-BACK-010-012, RNF-BACK-005-007

4. **RF-BACK-010-validar-credenciales.md**
   - Tipo: Requisito Funcional
   - Referencias: UC-BACK-001, RN-BACK-001, RNF-BACK-006

5. **RNF-BACK-005-longitud-contrasena.md**
   - Tipo: Atributo de Calidad
   - Referencias: UC-BACK-001, UC-BACK-003, UC-BACK-004, RN-BACK-001, RF-BACK-015

6. **UC-FRONT-001-ejemplo-sin-referencias.md**
   - Tipo: Caso de Uso (huérfano intencional)
   - Referencias: ninguna

### Matriz de Trazabilidad de Prueba

```
RN-BACK-001
    ↓ referenciado por
RNEG-BACK-001
    ↓ referenciado por
UC-BACK-001
    ↓ referenciado por
RF-BACK-010
    ↓ cumple
RNF-BACK-005
```

---

## Documentación Creada

### 1. README de Scripts
**Ubicación**: `/home/user/IACT---project/scripts/trazabilidad/README.md`

**Contenido**:
- Arquitectura del sistema
- Guías de uso detalladas
- Ejemplos de comandos
- Integración con CI/CD
- Casos de uso comunes
- Troubleshooting

**Tamaño**: 12 KB

### 2. Este Documento
**Ubicación**: `/home/user/IACT---project/docs/gobernanza/trazabilidad/IMPLEMENTACION_SCRIPTS.md`

**Contenido**:
- Reporte de implementación
- Casos de prueba
- Evidencias de funcionamiento

---

## Limitaciones y Suposiciones

### Limitaciones Conocidas

1. **Formato de Referencias**
   - Solo detecta IDs en formato exacto TIPO-DOMINIO-###
   - No detecta referencias en comentarios HTML
   - No procesa tablas complejas

2. **Rendimiento**
   - Script bash puede ser lento con > 1000 archivos
   - Script Python mantiene todo en memoria

3. **Validaciones**
   - No valida contenido semántico
   - No verifica que las relaciones sean lógicas
   - No detecta relaciones circulares

### Suposiciones

1. **Archivos Markdown**
   - Todos los artefactos están en archivos .md
   - IDs están en frontmatter, nombre, o título
   - UTF-8 encoding

2. **Estructura de Directorios**
   - Directorio base: `docs/gobernanza/requisitos/`
   - Estructura puede ser anidada

3. **IDs Únicos**
   - Un archivo = un artefacto
   - Un artefacto = un ID único
   - IDs no se reutilizan

---

## Mejoras Futuras Posibles

### Corto Plazo

1. **Cache de Resultados**
   - Almacenar grafo en JSON para evitar re-parsing
   - Invalidar cache solo si archivos cambian

2. **Visualización Gráfica**
   - Generar diagramas con Graphviz/Mermaid
   - SVG interactivos

3. **Métricas Adicionales**
   - Densidad de trazabilidad
   - Artefactos más referenciados
   - Profundidad de cadenas

### Largo Plazo

1. **Base de Datos**
   - Almacenar trazabilidad en SQLite
   - Queries más eficientes

2. **Web UI**
   - Interfaz web para explorar trazabilidad
   - Navegación interactiva

3. **Integración con IDEs**
   - Plugin VSCode para navegar referencias
   - Auto-completado de IDs

---

## Conclusiones

### Logros

✅ Ambos scripts implementados completamente
✅ Todas las funcionalidades del ADR-GOB-009 cubiertas
✅ Sin dependencias externas
✅ Código limpio y documentado
✅ Manejo robusto de errores
✅ Tests exitosos

### Cumplimiento con ADR-GOB-009

| Requisito ADR | Estado | Notas |
|---------------|--------|-------|
| Sistema de IDs únicos | ✅ | Patrón TIPO-DOMINIO-### |
| Referencias bidireccionales | ✅ | Detecta ambas direcciones |
| Validación automática | ✅ | Script bash completo |
| Generación de matrices | ✅ | Script Python 3 tipos |
| Detección de referencias rotas | ✅ | Reportadas como ERROR |
| Identificación de huérfanos | ✅ | Reportados como WARNING |
| Análisis de cobertura | ✅ | En matriz de dominio |

### Recomendaciones

1. **Adopción Gradual**
   - Empezar con módulos pequeños
   - Validar manualmente primeras matrices
   - Iterar basado en feedback

2. **Integración CI/CD**
   - Agregar validación en pre-commit hooks
   - Ejecutar en GitHub Actions
   - Bloquear PRs con errores

3. **Mantenimiento**
   - Revisar mensajes de warnings
   - Actualizar artefactos rotos
   - Generar matrices periódicamente

---

## Anexos

### A. Comandos de Prueba Ejecutados

```bash
# 1. Validación estándar
./scripts/validar-trazabilidad.sh

# 2. Validación verbose
./scripts/validar-trazabilidad.sh -v

# 3. Matriz vertical
python3 scripts/generar-matriz-trazabilidad.py --tipo vertical --dominio BACK

# 4. Matriz horizontal
python3 scripts/generar-matriz-trazabilidad.py --tipo horizontal --id UC-BACK-001

# 5. Matriz de dominio
python3 scripts/generar-matriz-trazabilidad.py \
  --tipo dominio --dominio BACK \
  --output docs/gobernanza/trazabilidad/matrices/MATRIZ-BACK-autenticacion.md

# 6. Help de scripts
./scripts/validar-trazabilidad.sh --help
python3 scripts/generar-matriz-trazabilidad.py --help
```

### B. Estructura de Archivos Generados

```
IACT---project/
├── scripts/
│   ├── validar-trazabilidad.sh           (14 KB, ejecutable)
│   ├── generar-matriz-trazabilidad.py    (23 KB, ejecutable)
│   └── trazabilidad/
│       └── README.md                     (12 KB)
├── docs/
│   └── gobernanza/
│       ├── requisitos/
│       │   └── ejemplos_test/            (6 archivos .md de prueba)
│       │       ├── RN-BACK-001-autenticacion-requerida.md
│       │       ├── RNEG-BACK-001-sistema-autenticacion.md
│       │       ├── UC-BACK-001-iniciar-sesion.md
│       │       ├── RF-BACK-010-validar-credenciales.md
│       │       ├── RNF-BACK-005-longitud-contrasena.md
│       │       └── UC-FRONT-001-ejemplo-sin-referencias.md
│       └── trazabilidad/
│           ├── IMPLEMENTACION_SCRIPTS.md (este documento)
│           └── matrices/
│               └── MATRIZ-BACK-autenticacion.md
```

### C. Referencias

- **ADR-GOB-009**: `/home/user/IACT---project/docs/gobernanza/adr/ADR-GOB-009-trazabilidad-artefactos-requisitos.md`
- **Scripts**: `/home/user/IACT---project/scripts/`
- **Docs**: `/home/user/IACT---project/scripts/trazabilidad/README.md`

---

**Documento generado**: 2025-11-17 08:00:00
**Autor**: Claude Code (Sonnet 4.5)
**Versión**: 1.0.0
