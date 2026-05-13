```yml
type: Ejemplos Prácticos
category: Casos de Uso
version: 1.0
purpose: Colección de ejemplos reales de cómo usar THYROX en diferentes escenarios.
goal: Demostrar aplicación práctica del skill con casos concretos.
updated_at: 2026-04-10 05:00:00
owner: thyrox (cross-phase)
```

# THYROX Use Cases & Examples

## Propósito

Colección de ejemplos reales de cómo usar THYROX en diferentes escenarios.

> Objetivo: Demostrar aplicación práctica del skill con casos concretos.

---

This document provides real-world examples of using THYROX across different scenarios.

Each use case follows the 7-phase methodology: **ANALYZE → SOLUTION_STRATEGY → PLAN → STRUCTURE → DECOMPOSE → EXECUTE → TRACK**

> Note: Short examples may skip phases 1 and 2 when analysis and strategy are implicit or trivial.

## Use Case 1: Simple Feature - "Add Password Reset"

### Phase 3: PLAN (5 min)

```
User: "We need to add password reset functionality"

THYROX:
  Q1: When users forget password, what happens?
  Q2: Email verification or SMS?
  Q3: Token expiry time?
  Q4: Resend limit?
  Q5: Success/error messages?

User: Email verification, 1 hour token, 5 resends/hour

THYROX Updates ROADMAP.md:
```

### Phase 5: DECOMPOSE (5 min)

```
THYROX: Breaking down into tasks...

/task:create "Database: add password_reset_tokens table"
/task:create "Service: create reset token" --depends-on "task-1"
/task:create "API: POST /auth/password-reset" --depends-on "task-2"
/task:create "API: POST /auth/password-reset/verify" --depends-on "task-3"
/task:create "Email: password reset template"
/task:create "Tests: password reset flow"
/task:create "Docs: password reset API"

ROADMAP.md updated with all subtasks:
  Password Reset Feature
  - [ ] Database schema
  - [ ] Reset service
  - [ ] Reset endpoint
  - [ ] Verify endpoint
  - [ ] Email template
  - [ ] Tests
  - [ ] Docs
```

### Phase 6: EXECUTE (2-3 hours total)

```
Day 1 - Session 1 (Database):
  /task:show
  → Shows task-1 (no blockers)
  
  Dev: Creates migration, commits:
  feat(db): add password_reset_tokens table
  
  Updates ROADMAP.md:
  - [x] Database schema (2025-03-24)

Day 1 - Session 2 (API + Service):
  /task:show
  → Shows task-2 (task-1 complete)
  
  Dev: Creates service, commits:
  feat(auth): add reset token generation
  feat(api): add password reset endpoint
  
  Updates ROADMAP.md:
  - [x] Reset service (2025-03-24)
  - [x] Reset endpoint (2025-03-24)

Day 2 - Session 3 (Verify + Email):
  /task:show
  → Shows task-4, task-5 (no blockers)
  
  Dev: Creates verify logic, email template, commits:
  feat(api): add password reset verification
  feat(email): add password reset template
  
  Updates ROADMAP.md:
  - [x] Verify endpoint (2025-03-25)
  - [x] Email template (2025-03-25)

Day 2 - Session 4 (Tests):
  /task:show
  → Shows task-6 (all dependencies met)
  
  Dev: Creates tests, commits:
  test(auth): add password reset tests
  test(api): add endpoint tests
  
  Updates ROADMAP.md:
  - [x] Tests (2025-03-25)

Day 3 - Session 5 (Docs):
  /task:show
  → Shows task-7 (ready)
  
  Dev: Updates docs, commits:
  docs(api): add password reset endpoint docs
  
  Updates ROADMAP.md:
  - [x] Docs (2025-03-25)
```

### Phase 7: TRACK

```
User: "What's our status?"

THYROX reads ROADMAP.md:
  Password Reset Feature - COMPLETE
  - [x] Database schema (2025-03-24)
  - [x] Reset service (2025-03-24)
  - [x] Reset endpoint (2025-03-24)
  - [x] Verify endpoint (2025-03-25)
  - [x] Email template (2025-03-25)
  - [x] Tests (2025-03-25)
  - [x] Docs (2025-03-25)
  
  Recent commits:
  feat(db): add password_reset_tokens table
  feat(auth): add reset token generation
  feat(api): add password reset endpoint
  feat(api): add password reset verification
  feat(email): add password reset template
  test(auth): add password reset tests
  test(api): add endpoint tests
  docs(api): add password reset endpoint docs
```

