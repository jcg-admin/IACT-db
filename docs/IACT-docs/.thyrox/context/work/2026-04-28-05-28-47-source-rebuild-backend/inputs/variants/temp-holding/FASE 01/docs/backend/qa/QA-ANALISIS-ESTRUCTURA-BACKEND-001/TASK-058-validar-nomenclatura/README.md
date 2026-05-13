# TASK-058: Validar Nomenclatura

## Metadatos
- **ID**: TASK-058
- **Fase**: FASE 4 - Validación y Limpieza
- **Prioridad**: MEDIA 
- **Estimación**: 15 minutos
- **Estado**: PENDIENTE
- **Metodología**: Auto-CoT + Self-Consistency + Chain-of-Verification

## Descripción
Validar que todos los nombres de archivos y carpetas sigan las convenciones de nomenclatura establecidas para el proyecto, garantizando consistencia y buenas prácticas.

## Auto-CoT: Razonamiento Paso a Paso

### Paso 1: Definir Convenciones de Nomenclatura
**Pensamiento**: ¿Qué reglas de nomenclatura debemos seguir?

**Para Carpetas**:
- kebab-case (palabras-separadas-por-guiones)
- Minúsculas
- Sin espacios, sin caracteres especiales
- Descriptivas y específicas
- Ejemplos: `user-management`, `api-gateway`, `common-utils`

**Para Archivos**:
- **Código**: camelCase o kebab-case según lenguaje
 - JavaScript/TypeScript: camelCase (userService.js)
 - Python: snake_case (user_service.py)
 - Configuración: kebab-case (eslint-config.js)

- **Documentación**: SCREAMING_CASE o kebab-case
 - README.md (estándar)
 - INDEX.md (estándar)
 - CHANGELOG.md (estándar)
 - guia-rapida.md (contenido)

- **Configuración**: Según convención del tool
 - .eslintrc.json
 - package.json
 - docker-compose.yml

### Paso 2: Identificar Patrones Problemáticos
**Pensamiento**: ¿Qué nombres son incorrectos?
- Espacios en nombres: "mi carpeta"
- Mayúsculas inconsistentes: "MiCarpeta", "MICARPETA"
- Caracteres especiales: "carpeta_vieja", "carpeta (1)"
- Nombres genéricos: "temp", "old", "backup", "test"
- Números sin contexto: "component1", "service2"
- Mezcla de estilos: "MiCarpeta-v2"

### Paso 3: Crear Catálogo de Nombres Actuales
**Pensamiento**: ¿Cómo mapeo toda la estructura?
```bash
# Listar todas las carpetas
find docs/backend -type d

# Listar todos los archivos
find docs/backend -type f

# Generar árbol de estructura
tree docs/backend -L 3
```

### Paso 4: Planificar Correcciones
**Pensamiento**: ¿Cómo renombro sin romper referencias?
1. Identificar nombres incorrectos
2. Proponer nombres correctos
3. Verificar que el nuevo nombre no existe
4. Buscar referencias al nombre antiguo
5. Actualizar referencias
6. Renombrar archivo/carpeta
7. Validar que todo funciona

## Chain-of-Verification (CoVe)

### Verificación 1: Baseline Response
**Pregunta**: ¿Todos los nombres siguen las convenciones?
**Método**: Escanear toda la estructura y categorizar nombres

### Verificación 2: Plan Questions
**Preguntas por tipo**:

**Para Carpetas**:
1. ¿Es kebab-case?
2. ¿Está en minúsculas?
3. ¿No tiene espacios ni caracteres especiales?
4. ¿Es suficientemente descriptiva?
5. ¿No es genérica (temp, old, etc.)?

**Para Archivos**:
1. ¿Sigue la convención del tipo de archivo?
2. ¿La extensión es correcta?
3. ¿No tiene caracteres especiales?
4. ¿Es descriptivo y específico?

