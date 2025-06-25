import 'package:expath_app/logic/filesystem/root_directory_entry.dart';
import 'package:flutter/material.dart';

/// Individual directory list item widget
class DirectoryListItem extends StatelessWidget {
  final RootDirectoryEntry directory;
  final VoidCallback onRemove;

  const DirectoryListItem({
    super.key,
    required this.directory,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 6, child: Text(directory.path)),
          Expanded(flex: 2, child: Text('${directory.fileCount} Dateien')),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _showRemoveConfirmation(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Show confirmation dialog before removing directory
  void _showRemoveConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Verzeichnis entfernen'),
        content: Text('Möchten Sie das Verzeichnis "${directory.path}" wirklich entfernen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Entfernen'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onRemove();
    }
  }
}