import 'dart:io';

import 'package:flutter/foundation.dart';

class Pathfinder {
  final String rootDirectoryPath;

  Pathfinder(this.rootDirectoryPath);

  List<String> getAllFilePaths() {
    final directory = Directory(rootDirectoryPath);
    if (!directory.existsSync()) {
      throw Exception("Directory does not exist: $rootDirectoryPath");
    }

    final List<String> filePaths = [];

    void scanDirectory(Directory dir) {
      try {
        for (var entity in dir.listSync(recursive: false)) {
          if (entity is File) {
            filePaths.add(entity.path);
          } else if (entity is Directory) {
            scanDirectory(entity);
          }
        }
      } on FileSystemException catch (e) {
        if (kDebugMode) {
          print('Zugriff verweigert oder Fehler bei ${dir.path}: ${e.message}');
        }
      }
    }

    scanDirectory(directory);

    return filePaths;
  }

  List<File> getAllFiles() {
    final directory = Directory(rootDirectoryPath);
    if (!directory.existsSync()) {
      throw Exception("Directory does not exist: $rootDirectoryPath");
    }
    final List<File> files = [];

    void scanDirectory(Directory dir) {
      try {
        for (var entity in dir.listSync(recursive: false)) {
          if (entity is File) {
            files.add(entity);
          } else if (entity is Directory) {
            scanDirectory(entity);
          }
        }
      } on FileSystemException catch (e) {
        if (kDebugMode) {
          print('Zugriff verweigert oder Fehler bei ${dir.path}: ${e.message}');
        }
      }
    }

    scanDirectory(directory);

    return files;
  }
}
