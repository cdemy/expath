import 'package:dj_projektarbeit/logic/pathfinder.dart';
import 'package:dj_projektarbeit/models/root_directory_entry.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<RootDirectoryEntry> directories = [];

  Future<void> selectDirectory() async {
    final String? selectedDirectory = await getDirectoryPath();
    if (selectedDirectory != null) {
      if (directories.any((dir) => dir.path == selectedDirectory)) {
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
                ElevatedButton(onPressed: () {}, child: Text("Vorschau")),
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
                      ElevatedButton(onPressed: () {}, child: Text("Hinzufügen")),
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
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) => ListTile(
                          title: Text("Regel ${index + 1}"),
                        ),
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
