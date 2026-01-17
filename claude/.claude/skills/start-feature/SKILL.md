---
name: start-feature
description: Start a new feature from a Trello card. Use when the user wants to begin working on a feature, task, or card from Trello.
argument-hint: <card-id-or-search-term>
---

# Start Feature Skill

Start a new feature for the Trello card: **$ARGUMENTS**

## Overview

When starting a new feature:
1. **Find the Trello card** - Search for the card and understand the requirements
2. **Move the card** - Update card status to "In Progress"
3. **Create a feature branch** - Following branch naming conventions
4. **Explore documentation** - Understand relevant architecture and designs

## Prerequisites

- Card ID or search term to find the Trello card
- Clean working directory (no uncommitted changes)
- Main branch up-to-date

## Step 1: Find and Review the Trello Card

### Search for the Card

Use semantic search to find the card. First get project context to discover boards:

```
get_project_context()
```

Then search for the card:

```
search_cards(query="<card-id-or-description>", board_id="<board-id>")
```

### Get Card Details

Once the card is found, retrieve full details:

```
get_card_by_id(card_id="<card-id>")
```

Review:
- Card title and description
- Labels (priority, type)
- Current list (should be in "Approved" or similar)

## Step 2: Move Card to In Progress

Get the board's lists to find the "In Progress" list:

```
list_lists(board_id="<board-id>")
```

Move the card:

```
move_card(card_id="<card-id>", list_id="<in-progress-list-id>")
```

## Step 3: Create Feature Branch

Follow the branch naming convention:

```
<type>/<card-id>-<short-description>
```

### Branch Types

| Type | Use Case |
|------|----------|
| `feat` | New features or enhancements |
| `fix` | Bug fixes |
| `docs` | Documentation only changes |
| `refactor` | Code refactoring |
| `test` | Adding or updating tests |
| `chore` | Maintenance tasks |

### Commands

```bash
# Ensure main is up-to-date
git checkout main
git pull origin main

# Create and checkout the feature branch
git checkout -b <type>/<card-id>-<short-description>
```

### Branch Name Examples

From card `DES017-01` titled "ES256 Key Handling":
```bash
git checkout -b feat/des017-01-es256-key-handling
```

## Step 4: Explore Relevant Documentation

### Identify the Service

Based on the Trello board and card content, identify which service(s) are involved.

### Read Service Documentation

1. **Service README**: `docs/{service}/README.md`
2. **Architecture**: `docs/{service}/architecture.md`
3. **Relevant ADRs**: `docs/{service}/adr/`
4. **Related Designs**: `docs/{service}/designs/`

### Check Platform Documentation

For cross-cutting concerns:
- `docs/platform/architecture.md` - Global system architecture
- `docs/platform/devops/` - CI/CD, testing guidelines

## Step 5: Summarize and Confirm

After completing the above steps, provide a summary:

1. **Card Details**: Title, description, labels
2. **Branch Created**: Full branch name
3. **Relevant Documentation**: List of docs reviewed
4. **Implementation Context**: Key architectural decisions and patterns to follow
5. **Next Steps**: Suggested approach based on the card requirements

## Quick Reference

```bash
# 1. Update main
git checkout main && git pull origin main

# 2. Create feature branch
git checkout -b feat/<card-id>-<description>

# 3. Verify branch
git branch --show-current
```

## Error Handling

| Issue | Resolution |
|-------|------------|
| Card not found | Try different search terms or check board |
| Uncommitted changes | Stash or commit before starting |
| Branch already exists | Verify if work already started |
| Card not in Approved | Confirm with user before proceeding |
