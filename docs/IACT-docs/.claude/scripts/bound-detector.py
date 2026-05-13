#!/usr/bin/env python3
"""
bound-detector.py — PreToolUse hook para Agent tool calls
Detecta instrucciones sin scope bound y bloquea hasta que se especifique uno.

Eventos: PreToolUse (matcher: Agent)
Input:   JSON via stdin con tool_name y tool_input.prompt
Output:  JSON via stdout con permissionDecision
"""

import json
import re
import sys

# ── Señales de instrucción sin bound ──────────────────────────────────────────
UNBOUNDED_SIGNALS = [
    r"\btodos los\b", r"\btodas las\b", r"\btodo el\b", r"\btoda la\b",
    r"\bcada uno\b", r"\bcada archivo\b", r"\bcada script\b",
    r"\bcualquier\b", r"\bexhaustivamente\b", r"\bcompletamente\b",
    r"\bsin l[ií]mite\b", r"\bde forma exhaustiva\b",
    r"\bread ALL\b", r"\bleer todos\b", r"\bleer todas\b",
    r"\bprocesa todos\b", r"\brevisa todos\b", r"\banaliza todo\b",
    # English patterns
    r"\bevery\b", r"\beach\b", r"\ball\b",
    r"\bprocess all\b", r"\bread all\b", r"\banalyze all\b",
    r"\bfor each\b", r"\bfor every\b",
]

# ── Señales de bound presente ──────────────────────────────────────────────────
BOUND_SIGNALS = [
    r"\bmáximo\b", r"\bmaximo\b", r"\bm[áa]x\b",
    r"\bsolo estos\b", r"\bsolamente\b", r"\b[úu]nicamente\b",
    r"\bno m[áa]s de\b", r"\bprimeros \d+\b", r"\blos \d+ m[áa]s\b",
    r"\bhasta \d+\b", r"\bl[íi]mite de \d+\b", r"\bm[áa]ximo \d+\b",
    r"\bsolo: \[", r"\bsolo \[",
    # English patterns
    r"\bmaximum\b", r"\bmax\b", r"\bonly these\b",
    r"\bno more than\b", r"\bfirst \d+\b", r"\btop \d+\b", r"\bat most\b",
]

# ── Señales de bound difuso (presente pero no accionable) ─────────────────────
DIFFUSE_SIGNALS = [
    r"\brelevantes\b", r"\bimportantes\b", r"\bnecesarios\b",
    r"\bapropiados\b", r"\bsignificativos\b", r"\brepresentativos\b",
    r"\blos m[áa]s\b", r"\blos principales\b",
]

# ── Plantillas de opciones por tipo de instrucción ────────────────────────────
OPTIONS_TEMPLATE = """⚠ INSTRUCCIÓN SIN BOUND DETECTADO

Patrón detectado: {matched}
Fragmento: «{snippet}»

El Agent tool call fue bloqueado. Especifica un bound antes de continuar.

OPCIONES:
  A) Número máximo:     "máximo N archivos/secciones/elementos"
  B) Selección explícita: "solo estos: [item1, item2, item3]"
  C) Criterio de parada: "hasta encontrar N instancias de X"
  D) Representatividad: "los 3-5 más representativos de [criterio concreto]"
  E) Tiempo/profundidad: "máximo N tool_uses / N lecturas de archivo"

Reformula la instrucción con uno de estos bounds para continuar."""

DIFFUSE_TEMPLATE = """⚠ BOUND DIFUSO DETECTADO

Patrón detectado: {matched}
Fragmento: «{snippet}»

El bound existe pero no es accionable ("relevantes", "importantes", etc.
no son criterios de parada deterministas para un agente).

OPCIONES para hacer el bound preciso:
  A) Convertir a número: "los 5 más relevantes" → "máximo 5"
  B) Dar criterio concreto: "los importantes" → "los que mencionen X o Y"
  C) Selección explícita: listar directamente los ítems a procesar

¿Con cuál procedo?"""


def detect_signals(text: str, patterns: list[str]) -> tuple[bool, str]:
    """Retorna (found, matched_pattern)."""
    lower = text.lower()
    for pattern in patterns:
        m = re.search(pattern, lower, re.IGNORECASE)
        if m:
            return True, m.group(0)
    return False, ""


def extract_snippet(text: str, pattern: str, window: int = 60) -> str:
    """Extrae contexto alrededor del patrón detectado."""
    m = re.search(pattern, text, re.IGNORECASE)
    if not m:
        return text[:window]
    start = max(0, m.start() - 20)
    end = min(len(text), m.end() + 40)
    snippet = text[start:end].replace("\n", " ").strip()
    return snippet if len(snippet) <= window else snippet[:window] + "…"


def allow() -> None:
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "allow",
        }
    }))


def deny(reason: str) -> None:
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "reason": reason,
        }
    }))


def main() -> None:
    try:
        data = json.load(sys.stdin)
    except json.JSONDecodeError:
        allow()
        return

    # Solo interceptar Agent tool calls
    if data.get("tool_name") != "Agent":
        allow()
        return

    task = data.get("tool_input", {}).get("prompt", "")
    if not task:
        allow()
        return

    # ── Paso 1: ¿hay señal de instrucción sin bound? ──────────────────────────
    has_unbounded, unbounded_match = detect_signals(task, UNBOUNDED_SIGNALS)

    if not has_unbounded:
        allow()
        return

    # ── Paso 2: ¿hay un bound claro que lo compensa? ─────────────────────────
    has_bound, _ = detect_signals(task, BOUND_SIGNALS)

    if has_bound:
        # Bound claro presente → permitir
        allow()
        return

    # ── Paso 3: ¿hay un bound difuso? ────────────────────────────────────────
    has_diffuse, diffuse_match = detect_signals(task, DIFFUSE_SIGNALS)

    if has_diffuse:
        snippet = extract_snippet(task, diffuse_match)
        deny(DIFFUSE_TEMPLATE.format(matched=diffuse_match, snippet=snippet))
        return

    # ── Paso 4: Sin bound en absoluto → bloquear con opciones ────────────────
    snippet = extract_snippet(task, unbounded_match)
    deny(OPTIONS_TEMPLATE.format(matched=unbounded_match, snippet=snippet))


if __name__ == "__main__":
    main()
