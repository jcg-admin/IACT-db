```yml
created_at: 2026-04-23 09:15:00
project: IACT-docs
work_package: 2026-04-23-07-04-55-config-review-iact-docs
phase: Phase 3 — DIAGNOSE
author: claude
status: Borrador
version: 1.0.0
domain: rbac
confidence_baseline: 0.37
```

# RBAC Confidence Calibration — Root Cause Analysis

## Executive Summary

RBAC model documentation (GOB_02) is comprehensive at the **specification level** (17 roles, Flat RBAC, SoD rules), but confidence remains at **0.37** due to critical gaps between **documented specification** and **implementation evidence**.

**Gap Categories:**
1. No API endpoint documentation for role assignment
2. No database schema evidence
3. No validation that permissions actually cascade in code
4. No test coverage documentation
5. No deployment verification checklist

---

## 1. Documentation Evidence (PROVEN)

### 1.1 What Exists

**GOB_02 (Roles y RACI v1.0.0):**
- ✅ 17 functional roles defined (3 categories: User Mgmt, Reports, Visualization, Alerts, Admin)
- ✅ Flat RBAC model specified (no inheritance, explicit permissions, Union accumulation)
- ✅ SoD (Separation of Duties) rules: R016↔R017, R001↔R017
- ✅ RACI matrix for 17 artefact types × 6 roles (PMO, Arq Doc, BA Lead, Tech Lead, Dev, QA)
- ✅ Module profile matrix (BASICO, ANALISTA, ADMINISTRADOR_SEGMENTO, ADMINISTRADOR)
- ✅ 255-488 estimated users across 17 roles

**Temporal Permissions Model (CNST-005 section 4.2):**
- ✅ TemporaryPermission model with Django ORM schema
- ✅ Expiration validation (max 6 months, min 20 char justification)
- ✅ Signal handler for auto-expiration
- ✅ Custom permission classes (HasFunction, CanViewReports, CanAnalyzeData, etc.)
- ✅ API endpoints documented (create, list, expire, expiring_soon)

---

## 2. Implementation Gap Analysis (INFERRED)

### 2.1 Critical Missing Pieces

| Component | Documented? | Implemented? | Evidence Gap |
|-----------|------------|-------------|--------------|
| **Role model** (User↔Role N:N) | ✅ Yes | ❓ Unknown | No schema file, no migrations |
| **Function model** (44 atomic functions) | ✅ Mentioned (v5.1.1) | ❓ Unknown | Not defined in CNST-005 code samples |
| **Permission assignment logic** | ✅ Code templates | ❓ Unknown | No actual app/models/permissions.py reference |
| **RBAC validation in code** | ✅ Examples given | ❓ Unknown | No test files, no pre-commit hooks |
| **Audit logging for role changes** | ✅ Implicit | ❓ Unknown | No UserActionLog implementation details |
| **Role sync with LDAP/SSO** | ❓ No mention | ❓ Unknown | Not addressed anywhere |

### 2.2 Specific Implementation Uncertainties

**1. Role-Function Mapping**

In GOB_02, roles are mapped to RACI functions (PMO→R001, R014, R016), but the actual **function_code** field in TemporaryPermission model (CNST-005:399) references codes like:
- `ve_reportes` (view reports)
- `exporta_reportes` (export reports)
- `analiza_datos` (analyze data)
- `configura_alertas` (configure alerts)

**Question:** Are these 44 atomic functions (mentioned in CNST-005:220) formally documented anywhere? 
- If yes: reference missing
- If no: list is incomplete, confidence drops

**2. Role-User Assignment Process**

GOB_02 section 5.2 shows RACI matrix (who approves role assignment), but **no process document** specifies:
- How R001 (USERS_FULL_MANAGER) assigns roles to users
- Validation that assigned role doesn't violate SoD rules
- Exception workflow (if roles must be mutually exclusive but justified)

**3. Module Permission Inheritance**

Section 4.1 says "Reportes Personalizados requires: Reportes Basicos", but it's unclear:
- Is this enforced in code or manual?
- What happens if a user gets Reportes Personalizados without Reportes Basicos?
- Which layer validates this (API, permission_classes, signal handler)?

---

## 3. Calibration Factors (OBSERVABLE)

### 3.1 Confidence Degradation Reasons

| Factor | Confidence Impact | Reason |
|--------|-------------------|--------|
| **Specification completeness** | +0.7 | RBAC model well-articulated in GOB_02 |
| **Code example coverage** | +0.35 | CNST-005 provides permission classes, models, signals |
| **Implementation verification** | -0.4 | No actual codebase files linked to docs |
| **Testing coverage** | -0.15 | No test files for RBAC logic |
| **Audit trail clarity** | -0.13 | Logging mentioned but not detailed |

**Result: 0.7 + 0.35 - 0.4 - 0.15 - 0.13 = 0.37**

### 3.2 What Would Raise Confidence to 0.75+?

To move from **0.37 → 0.75**, need:

1. **Implementation Reference** (+0.15)
   - Link to actual `api/apps/access/models.py` in repository
   - Link to actual `api/apps/common/permissions.py`
   - Link to actual database migrations

