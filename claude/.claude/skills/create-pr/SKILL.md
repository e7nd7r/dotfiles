---
name: create-pr
description: Create a pull request for the current branch. Use when the user wants to submit their changes for review.
---

# Create Pull Request Skill

Create a pull request for the current branch.

## Prerequisites

Before creating a PR:
1. Work is complete on a feature branch
2. All changes are committed (use `/commit` if needed)
3. Local CI checks pass

## Step 1: Commit Pending Changes

If there are uncommitted changes, **invoke the `/commit` skill** using the Skill tool. Do NOT run git commit commands directly - the commit skill ensures proper format and validation.

```
/commit
```

**IMPORTANT:** You must actually invoke the skill, not just follow its documentation manually. The `/commit` skill enforces:
- `[CARD-ID]` prefix in commit messages
- Two-part commits with separate `-m` flags
- No `Co-Authored-By` or `Generated with` footers
- Test execution before committing

## Step 2: Local CI Verification

Run these commands before pushing (same as GitHub Actions CI):

```bash
# Clean build artifacts to match CI behavior (incremental builds can miss errors)
cargo clean

# Check formatting
cargo fmt --all -- --check

# Run clippy with warnings as errors
SQLX_OFFLINE=true cargo clippy --all-targets --all-features -- -D warnings

# Build release
SQLX_OFFLINE=true cargo build --release

# Run all tests
SQLX_OFFLINE=true cargo test --all
```

All commands must pass with no errors.

**Note:** The `cargo clean` step is important because incremental builds may skip re-checking files that weren't modified, causing clippy to miss errors that CI (which always does a clean build) will catch.

## Step 3: Integration Tests (When Applicable)

Run integration tests **only if changes potentially impact them**, such as:
- Database schema changes (migrations)
- Repository implementations
- Storage backend changes
- API endpoints that interact with the database

### Starting the Database

```bash
cd apps/api
just up-db       # Start Postgres in Docker
```

### Running Integration Tests

```bash
# Run API migrations (--ignore-missing allows running both migration sets)
DATABASE_URL=postgres://pergamini:pergamini_dev@localhost:5433/pergamini_dev \
  sqlx migrate run --source apps/api/migrations --ignore-missing

# Run orchestrator migrations (if applicable)
DATABASE_URL=postgres://pergamini:pergamini_dev@localhost:5433/pergamini_dev \
  sqlx migrate run --source libs/orchestrator/migrations --ignore-missing

# Run integration tests
DATABASE_URL=postgres://pergamini:pergamini_dev@localhost:5433/pergamini_dev \
  cargo test -p pergamini-orchestrator -p pergamini-api --features integration
```

### Cleaning Up

After running integration tests, stop the database to free resources:

```bash
cd apps/api
just down-db     # Stop and remove Postgres container
```

## Step 4: Push and Create PR

### Push the Branch

```bash
git push -u origin <branch-name>
```

### Create PR Body File

Create a temporary file with the PR body using `printf`:

```bash
printf '## Summary
- Brief description of change 1
- Brief description of change 2

## Changes
- Detailed change 1
- Detailed change 2

## Test plan
- [x] Test case 1
- [x] Test case 2

## Related
- Task: [CARD-ID]
- Epic: [EPIC-ID]
' > /tmp/pr_body.md
```

### Create the PR

```bash
gh pr create --title "[CARD-ID] Short description" --body-file /tmp/pr_body.md
```

## PR Title Format

```
[CARD-ID] Short imperative description
```

Examples:
- `[DES017-01] Fix ES256 key handling in Auth0Provider`
- `[DES016-03] Add token validation middleware`

## PR Body Template

```markdown
## Summary
- Bullet points summarizing the change (1-3 items)

## Changes
- Specific code changes made

## Test plan
- [x] Checkbox list of tests/verification done

## Related
- Task: [CARD-ID]
- Epic: [EPIC-ID] (if applicable)
```

## Step 5: Update Trello

After PR creation:

1. Move Trello card to "In Review" list
2. Wait for CI checks to pass
3. Request review if needed

```
move_card(card_id="<card-id>", list_id="<in-review-list-id>")
```

**IMPORTANT:** STOP here and wait for the PR to be reviewed and merged. Do not proceed with post-merge steps until the user confirms the PR has been merged.

## After PR Merge

Once the PR is merged, execute these cleanup steps:

### 1. Update Local Repository

```bash
git checkout main
git pull origin main
```

### 2. Delete the Feature Branch

```bash
git branch -d <branch-name>
```

### 3. Update Trello Card

Move the card from "In Review" to "Done!":

```
move_card(card_id="<card-id>", list_id="<done-list-id>")
mark_task_completed(card_id="<card-id>")
```

### Quick Post-Merge Commands

```bash
git checkout main && git pull origin main && git branch -d <branch-name>
```

## CI Checks Reference

The CI pipeline runs:

| Job | Description |
|-----|-------------|
| `build` | Format check, clippy, build, unit tests |
| `integration-tests` | Tests with PostgreSQL database |
| `verify-sqlx` | Verify sqlx metadata is up-to-date |

## Quick Reference

```bash
# 1. Commit changes (if needed)
/commit

# 2. Verify locally (clean build to match CI)
cargo clean
cargo fmt --all -- --check
SQLX_OFFLINE=true cargo clippy --all-targets --all-features -- -D warnings
SQLX_OFFLINE=true cargo build --release
SQLX_OFFLINE=true cargo test --all

# 3. Push and create PR
git push -u origin <branch-name>
printf '## Summary\n- Change\n' > /tmp/pr_body.md
gh pr create --title "[CARD-ID] Description" --body-file /tmp/pr_body.md
```

## Related Skills

- `/commit` - Create validated git commits (used in Step 1)
- `/start-feature` - Start a feature from Trello card (precedes this workflow)
