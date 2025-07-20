import 'dart:io';
import 'package:expath_app/gui/rule_editor_screen/_widgets/rule_input_widget.dart';
import 'package:expath_app/gui/rule_editor_screen/state/rule_editor_state_notifier.dart';
import 'package:expath_app/logic/models/proto_rule.dart';
import 'package:expath_app/logic/rules/_rule_type.dart';
import 'package:expath_app/logic/models/rule_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget representing a single rule step in the editor
class RuleEditorRuleCard extends ConsumerWidget {
  final int ruleIndex;
  final File? previewFile;

  const RuleEditorRuleCard({
    super.key,
    required this.ruleIndex,
    this.previewFile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ruleEditorState = ref.watch(refRuleEditor);
    final protoRule = ruleEditorState.protoRules[ruleIndex];
    final ruleEditorNotifier = ref.watch(refRuleEditor.notifier);
    final currentType = protoRule.ruleType;
    final result = _calculatePreviewResult(ruleEditorState.protoRules, ruleEditorState.excelField);
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Schritt ${ruleIndex + 1}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<RuleType>(
                    value: protoRule.ruleType,
                    isExpanded: true,
                    items: _getAvailableRuleTypes().map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.label),
                      );
                    }).toList(),
                    onChanged: (type) {
                      if (type != null && type != currentType) {
                        ruleEditorNotifier.updateProtoRuleRuleType(ruleIndex, type);
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => ruleEditorNotifier.removeProtoRule(ruleIndex),
                  tooltip: 'Regel entfernen',
                ),
              ],
            ),
            SizedBox(height: 12),
            RuleInputsWidget(
              protoRule: protoRule,
              ruleIndex: ruleIndex,
              key: Key('rule_inputs:${protoRule.ruleType}:$ruleIndex'),
            ),
            if (previewFile != null) ...[
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vorschau:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      result ?? 'Kein Ergebnis',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Get available rule types based on position
  List<RuleType> _getAvailableRuleTypes() {
    if (ruleIndex == 0) {
      // First position can use any rule type
      return RuleType.values;
    } else {
      // Subsequent positions cannot use rules that are only for first position
      return RuleType.values.where((v) => !v.onlyFirstPosition).toList();
    }
  }

  /// Calculate preview result for this step
  String? _calculatePreviewResult(List<ProtoRule> protoRules, String excelField) {
    if (previewFile == null) return null;
    try {
      // Get rules up to and including this step
      final rulesSoFar = protoRules.getRange(0, ruleIndex + 1).map((rb) => rb.toRule()).toList();
      final ruleStackSoFar = RuleStack(rules: rulesSoFar, excelField: excelField);
      return ruleStackSoFar.apply(previewFile!);
    } catch (e) {
      return 'Fehler: $e';
    }
  }
}
