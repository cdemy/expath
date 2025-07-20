import 'dart:io';

/// State class for PreviewScreen
class PreviewScreenState {
  final Set<int> selectedRows;
  final bool isLoading;

  const PreviewScreenState({
    required this.selectedRows,
    this.isLoading = false,
  });

  PreviewScreenState copyWith({
    Set<int>? selectedRows,
    bool? isLoading,
  }) {
    return PreviewScreenState(
      selectedRows: selectedRows ?? this.selectedRows,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// Get list of selected files
  List<File> selectedFiles(List<File> allFiles) {
    final selectedFiles = <File>[];
    for (var i = 0; i < allFiles.length; i++) {
      if (selectedRows.contains(i)) {
        selectedFiles.add(allFiles[i]);
      }
    }
    return selectedFiles;
  }

  /// Check if any files are selected
  bool get isNotEmpty => selectedRows.isNotEmpty;
}
