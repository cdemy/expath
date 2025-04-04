import 'package:flutter/material.dart';
import '../logic/rule.dart';
import '../logic/root_directory_entry.dart';
import '../logic/excel_exporter.dart';

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
  void initState() {
    super.initState();
    allFiles = widget.directories.expand((dir) => dir.filePaths).toList();
    selectedRows = {for (var file in allFiles) file: true};
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  void _toggleSelection(String filePath, bool? selected) {
    setState(() {
      selectedRows[filePath] = selected ?? false;
    });
  }

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
                            child: DataTable(
                              columns: [
                                DataColumn(label: Text('✔')), // Checkbox-Spalte
                                ...widget.rules.map((rule) => DataColumn(label: Text(rule.excelField))),
                              ],
                              rows: allFiles.map((filePath) {
                                final isChecked = selectedRows[filePath] ?? false;
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Checkbox(
                                        value: isChecked,
                                        onChanged: (val) => _toggleSelection(filePath, val),
                                      ),
                                    ),
                                    ...widget.rules.map((rule) {
                                      final result = rule.apply(filePath) ?? "";
                                      return DataCell(Text(result));
                                    }),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
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
                    },
                    icon: Icon(Icons.file_download),
                    label: Text("Excel-Datei generieren"),
                  ),
                ],
              ),
      ),
    );
  }
}
