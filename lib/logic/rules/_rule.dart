import 'package:dj_projektarbeit/logic/rules/_eingabe.dart';
import 'package:dj_projektarbeit/logic/rules/_rule_type.dart';

/// -----------------------------
/// Abstract Rule
/// -----------------------------

abstract class Rule {
  String get type;
  String get excelField;
  set excelField(String value);
  String? apply(String input);
  Map<String, dynamic> toJson();

  RuleType get ruleType => RuleType.fromType(type);
  List<Eingabe> get eingaben;
}

/// -----------------------------
/// RuleFactory
/// -----------------------------

// class RuleFactory {
  // static Rule fromEingaben(RuleType type, List<Eingabewert> eingaben) {
  //   switch (type) {
  //     case RuleType.fileName:
  //       return SimpleRegexRule(
  //         type: type,
  //         name: type.label,
  //         excelField: type.defaultExcelField!,
  //         regex: type.defaultRegex!,
  //       );
  //     case RuleType.parentDirectory:
  //       return SimpleRegexRule(
  //         type: type,
  //         name: type.label,
  //         excelField: type.defaultExcelField!,
  //         regex: type.defaultRegex!,
  //       );
  //     case RuleType.pathSegment:
  //       final index = int.parse(eingaben[0].value);
  //       return PathSegmentRule(
  //         // name: 'Ordner an Position $index extrahieren',
  //         name: eingaben[2].value,
  //         excelField: eingaben[1].value,
  //         index: index,
  //       );
  //     case RuleType.reversePathSegment:
  //       return ReversePathSegmentRule(
  //         // name: 'Ordner von hinten auswählen',
  //         name: eingaben[2].value,
  //         excelField: eingaben[1].value,
  //         reverseIndex: int.parse(eingaben[0].value),
  //       );
  //     case RuleType.regEx:
  //       return SimpleRegexRule(
  //         type: type,
  //         name: eingaben[2].value,
  //         excelField: eingaben[1].value,
  //         regex: eingaben[0].value,
  //       );
  //   }
  // }

//   static Rule fromJson(Map<String, dynamic> json) {
//     final type = json['type'] as String;
//     final ruleType = RuleType.values.firstWhere(
//       (rt) => rt.type == type,
//       orElse: () => throw Exception('Unbekannter Regeltyp: $type'),
//     );

//     return ruleType.fromJson(json);
//   }
// }
