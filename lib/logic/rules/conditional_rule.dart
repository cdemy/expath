import 'dart:io';

import 'package:dj_projektarbeit/logic/rules/_eingabe.dart';
import 'package:dj_projektarbeit/logic/rules/_rule.dart';

class ConditionalRule extends Rule {
  String keyword;
  String valueIfMatch;
  String valueIfNoMatch;
  @override
  final String type;
  @override
  String excelField;

  ConditionalRule.empty()
      : keyword = '',
        valueIfMatch = '',
        valueIfNoMatch = '',
        type = 'conditional',
        excelField = 'Conditional';

  ConditionalRule({
    required this.keyword,
    required this.valueIfMatch,
    required this.valueIfNoMatch,
    this.type = 'conditional',
    this.excelField = 'Conditional',
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
  String apply(File file) {
    final path = file.path;
    return path.contains(keyword) ? valueIfMatch : valueIfNoMatch;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'conditional',
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
}
