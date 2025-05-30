import 'dart:io';

import 'package:dj_projektarbeit/logic/rules/_eingabe.dart';
import 'package:dj_projektarbeit/logic/rules/_rule.dart';
import 'package:dj_projektarbeit/logic/rules/_rule_type.dart';

class ReversePathSegmentRule extends Rule {
  int reverseIndex;

  ReversePathSegmentRule._({
    required this.reverseIndex,
  });

  ReversePathSegmentRule() : reverseIndex = 0;

  @override
  String? apply(File input) {
    final path = input.path;
    final parts = path.split(Platform.pathSeparator);
    final index = parts.length - 1 - reverseIndex;
    if (index < 0 || index >= parts.length) return null;
    return parts[index];
  }

  @override
  String? applyString(String? string) {
    throw Exception('Cannot be applied to a String');
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': ruleType.type,
        'reverseIndex': reverseIndex,
      };

  static ReversePathSegmentRule fromJson(Map<String, dynamic> json) {
    return ReversePathSegmentRule._(
      reverseIndex: json['reverseIndex'],
    );
  }

  @override
  List<Eingabe> get eingaben => [
        Eingabe(
          label: 'Rückwärts-Index',
          valueType: int,
          value: () => reverseIndex.toString(),
          setValue: (value) {
            final intValue = int.tryParse(value);
            if (intValue != null) {
              reverseIndex = intValue;
            }
          },
        ),
      ];

  @override
  RuleType get ruleType => RuleType.reversePathSegment;
}
