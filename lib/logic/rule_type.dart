/// -----------------------------
/// RuleType - vordefinierte Regeltypen
/// -----------------------------

enum RuleType {
  fileName(
    label: 'Dateiname extrahieren',
    eingaben: [],
    defaultRegex: r'[^\\/]+$',
    defaultExcelField: 'Dateiname',
  ),
  parentDirectory(
    label: 'Ordnerpfad extrahieren',
    eingaben: [],
    defaultRegex: r'^.*(?=\\[^\\]+$)',
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
