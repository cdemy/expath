class ProtoEingabe {
  final String label;
  final String eingabe;
  final Type valueType;

  ProtoEingabe({
    required this.label,
    required this.eingabe,
    required this.valueType,
  });

  ProtoEingabe copyWith({
    String? label,
    String? eingabe,
    Type? valueType,
  }) {
    return ProtoEingabe(
      label: label ?? this.label,
      eingabe: eingabe ?? this.eingabe,
      valueType: valueType ?? this.valueType,
    );
  }
}
