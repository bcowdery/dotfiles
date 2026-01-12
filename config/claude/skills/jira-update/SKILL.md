---
name: jira-update
description: This skill should be used when updating existing JIRA tickets, when adding comments or work notes, when transitioning ticket status, or when the user says "update ticket", "add comment", "move to in progress", etc.
allowed-tools:
  - Bash
  - AskUserQuestion
---

# JIRA Update Skill

## Overview

Update existing JIRA tickets using the Atlassian CLI (`acli`), supporting comments, field updates, and status transitions.

## When to Use

Use this skill when:
- Adding comments or work notes to a ticket
- Updating ticket fields (assignee, priority, labels, etc.)
- Transitioning ticket status (move to In Progress, Done, etc.)
- Making multiple updates to a single ticket

Do NOT use this skill for:
- Creating new tickets (use `jira-create` instead)
- Searching for tickets (use `jira-search` instead)
- Sprint planning or backlog analysis (use `jira-backlog-summary` instead)

## Quick Reference

```bash
# Add comment
acli jira workitem comment create \
  --key "KEY-123" \
  --body "Comment text"

# Update fields
acli jira workitem edit \
  --key "KEY-123" \
  --assignee "@me" \
  --labels "label1,label2"

# Transition status
acli jira workitem transition \
  --key "KEY-123" \
  --status "In Progress"
```

## Step-by-Step Process

### 1. Get Ticket Key

Extract ticket key from user input (e.g., "PROJ-123").
Validate format: `UPPERCASE-NUMBER` pattern.

### 2. Determine Update Type

Ask what to update:
- Add a comment/work note
- Update ticket fields
- Transition status
- Multiple updates at once

### 3. Gather Update Information

**For Comments:**
- Comment text (supports multi-line)

**For Field Updates:**
- Assignee (email or "@me")
- Priority (Highest, High, Medium, Low, Lowest)
- Labels (comma-separated)
- Summary (ticket title)
- Description

**For Status Transitions:**
- Target status (e.g., "In Progress", "Done", "Blocked")
- Optional comment with transition

### 4. Show Preview and Confirm

Display the command(s) before execution.

### 5. Execute Command(s)

Run the appropriate acli command(s).

### 6. Provide Summary

Show confirmation with link to ticket.

## Commands Reference

### Add Comment
```bash
acli jira workitem comment create \
  --key "KEY-123" \
  --body "Comment text here"
```

### Update Single Field
```bash
acli jira workitem edit \
  --key "KEY-123" \
  --assignee "user@example.com"
```

### Update Multiple Fields
```bash
acli jira workitem edit \
  --key "KEY-123" \
  --assignee "@me" \
  --labels "label1,label2" \
  --summary "Updated summary"
```

### Transition Status
```bash
acli jira workitem transition \
  --key "KEY-123" \
  --status "In Progress"
```

### Transition with Comment
```bash
# Run sequentially
acli jira workitem transition \
  --key "KEY-123" \
  --status "Done"

acli jira workitem comment create \
  --key "KEY-123" \
  --body "Completed and deployed to production"
```

### Remove Assignee
```bash
acli jira workitem edit \
  --key "KEY-123" \
  --remove-assignee
```

### Remove Labels
```bash
acli jira workitem edit \
  --key "KEY-123" \
  --remove-labels "label1,label2"
```

## Field Update Options

| Flag | Description |
|------|-------------|
| `--assignee "email"` | Assign to user |
| `--assignee "@me"` | Self-assign |
| `--remove-assignee` | Unassign ticket |
| `--labels "a,b,c"` | Set labels (comma-separated, no spaces) |
| `--remove-labels "a,b"` | Remove specific labels |
| `--summary "text"` | Update ticket title |
| `--description "text"` | Update description |
| `--description-file "path"` | Update description from file |
| `--type "Story"` | Change issue type |

## Natural Language Shortcuts

| User Says | Action |
|-----------|--------|
| "mark as done" | `--status "Done"` |
| "move to in progress" | `--status "In Progress"` |
| "assign to me" | `--assignee "@me"` |
| "unassign" | `--remove-assignee` |
| "add comment" | `comment create --body "..."` |
| "block ticket" | `--status "Blocked"` |

## Common Mistakes

| Mistake | Solution |
|---------|----------|
| Spaces in labels | Use comma-separated with no spaces: `"label1,label2"` |
| Wrong status name | Check available transitions for current status |
| Missing ticket key | Always validate KEY-123 format before making API calls |
| Forgetting confirmation | Always preview command before execution |
| Transition without comment | Offer to add a comment explaining the status change |

## Troubleshooting

- **"Issue does not exist"**: Verify ticket key is correct and accessible
- **"Field cannot be set"**: Field may not be editable or user lacks permission
- **"Transition not found"**: Status may not be available from current state
- **"Resolution is required"**: Some transitions (e.g., Done) require resolution field
- **Permission errors**: User may lack edit permission on this ticket

## Smart Features

- **Ticket Key Detection**: Extract ticket key from natural language (e.g., "update PROJ-123")
- **Batch Updates**: Support updating multiple tickets in sequence
- **Status Shortcuts**: Map common phrases to transitions:
  - "start" → In Progress
  - "done" / "complete" → Done
  - "block" → Blocked
  - "review" → In Review
