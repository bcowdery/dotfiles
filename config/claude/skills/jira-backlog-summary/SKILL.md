---
name: jira-backlog-summary
description: Summarize top backlog tickets for sprint planning using AI analysis
tools:
  - Bash
  - AskUserQuestion
---

# JIRA Backlog Summary Skill

You are helping the user understand and plan their sprint by analyzing top backlog tickets using the Atlassian CLI (`acli`) and AI-powered summarization.

## Your Task

Fetch the top N tickets from the project backlog, analyze them using your AI capabilities, and provide an actionable sprint planning summary.

## Step-by-Step Process

1. **Gather Configuration**:
   - Ask for project key (e.g., "PROJ")
   - Ask how many tickets to analyze (default: 10, max: 25)
   - Optional: Filter criteria (epic, component, label)

2. **Build JQL Query**:
   ```
   project = KEY AND status IN ("To Do", "Backlog") ORDER BY rank ASC
   ```

   Add filters if specified:
   - Epic: `AND "Epic Link" = EPIC-123`
   - Component: `AND component = "ComponentName"`
   - Label: `AND labels = "label-name"`

3. **Fetch Backlog Tickets**:
   ```bash
   acli jira workitem search \
     --jql "project = KEY AND status IN ('To Do', 'Backlog') ORDER BY rank ASC" \
     --limit 10 \
     --json
   ```

4. **Parse Response** - Extract for each ticket:
   - Key (e.g., PROJ-123)
   - Summary (title)
   - Issue type (Story, Bug, Task, Epic)
   - Priority
   - Story points (if available)
   - Labels
   - Assignee (if any)
   - Epic link (parent epic)
   - Description (first 500 chars)

5. **AI Analysis** - Analyze the tickets and provide:

   **A. Executive Summary**:
   - Overall theme of upcoming work
   - Key areas of focus (e.g., "5 tickets focused on authentication, 3 on API improvements")
   - Notable patterns or concerns

   **B. Ticket Groupings**:
   - Group tickets by epic, component, or theme
   - Show breakdown by category
   - Identify related work that should be tackled together

   **C. Complexity Distribution**:
   - Story point distribution (if available)
   - Estimated total effort
   - Balance of ticket types (Stories vs. Bugs vs. Tasks)

   **D. Priority Analysis**:
   - High-priority items requiring immediate attention
   - Dependencies between tickets
   - Potential blockers

   **E. Sprint Planning Recommendations**:
   - Suggested ticket groupings for the sprint
   - Tickets that pair well together
   - Tickets that might be too large (should be broken down)
   - Quick wins vs. complex work

6. **Format Output** - Present in clear, scannable format:
   ```
   # Sprint Planning Summary - [PROJECT] Backlog

   ## Executive Summary
   [1-2 paragraphs describing the overall state and focus areas]

   ## Ticket Breakdown (10 tickets analyzed)

   ### By Theme
   - **Authentication & Security** (4 tickets, 21 points)
     - PROJ-101: Implement JWT authentication (8 pts)
     - PROJ-102: Add password reset flow (5 pts)
     - ...

   - **API Improvements** (3 tickets, 13 points)
     - PROJ-201: Add rate limiting (5 pts)
     - ...

   ### By Priority
   - **High**: 3 tickets (15 points)
   - **Medium**: 5 tickets (19 points)
   - **Low**: 2 tickets (8 points)

   ### By Type
   - Stories: 7 (34 points)
   - Bugs: 2 (5 points)
   - Tasks: 1 (3 points)

   ## Sprint Recommendations

   ### Suggested Sprint Scope (if 20-point sprint)
   1. PROJ-101 (8 pts) - Critical auth work, foundational
   2. PROJ-102 (5 pts) - Builds on PROJ-101
   3. PROJ-201 (5 pts) - Independent, can run in parallel
   4. PROJ-305 (2 pts) - Quick win, polish work

   **Total**: 20 points

   ### Consider for Next Sprint
   - PROJ-203 (8 pts) - Complex, needs design discussion
   - PROJ-401 (13 pts) - Large ticket, should be broken down

   ### Risks & Blockers
   - PROJ-101 blocked by security review
   - PROJ-305 has no clear acceptance criteria

   ## Detailed Tickets

   [List of all tickets with key details]
   ```

## Example Interaction

**User**: `/jira-backlog-summary`

**Assistant**: I'll analyze your backlog for sprint planning. What project should I look at?

**User**: PLAT

**Assistant**: How many tickets should I analyze? (default: 10)

**User**: 15

**Assistant**: Fetching top 15 tickets from PLAT backlog...

*[Executes acli command]*

**Assistant**: [Provides full analysis as described above]

## Important Notes

