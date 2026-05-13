---
title: High-Level Design - Git Documentation Reorganization
issue_number: IACT-GIT-DOCS-001
date: 2025-11-13
phase: design
status: hld_complete
domain: operaciones
---

# High-Level Design: Git Documentation Reorganization

**Issue**: IACT-GIT-DOCS-001
**Phase**: FASE 3 - DESIGN (High-Level)
**Date**: 2025-11-13
**Status**: HLD Complete

---

## 1. System Overview

### 1.1 Purpose

Create a hierarchical 3-level documentation system for Git/GitHub workflows that enables progressive learning from basic to advanced concepts, supports self-service problem resolution, and serves as foundation for Git automation agents.

### 1.2 Scope

**In Scope**:
- 3-level folder structure (basic, intermediate, advanced)
- Integration of user-provided basic guide
- Reorganization of existing advanced guides
- README with learning roadmap and decision matrix
- Metadata standardization across all guides
- Cross-reference system between levels

**Out of Scope**:
- Creation of new guides beyond reorganization
- Video tutorials or interactive content
- Automated validation scripts (future work)
- Translation to other languages

### 1.3 Design Principles

**DP-1: Progressive Disclosure**
- Users see only information appropriate to their skill level
- Advanced concepts referenced but not explained in basic guides
- Clear pointers to next level when ready

**DP-2: Self-Contained Levels**
- Each level guide can be read independently
- Prerequisites clearly stated
- No assumptions about prior knowledge beyond stated prerequisites

**DP-3: Consistent Structure**
- All guides follow same metadata schema
- Consistent section naming and ordering
- Uniform formatting conventions

**DP-4: Discoverable Navigation**
- README serves as entry point for all users
- Decision matrix helps users find right guide
- Cross-references enable exploration

**DP-5: Maintainability**
- Clear ownership and update procedures
- Easy to add new guides to existing structure
- Metadata enables automated tooling (future)

---

## 2. System Architecture

### 2.1 Folder Structure Architecture

```
docs/devops/git/
├── README.md                           # Entry point, roadmap, decision matrix
├── planificacion/                      # SDLC documentation for this reorganization
│   ├── ISSUE_GIT_DOCS_REORGANIZATION.md
│   ├── FEASIBILITY_ANALYSIS_GIT_DOCS.md
│   ├── HLD_GIT_DOCS_REORGANIZATION.md  # This document
│   ├── LLD_GIT_DOCS_REORGANIZATION.md  # To be created
│   ├── DEPLOYMENT_PLAN_GIT_DOCS.md     # To be created
│   └── MAINTENANCE_PLAN_GIT_DOCS.md    # To be created
│
├── nivel_1_basico/
│   └── GIT_GITHUB_GUIA_INICIO.md       # Basic commands, workflows, conventions
│
├── nivel_2_intermedio/
│   └── FLUJO_SYNC_DEVELOP_ANTES_MERGE.md  # Sync with develop before PR
│
└── nivel_3_avanzado/
    └── MERGE_STRATEGY_NO_COMMON_ANCESTOR.md  # Special merge cases
```

### 2.2 Component Relationships

```
[README.md]
    |
    |-- Decision Matrix ---------> [Appropriate Guide]
    |
    |-- Learning Roadmap
         |
         +--> [Level 1] --> Prerequisites: None
         |       |
         |       +--> GIT_GITHUB_GUIA_INICIO.md
         |       |
         |       +--> Cross-refs --> [Level 2, Level 3]
         |
         +--> [Level 2] --> Prerequisites: Level 1
         |       |
         |       +--> FLUJO_SYNC_DEVELOP_ANTES_MERGE.md
         |       |
         |       +--> Cross-refs --> [Level 1, Level 3]
         |
         +--> [Level 3] --> Prerequisites: Level 1 + Level 2
                 |
                 +--> MERGE_STRATEGY_NO_COMMON_ANCESTOR.md
                 |
                 +--> Cross-refs --> [Level 1, Level 2]
```

### 2.3 User Flow Diagram

