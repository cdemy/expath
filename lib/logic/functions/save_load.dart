import 'dart:convert';
import 'dart:io';

import 'package:dj_projektarbeit/logic/rule.dart';

Future<void> saveRulesToJson(List<Rule> rules, String filePath) async {
  final jsonList = rules.map((r) => r.toJson()).toList();
  final jsonString = jsonEncode(jsonList);
  final file = File(filePath);
  await file.writeAsString(jsonString);
}

Future<List<Rule>> loadRulesFromJson(String filePath) async {
  final file = File(filePath);
  if (!file.existsSync()) return [];
  final jsonString = await file.readAsString();
  final List<dynamic> jsonList = jsonDecode(jsonString);
  return jsonList.map((e) => RuleFactory.fromJson(e)).toList();
}
