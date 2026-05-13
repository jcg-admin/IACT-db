```yml
created_at: 2026-04-29 05:30:00
project: IACT-docs
work_package: 2026-04-28-01-58-08-source-rebuild-strategy
phase: Phase 11 — TRACK (deep-review independiente Fases 1+2)
author: claude
status: Aprobado
version: 1.0.0
```

# Deep-Review independiente — Remediation Fases 1 y 2 (2026-04-29)

## Resumen ejecutivo

**Veredicto: PARTIAL.**

Las Fases 1+2 cierran correctamente los 15 hallazgos del audit (B-1, B-2, R-1..R-5, G-1, Q-1..Q-6, E-1, P-1) en sus puntos focales: los 4 artefactos nuevos (CNST_032, CNST_033, ADR-GOB-008, PROC_Excepciones_CNST) son coherentes entre sí, las 8 decisiones D-RBAC están reflejadas en source/, y las cross-refs ACC↔PERM existen. Sin embargo, las 6 iteraciones rápidas introdujeron **drift residual no contemplado por el audit**: bloques internos de MTM_03 que conservan el modelo v4.0 (18 roles, R001/R016/R017), el glosario apunta a CNST_033 como "pendiente de creación" cuando ya existe, y conteos de funciones inconsistentes (42 vs 44) entre artefactos sincronizados el mismo día. Ningún drift bloquea uso operativo, pero contradicen explícitamente CNST_033 y D-RBAC-1.

## Hallazgos del deep-review

### F-DR-1 (ALTO) — MTM_03 conserva drift v4.0 fuera de § 3.2

`source/base_cognitiva/_taxonomias_y_metamodelos/metamodelos/MTM_03_Metamodelo_RBAC.rst:193` declara `codigo: VARCHAR(50) // R001-R018`; líneas 404-410 contienen tabla `PARES CONFLICTIVOS IACT` con R016/R017/R001 (modelo v4.0); líneas 654-673 (§ 8.2) tabula 4 roles legacy `USERS_FULL_MANAGER`, `SYSTEM_ADMIN`. La fix de B-1 sólo enriqueció § 3.2 con la nota v5.2.x sin purgar las tablas previas/posteriores. Contradice CNST_033 dentro del propio doc.

### F-DR-2 (ALTO) — Glosario contradice estado real de CNST_033

`source/base_cognitiva/glosario.rst:334-335` dice "ver CNST_033 Vocabulario Unificado RBAC, **pendiente de creación en WP #4 v3**". CNST_033 ya existe (`CNST_033_Vocabulario_Unificado_RBAC.rst:1-306`, version 1.0.0). Texto stale del WP #1 v3 no actualizado al cerrar WP #4 v3.

### F-DR-3 (ALTO) — Conteo inconsistente 42 vs 44 funciones

`rbac-formalization.md:152` declara "44 (v5.1.1) o 42 (v5.2.1)". CNST_029 no fija número. UC_ACC_01 (`UC_ACC_01_Asignar_Funciones.rst:62, 180, 435`) repite "44 disponibles" en flujo, FR-ACC-003 y diagramas. ADR-GOB-008:36 dice "Catalogo cerrado: 42 funciones". Tres artefactos canónicos sincronizados el 2026-04-29 con números distintos. D-RBAC-x no resolvió este conflicto.

### F-DR-4 (MEDIO) — `requisitos_funcionales/index.rst` carece de metadata estándar

`source/requisitos/requisitos_funcionales/index.rst:1-43` no tiene bloque `.. meta::` con `version`, `fecha_creacion`, `autor`, `estado` — a diferencia de `reglas_negocio/index.rst:1-12` (creado el mismo día con metadata completa). Q-5 cerrado de forma desigual frente a Q-4. Además, el toctree expone `users/`, `auth/`, `access/` (subdir UC) en cajón FR — confusión categorial: requisitos funcionales ≠ casos de uso.

### F-DR-5 (MEDIO) — UC_PERM_01 conserva vocabulario PERM granular en cuerpo

`UC_PERM_01_Asignar_Grupo_a_Usuario.rst:115` ("AuditoriaPermiso"), :326 ("usuarios_grupos"), :433 ("auditoria_permisos") usan tablas PERM. Aunque el grep de "Capacidad" da 0 (Q-2 cerrado para ese término concreto), CNST_033 también canonifica `UsuarioGrupo→UserGroupAssignment` y `AuditoriaPermiso→PermissionAudit`. El UC mantiene vocabulario tabla-PERM en flujos y RFs. Q-2 fue interpretado de forma estrecha (solo "Capacidad").

### F-DR-6 (MEDIO) — `reglas_negocio/index.rst` salta BR_016

Toctree (`source/requisitos/reglas_negocio/index.rst:28-46`) lista BR_001..BR_015, luego BR_017..BR_020. Falta BR_016 sin nota explicativa. Verificación: 19 archivos BR_*.rst en disco coinciden con el toctree, pero el gap numérico es incoherente con la convención sequential implícita y con MTM_03:725 que referencia "BR_006".

### F-DR-7 (MEDIO) — CNST_032 cita CNST_031 con doc-ref inexistente

`CNST_032_Menu_Dinamico_Obligatorio.rst:80` y CNST_029:80 referencian `:doc:\`CNST_031_Permisos_Temporales_Maximo_6_Meses\``. No verifiqué el archivo (fuera del set de 15) pero el patrón de naming difiere de CNST_032/033 (subrayado entre todos los tokens). Si CNST_031 vive con otro nombre canónico, los `:doc:` rompen el build Sphinx.

