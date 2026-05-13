# Casos de Uso (Plantilla UC-V2)

Este directorio almacena las especificaciones UC-V2 con trazabilidad bidireccional.

## Instrucciones
- Ubicar cada caso de uso en un archivo independiente (`UC-XXX.md`) siguiendo la Plantilla UC-V2.
- Completar campos obligatorios: actores, precondiciones, flujo básico, flujos alternos, trazabilidad upward (BR/RNF) y downward (UML/API/Código/Tests), riesgos y evidencia.
- Referenciar la matriz RTM-IACT para registrar relaciones `BR → UC → UML/API/Código/Tests` y validar la cobertura bidireccional.
- Asociar los RNF aplicables (p. ej., `RNF-AUD-001`, `RNF-NOT-001`) y los módulos implementadores en `api/callcentersite/src/callcentersite/apps/`.
- Incluir en el bloque de metadatos los enlaces a ADRs y reglas de negocio correspondientes.
- Mantener alineado el inventario de UC con la estructura `PRODUCTO_DASHBOARD_ANALYTICS/REQUISITOS/UC/` descrita en `docs/trazabilidad/REORGANIZACION_DOCS.md` y actualizar RTM cuando se agregue o modifique un UC.
