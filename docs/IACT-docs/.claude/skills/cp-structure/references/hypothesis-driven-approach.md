# Hypothesis-Driven Approach — Reference Guide

> Reference for cp:structure Activities 1-3. Complete guide to the hypothesis-driven consulting approach.

## What Is the Hypothesis-Driven Approach?

The hypothesis-driven approach is the core productivity principle of McKinsey-style consulting. Instead of analyzing all available data before forming a view, the team states a provisional answer (the hypothesis) and then gathers targeted evidence to confirm or kill it.

**Traditional analytical approach:**
```
Gather data → Analyze data → Draw conclusions → Form recommendation
```

**Hypothesis-driven approach:**
```
Form hypothesis → Design targeted analysis → Gather specific data → Confirm or kill → Update hypothesis
```

The hypothesis-driven approach is 3-5x faster because it focuses analytical effort on the questions that matter most, rather than conducting exhaustive analysis across all possible dimensions.

---

## Forming Good Hypotheses

### The anatomy of a consulting hypothesis

A good hypothesis has five components:

1. **Claim:** A specific, falsifiable statement about the world
2. **Reasoning:** Why you believe the claim (initial evidence or logic)
3. **Observable prediction:** What you would expect to see in the data if the claim is true
4. **Kill condition:** What data would prove the claim false
5. **Confidence level:** How strongly you believe the claim at this stage (Low / Medium / High)

**Template:**

```
We believe [CLAIM] because [REASONING].
If true, we would expect to see [OBSERVABLE PREDICTION].
This hypothesis would be killed if [KILL CONDITION].
Current confidence: [Low / Medium / High]
```

**Example:**

```
We believe the margin decline is primarily driven by pricing erosion in the SMB segment 
because preliminary interview data shows sales managers report "significant pressure to 
discount to close deals" and Q3 data shows SMB gross margin at 22% vs 35% for enterprise.

If true, we would expect to see:
- Average discount rate in SMB > 15% (vs 10% policy)
- Revenue per unit declining while volume is stable
- Margin gap between high-discount and low-discount reps > 10pp

This hypothesis would be killed if:
- Discount analysis shows rates within 12% (within policy tolerance)
- Volume decline in SMB > 15% (volume, not pricing, is the driver)
- COGS per unit increased > 10% (cost, not revenue, is the driver)

Current confidence: Medium (supported by qualitative interviews; quantitative validation pending)
```

---

## Hypothesis Prioritization

### The Impact-Probability Matrix

Prioritize hypotheses based on two dimensions:

| | High probability of being true | Low probability of being true |
|--|------------------------------|------------------------------|
| **High business impact if true** | **P1 — Analyze first** | **P2 — Analyze if P1 inconclusive** |
| **Low business impact if true** | **P3 — Analyze if time allows** | **P4 — Park** |

**How to estimate impact:**
- High: If true, changes the recommendation materially (e.g., $10M+ in value at stake)
- Medium: If true, adds nuance to the recommendation but doesn't change the core answer
- Low: If true, is interesting but doesn't affect the recommendation

**How to estimate probability:**
- High: Multiple sources of initial evidence (interviews + some data) point in this direction
- Medium: Some evidence, but could also be explained by alternative hypotheses
- Low: No strong initial evidence; included for completeness (CE test on the Issue Tree)

---

## Designing Analyses Before Gathering Data

This is the discipline that separates hypothesis-driven analysis from data exploration.

**Rule:** Before requesting a single row of data, write down:
1. The exact metric you will calculate
2. The calculation method
3. The threshold that confirms or kills the hypothesis
4. The visualization you will use to communicate the finding

**Example — Discount Analysis:**

```
Metric: Average discount rate = (List Price − Net Revenue) / List Price
Calculation: Per transaction in CRM; group by customer segment, rep, quarter
Confirmation threshold: Average discount rate SMB > 15% → H1 confirmed
Kill threshold: Average discount rate SMB < 12% → H1 killed (within policy tolerance)
Visualization: Bar chart — average discount by segment; line showing policy threshold
```

**Why this discipline matters:**

Without pre-defined thresholds, analysts fall into the trap of interpreting data to fit their prior beliefs. A 14.5% discount rate is above 12% and below 15% — which conclusion you draw depends on whether you pre-defined the threshold.

---

## Killing a Hypothesis Gracefully

A hypothesis that gets killed is not a failure — it is a valuable finding that narrows the problem space. The team that kills H3 ("cost is not the driver") and confirms H1 ("pricing is the driver") has made progress even though H3 was wrong.

**How to document a killed hypothesis:**

```
H3: Cost structure is the primary margin driver
Status: KILLED
Kill evidence: COGS per unit stable at 41% of revenue (±0.5pp) over 3 years; 
               benchmarking shows cost structure in line with industry peers (±2pp)
Implication: Cost is not the primary driver. Focus shifts entirely to revenue diagnosis.
Date killed: [Date]
```

**Common mistakes when killing a hypothesis:**

| Mistake | Consequence | Prevention |
|---------|------------|-----------|
| Softening the kill ("cost may still be a minor factor") | Team continues analyzing a dead hypothesis; wastes time | Declare the hypothesis killed definitively; document the kill evidence |
| Not updating stakeholders when a hypothesis is killed | Client or engagement lead still believes a dead hypothesis | Include killed hypotheses in the mid-engagement update |
| Killing a hypothesis prematurely | May miss a cost driver that's hidden in a specific category | Define the kill threshold before gathering data; don't adjust it after |

---

## The Ghost Deck — Hypothesis to Deck

At the start of cp:structure, experienced consultants build a "ghost deck" — an outline of what the final deck will look like if all hypotheses are confirmed.

**Ghost deck format:**

```
[Slide 1] Executive Summary
  → Answer: [Current best guess at recommendation]
  → Arg 1: [If H1 confirmed: "Pricing is the primary driver"]
  → Arg 2: [If H2 confirmed: "Mix shift compounds the problem"]
  → Arg 3: [If analysis confirms: "Governance is feasible"]

[Slide 2-3] Context — Situation and Complication
[Slide 4-5] Finding 1: Pricing analysis → expected chart type
[Slide 6-7] Finding 2: Mix analysis → expected chart type
[Slide 8-9] Finding 3: Feasibility → expected chart type
[Slide 10] Recommendation
[Slide 11] Implementation overview
[Slide 12] Financials
```

The ghost deck is not a draft — it is a planning tool. As hypotheses are confirmed or killed, the ghost deck evolves into the actual recommendation deck (cp:recommend).

---

## Hypothesis Update Log

Track hypothesis status throughout the engagement:

| Hypothesis | Initial confidence | Week 1 status | Week 2 status | Final status |
|-----------|-------------------|--------------|--------------|-------------|
| H1: Pricing driver | Medium | Supported by interview data | Confirmed: avg discount 22% in SMB | CONFIRMED |
| H2: Mix shift | Low | No initial data | Partially confirmed: $3M in mix | PARTIALLY CONFIRMED |
| H3: Cost driver | Medium | Initial data shows stable COGS | KILLED: COGS% stable ±0.5pp | KILLED |
