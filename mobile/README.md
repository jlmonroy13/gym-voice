# GymVoice Mobile (React Native, TypeScript)

Minimal React Native + TypeScript scaffold for the GymVoice mobile app. This project is the UI layer for the voice-first workout logging flow.

## Prerequisites

- Node.js LTS and npm (or yarn)
- React Native CLI environment configured for at least one platform (iOS or Android)

## Install dependencies

```bash
cd mobile
npm install
```

## Scripts

- `npm run start` — start Metro bundler
- `npm run ios` — run the app on iOS simulator (requires Xcode tooling)
- `npm run android` — run the app on Android emulator (requires Android tooling)
- `npm run lint` — run ESLint over the project
- `npm run typecheck` — run TypeScript type checking
- `npm run test` — run Jest tests (includes a basic App smoke test)

## Project structure

```text
mobile/
  App.tsx           # Root component (Spanish UI copy; no business logic)
  src/
    __tests__/      # Jest + React Native Testing Library tests
```

This structure is consistent with the architecture design: mobile is the UI layer only (no voice parsing, agents, or persistence here).

