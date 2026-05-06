# Investigación: Descubrimiento del formato NK90

**Script:** `qCentros_de_transferencia_ID.sql`
**Tipo:** Exploratorio — no es un reporte de producción
**Resultado:** Definición de BR-ROUTING-001 (normalización NK90)

---

## Qué es este script

Seis queries distintas que representan el proceso de descubrimiento
iterativo para entender el formato de `cDID_Centro_Transferencia`.
El equipo ejecutó cada variante hasta encontrar la extracción correcta
del VDN (número de enrutamiento real).

## Las 6 iteraciones

**Query 1:** `SUBSTRING(campo, 1, 10)` — toma los primeros 10 caracteres.
Asume que el VDN siempre tiene 10 dígitos. Incorrecto para VDNs de 7-8 dígitos.

**Query 2:** `LEFT(campo, LENGTH - 10)` — descarta los últimos 10 dígitos.
Primera aproximación correcta a la regla NK90. Funciona cuando el teléfono
digitado siempre tiene exactamente 10 dígitos.

**Query 3:** `CASE WHEN REGEXP y LENGTH > 10 THEN LEFT(...)  ELSE NULL`.
Agrega la condición de solo procesar campos con más de 10 dígitos.

**Query 4:** `CASE WHEN ... ELSE cDID_Centro_Transferencia`.
Primera versión que no descarta registros — los que no cumplen la condición
pasan tal cual. Más completa que la anterior.

**Query 5:** `CASE WHEN LENGTH > 10 THEN SUBSTRING(...)  ELSE campo`.
Simplifica a solo la condición de longitud, sin REGEXP. Versión más limpia.

**Query 6 (definitiva):** Verifica que el campo **termina** con `cTelefono_Digitado`
antes de extraer. Cuatro condiciones en cascada: termina con, comienza con,
contiene, o longitud mayor que el teléfono. La más robusta y la que confirma
la hipótesis NK90 (concatenación al final, no al inicio).

## Regla resultante (BR-ROUTING-001)

```sql
WHEN LENGTH(cDID_Centro_Transferencia) > 10
THEN LEFT(cDID_Centro_Transferencia,
          LENGTH(cDID_Centro_Transferencia) - 10)
```

La query 6 confirma que `cTelefono_Digitado` siempre va al final del campo.
Por eso `LEFT(campo, LENGTH - 10)` extrae el VDN real en todos los casos
donde `LENGTH > 10`.
