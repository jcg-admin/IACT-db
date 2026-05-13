# MECE Guide — Mutually Exclusive, Collectively Exhaustive

> Reference for cp:diagnosis Activity 1. Complete guide to MECE decomposition for consulting problem structuring.

## The Fundamental MECE Tests

### Mutually Exclusive (ME) Test

**Question:** Can any item from one branch also legitimately belong to another branch?

If yes → the branches overlap → the decomposition fails ME.

**How to test:**
1. Take any specific example from your data
2. Ask: does it fall clearly into exactly one branch?
3. If it could fall into two or more branches → not ME

**Example:**

```
Revenue problem decomposition:
Branch A: B2B Revenue
Branch B: Enterprise Revenue

Test: An enterprise B2B client → falls into BOTH A and B → NOT mutually exclusive
Fix: Split by customer segment size (SMB / Mid-market / Enterprise) OR by channel (Direct / Partner / Online)
```

### Collectively Exhaustive (CE) Test

**Question:** If you combined all the branches together, would they account for 100% of the problem space?

If any scenario is not covered → the branches have gaps → the decomposition fails CE.

**How to test:**
1. Think of 10 random specific examples from your data
2. Ask: does each one clearly fall into one of the branches?
3. If any example doesn't fit any branch → not CE

**Example:**

```
Customer segmentation:
Branch A: Large customers (> $1M revenue)
Branch B: Medium customers ($100K–$1M revenue)

Test: A customer with $50K revenue → doesn't fit any branch → NOT collectively exhaustive
Fix: Add Branch C: Small customers (< $100K revenue)
```

---

## Standard MECE Splits by Problem Type

### Revenue Problems

**Split by revenue formula:**
```
Revenue
├── Volume (units sold)
│   ├── Number of customers
│   └── Purchase frequency per customer
└── Price (revenue per unit)
    ├── List price
    └── Discount rate
```

**Split by customer:**
```
Revenue
├── Existing customers (retention and expansion)
└── New customers (acquisition)
```

**Split by product/geography:**
```
Revenue
├── Product line A
├── Product line B
└── Product line C
```

_Note: Customer / Product / Geography are three separate valid Level 1 splits — using more than one at the same level breaks ME (a customer in Region A with Product B appears in multiple branches)._

### Cost Problems

**Split by cost structure:**
```
Total Cost
├── Fixed costs (don't vary with volume)
│   ├── Overhead / G&A
│   ├── Depreciation
│   └── Lease / facility
└── Variable costs (vary with volume)
    ├── Direct materials (COGS)
    ├── Direct labor
    └── Variable logistics
```

**Split by controllability:**
```
Total Cost
├── Controllable by management
│   ├── Headcount
│   ├── Discretionary spend
│   └── Procurement terms
└── Non-controllable in short term
    ├── Long-term contracts
    ├── Regulatory requirements
    └── Infrastructure commitments
```

### Profitability Problems

**Profit formula decomposition:**
```
Profit = Revenue − Cost
├── Revenue issue?
│   ├── Volume (units)
│   └── Price (per unit)
└── Cost issue?
    ├── Fixed cost increase?
    └── Variable cost per unit increase?
```

_This is the most common first-level split for profitability diagnostics. It is MECE because: Revenue − Cost = Profit (mathematical identity)._

### Market Entry Problems

```
Market Entry Decision
├── Market attractiveness
│   ├── Market size and growth
│   ├── Competitive intensity
│   └── Structural profitability (Porter's Five Forces)
└── Our ability to compete
    ├── Capabilities match
    ├── Cost position
    └── Strategic fit
```

### Operational Problems

```
Process Performance Problem
├── Capacity constraint (can't do more)
│   ├── People capacity
│   ├── Equipment / system capacity
│   └── Physical space
└── Quality / yield problem (doing it wrong)
    ├── Input quality
    ├── Process variation
    └── Definition of quality standard
```

---

## Anti-Patterns — Common MECE Failures

### The "Other" bucket

```
❌ Revenue problem can be: pricing, volume, mix, or OTHER
```

"Other" = the CE test failed. If "other" is necessary, the first three categories don't cover everything. Fix: identify what's in "other" and add proper branches.

### The org chart decomposition

```
❌ Revenue problem
├── Sales team problem
├── Marketing team problem
└── Product team problem
```

This reflects the company org chart, not the economics of revenue. It breaks ME because Sales, Marketing, and Product all affect revenue through overlapping mechanisms. Fix: decompose by the economics (volume × price) and then map which team is responsible.

### Overlapping dimensions

```
❌ Customer segments
├── US customers
├── International customers
└── Enterprise customers
```

Enterprise customers can be in US or International → ME fails. Fix: choose one dimension (geography OR size, not both at Level 1).

### Solutions masquerading as issue branches

```
❌ How to grow revenue
├── Launch new products
├── Expand to new markets
└── Improve sales effectiveness
```

These are solutions (what to do), not issues (what is wrong). An Issue Tree diagnoses the problem; solutions come in cp:recommend. Fix: frame branches as problem areas ("revenue underperformance by segment") not as actions.

---

## MECE by Problem Complexity

| Problem type | Recommended split | Depth |
|-------------|------------------|-------|
| Simple profitability | Revenue / Cost | 3 levels |
| Growth strategy | Internal capability / External market | 3-4 levels |
| Operational efficiency | Effectiveness / Efficiency / Capacity | 3-4 levels |
| Organization design | Structure / Process / People / Culture | 3 levels |
| M&A target assessment | Strategic fit / Financial attractiveness / Integration risk | 3-4 levels |

---

## MECE in Practice — Worked Example

**Problem:** *"E-commerce conversion rate is declining."*

**Step 1 — First split (MECE):**
```
Conversion Rate = f(Traffic × Conversion Rate by Visitor)
├── Traffic problem (fewer relevant visitors)
└── Conversion problem (same visitors, fewer buying)
```
ME test: A visitor is either counted in traffic or conversion — not both. ✅
CE test: All scenarios are either a traffic issue or a conversion issue. ✅

**Step 2 — Decompose Traffic:**
```
Traffic
├── Organic (SEO, direct)
├── Paid (SEM, social ads)
└── Referral (partners, affiliates)
```
ME test: Traffic sources are distinct (same visitor can only arrive once per session via one source). ✅
CE test: All digital traffic sources covered. ✅

**Step 3 — Decompose Conversion:**
```
Conversion
├── Product page performance (do visitors engage?)
│   ├── Page load speed
│   └── Content quality / relevance
├── Purchase funnel completion (do engaged visitors buy?)
│   ├── Cart abandonment rate
│   └── Checkout friction
└── Pricing relative to alternatives
```
ME test: Page performance, funnel completion, and pricing are distinct causal factors. ✅
CE test: All major conversion drivers are represented. ✅

**Result:** A 3-level MECE Issue Tree with 7 leaf nodes, each answerable with analytics data.
