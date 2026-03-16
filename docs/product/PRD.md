# Product Requirements Document

## Product Name
GymVoice

## Document Purpose
This PRD defines the product scope, target users, primary workflows, constraints, and success criteria for GymVoice. It keeps the project aligned around a focused MVP: voice-driven workout logging with correct persistence, history, and error handling. Technical implementation details belong in the architecture and technical documentation. Domain context (flows, rules, data) is in **`docs/architecture/# GymVoice – Business Logic.md`**; stack, agents, and skills are in **`docs/architecture/# GymVoice – Technical Documentation.md`**.

Related baseline docs:

- Repository operating contract: `PROJECT.md`
- Solution design / architecture: `docs/architecture/SOLUTION_DESIGN.md`
- Stack and tooling decisions: `docs/architecture/STACK.md`
- Milestones and MVP plan: `docs/planning/MILESTONES.md`, `docs/planning/MVP_PLAN.md`
- Workflow and completion standard: `docs/process/TASK_EXECUTION_WORKFLOW.md`, `docs/process/DEFINITION_OF_DONE.md`

---

## Problem Statement
Gym users often skip logging because typing or tapping during a workout is cumbersome. Many apps support manual entry of sets and reps, but that breaks focus and takes time. The core problem is enabling **hands-free logging by voice** so the user can speak after each set and have the app capture exercise, weight, reps, and notes—including supersets and trisets—with correct grouping and persistence, and without saving incomplete or conflicting data.

---

## Product Goal
Build a mobile app that allows users to:

- Log workouts by natural voice (exercise, set, weight, reps, effort notes)
- Manage sessions (start, end, duration)
- Group sets into supersets (bisets) and trisets when applicable
- View history and progress (daily, weekly, monthly)
- Correct or confirm when voice is unrecognized or data is incomplete
- Rely on data integrity (no silent save of invalid or conflicting sets)

---

## Product Vision
GymVoice should become a reliable voice-first workout tracker: the user focuses on training, the app captures everything accurately, and progress is visible over time. The MVP should prove that the core lifecycle—session start, voice logging with parsing and grouping, session end, and history—works with strong data integrity and a natural UX.

---

## Target Users

### Primary Users
- Gym users who want to log workouts by voice during the session
- Users who prefer minimal manual input (confirmations only when needed)

### Secondary Users
- Users who want to review progress and trends over time

### Non-Target Users for MVP
- Users who need a full social or community experience
- Users who need UI in a language other than Spanish in the first release

---

## MVP Scope

### Included in MVP
- Authentication (OAuth Google/Apple or custom); user registered for history
- Workout session start/end; date, time, duration
- Voice-driven exercise logging: parse phrase (exercise, set, weight, reps, notes); confirm and store
- Supersets and trisets: detect or ask grouping; store sets in groups; notes per set
- Session completion (“finish workout”); save session and update history
- History view: sessions by day/week/month; progress and trends (basic)
- Error handling: confirm on unrecognized or incomplete input; allow correction or manual add; clarify conflicts
- UI in Spanish; code and comments in English
- Tests for ParseExerciseSkill, GroupSeriesSkill, VoiceParserAgent, session flow, and key UI

### Excluded from MVP
- UI in languages other than Spanish
- Social features, sharing, or community
- Offline-first sync
- Broad support for every possible exercise or phrase on day one

---

## Core User Needs

### 1. Log a set by voice
The user must be able to speak after a set (e.g. “First set bench press, 20kg, 10 reps, it was heavy”) and see the app interpret and confirm before storing.

### 2. Group sets into supersets/trisets
When the next set belongs to a biset or triset, the app must ask or suggest and record the group correctly.

### 3. Complete a session
The user must be able to finish the workout (e.g. “finish workout”) and have the full session saved and reflected in history.

### 4. View progress
The user must be able to view past sessions and progress (weight, reps, trends) by day, week, or month.

### 5. Correct errors
When voice is unrecognized or data is incomplete or conflicting, the app must ask for confirmation or correction and must not save invalid data.

### 6. Trust data integrity
All stored data must be consistent. Incomplete or conflicting sets must not be persisted without explicit user confirmation or clarification.

---

## Primary User Flows

### Flow 1: Login
User authenticates via OAuth (Google, Apple) or custom account.

**Expected outcome:** User is registered; session can be associated with the user for history.

### Flow 2: Start session
User selects an existing workout or starts a new one.

**Expected outcome:** Session start time is recorded; session is in progress.

### Flow 3: Log set by voice
User speaks after a set (e.g. “First set bench press, 20kg, 10 reps, it was heavy”). App parses and shows structured result. User confirms or corrects.

**Expected outcome:** Parsed data (exercise, set number, weight, reps, notes) is shown; on confirm, set is stored. If next set is part of superset/triset, app asks and groups.

### Flow 4: Complete exercise / session
User indicates exercise is finished (timeout or “I finished this exercise”) or says “finish workout” when done.

**Expected outcome:** Exercise end or session end is detected; session is saved; history is updated.

### Flow 5: View history
User opens history and filters by day, week, or month.

**Expected outcome:** Sessions and progress are visible; data is consistent with what was logged.

### Flow 6: Handle error or incomplete input
Voice is unrecognized, or reps/weight are missing, or data conflicts with a previous set.

