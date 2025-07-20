part of '_rule.dart';

class SimpleRegexRule extends Rule {
  String regex;

  SimpleRegexRule()
      : regex = '',
        super(RuleType.regEx);

  SimpleRegexRule.fileName()
      : regex = r'[^\\/]+$',
        super(RuleType.fileName);

  SimpleRegexRule.parentDirectory()
      : regex = r'^.*(?=\\[^\\]+$)',
        super(RuleType.parentDirectory);

  SimpleRegexRule._({
    required RuleType ruleType,
    required this.regex,
  }) : super(ruleType);

  @override
  String? apply(File input) {
    final path = input.path;
    return applyString(path);
  }

  @override
  String? applyString(String? string) {
    if (string == null) return null;
    final regExp = RegExp(regex, caseSensitive: false, multiLine: true);
    final match = regExp.firstMatch(string);
    return match?.groupCount == 0 ? match?.group(0) : match?.group(1);
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': ruleType.type,
        'regex': regex,
      };

  static SimpleRegexRule fromJson(Map<String, dynamic> json) {
    return SimpleRegexRule._(
      ruleType: RuleType.fromType(json['type']),
      regex: json['regex'],
    );
  }
}
