---
name: design
description: Create a design document following the standard workflow. Use when the user needs to design a new feature, system, or solve a complex technical problem.
argument-hint: <problem-description-or-trello-card>
---

# Design Document Skill

Start the design workflow for: **$ARGUMENTS**

Output: design document.

## Overview

The workflow consists of 8 phases:

```
1. Problem Discovery    - Identify and articulate the problem
2. Research             - Research patterns, approaches, prior art
3. Proposals & Iteration - Generate multiple proposals, discard, iterate
4. Decision             - Choose the best approach, document rationale
5. Implementation Plan  - Structured strategy, phased implementation
6. Open Questions       - Identify unknowns, resolve 1-by-1
7. Section Review       - Review each section, approve or iterate
8. Final Approval       - Mark document approved, update metadata
```

---

## Prelude: Trello Card Setup

Before starting the design workflow, ensure proper task tracking is in place.

### Agent Actions
1. Check if a Trello card exists for this work
2. If no card exists, create one (start as `task` or `feature`)
3. Link the design document to the card via `trackId`
4. During the design process, evaluate scope:
   - If work is larger than expected, propose promoting to `epic`
   - Create child `feature` or `task` cards as needed

### Card Type Guidelines

| Type | When to Use |
|------|-------------|
| **Task** | Single, focused piece of work (1-2 days) |
| **Feature** | Multi-step work requiring design (3-5 days) |
| **Epic** | Large initiative with multiple features/tasks (1+ weeks) |

**Promotion triggers**:
- Design reveals multiple distinct components -> promote to `epic`
- Implementation plan has 5+ phases -> consider `epic`
- Multiple blocking dependencies identified -> likely `epic`

---

## Phase 1: Problem Discovery

**Goal**: Clearly identify and articulate the problem to solve.

### Agent Actions
1. Ask clarifying questions about the problem
2. Read relevant existing code/documentation
3. **Search for prior work**: Use Trello semantic search to find related cards, previous features, or past decisions
4. Review existing design documents (DES-XXX) for related work
5. Summarize understanding back to user, including relevant history
6. Draft Overview, Goals, Non-Goals, Problem Analysis sections
7. Present draft for feedback

**Output**: Overview, Goals, Non-Goals, Problem Analysis sections

**Prior work discovery**:
- Use `search_cards` with semantic query to find related Trello cards
- Check `docs/{service}/designs/` for existing design documents
- Reference prior decisions to maintain consistency

---

## Phase 2: Research

**Goal**: Explore existing patterns, approaches, and prior art.

### Agent Actions
1. Use web search to research industry patterns
2. Look at established libraries and frameworks
3. Read documentation of relevant tools
4. Compile findings with pros/cons for each approach
5. Present research summary to user

**Output**: Research findings, pattern analysis

**Tips**:
- Use web search for current best practices
- Look at established libraries (Radix UI, TanStack, etc.)
- Document ALL options, even ones that seem suboptimal

---

## Phase 3: Proposals & Iteration

**Goal**: Generate multiple proposals and refine through discussion.

### Agent Actions
1. Present 3-4 different approaches with pros/cons
2. Wait for user feedback on each approach
3. Mark discarded options with `> **DISCARDED**: rationale`
4. Iterate on promising approaches based on feedback
5. Ask clarifying questions when user feedback is ambiguous
6. Update document after each decision

**Output**: Architecture Patterns Analysis section with DISCARDED/CHOSEN markers

**Pattern for discarding**:
```markdown
### Pattern X: Name

> **DISCARDED**: Brief rationale for why this doesn't fit.

[Details of the pattern...]
```

**Key principle**: Don't delete discarded options. Mark them clearly so the decision history is preserved.

---

## Phase 4: Decision

**Goal**: Choose the best approach and document the rationale.

### Agent Actions
1. Summarize the chosen approach clearly
2. Document why it was chosen over alternatives
3. Create architecture diagrams (ASCII or description)
4. Define the high-level structure
5. Present decision summary for confirmation

**Output**: Chosen Approach section with diagrams and rationale

**Include**:
- Clear statement of the decision
- Comparison table (if helpful)
- Architecture diagram
- Key benefits and trade-offs acknowledged

---

## Phase 5: Implementation Planning

**Goal**: Create a structured implementation strategy and phased plan.

