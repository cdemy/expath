import 'dart:io';

import 'package:dj_projektarbeit/logic/rules/_eingabe.dart';
import 'package:dj_projektarbeit/logic/rules/_rule.dart';

class MetadataRule extends Rule {
  @override
  final String type;

  @override
  String excelField;

  @override
  List<Eingabe> get eingaben => [
        Eingabe(
          label: 'Metadatenfeld',
          valueType: String,
          value: () => type,
          setValue: (value) {
            // No setter needed for metadata field
          },
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
    final metadata = input.statSync().size;
    final sizeAsString = metadata.toString();
    return sizeAsString;
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'excelField': excelField,
      };

  static MetadataRule fromJson(Map<String, dynamic> json) {
    return MetadataRule._(
      type: json['type'],
      excelField: json['excelField'],
    );
  }
}
