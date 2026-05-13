```yml
created_at: 2026-04-20 13:52:46
project: THYROX
author: NestorMonroy
status: Borrador
```

# Gate Calibrado — Contratos de Evaluadores y Merger

## Arquitectura del gate calibrado

El gate calibrado usa 3 evaluadores en paralelo + 1 Merger. Cada evaluador es un agente especializado con scope acotado.

## Contratos de output_key por evaluador

### Evaluador 1 — Completitud de evidencia
```
output_key: "completitud"
schema:
  ratio_calibracion: float  # (PROVEN + INFERRED) / total_claims, rango [0.0, 1.0]
  claims_speculative: int   # número de claims SPECULATIVE detectados
  gate_pasa: bool           # True si ratio >= 0.75 para gate artifacts, >= 0.50 para exploración
  evidencia_citada: list[str]  # lista de fuentes citadas (archivo:línea)
```

### Evaluador 2 — Consistencia con stages anteriores
```
output_key: "consistencia"
schema:
  claims_contradictorios: list[str]  # claims que contradicen decisions/ anteriores
  claims_heredados_sin_verificar: list[str]  # claims con Origen=heredado no re-verificados
  gate_pasa: bool  # True si claims_contradictorios == []
  notas: str
```

### Evaluador 3 — Separabilidad de exit criteria
```
output_key: "separabilidad"
schema:
  tiene_entry_condition: bool   # gate tiene prerequisito explícito
  tiene_exit_threshold: bool    # gate tiene criterio medible de salida
  umbral_derivado: bool         # exit_threshold tiene número derivado (no "cuando esté listo")
  gate_pasa: bool               # True si los 3 campos anteriores son True
  notas: str
```

## Instrucción anti-confabulación para el Merger

El Merger combina los 3 outputs y DEBE seguir estas reglas:
1. NUNCA inferir un `gate_pasa: True` si el evaluador no lo declaró explícitamente
2. Si cualquier evaluador retorna `gate_pasa: False` → gate global = False
3. Si cualquier output_key falta → gate global = False (no inferir el valor)
4. El resumen del Merger cita textualmente los valores recibidos — no los parafrasea

```python
# Ejemplo de Merger correcto
def merge_gate_results(completitud, consistencia, separabilidad):
    gate_global = (
        completitud.get("gate_pasa", False) and
        consistencia.get("gate_pasa", False) and
        separabilidad.get("gate_pasa", False)
    )
    return {
        "gate_global": gate_global,
        "detalle": {
            "completitud": completitud["gate_pasa"],
            "consistencia": consistencia["gate_pasa"],
            "separabilidad": separabilidad["gate_pasa"],
        },
        "ratio_calibracion": completitud.get("ratio_calibracion", 0.0),
        "claims_bloqueantes": completitud.get("claims_speculative", 0),
    }
```
