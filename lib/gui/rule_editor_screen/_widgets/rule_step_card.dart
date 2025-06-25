import 'dart:io';
import 'package:expath_app/gui/rule_editor_screen/_widgets/rule_input_widget.dart';
import 'package:expath_app/gui/rule_editor_screen/rule_editor_state.dart';
import 'package:expath_app/logic/rules/_rule_type.dart';
import 'package:expath_app/logic/rules/rule_stack.dart';
import 'package:flutter/material.dart';

/// Widget representing a single rule step in the editor
class RuleStepCard extends StatelessWidget {
  final int stepIndex;
  final RuleEditingBundle bundle;
  final File? previewFile;
  final List<RuleEditingBundle> allBundles;
  final Function(RuleType) onRuleTypeChanged;
  final VoidCallback onRemove;
  final VoidCallback onInputChanged;

  const RuleStepCard({
    super.key,
    required this.stepIndex,
    required this.bundle,
    this.previewFile,
    required this.allBundles,
    required this.onRuleTypeChanged,
    required this.onRemove,
    required this.onInputChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            SizedBox(height: 12),
            RuleInputWidget(
              bundle: bundle,
              onChanged: onInputChanged,
            ),
            if (previewFile != null) ...[
              SizedBox(height: 12),
              _buildPreviewResult(context),
            ],
          ],
        ),
      ),
    );
  }

  /// Build the card header with step number, rule type dropdown, and remove button
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          'Schritt ${stepIndex + 1}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 16),
        Expanded(
          child: DropdownButton<RuleType>(
            value: bundle.selectedRuleType,
            isExpanded: true,
            items: _getAvailableRuleTypes().map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.label),
              );
            }).toList(),
            onChanged: (type) {
              if (type != null) {
                onRuleTypeChanged(type);
              }
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: onRemove,
          tooltip: 'Regel entfernen',
        ),
      ],
    );
  }

  /// Build preview result section
  Widget _buildPreviewResult(BuildContext context) {
    final result = _calculatePreviewResult();
    
    return Container(
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
    );
  }

  /// Get available rule types based on position
  List<RuleType> _getAvailableRuleTypes() {
    if (stepIndex == 0) {
      // First position can use any rule type
      return RuleType.values;
    } else {
      // Subsequent positions cannot use rules that are only for first position
      return RuleType.values.where((v) => !v.onlyFirstPosition).toList();
    }
  }

  /// Calculate preview result for this step
  String? _calculatePreviewResult() {
    if (previewFile == null) return null;
    
    try {
      // Get rules up to and including this step
      final rulesSoFar = allBundles
          .getRange(0, stepIndex + 1)
          .map((rb) => rb.toRule())
          .toList();
      
      final ruleStackSoFar = RuleStack(rules: rulesSoFar);
      return ruleStackSoFar.apply(previewFile!);
    } catch (e) {
      return 'Fehler: $e';
    }
  }
}