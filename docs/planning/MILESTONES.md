# Project Milestones

**Purpose:** Single source of truth for MVP milestone definitions: description, expected outcome, deliverables, and dependencies.

**Related documents:**
- [MVP_PLAN.md](MVP_PLAN.md) — MVP boundary, implementation order, and issue mapping.
- [PRD.md](../product/PRD.md) — Product scope and MVP framing.
- **GitHub:** [jlmonroy13/gym-voice](https://github.com/jlmonroy13/gym-voice) — Issues can be assigned to milestones on the project board.

---

## M1 – Foundation

**Description:** Set up the project foundation required to build GymVoice safely and consistently. This milestone focuses on repository workflow, folder structure, mobile and backend scaffolding, authentication, and the first vertical slice: voice input → parse → persist one set.

This milestone does not include full superset/triset flows or history UI. Its goal is a stable technical base and proof that voice-to-persist works for a single set.

**Expected outcome:** Repo, workflow, baseline docs, mobile + backend structure, auth, basic voice integration, first vertical slice (user can log one set by voice and see it persisted).

**Deliverables:**
- Project and process docs (PROJECT.md, PRD, SOLUTION_DESIGN, DoD, workflow).
- Branching convention and PR template.
- CI and README run instructions (or equivalent).
- Folder structure: `mobile/` (React Native), `backend/` (Node + Neón), `docs/`, `scripts/`, `.cursor/`.
- Authentication (OAuth or custom); user registration for history.
- Voice-to-text integration (e.g. Google Speech-to-Text or similar).
- ParseExerciseSkill (or equivalent): raw text → structured set (exercise, set number, weight, reps, notes).
- Backend: session and set persistence (minimal schema); API to create session and add set.
- First vertical slice: speak → parse → confirm → persist one set; retrieve in a simple way (e.g. API or minimal UI).

**Dependencies:** None (first milestone).

**Issues:** Create and assign issues to this milestone on the GitHub project board; link in issue descriptions to this document.

---

## M2 – MVP

**Description:** Implement the full MVP: complete voice logging flow, supersets and trisets, session start/end, history and progress view, error handling and confirmations, Spanish UI, and tests for parsing and grouping.

This milestone should produce an app where the user can complete a full workout by voice (with confirmations when needed), with all sets and groups stored correctly and history visible.

**Expected outcome:** Full voice logging (exercises, sets, reps, weights, notes); supersets/trisets with grouping; session start/end; history and progress view; error handling and confirmations; Spanish UI; tests for ParseExerciseSkill, GroupSeriesSkill, session flow, and key UI.

**Deliverables:**
- VoiceParserAgent and ErrorHandlerAgent (or equivalent) for parsing and error/confirmation flows.
- GroupSeriesSkill and ExerciseLoggerAgent for superset/triset grouping and exercise/session lifecycle.
- SessionManagerAgent: session start/end, duration, history.
- Backend: full session/set/set-group model and APIs; history and progress queries.
- Mobile: screens for login, session, voice capture, confirm/correct set, view history (day/week/month).
- Business rules enforced: no persist of incomplete or conflicting sets without confirmation.
- Spanish UI strings; code and comments in English.
- Unit tests: ParseExerciseSkill, GroupSeriesSkill. Integration tests: session flow, ExerciseLogger + SessionManager. UI tests: key screens/flows where applicable.

**Dependencies:** M1 (Foundation) — auth, voice integration, parsing, and persistence baseline must be in place.

**Issues:** Create and assign issues to this milestone; keep dependencies visible (e.g. "Depends on #N").

---

## M3+ – Post-MVP

**Description:** Optional future milestones for richer progress visualization, offline support, additional agents or skills, or other enhancements. Scope to be defined when M2 is complete or when prioritization is updated.

**Expected outcome:** Defined per initiative (e.g. richer charts, offline sync, new skills).

**Dependencies:** M2 (MVP) complete.

---

## Dependency and Issue Visibility

- Dependencies between milestones and between issues must be visible in issue descriptions (e.g. "Depends on #N") and on the project board.
- Do not start an issue whose dependencies are not closed or explicitly relaxed.
