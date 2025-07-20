part of '_rule.dart';

class SubstringRule extends Rule {
  int von;
  int bis;

  SubstringRule._({
    required this.von,
    required this.bis,
  }) : super(RuleType.substring);

  SubstringRule()
      : von = RuleType.substring.eingabeBlueprints[0].defaultValue as int,
        bis = RuleType.substring.eingabeBlueprints[1].defaultValue as int,
        super(RuleType.substring);

  @override
  String? apply(File input) => applyString(input.path.split('/').last);

  @override
  String? applyString(String? string) {
    if (string == null || string.length < von) return null;
    var start = von - 1;
    var end = bis;
    if (start < 0) start = 0;
    if (end < start) end = start + 1;
    if (end > string.length) end = string.length;
    if (string.length < bis) return string.substring(start);
    return string.substring(start, end);
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': ruleType.type,
        'von': von,
        'bis': bis,
      };

  static SubstringRule fromJson(Map<String, dynamic> json) {
    return SubstringRule._(
      von: json['von'],
      bis: json['bis'],
    );
  }
}
