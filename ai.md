# Project Global Engineering Rules

## 1) Clean code always
- Keep code clean, readable, and maintainable.
- Prefer clarity over cleverness.
- Code should be straightforward; clever or obscure code is difficult to maintain.

## 2) Small files and functions
- Files and functions must stay small and focused.
- Avoid large classes or overly complex files.
- Strive for functions that are less than 20 lines with a single purpose.

## 3) Documentation and comments
- Add comments only when the intent is not obvious. Explain *why* the code is written a certain way, not *what* it does.
- Do not add redundant or obvious comments.
- Use `dartdoc` style (`///`) for all public APIs, classes, and complex functions.
- Start documentation with a single-sentence summary, followed by a blank line and deeper context.

## 4) Clean Architecture discipline (strict)
- Follow Clean Architecture layer boundaries strictly: presentation → domain → data.
- Each layer must have a single responsibility. Never bypass layers or mix responsibilities.
- Do not put business logic inside the UI (presentation layer).
- UI must only handle rendering, user interaction, and state observation.
- All business logic must reside in the domain layer and be triggered via Cubit/UseCases.
- Data layer must only handle API calls, persistence, and data mapping.
- Do not introduce unnecessary abstractions or overengineering.

## 5) Apply SOLID, DRY, and sound engineering principles
- Apply SOLID, DRY, and other sound engineering principles when beneficial.
- Favor composition over inheritance for building complex widgets and logic.
- Do not force patterns unnecessarily.

## 6) Root-cause first
- Always identify and fix the root cause, not just symptoms.
- Do not apply superficial fixes.

## 7) Minimal safe changes
- Make the smallest possible change that solves the problem.
- Do not refactor unrelated code unless explicitly requested.

## 8) No breaking changes
- Do not break existing functionality, APIs, flows, or UX unless explicitly instructed.

## 9) Follow repository conventions
- Follow existing architecture, folder structure, naming conventions, and patterns.
- Do not introduce a new style inconsistent with the project.

## 10) Core folder for shared components
- Any reusable logic, utilities, services, constants, extensions, helpers, or shared components used in more than one place must be placed in the `core/` folder.
- Avoid duplication across features.

## 11) Performance awareness (Flutter)
- Follow Flutter performance best practices at all times.
- Prefer `const` constructors wherever possible to reduce rebuilds.
- Avoid heavy work inside build methods (e.g., unnecessary object allocations, network calls).
- Use `compute()` to run expensive calculations (like JSON parsing) in a separate Isolate to avoid blocking the UI thread.
- Be careful when using `setState`: Use it only for ephemeral local UI state. Never use it for business logic.
- Dispose controllers (`TextEditingController`, `AnimationController`) and focus nodes properly in `dispose()`.

## 12) State management discipline (Cubit / Clean Architecture)
- Use Cubit/Bloc for feature state and business logic coordination.
- UI must never contain business logic. UI must only observe state and trigger Cubit actions.
- Do not bypass architecture layers.

## 13) Edge cases, error handling, and logging
- Properly handle null, empty, loading, and error states. Do not allow silent failures.
- Ensure safe and predictable behavior using `try-catch` blocks appropriate for the exception type.
- Errors must propagate cleanly: data → domain → presentation.
  - Data layer: catch exceptions and map them to typed Failure/Error classes.
  - Domain layer: return Result types (e.g., `Either<Failure, Success>`).
  - Presentation layer: map failures to user-friendly messages.
- **Logging:** Use structured logging via the `log` function from `dart:developer` instead of `print()`. Never log sensitive information.

## 14) Dependencies rule
- Do not add new packages unless necessary and justified.
- Use the `pub` tool to manage dependencies. Any added package must be the latest stable version, well-maintained, and production-grade.

## 15) Security awareness
- Always consider security implications and proactively warn about risks.
- Never hardcode secrets, tokens, or credentials.
- Safely validate and handle external and API data.

