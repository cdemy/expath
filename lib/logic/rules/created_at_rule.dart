part of '_rule.dart';

class CreatedAtRule extends Rule {
  String format;

  CreatedAtRule({
    this.format = 'yyyy-MM-dd HH:mm:ss',
  }) : super(RuleType.createdAt);

  @override
  String? apply(File file) {
    try {
      final date = file.lastModifiedSync();
      return DateFormat(format).format(date);
    } catch (e) {
      return null;
    }
  }

  @override
  String? applyString(String? string) {
    throw Exception('Cannot be applied to a String');
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': ruleType.type,
        'format': format,
      };

  static CreatedAtRule fromJson(Map<String, dynamic> json) {
    return CreatedAtRule(
      format: json['format'] ?? 'yyyy-MM-dd HH:mm:ss',
    );
  }
}
