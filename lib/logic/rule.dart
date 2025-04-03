import 'package:dj_projektarbeit/logic/rule_type.dart';

/// -----------------------------
/// abstract Rule
/// -----------------------------

abstract class Rule {
  RuleType get type;
  String get name;
  String get excelField;
  String get regex;
  String? apply(String input);
  Map<String, dynamic> toJson();
}

/// -----------------------------
/// concrete Rule
/// -----------------------------

class SimpleRegexRule implements Rule {
  @override
  final RuleType type;

  @override
  final String name;

  @override
  final String excelField;

  @override
  final String regex;

  SimpleRegexRule({
    required this.type,
    required this.name,
    required this.excelField,
    required this.regex,
  });

  @override
  String? apply(String input) {
    final regExp = RegExp(regex, caseSensitive: false, multiLine: true);
    final match = regExp.firstMatch(input);
    return match?.group(0);
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'name': name,
        'excelField': excelField,
        'regex': regex,
      };

  static SimpleRegexRule fromJson(Map<String, dynamic> json) {
    return SimpleRegexRule(
      type: RuleType.values.firstWhere((e) => e.name == json['type']),
      name: json['name'],
      excelField: json['excelField'],
      regex: json['regex'],
    );
  }
}

/// -----------------------------
/// RuleFactory
/// -----------------------------

class RuleFactory {
  static Rule fromEingaben(RuleType type, List<Eingabewert> eingaben) {
    switch (type) {
      case RuleType.fileName:
        return SimpleRegexRule(
          type: type,
          name: type.label,
          excelField: type.defaultExcelField!,
          regex: type.defaultRegex!,
        );
      case RuleType.parentDirectory:
        return SimpleRegexRule(
          type: type,
          name: type.label,
          excelField: type.defaultExcelField!,
          regex: type.defaultRegex!,
        );
      case RuleType.regEx:
        return SimpleRegexRule(
          type: type,
          name: eingaben[2].value,
          excelField: eingaben[1].value,
          regex: eingaben[0].value,
        );
    }
  }

  static Rule fromJson(Map<String, dynamic> json) {
    return SimpleRegexRule.fromJson(json);
  }
}
