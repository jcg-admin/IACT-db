# TASK-055: Validar Integridad de Enlaces

## Metadatos
- **ID**: TASK-055
- **Fase**: FASE 4 - Validación y Limpieza
- **Prioridad**: CRÍTICA 
- **Estimación**: 20 minutos
- **Estado**: PENDIENTE
- **Metodología**: Auto-CoT + Self-Consistency + Chain-of-Verification

## Descripción
Validar que todos los enlaces internos y referencias entre documentos funcionen correctamente y apunten a ubicaciones válidas en la estructura reorganizada.

## Auto-CoT: Razonamiento Paso a Paso

### Paso 1: Identificar Alcance
**Pensamiento**: ¿Qué documentos contienen enlaces?
- Todos los README.md en la estructura backend
- Archivos INDEX.md y INDICE.md
- Documentos de documentación en docs/
- Archivos de configuración con referencias

### Paso 2: Definir Tipos de Enlaces
**Pensamiento**: ¿Qué tipos de enlaces debo validar?
1. Enlaces relativos entre documentos (../folder/file.md)
2. Enlaces absolutos desde raíz (/docs/backend/...)
3. Referencias a secciones (#nombre-seccion)
4. Enlaces a archivos de código fuente
5. Enlaces externos (opcional, solo verificar formato)

### Paso 3: Determinar Método de Validación
**Pensamiento**: ¿Cómo verifico cada tipo?
- Para enlaces relativos: resolver ruta y verificar existencia
- Para enlaces absolutos: verificar desde raíz del proyecto
- Para anclas: verificar que la sección existe en el documento
- Usar herramientas automatizadas cuando sea posible

### Paso 4: Planificar Correcciones
**Pensamiento**: ¿Qué hago con enlaces rotos?
- Documentar todos los enlaces rotos encontrados
- Actualizar rutas según nueva estructura
- Eliminar enlaces a contenido obsoleto
- Crear issues para contenido faltante

## Chain-of-Verification (CoVe)

### Verificación 1: Baseline Response
**Pregunta**: ¿Todos los enlaces en README.md están válidos?
**Respuesta Inicial**: Ejecutar script de validación y listar todos los enlaces

### Verificación 2: Plan Questions
**Preguntas a verificar**:
1. ¿El archivo de destino existe en la ruta indicada?
2. ¿La sección referenciada existe en el documento?
3. ¿El formato del enlace es correcto (Markdown)?
4. ¿La ruta relativa se resuelve correctamente?

### Verificación 3: Answer Questions
Para cada enlace encontrado:
- Verificar existencia del archivo
- Verificar formato de enlace
- Verificar anclas si existen
- Marcar como VÁLIDO o ROTO

### Verificación 4: Generate Final Verified Response
**Reporte Final**:
- Total de enlaces analizados: X
- Enlaces válidos: Y
- Enlaces rotos: Z
- Lista detallada de enlaces rotos con ubicación
- Recomendaciones de corrección

## Self-Consistency: Validación Múltiple

### Enfoque 1: Validación Manual
- Abrir cada README.md
- Seguir manualmente cada enlace
- Verificar que el destino existe

### Enfoque 2: Script Automatizado
```bash
# Encontrar todos los enlaces en archivos .md
find docs/backend -name "*.md" -exec grep -H "\[.*\](.*)" {} \;

# Validar existencia de archivos referenciados
# Script Python o Node.js para parsear y validar
```

### Enfoque 3: Herramienta Especializada
```bash
# Usar markdown-link-check o similar
npx markdown-link-check docs/backend/**/*.md
```

### Convergencia de Resultados
- Comparar resultados de los 3 enfoques
- Enlaces que fallan en 2+ enfoques son definitivamente rotos
- Priorizar corrección de enlaces críticos

## Criterios de Aceptación
- [ ] Todos los README.md validados
- [ ] Todos los INDEX.md validados
- [ ] Enlaces rotos documentados en reporte
- [ ] Enlaces críticos corregidos (prioridad ALTA/CRÍTICA)
- [ ] Script de validación documentado para uso futuro
- [ ] Pasar verificación con 3 enfoques diferentes

## Entregables
1. **REPORTE-VALIDACION-ENLACES.md**
 - Lista completa de enlaces analizados
 - Enlaces rotos por archivo
 - Estadísticas generales

2. **ENLACES-CORREGIDOS.md**
 - Lista de correcciones aplicadas
 - Enlaces antes/después

3. **script-validar-enlaces.sh** o **.py**
 - Script reutilizable para validaciones futuras

## Comandos Útiles

### Buscar todos los enlaces Markdown
```bash
grep -r "\[.*\](.*)" docs/backend/ --include="*.md"
```

### Encontrar enlaces relativos
```bash
grep -r "\[.*\](\.\./" docs/backend/ --include="*.md"
```

### Listar todos los README.md
```bash
find docs/backend -name "README.md" -type f
```

## Dependencias
- TASK-054: Migración de contenido legacy (debe estar completada)
- Estructura de carpetas finalizada

## Notas
- Esta es una tarea CRÍTICA porque enlaces rotos rompen la navegación de la documentación
- Priorizar enlaces en documentos de alto nivel (README principal, INDEX)
- Documentar proceso para validaciones futuras
- Considerar agregar validación de enlaces al CI/CD

## Referencias
- [Markdown Link Check](https://github.com/tcort/markdown-link-check)
- Auto-CoT: Wei et al. (2022) - Automatic Chain of Thought Prompting
- Chain-of-Verification: Dhuliawala et al. (2023)
- Self-Consistency: Wang et al. (2022)
