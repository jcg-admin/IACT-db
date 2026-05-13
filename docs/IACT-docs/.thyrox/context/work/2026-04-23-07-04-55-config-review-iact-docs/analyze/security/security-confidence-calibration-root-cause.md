```yml
created_at: 2026-04-23 09:25:00
project: IACT-docs
work_package: 2026-04-23-07-04-55-config-review-iact-docs
phase: Phase 3 — DIAGNOSE
author: claude
status: Borrador
version: 1.0.0
domain: security
confidence_baseline: 0.41
```

# Security Confidence Calibration — Root Cause Analysis

## Executive Summary

Security documentation (CNST-005) provides **comprehensive code templates and best practices** (authentication, permissions, throttling, validation), but confidence remains at **0.41** due to **critical gap between templates and deployment evidence**.

**Gap Categories:**
1. No settings.py configuration file provided
2. No actual views.py with security decorators
3. No test validation of security rules
4. No security audit trail evidence
5. No deployment configuration (JWT keys, throttle rates)
6. No third-party dependency lock file

---

## 1. Documentation Evidence (PROVEN)

### 1.1 Security Checklist Coverage

CNST-005 (Seguridad Django REST Framework v1.1.0) provides:

**✅ Autenticación (Section 2)**
- JWT configuration with HS256 algorithm
- Token lifetime (15min access, 7-day refresh)
- Token rotation and blacklist configuration
- Auth header type: Bearer

**✅ Autorización (Section 3)**
- Base permissions: IsActiveUser, IsAdminUser, IsOwnerOrAdmin
- RBAC permissions: HasFunction, CanViewReports, CanAnalyzeData, CanManageAlerts, CanManageUsers
- Temporal permissions: TemporaryPermission model with 6-month max duration
- SoD enforcement rules

**✅ Throttling (Section 5)**
- AnonRateThrottle: 20/hour
- UserRateThrottle: 1000/hour
- LoginRateThrottle: 5/minute
- ReportThrottle: 10/hour
- ExportThrottle: 5/hour
- ETLThrottle: 1/hour

**✅ Validación de Datos (Section 6)**
- DateRangeValidator (max 90 days, no future dates)
- ReportRequestData serializer with queue_id validation
- Generic serializer patterns

**✅ Manejo de Excepciones (Section 7)**
- custom_exception_handler with standardized error format
- Automatic logging of 4xx/5xx errors
- Unhandled exception logging with traceback

**✅ Paginación (Section 8)**
- StandardPagination: page_size=50, max=200
- LargePagination: page_size=100, max=1000
- Metadata-rich response format

**✅ Ejemplos Completos (Section 9)**
- ReportViewSet with full security implementation
- Custom action methods (generate, export) with proper throttles
- UserActionLog audit trail recording

**✅ Pre-commit Checklists (Section 10)**
- 6-item developer checklist
- 6-item code review checklist
- Bash validation script

---

## 2. Implementation Gap Analysis (INFERRED)

### 2.1 Template vs Reality Gap

| Component | Template? | Production Code? | Evidence Level |
|-----------|-----------|------------------|-----------------|
| **REST_FRAMEWORK settings** | ✅ Section 2.1 | ❓ Unknown | Code provided but actual settings.py not referenced |
| **SIMPLE_JWT config** | ✅ Section 2.2 | ❓ Unknown | OS env vars mentioned but no .env or config shown |
| **Base permission classes** | ✅ Section 3.1 | ❓ Unknown | Code in docs but no actual app/common/permissions.py link |
| **RBAC permission classes** | ✅ Section 3.2 | ❓ Unknown | 5 permission classes defined, but implementation status unknown |
| **Temporal permissions model** | ✅ Section 4 | ❓ Unknown | Full model with signals and migrations, but not deployed? |
| **Custom throttles** | ✅ Section 5.1 | ❓ Unknown | 4 custom throttle classes, integration status unknown |
| **Exception handler** | ✅ Section 7 | ❓ Unknown | Complete handler with logging, but active? |
| **View examples** | ✅ Section 9 | ❓ Unknown | ReportViewSet with all decorators, but actual code? |

### 2.2 Critical Implementation Questions

**1. Are these modules actually installed?**
```
Mentioned but not verified:
- rest_framework_simplejwt (JWT authentication)
- rest_framework (DRF core)
- apps.common.permissions (custom module)
- apps.access.models (custom module)
- apps.common.throttling (custom module)
```