### F-DR-8 (BAJO) — ADR-GOB-008 cita "MOD_Permissions backend 75% completa" como dato cuantitativo

`ADR-GOB-008-rbac-coexistencia-acc-perm.rst:42, 104` afirma "Implementacion backend 75% completa". Viola `.claude/rules/calibration-verified-numbers.md` — número sin método de verificación citado. Severidad baja porque es contexto, no fundamento de la decisión.

## Aciertos detectados

1. **Coherencia D-RBAC fuerte.** Las 8 decisiones (D-RBAC-1..8) están explícitamente referenciadas con ID en CNST_032 (origen D-RBAC-5), CNST_033 (D-RBAC-1, D-RBAC-6), CNST_029 (D-RBAC-4), CNST_030 (D-RBAC-7) y consolidadas en ADR-GOB-008 § "Decisiones Relacionadas" — trazabilidad bidireccional impecable.
2. **Cross-refs UC_ACC↔UC_PERM efectivas.** Ambos UCs contienen el bloque `.. note:: Vista alternativa (coexistencia)` con `:doc:` recíproco al ADR-GOB-008, cerrando Q-3 con simetría.
3. **PROC_Excepciones_CNST cubre matriz por criticidad** (§ 4.3) con vigencias máximas alineadas a la severidad declarada en cada CNST — diseño consistente con el catálogo.
4. **STD_007 § 7 idioma tabla canónica** (`STD_007_Convencion_Naming.rst:399-447`) cubre 13 tipos de elemento, supera el alcance del hallazgo E-1 (que sólo pedía mención).
5. **Glosario § H** (8 términos) cubre los 7 términos de B-2 + AuditoriaPermiso, cada uno con `:doc:` al CNST canónico.

## Recomendaciones

| Hallazgo | Acción concreta |
|---|---|
| F-DR-1 | Iteración WP #1 v4: purgar líneas 193, 404-410, 654-673 de MTM_03 (o marcarlas explícitamente como "ejemplos legacy obsoletos"); regenerar tabla 8.2 con grupos AGR-001..010. |
| F-DR-2 | Edit en `glosario.rst:334-335`: cambiar "pendiente de creación en WP #4 v3" por `:doc:` directo al CNST_033 ya creado. |
| F-DR-3 | Decisión D-RBAC-9 nueva: fijar el número canónico (42 o 44). Propagar a UC_ACC_01 (3 sitios), rbac-formalization, ADR-GOB-008 y al futuro `Catalogo_Funciones.rst`. |
| F-DR-4 | Agregar bloque `.. meta::` a `requisitos_funcionales/index.rst` simétrico al de `reglas_negocio/index.rst`. Considerar mover `users/auth/access` del toctree FR (parecen UCs sembrados). |
| F-DR-5 | Q-2 v2: extender migración Capacidad→Funcion a tabla `UsuarioGrupo→UserGroupAssignment` y `AuditoriaPermiso→PermissionAudit` per CNST_033 § 2.1, en cuerpos UC_PERM. |
| F-DR-6 | Documentar gap BR_016 en `reglas_negocio/index.rst` (placeholder o nota "BR_016 deprecado/reservado"); o crear el BR faltante si fue olvido. |
| F-DR-7 | Grep `find source/normativa/restricciones -name 'CNST_031*'` y verificar build Sphinx. Si difiere, fix `:doc:` en CNST_032:80, CNST_029:80, CNST_030:244. |
| F-DR-8 | Reemplazar "75% completa" en ADR-GOB-008:42, :104 por afirmación calibrada o eliminar si no hay método de medida. |

## Trazabilidad

Documentos analizados (15/15):

- `source/normativa/restricciones/CNST_032_Menu_Dinamico_Obligatorio.rst` (1-263)
- `source/normativa/restricciones/CNST_033_Vocabulario_Unificado_RBAC.rst` (1-306)
- `source/normativa/restricciones/CNST_029_RBAC_Modelo_Plano.rst` (1-303)
- `source/normativa/restricciones/CNST_030_Reglas_de_Separacion_de_Funciones_SoD.rst` (1-273)
- `source/normativa/gobernanza/ADR-GOB-008-rbac-coexistencia-acc-perm.rst` (1-239)
- `source/normativa/procedimientos/PROC_Excepciones_CNST.rst` (1-198)
- `source/normativa/estandares/STD_007_Convencion_Naming.rst` (1-619)
- `source/base_cognitiva/glosario.rst` (1-499)
- `source/base_cognitiva/_taxonomias_y_metamodelos/metamodelos/MTM_03_Metamodelo_RBAC.rst` (1-728)
- `source/requisitos/casos_uso/access/UC_ACC_01_Asignar_Funciones.rst` (1-630)
- `source/requisitos/casos_uso/permissions/UC_PERM_01_Asignar_Grupo_a_Usuario.rst` (1-518)
- `source/requisitos/reglas_negocio/index.rst` (1-46)
- `source/requisitos/requisitos_funcionales/index.rst` (1-43)
- `track/cross-wp-deep-audit-2026-04-29.md` (audit referencia)
- `WP #6/analyze/rbac-formalization.md` (decisiones D-RBAC fuente)

Greps de verificación ejecutados:
- `grep -rn "Capacidad" source/requisitos/casos_uso/permissions/ | grep -v deprecated` → 0 (Q-2 cerrado en sentido estrecho)
- `grep "BR_" source/requisitos/reglas_negocio/index.rst` → 19 entradas, gap BR_016
- `ls source/requisitos/requisitos_no_funcionales/` → 2 RNFs presentes (Q-6 cerrado)
