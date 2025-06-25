import 'package:expath_app/gui/rule_editor_screen/rule_editor_state.dart';
import 'package:flutter/material.dart';

/// Widget for rendering rule input fields based on rule type
class RuleInputWidget extends StatelessWidget {
  final RuleEditingBundle bundle;
  final VoidCallback onChanged;

  const RuleInputWidget({
    super.key,
    required this.bundle,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: bundle.eingabenControllers.map((eingabe) => _buildInputField(eingabe)).toList(),
    );
  }

  /// Build input field based on rule type and input configuration
  Widget _buildInputField(TitledTextEditingController eingabe) {
    // Special handling for LowerUpperCaseRule
    if (bundle.rule.runtimeType.toString() == 'LowerUpperCaseRule' &&
        eingabe.label == 'Groß-/Kleinschreibung') {
      return _buildCaseSelectionDropdown(eingabe);
    }
    
    // Default text field for most inputs
    return _buildTextInputField(eingabe);
  }

  /// Build dropdown for case selection (LowerUpperCaseRule)
  Widget _buildCaseSelectionDropdown(TitledTextEditingController eingabe) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<int>(
        value: int.tryParse(eingabe.controller.text) ?? 0,
        decoration: InputDecoration(
          labelText: eingabe.label,
          border: OutlineInputBorder(),
        ),
        items: const [
          DropdownMenuItem(value: 0, child: Text('Kleinbuchstaben (lowercase)')),
          DropdownMenuItem(value: 1, child: Text('Großbuchstaben (UPPERCASE)')),
        ],
        onChanged: (val) {
          eingabe.controller.text = val.toString();
          onChanged();
        },
      ),
    );
  }

  /// Build standard text input field
  Widget _buildTextInputField(TitledTextEditingController eingabe) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: eingabe.controller,
        decoration: InputDecoration(
          labelText: eingabe.label,
          border: OutlineInputBorder(),
          helperText: _getHelperText(eingabe),
        ),
        keyboardType: eingabe.valueType == int ? TextInputType.number : TextInputType.text,
        onChanged: (_) => onChanged(),
      ),
    );
  }

  /// Get helper text for input fields based on rule type and label
  String? _getHelperText(TitledTextEditingController eingabe) {
    final ruleTypeName = bundle.rule.runtimeType.toString();
    
    switch (ruleTypeName) {
      case 'SimpleRegexRule':
        if (eingabe.label.contains('Regex')) {
          return 'Regulärer Ausdruck (z.B. \\d+ für Zahlen)';
        }
        break;
      case 'PathSegmentRule':
        if (eingabe.label.contains('Index')) {
          return 'Index des Pfadsegments (0 = erstes Segment)';
        }
        break;
      case 'FileSizeRule':
        if (eingabe.label.contains('Einheit')) {
          return 'B, KB, MB, GB';
        }
        break;
    }
    
    return null;
  }
}