# GymVoice – Business Logic

## 1. Overview

**GymVoice** is a mobile application that allows users to track their gym progress using **natural voice**, avoiding manual input of exercises, sets, or repetitions.
The goal is for the user to focus on their workout while the app captures all details of the session, including supersets (bisets) and trisets.

---

## 2. Business Objectives

1. Simplify workout logging through voice commands.
2. Track sets, repetitions, weights, and perceived effort for each exercise.
3. Manage individual exercises, bisets, and trisets.
4. Visualize users' historical progress (daily, weekly, monthly).
5. Alert users of errors or inconsistencies during the workout session.
6. Maintain a fast, intuitive, and natural user experience.
7. Ensure that data can be analyzed later for performance statistics.

---

## 3. General User Flow

1. **Login**
   - Users authenticate via OAuth (Google, Apple) or their own account.
   - The user is registered in the database to maintain history.

2. **Workout session start**
   - Users select an existing workout or start a new one.
   - The start date and time of the session are recorded.

3. **Exercise logging**
   - After each set, the user speaks into the device:
     - Example: “First set bench press, 20kg, 10 reps, it was heavy.”
   - The app interprets:
     - Exercise name
     - Set number
     - Weight
     - Repetitions
     - Effort or sensation notes
   - The app confirms whether the next set belongs to the same exercise, a superset, or a triset.

4. **Supersets and Trisets**
   - If the next set is part of a biset or triset:
     - The app asks: “Is this part of a superset or triset?”
     - The user confirms.
   - Each set is recorded within the group in order.

5. **Exercise completion**
   - The app automatically detects when an exercise is finished if:
     - No new sets are logged within a defined time.
     - The user indicates “I finished this exercise.”
   - The app can suggest the final set if it detects the last one of the superset/triset.

6. **Session completion**
   - When all exercises are done, the user says “finish workout.”
   - The app saves the full session and updates the progress history.

---

## 4. Business Rules

1. **Single set**
   - Each set belongs to an exercise.
   - Must include repetitions and weight.

2. **Supersets / Trisets**
   - A set can be part of a biset or triset.
   - The system must group sets under the same exercise group.
   - Users can add notes for each set, even inside supersets or trisets.

3. **Set confirmation**
   - The app may automatically suggest if a set belongs to a superset/triset.
   - Users can accept or modify the suggestion.

4. **Errors and exceptions**
   - If speech recognition cannot understand the exercise or repetitions, the app asks for confirmation.
   - If the user skips sets, the app allows adding them manually later.
   - If there is a conflict between sets (weight or repetitions inconsistent), the app requests clarification.

5. **History and progress**
   - Each session is stored, including:
     - Date and time
     - Exercises performed
     - Sets, repetitions, weights
     - Effort notes
     - Supersets/trisets groups
   - Users can view:
     - Sessions by day, week, or month
     - Progress in weight and repetitions per exercise
     - Performance graphs and trends

6. **Language and UX**
   - The interface is fully in **Spanish** for the user.
   - All internal records and data structure follow strict rules for app consistency.

---

## 5. Special Cases

1. **Unrecognized exercises**
   - The app should suggest similar exercises for selection.

2. **Incomplete sets**
   - If the user forgets to indicate repetitions or weight, the app asks for confirmation before saving.

3. **Interruptions**
   - If the user pauses or interrupts the workout, the session remains open and can be resumed.

4. **Superset/triset updates**
   - Users can add a set to an existing group if they realize they forgot to include it.

5. **Additional notes**
   - Users can add effort or sensation notes to any set.

---

## 6. Data Stored

- User: ID, name, history
- Workout session: date, time, duration
- Exercise: name, aliases
- Set: number, repetitions, weight, notes, group (superset/triset)
- Set group: biset/triset (list of sets)
- Full history for reports and graphs

---

**This document covers all business logic for GymVoice, including user flow, rules, exceptions, and how voice input and progression are handled.**
