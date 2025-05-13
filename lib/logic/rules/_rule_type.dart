import 'package:dj_projektarbeit/logic/rules/_rule.dart';
import 'package:dj_projektarbeit/logic/rules/path_segment_rule.dart';
import 'package:dj_projektarbeit/logic/rules/reverse_path_segment.dart';
import 'package:dj_projektarbeit/logic/rules/simple_regex_rule.dart';

/// -----------------------------
/// RuleType - predefined rules
/// -----------------------------

enum RuleType {
  fileName(
    type: 'fileName',
    label: 'Dateiname extrahieren',
    constructor: SimpleRegexRule.fileName,
    fromJson: SimpleRegexRule.fromJson,
  ),
  parentDirectory(
    type: 'parentDirectory',
    label: 'Ordnerpfad extrahieren',
    constructor: SimpleRegexRule.parentDirectory,
    fromJson: SimpleRegexRule.fromJson,
  ),
  pathSegment(
    type: 'pathSegment',
    label: 'Ordner an Position extrahieren',
    hint: '0 = Partition, 1 = erster Ordner, 2 = zweiter Ordner, ...',
    constructor: PathSegmentRule.new,
    fromJson: PathSegmentRule.fromJson,
  ),
  reversePathSegment(
    label: 'Ordner invertiert extrahieren',
    hint: '0 = Datei, 1 = letzter Ordner, 2 = vorletzter Ordner, ...',
    type: 'reversePathSegment',
    constructor: ReversePathSegmentRule.new,
    fromJson: ReversePathSegmentRule.fromJson,
  ),
  regEx(
    label: 'Benutzerdefinierter Regex',
    type: 'regEx',
    constructor: SimpleRegexRule.new,
    fromJson: SimpleRegexRule.fromJson,
  );

  const RuleType({
    required this.type,
    required this.label,
    required this.constructor,
    required this.fromJson,
    this.hint,
  });

  final String type;
  final String label;
  final String? hint;
  final Rule Function() constructor;
  final Rule Function(Map<String, dynamic>) fromJson;

  static RuleType fromType(String type) {
    return RuleType.values.firstWhere(
      (ruleType) => ruleType.type == type,
      orElse: () => throw Exception('Unbekannter Regeltyp: $type'),
    );
  }
}
