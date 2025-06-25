import 'dart:io';

import 'package:expath_app/logic/rules/_eingabe.dart';
import 'package:expath_app/logic/rules/_rule.dart';
import 'package:expath_app/logic/rules/_rule_type.dart';

class PathSegmentRule extends Rule {
  int index;

  @override
  List<Eingabe> get eingaben => [
        Eingabe(
          label: 'Position',
          valueType: int,
          value: () => index.toString(),
          setValue: (value) {
            final intValue = int.tryParse(value);
            if (intValue != null) {
              index = intValue;
            }
          },
        ),
      ];

  PathSegmentRule._({
    required this.index,
  });

  PathSegmentRule() : index = 0;

  @override
  String? apply(File input) {
    final path = input.path;
    final parts = path.split(Platform.pathSeparator);
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
        'index': index,
      };

  static PathSegmentRule fromJson(Map<String, dynamic> json) {
    return PathSegmentRule._(
      index: json['index'],
    );
  }

  @override
  RuleType get ruleType => RuleType.pathSegment;
}
