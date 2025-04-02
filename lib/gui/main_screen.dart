import 'package:dj_projektarbeit/gui/preview_screen.dart';
import 'package:dj_projektarbeit/gui/rule_editor_screen.dart';
import 'package:dj_projektarbeit/logic/pathfinder.dart';
import 'package:dj_projektarbeit/logic/rule_system.dart';
import 'package:dj_projektarbeit/models/root_directory_entry.dart';
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
                ElevatedButton(onPressed: () {}, child: Text("Neu")),
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
                ElevatedButton(onPressed: () {}, child: Text("Excel-Datei generieren")),
              ],
            ),
            SizedBox(height: 8),
            Expanded(
              child: Column(
                children: [
                  /// ------------------- Verzeichnis-Liste -------------------
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

                  /// ------------------- Regel-Liste -------------------
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
                      ElevatedButton(onPressed: () {}, child: Text("Entfernen")),
                      SizedBox(width: 8),
                      ElevatedButton(onPressed: () {}, child: Text("Speichern")),
                      SizedBox(width: 8),
                      ElevatedButton(onPressed: () {}, child: Text("Laden")),
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
                                  title: Text(rule.description()),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        rules.removeAt(index);
                                      });
                                    },
                                  ),
                                );
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
}
