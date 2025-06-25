import 'dart:io';

import 'package:expath_app/logic/rules/_eingabe.dart';
import 'package:expath_app/logic/rules/_rule.dart';
import 'package:expath_app/logic/rules/_rule_type.dart';

class LowerUpperCaseRule extends Rule {
  int caseChoice;

  @override
  List<Eingabe> get eingaben => [
        Eingabe(
            label: 'Groß-/Kleinschreibung',
            valueType: int,
            value: () => caseChoice.toString(),
            setValue: (value) {
              final intValue = int.tryParse(value);
              if (intValue != null && intValue >= 0 && intValue <= 1) {
                caseChoice = intValue;
              } else {
                caseChoice = 0;
              }
            })
      ];

  LowerUpperCaseRule() : caseChoice = 0;

  @override
  String? apply(File file) {
    try {
      if (caseChoice == 0) {
        return file.path.toLowerCase();
      } else if (caseChoice == 1) {
        return file.path.toUpperCase();
      } else {
        return file.path; // No change if caseChoice is not set
      }
    } catch (e) {
      return null;
    }
  }

  @override
  String? applyString(String? string) {
    if (string == null) return null;
    try {
      if (caseChoice == 0) {
        return string.toLowerCase();
      } else if (caseChoice == 1) {
        return string.toUpperCase();
      } else {
        return string; // No change if caseChoice is not set
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': ruleType.type,
      };

  static LowerUpperCaseRule fromJson(Map<String, dynamic> json) {
    return LowerUpperCaseRule();
  }

  @override
  RuleType get ruleType => RuleType.filepath;
}
