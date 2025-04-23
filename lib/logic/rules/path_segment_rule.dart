import 'dart:io';

import 'package:dj_projektarbeit/logic/rules/_eingabe.dart';
import 'package:dj_projektarbeit/logic/rules/_rule.dart';

class PathSegmentRule extends Rule {
  @override
  final String type;
  @override
  String excelField;
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
    required this.type,
    required this.excelField,
    required this.index,
  });

  PathSegmentRule()
      : type = 'pathSegment',
        excelField = 'Ordner',
        index = 0;

  @override
  String? apply(String input) {
    final parts = input.split(Platform.pathSeparator);
    if (index < 0 || index >= parts.length) return null;
    return parts[index];
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'excelField': excelField,
        'index': index,
      };

  static PathSegmentRule fromJson(Map<String, dynamic> json) {
    return PathSegmentRule._(
      type: json['type'],
      excelField: json['excelField'],
      index: json['index'],
    );
  }
}
