import 'dart:io';

/// Represents a root directory with its associated files
/// This class is immutable to prevent unintended side effects
class RootDirectoryEntry {
  /// The absolute path to the root directory
  final String path;
  
  /// List of files found in this directory (immutable)
  final List<File> files;

  /// Creates a new RootDirectoryEntry with the given path and files
  /// 
  /// The [files] list is copied to ensure immutability
  RootDirectoryEntry(this.path, List<File> files) 
      : files = List.unmodifiable(files);

  /// Creates a RootDirectoryEntry with an empty file list
  RootDirectoryEntry.empty(this.path) : files = const [];

  /// Creates a copy of this entry with updated files
  RootDirectoryEntry copyWith({
    String? path,
    List<File>? files,
  }) {
    return RootDirectoryEntry(
      path ?? this.path,
      files ?? this.files,
    );
  }

  /// Get the number of files in this directory
  int get fileCount => files.length;

  /// Check if this directory contains any files
  bool get hasFiles => files.isNotEmpty;

  /// Check if this directory is empty
  bool get isEmpty => files.isEmpty;

  /// Get the directory name (last segment of the path)
  String get directoryName {
    final segments = path.split(Platform.pathSeparator);
    return segments.isNotEmpty ? segments.last : path;
  }

  /// Get files filtered by extension
  List<File> getFilesByExtension(String extension) {
    final normalizedExtension = extension.toLowerCase();
    return files.where((file) {
      final fileExtension = file.path.split('.').last.toLowerCase();
      return fileExtension == normalizedExtension;
    }).toList();
  }

  /// Get files filtered by multiple extensions
  List<File> getFilesByExtensions(List<String> extensions) {
    final normalizedExtensions = extensions.map((e) => e.toLowerCase()).toSet();
    return files.where((file) {
      final fileExtension = file.path.split('.').last.toLowerCase();
      return normalizedExtensions.contains(fileExtension);
    }).toList();
  }

  /// Get total size of all files in bytes
  int getTotalSize() {
    int totalSize = 0;
    for (final file in files) {
      try {
        final stat = file.statSync();
        totalSize += stat.size;
      } catch (e) {
        // Skip files that can't be accessed
        continue;
      }
    }
    return totalSize;
  }

  /// Get human-readable total size
  String getFormattedTotalSize() {
    final totalSize = getTotalSize();
    if (totalSize < 1024) return '$totalSize B';
    if (totalSize < 1024 * 1024) return '${(totalSize / 1024).toStringAsFixed(1)} KB';
    if (totalSize < 1024 * 1024 * 1024) return '${(totalSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(totalSize / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RootDirectoryEntry) return false;
    
    return path == other.path && 
           files.length == other.files.length &&
           _listsEqual(files, other.files);
  }

  @override
  int get hashCode => Object.hash(path, files.length);

  @override
  String toString() {
    return 'RootDirectoryEntry(path: $path, fileCount: $fileCount)';
  }

  /// Helper method to compare file lists
  bool _listsEqual(List<File> list1, List<File> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].path != list2[i].path) return false;
    }
    return true;
  }
}
