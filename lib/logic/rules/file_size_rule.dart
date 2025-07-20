part of '_rule.dart';

class FileSizeRule extends Rule {
  FileSizeRule() : super(RuleType.filesize);

  @override
  String? apply(File file) {
    try {
      return file.lengthSync().toString();
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
      };

  static FileSizeRule fromJson(Map<String, dynamic> json) {
    return FileSizeRule();
  }
}
