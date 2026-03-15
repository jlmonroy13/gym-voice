# GymVoice — Solution design / architecture

## Purpose

This document defines the technical design for the GymVoice mobile app and backend. It describes system boundaries, core modules, data flow, architectural decisions, and operational constraints for a reliable, maintainable voice-driven workout logging platform.

The document is pragmatic: it guides implementation, reduces ambiguity, and keeps the project focused on the current MVP scope.

**Stack and tooling:** Language, runtime, mobile framework, database, and test choices are documented in [STACK.md](./STACK.md). Implementers should assume those choices.

---

## System Goal

Build a mobile-first system capable of:

- capturing voice input during workouts and converting it to structured exercise/set data
- validating and grouping sets (including supersets and trisets) with user confirmation when needed
- persisting sessions, sets, and set groups with clear ownership and history
- exposing session and progress history to the user
- handling recognition errors, incomplete data, and conflicts without persisting invalid or ambiguous data

The system must prioritize correctness of logged data, explicit confirmation for ambiguous or incomplete input, and safe evolution of the voice pipeline over convenience or premature abstraction.

---

## MVP Scope

**In scope:**

- Authentication (OAuth Google/Apple or custom).
- Session start/end; store date, time, duration.
- Voice-driven exercise logging: parse exercise, set, weight, reps, notes; confirm and store.
- Supersets and trisets: detect or ask grouping; store sets in groups.
- Session completion; save session and update history.
- History view: sessions by day/week/month; basic progress and trends.
- Error handling: confirm on unrecognized or incomplete input; clarify conflicts before persist.
- UI in Spanish; code and comments in English.
- Unit tests for parsing/grouping; integration for session/set flow; UI tests for key screens.

**Out of scope for MVP:**

- Social features, leaderboards, coach dashboards.
- Offline-first sync and conflict resolution across devices.
- Advanced analytics, charts, or export.
- Multiple users per device or family accounts.
- Support for all possible exercise types or equipment catalogs.

---

## High-Level Architecture

### Main Layers

The system is organized into the following layers:

1. **Mobile UI Layer** — Screens, components, voice capture, local state.
2. **Voice Pipeline Layer** — Voice-to-text integration, parsing, grouping, validation.
3. **Application / Agents Layer** — Orchestration of logging, session, and error-handling flows.
4. **Backend API Layer** — HTTP API, auth, request/response validation.
5. **Domain Layer** — Core entities and business rules (session, set, set group, user).
6. **Persistence Layer** — PostgreSQL via Neon; repositories, migrations.
7. **External Integrations** — Voice API, OAuth providers (boundary only).

Each layer has a clear responsibility and minimal leakage of concerns.

---

## Architectural Principles

### 1. Domain First

The internal model (user, session, exercise, set, set group) is the core. External voice API and OAuth outputs are mapped into the domain; domain logic does not depend on external shapes.

### 2. Voice-Pipeline Isolation

Parsing, grouping, and validation of voice-derived data are isolated from generic UI and persistence logic. Changes to recognition or parsing rules should not force changes across the whole app.

### 3. Explicit Confirmation for Ambiguity

Incomplete sets, conflicting data, or unrecognized input must not be persisted without user confirmation or clarification. The system should never silently guess and store.

### 4. Auditability by Default

Session start/end and set persistence should be traceable (who, when, what was stored). Critical failures (e.g. voice API or DB errors) should be loggable for support.

### 5. Safe Evolution

Voice pipeline and auth are sensitive areas; changes there should be introducible without rewriting the entire codebase. Keep boundaries clear.

### 6. UI Language vs Code

User-facing strings in Spanish; code, comments, and internal identifiers in English.

---

## Layer Design

### 1. Mobile UI Layer

**Responsibilities**

- Render screens (login, session, history) and components.
- Capture voice input and trigger voice-to-text.
- Manage local UI state and call backend API.
- Show confirmations, errors, and history in Spanish.

**Implementation**

- React Native; custom mobile-ready components (shadcn-inspired).
- Voice capture via platform APIs; text sent to parsing pipeline.
- No parsing or grouping logic in UI; delegate to services/agents.

