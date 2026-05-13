# TEMPLATE T04: Documentación de Functional Requirement

**Versión:** 1.0.0  
**Categoría:** Derivación de FR  
**Fuente:** PARTE 2B, Sección 6.3  
**Uso:** Documentar un FR con los 10 componentes esenciales

---

## ¿CUÁNDO USAR ESTE TEMPLATE?

Usa este template cuando:
- Derivaste un FR desde un paso de UC
- Necesitas documentar una capacidad técnica específica
- Quieres asegurar que el FR es implementable

---

## TEMPLATE COMPLETO

```markdown
# FR-[NNN]: [Nombre del Functional Requirement]

═══════════════════════════════════════════════════════════

## 1. IDENTIFICACIÓN

ID: FR-[NNN]
Módulo: MOD_[Nombre]
Tipo: [Query / Data Retrieval / Validation / Calculation / Business Logic]
Versión: 1.0.0
Prioridad: [Crítica / Alta / Media / Baja]
Complejidad: [Alta / Media / Baja]

---

## 2. DESCRIPCIÓN BREVE

[1-2 oraciones describiendo QUÉ hace este FR]

[Párrafo adicional con contexto si necesario]

---

## 3. DERIVACIÓN Y TRAZABILIDAD

**Derivado de:**
- UC-[ID] (Paso [N]): "[Nombre del paso]"
- BR-[ID]: "[Nombre de la BR]"

**Relacionado con:**
- FR-[ID]: [Cómo se relaciona]
- FR-[ID]: [Cómo se relaciona]

**Usado en:**
- UC-[ID]: [Dónde más se usa]

---

## 4. PRIORIDAD Y COMPLEJIDAD

**Prioridad:** [Crítica / Alta / Media / Baja]

Justificación:
  [Explicar por qué tiene esta prioridad]

**Complejidad:** [Alta / Media / Baja]

Factores:
  - [Factor 1 que afecta complejidad]
  - [Factor 2 que afecta complejidad]
  - [Factor 3 que afecta complejidad]

---

## 5. INPUTS

[Listar parámetros de entrada con tipos]

**Parámetros:**

- `[param1]`: [Tipo] - [Descripción]
- `[param2]`: [Tipo] - [Descripción]
- `[param3]`: [Tipo] - [Descripción opcional]

**Restricciones en inputs:**
- [Validación 1]
- [Validación 2]

---

## 6. OUTPUTS

[Describir qué retorna]

**Tipo de retorno:** [Tipo]

**Estructura:**
```
[Si es objeto complejo, describir estructura]
{
  "field1": type,
  "field2": type,
  "field3": {
    "nested": type
  }
}
```

**Cantidad esperada:** [N registros / Único valor / Lista variable]

---

## 7. ALGORITMO / QUERY

[Incluir pseudocódigo o SQL específico]

### Pseudocódigo:

```
FUNCTION [nombre](params):
  1. [Paso 1 del algoritmo]
  2. [Paso 2 del algoritmo]
  3. IF [condición] THEN
       [acción]
     ELSE
       [acción alternativa]
     END IF
  4. RETURN [resultado]
END FUNCTION
```

### Query SQL (si aplica):

```sql
SELECT 
  [campos]
FROM [tabla]
WHERE [condiciones]
  AND [filtro específico de BR]
ORDER BY [orden];
```

**Explicación de filtros:**
- [Filtro 1]: [Por qué existe, qué BR implementa]
- [Filtro 2]: [Por qué existe, qué BR implementa]

### Índices requeridos:

```sql
CREATE INDEX [nombre_idx] 
  ON [tabla]([campos]);
```

### Performance esperada:

- Tiempo: <[X]ms
- Registros escaneados: ~[N]
- Uso de RAM: ~[N]MB

---

## 8. CASOS DE PRUEBA

### CP-1: [Nombre del caso exitoso]

**Precondición:**
- [Estado inicial del sistema]
- [Datos de entrada]

**Acción:**
- [Ejecutar FR con params específicos]

**Resultado esperado:**
- [Output esperado]
- [Validaciones que deben pasar]

---

### CP-2: [Caso con error/validación]

**Precondición:**
- [Estado que causa el error]

**Acción:**
- [Ejecutar FR]

**Resultado esperado:**
- [Error específico o manejo]

---

### CP-3: [Caso edge/límite]

[Repetir estructura]

---

[Mínimo 3 casos de prueba, idealmente 5-7]

---

## 9. MANEJO DE ERRORES

### Error 1: [Tipo de error]

**Causa:** [Qué lo causa]

**Acción del sistema:**
```
TRY:
  [intentar operación]
