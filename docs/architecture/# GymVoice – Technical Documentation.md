# GymVoice – Technical Documentation

## 1. Overview

This document covers the **technical architecture and setup** for GymVoice, the gym workout tracker app using voice.
It includes repository structure, prompts, agents, rules, skills, backend, frontend, and testing strategy.

---

## 2. Tech Stack

- **Frontend**: React Native
- **Backend**: Node.js / Neon (PostgreSQL)
- **Authentication**: OAuth (Google, Apple) or custom username/password
- **Voice Processing**: Voice-to-text recognition API
- **State & Data Management**: Local state in React Native and backend persistence in Neon
- **UI Library**: Custom React Native components inspired by shadcn (mobile-ready)
- **Testing**: Jest / React Native Testing Library for components, unit tests for logic

---

## 3. Repository Structure

```

gymvoice/
├─ mobile/                   # React Native app
│  ├─ src/
│  │  ├─ components/         # UI components
│  │  ├─ screens/            # Screens for different flows
│  │  ├─ services/           # API and voice recognition service
│  │  ├─ hooks/              # Custom hooks
│  │  └─ utils/              # Helpers & utilities
│  └─ App.tsx
├─ backend/                  # Backend (Neon + API)
│  ├─ src/
│  │  ├─ controllers/
│  │  ├─ models/
│  │  ├─ routes/
│  │  ├─ services/
│  │  └─ utils/
├─ .ai-system/               # Cursor agents, skills, rules
│  ├─ agents/
│  ├─ skills/
│  └─ rules/
├─ .ai-context/              # Context files for agents
├─ tests/                    # Tests for frontend & backend
├─ package.json
└─ README.md

````

---

## 4. Agents, Skills, and Rules

### 4.1 Agents

- **ExerciseLoggerAgent**: Handles new exercise input, supersets, trisets, and final set detection.
- **SessionManagerAgent**: Manages workout sessions, start/end times, and history.
- **VoiceParserAgent**: Converts voice input into structured data.
- **ErrorHandlerAgent**: Detects voice misrecognition or missing fields.

### 4.2 Skills

- **ParseExerciseSkill**: Extract exercise name, weight, reps, and notes from voice.
- **GroupSeriesSkill**: Handles bisets/trisets grouping logic.
- **ProgressHistorySkill**: Fetches historical data for visualization.
- **AlertSkill**: Sends alerts for inconsistencies or missing data.

### 4.3 Rules

- **Language Rule**: UI in Spanish, but all code and comments must be in English.
- **Voice Confirmation Rule**: Ask the user if the next set belongs to a superset/triset.
- **Session Timeout Rule**: Detects exercise end after a period of inactivity.
- **Data Integrity Rule**: Prevents saving incomplete or conflicting sets.

---

## 5. Prompts & Workflow

- **super_prompt.md**: Contains all instructions for Cursor:
  - Create repo, milestones, and issues.
  - Generate folders and initial files.
  - Setup agents, skills, rules, and initial test files.
  - Provide recommended installation commands (React Native, dependencies).

- **Context file** (`.ai-context/context.md`):
  - Includes example voice phrases.
  - Contains decisions made on supersets, series, and session logic.

- **Command to run prompt**:
  Inside Cursor, select `super_prompt.md` and execute. Optionally, start from milestone `Project Setup`.

---

## 6. Dependencies & Installation

- **React Native CLI / Expo**: Choose CLI for more control, optionally Expo for faster prototyping.
- **Voice Recognition API** (e.g., Google Speech-to-Text or other service).
- **Database**: Neon (PostgreSQL) for user data, sessions, and exercise logs.
- **Testing**: Jest, React Native Testing Library.

**Installation Steps (example for MVP):**

1. Create the repo and initialize React Native:
   ```bash
   npx react-native init GymVoice
   cd GymVoice
````

2. Setup Neon backend with initial models and tables.
3. Install dependencies:

   ```bash
   npm install react-native-voice axios react-navigation
   npm install --save-dev jest @testing-library/react-native
   ```
4. Add `.ai-system/` and `.ai-context/` folders with agents and context files.
5. Add linter & formatter:

   ```bash
   npm install --save-dev eslint prettier
   ```

---

## 7. Testing Strategy

* **Unit tests**:

  * ParseExerciseSkill
  * GroupSeriesSkill
  * VoiceParserAgent
* **Integration tests**:

  * SessionManagerAgent with ExerciseLoggerAgent
* **UI tests**:

  * Screens and components using React Native Testing Library
* **Edge cases**:

  * Supersets/trisets
  * Missed sets
  * Voice recognition errors

---

## 8. Notes

* All code and comments are in English.
* UI is in Spanish.
* The system should be extensible for adding new agents, skills, or rules.
* Tests are part of the MVP and should be executed automatically when new features are added.
