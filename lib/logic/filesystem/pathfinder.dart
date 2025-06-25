import 'dart:async';
import 'dart:io';
import 'package:expath_app/logic/filesystem/directory_stats.dart';
import 'package:expath_app/logic/filesystem/pathfinder_exception.dart';
import 'package:expath_app/logic/filesystem/scan_result.dart';
import 'package:flutter/foundation.dart';

class Pathfinder {
  final String rootDirectoryPath;

  Pathfinder(this.rootDirectoryPath);

  /// Get all file paths synchronously (legacy method for compatibility)
  List<String> getAllFilePaths() {
    final files = getAllFiles();
    return files.map((file) => file.path).toList();
  }

  /// Get all files synchronously (legacy method for compatibility)
  List<File> getAllFiles() {
    final directory = Directory(rootDirectoryPath);
    if (!directory.existsSync()) {
      throw PathfinderException(
        "Directory does not exist",
        rootDirectoryPath,
      );
    }
    
    final List<File> files = [];

    void scanDirectory(Directory dir) {
      try {
        for (var entity in dir.listSync(recursive: false)) {
          if (entity is File) {
            files.add(entity);
          } else if (entity is Directory) {
            scanDirectory(entity);
          }
        }
      } on FileSystemException catch (e) {
        if (kDebugMode) {
          print('Access denied or error at ${dir.path}: ${e.message}');
        }
      }
    }

    scanDirectory(directory);
    return files;
  }

  /// Get all files asynchronously with comprehensive error handling
  Future<ScanResult> getAllFilesAsync({
    bool recursive = true,
    List<String>? allowedExtensions,
    int? maxFiles,
    Duration? timeout,
  }) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      // Validate root directory
      final directory = Directory(rootDirectoryPath);
      if (!await directory.exists()) {
        throw PathfinderException(
          "Root directory does not exist",
          rootDirectoryPath,
        );
      }

      final files = <File>[];
      final errors = <String>[];
      int directoriesScanned = 0;

      // Use timeout if specified
      if (timeout != null) {
        try {
          await _scanDirectoryAsync(
            directory,
            files,
            errors,
            recursive,
            allowedExtensions,
            maxFiles,
            (count) => directoriesScanned += count,
          ).timeout(timeout);
        } on TimeoutException {
          errors.add('Scan operation timed out after ${timeout.inSeconds} seconds');
        }
      } else {
        await _scanDirectoryAsync(
          directory,
          files,
          errors,
          recursive,
          allowedExtensions,
          maxFiles,
          (count) => directoriesScanned += count,
        );
      }

      stopwatch.stop();
      
      return ScanResult(
        files: files,
        errors: errors,
        directoriesScanned: directoriesScanned,
        scanDuration: stopwatch.elapsed,
      );
      
    } on PathfinderException {
      rethrow;
    } catch (e) {
      throw PathfinderException(
        "Unexpected error during file scanning",
        rootDirectoryPath,
        e.toString(),
      );
    }
  }

  /// Scan directory asynchronously with proper error handling
  Future<void> _scanDirectoryAsync(
    Directory dir,
    List<File> files,
    List<String> errors,
    bool recursive,
    List<String>? allowedExtensions,
    int? maxFiles,
    Function(int) onDirectoryScanned,
  ) async {
    try {
      int dirCount = 0;
      
      await for (var entity in dir.list(recursive: false)) {
        // Check if we've reached the maximum file limit
        if (maxFiles != null && files.length >= maxFiles) {
          break;
        }
        
        try {
          if (entity is File) {
            // Check file extension if filter is specified
            if (allowedExtensions != null) {
              final extension = entity.path.split('.').last.toLowerCase();
              if (!allowedExtensions.contains(extension)) {
                continue;
              }
            }
            
            files.add(entity);
          } else if (entity is Directory && recursive) {
            dirCount++;
            await _scanDirectoryAsync(
              entity,
              files,
              errors,
              recursive,
              allowedExtensions,
              maxFiles,
              onDirectoryScanned,
            );
          }
        } on FileSystemException catch (e) {
          final errorMsg = 'Access denied or error at ${entity.path}: ${e.message}';
          errors.add(errorMsg);
          if (kDebugMode) {
            print(errorMsg);
          }
        }
        
        // Yield control periodically to keep UI responsive
        if (files.length % 100 == 0) {
          await Future.delayed(Duration.zero);
        }
      }
      
      onDirectoryScanned(dirCount);
      
    } on FileSystemException catch (e) {
      final errorMsg = 'Cannot access directory ${dir.path}: ${e.message}';
      errors.add(errorMsg);
      if (kDebugMode) {
        print(errorMsg);
      }
    }
  }

  /// Check if a directory can be accessed
  Future<bool> canAccessDirectory() async {
    try {
      final directory = Directory(rootDirectoryPath);
      if (!await directory.exists()) {
        return false;
      }
      
      // Try to list the directory contents
      await directory.list(recursive: false).take(1).toList();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get directory statistics without scanning all files
  Future<DirectoryStats> getDirectoryStats() async {
    final directory = Directory(rootDirectoryPath);
    if (!await directory.exists()) {
      throw PathfinderException(
        "Directory does not exist",
        rootDirectoryPath,
      );
    }

    int fileCount = 0;
    int directoryCount = 0;
    int totalSize = 0;
    final errors = <String>[];

    try {
      await for (var entity in directory.list(recursive: true)) {
        try {
          if (entity is File) {
            fileCount++;
            final stat = await entity.stat();
            totalSize += stat.size;
          } else if (entity is Directory) {
            directoryCount++;
          }
        } on FileSystemException catch (e) {
          errors.add('Error accessing ${entity.path}: ${e.message}');
        }
        
        // Yield control periodically
        if ((fileCount + directoryCount) % 100 == 0) {
          await Future.delayed(Duration.zero);
        }
      }
    } on FileSystemException catch (e) {
      throw PathfinderException(
        "Error scanning directory for statistics",
        rootDirectoryPath,
        e.message,
      );
    }

    return DirectoryStats(
      fileCount: fileCount,
      directoryCount: directoryCount,
      totalSize: totalSize,
      errors: errors,
    );
  }
}
