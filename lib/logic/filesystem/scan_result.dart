import 'dart:io';

/// Result class for file scanning operations
class ScanResult {
  final List<File> files;
  final List<String> errors;
  final int directoriesScanned;
  final Duration scanDuration;
  
  const ScanResult({
    required this.files,
    required this.errors,
    required this.directoriesScanned,
    required this.scanDuration,
  });
  
  /// Check if scan completed without errors
  bool get hasErrors => errors.isNotEmpty;
  
  /// Get total number of files found
  int get fileCount => files.length;
}