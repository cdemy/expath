part of '_rule.dart';

class PathSegmentRule extends Rule {
  int index;

  PathSegmentRule._({
    required this.index,
  }) : super(RuleType.pathSegment);

  PathSegmentRule()
      : index = 0,
        super(RuleType.pathSegment);

  @override
  String? apply(File input) {
    final path = input.path;
    final parts = path.split(Platform.pathSeparator);
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
        'index': index,
      };

  static PathSegmentRule fromJson(Map<String, dynamic> json) {
    return PathSegmentRule._(
      index: int.parse(json['index'].toString()),
    );
  }
}
