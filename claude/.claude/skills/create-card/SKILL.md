---
name: create-card
description: Create a Trello card with proper nomenclature and context. Use when creating epics, features, tasks, designs, or other card types.
argument-hint: <card-type> <title-or-description>
---

# Create Card Skill

Create a Trello card for: **$ARGUMENTS**

## Overview

This skill creates properly formatted Trello cards following the nomenclature conventions. Each card type requires specific context to be useful for implementation.

## Card Types Reference

| Type | Prefix | When to Use |
|------|--------|-------------|
| **Epic** | `[EPIC-XXX]` | Major initiative (1+ weeks, multiple features) |
| **Design** | `[DESIGN] DES-XXX:` | Technical design documentation |
| **Feature (Epic)** | `[EPICXXX-FN]` | Implementation work under an epic |
| **Feature (Standalone)** | `[FEAT] FEAT-NNN:` | Independent feature (no epic) |
| **Task** | Checklist or `[FEAT-NNN-NN]` | Individual work item |
| **Chore** | `[CHORE]` | Maintenance, cleanup, tech debt |
| **Docs** | `[DOCS]` | Documentation work |
| **Plan** | `[PLAN-QN]` | Quarterly plan |

## Step 1: Determine Card Type and Scope

Before creating, assess the work:

| Scope | Card Type | Criteria |
|-------|-----------|----------|
| Multi-feature | Epic | Requires 2+ features, 1+ weeks |
| Design needed | Design + Feature/Epic | Complex work requiring design doc |
| Single deliverable | Standalone Feature | 3-5 days, multiple tasks |
| Small focused work | Task (checklist) | 1-2 days, part of feature |
| Maintenance | Chore | Cleanup, updates, no new functionality |

## Step 2: Get Next Card Number

Search existing cards to find the next available number:

```
# For epics - find highest EPIC number
search_cards(board_id, type="epic", limit=50)

# For designs - find highest DES number
search_cards(board_id, query="DES-", limit=50)

# For standalone features - find highest FEAT number
search_cards(board_id, query="FEAT-", type="feature", limit=50)
```

## Step 3: Gather Context

**CRITICAL**: Before creating any card, gather relevant context to include:

### For All Cards
- [ ] Search for related existing cards
- [ ] Identify relevant design documents
- [ ] Find related code paths/files
- [ ] Check for dependencies on other work

### Context Gathering Commands

```bash
# Find related design docs
ls docs/*/designs/

# Find relevant code
grep -r "keyword" src/

# Check existing architecture
cat docs/{service}/architecture.md
```

---

## Card Templates by Type

### Epic Card

```
create_card(
    list_id="<approved-list-id>",
    name="[EPIC-XXX] Epic Title",
    card_type="epic",
    desc="..."
)
```

**Description Template:**
```markdown
## Overview
[2-3 sentences describing the initiative and its business value]

## Goals
1. [Measurable goal 1]
2. [Measurable goal 2]
3. [Measurable goal 3]

## Non-Goals
- [Explicitly out of scope item 1]
- [Explicitly out of scope item 2]

## Success Criteria
- [ ] [Criterion 1 - measurable]
- [ ] [Criterion 2 - measurable]

## Features
- [ ] EPICXXX-F1: [Feature 1 name]
- [ ] EPICXXX-F2: [Feature 2 name]
- [ ] EPICXXX-F3: [Feature 3 name]

## Related Designs
- [DESIGN] DES-XXX: [Design name](link-to-card)

## Architecture Context
- Service: `{service-name}`
- Key files: `src/path/to/relevant/code`
- ADRs: [ADR-XXX](docs/{service}/adr/XXX-name.md)

## Dependencies
- [Dependency on other epic/feature if any]

## Notes
[Any additional context, constraints, or considerations]
```

---

### Design Card

```
create_card(
    list_id="<approved-list-id>",
    name="[DESIGN] DES-XXX: Design Title",
    card_type="docs",
    desc="..."
)
```

**Description Template:**
```markdown
## Problem Statement
[Clear description of the problem to solve]

## Goals
1. [Design goal 1]
2. [Design goal 2]

## Non-Goals
- [Out of scope 1]

## Input
- Epic: [EPIC-XXX](link) (if applicable)
- Requirements: [Link to requirements or describe]

## Output
- Design doc: `docs/{service}/designs/XXX-design-name.md`

## Related Work
- Prior designs: [DES-YYY](link)
- Existing code: `src/path/to/related/code`
- ADRs: [ADR-ZZZ](link)

## Status
- [ ] Draft
- [ ] In Review
- [ ] Approved
```

---

### Feature Card (Epic-based)

```
create_card(
    list_id="<approved-list-id>",
    name="[EPICXXX-FN] Feature Title",
    card_type="feature",
    parent="<epic-card-id>",
    desc="..."
)
```

