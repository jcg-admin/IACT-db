```yml
created_at: 2026-04-23 09:35:00
project: IACT-docs
work_package: 2026-04-23-07-04-55-config-review-iact-docs
phase: Phase 3 — DIAGNOSE
author: claude
status: Borrador
version: 1.0.0
domain: constraints
confidence_baseline: 0.56
```

# System Constraints Confidence Calibration — Root Cause Analysis

## Executive Summary

System constraints documentation (CNST-007 and related constraints) is **well-specified at the SLA level** (performance targets, response times, throughput limits), but confidence remains at **0.56** due to **critical gap between specification and monitoring evidence**.

**Gap Categories:**
1. No monitoring implementation evidence
2. No alert configuration documented
3. No performance baseline data
4. No capacity planning details
5. No compliance verification checklist
6. No incident escalation procedures

---

## 1. Documentation Evidence (PROVEN)

### 1.1 Constraint Coverage

CNST-007 (Límites de Performance y SLA v1.0.1) specifies:

**✅ Response Time SLAs (Section 2)**
- GET simple: <200ms target, 500ms max
- GET filtered: <500ms target, 1s max
- POST/PUT/DELETE: <300ms target, 1s max
- Simple reports: <2s target, 5s max
- Complex reports: <5s target, 15s max
- Exports: <10s target, 30s max

**✅ Dashboard Performance (Section 2.2)**
- Initial load: <2s target, 5s max
- Navigation: <500ms target, 1s max
- Widget refresh: <1s target, 3s max

**✅ ETL Performance (Section 2.3)**
- Daily ETL window: 8PM-6AM
- Max duration: 8 hours
- Parallel threads: 4 max
- Failure recovery: auto-retry 3x

**✅ Database Query Limits**
- Max result set: 50K rows without pagination
- Query timeout: 5 minutes for reports, 30s for real-time
- Connection pool: 20 connections

**✅ Concurrent User SLA (Section 2.4)**
- Peak concurrent users: 200 simultaneous
- Degraded mode: 100-200 (response time increases 20%)
- Failure mode: >200 (500 errors returned)

**✅ Storage Constraints**
- Database: 50GB max (current 12GB)
- File uploads: 1GB per user per year
- Archive: data > 2 years moved to cold storage

**✅ Availability (Section 3)**
- Target: 99.5% uptime (4h downtime/month)
- Maintenance window: 2-4 AM Sunday
- RTO (Recovery Time Objective): 2 hours max

Other CNST documents:
- CNST-001: Prohibited Communications
- CNST-002: Session Management in DB
- CNST-003: Dual Immutable Database
- CNST-004: ETL Update Process
- CNST-006: Architecture Anti-patterns
- CNST-008: Infrastructure Deployment
- CNST-009: Immutable Logging
- CNST-010: Data Classification

---

## 2. Implementation Gap Analysis (INFERRED)

### 2.1 Monitoring vs Specification Gap

| Constraint | Documented? | Monitored? | Evidence Gap |
|-----------|------------|-----------|--------------|
| **API response time** | ✅ CNST-007 | ❓ Unknown | No APM tool mentioned (New Relic, Datadog, Prometheus?) |
| **ETL window compliance** | ✅ CNST-007 | ❓ Unknown | No job scheduler config (Celery beat? Jenkins?) |
| **Concurrent user limit** | ✅ CNST-007 | ❓ Unknown | No load test baseline, no auto-scaling rules |
| **Database connections** | ✅ CNST-007 | ❓ Unknown | No connection pool monitoring |
| **Availability uptime** | ✅ CNST-007 | ❓ Unknown | No SLA tracking dashboard, no incident log |
| **Disk space usage** | ✅ CNST-007 | ❓ Unknown | No alert when >85% full |
| **Query timeout** | ✅ CNST-007 | ❓ Unknown | Timeout set in Django ORM? Database? |

### 2.2 Critical Monitoring Questions

**1. Is there an APM (Application Performance Monitoring) tool?**
```
CNST-007 specifies response times but doesn't mention:
- How are response times measured?
- Is there a monitoring dashboard?
- What tool collects metrics (Prometheus, Datadog, New Relic)?
- Are alerts configured when targets are exceeded?
```

**2. Are ETL windows actually enforced?**
```
CNST-007 Section 2.3 specifies 8PM-6AM window.
But:
- Is there a job scheduler preventing daytime runs?
- What happens if ETL runs > 8 hours?
- Is there manual intervention required or auto-rollback?
```

