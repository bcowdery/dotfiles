---
name: review-pr
description: Use when reviewing GitHub Pull Requests to provide comprehensive code quality, security, and architecture analysis with optional JIRA ticket integration
tools:
  - Bash
  - Task
  - Read
  - AskUserQuestion
---

# Review PR Skill

## Overview

Perform comprehensive code reviews of GitHub Pull Requests using the `gh` CLI tool, analyzing code quality, security, architecture, and alignment with requirements. Automatically fetch JIRA ticket context when ticket references are detected, then dispatch detailed review work to the `code-reviewer` agent.

## When to Use

Use this skill when:
- User explicitly requests a PR review (e.g., "/review-pr", "review this PR", "analyze PR #123")
- User asks to review changes before merging
- User requests feedback on a pull request
- User wants security or code quality analysis of a PR

Do NOT use this skill for:
- Creating pull requests (use `/create-pr` instead)
- Reviewing uncommitted local changes
- General code review without a PR context

## Step-by-Step Process

### 1. Identify the Pull Request

**Extract PR reference from user input:**
- PR number (e.g., "123", "#123")
- PR URL (e.g., "https://github.com/owner/repo/pull/123")
- Current branch (if no PR specified, check if current branch has an open PR)

**If PR not specified:**
```bash
# Check if current branch has an associated PR
gh pr status --json number,title,url
```

Ask user which PR to review if multiple options exist or none found.

### 2. Fetch PR Information

**Retrieve comprehensive PR details:**
```bash
# Get PR metadata
gh pr view <pr-number> --json number,title,body,headRefName,baseRefName,commits,author,state,url

# Get the full diff
gh pr diff <pr-number>

# Get changed files list
gh pr view <pr-number> --json files
```

**Parse the PR title** to extract:
- Conventional commit type (feat, fix, chore, etc.)
- Optional ticket reference (e.g., "feat(PROJ-123): Add feature" → "PROJ-123")

Common patterns for ticket extraction:
- `feat(PROJ-123): Title`
- `fix: [PROJ-123] Title`
- `PROJ-123 - Title`
- `feat: Title (PROJ-123)`

### 3. Fetch JIRA Ticket Context (If Applicable)

**When a ticket reference is found** in the PR title or description:

```bash
# Fetch ticket details
acli jira workitem search \
  --jql "key = PROJ-123" \
  --fields "key,summary,description,status,assignee,priority,labels" \
  --limit 1 \
  --json
```

**Extract from ticket:**
- Summary and description (requirements)
- Acceptance criteria
- Priority
- Labels that might indicate special requirements (e.g., "security", "breaking-change")

**If acli is not available** or ticket fetch fails:
- Proceed with review based solely on PR information
- Note in review output that JIRA context was not available

### 4. Prepare Review Context

**Organize collected information:**

```
PR Information:
- Number: #123
- Title: feat(PROJ-456): Add user authentication
- Author: @username
- Base branch: main
- Head branch: feature/auth
- URL: https://github.com/owner/repo/pull/123

PR Description:
[Full PR body content]

JIRA Ticket (PROJ-456):
- Type: Story
- Priority: High
- Summary: Implement JWT authentication
- Description: [Ticket description]
- Acceptance Criteria:
  - Users can log in with email/password
  - JWT tokens expire after 1 hour
  - Refresh tokens supported

Changed Files:
- src/auth/login.ts (128 additions, 5 deletions)
- src/middleware/auth.ts (45 additions, 0 deletions)
- tests/auth.test.ts (89 additions, 0 deletions)

Code Changes:
[Full diff from gh pr diff]
```

### 5. Dispatch to Code Reviewer Agent

**Use the Task tool** to launch the `code-reviewer` agent with comprehensive context:

```
Task tool parameters:
- subagent_type: "code-reviewer"
- description: "Review PR #123 implementation"
- prompt: [Comprehensive prompt with all context]
```

**Prompt structure for code-reviewer agent:**