- **AI-Powered Analysis**: This skill leverages your natural language understanding to identify patterns, themes, and relationships
- **Context Matters**: Consider story points, priorities, and dependencies in your analysis
- **Actionable Output**: Focus on sprint planning utility, not just data presentation
- **Story Points**: If story points aren't available, note this and focus on other signals (priority, complexity from description)
- **Flexible Grouping**: Intelligently group by epics, components, or themes you detect in summaries/descriptions
- **Real Recommendations**: Provide specific, actionable sprint planning advice based on the data

## acli Command Reference

### Get Backlog Tickets
```bash
acli jira workitem search \
  --jql "project = PROJ AND status IN ('To Do', 'Backlog') ORDER BY rank ASC" \
  --limit 10 \
  --json
```

### With Epic Filter
```bash
acli jira workitem search \
  --jql "project = PROJ AND status = 'To Do' AND 'Epic Link' = EPIC-123 ORDER BY rank ASC" \
  --limit 10 \
  --json
```

### With Component Filter
```bash
acli jira workitem search \
  --jql "project = PROJ AND status = 'To Do' AND component = 'Backend' ORDER BY rank ASC" \
  --limit 10 \
  --json
```

### With Label Filter
```bash
acli jira workitem search \
  --jql "project = PROJ AND status = 'To Do' AND labels = 'Q1-priority' ORDER BY rank ASC" \
  --limit 10 \
  --json
```

### Get Full Ticket Details with Specific Fields
```bash
acli jira workitem search \
  --jql "project = PROJ AND status = 'To Do' ORDER BY rank ASC" \
  --limit 10 \
  --fields "key,summary,description,issuetype,priority,status,labels,assignee" \
  --json
```

## Parsing acli Output

The `--json` flag returns detailed data. Parse the response to extract:

```json
{
  "key": "PROJ-123",
  "fields": {
    "summary": "Ticket title",
    "description": "Full description...",
    "issuetype": {"name": "Story"},
    "priority": {"name": "High"},
    "assignee": {"emailAddress": "user@example.com"},
    "labels": ["backend", "api"],
    "status": {"name": "To Do"}
  }
}
```

Note: The default `--fields` includes: `issuetype,key,assignee,priority,status,summary`
To get descriptions and labels, use: `--fields "key,summary,description,issuetype,priority,status,labels,assignee"`

## Analysis Guidelines

### Identify Themes
Look for patterns in:
- Ticket summaries (common keywords)
- Labels
- Components
- Epic groupings
- Related functionality

### Assess Complexity
Indicators of complex work:
- High story point estimates
- Vague or incomplete descriptions
- Multiple dependencies
- Mentions of "research", "spike", "investigation"

### Spot Quick Wins
Indicators of quick wins:
- Low story points (1-2)
- Clear acceptance criteria
- Labels like "good-first-issue", "polish"
- Bug fixes with known root cause

### Flag Risks
Watch for:
- Blockers or dependencies
- Incomplete descriptions
- Missing acceptance criteria
- Unclear requirements
- Work that spans multiple systems

### Sprint Scope Calculation
If the user mentions their team velocity:
- Suggest realistic sprint scope
- Balance complex and simple work
- Include buffer (don't fill 100% of capacity)
- Group related work together

## Advanced Features

### Multi-Project Support
If user wants to analyze multiple projects:
```bash
acli jira workitem search \
  --jql "project IN (PROJ1, PROJ2) AND status = 'To Do' ORDER BY rank ASC" \
  --limit 20 \
  --json
```

### Compare to Previous Sprint
If user provides previous sprint name:
```bash
acli jira workitem search \
  --jql "sprint = 'Sprint 42'" \
  --json
```

Analyze:
- What was completed vs. committed
- Carry-over work in current backlog
- Velocity trends

### Epic Health Check
If tickets belong to epics, analyze epic progress:
- How many tickets remain in epic
- Estimated vs. completed work
- Timeline concerns

## Troubleshooting

- **No story points**: Acknowledge limitation and analyze based on other signals (title complexity, description length, priority)
- **Empty backlog**: Check if status values are correct for this project (might use "Backlog", "Open", "New" instead of "To Do")
- **Custom field IDs**: Story points field ID varies by instance (typically customfield_10016, but may differ)
- **Rank field**: Some instances use different ranking fields; JQL should still work with ORDER BY rank

## User Experience Tips

- **Visual Hierarchy**: Use markdown formatting (headers, lists, bold) for scannability
- **Concise**: Keep executive summary brief (2-3 paragraphs max)
- **Actionable**: Every section should help with sprint planning decisions
- **Balanced**: Show both opportunities (quick wins) and risks (blockers)
- **Context-Aware**: If user asks for 5 tickets, provide proportionally lighter analysis than for 25 tickets
