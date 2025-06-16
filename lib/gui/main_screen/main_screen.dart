import 'package:dj_projektarbeit/gui/main_screen/_widgets/directories_list.dart';
import 'package:dj_projektarbeit/gui/main_screen/_widgets/rules_list.dart';
import 'package:dj_projektarbeit/gui/preview_screen/preview_screen.dart';
import 'package:dj_projektarbeit/gui/rule_editor_screen/rule_editor_screen.dart';
import 'package:dj_projektarbeit/logic/filesystem/save_load.dart';
import 'package:dj_projektarbeit/logic/filesystem/pathfinder.dart';
import 'package:dj_projektarbeit/logic/filesystem/root_directory_entry.dart';
import 'package:dj_projektarbeit/logic/rules/rule_stack.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

/// MainScreen of the Application
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<RootDirectoryEntry> directories = [];
  List<RuleStack> ruleStacks = [];

  @override
  Widget build(BuildContext context) {
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
            Row(
              children: [
                // "New" button (resets directories list)
                ElevatedButton(
                  onPressed: _clearDirectories,
                  child: Text("Neu"),
                ),
                SizedBox(width: 8),
                // "Add directory" button
                ElevatedButton(
                  onPressed: _selectDirectory,
                  child: Text("Ordner hinzufügen"),
                ),
                SizedBox(width: 8),
                // "Preview" button
                ElevatedButton(
                  onPressed: _preview,
                  child: Text("Vorschau"),
                ),
              ],
            ),
            SizedBox(height: 8),
            // --- Directory list ----------------------------------------------
            Expanded(
              child: DirectoriesList(
                directories: directories,
                removeDirectory: _removeDirectory,
              ),
            ),

            SizedBox(height: 8),

            /// --- Rules related buttons --------------------------------------
            Row(
              children: [
                // "Add rule" button
                ElevatedButton(
                  onPressed: _addRule,
                  child: Text("Regel hinzufügen"),
                ),
                SizedBox(width: 8),
                // "Save rules" button
                ElevatedButton(
                  onPressed: _saveRules,
                  child: Text("Regelsatz speichern"),
                ),
                SizedBox(width: 8),
                // "Load rules" button
                ElevatedButton(
                  onPressed: _loadRuleStacks,
                  child: Text("Regelsatz laden"),
                ),
              ],
            ),
            SizedBox(height: 8),

            // --- Rules list --------------------------------------------------
            Expanded(
              child: RuleStacksList(
                ruleStacks: ruleStacks,
                moveRuleStack: _moveRuleStack,
                editRuleStack: _editRuleStack,
                removeRuleStack: _removeRuleStack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addRule() async {
    final ruleStack = await Navigator.push<RuleStack>(
      context,
      MaterialPageRoute(
          builder: (context) => RuleStackEditorScreen(
                directories: directories,
              )),
    );
    if (ruleStack != null) {
      setState(() {
        ruleStacks.add(ruleStack);
      });
    }
  }

  void _clearDirectories() async {
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
      setState(() {
        directories.clear();
        ruleStacks.clear();
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Neue Instanz gestartet')),
      );
    }
  }

  void _editRuleStack(RuleStack ruleStack) async {
    final editedRuleStack = await Navigator.push<RuleStack>(
      context,
      MaterialPageRoute(
        builder: (context) => RuleStackEditorScreen(
          existingRuleStack: ruleStack,
          directories: directories,
        ),
      ),
    );

    if (editedRuleStack != null) {
      setState(() {
        ruleStacks[ruleStacks.indexOf(ruleStack)] = editedRuleStack;
      });
    }
  }

  void _loadRuleStacks() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final loadedRuleStacks = await SaveLoad.loadRuleStacksFromJson(result.files.single.path!);
      setState(() {
        ruleStacks = loadedRuleStacks;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Regel-Sets geladen')));
    }
  }

  void _moveRuleStack(int oldIndex, int newIndex) {
    setState(() {
      final ruleStack = ruleStacks.removeAt(oldIndex);
      ruleStacks.insert(newIndex, ruleStack);
    });
  }

  void _preview() {
    if (directories.isEmpty || ruleStacks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bitte Verzeichnisse und Regeln anlegen.')));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(
          directories: directories,
          ruleStacks: ruleStacks,
        ),
      ),
    );
  }

  void _removeDirectory(RootDirectoryEntry directory) {
    setState(() {
      directories.remove(directory);
    });
  }

  void _removeRuleStack(RuleStack ruleStack) {
    setState(() {
      ruleStacks.remove(ruleStack);
    });
  }

  void _saveRules() async {
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Regeln speichern',
      fileName: 'rules.json',
    );
    if (path != null) {
      await SaveLoad.saveRuleStacksToJson(ruleStacks, path);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Regel-Sets gespeichert')));
    }
  }

  Future<void> _selectDirectory() async {
    final String? selectedDirectory = await getDirectoryPath();
    if (selectedDirectory != null) {
      if (directories.any((dir) => dir.path == selectedDirectory)) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Dieses Verzeichnis wurde bereits hinzugefügt.')));
        }
        return;
      }

      final pathfinder = Pathfinder(selectedDirectory);
      final files = pathfinder.getAllFiles();

      setState(() {
        directories.add(RootDirectoryEntry(selectedDirectory, files));
      });
    }
  }
}
