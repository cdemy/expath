import 'dart:io';

import 'package:expath_app/logic/rules/rule_stack.dart';
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
      columns: _buildTableColumns(),
      rows: _buildTableRows(),
    );
  }

  /// Build the table columns (headers)
  List<DataColumn> _buildTableColumns() {
    return [
      DataColumn(label: Text('An/Abwählen')), // Checkbox column
      ...ruleStacks.map((ruleStack) => DataColumn(
        label: Text(ruleStack.excelField ?? '???'),
      )),
    ];
  }

  /// Build the table rows (data)
  List<DataRow> _buildTableRows() {
    return allFiles.map((file) => _buildTableRow(file)).toList();
  }

  /// Build a single table row for a file
  DataRow _buildTableRow(File file) {
    final isChecked = selectedRows[file.path] ?? false;
    
    return DataRow(
      cells: [
        _buildCheckboxCell(file, isChecked),
        ..._buildRuleResultCells(file),
      ],
    );
  }

  /// Build the checkbox cell for file selection
  DataCell _buildCheckboxCell(File file, bool isChecked) {
    return DataCell(
      Checkbox(
        value: isChecked,
        onChanged: (val) => toggleSelection(file.path, val),
      ),
    );
  }

  /// Build cells containing rule application results
  List<DataCell> _buildRuleResultCells(File file) {
    return ruleStacks.map((ruleStack) => _buildRuleResultCell(file, ruleStack)).toList();
  }

  /// Build a single cell with rule application result
  DataCell _buildRuleResultCell(File file, RuleStack ruleStack) {
    try {
      final result = _applyRuleStackSafely(file, ruleStack);
      return DataCell(
        Text(result),
        onTap: result.startsWith('ERROR:') ? () => _showErrorDetails(ruleStack, result) : null,
      );
    } catch (e) {
      final errorMessage = 'ERROR: Unerwarteter Fehler';
      return DataCell(
        Text(errorMessage, style: TextStyle(color: Colors.red)),
        onTap: () => _showErrorDetails(ruleStack, 'Unerwarteter Fehler: $e'),
      );
    }
  }

  /// Apply rule stack with proper error handling
  String _applyRuleStackSafely(File file, RuleStack ruleStack) {
    try {
      final result = ruleStack.apply(file);
      return result ?? '';
    } on FileSystemException catch (e) {
      return 'ERROR: Dateizugriff fehlgeschlagen (${e.message})';
    } on FormatException catch (e) {
      return 'ERROR: Formatfehler (${e.message})';
    } catch (e) {
      return 'ERROR: Regel "${ruleStack.excelField ?? 'Unbenannt'}" fehlgeschlagen';
    }
  }

  /// Show detailed error information
  void _showErrorDetails(RuleStack ruleStack, String errorMessage) {
    // This would need a BuildContext to show a dialog
    // For now, we'll just print the error (in a real implementation, 
    // this could be handled by passing a callback or using a global error handler)
    debugPrint('Error in rule stack "${ruleStack.excelField}": $errorMessage');
  }
}
