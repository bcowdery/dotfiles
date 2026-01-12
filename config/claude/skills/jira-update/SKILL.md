---
name: jira-update
description: Add comments and update JIRA ticket fields using the Atlassian CLI
tools:
  - Bash
  - AskUserQuestion
---

# JIRA Update Skill

You are helping the user update an existing JIRA ticket using the Atlassian CLI (`acli`).

## Your Task

Guide the user through updating a JIRA ticket by adding comments, updating fields, or transitioning status.

## Step-by-Step Process

1. **Get Ticket Key** - Ask for the JIRA ticket key (e.g., "PROJ-123")
   - Validate format: UPPERCASE-NUMBER pattern

2. **Determine Update Type** - Use AskUserQuestion to ask what they want to do:
   - Add a comment/work note
   - Update ticket fields (assignee, priority, labels, etc.)
   - Transition status (move to In Progress, Done, etc.)
   - Multiple updates at once

3. **Gather Update Information** based on type:

   **For Comments**:
   - Comment text (support multi-line input)
   - Optional: Make comment internal/restricted

   **For Field Updates**:
   - Which field(s) to update:
     - Assignee (email or "currentUser()")
     - Priority (Highest, High, Medium, Low, Lowest)
     - Labels (add or replace)
     - Summary (ticket title)
     - Description
     - Story points (custom field)
     - Components

   **For Status Transitions**:
   - Fetch available transitions for current status
   - Ask which transition to make
   - Optional: Add comment with transition

4. **Build acli Command(s)**:

   **Add Comment**:
   ```bash
   acli jira workitem comment create \
     --key "KEY-123" \
     --body "Work in progress. Implemented authentication module."
   ```

   **Update Fields**:
   ```bash
   acli jira workitem edit \
     --key "KEY-123" \
     --assignee "user@example.com" \
     --labels "backend,security"
   ```

   **Transition Status**:
   ```bash
   acli jira workitem transition \
     --key "KEY-123" \
     --status "In Progress"
   ```

   **Combined Update** (comment + field update):
   ```bash
   # First update fields
   acli jira workitem edit --key "KEY-123" --assignee "@me"

   # Then add comment
   acli jira workitem comment create --key "KEY-123" --body "Taking ownership of this ticket"
   ```

5. **Show Preview** - Display the command(s) you'll execute and ask for confirmation

6. **Execute Command(s)** - Run the acli command(s) using the Bash tool

7. **Provide Summary** - Show the user:
   - What was updated
   - Link to ticket: `https://your-domain.atlassian.net/browse/KEY-123`
   - Confirmation of changes

## Example Interaction Flows

### Example 1: Add Work Note

**User**: `/jira-update`

**Assistant**: I'll help you update a JIRA ticket. What's the ticket key? (e.g., PROJ-123)

**User**: PROJ-456

**Assistant**: What would you like to do with PROJ-456?
- Add a comment/work note
- Update ticket fields
- Transition status

**User**: Add a comment

**Assistant**: What comment would you like to add?

**User**: Completed API integration. Ready for testing.

**Assistant**: I'll add this comment to PROJ-456:
```bash
acli jira workitem comment create \
  --key "PROJ-456" \
  --body "Completed API integration. Ready for testing."
```

Proceed?

*[After confirmation, executes command]*

**Assistant**: ✓ Comment added successfully to PROJ-456
- **Link**: https://your-domain.atlassian.net/browse/PROJ-456

### Example 2: Update Multiple Fields

**User**: `/jira-update PROJ-789` (can provide ticket key inline)

**Assistant**: What would you like to update on PROJ-789?

**User**: Change assignee to me and set priority to High

**Assistant**: I'll update PROJ-789:
```bash
acli jira workitem edit \
  --key "PROJ-789" \
  --assignee "@me"
```

Proceed?

*[After confirmation, executes command]*

**Assistant**: ✓ Ticket updated successfully
- **Assignee**: Changed to current user
- **Link**: https://your-domain.atlassian.net/browse/PROJ-789

### Example 3: Transition with Comment

**User**: `/jira-update PROJ-123 move to in progress`

**Assistant**: I'll transition PROJ-123 to "In Progress". Would you like to add a comment?

**User**: Yes - "Starting work on this today"

**Assistant**: I'll transition PROJ-123 and add a comment:
```bash
# Transition status
acli jira workitem transition \
  --key "PROJ-123" \
  --status "In Progress"

# Add comment
acli jira workitem comment create \
  --key "PROJ-123" \
  --body "Starting work on this today"
```

Proceed?

*[After confirmation, executes command]*

**Assistant**: ✓ Ticket transitioned successfully
- **Status**: In Progress
- **Comment**: Added
- **Link**: https://your-domain.atlassian.net/browse/PROJ-123

## Important Notes

- **Validation**: Always validate ticket key format before making API calls
- **Current Status**: For transitions, optionally fetch current status first to show available transitions
- **Bulk Updates**: If updating multiple fields, use single `updateIssue` call when possible
- **Error Handling**: Parse acli errors and provide helpful guidance
- **Permissions**: User must have edit permission on the ticket

## acli Command Reference

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

### Transition Issue
```bash
acli jira workitem transition \
  --key "KEY-123" \
  --status "In Progress"
```

### Transition with Comment (separate commands)
```bash
# First transition
acli jira workitem transition \
  --key "KEY-123" \
  --status "Done"

# Then add comment
acli jira workitem comment create \
  --key "KEY-123" \
  --body "Completed and deployed to production"
```

### Clear Labels
```bash
acli jira workitem edit \
  --key "KEY-123" \
  --remove-labels "label1,label2"
```

### Remove Assignee
```bash
acli jira workitem edit \
  --key "KEY-123" \
  --remove-assignee
```

## Field Update Options

Common fields that can be updated:
- `--assignee "user@email.com"` or `--assignee "@me"` for self-assign
- `--labels "label1,label2"` (comma-separated, no spaces)
- `--summary "New ticket title"`
- `--description "Updated description"` or `--description-file "file.md"`
- `--type "Story"` (change issue type)
- `--remove-assignee` (unassign ticket)
- `--remove-labels "label1,label2"` (remove specific labels)

## Troubleshooting

- **"Issue does not exist"**: Verify ticket key is correct and accessible
- **"Field cannot be set"**: Field may not be editable or user lacks permission
- **"Transition not found"**: Use `getTransitionList` to see available transitions
- **"Resolution is required"**: Some transitions require setting resolution field
- **Permission errors**: User may lack edit permission on this ticket

## Smart Features

- **Ticket Key Detection**: If user provides ticket key in the message (e.g., "update PROJ-123"), extract it automatically
- **Natural Language**: Parse user intent from natural language (e.g., "mark PROJ-123 as done" → transition to Done)
- **Batch Updates**: If user wants to update multiple tickets, loop through them
- **Status Shortcuts**: Common phrases like "move to in progress", "mark as done" map to transitions
