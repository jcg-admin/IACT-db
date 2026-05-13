.. meta::
   :Proyecto: IACT
   :Codigo: TRZ-IACT-001
   :Titulo: Matriz de Trazabilidad (RTM)
   :Version: 1.0.0

======================================================================
TRZ-IACT-001: Requirements Traceability Matrix
======================================================================

ESTRUCTURA RTM
~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 15 10 15 20 20 15 5

   * - ID BR
     - Tipo
     - UC Generado
     - FR Derivados
     - Código
     - Tests
     - Cov%
   * - BR-028
     - Restricción
     - UC-RPT-01 FA-2
     - FR-RPT-01-07
     - reports.py:234
     - test_count.py
     - 95%
   * - BR-031
     - Desencadenador
     - UC-AUTH-07
     - FR-AUTH-07-01
     - auth.py:89
     - test_notify.py
     - 100%

METRICAS DE COBERTURA
~~~~~~~~~~~~~~~~~~~~~~

**Fórmula Cobertura:**

.. code-block:: text

   Nivel 1 (BR→UC): UC_generados / BR_totales * 100
   Nivel 2 (UC→FR): FR_derivados / UC_totales * 100
   Nivel 3 (FR→Code): Archivos_impl / FR_totales * 100
   Nivel 4 (Code→Test): Tests_exist / Archivos_código * 100

**Dashboard:**

.. code-block:: text

   BR Total: 45
   UC Generados: 22 (49%)
   FR Derivados: 156 (709%)
   Código Impl: 156 archivos (100%)
   Tests: 156 archivos (100%)

SCRIPT GENERACION AUTOMATICA
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   #!/usr/bin/env python3
   """
   Genera matriz RTM desde archivos RST
   """
   import re
   import glob
   
   def parse_br_file(filepath):
       with open(filepath) as f:
           content = f.read()
       
       br_id = re.search(r'BR-IACT-(\d+)', content).group(0)
       br_type = re.search(r'Tipo: (\w+)', content).group(1)
       uc_gen = re.search(r'UC_IACT_\w+', content)
       uc_gen = uc_gen.group(0) if uc_gen else '-'
       
       return {
           'id': br_id,
           'type': br_type,
           'uc': uc_gen
       }
   
   def generate_rtm():
       brs = []
       for file in glob.glob('fundacionales/BR_*.rst'):
           brs.append(parse_br_file(file))
       
       # Generar tabla RST
       print(".. list-table::")
       print("   :header-rows: 1")
       for br in brs:
           print(f"   * - {br['id']}")
           print(f"     - {br['type']}")
           print(f"     - {br['uc']}")

   if __name__ == '__main__':
       generate_rtm()

**Archivo:** TPL_TRZ_Matriz_RTM_1_1_0.rst
**Version:** 1.1.0
