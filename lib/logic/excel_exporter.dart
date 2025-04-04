import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'root_directory_entry.dart';
import 'rules/_rule.dart';

class ExcelExporter {
  static Future<void> export({
    required List<RootDirectoryEntry> directories,
    required List<Rule> rules,
  }) async {
    if (directories.isEmpty || rules.isEmpty) {
      throw Exception("Keine Daten oder Regeln vorhanden.");
    }

    // Save dialog
    final String? savePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Excel-Datei speichern',
      fileName: 'Export.xlsx',
    );

    if (savePath == null) return;

    final excel = Excel.createExcel();
    final Sheet sheet = excel['Sheet1'];

    // Header
    final headers = [...rules.map((r) => r.excelField)];
    for (int col = 0; col < headers.length; col++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0)).value = headers[col];
    }

    // Input values
    final allFiles = directories.expand((dir) => dir.filePaths).toList();
    for (int i = 0; i < allFiles.length; i++) {
      for (int j = 0; j < rules.length; j++) {
        final rule = rules[j];
        final result = rule.apply(allFiles[i]) ?? '';
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1)).value = result;
      }
    }

    // Encode and save the Excel file
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
