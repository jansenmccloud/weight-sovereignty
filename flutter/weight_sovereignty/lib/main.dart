import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_sovereignty/src/presentation/app_root.dart';

void main() {
  runApp(
    ProviderScope(child: AppRoot())
  );
}
