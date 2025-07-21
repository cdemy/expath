import 'package:expath_app/gui/rule_editor_screen/state/rule_editor_state_notifier.dart';
import 'package:expath_app/logic/rules/_rule_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RuleEingabeInputField extends ConsumerStatefulWidget {
  const RuleEingabeInputField({
    required this.ruleType,
    required this.ruleIndex,
    required this.eingabeIndex,
    super.key,
  });

  final RuleType ruleType;
  final int ruleIndex;
  final int eingabeIndex;

  @override
  ConsumerState<RuleEingabeInputField> createState() => _RuleEingabeInputFieldState();
}

class _RuleEingabeInputFieldState extends ConsumerState<RuleEingabeInputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    final protoRule = ref.read(refRuleEditor).protoRules[widget.ruleIndex];
    _controller.text = protoRule.protoEingaben[widget.eingabeIndex].eingabe;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eingabeBlueprint = widget.ruleType.eingabeBlueprints[widget.eingabeIndex];
    final ruleEditorNotifier = ref.read(refRuleEditor.notifier);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: eingabeBlueprint.label,
          border: OutlineInputBorder(),
          helperText: eingabeBlueprint.helperText,
        ),
        keyboardType: eingabeBlueprint.valueType == int ? TextInputType.number : TextInputType.text,
        onChanged: (value) {
          ruleEditorNotifier.updateEingabeValue(widget.ruleIndex, widget.eingabeIndex, value);
        },
      ),
    );
  }
}
