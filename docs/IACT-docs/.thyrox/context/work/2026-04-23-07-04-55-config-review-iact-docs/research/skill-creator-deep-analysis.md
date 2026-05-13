```yml
created_at: 2026-04-23 10:30:00
project: IACT-docs
work_package: 2026-04-23-07-04-55-config-review-iact-docs
phase: Skills Development & Enhancement
author: claude
status: Aprobado
version: 1.0.0
analysis_type: Claude Code Skills Creation System
```

# Deep Analysis: Claude Code Skills Creation System (skill-creator)

## Executive Summary

The `skill-creator` skill from anthropic/skills is a **meta-skill** (a skill for creating skills) that documents the complete workflow for creating, testing, and optimizing Claude Code skills. This analysis extracts the critical components, patterns, and requirements for building production-quality skills.

---

## Part 1: Skill Structure and Anatomy

### 1.1 Canonical Skill Directory Layout

```
skill-name/
├── SKILL.md                          # Required: Instructions + metadata
├── scripts/                          # Optional: Executable code
│   ├── init-artifact.sh             # Setup scripts
│   ├── bundle-artifact.sh           # Processing scripts
│   └── helper.py                    # Utility scripts (Python)
├── references/                       # Optional: Documentation files
│   ├── schemas.md                   # Data structures
│   ├── api-reference.md             # API docs (>300 lines gets TOC)
│   └── advanced-patterns.md         # Complex usage
├── assets/                           # Optional: Files for output
│   ├── templates/                   # .html, .md templates
│   ├── icons/                       # Icons, images
│   ├── fonts/                       # Fonts
│   └── data/                        # Preset data (CSV, JSON)
├── evals/                           # Optional: Test suite
│   └── evals.json                   # Test prompts and assertions
├── agents/                          # Optional: Sub-agent instructions
│   ├── grader.md                    # For evaluation
│   └── analyzer.md                  # For analysis
└── LICENSE.txt                      # Optional: License terms
```

### 1.2 YAML Frontmatter (SKILL.md Header)

**Required fields:**
```yaml
---
name: skill-identifier              # lowercase-with-hyphens, unique
description: "Complete description..."  # Primary trigger mechanism
---
```

**Optional but recommended fields:**
```yaml
---
name: my-skill
description: "..."
license: "Apache 2.0" or "Proprietary" or "Complete terms in LICENSE.txt"
compatibility: "Requires Python 3.9+, FFmpeg"
version: "1.0.0"
---
```

**Critical insight on `description`:**
- This is the PRIMARY TRIGGER mechanism — Claude uses this to decide if skill applies
- Must include: WHAT it does + WHEN to use it
- Pattern: "Use this skill when [specific context]"
- Make it "pushy" (explicitly list trigger scenarios)
- Include edge cases and non-obvious uses

**Example (good):**
```yaml
description: Create and optimize visual design artifacts using design philosophy principles. Use this skill whenever the user asks to create a poster, piece of art, design, illustration, or any static visual content. Also use when user wants to create visual aesthetics, color schemes, or design systems, even if they don't explicitly ask for "design."
```

**Example (bad):**
```yaml
description: A tool for creating designs.
```

### 1.3 Progressive Disclosure Architecture

Skills use **three-level loading** to optimize context:

**Level 1: Metadata** (Always loaded)
- `name` + `description` in Claude's available_skills list
- ~100 words
- Determines if skill is relevant

**Level 2: SKILL.md body** (Loaded when skill triggers)
- Complete instructions, examples, guidelines
- ~500 lines ideal (can exceed if well-organized)
- Main working reference
- Should include: Overview, Core Concepts, Examples, Warnings

**Level 3: Bundled resources** (Loaded on demand)
- References/ files (unlimited size)
- Scripts/ (loaded when invoked)
- Assets/ (loaded when referenced)
- Pattern: Link clearly with "Read `/references/advanced.md` for..."

