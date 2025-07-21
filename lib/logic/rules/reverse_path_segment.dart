part of '_rule.dart';

class ReversePathSegmentRule extends Rule {
  int reverseIndex;

  ReversePathSegmentRule._({
    required this.reverseIndex,
  }) : super(RuleType.reversePathSegment);

  ReversePathSegmentRule()
      : reverseIndex = 0,
        super(RuleType.reversePathSegment);

  @override
  String? apply(File input) {
    final path = input.path;
    final parts = path.split(Platform.pathSeparator);
    final index = parts.length - 1 - reverseIndex;
    if (index < 0 || index >= parts.length) return null;
    return parts[index];
  }

  @override
  String? applyString(String? string) {
    throw Exception('Cannot be applied to a String');
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': ruleType.type,
        'reverseIndex': reverseIndex,
      };

  static ReversePathSegmentRule fromJson(Map<String, dynamic> json) {
    return ReversePathSegmentRule._(
      reverseIndex: int.parse(json['reverseIndex'].toString()),
    );
  }
}
