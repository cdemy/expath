import 'package:dj_projektarbeit/logic/filesystem/root_directory_entry.dart';
import 'package:flutter/material.dart';

class DirectoriesList extends StatelessWidget {
  final List<RootDirectoryEntry> directories;
  final Function(RootDirectoryEntry) removeDirectory;
  const DirectoriesList({
    required this.directories,
    required this.removeDirectory,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: directories.isEmpty
          ? Center(child: Text('Noch keine Verzeichnisse hinzugefügt.'))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  child: Row(
                    children: [
                      Expanded(flex: 6, child: Text('Ordnerpfad', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 2, child: Text('Dateien', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 2, child: SizedBox()), // Leerer Platz für Aktionen (Icons)
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: directories.length,
                    itemBuilder: (context, index) {
                      final dir = directories[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Row(
                          children: [
                            Expanded(flex: 6, child: Text(dir.path)),
                            Expanded(flex: 2, child: Text('${dir.fileCount} Dateien')),
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () => removeDirectory(dir),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
