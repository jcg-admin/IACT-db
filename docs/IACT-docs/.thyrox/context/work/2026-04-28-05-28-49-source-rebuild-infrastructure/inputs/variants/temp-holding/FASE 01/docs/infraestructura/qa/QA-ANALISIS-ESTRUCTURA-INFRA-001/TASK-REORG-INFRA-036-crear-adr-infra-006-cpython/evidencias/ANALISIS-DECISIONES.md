# ANALISIS-DECISIONES: ADR-INFRA-006 - CPython

**Decision:** CPython 3.11+ como Python runtime

---

## Trade-offs

| Implementation | Compatibility | Performance | Support | Score |
|----------------|---------------|-------------|---------|-------|
| CPython | 5/5 (todo) | 3/5 | 5/5 (oficial) | 4.7/5 |
| PyPy | 3/5 (algunas C ext) | 5/5 (JIT) | 3/5 | 3.7/5 |
| Jython | 2/5 (JVM only) | 3/5 | 2/5 | 2.3/5 |
| IronPython | 2/5 (.NET only) | 3/5 | 2/5 | 2.3/5 |

## PROS de CPython

1. **Universal Compatibility:** Todas las librerias funcionan
2. **Official Implementation:** Python Software Foundation
3. **Wide Support:** Amplia documentacion y comunidad
4. **Industry Standard:** 95% de proyectos usan CPython

## CONTRAS

1. **Performance:** Menos rapido que PyPy (con JIT)
2. **Mitigacion:** Para IACT, performance de CPython es suficiente

## Trade-off

**Compatibilidad + Support > Performance extra** (que no es critico para IACT)

---

**Conclusion:** CPython es eleccion obvia para proyecto general-purpose
