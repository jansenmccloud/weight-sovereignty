import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncListScaffold<T> extends StatelessWidget {
  const AsyncListScaffold({
    super.key,
    required this.title,
    required this.asyncValue,
    required this.onRetry,
    required this.itemBuilder,
    this.floatingActionButton,
    this.appBarActions,
    this.header,
  });

  final String title;
  final AsyncValue<List<T>> asyncValue;
  final VoidCallback onRetry;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final Widget? floatingActionButton;
  final List<Widget>? appBarActions;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: appBarActions,
      ),
      floatingActionButton: floatingActionButton,
      body: asyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Error: $error', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton(onPressed: onRetry, child: const Text('Retry')),
              ],
            ),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Column(
              children: [
                if (header != null) header!,
                const Expanded(
                  child: Center(child: Text('No entries yet')),
                ),
              ],
            );
          }
          return Column(
            children: [
              if (header != null) header!,
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) =>
                      itemBuilder(context, items[index]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