### Agent Actions
1. Define implementation structure (interfaces, types, components)
2. Write detailed code examples for key parts
3. Define file/directory structure
4. Break implementation into logical phases
5. Identify dependencies and blockers explicitly
6. Consider migration strategy (v2 alongside v1)
7. Present implementation plan for review

**Output**: Implementation Structure, File Structure, Implementation Plan sections

**Implementation Plan format**:
```markdown
### Phase N: Name
1. Step one
2. Step two
3. **Blocker**: Note any blockers
```

**Tips**:
- Each phase should be independently deliverable
- Identify blockers explicitly
- Consider migration strategy (v2 alongside v1)

---

## Phase 6: Open Questions Resolution

**Goal**: Identify and resolve all open questions systematically.

### Agent Actions
1. List all open questions at the end of the document
2. Create a todo list with each question as an item
3. Present questions one at a time with options/recommendations
4. Wait for user decision on each question
5. Update the Open Questions section with decision
6. **Critically**: Update ALL other sections affected by the decision
7. Mark question as completed in todo, move to next

**Output**: Resolved Open Questions section

**Resolution format**:
```markdown
1. **Question topic**: DECIDED: Decision summary
   - Detail 1
   - Detail 2
   - Rationale
```

**Key principle**: Resolve questions one at a time. Update ALL relevant sections after each decision, not just the Open Questions section.

---

## Phase 7: Section-by-Section Review

**Goal**: Methodically review each section for approval.

### Agent Actions
1. Create a todo list with each document section
2. Present first section (content or summary for long sections)
3. Wait for user response
4. If "approved": mark completed, present next section
5. If feedback: update section, re-present for approval
6. Continue until all sections are approved

**Output**: All sections reviewed and approved

**Presenting sections**:
- Show the section content (can be summarized for long sections)
- Wait for explicit "approved" or questions
- If questions arise, discuss and update before continuing

---

## Phase 8: Final Approval

**Goal**: Mark the document as approved and update metadata.

### Agent Actions
1. Update frontmatter status: `draft` -> `approved`
2. Increment iteration number
3. Update tags to reflect final decisions
4. Add changelog entry for approval
5. Update related_designs if new dependencies emerged
6. Present summary of all decisions made
7. Confirm document is approved

**Output**: Approved design document

**Frontmatter updates**:
```yaml
status: approved
iteration: N+1
changelog:
  - YYYY-MM-DD (vN): Approved - brief summary of what was finalized
```

---

## Document Structure Template

```markdown
---
title: "DES-XXX: Title"
date: YYYY-MM-DD
status: draft
iteration: 1
author: Team
tags: [design, service-name, relevant-tags]
priority: low|medium|high
related_adrs: []
related_designs: []
changelog:
  - YYYY-MM-DD (v1): Initial draft
---

# DES-XXX: Title

## Overview
[Brief description of what this design addresses]

## Goals
1. Goal one
2. Goal two

## Non-Goals
- Non-goal one
- Non-goal two

---

## Problem Analysis
[Detailed analysis of the current state and problems]

---

## Architecture Patterns Analysis

### Pattern 1: Name
> **DISCARDED**: Rationale

### Pattern 2: Name (CHOSEN)
[Details...]

---

## Chosen Approach: Name
[Summary and diagrams]

---

## Implementation Structure
[Interfaces, components, code examples]

---

## Usage Examples
[How consumers will use this]

---

## File Structure
[Directory and file organization]

---

## Implementation Plan
[Phased plan with steps]

---

## Open Questions
1. **Question**: DECIDED: Answer
2. **Question**: DECIDED: Answer

---

## References
- [Link 1](url)
- [Link 2](url)

## Related Documents
- [Related doc](path)
```

---

## Tips for Effective Design Sessions

1. **Don't rush decisions** - It's okay to discuss multiple options
2. **Preserve history** - Mark discarded options, don't delete them
3. **Update comprehensively** - When a decision affects multiple sections, update all of them
4. **Use todos for tracking** - Makes progress visible and ensures nothing is missed
5. **Be explicit about blockers** - Dependencies on other work should be clearly marked
6. **Migration over big bang** - Prefer v2-alongside-v1 strategies for safer rollouts
7. **Section review catches issues** - The final review often surfaces inconsistencies
