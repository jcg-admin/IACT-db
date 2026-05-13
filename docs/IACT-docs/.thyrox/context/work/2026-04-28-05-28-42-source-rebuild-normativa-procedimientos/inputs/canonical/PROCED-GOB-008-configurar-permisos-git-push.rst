PROCED-GOB-008: Configurar Permisos Git para Push de Tags y Branches
====================================================================

**ID:** PROCED-GOB-008 **Version:** 1.0.0 **Fecha:** 2025-11-17
**Categoria:** Infraestructura / Git / Permisos

--------------

1. PROPOSITO
------------

1.1 Objetivo
~~~~~~~~~~~~

Configurar permisos adecuados en Git y el proxy local para permitir push
de tags y branches sin errores HTTP 403, habilitando operaciones
completas de consolidacion de ramas.

1.2 Problema que Resuelve
~~~~~~~~~~~~~~~~~~~~~~~~~

Error actual al ejecutar:

::

   git push origin backup-pre-consolidacion-2025-11-17
   git push origin <tag-name>

Error recibido:

::

   error: RPC failed; HTTP 403 curl 22 The requested URL returned error: 403
   send-pack: unexpected disconnect while reading sideband packet
   fatal: the remote end hung up unexpectedly

1.3 Beneficios Esperados
~~~~~~~~~~~~~~~~~~~~~~~~

-  Push de tags exitoso para backups de seguridad
-  Push de branches sin restricciones
-  Ejecucion completa del plan de consolidacion de ramas
-  Operaciones Git sin limitaciones

--------------

2. ALCANCE
----------

2.1 Incluye
~~~~~~~~~~~

-  Configuracion de credenciales Git
-  Ajustes de permisos en proxy local
-  Validacion de acceso al repositorio remoto
-  Pruebas de push de tags y branches

2.2 Excluye
~~~~~~~~~~~

-  Cambios en configuracion del servidor remoto (GitHub/GitLab)
-  Modificacion de politicas de seguridad del repositorio
-  Configuracion de SSH (este procedimiento usa HTTPS)

2.3 Aplicabilidad
~~~~~~~~~~~~~~~~~

-  Entorno: Desarrollo local con proxy
-  Repositorio: 2-Coatl/IACT—project
-  URL remoto:
   http://local_proxy@127.0.0.1:61479/git/2-Coatl/IACT—project

--------------

3. PREREQUISITOS
----------------

3.1 Tecnicos
~~~~~~~~~~~~

-  ☐ Git 2.x o superior instalado
-  ☐ Acceso al entorno local
-  ☐ Permisos de escritura en directorio del repositorio
-  ☐ Conexion al proxy local activa (puerto 61479)

3.2 Credenciales
~~~~~~~~~~~~~~~~

-  ☐ Usuario Git: Claude
-  ☐ Email Git: noreply@anthropic.com
-  ☐ Token de acceso (si aplica)
-  ☐ Clave SSH (si se migra a SSH)

3.3 Conocimientos
~~~~~~~~~~~~~~~~~

-  ☐ Configuracion de Git (git config)
-  ☐ Manejo de credenciales
-  ☐ Debug de conexiones HTTP/HTTPS

--------------

4. DIAGNOSTICO INICIAL
----------------------

Paso 4.1: Verificar Configuracion Actual
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Ver configuracion completa
   git config --list | grep -E "remote.origin|user\.|credential|http"

   # Ver URL del remoto
   git remote -v

   # Ver configuracion de proxy/credenciales
   git config --get http.proxy
   git config --get credential.helper

**Documentar:** - URL remoto actual:
\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ - Credential helper:
\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_ - HTTP proxy:
\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_\_

Paso 4.2: Probar Push Actual
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Crear branch de prueba
   git branch test-push-permissions

   # Intentar push
   git push origin test-push-permissions 2>&1 | tee /tmp/push-test.log

   # Analizar error
   cat /tmp/push-test.log

**Resultado esperado:** Error HTTP 403 (confirma el problema)

Paso 4.3: Verificar Permisos del Proxy
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Ver proceso del proxy local
   ps aux | grep 61479

   # Ver logs del proxy (si accesibles)
   # Ubicacion depende de implementacion del proxy

   # Verificar conectividad
   curl -I http://127.0.0.1:61479/

--------------

5. SOLUCION 1: CONFIGURAR CREDENCIALES EXPLICITAS
-------------------------------------------------

