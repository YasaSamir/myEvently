# Writing the authentication code yourself

This guide explains how to build the Firebase authentication flow in this
Flutter project. The working service is in
[`lib/core/config/auth_services.dart`](lib/core/config/auth_services.dart).
Use it as a reference while writing or adapting the code yourself.

The login, registration, and password-reset pages are currently disabled
placeholders. Writing the service does not automatically connect those pages:
their button callbacks must call the service methods as described below.

## 1. Configure Firebase

In the Firebase Console for this app:

1. Open **Authentication → Sign-in method**.
2. Enable **Email/Password**.
3. Enable **Google** and select a support email.
4. For web, add the app's host (and `localhost` for local testing) under
   **Authentication → Settings → Authorized domains**.
5. For Android, register the SHA-1 certificate for the build you are testing.
   The Android package name and Firebase app registration must match.

The project already depends on `firebase_core`, `firebase_auth`, and
`google_sign_in`; do not add them a second time.

## 2. Initialize Firebase before the app

Import Firebase Core and the generated Firebase options in `lib/main.dart`.
Make `main` asynchronous and initialize Firebase before `runApp`:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

Keep your existing providers and other app setup inside `runApp`; only add the
initialization before it. The project already has these generated options in
`lib/firebase_options.dart`.

## 3. Put the Firebase calls in one service

Create or edit `lib/core/config/auth_services.dart`. Import Firebase Auth,
Flutter's `kIsWeb` flag, and Google Sign-In:

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
```

Keep one `FirebaseAuth` instance in the service. Expose the current user and
auth streams so other parts of the app can check or observe sign-in state:

```dart
final FirebaseAuth _auth = FirebaseAuth.instance;

User? get currentUser => _auth.currentUser;
bool get isSignedIn => currentUser != null;
Stream<User?> get authStateChanges => _auth.authStateChanges();
```

Use a single service instance to make calls from the UI:

```dart
class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Add the methods below inside this class.
}
```

### Register with email and password

Create the Firebase account, save the display name, and optionally send an
email-verification message. Do not trim or otherwise modify the password:

```dart
Future<UserCredential> signUpWithEmail({
  required String name,
  required String email,
  required String password,
}) async {
  final credential = await _auth.createUserWithEmailAndPassword(
    email: email.trim(),
    password: password,
  );
  final user = credential.user;
  if (user == null) {
    throw StateError('Firebase created an account without returning a user.');
  }

  await user.updateDisplayName(name.trim());
  await user.sendEmailVerification();
  return credential;
}
```

### Sign in with email and password

```dart
Future<UserCredential> signInWithEmail({
  required String email,
  required String password,
}) {
  return _auth.signInWithEmailAndPassword(
    email: email.trim(),
    password: password,
  );
}
```

### Send a password-reset email

```dart
Future<void> sendPasswordReset(String email) {
  return _auth.sendPasswordResetEmail(email: email.trim());
}
```

### Sign in with Google

Use Firebase's popup on web. On Android, initialize the Google Sign-In
plugin, retrieve the Google ID token, then exchange it for a Firebase
credential:

```dart
bool _googleInitialized = false;

Future<void> initGoogle() async {
  if (_googleInitialized || kIsWeb) return;

  await GoogleSignIn.instance.initialize(
    serverClientId: 'YOUR_WEB_OAUTH_CLIENT_ID',
  );
  _googleInitialized = true;
}

Future<UserCredential> signInWithGoogle() async {
  if (kIsWeb) {
    return _auth.signInWithPopup(GoogleAuthProvider());
  }

  await initGoogle();
  final googleUser = await GoogleSignIn.instance.authenticate();
  final idToken = googleUser.authentication.idToken;
  if (idToken == null) {
    throw StateError('Google Sign-In did not return an ID token.');
  }

  final credential = GoogleAuthProvider.credential(idToken: idToken);
  return _auth.signInWithCredential(credential);
}
```

Replace `YOUR_WEB_OAUTH_CLIENT_ID` with the **Web application** OAuth client ID
from the same Firebase project. It is a client identifier, not a client secret.
The project currently has this value configured in `auth_services.dart`.

### Sign out

```dart
Future<void> signOut() async {
  await _auth.signOut();
  if (_googleInitialized) {
    await GoogleSignIn.instance.signOut();
  }
}
```

## 4. Call the service from a screen

In the login button's `onPressed`, read the text fields and call
`signInWithEmail`. Only navigate after it succeeds. Catch Firebase errors and
show a useful message rather than silently ignoring a failed sign-in:

```dart
try {
  await AuthService.instance.signInWithEmail(
    email: emailController.text,
    password: passwordController.text,
  );

  if (!context.mounted) return;
  Navigator.pushReplacementNamed(context, AppRoutes.home);
} on FirebaseAuthException catch (error) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(error.message ?? 'Sign-in failed.')),
  );
}
```

Use the same pattern for registration, password reset, and Google sign-in:

- Registration calls `signUpWithEmail(name:, email:, password:)`.
- Password reset calls `sendPasswordReset(email)`.
- Google sign-in calls `signInWithGoogle()`.
- Sign-out calls `signOut()`.

For Google sign-in, also handle `GoogleSignInException` from the plugin. Let
the user cancel the Google account picker without treating it as a successful
sign-in. Firebase and Google exceptions should be handled in the UI so it can
display appropriate feedback.

## 5. Verify the setup

Test email registration, email login, password reset, Google login, and sign-out
on each platform you intend to support. Web and Android Google login use
different flows, so success on one does not confirm the other is configured.

If the app reports a provider-configuration error, check that the provider is
enabled in Firebase Authentication. For Android Google login, also verify the
package name, signing certificate SHA-1, and Web OAuth client ID.
