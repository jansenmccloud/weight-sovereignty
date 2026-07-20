import 'package:flutter/material.dart';
import 'package:weight_sovereignty/src/presentation/theme/app_theme.dart';

class ConfigListTile extends StatelessWidget {
  const ConfigListTile({super.key, required this.title, this.subtitle, required this.onTap, required this.onDelete});

  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: TextStyle(color: AppTheme.white)),
      subtitle: subtitle != null ? Text(subtitle!, style: TextStyle(color: AppTheme.grey)) : null,
      onTap: onTap,
      trailing: IconButton(icon: const Icon(Icons.delete_outline), color: AppTheme.purple, iconSize: 18.0, onPressed: onDelete, tooltip: 'Delete'),
    );
  }
}
