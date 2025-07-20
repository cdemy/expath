import 'package:expath_app/core/providers.dart';
import 'package:expath_app/gui/preview_screen/preview_screen.dart';
import 'package:expath_app/logic/filesystem/pathfinder.dart';
import 'package:expath_app/logic/filesystem/root_directory_entry.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget for directory-related buttons
class DirectoryButtonsRow extends ConsumerWidget {

  const DirectoryButtonsRow({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // "New" button (resets directories list)
        ElevatedButton(
          onPressed: () {
            _onClearDirectories(context, ref);
          },
          child: Text("Neu"),
        ),
        SizedBox(width: 8),
        // "Add directory" button
        ElevatedButton(
          onPressed: () {
            _onSelectDirectory(context, ref);
          },
          child: Text("Ordner hinzufügen"),
        ),
        SizedBox(width: 8),
        // "Preview" button
        ElevatedButton(
          onPressed: () {
            _onPreview(context, ref);
          },
          child: Text("Vorschau"),
        ),
      ],
    );
  }

  void _onClearDirectories(BuildContext context, WidgetRef ref) async {
    final appStateNotifier = ref.read(refAppState.notifier);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alle nicht gespeicherten Daten gehen verloren!'),
        content: Text('Möchten Sie wirklich mit neuen leeren Darten neu starten?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Abbrechen')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Neu starten'),
          )
        ],
      ),
    );
    if (confirmed == true) {
      appStateNotifier.clearAll();
      if (context.mounted) {
        // Show confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Daten wurden zurückgesetzt')),
        );
      }
    }
  }

  void _onPreview(BuildContext context, WidgetRef ref) {
    final state = ref.read(refAppState);
    if (state.directories.isEmpty || state.ruleStacks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bitte Verzeichnisse und Regeln anlegen.')));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(
        ),
      ),
    );
  }



  Future<void> _onSelectDirectory(BuildContext context, WidgetRef ref) async {
    final appState = ref.read(refAppState);
    final appStateNotifier = ref.read(refAppState.notifier);

    final String? selectedDirectory = await getDirectoryPath();
    if (selectedDirectory != null) {
      if (appState.directories.any((dir) => dir.path == selectedDirectory)) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Dieses Verzeichnis wurde bereits hinzugefügt.')));
        return;
      }

      final pathfinder = Pathfinder(selectedDirectory);
      final files = pathfinder.getAllFiles();

      appStateNotifier.addDirectory(RootDirectoryEntry(selectedDirectory, files));
    }
  }
}
