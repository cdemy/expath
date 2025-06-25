import 'dart:io';

import 'package:expath_app/logic/rules/_eingabe.dart';
import 'package:expath_app/logic/rules/_rule.dart';
import 'package:expath_app/logic/rules/_rule_type.dart';

class ConditionalRule extends Rule {
  String keyword;
  String valueIfMatch;
  String valueIfNoMatch;

  ConditionalRule.empty()
      : keyword = '',
        valueIfMatch = '',
        valueIfNoMatch = '';

  ConditionalRule({
    required this.keyword,
    required this.valueIfMatch,
    required this.valueIfNoMatch,
  });

  @override
  List<Eingabe> get eingaben => [
        Eingabe(
          label: 'Keyword',
          valueType: String,
          value: () => keyword,
          setValue: (value) {
            keyword = value;
          },
        ),
        Eingabe(
          label: 'Value if match',
          valueType: String,
          value: () => valueIfMatch,
          setValue: (value) {
            valueIfMatch = value;
          },
        ),
        Eingabe(
          label: 'Value if no match',
          valueType: String,
          value: () => valueIfNoMatch,
          setValue: (value) {
            valueIfNoMatch = value;
          },
        ),
      ];

  @override
  String? apply(File file) {
    final path = file.path;
    return applyString(path);
  }

  @override
  String? applyString(String? string) {
    if (string == null) return null;
    return string.contains(keyword) ? valueIfMatch : valueIfNoMatch;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': ruleType.type,
      'keyword': keyword,
      'valueIfMatch': valueIfMatch,
      'valueIfNoMatch': valueIfNoMatch,
    };
  }

  static ConditionalRule fromJson(Map<String, dynamic> json) {
    return ConditionalRule(
      keyword: json['keyword'] as String,
      valueIfMatch: json['valueIfMatch'] as String,
      valueIfNoMatch: json['valueIfNoMatch'] as String,
    );
  }

  @override
  RuleType get ruleType => RuleType.conditional;
}
