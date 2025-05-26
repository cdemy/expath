import 'dart:io';

import 'package:dj_projektarbeit/logic/rules/_eingabe.dart';
import 'package:dj_projektarbeit/logic/rules/_rule.dart';
import 'package:intl/intl.dart';

class CreatedAtRule extends Rule {
  @override
  final String type = 'createdAt';

  @override
  String excelField;

  String format;

  CreatedAtRule({
    this.excelField = 'Erstellungsdatum',
    this.format = 'yyyy-MM-dd HH:mm:ss',
  });

  @override
  List<Eingabe> get eingaben => [
        Eingabe(
          label: 'Datumsformat',
          valueType: String,
          value: () => format,
          setValue: (value) {
            format = value;
          },
          hint: 'z.B. dd.MM.yyyy oder yyyyMMdd',
        ),
      ];

  @override
  String? apply(File file) {
    try {
      final date = file.lastModifiedSync();
      return DateFormat(format).format(date);
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'excelField': excelField,
        'format': format,
      };

  static CreatedAtRule fromJson(Map<String, dynamic> json) {
    return CreatedAtRule(
      excelField: json['excelField'],
      format: json['format'] ?? 'yyyy-MM-dd HH:mm:ss',
    );
  }
}
