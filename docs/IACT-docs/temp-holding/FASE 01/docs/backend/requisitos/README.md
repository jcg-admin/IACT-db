# Requisitos del Backend - IACT

Requisitos específicos del dominio Backend del proyecto IACT.

## Estructura (Jerarquía ADR-GOB-005)

```
requisitos/
 requerimientos_negocio/ ← RNEG: Objetivos organizacionales backend
 reglas_negocio/ ← RN: Políticas, restricciones, cálculos
 requerimientos_usuario/ ← UC: Casos de uso backend
 casos_uso/
 requerimientos_funcionales/ ← RF: Funcionalidad del sistema backend
 atributos_calidad/ ← RNF: Performance, seguridad, escalabilidad
```

## Gobernanza Multi-nivel

Consulta **primero** la gobernanza global:
- [Requisitos Globales](../../gobernanza/requisitos/)
- [ADR-GOB-005: Jerarquía de Requisitos](../../gobernanza/adr/ADR-GOB-005-jerarquia-requerimientos-5-niveles.md)
- [GUIA-GOB-005: Derivar Requisitos](../../gobernanza/guias/GUIA-GOB-005-derivar-requisitos-entre-niveles.md)

## ¿Cuándo documentar requisitos aquí vs. Global?

### [OK] Requisito de Backend (aquí)
- Solo afecta implementación backend
- Stack-specific (Django, PostgreSQL, Python)
- No impacta frontend u otros dominios

### [ERROR] Requisito Global (en /docs/gobernanza/requisitos/)
- Afecta múltiples dominios
- Define comportamiento del sistema completo
- Contrato entre dominios (ej: APIs)

## Referencias

- [Templates Globales](../../gobernanza/templates/)
- [Procedimientos](../../gobernanza/procedimientos/)
- [Trazabilidad](../../gobernanza/adr/ADR-GOB-009-trazabilidad-artefactos-requisitos.md)
