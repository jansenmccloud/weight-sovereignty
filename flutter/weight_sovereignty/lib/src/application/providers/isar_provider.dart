import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:weight_sovereignty/src/data/source/local/local_storage.dart';

final isarProvider = FutureProvider<Isar>((ref) async {
  ref.keepAlive();
  return LocalStorage.open();
});
