import 'package:expath_app/logic/state/app_state.dart';
import 'package:expath_app/logic/state/app_state_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for MainScreen state
final refAppState = NotifierProvider<AppStateNotifier, AppState>(() {
  return AppStateNotifier();
});

// Theyre all not used!

/// Provider factory for creating Pathfinder instances with specific directory paths
// final refPathfinder = Provider.family<Pathfinder, String>((ref, directoryPath) {
//   return Pathfinder(directoryPath);
// });

/// Provider for SaveLoad service
// final refSaveLoad = Provider<SaveLoad>((ref) {
//   return SaveLoad();
// });

/// Provider for ExcelExporter service
// final refExcelExporter = Provider<ExcelExporter>((ref) {
//   return ExcelExporter();
// });
