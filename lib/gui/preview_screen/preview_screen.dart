import 'package:dj_projektarbeit/gui/preview_screen/_widgets/preview_table.dart';
import 'package:dj_projektarbeit/logic/excel_exporter.dart';
import 'package:dj_projektarbeit/logic/root_directory_entry.dart';
import 'package:dj_projektarbeit/logic/rules/_rule.dart';
import 'package:flutter/material.dart';

class PreviewScreen extends StatefulWidget {
  final List<RootDirectoryEntry> directories;
  final List<Rule> rules;

  const PreviewScreen({
    super.key,
    required this.directories,
    required this.rules,
  });

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  late List<String> allFiles;
  late Map<String, bool> selectedRows;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vorschau"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: allFiles.isEmpty
            ? Center(child: Text('Keine Dateien gefunden.'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Scrollbar(
                      controller: _horizontalController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: _horizontalController,
                        scrollDirection: Axis.horizontal,
                        child: Scrollbar(
                          controller: _verticalController,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            controller: _verticalController,
                            scrollDirection: Axis.vertical,
                            child: PreviewTable(
                              rules: widget.rules,
                              allFiles: allFiles,
                              selectedRows: selectedRows,
                              toggleSelection: _toggleSelection,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _generateExcel,
                    icon: Icon(Icons.file_download),
                    label: Text("Excel-Datei generieren"),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    allFiles = widget.directories.expand((dir) => dir.filePaths).toList();
    selectedRows = {for (var file in allFiles) file: true};
  }

  void _generateExcel() async {
    final selectedPaths = allFiles.where((path) => selectedRows[path] == true).toList();

    if (selectedPaths.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Keine Zeilen ausgewählt für Export.")),
      );
      return;
    }

    try {
      await ExcelExporter.export(
        directories: [RootDirectoryEntry("Selektierte Dateien", selectedPaths)],
        rules: widget.rules,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Excel-Datei erfolgreich exportiert!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Export: $e')),
      );
    }
  }

  void _toggleSelection(String filePath, bool? selected) {
    setState(() {
      selectedRows[filePath] = selected ?? false;
    });
  }
}
