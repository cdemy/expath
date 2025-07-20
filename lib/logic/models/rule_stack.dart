import 'dart:io';

import 'package:expath_app/logic/rules/_rule.dart';

class RuleStack {
  List<Rule> rules;
  String excelField;

  RuleStack({
    this.rules = const [],
    this.excelField = '',
  }) : assert(excelField.isNotEmpty, 'Excel field cannot be empty');

  String? apply(File input) {
    if (rules.isEmpty) return null;
    try {
      var result = rules.first.apply(input);
      for (var i = 1; i < rules.length; i++) {
        result = rules[i].applyString(result);
      }
      return result;
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toJson() => {'rules': rules.map((r) => r.toJson()), 'excelField': excelField};

  static RuleStack fromJson(Map<String, dynamic> json) => RuleStack(
        excelField: json['excelField'],
        rules: (json['rules'] as List).map((e) => Rule.fromJson(Map<String, dynamic>.from(e))).toList(),
      );
}
