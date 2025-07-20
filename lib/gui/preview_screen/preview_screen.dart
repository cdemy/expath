import 'dart:io';

import 'package:expath_app/core/providers.dart';
import 'package:expath_app/gui/preview_screen/_widgets/bidirectional_scroll_view.dart';
import 'package:expath_app/gui/preview_screen/_widgets/preview_table.dart';
import 'package:expath_app/gui/preview_screen/state/preview_screen_notifier.dart';
import 'package:expath_app/logic/excel/excel_exporter.dart';
import 'package:expath_app/logic/filesystem/root_directory_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreviewScreen extends ConsumerWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewState = ref.watch(refPreviewScreen);
    final previewNotifier = ref.read(refPreviewScreen.notifier);
    final appState = ref.watch(refAppState);
    final files = <File>[
      for (final directory in appState.directories) ...directory.files,
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Vorschau"),
        actions: [
          if (files.isNotEmpty) ...[
            TextButton(
              onPressed: () => previewNotifier.selectAll(files.length),
              child: Text('Alle auswählen'),
            ),
            TextButton(
              onPressed: () => previewNotifier.deselectAll(),
              child: Text('Alle abwählen'),
            ),
          ],
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (files.isEmpty)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.folder_open, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Keine Dateien gefunden',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Fügen Sie Verzeichnisse hinzu und erstellen Sie Regeln, um eine Vorschau zu sehen.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            if (files.isNotEmpty)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // File count and selection info
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Theme.of(context).dividerColor),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, size: 16),
                          SizedBox(width: 8),
                          Text(
                            '${files.length} Dateien gefunden, ${previewState.selectedRows.length} ausgewählt',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    // Preview table
                    Expanded(
                      child: BidirectionalScrollView(
                        child: PreviewTable(),
                      ),
                    ),
                    SizedBox(height: 8),
                    // Export button
                    ElevatedButton.icon(
                      onPressed: previewState.selectedRows.isNotEmpty ? () => _generateExcel(context, ref) : null,
                      icon: Icon(Icons.file_download),
                      label: Text("Excel-Datei generieren"),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  void _generateExcel(BuildContext context, WidgetRef ref) async {
    final previewState = ref.read(refPreviewScreen);
    if (previewState.selectedRows.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Keine Zeilen ausgewählt für Export.')),
      );
      return;
    }
    final notifier = ref.read(refPreviewScreen.notifier);
    notifier.setLoading(true);
    final appState = ref.watch(refAppState);
    final files = <File>[
      for (final directory in appState.directories) ...directory.files,
    ];
    try {
      await ExcelExporter.export(
        directories: [RootDirectoryEntry("Selektierte Dateien", files)],
        rulesStacks: appState.ruleStacks,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Excel-Datei erfolgreich exportiert!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Export: $e')),
        );
      }
    } finally {
      notifier.setLoading(false);
    }
  }
}