**Notes**

- UI remains thin for business rules; it displays results and sends user actions.

---

### 2. Voice Pipeline Layer

**Responsibilities**

- Integrate with voice-to-text API (e.g. Google Speech-to-Text).
- Parse raw text into structured set data (exercise, weight, reps, notes).
- Group sets into supersets/trisets when applicable.
- Detect incomplete or conflicting data and return explicit outcomes (e.g. ask user to confirm or clarify).

**Key Components**

- **ParseExerciseSkill** — Extract exercise/set fields from phrase; handle missing/ambiguous fields.
- **GroupSeriesSkill** — Bisets/trisets; last set of group detection.
- **VoiceParserAgent** — Orchestrate parsing and return structured result or error category.
- **ErrorHandlerAgent** — Map parsing/validation outcomes to user-facing messages and next actions.

**Notes**

- Pipeline must not persist data; it returns structured data or error types. Persistence is decided in the application layer.

---

### 3. Application / Agents Layer

**Responsibilities**

- Orchestrate use cases: start/end session, log set, confirm set, resolve conflict.
- Coordinate voice pipeline, persistence, and UI feedback.
- Enforce process-level rules (e.g. do not persist incomplete set without confirmation).

**Key Agents**

- **ExerciseLoggerAgent** — New exercise input, supersets/trisets, final set detection.
- **SessionManagerAgent** — Session start/end, history.
- **ErrorHandlerAgent** — Misrecognition, missing fields, conflicts → user message and retry/clarify flow.

**Notes**

- Application layer does not contain low-level parsing or voice API calls; it uses the voice pipeline and repositories.

---

### 4. Backend API Layer

**Responsibilities**

- Receive requests from the mobile app.
- Authenticate and authorize callers.
- Validate request shape and delegate to application services.
- Return normalized JSON responses.

**Implementation**

- Node.js; Express or similar; Zod (or equivalent) for request/response validation.
- Structured logging (e.g. Pino) with correlation IDs and user/session identifiers.

**Example Endpoints**

- `POST /auth/...` (login, refresh).
- `POST /sessions` (start), `PATCH /sessions/:id` (end).
- `POST /sessions/:id/sets` (persist confirmed set or set group).
- `GET /sessions`, `GET /sessions/:id` (history, progress).

**Notes**

- API layer remains thin. No parsing or grouping logic in controllers.

---

### 5. Domain Layer

**Responsibilities**

- Model core entities: User, Session, Exercise, Set, SetGroup.
- Enforce business rules (e.g. set number, group consistency, session bounds).
- Keep concepts independent of transport or framework.

**Core Entities**

- User, Session (start/end time, duration), Exercise, Set (exercise, weight, reps, notes, order), SetGroup (superset/triset).

**Important Rule**

- Domain does not depend on voice API, HTTP transport, or UI framework.

---

### 6. Persistence Layer

**Database:** PostgreSQL hosted on **Neon** (managed, serverless-friendly). See [STACK.md](./STACK.md) for the single source of truth.

**Responsibilities**

- Store users, sessions, sets, set groups.
- Support history and progress queries.
- Support traceability (e.g. when a set was stored, for which session).

**Suggested Scope**

- users, sessions, exercises (if normalized), sets, set_groups (or equivalent schema).
- Migrations via a single tool (e.g. node-pg-migrate); schema under version control.

**Persistence Rules**

- Do not persist incomplete or unconfirmed sets.
- Session lifecycle (start/end) must be persisted.
- Failures should be traceable (logs) without storing raw voice in DB unless required by product.

---

### 7. External Integrations (Boundary)

**Responsibilities**

- Voice-to-text API: send audio or text, receive text; map errors to internal error model.
- OAuth providers: login flow; token refresh; map identity to internal user.

**Notes**

- Treat as adapters; keep configuration and secrets out of domain and application logic.

---

## Core State Model

Session and set lifecycle should be explicit enough to drive UI and persistence.

### Session States

- **active** — Session started, user can log sets.
- **completed** — Session ended; duration and sets finalized and persisted.

(Optional: `draft` if you support “prepared but not started” sessions; MVP can keep active/completed only.)