---

## Tabla de Contenidos

- [Use Case 1: Simple Feature - "Add Password Reset"](#use-case-1-simple-feature---"add-password-reset")
- [Use Case 2: Complex Feature - "Payment System"](#use-case-2-complex-feature---"payment-system")
- [Use Case 3: Bug Fix - "Token Expiry Race Condition"](#use-case-3-bug-fix---"token-expiry-race-condition")
- [Use Case 4: Standup During Development](#use-case-4-standup-during-development)
- [Use Case 5: Complex Dependencies](#use-case-5-complex-dependencies)
- [Use Case 6: Weekly Changelog Generation](#use-case-6-weekly-changelog-generation)
- [Use Case 7: Handling Blockers](#use-case-7-handling-blockers)
- [Use Case 8: Tech Debt & Refactoring](#use-case-8-tech-debt-&-refactoring)
- [Database Query Optimization](#database-query-optimization)
- [Consolidate Auth Services](#consolidate-auth-services)
- [Tips for Different Feature Sizes](#tips-for-different-feature-sizes)

---


## Use Case 2: Complex Feature - "Payment System"

### Phase 3: PLAN (30 min - complex feature)

```
User: "We need to build a payment system for subscriptions"

THYROX: [Asks 10 detailed questions about Stripe, billing cycles, etc.]

User: [Provides detailed context]

THYROX: "This looks complex. Should we create a PRD?"

User: "Yes, let's do that"
```

### Phase 4: STRUCTURE (1 hour)

```
THYROX creates .claude/prds/payment-system.md with:
- Overview
- Stripe integration requirements
- Billing cycles (monthly/yearly)
- Invoice generation
- Webhook handling
- User subscription management
- Admin controls

User reviews and refines PRD
```

### Phase 5: DECOMPOSE (30 min)

```
THYROX analyzes PRD and identifies work streams:

Stream A (Database):
/task:create "Database: customers table"
/task:create "Database: subscriptions table"
/task:create "Database: invoices table"
/task:create "Database: webhook_logs table"

Stream B (Stripe Service):
/task:create "Service: Stripe client init" --depends-on "task-1"
/task:create "Service: customer creation" --depends-on "task-2"
/task:create "Service: subscription creation" --depends-on "task-2,task-3"
/task:create "Service: invoice generation" --depends-on "task-4"

Stream C (API Endpoints):
/task:create "API: POST /subscriptions" --depends-on "task-6"
/task:create "API: GET /subscriptions" --depends-on "task-6"
/task:create "API: DELETE /subscriptions" --depends-on "task-6"

Stream D (Webhooks):
/task:create "Webhook: handle payment_intent.succeeded" --depends-on "task-8"
/task:create "Webhook: handle customer.subscription.updated" --depends-on "task-8"
/task:create "Webhook: signature verification" --depends-on "task-8"

Stream E (Admin):
/task:create "Admin: view customers"
/task:create "Admin: view subscriptions"
/task:create "Admin: manual invoice creation"

Stream F (Tests):
/task:create "Tests: subscription flow" --depends-on "task-9,task-10,task-11,task-12,task-13,task-14"

Stream G (Docs):
/task:create "Docs: API docs" --depends-on "task-9,task-10,task-11"
/task:create "Docs: webhook docs" --depends-on "task-12,task-13,task-14"

ROADMAP.md updated with all 16 subtasks
```

### Phase 6: EXECUTE (5-7 days, parallel)

```
Session 1 (Database Setup):
  Day 1-2: Create all schema migrations
  
Session 2 (Stripe Integration):
  Day 1-2: Set up Stripe client
  Day 2-3: Create customer/subscription services
  
Session 3 (API Development):
  Day 2-3: Build subscription endpoints
  
Session 4 (Webhook Handling):
  Day 3-4: Set up webhook receivers and processing
  
Session 5 (Admin Dashboard):
  Day 4-5: Create admin interfaces
  
Session 6 (Testing):
  Day 5-6: Comprehensive test suite
  
Session 7 (Documentation):
  Day 6-7: Complete API and webhook documentation

All sessions work in parallel, commit frequently.
Dependencies ensure Sequential work only where needed.
```

### Phase 7: TRACK

```
User: "What's our status on payments?"

THYROX shows:

Payment System - 90% Complete

Database:
  - [x] customers table (2025-03-24)
  - [x] subscriptions table (2025-03-24)
  - [x] invoices table (2025-03-24)
  - [x] webhook_logs table (2025-03-24)

Stripe Service:
  - [x] Stripe client init (2025-03-25)
  - [x] Customer creation (2025-03-25)
  - [x] Subscription creation (2025-03-25)
  - [x] Invoice generation (2025-03-25)

API Endpoints:
  - [x] POST /subscriptions (2025-03-26)
  - [x] GET /subscriptions (2025-03-26)
  - [-] DELETE /subscriptions (in progress)

Webhooks:
  - [x] Handle payment_intent.succeeded (2025-03-27)
  - [x] Handle subscription.updated (2025-03-27)
  - [x] Signature verification (2025-03-27)

Admin:
  - [x] View customers (2025-03-27)
  - [x] View subscriptions (2025-03-27)
  - [x] Manual invoice creation (2025-03-27)

Testing:
  - [-] Full flow tests (in progress, 75%)

Docs:
  - [ ] API docs (ready to start)
  - [ ] Webhook docs (ready to start)

In Progress: DELETE endpoint, tests (80%)
Blocked: None
Next: Complete tests, then API docs
```

---

## Use Case 3: Bug Fix - "Token Expiry Race Condition"

### Quick Flow (No Planning Needed)

```
User: "There's a bug in token handling - race condition on expiry"

THYROX: "Got it. This is a quick fix. Should I add it to ad-hoc-tasks.md?"

User: "Just fix it"

Dev: 
  feat(auth): fix race condition in token expiry
  test(auth): add regression test for token race condition

Updates ROADMAP.md or ad-hoc-tasks.md:
  Bug Fixes
  - [x] Token expiry race condition (2025-03-24)
```

---

## Use Case 4: Standup During Development

```
User: "Standup"

THYROX reads ROADMAP.md and git log:

Daily Standup - 2025-03-24

In Progress:
  - API endpoints (60%) - JSON serialization issue being debugged
  - Tests (40%) - Need to wait for API complete

Blocked:
  - Admin dashboard - waiting on database migration merge

Next (Ready to Start):
  - Documentation (all dependencies met)

Recent Commits (last 24h):
  feat(db): add webhook_logs table
  feat(auth): add reset token service
  feat(api): add subscription endpoint
  fix(auth): handle concurrent token requests
  test(auth): add token tests

Completed:
  - Database schema (all done)
  - Stripe client integration (all done)

Velocity: 5 commits, 3 features completed, 1 blocker
```

---

## Use Case 5: Complex Dependencies

```
ROADMAP.md structure for complex feature:

Feature: Real-time Notifications

- [ ] WebSocket setup (foundation)
- [ ] Notification service (depends on WebSocket)
- [ ] User preferences (independent)
- [ ] Frontend client (depends on WebSocket, User preferences)
- [ ] Push notifications (depends on Notification service)
- [ ] Email notifications (independent)
- [ ] Tests (depends on all components)
- [ ] Docs (final)

Task creation shows dependencies:

/task:create "WebSocket server setup"  # task-1
/task:create "Notification service" --depends-on "task-1"  # task-2
/task:create "User notification preferences"  # task-3 (independent)
/task:create "Frontend WebSocket client" --depends-on "task-1,task-3"  # task-4
/task:create "Push notification handler" --depends-on "task-2"  # task-5
/task:create "Email notification handler"  # task-6 (independent)
/task:create "Tests" --depends-on "task-2,task-4,task-5,task-6"  # task-7
/task:create "Docs" --depends-on "task-7"  # task-8

Parallel Paths:
- Path A: task-1 → task-2 → task-5 → task-7
- Path B: task-3 → task-4 (in parallel with Path A after task-1)
- Path C: task-6 (in parallel with all others)
- Final: task-8 (after task-7)

Result: Can execute in ~3-4 days instead of 8 (5 work streams in parallel)
```

---

## Use Case 6: Weekly Changelog Generation

```
User: "Generate changelog for this week"

THYROX:
  1. Reads recent commits: git log v0.1.0..HEAD
  2. Groups by type:
  
  feat(auth):
    - add JWT token refresh mechanism
    - add password reset flow
  
  feat(payments):
    - integrate Stripe API
    - add subscription endpoints
  
  fix(api):
    - fix race condition in token handling
    - handle null user references
  
  test:
    - add comprehensive auth tests
    - add payment flow tests
  
  3. Updates CHANGELOG.md:

  ## [0.2.0] - 2025-03-28
  
  ### Added
  - JWT token refresh mechanism
  - Password reset flow with email verification
  - Stripe payment integration with subscriptions
  - Subscription management endpoints
  
  ### Fixed
  - Race condition in concurrent token requests
  - Null reference handling in API responses
  
  ### Tests Added
  - Comprehensive authentication test suite
  - End-to-end payment flow tests
  
  4. Creates git tag:
  git tag -a v0.2.0 -m "Release v0.2.0"
```

---

## Use Case 7: Handling Blockers

```
ROADMAP.md during development:

Feature: Email Notifications

- [x] Email service setup (2025-03-24)
- [x] Template system (2025-03-24)
- [-] Email sending (BLOCKED - waiting on SMTP credentials)
- [ ] Testing (blocked, waiting on sending)

Blocked by: SMTP credentials from DevOps
Waiting on: @devops team
Contacted: 2025-03-24 10:00 AM
ETA: 2025-03-24 5:00 PM

Next day:

User: "What's the status?"

THYROX: "Email notifications blocked on SMTP credentials, waiting on devops"

When credentials arrive:

THYROX: Update ROADMAP.md
- [-] Email sending (BLOCKED → IN PROGRESS)

Dev: Complete and commit
feat(email): implement email sending

Update ROADMAP.md:
- [x] Email sending (2025-03-25)
- [-] Testing (ready to start)
```

---

## Use Case 8: Tech Debt & Refactoring

### Option 1: Add to refactors.md

```
../skills/workflow-track/assets/refactors.md.template:

## Database Query Optimization

Current issue: N+1 queries in user list endpoint
Location: api/handlers/users.py:45
Impact: High (users endpoint takes 500ms for 100 users)
Priority: High
Estimated: 2-3 hours
Status: Not started

---

## Consolidate Auth Services

Current issue: Auth logic scattered across 3 files
Location: auth/service.py, auth/tokens.py, middleware/auth.py
Impact: Medium (hard to maintain)
Priority: Medium
Estimated: 4-5 hours
Status: Not started
```

### Option 2: Create Refactor Tasks

When scheduling refactor work:

```
/task:create "Refactor: optimize database queries" --depends-on "task-X"
/task:create "Refactor: consolidate auth services" --depends-on "task-X"

Commits:
refactor(db): optimize N+1 queries in user endpoint
refactor(auth): consolidate auth logic into single module
```

---

## Tips for Different Feature Sizes

### Small Feature (1-2 hours)
- No PHASE update needed
- Use [ad-hoc-tasks](../skills/workflow-execute/assets/ad-hoc-tasks.md.template)
- One Claude Code session
- One commit or two

### Medium Feature (1-3 days)
- Add to ROADMAP.md under current PHASE
- Create 3-5 tasks
- Maybe 2-3 parallel sessions
- Use ROADMAP.md progress tracking

### Large Feature (1-2 weeks+)
- Create PRD at .claude/prds/
- Add to new PHASE in ROADMAP.md
- Create 8-12 tasks with dependencies
- Use multiple parallel sessions
- Track blockers and velocity

### Bug Fix
- Use [ad-hoc-tasks](../skills/workflow-execute/assets/ad-hoc-tasks.md.template) for documentation
- Fix and commit immediately
- No task creation needed unless complex
- Update CHANGELOG.md in next release

---

See [conventions.md](./conventions.md) for detailed formatting and structure requirements.
