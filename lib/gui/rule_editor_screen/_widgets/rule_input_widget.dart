import 'package:expath_app/gui/rule_editor_screen/_widgets/rule_eingabe_input_field.dart';
import 'package:expath_app/logic/models/proto_rule.dart';
import 'package:flutter/material.dart';

/// Widget for rendering rule input fields based on rule type
class RuleInputsWidget extends StatelessWidget {
  final ProtoRule protoRule;
  final int ruleIndex;

  const RuleInputsWidget({
    super.key,
    required this.protoRule,
    required this.ruleIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < protoRule.ruleType.eingabeBlueprints.length; i++)
          RuleEingabeInputField(
            ruleType: protoRule.ruleType,
            ruleIndex: ruleIndex,
            eingabeIndex: i,
            key: Key('rule_input:${protoRule.ruleType}:$ruleIndex:$i'),
          ),
      ],
    );
  }
}
