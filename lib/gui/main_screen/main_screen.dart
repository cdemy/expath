import 'package:expath_app/gui/main_screen/_widgets/directories_list.dart';
import 'package:expath_app/gui/main_screen/_widgets/directory_buttons_row.dart';
import 'package:expath_app/gui/main_screen/_widgets/rules_buttons_row.dart';
import 'package:expath_app/gui/main_screen/_widgets/rules_list.dart';
import 'package:expath_app/gui/main_screen/main_screen_state.dart';
import 'package:expath_app/gui/preview_screen/preview_screen.dart';
import 'package:expath_app/gui/rule_editor_screen/rule_editor_screen.dart';
import 'package:expath_app/logic/filesystem/pathfinder.dart';
import 'package:expath_app/logic/filesystem/root_directory_entry.dart';
import 'package:expath_app/logic/filesystem/save_load.dart';
import 'package:expath_app/logic/rules/rule_stack.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// MainScreen of the Application
class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainScreenState = ref.watch(mainScreenProvider);
    final mainScreenNotifier = ref.read(mainScreenProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('EXPATH'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Directory related buttons -----------------------------------
            DirectoryButtonsRow(
              onClearDirectories: () => _clearDirectories(context, mainScreenNotifier),
              onSelectDirectory: () => _selectDirectory(context, mainScreenState, mainScreenNotifier),
              onPreview: () => _preview(context, mainScreenState),
            ),
            SizedBox(height: 8),
            // --- Directory list ----------------------------------------------
            Expanded(
              child: DirectoriesList(
                directories: mainScreenState.directories,
                removeDirectory: (directory) => mainScreenNotifier.removeDirectory(directory),
              ),
            ),

            SizedBox(height: 8),

            /// --- Rules related buttons --------------------------------------
            RulesButtonsRow(
              onAddRule: () => _addRule(context, mainScreenState, mainScreenNotifier),
              onSaveRules: () => _saveRules(context, mainScreenState),
              onLoadRules: () => _loadRuleStacks(context, mainScreenNotifier),
            ),
            SizedBox(height: 8),

            // --- Rules list --------------------------------------------------
            Expanded(
              child: RuleStacksList(
                ruleStacks: mainScreenState.ruleStacks,
                moveRuleStack: (oldIndex, newIndex) => mainScreenNotifier.moveRuleStack(oldIndex, newIndex),
                editRuleStack: (ruleStack) => _editRuleStack(context, mainScreenState, mainScreenNotifier, ruleStack),
                removeRuleStack: (ruleStack) => mainScreenNotifier.removeRuleStack(ruleStack),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addRule(BuildContext context, MainScreenState state, MainScreenNotifier notifier) async {
    final ruleStack = await Navigator.push<RuleStack>(
      context,
      MaterialPageRoute(
          builder: (context) => RuleStackEditorScreen(
                directories: state.directories,
              )),
    );
    if (ruleStack != null) {
      notifier.addRuleStack(ruleStack);
    }
  }

  void _clearDirectories(BuildContext context, MainScreenNotifier notifier) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alle nicht gespeicherten Daten gehen verloren!'),
        content: Text('Möchten Sie eine neue Instanz starten?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Abbrechen')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Neu starten'),
          )
        ],
      ),
    );
    if (confirmed == true) {
      notifier.clearAll();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Neue Instanz gestartet')),
      );
    }
  }

  void _editRuleStack(BuildContext context, MainScreenState state, MainScreenNotifier notifier, RuleStack ruleStack) async {
    final editedRuleStack = await Navigator.push<RuleStack>(
      context,
      MaterialPageRoute(
        builder: (context) => RuleStackEditorScreen(
          existingRuleStack: ruleStack,
          directories: state.directories,
        ),
      ),
    );

    if (editedRuleStack != null) {
      final index = state.ruleStacks.indexOf(ruleStack);
      notifier.updateRuleStack(index, editedRuleStack);
    }
  }

  void _loadRuleStacks(BuildContext context, MainScreenNotifier notifier) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final loadedRuleStacks = await SaveLoad.loadRuleStacksFromJson(result.files.single.path!);
      notifier.loadRuleStacks(loadedRuleStacks);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Regel-Sets geladen')));
    }
  }

  void _preview(BuildContext context, MainScreenState state) {
    if (state.directories.isEmpty || state.ruleStacks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bitte Verzeichnisse und Regeln anlegen.')));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(
          directories: state.directories,
          ruleStacks: state.ruleStacks,
        ),
      ),
    );
  }

  void _saveRules(BuildContext context, MainScreenState state) async {
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Regeln speichern',
      fileName: 'rules.json',
    );
    if (path != null) {
      await SaveLoad.saveRuleStacksToJson(state.ruleStacks, path);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Regel-Sets gespeichert')));
    }
  }

  Future<void> _selectDirectory(BuildContext context, MainScreenState state, MainScreenNotifier notifier) async {
    final String? selectedDirectory = await getDirectoryPath();
    if (selectedDirectory != null) {
      if (state.directories.any((dir) => dir.path == selectedDirectory)) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Dieses Verzeichnis wurde bereits hinzugefügt.')));
        return;
      }

      final pathfinder = Pathfinder(selectedDirectory);
      final files = pathfinder.getAllFiles();

      notifier.addDirectory(RootDirectoryEntry(selectedDirectory, files));
    }
  }
}
