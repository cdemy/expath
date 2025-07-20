class ProtoEingabeBlueprint {
  final String label;
  final String helperText;
  final String field;
  final Type valueType;
  final String defaultValue;

  const ProtoEingabeBlueprint({
    required this.label,
    required this.helperText,
    required this.field,
    required this.valueType,
    required this.defaultValue,
  });
}
