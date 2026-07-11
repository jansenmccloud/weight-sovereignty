import 'package:flutter/material.dart';

class ConfigFormScaffold extends StatelessWidget {
  const ConfigFormScaffold({
    super.key,
    required this.title,
    required this.onSave,
    required this.child,
    this.isSaving = false,
  });

  final String title;
  final VoidCallback? onSave;
  final Widget child;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          TextButton(
            onPressed: isSaving ? null : onSave,
            child: isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [child],
      ),
    );
  }
}

void showConfigError(BuildContext context, Object error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(error.toString())),
  );
}
