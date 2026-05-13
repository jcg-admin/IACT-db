.. meta::
   :Proyecto: IACT
   :Codigo: UC-IACT-XXX-YY
   :Tipo: Actor_Secundario
   :Version: 4.0.0

======================================================================
UC-IACT-XXX-YY: [Nombre con Actores Múltiples]
======================================================================

ACTORES
~~~~~~~

Principal: [Usuario que inicia]
Secundario 1: [Sistema/Usuario que participa]
Secundario 2: [Otro actor]

DIAGRAMA DE ACTORES
~~~~~~~~~~~~~~~~~~~~

   [Actor Principal]
         |
         v
   [Sistema IACT]
         |
    +----+----+
    |         |
    v         v
[Sec 1]   [Sec 2]

FLUJO CON PARTICIPACION
~~~~~~~~~~~~~~~~~~~~~~~~

1. Actor Principal: Inicia acción
2. Sistema: Procesa
3. Sistema → Actor Secundario 1: Solicita info
4. Actor Secundario 1 → Sistema: Provee datos
5. Sistema → Actor Secundario 2: Notifica
6. Sistema → Actor Principal: Confirma

RESPONSABILIDADES POR ACTOR
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Principal: Iniciar, aprobar
Secundario 1: Proveer datos
Secundario 2: Recibir notificaciones

**Archivo:** TPL_UC_Actor_Secundario_1_1_0.rst
**Version:** 1.1.0