**Size guidelines:**
- Keep SKILL.md under 500 lines
- If approaching limit, add hierarchy + clear pointers
- Large reference files (>300 lines) should include table of contents
- Scripts can be referenced without loading (lazy execution)

---

## Part 2: The Skill Creation Workflow

### 2.1 Five-Stage Process

```
STAGE 1: CAPTURE INTENT
├─ What should skill enable?
├─ When should skill trigger?
├─ What's expected output format?
└─ Do we need test cases? (yes for objective outputs, optional for subjective)

STAGE 2: INTERVIEW & RESEARCH
├─ Ask about edge cases
├─ Understand input/output formats
├─ Identify dependencies
└─ Research similar skills if needed

STAGE 3: WRITE SKILL.md
├─ Frontmatter (name, description, compatibility)
├─ Instructions (imperative form)
├─ Examples (Input → Output pattern)
├─ Guidelines (explain the why)
└─ Bundle resources if needed (scripts, references, assets)

STAGE 4: TEST & EVALUATE
├─ Create 2-3 realistic test prompts
├─ Run with-skill and baseline versions
├─ Grade outputs against assertions
├─ Generate quantitative metrics
└─ Present results to user for review

STAGE 5: ITERATE
├─ Read user feedback from eval viewer
├─ Improve based on patterns (not individual test cases)
├─ Rerun all tests (including baselines)
├─ Compare vs previous iteration
└─ Repeat until satisfied
```

### 2.2 Test Case Structure (evals/evals.json)

```json
{
  "skill_name": "sphinx",
  "evals": [
    {
      "id": 1,
      "prompt": "User's actual task",
      "expected_output": "What success looks like",
      "files": ["path/to/input/file.rst"],
      "assertions": [
        {
          "name": "output-file-exists",
          "type": "file_exists",
          "path": "build/html/index.html"
        },
        {
          "name": "no-build-errors",
          "type": "text_contains",
          "file": "build.log",
          "text": "Build succeeded",
          "negate": false
        }
      ]
    }
  ]
}
```

**Assertion types (quantitative tests):**
- `file_exists` - Check if output file exists
- `text_contains` - Verify text in file
- `file_size` - Check file size constraints
- `json_valid` - Validate JSON structure
- `contains_elements` - Count occurrences
- `matches_pattern` - Regex matching