CATCH [ErrorType]:
  [registrar error]
  [retornar valor seguro o lanzar]
END
```

**Logging:**
- Nivel: [ERROR / WARNING / INFO]
- Mensaje: "[Template del mensaje]"

---

### Error 2: [Otro tipo de error]

[Repetir estructura]

---

## 10. IMPLEMENTACIÓN

### Función Python:

```python
def [nombre_funcion]([params]) -> [ReturnType]:
    """
    [Docstring con descripción]
    
    Trazabilidad:
        BR: BR-[ID]
        UC: UC-[ID] Paso [N]
        FR: FR-[NNN]
    
    Args:
        [param1] ([type]): [descripción]
        [param2] ([type]): [descripción]
    
    Returns:
        [ReturnType]: [descripción del retorno]
    
    Raises:
        [ErrorType]: [cuándo se lanza]
    
    Examples:
        >>> [ejemplo de uso]
        [resultado]
    """
    # Implementación
    [código]
```

### Tests unitarios:

```python
def test_[nombre_cp1]():
    """CP-1: [Descripción]"""
    # Arrange
    [preparar datos]
    
    # Act
    result = [llamar función]
    
    # Assert
    assert [verificaciones]
```

---

## 11. MÉTRICAS Y MONITOREO (Opcional)

**Métricas a capturar:**
- [Métrica 1]: [Qué mide]
- [Métrica 2]: [Qué mide]

**Alertas:**
- IF [condición] THEN alerta "[mensaje]"

**Dashboard:**
- [Visualización recomendada]

---

## 12. NOTAS ADICIONALES (Opcional)

[Cualquier consideración especial, limitaciones conocidas, decisiones de diseño]

═══════════════════════════════════════════════════════════
```

---

## VERSIÓN SIMPLIFICADA (FR SIMPLES)

Para FR sencillos (<20 líneas de código):

```markdown
# FR-[NNN]: [Nombre]

**Derivado de:** UC-[ID] Paso [N]  
**BR:** BR-[ID]

## Descripción
[1 párrafo]

## Inputs
- [param1]: [tipo]

## Output
[tipo de retorno]

## Algoritmo
```python
def [nombre]([params]):
    [código simple]
    return [resultado]
```

## Tests
- CP-1: [caso principal]
- CP-2: [caso error]

## Trazabilidad
- BR → UC → FR → Código
```

---

## TIPOS DE FR COMUNES

### Tipo 1: Query / Data Retrieval

Enfoque en:
- Query SQL optimizado
- Índices necesarios
- Performance (<Xms)

Ejemplo: FR-301 (Consultar sesiones elegibles)

---

### Tipo 2: Validation

Enfoque en:
- Reglas de validación precisas
- Mensajes de error claros
- Casos edge

Ejemplo: FR-401 (Validar nivel de seguridad)

---

### Tipo 3: Calculation

Enfoque en:
- Fórmula exacta
- Inputs con rangos
- Casos de prueba numéricos

Ejemplo: FR-601 (Calcular score de riesgo)

---

### Tipo 4: Business Logic

Enfoque en:
- Flujo de decisión (IF-THEN)
- BR implementadas
- Audit trail

Ejemplo: FR-904 (Componer notificación)

---

## GRANULARIDAD RECOMENDADA

**Nivel 1: Muy Granular (Atómico)**
- 1 FR = 1 Query o 1 Función
- Usar cuando FR es reutilizable
- Ejemplo: FR-302 (Calcular minutos inactividad)

**Nivel 2: Moderadamente Granular**
- 1 FR = 1 Paso del UC
- Usar para lógica específica de UC
- Ejemplo: FR-301 (Consultar sesiones para notif)

**Recomendación general:** Nivel 2 para balance

---

## CHECKLIST DE VALIDACIÓN

Antes de considerar FR completo:

☐ 10 componentes documentados (o justificar omisión)
☐ Trazabilidad clara (BR → UC → FR)
☐ Algoritmo implementable (no ambiguo)
☐ Mínimo 3 casos de prueba
☐ Manejo de errores especificado
☐ Código de ejemplo incluido
☐ Performance estimada (<Xms)
☐ Índices documentados (si aplica)

---

## REFERENCIAS

- **Documento fuente:** PARTE_2B_CONSTRUCCION_IACT.md, Sección 6.3
- **Ejemplos completos:**
  - FR-301: Query complejo con índices
  - FR-904: Template rendering
  - FR-907: Registro en BD
- **Templates relacionados:**
  - T02: Construcción de UC
  - T09: Checklist de Calidad

---

**Versión:** 1.0.0  
**Última actualización:** 2026-01-08  
**Mantenido por:** Equipo IACT
