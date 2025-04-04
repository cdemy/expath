import 'dart:io';

import 'package:dj_projektarbeit/logic/rule_type.dart';

/// -----------------------------
/// Abstract Rule
/// -----------------------------

abstract class Rule {
  RuleType get type;
  String get name;
  String get excelField;
  String get regex;
  String? apply(String input);
  Map<String, dynamic> toJson();
}

/// -----------------------------
/// Concrete Rule
/// -----------------------------

class SimpleRegexRule implements Rule {
  @override
  final RuleType type;

  @override
  final String name;

  @override
  final String excelField;

  @override
  final String regex;

  SimpleRegexRule({
    required this.type,
    required this.name,
    required this.excelField,
    required this.regex,
  });

  @override
  String? apply(String input) {
    final regExp = RegExp(regex, caseSensitive: false, multiLine: true);
    final match = regExp.firstMatch(input);
    return match?.group(0);
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'name': name,
        'excelField': excelField,
        'regex': regex,
      };

  static SimpleRegexRule fromJson(Map<String, dynamic> json) {
    return SimpleRegexRule(
      type: RuleType.values.firstWhere((e) => e.name == json['type']),
      name: json['name'],
      excelField: json['excelField'],
      regex: json['regex'],
    );
  }
}

class PathSegmentRule implements Rule {
  final String name;
  final String excelField;
  final int index;

  PathSegmentRule({required this.name, required this.excelField, required this.index});

  @override
  RuleType get type => RuleType.pathSegment;

  @override
  String get regex => '';

  @override
  String? apply(String input) {
    final parts = input.split(Platform.pathSeparator);
    if (index < 0 || index >= parts.length) return null;
    return parts[index];
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'name': name,
        'excelField': excelField,
        'index': index,
      };

  static PathSegmentRule fromJson(Map<String, dynamic> json) {
    return PathSegmentRule(
      name: json['name'],
      excelField: json['excelField'],
      index: json['index'],
    );
  }
}

class ReversePathSegmentRule implements Rule {
  final String name;
  final String excelField;
  final int reverseIndex;

  ReversePathSegmentRule({
    required this.name,
    required this.excelField,
    required this.reverseIndex,
  });

  @override
  RuleType get type => RuleType.reversePathSegment;

  @override
  String get regex => '';

  @override
  String? apply(String input) {
    final parts = input.split(Platform.pathSeparator);
    final index = parts.length + reverseIndex;
    if (index < 0 || index >= parts.length) return null;
    return parts[index];
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'name': name,
        'excelField': excelField,
        'reverseIndex': reverseIndex,
      };

  static ReversePathSegmentRule fromJson(Map<String, dynamic> json) {
    return ReversePathSegmentRule(
      name: json['name'],
      excelField: json['excelField'],
      reverseIndex: json['reverseIndex'],
    );
  }
}

/// -----------------------------
/// RuleFactory
/// -----------------------------

class RuleFactory {
  static Rule fromEingaben(RuleType type, List<Eingabewert> eingaben) {
    switch (type) {
      case RuleType.fileName:
        return SimpleRegexRule(
          type: type,
          name: type.label,
          excelField: type.defaultExcelField!,
          regex: type.defaultRegex!,
        );
      case RuleType.parentDirectory:
        return SimpleRegexRule(
          type: type,
          name: type.label,
          excelField: type.defaultExcelField!,
          regex: type.defaultRegex!,
        );
      case RuleType.pathSegment:
        final index = int.parse(eingaben[0].value);
        return PathSegmentRule(
          name: 'Ordner an Position $index extrahieren',
          excelField: eingaben[1].value,
          index: index,
        );
      case RuleType.reversePathSegment:
        return ReversePathSegmentRule(
          name: 'Ordner von hinten auswählen',
          excelField: eingaben[1].value,
          reverseIndex: int.parse(eingaben[0].value),
        );
      case RuleType.regEx:
        return SimpleRegexRule(
          type: type,
          name: eingaben[2].value,
          excelField: eingaben[1].value,
          regex: eingaben[0].value,
        );
    }
  }

  static Rule fromJson(Map<String, dynamic> json) {
    final typeName = json['type'] as String;
    final type = RuleType.values.firstWhere(
      (e) => e.name == typeName,
      orElse: () => throw Exception('Unbekannter Regeltyp: $typeName'),
    );

    switch (type) {
      case RuleType.fileName:
      case RuleType.parentDirectory:
      case RuleType.pathSegment:
        return PathSegmentRule.fromJson(json);
      case RuleType.reversePathSegment:
        return ReversePathSegmentRule.fromJson(json);
      case RuleType.regEx:
        return SimpleRegexRule.fromJson(json);
    }
  }
}