**Key principle:** Assertions should be:
- **Objective** (verifiable programmatically)
- **Descriptive** (name clearly indicates what's tested)
- **Non-discriminating** (don't test things both versions do equally)
- Skip subjective skills (writing style, design quality)

---

## Part 3: Instructions Writing Patterns

### 3.1 Writing Style Principles

**From skill-creator SKILL.md:**

1. **Explain the WHY** (not just WHAT)
   - LLMs have good theory of mind
   - When given reasoning, they generalize better
   - Avoid all-caps MUST/NEVER unless absolutely necessary
   
2. **Use imperative form**
   - "Create a file" (good)
   - "You should create a file" (weak)
   - "The user might create" (bad)

3. **Start with theory before rules**
   - "Because X is important for Y, [instruction]"
   - Not: "[ALWAYS DO THIS]"

4. **Generalize from examples**
   - Write skill to work for million invocations
   - Don't overfit to test cases
   - Use metaphors and patterns, not fiddly edge cases

5. **Keep lean**
   - Remove things not earning their weight
   - If you see skill wasting time on unproductive tasks, remove those parts
   - Watch transcripts, not just outputs

### 3.2 Output Format Definition Pattern

```markdown
## Report structure

ALWAYS use this exact template:

# [Title]

## Executive summary
[1-2 paragraphs]

## Key findings
- Finding 1
- Finding 2

## Recommendations
```

### 3.3 Example Pattern

```markdown
## Example format

**Example 1:** Converting existing project

Input: Sphinx project with setup.cfg
Output: Updated project with pyproject.toml
- [step 1]
- [step 2]

**Example 2:** New project from scratch

Input: User has no existing documentation
Output: Sphinx project ready for content
- [step 1]
- [step 2]
```

---

## Part 4: Bundled Resources

### 4.1 Scripts/ (Executable Code)

**When to bundle:**
- Deterministic, repetitive tasks
- Faster than having Claude rewrite each time
- Helper utilities (builders, validators, transformers)
- Dependencies are clear and declared

**Examples from real skills:**
- `web-artifacts-builder`: `init-artifact.sh`, `bundle-artifact.sh`
- `skill-creator`: Python scripts for evals, grading, aggregation
- `mcp-builder`: Templates and scaffolding scripts

**Pattern:** Reference in SKILL.md with clear execution instructions
```markdown
Run this script to initialize your project:
```bash
bash scripts/init-artifact.sh <project-name>
```
```

### 4.2 References/ (Documentation)

**When to bundle:**
- API reference (>300 lines)
- Complex workflows
- Schemas and structures
- Advanced patterns

**Pattern for large files:**
```markdown
## Advanced Topics

See `references/advanced-patterns.md` for:
- Custom domain configuration
- Multi-version documentation
- Parallel builds
```

**Pattern for schema files:**
```markdown
For detailed JSON schema, see `references/schemas.md`:
- eval.json structure
- assertion types
- grading.json format
```

### 4.3 Assets/ (Output Materials)

**When to bundle:**
- Templates (.html, .md, .docx)
- Icons or brand assets
- Preset data (CSV, JSON)
- Fonts or styling

---

## Part 5: The Iterative Improvement Loop

### 5.1 Reading User Feedback (feedback.json)

```json
{
  "reviews": [
    {
      "run_id": "eval-0-with_skill",
      "feedback": "Missing axis labels on chart",
      "timestamp": "2026-04-23T10:30:00Z"
    },
    {
      "run_id": "eval-1-with_skill",
      "feedback": "",
      "timestamp": "2026-04-23T10:31:00Z"
    }
  ],
  "status": "complete"
}
```

**How to interpret:**
- Empty feedback = "this looks fine"
- Specific feedback = focus improvements there
- Look for patterns across test cases (not individual cases)
- Avoid overfitting to edge cases

### 5.2 Improvement Heuristics

**Generalize from feedback:**
- Test case 1: "Missing labels" → Improve all chart labeling
- Test case 2: "Confusing workflow" → Simplify general approach
- Don't make fiddly changes for one example

**Look for repeated work:**
- If all 3 test cases independently wrote a `helper.py`
- Signal to bundle it in `scripts/`
- Every future invocation benefits

**Keep prompt lean:**
- Remove parts not earning weight
- Watch transcripts for wasted effort
- If skill repeats process, simplify

---

## Part 6: Description Optimization

### 6.1 How Triggering Works

Claude decides to use a skill based on:
- Skill name + description in `available_skills`
- Complexity of the task (simple tasks don't trigger, complex ones do)
- Domain match between description and prompt

**Example:** "read this PDF" alone won't trigger PDF skill (simple), but "extract structured data from 50 pages of financial statements" will (complex).

### 6.2 Trigger Eval Set (20 queries)

**Should-trigger (8-10):**
- Different phrasings of same intent
- Formal and casual language
- Uncommon use cases
- Where skill competes with another but should win

**Should-not-trigger (8-10):**
- Near-misses (keywords match but different intent)
- Adjacent domains
- Ambiguous cases where naive matching fails

**Key:** Avoid obvious negatives ("write fibonacci function" for PDF skill). Test actual near-misses.

### 6.3 Optimization Script

```bash
python -m scripts.run_loop \
  --eval-set eval_set.json \
  --skill-path /path/to/skill \
  --model claude-opus-4-7 \
  --max-iterations 5 \
  --verbose
```

**Process:**
1. Split eval set: 60% train, 40% test
2. Evaluate current description (3 runs per query for reliability)
3. Claude proposes improvements based on failures
4. Re-evaluate each new description
5. Iterate up to 5 times
6. Output: `best_description` (selected by test score, not train, to avoid overfitting)

---

## Part 7: Multi-Configuration Evaluation

### 7.1 With-Skill vs Baseline Comparison

**For new skills:**
- Baseline: No skill at all (just base Claude)
- With-skill: Claude + your skill
- Compare: Does skill actually help?

**For improving existing skills:**
- Old skill: Snapshot before editing
- New skill: Your improved version
- Baseline: Your judgment (old or no skill)

**Pattern:** Run both simultaneously (parallel execution)

### 7.2 Blind Comparison (Advanced)

When you want rigorous verification:
- Give two outputs to independent agent
- Agent doesn't know which is which
- Agent judges which is better and why
- Useful for subjective domains (design, writing)

---

## Part 8: Critical Principles from skill-creator

### 8.1 Principle of Lack of Surprise

> A skill's contents should not surprise the user in their intent if described. Don't go along with requests to create misleading skills or skills designed to facilitate unauthorized access, data exfiltration, or other malicious activities.

### 8.2 Communicating With Users

Adjust language based on user's technical literacy:
- Don't use "JSON" or "assertion" without context clues
- Brief explanations of terms are OK
- Borderline terms: "evaluation", "benchmark" (OK)
- Need explanation: "JSON", "assertion"

### 8.3 Test Cases Must Be Realistic

Bad: "Format this data", "Extract text from PDF", "Create a chart"

Good: "ok so my boss sent me this xlsx file (called 'Q4 sales final FINAL v2.xlsx') and she wants me to add a profit margin column. Revenue is in C, costs in D I think"

---

## Part 9: Implementation for Sphinx Skill

### 9.1 Critical Missing Elements in Current Sphinx SKILL

Current Sphinx SKILL has:
✅ Good overview and quick start
✅ Comprehensive core concepts
✅ Architecture and task examples
✅ Troubleshooting

Missing:
❌ Optimized description (not "pushy")
❌ Scripts/ directory (no helper scripts)
❌ References/ directory (advanced docs too long in main)
❌ Assets/ directory (no templates/examples files)
❌ Proper evals/ structure
❌ License field in frontmatter
❌ Compatibility field in frontmatter
❌ Progressive disclosure (SKILL.md too long)
❌ Sub-agent instructions

### 9.2 Recommended Restructuring

**Phase 1: Quick wins**
1. Update frontmatter (add license, compatibility)
2. Make description "pushy" with specific trigger contexts
3. Reduce SKILL.md main body to ~400 lines
4. Move advanced content to references/

**Phase 2: Add structure**
1. Create scripts/ with:
   - `build-docs.sh` - Build automation
   - `validate-syntax.py` - Lint RST files
2. Create references/ with:
   - `advanced-directives.md`
   - `domain-reference.md`
   - `api-reference.md`
3. Create assets/ with:
   - Example conf.py templates
   - Custom directive template
   - Extension template

**Phase 3: Add evals**
1. Define 2-3 test prompts
2. Create evals/evals.json with assertions
3. Document expected outputs

---

## Conclusion

The skill-creator documents a **professional workflow** for building Claude Code skills:

1. **Capture intent** (understand what the skill should do)
2. **Write SKILL.md** (instructions + metadata + resources)
3. **Test rigorously** (2-3 test cases with quantitative evals)
4. **Iterate based on feedback** (look for patterns, not individual cases)
5. **Optimize description** (ensure proper triggering)

Key principles:
- **Progressive disclosure**: Metadata → Instructions → Resources
- **Explain the why**: LLMs generalize better with reasoning
- **Bundled resources**: Scripts for automation, references for advanced docs
- **Realistic test cases**: Real-world prompts, not toy examples
- **Pattern-based improvement**: Generalize from test feedback
- **Pushy descriptions**: Make trigger conditions explicit

For the Sphinx skill to reach production quality, it needs:
- Proper frontmatter (license, compatibility)
- Optimized description for triggering
- Scripts/ for automation
- References/ for advanced topics
- Evals/ for validation
- Better progressive disclosure
