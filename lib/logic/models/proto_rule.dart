import 'package:expath_app/logic/models/proto_eingabe.dart';
import 'package:expath_app/logic/rules/_rule.dart';
import 'package:expath_app/logic/rules/_rule_type.dart';

class ProtoRule {
  RuleType ruleType;
  List<ProtoEingabe> protoEingaben;

  ProtoRule({
    required this.ruleType,
    required this.protoEingaben,
  });

  factory ProtoRule.fromRule(Rule rule) {
    final protoEingaben = <ProtoEingabe>[];
    for (final eingabeBlueprint in rule.ruleType.eingabeBlueprints) {
      protoEingaben.add(ProtoEingabe(
        label: eingabeBlueprint.label,
        eingabe: rule.toJson()[eingabeBlueprint.field]?.toString() ?? eingabeBlueprint.defaultValue,
        valueType: eingabeBlueprint.valueType,
      ));
    }
    return ProtoRule(
      ruleType: rule.ruleType,
      protoEingaben: protoEingaben,
    );
  }

  factory ProtoRule.empty() {
    final type = RuleType.values.where((v) => !v.onlyFirstPosition).first;
    final rule = type.constructor();
    return ProtoRule.fromRule(rule);
  }

  Rule toRule() {
    final json = {'type': ruleType.type};
    for (int i = 0; i < protoEingaben.length; i++) {
      json[ruleType.eingabeBlueprints[i].field] = protoEingaben[i].eingabe;
    }
    final rule = Rule.fromJson(json);
    return rule;
  }

  ProtoRule copyWith({required List<ProtoEingabe>? protoEingaben}) => ProtoRule(
        ruleType: ruleType,
        protoEingaben: protoEingaben ?? this.protoEingaben,
      );
}
