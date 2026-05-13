FASE 5: DEPLOYMENT - Plan de Despliegue Tests TDD
=================================================

**Agent**: SDLCDeploymentAgent **Fecha**: 2025-11-14 **Decisión**: GO
**Estrategia**: Rolling Deployment

--------------

Deployment Strategy
-------------------

Approach: Rolling Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Desplegar tests progresivamente por grupos, verificando cada uno antes
de proceder.

Rollout Plan
~~~~~~~~~~~~

**Week 1: Foundation** - Day 1: Setup infrastructure + conftest.py - Day
2-3: Grupo 1 (Técnicas Avanzadas) - Day 4: Validation y fixes

**Week 2: Expansion** - Day 5-7: Grupos 2-4 (Resto de técnicas) - Day 8:
Integration tests - Day 9: Documentation - Day 10: Final validation +
deployment

--------------

Pre-Deployment Checklist
------------------------

-  ☐ All tests implemented
-  ☐ Coverage >= 80%
-  ☐ CI/CD configured
-  ☐ Documentation complete
-  ☐ Code review approved
-  ☐ No blocking bugs

--------------

Deployment Steps
----------------

Step 1: Create Test Infrastructure
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   mkdir -p scripts/coding/ai/tests/techniques
   mkdir -p scripts/coding/ai/tests/fixtures
   mkdir -p scripts/coding/ai/tests/integration
   touch scripts/coding/ai/tests/__init__.py
   touch scripts/coding/ai/tests/techniques/__init__.py

Step 2: Deploy conftest.py
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Create conftest.py with shared fixtures
   cp docs/agent/design/conftest_template.py scripts/coding/ai/tests/conftest.py

Step 3: Deploy Test Files (Rolling)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Group 1
   git add scripts/coding/ai/tests/techniques/test_auto_cot_agent.py
   git add scripts/coding/ai/tests/techniques/test_self_consistency.py
   git commit -m "feat(tests): add Auto-CoT and Self-Consistency tests"

   # Verify
   pytest scripts/coding/ai/tests/techniques/test_auto_cot_agent.py -v
   pytest scripts/coding/ai/tests/techniques/test_self_consistency.py -v

   # If pass, continue with next group
   # If fail, fix and retry

Step 4: Activate CI/CD
~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Add GitHub Actions workflow
   cp docs/agent/testing/workflow_template.yml .github/workflows/test-prompting-techniques.yml
   git add .github/workflows/test-prompting-techniques.yml
   git commit -m "ci: add test workflow for prompting techniques"
   git push

Step 5: Monitor & Validate
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Watch CI/CD
   gh run watch

   # Generate coverage report
   pytest --cov=scripts/coding/ai/agents/base --cov-report=html
   open htmlcov/index.html

--------------

Rollback Plan
-------------

Trigger: Test failures in production
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Actions**: 1. Identify failing test 2. Disable in pytest.ini:
``ini  [pytest]  python_files = test_*.py  python_functions = test_*  markers =  slow: marks tests as slow  skip_on_ci: skip in CI``
3. Create hotfix 4. Re-deploy

Rollback Command
~~~~~~~~~~~~~~~~

.. code:: bash

   git revert <commit-hash>
   git push origin main

--------------

Health Checks
-------------

Post-Deployment Validation
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   # Run all tests
   pytest scripts/coding/ai/tests/ -v

   # Check coverage
   pytest --cov=scripts/coding/ai/agents/base --cov-report=term

   # Verify CI passing
   gh run list --workflow=test-prompting-techniques.yml

Success Criteria
~~~~~~~~~~~~~~~~

[OK] All tests pass locally [OK] All tests pass in CI [OK] Coverage >=
80% [OK] No performance degradation [OK] Documentation accessible

--------------

Monitoring
----------

Metrics to Track
~~~~~~~~~~~~~~~~

-  Test execution time
-  Test pass rate
-  Coverage percentage
-  Number of flaky tests
-  CI/CD pipeline duration

Alerting
~~~~~~~~

-  Email on CI failure
-  Slack notification on coverage drop
-  GitHub PR comments on test failures

--------------

Documentation
-------------

Files to Update
~~~~~~~~~~~~~~~

1. ``README.md`` - Add testing section
2. ``CONTRIBUTING.md`` - Add test guidelines
3. ``.github/agents/techniques/README.md`` - Link to tests
4. ``docs/agent/SDLC_COMPLETE_RUN.md`` - Document this process

--------------

Próximos Pasos
--------------

1. [OK] **APROBADO**: Proceder con implementación
2. Ejecutar deployment según plan
3. Monitorear métricas
4. Iterar basándose en feedback

**Decisión**: GO [OK]

--------------

**FIN DEL PIPELINE SDLC**

Todas las fases completadas exitosamente. Ahora proceder con la
implementación real de los tests TDD.
