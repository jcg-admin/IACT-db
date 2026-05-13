---
id: TASK-REORG-BACK-003
tipo: tarea
categoria: preparacion
titulo: Crear READMEs en Carpetas Nuevas
fase: FASE_1
prioridad: ALTA
duracion_estimada: 30min
estado: pendiente
dependencias: ["TASK-REORG-BACK-002"]
---

# TASK-REORG-BACK-003: Crear READMEs en Carpetas Nuevas

**Fase:** FASE 1 - Preparacion
**Prioridad:** ALTA
**Duracion Estimada:** 30 minutos
**Responsable:** Tech Writer
**Estado:** PENDIENTE

---

## Objetivo

Crear un README.md en cada una de las 13 carpetas nuevas, describiendo el proposito de la carpeta, tipo de contenido esperado y ejemplos.

---

## Prerequisitos

- [ ] TASK-002 completada (13 carpetas creadas)
- [ ] Plantilla de README definida

---

## Pasos de Ejecucion

### Paso 1: Crear README para adr/
```bash
cat > docs/backend/adr/README.md << 'EOF'
# Architecture Decision Records (ADR) - Backend

Este directorio contiene los Architecture Decision Records especificos del dominio backend.

## Proposito

Documentar decisiones arquitectonicas importantes del backend, incluyendo contexto, alternativas consideradas, decision tomada y consecuencias.

## Nomenclatura

```
ADR-BACK-###-titulo-snake-case.md
```

## Plantilla

Ver: `docs/backend/plantillas/plantilla-adr-backend.md`

## ADRs Existentes

(Lista se actualizara conforme se creen ADRs)

---
**Ultima actualizacion:** 2025-11-18
EOF
```

### Paso 2-13: Crear READMEs para carpetas restantes
(Repetir patron similar para las 12 carpetas restantes, adaptando proposito de cada una)

---

## Criterios de Exito

- [ ] 13 READMEs creados (uno por carpeta nueva)
- [ ] Cada README describe proposito de carpeta
- [ ] Cada README incluye seccion de nomenclatura
- [ ] Formato markdown consistente

---

## Validacion

```bash
# Verificar existencia de READMEs
for dir in adr catalogos ci_cd ejemplos estilos glosarios metodologias plantillas procesos referencias templates trazabilidad vision_y_alcance; do
 if [ -f "docs/backend/$dir/README.md" ]; then
 echo "OK: $dir/README.md"
 else
 echo "FALTA: $dir/README.md"
 fi
done
```

**Salida Esperada:** Todos muestran "OK"

---

## Tiempo de Ejecucion

**Inicio:** __:__
**Fin:** __:__
**Duracion Real:** __ minutos

---

**Tarea creada:** 2025-11-18
**Version:** 1.0.0
**Estado:** PENDIENTE
