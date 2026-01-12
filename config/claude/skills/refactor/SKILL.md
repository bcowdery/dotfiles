---
name: refactor
description: Structural code refactoring using ast-grep for syntax-aware search, analysis, and transformation of code patterns across multiple files. Use when renaming functions/classes, restructuring code architecture, or performing syntax-aware find-and-replace operations.
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - Edit
  - Write
  - AskUserQuestion
  - TodoWrite
context: fork
agent: general-purpose
---

# Structural Refactoring Skill

This skill enables systematic code refactoring using ast-grep, a syntax-aware tool for finding and transforming code patterns based on abstract syntax trees rather than plain text.

## Tool Requirements

**CRITICAL**: This skill requires ast-grep to be installed. Before proceeding:
1. Check if ast-grep is available: `which ast-grep`
2. If not installed, guide the user to install it via Homebrew: `brew install ast-grep`

## Workflow

When this skill is invoked, follow these phases in order:

### Phase 1: Discovery & Analysis

1. **Understand the Request**: Clarify what code structure the user wants to refactor (function names, patterns, architectural changes, etc.)

2. **Find Current Usage**: Use ast-grep to discover all instances of the code pattern:
   - Use `ast-grep --pattern 'PATTERN' --lang LANGUAGE` for simple searches
   - For complex patterns, consider creating a temporary ast-grep rule file
   - Analyze file locations, usage contexts, and dependencies
   - Example: `ast-grep --pattern 'class $CLASS { $$$ }' --lang typescript`

3. **Assess Impact**: Determine:
   - How many files/locations will be affected
   - Whether changes are isolated or have cascading effects
   - Potential breaking changes or test updates needed
   - Dependencies between affected code locations

### Phase 2: Planning

1. **Design the Transformation**:
   - Define the ast-grep pattern(s) for finding code to refactor
   - Define the replacement pattern(s) or transformation strategy
   - Identify any manual changes needed beyond automated transformation
   - Consider whether changes should be applied incrementally or atomically

2. **Create Refactoring Plan**: Write a concise summary including:
   - **What**: Brief description of the refactoring (1-2 sentences)
   - **Why**: Motivation or goal of the change
   - **Impact**: Number of files/locations affected
   - **Pattern**: Show the ast-grep pattern(s) to be used
   - **Transformation**: Show before/after code examples
   - **Diagram**: For architectural changes, include ASCII art showing:
     - Current structure → New structure
     - Module dependencies before/after
     - Call graph changes
     - Use simple boxes, arrows, and labels

3. **Present to User**: Show the plan clearly and concisely. Example format:
   ```
   ## Refactoring Plan: [Brief Title]

   **Goal**: [1-2 sentence description]

   **Impact**: [X files, Y instances]

   **Pattern Match**:
   ```typescript
   // Current pattern
   ```

   **Transform To**:
   ```typescript
   // New pattern
   ```

   **Architecture** (if applicable):
   ```
   Current:                    New:
   ┌─────────┐                ┌─────────┐
   │ Module  │ ──────▶        │ Module  │ ──────▶
   └─────────┘                └─────────┘
   ```

   **Additional Steps**: [Any manual changes needed]
   ```

### Phase 3: User Feedback

1. **Gather Feedback**: Use AskUserQuestion if there are:
   - Multiple valid approaches to present
   - Architectural decisions to make
   - Trade-offs requiring user input

2. **Adjust Plan**: Incorporate user feedback and iterate on the plan if needed

3. **Confirm Approach**: Once the user approves, proceed to execution

### Phase 4: Execution

1. **Backup Check**: Ensure the codebase is in a git repo with clean working tree (or user acknowledges uncommitted changes)

2. **Apply Transformations**:
   - For simple patterns: Use `ast-grep run --pattern 'FIND' --rewrite 'REPLACE' --lang LANGUAGE`
   - For complex patterns: Create an ast-grep rule file and use `ast-grep scan --update-all`
   - Use `--interactive` flag for careful review when appropriate
   - Example command: `ast-grep run -p 'console.log($MSG)' -r 'logger.info($MSG)' -l typescript --interactive`

3. **Verify Changes**:
   - Use git diff to show what changed
   - Run tests if available: `npm test`, `cargo test`, `go test`, etc.
   - Run linters/type checkers if applicable
   - Address any compilation errors or test failures

4. **Document Results**:
   - Summarize what was changed (files, patterns)
   - Report any issues encountered
   - Suggest follow-up actions if needed (update docs, manual review areas, etc.)

## ast-grep Capabilities Reference

**Basic Search**:
```bash
# Find pattern
ast-grep --pattern 'function $FUNC($$$PARAMS) { $$$ }' --lang javascript

# Search with context
ast-grep -p 'useState($$$)' -l typescript -A 3 -B 2
```

**Search & Replace**:
```bash
# Rewrite pattern
ast-grep run -p 'var $VAR = $VAL' -r 'const $VAR = $VAL' -l javascript

# Interactive mode
ast-grep run -p 'PATTERN' -r 'REPLACEMENT' -l LANG --interactive
```

**Rule-Based Refactoring**:
```yaml
# rule.yml
id: example-rule
language: typescript
rule:
  pattern: $OBJ.hasOwnProperty($PROP)
fix: Object.hasOwn($OBJ, $PROP)
message: Use Object.hasOwn instead of hasOwnProperty
```
```bash
ast-grep scan -r rule.yml --update-all
```

**Supported Languages**: JavaScript, TypeScript, Python, Go, Rust, Java, C, C++, C#, Kotlin, Swift, Ruby, PHP, and more.

## Pattern Syntax

- `$VAR`: Match single AST node (variable name, expression, etc.)
- `$$$ARGS`: Match multiple AST nodes (variadic, like function arguments)
- `$$$`: Match any sequence of nodes within a block
- Meta-variables are captured and can be used in replacements

## Best Practices

1. **Start Small**: Test patterns on a subset before running across entire codebase
2. **Use Interactive Mode**: For significant changes, use `--interactive` to review each change
3. **Verify Syntax**: ast-grep operates on valid AST, so ensure code compiles before refactoring
4. **Combine Tools**: Use ast-grep for structural changes, traditional tools for text changes
5. **Test Incrementally**: Run tests after each logical group of changes
6. **Git Integration**: Work with clean git state, commit refactoring separately from logic changes

## Safety Guidelines

- Never run destructive refactoring without user approval of the plan
- Always show the transformation plan with examples before executing
- Use `--interactive` or `--dry-run` modes when appropriate
- Verify tests pass after refactoring
- For large refactorings (50+ files), suggest incremental approach

## Example Invocations

Users can invoke this skill by saying:
- "Refactor all instances of X to Y using ast-grep"
- "I need to restructure how [pattern] works across the codebase"
- "Help me rename [function/class/pattern] everywhere it's used"
- "Use the refactor skill to change [old pattern] to [new pattern]"

## Notes

- ast-grep is language-aware, so it won't match patterns in comments or strings
- Complex refactorings may require multiple ast-grep passes
- Some edge cases may require manual intervention
- Always prefer semantic understanding over blind find-replace
