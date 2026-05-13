---
title: Scripts de Gestion de Requisitos
date: 2025-11-13
domain: general
status: active
---

# Scripts de Gestion de Requisitos

Documentacion de scripts para gestionar requisitos (RF, RNF).

## Ubicacion

`/home/user/IACT---project/scripts/requisitos/`

## Scripts Disponibles

### generar_indices.py

**Proposito:** Generar automaticamente indices de requisitos (INDICE.md en cada categoria).

**Uso:**
```bash
python scripts/requisitos/generar_indices.py
```

**Que hace:**
1. Escanea `docs/requisitos/`
2. Lee frontmatter de cada requisito
3. Genera archivos `INDICE.md` en cada subdirectorio
4. Ordena por ID de requisito

**Output:**
```
[INFO] Generando indices de requisitos...
[INFO] Procesando docs/requisitos/funcionales/
[OK] Generado: docs/requisitos/funcionales/INDICE.md (45 requisitos)
[INFO] Procesando docs/requisitos/no_funcionales/
[OK] Generado: docs/requisitos/no_funcionales/INDICE.md (18 requisitos)
[OK] Indices generados correctamente
```

**Ejemplo de INDICE.md generado:**
```markdown
# Indice de Requisitos Funcionales

Total: 45 requisitos

| ID | Titulo | Prioridad | Estado |
|----|--------|-----------|--------|
| RF-001 | Autenticacion de usuarios | P0 | Implementado |
| RF-002 | Registro de usuarios | P0 | Implementado |
| RF-003 | Recuperacion de contrasena | P1 | Pendiente |
...
```

---

### validar_frontmatter.py

**Proposito:** Validar que todos los requisitos tienen frontmatter YAML correcto.

**Uso:**
```bash
python scripts/requisitos/validar_frontmatter.py
```

**Validaciones:**
- Frontmatter YAML presente
- Campos requeridos: `id`, `tipo`, `prioridad`, `estado`
- Formato correcto de valores

**Output:**
```
[INFO] Validando frontmatter de requisitos...
[OK] docs/requisitos/funcionales/rf-001.md - Valid
[OK] docs/requisitos/funcionales/rf-002.md - Valid
[ERROR] docs/requisitos/funcionales/rf-003.md - Missing field 'prioridad'
[WARNING] docs/requisitos/no_funcionales/rnf-001.md - Invalid estado value
[INFO] Validacion completada: 43/45 validos
```

**Frontmatter esperado:**
```yaml
---
id: RF-001
tipo: funcional
titulo: Autenticacion de usuarios
prioridad: P0
estado: implementado
---
```

---

### contar_requisitos.sh

**Proposito:** Contar requisitos por categoria y estado.

**Uso:**
```bash
./scripts/requisitos/contar_requisitos.sh
```

**Output:**
```
===============================================
RESUMEN DE REQUISITOS
===============================================

Requisitos Funcionales:
  Total: 45
  Implementados: 38
  En desarrollo: 5
  Pendientes: 2

Requisitos No Funcionales:
  Total: 18
  Implementados: 15
  En desarrollo: 2
  Pendientes: 1

TOTAL: 63 requisitos
  Implementados: 53 (84%)
  En desarrollo: 7 (11%)
  Pendientes: 3 (5%)
===============================================
```

---

### listar_requisitos.sh

**Proposito:** Listar todos los requisitos del proyecto.

**Uso:**
```bash
# Listar todos
./scripts/requisitos/listar_requisitos.sh

# Solo funcionales
./scripts/requisitos/listar_requisitos.sh funcionales

# Solo no funcionales
./scripts/requisitos/listar_requisitos.sh no_funcionales

# Solo pendientes
./scripts/requisitos/listar_requisitos.sh --estado pendiente
```

**Output:**
```
RF-001: Autenticacion de usuarios [P0] [Implementado]
RF-002: Registro de usuarios [P0] [Implementado]
RF-003: Recuperacion de contrasena [P1] [Pendiente]
...
RNF-001: Performance - Tiempo de respuesta [P0] [Implementado]
RNF-002: Restricciones criticas [P0] [Implementado]
...
```

---

## Flujo de Trabajo

### 1. Crear nuevo requisito

```bash
# Usar template
cp docs/plantillas/template_requisito_funcional.md docs/requisitos/funcionales/rf-046-nuevo-requisito.md

# Editar frontmatter y contenido
vi docs/requisitos/funcionales/rf-046-nuevo-requisito.md
```

### 2. Validar frontmatter

```bash
python scripts/requisitos/validar_frontmatter.py
```

### 3. Regenerar indices

```bash
python scripts/requisitos/generar_indices.py
```

### 4. Commit

```bash
git add docs/requisitos/
git commit -m "docs(requisitos): agregar RF-046 nuevo requisito"
```

---

## Integration con Traceability Matrix

El `traceability_matrix_generator.py` usa estos scripts:

```python
from agents.traceability_matrix_generator import TraceabilityMatrixGenerator

generator = TraceabilityMatrixGenerator()
matrix = generator.generate()

# Genera matriz:
# Requisito → Features → Tests → Deployment
```

---

## Troubleshooting

### Error: Missing frontmatter

**Solucion:**
```bash
# Agregar frontmatter al archivo
cat << EOF > docs/requisitos/funcionales/rf-xxx.md
---
id: RF-XXX
tipo: funcional
titulo: Titulo del requisito
prioridad: P1
estado: pendiente
---

# Contenido del requisito...
EOF
```

### Indices desactualizados

**Solucion:**
```bash
# Regenerar todos los indices
python scripts/requisitos/generar_indices.py
```

---

## Mejores Practicas

1. **Validar antes de commitear:**
   ```bash
   python scripts/requisitos/validar_frontmatter.py
   python scripts/requisitos/generar_indices.py
   ```

2. **Usar templates:**
   - `docs/plantillas/template_requisito_funcional.md`
   - `docs/plantillas/template_requisito_no_funcional.md`

3. **Mantener indices actualizados:**
   - Los indices son auto-generados
   - NO editar manualmente
   - Re-generar despues de cambios

4. **Naming convention:**
   - Funcionales: `rf-XXX-nombre-descriptivo.md`
   - No Funcionales: `rnf-XXX-nombre-descriptivo.md`

---

**Mantenedores:** @arquitecto-senior, @product-owner
