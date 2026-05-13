---
id: SC00-MARCO-INTEGRADO
tipo: documentacion
prioridad: alta
estado: pendiente
fecha_creacion: 2025-11-04
responsable: business-analyst
relacionados: ["DOC-GOB-INDEX"]
---
# SC00: Integrar Marco Integrado de Análisis de Negocio

## Objetivo
Integrar el documento "Marco Integrado de Análisis de Negocio" (BABOK v3, PMBOK, ISO 29148) en la estructura de documentación del proyecto.

## Contexto
Se tiene un documento extenso (~50,000 caracteres) que establece metodología completa para análisis de negocio integrando:
- BABOK v3 (IIBA)
- PMBOK (PMI)  
- IREB/CPRE
- ISO/IEC/IEEE 29148

## Requisitos de Implementación

### 1. Ubicación del Documento
**Archivo destino:** `docs/gobernanza/marco_integrado_analisis_negocio.md`

**Justificación:**
- Es documento metodológico (gobernanza)
- Establece estándares y marcos de referencia
- Define procesos, roles y responsabilidades

### 2. Método de Creación OBLIGATORIO
Usar estrategia de staging con /tmp:

```bash
# Paso 1: Crear en /tmp
cat > /tmp/marco_integrado_analisis_negocio.md << 'EOF'
[CONTENIDO COMPLETO DEL DOCUMENTO - VER ANEXO]
EOF

# Paso 2: Verificar creación
ls -lh /tmp/marco_integrado_analisis_negocio.md
cat /tmp/marco_integrado_analisis_negocio.md | head -20

# Paso 3: Copiar a destino
cp /tmp/marco_integrado_analisis_negocio.md docs/gobernanza/

# Paso 4: Verificar en destino
ls -lh docs/gobernanza/marco_integrado_analisis_negocio.md
```

### 3. Actualizar Referencias

**Archivo:** `docs/gobernanza/readme.md`

Agregar en sección apropiada:

```markdown
### Marcos de Referencia
- [Marco Integrado de Análisis de Negocio](marco_integrado_analisis_negocio.md)
  - Integración BABOK v3, PMBOK, ISO 29148
  - Jerarquía completa de requisitos (6 niveles)
  - Proceso de transformación: Reglas → Necesidades → Requisitos
  - Casos prácticos (Bancario, Salud, E-commerce)
  - Plantillas y herramientas
```

### 4. Commit y Push

```bash
git add docs/gobernanza/marco_integrado_analisis_negocio.md docs/gobernanza/readme.md
git commit -m "docs: agregar Marco Integrado de Análisis de Negocio

- Documento integrador BABOK v3, PMBOK, ISO 29148
- Establece jerarquía de 6 niveles de requisitos
- Incluye proceso completo de análisis
- Contiene casos prácticos y plantillas
- 50K caracteres, formato profesional sin emojis"

git push -u origin claude/move-procedures-docs-011CUnrnSfS9ee5fpAwFEPTD
```

## Restricciones

1. **Máximo 2 mensajes para completar** toda la tarea
2. **Usar método staging /tmp** obligatoriamente
3. **No usar Write tool directamente** para el documento principal
4. **Ejecutar sin análisis paralítico** - actuar de inmediato

## Criterios de Aceptación

- [ ] Archivo creado en `docs/gobernanza/marco_integrado_analisis_negocio.md`
- [ ] Contenido completo e intacto (verificar con `wc -l`, `wc -c`)
- [ ] `docs/gobernanza/readme.md` actualizado con referencia
- [ ] Commit realizado con mensaje descriptivo
- [ ] Push exitoso a rama correspondiente
- [ ] Tarea completada en máximo 2 mensajes

## Anexo: Contenido del Documento

El contenido completo del documento se encuentra en el mensaje original del usuario y contiene:

**Secciones principales:**
1. VISION GENERAL
2. JERARQUIA COMPLETA (6 niveles)
3. REGLAS DE NEGOCIO COMO BASE
4. EL PROCESO COMPLETO (5 fases)
5. CASOS PRACTICOS INTEGRADOS
6. MATRICES Y HERRAMIENTAS
7. GUIA DE IMPLEMENTACION

**Características:**
- ~50,000 caracteres
- Formato profesional sin emojis
- Tablas, diagramas ASCII, código de ejemplo
- Plantillas y checklists
- Referencias normativas

---

**Instrucciones para el ejecutor:**
Copiar el contenido exacto del documento proporcionado por el usuario en el mensaje que contenía el título "# Marco Integrado de Análisis de Negocio".
