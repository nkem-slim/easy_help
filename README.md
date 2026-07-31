# EasyHelp

A cross-platform Flutter application designed to improve access to autism support services for caregivers and families in Rwanda.

## Overview

Many families in Rwanda struggle to access autism support — specialists are concentrated in Kigali, information is scattered, and caregivers often have no easy way to connect with professionals or other families facing similar challenges. **EasyHelp** brings these pieces together in a single platform, letting caregivers:

- Find and browse autism specialists and clinics
- Book and manage appointments
- Access educational resources about autism
- Connect with other parents through a support forum
- Track their child's developmental progress

The goal is a practical, scalable platform that grows over time — adding more specialists, services, and features as user feedback comes in.

## Current Features (Implemented)

- **Onboarding** — splash screen and onboarding flow introducing the app to new users
- **Authentication** — email/password login, account registration, and Google sign-in
- **Navigation shell** — bottom navigation across Home, Favourites, Appointments, and Profile
- **Home dashboard** — greeting, search, learning/resource sections, action cards, and clinic previews
- **Clinic discovery** — search and filter clinics/doctors by name, specialty, or location
- **Doctor details** — specialist info, services offered, statistics, and a location preview
- **Appointment booking** — full flow with booking, confirmation, loading, and appointment list states
- **Profile** — notification toggles, language settings, privacy policy, and log out

## Planned / In Progress

The following feature areas exist in the project structure but are currently placeholders, pending further development:

- Learn (educational resources)
- Journal (developmental progress tracking)
- Communicate (support forum/messaging)
- Favorites
- Settings (some options are marked "coming soon")

## Tech Stack

- **Framework:** Flutter (cross-platform: Android & iOS from one codebase)
- **State management:** BLoC — features like authentication and appointments use blocs that respond to events and emit loading/success/error states
- **Backend:** Firebase (Core, Authentication, Cloud Firestore, Storage) and Google Sign-In. The repository layer is structured for Firebase, but currently uses stubbed remote data sources until Firebase is fully configured — this lets development continue in parallel with backend setup.
- **Maps/Location:** Google Maps and OpenRouteService, currently using fixed clinic coordinates in the doctor model as a placeholder ahead of full location-data integration
- **Other:** `connectivity_plus` (offline checks), `shared_preferences` (local storage)

## Architecture

The project follows **clean architecture** with a feature-based structure. Each feature is organized into its own folder with **presentation**, **domain**, and **data** layers, which keeps concerns separated and makes the app easier to extend without touching unrelated modules.

```
lib/
├── features/
│   ├── appointments/
│   ├── auth/
│   ├── clinics/
│   ├── communicate/
│   ├── favorites/
│   ├── home/
│   ├── journal/
│   ├── learn/
│   ├── profile/
│   ├── screening/
│   ├── settings/
│   └── support/
├── navigation/
├── network/
├── routes/
├── theme/
├── usecases/
├── utils/
├── video/
├── widgets/
└── main.dart
```

Dependency injection is handled through the core layer, with `flutter_bloc` providing blocs at the top level.

## UI Design

The interface follows a soft, healthcare-oriented style — rounded cards, calm spacing, and clear visual hierarchy:

- Onboarding uses large illustrations with short, benefit-driven messaging
- Login uses a card-like layered composition with a background illustration and social sign-in
- Home is dashboard-style: greeting and search up top, followed by content sections and clinic highlights
- Clinic/doctor cards are designed for easy scanning and comparison
- Profile follows a grouped settings layout with toggles and tappable rows

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed
- A Firebase project (Authentication + Firestore) once backend integration is complete

### Setup

1. Clone the repository
   ```bash
   git clone <your-repo-url>
   cd easy_help
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Configure Firebase (once ready)
   - Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to their platform folders
   - Copy `.env.example` to `.env` and fill in environment variables
   - Confirm `.firebaserc` and `firebase.json` point to your Firebase project

4. Run the app
   ```bash
   flutter run
   ```

## Firestore Rules

Security rules for Firestore are defined in `firestore.rules`.

## Author

GROUP 11 — Software Engineering students, African Leadership University (ALU)

---

*EasyHelp is a summative software engineering project, under active development. Contributions and feedback are welcome as the platform expands toward a fuller caregiver support experience.*




# easy_help

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
