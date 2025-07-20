part of '_rule.dart';

class FileTypeRule extends Rule {
  FileTypeRule() : super(RuleType.filetype);

  @override
  String? apply(File file) {
    try {
      return file.path.split('.').last.toString();
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

  static FileTypeRule fromJson(Map<String, dynamic> json) {
    return FileTypeRule();
  }
}
