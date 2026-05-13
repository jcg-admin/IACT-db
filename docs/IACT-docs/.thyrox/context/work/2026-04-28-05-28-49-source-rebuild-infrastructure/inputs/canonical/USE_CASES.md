# IACT Automation System - Use Cases Documentation

**Document Type:** Use Cases Catalog
**Project:** IACT (Django 5 + React + PostgreSQL + MariaDB)
**Scope:** 7 Real Automation Agents
**Total Use Cases:** 70 (10 per agent)
**Version:** 1.0
**Date:** 2025-11-14

---

## Table of Contents

1. [Schema Validator Agent Use Cases](#1-schema-validator-agent-use-cases) (UC-001 to UC-010)
2. [DevContainer Validator Agent Use Cases](#2-devcontainer-validator-agent-use-cases) (UC-011 to UC-020)
3. [Metrics Collector Agent Use Cases](#3-metrics-collector-agent-use-cases) (UC-021 to UC-030)
4. [Coherence Analyzer Agent Use Cases](#4-coherence-analyzer-agent-use-cases) (UC-031 to UC-040)
5. [Constitution Validator Agent Use Cases](#5-constitution-validator-agent-use-cases) (UC-041 to UC-050)
6. [CI Pipeline Orchestrator Agent Use Cases](#6-ci-pipeline-orchestrator-agent-use-cases) (UC-051 to UC-060)
7. [PDCA Agent Use Cases](#7-pdca-agent-use-cases) (UC-061 to UC-070)

---

## 1. Schema Validator Agent Use Cases

### UC-001: Validate .constitucion.yaml Syntax

**Actor:** Developer, CI Pipeline
**Preconditions:** .constitucion.yaml file exists in project root
**Main Flow:**
1. Developer runs schema validator on .constitucion.yaml
2. Agent validates YAML syntax
3. Agent reports validation result
**Expected Outcome:** Valid YAML confirmed or syntax errors reported
**Example:**
```bash
python scripts/coding/ai/automation/schema_validator_agent.py --config .constitucion.yaml --mode syntax
```

---

### UC-002: Validate .constitucion.yaml Against JSON Schema

**Actor:** Developer, Pre-Push Hook
**Preconditions:** .constitucion.yaml and schemas/constitucion_schema.json exist
**Main Flow:**
1. Developer commits changes to .constitucion.yaml
2. Pre-push hook invokes schema validator
3. Agent validates against JSON schema
4. Agent reports schema compliance
**Expected Outcome:** Schema compliance verified or violations reported with specific errors
**Example:**
```bash
python scripts/coding/ai/automation/schema_validator_agent.py --config .constitucion.yaml --schema schemas/constitucion_schema.json
```

---

### UC-003: Validate Reference Integrity in Configuration

**Actor:** CI Pipeline
**Preconditions:** .constitucion.yaml contains principle_id references
**Main Flow:**
1. CI pipeline runs schema validation
2. Agent validates all principle_id references exist
3. Agent checks for dangling references
**Expected Outcome:** All references validated or broken references reported
**Example:**
```bash
python scripts/coding/ai/automation/schema_validator_agent.py --config .constitucion.yaml --check-references
```

---

### UC-004: Validate .ci-local.yaml Syntax

**Actor:** Developer
**Preconditions:** .ci-local.yaml file exists
**Main Flow:**
1. Developer modifies CI pipeline configuration
2. Developer runs schema validator
3. Agent validates YAML syntax
**Expected Outcome:** Valid YAML syntax confirmed
**Example:**
```bash
python scripts/coding/ai/automation/schema_validator_agent.py --config .ci-local.yaml --mode syntax
```

---

### UC-005: Validate CI Pipeline Stage Dependencies

**Actor:** CI Pipeline, Developer
**Preconditions:** .ci-local.yaml contains stage dependencies
**Main Flow:**
1. Developer defines new pipeline stage with dependencies
2. Schema validator checks dependency references
3. Agent validates no circular dependencies exist
**Expected Outcome:** Dependencies validated or circular dependencies reported
**Example:**
```bash
python scripts/coding/ai/automation/schema_validator_agent.py --config .ci-local.yaml --check-dependencies
```

---

### UC-006: Validate Type Constraints in Configuration

**Actor:** Developer
**Preconditions:** Configuration file contains type-specific fields
**Main Flow:**
1. Developer sets severity levels in .constitucion.yaml
2. Schema validator checks type constraints (enum values)
3. Agent validates booleans, integers, strings
**Expected Outcome:** Type compliance confirmed or type errors reported
**Example:**
```bash
python scripts/coding/ai/automation/schema_validator_agent.py --config .constitucion.yaml --strict-types
```

---

### UC-007: Generate JSON Validation Report

**Actor:** CI Pipeline
**Preconditions:** Configuration file provided
**Main Flow:**
1. CI pipeline invokes schema validator with JSON output
2. Agent performs complete validation
3. Agent outputs structured JSON report
**Expected Outcome:** JSON report with validation results for downstream processing
**Example:**
```bash
python scripts/coding/ai/automation/schema_validator_agent.py --config .constitucion.yaml --output json
```

---

### UC-008: Validate Multiple Configuration Files in Batch

**Actor:** Developer, CI Pipeline
**Preconditions:** Multiple YAML configuration files exist
**Main Flow:**
1. Developer provides list of configuration files
2. Agent validates each file sequentially
3. Agent aggregates results
**Expected Outcome:** Batch validation report with per-file status
**Example:**
```bash
python scripts/coding/ai/automation/schema_validator_agent.py --batch .constitucion.yaml,.ci-local.yaml
```

---

### UC-009: Validate Configuration Before Deployment

**Actor:** Deployment Pipeline
**Preconditions:** Production configuration ready for deployment
**Main Flow:**
1. Deployment pipeline runs final validation
2. Agent performs comprehensive schema validation
3. Agent blocks deployment if validation fails
**Expected Outcome:** Deployment proceeds only if configuration valid
**Example:**
```bash
python scripts/coding/ai/automation/schema_validator_agent.py --config .constitucion.yaml --strict || exit 1
```

---

### UC-010: Dry-Run Validation Mode

**Actor:** Developer
**Preconditions:** Developer wants to test configuration changes
**Main Flow:**
1. Developer modifies configuration file
2. Developer runs validation in dry-run mode
3. Agent validates without committing changes
**Expected Outcome:** Validation results without side effects
**Example:**
```bash
python scripts/coding/ai/automation/schema_validator_agent.py --config .constitucion.yaml --dry-run
```

---

## 2. DevContainer Validator Agent Use Cases

### UC-011: Validate PostgreSQL Service Health

**Actor:** DevContainer Initialization, Developer
**Preconditions:** DevContainer started, PostgreSQL should be running on port 5432
**Main Flow:**
1. DevContainer init script invokes validator
2. Agent checks PostgreSQL connectivity on port 5432
3. Agent validates database accepts connections
**Expected Outcome:** PostgreSQL service confirmed healthy or connection error reported
**Example:**
```bash
python scripts/coding/ai/automation/devcontainer_validator_agent.py --check-service postgresql
```

---

### UC-012: Validate MariaDB Service Health

**Actor:** DevContainer Initialization
**Preconditions:** DevContainer started, MariaDB should be running on port 3306
**Main Flow:**
1. Init script invokes validator for MariaDB
2. Agent checks MariaDB connectivity on port 3306
3. Agent validates IVR database accessibility
**Expected Outcome:** MariaDB service confirmed healthy for IVR data access
**Example:**
```bash
python scripts/coding/ai/automation/devcontainer_validator_agent.py --check-service mariadb
```

---

### UC-013: Validate Python Version

**Actor:** DevContainer Initialization
**Preconditions:** Python 3.12.x should be installed
**Main Flow:**
1. Init script checks Python version
2. Agent validates Python version matches 3.12.x
3. Agent reports version compliance
**Expected Outcome:** Python 3.12.x confirmed installed
**Example:**
```bash
python scripts/coding/ai/automation/devcontainer_validator_agent.py --check-version python --expected 3.12
```

---

### UC-014: Validate Node.js Version

**Actor:** DevContainer Initialization
**Preconditions:** Node.js 18.x should be installed for React development
**Main Flow:**
1. Init script validates Node version
2. Agent checks Node.js version matches 18.x
3. Agent validates npm is available
**Expected Outcome:** Node.js 18.x and npm confirmed available
**Example:**
```bash
python scripts/coding/ai/automation/devcontainer_validator_agent.py --check-version node --expected 18
```

---

### UC-015: Validate Required CLI Tools

**Actor:** DevContainer Initialization
**Preconditions:** Tools yq, jq, git must be installed
**Main Flow:**
1. Init script validates CLI tool availability
2. Agent checks each required tool
3. Agent reports missing tools
**Expected Outcome:** All required tools confirmed available or missing tools listed
**Example:**
```bash
python scripts/coding/ai/automation/devcontainer_validator_agent.py --check-tools yq,jq,git
```

---

### UC-016: Validate Port Availability

**Actor:** DevContainer Initialization
**Preconditions:** Ports 5432, 3306, 8000, 3000 should be available
**Main Flow:**
1. Init script checks port availability
2. Agent validates each port is not in use
3. Agent reports port conflicts
**Expected Outcome:** All required ports available or conflicts reported
**Example:**
```bash
python scripts/coding/ai/automation/devcontainer_validator_agent.py --check-ports 5432,3306,8000,3000
```

---

### UC-017: Validate Environment Variables

**Actor:** DevContainer Initialization, Developer
**Preconditions:** .env file contains required database credentials
**Main Flow:**
1. Developer starts DevContainer
2. Agent validates required environment variables exist
3. Agent checks DB_ANALYTICS_HOST, DB_IVR_HOST, etc.
**Expected Outcome:** All environment variables present or missing vars reported
**Example:**
```bash
python scripts/coding/ai/automation/devcontainer_validator_agent.py --check-env DB_ANALYTICS_HOST,DB_IVR_HOST
```

---

### UC-018: Validate devcontainer.json Schema

**Actor:** Developer
**Preconditions:** .devcontainer/devcontainer.json file exists
**Main Flow:**
1. Developer modifies devcontainer.json
2. Agent validates JSON syntax and schema
3. Agent checks required fields (name, image, features)
**Expected Outcome:** devcontainer.json validated or errors reported
**Example:**
```bash
python scripts/coding/ai/automation/devcontainer_validator_agent.py --check-config .devcontainer/devcontainer.json
```

---

### UC-019: Comprehensive Environment Health Check

**Actor:** Developer, CI Pipeline
**Preconditions:** DevContainer fully initialized
**Main Flow:**
1. Developer runs comprehensive health check
2. Agent validates services, versions, tools, ports, env vars
3. Agent generates health report
**Expected Outcome:** Complete environment health status report
**Example:**
```bash
python scripts/coding/ai/automation/devcontainer_validator_agent.py --full-check --output json
```

---

### UC-020: Validate Database Connectivity with Test Query

**Actor:** Developer
**Preconditions:** PostgreSQL and MariaDB services running
**Main Flow:**
1. Developer validates database connectivity
2. Agent executes test queries on both databases
3. Agent confirms successful connection and query execution
**Expected Outcome:** Database connectivity verified with test queries
**Example:**
```bash
python scripts/coding/ai/automation/devcontainer_validator_agent.py --test-db-connection
```

---

## 3. Metrics Collector Agent Use Cases

### UC-021: Collect Constitution Violation Metrics

**Actor:** CI Pipeline, Developer
**Preconditions:** Constitution validator logs exist
**Main Flow:**
1. CI pipeline invokes metrics collector
2. Agent parses violation logs
3. Agent aggregates violations by rule (R1-R6)
**Expected Outcome:** Violation metrics report by rule, severity, and file
**Example:**
```bash
python scripts/coding/ai/automation/metrics_collector_agent.py --source constitution --output json
```

---

### UC-022: Track Violations by Rule

**Actor:** DevOps Team
**Preconditions:** Violation logs from multiple CI runs
**Main Flow:**
1. DevOps runs metrics collector for specific rule
2. Agent filters violations by rule (e.g., R2 - no emojis)
3. Agent reports violation trend
**Expected Outcome:** Rule-specific violation metrics with trend analysis
**Example:**
```bash
python scripts/coding/ai/automation/metrics_collector_agent.py --rule R2 --period 7days
```

---

### UC-023: Track Violations by Severity

**Actor:** DevOps Team
**Preconditions:** Violation logs contain severity levels
**Main Flow:**
1. DevOps requests severity-based metrics
2. Agent aggregates violations by severity (ERROR, WARNING)
3. Agent generates severity distribution report
**Expected Outcome:** Violation count by severity level
**Example:**
```bash
python scripts/coding/ai/automation/metrics_collector_agent.py --group-by severity
```

---

### UC-024: Track Violations by File

**Actor:** Developer
**Preconditions:** Violation logs identify specific files
**Main Flow:**
1. Developer wants to know which files have most violations
2. Agent aggregates violations by file path
3. Agent ranks files by violation count
**Expected Outcome:** Ranked list of files by violation frequency
**Example:**
```bash
python scripts/coding/ai/automation/metrics_collector_agent.py --group-by file --top 10
```

---

### UC-025: Collect CI Pipeline Duration Metrics

**Actor:** DevOps Team, CI Pipeline
**Preconditions:** CI pipeline execution logs available
**Main Flow:**
1. CI pipeline completes execution
2. Metrics collector extracts pipeline duration
3. Agent tracks duration trend over time
**Expected Outcome:** Pipeline duration metrics and trend analysis
**Example:**
```bash
python scripts/coding/ai/automation/metrics_collector_agent.py --metric pipeline-duration --period 30days
```

---

### UC-026: Track CI Pipeline Success Rate

**Actor:** DevOps Team
**Preconditions:** CI pipeline logs with success/failure status
**Main Flow:**
1. DevOps requests pipeline success rate
2. Agent calculates success percentage
3. Agent identifies failure patterns
**Expected Outcome:** Success rate percentage and failure analysis
**Example:**
```bash
python scripts/coding/ai/automation/metrics_collector_agent.py --metric success-rate --period 7days
```

---

### UC-027: Analyze Test Coverage Trends

**Actor:** QA Team, DevOps
**Preconditions:** Test coverage reports from multiple runs
**Main Flow:**
1. QA team requests coverage trend analysis
2. Agent parses coverage reports
3. Agent calculates coverage trend (increasing/decreasing/stable)
**Expected Outcome:** Coverage trend with direction indicator
**Example:**
```bash
python scripts/coding/ai/automation/metrics_collector_agent.py --metric coverage --trend
```

---

### UC-028: Track Developer Compliance Metrics

**Actor:** Engineering Manager
**Preconditions:** Violation logs tagged with developer commits
**Main Flow:**
1. Manager requests developer-specific metrics
2. Agent aggregates violations by developer
3. Agent generates compliance scorecard
**Expected Outcome:** Developer compliance metrics (anonymized or by-dev)
**Example:**
```bash
python scripts/coding/ai/automation/metrics_collector_agent.py --by-developer --anonymize
```

---

### UC-029: Generate Metrics Dashboard Data

**Actor:** DevOps Team
**Preconditions:** Historical metrics data available
**Main Flow:**
1. DevOps requests metrics for dashboard
2. Agent aggregates all metrics (violations, duration, success rate, coverage)
3. Agent outputs dashboard-ready JSON
**Expected Outcome:** JSON data for metrics dashboard visualization
**Example:**
```bash
python scripts/coding/ai/automation/metrics_collector_agent.py --dashboard --format json
```

---

### UC-030: Generate Markdown Metrics Report

**Actor:** Engineering Manager
**Preconditions:** Metrics data collected
**Main Flow:**
1. Manager requests executive summary report
2. Agent generates formatted Markdown report
3. Report includes trends, top violations, recommendations
**Expected Outcome:** Executive-friendly Markdown report
**Example:**
```bash
python scripts/coding/ai/automation/metrics_collector_agent.py --report --format markdown --output metrics_report.md
```

---

## 4. Coherence Analyzer Agent Use Cases

### UC-031: Analyze UI/API Coherence After API Change

**Actor:** Developer, CI Pipeline
**Preconditions:** Developer modified Django API endpoint
**Main Flow:**
1. Developer commits API changes
2. CI pipeline invokes coherence analyzer
3. Agent detects API endpoint changes via AST parsing
4. Agent checks if corresponding UI services exist
**Expected Outcome:** Coherence report identifying missing UI updates
**Example:**
```bash
python scripts/coding/ai/automation/coherence_analyzer_agent.py --check api-ui --base main
```

---

### UC-032: Detect Missing UI Services for New API Endpoint

**Actor:** CI Pipeline
**Preconditions:** New API endpoint added to Django views
**Main Flow:**
1. Developer adds new ViewSet in api/callcentersite/views.py
2. Coherence analyzer parses API changes
3. Agent searches for corresponding service in ui/services/
4. Agent reports if service is missing
**Expected Outcome:** Gap detection report for missing UI service
**Example:**
```bash
python scripts/coding/ai/automation/coherence_analyzer_agent.py --detect-gaps --scope new-endpoints
```

---

### UC-033: Detect Missing UI Tests for API Changes

**Actor:** QA Team, CI Pipeline
**Preconditions:** API endpoint modified, UI service exists
**Main Flow:**
1. QA validates test coverage for API changes
2. Coherence analyzer checks for UI tests
3. Agent identifies missing test coverage
**Expected Outcome:** List of UI components lacking tests for changed APIs
**Example:**
```bash
python scripts/coding/ai/automation/coherence_analyzer_agent.py --check-tests --api-changes
```

---

### UC-034: Analyze Django Serializer Changes

**Actor:** Developer
**Preconditions:** Django serializer fields modified
**Main Flow:**
1. Developer modifies serializer in serializers.py
2. Coherence analyzer detects field changes
3. Agent checks if UI TypeScript interfaces updated
**Expected Outcome:** Report of serializer-interface coherence status
**Example:**
```bash
python scripts/coding/ai/automation/coherence_analyzer_agent.py --check serializers --base main
```

---

### UC-035: Detect Removed API Endpoints

**Actor:** CI Pipeline
**Preconditions:** Developer removed deprecated API endpoint
**Main Flow:**
1. Developer removes ViewSet from views.py
2. Coherence analyzer detects endpoint removal
3. Agent checks if UI services still reference removed endpoint
**Expected Outcome:** Warning about UI services referencing deleted endpoint
**Example:**
```bash
python scripts/coding/ai/automation/coherence_analyzer_agent.py --detect-removals
```

---

### UC-036: Correlation Analysis API to UI Service

**Actor:** Developer
**Preconditions:** Complete codebase with API and UI
**Main Flow:**
1. Developer requests correlation analysis
2. Agent performs AST parsing on API and UI code
3. Agent correlates API endpoints with UI services
4. Agent assigns confidence scores to correlations
**Expected Outcome:** Correlation map with confidence scores
**Example:**
```bash
python scripts/coding/ai/automation/coherence_analyzer_agent.py --correlate --confidence-threshold 70
```

---

### UC-037: Analyze GraphQL Schema Changes

**Actor:** Developer
**Preconditions:** GraphQL schema modified
**Main Flow:**
1. Developer updates GraphQL schema
2. Coherence analyzer detects schema changes
3. Agent checks if UI GraphQL queries updated
**Expected Outcome:** GraphQL schema-query coherence report
**Example:**
```bash
python scripts/coding/ai/automation/coherence_analyzer_agent.py --check graphql-schema
```

---

### UC-038: Generate Coherence Report for Pull Request

**Actor:** CI Pipeline
**Preconditions:** Pull request with API and/or UI changes
**Main Flow:**
1. Pull request triggers CI pipeline
2. Coherence analyzer runs on PR diff
3. Agent generates coherence report for PR review
**Expected Outcome:** Coherence status comment posted to PR
**Example:**
```bash
python scripts/coding/ai/automation/coherence_analyzer_agent.py --pr-mode --base main --head feature-branch
```

---

### UC-039: Validate API-UI Coherence Before Merge

**Actor:** CI Pipeline
**Preconditions:** Pull request ready for merge
**Main Flow:**
1. Pre-merge validation triggered
2. Coherence analyzer performs full check
3. Agent blocks merge if coherence score below threshold
**Expected Outcome:** Merge allowed only if coherence acceptable
**Example:**
```bash
python scripts/coding/ai/automation/coherence_analyzer_agent.py --gate --threshold 80 || exit 1
```

---

### UC-040: Identify High-Confidence Coherence Gaps

**Actor:** Tech Lead
**Preconditions:** Coherence analysis completed
**Main Flow:**
1. Tech lead requests high-priority gaps
2. Agent filters gaps by confidence score > 80
3. Agent outputs actionable gap list
**Expected Outcome:** Prioritized list of coherence gaps to fix
**Example:**
```bash
python scripts/coding/ai/automation/coherence_analyzer_agent.py --gaps --min-confidence 80
```

---

## 5. Constitution Validator Agent Use Cases

### UC-041: Validate No Direct Push to Main (R1)

**Actor:** Pre-Push Hook
**Preconditions:** Developer attempting to push to main/master
**Main Flow:**
1. Developer runs git push to main
2. Pre-push hook invokes constitution validator
3. Agent validates branch protection rule (R1)
4. Agent blocks push if target is main/master
**Expected Outcome:** Push blocked with error message
**Example:**
```bash
python scripts/coding/ai/automation/constitution_validator_agent.py --mode pre-push --rule R1
```

---

### UC-042: Validate No Emojis in Code (R2)

**Actor:** Pre-Commit Hook
**Preconditions:** Developer committing code changes
**Main Flow:**
1. Developer runs git commit
2. Pre-commit hook invokes constitution validator
3. Agent scans changed files for Unicode emojis
4. Agent reports violations if emojis detected
**Expected Outcome:** Commit blocked if emojis found, with file/line info
**Example:**
```bash
python scripts/coding/ai/automation/constitution_validator_agent.py --mode pre-commit --rule R2
```

---

### UC-043: Validate UI/API Coherence (R3)

**Actor:** Pre-Push Hook
**Preconditions:** Developer pushing API or UI changes
**Main Flow:**
1. Developer pushes changes
2. Constitution validator invokes coherence analyzer
3. Agent validates UI/API coherence threshold
**Expected Outcome:** Push allowed if coherence acceptable
**Example:**
```bash
python scripts/coding/ai/automation/constitution_validator_agent.py --mode pre-push --rule R3
```

---

### UC-044: Validate Database Router Configuration (R4)

**Actor:** CI Pipeline
**Preconditions:** Django settings contain database router
**Main Flow:**
1. CI pipeline validates database configuration
2. Agent checks settings.py for DATABASE_ROUTERS
3. Agent validates router implementation exists
**Expected Outcome:** Validation passes if router properly configured
**Example:**
```bash
python scripts/coding/ai/automation/constitution_validator_agent.py --rule R4 --settings api/callcentersite/settings.py
```

---

### UC-045: Validate Tests Pass (R5)

**Actor:** Pre-Push Hook, CI Pipeline
**Preconditions:** Test suite available
**Main Flow:**
1. Developer attempts to push
2. Constitution validator runs test suite
3. Agent validates all tests pass
4. Agent blocks push if any test fails
**Expected Outcome:** Push allowed only if tests pass
**Example:**
```bash
python scripts/coding/ai/automation/constitution_validator_agent.py --mode pre-push --rule R5 --run-tests
```

---

### UC-046: Validate DevContainer Compatibility (R6)

**Actor:** DevContainer Init, CI Pipeline
**Preconditions:** DevContainer configuration exists
**Main Flow:**
1. DevContainer initialization validates environment
2. Constitution validator invokes DevContainer validator
3. Agent ensures environment meets compatibility requirements
**Expected Outcome:** Initialization continues if environment valid
**Example:**
```bash
python scripts/coding/ai/automation/constitution_validator_agent.py --mode devcontainer-init --rule R6
```

---

### UC-047: Pre-Commit Validation (Fast Mode)

**Actor:** Pre-Commit Hook
**Preconditions:** Developer committing changes
**Main Flow:**
1. Git commit triggered
2. Constitution validator runs in pre-commit mode (R2 only)
3. Agent validates no emojis in changed files
**Expected Outcome:** Fast validation (< 1 second) for commit
**Example:**
```bash
python scripts/coding/ai/automation/constitution_validator_agent.py --mode pre-commit
```

---

### UC-048: Pre-Push Validation (Comprehensive Mode)

**Actor:** Pre-Push Hook
**Preconditions:** Developer pushing commits
**Main Flow:**
1. Git push triggered
2. Constitution validator runs comprehensive checks (R1, R3, R4, R5)
3. Agent validates all applicable rules
**Expected Outcome:** Comprehensive validation before push
**Example:**
```bash
python scripts/coding/ai/automation/constitution_validator_agent.py --mode pre-push
```

---

### UC-049: CI-Local Validation (Full Mode)

**Actor:** CI Pipeline
**Preconditions:** CI pipeline running locally or in CI/CD
**Main Flow:**
1. CI pipeline invokes constitution validator
2. Agent validates all rules R1-R6
3. Agent generates JSON report
**Expected Outcome:** Full compliance report
**Example:**
```bash
python scripts/coding/ai/automation/constitution_validator_agent.py --mode ci-local --output json
```

---

### UC-050: Manual Rule Validation

**Actor:** Developer
**Preconditions:** Developer wants to validate specific rule manually
**Main Flow:**
1. Developer runs validator with specific rule
2. Agent validates only requested rule
3. Agent reports validation result
**Expected Outcome:** Single-rule validation result
**Example:**
```bash
python scripts/coding/ai/automation/constitution_validator_agent.py --mode manual --rule R2 --files api/views.py
```

---

## 6. CI Pipeline Orchestrator Agent Use Cases

### UC-051: Execute Full CI Pipeline

**Actor:** CI Pipeline, Developer
**Preconditions:** .ci-local.yaml configuration exists
**Main Flow:**
1. Developer triggers CI pipeline
2. Orchestrator parses .ci-local.yaml
3. Agent executes all stages sequentially
4. Agent generates execution report
**Expected Outcome:** Complete pipeline execution with results
**Example:**
```bash
python scripts/coding/ai/automation/ci_pipeline_orchestrator_agent.py --config .ci-local.yaml
```

---

### UC-052: Smart Detection - Run Only Affected Tests

**Actor:** CI Pipeline
**Preconditions:** Git diff shows changed files
**Main Flow:**
1. Pipeline runs with smart detection enabled
2. Orchestrator analyzes git diff
3. Agent identifies affected test files
4. Agent runs only relevant tests
**Expected Outcome:** Faster pipeline execution by skipping unaffected tests
**Example:**
```bash
python scripts/coding/ai/automation/ci_pipeline_orchestrator_agent.py --smart-detect --base main
```

---

### UC-053: Parallel Job Execution

**Actor:** CI Pipeline
**Preconditions:** Multiple independent jobs in pipeline
**Main Flow:**
1. Pipeline starts with parallel jobs
2. Orchestrator identifies independent jobs
3. Agent executes jobs in parallel using asyncio
4. Agent aggregates results
**Expected Outcome:** Reduced pipeline execution time via parallelization
**Example:**
```bash
python scripts/coding/ai/automation/ci_pipeline_orchestrator_agent.py --parallel --max-workers 4
```

---

### UC-054: Handle Job Dependencies

**Actor:** CI Pipeline
**Preconditions:** Jobs have dependencies defined in .ci-local.yaml
**Main Flow:**
1. Pipeline starts with job dependencies
2. Orchestrator performs topological sort
3. Agent executes jobs in correct order
4. Agent respects dependencies
**Expected Outcome:** Jobs executed in dependency order
**Example:**
```bash
python scripts/coding/ai/automation/ci_pipeline_orchestrator_agent.py --respect-dependencies
```

---

### UC-055: Fail-Fast on Critical Job Failure

**Actor:** CI Pipeline
**Preconditions:** Critical job configured with fail-fast
**Main Flow:**
1. Pipeline runs with fail-fast enabled
2. Critical job fails (e.g., tests)
3. Orchestrator aborts remaining jobs
4. Agent reports failure immediately
**Expected Outcome:** Pipeline aborted early on critical failure
**Example:**
```bash
python scripts/coding/ai/automation/ci_pipeline_orchestrator_agent.py --fail-fast
```

---

### UC-056: Timeout Handling for Long-Running Jobs

**Actor:** CI Pipeline
**Preconditions:** Jobs have timeout configured
**Main Flow:**
1. Pipeline executes job with timeout
2. Job exceeds timeout threshold
3. Orchestrator terminates job
4. Agent reports timeout error
**Expected Outcome:** Job terminated on timeout, pipeline continues
**Example:**
```bash
python scripts/coding/ai/automation/ci_pipeline_orchestrator_agent.py --timeout 300
```

---

### UC-057: Dry-Run Pipeline Execution

**Actor:** Developer
**Preconditions:** Developer wants to test pipeline configuration
**Main Flow:**
1. Developer runs pipeline in dry-run mode
2. Orchestrator parses configuration
3. Agent simulates execution without running commands
4. Agent reports execution plan
**Expected Outcome:** Execution plan displayed without actual execution
**Example:**
```bash
python scripts/coding/ai/automation/ci_pipeline_orchestrator_agent.py --dry-run --verbose
```

---

### UC-058: Generate Pipeline Execution Report

**Actor:** CI Pipeline
**Preconditions:** Pipeline execution completed
**Main Flow:**
1. Pipeline finishes execution
2. Orchestrator aggregates job results
3. Agent generates JSON/Markdown report
4. Agent outputs execution statistics
**Expected Outcome:** Detailed execution report with timing and results
**Example:**
```bash
python scripts/coding/ai/automation/ci_pipeline_orchestrator_agent.py --report --format json
```

---

### UC-059: Execute Specific Stage Only

**Actor:** Developer
**Preconditions:** Developer wants to run specific stage (e.g., tests)
**Main Flow:**
1. Developer specifies stage to execute
2. Orchestrator filters pipeline to selected stage
3. Agent executes only specified stage
**Expected Outcome:** Single stage executed
**Example:**
```bash
python scripts/coding/ai/automation/ci_pipeline_orchestrator_agent.py --stage tests
```

---

### UC-060: Conditional Stage Execution

**Actor:** CI Pipeline
**Preconditions:** Stages have conditions defined (e.g., only on main branch)
**Main Flow:**
1. Pipeline evaluates stage conditions
2. Orchestrator checks condition (branch, file changes, etc.)
3. Agent executes stage only if condition met
**Expected Outcome:** Conditional stages executed appropriately
**Example:**
```bash
python scripts/coding/ai/automation/ci_pipeline_orchestrator_agent.py --eval-conditions --branch main
```

---

## 7. PDCA Agent Use Cases

### UC-061: Execute Plan Phase for DORA Metrics

**Actor:** DevOps Team
**Preconditions:** DORA metrics baseline established
**Main Flow:**
1. DevOps initiates PDCA cycle
2. PDCA agent analyzes current DORA metrics
3. Agent identifies improvement opportunities
4. Agent proposes changes
**Expected Outcome:** Improvement plan with proposed changes
**Example:**
```bash
python scripts/coding/ai/automation/pdca_agent.py --phase plan --metrics-source dora
```

---

### UC-062: Execute Do Phase - Deploy Changes

**Actor:** PDCA Agent (automated)
**Preconditions:** Plan approved, changes ready
**Main Flow:**
1. PDCA agent executes approved changes
2. Agent deploys configuration updates
3. Agent monitors deployment status
**Expected Outcome:** Changes deployed to controlled environment
**Example:**
```bash
python scripts/coding/ai/automation/pdca_agent.py --phase do --apply-plan plan_2024_11_14.json
```

---

### UC-063: Execute Check Phase - Validate Metrics

**Actor:** PDCA Agent (automated)
**Preconditions:** Changes deployed, waiting period elapsed
**Main Flow:**
1. PDCA agent collects post-change metrics
2. Agent compares with baseline metrics
3. Agent calculates metric deltas
4. Agent evaluates if improvement achieved
**Expected Outcome:** Validation report with metric comparison
**Example:**
```bash
python scripts/coding/ai/automation/pdca_agent.py --phase check --baseline metrics_baseline.json
```

---

### UC-064: Execute Act Phase - Apply or Revert

**Actor:** PDCA Agent (automated)
**Preconditions:** Check phase completed
**Main Flow:**
1. PDCA agent evaluates check results
2. Agent decides: apply, revert, or escalate
3. Agent executes decision
4. Agent documents cycle outcome
**Expected Outcome:** Changes applied permanently or reverted based on validation
**Example:**
```bash
python scripts/coding/ai/automation/pdca_agent.py --phase act --decision auto
```

---

### UC-065: Track Deployment Frequency Metric

**Actor:** PDCA Agent
**Preconditions:** Git history with deployment tags
**Main Flow:**
1. PDCA agent analyzes git history
2. Agent counts deployments per time period
3. Agent calculates deployment frequency
**Expected Outcome:** Deployment frequency metric (daily, weekly, etc.)
**Example:**
```bash
python scripts/coding/ai/automation/pdca_agent.py --metric deployment-frequency --period 30days
```

---

### UC-066: Track Lead Time for Changes

**Actor:** PDCA Agent
**Preconditions:** Git commits linked to deployments
**Main Flow:**
1. PDCA agent analyzes commit-to-deploy time
2. Agent calculates average lead time
3. Agent tracks trend
**Expected Outcome:** Lead time metric with trend
**Example:**
```bash
python scripts/coding/ai/automation/pdca_agent.py --metric lead-time --period 30days
```

---

### UC-067: Track Change Failure Rate

**Actor:** PDCA Agent
**Preconditions:** CI pipeline logs with failure data
**Main Flow:**
1. PDCA agent analyzes deployment outcomes
2. Agent calculates failure rate percentage
3. Agent identifies failure patterns
**Expected Outcome:** Change failure rate metric
**Example:**
```bash
python scripts/coding/ai/automation/pdca_agent.py --metric change-failure-rate --period 30days
```

---

### UC-068: Track Mean Time to Recovery (MTTR)

**Actor:** PDCA Agent
**Preconditions:** Incident logs with resolution times
**Main Flow:**
1. PDCA agent parses incident logs
2. Agent calculates time from incident to resolution
3. Agent computes mean recovery time
**Expected Outcome:** MTTR metric
**Example:**
```bash
python scripts/coding/ai/automation/pdca_agent.py --metric mttr --period 30days
```

---

### UC-069: Automated PDCA Cycle Execution

**Actor:** PDCA Agent (scheduled)
**Preconditions:** PDCA cycle configuration exists
**Main Flow:**
1. Scheduled job triggers PDCA agent
2. Agent executes full PDCA cycle (Plan-Do-Check-Act)
3. Agent makes automated decisions
4. Agent generates cycle report
**Expected Outcome:** Complete PDCA cycle executed autonomously
**Example:**
```bash
python scripts/coding/ai/automation/pdca_agent.py --auto-cycle --config pdca_config.yaml
```

---

### UC-070: Generate PDCA Cycle History Report

**Actor:** Engineering Manager
**Preconditions:** Multiple PDCA cycles completed
**Main Flow:**
1. Manager requests PDCA history
2. Agent aggregates all cycle data
3. Agent generates trend report
4. Agent shows improvement over time
**Expected Outcome:** Historical report showing continuous improvement trends
**Example:**
```bash
python scripts/coding/ai/automation/pdca_agent.py --history --format markdown --output pdca_history.md
```

---

## Appendix A: Use Case Cross-References

**Constitution Validation Dependencies:**
- UC-043 depends on UC-031 to UC-040 (Coherence Analyzer)
- UC-046 depends on UC-011 to UC-020 (DevContainer Validator)

**CI Pipeline Dependencies:**
- UC-051 to UC-060 may invoke UC-001 to UC-010 (Schema Validator)
- UC-051 to UC-060 may invoke UC-041 to UC-050 (Constitution Validator)

**PDCA Cycle Dependencies:**
- UC-061 to UC-070 may use UC-021 to UC-030 (Metrics Collector)

---

## Appendix B: IACT Project Context

**Backend:** Django 5 with REST API
**Frontend:** React UI application
**Databases:**
- PostgreSQL (port 5432) - Analytics database
- MariaDB (port 3306) - IVR read-only data

**Development Environment:** DevContainer-based
**CI/CD:** Local CI pipeline (.ci-local.yaml) + GitHub Actions
**Constitution:** 6 rules (R1-R6) enforced by automation agents

---

**Document Status:** COMPLETE
**Total Use Cases:** 70
**Last Updated:** 2025-11-14
**Next Review:** 2026-02-14

---

*END OF USE CASES DOCUMENTATION*
