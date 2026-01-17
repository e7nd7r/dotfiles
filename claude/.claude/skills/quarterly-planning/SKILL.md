---
name: quarterly-planning
description: Start a quarterly planning session. Use when the user wants to plan work for an upcoming quarter, review previous quarter, or set priorities.
argument-hint: <quarter> [year] [focus-areas]
---

# Quarterly Planning Skill

Start quarterly planning for: **$ARGUMENTS**

Examples:
- `Q1` - Plan Q1 of current year
- `Q1 2026` - Plan Q1 2026
- `Q2 2026 focus:api,frontend` - Plan Q2 with focus on specific boards

## Overview

Quarterly planning occurs at the start of each quarter to:
- Review and close out the previous quarter
- Set priorities aligned with business goals
- Plan work for the upcoming quarter

## Prerequisites

- Access to all Trello boards
- Previous quarter's OKRs and business goals
- Velocity data from previous quarters

---

## Phase 1: Previous Quarter Review

### 1.1 Verify Card Status

Review all boards and ensure cards accurately reflect their status:

```
For each board:
1. Get all epics, features, tasks in Done list
   - Verify due_complete is set
   - Verify dates match actual completion (from git commits)

2. Get all in-progress items
   - Update status if work stalled
   - Move to appropriate list (Done, Backlog, or close)

3. Review Bugs inbox
   - Close resolved bugs
   - Prioritize remaining bugs

4. Review Chores inbox
   - Complete or schedule remaining chores
```

### 1.2 Update Epic Status

For each epic:

```bash
# Get epic tree to see all children
get_card_tree(epic_id)

# Verify:
- All completed features/tasks marked as done
- Epic description updated with final status
- Dates reflect actual start/completion
```

### 1.3 Generate Quarter Summary

Create a summary of completed work:

| Metric | Count |
|--------|-------|
| Epics completed | X |
| Features completed | X |
| Tasks completed | X |
| Bugs fixed | X |
| Chores done | X |

---

## Phase 2: Define Priorities

### 2.1 Review Business Goals

Gather input from:
- Company OKRs (Objectives and Key Results)
- Product roadmap
- Customer feedback
- Technical debt assessment
- Security/compliance requirements

### 2.2 Prioritization Framework

Rank initiatives using:

| Priority | Criteria |
|----------|----------|
| P0 - Critical | Blocking revenue, security issue, major bug |
| P1 - High | Key OKR, customer commitment, foundation work |
| P2 - Medium | Important improvement, tech debt reduction |
| P3 - Low | Nice to have, exploratory, polish |

### 2.3 Document Quarter Objectives

Update the quarterly plan card with:

```markdown
## Q[N] Objectives

### Business Goals
1. [Goal 1] - measurable outcome
2. [Goal 2] - measurable outcome

### Technical Goals
1. [Goal 1] - measurable outcome
2. [Goal 2] - measurable outcome

### Success Metrics
- KPI 1: target value
- KPI 2: target value
```

---

## Phase 3: Backlog Review

### 3.1 Review Existing Backlog

For each board's `[BUCKET] Backlog`:

```
1. Get backlog tree
2. For each item:
   - Is it still relevant? -> Keep or archive
   - Is it ready for design? -> Move to design-pending
   - Is design approved? -> Ready to schedule
```

### 3.2 Generate New Ideas

Based on priorities, brainstorm:
- New features aligned with OKRs
- Technical improvements
- Developer experience enhancements
- Documentation needs

```bash
# Browse completed features for inspiration
search_cards(board_id, type="feature", filter_status="completed")

# See what features are in progress across boards
search_cards(board_id, type="feature", filter_status="in-progress")
```

### 3.3 Add to Backlog

New ideas go to backlog with status tracking:

```markdown
---
type: backlog
parent: <backlog-bucket-id>
status: pending
---

## Idea
Brief description

## Context
Why this is valuable

## Notes
Additional considerations
```

---

## Phase 4: Create Work Items

### 4.1 Determine Scope

For each prioritized item, decide:

| Scope | Card Type | Criteria |
|-------|-----------|----------|
| Multi-feature | Epic | Work requires 2+ features to complete |
| Single feature | Standalone Feature | Single deliverable with multiple tasks |
| Small | Task/Chore | Single focused change |

**Key distinction:** Use an Epic when the work cannot be delivered as a single feature - it requires multiple distinct features working together.

### 4.2 Create Design Cards (if needed)

For complex work, create design first:

```
[DESIGN] DES-XXX: Design Name
```

Design goes through: Draft -> In Review -> Approved

### 4.3 Create Epics

For large initiatives:

```
[EPIC-XXX] Epic Name
    |
    +-- [DESIGN] DES-XXX: Technical Design
    +-- [EPICXXX-F1] Feature 1
    +-- [EPICXXX-F2] Feature 2
    +-- [EPICXXX-F3] Feature 3
```

### 4.4 Create Standalone Features

