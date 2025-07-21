import 'dart:io';

import 'package:expath_app/logic/rules/_rule_type.dart';
import 'package:intl/intl.dart';

part 'concatenation_rule.dart';
part 'conditional_rule.dart';
part 'conditional_replacement_rule.dart';
part 'modified_at_rule.dart';
part 'file_path_rule.dart';
part 'file_size_rule.dart';
part 'file_type_rule.dart';
part 'lower_case_rule.dart';
part 'path_segment_rule.dart';
part 'reverse_path_segment.dart';
part 'substring_rule.dart';
part 'substring_start_rule.dart';
part 'substring_end_rule.dart';
part 'simple_regex_rule.dart';
part 'upper_case_rule.dart';

/// -----------------------------
/// Abstract Rule
/// -----------------------------

sealed class Rule {
  String? apply(File input);
  String? applyString(String? string);

  Map<String, dynamic> toJson();
  final RuleType ruleType;

  const Rule(this.ruleType);

  static Rule fromJson(Map<String, dynamic> json) {
    final ruleType = RuleType.fromType(json['type']);
    switch (ruleType) {
      case RuleType.concatenation:
        return ConcatenationRule.fromJson(json);
      case RuleType.fileName:
        return SimpleRegexRule.fileName();
      case RuleType.parentDirectory:
        return SimpleRegexRule.parentDirectory();
      case RuleType.pathSegment:
        return PathSegmentRule.fromJson(json);
      case RuleType.reversePathSegment:
        return ReversePathSegmentRule.fromJson(json);
      case RuleType.regEx:
        return SimpleRegexRule.fromJson(json);
      case RuleType.filesize:
        return FileSizeRule.fromJson(json);
      case RuleType.modifiedAt:
        return ModifiedAtRule.fromJson(json);
      case RuleType.conditional:
        return ConditionalRule.fromJson(json);
      case RuleType.conditionalReplacement:
        return ConditionalReplacementRule.fromJson(json);
      case RuleType.filetype:
        return FileTypeRule.fromJson(json);
      case RuleType.filepath:
        return FilePathRule.fromJson(json);
      case RuleType.lowerCase:
        return LowerCaseRule.fromJson(json);
      case RuleType.upperCase:
        return UpperCaseRule.fromJson(json);
      case RuleType.substring:
        return SubstringRule.fromJson(json);
      case RuleType.substringStart:
        return SubstringStartRule.fromJson(json);
      case RuleType.substringEnd:
        return SubstringEndRule.fromJson(json);
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