```markdown
Review the following GitHub Pull Request implementation.

## PR Context

**PR #123**: feat(PROJ-456): Add user authentication
**Author**: @username
**URL**: https://github.com/owner/repo/pull/123

**PR Description**:
[PR body]

## JIRA Ticket Requirements (PROJ-456)

**Type**: Story
**Priority**: High
**Summary**: Implement JWT authentication

**Description**:
[Ticket description]

**Acceptance Criteria**:
- Users can log in with email/password
- JWT tokens expire after 1 hour
- Refresh tokens supported

## Changes Summary

**Changed Files** (3 files):
- src/auth/login.ts: +128/-5
- src/middleware/auth.ts: +45/-0
- tests/auth.test.ts: +89/-0

**Full Diff**:
[Complete diff from gh pr diff]

## Review Focus Areas

Based on the changes, focus your review on:

1. **Code Quality & Standards**
   - Readability, maintainability, conventions
   - Error handling and testing
   - Performance considerations

2. **Architecture & Design**
   - Design patterns and SOLID principles
   - Integration with existing codebase
   - Scalability considerations

3. **Alignment with Requirements** (CRITICAL)
   - Verify implementation matches JIRA ticket acceptance criteria
   - Check that all stated requirements are addressed
   - Identify any missing functionality

4. **Security** (CRITICAL for authentication changes)
   - Authentication/authorization implementation
   - Input validation and injection prevention
   - Sensitive data handling

## Instructions

Review the implementation using the criteria in `references/review_criteria.md`. Provide a structured analysis with:

1. **Executive Summary** - High-level assessment and recommendation
2. **Requirements Alignment** - How well the implementation matches the JIRA ticket
3. **Critical Issues** - Security vulnerabilities, breaking changes, data risks
4. **Important Issues** - Code quality, performance, missing tests
5. **Suggestions** - Nice-to-have improvements
6. **Positive Observations** - What was done well

Categorize each finding as Critical/Important/Suggestion and provide specific file/line references.
```

### 6. Format Review Output

**Once the code-reviewer agent completes**, format the output as a structured markdown report:

```markdown
# Pull Request Review: PR #123

**Title**: feat(PROJ-456): Add user authentication
**Author**: @username
**Reviewer**: Claude Code (code-reviewer agent)
**Review Date**: 2026-01-11
**PR URL**: https://github.com/owner/repo/pull/123
**JIRA Ticket**: [PROJ-456](https://your-domain.atlassian.net/browse/PROJ-456)

---

## Executive Summary

[High-level assessment with recommendation: Approve / Request Changes / Needs Work]

**Overall Assessment**: [1-2 paragraphs]

**Recommendation**: ✅ Approve / ⚠️ Request Changes / ❌ Needs Work

---

## Requirements Alignment

[Analysis of how well the implementation satisfies the JIRA ticket requirements]

**Acceptance Criteria Coverage**:
- ✅ Users can log in with email/password - Implemented in src/auth/login.ts:45-89
- ✅ JWT tokens expire after 1 hour - Configured in src/middleware/auth.ts:12
- ❌ Refresh tokens supported - Missing implementation

---

## Critical Issues

[Security vulnerabilities, data risks, breaking changes]

### 🔴 [Issue Title]

**Location**: `src/auth/login.ts:67-72`
**Category**: Security
**Severity**: Critical

**Description**: [Detailed explanation]

**Recommendation**: [Specific fix with code example if helpful]

---

## Important Issues

[Code quality, performance, architecture concerns]

### 🟡 [Issue Title]

**Location**: `src/middleware/auth.ts:34`
**Category**: Error Handling
**Severity**: Important

**Description**: [Detailed explanation]

**Recommendation**: [Specific fix]

---

## Suggestions

[Nice-to-have improvements]

### 💡 [Suggestion Title]

**Location**: `tests/auth.test.ts:100-120`
**Category**: Testing
**Severity**: Suggestion

**Description**: [Detailed explanation]

**Recommendation**: [Specific improvement]

---

## Positive Observations

[What was done well - be specific]

- ✅ Excellent test coverage with edge cases in tests/auth.test.ts
- ✅ Clean separation of concerns between login and middleware
- ✅ Proper error handling with meaningful messages

---

## Summary Statistics

- **Files Changed**: 3
- **Critical Issues**: 1
- **Important Issues**: 2
- **Suggestions**: 3
- **Tests Added**: Yes (89 lines)

---

## Next Steps

1. [Action item based on critical issues]
2. [Action item based on important issues]
3. [Optional improvements]
```

### 7. Present Review to User

**Display the formatted review** and offer follow-up actions:

```
I've completed a comprehensive review of PR #123. Here's my analysis:

[Display formatted review]

Would you like me to:
1. Post this review as a comment on the PR using `gh pr comment`
2. Export the review to a file
3. Discuss any specific findings in detail
4. Re-review after changes are made
```

## Quick Reference

### Common Commands

```bash
# View PR
gh pr view <number> --json number,title,body,url

# Get PR diff
gh pr diff <number>

# Check PR status
gh pr status

# List open PRs
gh pr list --state open

# Post review comment
gh pr comment <number> --body "Review content"

# Fetch JIRA ticket
acli jira workitem search --jql "key = PROJ-123" --limit 1 --json
```

### PR Title Parsing Patterns

Extract ticket references from titles using these patterns:

