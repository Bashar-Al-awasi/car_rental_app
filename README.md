# Drive Premium

Drive Premium is a Flutter mobile app for browsing and booking premium cars. The project demonstrates a modern car rental experience with authentication, car listings, booking flow, and a polished UI.

## Features

- User authentication and profile management
- Car listing and detailed car views
- Favorites and booking experience
- Responsive Flutter UI
- Firebase-backed data integration

## Tech Stack

- Flutter
- Dart
- Firebase Auth
- Cloud Firestore
- Provider / state management patterns

## Getting Started

### Prerequisites

- Flutter SDK installed
- Android Studio or VS Code with Flutter extensions
- Firebase project configured for Android and iOS

### Installation

```bash
git clone <your-repo-url>
cd car_rental_app
flutter pub get
flutter run
```

### Build for Android

```bash
flutter build apk --release
```

## Project Structure

```text
lib/
  core/
  models/
  screens/
  main.dart
android/
ios/
assets/
```

## Configuration

Before running the app, make sure you have the correct Firebase configuration files:

- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`

Do not commit secrets or signing files. The repository ignore rules in `.gitignore` are intended to help protect sensitive files.



## License

This project is licensed under the MIT License.
