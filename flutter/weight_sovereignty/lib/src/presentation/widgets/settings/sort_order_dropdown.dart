import 'package:flutter/material.dart';

enum SortOrder { ascending, descending }

class SortOrderDropdown<T> extends StatefulWidget {
  const SortOrderDropdown({super.key, required this.onChanged, this.initialValue = SortOrder.ascending});

  final ValueChanged<SortOrder> onChanged;
  final SortOrder initialValue;

  @override
  State<SortOrderDropdown<T>> createState() => _SortOrderDropdownState();
}

class _SortOrderDropdownState extends State<SortOrderDropdown<T>> {
  SortOrder _value = SortOrder.ascending;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortOrder>(
      initialValue: _value,
      tooltip: 'Sort order',
      icon: const Icon(Icons.sort, size: 18),
      onSelected: (v) {
        setState(() => _value = v);
        widget.onChanged(v);
      },
      itemBuilder: const [
        PopupMenuItem(value: SortOrder.ascending, child: Text('A → Z')),
        PopupMenuItem(value: SortOrder.descending, child: Text('Z → A')),
      ],
    );
  }
}