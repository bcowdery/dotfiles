---
name: create-pr
description: This skill should be used when creating GitHub Pull Requests for a feature branch, when the user says "create PR", "open PR", or wants to push changes and create a pull request.
---

# Create PR Skill

## Overview

Create well-formatted GitHub Pull Requests using the `gh` CLI tool, with comprehensive descriptions, examples, and security checklists.

## When to Use

Use this skill when:
- Creating a new Pull Request for a feature branch
- User explicitly requests "create PR", "open PR", or similar
- Pushing changes and wanting to open a PR in one workflow

Do NOT use this skill for:
- Reviewing existing PRs (use `review-pr` instead)
- Creating JIRA tickets (use `jira-create` instead)
- Committing changes without a PR

## Quick Reference

```bash
# Check current branch status
git status
git log main..HEAD

# Push and create PR
git push -u origin <branch-name>
gh pr create --title "feat: Title" --body "$(cat <<'EOF'
...
EOF
)"
```

## Step-by-Step Process

### 1. Understand the Changes

Run these commands to gather context:

```bash
git status                    # See changed files
git diff                      # See code changes
git log main..HEAD            # See commits to include
```

If the branch is not pushed, note that pushing is required first.

### 2. Analyze the Changes

Review the code changes to identify:
- Main feature, fix, or improvement
- Usage examples from tests or documentation
- Security-relevant changes (authentication, data validation, user input handling)

### 3. Generate PR Content

Create a PR description following this template:

```markdown
# Summary

[2-3 sentence description of the changes]

## Examples

[1-3 code examples showing how to use the new functionality]

## Related Issues

- [PE-XXXX](link to related issue)

## Security Checklist

- [ ] Authorization has been implemented across these changes
- [ ] Injection has been prevented (parameterized queries, no eval or system calls)
- [ ] Any web UI is escaping output (to prevent XSS)
- [ ] Sensitive data has been identified and is being protected properly
- [ ] All client side console.logs have been reviewed and does not output sensitive data
- [ ] Server call parameters are validated (data types, ranges, etc.)

## Testing Checklist

[List any additional steps required to test this change]
```

**Guidelines for the description:**
- Summary should explain WHAT changed and WHY, not just list commits
- Examples should show actual usage of the new/modified code
- Pre-check relevant security checklist items based on the code changes
- Add specific testing steps if there are manual testing requirements

### 4. Create the PR

Push the branch if needed:
```bash
git push -u origin <branch-name>
```

Create the PR using a HEREDOC for proper formatting:
```bash
gh pr create --title "feat: Add feature name" --body "$(cat <<'EOF'
[PR description here]
EOF
)"
```

**Title format**: Follow conventional commits (feat:, fix:, chore:, docs:, etc.)

### 5. Confirm Success

Display the PR URL and summarize what was included.

## Common Mistakes

| Mistake | Solution |
|---------|----------|
| Skipping git diff/log review | Always read the full diff and commit history before creating PR description |
| Using hypothetical examples | Examples must be ACTUAL code from the changes |
| Leaving PE-XXXX placeholder | Ask the user for related issue numbers, or remove if none |
| Not pushing branch first | Always check if branch is pushed before running `gh pr create` |
| Generic security checklist | Pre-check items that are clearly addressed in the code |

## Important Notes

- Use the main branch as the base unless the user specifies otherwise
- For multi-line PR bodies, always use HEREDOC syntax to preserve formatting
- Never commit or push without user confirmation
