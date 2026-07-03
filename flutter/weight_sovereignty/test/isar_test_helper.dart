import 'dart:ffi';
import 'dart:io';

import 'package:isar/isar.dart';

String get isarFixtureDllPath => [
      Directory.current.path,
      'test',
      'fixtures',
      'isar.dll',
    ].join(Platform.pathSeparator);

Future<void> initializeIsarCoreForTests() async {
  final dllPath = isarFixtureDllPath;
  if (!File(dllPath).existsSync()) {
    throw StateError(
      'Missing Isar DLL at $dllPath. See test/fixtures/README.md',
    );
  }

  await Isar.initializeIsarCore(
    libraries: {Abi.current(): dllPath},
  );
}
