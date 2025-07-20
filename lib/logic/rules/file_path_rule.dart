part of '_rule.dart';

class FilePathRule extends Rule {
  FilePathRule() : super(RuleType.filepath);

  @override
  String? apply(File file) {
    try {
      return file.path;
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

  static FilePathRule fromJson(Map<String, dynamic> json) {
    return FilePathRule();
  }
}
