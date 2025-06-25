import 'dart:io';
import 'package:expath_app/logic/filesystem/root_directory_entry.dart';
import 'package:expath_app/logic/rules/rule_stack.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State class for PreviewScreen
class PreviewScreenState {
  final List<RootDirectoryEntry> directories;
  final List<RuleStack> ruleStacks;
  final List<File> allFiles;
  final Map<String, bool> selectedRows;
  final Map<String, File> fileIndex;
  final bool isLoading;

  const PreviewScreenState({
    required this.directories,
    required this.ruleStacks,
    required this.allFiles,
    required this.selectedRows,
    required this.fileIndex,
    this.isLoading = false,
  });

  PreviewScreenState copyWith({
    List<RootDirectoryEntry>? directories,
    List<RuleStack>? ruleStacks,
    List<File>? allFiles,
    Map<String, bool>? selectedRows,
    Map<String, File>? fileIndex,
    bool? isLoading,
  }) {
    return PreviewScreenState(
      directories: directories ?? this.directories,
      ruleStacks: ruleStacks ?? this.ruleStacks,
      allFiles: allFiles ?? this.allFiles,
      selectedRows: selectedRows ?? this.selectedRows,
      fileIndex: fileIndex ?? this.fileIndex,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// Get list of selected files
  List<File> get selectedFiles {
    return selectedRows.entries
        .where((entry) => entry.value)
        .map((entry) => fileIndex[entry.key]!)
        .toList();
  }

  /// Check if any files are selected
  bool get hasSelectedFiles => selectedFiles.isNotEmpty;

  /// Check if there are any files to display
  bool get hasFiles => allFiles.isNotEmpty;
}

/// Notifier for PreviewScreen state management
class PreviewScreenNotifier extends Notifier<PreviewScreenState> {
  @override
  PreviewScreenState build() {
    return const PreviewScreenState(
      directories: [],
      ruleStacks: [],
      allFiles: [],
      selectedRows: {},
      fileIndex: {},
    );
  }

  /// Initialize the preview screen with directories and rule stacks
  void initialize(List<RootDirectoryEntry> directories, List<RuleStack> ruleStacks) {
    final allFiles = directories.expand((dir) => dir.files).toList();
    final selectedRows = {for (var file in allFiles) file.path: true};
    final fileIndex = {for (var file in allFiles) file.path: file};

    state = PreviewScreenState(
      directories: directories,
      ruleStacks: ruleStacks,
      allFiles: allFiles,
      selectedRows: selectedRows,
      fileIndex: fileIndex,
    );
  }

  /// Toggle selection of a file
  void toggleSelection(String filePath, bool? selected) {
    final updatedSelectedRows = Map<String, bool>.from(state.selectedRows);
    updatedSelectedRows[filePath] = selected ?? false;
    
    state = state.copyWith(selectedRows: updatedSelectedRows);
  }

  /// Set loading state
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  /// Select all files
  void selectAll() {
    final updatedSelectedRows = {for (var file in state.allFiles) file.path: true};
    state = state.copyWith(selectedRows: updatedSelectedRows);
  }

  /// Deselect all files
  void deselectAll() {
    final updatedSelectedRows = {for (var file in state.allFiles) file.path: false};
    state = state.copyWith(selectedRows: updatedSelectedRows);
  }
}

/// Provider for PreviewScreen state
final previewScreenProvider = NotifierProvider<PreviewScreenNotifier, PreviewScreenState>(() {
  return PreviewScreenNotifier();
});