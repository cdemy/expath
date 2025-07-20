import 'package:expath_app/logic/models/proto_eingabe_blueprint.dart';
import 'package:expath_app/logic/rules/_rule.dart';

/// -----------------------------
/// RuleType - predefined rules
/// -----------------------------

enum RuleType {
  regEx(
    label: 'Benutzerdefinierter Regex',
    type: 'regEx',
    constructor: SimpleRegexRule.new,
    // fromJson: SimpleRegexRule.fromJson,
    onlyFirstPosition: false,
    eingabeBlueprints: [
      ProtoEingabeBlueprint(
        label: 'Regex',
        helperText: 'Regulärer Ausdruck (z.B. \\d+ für Zahlen)',
        field: 'regex',
        valueType: String,
        defaultValue: '',
      ),
    ],
  ),
  concatenation(
    type: 'concatenation',
    label: 'Verketten',
    constructor: ConcatenationRule.new,
    // fromJson: ConcatenationRule.fromJson,
    onlyFirstPosition: false,
    eingabeBlueprints: [
      ProtoEingabeBlueprint(
        label: 'Vorher',
        helperText: 'Text vor der Verkettung',
        field: 'before',
        valueType: String,
        defaultValue: '',
      ),
      ProtoEingabeBlueprint(
        label: 'Nachher',
        helperText: 'Text nach der Verkettung',
        field: 'after',
        valueType: String,
        defaultValue: '',
      ),
    ],
  ),

  conditional(
    label: 'Fallunterscheidung',
    type: 'conditional',
    constructor: ConditionalRule.empty,
    // fromJson: ConditionalRule.fromJson,
    onlyFirstPosition: false,
    eingabeBlueprints: [
      ProtoEingabeBlueprint(
        label: 'Keyword',
        helperText: 'Keyword, das geprüft wird',
        field: 'keyword',
        valueType: String,
        defaultValue: '',
      ),
      ProtoEingabeBlueprint(
        label: 'Falls ja',
        helperText: 'Wert, wenn Keyword gefunden wird',
        field: 'valueIfMatch',
        valueType: String,
        defaultValue: '',
      ),
      ProtoEingabeBlueprint(
        label: 'Falls nein',
        helperText: 'Wert, wenn Keyword nicht gefunden wird',
        field: 'valueIfNoMatch',
        valueType: String,
        defaultValue: '',
      ),
    ],
  ),

  lowerCase(
    label: 'Kleinschreibung',
    type: 'lowerCase',
    constructor: LowerCaseRule.new,
    // fromJson: LowerCaseRule.fromJson,
    onlyFirstPosition: false,
    eingabeBlueprints: [],
  ),

  upperCase(
    label: 'Großschreibung',
    type: 'upperCase',
    constructor: UpperCaseRule.new,
    // fromJson: UpperCaseRule.fromJson,
    onlyFirstPosition: false,
    eingabeBlueprints: [],
  ),

  fileName(
    type: 'fileName',
    label: 'Dateiname extrahieren',
    constructor: SimpleRegexRule.fileName,
    // fromJson: SimpleRegexRule.fromJson,
    onlyFirstPosition: true,
    eingabeBlueprints: [],
  ),

  parentDirectory(
    type: 'parentDirectory',
    label: 'Ordnerpfad extrahieren',
    constructor: SimpleRegexRule.parentDirectory,
    // fromJson: SimpleRegexRule.fromJson,
    onlyFirstPosition: true,
    eingabeBlueprints: [],
  ),

  pathSegment(
    type: 'pathSegment',
    label: 'Ordner an Position extrahieren',
    constructor: PathSegmentRule.new,
    // fromJson: PathSegmentRule.fromJson,
    onlyFirstPosition: true,
    eingabeBlueprints: [
      ProtoEingabeBlueprint(
        label: 'Position',
        helperText: '0 = Partition, 1 = erster Ordner, 2 = zweiter Ordner, ...',
        field: 'index',
        valueType: int,
        defaultValue: '0',
      ),
    ],
  ),

