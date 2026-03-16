# Project Overview

## Project Name
GymVoice

## Mission
Build a mobile application that lets users track their gym progress using **natural voice**, so they can focus on their workout while the app captures sets, repetitions, weights, effort notes, and supersets (bisets) and trisets—with strong data integrity, traceability, and a fast, intuitive experience.

## Product Vision
GymVoice should become the go-to voice-driven workout logger: reliable parsing of spoken input, correct persistence of sessions and sets, clear handling of errors and confirmations, and progress visibility over time. The system must be designed as a real product, not a prototype. Data integrity, user trust, and safe evolution are first-class concerns.

## Product Scope

### In Scope (MVP)
- Voice-driven workout logging (exercise, set, weight, reps, effort notes)
- Session start/end; date, time, duration
- Exercises, sets, supersets (bisets), trisets with grouping and notes
- History and progress (daily, weekly, monthly views; trends)
- Error handling and confirmations (unrecognized voice, incomplete sets, conflicts)
- Authentication (OAuth Google/Apple or custom); user registered for history
- Spanish UI; code and comments in English
- Extensible agents and skills (VoiceParser, ExerciseLogger, SessionManager, ErrorHandler; ParseExercise, GroupSeries, ProgressHistory, Alert)

### Out of Scope for MVP
- UI in languages other than Spanish
- Non-voice as primary input
- Social features, sharing, or community
- Offline-first sync (can be added later)
- Native iOS/Android code outside React Native

## Primary Goal
Deliver an app where the user can complete a full workout by voice (with minimal taps for confirmations), with every set and session stored correctly, incomplete or conflicting data never saved without confirmation, and progress visible in history.

## Target Users
- Gym users who want to log workouts by voice during the session
- Users who prefer not to touch the phone for data entry while training

## Core Product Principles

### 1. Data Integrity First
Do not persist incomplete or conflicting sets. Confirm with the user before saving when voice is ambiguous or data is missing. Voice misrecognition must be detectable and correctable.

### 2. Traceability by Default
Important actions (session start/end, set stored, group formed, session completed) should be understandable afterwards. Persisted state must support history and progress.

### 3. Explicitness Over Magic
Parsing results, grouping decisions, and persistence effects must be explicit. No silent saves of invalid or ambiguous data.

### 4. Small, Reviewable Changes
Work in small increments. Large, ambiguous PRs are discouraged.

### 5. Clear Boundaries
Domain logic (session, exercise, set, set group), voice parsing, grouping, persistence, and UI should remain clearly separated. External voice API and OAuth are integration boundaries.

### 6. Safe Evolution
The codebase must support adding new agents, skills, or flows without destabilizing existing behavior.

## Technical Priorities
- Correctness of parsing and persistence
- Traceability of session and set data
- Testability of voice pipeline and business rules
- Clear error handling and user-facing confirmations
- Maintainability and extensibility

## Architecture Principles

### Domain-Centered Design
The internal model (user, session, exercise, set, set group) is the core. External voice API and OAuth outputs are mapped into the domain; they do not leak across the entire codebase.

### Separation of Concerns
- Voice capture and voice-to-text (external API)
- Parsing (ParseExerciseSkill, VoiceParserAgent)
- Grouping (GroupSeriesSkill, ExerciseLoggerAgent)
- Session lifecycle (SessionManagerAgent)
- Error handling and validation (ErrorHandlerAgent)
- Persistence (backend)
- UI (Spanish, mobile)

### Explicit State
Session and set state must be explicit. No hidden transitions or silent persistence.

### Deterministic Where Possible
Same voice phrase under same rules should yield same parsed structure. Persistence must be consistent and queryable.

## Data Integrity and Voice Pipeline Principles
- Never save a set without required fields (reps, weight) unless the user explicitly confirms or corrects.
- Never save conflicting data (e.g. inconsistent weight/reps for the same set) without clarification.
- Never assume voice recognition is correct; allow confirmation and correction.
- Treat user data, session data, and auth as sensitive: store and transmit appropriately.
- Changes affecting parsing, grouping, or persistence must be testable and documented.

