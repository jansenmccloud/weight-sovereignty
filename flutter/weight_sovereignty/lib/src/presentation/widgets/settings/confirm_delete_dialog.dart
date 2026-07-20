import 'package:flutter/material.dart';

Future<bool> confirmDelete(BuildContext context, {String? itemName}) async {
  final label = itemName?.trim();
  final message = label != null && label.isNotEmpty ? 'Delete "$label"?' : 'Delete this item?';

  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete'),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
      ],
    ),
  );
  return result ?? false;
}
