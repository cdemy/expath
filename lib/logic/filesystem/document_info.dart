import 'dart:io';

class DocumentInfo {
  final File file;

  DocumentInfo(this.file);

  static Future<DocumentInfo> fromPath(String path) async {
    final file = File(path);

    return DocumentInfo(file);
  }

  size() => file.statSync().size;

  type() => file.statSync().type;

  createdAt() => file.statSync().changed;

  lastModifiedAt() => file.statSync().modified;
}

final documentInfo = DocumentInfo(File('path/to/your/file.txt'));
final abc = documentInfo.size();
