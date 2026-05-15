# About the fixture isar.dll

## Why?

On a Windows host, `flutter test` runs Isar as a **native VM test**, not as a Flutter app. `isar_flutter_libs` bundles the DLL for `flutter run` on device/desktop, but unit tests must load `isar.dll` themselves via `Isar.initializeIsarCore()`.

## Workaround

### 1. Download the matching Isar Core binary

For your project (`isar: ^3.1.0+1`, 64-bit Windows):

https://github.com/isar/isar/releases/download/3.1.0%2B1/isar_windows_x64.dll

### 2. Rename and place it

Rename to `isar.dll` and put it somewhere stable, e.g.:

`flutter/weight_sovereignty/test/fixtures/isar.dll`

(Add `test/fixtures/isar.dll` to `.gitignore` if you don’t want the binary in git — document the download step in README instead.)

3. Point tests at that file explicitly

Tests use [`test/isar_test_helper.dart`](../isar_test_helper.dart), which loads `test/fixtures/isar.dll` via `Isar.initializeIsarCore(libraries: {Abi.current(): dllPath})`.

Run tests from the app directory:

```
cd flutter\weight_sovereignty
flutter test -j 1
```

4. If you still get error 126

Install the Microsoft Visual C++ Redistributable (x64) — the Isar DLL depends on it
