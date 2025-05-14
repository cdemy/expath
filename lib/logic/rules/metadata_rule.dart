import 'dart:io';

import 'package:dj_projektarbeit/logic/rules/_eingabe.dart';
import 'package:dj_projektarbeit/logic/rules/_rule.dart';

class MetadataRule extends Rule {
  String selectedField = 'size';
  @override
  final String type;

  @override
  String excelField;

  @override
  List<Eingabe> get eingaben => [
        Eingabe(
          label: 'Metadatenfeld',
          valueType: String,
          value: () => selectedField,
          setValue: (val) => selectedField = val,
        ),
      ];

  MetadataRule._({
    required this.type,
    required this.excelField,
  });

  MetadataRule()
      : type = 'metadata',
        excelField = 'Metadatenfeld';

  @override
  String? apply(File input) {
    final stat = input.statSync();
    switch (selectedField) {
      case 'size':
        return stat.size.toString();
      case 'lastModified':
        return stat.modified.toString();
      case 'created':
        return stat.changed.toString();
      default:
        return null;
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'excelField': excelField,
        'selectedField': selectedField,
      };

  static MetadataRule fromJson(Map<String, dynamic> json) {
    return MetadataRule._(
      type: json['type'],
      excelField: json['excelField'],
    )..selectedField = json['selectedField'] ?? 'size';
  }
}
