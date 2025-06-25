import 'package:expath_app/gui/main_screen/_widgets/directory_list_item.dart';
import 'package:expath_app/logic/filesystem/root_directory_entry.dart';
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
                  // ignore: deprecated_member_use
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  child: Row(
                    children: [
                      Expanded(flex: 6, child: Text('Ordnerpfad', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 2, child: Text('Dateien', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 2, child: SizedBox()),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: directories.length,
                    itemBuilder: (context, index) {
                      final dir = directories[index];
                      return DirectoryListItem(
                        directory: dir,
                        onRemove: () => removeDirectory(dir),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
