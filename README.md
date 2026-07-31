# Easy Help

Easy Help is a Flutter mobile application built to help caregivers in Rwanda spot early signs of Autism Spectrum Disorder (ASD), take a quick screening test, find nearby clinics and specialists, and book appointments with doctors — all in one place.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Firebase Setup](#firebase-setup)
- [Testing](#testing)
- [Development Workflow](#development-workflow)

---

## Overview

Easy Help guides a caregiver through a simple journey:

1. **Onboarding** — learn what early signs of autism look like and why early screening matters.
2. **Auth** — register, log in, or recover a password.
3. **Home** — quick access to learning resources, a screening test, clinics, and support.
4. **Find Clinic** — search and browse nearby clinics and specialists.
5. **Booking** — pick a doctor, fill in appointment details, choose a date/time, and confirm.
6. **Booked Appointments** — view, track, and manage upcoming appointments.
7. **Profile** — manage account settings, view the privacy policy, and log out.

---

## Features

### Onboarding
- Three-screen intro flow: *Spot the Sign Early → Take a Quick Test Today → Find Solutions*
- Skip / Next navigation with progress indicators

### Authentication
- Login, Register, and Forgot Password screens
- Firebase Authentication wired for real: email/password sign-in **and** Google Sign-In
- Displays the currently logged-in user's info across the app
- Firestore-backed user profile documents scoped by UID

### Home Screen
- Personalized greeting header
- Search bar for finding clinics
- Quick-action cards: **Learn**, **Take Test**, **Ask**
- Helpful videos section
- Helpful clinics preview section

### Find Clinic
- Location-based search UI
- Clinic list with ratings, patient counts, and availability
- Doctor details page, including a map preview of the clinic location
- "Book Now" entry point into the booking flow

### Favourite Clinic
- Save/unsave clinics from the clinic list or doctor details page
- Dedicated Favourites tab with search-within-favourites and an empty state

### Screening / Take Test
- Multi-question guided test flow ("How to Spot Early Signs of Autism Spectrum Disorder")
- Progress indicator across questions
- Results screen with a risk-level summary (e.g. "Low Risk")
- Follow-up resources: helpful videos and "Nurturing Growth at Home" guidance

### Appointments
- Doctor details page (bio, ratings, services, stats)
- Appointment-for form (patient name, contact, relationship)
- Calendar + time slot picker with reminder options
- Booking confirmation screen
- **Booked Appointments** tab: view, and manage appointments tied to the logged-in user, backed by Firestore with real-time permission rules

### Profile
- Reusable profile widgets (header, tiles, icon badges, section titles)
- Edit Profile → User Details screen (labeled fields, gender selector, day/month/year date-of-birth picker with month-based validation)
- Profile picture support
- Privacy Policy screen, linked from the profile
- Logout flow behind a confirmation dialog

---

## Architecture

The project follows **Clean Architecture**, split by feature, with each feature broken into three layers:

```
feature/
├── data/
│   ├── datasources/   → Firebase/remote or stub data sources
│   ├── models/        → DTOs (fromMap / toMap / fromEntity)
│   └── repositories/  → Repository implementations
├── domain/
│   ├── entities/       → Core business objects (Equatable)
│   ├── repositories/    → Abstract repository contracts
│   └── usecases/        → Single-responsibility use cases
└── presentation/
    ├── bloc/            → State management (flutter_bloc)
    ├── pages/           → Screens
    └── widgets/         → Reusable UI components
```

Cross-cutting concerns (network info, error handling, DI, routing, theming) live under `lib/core/`.

Dependency injection is handled via **GetIt**, registered in `lib/core/di/injection_container.dart`. Auth and Appointments are wired to real Firebase implementations; **Screening** still runs on a stub data source pending Firestore integration (see [Roadmap](#roadmap)).

Error handling uses **dartz's `Either<Failure, T>`** pattern throughout the repository layer, keeping success/failure explicit at every boundary.

---

## Tech Stack

| Concern | Technology |
|---|---|
| Framework | Flutter |
| Language | Dart |
| State management | flutter_bloc |
| Backend | Firebase (Auth, Cloud Firestore) |
| Dependency Injection | get_it |
| Functional error handling | dartz (`Either`) |
| Auth providers | Firebase Auth (email/password), Google Sign-In |
| Connectivity checks | connectivity_plus |
| Maps | Google Maps JavaScript API (web) |
| Environment config | flutter_dotenv |

---

## Project Structure

```
lib/
├── core/
│   ├── constants/        → App strings, colors, Firestore collection names
│   ├── di/                → injection_container.dart
│   ├── errors/            → Failures & exceptions
│   ├── maps/              → Google Maps bootstrap
│   ├── network/           → Connectivity/network info
│   ├── routes/            → App router and route names
│   └── theme/             → App theming
├── features/
│   ├── auth/
│   ├── appointments/
│   ├── screening/
│   └── profile/
├── firebase_options.dart
└── main.dart
```

---

## Getting Started

### Prerequisites
- Flutter SDK installed
- A Firebase project (or access to the shared `easy-help-rw` project)
- Firebase CLI installed (`npm install -g firebase-tools`)

### Installation

```bash
git clone https://github.com/nkem-slim/easy_help.git
cd easy_help
flutter pub get
```

### Environment variables

Create a `.env` file in the project root with any required keys (e.g. Google Maps API key):

```
GOOGLE_MAPS_API_KEY=your_key_here
```

### Run the app

```bash
flutter run
```

---

## Firebase Setup

This project uses Firebase Authentication and Cloud Firestore.

1. Link the Firebase CLI to the project:
   ```bash
   firebase use --add
   ```
   Select `easy-help-rw` and set an alias (a `.firebaserc` is already committed for convenience).

2. Deploy Firestore rules after any changes to `firestore.rules`:
   ```bash
   firebase deploy --only firestore:rules
   ```

3. Firestore security rules currently scope access per-collection to the authenticated user's UID (e.g. `users/{userId}` and `appointments/{appointmentId}` both check `request.auth.uid` against the relevant owner field).

4. **Composite indexes:** some queries (e.g. filtering appointments by `patientId` and ordering by `date`) require a composite index. If you see a `failed-precondition` error mentioning an index, follow the link Firestore provides in the error message to create it directly in the console.

---

## Testing

The Screening feature has both unit and widget test coverage:

**Unit tests** — `score_screening_answers`:
- All-healthy answers score 0, resolve to Low risk, flag no domains
- All-concerning answers score 4, resolve to High risk, flag all four domains
- Mixed answers score 2, resolve to Medium risk, flag exactly the implicated domains

**Widget tests** — `ScreeningResultPage`:
- Low risk result renders the Low Risk badge, no "Areas to watch" section
- High risk result renders the Medium/High Risk badge and lists every flagged domain

Run them with:

```bash
flutter test
```

**Static analysis:**

```bash
flutter analyze
```

should report `No issues found!`. If `analysis_options.yaml` isn't already present at the project root, add:

```yaml
include: package:flutter_lints/flutter.yaml
```

**Coverage gap:** Auth and Appointments do not yet have automated tests — see [Roadmap](#roadmap).

---

## Development Workflow

- **Branching:** feature work happens on branches named `feature/<contributor>/<feature-name>` off of `dev`.
- **Merging:** feature branches are merged into `dev` via pull request; `dev` is periodically merged into `main` for releases.
- **Commit style:** commits are prefixed by intent — `feat:`, `fix:`, `update:`, `chore:`, `create:` — to keep history scannable.
- **PRs:** include a short summary of what changed, screenshots/UI previews where relevant, and a test plan checklist for larger features.
