# Fish MVP App

**Offline-capable Flutter application for fishermen to track catches, health, and traceability.**

This project is the MVP version that includes:
- User registration & login with **SQLite**
- Navigation to **Home Screen**
- Flutter setup and Android emulator usage

---

## Table of Contents

1. [Getting Started](#getting-started)
2. [Dependencies](#dependencies)
3. [SQLite Integration](#sqlite-integration)
4. [Folder Structure](#folder-structure)
5. [Screens Implemented](#screens-implemented)
6. [Screenshots](#screenshots)
7. [Next Steps](#next-steps)

---

## Getting Started

If you clone this repository, follow these steps to set up and run the project.

### 1. Install Flutter SDK
Download and install the Flutter SDK from the [Flutter Installation Guide](https://flutter.dev/docs/get-started/install).

### 2. Clone the Repository

git clone <https://github.com/Neki18/SIH_25174>
cd fish_mvp1

### 3. Install Dependencies
Ensure the Flutter SDK is installed, then run:  (flutter pub get)

Fix any reported issues (e.g., missing SDK or tools).

### 5. Set Up Emulator or Device
You have two options:

**a Android Emulator (No Android Studio required):**
- List available emulators: flutter emulators

- Launch an emulator (replace with your emulator name): eg. flutter emulators --launch Medium_Phone_API_36.0

- Verify the device: flutter devices


### 6. Run the App
With a device or emulator ready, run:  flutter run


- Press `r` in the terminal for hot reload.
- Press `R` for hot restart.

### 7. Initial Screens
- **Register Screen**: For first-time users to create an account.
- **Login Screen**: Log in using registered email and password.
- **Home Screen**: Accessed after successful login.

---

## Dependencies

- `flutter`: Core framework.
- `sqflite`: For local SQLite database.
- `path_provider`: To access device file paths.
- `cupertino_icons`: For iOS-style icons.

---

## SQLite Integration

The app uses SQLite for offline data storage, handling user credentials and catch data via local database services.

---

## Folder Structure

- `lib/` - Main source code directory.
- `lib/screens/` - Flutter UI screen implementations.
- `lib/models/` - Data models.
- `lib/services/` - Services like database handling.


fish_mvp1/
├─ lib/
│ ├─ main.dart
│ ├─ screens/
│ │ ├─ register_screen.dart
│ │ ├─ login_screen.dart
│ │ └─ home_screen.dart
│ ├─ services/
│ │ └─ db_service.dart
│ └─ models/
│ └─ user.dart
├─ assets/
│ └─ screenshots/
├─ pubspec.yaml
└─ ...

---

## Screens Implemented

- Register Screen
- Login Screen
- Home Screen

---

## Screenshots

_Screenshots to be added here._

---

## Next Steps

- Implement more fishing-related features.
- Add offline sync capabilities.
- Enhance UI/UX.
- Write tests.





