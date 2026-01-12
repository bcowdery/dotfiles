---
name: jira-search
description: This skill should be used when searching for JIRA tickets using JQL queries, when finding tickets by status, assignee, or other criteria, or when the user says "find tickets", "search JIRA", "my open tickets", etc.
allowed-tools:
  - Bash
  - AskUserQuestion
---

# JIRA Search Skill

## Overview

Search for JIRA tickets using JQL (JIRA Query Language) via the Atlassian CLI (`acli`), supporting both predefined quick filters and custom queries with formatted results.

## When to Use

Use this skill when:
- Searching for tickets by any criteria (status, assignee, labels, etc.)
- Using quick filters like "my open tickets", "blocked tickets", "bugs"
- Building custom JQL queries
- Listing tickets from a sprint, epic, or project

Do NOT use this skill for:
- Creating new tickets (use `jira-create` instead)
- Updating existing tickets (use `jira-update` instead)
- Sprint planning analysis (use `jira-backlog-summary` instead)

## Quick Reference

### Quick Filters

| Shortcut | JQL |
|----------|-----|
| `mine` | `assignee = currentUser() AND status NOT IN (Done, Closed)` |
| `review` | `assignee = currentUser() AND status IN ("In Review", "Code Review")` |
| `blocked` | `status = Blocked OR labels = "blocked"` |
| `urgent` | `priority IN (High, Highest) AND status != Done` |
| `bugs` | `type = Bug AND status != Done` |
| `recent` | `updated >= -7d ORDER BY updated DESC` |
| `unassigned` | `assignee is EMPTY AND status != Done` |
| `sprint` | `sprint in openSprints()` |

### Basic Command

```bash
acli jira workitem search \
  --jql "YOUR JQL QUERY" \
  --limit 50
```

## Step-by-Step Process

### 1. Understand User Intent

Parse the request to determine:
- Quick filter or custom search?
- Search parameters: assignee, status, project, labels, etc.

### 2. Build JQL Query

**Natural Language Mapping:**

| User Says | JQL |
|-----------|-----|
| "my tickets" | `assignee = currentUser()` |
| "high priority" | `priority IN (High, Highest)` |
| "bugs" | `type = Bug` |
| "in review" | `status IN ("In Review", "Code Review")` |
| "unassigned" | `assignee is EMPTY` |
| "updated this week" | `updated >= -7d` |
| "created today" | `created >= startOfDay()` |
| "overdue" | `duedate < now() AND status != Done` |

**Combine conditions:**
```jql
project = KEY AND status = "In Progress" AND assignee = currentUser()
```

### 3. Execute Search

```bash
acli jira workitem search \
  --jql "assignee = currentUser() AND status NOT IN (Done, Closed)" \
  --limit 50
```

Add `--json` for programmatic parsing or omit for table output.

### 4. Format Results

**Compact format** (5+ results):
```
Found 12 tickets:

PROJ-101  [Story] [High] Implement JWT authentication
          Assignee: user@example.com | Status: In Progress

PROJ-102  [Bug] [Highest] Login page crashes on mobile
          Assignee: Unassigned | Status: To Do
```

**Detailed format** (1-4 results):
```
PROJ-101: Implement JWT authentication
Type: Story | Priority: High | Status: In Progress
Assignee: user@example.com
Labels: authentication, backend
Description: Implement JWT-based authentication...
Link: https://your-domain.atlassian.net/browse/PROJ-101
```

### 5. Provide Summary

- Total count and breakdown by status/priority if relevant
- Suggest refinements if too many (50+) or no results

## JQL Syntax Reference

### Operators
- Comparison: `=`, `!=`, `>`, `>=`, `<`, `<=`
- Lists: `IN (val1, val2)`, `NOT IN (val1, val2)`
- Text: `~ "search phrase"`
- Empty: `IS EMPTY`, `IS NOT EMPTY`

### Logical
- `AND`, `OR`, `NOT`

### Functions
- `currentUser()` - Logged in user
- `now()` - Current time
- `startOfDay()`, `endOfDay()`
- `startOfWeek()`, `endOfWeek()`
- `openSprints()` - Active sprints

### Date Ranges
- `-7d` (7 days ago)
- `-2w` (2 weeks ago)
- `-1M` (1 month ago)

### Sorting
```jql
ORDER BY priority DESC, created DESC
ORDER BY rank ASC  -- backlog order
```

## Common JQL Patterns

### My Open Tickets
```jql
assignee = currentUser() AND status NOT IN (Done, Closed, Resolved)
```

### High Priority Bugs
```jql
type = Bug AND priority IN (High, Highest) AND status != Done
```

### Current Sprint
```jql
sprint in openSprints() AND project = KEY
```

### Recently Updated
```jql
updated >= -7d ORDER BY updated DESC
```

### Text Search
```jql
text ~ "authentication" AND project = KEY
```

### Tickets by Epic
```jql
"Epic Link" = EPIC-123 ORDER BY rank ASC
```

## Command Variations

### With Specific Fields (JSON)
```bash
acli jira workitem search \
  --jql "project = KEY" \
  --fields "key,summary,status,assignee" \
  --json
```

### With Sorting
```bash
acli jira workitem search \
  --jql "assignee = currentUser() ORDER BY priority DESC, created DESC" \
  --limit 50
```

### Complex Query
```bash
acli jira workitem search \
  --jql "project = KEY AND (status = 'To Do' OR status = 'In Progress') AND (priority = High OR labels = 'urgent') ORDER BY rank ASC" \
  --limit 50
```

## Common Mistakes

| Mistake | Solution |
|---------|----------|
| No result limit | Always include `--limit` to avoid huge result sets |
| Wrong status names | Check project's actual status values (might be "Open" not "To Do") |
| Forgetting quotes | Multi-word status values need quotes: `status = "In Progress"` |
| Case sensitivity | Field values are case-sensitive in some instances |
| Empty results confusion | Suggest widening filters or checking project key |

## Troubleshooting

- **JQL syntax errors**: Check operator usage, quotes, field names
- **Unknown fields**: Use standard field names or check custom field IDs
- **Invalid values**: Status, priority values vary by project configuration
- **Permission errors**: User may not have access to some projects
- **Too many results**: Add filters or reduce limit
