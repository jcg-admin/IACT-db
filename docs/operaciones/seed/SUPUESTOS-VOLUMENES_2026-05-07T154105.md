# Supuestos de volumenes por quarter

**Fecha:** 2026-05-07
**Contexto:** El seed original tenia 50K uniformes en todos los quarters.
Con `--rows 1000000` y escalas corregidas, cada quarter refleja una
volumetria plausible de produccion.

---

## Datos reales vs supuestos

| Quarter | Tabla | Filas sandbox | Escala | Volumen equiv. prod. | Fuente |
|---|---|---|---|---|---|
| Q01_25 | tbl_historico_t1_2025 | 1,000,000 | 1.000 | 11,643,679 | REAL — datos confirmados |
| Q02_25 | tbl_historico_t2_2025 | 1,169,000 | 1.169 | 13,612,375 | REAL — pico del anio |
| Q03_25 | tbl_historico_t3_2025 | 986,000 | 0.986 | 11,482,117 | REAL |
| Q04_25 | tbl_historico_t4_2025 | 1,069,000 | 1.069 | ~12,447,000 | SUPUESTO |
| Q01_26 | tbl_historico_t1_2026 | 1,039,000 | 1.039 | ~12,098,000 | SUPUESTO |
| Q02_26 | tbl_historico_t2_2026 | 486,000 | 0.486 | ~5,659,000 | SUPUESTO parcial |
| **TOTAL** | | **5,749,000** | | | |

---

## Razonamiento por supuesto

### Q04_25 — escala 1.069 (antes 0.993)

**Problema anterior:** promedio simple de Q01 y Q03 — sin logica de negocio.

**Supuesto nuevo:** Q4 tiene volumen mayor a Q3 por actividad de fin de ano.
Noviembre y diciembre concentran campanas comerciales (Buen Fin, fin de anio,
portabilidades, renovaciones de contrato). Se asume +8% sobre Q03_25.

```
Q03_25: 11,482,117 registros reales
Q04_25 supuesto: 11,482,117 × 1.084 = 12,446,620
Escala vs Q01_25: 12,446,620 / 11,643,679 = 1.069
```

### Q01_26 — escala 1.039 (antes 1.000)

**Problema anterior:** igual a Q01_25 — sin crecimiento YoY.

**Supuesto nuevo:** El sector telecom en Mexico crece 3-5% anual
(fuente general del sector). Se asume crecimiento conservador de +4%.

```
Q01_25 real: 11,643,679
Q01_26 supuesto: 11,643,679 × 1.04 = 12,099,426
Escala vs Q01_25: 12,099,426 / 11,643,679 = 1.039
```

### Q02_26 — escala 0.486 (antes 0.462)

**Problema anterior:** Q02_25 base × 36/91 dias — sin crecimiento YoY.

**Supuesto nuevo:** El quarter completo de Q02_26 creceria ~5% sobre Q02_25.
Se aplica la misma proporcion de dias parciales sobre el volumen proyectado.

```
Q02_25 real: 13,612,375
Q02_26 full supuesto: 13,612,375 × 1.05 = 14,292,994
Q02_26 parcial (36/91 dias): 14,292,994 × (36/91) = 5,654,370
Escala vs Q01_25: 5,654,370 / 11,643,679 = 0.486
```

---

## Por que importa la variacion

Con escalas uniformes (~1.0 en todo) el ETL siempre procesa
el mismo volumen, lo que no revela problemas que solo aparecen
con variaciones de carga como:

- Tiempo de procesamiento por mes (el mes mas largo del quarter
  puede ser 10% mayor en llamadas que el mas corto)
- Comportamiento del `ON DUPLICATE KEY UPDATE` con volumenes grandes
- Distribucion del grain: Q02 con 1.17M genera mas combinaciones
  unicas que Q01 con 1.0M
- Verificacion de que `pct_entre_semana` varia correctamente entre
  quarters (Q01=74%, Q02=~73%, Q03=~72%) segun la composicion
  real de dias de semana

---

## Comando para repoblar con estos supuestos

```bash
cd provisioners/mariadb

# Repoblar todo desde cero con supuestos correctos
python3 poblar_historico.py \
    --rows 1000000 \
    --truncate \
    --chunk 500 \
    --socket /run/mysqld/mysqld.sock

# Solo los quarters de supuesto (sin tocar los datos reales)
python3 poblar_historico.py \
    --rows 1000000 \
    --tables Q04_25 Q01_26 Q02_26 \
    --truncate \
    --chunk 500 \
    --socket /run/mysqld/mysqld.sock
```

Los quarters Q01_25, Q02_25, Q03_25 tienen escalas de datos reales
y no necesitan ajuste — solo los tres de supuesto.

---

## Limitaciones documentadas

1. Q04_25 usa el catalogo de menus de Q03_25 (proxy). Si en produccion
   Q04 introdujo menus nuevos en el IVR, el seed no los refleja.

2. Q01_26 usa el catalogo de menus de Q01_25. El IVR puede haber
   evolucionado en 2026 — sin datos reales no es posible saberlo.

3. El crecimiento YoY (+4% y +5%) es un supuesto conservador.
   El cliente podria haber crecido mas o menos segun estrategia comercial.

4. La proporcion de menus dentro de cada quarter es fija segun el perfil.
   En produccion esa distribucion puede variar estacionalmente dentro
   del mismo quarter.
