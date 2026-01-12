---
name: create-pr
description: Use when creating GitHub Pull Requests for a feature branch.
---

# Create PR Skill

You are helping the user create a GitHub Pull Request using the `gh` CLI tool.

## Instructions

Follow these steps to create a well-formatted PR:

1. **Understand the changes**:
   - Run `git status` to see what files have changed
   - Run `git diff` to see the actual code changes
   - Run `git log main..HEAD` (or appropriate base branch) to see all commits that will be included
   - If the branch is not pushed, note that you'll need to push it first

2. **Analyze the changes**:
   - Review the code changes to understand what was added/modified/fixed
   - Identify the main feature, fix, or improvement
   - Look for usage examples in the code (tests, documentation, etc.)
   - Identify any security-relevant changes (authentication, data validation, user input handling, etc.)

3. **Generate PR content**:
   Create a PR description following this template:

   ```markdown
   # Summary

   [Write a brief 2-3 sentence description of the changes]

   ## Examples

   [Provide 1-3 code examples showing how to use the new functionality]

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

   **Important guidelines for the description**:
   - Summary should explain WHAT changed and WHY, not just list commits
   - Examples should show actual usage of the new/modified code
   - Pre-check relevant security checklist items based on the code changes
   - Add specific testing steps if there are manual testing requirements

4. **Create the PR**:
   - If the branch hasn't been pushed, run: `git push -u origin <branch-name>`
   - Use `gh pr create --title "<title>" --body "<body>"` where:
     - Title should be concise and descriptive (e.g., "feat: Add user authentication", "fix: Resolve race condition in API")
     - Body should contain the complete PR description from step 3
   - Use a HEREDOC for the body to handle multi-line content properly:
     ```bash
     gh pr create --title "feat: Add feature name" --body "$(cat <<'EOF'
     [PR description here]
     EOF
     )"
     ```

5. **Confirm success**:
   - Display the PR URL to the user
   - Summarize what was included in the PR

## Important Notes

- NEVER skip reading the git diff and git log - you need to understand the full scope of changes
- Examples should be ACTUAL code from the changes, not hypothetical
- Pre-check security items that are clearly addressed in the code (e.g., if you see parameterized queries, check that item)
- If you're unsure about which issues this relates to, ask the user or leave the PE-XXXX placeholder
- Use the main branch as the base unless the user specifies otherwise
- Follow conventional commit format for the title (feat:, fix:, chore:, docs:, etc.)
