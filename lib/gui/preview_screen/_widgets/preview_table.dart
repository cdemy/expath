import 'dart:io';

import 'package:dj_projektarbeit/logic/rules/_rule.dart';
import 'package:flutter/material.dart';

class PreviewTable extends StatelessWidget {
  final List<RuleStack> ruleStacks;
  final List<File> allFiles;
  final Map<String, bool> selectedRows;
  final void Function(String, bool?) toggleSelection;

  const PreviewTable({
    required this.ruleStacks,
    required this.allFiles,
    required this.selectedRows,
    required this.toggleSelection,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text('An/Abwählen')), // Checkbox-Spalte
        ...ruleStacks.map((ruleStack) => DataColumn(label: Text(ruleStack.excelField ?? '???'))),
      ],
      rows: allFiles.map((file) {
        final isChecked = selectedRows[file.path] ?? false;
        return DataRow(
          cells: [
            DataCell(
              Checkbox(
                value: isChecked,
                onChanged: (val) => toggleSelection(file.path, val),
              ),
            ),
            ...ruleStacks.map((rule) {
              final result = rule.apply(file) ?? "";
              return DataCell(Text(result));
            }),
          ],
        );
      }).toList(),
    );
  }
}
