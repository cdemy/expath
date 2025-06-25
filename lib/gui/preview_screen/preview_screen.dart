import 'package:expath_app/gui/preview_screen/_widgets/bidirectional_scroll_view.dart';
import 'package:expath_app/gui/preview_screen/_widgets/preview_table.dart';
import 'package:expath_app/gui/preview_screen/preview_screen_state.dart';
import 'package:expath_app/logic/excel/excel_exporter.dart';
import 'package:expath_app/logic/filesystem/root_directory_entry.dart';
import 'package:expath_app/logic/rules/rule_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreviewScreen extends ConsumerWidget {
  final List<RootDirectoryEntry> directories;
  final List<RuleStack> ruleStacks;

  const PreviewScreen({
    super.key,
    required this.directories,
    required this.ruleStacks,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize the preview screen state on first build
    final previewNotifier = ref.read(previewScreenProvider.notifier);
    final previewState = ref.watch(previewScreenProvider);
    
    // Initialize if not already done
    if (previewState.directories.isEmpty && previewState.ruleStacks.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        previewNotifier.initialize(directories, ruleStacks);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Vorschau"),
        actions: [
          if (previewState.hasFiles) ...[
            TextButton(
              onPressed: () => previewNotifier.selectAll(),
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
        child: _buildBody(context, ref, previewState, previewNotifier),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, PreviewScreenState state, PreviewScreenNotifier notifier) {
    if (state.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Daten werden verarbeitet...'),
          ],
        ),
      );
    }

    if (!state.hasFiles) {
      return const Center(
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
      );
    }

    return Column(
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
                '${state.allFiles.length} Dateien gefunden, ${state.selectedFiles.length} ausgewählt',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        // Preview table
        Expanded(
          child: BidirectionalScrollView(
            child: PreviewTable(
              ruleStacks: state.ruleStacks,
              allFiles: state.allFiles,
              selectedRows: state.selectedRows,
              toggleSelection: (filePath, selected) => notifier.toggleSelection(filePath, selected),
            ),
          ),
        ),
        SizedBox(height: 8),
        // Export button
        ElevatedButton.icon(
          onPressed: state.hasSelectedFiles ? () => _generateExcel(context, ref, state) : null,
          icon: Icon(Icons.file_download),
          label: Text("Excel-Datei generieren"),
        ),
      ],
    );
  }

  void _generateExcel(BuildContext context, WidgetRef ref, PreviewScreenState state) async {
    if (!state.hasSelectedFiles) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Keine Zeilen ausgewählt für Export.')),
      );
      return;
    }

    final notifier = ref.read(previewScreenProvider.notifier);
    notifier.setLoading(true);

    try {
      await ExcelExporter.export(
        directories: [RootDirectoryEntry("Selektierte Dateien", state.selectedFiles)],
        rulesStacks: state.ruleStacks,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Excel-Datei erfolgreich exportiert!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Export: $e')),
      );
    } finally {
      notifier.setLoading(false);
    }
  }
}
