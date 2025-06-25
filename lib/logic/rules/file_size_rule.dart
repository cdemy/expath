import 'dart:io';

import 'package:expath_app/logic/rules/_eingabe.dart';
import 'package:expath_app/logic/rules/_rule.dart';
import 'package:expath_app/logic/rules/_rule_type.dart';

class FileSizeRule extends Rule {
  FileSizeRule();

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
  String? applyString(String? string) {
    throw Exception('Cannot be applied to a String');
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': ruleType.type,
      };

  static FileSizeRule fromJson(Map<String, dynamic> json) {
    return FileSizeRule();
  }

  @override
  RuleType get ruleType => RuleType.filesize;
}
