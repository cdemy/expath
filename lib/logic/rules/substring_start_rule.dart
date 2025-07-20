part of '_rule.dart';

class SubstringStartRule extends Rule {
  int chars;

  SubstringStartRule._({
    required this.chars,
  }) : super(RuleType.substringStart);

  SubstringStartRule()
      : chars = RuleType.substring.eingabeBlueprints[0].defaultValue as int,
        super(RuleType.substringStart);

  @override
  String? apply(File input) => applyString(input.path.split('/').last);

  @override
  String? applyString(String? string) {
    if (string == null || string.isEmpty) return null;
    if (chars < 1) return null;
    if (chars > string.length) chars = string.length;
    return string.substring(0, chars);
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': ruleType,
        'chars': chars,
      };

  static SubstringStartRule fromJson(Map<String, dynamic> json) {
    return SubstringStartRule._(
      chars: json['chars'] as int,
    );
  }
}
