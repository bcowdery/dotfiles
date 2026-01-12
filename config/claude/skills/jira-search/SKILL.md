---
name: jira-search
description: Search JIRA tickets using JQL queries with smart filters and formatting
tools:
  - Bash
  - AskUserQuestion
---

# JIRA Search Skill

You are helping the user search for JIRA tickets using the Atlassian CLI (`acli`) with JQL (JIRA Query Language).

## Your Task

Execute JIRA searches based on user intent, using either predefined quick filters or custom JQL queries, and format results for readability.

## Step-by-Step Process

1. **Understand User Intent**:
   - Parse user's request to determine search type
   - Identify if they want a quick filter or custom search
   - Extract search parameters (assignee, status, project, labels, etc.)

2. **Choose Search Approach**:

   **Option A: Quick Filters** (common patterns)
   - My open tickets
   - My tickets in review
   - Blocked tickets
   - High priority bugs
   - Recent updates
   - Unassigned tickets
   - Tickets assigned to specific user
   - Tickets in specific sprint

   **Option B: Custom JQL**
   - User provides explicit JQL query
   - Or you construct JQL from natural language

3. **Build JQL Query**:

   Follow JQL syntax:
   ```jql
   project = KEY AND status = "In Progress" AND assignee = currentUser()
   ```

   Common JQL patterns:
   - `project = KEY`
   - `status IN ("To Do", "In Progress", "Done")`
   - `assignee = currentUser()` or `assignee = "user@email.com"`
   - `priority IN (High, Highest)`
   - `labels = "label-name"`
   - `updated >= -7d` (updated in last 7 days)
   - `created >= -30d` (created in last 30 days)
   - `text ~ "search phrase"` (text search)
   - `status = Blocked OR labels = "blocked"`
   - `sprint = "Sprint Name"`
   - `"Epic Link" = EPIC-123`

4. **Execute Search**:
   ```bash
   acli jira workitem search \
     --jql "YOUR JQL QUERY HERE" \
     --limit 50
   ```

   Add `--json` for programmatic parsing or omit for human-readable table output.

5. **Format Results** - Present in clear, scannable format:

   **Compact Format** (for 5+ results):
   ```
   Found 12 tickets matching your search:

   PROJ-101  [Story] [High] Implement JWT authentication
             Assignee: user@example.com | Status: In Progress
             https://your-domain.atlassian.net/browse/PROJ-101

   PROJ-102  [Bug] [Highest] Login page crashes on mobile
             Assignee: Unassigned | Status: To Do
             https://your-domain.atlassian.net/browse/PROJ-102

   [... continue for all results ...]
   ```

   **Detailed Format** (for 1-4 results):
   ```
   Found 2 tickets:

   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   PROJ-101: Implement JWT authentication
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   Type: Story | Priority: High | Status: In Progress
   Assignee: user@example.com
   Labels: authentication, backend, security
   Story Points: 8

   Description:
   Implement JWT-based authentication for the REST API...

   Link: https://your-domain.atlassian.net/browse/PROJ-101
   ```

6. **Provide Summary**:
   - Total count of results
   - Breakdown by status, priority, or type if relevant
   - Suggest refinements if too many/few results

## Quick Filter Examples

### My Open Tickets
```jql
assignee = currentUser() AND status NOT IN (Done, Closed, Resolved)
```

### My Tickets In Review
```jql
assignee = currentUser() AND status IN ("In Review", "Code Review", "PR Review")
```

### Blocked Tickets
```jql
status = Blocked OR labels = "blocked"
```

### High Priority Bugs
```jql
type = Bug AND priority IN (High, Highest) AND status != Done
```

### Recently Updated (Last 7 Days)
```jql
updated >= -7d ORDER BY updated DESC
```

### Unassigned in Project
```jql
project = KEY AND assignee is EMPTY AND status != Done
```

### Current Sprint
```jql
sprint in openSprints() AND project = KEY
```

### Tickets Assigned to Someone Else
```jql
assignee = "user@email.com" AND status != Done
```

## Example Interactions

### Example 1: Quick Filter

**User**: `/jira-search my open tickets`

**Assistant**: Searching for your open tickets...

*[Executes: `assignee = currentUser() AND status NOT IN (Done, Closed, Resolved)`]*

**Assistant**: Found 7 open tickets assigned to you:

[Formatted results...]

### Example 2: Custom Search

**User**: `/jira-search high priority bugs in PLAT project`

**Assistant**: Searching for high priority bugs in PLAT...

*[Executes: `project = PLAT AND type = Bug AND priority IN (High, Highest) AND status != Done`]*

**Assistant**: Found 3 high priority bugs:

[Formatted results...]

### Example 3: Natural Language to JQL

**User**: `/jira-search tickets updated in the last week that are blocked`

**Assistant**: Searching for blocked tickets updated recently...

*[Executes: `updated >= -7d AND (status = Blocked OR labels = "blocked") ORDER BY updated DESC`]*

**Assistant**: Found 2 blocked tickets updated in the last 7 days:

