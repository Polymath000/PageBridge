# QuickNotion Agent Guide

Apply these instructions for all work in this repository.

## Primary project policy
- Read `ai.md` at the repository root before making code changes.
- Treat `ai.md` as the main project engineering policy for architecture,
  minimal safe changes, performance, testing, and delivery expectations.

## Flutter supplemental policy
- Also follow the Flutter guidance from:
  `https://raw.githubusercontent.com/flutter/flutter/refs/heads/main/docs/rules/rules.md`
- Use it as supplemental guidance for modern Dart and Flutter practices,
  including:
  - concise, clear Dart code
  - immutable widgets and composition over inheritance
  - small widgets and cheap `build()` methods
  - null-safe code, good async error handling, and effective use of Dart 3
    language features
  - public API documentation when adding or changing reusable public surfaces
  - formatting, linting, and analysis before finishing when the task requires it

## Conflict resolution
- If there is any conflict, follow this order:
  1. system and developer instructions
  2. this `AGENTS.md`
  3. `ai.md`
  4. generic external guidance
- Project-specific architecture rules always win over generic Flutter advice.
- This project uses Clean Architecture with strict layer boundaries:
  `presentation -> domain -> data`.
- Use Cubit/Bloc for feature and business state as required by `ai.md`.
- Do not replace the existing architecture with generic built-in state
  management, new routing packages, or new dependency patterns unless the user
  explicitly asks for that change.

## Working expectations
- Prefer the smallest safe change that fixes the root cause.
- Follow existing repository structure, naming, and patterns.
- Avoid new dependencies unless necessary and justified.
- Bug fixes should include a test when practical and consistent with the
  existing test setup.