**Description Template:**
```markdown
## Overview
[Brief description of what this feature implements]

## Design Reference
- Design: [DES-XXX: Design Name](link-to-design-card)
- Section: [Specific section of design this implements]

## Tasks
- [ ] EPICXXX-FN-01: [Task 1 - specific implementation step]
- [ ] EPICXXX-FN-02: [Task 2 - specific implementation step]
- [ ] EPICXXX-FN-03: [Task 3 - specific implementation step]
- [ ] EPICXXX-FN-04: [Tests for this feature]

## Implementation Context

### Files to Create/Modify
- `src/path/to/new/file.rs` - [purpose]
- `src/path/to/existing/file.rs` - [what to change]

### Key Code References
- `src/path/to/related/module.rs:123` - [relevant function/struct]
- `src/path/to/pattern/example.rs` - [pattern to follow]

### API/Interface Changes
- New endpoint: `POST /api/resource`
- Modified: `GET /api/existing` - [what changes]

## Dependencies
- Requires: [EPICXXX-F(N-1)] (if sequential)
- Blocked by: [Other card if applicable]

## Acceptance Criteria
- [ ] [Testable criterion 1]
- [ ] [Testable criterion 2]
- [ ] Tests pass
- [ ] Code reviewed
```

---

### Feature Card (Standalone)

```
create_card(
    list_id="<approved-list-id>",
    name="[FEAT] FEAT-NNN: Feature Title",
    card_type="feature",
    desc="..."
)
```

**Description Template:**
```markdown
## Overview
[Brief description of the standalone feature]

## Related
- Design: [DES-XXX: Design Name](link) (if applicable)
- Related feature: [FEAT-YYY](link) (if applicable)

## Tasks
- [ ] FEAT-NNN-01: [Task 1]
- [ ] FEAT-NNN-02: [Task 2]
- [ ] FEAT-NNN-03: [Task 3]
- [ ] FEAT-NNN-04: [Tests]

## Implementation Context

### Files to Create/Modify
- `src/path/to/file.rs` - [purpose]

### Key Code References
- `src/path/to/similar/feature.rs` - [pattern to follow]

### Tests
- Unit tests: `tests/unit/feature_test.rs`
- Integration: `tests/integration/feature_test.rs`

## Acceptance Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]
```

---

### Task Card (Standalone)

Only create as separate card if NOT part of a feature. Usually tasks are checklists in feature descriptions.

```
create_card(
    list_id="<approved-list-id>",
    name="[FEAT-NNN-NN] Task Title",
    card_type="task",
    parent="<feature-card-id>",
    desc="..."
)
```

**Description Template:**
```markdown
## Task
[Specific description of what to implement]

## Implementation Details
- File: `src/path/to/file.rs`
- Function/Struct: `function_name` or `StructName`
- Line range: ~L100-150

## Code Reference
```rust
// Example of pattern to follow or code to modify
fn example_function() {
    // ...
}
```

## Tests Required
- [ ] Unit test for [specific case]
- [ ] Edge case: [description]

## Done When
- [ ] Implementation complete
- [ ] Tests pass
- [ ] Feature checklist updated
```

---

### Chore Card

```
create_card(
    list_id="<chores-list-id>",
    name="[CHORE] Chore Title",
    card_type="chore",
    desc="..."
)
```

**Description Template:**
```markdown
## Task
[What maintenance work needs to be done]

## Reason
[Why this chore is needed - tech debt, cleanup, update, etc.]

## Files Affected
- `path/to/file1`
- `path/to/file2`

## Steps
1. [Step 1]
2. [Step 2]

## Done When
- [ ] [Completion criterion]
```

---

## Context Guidelines by Card Type

### Epic Context Requirements

| Required | Description |
|----------|-------------|
| Business value | Why this matters |
| Goals (3-5) | Measurable objectives |
| Feature breakdown | High-level feature list |
| Design links | Related design documents |
| Architecture | Service, key files, ADRs |
| Dependencies | Blocking/blocked-by relationships |

### Feature Context Requirements

| Required | Description |
|----------|-------------|
| Design reference | Link to design doc + section |
| Task checklist | Numbered tasks (EPICXXX-FN-NN) |
| Files to modify | Specific paths |
| Code references | Existing patterns to follow |
| API changes | New/modified endpoints |
| Acceptance criteria | Testable conditions |

### Task Context Requirements

| Required | Description |
|----------|-------------|
| Specific file | Exact path |
| Function/struct | What to create/modify |
| Code example | Pattern to follow |
| Test requirements | What tests to write |

---

## Workflow

1. **Assess scope** → Determine card type
2. **Get next number** → Search existing cards
3. **Gather context** → Find designs, code, dependencies
4. **Create card** → Use appropriate template
5. **Link relationships** → Set parent, add related links
6. **Set dates** (optional) → start, due_date

## Quick Reference

```bash
# Create epic
create_card(list_id, name="[EPIC-XXX] Title", card_type="epic", desc="...")

# Create design
create_card(list_id, name="[DESIGN] DES-XXX: Title", card_type="docs", desc="...")

# Create feature under epic
create_card(list_id, name="[EPICXXX-FN] Title", card_type="feature", parent="<epic-id>", desc="...")

# Create standalone feature
create_card(list_id, name="[FEAT] FEAT-NNN: Title", card_type="feature", desc="...")

# Create chore
create_card(list_id, name="[CHORE] Title", card_type="chore", desc="...")
```

## Related Skills

- `/design` - Create design document (often precedes feature work)
- `/start-feature` - Start working on a feature card
- `/quarterly-planning` - Plan and create cards for a quarter