| Pattern | Example | Extracted Key |
|---------|---------|---------------|
| Prefix with colon | `PROJ-123: Add feature` | PROJ-123 |
| Conventional commits | `feat(PROJ-123): Add feature` | PROJ-123 |
| Square brackets | `feat: [PROJ-123] Add feature` | PROJ-123 |
| Suffix in parens | `feat: Add feature (PROJ-123)` | PROJ-123 |

Regex pattern: `([A-Z]+-\d+)` matches most JIRA ticket keys.

## Important Notes

### JIRA Integration
- **Automatic fetching**: Always attempt to fetch JIRA ticket when a reference is detected
- **Graceful degradation**: If acli is not installed or ticket fetch fails, proceed without JIRA context
- **Clear indication**: Note in the review when JIRA context was unavailable
- **Ticket patterns**: Support common conventional commit formats with ticket references

### Code Reviewer Agent
- **Comprehensive context**: Provide the agent with ALL relevant information (PR description, JIRA requirements, full diff)
- **Focus areas**: Highlight what aspects need special attention (e.g., security for auth changes)
- **Reference criteria**: Direct the agent to use `references/review_criteria.md` for evaluation standards
- **Structured output**: Request specific output format to ensure consistent reviews

### Review Quality
- **Specificity**: All findings should reference specific files and line numbers
- **Actionability**: Recommendations should be concrete and implementable
- **Balance**: Acknowledge positive aspects, not just problems
- **Categorization**: Use severity levels (Critical/Important/Suggestion) consistently
- **Context**: Consider the JIRA ticket requirements as the primary success criteria

### Performance
- **Parallel fetching**: Fetch PR data and JIRA ticket simultaneously when possible
- **Diff size**: For very large PRs (500+ changed lines), consider asking if user wants full review or focused review
- **Token efficiency**: The code-reviewer agent has full PR context, no need to duplicate in follow-up

### Error Handling
- **Missing PR**: If PR number not found, list open PRs to help user identify the right one
- **Private repos**: Ensure `gh` is authenticated with appropriate permissions
- **JIRA unavailable**: Gracefully handle when acli is not configured or ticket doesn't exist
- **Network issues**: Retry once on transient failures, then inform user

## Example Interactions

### Example 1: Review with PR Number

**User**: `/review-pr 123`

**Assistant**:
```
Fetching PR #123 details...
Found: feat(PROJ-456): Add user authentication

Detected JIRA ticket: PROJ-456
Fetching ticket requirements...

Preparing comprehensive review context...
Dispatching to code-reviewer agent...

[After agent completes]

I've completed a comprehensive review of PR #123. Here's my analysis:

[Displays formatted review with all sections]

The implementation looks solid overall with 1 critical security issue and 2 important improvements needed. Would you like me to post this review as a PR comment?
```

### Example 2: Review Current Branch

**User**: `/review-pr`

**Assistant**:
```
Checking for PR associated with current branch...

Found open PR #456 for branch 'feature/user-dashboard':
- Title: feat: Add user dashboard
- Author: @johndoe

Would you like me to review this PR?

[After confirmation, proceeds with standard review flow]
```

### Example 3: Review without JIRA Integration

**User**: `/review-pr https://github.com/owner/repo/pull/789`

**Assistant**:
```
Fetching PR #789 details...
Found: chore: Update dependencies

No JIRA ticket reference detected in PR title or description.
Proceeding with review based on PR context only...

[Continues with review focusing on code quality, testing, security]
```

## Resources

This skill uses a reference document for detailed review criteria:

### references/review_criteria.md

Comprehensive code review criteria organized by category:
- **Code Quality & Standards**: Readability, organization, error handling, testing, performance
- **Security**: Input validation, injection prevention, authentication, data protection, API security
- **Architecture & Design**: Design patterns, integration, scalability, data model
- **Alignment with Requirements**: Functional requirements, non-functional requirements, UX
- **Documentation**: Code documentation, external documentation

The code-reviewer agent uses this document to ensure consistent, thorough reviews across all PRs.

## Troubleshooting

### "gh: command not found"
Install GitHub CLI: `brew install gh` (macOS) or follow instructions at https://cli.github.com

### "acli: command not found"
JIRA integration will be skipped. To enable:
- Install Atlassian CLI and configure with your JIRA instance
- Or provide JIRA context manually

### "API rate limit exceeded"
GitHub API has rate limits. Wait or authenticate with `gh auth login` for higher limits.

### "Could not resolve to a PullRequest"
- Verify PR number exists
- Check you have access to the repository
- Ensure `gh` is authenticated for private repos

### Large PR Reviews
For PRs with 500+ changed lines:
- Review may take longer due to content volume
- Consider asking for focused review on specific aspects
- May need to review in smaller chunks

### Missing JIRA Ticket
If JIRA ticket referenced but not found:
- Verify ticket key format
- Check ticket exists and is accessible
- Proceed with review based on PR description
