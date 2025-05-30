import 'dart:convert';
import 'dart:io';

import 'package:dj_projektarbeit/logic/rules/_rule.dart';

abstract class SaveLoad {
  static Future<void> saveRuleStacksToJson(List<RuleStack> ruleStacks, String filePath) async {
    final jsonList = ruleStacks.map((r) => r.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    final file = File(filePath);
    await file.writeAsString(jsonString);
  }

  static Future<List<RuleStack>> loadRuleStacksFromJson(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) return [];
    final jsonString = await file.readAsString();
    // final List<Map<String, dynamic>> jsonList = jsonDecode(jsonString) as List<Map<String, dynamic>>;
    final jsonRawList = jsonDecode(jsonString) as List<dynamic>;
    final jsonList = jsonRawList.cast<Map<String, dynamic>>();
    return jsonList.map((e) => RuleStack.fromJson(e)).toList();
  }
}
