# Stack and tooling — GymVoice

This document is the single source of truth for stack and tooling decisions for the GymVoice mobile app and backend.

Implementers should assume these choices; planning and architecture docs (MVP_PLAN, SOLUTION_DESIGN) reference this document.

---

## Core stack decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| **Mobile framework** | React Native | Cross-platform (iOS/Android), single codebase, strong ecosystem; aligns with voice and API integration needs. |
| **Language (mobile)** | TypeScript / JavaScript | TypeScript preferred for type safety and refactors; consistent with backend. |
| **Backend runtime** | Node.js (LTS) | Same language as mobile tooling; simple REST API and persistence; good fit for MVP. |
| **Type discipline** | TypeScript (backend), TypeScript or JavaScript (mobile) | Required for API contracts, domain models, and safe refactors; mobile can adopt TypeScript gradually. |
| **Primary database** | PostgreSQL on **Neon** | Neon is the managed PostgreSQL provider (serverless, branch-friendly). Used for dev and production; stores users, sessions, sets, set groups. |
| **Test framework (backend)** | Jest or Vitest | Unit and integration tests; good TypeScript support; use one consistently. |
| **Test framework (mobile)** | Jest + React Native Testing Library | Component and screen tests; Spanish strings and key flows covered. |
| **Lint & format** | ESLint + Prettier | CI and PR checks; consistent style; TypeScript-aware linting. |
| **Migration tool** | node-pg-migrate or equivalent | PostgreSQL migrations with up/down scripts when persistence schema work starts. |

---

> For architecture and data flow, see [`SOLUTION_DESIGN.md`](./SOLUTION_DESIGN.md). For product scope and MVP framing, see [`PRD.md`](../product/PRD.md). For milestones and MVP boundary, see [`MILESTONES.md`](../planning/MILESTONES.md) and [`MVP_PLAN.md`](../planning/MVP_PLAN.md). For workflow and completion standard, see [`TASK_EXECUTION_WORKFLOW.md`](../process/TASK_EXECUTION_WORKFLOW.md) and [`DEFINITION_OF_DONE.md`](../process/DEFINITION_OF_DONE.md).

## Mobile layer decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| **UI components** | Custom React Native components (shadcn-inspired, mobile-ready) | Consistent, accessible UI; Spanish copy; no web-only dependencies. |
| **State (client)** | React state / context or minimal state library | Local state for session and UI; server state via API calls; keep MVP simple. |
| **Voice input** | Platform APIs + voice-to-text service (e.g. Google Speech-to-Text) | Capture audio; send to external API; receive text for parsing pipeline. |
| **API client** | fetch or typed client (e.g. Axios) | REST JSON; auth headers; error handling aligned with backend error model. |

---

## Backend API decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| **HTTP framework** | Express or similar | Simple, well-documented; thin API layer; no business logic in controllers. |
| **Request/response validation** | Zod or similar | Schema validation with TypeScript inference; clear error messages for invalid payloads. |
| **Logging** | Pino or structured JSON logger | Structured logs; correlation IDs; user/session identifiers for support. |
| **API style** | REST, JSON | Aligns with SOLUTION_DESIGN; mobile consumes JSON. |

---

## Auth and integrations

| Decision | Choice | Rationale |
|----------|--------|-----------|
| **Auth** | OAuth (Google, Apple) and/or custom username/password | Product choice; isolate tokens and secrets; no secrets in code. |
| **Secrets** | Environment variables or secure store | Backend: env; mobile: secure storage for tokens; never commit secrets. |

---

## References

- **Architecture and layers:** [SOLUTION_DESIGN.md](./SOLUTION_DESIGN.md).
- **MVP boundary and milestones:** [MVP_PLAN.md](../planning/MVP_PLAN.md), [MILESTONES.md](../planning/MILESTONES.md).
