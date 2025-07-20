part of '_rule.dart';

class ConcatenationRule extends Rule {
  String? before;
  String? after;

  @override
  String? apply(File input) {
    final string = ReversePathSegmentRule().apply(input);
    return applyString(string);
  }

  @override
  String? applyString(String? string) {
    if (string == null) return null;
    return (before ?? '') + string + (after ?? '');
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': ruleType.type,
        'before': before,
        'after': after,
      };

  static ConcatenationRule fromJson(Map<String, dynamic> json) {
    return ConcatenationRule._(
      before: json['before'],
      after: json['after'],
    );
  }

  ConcatenationRule()
      : before = null,
        after = null,
        super(RuleType.concatenation);

  ConcatenationRule._({
    required this.before,
    required this.after,
  }) : super(RuleType.concatenation);
}
