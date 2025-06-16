import 'dart:io';

import 'package:dj_projektarbeit/logic/rules/_eingabe.dart';
import 'package:dj_projektarbeit/logic/rules/_rule.dart';
import 'package:dj_projektarbeit/logic/rules/_rule_type.dart';

class FileTypeRule extends Rule {
  FileTypeRule();

  @override
  List<Eingabe> get eingaben => [];

  @override
  String? apply(File file) {
    try {
      return file.path.split('.').last.toString();
    } catch (e) {
      return null;
    }
  }

  @override
  String? applyString(String? string) {
    throw Exception('Cannot be applied to a String');
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': ruleType.type,
      };

  static FileTypeRule fromJson(Map<String, dynamic> json) {
    return FileTypeRule();
  }

  @override
  RuleType get ruleType => RuleType.filetype;
}
