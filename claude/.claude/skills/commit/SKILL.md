---
name: commit
description: Create a git commit with proper checks and validation. Use when the user asks to commit changes, create a commit, or save their work to git.
---

# Commit Changes Skill

Create clean, validated git commits following best practices.

## Commit Workflow

1. **Review changes**: `git status` and `git diff`
2. **Check for sensitive files** (see excluded files list below)
3. **Run tests**: cargo test, npm test, pytest, go test, etc.
4. **Stage files**: `git add <specific-files>` (avoid `git add .`)
5. **Create two-part commit** (see format below)
6. **Verify**: `git log -1` and `git status`

## Commit Message Format

**CRITICAL: Always use two-part commits with `-m` flags**

```bash
git commit -m "[CARD-ID] Short summary (50 chars max)" -m "Detailed explanation of why this change was made and what problem it solves.

- Bullet point 1
- Bullet point 2"
```

### Format Rules:

- **First -m**: `[CARD-ID] Imperative description` (e.g., `[DES017-01] Add JWT authentication`)
- **Second -m**: Explain WHY, include context, changes list, reasoning
- **Card ID**: Use the Trello card ID from the current feature branch (extract from branch name)
- Only use single -m for trivial chores (typos, formatting) without card ID

### Examples:

**Feature with Card ID:**
```bash
git commit -m "[DES017-01] Fix ES256 key handling in Auth0Provider" \
  -m "Update find_decoding_key to support both ES256 (ECDSA P-256) and RS256 (RSA) algorithms.

Changes:
- find_decoding_key now returns (DecodingKey, Algorithm) tuple
- Added support for EllipticCurve JWKs (ES256/P-256)
- Kept RSA JWK support (RS256) for compatibility
- Added 4 unit tests"
```

**Bug Fix:**
```bash
git commit -m "[DES016-03] Fix email validation to allow plus signs" \
  -m "Previous regex rejected valid emails with + characters (common in gmail aliases).

Changes:
- Updated to RFC 5322 compliant pattern
- Added test cases for plus-sign emails"
```

**Refactor:**
```bash
git commit -m "[EPIC001-F2] Refactor components to functional style" \
  -m "Converts class components to hooks-based functional components.

Benefits:
- Reduces bundle size by 15%
- Improves code readability
- Enables better tree-shaking"
```

**Trivial (no card ID needed):**
```bash
git commit -m "Fix typo in README"
```

## Extracting Card ID

Get the card ID from the current branch name:

```bash
# Branch name format: <type>/<card-id>-<description>
# Example: feat/des017-01-es256-key-handling → DES017-01

git branch --show-current | sed 's/.*\///' | cut -d'-' -f1-2 | tr '[:lower:]' '[:upper:]'
```

## Excluded Files (NEVER commit)

**Warn user if any of these are staged:**
- `.env`, `.env.*` (environment variables)
- `credentials.json`, `secrets.json`, `*.pem`, `*.key`, `*.p12`
- Files with API keys, tokens, or passwords
- `node_modules/`, `dist/`, `build/`, `target/` (unless intentional)

## Test Commands by Project Type

### Rust (Pergamini)
```bash
# Standard tests
SQLX_OFFLINE=true cargo test --all

# With clippy check (recommended before commit)
SQLX_OFFLINE=true cargo clippy --all-targets --all-features -- -D warnings
```

### Other Languages
- **Node.js**: `npm test` or `npm run test`
- **Python**: `pytest`, `python -m pytest`, `python -m unittest`
- **Go**: `go test ./...`
- **Make**: `make test`

**If tests fail, DO NOT commit** - fix failures first.

Skip tests only when:
- User explicitly says "skip tests"
- Documentation-only changes (README, comments)
- Tests broken in main branch (confirm with user)

## Critical Rules

1. **NEVER** add `Co-Authored-By` or `Generated with Claude` messages
2. **NEVER** force push to main/master
3. **NEVER** commit with --no-verify (unless user explicitly requests)
4. **NEVER** amend pushed commits (unless user explicitly requests)
5. **ALWAYS** use two-part commit messages with separate -m flags
6. **ALWAYS** include card ID when working on a feature branch
7. **ALWAYS** run tests before committing
8. **ALWAYS** check for sensitive files

## Pre-commit Hook Handling

If hooks modify files:
1. Review hook changes
2. `git add <modified-files>`
3. `git commit --amend --no-edit`

## Quick Reference

```bash
# 1. Review changes
git status
git diff

# 2. Run tests (Rust)
SQLX_OFFLINE=true cargo test --all

# 3. Stage specific files
git add <files>

# 4. Commit with card ID
git commit -m "[CARD-ID] Short description" -m "Detailed explanation.

Changes:
- Change 1
- Change 2"

# 5. Verify
git log -1
git status
```