```
[New User] --> README.md
                   |
                   +--> Am I new to Git?
                   |        YES --> Level 1: GIT_GITHUB_GUIA_INICIO.md
                   |                    |
                   |                    +--> Practice 1-2 weeks
                   |                    |
                   |                    +--> Success: Can create PR
                   |                             |
                   |                             +--> Level 2
                   |
                   +--> Long-running feature branch?
                   |        YES --> Level 2: FLUJO_SYNC_DEVELOP_ANTES_MERGE.md
                   |                    |
                   |                    +--> Learn sync workflow
                   |                    |
                   |                    +--> Success: Can handle conflicts
                   |                             |
                   |                             +--> Level 3 (when needed)
                   |
                   +--> Error "no merge base"?
                            YES --> Level 3: MERGE_STRATEGY_NO_COMMON_ANCESTOR.md
                                        |
                                        +--> Learn cherry-pick strategy
                                        |
                                        +--> Success: Resolved special case
```

---

## 3. Component Design

### 3.1 README.md Component

**Purpose**: Entry point for all users, provides navigation and decision support

**Key Sections**:
1. Overview of documentation structure
2. Quick Start (which guide to read first)
3. Learning Roadmap (progression path)
4. Decision Matrix (situation -> guide mapping)
5. Quick Reference Table (commands by category)
6. Contribution Guidelines (for updating guides)

**Interfaces**:
- Input: User's skill level, current situation
- Output: Link to appropriate guide

**Design Rationale**:
- Single entry point reduces cognitive load
- Decision matrix enables self-service
- Learning roadmap shows clear progression

### 3.2 Level 1 Basic Component

**Purpose**: Teach fundamental Git commands and workflows for daily work

**Target Audience**:
- Developers with 0-6 months Git experience
- Anyone new to team's Git workflow
- Reference for basic commands

**Content Scope**:
- Essential commands (clone, add, commit, push, pull)
- Branch creation and switching
- Basic merge workflow
- Branch naming conventions
- Pre-push checklist
- Basic conflict resolution
- Emergency commands (reset, checkout)

**Cross-References**:
- Points to Level 2 for long-running branches
- Points to Level 3 for special merge cases

**Success Criteria**:
- User can create feature branch independently
- User can create PR without help
- User understands basic conflict resolution

### 3.3 Level 2 Intermediate Component

**Purpose**: Handle advanced workflows for long-running feature branches

**Target Audience**:
- Developers with 6+ months Git experience
- Working on features taking > 3 days
- Need to sync with frequently changing develop branch

**Content Scope**:
- Fetch and analyze develop changes
- Sync strategies (merge vs rebase)
- Conflict resolution for complex cases
- Validation before PR creation
- Rollback strategies

**Prerequisites**:
- Mastery of Level 1 commands
- Understanding of branches and merges
- Experience with at least 5 successful PRs

**Cross-References**:
- References Level 1 for basic commands
- Points to Level 3 if "no merge base" error occurs

**Success Criteria**:
- User can sync 3-day-old branch with develop
- User can resolve complex merge conflicts
- User can validate before PR

### 3.4 Level 3 Advanced Component

**Purpose**: Resolve special-case merge scenarios (branches without common ancestor)

**Target Audience**:
- Senior developers (1+ years experience)
- Handling repositories with divergent histories
- Resolving "no merge base" errors

**Content Scope**:
- Diagnosing "no merge base" problem
- Cherry-pick strategy with batching
- Git CP for file migration
- Rebase with --root
- Conflict detection scripts
- Rollback plans for failed merges

**Prerequisites**:
- Mastery of Level 1 and Level 2
- Understanding of Git internals (commits, SHAs, history)
- Experience with both merge and rebase

**Cross-References**:
- References Level 1 for basic commands
- References Level 2 for standard sync workflow
- May recommend consulting tech lead for first attempt

**Success Criteria**:
- User can diagnose "no merge base" problem
- User can execute cherry-pick strategy
- User understands when to escalate

---

## 4. Data Model

### 4.1 Guide Metadata Schema

Every guide file must include YAML frontmatter with following schema:

```yaml
---
title: string                    # Human-readable title
date: YYYY-MM-DD                 # Last update date
level: basic|intermediate|advanced  # Skill level
domain: operaciones              # Documentation domain
prerequisites: string|list       # Required knowledge
next_step: string (path)         # Next recommended guide
estimated_time: string           # Time to master (e.g., "1-2 weeks")
status: active|deprecated        # Current status
---
```

