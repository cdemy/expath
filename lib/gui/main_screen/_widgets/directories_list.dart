import 'package:expath_app/core/providers.dart';
import 'package:expath_app/gui/main_screen/_widgets/directory_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DirectoriesList extends ConsumerWidget {
  const DirectoriesList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(refAppState);
    final appStateNotifier = ref.read(refAppState.notifier);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: appState.directories.isEmpty
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
                    itemCount: appState.directories.length,
                    itemBuilder: (context, index) {
                      final dir = appState.directories[index];
                      return DirectoryListItem(
                        directory: dir,
                        onRemove: () => appStateNotifier.removeDirectory(dir),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