For medium work without epic:

```
[FEAT] FEAT-NNN: Feature Name
    |
    +-- [FEAT-NNN-01] Task 1
    +-- [FEAT-NNN-02] Task 2
    +-- [FEAT-NNN-03] Task 3
```

---

## Phase 5: Estimate and Schedule

### 5.1 Gather Historical Data

Use git history and closed cards to estimate:

```bash
# Find similar completed features
search_cards(board_id, query="similar feature", filter_status="completed")

# Filter by type for more specific results
search_cards(board_id, query="authentication", type="feature", filter_status="completed")
search_cards(board_id, type="epic", filter_status="completed")  # All completed epics

# Check commit history for duration
git log --oneline --format="%ad %s" --date=short -- "relevant/path"

# Look at card dates
get_card_by_id(similar_card_id)  # Check start -> due dates
```

### 5.2 Estimate by Comparison

Find previously closed features/epics with similar magnitude:

| New Work | Similar Completed Work | Duration |
|----------|------------------------|----------|
| Auth system | EPIC-002 Color Palette Panel | ~3 days |
| New API endpoint | EPIC001-F5 | ~1 day |
| UI component | FEAT-001-03 | ~2 hours |

**Process:**
1. Identify similar completed work (same complexity, scope)
2. Check actual duration from start to due dates
3. Review commit frequency during that period
4. Adjust for any known differences (new tech, dependencies)

### 5.3 Set Dates

Based on historical comparison:

```
Start date = Previous item end date (or quarter start)
Duration = Similar feature duration (adjusted for differences)
End date = Start date + Duration
```

### 5.4 Update Cards

Set dates on all cards:

```python
update_card(
    card_id=card_id,
    start="YYYY-MM-DD",
    due_date="YYYY-MM-DD",
    due_time="23:59"  # End of day
)
```

---

## Phase 6: Finalize Plan

### 6.1 Review Timeline

Visualize the quarter:

```
Week 1-2:  [Epic A - Feature 1] [Feature X]
Week 3-4:  [Epic A - Feature 2] [Bug fixes]
Week 5-6:  [Epic B - Feature 1]
Week 7-8:  [Epic B - Feature 2] [Chores]
Week 9-10: [Buffer / Overflow]
Week 11-12: [Testing / Release prep]
Week 13:   [Quarter review]
```

### 6.2 Identify Risks

Document potential blockers:
- Dependencies on external teams
- Technical unknowns
- Resource constraints
- Competing priorities

### 6.3 Create Planning Documents

Generate documents from templates in the planning folder structure:

```
docs/platform-ops/planning/
  {year}/
    Q{N}/
      plan.mdx          # Quarterly plan (MDX with roadmap component)
      {MMM}-review.md   # Monthly reviews (JAN, FEB, MAR, etc.)
```

**Important:** The quarterly plan must be saved as `.mdx` (not `.md`) to support the roadmap component.

### 6.4 Communicate Plan

Share with stakeholders:
- Update quarterly plan card with link to planning document
- Link to relevant design documents
- Set up tracking dashboards

---

## Quick Reference

### Trello Commands

```bash
# Get project context
get_project_context()

# Get board details
get_board_context(board_id)

# Search for cards
search_cards(board_id, query, type, filter_status)

# Get epic tree
get_card_tree(epic_id)

# Update card dates
update_card(card_id, start, due_date, due_time, due_complete)

# Create new cards
create_card(list_id, name, card_type, parent, start, due_date)
```

### Card Nomenclature

| Type | Format |
|------|--------|
| Epic | `[EPIC-XXX] Name` |
| Epic Feature | `[EPICXXX-FN] Name` |
| Standalone Feature | `[FEAT] FEAT-NNN: Name` |
| Feature Task | `[FEAT-NNN-NN] Name` |
| Design | `[DESIGN] DES-XXX: Name` |
| Plan | `[PLAN-QN] Scientist Name` |
| Monthly Review | `[PLAN-QN-MMM] Month Review` |

### Scientist Names for Quarters

| Quarter | Scientist | Field |
|---------|-----------|-------|
| Q1 | Marie Curie | Physics/Chemistry |
| Q2 | Alexander Fleming | Medicine |
| Q3 | Rosalind Franklin | Chemistry/Biology |
| Q4 | Louis Pasteur | Microbiology |

---

## Checklist

### Pre-Planning
- [ ] Previous quarter cards reviewed and updated
- [ ] Similar completed work identified for estimation
- [ ] Business goals and OKRs gathered
- [ ] Backlog reviewed and pruned

### Planning
- [ ] Priorities defined (P0-P3)
- [ ] Work items created (Epics/Features)
- [ ] Duration estimated from similar past work
- [ ] Dates set based on historical comparison

### Post-Planning
- [ ] Timeline reviewed for conflicts
- [ ] Risks documented
- [ ] Plan communicated to stakeholders
- [ ] Quarterly plan card updated