Paso 5.1: Configurar Credential Helper
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Opcion A: Store (guarda en texto plano - desarrollo local)
   git config --global credential.helper store

   # Opcion B: Cache (temporal en memoria - mas seguro)
   git config --global credential.helper 'cache --timeout=3600'

   # Opcion C: Desactivar (si causa problemas)
   git config --global --unset credential.helper

**Recomendacion:** Usar cache para desarrollo local

Paso 5.2: Configurar Credenciales en URL
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Ver URL actual
   git remote get-url origin

   # Si no tiene credenciales embebidas, agregarlas:
   # Formato: http://usuario:token@host:puerto/ruta

   # Ejemplo (ajustar con credenciales reales):
   git remote set-url origin "http://local_proxy:TOKEN@127.0.0.1:61479/git/2-Coatl/IACT---project"

**IMPORTANTE:** Reemplazar TOKEN con token real de acceso

Paso 5.3: Validar Credenciales
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Probar push de nuevo
   git push origin test-push-permissions

   # Si falla, revisar logs
   git config --get-all credential.helper

--------------

6. SOLUCION 2: AJUSTAR CONFIGURACION HTTP
-----------------------------------------

Paso 6.1: Aumentar Buffer HTTP
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Aumentar buffer (ayuda con errores de conexion)
   git config --global http.postBuffer 524288000

   # Ver configuracion
   git config --get http.postBuffer

Paso 6.2: Configurar HTTP Version
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Forzar HTTP/1.1 (mas compatible)
   git config --global http.version HTTP/1.1

   # Ver configuracion
   git config --get http.version

Paso 6.3: Desactivar Verificacion SSL (solo desarrollo local)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # SOLO para desarrollo local con proxy auto-firmado
   git config --global http.sslVerify false

   # Verificar
   git config --get http.sslVerify

**ADVERTENCIA:** Solo usar en entorno desarrollo local, nunca en
produccion

--------------

7. SOLUCION 3: MIGRAR A SSH (ALTERNATIVA)
-----------------------------------------

Paso 7.1: Generar Clave SSH (si no existe)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Verificar si existe
   ls -la ~/.ssh/id_*

   # Generar nueva clave
   ssh-keygen -t ed25519 -C "noreply@anthropic.com" -f ~/.ssh/claude_git_key

   # Ver clave publica
   cat ~/.ssh/claude_git_key.pub

Paso 7.2: Agregar Clave al Agente SSH
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Iniciar agente
   eval "$(ssh-agent -s)"

   # Agregar clave
   ssh-add ~/.ssh/claude_git_key

   # Verificar claves cargadas
   ssh-add -l

Paso 7.3: Cambiar URL Remoto a SSH
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Ver URL actual (HTTP)
   git remote get-url origin

   # Cambiar a SSH (ajustar con host real)
   git remote set-url origin "git@github.com:2-Coatl/IACT---project.git"

   # Verificar cambio
   git remote -v

**NOTA:** Requiere agregar clave publica al servidor Git (GitHub/GitLab)

--------------

8. SOLUCION 4: CONFIGURAR PERMISOS EN PROXY LOCAL
-------------------------------------------------

Paso 8.1: Identificar Tipo de Proxy
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Ver proceso
   ps aux | grep 61479 | grep -v grep

   # Identificar si es:
   # - nginx
   # - squid
   # - custom proxy
   # - git-daemon

Paso 8.2: Configuracion Nginx (si aplica)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: nginx

   # Archivo: /etc/nginx/sites-available/git-proxy
   # O ubicacion del config del proxy

   location / {
       # Permitir metodos necesarios para Git
       limit_except GET POST PUT DELETE {
           deny all;
       }

       # Headers requeridos
       proxy_set_header Authorization $http_authorization;
       proxy_pass_request_headers on;

       # Timeouts
       proxy_connect_timeout 300s;
       proxy_send_timeout 300s;
       proxy_read_timeout 300s;
   }

Paso 8.3: Reiniciar Proxy
~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Si es nginx
   sudo systemctl restart nginx

   # Si es proceso custom
   pkill -HUP <proceso>

   # Verificar
   curl -I http://127.0.0.1:61479/

--------------

9. VALIDACION
-------------

Paso 9.1: Probar Push de Branch
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Crear branch de prueba
   git branch test-push-validation-$(date +%s)

   # Push
   git push origin test-push-validation-*

   # Verificar en remoto
   git branch -r | grep test-push-validation

**Criterio de exito:** Push exitoso sin error 403

Paso 9.2: Probar Push de Tag
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Crear tag de prueba
   git tag -a test-tag-validation -m "Test tag push"

   # Push
   git push origin test-tag-validation

   # Verificar en remoto
   git ls-remote --tags origin | grep test-tag-validation

