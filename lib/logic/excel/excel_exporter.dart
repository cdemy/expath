import 'dart:io';
import 'dart:typed_data';
import 'package:expath_app/logic/excel/file_saver.dart';
import 'package:expath_app/logic/models/rule_stack.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import '../filesystem/root_directory_entry.dart';

/// Custom exceptions for Excel export operations
class ExcelExportException implements Exception {
  final String message;
  final String? details;

  const ExcelExportException(this.message, [this.details]);

  @override
  String toString() => details != null ? '$message: $details' : message;
}

class ExcelExporter {
  /// Export data to Excel file with comprehensive error handling
  static Future<void> export({
    required List<RootDirectoryEntry> directories,
    required List<RuleStack> rulesStacks,
  }) async {
    try {
      // Validate input data
      _validateInputData(directories, rulesStacks);

      // Get save path from user
      final String? savePath = await _getSaveFilePath();
      if (savePath == null) return; // User cancelled

      // Create Excel workbook
      final excel = _createExcelWorkbook();
      final sheet = excel['Sheet1'];

      // Build Excel content
      _createHeaderRow(sheet, rulesStacks);
      await _populateDataRows(sheet, directories, rulesStacks);

      // Save the Excel file
      await _saveExcelFile(excel, savePath);
    } on ExcelExportException {
      rethrow; // Re-throw our custom exceptions
    } on FileSystemException catch (e) {
      throw ExcelExportException(
        'Dateisystem-Fehler beim Excel-Export',
        e.message,
      );
    } on FormatException catch (e) {
      throw ExcelExportException(
        'Datenformat-Fehler beim Excel-Export',
        e.message,
      );
    } catch (e) {
      throw ExcelExportException(
        'Unerwarteter Fehler beim Excel-Export',
        e.toString(),
      );
    }
  }

  /// Validate input data before processing
  static void _validateInputData(
    List<RootDirectoryEntry> directories,
    List<RuleStack> rulesStacks,
  ) {
    if (directories.isEmpty) {
      throw const ExcelExportException(
        'Keine Verzeichnisse zum Exportieren vorhanden',
        'Fügen Sie mindestens ein Verzeichnis hinzu',
      );
    }

    if (rulesStacks.isEmpty) {
      throw const ExcelExportException(
        'Keine Regeln zum Exportieren vorhanden',
        'Erstellen Sie mindestens eine Regel',
      );
    }

    // Check if any files exist
    final totalFiles = directories.expand((dir) => dir.files).length;
    if (totalFiles == 0) {
      throw const ExcelExportException(
        'Keine Dateien in den ausgewählten Verzeichnissen gefunden',
        'Stellen Sie sicher, dass die Verzeichnisse Dateien enthalten',
      );
    }

    // Validate rule stacks have valid Excel field names
    for (int i = 0; i < rulesStacks.length; i++) {
      final ruleStack = rulesStacks[i];
      if (ruleStack.excelField.trim().isEmpty) {
        throw ExcelExportException(
          'Regel ${i + 1} hat keinen gültigen Excel-Feldnamen',
          'Jede Regel muss einen Excel-Feldnamen haben',
        );
      }
    }
  }

  /// Get save file path from user
  static Future<String?> _getSaveFilePath() async {
    try {
      return await FilePicker.platform.saveFile(
        dialogTitle: 'Excel-Datei speichern',
        fileName: 'Export.xlsx',
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );
    } catch (e) {
      throw ExcelExportException(
        'Fehler beim Öffnen des Speichern-Dialogs',
        e.toString(),
      );
    }
  }

  /// Create a new Excel workbook
  static Excel _createExcelWorkbook() {
    try {
      return Excel.createExcel();
    } catch (e) {
      throw ExcelExportException(
        'Fehler beim Erstellen der Excel-Arbeitsmappe',
        e.toString(),
      );
    }
  }

  /// Create header row in the Excel sheet
  static void _createHeaderRow(Sheet sheet, List<RuleStack> rulesStacks) {
    try {
      final headers = rulesStacks.map((r) => r.excelField).toList();

      for (int col = 0; col < headers.length; col++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(
          columnIndex: col,
          rowIndex: 0,
        ));
        cell.value = headers[col];

        // Style the header cell
        cell.cellStyle = CellStyle(
          bold: true,
          backgroundColorHex: '#E0E0E0',
        );
      }
    } catch (e) {
      throw ExcelExportException(
        'Fehler beim Erstellen der Excel-Kopfzeile',
        e.toString(),
      );
    }
  }

  /// Populate data rows in the Excel sheet
  static Future<void> _populateDataRows(
    Sheet sheet,
    List<RootDirectoryEntry> directories,
    List<RuleStack> rulesStacks,
  ) async {
    try {
      final allFiles = directories.expand((dir) => dir.files).toList();

      for (int fileIndex = 0; fileIndex < allFiles.length; fileIndex++) {
        final file = allFiles[fileIndex];

        for (int ruleIndex = 0; ruleIndex < rulesStacks.length; ruleIndex++) {
          final ruleStack = rulesStacks[ruleIndex];

          try {
            final result = ruleStack.apply(file) ?? '';
            final cell = sheet.cell(CellIndex.indexByColumnRow(
              columnIndex: ruleIndex,
              rowIndex: fileIndex + 1,
            ));
            cell.value = result;
          } catch (e) {
            // Handle individual rule application errors
            final cell = sheet.cell(CellIndex.indexByColumnRow(
              columnIndex: ruleIndex,
              rowIndex: fileIndex + 1,
            ));
            cell.value = 'ERROR: ${e.toString()}';
            cell.cellStyle = CellStyle(
              fontColorHex: '#FF0000', // Red text for errors
            );
          }
        }

        // Yield control periodically for large datasets
        if (fileIndex % 100 == 0) {
          await Future.delayed(Duration.zero);
        }
      }
    } catch (e) {
      throw ExcelExportException(
        'Fehler beim Befüllen der Excel-Datenzeilen',
        e.toString(),
      );
    }
  }

  /// Save the Excel file to disk
  static Future<void> _saveExcelFile(Excel excel, String savePath) async {
    try {
      final bytes = excel.encode();
      if (bytes == null) {
        throw const ExcelExportException(
          'Fehler beim Kodieren der Excel-Datei',
          'Die Excel-Bibliothek konnte keine Bytes generieren',
        );
      }

      await FileSaver.saveFile(
        filePath: savePath,
        bytes: Uint8List.fromList(bytes),
      );
    } catch (e) {
      if (e is ExcelExportException) {
        rethrow;
      }
      throw ExcelExportException(
        'Fehler beim Speichern der Excel-Datei',
        e.toString(),
      );
    }
  }
}
