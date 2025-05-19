import 'dart:io';

import 'package:dj_projektarbeit/logic/rules/_eingabe.dart';
import 'package:dj_projektarbeit/logic/rules/_rule.dart';

class FileSizeRule extends Rule {
  @override
  final String type = 'fileSize';

  @override
  String excelField;

  FileSizeRule({this.excelField = 'Dateigröße (Bytes)'});

  @override
  List<Eingabe> get eingaben => [];

  @override
  String? apply(File file) {
    try {
      return file.lengthSync().toString();
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'excelField': excelField,
      };

  static FileSizeRule fromJson(Map<String, dynamic> json) {
    return FileSizeRule(
      excelField: json['excelField'],
    );
  }
}
