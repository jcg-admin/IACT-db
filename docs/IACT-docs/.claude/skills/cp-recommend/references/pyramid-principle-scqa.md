# Pyramid Principle and SCQA — Reference Guide

> Reference for cp:recommend Activities 1-4. Complete guide to the Pyramid Principle, SCQA framework, slide headline writing, and common structural failure modes.

## The Pyramid Principle — Origin and Core Idea

The Pyramid Principle was developed by Barbara Minto at McKinsey & Company in the 1970s and published in *The Pyramid Principle: Logic in Writing and Thinking* (1987). It is now used across virtually all major consulting firms as the standard for structuring recommendations and presentations.

**Core idea:** Humans process top-down better than bottom-up. State the conclusion first, then provide the supporting arguments, then the evidence. The pyramid shape represents this hierarchy.

```
                        ┌─────────────┐
                        │   ANSWER    │  ← State first
                        └──────┬──────┘
              ┌────────────────┼────────────────┐
         ┌────┴────┐      ┌────┴────┐      ┌────┴────┐
         │  Arg 1  │      │  Arg 2  │      │  Arg 3  │  ← Then arguments
         └────┬────┘      └────┬────┘      └────┬────┘
          ┌───┴───┐        ┌───┴───┐        ┌───┴───┐
         E1      E2       E3      E4       E5      E6    ← Then evidence
```

---

## Vertical Logic — The "So What" Test

Vertical logic means each level of the pyramid must directly support the level above it.

**The "So What" test:** Read an evidence statement, then ask "so what?" — the answer should be the argument it supports.

**The "Why?" test:** Read an argument, then ask "why?" — the answer should be in the evidence below.

**Example:**

```
Answer: "RetailCo should implement discount governance"

Ask "Why?" →

Arg 1: "Unmanaged discounting is costing $18M annually"

Ask "Why?" →

Evidence 1a: Discount waterfall shows average SMB discount 22% vs 10% policy
Evidence 1b: Revenue per unit declining 8% YoY in SMB while volume is flat
Evidence 1c: High-discount reps produce 40% lower gross margin than low-discount reps
```

Each evidence item answers "why is this argument true?" directly and specifically.

**Vertical logic failure modes:**

| Failure | Example | Fix |
|---------|---------|-----|
| Evidence doesn't directly support argument | Arg: "Pricing is the issue." Evidence: "The market is competitive." | Market competitiveness doesn't prove pricing is the issue — replace with discount analysis |
| Argument doesn't directly support answer | Answer: "Implement governance." Arg: "The market is growing 12%." | Market growth doesn't support the governance recommendation — replace with governance impact evidence |
| Circular reasoning | Arg: "We should implement governance." Evidence: "Governance would help." | Evidence must be data, not a restatement of the argument |

---

## Horizontal Logic — MECE Arguments

Arguments at the same level must be MECE (Mutually Exclusive, Collectively Exhaustive).

**ME test for arguments:** Does any argument make the same point as another?

**CE test for arguments:** Do the arguments together completely answer "why should you follow this recommendation?"

**Common argument structures:**

### Structure 1: Diagnosis → Solution → Feasibility (most common)

```
Answer: Implement discount governance

Arg 1: The problem is real and large (diagnosis confirmed — $18M at stake)
Arg 2: Discount governance is the highest-impact solution (alternatives assessed)
Arg 3: Implementation is feasible within current systems and budget (feasibility confirmed)
```

MECE check: Each argument answers a different dimension of "why." Together, they cover "what's wrong, what to do about it, and whether we can." No overlap.

### Structure 2: Multiple independent drivers (for multi-causal problems)

```
Answer: RetailCo should pursue a three-lever margin recovery program

Arg 1: Pricing governance recovers $12-15M (lever 1)
Arg 2: Mix optimization adds $4-6M (lever 2)
Arg 3: Procurement renegotiation adds $3-4M (lever 3)
```

MECE check: Three distinct value levers, no overlap. Together, they sum to the total opportunity.

### Structure 3: Situation → Consequences → Recommendation (for risk-framing)

```
Answer: RetailCo must act within 90 days or risk losing the SMB segment

Arg 1: Pricing erosion is accelerating (trajectory getting worse)
Arg 2: Competitors are taking share in SMB (external pressure compounding)
Arg 3: Internal capability to implement governance is available now (window closing)
```