**3. What happens at concurrent user limit?**
```
CNST-007 specifies:
- 100-200 users: degraded mode (20% slower)
- >200 users: return 500 errors

But:
- Is load balancer configured to reject >200?
- Or does application crash?
- Is there a queue/waiting mechanism?
```

**4. Are database constraints actually enforced?**
```
CNST-007 specifies:
- 50GB max (currently 12GB)
- 20 connection pool
- Query timeout 5min reports, 30s real-time

But:
- Is pool size configured in Django settings?
- Are timeouts set in ORM or database?
- What happens at pool exhaustion?
```

**5. How is 99.5% uptime tracked?**
```
CNST-007 requires 99.5% availability (4h downtime/month).
But:
- Is there an uptime monitoring service (StatusPage, Pingdom)?
- How is downtime calculated (total service vs per-component)?
- Who has access to SLA metrics?
```

---

## 3. Calibration Factors (OBSERVABLE)

### 3.1 Confidence Degradation Reasons

| Factor | Confidence Impact | Reason |
|--------|-------------------|--------|
| **SLA specification** | +0.60 | CNST-007 covers all major performance targets |
| **Multi-constraint coverage** | +0.15 | 10 separate CNST documents addressing different areas |
| **Monitoring evidence** | -0.10 | No APM tool mentioned |
| **Alert configuration** | -0.05 | No alert thresholds or escalation procedures |
| **Baseline data** | -0.04 | No current performance metrics provided |

**Result: 0.60 + 0.15 - 0.10 - 0.05 - 0.04 = 0.56**

### 3.2 What Would Raise Confidence to 0.75+?

To move from **0.56 → 0.75**, need:

1. **Monitoring Tool Reference** (+0.08)
   - Link to actual APM tool (Prometheus, Datadog, New Relic)
   - Show dashboard URL with response time metrics
   - Show database metrics dashboard

2. **Alert Configuration** (+0.10)
   - Alert when response time >500ms for APIs
   - Alert when response time >5s for reports
   - Alert when concurrent users >200
   - Alert when database >40GB

3. **ETL Monitoring** (+0.08)
   - Job scheduler configuration (Celery beat, cron, Jenkins)
   - ETL start time enforcement (must be 8PM-6AM)
   - ETL duration tracking (max 8 hours)
   - Auto-rollback or manual override procedures

4. **Capacity Planning** (+0.10)
   - Current baseline metrics (avg response time, peak users, DB size)
   - Trend analysis (growing 10%/month?)
   - Projected capacity (when will we hit limits?)
   - Scaling plan (how to handle growth?)

5. **SLA Tracking** (+0.09)
   - Uptime percentage for last 30 days
   - Incident log with RTO/RTW metrics
   - SLA compliance report template
   - Escalation procedures for SLA breach

6. **Load Testing Results** (+0.10)
   - Load test showing performance at 100, 150, 200 concurrent users
   - Database query performance under load
   - Network bandwidth utilization

---

## 4. Observable Gaps vs Specification

### 4.1 Specification Level ✅

**What we can verify from constraints documents:**
- ✅ Response time targets are explicit (GET <200ms, reports <5s)
- ✅ Concurrency limits are defined (200 simultaneous)
- ✅ Storage limits are specified (50GB DB, 1GB per user)
- ✅ ETL window is fixed (8PM-6AM)
- ✅ Availability target is clear (99.5%)
- ✅ Architecture anti-patterns are listed (CNST-006)

### 4.2 Implementation Level ❓

**What we cannot verify without monitoring evidence:**
- ❓ Are response times actually <200ms for GET requests?
- ❓ Are concurrent users limited to 200 or can it exceed?
- ❓ Is database size tracked and alerted at thresholds?
- ❓ Do ETL jobs run within 8PM-6AM window?
- ❓ Is 99.5% uptime being achieved?
- ❓ Are anti-patterns being prevented in code review?

---

## 5. Recommended Actions (Priority Order)

### Immediate (Phase 3 Continuation)

**T-001:** Inventory monitoring tools
```
Task: grep -r "prometheus\|datadog\|newrelic\|elastic" . --include="*.py" 2>/dev/null
Task: Look for settings.py references to APM configuration
Evidence: List any monitoring tools found, versions, configuration
```

**T-002:** Search for alert configuration
```
Task: find . -name "*alert*" -type f 2>/dev/null
Task: grep -r "AlertManager\|alerting_config" . 2>/dev/null
Evidence: Document any alert rules found
```

**T-003:** Locate job scheduler configuration
```
Task: grep -r "celery\|celery_beat\|cron" . --include="*.py" 2>/dev/null
Task: Look for ETL job definitions
Evidence: Show ETL schedule and window enforcement
```

