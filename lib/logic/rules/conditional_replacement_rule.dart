part of '_rule.dart';

class ConditionalReplacementRule extends Rule {
  String keyword;
  String valueIfMatch;

  ConditionalReplacementRule.empty()
      : keyword = '',
        valueIfMatch = '',
        super(RuleType.conditionalReplacement);

  ConditionalReplacementRule({
    required this.keyword,
    required this.valueIfMatch,
  }) : super(RuleType.conditionalReplacement);

  @override
  String? apply(File file) {
    final path = file.path;
    return applyString(path);
  }

  @override
  String? applyString(String? string) {
    if (string == null) return null;
    return string.contains(keyword) ? valueIfMatch : string;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': ruleType.type,
      'keyword': keyword,
      'valueIfMatch': valueIfMatch,
    };
  }

  static ConditionalReplacementRule fromJson(Map<String, dynamic> json) {
    return ConditionalReplacementRule(
      keyword: json['keyword'] as String,
      valueIfMatch: json['valueIfMatch'] as String,
    );
  }
}
