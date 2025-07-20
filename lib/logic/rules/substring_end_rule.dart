part of '_rule.dart';

class SubstringEndRule extends Rule {
  int chars;

  SubstringEndRule._({
    required this.chars,
  }) : super(RuleType.substringEnd);

  SubstringEndRule()
      : chars = RuleType.substring.eingabeBlueprints[0].defaultValue as int,
        super(RuleType.substringEnd);

  @override
  String? apply(File input) => applyString(input.path.split('/').last);

  @override
  String? applyString(String? string) {
    if (string == null || string.isEmpty) return null;
    if (chars < 1) return null;
    if (chars > string.length) chars = string.length;
    return string.substring(string.length - chars);
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': ruleType,
        'chars': chars,
      };

  static SubstringEndRule fromJson(Map<String, dynamic> json) {
    return SubstringEndRule._(
      chars: json['chars'] as int,
    );
  }
}
