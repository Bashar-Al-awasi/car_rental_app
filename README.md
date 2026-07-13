<h1 align="center">
  🚗 Drive Premium
</h1>

<p align="center">
  <b>A modern, full-featured car rental mobile application built with Flutter &amp; Firebase</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"/>
  <img src="https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase"/>
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green?style=for-the-badge&logo=android&logoColor=white" alt="Platform"/>
  <img src="https://img.shields.io/badge/License-MIT-blue?style=for-the-badge" alt="License"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-1.0.0-brightgreen?style=flat-square" alt="Version"/>
  <img src="https://img.shields.io/badge/PRs-welcome-brightgreen?style=flat-square" alt="PRs Welcome"/>
  <img src="https://img.shields.io/badge/i18n-EN%20%7C%20AR-informational?style=flat-square" alt="Localization"/>
</p>

---

## 📖 Overview

**Drive Premium** is a sleek and polished car rental mobile application that delivers a premium booking experience. Users can browse a curated fleet of vehicles, view detailed specs, save favourites, and complete bookings — all from an elegantly themed interface that supports both **Light & Dark mode** and **English / Arabic** localization.

---

## ✨ Features

### 🔐 Authentication
- Email & password **Sign Up / Login** via Firebase Auth
- Persistent session with automatic auth-gate routing
- Secure user profile management

### 🚘 Car Catalogue
- Real-time car listings fetched from **Cloud Firestore**
- Rich car cards with images, brand, model, price, and rating
- Advanced filtering by type, price range, and availability
- Glassmorphism-styled UI components

### 📋 Car Details
- Full specification view (engine, fuel, transmission, seats, 0–100 speed)
- Image gallery with interactive viewer
- Shop information and ratings

### ❤️ Favourites
- Add / remove cars from a personal favourites list
- Dedicated favourites screen for quick access

### 📅 Booking Flow
- Step-by-step booking screen with date and rental period selection
- Daily / Weekly / Monthly pricing tiers
- Booking confirmation with summary

### 👤 Profile Management
- View and edit personal account details
- Toggle **Dark / Light** theme
- Switch app language between **English 🇬🇧** and **Arabic 🇸🇦**

### 🛠️ Admin Panel
- Dedicated admin panel screen for fleet and booking management

---

## 🏗️ Tech Stack

| Technology | Purpose |
|---|---|
| **Flutter 3.x** | Cross-platform UI framework |
| **Dart 3.x** | Programming language |
| **Firebase Auth** | User authentication |
| **Cloud Firestore** | Real-time NoSQL database |
| **Google Fonts (Outfit)** | Custom typography |
| **flutter_animate** | Smooth UI animations |
| **flutter_localizations** | Multi-language support (EN / AR) |
| **shared_preferences** | Persisting locale & theme settings |
| **Material 3** | Modern design system |

---

## 📁 Project Structure

```
car_rental_app/
├── lib/
│   ├── core/
│   │   ├── auth/               # Auth helper services
│   │   ├── constants/          # App colours & constants
│   │   ├── localization/       # Locale notifier (ValueNotifier)
│   │   ├── theme/              # Light & Dark ThemeData + ThemeNotifier
│   │   └── widgets/            # Reusable UI components
│   │       ├── car_card.dart
│   │       ├── custom_button.dart
│   │       ├── custom_textfield.dart
│   │       └── glass_container.dart
│   ├── l10n/
│   │   └── app_localizations.dart   # EN / AR string tables
│   ├── models/
│   │   ├── app_user.dart       # User model
│   │   ├── car.dart            # Car model (Firestore serialization)
│   │   └── shop.dart           # Shop / rental agency model
│   ├── screens/
│   │   ├── admin/              # Admin panel
│   │   ├── auth/               # Login, Register, AuthGate
│   │   ├── booking/            # Booking flow screen
│   │   ├── details/            # Car details screen
│   │   ├── favorites/          # Favourites screen
│   │   ├── home/               # Home screen with catalogue
│   │   ├── navigation/         # Bottom navigation shell
│   │   ├── profile/            # User profile screen
│   │   └── shop/               # Shop listings screen
│   └── main.dart               # App entry point
├── assets/
│   └── images/                 # Static image assets
├── images/                     # Additional image assets
├── android/                    # Android platform project
├── ios/                        # iOS platform project
├── pubspec.yaml
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites

Before running this project, make sure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) **≥ 3.3.0**
- [Dart SDK](https://dart.dev/get-dart) **≥ 3.0.0**
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/) with the Flutter extension
- A configured **Firebase project** (see [Firebase Setup](#-firebase-setup) below)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/your-username/car_rental_app.git

# 2. Navigate into the project directory
cd car_rental_app

# 3. Install dependencies
flutter pub get

# 4. Run the app
flutter run
```

---

## 🔥 Firebase Setup

This app requires a Firebase project with **Authentication** and **Cloud Firestore** enabled.

### Step 1 — Create a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.
2. Enable **Email/Password** sign-in under **Authentication → Sign-in method**.
3. Create a **Cloud Firestore** database in production or test mode.

### Step 2 — Add Configuration Files

| Platform | File | Location |
|---|---|---|
| Android | `google-services.json` | `android/app/` |
| iOS | `GoogleService-Info.plist` | `ios/Runner/` |

> ⚠️ **Never commit these files to source control.** They are already included in `.gitignore`.

### Step 3 — Firestore Data Structure

Each car document in the `cars` collection should follow this schema:

```json
{
  "Name": "Toyota Camry",
  "image": "https://your-image-url.com/camry.jpg",
  "price": 1500,
  "condition": "Daily",
  "transmission": "Automatic",
  "fuel": "Petrol",
  "seats": "5",
  "engine": "2.5L 4-Cylinder",
  "speed": "0-100 in 8.0s",
  "rating": 4.8,
  "shopId": "shop_001",
  "shopName": "Elite Car Hub"
}
```

---

## 📱 Supported Platforms

| Platform | Status |
|---|---|
| Android | ✅ Fully supported |
| iOS | ✅ Fully supported |
| Web | 🔧 Experimental |
| Windows | 🔧 Experimental |
| macOS | 🔧 Experimental |
| Linux | 🔧 Experimental |

---

## 🏗️ Build

### Android APK (Release)

```bash
flutter build apk --release
```

### iOS Archive

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

---

## 🌐 Localization

The app supports **English** and **Arabic** out of the box, with RTL layout automatically applied for Arabic.

- String tables are defined in `lib/l10n/app_localizations.dart`
- The active locale is persisted via `shared_preferences` using `LocaleNotifier`
- Users can switch language from the **Profile** screen

To add a new language, extend the `AppLocalizations` class with a new locale entry.

---

## 🎨 Theming

Drive Premium uses a fully custom **Material 3** design system:

- **Font:** [Outfit](https://fonts.google.com/specimen/Outfit) via Google Fonts
- **Light & Dark mode** with distinct colour palettes
- User's preferred theme is persisted between sessions via `ThemeNotifier` + `shared_preferences`
- Glassmorphism effects via the `GlassContainer` widget

---

## 🤝 Contributing

Contributions are welcome! Here's how to get started:

1. **Fork** this repository
2. **Create** a feature branch: `git checkout -b feature/amazing-feature`
3. **Commit** your changes: `git commit -m 'feat: add amazing feature'`
4. **Push** to the branch: `git push origin feature/amazing-feature`
5. **Open** a Pull Request

Please make sure your code follows the existing style and passes `flutter analyze` before submitting.

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

Built with ❤️ using Flutter & Firebase.

---

<p align="center">
  ⭐ If you find this project useful, please consider giving it a star!
</p>
