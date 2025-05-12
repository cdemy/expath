import 'dart:io';

import 'package:dj_projektarbeit/logic/filesystem/document_info.dart';
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

  Future<List<DocumentInfo>> getAllDocumentInfos() async {
    final List<DocumentInfo> documentInfos = [];
    final directory = Directory(rootDirectoryPath);
    if (!directory.existsSync()) {
      throw Exception("Directory does not exist: $rootDirectoryPath");
    }
    await _scanDirectory(directory, documentInfos);
    return documentInfos;
  }

  Future<void> _scanDirectory(Directory dir, List<DocumentInfo> collector) async {
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) {
        final info = await DocumentInfo.fromPath(entity.path);
        collector.add(info);
      }
    }
  }
}