## Repository Working Model

### Source of Truth
- GitHub Issues = unit of work
- GitHub Project = workflow and backlog visibility
- Pull Requests = implementation delivery
- `docs/` = persistent project knowledge
- `docs/architecture/# GymVoice – Business Logic.md` and `# GymVoice – Technical Documentation.md` = domain and technical context
- `PROJECT.md` = repository operating contract

### Standard Workflow
1. Requirements enter backlog
2. Scope is clarified (objective, AC, dependencies)
3. Work is broken into issues
4. One issue is implemented at a time
5. PR is opened with "Closes #N"
6. Validation runs through review and CI
7. Work is merged only after Definition of Done is satisfied

### Branching Convention
Use **`scripts/task-start.sh <issue_number>`** to create branch `issue/N-title-slug` and move the issue to "In progress" when ready. See `scripts/README.md` for prerequisites (`gh`, project scope).

### Pull Requests
Every PR must link to the issue (e.g. `Closes #N`) and include a brief scope description. Use the pull request template at `.github/pull_request_template.md` when opening via UI; when using `gh pr create` or `scripts/task-pr.sh`, fill in the template manually if needed.

## Documentation Requirements
The following documents should exist and stay updated (see `README.md` for a single entry point and docs map):
- `PROJECT.md`
- `docs/product/PRD.md`
- `docs/architecture/SOLUTION_DESIGN.md`
- `docs/architecture/STACK.md`
- `docs/architecture/# GymVoice – Business Logic.md`
- `docs/architecture/# GymVoice – Technical Documentation.md`
- `docs/process/DEFINITION_OF_DONE.md`
- `docs/process/TASK_EXECUTION_WORKFLOW.md`
- `docs/planning/MILESTONES.md`, `docs/planning/MVP_PLAN.md`
- `docs/architecture/adr/` for significant design decisions

### Cross-references

- Product scope and MVP framing: `docs/product/PRD.md`
- Architecture and data flow: `docs/architecture/SOLUTION_DESIGN.md`
- Stack and tooling decisions: `docs/architecture/STACK.md`
- Milestones and MVP boundary: `docs/planning/MILESTONES.md`, `docs/planning/MVP_PLAN.md`
- Workflow and completion standard: `docs/process/TASK_EXECUTION_WORKFLOW.md`, `docs/process/DEFINITION_OF_DONE.md`

## Definition of Success
This project is successful when:
- Users can complete a full workout by voice with minimal taps
- Sets, reps, weights, and superset/triset groups are stored correctly and appear in history
- Unrecognized or incomplete input is handled with confirmation or correction
- Parsing, grouping, and session logic are covered by automated tests
- The codebase remains maintainable as new agents or flows are added

## Non-Negotiables
- Do not merge work that expands scope without explicit approval
- Do not introduce architecture changes without documenting them
- Do not mark issues as done without validation evidence
- Do not hide voice-pipeline or persistence logic inside unrelated layers
- Do not persist incomplete or conflicting sets without user confirmation
- Do not sacrifice correctness for speed in data-integrity-sensitive flows

## Team Operating Principles
- Prefer clarity over speed when requirements are ambiguous
- Prefer explicit tradeoffs over silent assumptions
- Prefer documented decisions over tribal knowledge
- Prefer incremental delivery over large rewrites

## Current MVP Direction
The current MVP should focus on:
- Mobile and backend scaffolding
- Authentication (OAuth or custom)
- Voice-to-text integration and ParseExerciseSkill
- Session and set persistence
- Superset/triset grouping (GroupSeriesSkill, ExerciseLoggerAgent)
- Session completion and history view
- Error handling and confirmations
- Spanish UI and tests for parsing and grouping

## Future Expansion Areas
Possible future phases:
- Richer progress visualization and statistics
- Offline-first sync
- Additional agents or skills
- More languages for UI
- Integrations (e.g. wearables)

## Final Rule
This repository exists to build a reliable voice-driven workout tracker. Every change should be evaluated against: Does it improve correctness, data integrity, traceability, and maintainability for GymVoice? If not, it probably does not belong in the current scope.
