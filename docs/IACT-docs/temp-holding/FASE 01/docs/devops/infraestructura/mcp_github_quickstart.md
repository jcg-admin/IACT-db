---
id: DOC-MCP-GITHUB-QUICKSTART
estado: activo
propietario: equipo-devops
ultima_actualizacion: 2025-11-02
relacionados: ["RUNBOOK-CLAUDE-CODE", "DOC-DEVOPS-INDEX"]
---
# Guía Rápida: Servidor MCP de GitHub

## Resumen

Esta guía proporciona los pasos esenciales para configurar el servidor MCP (Model Context Protocol) de GitHub en Claude Code.

## Prerrequisitos

- [OK] Claude Code instalado
- [OK] Cuenta de GitHub activa
- [OK] Acceso a terminal/shell

## Configuración en 4 Pasos

### Paso 1: Crear Personal Access Token (PAT)

1. Visitar: https://github.com/settings/tokens
2. Click: "Generate new token" > "Generate new token (classic)"
3. Configurar:
   - **Note**: "Claude Code MCP Server"
   - **Expiration**: 90 days (recomendado)
   - **Scopes**:
     - [x] `repo` (Full control of private repositories)
     - [x] `read:packages` (Read packages)
     - [x] `read:org` (Read org and team membership)
4. Click: "Generate token"
5. **Copiar** el token (se muestra solo una vez)

### Paso 2: Configurar Variable de Entorno

```bash
# Abrir archivo de configuración del shell
nano ~/.bashrc

# Agregar al final del archivo:
export GITHUB_TOKEN="ghp_tu_token_aqui"

# Guardar (Ctrl+O) y salir (Ctrl+X)

# Aplicar cambios
source ~/.bashrc

# Verificar
echo ${GITHUB_TOKEN:0:10}...
# Debe mostrar: ghp_xxxxxx...
```

### Paso 3: Configurar Claude Code

```bash
# Editar configuración
nano ~/.claude.json

# Localizar la sección de tu proyecto:
# "projects": {
#   "/ruta/al/proyecto": {

# Agregar dentro de esa sección:
"mcpServers": {
  "github": {
    "type": "http",
    "url": "https://api.githubcopilot.com/mcp/",
    "headers": {
      "Authorization": "Bearer ${env:GITHUB_TOKEN}"
    }
  }
}

# Guardar y salir
```

**Ejemplo completo de configuración:**

```json
{
  "projects": {
    "/home/user/mi-proyecto": {
      "allowedTools": [],
      "history": [],
      "mcpContextUris": [],
      "mcpServers": {
        "github": {
          "type": "http",
          "url": "https://api.githubcopilot.com/mcp/",
          "headers": {
            "Authorization": "Bearer ${env:GITHUB_TOKEN}"
          }
        }
      },
      "enabledMcpjsonServers": []
    }
  }
}
```

### Paso 4: Reiniciar Claude Code

```bash
# Salir de la sesión actual
exit

# Iniciar nueva sesión
claude

# El servidor MCP debería estar activo
```

## Verificación

### Probar la Conexión

Solicitar a Claude Code:

```
"Muéstrame los últimos 5 issues abiertos de este repositorio"
```

Si responde con información de GitHub, [OK] la configuración es correcta.

### Verificar Manualmente

```bash
# Verificar variable de entorno
echo $GITHUB_TOKEN | wc -c
# Resultado esperado: > 50

# Verificar configuración
cat ~/.claude.json | grep -A 8 "mcpServers"
# Debe mostrar la configuración del servidor MCP

# Probar API de GitHub
curl -H "Authorization: Bearer $GITHUB_TOKEN" \
     https://api.github.com/user
# Debe responder con tu información de usuario
```

## Ejemplos de Uso

Una vez configurado, puedes solicitar a Claude Code:

### Issues

```
"Lista los issues abiertos etiquetados como 'bug'"
"Crea un issue titulado 'Fix login error' con descripción..."
"Muestra los comentarios del issue #123"
"Cierra el issue #456"
```

