part of '_rule.dart';

class LowerCaseRule extends Rule {
  LowerCaseRule() : super(RuleType.lowerCase);

  @override
  String? apply(File file) => file.path.toLowerCase();

  @override
  String? applyString(String? string) => (string ?? '').toLowerCase();

  @override
  Map<String, dynamic> toJson() => {
        'type': ruleType.type,
      };

  static LowerCaseRule fromJson(Map<String, dynamic> json) {
    return LowerCaseRule();
  }
}
