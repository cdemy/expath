import 'package:expath_app/logic/filesystem/root_directory_entry.dart';
import 'package:expath_app/logic/models/rule_stack.dart';
import 'package:expath_app/logic/state/app_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier for MainScreen state management
class AppStateNotifier extends Notifier<AppState> {
  @override
  AppState build() {
    return const AppState(
      directories: [],
      ruleStacks: [],
    );
  }

  /// Add a directory to the list
  void addDirectory(RootDirectoryEntry directory) {
    // Check if directory already exists
    if (state.directories.any((dir) => dir.path == directory.path)) {
      return; // Directory already exists
    }

    state = state.copyWith(
      directories: [...state.directories, directory],
    );
  }

  /// Remove a directory from the list
  void removeDirectory(RootDirectoryEntry directory) {
    state = state.copyWith(
      directories: state.directories.where((dir) => dir != directory).toList(),
    );
  }

  /// Clear all directories
  void clearDirectories() {
    state = state.copyWith(directories: []);
  }

  /// Add a rule stack to the list
  void addRuleStack(RuleStack ruleStack) {
    state = state.copyWith(
      ruleStacks: [...state.ruleStacks, ruleStack],
    );
  }

  /// Remove a rule stack from the list
  void removeRuleStack(RuleStack ruleStack) {
    state = state.copyWith(
      ruleStacks: state.ruleStacks.where((rs) => rs != ruleStack).toList(),
    );
  }

  /// Update a rule stack at a specific index
  void updateRuleStack(RuleStack oldRuleStack, RuleStack ruleStack) {
    final updatedRuleStacks = [...state.ruleStacks.map((rs) => rs == oldRuleStack ? ruleStack : rs)];
    state = state.copyWith(ruleStacks: updatedRuleStacks);
  }

  /// Move a rule stack from one position to another
  void moveRuleStack(int oldIndex, int newIndex) {
    final updatedRuleStacks = [...state.ruleStacks];
    final ruleStack = updatedRuleStacks.removeAt(oldIndex);
    updatedRuleStacks.insert(newIndex, ruleStack);
    state = state.copyWith(ruleStacks: updatedRuleStacks);
  }

  /// Clear all rule stacks
  void clearRuleStacks() {
    state = state.copyWith(ruleStacks: []);
  }

  /// Clear all data (directories and rule stacks)
  void clearAll() {
    state = const AppState(directories: [], ruleStacks: []);
  }

  /// Load rule stacks from external source
  void loadRuleStacks(List<RuleStack> ruleStacks) {
    state = state.copyWith(ruleStacks: ruleStacks);
  }
}
