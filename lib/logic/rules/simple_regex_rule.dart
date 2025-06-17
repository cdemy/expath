import 'dart:io';

import 'package:dj_projektarbeit/logic/rules/_eingabe.dart';
import 'package:dj_projektarbeit/logic/rules/_rule.dart';
import 'package:dj_projektarbeit/logic/rules/_rule_type.dart';

class SimpleRegexRule extends Rule {
  @override
  final RuleType ruleType;

  String regex;

  SimpleRegexRule()
      : ruleType = RuleType.regEx,
        regex = '';

  SimpleRegexRule.fileName()
      : ruleType = RuleType.fileName,
        regex = r'[^\\/]+$';

  SimpleRegexRule.parentDirectory()
      : ruleType = RuleType.parentDirectory,
        regex = r'^.*(?=\\[^\\]+$)';

  SimpleRegexRule._({
    required this.ruleType,
    required this.regex,
  });

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

  @override
  List<Eingabe> get eingaben => [
        Eingabe(
          label: 'Regex',
          valueType: String,
          value: () => regex,
          setValue: (value) {
            regex = value;
          },
        ),
      ];
}
