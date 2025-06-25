import 'package:flutter_test/flutter_test.dart';
import 'package:expath_app/logic/filesystem/root_directory_entry.dart';

void main() {
  test('RootDirectoryEntry speichert Pfad korrekt', () {
    final rootEntry = RootDirectoryEntry('C:\\Daten', []);

    expect(rootEntry.path, 'C:\\Daten');
  });
}