**2. Are settings actually configured?**
```
If CNST-005 code is production code:
  - JWT_SECRET_KEY must be in os.environ
  - DEFAULT_AUTHENTICATION_CLASSES must be set
  - DEFAULT_PERMISSION_CLASSES must be set
  - INSTALLED_APPS must include token_blacklist
  
If not found in settings.py → config is incomplete
```

**3. Are permissions actually enforced?**
```
Example from CNST-005 Section 9:
  permission_classes = [IsAuthenticated, CanViewReports]

Question: Are ALL views in api/apps/reports/views.py 
configured this way, or are there naked views with AllowAny?
```

**4. Is token rotation actually enabled?**
```
Config says: 'ROTATE_REFRESH_TOKENS': True
But is rotate_refresh_tokens task scheduled?
Is there a celery worker running?
```

**5. Are temporary permissions actually expiring?**
```
Model has signal (Section 4.3) for auto-expiration.
Question: Is the signal registered in apps.py?
Or is only the management command expire_permissions.py used?
If only command: is it scheduled in cron or celery?
```

---

## 3. Calibration Factors (OBSERVABLE)

### 3.1 Confidence Degradation Reasons

| Factor | Confidence Impact | Reason |
|--------|-------------------|--------|
| **Documentation completeness** | +0.65 | CNST-005 covers all major security areas |
| **Code example quality** | +0.25 | Models, signals, serializers, views provided |
| **Settings verification** | -0.25 | No actual settings.py file shown |
| **Deployment evidence** | -0.15 | No migration files, no requirements.txt |
| **Security test coverage** | -0.09 | No test suite for security rules |

**Result: 0.65 + 0.25 - 0.25 - 0.15 - 0.09 = 0.41**

### 3.2 What Would Raise Confidence to 0.75+?

To move from **0.41 → 0.75**, need:

1. **Settings.py Reference** (+0.12)
   - Link to actual api/config/settings/base.py
   - Show JWT_SECRET_KEY config
   - Show DEFAULT_AUTHENTICATION_CLASSES
   - Show REST_FRAMEWORK with all fields

2. **Module Inventory** (+0.10)
   - Link to actual api/apps/common/permissions.py
   - Link to actual api/apps/access/models.py
   - Link to actual api/apps/common/throttling.py
   - Verify modules exist and are importable

3. **Migration Evidence** (+0.12)
   - Show api/apps/access/migrations/0001_create_temporarypermission.py
   - Show TemporaryPermission table in database schema
   - Show index definitions

4. **Test Suite** (+0.13)
   - tests/test_jwt_authentication.py (min 4 tests)
   - tests/test_rbac_permissions.py (min 8 tests)
   - tests/test_temporal_permissions.py (min 6 tests)
   - tests/test_throttling.py (min 6 tests)

5. **Security Audit** (+0.18)
   - No AllowAny views outside auth
   - All views have permission_classes
   - All POST/PUT/DELETE have throttling
   - Token rotation task configured

---

## 4. Observable Gaps vs Specification

### 4.1 Specification Level ✅

**What we can verify from CNST-005:**
- ✅ JWT authentication is required
- ✅ Throttling rates are specified
- ✅ Permissions structure is defined
- ✅ Exception handling format is standardized
- ✅ Pagination requirements are clear
- ✅ Temporal permissions have 6-month max

### 4.2 Implementation Level ❓

**What we cannot verify without implementation code:**
- ❓ Is JWT actually configured with HS256?
- ❓ Are permissions being checked on every endpoint?
- ❓ Is throttling preventing abuse?
- ❓ Are exceptions being logged?
- ❓ Is pagination enforced on list endpoints?
- ❓ Are temporal permissions auto-expiring?

---

## 5. Recommended Actions (Priority Order)

### Immediate (Phase 3 Continuation)

**T-001:** Locate Django settings
```
Task: find . -path "*/config/settings/base.py" 2>/dev/null
Task: grep -n "REST_FRAMEWORK\|SIMPLE_JWT" <settings.py>
Evidence: Show actual configuration values
```

**T-002:** Verify JWT installation
```
Task: grep "rest_framework_simplejwt" requirements.txt pyproject.toml setup.py 2>/dev/null
Task: Check if simplejwt is in INSTALLED_APPS
Evidence: Version number and installation method
```