**T-004:** Find baseline performance data
```
Task: grep -r "performance\|benchmark\|metrics" . --include="*.md" --include="*.txt" 2>/dev/null
Task: Look for any existing performance reports
Evidence: Document current baseline metrics
```

### Medium Term (Phase 4 Remediation)

**T-005:** Create monitoring implementation plan
- APM tool selection (Prometheus + Grafana for open-source)
- Dashboard creation (API response times, database metrics)
- Alert rule setup (threshold breaches)

**T-006:** Implement capacity tracking
- Database size monitoring (alert at 40GB, 45GB, 50GB)
- User growth tracking (trend analysis)
- Projected capacity exhaustion date

**T-007:** Document ETL window enforcement
- Job scheduler configuration (Celery beat timing)
- Timeout and retry procedures
- Rollback procedures for failed ETL

**T-008:** Create load testing baseline
- Load test plan (100, 150, 200, 250 concurrent users)
- Performance baseline at each level
- Scaling recommendations

---

## 6. Root Cause Summary

**Primary Root Cause:** *System constraints are well-specified, but monitoring and verification procedures are not documented or implemented.*

| Level | Status | Example |
|-------|--------|---------|
| **Specification** | ✅ Complete | "Response time <200ms for GET, <1s max" |
| **Design** | ✅ Described | "Database max 50GB, alert at >40GB" |
| **Configuration** | ❓ Unverified | APM tool? Thresholds? Alert rules? |
| **Monitoring** | ❓ Unverified | Are metrics actually collected and tracked? |
| **Alerting** | ❓ Unverified | Do teams get notified of SLA breaches? |
| **Capacity Planning** | ❓ Unverified | Current metrics? Trend analysis? Scaling plan? |
| **SLA Tracking** | ❓ Unverified | Uptime percentage? Incident log? |

**Confidence resets when:** Monitoring is deployed, metrics are collected, and SLA compliance is verified.

---

## 7. Secondary Concerns (SPECULATIVE)

**Implementation risks not covered in constraints docs:**

1. **Database Scaling Strategy**
   - CNST-007 specifies 50GB limit
   - But what happens when approached?
   - Sharding strategy? Read replicas? Archive?

2. **Query Optimization Process**
   - CNST-007 specifies 5min timeout for reports
   - But query tuning procedures not documented
   - Index creation process? Query plan analysis?

3. **Load Balancer Configuration**
   - CNST-007 specifies 200 concurrent user limit
   - But load balancer rules not documented
   - How is limit enforced (connection limit? rate limit?)

4. **ETL Error Handling**
   - CNST-007 specifies 8PM-6AM window
   - But failure recovery not clear
   - Auto-retry 3x? Then what? Manual intervention?
   - Can manual trigger override window constraint?

5. **Degradation Strategy**
   - CNST-007 says 100-200 users = degraded mode (20% slower)
   - But how is degradation triggered?
   - Which features degrade? Disable reports? Caching?

---

## 8. Evidence Classification

| Evidence | Status | Type | Source |
|----------|--------|------|--------|
| CNST-007 v1.0.1 document | PROVEN | Document | source/normativa/restricciones/CNST_007... |
| Response time SLAs | PROVEN | Specification | CNST-007 Section 2 |
| ETL window spec | PROVEN | Specification | CNST-007 Section 2.3 |
| Concurrency limits | PROVEN | Specification | CNST-007 Section 2.4 |
| Storage constraints | PROVEN | Specification | CNST-007 Section 2.5 |
| Availability target | PROVEN | Specification | CNST-007 Section 3 |
| APM tool implementation | SPECULATIVE | Implementation | Not found in documentation |
| Alert configuration | SPECULATIVE | Implementation | Not mentioned in CNST-007 |
| Current performance baseline | SPECULATIVE | Metrics | Not provided anywhere |
| Capacity planning document | SPECULATIVE | Planning | Not found |

---

## Conclusion

System constraints documentation is **strong on specification** (0.60 confidence) but **weak on monitoring and verification** (0.25 confidence). The 0.56 blended confidence reflects incomplete operational procedures.

**To advance from Phase 3 → Phase 4,** we need to:
1. Deploy APM tool with response time tracking
2. Configure alerts for SLA threshold breaches
3. Document and enforce ETL window constraints
4. Create capacity planning baseline with trends
5. Establish SLA compliance tracking and reporting
6. Create load testing plan and baseline

**Next step:** T-001 (search for existing monitoring tools)
