part of '_rule.dart';

class ConditionalRule extends Rule {
  String keyword;
  String valueIfMatch;
  String valueIfNoMatch;

  ConditionalRule.empty()
      : keyword = '',
        valueIfMatch = '',
        valueIfNoMatch = '',
        super(RuleType.conditional);

  ConditionalRule({
    required this.keyword,
    required this.valueIfMatch,
    required this.valueIfNoMatch,
  }) : super(RuleType.conditional);

  @override
  String? apply(File file) {
    final path = file.path;
    return applyString(path);
  }

  @override
  String? applyString(String? string) {
    if (string == null) return null;
    return string.contains(keyword) ? valueIfMatch : valueIfNoMatch;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': ruleType.type,
      'keyword': keyword,
      'valueIfMatch': valueIfMatch,
      'valueIfNoMatch': valueIfNoMatch,
    };
  }

  static ConditionalRule fromJson(Map<String, dynamic> json) {
    return ConditionalRule(
      keyword: json['keyword'] as String,
      valueIfMatch: json['valueIfMatch'] as String,
      valueIfNoMatch: json['valueIfNoMatch'] as String,
    );
  }
}
