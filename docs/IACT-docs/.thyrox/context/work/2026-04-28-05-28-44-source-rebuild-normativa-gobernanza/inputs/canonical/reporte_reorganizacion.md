---
title: Reporte de Reorganización de Documentación
date: 2025-11-13
---

# Reporte de Reorganización de Documentación IACT

## Resumen Ejecutivo

- **Fecha:** 2025-11-13 12:02:12
- **Total archivos reorganizados:** 152
- **Método:** Auto-CoT + Self-Consistency
- **Estructura:** Jerarquía de 5 niveles de requisitos

## Distribución por Dominio

- **ai:** 40 archivos
- **backend:** 61 archivos
- **dora:** 5 archivos
- **frontend:** 11 archivos
- **gobernanza:** 16 archivos
- **infraestructura:** 19 archivos


## Archivos que Permanecen en docs/ Raíz

- `CATALOGO_TODOS_PENDIENTES.md`
- `CHANGELOG.md`
- `CONTRIBUTING.md`
- `INDEX.md`
- `INDICE.md`
- `ONBOARDING.md`
- `README.md`
- `RESUMEN_REMEDIACION_CRITICA_DOCS.md`
- `SETUP.md`


## Carpetas que Permanecen en docs/ Raíz

- `analisis/`
- `anexos/`
- `features/`
- `guias/`
- `operaciones/`
- `plans/`
- `scripts/`


## Estructura Aplicada

Cada dominio (ai, backend, frontend, infraestructura) ahora sigue:

```
docs/{dominio}/
├── adr/                      # Architecture Decision Records
├── arquitectura/             # High-Level Design
├── requisitos/               # Jerarquía de 5 niveles
│   ├── reglas_negocio/       # Nivel 1
│   ├── requerimientos_negocio/ # Nivel 2
│   ├── requerimientos_usuario/ # Nivel 3 (Casos de Uso)
│   ├── requerimientos_funcionales/ # Nivel 4
│   └── atributos_calidad/    # Nivel 5
├── diseno_detallado/
├── planificacion_y_releases/
├── qa/
├── deployment/
└── gobernanza/
```

## Marcos Conceptuales Aplicados

Los marcos de gobernanza están en:

1. **Reglas de Negocio:** `docs/gobernanza/marco_integrado/marco_reglas_negocio.md`
2. **Casos de Uso:** `docs/gobernanza/marco_integrado/marco_casos_uso.md`

Estos marcos se aplican a TODOS los dominios.

## Próximos Pasos

1. Revisar archivos reorganizados
2. Completar documentación faltante en cada nivel
3. Crear casos de uso siguiendo nomenclatura VERBO+OBJETO
4. Documentar reglas de negocio (5 tipos)
5. Actualizar trazabilidad entre niveles

## Referencias

- Clasificación: `/tmp/domain_classification_report.json`
- Estructura definida: `/tmp/estructura_dominios_final.md`
- Script usado: `/tmp/reorganize_docs_v2.py`
