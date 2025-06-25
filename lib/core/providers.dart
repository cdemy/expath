import 'package:expath_app/logic/excel/excel_exporter.dart';
import 'package:expath_app/logic/filesystem/pathfinder.dart';
import 'package:expath_app/logic/filesystem/save_load.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider factory for creating Pathfinder instances with specific directory paths
final pathfinderProvider = Provider.family<Pathfinder, String>((ref, directoryPath) {
  return Pathfinder(directoryPath);
});

/// Provider for SaveLoad service
final saveLoadProvider = Provider<SaveLoad>((ref) {
  return SaveLoad();
});

/// Provider for ExcelExporter service
final excelExporterProvider = Provider<ExcelExporter>((ref) {
  return ExcelExporter();
});
