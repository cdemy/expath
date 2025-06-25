import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget for directory-related buttons
class DirectoryButtonsRow extends ConsumerWidget {
  final VoidCallback onClearDirectories;
  final VoidCallback onSelectDirectory;
  final VoidCallback onPreview;

  const DirectoryButtonsRow({
    super.key,
    required this.onClearDirectories,
    required this.onSelectDirectory,
    required this.onPreview,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // "New" button (resets directories list)
        ElevatedButton(
          onPressed: onClearDirectories,
          child: Text("Neu"),
        ),
        SizedBox(width: 8),
        // "Add directory" button
        ElevatedButton(
          onPressed: onSelectDirectory,
          child: Text("Ordner hinzufügen"),
        ),
        SizedBox(width: 8),
        // "Preview" button
        ElevatedButton(
          onPressed: onPreview,
          child: Text("Vorschau"),
        ),
      ],
    );
  }
}