**T-003:** Search for permission_classes usage
```
Task: grep -r "permission_classes" api/apps/ --include="*.py" | wc -l
Task: grep -r "AllowAny" api/apps/ --include="*.py" | grep -v "login\|register"
Evidence: Count of protected vs unprotected views
```

**T-004:** Find test suite
```
Task: find tests/ -name "*test*security*" -o -name "*test*jwt*" 2>/dev/null
Task: find tests/ -name "*test*permission*" 2>/dev/null
Evidence: List of security-related test files and coverage
```

### Medium Term (Phase 4 Remediation)

**T-005:** Create security audit checklist
- Verify all views have authentication
- Verify throttles on sensitive endpoints
- Verify exception handler is active
- Verify audit logging captures actions

**T-006:** Add test coverage
- test_jwt_authentication.py (token creation, refresh, expiry)
- test_rbac_enforcement.py (function assignment validation)
- test_temporal_permissions.py (expiration, renewal)

**T-007:** Document deployment security
- JWT_SECRET_KEY management (rotation? security?)
- Throttle rate configuration in production
- Token blacklist cleanup schedule
- Temporal permission expiration schedule

---

## 6. Root Cause Summary

**Primary Root Cause:** *Security documentation provides templates and best practices, but actual implementation status in codebase is unverified.*

| Level | Status | Example |
|-------|--------|---------|
| **Specification** | ✅ Complete | "JWT with HS256, 15min access token lifetime" |
| **Design** | ✅ Described | TemporaryPermission model with validation |
| **Code Templates** | ✅ Provided | Complete permission classes, signals, views |
| **Settings Configuration** | ❓ Unverified | REST_FRAMEWORK dict not shown in actual settings.py |
| **Module Installation** | ❓ Unverified | rest_framework_simplejwt version not specified |
| **View Decoration** | ❓ Unverified | Are actual views using permission_classes from templates? |
| **Testing** | ❓ Unverified | No test coverage data for security features |
| **Deployment** | ❓ Unverified | Token rotation task? Expiration schedule? |

**Confidence resets when:** Implementation code is linked, tested, and deployed.

---

## 7. Secondary Concerns (SPECULATIVE)

**Potential implementation risks not covered in CNST-005:**

1. **JWT Secret Rotation**
   - CNST-005 specifies HS256 + os.environ.get('JWT_SECRET_KEY')
   - But how often is secret rotated?
   - How are old tokens handled during rotation?

2. **Token Blacklist Cleanup**
   - Token rotation with blacklist enabled
   - But blacklist table grows indefinitely
   - When/how is cleanup scheduled?

3. **Throttle Bypass via Distributed Attack**
   - Throttles are per-user or per-IP
   - But document doesn't specify rate limit key
   - Could attacker use load balancer header spoofing?

4. **Function Code Inconsistency**
   - Permission classes reference function_code like 've_reportes'
   - But where is canonical list of valid function codes?
   - What prevents typos in function_code assignment?

---

## 8. Evidence Classification

| Evidence | Status | Type | Source |
|----------|--------|------|--------|
| CNST-005 v1.1.0 document | PROVEN | Document | source/normativa/restricciones/CNST_005_... |
| JWT config specification | PROVEN | Specification | CNST-005 Section 2.2 |
| Permission classes code | PROVEN | Code template | CNST-005 Section 3.1-3.2 |
| TemporaryPermission model | PROVEN | Code template | CNST-005 Section 4.2 |
| Throttle configuration | PROVEN | Code template | CNST-005 Section 5 |
| Exception handler | PROVEN | Code template | CNST-005 Section 7 |
| Actual settings.py config | SPECULATIVE | Implementation | Not found in documentation |
| Test suite | SPECULATIVE | Implementation | Not mentioned in CNST-005 |
| Deployment schedule | SPECULATIVE | Operations | Token rotation not documented |

---

## Conclusion

Security documentation is **strong on specification and templates** (0.65 confidence) but **weak on deployment evidence** (0.25 confidence). The 0.41 blended confidence reflects heavy reliance on code templates without verification.

**To advance from Phase 3 → Phase 4,** we need to:
1. Locate actual settings.py and verify REST_FRAMEWORK config
2. Verify all modules are installed and imported
3. Audit all views for permission_classes decorators
4. Create security test suite (min 20 tests)
5. Document deployment procedures (token rotation, blacklist cleanup)

**Next step:** T-001 (find api/config/settings/base.py)