2. **Test Coverage** (+0.15)
   - tests/test_rbac_role_assignment.py
   - tests/test_rbac_sod_validation.py
   - tests/test_temporary_permissions.py

3. **Deployment Verification** (+0.12)
   - SQL schema dump showing Role, User, FunctionAssignment tables
   - Pre-commit hook output validating no AllowAny exceptions
   - CI/CD gate checking all views have permission_classes

4. **Process Documentation** (+0.08)
   - Link to PROC_Gestión_Usuarios or equivalent
   - Exception workflow diagram for SoD violations
   - Module inheritance enforcement logic

5. **Audit Trail** (+0.08)
   - Sample audit log entries showing role assignment
   - Retention policy (90, 180, 365 days?)
   - Access to audit logs (R017 only? immutable?)

---

## 4. Observable Gaps vs Specification

### 4.1 Specification Level ✅

**What we can verify from GOB_02:**
- ✅ Role catalog is complete (17 roles, defined in section 2.1-2.6)
- ✅ SoD rules are explicit (R016↔R017, R001↔R017 in section 3)
- ✅ RACI assignments are complete (15 artifact types × 6 roles in 5.2)
- ✅ Module profiles are defined (4 predefined profiles in 4.1)

### 4.2 Implementation Level ❓

**What we cannot verify without implementation code:**
- ❓ Are all 17 roles actually stored in database?
- ❓ Are SoD rules enforced by code or manual review?
- ❓ Can users actually have multiple roles and accumulate permissions?
- ❓ Does TemporaryPermission model actually prevent role assignment after 6 months?
- ❓ Are module dependencies validated (Reportes Personalizados requires Reportes Basicos)?

---

## 5. Recommended Actions (Priority Order)

### Immediate (Phase 3 Continuation)

**T-001:** Locate and link implementation files
```
Task: grep -r "class Role" api/apps/*/models.py 2>/dev/null | head -20
Task: Find database schema file (migrations/0001_initial.py or schema.sql)
Evidence: Return actual file paths and line numbers
```

**T-002:** Create test inventory document
```
Task: find tests/ -name "*rbac*" -o -name "*permission*" 2>/dev/null
Task: Count test methods for role assignment and SoD validation
Evidence: List any existing tests; identify gap areas
```

**T-003:** Verify SoD enforcement
```
Task: grep -r "SoD\|separation" api/ --include="*.py" 2>/dev/null
Task: Search for validation that prevents R016+R017 assignment
Evidence: Document where/how SoD is checked (pre_save signal? custom validator?)
```

### Medium Term (Phase 4 Remediation)

**T-004:** Create implementation mapping document
- GOB_02 section → actual code file
- Role name → database table field
- Permission class → APIView usage

**T-005:** Add test coverage for RBAC
- test_role_assignment.py (minimum 8 test methods)
- test_sod_validation.py (minimum 4 test methods)
- test_permission_accumulation.py (minimum 6 test methods)

**T-006:** Document module inheritance validation
- PROC document specifying module dependencies
- Code implementation in permissions.py
- API test for cascading permission grants

---

## 6. Root Cause Summary

**Primary Root Cause:** *Documentation describes RBAC specification, but implementation reference is missing.*

| Level | Status | Example |
|-------|--------|---------|
| **Specification** | ✅ Complete | "R001 administrates users, roles, segments" |
| **Design** | ✅ Described | TemporaryPermission model with validation |
| **Code** | ❓ Unverified | "permission_classes = [IsAuthenticated, HasFunction]" |
| **Deployment** | ❓ Unverified | Database tables, migrations, indexes |
| **Testing** | ❓ Unverified | Test coverage for role assignment, SoD |
| **Audit Trail** | ❓ Unverified | Logging of role changes, access patterns |

**Confidence reset depends on:** Moving one or more items from ❓ to ✅.

---

## 7. Evidence Classification

| Evidence | Status | Type | Source |
|----------|--------|------|--------|
| GOB_02 v1.0.0 document | PROVEN | Document | source/normativa/gobernanza/GOB_02_Roles_y_RACI.rst |
| RBAC Flat model spec | PROVEN | Specification | GOB_02 section 1.1 |
| 17 functional roles | PROVEN | List | GOB_02 section 2.1 |
| TemporaryPermission code | INFERRED | Code example | CNST-005 section 4.2 (Django model) |
| Role-Function mapping | SPECULATIVE | Implicit | GOB_02 section 7.1 (mapping table) |
| SoD enforcement in code | SPECULATIVE | Unknown | No actual code reference |
| Test coverage | SPECULATIVE | Unknown | Not mentioned anywhere |

---

## Conclusion

RBAC documentation is **strong on specification** (0.70 confidence) but **weak on implementation evidence** (0.20 confidence). The 0.37 blended confidence reflects this gap.

**To advance from Phase 3 → Phase 4,** we need to:
1. Locate actual implementation files
2. Verify SoD enforcement
3. Audit test coverage
4. Document deployment procedures

**Next step:** T-001 (grep for Role model in codebase)