## 16) Follow modern Dart best practices
- Follow current Dart 3+ standards. 
- Use `sealed class` for state unions, exhaustive `switch` expressions, and pattern matching.
- Use records to return multiple types when defining a class is cumbersome.
- Avoid code generation libraries (like Freezed) unless explicitly adopted.
- If JSON serialization is adopted, use `json_serializable` with `fieldRename: FieldRename.snake`.
- Utilize `dart format` and `dart fix` to ensure consistent formatting and lint compliance. Include `flutter_lints`.

## 17) Routing and navigation
- Use the `go_router` package for declarative navigation, deep linking, and web support (including authentication redirects).
- Use the built-in `Navigator` only for short-lived screens that do not need to be deep-linkable, such as dialogs or temporary overlays.

## 18) UI layout, theming, and visual design
- **Layouts:** Use `ListView.builder` or `SliverList` for lazy-loading long lists. Use `Expanded` and `Flexible` correctly within Rows/Columns. Use `OverlayPortal` for advanced overlays instead of global stacks.
- **Theming:** Embrace Material 3. Use `ColorScheme.fromSeed()` to generate harmonious light and dark mode palettes.
- **Design Tokens:** Use `ThemeExtension` to define custom, reusable design tokens (like specific status colors) that aren't part of standard `ThemeData`.
- **Styling:** Utilize `WidgetStateProperty` for interactive component states (e.g., hovered, pressed).

## 19) Accessibility (A11Y)
- **Contrast:** Ensure text has a contrast ratio of at least 4.5:1 against its background.
- **Semantics:** Use the `Semantics` widget to provide clear, descriptive labels for screen readers.
- **Responsiveness:** Ensure the UI scales safely when users increase system font sizes.

## 20) Team mindset (engineering partner mode)
- Act as a senior engineer partner, not just a task executor.
- Suggest improvements when valuable and explain tradeoffs briefly.

## 21) No assumptions without verification
- Always read and understand relevant code before modifying it.
- Ask or clearly state assumptions if something is unclear.

## 22) Avoid duplication
- Reuse existing logic when available. Do not duplicate code unnecessarily.

## 23) Dart naming conventions and best practices
- Files: `snake_case.dart`
- Classes, enums, typedefs: `PascalCase`
- Variables, functions, parameters, constants: `camelCase` (no SCREAMING_CAPS for constants)
- Private members: prefix with `_`
- Feature folder structure: `feature_name/data/`, `feature_name/domain/`, `feature_name/presentation/`

## 24) Import ordering
- Organize imports in this order, separated by blank lines:
  1. Dart SDK imports (`dart:`)
  2. Flutter SDK imports (`package:flutter/`)
  3. Third-party package imports (`package:`)
  4. Project package imports (`package:project_name/`)
- Use relative imports within the same feature; use package imports across features. Remove unused imports.

## 25) Testing discipline
- Follow the Arrange-Act-Assert (Given-When-Then) pattern.
- Write unit tests for domain logic, data layer, and state management.
- Write widget tests for critical UI components.
- Use `integration_test` to verify end-to-end user flows.
- Prefer fakes or stubs over mocks. If mocks are absolutely necessary, use `mocktail` or `mockito`.
- Bug fixes must include a test that reproduces the issue. Keep tests deterministic and focused.

## 26) Separation of concerns enforcement
- Presentation layer must not directly access repositories or data sources.
- All business operations must go through domain use cases.
- Cubits must depend only on use cases, never directly on repositories.

## 27) Completion self-review checklist (mandatory)
Before finishing any task, verify:
- The root cause is correctly addressed.
- The solution is safe, minimal, and performant.
- No existing functionality is broken.
- Architecture rules and separation of concerns are respected (no business logic in UI).
- No security risks or accessibility regressions are introduced.
- Code is properly formatted, commented, and linted.

Then provide a brief summary of:
- What was changed
- Why it was changed
- Why the solution is safe and correct

## 28) Git and Pull Request output (mandatory after task completion)
After confirmation that the task is complete and approved, provide:

**Branch name:**
- Format: `type/<description>` (Types: `fix`, `feat`, `refactor`, `perf`, `chore`)

**Commit message:**
- Clear, concise, professional, following conventional commit format.

**Pull Request title & description:**
- Markdown format (`.md`), concise, and straight to the point. Include summary and root cause (if bug fix).
