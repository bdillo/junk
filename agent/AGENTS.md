Be concise unless asked to explain something further.

## Philosophy

- Simplicity: Prefer readable, maintainable code over clever or terse code.
  Introduce abstractions when they hide complexity, not just to shorten files or
  eliminate duplication before a pattern emerges.
- Smallest changes: Make the minimum reasonable change to achieve the goal.
  Leave unrelated code and uncommitted changes alone.
- Understand before changing: Read relevant code before modifying it.
- Conservative dependencies: Prefer self-contained solutions. Add dependencies
  when their value justifies the maintenance burden and supply-chain risk.
- Security: Build clear security boundaries into the design from the start.
  Identify trust boundaries, validate inputs, and plan for failure modes.

## Code Style

### Naming

Name things for their role. Include implementation details only when they
distinguish things the reader needs to tell apart. Avoid time-based labels like
`NewAPI` and redundant suffixes like `ToolFactory` when `Tool` is enough.

### Comments

Write comments to explain intent or non-obvious decisions, not to narrate the
code or its history. Remove comments that are no longer accurate.

### Structure

- Functional core, imperative shell: Keep I/O at the edges when practical so
  core logic stays easy to understand and test.
- Centralize control flow: Push conditionals to callers when that brings
  branching together and gives helpers clear preconditions and straight-line
  logic.
- Fail fast: Don't silently ignore errors. Handle them where there's enough
  context to act, or return them to the caller.
- Leverage types: In strongly typed languages, model data so invalid states are
  hard to represent.
- Parse, don't validate: Turn loosely structured input into domain types at the
  boundary. Preserve what you learned in the result instead of repeatedly
  checking the raw input.
- Local consistency: Match the surrounding code's style unless doing so
  conflicts with a specific rule here.

## Collaboration

We work as colleagues. I value your honest technical judgment over agreement.

- Flag concerns early and push back when you disagree. Explain why.
- Handle routine work without asking. Check in when requirements are unclear,
  there are multiple reasonable approaches, or the change would delete or
  substantially restructure code.

## Testing

- Test behavior, not implementation details. Tests should still pass after an
  internal refactor, and shouldn't exist just to verify calls to mocks.
- Include tests for new functionality and bug fixes. Write them so a reader can
  understand the expected behavior.
- Run relevant checks when possible. Say what you ran and what you couldn't
  verify.
