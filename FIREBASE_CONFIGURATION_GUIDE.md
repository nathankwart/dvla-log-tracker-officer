# Firebase Configuration Guide

This guide will help you set up Firebase for the Security Agency (Police MTTD) Mobile Application.

## Prerequisites

- A Firebase account (create one at https://firebase.google.com/)
- Flutter SDK installed
- Firebase CLI installed (optional, but recommended)

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or select an existing project
3. Enter project name: `driver-vehicle-mttd` (or your preferred name)
4. Enable Google Analytics (optional)
5. Click "Create project"

## Step 2: Add Firebase to Your Flutter App

### Option A: Using FlutterFire CLI (Recommended)

1. Install FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. Navigate to your project directory:
   ```bash
   cd driver_vehicle_mttd
   ```

3. Run FlutterFire configure:
   ```bash
   flutterfire configure
   ```

4. Select your Firebase project
5. Select platforms (Android, iOS, Web, etc.)
6. This will automatically create `firebase_options.dart` file

### Option B: Manual Configuration

#### For Android:

1. In Firebase Console, click "Add app" → Android
2. Register your app:
   - Android package name: `com.dvl.driver_vehicle_mttd` (check your `build.gradle`)
   - App nickname: "Police MTTD Android"
   - Debug signing certificate SHA-1 (optional)
3. Download `google-services.json`
4. Place it in `android/app/` directory
5. Update `android/build.gradle`:
   ```gradle
   buildscript {
       dependencies {
           classpath 'com.google.gms:google-services:4.4.0'
       }
   }
   ```
6. Update `android/app/build.gradle`:
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

#### For iOS:

1. In Firebase Console, click "Add app" → iOS
2. Register your app:
   - iOS bundle ID: `com.dvl.driverVehicleMttd` (check your `Info.plist`)
   - App nickname: "Police MTTD iOS"
3. Download `GoogleService-Info.plist`
4. Open Xcode and add the file to `ios/Runner/`
5. Ensure it's added to the Runner target

#### Create firebase_options.dart:

Create `lib/firebase_options.dart`:

```dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    iosBundleId: 'com.dvl.driverVehicleMttd',
  );
}
```

Replace the placeholder values with your actual Firebase project credentials from the Firebase Console.

## Step 3: Enable Firebase Authentication

1. In Firebase Console, go to **Authentication** → **Sign-in method**
2. Enable **Email/Password** authentication
3. Click "Save"

## Step 4: Set Up Firestore Database

1. In Firebase Console, go to **Firestore Database**
2. Click "Create database"
3. Choose **Production mode** (we'll add security rules)
4. Select your preferred location (choose closest to Ghana)
5. Click "Enable"

## Step 5: Configure Firestore Security Rules

1. In Firebase Console, go to **Firestore Database** → **Rules**
2. Replace the default rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper function to check if user is authenticated
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Vehicles collection - read-only for authenticated officers
    match /vehicles/{vehicleId} {
      allow read: if isAuthenticated();
      allow write: if false; // Officers cannot write
    }
    
    // Trip logs collection - read-only for authenticated officers
    match /tripLogs/{tripId} {
      allow read: if isAuthenticated();
      allow write: if false; // Officers cannot write
    }
    
    // Officers collection (optional, for officer profiles)
    match /officers/{officerId} {
      allow read: if isAuthenticated() && request.auth.uid == officerId;
      allow write: if false;
    }
  }
}
```

3. Click "Publish"

## Step 6: Create Firestore Collections Structure

Your Firestore should have the following collections:

### Collection: `vehicles`
Document structure:
```json
{
  "registrationNumber": "GR-1234-21",
  "description": "Toyota Corolla - Blue",
  "createdAt": "2024-01-01T00:00:00Z"
}
```

### Collection: `tripLogs`
Document structure:
```json
{
  "vehicleId": "vehicle_document_id",
  "date": "2024-01-15T00:00:00Z",
  "reasonForJourney": "Official duty",
  "timeOfLeaving": "2024-01-15T08:00:00Z",
  "timeOfReturn": "2024-01-15T17:00:00Z",
  "routeTaken": "Accra to Kumasi",
  "vehicleDescription": "Toyota Corolla - Blue",
  "registrationNumber": "GR-1234-21",
  "driverName": "John Doe",
  "signatureOfPersonMakingEntry": "John Doe"
}
```

**Important:** Create indexes for efficient queries:
- Collection: `tripLogs`
- Fields: `vehicleId` (Ascending), `date` (Descending), `timeOfLeaving` (Descending)

## Step 7: Create Test Officer Account

1. In Firebase Console, go to **Authentication** → **Users**
2. Click "Add user"
3. Enter email: `officer@mttd.gov.gh` (or your test email)
4. Enter password: `TestPassword123!` (use a strong password)
5. Click "Add user"

## Step 8: Update main.dart

Uncomment the Firebase initialization code in `lib/main.dart`:

```dart
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}
```

## Step 9: Test the Configuration

1. Run the app:
   ```bash
   flutter run
   ```

2. Try logging in with the test officer account
3. Test QR code scanning (you'll need a valid QR code from the driver app)

## Troubleshooting

### Android Issues:
- Ensure `google-services.json` is in `android/app/`
- Check that `minSdkVersion` is at least 21 in `android/app/build.gradle`
- Run `flutter clean` and `flutter pub get`

### iOS Issues:
- Ensure `GoogleService-Info.plist` is added to Xcode project
- Check that the file is included in the Runner target
- Run `pod install` in `ios/` directory

### Firestore Issues:
- Verify security rules are published
- Check that indexes are created for queries
- Ensure collections match the expected schema

### Authentication Issues:
- Verify Email/Password is enabled in Firebase Console
- Check that test user is created
- Verify API keys are correct in `firebase_options.dart`

## Security Best Practices

1. **Never commit `firebase_options.dart` with real credentials** (use environment variables in production)
2. **Use different Firebase projects** for development and production
3. **Regularly review security rules**
4. **Enable Firebase App Check** for additional security
5. **Monitor Firebase usage** in the console

## Additional Resources

- [Firebase Flutter Documentation](https://firebase.flutter.dev/)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Firebase Authentication](https://firebase.google.com/docs/auth)

## Support

For issues specific to this application, refer to the technical report or contact the development team.
