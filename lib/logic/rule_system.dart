enum RuleType {
  regEx(
    label: 'Regex-Ausdruck',
    eingaben: [Eingabe(label: 'Regex', valueType: 'String')],
  ),
  subString(
    label: 'String-Abschnitt',
    eingaben: [
      Eingabe(label: 'Start-Index', valueType: 'int'),
      Eingabe(label: 'End-Index', valueType: 'int'),
    ],
  );

  const RuleType({
    required this.label,
    required this.eingaben,
  });

  final String label;
  final List<Eingabe> eingaben;
}

class Eingabe {
  final String label;
  final String valueType;

  const Eingabe({
    required this.label,
    required this.valueType,
  });
}

class Eingabewert {
  final String value;

  Eingabewert(this.value);
}

// -----------------------------
// Regel-System
// -----------------------------

abstract class Rule {
  RuleType get type;
  String description();
}

class RegExRule implements Rule {
  final String regexPattern;

  RegExRule(this.regexPattern);

  @override
  RuleType get type => RuleType.regEx;

  @override
  String description() => 'RegEx: $regexPattern';
}

class SubStringRule implements Rule {
  final int startIndex;
  final int endIndex;

  SubStringRule(this.startIndex, this.endIndex);

  @override
  RuleType get type => RuleType.subString;

  @override
  String description() => 'Substring zwischen /$startIndex und /$endIndex';
}

// -----------------------------
// Factory-Helper
// -----------------------------

class RuleFactory {
  static Rule fromEingaben(RuleType type, List<Eingabewert> eingaben) {
    switch (type) {
      case RuleType.regEx:
        return RegExRule(eingaben[0].value);
      case RuleType.subString:
        return SubStringRule(
          int.parse(eingaben[0].value),
          int.parse(eingaben[1].value),
        );
    }
  }
}
