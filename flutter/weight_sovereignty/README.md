# weight_sovereignty

Self-control your body weight — offline Flutter app (Android primary).

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) on `PATH` (`flutter doctor` should show Android toolchain OK)
- Android SDK (via Android Studio or command-line tools)
- USB debugging enabled on device, or copy APK manually

All commands below run from this directory:

```powershell
cd flutter/weight_sovereignty
```

## Run on a connected device

```powershell
flutter pub get
flutter run
```

Release mode on device:

```powershell
flutter run --release
```

## Build a release APK

Standard single APK (all ABIs, easiest for manual install):

```powershell
flutter pub get
flutter build apk --release
```

Output:

```text
build/app/outputs/flutter-apk/app-release.apk
```

Smaller per-CPU APKs (install only the one matching your phone):

```powershell
flutter build apk --release --split-per-abi
```

Outputs under `build/app/outputs/flutter-apk/`:

- `app-armeabi-v7a-release.apk` — older 32-bit ARM phones
- `app-arm64-v8a-release.apk` — most current Android phones
- `app-x86_64-release.apk` — emulators

### Install on phone

**Option A — USB (`adb`):**

```powershell
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

`-r` replaces an existing install. Uninstall first if signature conflicts.

**Option B — manual:** copy `app-release.apk` to the phone and open it (allow install from unknown sources if prompted).

### Signing note

Release builds currently use the **debug keystore** (see `android/app/build.gradle.kts`). Fine for personal sideload testing. For Play Store or long-term installs, configure a release keystore before publishing.

## Android / Gradle

The app module lives in `android/`; Flutter code is the project root (`flutter { source = "../.." }` in `android/app/build.gradle.kts`).

`isar_flutter_libs` 3.1.x needs a small workaround in `android/build.gradle.kts` (namespace + `compileSdk`) for AGP 8 release builds. Keep that block when upgrading Isar until the plugin ships a fix.

If a build fails after dependency changes:

```powershell
flutter clean
flutter pub get
flutter build apk --release
```

## Development

Generate Isar models after changing `@collection` / `@embedded` types:

```powershell
dart run build_runner build --delete-conflicting-outputs
```

Run tests:

```powershell
flutter test -j 1
```

On Windows, Isar unit tests need `test/fixtures/isar.dll` — see [test/fixtures/README.md](test/fixtures/README.md).

## App ID

`com.mccloud.weight_sovereignty` — set in `android/app/build.gradle.kts`.