  reversePathSegment(
    label: 'Ordner invertiert extrahieren',
    type: 'reversePathSegment',
    constructor: ReversePathSegmentRule.new,
    // fromJson: ReversePathSegmentRule.fromJson,
    onlyFirstPosition: true,
    eingabeBlueprints: [
      ProtoEingabeBlueprint(
        label: 'Position',
        helperText: '0 = Datei, 1 = letzter Ordner, 2 = vorletzter Ordner, ...',
        field: 'reverseIndex',
        valueType: int,
        defaultValue: '0',
      ),
    ],
  ),

  filesize(
    label: 'Dateigröße',
    type: 'fileSize',
    constructor: FileSizeRule.new,
    // fromJson: FileSizeRule.fromJson,
    onlyFirstPosition: true,
    eingabeBlueprints: [],
  ),

  createdAt(
    label: 'Erstellungsdatum',
    type: 'createdAt',
    constructor: CreatedAtRule.new,
    // fromJson: CreatedAtRule.fromJson,
    onlyFirstPosition: true,
    eingabeBlueprints: [
      ProtoEingabeBlueprint(
        label: 'Format',
        helperText: 'Format des Datums (z.B. dd.MM.yyyy HH:mm:ss)',
        field: 'format',
        valueType: String,
        defaultValue: 'dd.MM.yyyy HH:mm:ss',
      ),
    ],
  ),

  filepath(
    label: 'Dateipfad',
    type: 'filepath',
    constructor: FilePathRule.new,
    // fromJson: FilePathRule.fromJson,
    onlyFirstPosition: true,
    eingabeBlueprints: [],
  ),

  substring(
    label: 'Zeichen (X bis Y)',
    type: 'substring',
    constructor: SubstringRule.new,
    onlyFirstPosition: false,
    eingabeBlueprints: [
      ProtoEingabeBlueprint(
        label: 'Von',
        helperText: 'Startet an Zeichen (z.B. 1 für das erste Zeichen)',
        field: 'von',
        valueType: int,
        defaultValue: '0',
      ),
      ProtoEingabeBlueprint(
        label: 'Bis',
        helperText: 'Endet an Zeichen (z.B. 5 für das fünfte Zeichen)',
        field: 'bis',
        valueType: int,
        defaultValue: '0',
      ),
    ],
  ),

  substringStart(
    label: 'Zeichen (von vorne)',
    type: 'substringStart',
    constructor: SubstringStartRule.new,
    onlyFirstPosition: false,
    eingabeBlueprints: [
      ProtoEingabeBlueprint(
        label: 'Zeichen',
        helperText: 'Wieviele Zeichen von vorne',
        field: 'chars',
        valueType: int,
        defaultValue: '0',
      ),
    ],
  ),

  substringEnd(
    label: 'Zeichen (von hinten)',
    type: 'substringEnd',
    constructor: SubstringEndRule.new,
    onlyFirstPosition: false,
    eingabeBlueprints: [
      ProtoEingabeBlueprint(
        label: 'Zeichen',
        helperText: 'Wieviele Zeichen von hinten',
        field: 'chars',
        valueType: int,
        defaultValue: '0',
      ),
    ],
  ),

  filetype(
    label: 'Dateityp',
    type: 'filetype',
    constructor: FileTypeRule.new,
    // fromJson: FileTypeRule.fromJson,
    onlyFirstPosition: true,
    eingabeBlueprints: [],
  );

  const RuleType({
    required this.type,
    required this.label,
    required this.constructor,
    // required this.fromJson,
    required this.onlyFirstPosition,
    required this.eingabeBlueprints,
  });

  final String type;
  final String label;
  final Rule Function() constructor;
  // final Rule Function(Map<String, dynamic>) fromJson;
  final bool onlyFirstPosition;
  final List<ProtoEingabeBlueprint> eingabeBlueprints;

  static RuleType fromType(String type) {
    return RuleType.values.firstWhere(
      (ruleType) => ruleType.type == type,
      orElse: () => throw Exception('Unbekannter Regeltyp: $type'),
    );
  }
}