### Verificación 3: Answer Questions Independently
```
Evaluación: docs/backend/User Management/
[ERROR] Tiene espacio
[ERROR] Usa mayúsculas
[OK] Es descriptivo
Propuesta: user-management

Evaluación: docs/backend/temp/
[OK] Sin espacios
[OK] Minúsculas
[ERROR] Nombre genérico
[ERROR] No descriptivo
Propuesta: temporal-migrations (según contenido)

Evaluación: docs/backend/api_gateway/
[WARNING] Usa snake_case en lugar de kebab-case
[OK] Descriptivo
Propuesta: api-gateway
```

### Verificación 4: Generate Final Verified Response
**Reporte de Nomenclatura**:
- Total items evaluados: X
- Conformes: Y
- No conformes: Z
- Requieren renombrado: W
- Plan de renombrado priorizado

## Self-Consistency: Validación Múltiple

### Enfoque 1: Regex Pattern Matching
```bash
# Detectar nombres con espacios
find docs/backend -name "* *"

# Detectar nombres con mayúsculas (carpetas)
find docs/backend -type d | grep -v "^[a-z0-9-/]*$"

# Detectar underscore en carpetas
find docs/backend -type d -name "*_*"

# Detectar nombres genéricos
find docs/backend -type d -name "temp" -o -name "old" -o -name "backup"
```

### Enfoque 2: Script de Validación con Reglas
```python
import re
import os

KEBAB_CASE_PATTERN = re.compile(r'^[a-z0-9]+(-[a-z0-9]+)*$')
GENERIC_NAMES = ['temp', 'old', 'backup', 'test', 'tmp', 'archive']

def validate_folder_name(name):
 issues = []

 if ' ' in name:
 issues.append("Contiene espacios")

 if not KEBAB_CASE_PATTERN.match(name):
 issues.append("No es kebab-case")

 if name.lower() in GENERIC_NAMES:
 issues.append("Nombre genérico")

 return issues

# Validar toda la estructura
# ...
```

### Enfoque 3: Checklist Manual
- Revisar carpetas de nivel superior
- Verificar consistencia en subcarpetas
- Validar nombres de archivos importantes
- Comparar con estructura propuesta

### Convergencia de Resultados
- Nombres marcados por 2+ enfoques: Definitivamente requieren corrección
- Nombres con issues menores: Evaluar caso por caso
- Nombres aprobados por todos: No requieren cambios

## Criterios de Aceptación
- [ ] 100% de carpetas principales en kebab-case
- [ ] 0 nombres con espacios
- [ ] 0 nombres genéricos en carpetas principales
- [ ] Documentación en UPPER_CASE o kebab-case
- [ ] Código sigue convención del lenguaje
- [ ] Plan de renombrado documentado
- [ ] Referencias actualizadas donde sea necesario

## Entregables
1. **REPORTE-NOMENCLATURA.md**
 - Árbol de estructura actual
 - Lista de nombres no conformes
 - Propuestas de renombrado
 - Estadísticas de conformidad

2. **PLAN-RENOMBRADO.md**
 - Lista priorizada de renombrados
 - Impacto de cada cambio
 - Orden de ejecución
 - Script de renombrado

3. **script-validar-nombres.sh/py**
 - Validación automatizada
 - Detección de patrones incorrectos
 - Generación de reporte

4. **CONVENCIONES-NOMENCLATURA.md**
 - Guía de nomenclatura del proyecto
 - Ejemplos buenos y malos
 - Reglas por tipo de archivo

## Reglas de Nomenclatura Detalladas

### Carpetas
[OK] **CORRECTO**:
- `user-management`
- `api-gateway`
- `common-utils`
- `authentication-service`

[ERROR] **INCORRECTO**:
- `User Management` (espacios, mayúsculas)
- `user_management` (snake_case)
- `userManagement` (camelCase)
- `temp` (genérico)
- `old-stuff` (poco específico)