**Expected outcome:** App asks for confirmation or clarification; does not save until user confirms or corrects; no silent persistence of invalid data.

---

## Product Principles

### 1. Data Integrity First
Do not persist incomplete or conflicting sets without confirmation.

### 2. Traceability by Default
Session and set data must support history and progress and be explainable.

### 3. Explicit Workflow
Parsing, grouping, and persistence must be explicit; no silent or ambiguous saves.

### 4. Narrow Scope, Strong Execution
MVP does a small number of important things very well: voice log, group, persist, history, errors.

### 5. Safe Evolution
New agents, skills, or flows can be added without breaking existing behavior.

---

## Functional Requirements

### Authentication
- System must support OAuth (Google, Apple) or custom username/password.
- User must be registered for history to be associated.

### Session Management
- System must support session start and end; record date, time, duration.
- User must be able to select existing workout or start new one.

### Voice Logging
- System must accept voice input and produce structured data (exercise, set, weight, reps, notes).
- System must confirm with user before persisting a set.
- System must support supersets and trisets (detect or ask; group sets; notes per set).

### Session Completion
- System must support “finish workout” (or equivalent) to save session and update history.
- System may auto-detect exercise end by timeout or explicit user phrase.

### History and Progress
- System must store sessions with exercises, sets, reps, weights, notes, and groups.
- System must support viewing by day, week, month and progress/trends.

### Error Handling
- System must confirm when voice is unrecognized or ambiguous.
- System must allow manual correction or adding missed sets.
- System must request clarification when data conflicts (e.g. weight/reps inconsistency).
- System must not save incomplete or conflicting sets without user confirmation or correction.

### UI and Language
- UI must be in Spanish for the user.
- Code and comments must be in English.

---

## Non-Functional Requirements

### Reliability
Parsing and persistence must behave predictably; no silent data corruption.

### Data Integrity
Incomplete or conflicting sets must not be persisted without confirmation. Business rules (Business Logic doc) must be enforced.

### Maintainability
Codebase must support adding agents, skills, or flows without broad rewrites.

### Testability
Parsing (ParseExerciseSkill), grouping (GroupSeriesSkill), session flow, and critical UI paths must be testable with automated tests.

### Usability
Experience must be fast, intuitive, and natural; minimal taps for confirmations only when needed.

---

## Constraints

### Scope Constraint
MVP remains focused on voice-driven logging, session lifecycle, and history—not social or broad platform features.

### Data Integrity Constraint
Product operates in a domain where wrong or ambiguous data must not be stored without explicit user action.

### Language Constraint
UI in Spanish; all code and technical content in English.

---

## Success Criteria

The MVP is successful when the system can reliably:

- Accept voice input and parse it into exercise, set, weight, reps, notes
- Confirm with user before storing a set
- Group sets into supersets/trisets when applicable
- Start and end sessions and persist full session data
- Expose history and progress by day/week/month
- Handle unrecognized or incomplete input with confirmation or correction
- Avoid persisting incomplete or conflicting sets without user confirmation

---

## MVP Milestones

For details and issue mapping, see [docs/planning/MILESTONES.md](../planning/MILESTONES.md) and [MVP_PLAN.md](../planning/MVP_PLAN.md).

| Milestone | Summary |
|-----------|---------|
| **M1 – Foundation** | Repo, workflow, mobile + backend scaffolding, CI; project ready for feature work. |
| **M2 – Auth and first vertical slice** | Auth (OAuth or custom); voice-to-text; ParseExerciseSkill; minimal session/set persistence; speak → confirm → persist one set. |
| **M3 – Voice pipeline and session** | VoiceParserAgent, ErrorHandlerAgent, GroupSeriesSkill, SessionManager; session start/end; set and set-group persistence; confirm/clarify flow. |
| **M4 – History, progress, and polish** | History and progress view; Spanish UI; error handling and confirmations; unit/integration/UI tests; MVP complete. |
| **M5+** | Post-MVP (e.g. richer progress visualization, offline support). |

---

## Risks

### Scope Creep
Expanding into social, multi-language UI, or broad platform features too early could dilute focus.

### Data Integrity Gaps
If parsing or persistence allow incomplete or conflicting data to be saved without confirmation, user trust and history accuracy suffer.

### Over-Engineering
Building for every possible phrase or exercise variant too early may slow MVP delivery.

---

## Product Decisions for MVP

### Decision 1
MVP will prioritize voice logging correctness and data integrity over UI richness or extra features.

### Decision 2
MVP will support a single UI language (Spanish); code and docs in English.

### Decision 3
Supersets and trisets will be supported via explicit grouping (detect or ask); sets can have notes within groups.

### Decision 4
Incomplete or conflicting sets will never be saved without user confirmation or correction; this is non-negotiable.

---

## Open Product Questions
- Exact voice API provider and language model (e.g. Google Speech-to-Text, language/locale).
- Offline voice recognition in a later phase (yes/no, when).
- How much progress visualization in M4 (basic list + trends vs. richer charts).

---

## Future Expansion
- Richer progress visualization and statistics
- Offline-first sync
- Additional agents or skills
- More UI languages
- Integrations (e.g. wearables)

---

## Final Rule
If a proposed feature does not directly improve the system’s ability to capture, validate, persist, and expose voice-driven workout data with integrity for the MVP scope, it should probably not be included yet.
