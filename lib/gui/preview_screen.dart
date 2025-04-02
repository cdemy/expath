import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import '../logic/rule_system.dart';
import '../models/root_directory_entry.dart';
import 'package:file_picker/file_picker.dart';
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

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allFiles = widget.directories.expand((dir) => dir.filePaths).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Vorschau"),
        actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            tooltip: "Export nach Excel (noch ohne Funktion)",
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Export noch nicht implementiert.")),
              );
            },
          ),
        ],
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
                                DataColumn(label: Text('Dateipfad')),
                                ...widget.rules.map((rule) => DataColumn(label: Text(rule.excelField))),
                              ],
                              rows: allFiles.map((filePath) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(filePath)),
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
                      try {
                        await ExcelExporter.export(
                          directories: widget.directories,
                          rules: widget.rules,
                        );
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Excel-Datei erfolgreich exportiert!')));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fehler: $e')));
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
