import 'dart:io';

import 'package:dj_projektarbeit/logic/rules/_eingabe.dart';
import 'package:dj_projektarbeit/logic/rules/_rule.dart';

class CreatedAtRule extends Rule {
  @override
  final String type = 'createdAt';

  @override
  String excelField;

  CreatedAtRule({this.excelField = 'Erstellungsdatum'});

  @override
  List<Eingabe> get eingaben => [];

  @override
  String? apply(File file) {
    try {
      return file.lastModifiedSync().toString();
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'excelField': excelField,
      };

  static CreatedAtRule fromJson(Map<String, dynamic> json) {
    return CreatedAtRule(
      excelField: json['excelField'],
    );
  }
}
