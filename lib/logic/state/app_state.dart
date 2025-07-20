import 'package:expath_app/logic/filesystem/root_directory_entry.dart';
import 'package:expath_app/logic/models/rule_stack.dart';

/// State class for MainScreen
class AppState {
  final List<RootDirectoryEntry> directories;
  final List<RuleStack> ruleStacks;

  const AppState({
    required this.directories,
    required this.ruleStacks,
  });

  AppState copyWith({
    List<RootDirectoryEntry>? directories,
    List<RuleStack>? ruleStacks,
  }) {
    return AppState(
      directories: directories ?? this.directories,
      ruleStacks: ruleStacks ?? this.ruleStacks,
    );
  }
}
