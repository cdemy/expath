// rule_system.dart

/// -----------------------------
/// RuleType - vordefinierte Regeltypen
/// -----------------------------

enum RuleType {
  fileName(
    label: 'Dateiname extrahieren',
    eingaben: [], // keine Benutzer-Eingaben nötig
    defaultRegex: r'[^\\/]+$', // alles nach dem letzten / oder \
    defaultExcelField: 'Dateiname',
  ),
  parentDirectory(
    label: 'Ordnerpfad extrahieren',
    eingaben: [], // keine Benutzer-Eingaben nötig
    defaultRegex: r'^.*(?=\\[^\\]+$)', // alles bis zum letzten /
    defaultExcelField: 'Ordnerpfad',
  ),
  regEx(
    label: 'Benutzerdefinierter Regex',
    eingaben: [
      Eingabe(label: 'Regex', valueType: 'String'),
      Eingabe(label: 'Excel-Feldname', valueType: 'String'),
      Eingabe(label: 'Regelname', valueType: 'String'),
    ],
  );

  const RuleType({
    required this.label,
    this.eingaben = const [],
    this.defaultRegex,
    this.defaultExcelField,
  });

  final String label;
  final List<Eingabe> eingaben;
  final String? defaultRegex;
  final String? defaultExcelField;
}

/// -----------------------------
/// Eingabe-Definition (Meta)
/// -----------------------------

class Eingabe {
  final String label;
  final String valueType;

  const Eingabe({
    required this.label,
    required this.valueType,
  });
}

/// -----------------------------
/// Eingabewert (User-Eingabe)
/// -----------------------------

class Eingabewert {
  final String value;

  Eingabewert(this.value);
}

/// -----------------------------
/// Abstrakte Regel
/// -----------------------------

abstract class Rule {
  RuleType get type;
  String get name; // Anzeigename der Regel
  String get excelField; // Excel-Spaltenname
  String get regex; // Regex der Regel
  String description(); // kurze Beschreibung
  String? apply(String input); // Wendet Regel auf einen Dateipfad an
}

/// -----------------------------
/// Konkrete Regel (Regex basierend)
/// -----------------------------

class SimpleRegexRule implements Rule {
  final RuleType type;
  final String name;
  final String excelField;
  final String regex;

  SimpleRegexRule({
    required this.type,
    required this.name,
    required this.excelField,
    required this.regex,
  });

  @override
  String description() => '$name → $excelField = $regex';

  @override
  String? apply(String input) {
    final regExp = RegExp(regex);
    final match = regExp.firstMatch(input);
    return match?.group(0);
  }
}

/// -----------------------------
/// Regel Factory
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
      case RuleType.regEx:
        return SimpleRegexRule(
          type: type,
          name: eingaben[2].value,
          excelField: eingaben[1].value,
          regex: eingaben[0].value,
        );
    }
  }
}
