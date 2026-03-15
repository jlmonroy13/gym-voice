# GymVoice — MVP plan

**Purpose:** Single reference for MVP boundary, milestone structure, implementation order, and stack. See also docs/product/PRD.md and docs/planning/MILESTONES.md.

**Execution readiness:** This plan defines what is in/out of scope, how milestones are structured, and a suggested implementation order. Map concrete issues to M1/M2 (and later milestones) in MILESTONES.md.

---

## 1. MVP boundary (one page)

### In scope

| Area | What is included |
|------|------------------|
| **Auth** | OAuth (Google, Apple) or custom username/password; tokens and session identity. |
| **Session lifecycle** | Start session → log sets → end session; store date, time, duration. |
| **Voice pipeline** | Capture voice → voice-to-text API → parse to structured set (exercise, weight, reps, notes) → confirm or clarify → persist. |
| **Supersets / trisets** | Detect or ask grouping; store sets in groups with notes. |
| **Persistence** | Users, sessions, sets, set groups; history and progress queries. |
| **API** | Auth endpoints; session start/end; persist confirmed sets; history/progress. Thin API layer; no parsing logic in controllers. |
| **Domain** | Internal model (user, session, exercise, set, set group); validation rules; explicit confirmation before persist. |
| **Error handling** | Unrecognized or incomplete input → confirm or correct; conflicts → clarify before persist; no silent persist of invalid data. |
| **UI** | Spanish for user-facing strings; key screens (login, session, history); code and comments in English. |
| **Testing** | Unit tests for ParseExerciseSkill, GroupSeriesSkill, VoiceParserAgent; integration for SessionManager + ExerciseLogger; UI tests for key screens. |

### Out of scope for MVP

- Social features, leaderboards, coach dashboards.
- Offline-first sync and conflict resolution across devices.
- Advanced analytics, charts, or export.
- Multiple users per device or family accounts.
- Full catalog of exercises or equipment; MVP can start with free-text exercise names.
- E2E tests (optional for MVP; can be added in a later milestone).

### Success definition

MVP is done when: a user can log in → start a session → log at least one set by voice (with confirmation) → end the session → see session and history; supersets/trisets can be grouped and stored; incomplete or conflicting voice input does not get persisted without confirmation; and critical paths are covered by unit/integration/UI tests.

---

## 2. Milestone structure

| # | Milestone | Outcome |
|---|-----------|--------|
| **M1** | **Foundation** | Repo, workflow, baseline docs, project setup (mobile + backend), auth, basic API; team can ship small changes safely. |
| **M2** | **Voice pipeline and session** | Voice capture → parsing → structured set; session start/end; set and set-group persistence; confirm/clarify flow. |
| **M3+** | **History, progress, polish** | History view (sessions by day/week/month); progress and trends; error handling and UX polish; optional E2E. |

For detailed description, deliverables, dependencies, and issues per milestone, see [MILESTONES.md](MILESTONES.md).

---

## 3. Stack decisions (locked)

**Status:** Stack and tooling are documented in **[docs/architecture/STACK.md](../architecture/STACK.md)**.

| Area | Decision |
|------|----------|
| **Mobile** | React Native; TypeScript or JavaScript; Jest + React Native Testing Library |
| **Backend** | Node.js LTS; Express (or similar); Zod (or equivalent); Pino (or structured logging) |
| **Database** | PostgreSQL (Neon) |
| **Auth** | OAuth (Google, Apple) and/or custom; secrets via env / secure store |
| **Voice** | Voice-to-text API (e.g. Google Speech-to-Text); parsing and grouping in app/backend |
| **Lint & format** | ESLint + Prettier |
| **Migrations** | node-pg-migrate or equivalent when schema work starts |

**Source of truth:** [docs/architecture/STACK.md](../architecture/STACK.md)

---

## 4. Suggested implementation order

| Order | Theme | Summary |
|-------|--------|--------|
| 0 | Lock stack | Document stack and tooling (STACK.md). |
| 1 | Project setup | Mobile (React Native) + backend (Node + Neón); repo workflow; CI (lint, typecheck, test). |
| 2 | Auth | Login (OAuth or custom); token handling; basic API with auth. |
| 3 | Voice pipeline | Capture → voice API → ParseExerciseSkill / VoiceParserAgent → structured set; no persist yet. |
| 4 | Session and persistence | Session start/end; set and set-group persistence; SessionManagerAgent, ExerciseLoggerAgent. |
| 5 | Superset/triset | GroupSeriesSkill; grouping and confirmation flow. |
| 6 | Session completion and history | End session; history API + UI (sessions, progress). |
| 7 | Error handling and polish | Confirmations, conflict clarification, alerts; progress visualization; tests. |

Map issues to these themes and to M1/M2 in MILESTONES.md.
