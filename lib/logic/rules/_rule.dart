import 'dart:io';

import 'package:expath_app/logic/rules/_eingabe.dart';
import 'package:expath_app/logic/rules/_rule_type.dart';
import 'package:expath_app/logic/rules/concatenation_rule.dart';
import 'package:expath_app/logic/rules/file_path_rule.dart';
import 'package:expath_app/logic/rules/file_type_rule.dart';
import 'package:expath_app/logic/rules/lower_upper_case_rule.dart';
import 'package:expath_app/logic/rules/simple_regex_rule.dart';
import 'package:expath_app/logic/rules/path_segment_rule.dart';
import 'package:expath_app/logic/rules/reverse_path_segment.dart';
import 'package:expath_app/logic/rules/file_size_rule.dart';
import 'package:expath_app/logic/rules/created_at_rule.dart';
import 'package:expath_app/logic/rules/conditional_rule.dart';

/// -----------------------------
/// Abstract Rule
/// -----------------------------

abstract class Rule {
  // Rule? stackedRule;
  // String get excelField;
  // set excelField(String value);
  String? apply(File input);
  String? applyString(String? string);

  Map<String, dynamic> toJson();
  RuleType get ruleType;

  List<Eingabe> get eingaben;

  static Rule fromJson(Map<String, dynamic> json) {
    final ruleType = RuleType.fromType(json['type']);
    switch (ruleType) {
      case RuleType.concatenation:
        return ConcatenationRule.fromJson(json);
      case RuleType.fileName:
        return SimpleRegexRule.fromJson(json);
      case RuleType.parentDirectory:
        return SimpleRegexRule.fromJson(json);
      case RuleType.pathSegment:
        return PathSegmentRule.fromJson(json);
      case RuleType.reversePathSegment:
        return ReversePathSegmentRule.fromJson(json);
      case RuleType.regEx:
        return SimpleRegexRule.fromJson(json);
      case RuleType.filesize:
        return FileSizeRule.fromJson(json);
      case RuleType.createdAt:
        return CreatedAtRule.fromJson(json);
      case RuleType.conditional:
        return ConditionalRule.fromJson(json);
      case RuleType.filetype:
        return FileTypeRule.fromJson(json);
      case RuleType.filepath:
        return FilePathRule.fromJson(json);
      case RuleType.lowerUpperCase:
        return LowerUpperCaseRule.fromJson(json);
    }
  }
}

// class RuleStack {
//   List<Rule> rules;
//   // String get type;
//   String? excelField;

//   RuleStack({
//     this.rules = const [],
//     this.excelField,
//   });

//   String? apply(File input) {
//     if (rules.isEmpty) return null;
//     var result = rules.first.apply(input);
//     for (var i = 1; i < rules.length; i++) {
//       result = rules[i].applyString(result);
//     }
//     return result;
//   }

//   Map<String, dynamic> toJson() => {'rules': rules.map((r) => r.toJson()), 'excelField': excelField};

//   static RuleStack fromJson(Map<String, dynamic> json) => RuleStack(
//         excelField: json['excelField'],
//         rules: (json['rules'] as List).map((e) => Rule.fromJson(Map<String, dynamic>.from(e))).toList(),
//       );
// }
