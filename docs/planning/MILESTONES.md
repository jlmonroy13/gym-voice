# Project Milestones

**Purpose:** Single source of truth for MVP milestone definitions: description, expected outcome, deliverables, and dependencies.

**Related documents:**
- [MVP_PLAN.md](MVP_PLAN.md) — MVP boundary, implementation order, and issue mapping.
- [PRD.md](../product/PRD.md) — Product scope and MVP framing.
- **GitHub:** [jlmonroy13/gym-voice](https://github.com/jlmonroy13/gym-voice) — Issues can be assigned to milestones on the project board.

---

## M1 – Foundation

**Description:** Set up the project foundation so the team can develop and ship small changes safely. This milestone focuses on repository workflow, folder structure, mobile and backend scaffolding, and baseline documentation. No auth or voice yet.

**Expected outcome:** Repo, workflow, baseline docs, mobile + backend structure, CI; project is ready for feature work.

**Deliverables:**
- Project and process docs (PROJECT.md, PRD, SOLUTION_DESIGN, DoD, workflow).
- Branching convention and PR template.
- CI and README run instructions (or equivalent).
- Folder structure: `mobile/` (React Native), `backend/` (Node + Neón), `docs/`, `scripts/`, `.cursor/`.

**Dependencies:** None (first milestone).

**Issues:** Create and assign issues to this milestone on the GitHub project board; link in issue descriptions to this document.

---

## M2 – Auth and first vertical slice

**Description:** Add authentication and prove voice-to-persist for a single set. Voice-to-text integration, ParseExerciseSkill, minimal backend persistence, and one end-to-end flow: speak → parse → confirm → persist one set (retrievable via API or minimal UI).

**Expected outcome:** Auth (OAuth or custom); user identity for history; voice-to-text integration; ParseExerciseSkill (raw text → structured set); backend session and set persistence (minimal schema); first vertical slice working.

**Deliverables:**
- Authentication (OAuth or custom); user registration for history.
- Voice-to-text integration (e.g. Google Speech-to-Text or similar).
- ParseExerciseSkill (or equivalent): raw text → structured set (exercise, set number, weight, reps, notes).
- Backend: session and set persistence (minimal schema); API to create session and add set.
- First vertical slice: speak → parse → confirm → persist one set; retrieve in a simple way (e.g. API or minimal UI).

**Dependencies:** M1 (Foundation).

**Issues:** Create and assign issues to this milestone; keep dependencies visible (e.g. "Depends on #N").

---

## M3 – Voice pipeline and session

**Description:** Complete voice logging flow, agents, supersets/trisets, and session lifecycle. No history UI or full polish yet.

**Expected outcome:** VoiceParserAgent and ErrorHandlerAgent; GroupSeriesSkill and ExerciseLoggerAgent; SessionManagerAgent; session start/end and duration; set and set-group persistence; confirm/clarify flow; business rules (no persist of incomplete or conflicting sets without confirmation).

**Deliverables:**
- VoiceParserAgent and ErrorHandlerAgent (or equivalent) for parsing and error/confirmation flows.
- GroupSeriesSkill and ExerciseLoggerAgent for superset/triset grouping and exercise/session lifecycle.
- SessionManagerAgent: session start/end, duration.
- Backend: full session/set/set-group model and APIs (excluding history/progress queries).
- Business rules enforced: no persist of incomplete or conflicting sets without confirmation.

**Dependencies:** M2 (Auth and first vertical slice).

**Issues:** Create and assign issues to this milestone; keep dependencies visible (e.g. "Depends on #N").

---

## M4 – History, progress, and polish

**Description:** History and progress view, mobile screens for session and history, Spanish UI, and tests. MVP is complete at the end of this milestone.

**Expected outcome:** User can complete a full workout by voice (with confirmations), with all sets and groups stored correctly; history visible by day/week/month; Spanish UI; critical paths covered by unit/integration/UI tests.

**Deliverables:**
- Backend: history and progress queries.
- Mobile: screens for login, session, voice capture, confirm/correct set, view history (day/week/month).
- Spanish UI strings; code and comments in English.
- Unit tests: ParseExerciseSkill, GroupSeriesSkill, VoiceParserAgent. Integration tests: session flow, ExerciseLogger + SessionManager. UI tests: key screens/flows where applicable.
- Error handling and confirmations polished; progress visualization (basic).

**Dependencies:** M3 (Voice pipeline and session).

**Issues:** Create and assign issues to this milestone; keep dependencies visible (e.g. "Depends on #N").

---

## M5+ – Post-MVP

**Description:** Optional future milestones for richer progress visualization, offline support, additional agents or skills, or other enhancements. Scope to be defined when M4 is complete or when prioritization is updated.

**Expected outcome:** Defined per initiative (e.g. richer charts, offline sync, new skills).

**Dependencies:** M4 (History, progress, and polish) — MVP complete.

---

## Dependency and Issue Visibility

- Dependencies between milestones and between issues must be visible in issue descriptions (e.g. "Depends on #N") and on the project board.
- Do not start an issue whose dependencies are not closed or explicitly relaxed.
- MVP is complete when M4 is done.