### Set / SetGroup States (Logical)

- **pending** — Parsed from voice but not yet confirmed by user (do not persist).
- **confirmed** — User confirmed; ready to persist.
- **persisted** — Stored in backend; part of session history.

Transitions: pending → confirmed (user confirms) → persisted (API success). On conflict or incomplete, remain pending until clarified.

### Notes

- Internal state transitions (e.g. persist success/failure) should be loggable. Retries (e.g. API retry) should not erase prior failure history.

---

## Main Data Flows

### Flow 1: Log set by voice

1. User speaks → mobile captures audio → voice API returns text.
2. Text → VoiceParserAgent / ParseExerciseSkill → structured set (or error category).
3. If incomplete or conflict → ErrorHandlerAgent → show message in Spanish; user corrects or confirms.
4. If complete and confirmed → ExerciseLoggerAgent / GroupSeriesSkill may attach to superset/triset.
5. Application layer sends confirmed set(s) to backend API → Persistence layer stores in DB.
6. Mobile updates local state and UI (e.g. “Set saved”).

### Flow 2: Session lifecycle

1. User starts session → API creates session (active) → persisted.
2. User logs sets (Flow 1) for that session.
3. User ends session → API updates session (completed), stores duration → persisted.
4. History/progress queries return sessions and sets for the user.

### Flow 3: History and progress

1. Client requests sessions (e.g. by date range) or progress summary.
2. API queries persistence layer; returns normalized JSON.
3. Mobile renders history/progress in Spanish.

---

## Tech stack

See [STACK.md](./STACK.md) for the single source of truth on stack and tooling; summary below.

- **Frontend:** React Native (mobile).
- **Backend:** Node.js; Neon (PostgreSQL).
- **Authentication:** OAuth (Google, Apple) or custom username/password.
- **Voice:** Voice-to-text recognition API (e.g. Google Speech-to-Text).
- **State & data:** Local state in React Native; persistence in Neon.
- **UI:** Custom React Native components (mobile-ready, shadcn-inspired).
- **Testing:** Jest; React Native Testing Library for components; unit tests for parsing and logic.

## Repository structure (high level)

```
gym-voice/
├── mobile/                 # React Native app
│   ├── src/
│   │   ├── components/     # UI components
│   │   ├── screens/        # Screens for flows
│   │   ├── services/      # API and voice recognition
│   │   ├── hooks/          # Custom hooks
│   │   └── utils/          # Helpers
│   └── App.tsx
├── backend/                # Node.js + Neon (PostgreSQL)
│   └── src/
│       ├── controllers/
│       ├── models/
│       ├── routes/
│       ├── services/
│       └── utils/
├── docs/                   # Product, process, architecture
├── scripts/                # Task/workflow scripts
└── .cursor/                # Rules, skills, commands
```

(.ai-system / .ai-context paths from the technical doc can live under mobile or repo root as agreed; agents/skills/rules are part of the design.)

## Modules and responsibilities

- **Mobile (React Native):** UI (Spanish), screens (login, session, history), voice capture, API client, local state. Calls voice API and backend API.
- **Backend:** Auth, user and session CRUD, exercise/set persistence, history and progress queries. Exposes REST (or equivalent) for mobile.
- **Voice pipeline:** Voice-to-text API → structured data (exercise, set, weight, reps, notes). Handled by parsing skills and agents.
- **Agents (logic/orchestration):**
  - **ExerciseLoggerAgent:** New exercise input, supersets, trisets, final set detection.
  - **SessionManagerAgent:** Session start/end, history.
  - **VoiceParserAgent:** Voice input → structured data.
  - **ErrorHandlerAgent:** Misrecognition, missing fields, conflicts.
- **Skills:** ParseExerciseSkill (extract from voice), GroupSeriesSkill (bisets/trisets), ProgressHistorySkill (fetch history), AlertSkill (inconsistencies, missing data).

## Data flow

