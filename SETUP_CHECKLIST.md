# Setup Checklist

Use this checklist to ensure all setup steps are completed before running the application.

## Pre-Development Setup

- [ ] Flutter SDK installed (3.10.1+)
- [ ] Dart SDK installed (3.10.1+)
- [ ] Android Studio / Xcode installed
- [ ] Git repository cloned

## Firebase Setup

- [ ] Firebase project created
- [ ] Android app added to Firebase project
- [ ] iOS app added to Firebase project (if needed)
- [ ] `google-services.json` downloaded and placed in `android/app/`
- [ ] `GoogleService-Info.plist` downloaded and added to iOS project
- [ ] `firebase_options.dart` generated using `flutterfire configure`
- [ ] Firebase Authentication enabled (Email/Password)
- [ ] Firestore Database created
- [ ] Firestore security rules deployed (`firestore.rules`)
- [ ] Test officer account created in Firebase Authentication

## Firestore Configuration

- [ ] `vehicles` collection structure understood
- [ ] `tripLogs` collection structure understood
- [ ] Composite index created for `tripLogs`:
  - Fields: `vehicleId` (Ascending), `date` (Descending), `timeOfLeaving` (Descending)
- [ ] Sample test data added (optional, for testing)

## Code Configuration

- [ ] Dependencies installed (`flutter pub get`)
- [ ] `lib/main.dart` updated to import `firebase_options.dart`
- [ ] Firebase initialization uncommented in `main.dart`
- [ ] Android permissions added to `AndroidManifest.xml`
- [ ] iOS camera permissions added to `Info.plist`

## Build Configuration

### Android
- [ ] `minSdkVersion` set to 21 or higher in `android/app/build.gradle`
- [ ] `google-services` plugin added to `android/build.gradle`
- [ ] `google-services` plugin applied in `android/app/build.gradle`

### iOS
- [ ] `GoogleService-Info.plist` added to Xcode project
- [ ] `GoogleService-Info.plist` included in Runner target
- [ ] Pods installed (`cd ios && pod install`)

## Testing

- [ ] App builds successfully (`flutter build apk` or `flutter build ios`)
- [ ] App runs on device/emulator (`flutter run`)
- [ ] Login screen displays correctly
- [ ] Can log in with test officer account
- [ ] Scanner screen displays camera view
- [ ] QR code scanning works (test with valid QR code)
- [ ] Trip logs display correctly after scanning
- [ ] Error handling works (test with invalid QR code)
- [ ] Logout functionality works

## Security Verification

- [ ] Firestore security rules deployed and tested
- [ ] Read-only access verified (attempt to write should fail)
- [ ] Unauthenticated access blocked
- [ ] Authentication required for all screens

## Documentation

- [ ] README.md reviewed
- [ ] FIREBASE_CONFIGURATION_GUIDE.md reviewed
- [ ] TECHNICAL_REPORT.md reviewed
- [ ] Team members have access to documentation

## Deployment Preparation

- [ ] App name updated in `pubspec.yaml`
- [ ] App icons configured for Android and iOS
- [ ] Splash screens configured
- [ ] Version number set appropriately
- [ ] Release build tested
- [ ] App signing configured (for production)

## Final Checks

- [ ] All linting errors resolved
- [ ] Code follows project style guidelines
- [ ] No hardcoded credentials or sensitive data
- [ ] Error messages are user-friendly
- [ ] UI is optimized for roadside use
- [ ] Performance is acceptable

---

**Note**: This checklist should be completed before deploying to production or sharing with end users.
