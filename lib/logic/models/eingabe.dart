class Eingabe {
  final String label;
  final Type valueType;
  final String Function() value;
  final void Function(String) setValue;
  final String? hint;

  const Eingabe({
    required this.label,
    required this.valueType,
    required this.value,
    required this.setValue,
    this.hint,
  });
}

// /// -----------------------------
// /// Eingabewert - User input value
// /// -----------------------------

// class Eingabewert {
//   final String value;

//   Eingabewert(this.value);
// }
