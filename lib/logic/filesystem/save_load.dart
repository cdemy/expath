import 'dart:convert';
import 'dart:io';

import 'package:dj_projektarbeit/logic/rules/_rule.dart';
import 'package:dj_projektarbeit/logic/rules/_rule_type.dart';

abstract class SaveLoad {
  static Future<void> saveRulesToJson(List<Rule> rules, String filePath) async {
    final jsonList = rules.map((r) => r.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    final file = File(filePath);
    await file.writeAsString(jsonString);
  }

  static Future<List<Rule>> loadRulesFromJson(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) return [];
    final jsonString = await file.readAsString();
    final List<Map<String, dynamic>> jsonList = jsonDecode(jsonString) as List<Map<String, dynamic>>;
    return jsonList.map((e) {
      final type = e['type'] as String;
      final ruleType = RuleType.fromType(type);
      return ruleType.fromJson(e);
    }).toList();
  }
}