**Criterio de exito:** Tag visible en remoto

Paso 9.3: Limpiar Pruebas
~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Eliminar branch de prueba
   git push origin --delete test-push-validation-*
   git branch -d test-push-validation-*

   # Eliminar tag de prueba
   git push origin --delete test-tag-validation
   git tag -d test-tag-validation

--------------

10. TROUBLESHOOTING
-------------------

Problema 1: Sigue error 403 tras configurar credenciales
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Diagnostico:**

.. code:: bash

   # Verificar credenciales almacenadas
   cat ~/.git-credentials

   # Ver log detallado
   GIT_CURL_VERBOSE=1 git push origin test-branch 2>&1 | tee /tmp/git-debug.log

**Solucion:** - Verificar que token tiene permisos write - Confirmar que
usuario tiene acceso al repositorio - Revisar politicas del repositorio
(proteccion de branches)

Problema 2: Error “Authentication failed”
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Diagnostico:**

.. code:: bash

   # Probar credenciales manualmente
   curl -u local_proxy:TOKEN http://127.0.0.1:61479/git/2-Coatl/IACT---project

**Solucion:** - Regenerar token de acceso - Verificar expiracion del
token - Confirmar formato del token en URL

Problema 3: Timeout en push
~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Diagnostico:**

.. code:: bash

   # Ver configuracion timeout
   git config --get http.timeout

   # Ver tamaño del push
   git count-objects -vH

**Solucion:**

.. code:: bash

   # Aumentar timeout
   git config --global http.timeout 600

   # Aumentar buffer
   git config --global http.postBuffer 1048576000

--------------

11. CONFIGURACION RECOMENDADA FINAL
-----------------------------------

Tras aplicar soluciones, configuracion recomendada:

.. code:: bash

   # Credenciales
   git config --global credential.helper 'cache --timeout=7200'

   # HTTP
   git config --global http.postBuffer 524288000
   git config --global http.version HTTP/1.1
   git config --global http.timeout 300

   # Usuario
   git config --global user.name "Claude"
   git config --global user.email "noreply@anthropic.com"

   # Remoto con credenciales
   git remote set-url origin "http://local_proxy:TOKEN@127.0.0.1:61479/git/2-Coatl/IACT---project"

--------------

12. ROLLBACK
------------

Si configuracion causa problemas:

.. code:: bash

   # Restaurar URL original
   git remote set-url origin "http://local_proxy@127.0.0.1:61479/git/2-Coatl/IACT---project"

   # Eliminar configuraciones HTTP
   git config --global --unset http.postBuffer
   git config --global --unset http.version
   git config --global --unset http.sslVerify
   git config --global --unset http.timeout

   # Eliminar credential helper
   git config --global --unset credential.helper

   # Limpiar cache de credenciales
   rm -f ~/.git-credentials

--------------

13. CHECKLIST DE EJECUCION
--------------------------

-  ☐ Diagnostico inicial completado
-  ☐ Solucion elegida: [ ] Cred. explicitas [ ] HTTP config [ ] SSH [ ]
   Proxy config
-  ☐ Configuracion aplicada
-  ☐ Push de branch validado (sin error 403)
-  ☐ Push de tag validado (sin error 403)
-  ☐ Pruebas limpiadas
-  ☐ Configuracion documentada
-  ☐ Procedimiento marcado como completado

--------------

14. SIGUIENTE PASO
------------------

Una vez completado este procedimiento:

1. Volver a TASK-001 del plan de consolidacion
2. Ejecutar push de backup exitosamente
3. Continuar con TASK-002 a TASK-014

**Link:**
docs/gobernanza/qa/QA-ANALISIS-RAMAS-001/TASK-001-crear-backup-seguridad/

--------------

15. REFERENCIAS
---------------

Documentacion Git
~~~~~~~~~~~~~~~~~

-  git-credential: https://git-scm.com/docs/git-credential
-  git-config: https://git-scm.com/docs/git-config
-  gitcredentials: https://git-scm.com/docs/gitcredentials

.. _troubleshooting-1:

Troubleshooting
~~~~~~~~~~~~~~~

-  HTTP 403: Permisos insuficientes
-  HTTP 401: Autenticacion fallida
-  Timeout: Buffer o timeout insuficiente

--------------

**Procedimiento creado:** 2025-11-17 **Ultima revision:** 2025-11-17
**Próxima revisión:** Post-aplicación **Estado:** ACTIVO **Version:**
1.0.0
