# Impact Measurement Guide — Consulting Engagements

> Reference for cp:evaluate Activity 1. Covers measurement timing, attribution methodology, controlling for external factors, and constructing a credible impact narrative.

## Why Impact Measurement Is Hard

Three factors make consulting impact measurement genuinely difficult:

1. **Attribution:** Many things happen simultaneously. The market improves. The CEO changes. A competitor exits. Isolating the consulting engagement's contribution requires explicit methodology.

2. **Timing:** Operational changes take 3-6 months to stabilize. Financial impact may take 12-18 months to flow through the P&L. Measuring too early systematically underestimates impact.

3. **Baseline integrity:** The baseline must be the pre-implementation state, measured at the same time of year, with the same methodology, from the same data source. Baseline drift is the most common source of measurement error.

---

## Measurement Timing Guidelines

| Type of recommendation | Earliest valid measurement | Optimal measurement |
|-----------------------|--------------------------|---------------------|
| Operational process changes | 3 months post go-live | 6 months post go-live |
| Pricing / commercial changes | 2 months post implementation | 6 months (1 full cycle) |
| Organizational structure | 6 months post change | 12 months |
| P&L / financial impact | 6 months | 12 months (full fiscal year) |
| Cultural / behavior change | 6 months (survey) | 12-18 months |

**Rule:** Agree on measurement timing in cp:plan (before implementation begins). Do not renegotiate timing at close.

---

## Attribution Methodology

### Method 1: Direct attribution (best case)

When the change is isolated (only this workstream changed; all other variables stable), direct attribution is defensible:

```
Impact = [Post metric] − [Baseline metric]
Attribution = 100% to engagement (assuming no external factors)
```

**When it's valid:** Narrow scope engagements; stable market conditions; changes confined to a single business unit with no cross-effects.

### Method 2: Contribution analysis

Most common in practice. Identify all factors that contributed to observed improvement and estimate each factor's share:

```
Total observed improvement: $18M
  - Engagement (discount governance): $12M (67%)
  - Market volume growth: $4M (22%)
  - FX tailwind: $2M (11%)

Engagement-attributable impact: $12M (range: $10-14M)
```

**How to estimate each factor's contribution:**
- Market effect: use industry benchmarks or control group
- FX effect: standard currency adjustment
- Other initiatives: estimate from internal project teams

**Conservative bias:** When in doubt, attribute less to the engagement. Overattribution damages credibility more than underattribution.

### Method 3: Counterfactual comparison (most rigorous)

Compare the client's performance against a control group (comparable business unit, region, or competitor) that did NOT receive the intervention:

```
Observed improvement (treated): +6pp margin
Improvement in control group (untreated): +2pp (market improvement)
Net attributable improvement: 4pp (6pp − 2pp)
```

**When applicable:** Multi-location rollouts (compare pilot vs non-pilot stores); segmented implementations (treated vs untreated customer segments); clear natural control group exists.

**Limitation:** Control groups are rarely perfect; acknowledge comparability limitations.

---

## External Factor Analysis

Before presenting impact results, systematically identify external factors:

| External factor category | Examples | How to assess | How to adjust |
|------------------------|---------|--------------|--------------|
| **Market conditions** | Industry volume growth, price inflation, competitor exits | Industry data; peer company results | Subtract market-average improvement |
| **Macroeconomic** | Currency changes, commodity prices, interest rates | Macroeconomic data | Standard financial adjustment |
| **Seasonal patterns** | Year-end effect, holiday patterns | Historical seasonality analysis | Compare same period vs prior year |
| **Organizational** | Leadership changes, M&A, restructuring | Internal records | Qualitative assessment; flag as limitation |
| **Regulatory** | New regulations affecting the business | Regulatory calendar | Estimate regulatory effect separately |

**Presentation principle:** Show the gross improvement first, then decompose by factor. Never show only the net engagement-attributable number without showing how it was derived — it looks like cherry-picking.

---

## Constructing a Credible Impact Narrative

A credible impact narrative has four components:

### 1. Clear baseline

State the baseline clearly:
- Data source (same as recommendation phase — e.g., "Q4 FY2024 data from ERP system")
- Metric definition (identical to what was tracked in cp:structure)
- Time period (12 months pre-implementation)

### 2. Clear measurement

State the post-implementation measurement:
- Same data source as baseline
- Same metric definition
- Time period (same-length window post-implementation)
- Seasonal adjustment applied? If yes, state the method.

### 3. Decomposition

Show all factors, not just the favorable ones:
- Total gross improvement
- External factor adjustments (each one explicit)
- Engagement-attributable improvement (range, not point estimate)

### 4. Conservative estimate

Report a range, not a single number. The range communicates:
- Low end: conservative assumptions on attribution
- High end: favorable but defensible assumptions

```
Engagement-attributable improvement: $10M−$14M (base case: $12M)
Assumptions: [List the 3 key assumptions and which direction they push]
```

---

## What to Do When Impact Is Below Target

Under-delivery is a difficult conversation. Handle it with credibility, not defensiveness.

**Framework for under-delivery:**

1. **Quantify the gap:** "We projected $15M; we realized $10M — a $5M gap."

2. **Diagnose the gap:**

| Root cause | Proportion of gap | Response |
|-----------|------------------|---------|
| Recommendation assumption proved wrong | [%] | Acknowledge; explain what data changed |
| Implementation execution shortfall | [%] | Identify which workstream underperformed and why |
| External factor (unforeseeable) | [%] | Show the counterfactual: "without external headwind, impact would have been $13M" |
| Measurement timing (too early) | [%] | Provide trajectory data showing impact is still building |

3. **Residual opportunity:** If the gap is addressable, quantify what remains and recommend a path to capture it.

4. **Lessons learned:** Be specific about what the team would do differently. Vague "we would do better" is not credible.

**What not to do:**
- Redefine the metric so the numbers look better
- Omit the gap and present only what was achieved
- Blame the client entirely (even if partially true)
- Over-explain external factors to avoid ownership

---

## Impact Measurement Artifacts Checklist

Before presenting the impact assessment:

| Item | Complete |
|------|---------|
| Baseline data documented with source and date | |
| Post-implementation data documented with source and date | |
| Metric definitions identical between baseline and post | |
| Seasonal adjustment applied and documented | |
| External factors identified and quantified | |
| Attribution methodology stated explicitly | |
| Impact presented as range, not point estimate | |
| Workstream-level decomposition complete | |
| Sustainability assessment complete | |
| Lessons learned documented | |
| Client feedback collected | |
