```yml
id: ERR-021
created_at: 2026-03-28
type: Violación de proceso
severity: Alta
status: Detectado
```

# ERR-021: Sesión completa sin work-log

## Qué pasó

Una sesión de 44+ commits, 85+ archivos tocados, 3 ciclos completos de 7 fases, 21+ errores documentados — y zero work-logs en `context/work-logs/`.

## Causa raíz

El SKILL dice "Document sessions in work-logs/ if needed" en Phase 6. El "if needed" lo convierte en opcional. Ningún gate exige crear un work-log. No hay checkpoint al cerrar sesión.

## Impacto

Si alguien abre este proyecto mañana, tiene que leer 44 commits para entender qué pasó. Un work-log de 30 líneas lo resumiría en 2 minutos.

## Corrección propuesta

1. Crear work-log de esta sesión ahora
2. Cambiar SKILL.md Phase 6: de "if needed" a siempre
3. Agregar gate en EXIT_CONDITIONS Phase 7: "Work-log de sesión creado"
