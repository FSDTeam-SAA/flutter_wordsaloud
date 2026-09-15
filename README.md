# Aturservicett Mobile App

This is the Flutter mobile application for Aturservicett / Wordsaloud.

The mobile app connects to the backend API and lets users register, log in, browse tradesmen, create tradesman profiles, post reviews, and use the app features.

## 1. Install Required Software

Install these before running the mobile app.

### Install VS Code

1. Go to https://code.visualstudio.com/
2. Download VS Code for your computer.
3. Install it.
4. Open VS Code after installation.

### Install Git

1. Go to https://git-scm.com/downloads
2. Download Git for your computer.
3. Install it.
4. Check that Git is installed:

```bash
git --version
```

### Install Flutter

Follow the official Flutter installation guide:

https://docs.flutter.dev/install/manual

After installing Flutter, check that it works:

```bash
flutter doctor
```

Flutter Doctor will tell you if anything else is missing.

### Install Android Studio For Android

If you want to run the app on Android:

1. Install Android Studio from https://developer.android.com/studio
2. Install the Android SDK when Android Studio asks.
3. Create an Android emulator, or connect a real Android phone.

### Install Xcode For iPhone

If you want to run the app on iPhone, you need a Mac.

1. Install Xcode from the Mac App Store.
2. Open Xcode once after installation.
3. Accept the license if Xcode asks.

## 2. Download The Mobile App Project

Open a terminal in the folder where you want to keep the project.

Run:

```bash
git clone YOUR_GITHUB_FLUTTER_LINK_HERE
```

Replace `YOUR_GITHUB_FLUTTER_LINK_HERE` with the real GitHub link.

Then open the project in VS Code:

```bash
cd flutter_wordsaloud
code .
```

If `code .` does not work, open VS Code manually, choose **File > Open Folder**, and select the `flutter_wordsaloud` folder.

## 3. Install Flutter Packages

In the VS Code terminal, make sure you are inside the `flutter_wordsaloud` folder.

Run:

```bash
flutter pub get
```

This command downloads all Flutter packages needed by the app.

## 4. Connect The App To The Backend

The app has a backend URL inside this file:

```text
lib/core/network/constants/api_constants.dart
```

Look for this line:

```dart
static const String baseDomain = 'https://backendwordsaloudd-rose.vercel.app';
```

### Option A: Use The Published Backend

If you want to use the already published backend, keep the line as it is.

Then run the app normally.

### Option B: Use A Backend Running On Your Computer

If you want the app to use your local backend, first start the backend with:

```bash
npm run dev
```

Then change the `baseDomain` value in `api_constants.dart`.

For Android emulator, use:

```dart
static const String baseDomain = 'http://10.0.2.2:5000';
```

For iPhone simulator, use:

```dart
static const String baseDomain = 'http://localhost:5000';
```

For a real Android phone or real iPhone, use your computer's local Wi-Fi IP address. Example:

```dart
static const String baseDomain = 'http://192.168.1.10:5000';
```

Your phone and computer must be connected to the same Wi-Fi network.

After changing the backend URL, stop the app and run it again.

## 5. Check Connected Devices

Run:

```bash
flutter devices
```

This will show your available Android emulator, Android phone, iPhone simulator, or connected iPhone.

## 6. Run The App

Run:

```bash
flutter run
```

If more than one device is connected, Flutter may ask you to choose one.

## 7. Run On A Real Android Phone

1. Install Flutter and Android Studio.
2. Enable Developer Options on your Android phone.
3. Turn on USB Debugging.
4. Connect the phone to your computer with a USB cable.
5. Allow USB debugging when the phone asks.
6. Run:

```bash
flutter devices
flutter run
```

If the phone appears in the device list, Flutter can install the app on it.

## 8. Run On An iPhone

You need a Mac for iPhone development.

1. Install Xcode from the Mac App Store.
2. Install Flutter.
3. Connect the iPhone to the Mac.
4. Open the iOS project in Xcode if signing is required:

```bash
open ios/Runner.xcworkspace
```

5. In Xcode, choose your Apple developer team.
6. Go back to the terminal and run:

```bash
flutter devices
flutter run
```

## 9. Useful Flutter Commands

Run these commands inside the `flutter_wordsaloud` folder.

```bash
flutter pub get
flutter doctor
flutter devices
flutter run
flutter clean
```

If the app has strange build problems, try:

```bash
flutter clean
flutter pub get
flutter run
```

## 10. Common Mobile App Problems

### Flutter Doctor Shows Errors

Run:

```bash
flutter doctor
```

Read the message carefully. Flutter usually tells you exactly what is missing.

### App Cannot Connect To Backend

Check these things:

- The backend terminal is still running.
- The backend URL in `api_constants.dart` is correct.
- If using a real phone, the phone and computer are on the same Wi-Fi.
- If using Android emulator, use `http://10.0.2.2:5000`, not `http://localhost:5000`.
- If using iPhone simulator, `http://localhost:5000` should work.

### No Device Found

Run:

```bash
flutter devices
```

If no device appears, open an emulator from Android Studio or connect a real phone.
