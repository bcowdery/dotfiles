---
name: jira-create
description: Create new JIRA tickets interactively using the Atlassian CLI
tools:
  - Bash
  - Read
  - AskUserQuestion
---

# JIRA Create Skill

You are helping the user create a new JIRA ticket using the Atlassian CLI (`acli`).

## Your Task

Guide the user through creating a JIRA ticket by gathering required information and executing the appropriate `acli` command.

## Step-by-Step Process

1. **Read the Issue Template** - First, read the `issue_template.md` file in this skill directory to understand the expected ticket structure

2. **Gather Required Information** - Use AskUserQuestion to collect:
   - Project key (e.g., "PROJ", "ENG", "PLAT")
   - Issue type (Story, Bug, Task, Epic, etc.)
   - Summary (ticket title - concise, action-oriented)

3. **Gather Description Components** - For the description, collect information for each template section:

   **For Stories**:
   - **User Story**: Who is the user, what do they want, and why?
   - **Context**: High-level overview and desired outcome
   - **Acceptance Criteria**: Requirements using RFC 2119 language (MUST, SHOULD, MAY)
   - **Implementation Details**: Technical suggestions (optional)
   - **Out of Scope**: Explicit scope boundaries (optional)
   - **Resources**: Links to relevant documentation (optional)

   **For Bugs**:
   - **Context**: What's broken and the impact
   - **Steps to Reproduce**: How to trigger the bug
   - **Expected Behavior**: What should happen
   - **Actual Behavior**: What actually happens
   - **Additional Information**: Environment, logs, screenshots

   **For Tasks**:
   - **Context**: What needs to be done and why
   - **Acceptance Criteria**: Success criteria
   - **Technical Details**: Approach or requirements (optional)

4. **Gather Optional Information** - Ask if the user wants to specify:
   - Assignee (email address or "currentUser()")
   - Priority (Highest, High, Medium, Low, Lowest)
   - Labels (comma-separated list)
   - Epic link (parent epic key, if applicable)
   - Components (comma-separated list)
   - Story points (for Stories)

5. **Format Description** - Build the description using the template structure:
   - For Stories, use the full template with all sections
   - For Bugs/Tasks, adapt the template to fit the issue type
   - Include only sections with content (omit empty optional sections)
   - Preserve emoji markers for visual hierarchy
   - Format acceptance criteria as checkboxes

6. **Validate Input**:
   - Project key should be uppercase alphanumeric (e.g., "PROJ")
   - Issue type should match JIRA instance types
   - Summary should be concise (< 255 characters)
   - If epic link provided, validate format (KEY-123)
   - Description should follow template structure

7. **Build acli Command**:
   ```bash
   acli jira workitem create \
     --project "PROJECT_KEY" \
     --type "Issue Type" \
     --summary "Ticket summary" \
     --description "Detailed description"
   ```

   **Add optional parameters if provided**:
   - `--assignee "user@email.com"` or `--assignee "@me"` (for self-assign)
   - `--label "label1,label2,label3"` (comma-separated, no spaces)
   - `--parent "EPIC-123"` (for parent epic)

8. **Show Preview** - Display the formatted description and command you'll execute, ask for confirmation

9. **Execute Command** - Run the acli command using the Bash tool

10. **Parse Response** - Extract the created ticket key from the output

11. **Provide Summary** - Show the user:
    - Created ticket key (e.g., "PROJ-123")
    - Direct link to ticket: `https://your-domain.atlassian.net/browse/PROJ-123`
    - Summary of what was created

## Example Interaction Flow

**User**: `/jira-create`

**Assistant**: I'll help you create a JIRA ticket. Let me gather the necessary information.

*[Reads issue_template.md to understand structure]*

**Assistant**: What project should this ticket be in? (e.g., PROJ, ENG, PLAT)

**User**: PROJ

**Assistant**: What type of issue? (Story, Bug, Task, Epic)

**User**: Story

**Assistant**: What's the ticket summary? (concise, action-oriented title)

**User**: Add user authentication system

**Assistant**: Now let me gather the details for the description.

**For the User Story**: Who is the user, what do they want, and why?

**User**: As a user I want to securely log in with my credentials because I need to access protected features

**Assistant**: What's the high-level context? Why is this work necessary?

**User**: We need to implement authentication to protect user data and enable role-based access control. Currently the app has no security layer.

