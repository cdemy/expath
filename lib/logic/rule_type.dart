/// -----------------------------
/// RuleType - predefined rules
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
  pathSegment(
    label: 'Ordner an Position extrahieren (0 = Partition, 1 = erster Ordner, 2 = zweiter Ordner, ...)',
    eingaben: [
      Eingabe(label: 'Position', valueType: 'int'),
      Eingabe(label: 'Excel Spalte', valueType: 'String'),
      Eingabe(label: 'Regelname', valueType: 'String'),
    ],
  ),
  reversePathSegment(
    label: 'Ordner invertiert extrahieren (-1 = Datei, -2 = letzter Ordner, -3 = vorletzter Ordner, ...)',
    eingaben: [
      Eingabe(label: 'Rückwärts-Index', valueType: 'int'),
      Eingabe(label: 'Excel Spalte', valueType: 'String'),
      Eingabe(label: 'Regelname', valueType: 'String'),
    ],
  ),
  regEx(
    label: 'Benutzerdefinierter Regex',
    eingaben: [
      Eingabe(label: 'Regex', valueType: 'String'),
      Eingabe(label: 'Excel Spalte', valueType: 'String'),
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
/// Eingabe - User input for rules
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
/// Eingabewert - User input value
/// -----------------------------

class Eingabewert {
  final String value;

  Eingabewert(this.value);
}
