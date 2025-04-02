import 'package:flutter/material.dart';
import '../logic/rule_system.dart';
import '../models/root_directory_entry.dart';

class PreviewScreen extends StatelessWidget {
  final List<RootDirectoryEntry> directories;
  final List<Rule> rules;

  const PreviewScreen({
    super.key,
    required this.directories,
    required this.rules,
  });

  @override
  Widget build(BuildContext context) {
    // Sammle alle Dateien
    final allFiles = directories.expand((dir) => dir.filePaths).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Vorschau"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: allFiles.isEmpty
            ? Center(child: Text('Keine Dateien gefunden.'))
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Dateipfad')),
                    ...rules.map((rule) => DataColumn(label: Text(rule.excelField))),
                  ],
                  rows: allFiles.map((filePath) {
                    return DataRow(cells: [
                      DataCell(Text(filePath)),
                      ...rules.map((rule) {
                        final result = rule.apply(filePath) ?? "";
                        return DataCell(Text(result));
                      }),
                    ]);
                  }).toList(),
                ),
              ),
      ),
    );
  }
}
