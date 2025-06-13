import 'dart:io';

import 'package:dj_projektarbeit/logic/rules/_rule.dart';

class RuleStack {
  List<Rule> rules;
  // String get type;
  String? excelField;

  RuleStack({
    this.rules = const [],
    this.excelField,
  });

  String? apply(File input) {
    if (rules.isEmpty) return null;
    var result = rules.first.apply(input);
    for (var i = 1; i < rules.length; i++) {
      result = rules[i].applyString(result);
    }
    return result;
  }

  Map<String, dynamic> toJson() => {'rules': rules.map((r) => r.toJson()), 'excelField': excelField};

  static RuleStack fromJson(Map<String, dynamic> json) => RuleStack(
        excelField: json['excelField'],
        rules: (json['rules'] as List).map((e) => Rule.fromJson(Map<String, dynamic>.from(e))).toList(),
      );
}