### Pull Requests

```
"Crea un PR para esta rama con título... y descripción..."
"Revisa el código del PR #789"
"Lista los PRs pendientes de review"
"Aprueba el PR #101"
```

### Repositorio

```
"Muéstrame la estructura de archivos del proyecto"
"Busca archivos que contengan 'authentication'"
"Muestra los últimos 10 commits"
"¿Quién modificó el archivo models.py recientemente?"
```

### CI/CD

```
"Muestra el estado de los workflows de GitHub Actions"
"¿Por qué falló el último build?"
"Lista todos los workflows disponibles"
"Ejecuta el workflow 'tests'"
```

## Troubleshooting

### Error: No responde

```bash
# 1. Verificar token
echo $GITHUB_TOKEN

# 2. Verificar permisos del token
# Ir a: https://github.com/settings/tokens
# Verificar scopes: repo, read:packages, read:org

# 3. Reiniciar Claude Code
exit
claude
```

### Error: Unauthorized

```bash
# Regenerar token con permisos correctos
# https://github.com/settings/tokens

# Actualizar en ~/.bashrc
nano ~/.bashrc
# Cambiar valor de GITHUB_TOKEN

# Recargar
source ~/.bashrc
```

### Error: Cannot connect

```bash
# Verificar conectividad
curl https://api.github.com/
# Debe responder con JSON

# Verificar API con token
curl -H "Authorization: Bearer $GITHUB_TOKEN" \
     https://api.github.com/user
# Debe mostrar tu usuario
```

## Seguridad

### Mejores Prácticas

- [OK] **Nunca commitear** el token a git
- [OK] **Permisos mínimos**: solo los scopes necesarios
- [OK] **Rotación**: cambiar token cada 90 días
- [OK] **Permisos de archivos**:
  ```bash
  chmod 600 ~/.bashrc
  chmod 600 ~/.claude.json
  ```
- [OK] **Agregar a .gitignore**:
  ```gitignore
  .env
  .env.local
  *.secret
  .claude.json
  ```

### Revocar Token

Si el token se compromete:

1. Ir a: https://github.com/settings/tokens
2. Localizar el token
3. Click en "Delete"
4. Generar nuevo token
5. Actualizar `~/.bashrc`

## Referencias

- [Runbook Claude Code](./runbooks/claude_code.md)
- [GitHub MCP Server](https://github.com/github/github-mcp-server)
- [Model Context Protocol](https://modelcontextprotocol.io/)
- [GitHub Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)

## FAQ

**¿Es seguro usar tokens en variables de entorno?**

[OK] Sí, siempre que:
- El archivo `.bashrc` tenga permisos restrictivos (`chmod 600`)
- No se commitee a git
- Se rote periódicamente

**¿Puedo usar el mismo token para múltiples proyectos?**

[OK] Sí, pero es mejor crear tokens separados por proyecto para:
- Mejor control de acceso
- Facilitar revocación si es necesario
- Auditoría más clara

**¿Qué pasa si el token expira?**

[WARN] El servidor MCP dejará de funcionar. Necesitas:
1. Generar nuevo token
2. Actualizar `~/.bashrc`
3. Reiniciar Claude Code

**¿El servidor MCP funciona offline?**

[NO] Requiere conexión a internet para acceder a la API de GitHub.

**¿Puedo usar GitHub Enterprise?**

[OK] Sí, configurando la variable de entorno:
```bash
export GITHUB_HOST="https://github.empresa.com"
```

## Soporte

Para problemas o preguntas:

1. Revisar [Troubleshooting MCP](./runbooks/claude_code.md#troubleshooting-mcp)
2. Consultar [Issues del repositorio](https://github.com/2-Coatl/IACT---project/issues)
3. Contactar al equipo DevOps

## Changelog

- **2025-11-02 v1**: Creación inicial
  - Guía de configuración en 4 pasos
  - Ejemplos de uso
  - Troubleshooting
  - Mejores prácticas de seguridad
