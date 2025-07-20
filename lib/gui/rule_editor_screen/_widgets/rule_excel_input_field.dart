import 'package:expath_app/gui/rule_editor_screen/state/rule_editor_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RuleExcelInputField extends ConsumerStatefulWidget {
  const RuleExcelInputField({
    this.initialValue,
    super.key,
  });

  final String? initialValue;

  @override
  ConsumerState<RuleExcelInputField> createState() => _RuleExcelInputFieldState();
}

class _RuleExcelInputFieldState extends ConsumerState<RuleExcelInputField> {
  final TextEditingController _controller = TextEditingController();
  late final RuleEditorNotifier _ruleEditorNotifier;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue ?? '';
    _ruleEditorNotifier = ref.read(refRuleEditor.notifier);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: 'Spalte (Excel-Feld für diese Regelgruppe)',
        border: OutlineInputBorder(),
        helperText: 'Name der Spalte in der Excel-Datei',
      ),
      onChanged: (value) {
        _ruleEditorNotifier.updateExcelField(value);
      },
    );
  }
}
