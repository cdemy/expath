import 'dart:io';

import 'package:dj_projektarbeit/logic/rules/_eingabe.dart';
import 'package:dj_projektarbeit/logic/rules/_rule.dart';

class ReversePathSegmentRule extends Rule {
  @override
  final String type;
  @override
  String excelField;
  int reverseIndex;

  ReversePathSegmentRule._({
    required this.type,
    required this.excelField,
    required this.reverseIndex,
  });

  ReversePathSegmentRule()
      : type = 'reversePathSegment',
        excelField = 'OrdnerB',
        reverseIndex = 0;

  @override
  String? apply(File input) {
    final path = input.path;
    final parts = path.split(Platform.pathSeparator);
    final index = parts.length - 1 - reverseIndex;
    if (index < 0 || index >= parts.length) return null;
    return parts[index];
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'excelField': excelField,
        'reverseIndex': reverseIndex,
      };

  static ReversePathSegmentRule fromJson(Map<String, dynamic> json) {
    return ReversePathSegmentRule._(
      type: json['type'],
      excelField: json['excelField'],
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
}