### Archivos de Documentación
[OK] **CORRECTO**:
- `README.md`
- `CHANGELOG.md`
- `CONTRIBUTING.md`
- `guia-rapida.md`
- `arquitectura-backend.md`

[ERROR] **INCORRECTO**:
- `readme.md` (debe ser README.md)
- `Guia Rapida.md` (espacios)
- `GUIA_RAPIDA.MD` (extensión en mayúsculas)

### Archivos de Código
[OK] **CORRECTO** (JavaScript/TypeScript):
- `userService.js`
- `authController.ts`
- `database-config.js`

[OK] **CORRECTO** (Python):
- `user_service.py`
- `auth_controller.py`
- `database_config.py`

[ERROR] **INCORRECTO**:
- `UserService.js` (PascalCase para clases, no archivos)
- `user-service.py` (Python usa snake_case)
- `auth controller.js` (espacios)

### Archivos de Configuración
[OK] **CORRECTO**:
- `package.json`
- `.eslintrc.json`
- `docker-compose.yml`
- `tsconfig.json`

## Comandos Útiles

### Detectar problemas comunes
```bash
# Nombres con espacios
find docs/backend -name "* *" -type f -o -name "* *" -type d

# Carpetas no en kebab-case
find docs/backend -type d | grep -E "[A-Z_]"

# Nombres genéricos
find docs/backend -type d \( -name "temp" -o -name "old" -o -name "backup" -o -name "test" \)

# Extensiones en mayúsculas
find docs/backend -name "*.MD" -o -name "*.JSON" -o -name "*.YML"
```

### Generar árbol de estructura
```bash
# Árbol completo
tree docs/backend

# Solo carpetas, 3 niveles
tree docs/backend -d -L 3

# Con archivo de salida
tree docs/backend -d -L 3 > estructura-actual.txt
```

### Renombrar (ejemplo seguro)
```bash
# Backup primero
cp -r docs/backend docs/backend.backup

# Renombrar carpeta
git mv "docs/backend/User Management" "docs/backend/user-management"

# Actualizar referencias (ejemplo)
grep -rl "User Management" docs/backend | xargs sed -i 's/User Management/user-management/g'
```

## Estrategia de Renombrado

### Fase 1: Preparación
1. Generar lista completa de renombrados necesarios
2. Identificar dependencias y referencias
3. Priorizar por impacto (menor a mayor)
4. Crear backup completo

### Fase 2: Ejecución
1. Renombrar en orden de dependencias
2. Actualizar referencias inmediatamente
3. Validar que no se rompió nada
4. Commit pequeños y frecuentes

### Fase 3: Validación
1. Ejecutar TASK-055 (validar enlaces)
2. Ejecutar tests si existen
3. Verificar documentación accesible
4. Review manual de cambios críticos

## Prioridades

### P1 - Renombrar Inmediatamente
- Carpetas con espacios
- Nombres que rompen herramientas
- Carpetas principales no conformes

### P2 - Renombrar en Esta Fase
- Subcarpetas con convenciones incorrectas
- Archivos de documentación importantes
- Nombres genéricos en ubicaciones clave

### P3 - Considerar Renombrar
- Nombres subóptimos pero funcionales
- Legacy code con convenciones antiguas
- Archivos de bajo impacto

## Dependencias
- TASK-054: Migración de contenido (para no renombrar durante migración)
- Antes de TASK-055: Validar enlaces (para no romper referencias)

## Notas
- Git preserva historia al usar `git mv` en lugar de `mv`
- Validar que nombres nuevos no existen antes de renombrar
- Considerar URLs y bookmarks que apunten a documentación
- Documentar cambios de nombres en CHANGELOG

## Referencias
- [Google Style Guide - File Naming](https://google.github.io/styleguide/)
- [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)
- [PEP 8 - Python Naming Conventions](https://www.python.org/dev/peps/pep-0008/)
- Auto-CoT: Wei et al. (2022)
- Chain-of-Verification: Dhuliawala et al. (2023)
