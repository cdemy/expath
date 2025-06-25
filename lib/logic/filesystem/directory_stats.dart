/// Statistics about a directory
class DirectoryStats {
  final int fileCount;
  final int directoryCount;
  final int totalSize;
  final List<String> errors;

  const DirectoryStats({
    required this.fileCount,
    required this.directoryCount,
    required this.totalSize,
    required this.errors,
  });

  /// Get human-readable size
  String get formattedSize {
    if (totalSize < 1024) return '$totalSize B';
    if (totalSize < 1024 * 1024) return '${(totalSize / 1024).toStringAsFixed(1)} KB';
    if (totalSize < 1024 * 1024 * 1024) return '${(totalSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(totalSize / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Check if there were any errors during scanning
  bool get hasErrors => errors.isNotEmpty;
}