MECE check: Each argument creates urgency from a different angle (internal trend, external pressure, timing). Together, they build a compelling case for action now.

---

## SCQA — Detailed Guide

### Situation — establishing common ground

The Situation is the factual starting point — things the audience already knows and agrees with. It provides context but creates no tension.

**Rules for the Situation:**
- Only include facts the audience agrees with — don't introduce contested claims
- Keep it short: 2-3 sentences maximum
- Set up the Complication: the Situation should make the Complication feel natural

**Common Situation structures:**

| Type | Example |
|------|---------|
| Historical performance | "RetailCo has delivered 8% operating margin for six years, consistently above the 5.5% industry average." |
| Market position | "Acme Corp is the #2 player in the B2B SaaS security market with $120M ARR and 18% market share." |
| Strategic context | "Following the 2024 acquisition, MegaCo is integrating three separate business units with distinct P&L structures." |

### Complication — the tension

The Complication introduces the change, problem, or risk that makes the engagement necessary. It creates the tension that demands a response.

**Rules for the Complication:**
- Must be specific and quantified — vague complications feel like background
- Should be a change from the Situation or a gap between current and desired state
- Must create a natural Question in the audience's mind

**Common Complication structures:**

| Type | Example |
|------|---------|
| Trend reversal | "Over the past three years, margin has declined to 4%, driven primarily by unmanaged discounting in SMB — a trend that is accelerating." |
| External shock | "Entry of a low-cost competitor in Q1 2025 has compressed industry pricing by 15%, threatening RetailCo's cost advantage." |
| Gap vs target | "Despite a strategic goal of $200M ARR by 2026, the business is tracking to $140M — a $60M gap that requires structural changes to close." |

### Question — the audience's natural response

The Question is usually implicit — it is the natural thought in the audience's mind after hearing the Situation and Complication. Sometimes it is stated explicitly; usually it is not.

**Explicit:** "So, what should RetailCo do to restore margin?"
**Implicit:** [The audience is already asking this; you don't need to say it]

**When to state the Question explicitly:**
- When the problem space is ambiguous and you want to confirm scope
- When the audience might interpret the Complication differently (and therefore ask a different question)
- In written documents where you can't read the room

### Answer — the recommendation

The Answer is your response to the Question. It must be:
- **Direct:** State the recommendation, not the direction of thinking
- **Specific:** Include the key decision, lever, or action
- **Quantified:** Include the expected impact where possible

**Weak Answer:** "RetailCo should investigate pricing strategies."
**Strong Answer:** "RetailCo should implement a structured discount governance program in SMB, which we estimate will recover $12-15M in annual margin within 12 months."

---

## Slide Headlines — The Action Headline

Every slide in a consulting deck should have an "action headline" — a headline that states the finding or conclusion, not a description of the topic.

**Descriptive title (avoid):** "Discount Analysis"
**Action headline (use):** "SMB discounts average 22% — twice the stated 10% policy — costing $18M annually"

**Rules for action headlines:**
1. One complete sentence with a verb
2. States the finding, not the subject
3. Contains the "so what" — the implication is clear from the headline alone
4. Uses specific numbers wherever possible

**Test:** Cover the chart/content of the slide. Does the headline tell you everything you need to know? If yes → good action headline.

---

## Common Structural Failure Modes

### The "data dump" deck

Every slide shows a chart with no action headline. The audience has to interpret the data themselves.

Fix: Add action headline to every slide. If you can't write an action headline, the chart doesn't belong in the deck — it goes to the appendix.

### The "academic conclusion"

Data → analysis → conclusion. The recommendation appears on slide 22.

Fix: Pyramid Principle inversion — answer on slide 1, evidence follows.

### The "three everything" deck

Three sections, each with three sub-sections, each with three bullets. Artificial symmetry imposes MECE where none exists.

Fix: Arguments should be MECE because the logic is MECE, not because you forced three of everything.

### The "20 supporting arguments" deck

Instead of 3-5 key arguments, the deck has 12 separate findings, all at the same level.

Fix: Cluster findings into 3-5 argument groups. The smaller findings become evidence within each group.

### The "risk-free" deck

Risks section is missing or contains only trivial risks.

Fix: A recommendation with no risks is not credible. Acknowledge 3-5 real risks with specific mitigations.
