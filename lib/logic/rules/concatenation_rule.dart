import 'dart:io';

import 'package:dj_projektarbeit/logic/rules/_eingabe.dart';
import 'package:dj_projektarbeit/logic/rules/_rule.dart';
import 'package:dj_projektarbeit/logic/rules/_rule_type.dart';
import 'package:dj_projektarbeit/logic/rules/reverse_path_segment.dart';

class ConcatenationRule implements Rule {
  String? before;
  String? after;

  @override
  List<Eingabe> get eingaben => [
        Eingabe(
          label: 'Davor',
          valueType: String,
          value: () => before ?? '',
          setValue: (value) {
            before = value;
          },
          hint: 'Beliebige Zeichenkette',
        ),
        Eingabe(
          label: 'Danach',
          valueType: String,
          value: () => after ?? '',
          setValue: (value) {
            after = value;
          },
          hint: 'Beliebige Zeichenkette',
        ),
      ];

  @override
  String? apply(File input) {
    final string = ReversePathSegmentRule().apply(input);
    return applyString(string);
  }

  @override
  String? applyString(String? string) {
    if (string == null) return null;
    return (before ?? '') + string + (after ?? '');
  }

  @override
  RuleType get ruleType => RuleType.concatenation;

  @override
  Map<String, dynamic> toJson() => {
        'type': ruleType.type,
        'before': before,
        'after': after,
      };

  static ConcatenationRule fromJson(Map<String, dynamic> json) {
    return ConcatenationRule._(
      before: json['before'],
      after: json['after'],
    );
  }

  ConcatenationRule();

  ConcatenationRule._({
    required this.before,
    required this.after,
  });
}
