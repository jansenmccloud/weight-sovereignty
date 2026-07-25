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
    this.filter,
    required this.comparator,
    this.reversed = false,
  });

  final String title;
  final AsyncValue<List<T>> asyncValue;
  final VoidCallback onRetry;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final Widget? floatingActionButton;
  final List<Widget>? appBarActions;
  final Widget? header;

  /// Filter predicate — only items matching are shown. null = no filter.
  final bool Function(T item)? filter;

  /// Comparator for sorting. Must not be null.
  final int Function(T a, T b) comparator;

  /// Whether to reverse the comparator (for descending sort).
  final bool reversed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: appBarActions),
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
          // Apply filter if provided
          var displayItems = filter != null ? items.where(filter!).toList() : items;

          // Apply sort
          final comp = reversed ? ((a, b) => comparator(b, a)) : comparator;
          displayItems..sort(comp);

          if (displayItems.isEmpty) {
            return Column(
              children: [
                if (header != null) header!,
                const Expanded(child: Center(child: Text('No entries yet'))),
              ],
            );
          }
          return Column(
            children: [
              if (header != null) header!,
              Expanded(
                child: ListView.builder(itemCount: displayItems.length, itemBuilder: (context, index) => itemBuilder(context, displayItems[index])),
              ),
            ],
          );
        },
      ),
    );
  }
}
