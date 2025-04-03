import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'root_directory_entry.dart';
import 'rule.dart';

class ExcelExporter {
  static Future<void> export({
    required List<RootDirectoryEntry> directories,
    required List<Rule> rules,
  }) async {
    if (directories.isEmpty || rules.isEmpty) {
      throw Exception("Keine Daten oder Regeln vorhanden.");
    }

    // Save-Dialog
    final String? savePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Excel-Datei speichern',
      fileName: 'Export.xlsx',
    );

    if (savePath == null) return; // Abbruch durch User

    final excel = Excel.createExcel();
    final Sheet sheet = excel['Sheet1'];

    // Header
    final headers = ['Dateipfad', ...rules.map((r) => r.excelField)];
    for (int col = 0; col < headers.length; col++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0)).value = headers[col];
    }

    // Daten eintragen
    final allFiles = directories.expand((dir) => dir.filePaths).toList();
    for (int i = 0; i < allFiles.length; i++) {
      final filePath = allFiles[i];
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1)).value = filePath;

      for (int j = 0; j < rules.length; j++) {
        final rule = rules[j];
        final result = rule.apply(filePath) ?? '';
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: j + 1, rowIndex: i + 1)).value = result;
      }
    }

    // Encode und speichern
    final bytes = excel.encode();
    if (bytes != null) {
      final file = File(savePath);
      file.createSync(recursive: true);
      file.writeAsBytesSync(bytes);
    } else {
      throw Exception("Fehler beim Erstellen der Excel-Datei.");
    }
  }
}
