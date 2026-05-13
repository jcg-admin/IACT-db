# Playbook: tareas para Copilot CLI en Codespaces

> **Nota**: la verificación operativa y la bitácora viva se mantienen en `docs/07-devops/runbooks/github-copilot_codespaces.md`.

## Contexto
El énfasis cambia de la extensión tradicional hacia **GitHub Copilot CLI**. Queremos que cualquier Codespace (o estación local) pueda instalar una sola vez la CLI, autenticarse con la cuenta corporativa y comenzar a trabajar desde la terminal usando los flujos guiados por slash commands. Las dependencias previas (Node, npm) se encontraban en la imagen precisamente para soportar este escenario.

### Problema actual

- Las personas desarrolladoras siguen dependiendo de la extensión de VS Code; cuando las ventanas de autenticación se bloquean en redes corporativas no existe un respaldo oficial.
- Aún no se han documentado los flujos de “instala una vez, autentica y trabaja” pensados para la CLI, por lo que se desconoce el alcance real de la herramienta.
- No hay un checklist que traduzca los casos de uso clave (diagnóstico de repositorio, verificación de entorno, búsqueda de issues, automatización de PRs, utilidades operativas) al contexto del monolito de IACT.

## Qué vamos a crear

1. **Guía de instalación automatizada**
   - Validar versiones mínimas (`node >=22`, `npm >=10`).
   - Instalar `@github/copilot` mediante `npm install -g @github/copilot`.
   - Verificar que el comando `copilot` quede disponible para todas las shells.
2. **Checklist de autenticación**
   - Ejecutar `copilot` y navegar al flujo `/login`.
   - Documentar los permisos que se deben conceder (Copilot Pro/Business/Enterprise) y las validaciones con `gh auth status`.
3. **Guía de arranque rápido**
   - Preguntas sugeridas para entender la estructura del repositorio (`Explain the layout...`).
   - Comandos para verificar dependencias y estado del entorno (`Make sure my environment is ready...`).
4. **Rastreo de issues y priorización**
   - Uso del MCP de GitHub integrado para listar _good first issues_ ordenados por dificultad.
   - Criterios para registrar hallazgos en la wiki y asignar responsables.
5. **Flujo de implementación asistida**
   - Cómo pedir a Copilot que proponga un plan, muestre los diffs y solicite aprobación antes de aplicar cambios.
   - Validaciones previas a `git commit` y apertura de PR.
6. **Automatización de entrega**
   - Uso del comando para preparar commits y abrir PRs de forma asistida (manteniendo control humano).
   - Convenciones corporativas (Commits convencionales, vínculos a tickets, etc.).
7. **Utilidades de soporte**
   - Recetas para detectar procesos en puertos ocupados (ej. `/ask What process is using port 8080?`).
   - Reset de permisos (`/session`, `/reset`, `/add-directory`).
8. **Playbooks de extensión**
   - Documentar cómo agregar MCP adicionales (Playwright, herramientas internas) usando `/mcp`.
   - Checklist de seguridad para aprobar nuevos servidores MCP.

## Cómo lo vamos a distribuir

- Actualizar el runbook operativo (`docs/07-devops/runbooks/github-copilot_codespaces.md`) con los requisitos de versión, el nuevo flujo CLI y la matriz de cumplimiento alineada a `@github/copilot`.
- Generar ejemplos guiados (scripts o snippets) que puedan copiarse en la terminal para replicar los casos de uso descritos arriba. La sección §6 del runbook consolida este recetario con comandos listos para copiar.
- Añadir referencias cruzadas desde la wiki interna para que soporte y capacitación puedan seguir la misma guía.

## Próximos entregables

| Entregable | Responsable | Alcance |
|------------|-------------|---------|
| Actualización del `post-create.sh` | DevOps | Validar versiones de Node/npm e instalar `@github/copilot` automáticamente. |
| Manual de autenticación y primeros pasos | Capacitación | Capturas de `/login`, confirmación de planes compatibles y comandos de verificación. |
| Recetario de flujos CLI | Equipo de desarrollo | Ejemplos prácticos para onboarding, debugging y gestión de PRs desde la terminal. |
| Lineamientos de seguridad MCP | Seguridad TI | Criterios y proceso para aprobar MCP adicionales dentro del CLI. |

## Riesgos y mitigaciones

- **Falta de compatibilidad con Node antiguo** → Se documenta el requisito en los scripts y en el runbook; se aborta la instalación con un mensaje claro.
- **Cambios en el paquete de Copilot CLI** → Mantener vigilancia trimestral sobre la documentación oficial; agregar verificación manual en la checklist semanal.
- **Errores de autenticación** → Documentar procedimientos de `/reset` y la revalidación con GitHub CLI para liberar sesiones atascadas.

## Seguimiento

- Registrar en la wiki cada validación (fecha, persona responsable, red utilizada, resultado).
- Levantar incidentes en el tablero de plataforma cuando la CLI no pueda instalarse o autenticarse.
- Revisar métricas de adopción (número de personas usando la CLI vs. la extensión) cada sprint para ajustar la capacitación.