**Validation Rules**:
- `title`: Required, max 100 characters
- `date`: Required, ISO 8601 format
- `level`: Required, enum validation
- `domain`: Required, must be "operaciones" for Git docs
- `prerequisites`: Required (can be "None" for Level 1)
- `next_step`: Optional for Level 3, required for Level 1-2
- `estimated_time`: Required, human-readable format
- `status`: Required, enum validation

### 4.2 Cross-Reference Format

**Internal Links** (within Git documentation):
```markdown
For advanced sync workflows, see: [FLUJO_SYNC_DEVELOP_ANTES_MERGE.md](../nivel_2_intermedio/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md)
```

**External Links** (to other docs or web):
```markdown
See: [Conventional Commits](https://www.conventionalcommits.org/)
```

**Design Rationale**:
- Relative paths enable folder moves without breaking links
- Consistent format enables automated link validation (future)
- Full filename in link text aids discoverability

---

## 5. Interface Specifications

### 5.1 README -> Guide Interface

**Input**: User query (skill level, problem, situation)

**Processing**:
1. User reads decision matrix
2. Identifies situation (new developer, long branch, merge error)
3. Follows link to appropriate guide

**Output**: URL to specific guide file

**Contract**:
- README must keep decision matrix updated
- All guides referenced in decision matrix must exist
- Links must use relative paths

### 5.2 Guide -> Guide Interface

**Input**: User reading guide, encounters advanced topic

**Processing**:
1. Guide mentions topic beyond current level
2. Provides context-sensitive link to relevant guide
3. User clicks link (optional)

**Output**: Navigation to referenced guide

**Contract**:
- Cross-references must include brief context
- Links must point to existing files
- Target guide must cover referenced topic

### 5.3 User -> Metadata Interface

**Input**: User viewing guide in text editor or GitHub

**Processing**:
1. User reads YAML frontmatter
2. Extracts key information (level, prerequisites, time estimate)
3. Decides if guide is appropriate

**Output**: Decision to read or skip guide

**Contract**:
- Frontmatter must be valid YAML
- All required fields must be present
- Values must be human-readable

---

## 6. Performance Considerations

### 6.1 Discoverability Performance

**Goal**: User finds correct guide in < 2 minutes

**Measurement**:
- Time from "I have a Git problem" to "I'm reading the right guide"

**Design Support**:
- Single entry point (README)
- Decision matrix with 6-8 common situations
- Clear level naming (basic, intermediate, advanced)

**Target**: 90% of users find correct guide in < 2 minutes

### 6.2 Navigation Performance

**Goal**: Minimal clicks to reach any guide

**Measurement**:
- Click depth from README to any guide

**Design Support**:
- Flat structure (max 2 levels deep)
- Direct links in decision matrix (1 click from README)
- Cross-references for related topics (1 click between guides)

**Target**: Max 2 clicks from README to any guide

### 6.3 Learning Performance

**Goal**: Users progress through levels efficiently

**Measurement**:
- Time to complete each level (reach success criteria)

