# Project Instructions

## General

- This is a Flutter application.
- Follow the existing project architecture and feature-first structure.
- Use GetX for state management, navigation, and dependency injection where the project already uses GetX.
- Before creating new code, inspect the existing codebase for reusable models, repositories, services, controllers, widgets, utilities, and screens.
- Prefer extending existing functionality over creating duplicate implementations.
- Keep changes limited to the requested feature.
- Do not refactor unrelated code.
- Do not change existing behavior unless required by the requested feature.

## UI and Design

- Follow the existing UI/UX and visual design of the application.
- Reuse existing widgets and components whenever possible.
- Use `SColors` for application colors.
- Use `SSize` for dimensions, spacing, and sizing.
- Use `SAppTheme` and the existing theme system.
- Use `Theme.of(context).colorScheme` for theme-aware colors.
- Use `Theme.of(context).textTheme` for text styles.
- Keep screens organized into small, reusable widget files.
- Do not introduce a new design system when an existing one already exists.

## State Management

- Follow the existing GetX architecture and patterns.
- Keep business logic out of UI widgets when the existing architecture separates it.
- Use the existing controller/service/repository patterns.
- Do not introduce another state-management solution.

## Data and Backend

- Reuse existing models, repositories, services, and API/database functionality.
- Do not create duplicate models or repositories when existing ones can be reused safely.
- Do not invent API endpoints, database fields, backend behavior, or data that do not exist.
- If backend functionality is required but does not exist, clearly identify the requirement before implementing a workaround.
- Respect existing authentication and role-based authorization.

## Loading, Empty, and Error States

- Every new data-driven screen should handle loading, success, empty, and error states.
- Use `SFullScreenLoader` where the existing application uses full-screen loading.
- Use `SSnackBarHelpers.errorSnackBar` for user-facing errors.
- Handle null, missing, malformed, and unavailable data safely.
- Do not allow errors to crash the application.

## AI Features

- Keep AI inputs and outputs structured.
- Validate AI responses before using them in application logic.
- Never allow arbitrary AI text to directly control application logic.
- Use validated enums or allowed-value checks for fields such as `LOW`, `MEDIUM`, and `HIGH`.
- Handle AI timeout, unavailable AI service, invalid responses, and API errors gracefully.
- Do not fabricate AI-generated data when required information is unavailable.
- Keep deterministic calculations outside the AI whenever possible.
- AI should interpret or generate insights from trusted application data rather than inventing application data.

## Code Quality

- Follow existing naming conventions.
- Prefer simple, maintainable implementations.
- Avoid unnecessary dependencies.
- Avoid unnecessary duplication.
- Do not leave unused imports, dead code, debug code, or temporary test implementations.
- Do not silently suppress analyzer warnings or errors.

## Before Implementation

Before implementing a significant feature:

1. Inspect the relevant existing code.
2. Identify reusable models, repositories, services, controllers, widgets, and routes.
3. Identify the files that need to be changed.
4. Identify genuinely new files that are required.
5. Provide a short implementation plan.
6. Do not modify files during the inspection/planning step unless explicitly requested.

## After Implementation

After implementing a feature:

- Run `flutter analyze`.
- Run relevant tests if they exist.
- Check the normal/success state.
- Check loading state.
- Check empty state.
- Check error state.
- Check navigation and back behavior.
- Check null safety.
- Review the changes for unnecessary modifications.
- Fix issues caused by the feature.
- Do not refactor unrelated code.
