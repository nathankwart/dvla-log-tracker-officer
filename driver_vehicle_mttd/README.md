# Security Agency (Police MTTD) Mobile Application

A Flutter mobile application for Security Agencies (Police MTTD) to digitally verify DV vehicle movement records by scanning QR codes and retrieving trip logs from Firebase.

## Features

- 🔐 **Secure Authentication** - Firebase Authentication for security personnel
- 📱 **QR Code Scanning** - Fast and reliable QR code scanning for vehicle verification
- 📋 **Trip Log Display** - Clean, readable format showing all trip details
- 🎨 **Professional UI** - Optimized for roadside checks with large text and clear labels
- 🔒 **Read-Only Access** - Strict read-only access to trip logs (no modifications)

## Requirements

- Flutter SDK 3.10.1 or higher
- Dart SDK 3.10.1 or higher
- Firebase project configured
- Android Studio / Xcode for platform-specific builds

## Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd driver-vehicle-mttd/driver_vehicle_mttd
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Follow the instructions in [FIREBASE_CONFIGURATION_GUIDE.md](../FIREBASE_CONFIGURATION_GUIDE.md)
   - Run `flutterfire configure` or manually set up Firebase
   - Update `lib/main.dart` to import `firebase_options.dart`

4. **Set up Firestore Security Rules**
   - Copy `firestore.rules` to your Firebase Console
   - Deploy the rules in Firestore Database → Rules

5. **Run the application**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # Application entry point
├── core/
│   ├── constants/           # App-wide constants
│   ├── theme/               # UI theme configuration
│   └── utils/               # Utility functions
├── models/                  # Data models
├── services/                # Business logic services
├── providers/               # State management
├── screens/                 # UI screens
└── widgets/                 # Reusable UI components
```

## Usage

### Login
1. Launch the application
2. Enter your officer email and password
3. Tap "Login"

### Scan QR Code
1. After login, the scanner screen will open
2. Point the camera at the vehicle's QR code
3. The app will automatically detect and process the QR code

### View Trip Logs
1. After scanning, trip logs for the vehicle will be displayed
2. Scroll through the logs chronologically
3. Each log shows:
   - Date and time
   - Driver name
   - Vehicle details
   - Reason for journey
   - Route taken
   - Time of leaving and return

## Documentation

- [Firebase Configuration Guide](../FIREBASE_CONFIGURATION_GUIDE.md) - Complete Firebase setup instructions
- [Technical Report](../TECHNICAL_REPORT.md) - Detailed technical documentation
- [Implementation Plan](../IMPLEMENTATION_PLAN.md) - Development plan and phases

## Security

- All officers must authenticate before accessing the application
- Read-only access to Firestore data (enforced by security rules)
- No data modification capabilities
- Secure token storage

## Troubleshooting

### Firebase Issues
- Ensure `firebase_options.dart` is properly configured
- Verify Firebase project is set up correctly
- Check that security rules are deployed

### QR Scanning Issues
- Ensure camera permissions are granted
- Check that QR code format matches expected format
- Try improving lighting conditions

### Authentication Issues
- Verify officer account exists in Firebase Authentication
- Check email/password are correct
- Ensure Email/Password authentication is enabled in Firebase Console

## Development

### Running Tests
```bash
flutter test
```

### Building for Production

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## License

This project is proprietary software for official use by Security Agencies.

## Support

For technical support or questions, refer to the technical documentation or contact the development team.
