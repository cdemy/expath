import 'dart:io';

class RootDirectoryEntry {
  final String path;
  final List<File> files;

  RootDirectoryEntry(this.path, this.files);

  int get fileCount => files.length;
}