1. User speaks → mobile captures audio → voice API returns text.
2. Text → VoiceParserAgent / ParseExerciseSkill → structured set (exercise, weight, reps, notes).
3. ExerciseLoggerAgent / GroupSeriesSkill → decide exercise and superset/triset grouping → confirm with user if needed.
4. Valid set/session data → backend API → Neon (users, sessions, exercises, sets, groups).
5. History/progress → backend queries → mobile for visualization.

## Boundaries

- **Domain vs external:** Internal model (user, session, exercise, set, set group) is the source of truth; external voice API and OAuth providers are integration boundaries; map their outputs into the domain model.
- **UI language:** Spanish for user-facing strings; code and comments in English.
- **Data integrity:** No persisting incomplete or conflicting sets without confirmation; validation and ErrorHandlerAgent at boundaries.

## Required reading before important work

- `PROJECT.md` — mission, scope, principles, sensitive areas.
- `docs/product/PRD.md` — product goal, MVP, workflows.
- `docs/architecture/STACK.md` — stack and tooling (single source of truth).
- `docs/architecture/# GymVoice – Business Logic.md` — user flow, business rules, exceptions.
- `docs/architecture/# GymVoice – Technical Documentation.md` — structure, agents, skills, rules, testing.
- `docs/process/TASK_EXECUTION_WORKFLOW.md`, `docs/process/DEFINITION_OF_DONE.md` — workflow and DoD.
- ADRs in `docs/architecture/adr/` for significant design decisions.

## Error Model

The system should classify errors explicitly so the UI and backend can react appropriately.

### Minimum Error Categories

- **UNRECOGNIZED_VOICE** — Voice input could not be parsed or matched to an exercise/set structure; ask user to repeat or correct.
- **INCOMPLETE_SET** — Required fields missing (e.g. reps or weight); do not persist until user confirms or provides.
- **CONFLICTING_DATA** — New set data conflicts with previous (e.g. weight/reps inconsistency); request clarification before persist.
- **AUTH_ERROR** — Login or token failure; surface to user without exposing secrets.
- **SESSION_ERROR** — Session load/save failure; allow retry or recovery where applicable.
- **VALIDATION_ERROR** — Business rule violated (e.g. invalid set number, invalid group); return clear message.

### Error Handling Principles

- Do not swallow errors; surface them in a user-appropriate way (Spanish in UI).
- Do not persist invalid or ambiguous data; confirm or clarify first.
- Do log operationally relevant failures (e.g. voice API failure, DB error) for support.
- Do attach actionable context where useful (e.g. which field is missing).

---

## Testing Strategy

### 1. Parsing / Voice Pipeline

- **ParseExerciseSkill:** Unit tests — given phrase → expected structure; missing/ambiguous fields → no persist, explicit result (e.g. ask for confirmation).
- **GroupSeriesSkill:** Unit tests — grouping logic for bisets/trisets; last set of group; edge cases.
- **VoiceParserAgent / ErrorHandlerAgent:** Unit or integration tests — success path and at least one error path (unrecognized, incomplete, conflict).

### 2. Session and Persistence

- Session start/end, duration, and storage.
- Set and set-group persistence; history and progress queries return consistent data.
- Integration tests: SessionManagerAgent with ExerciseLoggerAgent; backend APIs with DB.

### 3. UI

- Key screens and flows with React Native Testing Library (e.g. confirm set, view history).
- Spanish strings and critical user paths covered.
- Edge cases: supersets/trisets, missed sets, voice recognition errors (see Technical Documentation §7).

### 4. End-to-End (Optional for MVP)

- Smoke or critical-path E2E: login → start session → log one set by voice → confirm → end session → view history. Scope and tooling can be defined in a separate E2E strategy doc when needed.

---

## Security and Sensitive Data

### Sensitive Areas

- Authentication tokens and credentials (OAuth, custom).
- User and session data (personal workout history).
- Voice input (may be considered personal; handle according to product/legal stance).

### Principles

- Do not store secrets in code or unsafe config.
- Isolate secret access (e.g. env or secure store).
- Minimize exposure of sensitive data in logs.
- Apply least-privilege access where possible.

---

## References

- Business logic: `docs/architecture/# GymVoice – Business Logic.md`
- Technical documentation: `docs/architecture/# GymVoice – Technical Documentation.md`
