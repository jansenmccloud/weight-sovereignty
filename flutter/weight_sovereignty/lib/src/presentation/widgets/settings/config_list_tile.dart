import 'package:flutter/material.dart';

class ConfigListTile extends StatelessWidget {
  const ConfigListTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.onTap,
    required this.onDelete,
  });

  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      onTap: onTap,
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: onDelete,
        tooltip: 'Delete',
      ),
    );
  }
}