**Assistant**: What are the acceptance criteria? (I'll format these with checkboxes and RFC 2119 language)

**User**:
- Must support email/password authentication
- Should use JWT tokens for session management
- Must hash passwords with bcrypt
- Should have password reset flow

**Assistant**: Any implementation details or technical suggestions?

**User**: Use Passport.js for the authentication middleware. Store tokens in httpOnly cookies.

**Assistant**: Anything explicitly out of scope?

**User**: Social auth (Google, GitHub) is out of scope for this ticket

**Assistant**: Would you like to specify optional fields like assignee, priority, labels, or story points?

**User**: Assign to me, high priority, 8 story points, labels: security, backend

**Assistant**: I'm ready to create this ticket with the following description:

```markdown
# 🗣️ User Story

As a user I want to securely log in with my credentials because I need to access protected features.

# 🌐 Context

We need to implement authentication to protect user data and enable role-based access control. Currently the app has no security layer.

## 📋 Acceptance Criteria

 - [ ] MUST support email/password authentication
 - [ ] SHOULD use JWT tokens for session management
 - [ ] MUST hash passwords with bcrypt
 - [ ] SHOULD have password reset flow

## 🛠️ Implementation/Technical Details or Suggestions

Use Passport.js for the authentication middleware. Store tokens in httpOnly cookies.

## ⛔ Out of Scope

Social auth (Google, GitHub) is out of scope for this ticket.
```

Command to execute:
```bash
acli jira workitem create \
  --project "PROJ" \
  --type "Story" \
  --summary "Add user authentication system" \
  --description "..." \
  --assignee "@me" \
  --label "security,backend"
```

Should I proceed with creating this ticket?

*[After confirmation, executes command]*

**Assistant**: ✓ Ticket created successfully!
- **Key**: PROJ-123
- **Link**: https://your-domain.atlassian.net/browse/PROJ-123
- **Summary**: Add user authentication system
- **Story Points**: 8

## Important Notes

- **Template Usage**: ALWAYS read `issue_template.md` at the start to understand the expected structure
- **Description Format**: Use the template structure for all ticket descriptions to maintain consistency
- **RFC 2119 Language**: In acceptance criteria, use MUST/SHOULD/MAY keywords per RFC 2119 spec
- **Checkbox Format**: Format acceptance criteria as `- [ ] MUST/SHOULD/MAY ...` for JIRA compatibility
- **Section Omission**: Skip optional sections (Implementation Details, Out of Scope, Resources) if user doesn't provide content
- **Emoji Markers**: Preserve emoji section markers (🗣️, 🌐, 📋, 🛠️, ⛔, 📚) for visual hierarchy in JIRA
- **Authentication**: Assumes `acli` is already configured with `acli jira auth` command
- **Error Handling**: If acli returns an error, parse the error message and provide helpful guidance (e.g., "Invalid project key", "Missing required field")
- **Multi-line Descriptions**: For descriptions with line breaks, use `--description-file` flag to pass a file path instead of inline text
- **Label Format**: Labels must be comma-separated with no spaces (e.g., `--label "label1,label2,label3"`)

## Template Structure Guidelines

### For Stories
Use the full template structure:
```markdown
# 🗣️ User Story
As a [role] I want to [action] because [reason].

# 🌐 Context
[High-level overview and desired outcome]

## 📋 Acceptance Criteria
 - [ ] MUST [requirement]
 - [ ] SHOULD [requirement]
 - [ ] MAY [requirement]

## 🛠️ Implementation/Technical Details or Suggestions
[Technical approach, sample code, design patterns]

## ⛔ Out of Scope
[Explicit scope boundaries]

## 📚 Additional Information & Resources
- [Link to documentation]
```

### For Bugs
Adapt the template for bug reporting:
```markdown
# 🐛 Bug Description
[What's broken and the impact]

## 📋 Steps to Reproduce
1. [Step one]
2. [Step two]
3. [Step three]

## ✅ Expected Behavior
[What should happen]

## ❌ Actual Behavior
[What actually happens]

## 🌐 Additional Information
- Environment: [production/staging/local]
- Browser/Platform: [if applicable]
- Error logs: [if available]
```

### For Tasks
Simplified template for tasks:
```markdown
# 🌐 Context
[What needs to be done and why]

## 📋 Acceptance Criteria
 - [ ] MUST [requirement]
 - [ ] SHOULD [requirement]

## 🛠️ Technical Details
[Approach or specific requirements]
```

## acli Command Reference

### Basic Create
```bash
acli jira workitem create \
  --project "KEY" \
  --type "Story" \
  --summary "Summary text" \
  --description "Description text"
```

### With Optional Fields
```bash
acli jira workitem create \
  --project "KEY" \
  --type "Bug" \
  --summary "Fix login issue" \
  --description "Users cannot log in with SSO" \
  --assignee "developer@example.com" \
  --label "bug,urgent"
```

### With Description File
```bash
acli jira workitem create \
  --project "KEY" \
  --type "Story" \
  --summary "Feature request" \
  --description-file "description.md" \
  --assignee "@me" \
  --label "feature,backend"
```

## Troubleshooting

- **"Project does not exist"**: Verify project key is correct and user has access
- **"Issue type not found"**: Check available issue types for the project
- **"Field required"**: Some projects require additional fields (e.g., components, fix versions)
- **Permission errors**: User may lack permission to create tickets in this project

## Configuration Requirements

User should authenticate with:
```bash
acli jira auth
```

This will prompt for:
- Jira URL (e.g., `https://your-domain.atlassian.net`)
- Email address
- API token (create at https://id.atlassian.com/manage-profile/security/api-tokens)
