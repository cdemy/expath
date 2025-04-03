import 'package:dj_projektarbeit/gui/preview_screen.dart';
import 'package:dj_projektarbeit/gui/rule_editor_screen.dart';
import 'package:dj_projektarbeit/logic/excel_exporter.dart';
import 'package:dj_projektarbeit/logic/functions/save_load.dart';
import 'package:dj_projektarbeit/logic/pathfinder.dart';
import 'package:dj_projektarbeit/logic/rule.dart';
import 'package:dj_projektarbeit/logic/root_directory_entry.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<RootDirectoryEntry> directories = [];
  List<Rule> rules = [];

  Future<void> selectDirectory() async {
    final String? selectedDirectory = await getDirectoryPath();
    if (selectedDirectory != null) {
      if (directories.any((dir) => dir.path == selectedDirectory)) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Dieses Verzeichnis wurde bereits hinzugefügt.')));
        return;
      }

      final pathfinder = Pathfinder(selectedDirectory);
      final files = pathfinder.getAllFilePaths();

      setState(() {
        directories.add(RootDirectoryEntry(selectedDirectory, files));
      });
    }
  }

  void removeDirectory(int index) {
    setState(() {
      directories.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RegEx Pathfinder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Alles zurücksetzen'),
                          content: Text('Möchten Sie alles zurücksetzen?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Abbrechen')),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text('Zurücksetzen'),
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
                          SnackBar(content: Text('Alles zurückgesetzt.')),
                        );
                      }
                    },
                    child: Text("Neu")),
                SizedBox(width: 8),
                ElevatedButton(onPressed: selectDirectory, child: Text("Ordner hinzufügen")),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (directories.isEmpty || rules.isEmpty) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Bitte Verzeichnisse und Regeln anlegen.')));
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
                  },
                  child: Text("Vorschau"),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        await ExcelExporter.export(
                          directories: directories,
                          rules: rules,
                        );
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Excel-Datei erfolgreich exportiert')));
                      } catch (e) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Fehler: $e')),
                        );
                      }
                    },
                    child: Text("Excel-Datei generieren")),
              ],
            ),
            SizedBox(height: 8),
            Expanded(
              child: Column(
                children: [
                  /// ------------------- List of Directories -------------------
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: directories.isEmpty
                          ? Center(child: Text('Noch keine Verzeichnisse hinzugefügt.'))
                          : ListView.builder(
                              itemCount: directories.length,
                              itemBuilder: (context, index) {
                                final dir = directories[index];
                                return ListTile(
                                  leading: Icon(Icons.folder),
                                  title: Text(dir.path),
                                  subtitle: Row(children: [
                                    Icon(Icons.insert_drive_file, size: 16),
                                    SizedBox(width: 4),
                                    Text('${dir.fileCount} Dateien'),
                                  ]),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () => removeDirectory(index),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                  SizedBox(height: 8),

                  /// ------------------- List of Rules -------------------
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final rule = await Navigator.push<Rule>(
                            context,
                            MaterialPageRoute(builder: (context) => RuleEditorScreen()),
                          );
                          if (rule != null) {
                            setState(() {
                              rules.add(rule);
                            });
                          }
                        },
                        child: Text("Hinzufügen"),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(onPressed: _saveRules, child: Text("Speichern")),
                      SizedBox(width: 8),
                      ElevatedButton(onPressed: _loadRules, child: Text("Laden")),
                    ],
                  ),
                  SizedBox(height: 8),

                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: rules.isEmpty
                          ? Center(child: Text("Noch keine Regeln hinzugefügt."))
                          : ListView.builder(
                              itemCount: rules.length,
                              itemBuilder: (context, index) {
                                final rule = rules[index];
                                return ListTile(
                                    title: Text(rule.name),
                                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () async {
                                          final editedRule = await Navigator.push<Rule>(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => RuleEditorScreen(existingRule: rule),
                                            ),
                                          );
                                          if (editedRule != null) {
                                            setState(() {
                                              rules[index] = editedRule;
                                            });
                                          }
                                        },
                                      ),
                                      IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            setState(() {
                                              rules.removeAt(index);
                                            });
                                          })
                                    ]));
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveRules() async {
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Regeln speichern',
      fileName: 'rules.json',
    );
    if (path != null) {
      await saveRulesToJson(rules, path);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Regeln gespeichert')));
    }
  }

  void _loadRules() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final loadedRules = await loadRulesFromJson(result.files.single.path!);
      setState(() {
        rules = loadedRules;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Regeln geladen')));
    }
  }
}
