# Project Setup

Steps for a new team member to get Easy Help running locally, including Firebase access.

## 1. Get added to the Firebase project

Ask a project Owner to add you as a member on the `easy-help-rw` Firebase project:

1. [console.firebase.google.com](https://console.firebase.google.com) → **Easy Help**
2. Gear icon → **Project settings** → **Users and permissions** tab
3. **Add member** → your Google account email → role **Editor**

You'll get an email invite, or the project will just appear when you log into the
Firebase console with that Google account.

## 2. Install the tooling

```bash
npm install -g firebase-tools
firebase login              # log in with the Google account that was invited
dart pub global activate flutterfire_cli
```

## 3. Clone the repo and generate your local Firebase config

```bash
git clone <repo-url>
cd easy_help
flutterfire configure
```

Pick the `easy-help-rw` project when prompted (it only shows up once you've been
added as a member), and select the android/ios/web platforms you need.

This generates:

- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

These are all gitignored — every developer generates their own copy locally, they're
never committed or shared manually.

## 4. Install dependencies and run

```bash
flutter pub get
flutter run
```

You should be able to sign up / sign in with email+password or Google immediately.
Firestore writes to your own `users/{uid}` document will succeed under the current
security rules (`firestore.rules`).

## 5. Google Sign-In on Android: register your debug SHA-1

Google Sign-In verifies requests using the package name plus the SHA-1 fingerprint of
whatever certificate signed the APK. Android auto-generates a unique debug keystore per
developer machine, so your debug build's fingerprint isn't registered yet — Google Sign-In
will fail with a `DEVELOPER_ERROR` until it is (email/password sign-in is unaffected, since
it doesn't involve certificate verification).

```bash
cd android
./gradlew signingReport
```

Copy the `SHA1` value under the `debug` variant, then in the Firebase console go to
**Project settings → Your apps → Android app → Add fingerprint** and paste it in.

## Notes

- `firestore.rules` currently only covers the `users` collection (each user can read/write
  their own document). If you're adding a new Firestore collection, extend the rules file
  and deploy with `firebase deploy --only firestore:rules`.
- iOS Google Sign-In additionally requires the `REVERSED_CLIENT_ID` URL scheme to be present
  in `ios/Runner/Info.plist` — check this is set up if you're testing on iOS.
