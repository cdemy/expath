import 'dart:io';

import 'package:expath_app/logic/rules/_eingabe.dart';
import 'package:expath_app/logic/rules/_rule.dart';
import 'package:expath_app/logic/rules/_rule_type.dart';
import 'package:intl/intl.dart';

class CreatedAtRule extends Rule {
  String format;

  CreatedAtRule({
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
  String? applyString(String? string) {
    throw Exception('Cannot be applied to a String');
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': ruleType.type,
        'format': format,
      };

  static CreatedAtRule fromJson(Map<String, dynamic> json) {
    return CreatedAtRule(
      format: json['format'] ?? 'yyyy-MM-dd HH:mm:ss',
    );
  }

  @override
  RuleType get ruleType => RuleType.createdAt;
}
