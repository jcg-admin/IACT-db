---
id: RB-DEVOPS-005
estado: borrador
propietario: equipo-devops
ultima_actualizacion: 2025-02-19
relacionados: ["DOC-INDEX-GENERAL", "docs/mkdocs.yml"]
---
# Runbook: Instalación de MkDocs

Guía estandarizada para preparar MkDocs en estaciones de trabajo y servidores de documentación. Replica el formato corporativo y
conserva evidencia para auditorías.

## 1. Matriz de cumplimiento

| Requisito | Validación | Evidencia esperada |
| --- | --- | --- |
| Python ≥3.8 disponible | `python --version` | Salida similar a `Python 3.8.2`.
| `pip` operativo | `pip --version` | Ruta al entorno base (`.../site-packages/pip`). |
| MkDocs instalado | `mkdocs --version` | Respuesta `mkdocs, version X.Y.Z` sin errores. |
| PATH configurado (Windows) | `where python` / `where mkdocs` | Localiza binarios en `%PATH%`. |
| Documentación opcional (manpages) | `man mkdocs` | Página disponible tras ejecutar `click-man`. |

## 2. Preparación previa

1. **Verificar Python y pip**
   ```bash
   python --version
   pip --version
   ```
   - Si alguno falta, continúa con §3 y documenta la incidencia en la bitácora de DevOps.
2. **Revisar privilegios**
   - En Linux/macOS usa un entorno virtual o `pip install --user` si no tienes permisos de superusuario.
   - En Windows valida que tengas derechos para modificar `%APPDATA%\Python` y `%LOCALAPPDATA%\Programs\Python`.

## 3. Instalar o actualizar Python

1. **GNU/Linux**: utiliza el gestor de paquetes corporativo (por ejemplo `apt`, `dnf`).
   ```bash
   sudo apt update && sudo apt install python3 python3-pip
   ```
2. **macOS**: instala desde Homebrew (`brew install python`) o desde el instalador de `python.org`.
3. **Windows**: descarga el instalador oficial de [python.org](https://www.python.org/downloads/).
   - Durante la instalación marca **Add Python to PATH**.
   - Ejecuta `py --version` al finalizar para validar el registro del lanzador.

## 4. Gestionar pip

1. **Actualizar pip** (todas las plataformas):
   ```bash
   pip install --upgrade pip
   ```
   - En Windows puedes forzar el modo módulo si hay conflictos en PATH:
     ```bash
     python -m pip install --upgrade pip
     ```
2. **Instalar pip desde cero** (solo si no viene incluido):
   ```bash
   curl -O https://bootstrap.pypa.io/get-pip.py
   python get-pip.py
   ```
   - Conserva `get-pip.py` en `infrastructure/artifacts/` mientras se verifica la instalación y luego elimínalo.

## 5. Instalar MkDocs

1. **Instalación estándar**:
   ```bash
   pip install -r docs/requirements.txt
   ```
   - Alternativa Windows si `pip` no está en PATH:
     ```bash
    python -m pip install -r docs/requirements.txt
     ```
2. **Validar versión**:
   ```bash
   mkdocs --version
   ```
   - Comprueba que la ruta pertenezca al entorno corporativo y no a entornos personales.
3. **Registrar evidencia**
   - Captura la salida de `mkdocs --version` y súbela al ticket o wiki correspondiente.

## 6. Manpages opcionales

1. **Instalar `click-man`**:
   ```bash
   pip install click-man
   ```
2. **Generar páginas**:
   ```bash
   click-man --target /usr/local/share/man mkdocs
   ```
   - Ajusta la ruta de destino según la política del sistema (`~/share/man` en instalaciones sin privilegios).
3. **Verificar**:
   ```bash
   man mkdocs
   ```
   - Documenta si la organización prefiere omitir la generación de manpages por políticas de empaquetado.

## 7. Consideraciones específicas de Windows

- Prefija los comandos con `python -m` cuando `pip` o `mkdocs` no estén en `%PATH%`.
- Si persisten problemas de PATH, ejecuta `win_add2path.py` desde `C:\Python<versión>\Tools\Scripts\` o descarga el script
  oficial y ejecútalo:
  ```bash
  python win_add2path.py
  ```
- Tras ajustar el PATH, abre una nueva terminal PowerShell/CMD y valida:
  ```powershell
  where python
  where mkdocs
  ```
- Registra cualquier edición manual del PATH en la bitácora de DevOps, incluyendo usuario y timestamp.

## 8. Checklist de cierre

- [ ] `python --version` y `pip --version` capturados en evidencia.
- [ ] `mkdocs --version` registrado con la ruta correcta.
- [ ] (Opcional) Manpages generadas o decisión documentada.
- [ ] PATH validado en sistemas Windows cuando aplique.
- [ ] Incidentes o bloqueos escalados con logs adjuntos.

## 9. Escalamiento

1. **Fallas de proxy o firewall**
   - Adjunta salida de `pip --version`, `pip config list` y los mensajes de error.
   - Coordina con Seguridad para habilitar `https://pypi.org/` y `https://bootstrap.pypa.io/`.
2. **Conflictos de versiones**
   - Evalúa entornos virtuales dedicados (`python -m venv .venv`) y documenta el aislamiento aplicado.
3. **Repositorio corporativo**
   - Si MkDocs debe instalarse vía artefacto interno, levanta ADR correspondiente y actualiza este runbook.