[Formatted results...]

### Example 4: Explicit JQL

**User**: `/jira-search --jql "project = PLAT AND sprint = 'Sprint 42'"`

**Assistant**: Executing custom JQL search...

*[Executes provided JQL]*

**Assistant**: Found 15 tickets in Sprint 42:

[Formatted results...]

## Important Notes

- **JQL Validation**: Basic validation of JQL syntax before execution
- **Result Limits**: Default to 50 results, adjust if user wants more
- **Empty Results**: If no results found, suggest query refinements
- **Too Many Results**: If 50+ results, suggest adding filters
- **Natural Language**: Parse user intent and construct appropriate JQL
- **Quick Access**: Recognize common phrases and map to predefined queries

## acli Command Reference

### Basic Search
```bash
acli jira workitem search \
  --jql "project = KEY AND status = 'In Progress'" \
  --limit 50
```

### With Sorting
```bash
acli jira workitem search \
  --jql "assignee = currentUser() ORDER BY priority DESC, created DESC" \
  --limit 50
```

### Text Search
```bash
acli jira workitem search \
  --jql "text ~ 'authentication' AND project = KEY" \
  --limit 50
```

### Complex Query
```bash
acli jira workitem search \
  --jql "project = KEY AND (status = 'To Do' OR status = 'In Progress') AND (priority = High OR labels = 'urgent') ORDER BY rank ASC" \
  --limit 50
```

### With Specific Fields (JSON output)
```bash
acli jira workitem search \
  --jql "project = KEY" \
  --fields "key,summary,description,status,assignee" \
  --json
```

### Using Saved Filter
```bash
acli jira workitem search \
  --filter 10001 \
  --limit 50
```

## Natural Language Mapping

Map common user phrases to JQL:

| User Says | JQL Translation |
|-----------|----------------|
| "my tickets" | `assignee = currentUser()` |
| "my open tickets" | `assignee = currentUser() AND status NOT IN (Done, Closed)` |
| "blocked tickets" | `status = Blocked OR labels = "blocked"` |
| "high priority" | `priority IN (High, Highest)` |
| "bugs" | `type = Bug` |
| "in review" | `status IN ("In Review", "Code Review", "PR Review")` |
| "unassigned" | `assignee is EMPTY` |
| "updated this week" | `updated >= -7d` |
| "created today" | `created >= startOfDay()` |
| "overdue" | `duedate < now() AND status != Done` |

## Predefined Quick Searches

Offer these as shortcuts:

1. **mine** - My open tickets
2. **review** - My tickets in review
3. **blocked** - All blocked tickets
4. **urgent** - High priority items
5. **recent** - Updated in last 7 days
6. **unassigned** - Unassigned tickets in my projects
7. **sprint** - Current sprint tickets
8. **bugs** - Open bugs

Usage: `/jira-search mine` or `/jira-search blocked`

## Output Formatting Tips

### For Many Results (10+)
- Use compact format
- Show key info only (key, type, priority, summary)
- Group by status or priority if helpful
- Provide summary statistics

### For Few Results (1-9)
- Use detailed format
- Show descriptions (truncated if long)
- Include all relevant fields
- Make it easy to pick which ticket to work on

### For Empty Results
- Confirm the query that was executed
- Suggest modifications:
  - Widen status filter
  - Remove date constraints
  - Check project key
  - Verify assignee

## Advanced Features

### Search History
Track recent searches (optional):
- Store last 5 JQL queries
- Allow quick re-run: `/jira-search --last`

### Saved Searches
Allow naming and saving frequent searches:
- Save: `/jira-search --save "my-filter" "assignee = currentUser() AND ..."`
- Use: `/jira-search --saved "my-filter"`

### Export Results
Offer to export to formats:
- Markdown table
- CSV
- JSON

### Interactive Refinement
If too many results:
- Suggest adding filters
- Ask which refinement to add (status, priority, date range)

## Troubleshooting

- **JQL syntax errors**: Parse acli error and suggest correction
- **Unknown fields**: Suggest correct field names
- **Invalid values**: List valid values for enums (status, priority)
- **Permission errors**: Explain user may not have access to certain projects
- **Too many results**: Auto-truncate and suggest filters

## JQL Syntax Quick Reference

**Operators**:
- `=`, `!=`, `>`, `>=`, `<`, `<=`
- `IN (val1, val2)`
- `NOT IN (val1, val2)`
- `~ "text search"`
- `IS EMPTY`, `IS NOT EMPTY`

**Logical**:
- `AND`
- `OR`
- `NOT`

**Functions**:
- `currentUser()`
- `now()`
- `startOfDay()`, `endOfDay()`
- `startOfWeek()`, `endOfWeek()`
- `openSprints()`

**Date Ranges**:
- `-7d` (7 days ago)
- `-2w` (2 weeks ago)
- `-1M` (1 month ago)

**Sorting**:
- `ORDER BY priority DESC`
- `ORDER BY created ASC`
- `ORDER BY rank ASC` (backlog order)
