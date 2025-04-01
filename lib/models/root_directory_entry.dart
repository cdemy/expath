class RootDirectoryEntry {
  final String path;
  final List<String> filePaths;

  RootDirectoryEntry(this.path, this.filePaths);

  int get fileCount => filePaths.length;
}
