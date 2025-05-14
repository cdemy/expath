import 'package:dj_projektarbeit/gui/main_screen/_widgets/directories_list.dart';
import 'package:dj_projektarbeit/gui/main_screen/_widgets/rules_list.dart';
import 'package:dj_projektarbeit/gui/preview_screen/preview_screen.dart';
import 'package:dj_projektarbeit/gui/rule_editor_screen/rule_editor_screen.dart';
import 'package:dj_projektarbeit/logic/filesystem/save_load.dart';
import 'package:dj_projektarbeit/logic/filesystem/pathfinder.dart';
import 'package:dj_projektarbeit/logic/filesystem/root_directory_entry.dart';
import 'package:dj_projektarbeit/logic/rules/_rule.dart';
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
  List<Rule> rules = [];

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
                  onPressed: _loadRules,
                  child: Text("Regelsatz laden"),
                ),
              ],
            ),
            SizedBox(height: 8),

            // --- Rules list --------------------------------------------------
            Expanded(
              child: RulesList(
                rules: rules,
                moveRule: _moveRule,
                editRule: _editRule,
                removeRule: _removeRule,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addRule() async {
    final rule = await Navigator.push<Rule>(
      context,
      MaterialPageRoute(builder: (context) => RuleEditorScreen()),
    );
    if (rule != null) {
      setState(() {
        rules.add(rule);
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
        rules.clear();
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Neue Instanz gestartet')),
      );
    }
  }

  void _editRule(Rule rule) async {
    final editedRule = await Navigator.push<Rule>(
      context,
      MaterialPageRoute(
        builder: (context) => RuleEditorScreen(existingRule: rule),
      ),
    );

    if (editedRule != null) {
      setState(() {
        rules[rules.indexOf(rule)] = editedRule;
      });
    }
  }

  void _loadRules() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final loadedRules = await SaveLoad.loadRulesFromJson(result.files.single.path!);
      setState(() {
        rules = loadedRules;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Regeln geladen')));
    }
  }

  void _moveRule(int oldIndex, int newIndex) {
    setState(() {
      final rule = rules.removeAt(oldIndex);
      rules.insert(newIndex, rule);
    });
  }

  void _preview() {
    if (directories.isEmpty || rules.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bitte Verzeichnisse und Regeln anlegen.')));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(
          directories: directories,
          rules: rules,
        ),
      ),
    );
  }

  void _removeDirectory(RootDirectoryEntry directory) {
    setState(() {
      directories.remove(directory);
    });
  }

  void _removeRule(Rule rule) {
    setState(() {
      rules.remove(rule);
    });
  }

  void _saveRules() async {
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Regeln speichern',
      fileName: 'rules.json',
    );
    if (path != null) {
      await SaveLoad.saveRulesToJson(rules, path);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Regeln gespeichert')));
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
