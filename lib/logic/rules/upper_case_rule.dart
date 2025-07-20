part of '_rule.dart';

class UpperCaseRule extends Rule {
  const UpperCaseRule() : super(RuleType.upperCase);

  @override
  String? apply(File file) => file.path.toUpperCase();

  @override
  String? applyString(String? string) => (string ?? '').toUpperCase();

  @override
  Map<String, dynamic> toJson() => {
        'type': ruleType.type,
      };

  static UpperCaseRule fromJson(Map<String, dynamic> json) {
    return UpperCaseRule();
  }
}
