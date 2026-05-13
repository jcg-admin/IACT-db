# Recommendation Deck Structure — Template

> Use this template for the cp:recommend artifact. Each section maps to slides in the executive presentation.

```yml
created_at: YYYY-MM-DD HH:MM:SS
project: [Project name]
work_package: YYYY-MM-DD-HH-MM-SS-nombre
phase: Phase 5 — STRATEGY
author: [Consultant name]
status: Borrador
```

---

## Deck Header

| Field | Value |
|-------|-------|
| **Title** | [Recommendation title — should state the answer, e.g., "RetailCo should implement discount governance to recover $12-15M margin"] |
| **Client** | [Client name] |
| **Presented by** | [Consulting team] |
| **Date** | [YYYY-MM-DD] |
| **Version** | [Final / Pre-read] |
| **Confidentiality** | [Confidential — for [client] management use only] |

---

## Slide 1: Executive Summary (THE most important slide)

**Slide purpose:** Stand-alone summary — if the client reads only this slide, they understand the full recommendation.

**Structure:**

```
HEADLINE: [Recommendation stated directly — 1 sentence with $ or % impact]

Situation:
[1-2 sentences: agreed context]

Complication:
[1-2 sentences: the problem, quantified]

Recommendation:
[1-2 sentences: the answer]

Supporting arguments:
• [Arg 1 — 1 sentence with key number]
• [Arg 2 — 1 sentence with key number]
• [Arg 3 — 1 sentence with key number]

Expected impact: [$ or % outcome in N months]
Investment required: [$ and resource effort]
```

---

## Section A: Context (Slides 2-3)

**Purpose:** Establish the Situation — facts the audience already agrees with.

**Slide 2: Business Context**

Headline: "[Client] operates in a [X] industry with [Y characteristics]"

Content:
- Company / market snapshot (2-3 bullet points)
- Historical performance (chart: key metric over 5 years)
- Strategic context (1-2 sentences)

**Slide 3: The Problem — Quantified**

Headline: "[Specific metric] has declined [X%] over [N years], costing [$ amount]"

Content:
- Problem statement with numbers
- Impact quantification
- Timeline of decline
- Chart: metric trend with annotation

---

## Section B: Our Approach (Slide 4)

**Purpose:** Show analytical rigor without dwelling on process.

**Slide 4: Analytical Approach**

Headline: "We examined [N] hypotheses across [N] workstreams to identify the primary driver"

Content:
- Issue Tree summary (simplified version — 2 levels)
- Hypotheses tested (list H1, H2, H3 with status: confirmed/killed)
- Data sources used
- Interviews conducted (number, functions)

> Rule: This slide establishes credibility but should not exceed 1 slide. The client hired you for the answer, not the methodology.

---

## Section C: Findings (Slides 5-12)

**Purpose:** Evidence supporting the 3-5 key arguments. 2-3 slides per argument.

### Finding 1: [Title of Argument 1]

**Slide 5: [Arg 1 stated as finding]**

Headline: "[Specific claim with number — e.g., 'SMB discounting averages 22% vs 10% policy, costing $18M annually']"

Content:
- Primary chart/analysis (the key exhibit)
- 2-3 bullet points interpreting the chart
- "So what": implication for the recommendation

**Slide 6: [Supporting evidence for Arg 1]**

Headline: "[Second supporting finding]"

Content:
- Supporting analysis
- Benchmark or comparison
- "So what"

---

### Finding 2: [Title of Argument 2]

**Slide 7: [Arg 2 stated as finding]**

Headline: "[Specific claim with number]"

Content:
- Primary chart/analysis
- 2-3 bullets
- "So what"

**Slide 8: [Supporting evidence for Arg 2]**

Headline: "[Second supporting finding]"

---

### Finding 3: [Title of Argument 3]

**Slide 9: [Arg 3 stated as finding]**

Headline: "[Specific claim with number]"

**Slide 10: [Supporting evidence for Arg 3]**

---

## Section D: Recommendation (Slides 11-12)

**Purpose:** Restate the answer with full synthesis.

**Slide 11: The Recommendation**

Headline: "[Recommendation restated — same as executive summary headline]"

Content:
- Recommendation in 2-3 sentences
- Summary argument table:

| Argument | Key finding | Implication |
|----------|------------|-------------|
| Arg 1 | [Summary] | [Why this supports the recommendation] |
| Arg 2 | [Summary] | [Why this supports the recommendation] |
| Arg 3 | [Summary] | [Why this supports the recommendation] |

**Slide 12: Alternatives Considered**

Headline: "[Recommendation] is the highest-impact option among [N] alternatives assessed"

Content:
- Options evaluated (3-4 options including recommended one)
- Assessment matrix:

| Option | Impact | Feasibility | Timeline | Selected? |
|--------|--------|-------------|----------|-----------|
| [Recommended option] | High | High | 12 mo | ✓ |
| [Alternative A] | Med | High | 6 mo | — |
| [Alternative B] | High | Low | 24 mo | — |
| [Status quo] | None | — | — | — |

---

## Section E: Implementation Overview (Slides 13-15)

**Purpose:** Show the path from recommendation to results. Detailed plan in cp:plan.

**Slide 13: Implementation Roadmap (high level)**

Headline: "Implementation across [N] workstreams over [N months] — quick wins in first [N weeks]"

Content:
- Gantt-style timeline (phases, not tasks)
- Quick wins highlighted (first 90 days)
- Major milestones

**Slide 14: Expected Financial Impact**

Headline: "Full implementation recovers [$X-Y] in [N months], with breakeven in [N months]"

Content:
- Investment required (one-time + ongoing)
- Benefit build-up (monthly/quarterly)
- NPV or ROI (if appropriate)
- Sensitivity: conservative / base / optimistic scenarios

**Slide 15: Risks and Mitigations**

Headline: "Key risks are manageable with proactive mitigation"

Content:

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|-----------|
| [Risk 1] | High/Med/Low | High/Med/Low | [Specific action] |
| [Risk 2] | | | |
| [Risk 3] | | | |

---

## Section F: Next Steps (Slide 16)

**Purpose:** Define the decision needed and the immediate actions.

**Slide 16: Next Steps**

Headline: "Decision needed: [Specific decision the sponsor must make today]"

Content:
- Decision required: [What needs to be approved / decided]
- If approved, immediate actions:
  1. [Action 1] — Owner: [Name], by: [Date]
  2. [Action 2] — Owner: [Name], by: [Date]
  3. [Action 3] — Owner: [Name], by: [Date]
- Next touchpoint: [Steering committee date / follow-up meeting]

---

## Appendix (Optional)

Include detailed analyses that support findings but are too granular for the main deck:
- Full data tables
- Detailed interview synthesis
- Benchmarking detail
- Technical methodology
- Full risk register

---

## Storyline Review Checklist

| Check | Status |
|-------|--------|
| Recommendation stated in Slide 1 (not at the end) | Pass / Fail |
| Executive summary can stand alone | Pass / Fail |
| 3-5 arguments (not more) | Pass / Fail |
| Arguments are MECE | Pass / Fail |
| Each argument has ≥ 2 slides of evidence | Pass / Fail |
| Each slide has an "action headline" (not a descriptive title) | Pass / Fail |
| Each chart has a "so what" | Pass / Fail |
| Financial impact is quantified ($) | Pass / Fail |
| Alternatives were explicitly considered | Pass / Fail |
| Risks are acknowledged | Pass / Fail |
| Next steps include a specific decision ask | Pass / Fail |
| Total slide count ≤ 20 (excluding appendix) | Pass / Fail |
