import 'dart:io';
import 'dart:typed_data';

/// Service for saving files with platform-specific handling
class FileSaver {
  /// Save bytes to a file with proper error handling
  static Future<void> saveFile({
    required String filePath,
    required Uint8List bytes,
  }) async {
    try {
      final file = File(filePath);
      
      // Ensure directory exists
      final directory = file.parent;
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      
      // Check if we have write permissions
      if (await file.exists()) {
        final stat = await file.stat();
        if (stat.type == FileSystemEntityType.directory) {
          throw FileSystemException(
            'Der angegebene Pfad ist ein Verzeichnis, keine Datei',
            filePath,
          );
        }
      }
      
      // Write the file
      await file.writeAsBytes(bytes);
      
    } on FileSystemException catch (e) {
      throw FileSystemException(
        'Fehler beim Speichern der Datei: ${e.message}',
        filePath,
      );
    } catch (e) {
      throw FileSystemException(
        'Unerwarteter Fehler beim Speichern: $e',
        filePath,
      );
    }
  }
  
  /// Check if a file path is valid and writable
  static Future<bool> isPathWritable(String filePath) async {
    try {
      final file = File(filePath);
      final directory = file.parent;
      
      // Check if directory exists or can be created
      if (!await directory.exists()) {
        try {
          await directory.create(recursive: true);
          await directory.delete(); // Clean up test directory
        } catch (e) {
          return false;
        }
      }
      
      // Try to create a temporary file to test write permissions
      final tempFile = File('${filePath}_temp_test');
      try {
        await tempFile.writeAsString('test');
        await tempFile.delete();
        return true;
      } catch (e) {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  
  /// Get a safe filename by removing invalid characters
  static String sanitizeFileName(String fileName) {
    // Remove or replace invalid characters for file names
    return fileName
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .trim();
  }
}