import 'dart:io';

import 'package:expath_app/core/providers.dart';
import 'package:expath_app/gui/preview_screen/state/preview_screen_notifier.dart';
import 'package:expath_app/logic/models/rule_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreviewTable extends ConsumerWidget {
  const PreviewTable({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewState = ref.watch(refPreviewScreen);
    final appState = ref.watch(refAppState);
    final ruleStacks = appState.ruleStacks;
    final allFiles = appState.directories.expand((dir) => dir.files).toList();
    final selectedRows = previewState.selectedRows;
    final selectedFiles = selectedRows.map((index) => allFiles[index]).toList();
    return DataTable(
      columns: [
        DataColumn(label: Text('An/Abwählen')), // Checkbox column
        ...appState.ruleStacks.map((ruleStack) => DataColumn(
              label: Text(ruleStack.excelField),
            )),
      ],
      rows: allFiles
          .map((file) => DataRow(
                cells: [
                  DataCell(
                    Checkbox(
                      value: selectedFiles.contains(file),
                      onChanged: (_) {
                        final index = allFiles.indexOf(file);
                        final notifier = ref.read(refPreviewScreen.notifier);
                        notifier.toggleSelection(index);
                      },
                    ),
                  ),
                  ..._buildRuleResultCells(file, ruleStacks),
                ],
              ))
          .toList(),
    );
  }

  /// Build cells containing rule application results
  List<DataCell> _buildRuleResultCells(File file, List<RuleStack> ruleStacks) {
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
      return 'ERROR: Regel "${ruleStack.excelField}" fehlgeschlagen';
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