**Design Support**:
- Clear success criteria per level
- Estimated time guidance
- Progressive disclosure (don't overwhelm)

**Targets**:
- Level 1: 1-2 weeks for new developer
- Level 2: 3-5 days for intermediate developer
- Level 3: As needed (special cases only)

---

## 7. Security and Access Control

### 7.1 No Sensitive Information

**Requirement**: Guides must not contain secrets, credentials, or internal URLs

**Implementation**:
- Use example URLs (example.com, usuario/repositorio)
- Use placeholder names (nombre_archivo, nombre_rama)
- No actual repository URLs or credentials

**Validation**: Manual review during creation and updates

### 7.2 Public Accessibility

**Design Decision**: All Git guides are public documentation

**Rationale**:
- Git workflows are not proprietary
- Public documentation aids collaboration
- No competitive advantage in hiding Git practices

**Implication**: Safe to reference in public commits and PRs

---

## 8. Scalability and Extensibility

### 8.1 Adding New Guides

**Process**:
1. Determine appropriate level (basic, intermediate, advanced)
2. Create guide with standard metadata
3. Update README decision matrix
4. Add cross-references from related guides
5. Update learning roadmap if needed

**Design Support**:
- Flat folder structure accommodates unlimited guides per level
- Metadata schema supports future categories
- README structure supports additional sections

**Example**: Adding "REBASE_VS_MERGE.md" (intermediate)
1. Create docs/devops/git/nivel_2_intermedio/REBASE_VS_MERGE.md
2. Add to README decision matrix: "Need to clean up commits before PR? -> REBASE_VS_MERGE.md"
3. Cross-reference from Level 1 (mention rebase exists)
4. Update Level 2 prerequisite list

### 8.2 Adding New Levels

**Scenario**: Future need for Level 4 (expert) or Level 0 (absolute beginner)

**Design Support**:
- Naming convention supports additional levels (nivel_4_experto)
- README structure accommodates more levels in roadmap
- Metadata schema supports new level values

**Process**:
1. Create new folder (nivel_4_experto/)
2. Move or create appropriate guides
3. Update README roadmap with new level
4. Update decision matrix
5. Add new level to metadata enum

### 8.3 Integration with Automation

**Future Extension**: Git automation agents reference guides

**Design Support**:
- Consistent file naming enables programmatic reference
- Metadata enables agent to recommend appropriate guide
- Relative links work regardless of access method

**Example**: GitAnalysisAgent detects "no merge base"
```python
error_message = (
    "No common ancestor detected. "
    "See: docs/devops/git/nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md"
)
```

---

## 9. Error Handling and Edge Cases

### 9.1 User at Wrong Level

**Scenario**: Beginner reads advanced guide

**Handling**:
- Frontmatter clearly states level and prerequisites
- Guide mentions required knowledge upfront
- Cross-reference to prerequisite guides

**Example**:
```markdown
IMPORTANTE: This is an ADVANCED guide. Prerequisites:
- Mastery of basic Git commands (see: GIT_GITHUB_GUIA_INICIO.md)
- Understanding of merge vs rebase (see: FLUJO_SYNC_DEVELOP_ANTES_MERGE.md)
```

### 9.2 Situation Not in Decision Matrix

**Scenario**: User's problem not covered in decision matrix

**Handling**:
- Decision matrix includes "Other/Unsure" row
- Points to most general guide (Level 1) as starting point
- Includes "Ask for help" escalation path

**Example**:
```markdown
| Unsure / Not listed | Start with Level 1, then ask tech lead | GIT_GITHUB_GUIA_INICIO.md |
```

### 9.3 Broken Cross-Reference

**Scenario**: Guide references moved or deleted file

**Handling**:
- Validation step in deployment checks all links
- Broken links block deployment
- Maintenance plan includes quarterly link validation

**Prevention**:
- Use relative paths (survive folder moves)
- Document file moves in git history
- Automated link checker (future enhancement)

---

## 10. Assumptions and Constraints

### 10.1 Assumptions

**A-1**: Users have basic markdown reading ability
- **Validation**: Reasonable for technical audience
- **Impact if False**: Need to provide markdown primer

**A-2**: Users access documentation via GitHub or local clone
- **Validation**: Aligns with development workflow
- **Impact if False**: May need web-hosted version

**A-3**: Git workflows remain relatively stable
- **Validation**: Git fundamentals unchanged for 10+ years
- **Impact if False**: Major updates needed (unlikely)

**A-4**: Users prefer text documentation over video
- **Validation**: Searchable, versionable, faster to scan
- **Impact if False**: May add video supplements later

### 10.2 Constraints

**C-1**: Must not use emojis (user requirement)
- **Implication**: Use text labels (NOTA:, ADVERTENCIA:, IMPORTANTE:)

**C-2**: Must follow SDLC 6-phase methodology
- **Implication**: This HLD is FASE 3 of 6

**C-3**: Documentation must be in Spanish (current state)
- **Implication**: English translation future work

**C-4**: Must work with existing Git infrastructure
- **Implication**: Cannot require special tools or platforms

---

## 11. Deployment Architecture

### 11.1 File Deployment

**Location**: docs/devops/git/ within IACT---project repository

**Access**:
- Local: Via cloned repository
- Remote: Via GitHub web interface
- CI/CD: Accessible to automation scripts

**Version Control**:
- All changes tracked in Git
- Updates via standard PR process
- History preserved (git mv for file moves)

### 11.2 Update Process

**Minor Updates** (typo fixes, small clarifications):
1. Edit file directly
2. Update `date` in frontmatter
3. Commit with message: "docs(git): fix typo in [guide]"
4. Push to feature branch
5. Create PR

**Major Updates** (new sections, restructuring):
1. Create feature branch
2. Update guide(s)
3. Update README if navigation changes
4. Update `date` in frontmatter
5. Validate all cross-references
6. PR with detailed description

**Adding New Guide**:
1. Follow process in Section 8.1
2. Use existing guide as template
3. PR must update README decision matrix

---

## 12. Integration Points

### 12.1 Integration with TFG-Server (Future)

**Context**: User plans integration with TFG-Server project after Git phases

**Integration Strategy**:
- Copy or symlink docs/devops/git/ -> TFG-server/docs/devops/git/
- Adapt content references to TFG-Server conventions
- Align with TFG-Server script names (ci-local.sh, etc.)
- Add TFG-Server-specific examples

**Design Support**:
- Generic examples easily adapted
- No IACT-specific content (uses placeholders)
- Structure transferable to any project

**Future Work**: FASE 1-6 for TFG-Server integration

### 12.2 Integration with Git Automation Agents

**Context**: Git agents proposed in PROPUESTA_GIT_AUTOMATION_AGENTS.md

**Integration Strategy**:
- Agents reference guides in error messages
- Agents use metadata to recommend appropriate guide
- Agents validate practices documented in guides

**Example**:
```python
class GitAnalysisAgent:
    def _detect_no_merge_base(self, branch1, branch2):
        result = {
            "error": "no_merge_base",
            "recommendation": "docs/devops/git/nivel_3_avanzado/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md"
        }
        return result
```

**Design Support**:
- Stable file paths (agents can hardcode)
- Metadata `level` helps agent recommend appropriate guide for user skill

### 12.3 Integration with Git Hooks Framework

**Context**: MODULAR SUBDIVISION Framework proposed in INTEGRACION_GIT_HOOKS_Y_AGENTS.md

**Integration Strategy**:
- Hooks enforce conventions documented in guides
- Guides reference hook behavior
- Bi-directional documentation

**Example in Guide**:
```markdown
NOTA: Branch naming conventions are validated automatically by pre-commit hook.
See: docs/devops/git-hooks/PRECOMMIT.3-naming-validation.sh
```

**Example in Hook**:
```bash
# PRECOMMIT.3
echo "ERROR: Invalid branch name. See naming conventions:"
echo "docs/devops/git/nivel_1_basico/GIT_GITHUB_GUIA_INICIO.md#convenciones-de-nombres-de-ramas"
```

---

## 13. Testing Strategy (High-Level)

**Note**: Detailed testing in FASE 4, this section outlines approach

### 13.1 Structural Testing

**Objective**: Verify folder structure and file locations

**Approach**:
- Script to verify 3 levels exist
- Check each guide is in correct level folder
- Validate README exists

**Success Criteria**: 100% structural compliance

### 13.2 Content Testing

**Objective**: Verify guides contain required sections and metadata

**Approach**:
- Parse YAML frontmatter
- Check all required fields present
- Verify no emojis (grep)
- Check cross-references point to existing files

**Success Criteria**:
- 100% guides have complete metadata
- 0 emojis found
- 100% cross-references valid

### 13.3 Usability Testing

**Objective**: Verify users can find and use guides

**Approach**:
- Manual review of decision matrix coverage
- Check prerequisite chains are logical
- Verify success criteria are measurable

**Success Criteria**: Subjective "makes sense" validation

---

## 14. Maintenance and Evolution

### 14.1 Ownership

**Primary Owner**: Tech Lead / DevOps Team

**Responsibilities**:
- Review PRs updating guides
- Quarterly validation of cross-references
- Monitor for outdated content

### 14.2 Update Triggers

**When to Update**:
1. Git workflow changes (new conventions)
2. User feedback (confusing sections)
3. New Git features (Git version upgrades)
4. Broken links detected
5. Quarterly maintenance review

**Update Process**: See Section 11.2

### 14.3 Metrics for Health

**M-1**: Cross-reference validity
- Target: 100% valid links
- Check: Quarterly via script or manual

**M-2**: Metadata completeness
- Target: 100% guides with complete frontmatter
- Check: Automated via YAML parser

**M-3**: Emoji compliance
- Target: 0 emojis
- Check: Automated via grep

**M-4**: Usage metrics (future)
- Measure: Page views, time on page (if web-hosted)
- Target: TBD based on baseline

---

## 15. Risks and Mitigations (Design Level)

### R-1: README Becomes Bloated

**Risk**: As guides added, README grows too large

**Likelihood**: Medium (over 1-2 years)
**Impact**: Low (users confused, long scroll)

**Mitigation**:
- Use collapsible sections if markdown supports
- Break README into multiple pages if needed
- Prioritize decision matrix (most critical section)

### R-2: Level Classification Ambiguity

**Risk**: Unclear whether guide is intermediate or advanced

**Likelihood**: Low
**Impact**: Low (user reads wrong guide first)

**Mitigation**:
- Clear definition of each level in README
- Prerequisites explicitly list required knowledge
- When in doubt, classify higher (better to be too advanced than too basic)

### R-3: Cross-Reference Rot

**Risk**: Guides reference each other, but links break as files move

**Likelihood**: Medium (without automated checking)
**Impact**: Medium (user frustration)

**Mitigation**:
- Use relative paths (survive folder moves)
- Quarterly manual validation
- Future: Automated link checker in CI

---

## 16. Success Metrics

### Design-Level Metrics

**DM-1: Structural Completeness**
- Target: 100% (all planned folders and files exist)
- Measure: Directory tree matches Section 2.1

**DM-2: Component Cohesion**
- Target: Each guide covers single skill level
- Measure: Manual review (no mixed-level content)

**DM-3: Interface Clarity**
- Target: All cross-references have context
- Measure: Manual review (each link has explanatory text)

**DM-4: Metadata Consistency**
- Target: 100% guides use same schema
- Measure: Automated YAML validation

---

## 17. Alternative Designs Considered

### Alt-1: Single Flat Folder

**Structure**:
```
docs/devops/git/
├── README.md
├── basic_guide.md
├── intermediate_guide.md
└── advanced_guide.md
```

**Pros**: Simpler, fewer folders
**Cons**: Doesn't scale, no clear organization
**Decision**: REJECTED - Poor scalability

### Alt-2: Feature-Based Organization

**Structure**:
```
docs/devops/git/
├── branching/
├── merging/
├── conflicts/
└── workflows/
```

**Pros**: Organized by topic
**Cons**: Same topic spans multiple skill levels, confusing
**Decision**: REJECTED - Doesn't support progressive learning

### Alt-3: Role-Based Organization

**Structure**:
```
docs/devops/git/
├── developers/
├── tech_leads/
└── devops/
```

**Pros**: Clear audience
**Cons**: Developers progress through roles, unclear which to read
**Decision**: REJECTED - Skills don't map cleanly to roles

### Alt-4: Skill-Based Hierarchy (SELECTED)

**Structure**: See Section 2.1

**Pros**:
- Clear progression path
- Scales well
- Maps to user skill development
- Supports self-assessment

**Cons**: Must classify each guide by level (minor effort)

**Decision**: SELECTED - Best supports user learning journey

---

## 18. Appendices

### A. Glossary

- **Level**: Skill tier (basic, intermediate, advanced)
- **Cross-Reference**: Link from one guide to another
- **Decision Matrix**: Table mapping situations to guides
- **Frontmatter**: YAML metadata at top of markdown file
- **Progressive Disclosure**: Show information appropriate to user's level

### B. References

- **Planning Phase**: ISSUE_GIT_DOCS_REORGANIZATION.md
- **Feasibility Phase**: FEASIBILITY_ANALYSIS_GIT_DOCS.md
- **User-Provided Guide**: Shared in conversation 2025-11-13
- **Existing Guides**:
  - docs/operaciones/FLUJO_SYNC_DEVELOP_ANTES_MERGE.md
  - docs/operaciones/MERGE_STRATEGY_NO_COMMON_ANCESTOR.md

### C. Design Decisions Log

| Decision | Rationale | Alternatives Considered | Date |
|----------|-----------|------------------------|------|
| 3-level hierarchy | Maps to skill progression | Flat, feature-based, role-based | 2025-11-13 |
| Spanish documentation | Current state, team language | English first, bilingual | 2025-11-13 |
| No emojis | User requirement | Text-based emojis, icons | 2025-11-13 |
| Relative links | Survive folder moves | Absolute paths, anchors | 2025-11-13 |
| YAML frontmatter | Standard, parseable | JSON, TOML | 2025-11-13 |

---

**Status**: HLD COMPLETE
**Approved By**: SDLC Agent (autonomous)
**Next Step**: LLD (Low-Level Design)
**Estimated LLD Duration**: 2-3 hours
