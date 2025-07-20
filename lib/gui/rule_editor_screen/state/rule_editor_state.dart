import 'package:expath_app/logic/models/proto_rule.dart';
import 'package:expath_app/logic/models/rule_stack.dart';

/// State class for RuleEditorScreen
class RuleEditorState {
  final String excelField;
  final List<ProtoRule> protoRules;
  // final int? currentFileIndex;
  // final int? maxFileIndex;
  // final Map<String, String> validationErrors;

  const RuleEditorState({
    required this.excelField,
    required this.protoRules,
    // this.currentFileIndex,
    // this.maxFileIndex,
    // this.validationErrors = const {},
  });

  RuleEditorState copyWith({
    String? excelField,
    List<ProtoRule>? protoRules,
    // int? currentFileIndex,
    // int? maxFileIndex,
    // Map<String, String>? validationErrors,
  }) {
    return RuleEditorState(
      excelField: excelField ?? this.excelField,
      protoRules: protoRules ?? this.protoRules,
      // currentFileIndex: currentFileIndex ?? this.currentFileIndex,
      // maxFileIndex: maxFileIndex ?? this.maxFileIndex,
      // validationErrors: validationErrors ?? this.validationErrors,
    );
  }

  /// Create RuleStack from current state
  RuleStack? toRuleStack() {
    final rules = protoRules.map((protoRule) => protoRule.toRule()).toList();
    try {
      final ruleStack = RuleStack(
        rules: rules,
        excelField: excelField.trim(),
      );
      return ruleStack;
    } catch (e) {
      print('Error creating RuleStack: $e');
      return null;
    }
  }

  /// Get the currently selected file for preview
  // File? get currentFile {
  //   if (currentFileIndex == null || directories.isEmpty) return null;
  //   final files = directories.first.files;
  //   if (currentFileIndex! >= 0 && currentFileIndex! < files.length) {
  //     return files[currentFileIndex!];
  //   }
  //   return null;
  // }

  /// Check if we can navigate to previous file
  // bool get canNavigatePrevious => currentFileIndex != null && currentFileIndex! > 0;

  /// Check if we can navigate to next file
  // bool get canNavigateNext => currentFileIndex != null && maxFileIndex != null && currentFileIndex! < maxFileIndex!;

  /// Check if the current state is valid for saving
  // bool get isValid => validationErrors.isEmpty && excelFieldController.text.trim().isNotEmpty;
}
