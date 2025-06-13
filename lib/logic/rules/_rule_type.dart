import 'package:dj_projektarbeit/logic/rules/_rule.dart';
import 'package:dj_projektarbeit/logic/rules/concatenation_rule.dart';
import 'package:dj_projektarbeit/logic/rules/conditional_rule.dart';
import 'package:dj_projektarbeit/logic/rules/created_at_rule.dart';
import 'package:dj_projektarbeit/logic/rules/file_path_rule.dart';
import 'package:dj_projektarbeit/logic/rules/file_size_rule.dart';
import 'package:dj_projektarbeit/logic/rules/file_type_rule.dart';
import 'package:dj_projektarbeit/logic/rules/path_segment_rule.dart';
import 'package:dj_projektarbeit/logic/rules/reverse_path_segment.dart';
import 'package:dj_projektarbeit/logic/rules/simple_regex_rule.dart';

/// -----------------------------
/// RuleType - predefined rules
/// -----------------------------

enum RuleType {
  regEx(
    label: 'Benutzerdefinierter Regex',
    type: 'regEx',
    constructor: SimpleRegexRule.new,
    fromJson: SimpleRegexRule.fromJson,
    onlyFirstPosition: false,
  ),
  concatenation(
    type: 'concatenation',
    label: 'Verketten',
    constructor: ConcatenationRule.new,
    fromJson: ConcatenationRule.fromJson,
    onlyFirstPosition: false,
  ),
  conditional(
    label: 'Fallunterscheidung',
    type: 'conditional',
    constructor: ConditionalRule.empty,
    fromJson: ConditionalRule.fromJson,
    onlyFirstPosition: false,
  ),
  fileName(
    type: 'fileName',
    label: 'Dateiname extrahieren',
    constructor: SimpleRegexRule.fileName,
    fromJson: SimpleRegexRule.fromJson,
    onlyFirstPosition: true,
  ),
  parentDirectory(
    type: 'parentDirectory',
    label: 'Ordnerpfad extrahieren',
    constructor: SimpleRegexRule.parentDirectory,
    fromJson: SimpleRegexRule.fromJson,
    onlyFirstPosition: true,
  ),
  pathSegment(
    type: 'pathSegment',
    label: 'Ordner an Position extrahieren',
    hint: '0 = Partition, 1 = erster Ordner, 2 = zweiter Ordner, ...',
    constructor: PathSegmentRule.new,
    fromJson: PathSegmentRule.fromJson,
    onlyFirstPosition: true,
  ),
  reversePathSegment(
    label: 'Ordner invertiert extrahieren',
    hint: '0 = Datei, 1 = letzter Ordner, 2 = vorletzter Ordner, ...',
    type: 'reversePathSegment',
    constructor: ReversePathSegmentRule.new,
    fromJson: ReversePathSegmentRule.fromJson,
    onlyFirstPosition: true,
  ),
  filesize(
    label: 'Dateigröße',
    type: 'fileSize',
    constructor: FileSizeRule.new,
    fromJson: FileSizeRule.fromJson,
    onlyFirstPosition: true,
  ),
  createdAt(
    label: 'Erstellungsdatum',
    type: 'createdAt',
    constructor: CreatedAtRule.new,
    fromJson: CreatedAtRule.fromJson,
    onlyFirstPosition: true,
  ),
  filepath(
    label: 'Dateipfad',
    type: 'filepath',
    constructor: FilePathRule.new,
    fromJson: FilePathRule.fromJson,
    onlyFirstPosition: true,
  ),
  filetype(
    label: 'Dateityp',
    type: 'filetype',
    constructor: FileTypeRule.new,
    fromJson: FileTypeRule.fromJson,
    onlyFirstPosition: true,
  );

  const RuleType({
    required this.type,
    required this.label,
    required this.constructor,
    required this.fromJson,
    required this.onlyFirstPosition,
    this.hint,
  });

  final String type;
  final String label;
  final String? hint;
  final Rule Function() constructor;
  final Rule Function(Map<String, dynamic>) fromJson;
  final bool onlyFirstPosition;

  static RuleType fromType(String type) {
    return RuleType.values.firstWhere(
      (ruleType) => ruleType.type == type,
      orElse: () => throw Exception('Unbekannter Regeltyp: $type'),
    );
  }
}
