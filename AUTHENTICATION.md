# 🔐 Authentication setup and troubleshooting

> [!IMPORTANT]
> This guide reflects the repository configuration at the time it was written.
> Firebase Console settings (such as enabled providers and authorized domains)
> are not stored in this repository and must be checked separately.

## Contents

- [At a glance](#at-a-glance)
- [What is implemented](#what-is-implemented)
- [Current Firebase configuration](#current-firebase-configuration)
- [One-time Firebase Console setup](#one-time-firebase-console-setup)
- [Android setup](#android-setup)
- [Web setup](#web-setup)
- [Run and diagnostic commands](#run-and-diagnostic-commands)
- [Troubleshooting](#troubleshooting)
- [Security and account-handling notes](#security-and-account-handling-notes)
- [Configuration checklist before release](#configuration-checklist-before-release)

## At a glance

| Goal | Start here |
| --- | --- |
| Try Google sign-in in Chrome | [Web setup](#web-setup) |
| Set up Google sign-in on Android | [Android setup](#android-setup) |
| Diagnose an error | [Troubleshooting](#troubleshooting) |
| Prepare a release | [Release checklist](#configuration-checklist-before-release) |

### Quick start: local Chrome

1. In Firebase project `evently-c20-6b786`, enable **Google** under
   **Authentication → Sign-in method**.
2. Confirm `localhost` is in **Authentication → Settings → Authorized domains**.
3. Run:

   ```powershell
   flutter run --release -d chrome
   ```

4. Click **Continue with Google**. If it fails, copy the exception from the
   Flutter terminal and compare it with the [troubleshooting table](#troubleshooting).

> [!NOTE]
> A successful web test does not verify Android OAuth settings. Web and Android
> use different sign-in flows and must be tested independently.

## What is implemented

Authentication is implemented in
[`lib/core/config/auth_services.dart`](lib/core/config/auth_services.dart).
Firebase is initialized before the app starts in
[`lib/main.dart`](lib/main.dart) using
[`lib/firebase_options.dart`](lib/firebase_options.dart).

The current sign-in paths are:

| Platform | Google sign-in implementation |
| --- | --- |
| Web (including Chrome) | Firebase Auth `signInWithPopup(GoogleAuthProvider())` |
| Android and other supported native targets | `google_sign_in` obtains a Google ID token; Firebase Auth exchanges it for a Firebase credential |

`AuthService` provides methods for Google sign-in, email/password sign-in and
registration, password reset, sign-out, and auth-state observation.
Registration saves the entered name as the Firebase user's display name and
sends an email verification message. Firebase and Google errors propagate to
the caller so the UI can handle them.

The login, registration, and password-reset pages are currently disabled
placeholders and are not yet connected to `AuthService`. Enable Firebase's
Email/Password provider and connect the pages before using these flows in the
app.

For a detailed breakdown of the current `AuthService` design and behavior, see
[AUTH_SERVICE_CHANGES.md](AUTH_SERVICE_CHANGES.md).

## Current Firebase configuration

The Android and web app registrations currently use Firebase project
`evently-c20-6b786` (display name `evently-c20`):

| Setting | Current value |
| --- | --- |
| Android application ID | `com.example.my_evently` |
| Android Firebase app ID | `1:443200183987:android:e161ba24d736ad91cf5ac6` |
| Firebase project number | `443200183987` |
| Android OAuth certificate SHA-1 in `google-services.json` | `7fd758218a998e8fcb465779c9f883ef9645c50d` |
| Web Firebase app ID | `1:443200183987:web:802283db0ea3db0ecf5ac6` |
| Web OAuth client ID | `443200183987-gvvoo98e1smmfvbvcgqqe1pssftd9pj0.apps.googleusercontent.com` |

The Android SHA-1 matches the debug signing certificate found on the
development machine during setup. These values are also in
[`android/app/google-services.json`](android/app/google-services.json),
[`lib/firebase_options.dart`](lib/firebase_options.dart), and
[`firebase.json`](firebase.json).

> [!WARNING]
> At the time this guide was written, the iOS, macOS, and Windows entries in
> `firebase_options.dart` still reference the older project `c20-evently`.
> Configuration is aligned for Android and web, but not those other targets.
> Configure each target for the intended Firebase project before using
> authentication on it.

## One-time Firebase Console setup

Complete these checks in the Firebase Console for project
`evently-c20-6b786`:

1. **Enable Google as a Firebase Authentication provider.**
   - Open **Authentication** → **Sign-in method** (the console may call this
     **Sign-in providers**).
   - Select **Google**, enable it, select the required support email, and save.
   - This is a project-side setting and cannot be verified from the source files.
2. **Check authorized domains for web.**
   - Open **Authentication** → **Settings** → **Authorized domains**.
   - Confirm `localhost` is present for local Chrome runs.
   - Add the exact host/domain used to serve the deployed web app. Do not include
     a scheme (`https://`) or a path. A custom domain must be explicitly added.
3. **Confirm the Android registration.**
   - Open **Project settings** → **General** and find the Android app registered
     as `com.example.my_evently`.
   - Confirm its signing certificate SHA-1 is registered. The debug SHA-1 above
     is needed for local debug builds; release and Play signing may require
     additional fingerprints.
4. **Confirm the Google OAuth clients.**
   - The Android OAuth client must pair the exact application ID with the
     certificate SHA-1 used to sign the installed build.
   - The Web client is used as the server client ID for native Google Sign-In
     and for OAuth consent/configuration on the web.
   - Do not paste an OAuth client secret into Flutter code. Client IDs are
     identifiers, not client secrets.

## Android setup

### 1. Verify the package name

The package/application ID must agree in both places:

- `android/app/build.gradle.kts`: `applicationId = "com.example.my_evently"`
- `android/app/google-services.json`: the Android client's
  `package_name` is `com.example.my_evently`

If you change the application ID, register a new Android app in Firebase using
the new exact ID and download its matching `google-services.json`.

### 2. Register signing certificate fingerprints

For local debug builds, the debug signing key must be registered in Firebase.
From the project root in PowerShell, run:

```powershell
cd android
.\gradlew.bat signingReport
```

Find the `debug` variant and copy the SHA-1 (and SHA-256 if the console requests
it). Alternatively, inspect the default debug keystore directly:

```powershell
keytool -list -v `
  -keystore "$env:USERPROFILE\.android\debug.keystore" `
  -alias androiddebugkey `
  -storepass android `
  -keypass android
```

In **Firebase Console → Project settings → General → Your apps → Android app**,
add the SHA-1 to the app registered as `com.example.my_evently`. After a
fingerprint is added, download a fresh `google-services.json` and replace
`android/app/google-services.json`. Inspect the file to make sure it contains
an Android OAuth client (`client_type: 1`) with the correct package name and
fingerprint.

Each signing certificate has its own fingerprint. Register the release
keystore fingerprint before testing a release-signed app. When distributing
through Google Play App Signing, also register the **App signing key
certificate** SHA-1 from Play Console → **App integrity**. The upload
certificate and Play app-signing certificate can differ.

The current Gradle configuration uses the debug signing config for its release
build type. If that remains unchanged, the local release APK uses the debug
fingerprint; production signing should use the real release key and its
registered fingerprint.

### 3. Check the Google server client ID

In `AuthService.initGoogle`, the `serverClientId` must be the **Web application
OAuth client ID** from the same Firebase/Google Cloud project. It is currently
configured as the Web client ID listed in the current configuration table.

Do not put the Android OAuth client ID here. A stale client ID from another
Firebase project commonly prevents the native flow from returning an ID token.
When Google client IDs change, update this value and rebuild the app.

### 4. Rebuild and test

From the project root:

```powershell
flutter clean
flutter pub get
flutter run -d <android-device-id>
```

Get the exact device ID with:

```powershell
flutter devices
```

Use the same Android device/emulator configuration when comparing results.
Changing `google-services.json` or signing settings requires a rebuild; hot
reload does not replace native configuration packaged into the app.

## Web setup

### 1. Use the Web Firebase options

`main.dart` selects `DefaultFirebaseOptions.web` when Flutter is running in a
browser. The current Web options in `firebase_options.dart` are registered to
the new project and should remain consistent with that project's Web app.

If the Web app is removed/recreated or you switch Firebase projects, regenerate
the options with FlutterFire CLI. For this project, which has Android and Web
registered:

```powershell
flutterfire configure `
  --project=evently-c20-6b786 `
  --platforms=android,web `
  --yes
```

Review both `lib/firebase_options.dart` and `android/app/google-services.json`
after the command. Confirm that the project ID, sender number, app IDs, package
name, and OAuth IDs still match the intended project. Avoid selecting or
registering the wrong Firebase app if prompted.

### 2. Authorize the serving domain

For local development, use the local server started by Flutter:

```powershell
flutter run --release -d chrome
```

The current code uses Firebase Auth's popup flow directly from the button tap.
The site origin must be in Firebase Authentication's authorized domains. For
deployment, authorize the hostname actually serving the app (for example,
`example.com`), not just the Firebase project domain. If the app is hosted under
a custom domain, add that domain too.

### 3. Test Google sign-in

1. Confirm Google is enabled in Firebase Authentication for this project.
2. Run the release command above and open the app in Chrome.
3. Click **Continue with Google** and complete the provider prompt.
4. If it fails, read the terminal output where Flutter was launched; the login
   page now prints the exception and stack trace.

`flutter run --release -d chrome` uses a release-compiled Flutter web app, but
the Flutter tool still manages the browser process and terminal session. To
deploy independently, create the static web build:

```powershell
flutter build web --release
```

Deploy the contents of `build/web` to a web host and authorize that host's
domain in Firebase Authentication.

### Popup limitations

- Popups must be triggered by a direct user action. The current login button
  calls the popup flow from its tap callback.
- Browser popup blockers, strict privacy settings, or embedded/in-app browsers
  can prevent the popup or its return flow. Test in a normal Chrome window.
- Do not invoke sign-in automatically during app startup.
- If popup flow is unsuitable for the deployment environment, an alternate
  redirect flow requires implementation and testing; it is not the current
  flow.

## Run and diagnostic commands

Use the commands for the platform you are diagnosing. Replace the Android
device placeholder with an ID reported by `flutter devices`.

```powershell
# Check available devices
flutter devices

# Android debug run (replace with the listed Android device ID)
flutter run -d <android-device-id>

# Web release run in Chrome
flutter run --release -d chrome

# Build deployable web output
flutter build web --release

# Analyze the project
flutter analyze
```

For Google sign-in errors, retain the full exception text and stack trace from
the terminal or VS Code Debug Console. The snack-bar message is intentionally
short and does not identify the underlying Firebase/OAuth cause.

## Troubleshooting

Start with the exact exception printed to the Flutter terminal or VS Code
Debug Console. Match its code/message below; the short snack-bar text alone is
not enough to identify the cause.

| Symptom or error | Likely cause | What to check/fix |
| --- | --- | --- |
| Button appears to do nothing | Button is disabled while `_isLoading` is true, callback isn't reached, or the popup is blocked | Run from a terminal, click once, check console output, verify the button is visible/tappable, and test in a normal Chrome window. |
| Generic “Unable to sign in with Google” message | The native flow returned no ID token, or the service returned `null` | Check logs for `No ID token returned from Google.` Verify the Web `serverClientId`, Android OAuth registration, package, and SHA-1. |
| `GoogleSignInException` / `DEVELOPER_ERROR` / Android API error 10 | OAuth client does not match the installed app's package/signing certificate, or wrong Firebase project config | Compare the installed build's certificate SHA-1 and application ID with the Android OAuth client in the latest JSON. Add the right fingerprint, download JSON again, clean and rebuild. |
| `No ID token returned from Google` | Incorrect or missing Web server client ID, or OAuth configuration not set up for the app | Use the Web client ID from the same Firebase project in `serverClientId`; verify Android client registration and enabled Google provider. |
| `FirebaseAuthException: operation-not-allowed` | Google provider is disabled for the Firebase project receiving the request | Enable Google under Authentication → Sign-in method in the project used by the platform's `FirebaseOptions`. |
| Web `auth/unauthorized-domain` | The current site host is not authorized | Add the exact host under Authentication → Settings → Authorized domains. For local runs, ensure `localhost` is authorized. |
| Web popup is blocked or closes immediately | Popup blocker, embedded browser, or popup launched outside direct user gesture | Allow popups for the site and test in a normal browser tab. The sign-in call should remain directly in the button callback. |
| Web `auth/operation-not-allowed` | Google provider is disabled for the Web app's Firebase project | Enable Google in that project and retry. |
| `auth/popup-closed-by-user` | User dismissed the Google popup before completing sign-in | This is a cancellation, not a configuration defect; retry and complete the prompt. |
| `auth/account-exists-with-different-credential` | The email already has an account using another sign-in provider | Sign in using the existing provider, then implement an account-linking flow if linking is desired. This project logs the error but does not implement automatic linking. |
| `auth/network-request-failed` or request timeout | Network connectivity, browser extension, proxy, DNS, or blocked Google/Firebase request | Retry on another network/browser profile; inspect browser Network/Console output and ensure Google/Firebase domains are not blocked. |
| `api-key-not-valid` or Firebase config error | `firebase_options.dart` and app registration do not belong to the same project, or API key restrictions are incorrect | Regenerate options for the intended Firebase project and confirm the selected platform app. Review API-key restrictions in Google Cloud Console. |
| Sign-in succeeds but user data appears missing | User signed in to a different Firebase project than expected | Check the platform's selected `FirebaseOptions.projectId`. Android, Web, iOS, macOS, and Windows can currently have different project IDs in this repository. |
| Google works on Android but not Chrome (or vice versa) | Android and Web use separate OAuth configurations and different sign-in APIs | Verify Android package/SHA-1/server client ID separately from Web options/authorized domains/Google provider. Passing on one platform does not validate the other. |
| App still has old config after editing JSON/options | Native config was not rebuilt or a stale browser build/service worker is running | Run `flutter clean`, rebuild/relaunch, and hard-refresh or clear the deployed site's cache/service worker where applicable. |
| iOS/macOS auth fails after Android/Web were configured | Their options and OAuth IDs still point to the older Firebase project | Register each platform app in the intended project, configure bundle IDs and URL schemes, add the platform-specific OAuth setup, and regenerate FlutterFire options. |
| Windows Google auth fails | The current service's non-web branch uses the native `google_sign_in` plugin, which is not configured as an implemented Windows sign-in flow here | Use a supported platform or implement and configure a Windows-specific provider flow. The current Windows Firebase options also reference the older project. |
| Email sign-up fails | Email/Password provider is disabled, or the email/password is rejected | Enable Email/Password under Authentication → Sign-in method in the Firebase project used by the app. Review Flutter console output for the Firebase Auth error code. |

## Security and account-handling notes

- Firebase client configuration and OAuth client IDs are embedded in client apps;
  they are not substitutes for Firebase Security Rules or server-side
  authorization.
- Never commit OAuth **client secrets**, service-account private keys, signing
  keystores, or passwords. Do not put privileged credentials in Flutter code.
- Restrict API keys where appropriate, but do not mistake an API key for
  authentication or authorization.
- Authentication proves a user's identity; database/storage access must still
  be protected with Firebase Security Rules.
- `AuthService.deleteAccount()` deletes the current Firebase Auth user but does
  not itself clean up application data. Deletion may require recent
  re-authentication; handle `requires-recent-login` if this method is exposed.
- `revokeGoogleAccess()` disconnects the Google account and signs out of
  Firebase. It is a stronger action than ordinary sign-out and should only be
  offered intentionally.

## Configuration checklist before release

- [ ] Google provider enabled in the correct Firebase project
- [ ] Web authorized domains include every production hostname
- [ ] Android application ID exactly matches the registered Firebase app
- [ ] Debug, release, and (if applicable) Play App Signing fingerprints are registered
- [ ] Latest `google-services.json` belongs to the Android app/project being shipped
- [ ] Native `serverClientId` is the Web OAuth client ID for that same project
- [ ] `firebase_options.dart` has correct options for every platform being shipped
- [ ] Release signing uses the intended release key, not an unintended debug key
- [ ] Google sign-in tested on each target platform using a release-like build
- [ ] Firebase Security Rules and account-data lifecycle have been reviewed
