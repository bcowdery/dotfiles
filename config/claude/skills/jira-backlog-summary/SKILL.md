---
name: jira-backlog-summary
description: This skill should be used when summarizing backlog tickets for sprint planning, when analyzing top tickets from a JIRA project, or when the user needs AI-powered sprint planning recommendations.
allowed-tools:
  - Bash
  - AskUserQuestion
---

# JIRA Backlog Summary Skill

## Overview

Fetch and analyze top backlog tickets from a JIRA project using the Atlassian CLI (`acli`), providing AI-powered sprint planning summaries with actionable recommendations.

## When to Use

Use this skill when:
- Preparing for sprint planning and need backlog analysis
- Summarizing top N tickets from a project backlog
- Identifying themes, patterns, or groupings in upcoming work
- Generating sprint scope recommendations based on team velocity

Do NOT use this skill for:
- Searching for specific tickets (use `jira-search` instead)
- Creating new tickets (use `jira-create` instead)
- Updating existing tickets (use `jira-update` instead)

## Quick Reference

```bash
# Fetch backlog tickets
acli jira workitem search \
  --jql "project = KEY AND status IN ('To Do', 'Backlog') ORDER BY rank ASC" \
  --limit 10 \
  --fields "key,summary,description,issuetype,priority,status,labels,assignee" \
  --json
```

## Step-by-Step Process

### 1. Gather Configuration

Collect from user:
- Project key (e.g., "PROJ", "ENG", "PLAT")
- Number of tickets to analyze (default: 10, max: 25)
- Optional filters: epic, component, or label

### 2. Build JQL Query

Base query:
```jql
project = KEY AND status IN ("To Do", "Backlog") ORDER BY rank ASC
```

Add filters if specified:
- Epic: `AND "Epic Link" = EPIC-123`
- Component: `AND component = "ComponentName"`
- Label: `AND labels = "label-name"`

### 3. Fetch Backlog Tickets

```bash
acli jira workitem search \
  --jql "project = PROJ AND status IN ('To Do', 'Backlog') ORDER BY rank ASC" \
  --limit 10 \
  --fields "key,summary,description,issuetype,priority,status,labels,assignee" \
  --json
```

### 4. Parse and Analyze

Extract for each ticket:
- Key, Summary, Issue type, Priority
- Story points (if available)
- Labels, Assignee, Epic link
- Description (first 500 chars)

### 5. Generate AI Analysis

Provide structured analysis covering:

**A. Executive Summary**
- Overall theme of upcoming work
- Key focus areas (e.g., "5 tickets focused on authentication")
- Notable patterns or concerns

**B. Ticket Groupings**
- Group by epic, component, or detected theme
- Show breakdown by category
- Identify related work to tackle together

**C. Complexity Distribution**
- Story point distribution
- Estimated total effort
- Balance of ticket types (Stories vs. Bugs vs. Tasks)

**D. Priority Analysis**
- High-priority items requiring immediate attention
- Dependencies between tickets
- Potential blockers

**E. Sprint Recommendations**
- Suggested ticket groupings for sprint
- Tickets that pair well together
- Large tickets that should be broken down
- Quick wins vs. complex work

### 6. Format Output

```markdown
# Sprint Planning Summary - [PROJECT] Backlog

## Executive Summary
[1-2 paragraphs describing overall state and focus areas]

## Ticket Breakdown (N tickets analyzed)

### By Theme
- **Authentication & Security** (4 tickets, 21 points)
  - PROJ-101: Implement JWT authentication (8 pts)
  - PROJ-102: Add password reset flow (5 pts)

### By Priority
- **High**: 3 tickets (15 points)
- **Medium**: 5 tickets (19 points)

### By Type
- Stories: 7 (34 points)
- Bugs: 2 (5 points)

## Sprint Recommendations

### Suggested Sprint Scope (if 20-point sprint)
1. PROJ-101 (8 pts) - Critical auth work
2. PROJ-102 (5 pts) - Builds on PROJ-101
3. PROJ-201 (5 pts) - Independent work
4. PROJ-305 (2 pts) - Quick win

**Total**: 20 points

### Consider for Next Sprint
- PROJ-203 (8 pts) - Needs design discussion
- PROJ-401 (13 pts) - Should be broken down

### Risks & Blockers
- PROJ-101 blocked by security review
- PROJ-305 has no clear acceptance criteria

## Detailed Tickets
[List of all tickets with key details]
```

## Common Mistakes

| Mistake | Solution |
|---------|----------|
| Not including `--fields` flag | Always specify fields to get descriptions and labels |
| Using wrong status values | Check project's actual status values (might be "Open", "New" instead of "To Do") |
| Analyzing too many tickets | Keep limit to 25 max for useful analysis |
| Missing story points | Acknowledge limitation and analyze based on priority, title complexity |
| Generic recommendations | Provide specific, actionable sprint planning advice based on actual data |

## acli Command Variations

### With Epic Filter
```bash
acli jira workitem search \
  --jql "project = PROJ AND status = 'To Do' AND 'Epic Link' = EPIC-123 ORDER BY rank ASC" \
  --limit 10 --json
```

### With Component Filter
```bash
acli jira workitem search \
  --jql "project = PROJ AND status = 'To Do' AND component = 'Backend' ORDER BY rank ASC" \
  --limit 10 --json
```

### Multi-Project
```bash
acli jira workitem search \
  --jql "project IN (PROJ1, PROJ2) AND status = 'To Do' ORDER BY rank ASC" \
  --limit 20 --json
```

## Analysis Guidelines

### Identify Themes
Look for patterns in:
- Ticket summaries (common keywords)
- Labels and components
- Epic groupings
- Related functionality

### Assess Complexity
Complex work indicators:
- High story point estimates
- Vague or incomplete descriptions
- Multiple dependencies
- Mentions of "research", "spike", "investigation"

### Spot Quick Wins
Quick win indicators:
- Low story points (1-2)
- Clear acceptance criteria
- Labels like "good-first-issue", "polish"
- Bug fixes with known root cause

### Flag Risks
Watch for:
- Blockers or dependencies
- Incomplete descriptions
- Missing acceptance criteria
- Work spanning multiple systems

## Troubleshooting

- **No story points**: Analyze based on title complexity, description length, priority
- **Empty backlog**: Check status values for this project
- **Custom fields**: Story points field ID varies by instance (typically customfield_10016)
